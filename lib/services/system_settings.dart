import 'package:flutter/services.dart';

const _channel = MethodChannel('aprompter/system');

/// Opens this app's page in the system settings (permissions etc.).
Future<void> openAppSettings() async {
  try {
    await _channel.invokeMethod<bool>('openAppSettings');
  } on PlatformException {
    // Nothing more we can do; the user can still open settings manually.
  } on MissingPluginException {
    // Not available on this platform.
  }
}

/// Hides the Android floating prompter from screen recordings, screen
/// sharing and live streams. Waits briefly for the window to appear.
Future<bool> secureOverlay() async {
  for (var i = 0; i < 30; i++) {
    try {
      if (await _channel.invokeMethod<bool>('secureOverlay') == true) {
        return true;
      }
    } on PlatformException {
      return false;
    } on MissingPluginException {
      return false;
    }
    await Future<void>.delayed(const Duration(milliseconds: 100));
  }
  return false;
}
