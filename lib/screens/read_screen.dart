import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../l10n/l10n.dart';
import '../models/prompter_settings.dart';
import '../models/script.dart';
import '../models/script_markup.dart';
import '../services/app_state.dart';
import '../services/orientation.dart';
import '../services/system_settings.dart';
import '../widgets/prompter_controls.dart';
import '../widgets/prompter_view.dart';
import '../widgets/settings_sheet.dart';

/// Rehearse mode (journey J3): full-screen prompter without camera. Also
/// works behind teleprompter glass with "Mirror text".
class ReadScreen extends StatefulWidget {
  const ReadScreen({super.key, required this.script});

  final Script script;

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  late final _prompter = PrompterController(
    wpm: AppScope.read(context).settings.wpm,
  );
  bool _counting = false;

  @override
  void initState() {
    super.initState();
    WakelockPlus.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Orientations.prompting();
    if (AppScope.read(context).settings.brightScreen) setBrightScreen(true);
  }

  @override
  void dispose() {
    _prompter.dispose();
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    Orientations.app();
    setBrightScreen(false);
    super.dispose();
  }

  void _start() {
    final seconds = AppScope.read(context).settings.countdownSeconds;
    if (_prompter.playing) {
      _prompter.pause();
    } else if (_counting) {
      return;
    } else if (seconds > 0) {
      setState(() => _counting = true);
    } else {
      _prompter.play();
    }
  }

  /// Shows how the run went. [partial] is for a run stopped before the
  /// end (T8): only the part read so far counts.
  Future<void> _onFinished({bool partial = false}) async {
    final state = AppScope.read(context);
    final time = _prompter.readTime;
    final fraction = partial ? _prompter.progress.value : 1.0;
    final words = (widget.script.wordCount * fraction).round();
    if (time.inSeconds < 5 || words == 0) return;
    _summaryShown = true;
    // T9: a run with drags or section jumps says nothing about pace.
    final reliable = !_prompter.jumpedDuringRun;
    // Pauses are part of the run but not of the speaking pace.
    final speaking =
        time.inMilliseconds / 1000 -
        widget.script.pauses * fraction * pauseSeconds;
    final actualWpm = words / (speaking < 1 ? 1 : speaking) * 60;
    final suggested = PrompterSettings.clampWpm(
      (actualWpm / PrompterSettings.wpmStep).round() * PrompterSettings.wpmStep,
    );
    final target = widget.script.targetSeconds;

    final usePace = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);
        final l = context.l10n;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(l.niceRun, style: theme.textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text(
                  l.runSummary(formatDuration(time), words, actualWpm.round()),
                  style: theme.textTheme.bodyLarge,
                ),
                if (target != null && !partial) ...[
                  const SizedBox(height: 8),
                  Text(
                    time.inSeconds > target * 1.1
                        ? l.runOver(
                            time.inSeconds - target,
                            formatDuration(Duration(seconds: target)),
                          )
                        : time.inSeconds < target * 0.9
                        ? l.runUnder(target - time.inSeconds)
                        : l.runOnTarget,
                  ),
                ],
                if (!reliable) ...[
                  const SizedBox(height: 8),
                  Text(l.runHadJumps),
                ],
                const SizedBox(height: 20),
                if (reliable)
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: Text(l.keepCurrent),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: Text(l.useWpm(suggested.round())),
                        ),
                      ),
                    ],
                  )
                else
                  FilledButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text(l.close),
                  ),
              ],
            ),
          ),
        );
      },
    );
    if (usePace == true) {
      await state.updateSettings(state.settings.copyWith(wpm: suggested));
      _prompter.wpm = suggested;
    }
    _prompter.focus();
  }

  bool _summaryShown = false;

  /// Leaving mid-run still shows how it went (T8), once.
  Future<void> _close() async {
    if (!_summaryShown &&
        _prompter.readTime.inSeconds >= 10 &&
        _prompter.progress.value > 0.15 &&
        _prompter.progress.value < 0.99) {
      _prompter.pause();
      await _onFinished(partial: true);
    }
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final settings = state.settings;
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: PrompterView(
                text: widget.script.body,
                settings: settings,
                controller: _prompter,
                onTap: _start,
                onFinished: _onFinished,
                onFontSizeChanged: (v) =>
                    state.updateSettings(settings.copyWith(fontSize: v)),
                onWpmChanged: (v) =>
                    state.updateSettings(settings.copyWith(wpm: v)),
              ),
            ),
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: PrompterProgressBar(controller: _prompter),
            ),
            if (_counting)
              Countdown(
                seconds: settings.countdownSeconds,
                onDone: () {
                  setState(() => _counting = false);
                  _prompter.play();
                },
              ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 8,
              // R9: behind teleprompter glass the controls are mirrored and
              // out of reach; hide them while reading (tap or remote to stop).
              child: ListenableBuilder(
                listenable: _prompter,
                builder: (context, child) => IgnorePointer(
                  ignoring: settings.mirror && _prompter.playing,
                  child: AnimatedOpacity(
                    opacity: settings.mirror && _prompter.playing ? 0 : 1,
                    duration: const Duration(milliseconds: 200),
                    child: child,
                  ),
                ),
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        tooltip: context.l10n.close,
                        color: Colors.white,
                        onPressed: _close,
                        icon: const Icon(Icons.close),
                      ),
                      DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        child: PrompterControls(
                          controller: _prompter,
                          wordCount: widget.script.wordCount,
                          pauses: widget.script.pauses,
                          onPlay: _start,
                          onSections: () => showSectionsSheet(
                            context,
                            sections: widget.script.sections,
                            controller: _prompter,
                          ).then((_) => _prompter.focus()),
                          onWpmChanged: (v) =>
                              state.updateSettings(settings.copyWith(wpm: v)),
                        ),
                      ),
                      IconButton(
                        tooltip: context.l10n.settings,
                        color: Colors.white,
                        onPressed: () {
                          _prompter.pause();
                          showSettingsSheet(
                            context,
                            settings: settings,
                            script: widget.script,
                            onChanged: (s) {
                              state.updateSettings(s);
                              _prompter.wpm = s.wpm;
                              setBrightScreen(s.brightScreen);
                            },
                          ).then((_) => _prompter.focus());
                        },
                        icon: const Icon(Icons.tune),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
