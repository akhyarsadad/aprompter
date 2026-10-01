import 'package:flutter/widgets.dart';

import '../models/prompter_settings.dart';
import '../models/script.dart';
import 'storage.dart';

/// App-wide state: the script library and prompter settings.
class AppState extends ChangeNotifier {
  AppState(this.storage)
    : _scripts = storage.loadScripts(),
      _settings = storage.loadSettings();

  final Storage storage;
  List<Script> _scripts;
  PrompterSettings _settings;

  List<Script> get scripts => List.unmodifiable(_scripts);
  PrompterSettings get settings => _settings;

  Script? byId(String id) {
    for (final s in _scripts) {
      if (s.id == id) return s;
    }
    return null;
  }

  Future<void> upsert(Script script) {
    final updated = script.copyWith(updatedAt: DateTime.now());
    _scripts = [updated, ..._scripts.where((s) => s.id != script.id)];
    notifyListeners();
    return storage.saveScripts(_scripts);
  }

  Future<void> delete(String id) {
    _scripts = _scripts.where((s) => s.id != id).toList();
    notifyListeners();
    return storage.saveScripts(_scripts);
  }

  Future<void> updateSettings(PrompterSettings settings) {
    _settings = settings;
    notifyListeners();
    return storage.saveSettings(settings);
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
