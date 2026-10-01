/// Lightweight teleprompter markup.
///
/// - `# Section` — a section cue you can jump to.
/// - `// note` — direction for the creator; dimmed, not spoken.
/// - `*word*` — emphasis.
/// - `[pause]` — a visible beat.
library;

enum BlockType { section, note, line, blank }

enum SpanType { text, emphasis, pause }

class ScriptSpan {
  const ScriptSpan(this.type, [this.text = '']);
  final SpanType type;
  final String text;
}

class ScriptBlock {
  const ScriptBlock(this.type, {this.text = '', this.spans = const []});
  final BlockType type;

  /// Raw text without the marker (`#` or `//`).
  final String text;

  /// Inline spans for [BlockType.line].
  final List<ScriptSpan> spans;
}

final _inline = RegExp(r'\*([^*\n]+)\*|\[pause\]', caseSensitive: false);
// Letters + combining marks, so Hindi, Bengali, Tamil… words with vowel signs
// stay one word.
final _words = RegExp(r"[\p{L}\p{M}\p{N}'’]+", unicode: true);

// Scripts written without spaces between words. Speaking time is estimated
// from characters, expressed in "English-word equivalents" so one pace in
// words per minute works for every language.
final _han = RegExp(r'\p{Script=Han}', unicode: true);
final _kana = RegExp(
  r'[\p{Script=Hiragana}\p{Script=Katakana}]',
  unicode: true,
);
final _southeastAsian = RegExp(
  r'[\p{Script=Thai}\p{Script=Lao}\p{Script=Khmer}\p{Script=Myanmar}]',
  unicode: true,
);
const _hanWeight = 0.5; // ~300 characters/min at 150 wpm
const _kanaWeight = 0.35; // Japanese kana are spoken faster
const _southeastAsianWeight = 0.2; // ~5 characters (incl. marks) per word

final _rtl = RegExp(
  r'[֐-ࣿיִ-﷿ﹰ-﻿]', // Hebrew, Arabic, Syriac, Thaana…
);
final _strong = RegExp(r'[\p{L}]', unicode: true);

List<ScriptBlock> parseScript(String body) {
  final blocks = <ScriptBlock>[];
  for (final raw in body.split('\n')) {
    final line = raw.trim();
    if (line.isEmpty) {
      blocks.add(const ScriptBlock(BlockType.blank));
    } else if (line.startsWith('#')) {
      blocks.add(
        ScriptBlock(
          BlockType.section,
          text: line.replaceFirst(RegExp(r'^#+\s*'), ''),
        ),
      );
    } else if (line.startsWith('//')) {
      blocks.add(
        ScriptBlock(
          BlockType.note,
          text: line.replaceFirst(RegExp(r'^//\s*'), ''),
        ),
      );
    } else {
      blocks.add(ScriptBlock(BlockType.line, text: line, spans: _spans(line)));
    }
  }
  return blocks;
}

List<ScriptSpan> _spans(String line) {
  final spans = <ScriptSpan>[];
  var i = 0;
  for (final m in _inline.allMatches(line)) {
    if (m.start > i) {
      spans.add(ScriptSpan(SpanType.text, line.substring(i, m.start)));
    }
    spans.add(
      m.group(1) != null
          ? ScriptSpan(SpanType.emphasis, m.group(1)!)
          : const ScriptSpan(SpanType.pause),
    );
    i = m.end;
  }
  if (i < line.length) spans.add(ScriptSpan(SpanType.text, line.substring(i)));
  return spans;
}

/// Text that will actually be spoken (no sections, notes or markers).
String spokenText(String body) => parseScript(body)
    .where((b) => b.type == BlockType.line)
    .map(
      (b) => b.spans
          .where((s) => s.type != SpanType.pause)
          .map((s) => s.text)
          .join(),
    )
    .join('\n');

/// Spoken length in word equivalents. Space-separated languages count
/// words; Chinese, Japanese, Thai, Lao, Khmer and Burmese count characters,
/// weighted to the time they take to say.
int countWords(String text) {
  final han = _han.allMatches(text).length;
  final kana = _kana.allMatches(text).length;
  final sea = _southeastAsian.allMatches(text).length;
  var rest = text;
  if (han + kana + sea > 0) {
    rest = text
        .replaceAll(_han, ' ')
        .replaceAll(_kana, ' ')
        .replaceAll(_southeastAsian, ' ');
  }
  final words = _words.allMatches(rest).length;
  return (words +
          han * _hanWeight +
          kana * _kanaWeight +
          sea * _southeastAsianWeight)
      .round();
}

/// Whether [text] should be laid out right-to-left (its first letter is
/// Hebrew, Arabic, Persian, Urdu…).
bool isRtlText(String text) {
  final first = _strong.firstMatch(text);
  return first != null && _rtl.hasMatch(first.group(0)!);
}

/// Section titles in order.
List<String> sectionTitles(String body) =>
    parseScript(body)
        .where((b) => b.type == BlockType.section)
        .map((b) => b.text)
        .toList();

/// Sentences with more words than [maxWords] — hard to say in one breath.
int longSentenceCount(String body, {int maxWords = 25}) =>
    spokenText(body)
        .split(RegExp(r'[.!?…。！？؟।۔]+|\n'))
        .where((s) => countWords(s) > maxWords)
        .length;
