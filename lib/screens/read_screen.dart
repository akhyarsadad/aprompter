import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../models/script.dart';
import '../services/app_state.dart';
import '../widgets/prompter_controls.dart';
import '../widgets/prompter_view.dart';
import '../widgets/settings_sheet.dart';

/// Full-screen prompter without camera — for reading on a second device or
/// behind teleprompter glass (enable "Mirror text").
class ReadScreen extends StatefulWidget {
  const ReadScreen({super.key, required this.script});

  final Script script;

  @override
  State<ReadScreen> createState() => _ReadScreenState();
}

class _ReadScreenState extends State<ReadScreen> {
  late final _prompter = PrompterController(
    speed: AppScope.read(context).settings.speed,
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

  void _onTap() {
    final seconds = AppScope.read(context).settings.countdownSeconds;
    if (_prompter.playing) {
      _prompter.pause();
    } else if (seconds > 0 && !_counting) {
      setState(() => _counting = true);
    } else if (!_counting) {
      _prompter.play();
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
                onTap: _onTap,
              ),
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
                      onSpeedChanged: (v) =>
                          state.updateSettings(settings.copyWith(speed: v)),
                    ),
                  ),
                  IconButton(
                    tooltip: 'Settings',
                    color: Colors.white,
                    onPressed: () => showSettingsSheet(
                      context,
                      settings: settings,
                      onChanged: (s) {
                        state.updateSettings(s);
                        _prompter.speed = s.speed;
                      },
                    ),
                    icon: const Icon(Icons.tune),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
