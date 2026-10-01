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

  /// Loads the library. Never throws: unreadable entries are skipped and the
  /// original data is backed up so nothing is silently destroyed.
  List<Script> loadScripts() {
    final raw = _prefs.getString(_scriptsKey);
    if (raw == null) return [_welcomeScript()];
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
    if (damaged) {
      _prefs.setString(
        '$_scriptsKey$backupSuffix${DateTime.now().millisecondsSinceEpoch}',
        raw,
      );
    }
    return scripts..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
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

  Future<void> saveScripts(List<Script> scripts) async {
    await _write(
      _scriptsKey,
      jsonEncode(scripts.map((s) => s.toJson()).toList()),
    );
    if (_prefs.getInt(_schemaKey) != schemaVersion) {
      await _prefs.setInt(_schemaKey, schemaVersion);
    }
  }

  /// Backups made when saved data could not be read (see [loadScripts]).
  List<String> damagedBackupKeys() =>
      _prefs
          .getKeys()
          .where((k) => k.startsWith('$_scriptsKey$backupSuffix'))
          .toList()
        ..sort();

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
