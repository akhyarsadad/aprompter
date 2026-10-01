import 'package:flutter/material.dart';

/// Visual and playback options for the teleprompter.
class PrompterSettings {
  const PrompterSettings({
    this.fontSize = 32,
    this.speed = 40,
    this.lineHeight = 1.4,
    this.mirror = false,
    this.textColor = 0xFFFFFFFF,
    this.backgroundOpacity = 0.45,
    this.countdownSeconds = 3,
    this.textAlign = TextAlign.center,
    this.showGuide = true,
    this.overlayHeightFraction = 0.35,
  });

  /// Font size in logical pixels.
  final double fontSize;

  /// Scroll speed in logical pixels per second.
  final double speed;

  final double lineHeight;

  /// Flip text horizontally, for beam-splitter teleprompter glass.
  final bool mirror;

  final int textColor;

  /// Opacity of the dark backdrop behind the text (0 = transparent).
  final double backgroundOpacity;

  final int countdownSeconds;
  final TextAlign textAlign;

  /// Show a reading-line marker so the eyes know where to look.
  final bool showGuide;

  /// Height of the floating/camera prompter as a fraction of the screen.
  final double overlayHeightFraction;

  static const minFontSize = 16.0;
  static const maxFontSize = 96.0;
  static const minSpeed = 5.0;
  static const maxSpeed = 300.0;

  static const textColors = <int>[
    0xFFFFFFFF,
    0xFFFFEB3B,
    0xFF00E676,
    0xFF40C4FF,
    0xFFFF80AB,
    0xFF000000,
  ];

  PrompterSettings copyWith({
    double? fontSize,
    double? speed,
    double? lineHeight,
    bool? mirror,
    int? textColor,
    double? backgroundOpacity,
    int? countdownSeconds,
    TextAlign? textAlign,
    bool? showGuide,
    double? overlayHeightFraction,
  }) => PrompterSettings(
    fontSize: fontSize ?? this.fontSize,
    speed: speed ?? this.speed,
    lineHeight: lineHeight ?? this.lineHeight,
    mirror: mirror ?? this.mirror,
    textColor: textColor ?? this.textColor,
    backgroundOpacity: backgroundOpacity ?? this.backgroundOpacity,
    countdownSeconds: countdownSeconds ?? this.countdownSeconds,
    textAlign: textAlign ?? this.textAlign,
    showGuide: showGuide ?? this.showGuide,
    overlayHeightFraction: overlayHeightFraction ?? this.overlayHeightFraction,
  );

  Map<String, dynamic> toJson() => {
    'fontSize': fontSize,
    'speed': speed,
    'lineHeight': lineHeight,
    'mirror': mirror,
    'textColor': textColor,
    'backgroundOpacity': backgroundOpacity,
    'countdownSeconds': countdownSeconds,
    'textAlign': textAlign.name,
    'showGuide': showGuide,
    'overlayHeightFraction': overlayHeightFraction,
  };

  factory PrompterSettings.fromJson(Map<String, dynamic> json) {
    const d = PrompterSettings();
    double n(String k, double fallback) =>
        (json[k] as num?)?.toDouble() ?? fallback;
    return PrompterSettings(
      fontSize: n(
        'fontSize',
        d.fontSize,
      ).clamp(minFontSize, maxFontSize).toDouble(),
      speed: n('speed', d.speed).clamp(minSpeed, maxSpeed).toDouble(),
      lineHeight: n('lineHeight', d.lineHeight),
      mirror: json['mirror'] as bool? ?? d.mirror,
      textColor: json['textColor'] as int? ?? d.textColor,
      backgroundOpacity: n(
        'backgroundOpacity',
        d.backgroundOpacity,
      ).clamp(0.0, 1.0),
      countdownSeconds: json['countdownSeconds'] as int? ?? d.countdownSeconds,
      textAlign: TextAlign.values.firstWhere(
        (a) => a.name == json['textAlign'],
        orElse: () => d.textAlign,
      ),
      showGuide: json['showGuide'] as bool? ?? d.showGuide,
      overlayHeightFraction: n(
        'overlayHeightFraction',
        d.overlayHeightFraction,
      ).clamp(0.15, 1.0),
    );
  }
}
