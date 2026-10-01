import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../models/prompter_settings.dart';
import '../models/script.dart';

/// Persists scripts and prompter settings on the device.
class Storage {
  Storage._(this._prefs);

  static const _scriptsKey = 'scripts';
  static const _settingsKey = 'settings';
  static const _activeScriptKey = 'active_script';

  final SharedPreferences _prefs;

  static Future<Storage> open() async =>
      Storage._(await SharedPreferences.getInstance());

  /// Re-read values written by another engine (e.g. the Android overlay).
  Future<void> reload() => _prefs.reload();

  List<Script> loadScripts() {
    final raw = _prefs.getString(_scriptsKey);
    if (raw == null) return [_welcomeScript()];
    final list =
        (jsonDecode(raw) as List)
            .map((e) => Script.fromJson(e as Map<String, dynamic>))
            .toList()
          ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
    return list;
  }

  Future<void> saveScripts(List<Script> scripts) => _prefs.setString(
    _scriptsKey,
    jsonEncode(scripts.map((s) => s.toJson()).toList()),
  );

  PrompterSettings loadSettings() {
    final raw = _prefs.getString(_settingsKey);
    if (raw == null) return const PrompterSettings();
    return PrompterSettings.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveSettings(PrompterSettings settings) =>
      _prefs.setString(_settingsKey, jsonEncode(settings.toJson()));

  /// The script currently shown in the floating overlay.
  Script? loadActiveScript() {
    final raw = _prefs.getString(_activeScriptKey);
    if (raw == null) return null;
    return Script.fromJson(jsonDecode(raw) as Map<String, dynamic>);
  }

  Future<void> saveActiveScript(Script script) =>
      _prefs.setString(_activeScriptKey, jsonEncode(script.toJson()));

  static Script newScript() => Script(
    id: const Uuid().v4(),
    title: '',
    body: '',
    updatedAt: DateTime.now(),
  );

  static Script _welcomeScript() => Script(
    id: const Uuid().v4(),
    title: 'Welcome to APrompter',
    body:
        'Hi there! This is your teleprompter.\n\n'
        'Tap the pencil to edit this script, or create a new one with the '
        '+ button.\n\n'
        'Use "Record" to film yourself with the text floating right under '
        'the front camera, so you keep eye contact with your audience.\n\n'
        'On Android you can also use "Float" to show this text on top of '
        'any other app — TikTok, Instagram, YouTube, Zoom and more.\n\n'
        'Tap the text to pause, drag it to scroll, and use the speed '
        'buttons to find your pace. Have fun creating!',
    updatedAt: DateTime.now(),
  );
}
