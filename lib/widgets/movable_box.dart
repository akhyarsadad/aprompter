import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../models/prompter_settings.dart';

/// Positions the prompter inside [area] and lets the creator drag it
/// anywhere (grip on top) and resize it (handle in the bottom-right corner).
///
/// Changes are previewed live and reported once through [onChanged] when the
/// gesture ends, so settings are not written on every frame.
class MovablePrompterBox extends StatefulWidget {
  const MovablePrompterBox({
    super.key,
    required this.area,
    required this.settings,
    required this.onChanged,
    required this.child,
    this.moveTooltip,
    this.resizeTooltip,
  });

  /// The region the box may occupy, in the parent Stack's coordinates.
  final Rect area;
  final PrompterSettings settings;
  final ValueChanged<PrompterSettings> onChanged;
  final Widget child;
  final String? moveTooltip;
  final String? resizeTooltip;

  @override
  State<MovablePrompterBox> createState() => _MovablePrompterBoxState();
}

class _MovablePrompterBoxState extends State<MovablePrompterBox> {
  /// Box while a gesture is in progress, relative to [MovablePrompterBox.area].
  Rect? _live;

  Size get _areaSize => widget.area.size;

  Rect get _rect => _live ?? widget.settings.prompterRect(_areaSize);

  void _move(DragUpdateDetails d) {
    final r = _rect.shift(d.delta);
    setState(() {
      _live = Rect.fromLTWH(
        r.left.clamp(0.0, _areaSize.width - r.width),
        r.top.clamp(0.0, _areaSize.height - r.height),
        r.width,
        r.height,
      );
    });
  }

  void _resize(DragUpdateDetails d) {
    final r = _rect;
    final minW = _areaSize.width * PrompterSettings.minWidthFraction;
    final minH = _areaSize.height * PrompterSettings.minHeightFraction;
    setState(() {
      _live = Rect.fromLTWH(
        r.left,
        r.top,
        (r.width + d.delta.dx).clamp(minW, _areaSize.width - r.left),
        (r.height + d.delta.dy).clamp(minH, _areaSize.height - r.top),
      );
    });
  }

  void _commit([DragEndDetails? _]) {
    final live = _live;
    if (live == null) return;
    widget.onChanged(widget.settings.withPrompterRect(live, _areaSize));
    // Keep showing the live rect until the new settings arrive.
  }

  @override
  void didUpdateWidget(MovablePrompterBox oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.settings != widget.settings ||
        oldWidget.area != widget.area) {
      _live = null;
    }
  }

  /// A3: 48 dp touch targets (accessibility minimum).
  static const _target = 48.0;
  static const _gripWidth = 96.0;

  @override
  Widget build(BuildContext context) {
    final r = _rect.shift(widget.area.topLeft);
    final moving = _live != null;
    // The grip stays clear of the left 48 dp, where the prompter's reading
    // line handle can sit: centred when the box is wide enough, otherwise
    // moved (and narrowed) to the right.
    final gripWidth = math.min(
      _gripWidth,
      math.max(_target, r.width - _target),
    );
    final gripLeft = math.max(_target, (r.width - gripWidth) / 2);
    return Positioned.fromRect(
      rect: r,
      child: Stack(
        children: [
          Positioned.fill(child: widget.child),
          if (moving)
            Positioned.fill(
              child: IgnorePointer(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white70, width: 2),
                  ),
                ),
              ),
            ),
          // Move grip.
          Positioned(
            top: 0,
            left: gripLeft,
            width: gripWidth,
            height: _target,
            child: Tooltip(
              message: widget.moveTooltip ?? '',
              child: GestureDetector(
                key: const ValueKey('prompter-move'),
                behavior: HitTestBehavior.opaque,
                onPanUpdate: _move,
                onPanEnd: _commit,
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    width: 40,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.white70,
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),
                ),
              ),
            ),
          ),
          // Resize handle.
          Positioned(
            right: 0,
            bottom: 0,
            child: Tooltip(
              message: widget.resizeTooltip ?? '',
              child: GestureDetector(
                key: const ValueKey('prompter-resize'),
                behavior: HitTestBehavior.opaque,
                onPanUpdate: _resize,
                onPanEnd: _commit,
                child: const SizedBox(
                  width: _target,
                  height: _target,
                  child: Align(
                    alignment: Alignment.bottomRight,
                    child: Padding(
                      padding: EdgeInsets.all(4),
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: Icon(
                          Icons.open_in_full,
                          size: 18,
                          color: Colors.white70,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
