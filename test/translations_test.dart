import 'dart:convert';
import 'dart:io';

import 'package:aprompter/models/script_markup.dart';
import 'package:flutter_test/flutter_test.dart';

/// Guards the ARB files in lib/l10n: every language must have every string,
/// keep the same {placeholders}, and keep the welcome script's markup.
void main() {
  final dir = Directory('lib/l10n');
  Map<String, dynamic> load(File f) =>
      jsonDecode(f.readAsStringSync()) as Map<String, dynamic>;
  final en = load(File('lib/l10n/app_en.arb'));
  final keys = en.keys.where((k) => !k.startsWith('@')).toSet();
  final arbs = dir
      .listSync()
      .whereType<File>()
      .where((f) => f.path.endsWith('.arb'))
      .toList();

  Set<String> placeholders(String s) =>
      RegExp(r'\{([A-Za-z_][A-Za-z0-9_]*)[,}]')
          .allMatches(s)
          .map((m) => m.group(1)!)
          .toSet();

  test('there are 28 languages', () => expect(arbs, hasLength(28)));

  for (final file in arbs) {
    final name = file.uri.pathSegments.last;
    test('$name is complete and consistent', () {
      final arb = load(file);
      final own = arb.keys.where((k) => !k.startsWith('@')).toSet();
      expect(own.difference(keys), isEmpty, reason: 'unknown keys');
      expect(keys.difference(own), isEmpty, reason: 'missing keys');
      for (final k in keys) {
        expect(
          placeholders(arb[k] as String),
          placeholders(en[k] as String),
          reason: '$name: $k',
        );
      }
      final welcome = parseScript(arb['welcomeBody'] as String);
      final enWelcome = parseScript(en['welcomeBody'] as String);
      int count(List<ScriptBlock> b, BlockType t) =>
          b.where((x) => x.type == t).length;
      for (final t in [BlockType.section, BlockType.note]) {
        expect(count(welcome, t), count(enWelcome, t), reason: '$name $t');
      }
      expect(
        (arb['welcomeBody'] as String).contains('[pause]'),
        isTrue,
        reason: '$name keeps [pause]',
      );
    });
  }
}
