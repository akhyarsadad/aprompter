import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:path_provider/path_provider.dart';

import '../l10n/l10n.dart';
import '../models/prompter_settings.dart';
import '../models/script.dart';
import 'backup.dart';
import 'entitlements.dart';
import 'storage.dart';
import 'system_settings.dart';

/// App-wide state: the script library and prompter settings.
class AppState extends ChangeNotifier {
  /// [takesDirectory] is where takes kept in the app are stored; tests pass
  /// a temporary folder.
  AppState(this.storage, {Future<Directory> Function()? takesDirectory})
    : _scripts = storage.loadScripts(),
      _settings = storage.loadSettings(),
      _trash = storage.loadTrash(),
      _locale = parseLocaleTag(storage.loadLocale()),
      _takesDirectory = takesDirectory ?? _documentsTakes {
    _expiredTrashCleared = _clearExpiredTrash().then(
      (_) => _forgetMissingTakes(),
    );
  }

  final Storage storage;
  final Future<Directory> Function() _takesDirectory;
  late final Future<void> _expiredTrashCleared;
  List<Script> _scripts;
  PrompterSettings _settings;
  List<TrashedScript> _trash;
  Locale? _locale;
  bool _saveFailed = false;

  /// One-time: scripts already over the free word cap before the paywall
  /// shipped stay editable forever. Call once at startup, before the first
  /// frame — see `main()`.
  Future<void> runWordCapMigrationIfNeeded() async {
    if (storage.wordCapMigrationDone) return;
    await storage.saveGrandfatheredWordCapIds(
      computeGrandfatheredIds(_scripts),
    );
    await storage.setWordCapMigrationDone();
  }

  /// Whether script [id] is exempt from the free word cap (Task 2/3).
  bool isGrandfatheredWordCap(String id) =>
      storage.grandfatheredWordCapIds.contains(id);

  /// Scripts that count toward the free script limit — everything except
  /// the auto-seeded welcome script, so a brand-new free account's first
  /// tap of "+ New script" isn't already a paywall (the tutorial content
  /// doesn't count as "their" script).
  List<Script> get scriptsCountingTowardFreeLimit {
    final seedId = storage.loadSeedScriptId();
    return seedId == null
        ? scripts
        : scripts.where((s) => s.id != seedId).toList();
  }

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
    if (fresh.wpm != _settings.wpm ||
        fresh.guidePosition != _settings.guidePosition) {
      _settings = _settings.copyWith(
        wpm: fresh.wpm,
        guidePosition: fresh.guidePosition,
      );
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

  /// Deletes a script from "Recently deleted" for good, with its versions
  /// and the takes kept in the app.
  Future<void> deleteForever(String id) async {
    _trash = _trash.where((t) => t.script.id != id).toList();
    notifyListeners();
    await _persist(() => storage.saveTrash(_trash));
    await _deleteBelongings(id);
  }

  /// What a script leaves behind when it goes for good: its earlier versions
  /// and the takes kept in the app, entries and videos.
  Future<void> _deleteBelongings(String id) async {
    await _persist(() => storage.saveVersions(id, const []));
    for (final take in takesOf(id)) {
      await deleteTake(take);
    }
  }

  /// Scripts deleted more than [Storage.trashDays] days ago leave
  /// "Recently deleted" (see [Storage.loadTrash]); this deletes what they
  /// left behind, as [deleteForever] does. Runs once, when the app starts.
  Future<void> _clearExpiredTrash() async {
    try {
      final expired = {
        for (final id in storage.loadExpiredTrashIds())
          // A script that is back in the library keeps everything.
          if (byId(id) == null && !_trash.any((t) => t.script.id == id)) id,
      };
      if (expired.isEmpty) return;
      for (final id in expired) {
        await _deleteBelongings(id);
      }
      await _persist(() => storage.saveTrash(_trash));
    } catch (_) {
      // Tried again on the next start.
    }
  }

  /// Takes whose video is gone are forgotten: Android's cloud backup leaves
  /// the videos out on purpose (they'd use up its quota and stop the scripts
  /// from being backed up), so a restored phone would list takes it can't
  /// play. Runs once, when the app starts.
  Future<void> _forgetMissingTakes() async {
    try {
      final takes = storage.loadTakes();
      if (takes.isEmpty) return;
      final gone = <String>{};
      for (final take in takes) {
        if (!await (await takeFile(take)).exists()) gone.add(take.path);
      }
      if (gone.isEmpty) return;
      await _persist(
        () => storage.saveTakes([
          for (final t in storage.loadTakes())
            if (!gone.contains(t.path)) t,
        ]),
      );
      notifyListeners();
    } catch (_) {
      // Tried again on the next start.
    }
  }

  /// Completes once what expired scripts left behind is deleted and takes
  /// without a video are forgotten.
  @visibleForTesting
  Future<void> get expiredTrashCleared => _expiredTrashCleared;

  /// Takes of script [id] kept inside the app (C4), newest first.
  List<Take> takesOf(String id) =>
      storage.loadTakes().where((t) => t.scriptId == id).toList();

  Future<void> addTake(Take take) async {
    await _persist(() => storage.saveTakes([take, ...storage.loadTakes()]));
    notifyListeners();
  }

  /// Where takes kept in the app are stored.
  Future<Directory> takesDirectory() => _takesDirectory();

  static Future<Directory> _documentsTakes() async {
    final dir = Directory(
      '${(await getApplicationDocumentsDirectory()).path}/takes',
    );
    // Takes kept in the app stay out of the cloud on both platforms:
    // Android's backup rules leave this folder out, iOS needs telling.
    if (Platform.isIOS && !_takesKeptFromICloud) {
      try {
        await dir.create(recursive: true);
        _takesKeptFromICloud = await excludeFromBackup(dir.path);
      } catch (_) {
        // Phone full: try again next time.
      }
    }
    return dir;
  }

  static bool _takesKeptFromICloud = false;

  /// The video of [take]. Always looked up by its file name in
  /// [takesDirectory]: iOS gives the app a new folder on every App Store
  /// update, so a full path stored before an update leads nowhere.
  Future<File> takeFile(Take take) async =>
      File('${(await takesDirectory()).path}/${take.fileName}');

  /// Deletes a take kept in the app: its entry and its video.
  Future<void> deleteTake(Take take) async {
    await removeTake(take);
    try {
      await (await takeFile(take)).delete();
    } catch (_) {
      // Already gone.
    }
  }

  /// Forgets a take; the caller deletes the file (see [deleteTake]).
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
  /// only by a newer copy; so is one in "Recently deleted", which otherwise
  /// stays there. Returns how many scripts were added or updated.
  Future<int> importScripts(List<Script> incoming) async {
    var changed = 0;
    final byIdMap = {for (final s in _scripts) s.id: s};
    final trashed = {for (final t in _trash) t.script.id: t.script};
    final replacedTrash = <String>{};
    for (final s in incoming) {
      final existing = byIdMap[s.id];
      if (existing == null) {
        final deleted = trashed[s.id];
        if (deleted != null) {
          // An older copy from a backup doesn't replace a newer deleted one.
          if (!s.updatedAt.isAfter(deleted.updatedAt)) continue;
          if (deleted.body != s.body) {
            await _keepVersion(deleted, newBody: '');
          }
          replacedTrash.add(s.id);
        }
        byIdMap[s.id] = s;
        changed++;
      } else if (s.updatedAt.isAfter(existing.updatedAt)) {
        if (existing.body != s.body) {
          await _keepVersion(existing, newBody: '');
        }
        byIdMap[s.id] = s;
        changed++;
      }
    }
    if (changed == 0) return 0;
    _scripts = byIdMap.values.toList()
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    _trash = _trash.where((t) => !replacedTrash.contains(t.script.id)).toList();
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
