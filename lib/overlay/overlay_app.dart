import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../l10n/l10n.dart';
import '../models/prompter_settings.dart';
import '../models/script.dart';
import '../services/floating_prompter.dart';
import '../services/storage.dart';
import '../widgets/prompter_controls.dart';
import '../widgets/prompter_view.dart';

/// The floating prompter window drawn above other apps (Android).
///
/// Runs in its own Flutter engine, started by `overlayMain` in main.dart.
/// Language picked in the main app; updated from storage and messages.
final _locale = ValueNotifier<Locale?>(null);

class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _locale,
      builder: (context, locale, _) => MaterialApp(
        locale: locale,
        localeListResolutionCallback: (locales, _) => resolveAppLocale(locales),
        debugShowCheckedModeBanner: false,
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: ThemeData.dark(useMaterial3: true),
        home: const Material(
          type: MaterialType.transparency,
          child: _FloatingPrompter(),
        ),
      ),
    );
  }
}

class _FloatingPrompter extends StatefulWidget {
  const _FloatingPrompter();

  @override
  State<_FloatingPrompter> createState() => _FloatingPrompterState();
}

class _FloatingPrompterState extends State<_FloatingPrompter> {
  final _controller = PrompterController();
  StreamSubscription<dynamic>? _sub;
  Script? _script;
  PrompterSettings _settings = const PrompterSettings();
  bool _minimized = false;
  bool _counting = false;

  @override
  void initState() {
    super.initState();
    _sub = FlutterOverlayWindow.overlayListener.listen(_onMessage);
    _loadFromStorage();
  }

  Future<void> _loadFromStorage() async {
    final storage = await Storage.open();
    await storage.reload();
    _locale.value = parseLocaleTag(storage.loadLocale());
    final script = storage.loadActiveScript();
    if (!mounted || _script != null || script == null) return;
    _apply(script, storage.loadSettings());
  }

  void _onMessage(dynamic event) {
    if (event is! String) return;
    final msg = jsonDecode(event) as Map<String, dynamic>;
    if (msg['type'] == 'load') {
      _locale.value = parseLocaleTag(msg['locale'] as String?);
      _apply(
        Script.fromJson(msg['script'] as Map<String, dynamic>),
        PrompterSettings.fromJson(msg['settings'] as Map<String, dynamic>),
      );
    } else if (msg['type'] == 'update') {
      // The script was edited in the app: show the new text in place.
      final script = Script.fromJson(msg['script'] as Map<String, dynamic>);
      if (script.id == _script?.id) setState(() => _script = script);
    }
  }

  void _apply(Script script, PrompterSettings settings) {
    setState(() {
      _script = script;
      _settings = settings;
      _controller.wpm = settings.wpm;
      _counting = false;
    });
    _controller.restart();
  }

  void _start() {
    if (_controller.playing) {
      _controller.pause();
    } else if (_settings.countdownSeconds > 0 && !_counting) {
      setState(() => _counting = true);
    } else {
      _controller.play();
    }
  }

  /// F9: pace set in the window is kept for the app and the next float.
  Future<void> _savePace(double wpm) async {
    _settings = _settings.copyWith(wpm: wpm);
    final storage = await Storage.open();
    await storage.reload();
    await storage.saveSettings(storage.loadSettings().copyWith(wpm: wpm));
  }

  Future<void> _toggleMinimize() async {
    final display = PlatformDispatcher.instance.displays.first;
    final screen = display.size / display.devicePixelRatio;
    final window = FloatingPrompter.windowSize(screen, _settings);
    _controller.pause();
    await FloatingPrompter.rememberPosition();
    // resizeOverlay takes logical pixels.
    await FlutterOverlayWindow.resizeOverlay(
      window.width.round(),
      _minimized ? window.height.round() : 56,
      true,
    );
    setState(() => _minimized = !_minimized);
  }

  Future<void> _close() async {
    _controller.pause();
    await FloatingPrompter.rememberPosition();
    await FlutterOverlayWindow.closeOverlay();
  }

  @override
  void dispose() {
    _sub?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bar = Container(
      height: 48,
      color: Colors.black.withValues(alpha: 0.75),
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          const Icon(Icons.drag_indicator, color: Colors.white54),
          Expanded(
            child: Text(
              _script?.title.isNotEmpty == true ? _script!.title : 'APrompter',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Colors.white, fontSize: 13),
            ),
          ),
          if (!_minimized)
            Flexible(
              flex: 4,
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Drags move the window, so these are the way back to
                    // a line or section.
                    IconButton(
                      tooltip: context.l10n.previousSection,
                      visualDensity: VisualDensity.compact,
                      color: Colors.white,
                      onPressed: _controller.previousSection,
                      icon: const Icon(Icons.skip_previous),
                    ),
                    IconButton(
                      tooltip: context.l10n.nextSection,
                      visualDensity: VisualDensity.compact,
                      color: Colors.white,
                      onPressed: _controller.nextSection,
                      icon: const Icon(Icons.skip_next),
                    ),
                    PrompterControls(
                      controller: _controller,
                      wordCount: _script?.wordCount ?? 0,
                      pauses: _script?.pauses ?? 0,
                      onPlay: _start,
                      onWpmChanged: _savePace,
                      dense: true,
                    ),
                  ],
                ),
              ),
            ),
          IconButton(
            tooltip: _minimized ? context.l10n.expand : context.l10n.minimize,
            visualDensity: VisualDensity.compact,
            color: Colors.white,
            onPressed: _toggleMinimize,
            icon: Icon(_minimized ? Icons.open_in_full : Icons.minimize),
          ),
          IconButton(
            tooltip: context.l10n.close,
            visualDensity: VisualDensity.compact,
            color: Colors.white,
            onPressed: _close,
            icon: const Icon(Icons.close),
          ),
        ],
      ),
    );

    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Column(
        children: [
          bar,
          if (!_minimized)
            Expanded(
              child: Stack(
                children: [
                  Positioned.fill(
                    child: _script == null
                        ? ColoredBox(
                            color: Colors.black54,
                            child: Center(
                              child: Text(
                                context.l10n.openScriptInApp,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                        : PrompterView(
                            text: _script!.body,
                            settings: _settings,
                            controller: _controller,
                            manualScroll: false,
                            autofocus: false,
                            onTap: _start,
                          ),
                  ),
                  if (_counting)
                    Countdown(
                      seconds: _settings.countdownSeconds,
                      onDone: () {
                        if (!mounted) return;
                        setState(() => _counting = false);
                        _controller.play();
                      },
                    ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
