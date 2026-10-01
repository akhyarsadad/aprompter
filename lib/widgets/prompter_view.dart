import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter/services.dart';

import '../l10n/l10n.dart';
import '../models/prompter_settings.dart';
import '../models/script_markup.dart';

/// Drives a [PrompterView]: play/pause, pace (words per minute) and
/// navigation between sections.
class PrompterController extends ChangeNotifier {
  PrompterController({double wpm = 150})
    : _wpm = PrompterSettings.clampWpm(wpm);

  bool _playing = false;
  double _wpm;
  _PrompterViewState? _view;
  final _readTime = Stopwatch();

  /// Scroll position from 0 (start) to 1 (end).
  final progress = ValueNotifier<double>(0);

  bool get playing => _playing;
  double get wpm => _wpm;

  /// Time spent actually scrolling since the last restart.
  Duration get readTime => _readTime.elapsed;

  set wpm(double value) {
    _wpm = PrompterSettings.clampWpm(value);
    notifyListeners();
  }

  void play() {
    if (_playing) return;
    _playing = true;
    _readTime.start();
    notifyListeners();
  }

  void pause() {
    if (!_playing) return;
    _playing = false;
    _readTime.stop();
    notifyListeners();
  }

  void toggle() => _playing ? pause() : play();

  void faster() => wpm = _wpm + PrompterSettings.wpmStep;
  void slower() => wpm = _wpm - PrompterSettings.wpmStep;

  /// Scroll back to the top and pause.
  void restart() {
    pause();
    _readTime.reset();
    _view?._jumpTo(0);
  }

  /// Jump so that section [index] sits on the reading line.
  void jumpToSection(int index) => _view?._jumpToSection(index);
  void nextSection() => _view?._stepSection(1);
  void previousSection() => _view?._stepSection(-1);

  @override
  void dispose() {
    progress.dispose();
    super.dispose();
  }
}

/// Auto-scrolling teleprompter text with markup support.
///
/// Tap to pause/resume, drag to scroll manually. Bluetooth remotes and
/// keyboards: Space/Enter/PageDown play-pause, PageUp previous section,
/// arrow keys change pace.
class PrompterView extends StatefulWidget {
  const PrompterView({
    super.key,
    required this.text,
    required this.settings,
    required this.controller,
    this.onFinished,
    this.manualScroll = true,
    this.onTap,
    this.autofocus = true,
    this.onFontSizeChanged,
  });

  final String text;
  final PrompterSettings settings;
  final PrompterController controller;
  final VoidCallback? onFinished;

  /// Whether vertical drags scroll the text. Disabled in the Android floating
  /// window, where drags move the window instead.
  final bool manualScroll;

  /// Overrides the default tap / play key behaviour (toggle play/pause).
  final VoidCallback? onTap;

  final bool autofocus;

  /// Called when the user pinches to resize the text. Pinch is disabled when
  /// null or when [manualScroll] is false.
  final ValueChanged<double>? onFontSizeChanged;

  @override
  State<PrompterView> createState() => _PrompterViewState();
}

class _PrompterViewState extends State<PrompterView>
    with SingleTickerProviderStateMixin {
  final _scroll = ScrollController();
  final _contentKey = GlobalKey();
  late final Ticker _ticker;
  late List<ScriptBlock> _blocks;
  late int _words;
  List<GlobalKey> _sectionKeys = [];
  Duration _lastTick = Duration.zero;
  bool _dragging = false;
  double? _pinchStartFontSize;

  @override
  void initState() {
    super.initState();
    _ticker = createTicker(_onTick);
    _parse();
    _scroll.addListener(_reportProgress);
    _attach(widget.controller);
  }

  void _parse() {
    _blocks = parseScript(widget.text);
    _words = countWords(spokenText(widget.text));
    _sectionKeys = [
      for (final b in _blocks)
        if (b.type == BlockType.section) GlobalKey(),
    ];
  }

  void _attach(PrompterController c) {
    c._view = this;
    c.addListener(_onControllerChanged);
    _onControllerChanged();
  }

  void _detach(PrompterController c) {
    if (c._view == this) c._view = null;
    c.removeListener(_onControllerChanged);
  }

  @override
  void didUpdateWidget(PrompterView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.text != widget.text) _parse();
    final old = oldWidget.settings;
    final now = widget.settings;
    if (_scroll.hasClients &&
        (old.fontSize != now.fontSize ||
            old.lineHeight != now.lineHeight ||
            old.mirror != now.mirror)) {
      // Keep the reader on the same line after the text reflows.
      final fraction = widget.controller.progress.value;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && _scroll.hasClients) {
          _jumpTo(fraction * _scroll.position.maxScrollExtent);
        }
      });
    }
    if (oldWidget.controller != widget.controller) {
      _detach(oldWidget.controller);
      _attach(widget.controller);
    }
  }

  void _onControllerChanged() {
    final c = widget.controller;
    if (c.playing && !_ticker.isActive) {
      // Playing again after the end starts over instead of finishing at once.
      if (_scroll.hasClients &&
          _scroll.position.maxScrollExtent > 0 &&
          _scroll.offset >= _scroll.position.maxScrollExtent - 1) {
        _jumpTo(0);
        c._readTime.reset();
      }
      _lastTick = Duration.zero;
      _ticker.start();
    } else if (!c.playing && _ticker.isActive) {
      _ticker.stop();
    }
    if (mounted) setState(() {});
  }

  /// Pixels per second so that the whole script takes words / wpm minutes,
  /// whatever the font size.
  double get _pixelsPerSecond {
    if (!_scroll.hasClients) return 0;
    final extent = _scroll.position.maxScrollExtent;
    if (_words == 0 || extent <= 0) return 40;
    final seconds = _words / widget.controller.wpm * 60;
    return extent / seconds;
  }

  void _onTick(Duration elapsed) {
    final dt = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    if (_dragging || !_scroll.hasClients) return;
    final pos = _scroll.position;
    final next = pos.pixels + _pixelsPerSecond * dt;
    if (next >= pos.maxScrollExtent) {
      _scroll.jumpTo(pos.maxScrollExtent);
      widget.controller.pause();
      widget.onFinished?.call();
    } else {
      _scroll.jumpTo(next);
    }
  }

  void _reportProgress() {
    if (!_scroll.hasClients) return;
    final max = _scroll.position.maxScrollExtent;
    widget.controller.progress.value = max <= 0
        ? 0
        : (_scroll.offset / max).clamp(0.0, 1.0);
  }

  void _jumpTo(double offset) {
    if (!_scroll.hasClients) return;
    final pos = _scroll.position;
    _scroll.jumpTo(offset.clamp(pos.minScrollExtent, pos.maxScrollExtent));
  }

  /// Scroll offsets that put each section heading on the reading line.
  List<double> _sectionOffsets() {
    final content = _contentKey.currentContext?.findRenderObject();
    if (content is! RenderBox) return [];
    return [
      for (final key in _sectionKeys)
        if (key.currentContext?.findRenderObject() case final RenderBox box)
          box.localToGlobal(Offset.zero, ancestor: content).dy,
    ];
  }

  void _jumpToSection(int index) {
    final offsets = _sectionOffsets();
    if (index < 0 || index >= offsets.length) return;
    _jumpTo(offsets[index]);
  }

  void _stepSection(int direction) {
    if (!_scroll.hasClients) return;
    final offsets = _sectionOffsets();
    final current = _scroll.offset;
    if (direction > 0) {
      for (final o in offsets) {
        if (o > current + 1) return _jumpTo(o);
      }
    } else {
      // Go to the start of the current section, or the previous one if we
      // are already (nearly) at its start.
      for (final o in offsets.reversed) {
        if (o < current - 24) return _jumpTo(o);
      }
      _jumpTo(0);
    }
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final c = widget.controller;
    final key = event.logicalKey;
    if (key == LogicalKeyboardKey.space ||
        key == LogicalKeyboardKey.enter ||
        key == LogicalKeyboardKey.pageDown ||
        key == LogicalKeyboardKey.mediaPlayPause) {
      if (event is KeyDownEvent) (widget.onTap ?? c.toggle)();
    } else if (key == LogicalKeyboardKey.pageUp) {
      c.previousSection();
    } else if (key == LogicalKeyboardKey.arrowUp) {
      c.faster();
    } else if (key == LogicalKeyboardKey.arrowDown) {
      c.slower();
    } else if (key == LogicalKeyboardKey.arrowRight) {
      c.nextSection();
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      c.previousSection();
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  void _onScaleStart(ScaleStartDetails d) {
    _dragging = true;
    _pinchStartFontSize = widget.settings.fontSize;
  }

  /// One finger scrolls; two fingers resize the text.
  void _onScaleUpdate(ScaleUpdateDetails d) {
    if (d.pointerCount >= 2 && widget.onFontSizeChanged != null) {
      final size = ((_pinchStartFontSize ?? widget.settings.fontSize) * d.scale)
          .clamp(PrompterSettings.minFontSize, PrompterSettings.maxFontSize)
          .roundToDouble();
      if (size != widget.settings.fontSize) widget.onFontSizeChanged!(size);
    } else if (d.pointerCount == 1 && _scroll.hasClients) {
      _jumpTo(_scroll.offset - d.focalPointDelta.dy);
    }
  }

  void _onScaleEnd(ScaleEndDetails d) {
    _dragging = false;
    _pinchStartFontSize = null;
  }

  @override
  void dispose() {
    _detach(widget.controller);
    _ticker.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.settings;
    final color = Color(s.textColor);
    return Focus(
      autofocus: widget.autofocus,
      onKeyEvent: _onKey,
      child: LayoutBuilder(
        builder: (context, constraints) {
          // Start the first line at the reading guide and let the last line
          // scroll all the way up to it.
          final guideY = constraints.maxHeight * 0.3;
          Widget content = ScriptText(
            key: _contentKey,
            blocks: _blocks,
            settings: s,
            sectionKeys: _sectionKeys,
          );
          if (s.mirror) content = Transform.flip(flipX: true, child: content);
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
                  onScaleStart: widget.manualScroll ? _onScaleStart : null,
                  onScaleUpdate: widget.manualScroll ? _onScaleUpdate : null,
                  onScaleEnd: widget.manualScroll ? _onScaleEnd : null,
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
                      child: content,
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
                      // Arrows point at the line in every UI direction.
                      textDirection: TextDirection.ltr,
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
      ),
    );
  }
}

/// Renders parsed script markup in prompter style. Also used for the live
/// preview in settings.
class ScriptText extends StatelessWidget {
  const ScriptText({
    super.key,
    required this.blocks,
    required this.settings,
    this.sectionKeys = const [],
  });

  final List<ScriptBlock> blocks;
  final PrompterSettings settings;
  final List<GlobalKey> sectionKeys;

  static const emphasisColor = Color(0xFFFFD54F);

  @override
  Widget build(BuildContext context) {
    final s = settings;
    final color = Color(s.textColor);
    final accent = s.textColor == 0xFFFFEB3B
        ? const Color(0xFF40C4FF)
        : emphasisColor;
    final base = TextStyle(
      color: color,
      fontSize: s.fontSize,
      height: s.lineHeight,
      fontWeight: FontWeight.w600,
      shadows: const [Shadow(blurRadius: 4, color: Colors.black54)],
    );
    // "Left" means the start of each line, so right-to-left lines (Arabic,
    // Hebrew…) hug the right edge even inside a left-to-right app.
    final align = s.textAlign == TextAlign.center
        ? TextAlign.center
        : TextAlign.start;
    TextDirection dir(String text) =>
        isRtlText(text) ? TextDirection.rtl : TextDirection.ltr;

    var sectionIndex = 0;
    final children = <Widget>[];
    for (final b in blocks) {
      switch (b.type) {
        case BlockType.blank:
          children.add(SizedBox(height: s.fontSize * 0.5));
        case BlockType.section:
          final key = sectionIndex < sectionKeys.length
              ? sectionKeys[sectionIndex]
              : null;
          sectionIndex++;
          children.add(
            Padding(
              key: key,
              padding: EdgeInsets.only(bottom: s.fontSize * 0.2),
              child: Text(
                b.text.toUpperCase(),
                textAlign: align,
                textDirection: dir(b.text),
                style: base.copyWith(
                  fontSize: s.fontSize * 0.5,
                  letterSpacing: 2,
                  color: accent.withValues(alpha: 0.9),
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          );
        case BlockType.note:
          children.add(
            Text(
              b.text,
              textAlign: align,
              textDirection: dir(b.text),
              style: base.copyWith(
                fontSize: s.fontSize * 0.5,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w400,
                color: color.withValues(alpha: 0.55),
              ),
            ),
          );
        case BlockType.line:
          children.add(
            Text.rich(
              TextSpan(
                style: base,
                children: [
                  for (final span in b.spans)
                    switch (span.type) {
                      SpanType.text => TextSpan(text: span.text),
                      SpanType.emphasis => TextSpan(
                        text: span.text,
                        style: TextStyle(
                          color: accent,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      SpanType.pause => TextSpan(
                        text: ' ‖ ',
                        style: TextStyle(color: accent.withValues(alpha: 0.8)),
                      ),
                    },
                ],
              ),
              textAlign: align,
              textDirection: dir(b.text),
            ),
          );
      }
    }
    if (children.isEmpty) {
      children.add(Text(context.l10n.emptyScript, style: base));
    }
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: children,
      ),
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
      if (_left > 0) HapticFeedback.selectionClick();
    }
    HapticFeedback.heavyImpact();
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
