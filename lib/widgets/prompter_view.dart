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
  bool _jumped = false;

  /// The reader dragged or jumped during this run, so its time says
  /// nothing reliable about their pace.
  bool get jumpedDuringRun => _jumped;

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
    _jumped = false;
    _view?._jumpTo(0);
  }

  /// Jump so that section [index] sits on the reading line.
  void jumpToSection(int index) =>
      _markJump(() => _view?._jumpToSection(index));
  void nextSection() => _markJump(() => _view?._stepSection(1));
  void previousSection() => _markJump(() => _view?._stepSection(-1));

  /// Puts the reading line at [fraction] of the script (0 = start).
  void seek(double fraction) {
    final view = _view;
    if (view == null || !view._scroll.hasClients) return;
    view._jumpTo(fraction * view._scroll.position.maxScrollExtent);
  }

  /// Gives the keyboard (remote) back to the prompter, e.g. after a sheet.
  void focus() => _view?._focus.requestFocus();

  void _markJump(VoidCallback jump) {
    if (_readTime.elapsed > Duration.zero) _jumped = true;
    jump();
  }

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
    this.onWpmChanged,
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

  /// Called when a remote or keyboard changes the pace, so it is kept.
  final ValueChanged<double>? onWpmChanged;

  @override
  State<PrompterView> createState() => _PrompterViewState();
}

class _PrompterViewState extends State<PrompterView>
    with SingleTickerProviderStateMixin {
  final _scroll = ScrollController();
  final _contentKey = GlobalKey();
  late final Ticker _ticker;
  late List<ScriptBlock> _blocks;
  List<GlobalKey> _sectionKeys = [];
  List<GlobalKey> _blockKeys = [];
  List<_Segment>? _timeline;
  double _timelineExtent = -1;
  Duration _lastTick = Duration.zero;
  bool _dragging = false;
  double? _pinchStartFontSize;
  final _focus = FocusNode(debugLabel: 'prompter');

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
    _sectionKeys = [
      for (final b in _blocks)
        if (b.type == BlockType.section) GlobalKey(),
    ];
    _blockKeys = [for (final _ in _blocks) GlobalKey()];
    _timeline = null;
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
    _timeline = null;
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
    // Line by line needs no ticker: nothing moves on its own.
    if (c.playing && !_ticker.isActive && !widget.settings.stepByLine) {
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

  /// Where each block sits and how long it takes to say. Spoken lines take
  /// their words / wpm (plus pauses), whatever the font size; sections, notes
  /// and blank lines glide by quickly so they don't eat into spoken time.
  List<_Segment> _segments(double extent) {
    if (_timeline != null && _timelineExtent == extent) return _timeline!;
    final content = _contentKey.currentContext?.findRenderObject();
    final segments = <_Segment>[];
    if (content is RenderBox) {
      for (final (i, key) in _blockKeys.indexed) {
        final box = key.currentContext?.findRenderObject();
        if (box is! RenderBox || !box.hasSize) continue;
        final top = box.localToGlobal(Offset.zero, ancestor: content).dy;
        final b = _blocks[i];
        final line = b.type == BlockType.line;
        segments.add(
          _Segment(
            top,
            top + box.size.height,
            words: line ? countWords(spokenText(b.text)) : 0,
            pauses: line
                ? b.spans.where((s) => s.type == SpanType.pause).length
                : 0,
          ),
        );
      }
    }
    // Right after the text changes, new blocks may not be laid out yet:
    // measure again next frame instead of keeping a partial timeline.
    if (segments.length == _blockKeys.length) {
      _timeline = segments;
      _timelineExtent = extent;
    }
    return segments;
  }

  /// Scrolls [dt] seconds' worth of text from [from]; returns the new offset.
  double _advance(double from, double dt, double extent) {
    final wpm = widget.controller.wpm;
    final segments = _segments(extent);
    final spoken = segments.where((s) => s.words + s.pauses > 0);
    final spokenPx = spoken.fold<double>(0, (a, s) => a + s.height);
    final spokenSec = spoken.fold<double>(0, (a, s) => a + s.seconds(wpm));
    // Only markup: keep a steady, readable pace.
    if (spokenSec <= 0) return from + 40 * dt;
    final glide = 3 * spokenPx / spokenSec;
    var offset = from;
    var left = dt;
    for (final s in segments) {
      if (left <= 0) break;
      if (s.end <= offset) continue;
      final seconds = s.words + s.pauses > 0
          ? s.seconds(wpm)
          : s.height / glide;
      final speed = seconds <= 0 ? double.infinity : s.height / seconds;
      final room = s.end - offset;
      if (room / speed >= left) return offset + speed * left;
      left -= room / speed;
      offset = s.end;
    }
    return left > 0 ? extent : offset;
  }

  void _onTick(Duration elapsed) {
    final dt = (elapsed - _lastTick).inMicroseconds / 1e6;
    _lastTick = elapsed;
    if (_dragging || !_scroll.hasClients || widget.settings.stepByLine) return;
    final pos = _scroll.position;
    final next = _advance(pos.pixels, dt, pos.maxScrollExtent);
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

  /// Keyboards, page-turners (`B` and `.` blank the screen in slide apps)
  /// and cheap selfie remotes, which send Volume Up.
  static final _playPauseKeys = {
    LogicalKeyboardKey.space,
    LogicalKeyboardKey.enter,
    LogicalKeyboardKey.pageDown,
    LogicalKeyboardKey.mediaPlayPause,
    LogicalKeyboardKey.mediaPlay,
    LogicalKeyboardKey.mediaPause,
    LogicalKeyboardKey.audioVolumeUp,
    LogicalKeyboardKey.audioVolumeDown,
    LogicalKeyboardKey.keyB,
    LogicalKeyboardKey.period,
  };

  /// Line-by-line mode: puts the next (or previous) spoken line on the
  /// reading line. Past the last line the script is finished.
  void _stepLine(int direction) {
    if (!_scroll.hasClients) return;
    final pos = _scroll.position;
    final starts = [
      for (final s in _segments(pos.maxScrollExtent))
        if (s.words + s.pauses > 0) s.start,
    ];
    final current = _scroll.offset;
    if (direction > 0) {
      for (final o in starts) {
        if (o > current + 1) return _animateTo(o);
      }
      _animateTo(pos.maxScrollExtent);
      widget.controller.pause();
      widget.onFinished?.call();
    } else {
      for (final o in starts.reversed) {
        if (o < current - 1) return _animateTo(o);
      }
      _animateTo(0);
    }
  }

  void _animateTo(double offset) {
    final pos = _scroll.position;
    _scroll.animateTo(
      offset.clamp(pos.minScrollExtent, pos.maxScrollExtent),
      duration: widget.settings.reduceEffects
          ? const Duration(milliseconds: 1)
          : const Duration(milliseconds: 250),
      curve: Curves.easeOut,
    );
  }

  /// Tap / play key: in line-by-line mode, while reading, each press is the
  /// next line.
  void _onPrimary() {
    if (widget.settings.stepByLine && widget.controller.playing) {
      _stepLine(1);
    } else {
      (widget.onTap ?? widget.controller.toggle)();
    }
  }

  /// R1: a hand holding the phone touches the screen edges; those touches
  /// must not pause a take.
  static const _edgeDeadZone = 24.0;

  void _onTapUp(TapUpDetails d) {
    final width = context.size?.width ?? 0;
    if (widget.manualScroll &&
        width > 4 * _edgeDeadZone &&
        (d.localPosition.dx < _edgeDeadZone ||
            d.localPosition.dx > width - _edgeDeadZone)) {
      return;
    }
    _onPrimary();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final c = widget.controller;
    final key = event.logicalKey;
    if (_playPauseKeys.contains(key)) {
      if (event is KeyDownEvent) _onPrimary();
    } else if (key == LogicalKeyboardKey.pageUp ||
        key == LogicalKeyboardKey.mediaTrackPrevious ||
        key == LogicalKeyboardKey.mediaRewind) {
      c.previousSection();
    } else if (key == LogicalKeyboardKey.mediaTrackNext ||
        key == LogicalKeyboardKey.mediaFastForward) {
      c.nextSection();
    } else if (key == LogicalKeyboardKey.arrowUp) {
      if (widget.settings.stepByLine) return _stepAndHandle(-1);
      c.faster();
      widget.onWpmChanged?.call(c.wpm);
    } else if (key == LogicalKeyboardKey.arrowDown) {
      if (widget.settings.stepByLine) return _stepAndHandle(1);
      c.slower();
      widget.onWpmChanged?.call(c.wpm);
    } else if (key == LogicalKeyboardKey.arrowRight) {
      c.nextSection();
    } else if (key == LogicalKeyboardKey.arrowLeft) {
      c.previousSection();
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  KeyEventResult _stepAndHandle(int direction) {
    _stepLine(direction);
    return KeyEventResult.handled;
  }

  void _onScaleStart(ScaleStartDetails d) {
    _dragging = true;
    if (widget.controller.playing) widget.controller._jumped = true;
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

  /// Fades text at the edges; with "focus line", also dims everything but
  /// the line being read (R8). No mask at all when effects are reduced.
  Widget _mask(PrompterSettings s, double height, Widget child) {
    if (s.reduceEffects && !s.focusLine) return child;
    const guide = 0.3;
    final line = height <= 0
        ? 0.1
        : (s.fontSize * s.lineHeight * 1.15 / height).clamp(0.02, 0.5);
    const dim = Color(0x40FFFFFF);
    final gradient = s.focusLine
        ? LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: const [dim, dim, Colors.white, Colors.white, dim, dim],
            stops: [
              0,
              (guide - 0.03).clamp(0.0, 1.0),
              guide - 0.005,
              (guide + line).clamp(0.0, 1.0),
              (guide + line + 0.03).clamp(0.0, 1.0),
              1,
            ],
          )
        : const LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.transparent,
              Colors.white,
              Colors.white,
              Colors.transparent,
            ],
            stops: [0, 0.08, 0.92, 1],
          );
    return ShaderMask(
      shaderCallback: gradient.createShader,
      blendMode: BlendMode.dstIn,
      child: child,
    );
  }

  @override
  void dispose() {
    _detach(widget.controller);
    _focus.dispose();
    _ticker.dispose();
    _scroll.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.settings;
    final color = Color(s.textColor);
    final l = context.l10n;
    // A2: screen readers get the spoken text and play / pause.
    final spoken = spokenText(widget.text);
    return Semantics(
      container: true,
      label: l.script,
      value: spoken.length > 4000 ? spoken.substring(0, 4000) : spoken,
      onTapHint: widget.controller.playing ? l.pause : l.play,
      onTap: _onPrimary,
      child: Focus(
        focusNode: _focus,
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
              blockKeys: _blockKeys,
            );
            if (s.mirror) content = Transform.flip(flipX: true, child: content);
            return Stack(
              children: [
                Positioned.fill(
                  child: ColoredBox(
                    // R2: dark text gets a light backdrop so it stays readable.
                    color:
                        (PrompterSettings.isDark(s.textColor)
                                ? Colors.white
                                : Colors.black)
                            .withValues(alpha: s.backgroundOpacity),
                  ),
                ),
                Positioned.fill(
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapUp: _onTapUp,
                    onScaleStart: widget.manualScroll ? _onScaleStart : null,
                    onScaleUpdate: widget.manualScroll ? _onScaleUpdate : null,
                    onScaleEnd: widget.manualScroll ? _onScaleEnd : null,
                    child: _mask(
                      s,
                      constraints.maxHeight,
                      SingleChildScrollView(
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
    this.blockKeys = const [],
  });

  final List<ScriptBlock> blocks;
  final PrompterSettings settings;
  final List<GlobalKey> sectionKeys;

  /// One key per block, so the prompter can measure where each one sits.
  final List<GlobalKey> blockKeys;

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
      letterSpacing: s.letterSpacing,
      shadows: s.reduceEffects
          ? null
          : [
              Shadow(
                blurRadius: 4,
                color: PrompterSettings.isDark(s.textColor)
                    ? Colors.white54
                    : Colors.black54,
              ),
            ],
    );
    // "Left" means the start of each line, so right-to-left lines (Arabic,
    // Hebrew…) hug the right edge even inside a left-to-right app.
    final align = s.textAlign == TextAlign.center
        ? TextAlign.center
        : TextAlign.start;
    TextDirection dir(String text) =>
        isRtlText(text) ? TextDirection.rtl : TextDirection.ltr;

    var sectionIndex = 0;
    Widget block(ScriptBlock b) {
      switch (b.type) {
        case BlockType.blank:
          return SizedBox(height: s.fontSize * 0.5);
        case BlockType.section:
          final key = sectionIndex < sectionKeys.length
              ? sectionKeys[sectionIndex]
              : null;
          sectionIndex++;
          return Padding(
            key: key,
            padding: EdgeInsets.only(bottom: s.fontSize * 0.2),
            child: Text(
              // Not upper-cased: casing rules differ per language
              // (Turkish i → İ, German ß…).
              b.text,
              textAlign: align,
              textDirection: dir(b.text),
              style: base.copyWith(
                fontSize: s.fontSize * 0.5,
                letterSpacing: 2,
                color: accent.withValues(alpha: 0.9),
                fontWeight: FontWeight.w800,
              ),
            ),
          );
        case BlockType.note:
        case BlockType.tags:
          return Text(
            b.text,
            textAlign: align,
            textDirection: dir(b.text),
            style: base.copyWith(
              fontSize: s.fontSize * 0.5,
              fontStyle: b.type == BlockType.note ? FontStyle.italic : null,
              fontWeight: FontWeight.w400,
              color: color.withValues(alpha: 0.55),
            ),
          );
        case BlockType.line:
          return Text.rich(
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
          );
      }
    }

    final children = <Widget>[
      for (final (i, b) in blocks.indexed)
        i < blockKeys.length
            ? KeyedSubtree(key: blockKeys[i], child: block(b))
            : block(b),
    ];
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

/// A block's place in the scroll and what is said in it.
class _Segment {
  const _Segment(this.start, this.end, {this.words = 0, this.pauses = 0});

  final double start;
  final double end;
  final int words;
  final int pauses;

  double get height => end - start;

  double seconds(double wpm) => words / wpm * 60 + pauses * pauseSeconds;
}
