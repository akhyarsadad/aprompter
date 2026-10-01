import 'dart:convert';

import 'package:flutter/painting.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../l10n/l10n.dart';
import '../models/prompter_settings.dart';
import '../models/script.dart';

/// Persists scripts and prompter settings on the device.
class Storage {
  Storage._(this._prefs);

  static const _scriptsKey = 'scripts';
  static const _settingsKey = 'settings';
  static const _activeScriptKey = 'active_script';
  static const _floatPositionKey = 'float_position';

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

  Future<void> saveScripts(List<Script> scripts) => _prefs.setString(
    _scriptsKey,
    jsonEncode(scripts.map((s) => s.toJson()).toList()),
  );

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
      _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));

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

  static Script newScript() => Script(
    id: const Uuid().v4(),
    title: '',
    body: '',
    updatedAt: DateTime.now(),
  );

  static Script _welcomeScript() {
    final l = deviceLocalizations();
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
