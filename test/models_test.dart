import 'package:aprompter/models/prompter_settings.dart';
import 'package:aprompter/models/script.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Script round-trips through JSON and counts words', () {
    final s = Script(
      id: '1',
      title: 'Intro',
      body: 'Hello   world\nthis is a test',
      updatedAt: DateTime(2026, 1, 1),
    );
    final copy = Script.fromJson(s.toJson());
    expect(copy.title, 'Intro');
    expect(copy.body, s.body);
    expect(copy.updatedAt, s.updatedAt);
    expect(s.wordCount, 6);
    expect(
      Script(
        id: '2',
        title: '',
        body: '  ',
        updatedAt: DateTime(2026),
      ).wordCount,
      0,
    );
  });

  test('PrompterSettings round-trips and clamps bad values', () {
    const s = PrompterSettings(
      fontSize: 50,
      mirror: true,
      textAlign: TextAlign.left,
    );
    final copy = PrompterSettings.fromJson(s.toJson());
    expect(copy.fontSize, 50);
    expect(copy.mirror, isTrue);
    expect(copy.textAlign, TextAlign.left);

    final bad = PrompterSettings.fromJson({'fontSize': 999, 'speed': -3});
    expect(bad.fontSize, PrompterSettings.maxFontSize);
    expect(bad.speed, PrompterSettings.minSpeed);
  });
}
