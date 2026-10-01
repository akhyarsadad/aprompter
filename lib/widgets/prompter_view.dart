import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';

import '../models/prompter_settings.dart';

/// Drives a [PrompterView]: play/pause, speed and restarting.
class PrompterController extends ChangeNotifier {
  PrompterController({double speed = 40})
    : _speed = speed.clamp(
        PrompterSettings.minSpeed,
        PrompterSettings.maxSpeed,
      );

  bool _playing = false;
  double _speed;
  int _restartToken = 0;

  bool get playing => _playing;
  double get speed => _speed;
  int get restartToken => _restartToken;

  set speed(double value) {
    _speed = value.clamp(PrompterSettings.minSpeed, PrompterSettings.maxSpeed);
    notifyListeners();
  }

  void play() {
    _playing = true;
    notifyListeners();
  }

  void pause() {
    _playing = false;
    notifyListeners();
  }

  void toggle() => _playing ? pause() : play();

  void faster() => speed = _speed + 5;
  void slower() => speed = _speed - 5;

  /// Scroll back to the top and pause.
  void restart() {
    _playing = false;
    _restartToken++;
    notifyListeners();
  }
}

/// Auto-scrolling teleprompter text.
///
/// Tap to pause/resume, drag to scroll manually.
class PrompterView extends StatefulWidget {
  const PrompterView({
    super.key,
    required this.text,
    required this.settings,
    required this.controller,
    this.onFinished,
    this.manualScroll = true,
    this.onTap,
  });

  final String text;
  final PrompterSettings settings;
  final PrompterController controller;
  final VoidCallback? onFinished;

  /// Whether vertical drags scroll the text. Disabled in the Android floating
  /// window, where drags move the window instead.
  final bool manualScroll;

  /// Overrides the default tap behaviour (toggle play/pause).
  final VoidCallback? onTap;

  @override
  State<PrompterView> createState() => _PrompterViewState();
}

class _PrompterViewState extends State<PrompterView>
    with SingleTickerProviderStateMixin {
  final _scroll = ScrollController();
  late final Ticker _ticker;
  Duration _lastTick = Duration.zero;
  bool _dragging = false;
  int _restartToken = 0;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _restartToken = widget.controller.restartToken;
    widget.controller.addListener(_onControllerChanged);
    _onControllerChanged();
  }

  @override
  void didUpdateWidget(PrompterView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.controller != widget.controller) {
      oldWidget.controller.removeListener(_onControllerChanged);
      widget.controller.addListener(_onControllerChanged);
      _onControllerChanged();
    }
  }

  void _onControllerChanged() {
    final c = widget.controller;
    if (c.restartToken != _restartToken) {
      _restartToken = c.restartToken;
      if (_scroll.hasClients) _scroll.jumpTo(0);
    }
    if (c.playing && !_ticker.isActive) {
      _lastTick = Duration.zero;
      _ticker.start();
    } else if (!c.playing && _ticker.isActive) {
      _ticker.stop();
    }
    if (mounted) setState(() {});
  }

  void _onTick(Duration elapsed) {
    final dt = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    if (_dragging || !_scroll.hasClients) return;
    final pos = _scroll.position;
    final next = pos.pixels + widget.controller.speed * dt;
    if (next >= pos.maxScrollExtent) {
      _scroll.jumpTo(pos.maxScrollExtent);
      widget.controller.pause();
      widget.onFinished?.call();
    } else {
      _scroll.jumpTo(next);
    }
  }

  void _onDrag(DragUpdateDetails d) {
    if (!_scroll.hasClients) return;
    final pos = _scroll.position;
    final delta = d.delta.dy;
    _scroll.jumpTo(
      (pos.pixels - delta).clamp(pos.minScrollExtent, pos.maxScrollExtent),
    );
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onControllerChanged);
    _ticker.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.settings;
    final color = Color(s.textColor);
    return LayoutBuilder(
      builder: (context, constraints) {
        // Start the first line at the reading guide and let the last line
        // scroll all the way up to it.
        final guideY = constraints.maxHeight * 0.3;
        Widget text = Text(
          widget.text.isEmpty ? '(empty script)' : widget.text,
          textAlign: s.textAlign,
          style: TextStyle(
            color: color,
            fontSize: s.fontSize,
            height: s.lineHeight,
            fontWeight: FontWeight.w600,
            shadows: const [Shadow(blurRadius: 4, color: Colors.black54)],
          ),
        );
        if (s.mirror) {
          text = Transform.flip(flipX: true, child: text);
        }
        return Stack(
          children: [
            Positioned.fill(
              child: ColoredBox(
                color: Colors.black.withValues(alpha: s.backgroundOpacity),
              ),
            ),
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: widget.onTap ?? widget.controller.toggle,
                onVerticalDragStart: widget.manualScroll
                    ? (_) => _dragging = true
                    : null,
                onVerticalDragUpdate: widget.manualScroll ? _onDrag : null,
                onVerticalDragEnd: widget.manualScroll
                    ? (_) => _dragging = false
                    : null,
                onVerticalDragCancel: widget.manualScroll
                    ? () => _dragging = false
                    : null,
                child: ShaderMask(
                  shaderCallback: (rect) => const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Colors.white,
                      Colors.white,
                      Colors.transparent,
                    ],
                    stops: [0, 0.08, 0.92, 1],
                  ).createShader(rect),
                  blendMode: BlendMode.dstIn,
                  child: SingleChildScrollView(
                    controller: _scroll,
                    physics: const NeverScrollableScrollPhysics(),
                    padding: EdgeInsets.fromLTRB(
                      16,
                      guideY,
                      16,
                      constraints.maxHeight - guideY,
                    ),
                    child: SizedBox(width: double.infinity, child: text),
                  ),
                ),
              ),
            ),
            if (s.showGuide)
              Positioned(
                top: guideY - 2,
                left: 0,
                right: 0,
                child: IgnorePointer(
                  child: Row(
                    children: [
                      Icon(
                        Icons.play_arrow,
                        color: color.withValues(alpha: 0.7),
                      ),
                      Expanded(
                        child: Container(
                          height: 2,
                          color: color.withValues(alpha: 0.25),
                        ),
                      ),
                      Transform.flip(
                        flipX: true,
                        child: Icon(
                          Icons.play_arrow,
                          color: color.withValues(alpha: 0.7),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            if (!widget.controller.playing)
              const Positioned(
                right: 8,
                bottom: 8,
                child: IgnorePointer(
                  child: Icon(
                    Icons.pause_circle,
                    color: Colors.white54,
                    size: 28,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}

/// Simple full-screen countdown shown before scrolling starts.
class Countdown extends StatefulWidget {
  const Countdown({super.key, required this.seconds, required this.onDone});

  final int seconds;
  final VoidCallback onDone;

  @override
  State<Countdown> createState() => _CountdownState();
}

class _CountdownState extends State<Countdown> {
  late int _left = widget.seconds;

  @override
  void initState() {
    super.initState();
    _tick();
  }

  Future<void> _tick() async {
    while (_left > 0) {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (!mounted) return;
      setState(() => _left--);
    }
    widget.onDone();
  }

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Center(
        child: Text(
          '$_left',
          style: const TextStyle(
            fontSize: 120,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(blurRadius: 12, color: Colors.black)],
          ),
        ),
      ),
    );
  }
}
