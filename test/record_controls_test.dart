// The Record screen's bottom row: the shutter sits in the middle of the
// screen like in any camera app, whatever else is around it.
import 'dart:async';

import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/main.dart';
import 'package:aprompter/models/script.dart';
import 'package:aprompter/screens/camera_prompter_screen.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/entitlements.dart';
import 'package:aprompter/services/purchase_service.dart';
import 'package:aprompter/services/storage.dart';
import 'package:camera_platform_interface/camera_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Stream<T> _never<T>() => StreamController<T>.broadcast().stream;

/// A phone camera that opens straight away and shows nothing.
class _FakeCamera extends CameraPlatform {
  _FakeCamera(this.cameras);

  final List<CameraDescription> cameras;

  @override
  Future<List<CameraDescription>> availableCameras() async => cameras;

  @override
  Future<int> createCameraWithSettings(
    CameraDescription cameraDescription,
    MediaSettings mediaSettings,
  ) async => 1;

  @override
  Future<void> initializeCamera(
    int cameraId, {
    ImageFormatGroup imageFormatGroup = ImageFormatGroup.unknown,
  }) async {}

  @override
  Stream<CameraInitializedEvent> onCameraInitialized(int cameraId) =>
      Stream.value(
        CameraInitializedEvent(
          cameraId,
          1920,
          1080,
          ExposureMode.auto,
          true,
          FocusMode.auto,
          true,
        ),
      );

  @override
  Stream<CameraResolutionChangedEvent> onCameraResolutionChanged(int id) =>
      _never();

  @override
  Stream<CameraClosingEvent> onCameraClosing(int id) => _never();

  @override
  Stream<CameraErrorEvent> onCameraError(int id) => _never();

  @override
  Stream<DeviceOrientationChangedEvent> onDeviceOrientationChanged() =>
      _never();

  @override
  Future<void> prepareForVideoRecording() async {}

  @override
  Future<double> getMaxZoomLevel(int cameraId) async => 4;

  @override
  Future<double> getMinZoomLevel(int cameraId) async => 1;

  @override
  Future<Iterable<VideoStabilizationMode>> getSupportedVideoStabilizationModes(
    int cameraId,
  ) async => const [];

  @override
  Future<void> dispose(int cameraId) async {}

  @override
  Widget buildPreview(int cameraId) => const ColoredBox(color: Colors.grey);
}

const _front = CameraDescription(
  name: 'front',
  lensDirection: CameraLensDirection.front,
  sensorOrientation: 270,
);
const _back = CameraDescription(
  name: 'back',
  lensDirection: CameraLensDirection.back,
  sensorOrientation: 90,
);

void main() {
  final en = lookupAppLocalizations(const Locale('en'));
  late CameraPlatform realCamera;

  setUpAll(() {
    realCamera = CameraPlatform.instance;
    // Keeping the screen on has no test implementation: answer quietly.
    final messenger =
        TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
    for (final call in ['toggle', 'isEnabled']) {
      messenger.setMockMessageHandler(
        'dev.flutter.pigeon.wakelock_plus_platform_interface.WakelockPlusApi.$call',
        (_) async =>
            const StandardMessageCodec().encodeMessage(<Object?>[false]),
      );
    }
  });
  tearDownAll(() => CameraPlatform.instance = realCamera);
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> openRecord(
    WidgetTester tester, {
    required Size size,
    required List<CameraDescription> cameras,
  }) async {
    CameraPlatform.instance = _FakeCamera(cameras);
    tester.view.physicalSize = size * 3;
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final storage = await Storage.open();
    await storage.setCameraIntroSeen();
    final entitlements = Entitlements(isUnlimited: true);
    await tester.pumpWidget(
      AprompterApp(
        state: AppState(storage),
        entitlements: entitlements,
        purchaseService: PurchaseService(entitlements: entitlements),
      ),
    );
    await tester.pumpAndSettle();
    tester
        .state<NavigatorState>(find.byType(Navigator).first)
        .push(
          MaterialPageRoute<void>(
            builder: (_) => CameraPrompterScreen(
              script: Script(
                id: 's',
                title: 'Take',
                body: 'Hello there, this is my take.',
                updatedAt: DateTime(2026),
              ),
            ),
          ),
        );
    await tester.pumpAndSettle();
  }

  final shutter = find.byWidgetPredicate(
    (w) => w is Semantics && w.properties.label == en.startRecording,
  );
  Finder button(String tooltip) => find.byTooltip(tooltip);

  for (final (name, size) in [
    ('portrait phone', const Size(360, 780)),
    ('landscape phone', const Size(780, 360)),
    ('tablet', const Size(800, 1280)),
    // Split screen: narrower than the row needs, so it shrinks as a whole.
    ('narrow window', const Size(250, 600)),
  ]) {
    for (final cameras in [
      [_front],
      [_front, _back],
    ]) {
      testWidgets('shutter is centred: $name, ${cameras.length} camera(s)', (
        tester,
      ) async {
        await openRecord(tester, size: size, cameras: cameras);
        expect(shutter, findsOneWidget);
        expect(tester.getCenter(shutter).dx, closeTo(size.width / 2, 0.5));

        // Close on the left of it, settings and switch camera on the right.
        final x = tester.getCenter(shutter).dx;
        expect(tester.getCenter(button(en.close)).dx, lessThan(x));
        expect(tester.getCenter(button(en.settings)).dx, greaterThan(x));
        expect(tester.getCenter(button(en.switchCamera)).dx, greaterThan(x));

        // All on one row.
        final y = tester.getCenter(shutter).dy;
        for (final t in [en.close, en.settings, en.switchCamera]) {
          expect(tester.getCenter(button(t)).dy, closeTo(y, 0.5));
        }

        // Switching needs a second camera.
        final switchButton = tester.widget<IconButton>(
          find.ancestor(
            of: find.byIcon(Icons.cameraswitch),
            matching: find.byType(IconButton),
          ),
        );
        expect(switchButton.onPressed != null, cameras.length > 1);
      });
    }
  }
}
