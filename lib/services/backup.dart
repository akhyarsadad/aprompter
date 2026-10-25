import 'dart:convert';

import '../models/script.dart';

/// Backup files: every script in one JSON file the creator can keep in
/// Files, Drive or a chat, and restore on any phone.
class Backup {
  static const format = 'aprompter-backup';
  static const version = 1;

  static String encode(List<Script> scripts, {DateTime? now}) =>
      const JsonEncoder.withIndent(' ').convert({
        'format': format,
        'version': version,
        'exportedAt': (now ?? DateTime.now()).toIso8601String(),
        'scripts': scripts.map((s) => s.toJson()).toList(),
      });

  /// File name like `aprompter-backup-2026-10-02.json`.
  static String fileName(DateTime now) =>
      'aprompter-backup-${now.toIso8601String().substring(0, 10)}.json';

  /// The scripts in a backup, or null if [text] is not one.
  static List<Script>? decode(String text) {
    try {
      final json = jsonDecode(text);
      if (json is! Map<String, dynamic> || json['format'] != format) {
        return null;
      }
      return [
        for (final s in json['scripts'] as List)
          Script.fromJson(s as Map<String, dynamic>),
      ];
    } catch (_) {
      return null;
    }
  }
}

/// Whatever scripts can still be read from damaged data: a list or a single
/// script, with missing ids, titles or dates filled in.
List<Script> salvageScripts(String raw) {
  Object? json;
  try {
    json = jsonDecode(raw);
  } catch (_) {
    return const [];
  }
  final entries = json is List
      ? json
      : json is Map && json['scripts'] is List
      ? json['scripts'] as List
      : [json];
  final out = <Script>[];
  for (final (i, e) in entries.indexed) {
    if (e is! Map || e['body'] is! String) continue;
    out.add(
      Script(
        id: e['id'] is String
            ? e['id'] as String
            : 'recovered-$i-${raw.hashCode}',
        title: e['title'] is String ? e['title'] as String : '',
        body: e['body'] as String,
        updatedAt:
            DateTime.tryParse(e['updatedAt']?.toString() ?? '') ??
            DateTime.now(),
      ),
    );
  }
  return out;
}
