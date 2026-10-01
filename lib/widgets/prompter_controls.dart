import 'package:flutter/material.dart';

import 'prompter_view.dart';

/// Compact play / speed / restart controls for a [PrompterController].
class PrompterControls extends StatelessWidget {
  const PrompterControls({
    super.key,
    required this.controller,
    this.onSpeedChanged,
    this.dense = false,
  });

  final PrompterController controller;
  final ValueChanged<double>? onSpeedChanged;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final iconSize = dense ? 20.0 : 26.0;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _btn(Icons.replay, 'Restart', controller.restart, iconSize),
          _btn(Icons.remove, 'Slower', () {
            controller.slower();
            onSpeedChanged?.call(controller.speed);
          }, iconSize),
          Text(
            controller.speed.round().toString(),
            style: TextStyle(
              color: Colors.white,
              fontSize: dense ? 12 : 14,
              fontFeatures: const [FontFeature.tabularFigures()],
            ),
          ),
          _btn(Icons.add, 'Faster', () {
            controller.faster();
            onSpeedChanged?.call(controller.speed);
          }, iconSize),
          _btn(
            controller.playing ? Icons.pause : Icons.play_arrow,
            controller.playing ? 'Pause' : 'Play',
            controller.toggle,
            iconSize,
          ),
        ],
      ),
    );
  }

  Widget _btn(IconData icon, String tip, VoidCallback onTap, double size) =>
      IconButton(
        tooltip: tip,
        visualDensity: dense ? VisualDensity.compact : null,
        iconSize: size,
        color: Colors.white,
        onPressed: onTap,
        icon: Icon(icon),
      );
}
