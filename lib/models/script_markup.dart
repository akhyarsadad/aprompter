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
final _words = RegExp(r"[\p{L}\p{N}'’]+", unicode: true);

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

int countWords(String text) => _words.allMatches(text).length;

/// Section titles in order.
List<String> sectionTitles(String body) =>
    parseScript(body)
        .where((b) => b.type == BlockType.section)
        .map((b) => b.text)
        .toList();

/// Sentences with more words than [maxWords] — hard to say in one breath.
int longSentenceCount(String body, {int maxWords = 25}) =>
    spokenText(body)
        .split(RegExp(r'[.!?…]+|\n'))
        .where((s) => countWords(s) > maxWords)
        .length;
