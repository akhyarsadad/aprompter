import 'package:aprompter/models/prompter_settings.dart';
import 'package:aprompter/models/script.dart';
import 'package:aprompter/models/script_markup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Script round-trips through JSON', () {
    final s = Script(
      id: '1',
      title: 'Intro',
      body: 'Hello world',
      updatedAt: DateTime(2026, 1, 1),
      status: ScriptStatus.ready,
      targetSeconds: 30,
      takes: 2,
    );
    final copy = Script.fromJson(s.toJson());
    expect(copy.title, 'Intro');
    expect(copy.status, ScriptStatus.ready);
    expect(copy.targetSeconds, 30);
    expect(copy.takes, 2);
    expect(copy.copyWith(targetSeconds: () => null).targetSeconds, isNull);
  });

  test('old scripts without new fields still load', () {
    final s = Script.fromJson({'id': 'x', 'title': 't', 'body': 'b'});
    expect(s.status, ScriptStatus.draft);
    expect(s.targetSeconds, isNull);
    expect(s.takes, 0);
  });

  group('markup', () {
    const body =
        '# Hook\n'
        '// smile\n'
        'This is *really* cool. [pause] Right?\n'
        '\n'
        '## CTA\n'
        'Follow for more';

    test('parses sections, notes, emphasis and pauses', () {
      final blocks = parseScript(body);
      expect(blocks.map((b) => b.type), [
        BlockType.section,
        BlockType.note,
        BlockType.line,
        BlockType.blank,
        BlockType.section,
        BlockType.line,
      ]);
      expect(blocks[0].text, 'Hook');
      expect(blocks[1].text, 'smile');
      expect(blocks[2].spans.map((s) => s.type), [
        SpanType.text,
        SpanType.emphasis,
        SpanType.text,
        SpanType.pause,
        SpanType.text,
      ]);
      expect(blocks[2].spans[1].text, 'really');
      expect(sectionTitles(body), ['Hook', 'CTA']);
    });

    test('counts only spoken words', () {
      // "This is really cool Right Follow for more"
      expect(countWords(spokenText(body)), 8);
      final script = Script(
        id: '1',
        title: '',
        body: body,
        updatedAt: DateTime(2026),
      );
      expect(script.wordCount, 8);
      expect(script.durationAt(120), const Duration(seconds: 4));
    });

    test('flags long sentences', () {
      final long = List.filled(30, 'word').join(' ');
      expect(longSentenceCount('$long. Short one.'), 1);
      expect(longSentenceCount('Short. Also short.'), 0);
    });
  });

  test('PrompterSettings round-trips, clamps and ignores old speed key', () {
    const s = PrompterSettings(
      fontSize: 50,
      wpm: 170,
      mirror: true,
      textAlign: TextAlign.left,
    );
    final copy = PrompterSettings.fromJson(s.toJson());
    expect(copy.fontSize, 50);
    expect(copy.wpm, 170);
    expect(copy.mirror, isTrue);
    expect(copy.textAlign, TextAlign.left);

    final bad = PrompterSettings.fromJson({'fontSize': 999, 'wpm': 5});
    expect(bad.fontSize, PrompterSettings.maxFontSize);
    expect(bad.wpm, PrompterSettings.minWpm);
    expect(PrompterSettings.fromJson({'speed': 40}).wpm, 150);
  });

  test('setup presets keep the pace', () {
    const s = PrompterSettings(wpm: 180);
    for (final p in SetupPreset.values) {
      expect(p.apply(s).wpm, 180);
    }
    expect(SetupPreset.glass.apply(s).mirror, isTrue);
  });
}
