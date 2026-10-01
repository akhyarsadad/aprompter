import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../models/prompter_settings.dart';
import '../models/script.dart';
import '../services/app_state.dart';
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
  }

  @override
  void dispose() {
    _prompter.dispose();
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
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

  Future<void> _onFinished() async {
    final state = AppScope.read(context);
    final time = _prompter.readTime;
    final words = widget.script.wordCount;
    if (time.inSeconds < 5 || words == 0) return;
    final actualWpm = words / time.inSeconds * 60;
    final suggested = PrompterSettings.clampWpm(
      (actualWpm / PrompterSettings.wpmStep).round() * PrompterSettings.wpmStep,
    );
    final target = widget.script.targetSeconds;

    final usePace = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) {
        final theme = Theme.of(context);
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Nice run!', style: theme.textTheme.headlineSmall),
                const SizedBox(height: 12),
                Text(
                  'You took ${formatDuration(time)} for $words words '
                  '→ ${actualWpm.round()} words per minute.',
                  style: theme.textTheme.bodyLarge,
                ),
                if (target != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    time.inSeconds > target * 1.1
                        ? 'That is ${time.inSeconds - target}s over your '
                              '${formatDuration(Duration(seconds: target))} '
                              'target — trim the script or speed up.'
                        : time.inSeconds < target * 0.9
                        ? 'You have ${target - time.inSeconds}s of room '
                              'before your target.'
                        : 'Right on your target length. 🎯',
                  ),
                ],
                const SizedBox(height: 20),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Keep current'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text('Use ${suggested.round()} wpm'),
                      ),
                    ),
                  ],
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
              child: FittedBox(
                fit: BoxFit.scaleDown,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      tooltip: 'Close',
                      color: Colors.white,
                      onPressed: () => Navigator.pop(context),
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
                        onPlay: _start,
                        onSections: () => showSectionsSheet(
                          context,
                          sections: widget.script.sections,
                          controller: _prompter,
                        ),
                        onWpmChanged: (v) =>
                            state.updateSettings(settings.copyWith(wpm: v)),
                      ),
                    ),
                    IconButton(
                      tooltip: 'Settings',
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
                          },
                        );
                      },
                      icon: const Icon(Icons.tune),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
