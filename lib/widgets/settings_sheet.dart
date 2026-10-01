import 'package:flutter/material.dart';

import '../models/prompter_settings.dart';

/// Bottom sheet for tweaking prompter appearance and behaviour.
Future<void> showSettingsSheet(
  BuildContext context, {
  required PrompterSettings settings,
  required ValueChanged<PrompterSettings> onChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) =>
        _SettingsSheet(initial: settings, onChanged: onChanged),
  );
}

class _SettingsSheet extends StatefulWidget {
  const _SettingsSheet({required this.initial, required this.onChanged});

  final PrompterSettings initial;
  final ValueChanged<PrompterSettings> onChanged;

  @override
  State<_SettingsSheet> createState() => _SettingsSheetState();
}

class _SettingsSheetState extends State<_SettingsSheet> {
  late PrompterSettings _s = widget.initial;

  void _update(PrompterSettings s) {
    setState(() => _s = s);
    widget.onChanged(s);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.8,
        ),
        child: ListView(
          shrinkWrap: true,
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
          children: [
            Text(
              'Prompter settings',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            _slider(
              label: 'Text size',
              value: _s.fontSize,
              min: PrompterSettings.minFontSize,
              max: PrompterSettings.maxFontSize,
              display: _s.fontSize.round().toString(),
              onChanged: (v) => _update(_s.copyWith(fontSize: v)),
            ),
            _slider(
              label: 'Scroll speed',
              value: _s.speed,
              min: PrompterSettings.minSpeed,
              max: PrompterSettings.maxSpeed,
              display: _s.speed.round().toString(),
              onChanged: (v) => _update(_s.copyWith(speed: v)),
            ),
            _slider(
              label: 'Line spacing',
              value: _s.lineHeight,
              min: 1.0,
              max: 2.5,
              display: _s.lineHeight.toStringAsFixed(1),
              onChanged: (v) => _update(_s.copyWith(lineHeight: v)),
            ),
            _slider(
              label: 'Background',
              value: _s.backgroundOpacity,
              min: 0,
              max: 1,
              display: '${(_s.backgroundOpacity * 100).round()}%',
              onChanged: (v) => _update(_s.copyWith(backgroundOpacity: v)),
            ),
            _slider(
              label: 'Prompter height',
              value: _s.overlayHeightFraction,
              min: 0.15,
              max: 1,
              display: '${(_s.overlayHeightFraction * 100).round()}%',
              onChanged: (v) => _update(_s.copyWith(overlayHeightFraction: v)),
            ),
            const SizedBox(height: 8),
            const Text('Text color'),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              children: [
                for (final c in PrompterSettings.textColors)
                  GestureDetector(
                    onTap: () => _update(_s.copyWith(textColor: c)),
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor: Colors.grey,
                      child: CircleAvatar(
                        radius: _s.textColor == c ? 13 : 16,
                        backgroundColor: Color(c),
                      ),
                    ),
                  ),
              ],
            ),
            const SizedBox(height: 16),
            SegmentedButton<TextAlign>(
              segments: const [
                ButtonSegment(
                  value: TextAlign.left,
                  icon: Icon(Icons.format_align_left),
                ),
                ButtonSegment(
                  value: TextAlign.center,
                  icon: Icon(Icons.format_align_center),
                ),
              ],
              selected: {_s.textAlign},
              onSelectionChanged: (v) =>
                  _update(_s.copyWith(textAlign: v.first)),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                const Expanded(child: Text('Countdown')),
                DropdownButton<int>(
                  value: _s.countdownSeconds,
                  items: const [0, 3, 5, 10]
                      .map(
                        (s) => DropdownMenuItem(
                          value: s,
                          child: Text(s == 0 ? 'Off' : '${s}s'),
                        ),
                      )
                      .toList(),
                  onChanged: (v) => _update(_s.copyWith(countdownSeconds: v)),
                ),
              ],
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Mirror text'),
              subtitle: const Text('For teleprompter glass / beam splitter'),
              value: _s.mirror,
              onChanged: (v) => _update(_s.copyWith(mirror: v)),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Reading guide line'),
              value: _s.showGuide,
              onChanged: (v) => _update(_s.copyWith(showGuide: v)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slider({
    required String label,
    required double value,
    required double min,
    required double max,
    required String display,
    required ValueChanged<double> onChanged,
  }) {
    return Row(
      children: [
        SizedBox(width: 110, child: Text(label)),
        Expanded(
          child: Slider(
            value: value.clamp(min, max),
            min: min,
            max: max,
            onChanged: onChanged,
          ),
        ),
        SizedBox(width: 44, child: Text(display, textAlign: TextAlign.end)),
      ],
    );
  }
}
