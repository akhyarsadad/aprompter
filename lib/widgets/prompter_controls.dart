import 'package:flutter/material.dart';

import '../models/script.dart';
import 'prompter_view.dart';

/// Play / pace / restart controls plus time remaining for a
/// [PrompterController].
class PrompterControls extends StatelessWidget {
  const PrompterControls({
    super.key,
    required this.controller,
    required this.wordCount,
    this.onWpmChanged,
    this.onPlay,
    this.onSections,
    this.dense = false,
  });

  final PrompterController controller;

  /// Spoken words in the script, used for the time-remaining readout.
  final int wordCount;
  final ValueChanged<double>? onWpmChanged;

  /// Overrides the play button (e.g. to run a countdown first).
  final VoidCallback? onPlay;

  /// Shows the section picker; hidden when null.
  final VoidCallback? onSections;
  final bool dense;

  @override
  Widget build(BuildContext context) {
    final iconSize = dense ? 20.0 : 26.0;
    final small = TextStyle(
      color: Colors.white,
      fontSize: dense ? 11 : 13,
      fontFeatures: const [FontFeature.tabularFigures()],
    );
    return ListenableBuilder(
      listenable: Listenable.merge([controller, controller.progress]),
      builder: (context, _) {
        final total = wordCount / controller.wpm * 60;
        final left = Duration(
          seconds: (total * (1 - controller.progress.value)).round(),
        );
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _btn(Icons.replay, 'Restart', controller.restart, iconSize),
            if (onSections != null)
              _btn(Icons.list, 'Sections', onSections!, iconSize),
            _btn(Icons.remove, 'Slower', () {
              controller.slower();
              onWpmChanged?.call(controller.wpm);
            }, iconSize),
            Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '${controller.wpm.round()}',
                  style: small.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'wpm',
                  style: small.copyWith(fontSize: 9, color: Colors.white70),
                ),
              ],
            ),
            _btn(Icons.add, 'Faster', () {
              controller.faster();
              onWpmChanged?.call(controller.wpm);
            }, iconSize),
            _btn(
              controller.playing ? Icons.pause : Icons.play_arrow,
              controller.playing ? 'Pause' : 'Play',
              controller.playing
                  ? controller.pause
                  : (onPlay ?? controller.play),
              iconSize,
            ),
            Padding(
              padding: EdgeInsets.only(right: dense ? 4 : 12),
              child: Text('-${formatDuration(left)}', style: small),
            ),
          ],
        );
      },
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

/// Thin progress bar for the prompter.
class PrompterProgressBar extends StatelessWidget {
  const PrompterProgressBar({super.key, required this.controller});

  final PrompterController controller;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<double>(
      valueListenable: controller.progress,
      builder: (context, value, _) => LinearProgressIndicator(
        value: value,
        minHeight: 3,
        backgroundColor: Colors.white12,
        color: Colors.white70,
      ),
    );
  }
}

/// Bottom sheet listing the script's sections to jump to.
Future<void> showSectionsSheet(
  BuildContext context, {
  required List<String> sections,
  required PrompterController controller,
}) {
  controller.pause();
  return showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    builder: (context) => SafeArea(
      child: sections.isEmpty
          ? const Padding(
              padding: EdgeInsets.fromLTRB(24, 0, 24, 24),
              child: Text(
                'No sections yet. Add lines starting with "#" in the editor '
                '(e.g. "# Hook") to jump between parts and retake just one.',
              ),
            )
          : ListView(
              shrinkWrap: true,
              children: [
                ListTile(
                  leading: const Icon(Icons.vertical_align_top),
                  title: const Text('Start of script'),
                  onTap: () {
                    Navigator.pop(context);
                    controller.restart();
                  },
                ),
                for (final (i, title) in sections.indexed)
                  ListTile(
                    leading: CircleAvatar(radius: 14, child: Text('${i + 1}')),
                    title: Text(title.isEmpty ? 'Section ${i + 1}' : title),
                    onTap: () {
                      Navigator.pop(context);
                      controller.jumpToSection(i);
                    },
                  ),
              ],
            ),
    ),
  );
}
