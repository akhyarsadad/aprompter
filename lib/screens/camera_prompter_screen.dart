import 'dart:async';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gal/gal.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:wakelock_plus/wakelock_plus.dart';

import '../l10n/l10n.dart';
import '../models/prompter_settings.dart';
import '../models/script.dart';
import '../services/app_state.dart';
import '../services/storage.dart';
import '../services/orientation.dart';
import '../services/system_settings.dart';
import '../widgets/movable_box.dart';
import '../widgets/prompter_controls.dart';
import '../widgets/prompter_view.dart';
import '../widgets/settings_sheet.dart';
import 'takes_screen.dart';

/// Records video with the camera while the script scrolls on top of the
/// preview, right below the front camera lens. Works on Android and iOS.
class CameraPrompterScreen extends StatefulWidget {
  const CameraPrompterScreen({super.key, required this.script});

  final Script script;

  @override
  State<CameraPrompterScreen> createState() => _CameraPrompterScreenState();
}

enum _CameraProblem { none, noCamera, permissionDenied, other }

class _CameraPrompterScreenState extends State<CameraPrompterScreen>
    with WidgetsBindingObserver {
  late final PrompterController _prompter;
  List<CameraDescription> _cameras = [];
  CameraController? _camera;
  int _cameraIndex = 0;
  _CameraProblem _problem = _CameraProblem.none;
  String? _error;

  /// False when the microphone is denied: we record video without sound.
  bool _withAudio = true;

  /// The camera was released because the app left the foreground.
  bool _released = false;
  bool _recording = false;
  bool _stopping = false;
  bool _counting = false;
  bool _saving = false;

  /// Where the take started, so a retake starts there again.
  double _startFraction = 0;
  Duration _elapsed = Duration.zero;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _prompter = PrompterController(wpm: AppScope.read(context).settings.wpm);
    WidgetsBinding.instance.addObserver(this);
    WakelockPlus.enable();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    Orientations.prompting();
    if (AppScope.read(context).settings.brightScreen) setBrightScreen(true);
    WidgetsBinding.instance.addPostFrameCallback((_) => _introThenInit());
  }

  /// O1: say why camera and microphone are needed before the phone asks,
  /// so the first answer isn't a reflex "Don't allow".
  Future<void> _introThenInit() async {
    if (!mounted) return;
    final storage = AppScope.read(context).storage;
    if (!storage.cameraIntroSeen) {
      final l = context.l10n;
      final go = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) => AlertDialog(
          icon: const Icon(Icons.videocam_outlined),
          title: Text(l.cameraIntroTitle),
          content: Text(l.cameraIntroBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(l.notNow),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(l.continueLabel),
            ),
          ],
        ),
      );
      if (!mounted) return;
      if (go != true) {
        Navigator.pop(context);
        return;
      }
      await storage.setCameraIntroSeen();
    }
    if (mounted) await _initCameras();
  }

  Future<void> _initCameras() async {
    setState(() {
      _problem = _CameraProblem.none;
      _error = null;
    });
    try {
      _cameras = await availableCameras();
      if (!mounted) return;
      if (_cameras.isEmpty) {
        setState(() {
          _problem = _CameraProblem.noCamera;
          _error = context.l10n.noCamera;
        });
        return;
      }
      final front = _cameras.indexWhere(
        (c) => c.lensDirection == CameraLensDirection.front,
      );
      _cameraIndex = front >= 0 ? front : 0;
      await _openCamera();
    } on CameraException catch (e) {
      _showProblem(e);
    }
  }

  Future<void> _openCamera() async {
    if (_cameras.isEmpty) return;
    final old = _camera;
    final quality = AppScope.read(context).settings.videoQuality;
    setState(() => _camera = null);
    await old?.dispose();
    final controller = CameraController(
      _cameras[_cameraIndex],
      switch (quality) {
        VideoQuality.hd => ResolutionPreset.high,
        VideoQuality.fullHd => ResolutionPreset.veryHigh,
        VideoQuality.uhd => ResolutionPreset.ultraHigh,
      },
      enableAudio: _withAudio,
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
        _problem = _CameraProblem.none;
        _error = null;
      });
    } on CameraException catch (e) {
      await controller.dispose();
      if (_withAudio && _isAudioDenied(e)) {
        // Camera is fine, microphone isn't: keep going without sound.
        _withAudio = false;
        return _openCamera();
      }
      _showProblem(e);
    }
  }

  static bool _isAudioDenied(CameraException e) => const {
    'AudioAccessDenied',
    'AudioAccessDeniedWithoutPrompt',
    'AudioAccessRestricted',
  }.contains(e.code);

  void _showProblem(CameraException e) {
    if (!mounted) return;
    final l = context.l10n;
    final denied = const {
      'CameraAccessDenied',
      'CameraAccessDeniedWithoutPrompt',
      'CameraAccessRestricted',
    }.contains(e.code);
    setState(() {
      _problem = denied
          ? _CameraProblem.permissionDenied
          : _CameraProblem.other;
      _error = denied ? l.cameraDenied : _friendlyError(e);
    });
  }

  /// C14: "camera in use" and similar errors in words people understand.
  String _friendlyError(CameraException e) {
    final l = context.l10n;
    final text = '${e.code} ${e.description ?? ''}'.toLowerCase();
    if (const [
      'in use',
      'busy',
      'max_cameras',
      'disconnected',
      'evicted',
    ].any(text.contains)) {
      return l.cameraBusy;
    }
    return l.cameraError(e.description ?? e.code);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.inactive) {
      final camera = _camera;
      if (camera != null && camera.value.isInitialized) _releaseCamera(camera);
    } else if (state == AppLifecycleState.resumed && _released) {
      _released = false;
      _openCamera();
    }
  }

  Future<void> _releaseCamera(CameraController camera) async {
    _released = true;
    _prompter.pause();
    if (_counting) setState(() => _counting = false);
    // Save what was recorded before the camera goes away.
    if (_recording) await _stopRecording();
    if (!mounted || _camera != camera) return;
    setState(() => _camera = null);
    await camera.dispose();
  }

  Future<void> _switchCamera() async {
    if (_cameras.length < 2 || _recording) return;
    _cameraIndex = (_cameraIndex + 1) % _cameras.length;
    await _openCamera();
  }

  /// C6 / C7 / C15: warn before a take that the phone may not finish —
  /// not enough free space for the expected length, or a low battery.
  Future<bool> _preflightOk() async {
    final l = context.l10n;
    final settings = AppScope.read(context).settings;
    final expected =
        (widget.script.targetSeconds ??
            widget.script.durationAt(settings.wpm).inSeconds) +
        30;
    final mbPerMinute = switch (settings.videoQuality) {
      VideoQuality.hd => 60,
      VideoQuality.fullHd => 130,
      VideoQuality.uhd => 375,
    };
    final warnings = <String>[];
    final free = await freeSpaceBytes();
    if (free != null) {
      final freeMinutes = free / (mbPerMinute * 1024 * 1024);
      if (freeMinutes * 60 < expected * 1.5 || free < 300 * 1024 * 1024) {
        warnings.add(l.lowStorageWarning(freeMinutes.floor()));
      }
    }
    final battery = await batteryStatus();
    if (battery != null && !battery.charging && battery.level <= 15) {
      warnings.add(l.lowBatteryWarning(battery.level));
    }
    if (warnings.isEmpty || !mounted) return true;
    final go = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        icon: const Icon(Icons.warning_amber),
        title: Text(l.beforeYouRecord),
        content: Text(warnings.join('\n\n')),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(l.recordAnyway),
          ),
        ],
      ),
    );
    return go == true;
  }

  bool _checking = false;

  Future<void> _onRecordPressed() async {
    if (_recording) {
      _stopRecording();
    } else if (_counting) {
      // Changed my mind: cancel the countdown.
      setState(() => _counting = false);
    } else {
      if (_checking) return;
      _checking = true;
      final ok = await _preflightOk();
      _checking = false;
      if (!ok || !mounted) return;
      final seconds = AppScope.read(context).settings.countdownSeconds;
      if (seconds > 0) {
        setState(() => _counting = true);
      } else {
        _startRecording();
      }
    }
  }

  Future<void> _startRecording() async {
    setState(() => _counting = false);
    // C1: the countdown can end while the camera is still opening or
    // switching. Wait a little for it instead of silently not recording.
    final deadline = DateTime.now().add(const Duration(seconds: 5));
    while (mounted &&
        _problem == _CameraProblem.none &&
        !(_camera?.value.isInitialized ?? false) &&
        DateTime.now().isBefore(deadline)) {
      await Future<void>.delayed(const Duration(milliseconds: 100));
    }
    if (!mounted) return;
    final camera = _camera;
    if (camera == null || !camera.value.isInitialized) {
      if (_problem == _CameraProblem.none) _toast(context.l10n.cameraNotReady);
      return;
    }
    try {
      _startFraction = _prompter.progress.value;
      await camera.startVideoRecording();
      _elapsed = Duration.zero;
      _timer = Timer.periodic(const Duration(seconds: 1), (_) {
        if (mounted) setState(() => _elapsed += const Duration(seconds: 1));
      });
      setState(() => _recording = true);
      // Keep the position so a retake can start from a chosen section.
      _prompter.play();
    } on CameraException catch (e) {
      if (mounted) _toast(_friendlyError(e));
    }
  }

  Future<void> _stopRecording() async {
    // Auto-stop, the stop button and leaving the screen can race.
    if (!_recording || _stopping) return;
    _stopping = true;
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
      await _decideTake(file, _elapsed.inSeconds);
    } on CameraException catch (e) {
      if (mounted) _toast(context.l10n.cameraError(e.description ?? e.code));
    } finally {
      _stopping = false;
      if (mounted) setState(() => _saving = false);
    }
  }

  /// C3: watch the take first (if enabled), then keep it in the gallery or
  /// inside the app (Y3), or throw it away and go again.
  Future<void> _decideTake(XFile file, int seconds) async {
    final settings = AppScope.read(context).settings;
    if (settings.reviewTakes && mounted) {
      final decision = await Navigator.push<TakeDecision>(
        context,
        MaterialPageRoute(builder: (_) => TakeReviewScreen(path: file.path)),
      );
      // Leaving the review with "back" keeps the take: never lose one by
      // accident.
      if (decision == TakeDecision.retake) {
        try {
          await File(file.path).delete();
        } catch (_) {
          // Temporary file; the system cleans it up anyway.
        }
        _prompter.seek(_startFraction);
        return;
      }
    }
    if (!mounted) return;
    if (settings.takesToGallery) {
      await _keepTake(file);
    } else {
      await _keepInApp(file, seconds);
    }
  }

  /// Y3: the take stays inside the app, out of Google Photos / iCloud.
  Future<void> _keepInApp(XFile file, int seconds) async {
    try {
      final dir = Directory(
        '${(await getApplicationDocumentsDirectory()).path}/takes',
      );
      await dir.create(recursive: true);
      final now = DateTime.now();
      final ext = file.path.contains('.') ? file.path.split('.').last : 'mp4';
      final path =
          '${dir.path}/${widget.script.id}-${now.millisecondsSinceEpoch}.$ext';
      await File(file.path).copy(path);
      try {
        await File(file.path).delete();
      } catch (_) {}
      if (!mounted) return;
      final state = AppScope.read(context);
      await state.addTake(
        Take(
          path: path,
          scriptId: widget.script.id,
          recordedAt: now,
          seconds: seconds,
        ),
      );
      await state.recordTake(widget.script.id);
      if (!mounted) return;
      final n = state.byId(widget.script.id)?.takes ?? 1;
      _toast(context.l10n.takeKeptInApp(n));
    } catch (_) {
      // Phone full or similar: fall back to the gallery / share rescue.
      if (mounted) await _keepTake(file);
    }
  }

  /// Saves the take to the gallery. If that fails the take is not thrown
  /// away: the creator can retry or share the file somewhere else.
  Future<void> _keepTake(XFile file) async {
    String? failure;
    while (mounted) {
      try {
        if (!await Gal.hasAccess(toAlbum: true)) {
          await Gal.requestAccess(toAlbum: true);
        }
        await Gal.putVideo(file.path, album: 'APrompter');
        await _countTake(saved: true);
        return;
      } on GalException catch (e) {
        failure = e.type.message;
      }
      if (!mounted) return;
      final choice = await _askRescue(failure);
      if (choice == _Rescue.retry) continue;
      if (choice == _Rescue.share && mounted) {
        final box = context.findRenderObject() as RenderBox?;
        final result = await SharePlus.instance.share(
          ShareParams(
            files: [file],
            sharePositionOrigin: box == null
                ? null
                : box.localToGlobal(Offset.zero) & box.size,
          ),
        );
        if (result.status == ShareResultStatus.success) {
          await _countTake(saved: false);
          return;
        }
        continue; // Share sheet dismissed: ask again rather than lose it.
      }
      return; // Discarded on purpose.
    }
  }

  Future<void> _countTake({required bool saved}) async {
    if (!mounted) return;
    final state = AppScope.read(context);
    await state.recordTake(widget.script.id);
    if (!mounted) return;
    final n = state.byId(widget.script.id)?.takes ?? 1;
    _toast(saved ? context.l10n.takeSaved(n) : context.l10n.takeShared(n));
  }

  Future<_Rescue?> _askRescue(String? reason) {
    final l = context.l10n;
    return showModalBottomSheet<_Rescue>(
      context: context,
      isDismissible: false,
      enableDrag: false,
      builder: (context) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l.saveFailedTitle,
                style: Theme.of(context).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Text(l.saveFailedBody(reason ?? '')),
              const SizedBox(height: 20),
              FilledButton.icon(
                onPressed: () => Navigator.pop(context, _Rescue.retry),
                icon: const Icon(Icons.refresh),
                label: Text(l.tryAgain),
              ),
              const SizedBox(height: 8),
              OutlinedButton.icon(
                onPressed: () => Navigator.pop(context, _Rescue.share),
                icon: const Icon(Icons.ios_share),
                label: Text(l.shareVideo),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, _Rescue.discard),
                child: Text(l.discardTake),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Auto-stop: give the creator a beat to finish the last line.
  Future<void> _onScriptFinished() async {
    final settings = AppScope.read(context).settings;
    if (!_recording || !settings.autoStopRecording) return;
    // C12: room to ad-lib after the last line.
    await Future<void>.delayed(Duration(seconds: settings.autoStopDelay));
    if (mounted && _recording && !_prompter.playing) await _stopRecording();
  }

  /// Back gesture / button while recording: save the take, then leave.
  Future<void> _onPopBlocked() async {
    if (_saving) return;
    if (_counting) setState(() => _counting = false);
    if (_recording) await _stopRecording();
    if (mounted) Navigator.pop(context);
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
    Orientations.app();
    setBrightScreen(false);
    super.dispose();
  }

  Widget _problemView(BuildContext context) {
    final l = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.no_photography_outlined,
            color: Colors.white70,
            size: 48,
          ),
          const SizedBox(height: 12),
          Text(
            _error ?? '',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            alignment: WrapAlignment.center,
            children: [
              if (_problem == _CameraProblem.permissionDenied)
                FilledButton.icon(
                  onPressed: openAppSettings,
                  icon: const Icon(Icons.settings),
                  label: Text(l.openSettings),
                ),
              if (_problem != _CameraProblem.noCamera)
                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    foregroundColor: Colors.white,
                  ),
                  onPressed: _initCameras,
                  icon: const Icon(Icons.refresh),
                  label: Text(l.tryAgain),
                ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppScope.of(context);
    final settings = state.settings;
    final size = MediaQuery.sizeOf(context);
    final padding = MediaQuery.paddingOf(context);
    final camera = _camera;

    return PopScope<Object?>(
      canPop: !_recording && !_saving && !_counting,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) _onPopBlocked();
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Stack(
          children: [
            Positioned.fill(
              child: camera != null && camera.value.isInitialized
                  ? _CameraControls(
                      controller: camera,
                      child: _CameraPreviewFrame(controller: camera),
                    )
                  : Center(
                      child: _error != null
                          ? _problemView(context)
                          : const CircularProgressIndicator(),
                    ),
            ),
            // Starts at the top, close to the front camera lens, so the eyes
            // stay near the lens; the creator can drag and resize it.
            MovablePrompterBox(
              area: Rect.fromLTWH(
                0,
                padding.top,
                size.width,
                size.height - padding.top - padding.bottom,
              ),
              settings: settings,
              onChanged: state.updateSettings,
              moveTooltip: context.l10n.movePrompter,
              resizeTooltip: context.l10n.resizePrompter,
              child: Stack(
                children: [
                  Positioned.fill(
                    child: PrompterView(
                      text: widget.script.body,
                      settings: settings,
                      controller: _prompter,
                      onFinished: _onScriptFinished,
                      // R12: no accidental pinch-resize during a take.
                      onFontSizeChanged: _recording
                          ? null
                          : (v) => state.updateSettings(
                              settings.copyWith(fontSize: v),
                            ),
                      onWpmChanged: (v) =>
                          state.updateSettings(settings.copyWith(wpm: v)),
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
            Positioned(
              top: padding.top + 28,
              right: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  if (_recording) _RecordingBadge(elapsed: _elapsed),
                  if (!_withAudio)
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: Chip(
                        avatar: const Icon(Icons.mic_off, size: 18),
                        label: Text(context.l10n.noMicBanner),
                      ),
                    ),
                ],
              ),
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
                        pauses: widget.script.pauses,
                        // C13: jumping during a take is allowed; the take
                        // keeps recording while the list is open.
                        onSections: () => showSectionsSheet(
                          context,
                          sections: widget.script.sections,
                          controller: _prompter,
                          keepPlaying: _recording,
                        ).then((_) => _prompter.focus()),
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
                        tooltip: context.l10n.close,
                        onPressed: _recording || _saving
                            ? null
                            : () => Navigator.maybePop(context),
                      ),
                      _RecordButton(
                        recording: _recording,
                        busy: _saving || (camera == null && _error == null),
                        enabled: camera != null,
                        onPressed: _onRecordPressed,
                      ),
                      _RoundButton(
                        icon: Icons.tune,
                        tooltip: context.l10n.settings,
                        onPressed: _recording
                            ? null
                            : () => showSettingsSheet(
                                context,
                                settings: settings,
                                script: widget.script,
                                onChanged: (s) async {
                                  final qualityChanged =
                                      s.videoQuality !=
                                      state.settings.videoQuality;
                                  await state.updateSettings(s);
                                  _prompter.wpm = s.wpm;
                                  setBrightScreen(s.brightScreen);
                                  if (qualityChanged) await _openCamera();
                                },
                              ).then((_) => _prompter.focus()),
                      ),
                      _RoundButton(
                        icon: Icons.cameraswitch,
                        tooltip: context.l10n.switchCamera,
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
      ),
    );
  }
}

enum _Rescue { retry, share, discard }

/// C10: tap to focus and expose on that spot, long-press to lock them
/// (stops exposure hunting mid-take), pinch to zoom.
class _CameraControls extends StatefulWidget {
  const _CameraControls({required this.controller, required this.child});

  final CameraController controller;
  final Widget child;

  @override
  State<_CameraControls> createState() => _CameraControlsState();
}

class _CameraControlsState extends State<_CameraControls> {
  double _minZoom = 1;
  double _maxZoom = 1;
  double _zoom = 1;
  double _zoomAtStart = 1;
  Offset? _focus;
  bool _locked = false;

  @override
  void initState() {
    super.initState();
    _readZoomRange();
  }

  @override
  void didUpdateWidget(_CameraControls old) {
    super.didUpdateWidget(old);
    if (old.controller != widget.controller) {
      _zoom = 1;
      _locked = false;
      _focus = null;
      _readZoomRange();
    }
  }

  Future<void> _readZoomRange() async {
    try {
      final min = await widget.controller.getMinZoomLevel();
      final max = await widget.controller.getMaxZoomLevel();
      if (mounted) {
        setState(() {
          _minZoom = min;
          _maxZoom = max.clamp(min, 8.0);
        });
      }
    } on CameraException {
      // Zoom isn't supported; pinch does nothing.
    }
  }

  Future<void> _focusAt(Offset local, Size size, {bool lock = false}) async {
    final point = Offset(
      (local.dx / size.width).clamp(0.0, 1.0),
      (local.dy / size.height).clamp(0.0, 1.0),
    );
    setState(() {
      _focus = local;
      _locked = lock;
    });
    final c = widget.controller;
    try {
      if (c.value.exposurePointSupported) await c.setExposurePoint(point);
      if (c.value.focusPointSupported) await c.setFocusPoint(point);
      await c.setExposureMode(lock ? ExposureMode.locked : ExposureMode.auto);
      await c.setFocusMode(lock ? FocusMode.locked : FocusMode.auto);
    } on CameraException {
      // Not every camera supports every control.
    }
    if (!lock) {
      await Future<void>.delayed(const Duration(seconds: 1));
      if (mounted && !_locked) setState(() => _focus = null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapUp: (d) => _focusAt(d.localPosition, size),
          onLongPressStart: (d) => _focusAt(d.localPosition, size, lock: true),
          onScaleStart: (_) => _zoomAtStart = _zoom,
          onScaleUpdate: (d) {
            if (d.pointerCount < 2 || _maxZoom <= _minZoom) return;
            final z = (_zoomAtStart * d.scale).clamp(_minZoom, _maxZoom);
            if ((z - _zoom).abs() < 0.01) return;
            setState(() => _zoom = z);
            widget.controller.setZoomLevel(z).ignore();
          },
          child: Stack(
            children: [
              Positioned.fill(child: widget.child),
              if (_focus case final f?)
                Positioned(
                  left: f.dx - 32,
                  top: f.dy - 32,
                  child: IgnorePointer(
                    child: Container(
                      width: 64,
                      height: 64,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: _locked ? Colors.amber : Colors.white,
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      alignment: Alignment.bottomCenter,
                      child: _locked
                          ? const Icon(
                              Icons.lock,
                              size: 14,
                              color: Colors.amber,
                            )
                          : null,
                    ),
                  ),
                ),
              if (_zoom > _minZoom + 0.05)
                Positioned(
                  top: MediaQuery.paddingOf(context).top + 28,
                  left: 16,
                  child: IgnorePointer(
                    child: Chip(label: Text('${_zoom.toStringAsFixed(1)}×')),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

/// The camera preview at the recorded aspect ratio (C2): what you see is
/// what gets recorded, nothing hidden off the edges.
class _CameraPreviewFrame extends StatelessWidget {
  const _CameraPreviewFrame({required this.controller});

  final CameraController controller;

  @override
  Widget build(BuildContext context) {
    // previewSize is reported in landscape orientation.
    final preview = controller.value.previewSize;
    if (preview == null) return CameraPreview(controller);
    final portrait = MediaQuery.orientationOf(context) == Orientation.portrait;
    return ClipRect(
      child: FittedBox(
        fit: BoxFit.contain,
        child: SizedBox(
          width: portrait ? preview.height : preview.width,
          height: portrait ? preview.width : preview.height,
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
    required this.enabled,
    required this.onPressed,
  });

  final bool recording;
  final bool busy;
  final bool enabled;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: recording
          ? context.l10n.stopRecording
          : context.l10n.startRecording,
      child: GestureDetector(
        onTap: busy || !enabled ? null : onPressed,
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
                    color: enabled ? Colors.red : Colors.white24,
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
