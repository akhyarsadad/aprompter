/// A teleprompter script written by the user.
class Script {
  Script({
    required this.id,
    required this.title,
    required this.body,
    required this.updatedAt,
  });

  final String id;
  final String title;
  final String body;
  final DateTime updatedAt;

  int get wordCount =>
      body.trim().isEmpty ? 0 : body.trim().split(RegExp(r'\s+')).length;

  /// Rough reading time at an average speaking pace of 150 words per minute.
  Duration get estimatedDuration =>
      Duration(seconds: (wordCount / 150 * 60).round());

  Script copyWith({String? title, String? body, DateTime? updatedAt}) => Script(
    id: id,
    title: title ?? this.title,
    body: body ?? this.body,
    updatedAt: updatedAt ?? this.updatedAt,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'body': body,
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Script.fromJson(Map<String, dynamic> json) => Script(
    id: json['id'] as String,
    title: json['title'] as String? ?? '',
    body: json['body'] as String? ?? '',
    updatedAt:
        DateTime.tryParse(json['updatedAt'] as String? ?? '') ?? DateTime.now(),
  );
}
