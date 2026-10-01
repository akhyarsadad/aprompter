import 'package:flutter/material.dart';

/// Visual and playback options for the teleprompter.
class PrompterSettings {
  const PrompterSettings({
    this.fontSize = 32,
    this.wpm = 150,
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

  /// Reading pace in spoken words per minute. Independent of font size.
  final double wpm;

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
  static const minWpm = 60.0;
  static const maxWpm = 300.0;
  static const wpmStep = 10.0;

  static const textColors = <int>[
    0xFFFFFFFF,
    0xFFFFEB3B,
    0xFF00E676,
    0xFF40C4FF,
    0xFFFF80AB,
    0xFF000000,
  ];

  static double clampWpm(double wpm) => wpm.clamp(minWpm, maxWpm).toDouble();

  PrompterSettings copyWith({
    double? fontSize,
    double? wpm,
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
    wpm: wpm != null ? clampWpm(wpm) : this.wpm,
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
    'wpm': wpm,
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
      wpm: clampWpm(n('wpm', d.wpm)),
      lineHeight: n('lineHeight', d.lineHeight).clamp(1.0, 2.5),
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

/// Named reading paces.
const pacePresets = <(String, double)>[
  ('Calm', 120),
  ('Natural', 150),
  ('Energetic', 180),
];

/// One-tap setups for common filming situations. Pace is kept as is.
class SetupPreset {
  const SetupPreset(this.name, this.description, this.icon, this.apply);
  final String name;
  final String description;
  final IconData icon;
  final PrompterSettings Function(PrompterSettings) apply;
}

final setupPresets = <SetupPreset>[
  SetupPreset(
    'Handheld selfie',
    'Medium text close to the lens',
    Icons.phone_android,
    (s) => s.copyWith(
      fontSize: 30,
      overlayHeightFraction: 0.3,
      backgroundOpacity: 0.45,
      mirror: false,
      textAlign: TextAlign.center,
    ),
  ),
  SetupPreset(
    'Tripod / distance',
    'Big text you can read from 1–2 m',
    Icons.videocam_outlined,
    (s) => s.copyWith(
      fontSize: 56,
      lineHeight: 1.3,
      overlayHeightFraction: 0.55,
      backgroundOpacity: 0.6,
      mirror: false,
    ),
  ),
  SetupPreset(
    'Teleprompter glass',
    'Mirrored, full screen, solid background',
    Icons.flip,
    (s) => s.copyWith(
      fontSize: 48,
      overlayHeightFraction: 1,
      backgroundOpacity: 1,
      mirror: true,
      textColor: 0xFFFFFFFF,
    ),
  ),
];
