/// Lightweight teleprompter markup.
///
/// - `# Section` — a section cue you can jump to (`#` then a space).
/// - `// note` — direction for the creator; dimmed, not spoken.
/// - `#fyp #viral` — a hashtag line; dimmed, not spoken, kept for captions.
/// - `*word*` or `**word**` — emphasis. `\*` is a literal asterisk.
/// - `[pause]` — a visible beat that also takes time.
library;

enum BlockType { section, note, tags, line, blank }

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

// Emphasis needs the asterisks to hug a word (`2*3*4`, `* tip` and `\*`
// stay literal). Pauses accept `[pause]`, `[ Pause. ]` and `(pause)`.
final _inline = RegExp(
  r'(?<![\p{L}\p{N}\\*])(\*\*?)(?![\s*])([^\n]+?)(?<![\s\\*])\1(?![\p{L}\p{N}*])'
  r'|\[\s*pause\s*[.!]?\s*\]|\(\s*pause\s*\)',
  caseSensitive: false,
  unicode: true,
);
final _section = RegExp(r'^(#+(\s|$)|##)');
final _hashtagLine = RegExp(r'^#[^\s#]+(\s+#[^\s#]+)*$', unicode: true);

/// Seconds a `[pause]` adds to the spoken time.
const pauseSeconds = 0.7;
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
final _digitsOnly = RegExp(r'^\d+$');

List<ScriptBlock> parseScript(String body) {
  final blocks = <ScriptBlock>[];
  for (final raw in body.split('\n')) {
    final line = raw.trim();
    if (line.isEmpty) {
      blocks.add(const ScriptBlock(BlockType.blank));
    } else if (_section.hasMatch(line)) {
      final title = line.replaceFirst(RegExp(r'^#+\s*'), '');
      // A lone "#" is not worth a section in the list.
      blocks.add(
        title.isEmpty
            ? const ScriptBlock(BlockType.blank)
            : ScriptBlock(BlockType.section, text: title),
      );
    } else if (_hashtagLine.hasMatch(line)) {
      blocks.add(ScriptBlock(BlockType.tags, text: line));
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
      spans.add(
        ScriptSpan(SpanType.text, _unescape(line.substring(i, m.start))),
      );
    }
    spans.add(
      m.group(2) != null
          ? ScriptSpan(SpanType.emphasis, _unescape(m.group(2)!))
          : const ScriptSpan(SpanType.pause),
    );
    i = m.end;
  }
  if (i < line.length) {
    spans.add(ScriptSpan(SpanType.text, _unescape(line.substring(i))));
  }
  return spans;
}

String _unescape(String text) => text.replaceAll(r'\*', '*');

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

/// Text for a post caption: what is spoken plus hashtag lines.
String captionText(String body) =>
    parseScript(body)
        .where((b) => b.type == BlockType.line || b.type == BlockType.tags)
        .map(
          (b) => b.type == BlockType.tags
              ? b.text
              : b.spans
                    .where((s) => s.type != SpanType.pause)
                    .map((s) => s.text)
                    .join(),
        )
        .join('\n');

/// Number of `[pause]` beats in spoken lines.
int pauseCount(String body) =>
    parseScript(body)
        .where((b) => b.type == BlockType.line)
        .expand((b) => b.spans)
        .where((s) => s.type == SpanType.pause)
        .length;

/// Seconds to say [body] at [wpm], pauses included.
double speakingSeconds(String body, double wpm) => wpm <= 0
    ? 0
    : countWords(spokenText(body)) / wpm * 60 + pauseCount(body) * pauseSeconds;

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
  // T3: "1299" or "2025" is several spoken words; count longer numbers as
  // about one word per two digits.
  var words = 0;
  for (final m in _words.allMatches(rest)) {
    final w = m.group(0)!;
    words += _digitsOnly.hasMatch(w) && w.length > 2 ? (w.length + 1) ~/ 2 : 1;
  }
  return (words +
          han * _hanWeight +
          kana * _kanaWeight +
          sea * _southeastAsianWeight)
      .round();
}

/// Whether [text] should be laid out right-to-left: most of its letters
/// are Hebrew, Arabic, Persian, Urdu… A line that starts with a brand name
/// ("iPhone الجديد…") still reads right-to-left.
bool isRtlText(String text) {
  var rtl = 0;
  var ltr = 0;
  bool? first;
  for (final m in _strong.allMatches(text)) {
    final isRtl = _rtl.hasMatch(m.group(0)!);
    first ??= isRtl;
    if (isRtl) {
      rtl++;
    } else {
      ltr++;
    }
  }
  // A tie goes to the first letter.
  return rtl == ltr ? (first ?? false) : rtl > ltr;
}

/// Section titles in order.
List<String> sectionTitles(String body) =>
    parseScript(body)
        .where((b) => b.type == BlockType.section)
        .map((b) => b.text)
        .toList();

/// Sentences with more words than [maxWords] — hard to say in one breath.
///
/// Thai, Lao, Khmer and Burmese have no full stop; a space marks the end of
/// a phrase there, so those sentences are split on spaces too.
int longSentenceCount(String body, {int maxWords = 25}) => spokenText(body)
    .split(RegExp(r'[.!?…。！？؟।۔]+|\n'))
    .expand((s) => _southeastAsian.hasMatch(s) ? s.split(RegExp(r'\s+')) : [s])
    .where((s) => countWords(s) > maxWords)
    .length;
