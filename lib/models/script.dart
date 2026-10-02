import 'script_markup.dart';

enum ScriptStatus { draft, ready, recorded }

/// A teleprompter script written by the user.
class Script {
  Script({
    required this.id,
    required this.title,
    required this.body,
    required this.updatedAt,
    this.status = ScriptStatus.draft,
    this.targetSeconds,
    this.takes = 0,
  });

  final String id;
  final String title;
  final String body;
  final DateTime updatedAt;
  final ScriptStatus status;

  /// Desired video length, or null for no target.
  final int? targetSeconds;

  /// Number of recordings made with this script.
  final int takes;

  /// Words that will be spoken (sections, notes and markers excluded).
  int get wordCount => countWords(spokenText(body));

  /// `[pause]` beats in spoken lines.
  int get pauses => pauseCount(body);

  /// Time to say the script at [wpm], `[pause]` beats included.
  Duration durationAt(double wpm) =>
      Duration(seconds: speakingSeconds(body, wpm).round());

  List<String> get sections => sectionTitles(body);

  Script copyWith({
    String? title,
    String? body,
    DateTime? updatedAt,
    ScriptStatus? status,
    int? Function()? targetSeconds,
    int? takes,
  }) => Script(
    id: id,
    title: title ?? this.title,
    body: body ?? this.body,
    updatedAt: updatedAt ?? this.updatedAt,
    status: status ?? this.status,
    targetSeconds: targetSeconds != null ? targetSeconds() : this.targetSeconds,
    takes: takes ?? this.takes,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'updatedAt': updatedAt.toIso8601String(),
    'status': status.name,
    'targetSeconds': targetSeconds,
    'takes': takes,
  };

  factory Script.fromJson(Map<String, dynamic> json) => Script(
    id: json['id'] as String,
    title: json['title'] as String? ?? '',
    body: json['body'] as String? ?? '',
    updatedAt:
        DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
    status: ScriptStatus.values.firstWhere(
      (s) => s.name == json['status'],
      orElse: () => ScriptStatus.draft,
    ),
    targetSeconds: json['targetSeconds'] as int?,
    takes: json['takes'] as int? ?? 0,
  );
}

/// Formats a duration as m:ss.
String formatDuration(Duration d) =>
    '${d.inMinutes}:${(d.inSeconds % 60).toString().padLeft(2, '0')}';
