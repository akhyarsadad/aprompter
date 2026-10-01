import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../models/script.dart';
import '../services/app_state.dart';
import '../widgets/prompter_controls.dart';
import '../widgets/prompter_view.dart';
import '../widgets/settings_sheet.dart';

/// Records video with the camera while the script scrolls on top of the
/// preview, right below the front camera lens. Works on Android and iOS.
class CameraPrompterScreen extends StatefulWidget {
  const CameraPrompterScreen({super.key, required this.script});

  final Script script;

  @override
  State<CameraPrompterScreen> createState() => _CameraPrompterScreenState();
}

class _CameraPrompterScreenState extends State<CameraPrompterScreen>
    with WidgetsBindingObserver {
  late final PrompterController _prompter;
  List<CameraDescription> _cameras = [];
  CameraController? _camera;
  int _cameraIndex = 0;
  String? _error;
  bool _recording = false;
  bool _counting = false;
  bool _saving = false;
  Duration _elapsed = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _prompter = PrompterController(wpm: AppScope.read(context).settings.wpm);
    WidgetsBinding.instance.addObserver(this);
    WakelockPlus.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    _initCameras();
  }

  Future<void> _initCameras() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        setState(() => _error = 'No camera found on this device.');
        return;
      }
      final front = _cameras.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );
      _cameraIndex = front >= 0 ? front : 0;
      await _openCamera();
    } on CameraException catch (e) {
      setState(() => _error = _describe(e));
    }
  }

  Future<void> _openCamera() async {
    final old = _camera;
    setState(() => _camera = null);
    await old?.dispose();
    final controller = CameraController(
      _cameras[_cameraIndex],
      ResolutionPreset.high,
      enableAudio: true,
    );
    try {
      await controller.initialize();
      await controller.prepareForVideoRecording();
      if (!mounted) {
        await controller.dispose();
        return;
      }
      setState(() {
        _camera = controller;
        _error = null;
      });
    } on CameraException catch (e) {
      await controller.dispose();
      if (mounted) setState(() => _error = _describe(e));
    }
  }

  String _describe(CameraException e) => switch (e.code) {
    'CameraAccessDenied' ||
    'CameraAccessDeniedWithoutPrompt' ||
    'CameraAccessRestricted' =>
      'Camera access was denied. Enable it in system settings.',
    'AudioAccessDenied' ||
    'AudioAccessDeniedWithoutPrompt' ||
    'AudioAccessRestricted' =>
      'Microphone access was denied. Enable it in system settings.',
    _ => 'Camera error: ${e.description ?? e.code}',
  };

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final camera = _camera;
    if (camera == null || !camera.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      _releaseCamera(camera);
    } else if (state == AppLifecycleState.resumed) {
      _openCamera();
    }
  }

  Future<void> _releaseCamera(CameraController camera) async {
    _prompter.pause();
    if (_recording) await _stopRecording();
    if (!mounted) return;
    setState(() => _camera = null);
    await camera.dispose();
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2 || _recording) return;
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _openCamera();
  }

  void _onRecordPressed() {
    if (_recording) {
      _stopRecording();
    } else if (!_counting) {
      final seconds = AppScope.read(context).settings.countdownSeconds;
      if (seconds > 0) {
        setState(() => _counting = true);
      } else {
        _startRecording();
      }
    }
  }

  Future<void> _startRecording() async {
    final camera = _camera;
    setState(() => _counting = false);
    if (camera == null || !camera.value.isInitialized) return;
    try {
      await camera.startVideoRecording();
      _elapsed = Duration.zero;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _elapsed += const Duration(seconds: 1));
      });
      setState(() => _recording = true);
      // Keep the position so a retake can start from a chosen section.
      _prompter.play();
    } on CameraException catch (e) {
      _toast(_describe(e));
    }
  }

  Future<void> _stopRecording() async {
    final camera = _camera;
    _timer?.cancel();
    _prompter.pause();
    setState(() {
      _recording = false;
      _saving = true;
    });
    try {
      if (camera == null || !camera.value.isRecordingVideo) return;
      final file = await camera.stopVideoRecording();
      if (!await Gal.hasAccess()) await Gal.requestAccess();
      await Gal.putVideo(file.path, album: 'APrompter');
      if (mounted) await AppScope.read(context).recordTake(widget.script.id);
      _toast('Take saved to your gallery');
    } on GalException catch (e) {
      _toast('Could not save video: ${e.type.message}');
    } on CameraException catch (e) {
      _toast(_describe(e));
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  void _toast(String msg) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(msg)));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _camera?.dispose();
    _prompter.dispose();
    WakelockPlus.disable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final settings = state.settings;
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final camera = _camera;

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: camera != null && camera.value.isInitialized
                ? _CameraPreviewCover(controller: camera)
                : Center(
                    child: _error != null
                        ? Padding(
                            padding: const EdgeInsets.all(24),
                            child: Text(
                              _error!,
                              textAlign: TextAlign.center,
                              style: const TextStyle(color: Colors.white),
                            ),
                          )
                        : const CircularProgressIndicator(),
                  ),
          ),
          // Prompter sits at the top, close to the front camera lens, so the
          // eyes stay near the lens while reading.
          Positioned(
            top: padding.top,
            left: 0,
            right: 0,
            height: size.height * settings.overlayHeightFraction,
            child: Stack(
              children: [
                Positioned.fill(
                  child: PrompterView(
                    text: widget.script.body,
                    settings: settings,
                    controller: _prompter,
                  ),
                ),
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: PrompterProgressBar(controller: _prompter),
                ),
              ],
            ),
          ),
          if (_counting)
            Countdown(
              seconds: settings.countdownSeconds,
              onDone: _startRecording,
            ),
          if (_recording)
            Positioned(
              top:
                  padding.top +
                  size.height * settings.overlayHeightFraction +
                  8,
              left: 0,
              right: 0,
              child: Center(child: _RecordingBadge(elapsed: _elapsed)),
            ),
          Positioned(
            left: 0,
            right: 0,
            bottom: padding.bottom + 16,
            child: Column(
              children: [
                DecoratedBox(
                  decoration: BoxDecoration(
                    color: Colors.black45,
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: PrompterControls(
                      controller: _prompter,
                      wordCount: widget.script.wordCount,
                      onSections: _recording
                          ? null
                          : () => showSectionsSheet(
                              context,
                              sections: widget.script.sections,
                              controller: _prompter,
                            ),
                      onWpmChanged: (v) =>
                          state.updateSettings(settings.copyWith(wpm: v)),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    _RoundButton(
                      icon: Icons.close,
                      tooltip: 'Close',
                      onPressed: _recording
                          ? null
                          : () => Navigator.pop(context),
                    ),
                    _RecordButton(
                      recording: _recording,
                      busy: _saving || camera == null,
                      onPressed: _onRecordPressed,
                    ),
                    _RoundButton(
                      icon: Icons.tune,
                      tooltip: 'Settings',
                      onPressed: _recording
                          ? null
                          : () => showSettingsSheet(
                              context,
                              settings: settings,
                              script: widget.script,
                              onChanged: (s) {
                                state.updateSettings(s);
                                _prompter.wpm = s.wpm;
                              },
                            ),
                    ),
                    _RoundButton(
                      icon: Icons.cameraswitch,
                      tooltip: 'Switch camera',
                      onPressed: _cameras.length > 1 && !_recording
                          ? _switchCamera
                          : null,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Fills the screen with the camera preview, cropping instead of letterboxing.
class _CameraPreviewCover extends StatelessWidget {
  const _CameraPreviewCover({required this.controller});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    // previewSize is reported in landscape orientation.
    final preview = controller.value.previewSize;
    if (preview == null) return CameraPreview(controller);
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.cover,
        child: SizedBox(
          width: preview.height,
          height: preview.width,
          child: CameraPreview(controller),
        ),
      ),
    );
  }
}

class _RecordingBadge extends StatelessWidget {
  const _RecordingBadge({required this.elapsed});

  final Duration elapsed;

  @override
  Widget build(BuildContext context) {
    final m = elapsed.inMinutes.toString().padLeft(2, '0');
    final s = (elapsed.inSeconds % 60).toString().padLeft(2, '0');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        'REC $m:$s',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _RecordButton extends StatelessWidget {
  const _RecordButton({
    required this.recording,
    required this.busy,
    required this.onPressed,
  });

  final bool recording;
  final bool busy;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: recording ? 'Stop recording' : 'Start recording',
      child: GestureDetector(
        onTap: busy ? null : onPressed,
        child: Container(
          width: 76,
          height: 76,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 4),
          ),
          alignment: Alignment.center,
          child: busy
              ? const CircularProgressIndicator(color: Colors.white)
              : AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: recording ? 30 : 60,
                  height: recording ? 30 : 60,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    borderRadius: BorderRadius.circular(recording ? 6 : 30),
                  ),
                ),
        ),
      ),
    );
  }
}

class _RoundButton extends StatelessWidget {
  const _RoundButton({
    required this.icon,
    required this.tooltip,
    required this.onPressed,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    return IconButton.filled(
      tooltip: tooltip,
      style: IconButton.styleFrom(
        backgroundColor: Colors.black54,
        foregroundColor: Colors.white,
        disabledBackgroundColor: Colors.black26,
      ),
      onPressed: onPressed,
      icon: Icon(icon),
    );
  }
}
