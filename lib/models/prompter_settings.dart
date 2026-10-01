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
    this.videoQuality = VideoQuality.fullHd,
    this.autoStopRecording = true,
    this.prompterWidthFraction = 1.0,
    this.prompterLeft = 0.0,
    this.prompterTop = 0.0,
    this.letterSpacing = 0.0,
    this.focusLine = false,
    this.reduceEffects = false,
    this.stepByLine = false,
    this.autoStopDelay = 2,
    this.brightScreen = false,
    this.takesToGallery = true,
    this.reviewTakes = true,
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

  final VideoQuality videoQuality;

  /// Stop recording shortly after the last line has scrolled past.
  final bool autoStopRecording;

  /// Width of the camera / floating prompter as a fraction of the screen.
  final double prompterWidthFraction;

  /// Where the camera prompter sits, as a fraction of the free space around
  /// it (0 = left/top edge, 1 = right/bottom edge). Keeps the box on screen
  /// whatever its size.
  final double prompterLeft;
  final double prompterTop;

  /// Extra space between letters, in logical pixels (reading comfort).
  final double letterSpacing;

  /// Dim every line except the one at the reading guide.
  final bool focusLine;

  /// No fades or text shadows: smoother on old phones, less battery.
  final bool reduceEffects;

  /// Move one line per tap / remote press instead of scrolling.
  final bool stepByLine;

  /// Seconds auto-stop waits after the last line, for ad-libs.
  final int autoStopDelay;

  /// Turn screen brightness up while prompting (sunlight).
  final bool brightScreen;

  /// Save takes to the phone gallery; otherwise they stay inside the app.
  final bool takesToGallery;

  /// Show each take for keep / retake before saving it.
  final bool reviewTakes;

  static const autoStopDelays = <int>[2, 5, 10];
  static const maxLetterSpacing = 4.0;

  static const minWidthFraction = 0.4;
  static const minHeightFraction = 0.15;

  /// The camera prompter's rectangle inside [area].
  Rect prompterRect(Size area) {
    final w = area.width * prompterWidthFraction;
    final h = area.height * overlayHeightFraction;
    return Rect.fromLTWH(
      (area.width - w) * prompterLeft,
      (area.height - h) * prompterTop,
      w,
      h,
    );
  }

  /// Inverse of [prompterRect]: stores [rect] (clamped to [area]).
  PrompterSettings withPrompterRect(Rect rect, Size area) {
    final wf = (rect.width / area.width).clamp(minWidthFraction, 1.0);
    final hf = (rect.height / area.height).clamp(minHeightFraction, 1.0);
    final freeX = area.width * (1 - wf);
    final freeY = area.height * (1 - hf);
    return copyWith(
      prompterWidthFraction: wf,
      overlayHeightFraction: hf,
      prompterLeft: freeX <= 0 ? 0 : (rect.left / freeX).clamp(0.0, 1.0),
      prompterTop: freeY <= 0 ? 0 : (rect.top / freeY).clamp(0.0, 1.0),
    );
  }

  static const minFontSize = 16.0;
  static const maxFontSize = 96.0;
  static const minWpm = 40.0;
  static const maxWpm = 400.0;
  static const wpmStep = 10.0;

  static const textColors = <int>[
    0xFFFFFFFF,
    0xFFFFEB3B,
    0xFF00E676,
    0xFF40C4FF,
    0xFFFF80AB,
    0xFF000000,
  ];

  /// Whether [color] is dark, so it needs a light backdrop to be readable.
  static bool isDark(int color) => Color(color).computeLuminance() < 0.3;

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
    VideoQuality? videoQuality,
    bool? autoStopRecording,
    double? prompterWidthFraction,
    double? prompterLeft,
    double? prompterTop,
    double? letterSpacing,
    bool? focusLine,
    bool? reduceEffects,
    bool? stepByLine,
    int? autoStopDelay,
    bool? brightScreen,
    bool? takesToGallery,
    bool? reviewTakes,
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
    videoQuality: videoQuality ?? this.videoQuality,
    autoStopRecording: autoStopRecording ?? this.autoStopRecording,
    prompterWidthFraction: prompterWidthFraction ?? this.prompterWidthFraction,
    prompterLeft: prompterLeft ?? this.prompterLeft,
    prompterTop: prompterTop ?? this.prompterTop,
    letterSpacing: letterSpacing ?? this.letterSpacing,
    focusLine: focusLine ?? this.focusLine,
    reduceEffects: reduceEffects ?? this.reduceEffects,
    stepByLine: stepByLine ?? this.stepByLine,
    autoStopDelay: autoStopDelay ?? this.autoStopDelay,
    brightScreen: brightScreen ?? this.brightScreen,
    takesToGallery: takesToGallery ?? this.takesToGallery,
    reviewTakes: reviewTakes ?? this.reviewTakes,
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
    'videoQuality': videoQuality.name,
    'autoStopRecording': autoStopRecording,
    'prompterWidthFraction': prompterWidthFraction,
    'prompterLeft': prompterLeft,
    'prompterTop': prompterTop,
    'letterSpacing': letterSpacing,
    'focusLine': focusLine,
    'reduceEffects': reduceEffects,
    'stepByLine': stepByLine,
    'autoStopDelay': autoStopDelay,
    'brightScreen': brightScreen,
    'takesToGallery': takesToGallery,
    'reviewTakes': reviewTakes,
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
      videoQuality: VideoQuality.values.firstWhere(
        (q) => q.name == json['videoQuality'],
        orElse: () => d.videoQuality,
      ),
      autoStopRecording:
          json['autoStopRecording'] as bool? ?? d.autoStopRecording,
      prompterWidthFraction: n(
        'prompterWidthFraction',
        d.prompterWidthFraction,
      ).clamp(minWidthFraction, 1.0),
      prompterLeft: n('prompterLeft', d.prompterLeft).clamp(0.0, 1.0),
      prompterTop: n('prompterTop', d.prompterTop).clamp(0.0, 1.0),
      letterSpacing: n(
        'letterSpacing',
        d.letterSpacing,
      ).clamp(0.0, maxLetterSpacing),
      focusLine: json['focusLine'] as bool? ?? d.focusLine,
      reduceEffects: json['reduceEffects'] as bool? ?? d.reduceEffects,
      stepByLine: json['stepByLine'] as bool? ?? d.stepByLine,
      autoStopDelay: (json['autoStopDelay'] as int? ?? d.autoStopDelay).clamp(
        0,
        60,
      ),
      brightScreen: json['brightScreen'] as bool? ?? d.brightScreen,
      takesToGallery: json['takesToGallery'] as bool? ?? d.takesToGallery,
      reviewTakes: json['reviewTakes'] as bool? ?? d.reviewTakes,
    );
  }
}

enum VideoQuality {
  hd('720p'),
  fullHd('1080p'),
  uhd('4K');

  const VideoQuality(this.label);
  final String label;
}

enum PacePreset {
  calm(120),
  natural(150),
  energetic(180);

  const PacePreset(this.wpm);
  final double wpm;
}

/// One-tap setups for common filming situations. Pace is kept as is.
enum SetupPreset {
  handheld(Icons.phone_android),
  tripod(Icons.videocam_outlined),
  glass(Icons.flip);

  const SetupPreset(this.icon);
  final IconData icon;

  PrompterSettings apply(PrompterSettings s) => switch (this) {
    SetupPreset.handheld => s.copyWith(
      fontSize: 30,
      overlayHeightFraction: 0.3,
      prompterWidthFraction: 1,
      prompterLeft: 0,
      prompterTop: 0,
      backgroundOpacity: 0.45,
      mirror: false,
      textAlign: TextAlign.center,
    ),
    SetupPreset.tripod => s.copyWith(
      fontSize: 56,
      lineHeight: 1.3,
      overlayHeightFraction: 0.55,
      prompterWidthFraction: 1,
      prompterLeft: 0,
      prompterTop: 0,
      backgroundOpacity: 0.6,
      mirror: false,
    ),
    SetupPreset.glass => s.copyWith(
      fontSize: 48,
      overlayHeightFraction: 1,
      prompterWidthFraction: 1,
      prompterLeft: 0,
      prompterTop: 0,
      backgroundOpacity: 1,
      mirror: true,
      textColor: 0xFFFFFFFF,
    ),
  };
}
