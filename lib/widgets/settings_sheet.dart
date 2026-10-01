import 'package:flutter/material.dart';

import '../l10n/l10n.dart';
import '../models/prompter_settings.dart';
import '../models/script.dart';
import '../models/script_markup.dart';
import 'prompter_view.dart';

/// Bottom sheet for tuning the prompter: setups, pace, text, layout and
/// recording, with a live preview (journey J4).
///
/// Pass [script] to enable "fit to target length".
Future<void> showSettingsSheet(
  BuildContext context, {
  required PrompterSettings settings,
  required ValueChanged<PrompterSettings> onChanged,
  Script? script,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (context) =>
        _SettingsSheet(initial: settings, onChanged: onChanged, script: script),
  );
}

String presetName(AppLocalizations l, SetupPreset p) => switch (p) {
  SetupPreset.handheld => l.presetHandheld,
  SetupPreset.tripod => l.presetTripod,
  SetupPreset.glass => l.presetGlass,
};

String presetHint(AppLocalizations l, SetupPreset p) => switch (p) {
  SetupPreset.handheld => l.presetHandheldHint,
  SetupPreset.tripod => l.presetTripodHint,
  SetupPreset.glass => l.presetGlassHint,
};

String paceName(AppLocalizations l, PacePreset p) => switch (p) {
  PacePreset.calm => l.paceCalm,
  PacePreset.natural => l.paceNatural,
  PacePreset.energetic => l.paceEnergetic,
};

class _SettingsSheet extends StatefulWidget {
  const _SettingsSheet({
    required this.initial,
    required this.onChanged,
    this.script,
  });

  final PrompterSettings initial;
  final ValueChanged<PrompterSettings> onChanged;
  final Script? script;

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
    final l = context.l10n;
    final theme = Theme.of(context);
    final script = widget.script;
    final target = script?.targetSeconds;
    final words = script?.wordCount ?? 0;
    final fitWpm = target != null && target > 0 && words > 0
        ? PrompterSettings.clampWpm(
            (words / target * 60 / PrompterSettings.wpmStep).round() *
                PrompterSettings.wpmStep,
          )
        : null;
    final previewBlocks = parseScript(
      '# ${l.secHook}\n${l.welcomeBody.split('\n')[1]}\n// ${l.noteHook}',
    );

    return SafeArea(
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.sizeOf(context).height * 0.85,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Live preview.
            Container(
              height: 150,
              margin: const EdgeInsets.symmetric(horizontal: 16),
              clipBehavior: Clip.antiAlias,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: const LinearGradient(
                  colors: [Color(0xFF455A64), Color(0xFF263238)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned.fill(
                    child: ColoredBox(
                      color: Colors.black.withValues(
                        alpha: _s.backgroundOpacity,
                      ),
                    ),
                  ),
                  Positioned.fill(
                    child: SingleChildScrollView(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(12),
                      child: Transform.flip(
                        flipX: _s.mirror,
                        child: ScriptText(blocks: previewBlocks, settings: _s),
                      ),
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 6,
                    child: Text(
                      l.preview,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: Colors.white54,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: ListView(
                shrinkWrap: true,
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                children: [
                  _header(context, l.setup),
                  SizedBox(
                    height: 124,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      children: [
                        for (final p in SetupPreset.values)
                          _PresetCard(
                            icon: p.icon,
                            name: presetName(l, p),
                            description: presetHint(l, p),
                            onTap: () => _update(p.apply(_s)),
                          ),
                      ],
                    ),
                  ),
                  _header(context, l.pace),
                  Row(
                    children: [
                      Text(
                        '${_s.wpm.round()}',
                        style: theme.textTheme.headlineSmall,
                      ),
                      const SizedBox(width: 4),
                      Text(l.wordsPerMinute),
                      const Spacer(),
                      if (script != null)
                        Text(
                          '≈ ${formatDuration(script.durationAt(_s.wpm))}'
                          '${target != null ? ' / ${formatDuration(Duration(seconds: target))}' : ''}',
                          style: theme.textTheme.bodyMedium,
                        ),
                    ],
                  ),
                  Slider(
                    value: _s.wpm,
                    min: PrompterSettings.minWpm,
                    max: PrompterSettings.maxWpm,
                    divisions:
                        ((PrompterSettings.maxWpm - PrompterSettings.minWpm) /
                                PrompterSettings.wpmStep)
                            .round(),
                    label: '${_s.wpm.round()} ${l.wpmUnit}',
                    onChanged: (v) => _update(_s.copyWith(wpm: v)),
                  ),
                  Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: [
                      for (final p in PacePreset.values)
                        ChoiceChip(
                          label: Text('${paceName(l, p)} ${p.wpm.round()}'),
                          selected: _s.wpm == p.wpm,
                          onSelected: (_) => _update(_s.copyWith(wpm: p.wpm)),
                        ),
                      if (fitWpm != null)
                        ActionChip(
                          avatar: const Icon(Icons.timer_outlined, size: 18),
                          label: Text(
                            l.fitTo(formatDuration(Duration(seconds: target!))),
                          ),
                          onPressed: () => _update(_s.copyWith(wpm: fitWpm)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(child: Text(l.countdown)),
                      DropdownButton<int>(
                        value: _s.countdownSeconds,
                        items: [
                          for (final s in const [0, 3, 5, 10])
                            DropdownMenuItem(
                              value: s,
                              child: Text(s == 0 ? l.off : '${s}s'),
                            ),
                        ],
                        onChanged: (v) =>
                            _update(_s.copyWith(countdownSeconds: v)),
                      ),
                    ],
                  ),
                  _header(context, l.text),
                  _slider(
                    label: l.size,
                    value: _s.fontSize,
                    min: PrompterSettings.minFontSize,
                    max: PrompterSettings.maxFontSize,
                    display: _s.fontSize.round().toString(),
                    onChanged: (v) => _update(_s.copyWith(fontSize: v)),
                  ),
                  _slider(
                    label: l.lineSpacing,
                    value: _s.lineHeight,
                    min: 1.0,
                    max: 2.5,
                    display: _s.lineHeight.toStringAsFixed(1),
                    onChanged: (v) => _update(_s.copyWith(lineHeight: v)),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 10,
                          runSpacing: 8,
                          children: [
                            for (final c in PrompterSettings.textColors)
                              Semantics(
                                button: true,
                                selected: _s.textColor == c,
                                label: l.textColor,
                                child: GestureDetector(
                                  onTap: () =>
                                      _update(_s.copyWith(textColor: c)),
                                  child: CircleAvatar(
                                    radius: 16,
                                    backgroundColor: theme.colorScheme.outline,
                                    child: CircleAvatar(
                                      radius: _s.textColor == c ? 11 : 14,
                                      backgroundColor: Color(c),
                                    ),
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      SegmentedButton<TextAlign>(
                        showSelectedIcon: false,
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
                    ],
                  ),
                  _header(context, l.layout),
                  _slider(
                    label: l.prompterHeight,
                    value: _s.overlayHeightFraction,
                    min: 0.15,
                    max: 1,
                    display: '${(_s.overlayHeightFraction * 100).round()}%',
                    onChanged: (v) =>
                        _update(_s.copyWith(overlayHeightFraction: v)),
                  ),
                  _slider(
                    label: l.background,
                    value: _s.backgroundOpacity,
                    min: 0,
                    max: 1,
                    display: '${(_s.backgroundOpacity * 100).round()}%',
                    onChanged: (v) =>
                        _update(_s.copyWith(backgroundOpacity: v)),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.readingGuide),
                    value: _s.showGuide,
                    onChanged: (v) => _update(_s.copyWith(showGuide: v)),
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.mirrorText),
                    subtitle: Text(l.mirrorTextHint),
                    value: _s.mirror,
                    onChanged: (v) => _update(_s.copyWith(mirror: v)),
                  ),
                  _header(context, l.recording),
                  Row(
                    children: [
                      Expanded(child: Text(l.videoQuality)),
                      SegmentedButton<VideoQuality>(
                        showSelectedIcon: false,
                        segments: [
                          for (final q in VideoQuality.values)
                            ButtonSegment(value: q, label: Text(q.label)),
                        ],
                        selected: {_s.videoQuality},
                        onSelectionChanged: (v) =>
                            _update(_s.copyWith(videoQuality: v.first)),
                      ),
                    ],
                  ),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(l.autoStop),
                    subtitle: Text(l.autoStopHint),
                    value: _s.autoStopRecording,
                    onChanged: (v) =>
                        _update(_s.copyWith(autoStopRecording: v)),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _header(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.only(top: 16, bottom: 8),
    child: Text(
      text.toUpperCase(),
      style: Theme.of(context).textTheme.labelMedium?.copyWith(
        color: Theme.of(context).colorScheme.primary,
        letterSpacing: 1.2,
      ),
    ),
  );

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

class _PresetCard extends StatelessWidget {
  const _PresetCard({
    required this.icon,
    required this.name,
    required this.description,
    required this.onTap,
  });

  final IconData icon;
  final String name;
  final String description;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: SizedBox(
        width: 150,
        child: Card.outlined(
          margin: EdgeInsets.zero,
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(icon, size: 20, color: theme.colorScheme.primary),
                  const SizedBox(height: 4),
                  Text(name, style: theme.textTheme.labelLarge),
                  Text(
                    description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
