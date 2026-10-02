import 'dart:convert';

import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../l10n/l10n.dart';
import '../models/prompter_settings.dart';
import '../models/script.dart';

/// A write to the phone's storage did not go through (usually: full).
class SaveFailed implements Exception {
  const SaveFailed(this.key);
  final String key;

  @override
  String toString() => 'SaveFailed($key)';
}

/// A script as it was earlier, kept so edits can be undone.
class ScriptVersion {
  const ScriptVersion({
    required this.title,
    required this.body,
    required this.savedAt,
  });

  final String title;
  final String body;
  final DateTime savedAt;

  Map<String, dynamic> toJson() => {
    'title': title,
    'body': body,
    'savedAt': savedAt.toIso8601String(),
  };

  factory ScriptVersion.fromJson(Map<String, dynamic> json) => ScriptVersion(
    title: json['title'] as String? ?? '',
    body: json['body'] as String? ?? '',
    savedAt:
        DateTime.tryParse(json['savedAt'] as String? ?? '') ?? DateTime(2000),
  );
}

/// A take kept inside the app instead of the gallery (Y3).
class Take {
  const Take({
    required this.path,
    required this.scriptId,
    required this.recordedAt,
    required this.seconds,
  });

  final String path;
  final String scriptId;
  final DateTime recordedAt;
  final int seconds;

  Map<String, dynamic> toJson() => {
    'path': path,
    'scriptId': scriptId,
    'recordedAt': recordedAt.toIso8601String(),
    'seconds': seconds,
  };

  factory Take.fromJson(Map<String, dynamic> json) => Take(
    path: json['path'] as String,
    scriptId: json['scriptId'] as String? ?? '',
    recordedAt:
        DateTime.tryParse(json['recordedAt'] as String? ?? '') ??
        DateTime(2000),
    seconds: json['seconds'] as int? ?? 0,
  );
}

/// A deleted script, kept for [Storage.trashDays] days.
class TrashedScript {
  const TrashedScript(this.script, this.deletedAt);

  final Script script;
  final DateTime deletedAt;

  Map<String, dynamic> toJson() => {
    'script': script.toJson(),
    'deletedAt': deletedAt.toIso8601String(),
  };

  factory TrashedScript.fromJson(Map<String, dynamic> json) => TrashedScript(
    Script.fromJson(json['script'] as Map<String, dynamic>),
    DateTime.tryParse(json['deletedAt'] as String? ?? '') ?? DateTime.now(),
  );
}

/// Persists scripts and prompter settings on the device.
class Storage {
  Storage._(this._prefs);

  static const _scriptsKey = 'scripts';
  static const _settingsKey = 'settings';
  static const _activeScriptKey = 'active_script';
  static const _floatPositionKey = 'float_position';
  static const _localeKey = 'app_locale';
  static const _trashKey = 'trash';
  static const _versionsPrefix = 'versions_';
  static const _schemaKey = 'schema_version';

  /// Bumped when the stored format changes, so later versions can migrate.
  static const schemaVersion = 1;

  /// How long deleted scripts stay in "Recently deleted".
  static const trashDays = 30;

  /// Earlier versions kept per script.
  static const maxVersions = 30;

  final SharedPreferences _prefs;

  static Future<Storage> open() async =>
      Storage._(await SharedPreferences.getInstance());

  /// Re-read values written by another engine (e.g. the Android overlay).
  Future<void> reload() => _prefs.reload();

  static const _indexKey = 'script_index';
  static const _scriptPrefix = 'script:';

  /// Loads the library. Never throws: unreadable entries are skipped and
  /// backed up so nothing is silently destroyed.
  ///
  /// Each script is stored under its own key (D3), so saving one script
  /// doesn't rewrite the whole library. Libraries from older versions (one
  /// JSON list under "scripts") are moved over on first start.
  List<Script> loadScripts() {
    final legacy = _prefs.getString(_scriptsKey);
    if (legacy != null) {
      final scripts = _parseLegacy(legacy);
      _migrate(scripts);
      return scripts..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    }
    final index = _prefs.getStringList(_indexKey);
    if (index == null) {
      final welcome = _welcomeScript();
      saveScript(welcome).ignore();
      saveSeedScriptId(welcome.id).ignore();
      return [welcome];
    }
    final scripts = <Script>[];
    for (final id in index) {
      final raw = _prefs.getString('$_scriptPrefix$id');
      if (raw == null) continue;
      try {
        scripts.add(Script.fromJson(jsonDecode(raw) as Map<String, dynamic>));
      } catch (_) {
        _backUpDamaged(raw);
      }
    }
    return scripts..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
  }

  List<Script> _parseLegacy(String raw) {
    final scripts = <Script>[];
    var damaged = false;
    try {
      for (final entry in jsonDecode(raw) as List) {
        try {
          scripts.add(Script.fromJson(entry as Map<String, dynamic>));
        } catch (_) {
          damaged = true;
        }
      }
    } catch (_) {
      damaged = true;
    }
    if (damaged) _backUpDamaged(raw);
    return scripts;
  }

  /// The old single-list format is removed only once every script is
  /// stored on its own, so an interrupted move is simply redone.
  Future<void> _migrate(List<Script> scripts) async {
    try {
      await saveScripts(scripts);
      await _prefs.remove(_scriptsKey);
    } catch (_) {
      // Try again on the next start.
    }
  }

  void _backUpDamaged(String raw) {
    _prefs
        .setString(
          '$_scriptsKey$backupSuffix${DateTime.now().microsecondsSinceEpoch}',
          raw,
        )
        .ignore();
  }

  static const backupSuffix = '_backup_';

  /// Writes [value] and throws [SaveFailed] if the phone refused it.
  Future<void> _write(String key, String value) async {
    bool ok;
    try {
      ok = await _prefs.setString(key, value);
    } catch (_) {
      ok = false;
    }
    if (!ok) throw SaveFailed(key);
  }

  Future<void> _writeIndex(List<String> ids) async {
    bool ok;
    try {
      ok = await _prefs.setStringList(_indexKey, ids);
    } catch (_) {
      ok = false;
    }
    if (!ok) throw const SaveFailed(_indexKey);
    if (_prefs.getInt(_schemaKey) != schemaVersion) {
      await _prefs.setInt(_schemaKey, schemaVersion);
    }
  }

  /// Saves one script.
  Future<void> saveScript(Script script) async {
    await _write('$_scriptPrefix${script.id}', jsonEncode(script.toJson()));
    final index = _prefs.getStringList(_indexKey) ?? const [];
    if (!index.contains(script.id)) await _writeIndex([...index, script.id]);
  }

  /// Removes one script from the library (not from the trash).
  Future<void> removeScript(String id) async {
    final index = _prefs.getStringList(_indexKey) ?? const [];
    await _writeIndex([
      for (final i in index)
        if (i != id) i,
    ]);
    await _prefs.remove('$_scriptPrefix$id');
  }

  /// Writes the whole library (bulk changes: import, migration, retry).
  Future<void> saveScripts(List<Script> scripts) async {
    for (final s in scripts) {
      await _write('$_scriptPrefix${s.id}', jsonEncode(s.toJson()));
    }
    final ids = [for (final s in scripts) s.id];
    final old = _prefs.getStringList(_indexKey) ?? const [];
    await _writeIndex(ids);
    for (final id in old) {
      if (!ids.contains(id)) await _prefs.remove('$_scriptPrefix$id');
    }
  }

  /// D4: data that couldn't be read, by storage key, oldest first.
  Map<String, String> damagedBackups() => {
    for (final k in _prefs.getKeys().toList()..sort())
      if (k.startsWith('$_scriptsKey$backupSuffix'))
        if (_prefs.getString(k) case final String raw) k: raw,
  };

  Future<void> deleteBackup(String key) => _prefs.remove(key);

  /// Earlier versions of script [id], newest first.
  List<ScriptVersion> loadVersions(String id) {
    final raw = _prefs.getString('$_versionsPrefix$id');
    if (raw == null) return [];
    try {
      return [
        for (final v in jsonDecode(raw) as List)
          ScriptVersion.fromJson(v as Map<String, dynamic>),
      ];
    } catch (_) {
      return [];
    }
  }

  Future<void> saveVersions(String id, List<ScriptVersion> versions) =>
      versions.isEmpty
      ? _prefs.remove('$_versionsPrefix$id')
      : _write(
          '$_versionsPrefix$id',
          jsonEncode(
            versions.take(maxVersions).map((v) => v.toJson()).toList(),
          ),
        );

  /// Recently deleted scripts, newest first; older than [trashDays] dropped.
  List<TrashedScript> loadTrash() {
    final raw = _prefs.getString(_trashKey);
    if (raw == null) return [];
    final cutoff = DateTime.now().subtract(const Duration(days: trashDays));
    try {
      return [
          for (final t in jsonDecode(raw) as List)
            TrashedScript.fromJson(t as Map<String, dynamic>),
        ].where((t) => t.deletedAt.isAfter(cutoff)).toList()
        ..sort((a, b) => b.deletedAt.compareTo(a.deletedAt));
    } catch (_) {
      return [];
    }
  }

  Future<void> saveTrash(List<TrashedScript> trash) => trash.isEmpty
      ? _prefs.remove(_trashKey)
      : _write(_trashKey, jsonEncode(trash.map((t) => t.toJson()).toList()));

  PrompterSettings loadSettings() {
    final raw = _prefs.getString(_settingsKey);
    if (raw == null) return const PrompterSettings();
    try {
      return PrompterSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return const PrompterSettings();
    }
  }

  Future<void> saveSettings(PrompterSettings settings) =>
      _write(_settingsKey, jsonEncode(settings.toJson()));

  static const _takesKey = 'takes';

  /// Takes kept inside the app, newest first.
  List<Take> loadTakes() {
    final raw = _prefs.getString(_takesKey);
    if (raw == null) return [];
    try {
      return [
        for (final t in jsonDecode(raw) as List)
          Take.fromJson(t as Map<String, dynamic>),
      ]..sort((a, b) => b.recordedAt.compareTo(a.recordedAt));
    } catch (_) {
      return [];
    }
  }

  Future<void> saveTakes(List<Take> takes) =>
      _write(_takesKey, jsonEncode(takes.map((t) => t.toJson()).toList()));

  static const _appLockKey = 'app_lock';

  /// Y1: ask for fingerprint / face / PIN to open the app.
  bool get appLock => _prefs.getBool(_appLockKey) ?? false;
  Future<void> setAppLock(bool on) => _prefs.setBool(_appLockKey, on);

  static const _oemTipsKey = 'oem_tips_seen';

  /// Whether the phone-maker Float tips were shown (F2).
  bool get oemTipsSeen => _prefs.getBool(_oemTipsKey) ?? false;
  Future<void> setOemTipsSeen() => _prefs.setBool(_oemTipsKey, true);

  static const _cameraIntroKey = 'camera_intro_seen';

  /// Whether the camera/microphone explanation was shown (O1).
  bool get cameraIntroSeen => _prefs.getBool(_cameraIntroKey) ?? false;
  Future<void> setCameraIntroSeen() => _prefs.setBool(_cameraIntroKey, true);

  static const _wordCapMigrationKey = 'word_cap_migration_done';

  /// Whether the one-time free-word-cap grandfathering snapshot has run.
  bool get wordCapMigrationDone =>
      _prefs.getBool(_wordCapMigrationKey) ?? false;
  Future<void> setWordCapMigrationDone() =>
      _prefs.setBool(_wordCapMigrationKey, true);

  static const _grandfatheredWordCapKey = 'grandfathered_word_cap_ids';

  /// Script ids exempt from the free word cap because they already had
  /// more than the cap's words before the paywall shipped.
  Set<String> get grandfatheredWordCapIds =>
      (_prefs.getStringList(_grandfatheredWordCapKey) ?? const []).toSet();

  Future<void> saveGrandfatheredWordCapIds(Set<String> ids) =>
      _prefs.setStringList(_grandfatheredWordCapKey, ids.toList());

  static const _seedScriptIdKey = 'seed_script_id';

  /// The auto-seeded welcome script's id, so a free account's one script
  /// slot isn't already spent by the tutorial content on first launch.
  /// Null once the library existed before this was tracked, or was never
  /// freshly seeded (e.g. restored from a backup).
  String? loadSeedScriptId() => _prefs.getString(_seedScriptIdKey);

  Future<void> saveSeedScriptId(String id) =>
      _prefs.setString(_seedScriptIdKey, id);

  static const _signedInUidKey = 'signed_in_uid';

  /// The signed-in person's stable identity (Apple/Google), or null.
  String? loadSignedInUid() => _prefs.getString(_signedInUidKey);

  Future<void> saveSignedInUid(String? uid) => uid == null
      ? _prefs.remove(_signedInUidKey)
      : _prefs.setString(_signedInUidKey, uid);

  static const _mySetupKey = 'my_setup';

  /// The creator's saved setup (S1), or null.
  PrompterSettings? loadMySetup() {
    final raw = _prefs.getString(_mySetupKey);
    if (raw == null) return null;
    try {
      return PrompterSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveMySetup(PrompterSettings settings) =>
      _write(_mySetupKey, jsonEncode(settings.toJson()));

  /// The script currently shown in the floating overlay.
  Script? loadActiveScript() {
    final raw = _prefs.getString(_activeScriptKey);
    if (raw == null) return null;
    try {
      return Script.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } catch (_) {
      return null;
    }
  }

  Future<void> saveActiveScript(Script script) =>
      _prefs.setString(_activeScriptKey, jsonEncode(script.toJson()));

  /// Last position of the Android floating window, in logical pixels.
  Offset? loadFloatPosition() {
    final raw = _prefs.getString(_floatPositionKey);
    if (raw == null) return null;
    try {
      final m = jsonDecode(raw) as Map<String, dynamic>;
      return Offset((m['x'] as num).toDouble(), (m['y'] as num).toDouble());
    } catch (_) {
      return null;
    }
  }

  Future<void> saveFloatPosition(Offset? position) => position == null
      ? _prefs.remove(_floatPositionKey)
      : _prefs.setString(
          _floatPositionKey,
          jsonEncode({'x': position.dx, 'y': position.dy}),
        );

  /// App language picked by the user ("zh-Hant", "ar"…); null = phone's.
  String? loadLocale() => _prefs.getString(_localeKey);

  Future<void> saveLocale(String? tag) => tag == null
      ? _prefs.remove(_localeKey)
      : _prefs.setString(_localeKey, tag);

  static Script newScript() => Script(
    id: const Uuid().v4(),
    title: '',
    body: '',
    updatedAt: DateTime.now(),
  );

  Script _welcomeScript() {
    final l = deviceLocalizations(parseLocaleTag(loadLocale()));
    return Script(
      id: const Uuid().v4(),
      title: l.welcomeTitle,
      status: ScriptStatus.ready,
      targetSeconds: 60,
      body: l.welcomeBody,
      updatedAt: DateTime.now(),
    );
  }
}
