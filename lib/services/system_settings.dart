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
