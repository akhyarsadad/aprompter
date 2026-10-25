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

/// Free space where recordings go, in bytes; null if unknown.
Future<int?> freeSpaceBytes() async {
  try {
    return await _channel.invokeMethod<int>('freeSpace');
  } on Object {
    return null;
  }
}

/// Battery level (0–100) and charging state; null if unknown.
Future<({int level, bool charging})?> batteryStatus() async {
  try {
    final m = await _channel.invokeMapMethod<String, Object?>('battery');
    if (m == null) return null;
    return (level: m['level'] as int, charging: m['charging'] as bool);
  } on Object {
    return null;
  }
}

/// Full screen brightness while prompting; false restores the phone's.
Future<void> setBrightScreen(bool on) async {
  try {
    await _channel.invokeMethod<bool>('setBright', on);
  } on Object {
    // A convenience; prompting works without it.
  }
}

/// Phone maker (lower case) and whether it is a low-RAM / Android Go phone.
Future<({String manufacturer, bool lowRam})> deviceInfo() async {
  try {
    final m = await _channel.invokeMapMethod<String, Object?>('deviceInfo');
    return (
      manufacturer: (m?['manufacturer'] as String?) ?? '',
      lowRam: (m?['lowRam'] as bool?) ?? false,
    );
  } on Object {
    return (manufacturer: '', lowRam: false);
  }
}
