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
    status: ScriptStatus.ready,
    targetSeconds: 60,
    body:
        '# Hook\n'
        'Want to film without forgetting your lines? [pause]\n'
        '// look straight into the lens\n'
        '\n'
        '# How it works\n'
        'Write your script, pick a *target length*, and watch the timer '
        'tell you if it fits.\n'
        'Rehearse to find your pace in words per minute.\n'
        'Then hit Record. The text scrolls right under the camera, so you '
        'keep *eye contact* with your audience.\n'
        '\n'
        '# CTA\n'
        'Tap the pencil to edit this script, or create your own with '
        'the plus button. [pause] Have fun creating!\n',
    updatedAt: DateTime.now(),
  );
}
