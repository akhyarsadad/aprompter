import 'dart:io';

import 'package:flutter/widgets.dart';

import '../l10n/l10n.dart';
import '../models/prompter_settings.dart';
import '../models/script.dart';
import 'backup.dart';
import 'storage.dart';

/// App-wide state: the script library and prompter settings.
class AppState extends ChangeNotifier {
  AppState(this.storage)
    : _scripts = storage.loadScripts(),
      _settings = storage.loadSettings(),
      _trash = storage.loadTrash(),
      _locale = parseLocaleTag(storage.loadLocale());

  final Storage storage;
  List<Script> _scripts;
  PrompterSettings _settings;
  List<TrashedScript> _trash;
  Locale? _locale;
  bool _saveFailed = false;

  /// The last write to the phone failed (storage full…). Everything is
  /// still in memory; [retrySave] tries again.
  bool get saveFailed => _saveFailed;

  /// Runs a write and remembers whether it went through, so a full phone
  /// never loses work silently.
  Future<void> _persist(Future<void> Function() write) async {
    try {
      await write();
      if (_saveFailed) {
        _saveFailed = false;
        notifyListeners();
      }
    } catch (_) {
      if (!_saveFailed) {
        _saveFailed = true;
        notifyListeners();
      }
    }
  }

  /// Writes everything again after a failed save.
  Future<void> retrySave() => _persist(() async {
    await storage.saveScripts(_scripts);
    await storage.saveTrash(_trash);
    await storage.saveSettings(_settings);
  });

  /// Scripts deleted in the last [Storage.trashDays] days, newest first.
  List<TrashedScript> get trash => List.unmodifiable(_trash);

  /// App language chosen in the app; null follows the phone.
  Locale? get locale => _locale;

  Future<void> setLocale(Locale? locale) async {
    final before = deviceLocalizations(_locale);
    _locale = locale;
    // O5: an untouched welcome script follows the new language.
    final after = deviceLocalizations(locale);
    _scripts = [
      for (final s in _scripts)
        s.title == before.welcomeTitle && s.body == before.welcomeBody
            ? s.copyWith(title: after.welcomeTitle, body: after.welcomeBody)
            : s,
    ];
    notifyListeners();
    await _persist(() => storage.saveScripts(_scripts));
    await storage.saveLocale(locale == null ? null : localeTag(locale));
  }

  bool get appLock => storage.appLock;

  Future<void> setAppLock(bool on) async {
    await storage.setAppLock(on);
    notifyListeners();
  }

  /// Picks up settings changed by the floating window (its own engine).
  Future<void> reloadSettings() async {
    await storage.reload();
    final fresh = storage.loadSettings();
    if (fresh.wpm != _settings.wpm) {
      _settings = _settings.copyWith(wpm: fresh.wpm);
      notifyListeners();
    }
  }

  List<Script> get scripts => List.unmodifiable(_scripts);
  PrompterSettings get settings => _settings;

  Script? byId(String id) {
    for (final s in _scripts) {
      if (s.id == id) return s;
    }
    return null;
  }

  Future<void> upsert(Script script) async {
    final stored = byId(script.id);
    // Only writing moves a script to the top; marking it ready or counting
    // a take keeps its place.
    final edited =
        stored == null ||
        stored.title != script.title ||
        stored.body != script.body ||
        stored.targetSeconds != script.targetSeconds;
    if (edited) {
      final updated = script.copyWith(updatedAt: DateTime.now());
      _scripts = [updated, ..._scripts.where((s) => s.id != script.id)];
    } else {
      final kept = script.copyWith(updatedAt: stored.updatedAt);
      _scripts = [for (final s in _scripts) s.id == script.id ? kept : s];
    }
    notifyListeners();
    await _persist(() => storage.saveScript(byId(script.id)!));
    if (stored != null && stored.body != script.body) {
      await _keepVersion(stored, newBody: script.body);
    }
  }

  /// Keeps the text as it was before an edit: at most every few minutes
  /// while typing, and always before a big deletion or a paste over it.
  Future<void> _keepVersion(Script before, {required String newBody}) async {
    final versions = storage.loadVersions(before.id);
    if (versions.isNotEmpty && versions.first.body == before.body) return;
    final last = versions.isEmpty ? null : versions.first.savedAt;
    final bigCut =
        before.body.trim().isNotEmpty &&
        newBody.length < before.body.length * 0.7;
    final stale =
        last == null || DateTime.now().difference(last) >= versionInterval;
    if (!bigCut && !stale) return;
    await _persist(
      () => storage.saveVersions(before.id, [
        ScriptVersion(
          title: before.title,
          body: before.body,
          savedAt: before.updatedAt,
        ),
        ...versions,
      ]),
    );
  }

  /// Minimum time between two kept versions while typing.
  static const versionInterval = Duration(minutes: 5);

  /// Earlier versions of script [id], newest first.
  List<ScriptVersion> versionsOf(String id) => storage.loadVersions(id);

  /// Puts an earlier version back; the current text becomes a version too.
  Future<Script?> restoreVersion(String id, ScriptVersion version) async {
    final current = byId(id);
    if (current == null) return null;
    final versions = storage.loadVersions(id);
    await _persist(
      () => storage.saveVersions(id, [
        ScriptVersion(
          title: current.title,
          body: current.body,
          savedAt: DateTime.now(),
        ),
        ...versions,
      ]),
    );
    final restored = current.copyWith(
      title: version.title,
      body: version.body,
      updatedAt: DateTime.now(),
    );
    _scripts = [restored, ..._scripts.where((s) => s.id != id)];
    notifyListeners();
    await _persist(() => storage.saveScript(restored));
    return restored;
  }

  /// Count a finished recording and mark the script as recorded.
  Future<void> recordTake(String id) async {
    final script = byId(id);
    if (script == null) return;
    await upsert(
      script.copyWith(takes: script.takes + 1, status: ScriptStatus.recorded),
    );
  }

  /// Copies a script as a fresh draft and returns the copy.
  Future<Script> duplicate(String id, {required String titleSuffix}) async {
    final source = byId(id)!;
    final copy = Storage.newScript().copyWith(
      title: '${source.title} $titleSuffix',
      body: source.body,
      targetSeconds: () => source.targetSeconds,
    );
    await upsert(copy);
    return copy;
  }

  /// Moves a script to "Recently deleted" and returns it so the deletion
  /// can be undone.
  Future<Script?> delete(String id) async {
    final removed = byId(id);
    if (removed == null) return null;
    _scripts = _scripts.where((s) => s.id != id).toList();
    _trash = [
      TrashedScript(removed, DateTime.now()),
      ..._trash.where((t) => t.script.id != id),
    ];
    notifyListeners();
    await _persist(() => storage.removeScript(id));
    await _persist(() => storage.saveTrash(_trash));
    return removed;
  }

  /// Puts a deleted script back unchanged.
  Future<void> restore(Script script) async {
    _scripts = [script, ..._scripts.where((s) => s.id != script.id)]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    _trash = _trash.where((t) => t.script.id != script.id).toList();
    notifyListeners();
    await _persist(() => storage.saveScript(script));
    await _persist(() => storage.saveTrash(_trash));
  }

  /// Deletes a script from "Recently deleted" for good, with its versions.
  Future<void> deleteForever(String id) async {
    _trash = _trash.where((t) => t.script.id != id).toList();
    notifyListeners();
    await _persist(() => storage.saveTrash(_trash));
    await _persist(() => storage.saveVersions(id, const []));
    // Takes kept in the app belong to the script.
    for (final take in takesOf(id)) {
      await removeTake(take);
      try {
        await File(take.path).delete();
      } catch (_) {
        // Already gone.
      }
    }
  }

  /// Takes of script [id] kept inside the app (C4), newest first.
  List<Take> takesOf(String id) =>
      storage.loadTakes().where((t) => t.scriptId == id).toList();

  Future<void> addTake(Take take) async {
    await _persist(() => storage.saveTakes([take, ...storage.loadTakes()]));
    notifyListeners();
  }

  /// Forgets a take; the caller deletes the file.
  Future<void> removeTake(Take take) async {
    await _persist(
      () => storage.saveTakes([
        for (final t in storage.loadTakes())
          if (t.path != take.path) t,
      ]),
    );
    notifyListeners();
  }

  /// D4: unreadable data kept aside, by storage key.
  Map<String, String> get damagedData => storage.damagedBackups();

  /// Tries to get scripts back from unreadable data; on success the
  /// damaged copy is removed. Returns how many scripts were recovered.
  Future<int> recoverDamaged(String key) async {
    final raw = storage.damagedBackups()[key];
    if (raw == null) return 0;
    final found = salvageScripts(raw);
    if (found.isEmpty) return 0;
    final count = await importScripts(found);
    await storage.deleteBackup(key);
    notifyListeners();
    return count == 0 ? found.length : count;
  }

  Future<void> discardDamaged(String key) async {
    await storage.deleteBackup(key);
    notifyListeners();
  }

  /// Adds scripts from a backup. A script that already exists is replaced
  /// only by a newer copy. Returns how many scripts were added or updated.
  Future<int> importScripts(List<Script> incoming) async {
    var changed = 0;
    final byIdMap = {for (final s in _scripts) s.id: s};
    for (final s in incoming) {
      final existing = byIdMap[s.id];
      if (existing == null || s.updatedAt.isAfter(existing.updatedAt)) {
        if (existing != null && existing.body != s.body) {
          await _keepVersion(existing, newBody: '');
        }
        byIdMap[s.id] = s;
        changed++;
      }
    }
    if (changed == 0) return 0;
    _scripts = byIdMap.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    _trash = _trash.where((t) => !byIdMap.containsKey(t.script.id)).toList();
    notifyListeners();
    await _persist(() => storage.saveScripts(_scripts));
    await _persist(() => storage.saveTrash(_trash));
    return changed;
  }

  Future<void> updateSettings(PrompterSettings settings) {
    _settings = settings;
    notifyListeners();
    return _persist(() => storage.saveSettings(settings));
  }
}

/// Makes [AppState] available to the widget tree.
class AppScope extends InheritedNotifier<AppState> {
  const AppScope({super.key, required AppState state, required super.child})
    : super(notifier: state);

  static AppState of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AppScope>()!.notifier!;

  /// Access without subscribing to rebuilds (for callbacks).
  static AppState read(BuildContext context) =>
      context.getInheritedWidgetOfExactType<AppScope>()!.notifier!;
}
