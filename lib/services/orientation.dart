import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';

/// Screen orientations (backlog R4 / X1).
///
/// Phones: the library and editor are portrait (short-form video is shot
/// vertically), but Rehearse and Record also turn to landscape for tripods,
/// rigs and long-form video. Tablets: every orientation everywhere, which
/// iPad multitasking (Split View, Stage Manager) expects.
class Orientations {
  static bool get isTablet {
    final views = WidgetsBinding.instance.platformDispatcher.views;
    if (views.isEmpty) return false;
    final view = views.first;
    final size = view.physicalSize / view.devicePixelRatio;
    return size.shortestSide >= 600;
  }

  static const _portrait = [DeviceOrientation.portraitUp];
  static const _prompting = [
    DeviceOrientation.portraitUp,
    DeviceOrientation.landscapeLeft,
    DeviceOrientation.landscapeRight,
  ];

  /// For the library, editor and settings.
  static Future<void> app() =>
      SystemChrome.setPreferredOrientations(isTablet ? const [] : _portrait);

  /// For Rehearse and Record.
  static Future<void> prompting() =>
      SystemChrome.setPreferredOrientations(isTablet ? const [] : _prompting);
}
