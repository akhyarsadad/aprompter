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
      _locale = parseLocaleTag(storage.loadLocale());

  final Storage storage;
  List<Script> _scripts;
  PrompterSettings _settings;
  Locale? _locale;

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

  Future<void> upsert(Script script) {
    final updated = script.copyWith(updatedAt: DateTime.now());
    _scripts = [updated, ..._scripts.where((s) => s.id != script.id)];
    notifyListeners();
    return storage.saveScripts(_scripts);
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

  /// Removes a script and returns it so the deletion can be undone.
  Future<Script?> delete(String id) async {
    final removed = byId(id);
    _scripts = _scripts.where((s) => s.id != id).toList();
    notifyListeners();
    await storage.saveScripts(_scripts);
    return removed;
  }

  /// Puts a deleted script back unchanged.
  Future<void> restore(Script script) {
    _scripts = [script, ..._scripts.where((s) => s.id != script.id)]
      ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
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
