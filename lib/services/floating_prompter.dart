import 'dart:convert';
import 'dart:io';
import 'dart:ui';

import 'package:flutter_overlay_window/flutter_overlay_window.dart';

import '../l10n/l10n.dart';
import '../models/prompter_settings.dart';
import '../models/script.dart';
import 'storage.dart';
import 'system_settings.dart';

/// Shows the prompter as a floating window above other apps (Android only).
///
/// The window can be dragged anywhere; its last position is remembered.
/// iOS does not allow apps to draw over other apps, so on iOS the in-app
/// camera prompter is used instead.
class FloatingPrompter {
  static bool get isSupported => Platform.isAndroid;

  /// Leaves room for the status bar on first use.
  static const _defaultTop = 32.0;

  static Future<bool> ensurePermission() async {
    if (await FlutterOverlayWindow.isPermissionGranted()) return true;
    return await FlutterOverlayWindow.requestPermission() ?? false;
  }

  /// Window size in logical pixels for a screen of [screen] logical pixels.
  static Size windowSize(Size screen, PrompterSettings settings) => Size(
    screen.width * settings.prompterWidthFraction,
    screen.height * settings.overlayHeightFraction,
  );

  /// Where to open the window: the saved spot, pulled back on screen if the
  /// screen or window size changed since; otherwise centred at the top.
  static Offset startPosition(Size screen, Size window, Offset? saved) {
    final maxX = (screen.width - window.width).clamp(0.0, double.infinity);
    final maxY = (screen.height - window.height).clamp(0.0, double.infinity);
    final p = saved ?? Offset(maxX / 2, _defaultTop);
    return Offset(p.dx.clamp(0.0, maxX), p.dy.clamp(0.0, maxY));
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
      final l = deviceLocalizations(parseLocaleTag(storage.loadLocale()));
      final display = PlatformDispatcher.instance.displays.first;
      final ratio = display.devicePixelRatio;
      final screen = display.size / ratio;
      final window = windowSize(screen, settings);
      final start = startPosition(screen, window, storage.loadFloatPosition());
      await FlutterOverlayWindow.showOverlay(
        // Size is in physical pixels, position in logical pixels.
        height: (window.height * ratio).round(),
        width: (window.width * ratio).round(),
        alignment: OverlayAlignment.topLeft,
        flag: OverlayFlag.defaultFlag,
        enableDrag: true,
        positionGravity: PositionGravity.none,
        startPosition: OverlayPosition(start.dx, start.dy),
        overlayTitle: l.floatingNotificationTitle,
        // The script title stays out of the notification shade.
        overlayContent: l.floatingNotificationBody,
      );
    }
    // Keep the script out of screen recordings and live streams.
    await secureOverlay();
    await FlutterOverlayWindow.shareData(
      jsonEncode({
        'type': 'load',
        'script': script.toJson(),
        'settings': settings.toJson(),
        'locale': storage.loadLocale(),
      }),
    );
  }

  /// Sends edits of [script] to the floating window if it is showing it,
  /// keeping the reader's place.
  static Future<void> update(Storage storage, Script script) async {
    if (!isSupported) return;
    try {
      if (!await FlutterOverlayWindow.isActive()) return;
    } catch (_) {
      return;
    }
    if (storage.loadActiveScript()?.id != script.id) return;
    await storage.saveActiveScript(script);
    await FlutterOverlayWindow.shareData(
      jsonEncode({'type': 'update', 'script': script.toJson()}),
    );
  }

  /// Remembers where the user dragged the window. Call from the overlay.
  static Future<void> rememberPosition() async {
    try {
      final p = await FlutterOverlayWindow.getOverlayPosition();
      final storage = await Storage.open();
      await storage.saveFloatPosition(Offset(p.x, p.y));
    } catch (_) {
      // Position is a convenience; never block closing on it.
    }
  }

  static Future<void> close() => FlutterOverlayWindow.closeOverlay();
}
