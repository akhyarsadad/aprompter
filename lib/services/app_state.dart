import 'package:flutter/widgets.dart';

import '../l10n/l10n.dart';
import '../models/prompter_settings.dart';
import '../models/script.dart';
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

  Future<void> setLocale(Locale? locale) {
    _locale = locale;
    notifyListeners();
    return storage.saveLocale(locale == null ? null : localeTag(locale));
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
    await _persist(() => storage.saveScripts(_scripts));
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
    await _persist(() => storage.saveScripts(_scripts));
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
    await _persist(() => storage.saveScripts(_scripts));
    await _persist(() => storage.saveTrash(_trash));
    return removed;
  }

  /// Puts a deleted script back unchanged.
  Future<void> restore(Script script) async {
    _scripts = [script, ..._scripts.where((s) => s.id != script.id)]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    _trash = _trash.where((t) => t.script.id != script.id).toList();
    notifyListeners();
    await _persist(() => storage.saveScripts(_scripts));
    await _persist(() => storage.saveTrash(_trash));
  }

  /// Deletes a script from "Recently deleted" for good, with its versions.
  Future<void> deleteForever(String id) async {
    _trash = _trash.where((t) => t.script.id != id).toList();
    notifyListeners();
    await _persist(() => storage.saveTrash(_trash));
    await _persist(() => storage.saveVersions(id, const []));
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
