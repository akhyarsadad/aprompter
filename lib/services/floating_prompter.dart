import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../models/prompter_settings.dart';
import '../models/script.dart';
import 'storage.dart';

/// Shows the prompter as a floating window above other apps (Android only).
///
/// iOS does not allow apps to draw over other apps, so on iOS the in-app
/// camera prompter is used instead.
class FloatingPrompter {
  static bool get isSupported => Platform.isAndroid;

  static Future<bool> ensurePermission() async {
    if (await FlutterOverlayWindow.isPermissionGranted()) return true;
    return await FlutterOverlayWindow.requestPermission() ?? false;
  }

  /// Opens (or refreshes) the floating prompter with [script].
  static Future<void> show({
    required Storage storage,
    required Script script,
    required PrompterSettings settings,
  }) async {
    // Persist so the overlay can recover the script if it misses the message.
    await storage.saveActiveScript(script);
    await storage.saveSettings(settings);

    if (!await FlutterOverlayWindow.isActive()) {
      final view = PlatformDispatcher.instance.implicitView!;
      final heightPx =
          (view.physicalSize.height * settings.overlayHeightFraction).round();
      await FlutterOverlayWindow.showOverlay(
        height: heightPx,
        width: WindowSize.matchParent,
        alignment: OverlayAlignment.topCenter,
        flag: OverlayFlag.defaultFlag,
        enableDrag: true,
        positionGravity: PositionGravity.none,
        overlayTitle: 'APrompter is floating',
        overlayContent: script.title.isEmpty ? 'Teleprompter' : script.title,
      );
    }
    await FlutterOverlayWindow.shareData(
      jsonEncode({
        'type': 'load',
        'script': script.toJson(),
        'settings': settings.toJson(),
      }),
    );
  }

  static Future<void> close() => FlutterOverlayWindow.closeOverlay();
}
