import 'dart:async';
import 'dart:convert';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../models/prompter_settings.dart';
import '../models/script.dart';
import '../services/storage.dart';
import '../widgets/prompter_controls.dart';
import '../widgets/prompter_view.dart';

/// The floating prompter window drawn above other apps (Android).
///
/// Runs in its own Flutter engine, started by `overlayMain` in main.dart.
class OverlayApp extends StatelessWidget {
  const OverlayApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(useMaterial3: true),
      home: const Material(
        type: MaterialType.transparency,
        child: _FloatingPrompter(),
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
    final script = storage.loadActiveScript();
    if (!mounted || _script != null || script == null) return;
    _apply(script, storage.loadSettings());
  }

  void _onMessage(dynamic event) {
    if (event is! String) return;
    final msg = jsonDecode(event) as Map<String, dynamic>;
    if (msg['type'] == 'load') {
      _apply(
        Script.fromJson(msg['script'] as Map<String, dynamic>),
        PrompterSettings.fromJson(msg['settings'] as Map<String, dynamic>),
      );
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

  Future<void> _toggleMinimize() async {
    final display = PlatformDispatcher.instance.displays.first;
    final screenDp = display.size.height / display.devicePixelRatio;
    final height = _minimized
        ? (screenDp * _settings.overlayHeightFraction).round()
        : 56;
    _controller.pause();
    await FlutterOverlayWindow.resizeOverlay(
      WindowSize.matchParent,
      height,
      true,
    );
    setState(() => _minimized = !_minimized);
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
                child: PrompterControls(
                  controller: _controller,
                  wordCount: _script?.wordCount ?? 0,
                  onPlay: _start,
                  dense: true,
                ),
              ),
            ),
          IconButton(
            tooltip: _minimized ? 'Expand' : 'Minimize',
            visualDensity: VisualDensity.compact,
            color: Colors.white,
            onPressed: _toggleMinimize,
            icon: Icon(_minimized ? Icons.open_in_full : Icons.minimize),
          ),
          IconButton(
            tooltip: 'Close',
            visualDensity: VisualDensity.compact,
            color: Colors.white,
            onPressed: () {
              _controller.pause();
              FlutterOverlayWindow.closeOverlay();
            },
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
                        ? const ColoredBox(
                            color: Colors.black54,
                            child: Center(
                              child: Text(
                                'Open a script in APrompter',
                                style: TextStyle(color: Colors.white),
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
