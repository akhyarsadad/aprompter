/// Scripts in from any notes app or text file, and out again as plain text.
///
/// Plain text, Markdown (Notion, Obsidian, Bear, Joplin), Word (.docx),
/// OpenDocument (.odt), RTF (TextEdit, WordPad), HTML (Google Docs, Apple
/// Notes, OneNote), Evernote (.enex), Google Keep exports and subtitles
/// (.srt, .vtt) all become APrompter markup — see `script_markup.dart`:
/// `# ` section cues, `*emphasis*`, `[pause]`, `// notes`, `#hashtags`.
///
/// Pure Dart: no widgets, no platform channels.
library;

import 'dart:convert';
import 'dart:io' as io show ZLibCodec;
import 'dart:isolate';
import 'dart:math' as math;
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:xml/xml.dart';

import '../models/script.dart';
import 'backup.dart';

/// Most text one import may bring in: 2 MB of characters.
const maxImportChars = 2 * 1024 * 1024;

/// Largest file read: 10 MB, the same limit the share sheet applies.
const maxImportBytes = 10 * 1024 * 1024;

/// A script read from a note or a file. [title] is null when nothing in the
/// source names it; the app then shows its default.
class ImportedScript {
  const ImportedScript({required this.title, required this.body});

  final String? title;
  final String body;

  @override
  String toString() => 'ImportedScript($title, ${body.length} chars)';
}

/// Why nothing could be imported.
enum ImportFailure {
  /// Not something that holds script text (photos, video, spreadsheets…).
  unsupportedFormat,

  /// A PDF: its text has to be copied and pasted.
  pdf,

  /// Old binary Word (.doc) or Apple Pages.
  binaryDocument,

  /// Nothing to read in it.
  empty,

  /// More than [maxImportChars] of text, or a file over [maxImportBytes].
  tooLarge,

  /// Only a link (a Notion or Google Docs share link), not the text.
  linkOnly,

  /// Damaged, or couldn't be decoded.
  unreadable,
}

/// What an import produced.
sealed class ImportResult {
  const ImportResult();
}

/// One or more new scripts (an Evernote export can hold many notes).
final class ImportedScripts extends ImportResult {
  const ImportedScripts(this.scripts);

  final List<ImportedScript> scripts;
}

/// An APrompter backup, to merge with `AppState.importScripts`.
final class ImportedBackup extends ImportResult {
  const ImportedBackup(this.scripts);

  final List<Script> scripts;
}

/// Nothing could be imported, because of [reason].
final class ImportFailed extends ImportResult {
  const ImportFailed(this.reason);

  final ImportFailure reason;
}

// ---------------------------------------------------------------------------
// Entry points

/// Imports text that was pasted or shared from another app. [title] is the
/// share's subject (Google Keep sends the note title there). With
/// [fromClipboard] a short first line may still name the script, but it is
/// never taken out of it: what someone copies is what they mean to read.
ImportResult importFromText(
  String text, {
  String? title,
  bool fromClipboard = false,
}) {
  // The 2 MB limit applies to the converted script (see _finish); this
  // only keeps a runaway paste from using up memory.
  if (text.length > maxImportBytes) {
    return const ImportFailed(ImportFailure.tooLarge);
  }
  if (normalizeScriptText(text).isEmpty) {
    return const ImportFailed(ImportFailure.empty);
  }
  try {
    final format =
        _sniff(text) ?? (_looksLikeMarkdown(text) ? _Format.markdown : null);
    return _importText(
      text,
      format: format ?? _Format.plain,
      explicitTitle: title,
      pasted: true,
      keepFirstLine: fromClipboard,
    );
  } catch (_) {
    return const ImportFailed(ImportFailure.unreadable);
  }
}

/// Imports a file picked in the app, shared to it or opened with it.
/// [name] is the file name with its extension; [title] is a share subject.
ImportResult importFromFile(
  String name,
  List<int> bytes, {
  String? mimeType,
  String? title,
}) => _importFile(name, bytes, mimeType: mimeType, title: title, depth: 0);

/// Files from this size on are read on a background isolate.
const _backgroundBytes = 64 * 1024;

/// [importFromFile], on a background isolate for big files so the screen
/// keeps moving while a long document is read.
Future<ImportResult> importFromFileAsync(
  String name,
  Uint8List bytes, {
  String? mimeType,
  String? title,
}) async {
  if (bytes.length < _backgroundBytes) {
    return importFromFile(name, bytes, mimeType: mimeType, title: title);
  }
  try {
    return await Isolate.run(
      () => importFromFile(name, bytes, mimeType: mimeType, title: title),
    );
  } catch (_) {
    return importFromFile(name, bytes, mimeType: mimeType, title: title);
  }
}

/// [importFromText], on a background isolate for very long text.
Future<ImportResult> importFromTextAsync(
  String text, {
  String? title,
  bool fromClipboard = false,
}) async {
  ImportResult run() =>
      importFromText(text, title: title, fromClipboard: fromClipboard);
  if (text.length < _backgroundBytes) return run();
  try {
    return await Isolate.run(run);
  } catch (_) {
    return run();
  }
}

// ---------------------------------------------------------------------------
// Export

/// A script as a text file: the title, a blank line, then the body. Importing
/// the file gives the same title and body back.
String scriptAsText(String title, String body) {
  final t = title.trim();
  final b = body.trim();
  return t.isEmpty ? '$b\n' : '$t\n\n$b\n';
}

/// A `.txt` file name for [title] that every phone and computer accepts.
/// [fallback] names a script without a title.
String textFileName(String title, {required String fallback}) {
  String clean(String s) {
    var name = s
        .replaceAll(RegExp(r'[\\/:*?"<>|\x00-\x1F\x7F]'), ' ')
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .replaceAll(RegExp(r'^[.\s]+|[.\s]+$'), '');
    // At most 80 characters, and 200 bytes of UTF-8: phones and computers
    // allow 255 bytes per file name, and emoji or CJK take 3–4 bytes each.
    final runes = name.runes.toList();
    var keep = 0;
    var bytes = 0;
    for (final r in runes) {
      final size = r < 0x80 ? 1 : (r < 0x800 ? 2 : (r < 0x10000 ? 3 : 4));
      if (keep == 80 || bytes + size > 200) break;
      bytes += size;
      keep++;
    }
    if (keep < runes.length) {
      final cut = runes.sublist(0, keep);
      // Don't end in the middle of an emoji: a joiner or half a flag.
      bool flag(int r) => r >= 0x1F1E6 && r <= 0x1F1FF;
      while (cut.isNotEmpty && cut.last == 0x200D) {
        cut.removeLast();
      }
      if (cut.reversed.takeWhile(flag).length.isOdd) cut.removeLast();
      name = String.fromCharCodes(cut).replaceAll(RegExp(r'[.\s]+$'), '');
    }
    return name;
  }

  var name = clean(title);
  if (name.isEmpty) name = clean(fallback);
  if (name.isEmpty) name = 'Script';
  if (RegExp(
    r'^(con|prn|aux|nul|com\d|lpt\d)$',
    caseSensitive: false,
  ).hasMatch(name)) {
    name = '${name}_';
  }
  return '$name.txt';
}

// ---------------------------------------------------------------------------
// Clean-up shared by every source and by the editor's Paste button

/// Characters that only mark a list item: the bullets Word, Docs, Notes and
/// RTF lists put in front of each item (Word's Symbol-font bullet comes out
/// as `·` or a private-use character).
const _bulletGlyphs = '•◦▪▫●○■□‣⁃·\uF0B7\uF0A7';

/// Windows and Unicode line ends, zero-width spaces, byte-order marks, soft
/// hyphens, non-breaking spaces, tabs and control characters. Zero-width
/// joiners stay: Persian, Indic scripts and emoji need them.
String _cleanInvisibles(String text) => text
    .replaceAll('\r\n', '\n')
    .replaceAll(RegExp('[\r\u2028\u2029\u000B\u000C\u0085]'), '\n')
    .replaceAll(RegExp('[\u200B\u2060\uFEFF\u00AD]'), '')
    .replaceAll(RegExp('[\u00A0\u202F\t]'), ' ')
    .replaceAll(RegExp('[\u0000-\u0008\u000E-\u001F\u007F-\u009F]'), '');

/// Removes what pasting from Google Docs, Word, Notes or WhatsApp brings
/// along into the editor: the clutter [_cleanInvisibles] removes, list
/// bullets and dashes, and spaces at line ends.
String cleanPastedText(String text) =>
    _cleanInvisibles(text)
        .replaceAll(RegExp('^[ ]*[$_bulletGlyphs–—-][ ]+', multiLine: true), '')
        .replaceAll(RegExp(r'[ ]+\n'), '\n');

/// Clean-up for imported scripts: like [cleanPastedText], but a dash at the
/// start of a line stays — it is dialogue (Russian, Spanish, French…) or a
/// list the writer typed, and exporting then importing must give it back.
/// Then at most one blank line in a row and no blank lines or spaces around
/// the whole text.
String normalizeScriptText(String text) =>
    _cleanInvisibles(text)
        .replaceAll(RegExp('^[ ]*[$_bulletGlyphs][ ]+', multiLine: true), '')
        .replaceAll(RegExp(r'[ ]+\n'), '\n')
        .replaceAll(RegExp(r'\n{3,}'), '\n\n')
        .trim();

// ---------------------------------------------------------------------------
// Bytes to text

/// Decodes a text file: UTF-8 (with or without a byte-order mark), UTF-16
/// (with a byte-order mark, or recognised by its shape), UTF-8 with a few
/// stray Windows-1252 bytes, otherwise Windows-1252, the encoding of old
/// Windows text files.
String decodeText(List<int> bytes) {
  if (_startsWith(bytes, const [0xEF, 0xBB, 0xBF])) {
    return utf8.decode(bytes.sublist(3), allowMalformed: true);
  }
  if (_startsWith(bytes, const [0xFF, 0xFE])) {
    return _utf16(bytes, 2, littleEndian: true);
  }
  if (_startsWith(bytes, const [0xFE, 0xFF])) {
    return _utf16(bytes, 2, littleEndian: false);
  }
  final utf16 = _utf16WithoutBom(bytes);
  if (utf16 != null) return utf16;
  try {
    return utf8.decode(bytes);
  } on FormatException {
    return _mostlyUtf8(bytes) ?? _singleByte(bytes, _cp1252);
  }
}

String _utf16(
  List<int> bytes,
  int start, {
  required bool littleEndian,
  int? end,
}) {
  final units = <int>[];
  final stop = end ?? bytes.length;
  for (var i = start; i + 1 < stop; i += 2) {
    units.add(
      littleEndian
          ? bytes[i] | (bytes[i + 1] << 8)
          : (bytes[i] << 8) | bytes[i + 1],
    );
  }
  return String.fromCharCodes(units);
}

/// UTF-16 saved without a byte-order mark. Read one byte at a time it is
/// full of control characters and zeros (Latin, Cyrillic: every other byte
/// is 0x00 or 0x04); read as UTF-16 it is ordinary text with line breaks
/// or spaces in it. Plain text read as UTF-16 looks like Chinese, so it is
/// only tried when the bytes don't read as text.
String? _utf16WithoutBom(List<int> bytes) {
  final n = math.min(bytes.length, 8192) & ~1;
  if (n < 4) return null;
  var controls = 0;
  for (var i = 0; i < n; i++) {
    final b = bytes[i];
    if (b < 0x09 || (b > 0x0D && b < 0x20)) controls++;
  }
  if (controls * 100 <= n) return null;
  String? best;
  var bestBad = n;
  for (final littleEndian in const [true, false]) {
    final sample = _utf16(bytes, 0, littleEndian: littleEndian, end: n);
    var spaces = 0;
    var bad = 0;
    for (var i = 0; i < sample.length; i++) {
      final c = sample.codeUnitAt(i);
      if (c == 0x0A || c == 0x0D || c == 0x20 || c == 0x09 || c == 0x3000) {
        spaces++;
      } else if (c >= 0xD800 && c < 0xDC00 && i + 1 < sample.length) {
        final next = sample.codeUnitAt(i + 1);
        if (next >= 0xDC00 && next < 0xE000) {
          i++;
        } else {
          bad++;
        }
      } else if (c < 0x20 ||
          (c >= 0x7F && c < 0xA0) ||
          (c >= 0xD800 && c < 0xF900) || // lone surrogates, private use
          c >= 0xFFFE) {
        bad++;
      }
    }
    if (spaces > 0 && bad * 50 <= sample.length && bad < bestBad) {
      best = littleEndian ? 'le' : 'be';
      bestBad = bad;
    }
  }
  if (best == null) return null;
  return _utf16(bytes, 0, littleEndian: best == 'le');
}

/// UTF-8 with a few bytes that aren't (a Windows-1252 dash or quote pasted
/// into a UTF-8 file): those bytes are read as Windows-1252 and the rest
/// stays UTF-8. Null when the file isn't mostly UTF-8.
String? _mostlyUtf8(List<int> bytes) {
  final out = StringBuffer();
  var valid = 0;
  var invalid = 0;
  var i = 0;
  while (i < bytes.length) {
    final b = bytes[i];
    if (b < 0x80) {
      out.writeCharCode(b);
      i++;
      continue;
    }
    final len = b >= 0xC2 && b <= 0xDF
        ? 2
        : b >= 0xE0 && b <= 0xEF
        ? 3
        : b >= 0xF0 && b <= 0xF4
        ? 4
        : 0;
    var cp = b & (len == 2 ? 0x1F : (len == 3 ? 0x0F : 0x07));
    var ok = len > 0 && i + len <= bytes.length;
    for (var k = 1; ok && k < len; k++) {
      final c = bytes[i + k];
      if (c & 0xC0 != 0x80) {
        ok = false;
      } else {
        cp = (cp << 6) | (c & 0x3F);
      }
    }
    if (ok) {
      final overlong = (len == 3 && cp < 0x800) || (len == 4 && cp < 0x10000);
      if (overlong || (cp >= 0xD800 && cp < 0xE000) || cp > 0x10FFFF) {
        ok = false;
      }
    }
    if (ok) {
      out.writeCharCode(cp);
      valid++;
      i += len;
    } else {
      out.writeCharCode(_cp1252(b));
      invalid++;
      i++;
    }
  }
  return valid > 0 && invalid <= valid ? out.toString() : null;
}

String _singleByte(List<int> bytes, int Function(int) map) {
  final out = StringBuffer();
  for (final b in bytes) {
    out.writeCharCode(map(b));
  }
  return out.toString();
}

// Windows-1252: 0x80–0x9F are typographic characters, not controls. The five
// unassigned bytes keep their value (and are cleaned up as controls).
const _cp1252High = [
  0x20AC, 0x81, 0x201A, 0x0192, 0x201E, 0x2026, 0x2020, 0x2021, //
  0x02C6, 0x2030, 0x0160, 0x2039, 0x0152, 0x8D, 0x017D, 0x8F,
  0x90, 0x2018, 0x2019, 0x201C, 0x201D, 0x2022, 0x2013, 0x2014,
  0x02DC, 0x2122, 0x0161, 0x203A, 0x0153, 0x9D, 0x017E, 0x0178,
];

int _cp1252(int b) => b >= 0x80 && b < 0xA0 ? _cp1252High[b - 0x80] : b;

// Windows-1251 (Cyrillic), used by WordPad on Russian and Ukrainian Windows.
const _cp1251High = [
  0x0402, 0x0403, 0x201A, 0x0453, 0x201E, 0x2026, 0x2020, 0x2021, //
  0x20AC, 0x2030, 0x0409, 0x2039, 0x040A, 0x040C, 0x040B, 0x040F,
  0x0452, 0x2018, 0x2019, 0x201C, 0x201D, 0x2022, 0x2013, 0x2014,
  0x98, 0x2122, 0x0459, 0x203A, 0x045A, 0x045C, 0x045B, 0x045F,
  0x00A0, 0x040E, 0x045E, 0x0408, 0x00A4, 0x0490, 0x00A6, 0x00A7,
  0x0401, 0x00A9, 0x0404, 0x00AB, 0x00AC, 0x00AD, 0x00AE, 0x0407,
  0x00B0, 0x00B1, 0x0406, 0x0456, 0x0491, 0x00B5, 0x00B6, 0x00B7,
  0x0451, 0x2116, 0x0454, 0x00BB, 0x0458, 0x0405, 0x0455, 0x0457,
];

int _cp1251(int b) => b < 0x80
    ? b
    : b < 0xC0
    ? _cp1251High[b - 0x80]
    : 0x0410 + (b - 0xC0);

/// More Windows code pages for bytes 0x80–0xFF, as RTF from WordPad and
/// Word uses them (`\ansicpg`, `\fcharset`). Bytes a code page leaves
/// undefined keep their value and are cleaned up as control characters.
const _codePages = {
  1250:
      '€\u0081‚\u0083„…†‡\u0088‰Š‹ŚŤŽŹ\u0090‘’“”•–—\u0098™š›śťžź'
      '\u00A0ˇ˘Ł¤Ą¦§¨©Ş«¬\u00AD®Ż°±˛ł´µ¶·¸ąş»Ľ˝ľżŔÁÂĂÄĹĆÇČÉĘËĚÍÎĎĐŃ'
      'ŇÓÔŐÖ×ŘŮÚŰÜÝŢßŕáâăäĺćçčéęëěíîďđńňóôőö÷řůúűüýţ˙',
  1253:
      '€\u0081‚ƒ„…†‡\u0088‰\u008A‹\u008C\u008D\u008E\u008F\u0090‘’“'
      '”•–—\u0098™\u009A›\u009C\u009D\u009E\u009F\u00A0΅Ά£¤¥¦§¨©ª«¬'
      '\u00AD®―°±²³΄µ¶·ΈΉΊ»Ό½ΎΏΐΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡÒΣΤΥΦΧΨΩΪΫάέήίΰαβγ'
      'δεζηθικλμνξοπρςστυφχψωϊϋόύώÿ',
  1254:
      '€\u0081‚ƒ„…†‡ˆ‰Š‹Œ\u008D\u008E\u008F\u0090‘’“”•–—˜™š›œ\u009D'
      '\u009EŸ\u00A0¡¢£¤¥¦§¨©ª«¬\u00AD®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊ'
      'ËÌÍÎÏĞÑÒÓÔÕÖ×ØÙÚÛÜİŞßàáâãäåæçèéêëìíîïğñòóôõö÷øùúûüışÿ',
  1255:
      '€\u0081‚ƒ„…†‡ˆ‰\u008A‹\u008C\u008D\u008E\u008F\u0090‘’“”•–—˜'
      '™\u009A›\u009C\u009D\u009E\u009F\u00A0¡¢£₪¥¦§¨©×«¬\u00AD®¯°±'
      '²³´µ¶·¸¹÷»¼½¾¿\u05B0\u05B1\u05B2\u05B3\u05B4\u05B5\u05B6'
      '\u05B7\u05B8\u05B9Ê\u05BB\u05BC\u05BD־\u05BF׀\u05C1\u05C2׃װױ'
      'ײ׳״ÙÚÛÜÝÞßאבגדהוזחטיךכלםמןנסעףפץצקרשתûü\u200E\u200Fÿ',
  1256:
      '€پ‚ƒ„…†‡ˆ‰ٹ‹Œچژڈگ‘’“”•–—ک™ڑ›œ\u200C\u200Dں\u00A0،¢£¤¥¦§¨©ھ«¬'
      '\u00AD®¯°±²³´µ¶·¸¹؛»¼½¾؟ہءآأؤإئابةتثجحخدذرزسشصض×طظعغـفقكàلâم'
      'نهوçèéêëىيîï\u064B\u064C\u064D\u064Eô\u064F\u0650÷\u0651ù'
      '\u0652ûü\u200E\u200Fے',
  1257:
      '€\u0081‚\u0083„…†‡\u0088‰\u008A‹\u008C¨ˇ¸\u0090‘’“”•–—\u0098'
      '™\u009A›\u009C¯˛\u009F\u00A0¡¢£¤¥¦§Ø©Ŗ«¬\u00AD®Æ°±²³´µ¶·ø¹ŗ»'
      '¼½¾æĄĮĀĆÄÅĘĒČÉŹĖĢĶĪĻŠŃŅÓŌÕÖ×ŲŁŚŪÜŻŽßąįāćäåęēčéźėģķīļšńņóōõö÷'
      'ųłśūüżž˙',
  1258:
      '€\u0081‚ƒ„…†‡ˆ‰\u008A‹Œ\u008D\u008E\u008F\u0090‘’“”•–—˜™'
      '\u009A›œ\u009D\u009EŸ\u00A0¡¢£¤¥¦§¨©ª«¬\u00AD®¯°±²³´µ¶·¸¹º»¼'
      '½¾¿ÀÁÂĂÄÅÆÇÈÉÊË\u0300ÍÎÏĐÑ\u0309ÓÔƠÖ×ØÙÚÛÜƯ\u0303ßàáâăäåæçèé'
      'êë\u0301íîïđñ\u0323óôơö÷øùúûüư₫ÿ',
  874:
      '€\u0081\u0082\u0083\u0084…\u0086\u0087\u0088\u0089\u008A'
      '\u008B\u008C\u008D\u008E\u008F\u0090‘’“”•–—\u0098\u0099'
      '\u009A\u009B\u009C\u009D\u009E\u009F\u00A0กขฃคฅฆงจฉชซฌญฎฏฐฑฒ'
      'ณดตถทธนบปผฝพฟภมยรฤลฦวศษสหฬอฮฯะ\u0E31าำ\u0E34\u0E35\u0E36'
      '\u0E37\u0E38\u0E39\u0E3AÛÜÝÞ฿เแโใไๅๆ\u0E47\u0E48\u0E49\u0E4A'
      '\u0E4B\u0E4C\u0E4D\u0E4E๏๐๑๒๓๔๕๖๗๘๙๚๛üýþÿ',
};

/// The byte-to-character map of Windows code page [cp]; null for the
/// Chinese, Japanese and Korean double-byte code pages, which can't be read
/// a byte at a time.
int Function(int)? _codePage(int cp) {
  switch (cp) {
    case 1252:
      return _cp1252;
    case 1251:
      return _cp1251;
    case 932 || 936 || 949 || 950 || 1361:
      return null;
  }
  final table = _codePages[cp];
  if (table == null) return _cp1252;
  return (b) => b < 0x80 ? b : table.codeUnitAt(b - 0x80);
}

/// RTF `\fcharset` values and their code pages. ANSI (0) and default (1)
/// follow the document's `\ansicpg`; symbol fonts (2) are -1.
const _charsetCodePages = {
  2: -1, 128: 932, 129: 949, 130: 1361, 134: 936, 136: 950, 161: 1253, //
  162: 1254, 163: 1258, 177: 1255, 178: 1256, 186: 1257, 204: 1251, 222: 874,
  238: 1250,
};

/// Mostly control characters: a binary file, not text. A few zero bytes
/// (padding, a damaged spot) don't make a text file binary.
bool _looksBinary(String text) {
  final n = math.min(text.length, 8192);
  var bad = 0;
  for (var i = 0; i < n; i++) {
    final c = text.codeUnitAt(i);
    final control =
        c < 0x20 &&
        c != 0x09 &&
        c != 0x0A &&
        c != 0x0B &&
        c != 0x0C &&
        c != 0x0D;
    if (control || c == 0xFFFD) bad++;
  }
  return n > 0 && bad > n / 20;
}

// ---------------------------------------------------------------------------
// Recognising formats

enum _Format { plain, markdown, html, rtf, enex, srt, vtt, mht }

const _markdownExt = {
  'md',
  'markdown',
  'mdown',
  'mkd',
  'mkdn',
  'mdwn',
  'mdtxt',
  'mdtext',
};
const _plainExt = {'txt', 'text', 'fountain', 'log', 'asc'};
const _htmlExt = {'html', 'htm', 'xhtml', 'xht'};
const _wordLikeExt = {'doc', 'dot', 'wps'};
const _mediaExt = {
  'jpg', 'jpeg', 'png', 'gif', 'heic', 'heif', 'webp', 'bmp', 'tif', //
  'tiff', 'svg', 'mp4', 'mov', 'm4v', 'avi', 'mkv', 'webm', '3gp', 'mp3',
  'm4a', 'aac', 'wav', 'ogg', 'opus', 'flac', 'amr', 'xls', 'xlsx', 'ppt',
  'pptx', 'key', 'numbers', 'epub', 'apk', 'exe', 'dmg', 'csv', 'ods', 'odp',
};

/// File types read inside a zip of notes (Notion, Bear, Obsidian exports).
const _notesZipExt = {
  ..._markdownExt,
  ..._plainExt,
  ..._htmlExt,
  'rtf',
  'enex',
  'srt',
  'vtt',
  'docx',
  'odt',
  'mht',
  'mhtml',
  'zip',
};

String _extensionOf(String name) {
  final base = name.split(RegExp(r'[/\\]')).last;
  final dot = base.lastIndexOf('.');
  return dot <= 0 ? '' : base.substring(dot + 1).toLowerCase();
}

_Format? _formatFor(String ext, String mime) {
  if (_markdownExt.contains(ext)) return _Format.markdown;
  if (_plainExt.contains(ext)) return _Format.plain;
  if (_htmlExt.contains(ext)) return _Format.html;
  switch (ext) {
    case 'rtf':
      return _Format.rtf;
    case 'srt':
      return _Format.srt;
    case 'vtt':
      return _Format.vtt;
    case 'enex':
      return _Format.enex;
    case 'mht' || 'mhtml':
      return _Format.mht;
  }
  switch (mime) {
    case 'text/markdown' || 'text/x-markdown':
      return _Format.markdown;
    case 'text/html' || 'application/xhtml+xml':
      return _Format.html;
    case 'text/rtf' || 'application/rtf':
      return _Format.rtf;
    case 'text/vtt':
      return _Format.vtt;
    case 'application/x-subrip' || 'text/srt':
      return _Format.srt;
    case 'multipart/related' || 'message/rfc822' || 'application/x-mimearchive':
      return _Format.mht;
    case 'text/plain':
      return _Format.plain;
  }
  return null;
}

final _srtStart = RegExp(
  r'^\s*\d+[ \t]*\r?\n[ \t]*(\d{1,2}:)?\d{1,2}:\d{2}[,.]\d{1,3}[ \t]*-->',
);

/// The start of a whole HTML page.
final _htmlPage = RegExp(r'^<(!doctype html|html|head|body)\b');

/// The start of an HTML fragment (Apple Notes, a clipboard).
final _htmlFragment = RegExp(
  r'^<(meta|div|p|span|h[1-6]|table|ul|ol|br|b|strong|font|style)\b',
);

/// Formats recognised from the text itself, whatever the file is called.
/// [plainFile] is a file that says it is plain text: only a whole HTML page
/// overrides that, not a note that happens to start with "<p>".
_Format? _sniff(String text, {bool allowHtml = true, bool plainFile = false}) {
  final head = text
      .substring(0, math.min(text.length, 4096))
      .replaceFirst('\uFEFF', '')
      .trimLeft();
  final lower = head.toLowerCase();
  if (lower.startsWith(r'{\rtf')) return _Format.rtf;
  // A note titled "WEBVTT tips" is not a subtitle file: one has cues.
  if (head.startsWith('WEBVTT') && _cueTime.hasMatch(text)) {
    return _Format.vtt;
  }
  if ((lower.startsWith('<?xml') ||
          lower.startsWith('<!doctype en-export') ||
          lower.startsWith('<en-export')) &&
      lower.contains('<en-export')) {
    return _Format.enex;
  }
  if ((lower.startsWith('mime-version:') || lower.startsWith('from:')) &&
      lower.contains('multipart/related')) {
    return _Format.mht;
  }
  if (allowHtml && _looksLikeHtml(text, lower, plainFile: plainFile)) {
    return _Format.html;
  }
  if (_srtStart.hasMatch(head)) return _Format.srt;
  return null;
}

bool _looksLikeHtml(String text, String lower, {required bool plainFile}) {
  if (_htmlPage.hasMatch(lower) ||
      (lower.startsWith('<?xml') && lower.contains('<html'))) {
    return true;
  }
  if (plainFile) return false;
  final tag = _htmlFragment.firstMatch(lower)?[1];
  if (tag == null) return false;
  // "<b> is the bold tag" in a note is text: HTML closes what it opens.
  final close = tag == 'br' || tag == 'meta'
      ? RegExp(r'</[a-z]', caseSensitive: false)
      : RegExp('</$tag\\s*>', caseSensitive: false);
  return close.hasMatch(text);
}

final _tableSeparator = RegExp(r'^\|?\s*:?-+:?\s*(\|\s*:?-+:?\s*)*\|?\s*$');

/// Strong signs of Markdown in shared or pasted text — things APrompter
/// markup would otherwise show as clutter.
bool _looksLikeMarkdown(String text) {
  final fm = _frontMatter.firstMatch(text);
  if (fm != null && _isFrontMatter(fm, fromFile: false)) return true;
  final signals = [
    if (text.contains(']('))
      RegExp(r'!?\[[^\]\n]{0,500}\]\((https?:|mailto:|/|\.|#)[^)\n]*\)'),
    if (text.contains(']]')) RegExp(r'\[\[[^\]\n]{1,500}\]\]'),
    RegExp(r'^[ \t]*[-*+] \[[ xX]\] ', multiLine: true),
    RegExp(r'^[ \t]*(```|~~~)', multiLine: true),
    RegExp(r'^\S[^\n]*\n=+[ \t]*$', multiLine: true),
  ];
  if (signals.any((s) => s.hasMatch(text))) return true;
  return text
      .split('\n')
      .any((l) => l.contains('|') && l.contains('-') && _isTableSeparator(l));
}

bool _isTableSeparator(String line) {
  final t = line.trim();
  return t.contains('|') && t.contains('-') && _tableSeparator.hasMatch(t);
}

// ---------------------------------------------------------------------------
// Files

ImportResult _importFile(
  String name,
  List<int> bytes, {
  String? mimeType,
  String? title,
  required int depth,
}) {
  if (bytes.isEmpty) return const ImportFailed(ImportFailure.empty);
  if (bytes.length > maxImportBytes) {
    return const ImportFailed(ImportFailure.tooLarge);
  }
  final ext = _extensionOf(name);
  final mime = (mimeType ?? '').split(';').first.trim().toLowerCase();
  try {
    final binary = _binaryFile(name, bytes, ext, mime, title, depth);
    if (binary != null) return binary;

    // Zero bytes padding the end of a file are not part of the text.
    final text = decodeText(bytes).replaceFirst(RegExp('\u0000+\$'), '');
    if (_looksBinary(text)) {
      if (_wordLikeExt.contains(ext) || mime == 'application/msword') {
        return const ImportFailed(ImportFailure.binaryDocument);
      }
      return ImportFailed(
        _formatFor(ext, mime) != null
            ? ImportFailure.unreadable
            : ImportFailure.unsupportedFormat,
      );
    }
    // The 2 MB limit is for the script's text, checked once it is converted:
    // an Evernote note with a photo or a web page with an embedded image is
    // much bigger than its text.

    if (ext == 'json' || mime == 'application/json') {
      final backup = _backupIn(text);
      if (backup != null) return ImportedBackup(backup);
      final keep = _fromKeepJson(text);
      if (keep == null) {
        return const ImportFailed(ImportFailure.unsupportedFormat);
      }
      return _finish(
        keep,
        explicitTitle: title,
        fileName: name,
        pasted: false,
        converted: false,
      );
    }

    final byName = _formatFor(ext, mime);
    final sniffed = _sniff(
      text,
      allowHtml: byName != _Format.markdown,
      plainFile: byName == _Format.plain,
    );
    if (sniffed == null &&
        byName == null &&
        text.trimLeft().replaceFirst('\uFEFF', '').startsWith('<?xml')) {
      // Some other XML document (a spreadsheet, a plist, a screenplay app's
      // file): its tags would end up in the script.
      return const ImportFailed(ImportFailure.unsupportedFormat);
    }
    final format =
        sniffed ??
        byName ??
        (_looksLikeMarkdown(text) ? _Format.markdown : _Format.plain);
    return _importText(
      text,
      format: format,
      explicitTitle: title,
      fileName: name,
      pasted: false,
    );
  } catch (_) {
    return const ImportFailed(ImportFailure.unreadable);
  }
}

bool _startsWith(List<int> bytes, List<int> sig, [int at = 0]) {
  if (bytes.length < at + sig.length) return false;
  for (var i = 0; i < sig.length; i++) {
    if (bytes[at + i] != sig[i]) return false;
  }
  return true;
}

bool _isMedia(List<int> b) =>
    _startsWith(b, const [0x89, 0x50, 0x4E, 0x47]) || // PNG
    _startsWith(b, const [0xFF, 0xD8, 0xFF]) || // JPEG
    _startsWith(b, ascii.encode('GIF8')) ||
    (_startsWith(b, ascii.encode('RIFF')) &&
        (_startsWith(b, ascii.encode('WEBP'), 8) ||
            _startsWith(b, ascii.encode('WAVE'), 8) ||
            _startsWith(b, ascii.encode('AVI '), 8))) ||
    _startsWith(b, ascii.encode('ftyp'), 4) || // MP4, MOV, HEIC, M4A
    _startsWith(b, ascii.encode('ID3')) || // MP3
    _startsWith(b, const [0xFF, 0xFB]) ||
    _startsWith(b, ascii.encode('OggS')) ||
    _startsWith(b, ascii.encode('fLaC')) ||
    _startsWith(b, const [0x1A, 0x45, 0xDF, 0xA3]) || // MKV, WebM
    _startsWith(b, const [0x49, 0x49, 0x2A, 0x00]) || // TIFF
    _startsWith(b, const [0x4D, 0x4D, 0x00, 0x2A]) ||
    _startsWith(b, ascii.encode('#!AMR'));

/// PDFs, Office, zip-based documents and media, recognised by their bytes
/// (then by name). Null for anything that may be text.
ImportResult? _binaryFile(
  String name,
  List<int> bytes,
  String ext,
  String mime,
  String? title,
  int depth,
) {
  final head = bytes.length < 1024 ? bytes : bytes.sublist(0, 1024);
  final pdfAt = latin1.decode(head).indexOf('%PDF-');
  if (pdfAt == 0 ||
      (pdfAt > 0 && (ext == 'pdf' || mime == 'application/pdf'))) {
    return const ImportFailed(ImportFailure.pdf);
  }
  if (_startsWith(bytes, const [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1])) {
    // Compound file: old Word, Excel, PowerPoint or Outlook.
    return ImportFailed(
      _wordLikeExt.contains(ext) || ext.isEmpty || mime == 'application/msword'
          ? ImportFailure.binaryDocument
          : ImportFailure.unsupportedFormat,
    );
  }
  if (_startsWith(bytes, const [0x50, 0x4B, 0x03, 0x04]) ||
      _startsWith(bytes, const [0x50, 0x4B, 0x05, 0x06])) {
    return _fromZip(name, bytes, ext, title, depth);
  }
  if (_isMedia(bytes)) {
    return const ImportFailed(ImportFailure.unsupportedFormat);
  }
  if (ext == 'pdf' || mime == 'application/pdf') {
    return const ImportFailed(ImportFailure.pdf);
  }
  if (ext == 'pages' || mime == 'application/vnd.apple.pages') {
    return const ImportFailed(ImportFailure.binaryDocument);
  }
  if (_mediaExt.contains(ext) ||
      mime.startsWith('image/') ||
      mime.startsWith('audio/') ||
      mime.startsWith('video/')) {
    return const ImportFailed(ImportFailure.unsupportedFormat);
  }
  return null;
}

/// Largest single document inside a zip (Word and OpenDocument XML).
const _maxXmlBytes = 32 * 1024 * 1024;

ImportResult _fromZip(
  String name,
  List<int> bytes,
  String ext,
  String? title,
  int depth,
) {
  final Archive zip;
  try {
    if (_hasHugeLink(bytes)) return const ImportFailed(ImportFailure.tooLarge);
    zip = ZipDecoder().decodeBytes(bytes);
  } catch (_) {
    return const ImportFailed(ImportFailure.unreadable);
  }
  if (zip.files.isEmpty) return const ImportFailed(ImportFailure.unreadable);
  String? entryText(String path) {
    final file = zip.findFile(path);
    if (file == null || !file.isFile) return null;
    return decodeText(_readEntry(file, _maxXmlBytes));
  }

  try {
    final odfMime = (entryText('mimetype') ?? '').trim();
    if (zip.findFile('word/document.xml') != null) {
      final doc = _fromDocx(
        entryText('word/document.xml')!,
        entryText('word/styles.xml'),
      );
      return _finish(
        doc,
        explicitTitle: title,
        fileName: name,
        pasted: false,
        converted: true,
      );
    }
    if (odfMime.startsWith('application/vnd.oasis.opendocument.text') ||
        (zip.findFile('content.xml') != null &&
            (ext == 'odt' || ext == 'ott'))) {
      final doc = _fromOdt(entryText('content.xml') ?? '');
      return _finish(
        doc,
        explicitTitle: title,
        fileName: name,
        pasted: false,
        converted: true,
      );
    }
    if (ext == 'pages' ||
        zip.findFile('Index/Document.iwa') != null ||
        (zip.findFile('index.xml') != null && ext == 'pages')) {
      return const ImportFailed(ImportFailure.binaryDocument);
    }
    if (odfMime.isNotEmpty ||
        zip.findFile('xl/workbook.xml') != null ||
        zip.findFile('ppt/presentation.xml') != null ||
        zip.files.any((f) => f.name.startsWith('Index/')) ||
        _mediaExt.contains(ext)) {
      return const ImportFailed(ImportFailure.unsupportedFormat);
    }
    if (depth > 1) return const ImportFailed(ImportFailure.unsupportedFormat);
    return _fromNotesZip(zip, name, depth);
  } on _TooLarge {
    return const ImportFailed(ImportFailure.tooLarge);
  } catch (_) {
    return const ImportFailed(ImportFailure.unreadable);
  }
}

class _TooLarge implements Exception {
  const _TooLarge();
}

/// Opening a zip already inflates its symbolic links, with no limit; a real
/// link is a short path, so a zip with a big one is turned away first.
bool _hasHugeLink(List<int> bytes) {
  final dir = ZipDirectory()..read(InputMemoryStream(bytes));
  return dir.fileHeaders.any(
    (h) =>
        h.versionMadeBy >> 8 == 3 &&
        (h.externalFileAttributes >> 16) & 0xF000 == 0xA000 &&
        h.compressedSize > 4096,
  );
}

/// The content of [file] in a zip, at most [limit] bytes. The size a zip
/// gives for a file can't be trusted — a crafted one says 1 KB and inflates
/// to gigabytes — so inflating itself stops at the limit ([_TooLarge]).
Uint8List _readEntry(ArchiveFile file, int limit) {
  if (file.size > limit) throw const _TooLarge();
  final raw = file.rawContent;
  if (raw == null) return Uint8List(0);
  final data = raw.getStream(decompress: false).toUint8List();
  switch (file.compression) {
    case CompressionType.deflate:
      return _inflate(data, limit);
    case CompressionType.none || null:
      if (data.length > limit) throw const _TooLarge();
      return data;
    case CompressionType.bzip2:
      // No notes app, Word or LibreOffice writes these.
      throw const FormatException('bzip2 in a zip');
  }
}

/// Raw deflate [data], inflated a piece at a time up to [limit] bytes.
Uint8List _inflate(Uint8List data, int limit) {
  final out = _CappedSink(limit);
  final input = io.ZLibCodec(raw: true).decoder.startChunkedConversion(out);
  const piece = 64 * 1024;
  for (var i = 0; i < data.length; i += piece) {
    input.addSlice(data, i, math.min(i + piece, data.length), false);
  }
  input.close();
  return out.bytes.takeBytes();
}

/// Collects inflated bytes; one past the limit throws [_TooLarge], which
/// stops the inflating.
class _CappedSink implements Sink<List<int>> {
  _CappedSink(this.limit);

  final int limit;
  final bytes = BytesBuilder(copy: false);

  @override
  void add(List<int> chunk) {
    if (bytes.length + chunk.length > limit) throw const _TooLarge();
    bytes.add(chunk);
  }

  @override
  void close() {}
}

/// A zip of notes — a Notion, Bear or Obsidian export, a folder sent from
/// Files: every note in it becomes a script.
ImportResult _fromNotesZip(Archive zip, String zipName, int depth) {
  final scripts = <ImportedScript>[];
  ImportFailure? failure;
  var budget = 64 * 1024 * 1024;
  for (final file in zip.files) {
    if (!file.isFile) continue;
    final path = file.name.replaceAll('\\', '/');
    final parts = path.split('/');
    if (parts.first == '__MACOSX' || parts.any((p) => p.startsWith('.'))) {
      continue;
    }
    final ext = _extensionOf(path);
    if (!_notesZipExt.contains(ext)) continue;
    final limit = math.min(maxImportBytes, budget);
    final List<int> content;
    try {
      content = _readEntry(file, limit);
    } on _TooLarge {
      failure ??= ImportFailure.tooLarge;
      // One that said it was small and wasn't (a zip bomb) used up the work
      // of reading that much.
      if (file.size <= limit) budget -= limit;
      if (budget <= 0) break;
      continue;
    } catch (_) {
      failure ??= ImportFailure.unreadable;
      continue;
    }
    budget -= content.length;
    final result = _importFile(
      _entryName(parts, ext, zipName),
      content,
      depth: depth + 1,
    );
    switch (result) {
      case ImportedScripts(scripts: final found):
        scripts.addAll(found);
      case ImportFailed(:final reason):
        failure ??= reason;
      case ImportedBackup():
        break;
    }
    if (scripts.length >= 500) break;
  }
  if (scripts.isNotEmpty) return ImportedScripts(scripts);
  return ImportFailed(failure ?? ImportFailure.unsupportedFormat);
}

/// The name a note in a zip goes by: `My idea.textbundle/text.md` is
/// "My idea", not "text".
String _entryName(List<String> parts, String ext, String zipName) {
  final file = parts.last;
  final dot = file.lastIndexOf('.');
  final stem = (dot > 0 ? file.substring(0, dot) : file).toLowerCase();
  if (!const {'text', 'txt', 'index', 'content'}.contains(stem)) return file;
  final parent = parts.length > 1 ? parts[parts.length - 2] : zipName;
  final base = parent.split('/').last;
  final pdot = base.lastIndexOf('.');
  return '${pdot > 0 ? base.substring(0, pdot) : base}.$ext';
}

// ---------------------------------------------------------------------------
// Text

List<Script>? _backupIn(String text) {
  final start = text.trimLeft();
  if (!start.startsWith('{') && !start.startsWith('\uFEFF{')) return null;
  return Backup.decode(start.replaceFirst('\uFEFF', ''));
}

typedef _Doc = ({String body, String? title});

ImportResult _importText(
  String text, {
  required _Format format,
  String? explicitTitle,
  String? fileName,
  required bool pasted,
  bool keepFirstLine = false,
}) {
  // Backups restore the person's own scripts, so like "Restore from a
  // backup" in the library menu they are never held back by the free plan;
  // that menu already takes the very same file.
  final backup = _backupIn(text);
  if (backup != null) return ImportedBackup(backup);
  if (format == _Format.enex) return _fromEnex(text, fileName);
  if (format == _Format.mht) return _fromMht(text, explicitTitle, fileName);
  final _Doc doc = switch (format) {
    _Format.plain => (body: text, title: null),
    _Format.markdown => _fromMarkdown(text, pasted: pasted),
    _Format.html => _fromHtml(text),
    _Format.rtf => (body: _fromRtf(text), title: null),
    _Format.srt => (body: _fromSubtitles(text), title: null),
    _Format.vtt => (body: _fromSubtitles(text), title: null),
    _Format.enex || _Format.mht => (body: '', title: null),
  };
  return _finish(
    doc,
    explicitTitle: explicitTitle,
    fileName: fileName,
    // Every line of subtitles was said: none of them is a title.
    pasted: pasted && format != _Format.srt && format != _Format.vtt,
    converted: format != _Format.plain,
    keepFirstLine: keepFirstLine,
  );
}

// ---------------------------------------------------------------------------
// Titles

final _atxLine = RegExp(r'^(#{1,6})[ \t]+(\S.*)$');
final _urlLine = RegExp(r'^<?(https?://|www\.)\S+>?$', caseSensitive: false);
final _pauseMark = RegExp(
  r'[\[(]\s*pause\s*[.!]?\s*[\])]',
  caseSensitive: false,
);
final _sentenceEnd = RegExp(r'[.!?…。！？؟।۔:;,]$');

String _stripEmphasis(String s) => s.replaceAllMapped(
  RegExp(
    r'(?<![\\*\p{L}\p{N}])\*\*?(?![\s*])(.{1,300}?)(?<![\s\\*])\*\*?(?![\p{L}\p{N}*])',
    unicode: true,
  ),
  (m) => m[1]!,
);

/// A title as written, on one line. [markup] is for a title taken from a
/// heading, whose emphasis stars were formatting; a title the person typed
/// keeps its stars.
String? _cleanTitle(String? raw, {bool markup = false}) {
  if (raw == null) return null;
  var t = normalizeScriptText(raw)
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim()
      .replaceFirst(RegExp(r'^#+\s+'), '');
  if (markup) t = _stripEmphasis(t).trim();
  return t.isEmpty ? null : t;
}

/// Letters and digits only, lower case: "My video: take 2/3" and the file
/// name "My video take 2 3" are the same.
String _loose(String s) =>
    s.toLowerCase().replaceAll(RegExp(r'[^\p{L}\p{N}]+', unicode: true), '');

/// Case- and space-insensitive, ignoring a leading "# " and emphasis.
String _squash(String s) =>
    _stripEmphasis(s.trim().replaceFirst(RegExp(r'^#+\s*'), ''))
        .replaceAll(RegExp(r'\s+'), '')
        .toLowerCase();

/// The first non-blank line and everything after it.
(String, String)? _splitFirstLine(String body) {
  final lines = body.split('\n');
  final i = lines.indexWhere((l) => l.trim().isNotEmpty);
  if (i < 0) return null;
  return (lines[i].trim(), lines.sublist(i + 1).join('\n').trim());
}

/// A leading heading is the document's title when no other heading is at
/// its level or above (Notion: "# Page" then "## Parts"). "# Hook", "# Value",
/// "# CTA" are sections, not a title.
(String, String)? _headingTitle(String body) {
  final lines = body.split('\n');
  final first = lines.indexWhere((l) => l.trim().isNotEmpty);
  if (first < 0) return null;
  final m = _atxLine.firstMatch(lines[first].trim());
  if (m == null) return null;
  final level = m[1]!.length;
  for (var i = first + 1; i < lines.length; i++) {
    final other = _atxLine.firstMatch(lines[i].trim());
    if (other != null && other[1]!.length <= level) return null;
  }
  final rest = lines.sublist(first + 1).join('\n').trim();
  final title = _cleanTitle(m[2], markup: true);
  if (rest.isEmpty || title == null) return null;
  return (title, rest);
}

/// The title of a file named [fileName]: no folder, no extension, no
/// " (1)" download counter, no Notion page id. With [keepCounter] a
/// trailing "(n)" stays: it may be part of the title ("Top 10 tips (2024)").
String? _fileTitle(String fileName, {bool keepCounter = false}) {
  var base = fileName
      .split(RegExp(r'[/\\]'))
      .last
      .replaceFirst(RegExp(r'(?<=.)\.[A-Za-z0-9]{1,8}$'), '')
      .replaceFirst(RegExp(r'\s+[0-9a-f]{32}$'), '');
  if (!keepCounter) base = base.replaceFirst(RegExp(r'\s*\(\d+\)$'), '');
  return _cleanTitle(base);
}

/// Whether [line] is what the file was named after — a file APrompter
/// exported, or a note saved under its first line.
bool _namesFile(String line, String fileTitle) {
  final a = _loose(line);
  final b = _loose(fileTitle);
  if (a.isEmpty || b.isEmpty) return false;
  return a == b || (b.length >= 40 && a.startsWith(b));
}

/// A short line without sentence punctuation or markup: a title, or a
/// caption-style script line.
bool _shortPlainLine(String line) =>
    line.length <= 60 &&
    _wordChar.hasMatch(line) &&
    !_sentenceEnd.hasMatch(line) &&
    !line.startsWith('#') &&
    !line.startsWith('//') &&
    !line.contains('*') &&
    !_pauseMark.hasMatch(line) &&
    !_urlLine.hasMatch(line) &&
    !RegExp(r'^\d+[.)]\s').hasMatch(line);

/// A short first line of shared or pasted text that reads like a title:
/// Apple Notes and Samsung Notes put the note title there. [keep] is true
/// when the line is better left in the script too: the lines after it are
/// just as short and bare, so it is the opening line of a caption-style
/// script ("Stop scrolling right now" / "This trick changes everything").
(String, String, bool keep)? _firstLineTitle(String body) {
  final lines = body.split('\n');
  final first = lines.indexWhere((l) => l.trim().isNotEmpty);
  if (first < 0) return null;
  var line = lines[first].trim();
  final rest = lines.sublist(first + 1).join('\n').trim();
  // A wholly bold first line (Apple Notes' title style) is still a title.
  final bold = RegExp(r'^\*([^*\s][^*]*)\*$').firstMatch(line);
  if (bold != null) line = bold[1]!.trim();
  if (rest.isEmpty || !_shortPlainLine(line)) return null;
  final blankAfter =
      first + 1 < lines.length && lines[first + 1].trim().isEmpty;
  final next = rest.split('\n').first.trim();
  return (line, rest, bold == null && !blankAfter && _shortPlainLine(next));
}

bool _onlyLinks(String body) => body
    .split('\n')
    .where((l) => l.trim().isNotEmpty)
    .every((l) => _urlLine.hasMatch(l.trim()));

/// Turns converted text into the final script: clean text, a title, and no
/// title repeated as the first line.
ImportResult _finish(
  _Doc doc, {
  String? explicitTitle,
  String? fileName,
  required bool pasted,
  required bool converted,
  bool keepFirstLine = false,
}) {
  var body = normalizeScriptText(doc.body);
  if (body.length > maxImportChars) {
    return const ImportFailed(ImportFailure.tooLarge);
  }
  if (converted) {
    body = normalizeScriptText(
      body.replaceAll(RegExp(r'^[ ]*#{1,6}[ ]*$', multiLine: true), ''),
    );
  }
  if (body.isEmpty) return const ImportFailed(ImportFailure.empty);

  var title = _cleanTitle(explicitTitle) ?? _cleanTitle(doc.title);
  // A title taken from the body's own first line is not looked for again
  // below: a script may start with the same words as its title.
  var fromBody = false;
  // In a plain text file "# Hook" is a section cue, kept as written; in a
  // converted document or pasted note a lone top heading is its title.
  if (title == null && (converted || fileName == null)) {
    if (_headingTitle(body) case (final t, final rest)) {
      title = t;
      body = rest;
      fromBody = true;
    }
  }
  if (title == null && fileName != null) {
    final fromName = _fileTitle(fileName);
    if (fromName != null) {
      final split = _splitFirstLine(body);
      // A file APrompter saved is named after the title as it is, "(2024)"
      // and all; a downloaded copy may add its own " (1)".
      final stem = _fileTitle(fileName, keepCounter: true);
      if (split != null &&
          split.$2.isNotEmpty &&
          (_namesFile(split.$1, fromName) ||
              (stem != null && _namesFile(split.$1, stem)))) {
        title = _cleanTitle(split.$1);
        body = split.$2;
        fromBody = true;
      } else {
        title = fromName;
      }
    }
  }
  if (title == null && fileName == null && pasted) {
    if (_firstLineTitle(body) case (final t, final rest, final keep)) {
      title = _cleanTitle(t);
      if (!keep && !keepFirstLine) body = rest;
      fromBody = true;
    }
  }
  if (converted) {
    body = body.replaceAll(RegExp(r'^#{2,6}(?=[ ])', multiLine: true), '#');
  }
  if (title != null && !fromBody) {
    final split = _splitFirstLine(body);
    if (split != null &&
        split.$1.length <= title.length * 2 + 20 &&
        _squash(split.$1) == _squash(title)) {
      body = split.$2;
    }
  }
  body = normalizeScriptText(body);
  if (body.isEmpty) return const ImportFailed(ImportFailure.empty);
  if (_onlyLinks(body)) return const ImportFailed(ImportFailure.linkOnly);
  return ImportedScripts([ImportedScript(title: title, body: body)]);
}

// ---------------------------------------------------------------------------
// Markdown (Notion, Obsidian, Bear, Joplin, iA Writer…)

final _frontMatter = RegExp(
  r'^\uFEFF?(---|\+\+\+)[ \t]*\n([\s\S]*?)\n(---|\.\.\.|\+\+\+)[ \t]*(\n|$)',
);

/// Keys that Obsidian, Jekyll, Hugo, Bear and Notion exports put in front
/// matter.
const _frontMatterKeys = {
  'title', 'tags', 'tag', 'aliases', 'alias', 'date', 'created', 'updated', //
  'modified', 'lastmod', 'author', 'authors', 'categories', 'category',
  'slug', 'draft', 'layout', 'permalink', 'cssclass', 'cssclasses',
  'publish', 'keywords', 'lang', 'uid', 'id', 'description', 'summary',
  'excerpt', 'cover', 'banner', 'weight', 'series', 'published',
  'date_created', 'date_modified', 'created_at', 'updated_at',
};

/// Whether a block between `---` lines is front matter, not part of the
/// script. Creators also use `---` as a divider around "Note: …" lines, so
/// pasted text needs a key front matter really uses; a Markdown file may
/// have any `key: value` lines.
bool _isFrontMatter(RegExpMatch fm, {required bool fromFile}) {
  if ((fm[1] == '+++') != (fm[3] == '+++')) return false;
  final lines = fm[2]!.split('\n').where((l) => l.trim().isNotEmpty).toList();
  if (lines.isEmpty) return fromFile;
  final key = RegExp(r'^\s*"?([A-Za-z_][\w -]*?)"?\s*[:=](\s|$)');
  if (lines.any(
    (l) => _frontMatterKeys.contains(key.firstMatch(l)?[1]?.toLowerCase()),
  )) {
    return true;
  }
  return fromFile &&
      lines.every((l) => key.hasMatch(l) || RegExp(r'^\s+\S').hasMatch(l));
}

/// [text] without what lies between each [open] and the next [close].
/// One pass, so a stray opener can't make it slow.
String _removeBetween(String text, String open, String close) {
  final out = StringBuffer();
  var at = 0;
  while (true) {
    final start = text.indexOf(open, at);
    if (start < 0) break;
    final end = text.indexOf(close, start + open.length);
    if (end < 0) break;
    out.write(text.substring(at, start));
    at = end + close.length;
  }
  out.write(text.substring(at));
  return out.toString();
}

/// A section cue in APrompter markup: `#` then a space, or `##`.
final _sectionStart = RegExp(r'^\s*(#+(\s|$)|##)');

_Doc _fromMarkdown(String source, {required bool pasted}) {
  var text = source.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  String? title;
  final fm = _frontMatter.firstMatch(text);
  if (fm != null && _isFrontMatter(fm, fromFile: !pasted)) {
    final t = RegExp(
      r'^title\s*[:=]\s*(.+)$',
      multiLine: true,
      caseSensitive: false,
    ).firstMatch(fm[2]!);
    if (t != null) {
      title = t[1]!.trim().replaceAll(RegExp(r'''^["']|["']$'''), '');
    }
    text = text.substring(fm.end);
  }
  text = _removeBetween(_removeBetween(text, '<!--', '-->'), '%%', '%%');

  final lines = text.split('\n');
  final out = <String>[];
  var paragraph = false; // the last line out was paragraph text
  var inTable = false;
  String? fence;
  for (var i = 0; i < lines.length; i++) {
    final raw = lines[i];
    if (fence != null) {
      if (raw.trimLeft().startsWith(fence)) {
        fence = null;
      } else {
        // Code is shown as written: a "# comment" in it is not a section
        // cue (nor the script's title).
        final code = raw.trimRight();
        out.add(
          _sectionStart.hasMatch(code) ? code.replaceFirst('#', r'\#') : code,
        );
      }
      continue;
    }
    final open = RegExp(r'^\s{0,3}(`{3,}|~{3,})').firstMatch(raw);
    if (open != null) {
      fence = open[1]!;
      paragraph = false;
      continue;
    }
    final line = raw
        .replaceFirst(RegExp(r'^\s{0,3}(>\s?)+'), '')
        .replaceFirst(RegExp(r'^\s*\[!\w+\][+-]?\s*'), '')
        .trim();
    if (line.isEmpty) {
      out.add('');
      paragraph = false;
      inTable = false;
      continue;
    }
    if (paragraph && RegExp(r'^=+$').hasMatch(line)) {
      out.last = '# ${_mdHeading(out.last)}';
      paragraph = false;
      continue;
    }
    if (paragraph && RegExp(r'^-{2,}$').hasMatch(line)) {
      out.last = '## ${_mdHeading(out.last)}';
      paragraph = false;
      continue;
    }
    if (RegExp(r'^([-*_])(\s*\1){2,}$').hasMatch(line)) {
      out.add('');
      paragraph = false;
      continue;
    }
    final heading = RegExp(r'^(#{1,6})\s+(.*?)(\s+#+)?$').firstMatch(line);
    if (heading != null) {
      final t = _mdHeading(heading[2]!);
      out.add(t.isEmpty ? '' : '${heading[1]} $t');
      paragraph = false;
      continue;
    }
    if (_isTableSeparator(line)) {
      inTable = true;
      continue;
    }
    final tableHeader =
        line.contains('|') &&
        i + 1 < lines.length &&
        _isTableSeparator(lines[i + 1]);
    if (line.startsWith('|') ||
        tableHeader ||
        (inTable && line.contains('|'))) {
      final cells = line
          .split(RegExp(r'(?<!\\)\|'))
          .map((c) => c.trim())
          .where((c) => c.isNotEmpty);
      out.add(_mdInline(cells.join(' ')));
      paragraph = false;
      continue;
    }
    if (RegExp(r'^\[[^\]^][^\]]*\]:\s*\S+').hasMatch(line)) continue;
    var content = line.replaceFirst(RegExp(r'^\[\^[^\]]+\]:\s*'), '');
    final bullet = RegExp(r'^[-*+]\s+(\[[ xX]\]\s+)?').firstMatch(content);
    final numbered = RegExp(r'^(\d{1,9}[.)])\s+(\[[ xX]\]\s+)?')
        .firstMatch(content);
    if (bullet != null) {
      out.add(_mdInline(content.substring(bullet.end)));
      paragraph = false;
    } else if (numbered != null) {
      content = '${numbered[1]} ${content.substring(numbered.end)}';
      out.add(_mdInline(content));
      paragraph = false;
    } else {
      out.add(_mdInline(content));
      paragraph = true;
    }
  }
  return (body: out.join('\n'), title: title);
}

String _mdHeading(String s) => _stripEmphasis(_mdInline(s)).trim();

const _escapeBase = 0xE100;
const _codeOpen = '\uE200';
const _codeClose = '\uE201';

/// Whether emphasis from [m] would sit inside a word ("**Super**man"):
/// APrompter shows such stars as they are, so the run stays plain text.
bool _insideWord(Match m) {
  final s = m.input;
  bool word(int i) => i >= 0 && i < s.length && _wordChar.hasMatch(s[i]);
  return word(m.start - 1) || word(m.end);
}

final _wordChar = RegExp(r'[\p{L}\p{N}]', unicode: true);

String _emphasize(Match m) => _insideWord(m) ? m[1]! : '*${m[1]}*';

String _mdInline(String input) {
  // Backslash escapes (not \*, which APrompter reads as a literal star).
  var s = input.replaceAllMapped(
    RegExp(r'''\\([!"#$%&'()+,\-./:;<=>?@\[\]^_`{|}~])'''),
    (m) => String.fromCharCode(_escapeBase + m[1]!.codeUnitAt(0)),
  );
  // Code spans keep their text exactly. Every span below is bounded, so a
  // long line with an unclosed marker can't take quadratic time.
  final code = <String>[];
  s = s.replaceAllMapped(RegExp(r'(`+)(.{1,500}?)\1'), (m) {
    code.add(m[2]!.trim());
    return '$_codeOpen${code.length - 1}$_codeClose';
  });
  const link =
      r'\((?:[^()\s]|\([^()\s]*\))*(?:\s+(?:"[^"]{0,500}"|'
      "'[^']{0,500}'"
      r'|\([^)]{0,500}\)))?\s*\)';
  // Links and images. A line without "]" has none, and looking first keeps
  // a line of "[[[[" fast.
  if (s.contains(']')) {
    s = s
        .replaceAll(RegExp(r'!\[\[[^\]]{0,500}\]\]'), '')
        .replaceAll(RegExp(r'!\[[^\]]{0,500}\]' + link), '')
        .replaceAll(RegExp(r'!\[[^\]]{0,500}\]\[[^\]]{0,500}\]'), '')
        .replaceAllMapped(
          RegExp(r'\[\[([^\]|]{0,500})(?:\|([^\]]{0,500}))?\]\]'),
          (m) {
            final alias = m[2]?.trim() ?? '';
            if (alias.isNotEmpty) return alias;
            final target = m[1]!.trim();
            final hash = target.indexOf('#');
            if (hash < 0) return target;
            final page = target.substring(0, hash).trim();
            return page.isNotEmpty
                ? page
                : target.substring(hash + 1).replaceAll('^', '').trim();
          },
        )
        .replaceAllMapped(RegExp(r'\[([^\]]{0,500})\]' + link), (m) => m[1]!)
        .replaceAllMapped(
          RegExp(r'\[([^\]]{1,500})\]\[[^\]]{0,500}\]'),
          (m) => m[1]!,
        )
        .replaceAll(RegExp(r'\[\^[^\]\s]+\]'), '');
  }
  s = s
      .replaceAllMapped(
        RegExp(r'<((?:https?|mailto):[^>\s]+)>', caseSensitive: false),
        (m) => m[1]!,
      )
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</?(b|strong)>', caseSensitive: false), '**')
      .replaceAll(RegExp(r'</?(i|em)>', caseSensitive: false), '*')
      .replaceAll(
        RegExp(
          r'</?(u|ins|mark|span|div|p|sup|sub|kbd|font|small|big|center|a|img|abbr|cite|q|s|strike|del|details|summary)\b[^>]{0,500}>',
          caseSensitive: false,
        ),
        '',
      )
      .replaceAllMapped(RegExp(r'~~(.{1,500}?)~~'), (m) => m[1]!)
      .replaceAllMapped(RegExp(r'==(?=\S)(.{1,300}?)(?<=\S)=='), _emphasize)
      .replaceAllMapped(
        RegExp(r'(?<![\\*])\*\*\*(?=\S)(.{1,300}?)(?<=\S)\*\*\*(?!\*)'),
        _emphasize,
      )
      .replaceAllMapped(
        RegExp(r'(?<![\\*])\*\*(?=\S)(.{1,300}?)(?<=\S)\*\*(?!\*)'),
        _emphasize,
      )
      .replaceAllMapped(
        RegExp(r'(?<![\w\\])___(?=\S)(.{1,300}?)(?<=\S)___(?!\w)'),
        (m) => '*${m[1]}*',
      )
      .replaceAllMapped(
        RegExp(r'(?<![\w\\])__(?=\S)(.{1,300}?)(?<=\S)__(?!\w)'),
        (m) => '*${m[1]}*',
      )
      .replaceAllMapped(
        RegExp(r'(?<![\w\\])_(?=[^\s_])(.{1,300}?)(?<=[^\s_])_(?!\w)'),
        (m) => '*${m[1]}*',
      )
      .replaceAllMapped(
        RegExp('$_codeOpen(\\d+)$_codeClose'),
        (m) => code[int.parse(m[1]!)],
      );
  // "\# not a heading" stays escaped: unescaped it would be a section cue.
  s = s.replaceFirstMapped(
    RegExp('^(\\s*)\uE123(?=\\s|\$|#|\uE123)'),
    (m) => '${m[1]}\\#',
  );
  return s.replaceAllMapped(
    RegExp('[\uE121-\uE17E]'),
    (m) => String.fromCharCode(m[0]!.codeUnitAt(0) - _escapeBase),
  );
}

// ---------------------------------------------------------------------------
// HTML (Google Docs, Apple Notes, OneNote, Evernote notes, web pages)

const _entities = XmlDefaultEntityMapping.html5();
const _boldOn = '\uE000';
const _boldOff = '\uE001';

const _voidTags = {
  'area', 'base', 'br', 'col', 'embed', 'hr', 'img', 'input', 'link', //
  'meta', 'param', 'source', 'track', 'wbr', 'en-media', 'en-todo',
};
const _blockTags = {
  'address', 'article', 'aside', 'blockquote', 'body', 'caption', 'center', //
  'dd', 'details', 'dialog', 'dir', 'div', 'dl', 'dt', 'en-note',
  'fieldset', 'figcaption', 'figure', 'footer', 'form', 'header', 'hgroup',
  'html', 'legend', 'li', 'main', 'menu', 'nav', 'ol', 'option', 'p', 'pre',
  'section', 'summary', 'table', 'tbody', 'td', 'tfoot', 'th', 'thead', 'tr',
  'ul', 'h1', 'h2', 'h3', 'h4', 'h5', 'h6',
};

/// Elements whose content is never script text: skipped up to their end
/// tag. Without an end tag they are ignored like any other unknown tag.
const _rawTextTags = {
  'script', 'style', 'noscript', 'template', 'svg', 'math', 'iframe', //
  'object', 'title', 'en-crypt', 'xml',
};

/// What may stand in a page's head.
const _headTags = {
  'title', 'meta', 'link', 'style', 'script', 'base', 'noscript', 'template', //
};

bool _isAsciiLetter(int c) => (c >= 65 && c <= 90) || (c >= 97 && c <= 122);

bool _isTagNameChar(int c) =>
    _isAsciiLetter(c) ||
    (c >= 48 && c <= 57) ||
    c == 0x5F || // _
    c == 0x3A || // :
    c == 0x2D; // -

/// Classes a page's style sheets make bold (Google Docs: `.c4{font-weight:
/// 700}`).
Set<String> _boldClasses(String html) {
  final classes = <String>{};
  final openTag = RegExp(r'<style\b', caseSensitive: false);
  final closeTag = RegExp(r'</style\s*>', caseSensitive: false);
  var at = 0;
  while (true) {
    final start = openTag.allMatches(html, at).firstOrNull;
    if (start == null) break;
    final gt = html.indexOf('>', start.end);
    if (gt < 0) break;
    final end = closeTag.allMatches(html, gt).firstOrNull;
    if (end == null) break;
    for (final rule in html.substring(gt + 1, end.start).split('}')) {
      final brace = rule.lastIndexOf('{');
      if (brace < 0 || !_isBoldStyle(rule.substring(brace + 1))) continue;
      final from = brace == 0 ? 0 : rule.lastIndexOf('{', brace - 1) + 1;
      final selectors = rule.substring(from, brace);
      for (final selector in selectors.split(',')) {
        final m = RegExp(r'^[\w-]*\.([\w-]+)$').firstMatch(selector.trim());
        if (m != null) classes.add(m[1]!);
      }
    }
    at = end.end;
  }
  return classes;
}

/// Reads HTML in one pass with a small tag scanner (no regular expression
/// over the whole page, so a broken page can't make it slow).
_Doc _fromHtml(String html) {
  final boldClasses = _boldClasses(html);
  String? title;
  final out = _HtmlWriter();
  final open = <_HtmlElement>[];
  final openCount = <String, int>{};
  final noEndTag = <String>{};
  var inHead = false;
  final n = html.length;
  final lastGt = html.lastIndexOf('>');
  final lastQuote = {0x22: html.lastIndexOf('"'), 0x27: html.lastIndexOf("'")};
  var quoteAware = true;
  var commentsEnd = true; // a "-->" may still come
  var text = 0; // where text not yet written starts
  var i = 0;

  void flush(int end) {
    if (end > text && !inHead) out.text(html.substring(text, end));
  }

  while (i < n) {
    final lt = html.indexOf('<', i);
    if (lt < 0 || lt >= lastGt) break;
    if (html.startsWith('<!--', lt)) {
      var end = commentsEnd ? html.indexOf('-->', lt + 4) : -1;
      if (end >= 0) {
        end += 3;
      } else {
        commentsEnd = false;
        end = html.indexOf('>', lt + 4) + 1;
        if (end == 0) break;
      }
      flush(lt);
      i = text = end;
      continue;
    }
    final c1 = lt + 1 < n ? html.codeUnitAt(lt + 1) : 0;
    if (c1 == 0x21 || c1 == 0x3F) {
      // <!doctype …>, <![CDATA[…]]>, <?xml …?>
      flush(lt);
      i = text = html.indexOf('>', lt) + 1;
      continue;
    }
    final closing = c1 == 0x2F;
    var j = closing ? lt + 2 : lt + 1;
    if (j >= n || !_isAsciiLetter(html.codeUnitAt(j))) {
      i = lt + 1; // a "<" in the text
      continue;
    }
    final nameStart = j;
    while (j < n && _isTagNameChar(html.codeUnitAt(j))) {
      j++;
    }
    final name = html.substring(nameStart, j).toLowerCase();
    // The tag ends at the first ">" outside quoted attribute values.
    var gt = -1;
    if (quoteAware) {
      var k = j;
      while (k < n) {
        final c = html.codeUnitAt(k);
        if (c == 0x3E) {
          gt = k;
          break;
        }
        if (c == 0x22 || c == 0x27) {
          if (k >= lastQuote[c]!) break;
          k = html.indexOf(String.fromCharCode(c), k + 1) + 1;
          continue;
        }
        k++;
      }
      // Quotes that never close: from here on a tag ends at the next ">".
      if (gt < 0) quoteAware = false;
    }
    if (gt < 0) gt = html.indexOf('>', j);
    if (gt < 0) break;
    final attrs = html.substring(j, gt);
    flush(lt);
    i = text = gt + 1;

    if (closing) {
      if (name == 'head') inHead = false;
      if ((openCount[name] ?? 0) == 0) continue;
      while (open.isNotEmpty) {
        final e = open.removeLast();
        openCount[e.name] = openCount[e.name]! - 1;
        out.end(e);
        if (e.name == name) break;
      }
      continue;
    }
    if (name == 'head') {
      inHead = true;
      continue;
    }
    // A page may leave </head> out: anything that can't be in the head
    // starts the body.
    if (!_headTags.contains(name)) inHead = false;
    final selfClosing = attrs.trimRight().endsWith('/');
    if (_rawTextTags.contains(name) &&
        !selfClosing &&
        !noEndTag.contains(name)) {
      final end = RegExp(
        '</$name\\s*>',
        caseSensitive: false,
      ).allMatches(html, i).firstOrNull;
      if (end != null) {
        if (name == 'title') {
          title ??= _entities
              .decode(
                html
                    .substring(i, end.start)
                    .replaceAll(RegExp(r'<[^>]{0,500}>'), ''),
              )
              .replaceAll(RegExp(r'\s+'), ' ')
              .trim();
        }
        i = text = end.end;
        continue;
      }
      noEndTag.add(name);
    }
    if (name == 'br') {
      out.lineBreak();
      continue;
    }
    if (name == 'hr') {
      out.block();
      out.lineBreak();
      continue;
    }
    if (_voidTags.contains(name)) continue;
    final classes = (_attribute(attrs, 'class') ?? '').split(RegExp(r'\s+'));
    final style = _attribute(attrs, 'style') ?? '';
    final weight = RegExp(
      r'font-weight\s*:\s*([\w]+)',
      caseSensitive: false,
    ).firstMatch(style)?[1];
    final bold = weight != null
        ? _isBoldStyle('font-weight:$weight')
        : (name == 'b' ||
              name == 'strong' ||
              classes.any(boldClasses.contains));
    final headingMatch = RegExp(r'^h([1-6])$').firstMatch(name);
    final level = headingMatch != null
        ? int.parse(headingMatch[1]!) + 1
        : (name == 'p' && classes.contains('title') ? 1 : 0);
    final element = _HtmlElement(
      name,
      bold: bold,
      level: level,
      block: _blockTags.contains(name),
    );
    out.start(element, ordered: open.lastOrNull?.name == 'ol');
    if (selfClosing) {
      out.end(element);
    } else {
      open.add(element);
      openCount[name] = (openCount[name] ?? 0) + 1;
    }
  }
  flush(n);
  while (open.isNotEmpty) {
    out.end(open.removeLast());
  }
  return (body: out.result(), title: title);
}

bool _isBoldStyle(String css) {
  final m = RegExp(
    r'font-weight\s*:\s*(\w+)',
    caseSensitive: false,
  ).firstMatch(css);
  if (m == null) return false;
  final w = m[1]!.toLowerCase();
  return w == 'bold' || w == 'bolder' || (int.tryParse(w) ?? 0) >= 600;
}

String? _attribute(String attrs, String name) {
  final m = RegExp(
    '(?:^|\\s)$name\\s*=\\s*(?:"([^"]*)"|\'([^\']*)\'|([^\\s>]+))',
    caseSensitive: false,
  ).firstMatch(attrs);
  return m == null ? null : (m[1] ?? m[2] ?? m[3]);
}

class _HtmlElement {
  _HtmlElement(
    this.name, {
    required this.bold,
    required this.level,
    required this.block,
  });

  final String name;
  final bool bold;
  final int level;
  final bool block;
  int textMark = 0;
  int number = 0; // items so far, for <ol>
}

/// Collects HTML text as lines; bold runs are marked with private-use
/// characters and become `*emphasis*` per line at the end.
class _HtmlWriter {
  final _out = StringBuffer();
  bool _lineHasText = false;

  /// The line holds only a list item's number so far: a paragraph or div
  /// inside the item (Evernote, pasted HTML) goes on the same line.
  bool _numberOnly = false;
  int _bold = 0;
  int _heading = 0;
  int _pre = 0;
  int _writes = 0;
  final _lists = <_HtmlElement>[];

  void text(String raw) {
    var t = _pre > 0 ? raw : raw.replaceAll(RegExp(r'[ \t\n\r\f]+'), ' ');
    t = _entities.decode(t);
    if (!_lineHasText && _pre == 0) t = t.trimLeft();
    if (t.isEmpty) return;
    if (_pre > 0 && t.contains('\n')) {
      final parts = t.split('\n');
      for (var i = 0; i < parts.length; i++) {
        if (i > 0) lineBreak();
        if (parts[i].isNotEmpty) _write(parts[i]);
      }
      return;
    }
    _write(t);
  }

  void _write(String t) {
    _out.write(t);
    _lineHasText = true;
    _numberOnly = false;
    _writes++;
  }

  void lineBreak() {
    final marks = _bold > 0 && _heading == 0;
    if (marks) _out.write(_boldOff);
    _out.write('\n');
    if (marks) _out.write(_boldOn);
    _lineHasText = false;
    _numberOnly = false;
    _writes++;
  }

  void block() {
    if (_lineHasText && !_numberOnly) lineBreak();
  }

  void start(_HtmlElement e, {required bool ordered}) {
    if (e.block) block();
    e.textMark = _writes;
    if (e.name == 'pre') _pre++;
    if (e.name == 'ol') _lists.add(e);
    if (e.level > 0) {
      _heading++;
      _out.write('${'#' * math.min(e.level, 6)} ');
      _lineHasText = true;
      _numberOnly = false;
    }
    if (e.name == 'li' && ordered && _lists.isNotEmpty) {
      _out.write('${++_lists.last.number}. ');
      _lineHasText = true;
      _numberOnly = true;
    }
    if (e.bold) {
      if (_bold == 0 && _heading == 0) _out.write(_boldOn);
      _bold++;
    }
  }

  void end(_HtmlElement e) {
    if (e.bold) {
      _bold--;
      if (_bold == 0 && _heading == 0) _out.write(_boldOff);
    }
    if (e.level > 0) _heading--;
    if (e.name == 'pre') _pre--;
    if (e.name == 'ol') _lists.remove(e);
    if (e.name == 'li' && _numberOnly) {
      lineBreak(); // an empty item keeps its number
      return;
    }
    if (e.block) {
      final empty = _writes == e.textMark;
      block();
      // An empty paragraph (Google Docs, Word) is a blank line.
      if (empty && !_numberOnly && (e.name == 'p' || e.name == 'div')) {
        _out.write('\n');
      }
    }
  }

  String result() => _out
      .toString()
      .split('\n')
      .map(_emphasis)
      .map((l) => l.replaceAllMapped(RegExp(r'(\S) {2,}'), (m) => '${m[1]} '))
      .join('\n');

  static final _marker = RegExp('[$_boldOn$_boldOff]');
  static final _run = RegExp(
    '$_boldOn(\\s*)([^$_boldOn$_boldOff]*?)(\\s*)$_boldOff',
  );

  /// Bold runs as `*emphasis*` — unless the run is part of a word
  /// ("<b>Super</b>man"), where APrompter would show the stars as text.
  static String _emphasis(String line) {
    final plain = line.replaceAll(_marker, '');
    if (plain.trimLeft().startsWith('#')) return plain;
    final merged = line.replaceAllMapped(
      RegExp('$_boldOff(\\s*)$_boldOn'),
      (m) => m[1]!,
    );
    String? visible(int i, int step) {
      for (; i >= 0 && i < merged.length; i += step) {
        if (!_marker.hasMatch(merged[i])) return merged[i];
      }
      return null;
    }

    bool blocks(String? c) =>
        c != null && (_wordChar.hasMatch(c) || c == '*' || c == r'\');
    final out = StringBuffer();
    var at = 0;
    for (final m in _run.allMatches(merged)) {
      out.write(merged.substring(at, m.start));
      at = m.end;
      final inner = m[2]!;
      final stars =
          inner.isNotEmpty &&
          !inner.startsWith('*') &&
          !inner.endsWith('*') &&
          !inner.endsWith(r'\') &&
          !(m[1]!.isEmpty && blocks(visible(m.start - 1, -1))) &&
          !(m[3]!.isEmpty && blocks(visible(m.end, 1)));
      out.write(stars ? '${m[1]}*$inner*${m[3]}' : '${m[1]}$inner${m[3]}');
    }
    out.write(merged.substring(at));
    return out.toString().replaceAll(_marker, '');
  }
}

// ---------------------------------------------------------------------------
// RTF (TextEdit, WordPad, Word, Apple Notes exports)

/// Groups that hold no document text.
const _rtfSkip = {
  'fonttbl', 'colortbl', 'stylesheet', 'info', 'pict', 'header', 'footer', //
  'headerl', 'headerr', 'headerf', 'footerl', 'footerr', 'footerf',
  'fldinst', 'listtable', 'listoverridetable', 'revtbl', 'rsidtbl',
  'generator', 'xmlnstbl', 'themedata', 'colorschememapping', 'latentstyles',
  'datastore', 'filetbl', 'object', 'objdata', 'shp', 'shpinst',
  'nonshppict', 'footnote', 'annotation', 'atnid', 'atnauthor', 'pgdsctbl',
  'mmathPr', 'listpicture', 'xe', 'tc', 'template', 'private', 'userprops',
  'docvar', 'pntxtb', 'pntxta', 'bkmkstart', 'bkmkend',
};

const _rtfSymbols = {
  'emdash': '—',
  'endash': '–',
  'bullet': '•',
  'lquote': '‘',
  'rquote': '’',
  'ldblquote': '“',
  'rdblquote': '”',
  'emspace': ' ',
  'enspace': ' ',
  'qmspace': ' ',
};

String _fromRtf(String rtf) {
  final out = StringBuffer();
  final stack = <(bool, int, int?)>[];
  var skip = false;
  var uc = 1;
  var pending = 0; // fallback characters to drop after \uN
  var groupStart = false;
  // \'hh bytes are read in the code page of the current font's character
  // set (WordPad: Polish text in a \fcharset238 font), else \ansicpg.
  var ansi = 1252;
  final charsets = <int, int>{};
  int? font;
  int? defaultFont;
  int? fontTableDepth; // inside {\fonttbl …}
  int? definingFont;
  var undecodable = 0;
  final n = rtf.length;
  var i = 0;

  bool isLetter(int c) => (c >= 65 && c <= 90) || (c >= 97 && c <= 122);
  bool isDigit(int c) => c >= 48 && c <= 57;
  int? hexDigit(int c) => isDigit(c)
      ? c - 48
      : (c >= 65 && c <= 70)
      ? c - 55
      : (c >= 97 && c <= 102)
      ? c - 87
      : null;
  void emit(String s) {
    if (skip) return;
    if (pending > 0) {
      pending--;
      return;
    }
    out.write(s);
  }

  void emitByte(int b) {
    if (skip) return;
    if (pending > 0) {
      pending--;
      return;
    }
    final charset = font == null ? null : charsets[font];
    final cp = _charsetCodePages[charset] ?? ansi;
    if (cp == -1) {
      // Symbol and Wingdings: Word's list bullets.
      out.write(
        b == 0xB7 ? '•' : (b == 0xA7 ? '▪' : String.fromCharCode(_cp1252(b))),
      );
      return;
    }
    final map = _codePage(cp);
    if (map == null) {
      if (b >= 0x80) undecodable++;
      if (b < 0x80) out.writeCharCode(b);
      return;
    }
    out.writeCharCode(map(b));
  }

  while (i < n) {
    final c = rtf.codeUnitAt(i);
    if (c == 0x7B) {
      // {
      stack.add((skip, uc, font));
      groupStart = true;
      pending = 0;
      i++;
      continue;
    }
    if (c == 0x7D) {
      // }
      if (stack.isNotEmpty) (skip, uc, font) = stack.removeLast();
      if (fontTableDepth != null && stack.length < fontTableDepth) {
        fontTableDepth = null;
        definingFont = null;
      }
      groupStart = false;
      pending = 0;
      i++;
      continue;
    }
    if (c == 0x5C && i + 1 < n) {
      // backslash
      final d = rtf.codeUnitAt(i + 1);
      final atGroupStart = groupStart;
      groupStart = false;
      if (isLetter(d)) {
        var j = i + 1;
        while (j < n && isLetter(rtf.codeUnitAt(j))) {
          j++;
        }
        final word = rtf.substring(i + 1, j);
        var k = j;
        if (k < n &&
            (rtf.codeUnitAt(k) == 0x2D || isDigit(rtf.codeUnitAt(k)))) {
          k++;
          while (k < n && isDigit(rtf.codeUnitAt(k))) {
            k++;
          }
        }
        final param = int.tryParse(rtf.substring(j, k));
        if (k < n && rtf.codeUnitAt(k) == 0x20) k++;
        i = k;
        if (word == 'bin') {
          i += math.max(0, param ?? 0);
          continue;
        }
        if (atGroupStart && _rtfSkip.contains(word)) {
          skip = true;
          if (word == 'fonttbl') fontTableDepth = stack.length;
          continue;
        }
        switch (word) {
          case 'par' || 'line' || 'sect' || 'page' || 'row' || 'cell':
            emit('\n');
          case 'tab':
            emit(' ');
          case 'u':
            if (param != null && !skip) {
              if (pending > 0) pending = 0;
              final unit = param < 0 ? param + 65536 : param;
              // A damaged value is skipped, not the whole document.
              if (unit >= 0 && unit <= 0xFFFF) out.writeCharCode(unit);
              pending = uc;
            }
          case 'uc':
            uc = (param ?? 1).clamp(0, 16);
          case 'ansicpg':
            ansi = param ?? 1252;
          case 'deff':
            defaultFont = param;
            font ??= param;
          case 'f':
            if (fontTableDepth != null) {
              definingFont = param;
            } else {
              font = param;
            }
          case 'fcharset':
            if (fontTableDepth != null && definingFont != null) {
              if (param != null) charsets[definingFont] = param;
            }
          case 'plain':
            font = defaultFont ?? font;
          default:
            final symbol = _rtfSymbols[word];
            if (symbol != null) {
              emit(symbol);
            } else if (pending > 0 && !skip) {
              pending--;
            }
        }
        continue;
      }
      i += 2;
      switch (d) {
        case 0x2A: // \*
          if (atGroupStart) skip = true;
        case 0x27: // \'hh
          final hi = i < n ? hexDigit(rtf.codeUnitAt(i)) : null;
          final lo = i + 1 < n ? hexDigit(rtf.codeUnitAt(i + 1)) : null;
          // Not two hex digits: the bad escape is skipped, nothing else.
          if (hi != null && lo != null) {
            i += 2;
            emitByte(hi * 16 + lo);
          }
        case 0x5C || 0x7B || 0x7D:
          emit(String.fromCharCode(d));
        case 0x7E: // \~ non-breaking space
          emit('\u00A0');
        case 0x5F: // \_ non-breaking hyphen
          emit('-');
        case 0x0A || 0x0D: // backslash + line end = \par
          emit('\n');
      }
      continue;
    }
    groupStart = false;
    i++;
    if (c == 0x0A || c == 0x0D) continue;
    emit(String.fromCharCode(c));
  }
  // Chinese, Japanese or Korean bytes in a double-byte code page: better
  // to say it can't be read than to import garbage.
  if (undecodable > 0) throw const FormatException('double-byte code page');
  // Indents before list numbers and bullets ("\t1.\t", "·\t").
  return out.toString().replaceAll(
    RegExp('^[ \\t\u00A0]+', multiLine: true),
    '',
  );
}

// ---------------------------------------------------------------------------
// Word (.docx — also Google Docs and Pages "Download as Word")

Iterable<XmlElement> _children(XmlElement? e, [String? local]) => e == null
    ? const []
    : e.childElements.where((c) => local == null || c.name.local == local);

XmlElement? _child(XmlElement? e, String local) =>
    _children(e, local).firstOrNull;

String? _attr(XmlElement? e, String local) {
  if (e == null) return null;
  for (final a in e.attributes) {
    if (a.name.local == local) return a.value;
  }
  return null;
}

/// Heading level from a style name: Title is 1, "heading N" is N + 1 (so a
/// Title above Heading 1 sections is told apart from them).
int? _headingLevelFor(String name) {
  final n = name.toLowerCase().replaceAll(' ', '');
  if (n == 'title') return 1;
  final m = RegExp(r'^heading([1-9])$').firstMatch(n);
  return m == null ? null : int.parse(m[1]!) + 1;
}

Map<String, int> _docxStyles(String? stylesXml) {
  if (stylesXml == null) return const {};
  final XmlDocument doc;
  try {
    doc = XmlDocument.parse(stylesXml);
  } catch (_) {
    return const {};
  }
  final levels = <String, int>{};
  final basedOn = <String, String>{};
  for (final s in doc.descendants.whereType<XmlElement>()) {
    if (s.name.local != 'style') continue;
    final id = _attr(s, 'styleId');
    if (id == null) continue;
    final outline = int.tryParse(
      _attr(_child(_child(s, 'pPr'), 'outlineLvl'), 'val') ?? '',
    );
    final level =
        _headingLevelFor(_attr(_child(s, 'name'), 'val') ?? '') ??
        _headingLevelFor(id) ??
        (outline != null && outline < 9 ? outline + 2 : null);
    if (level != null) levels[id] = level;
    final base = _attr(_child(s, 'basedOn'), 'val');
    if (base != null) basedOn[id] = base;
  }
  for (final id in basedOn.keys) {
    var at = id;
    for (var hop = 0; hop < 8 && !levels.containsKey(id); hop++) {
      final base = basedOn[at];
      if (base == null) break;
      if (levels[base] case final level?) levels[id] = level;
      at = base;
    }
  }
  return levels;
}

_Doc _fromDocx(String documentXml, String? stylesXml) {
  final doc = XmlDocument.parse(documentXml);
  final styles = _docxStyles(stylesXml);
  final lines = <String>[];
  // Text boxes met in a paragraph: their lines follow the paragraph.
  final boxes = <XmlElement>[];
  void findBoxes(XmlElement e) {
    for (final c in e.childElements) {
      if (c.name.local == 'txbxContent') {
        boxes.add(c);
      } else {
        findBoxes(c);
      }
    }
  }

  void runs(XmlElement e, StringBuffer sb) {
    for (final c in e.childElements) {
      switch (c.name.local) {
        case 't':
          sb.write(c.innerText);
        case 'tab' || 'ptab':
          sb.write(' ');
        case 'br' || 'cr':
          sb.write('\n');
        case 'noBreakHyphen':
          sb.write('-');
        case 'AlternateContent':
          // Word's choice for older readers: an emoji typed from the emoji
          // panel is in the fallback as plain text, a text box as VML.
          final pick = _child(c, 'Fallback') ?? _child(c, 'Choice');
          if (pick != null) runs(pick, sb);
        case 'drawing' || 'pict':
          findBoxes(c);
        case 'symEx':
          // An emoji or symbol saved without a fallback.
          final code = int.tryParse(_attr(c, 'char') ?? '', radix: 16);
          if (code != null && code > 0 && code <= 0x10FFFF) {
            sb.writeCharCode(code);
          }
        case 'del' ||
            'moveFrom' ||
            'delText' ||
            'instrText' ||
            'pPr' ||
            'rPr' ||
            'object' ||
            'footnoteReference' ||
            'endnoteReference' ||
            'commentReference' ||
            'sdtPr' ||
            'fldChar':
          break;
        default:
          runs(c, sb);
      }
    }
  }

  int levelOf(XmlElement p) {
    final pPr = _child(p, 'pPr');
    final style = _attr(_child(pPr, 'pStyle'), 'val');
    if (style != null) {
      final level = styles[style] ?? _headingLevelFor(style);
      if (level != null) return level;
    }
    final outline = int.tryParse(_attr(_child(pPr, 'outlineLvl'), 'val') ?? '');
    return outline != null && outline < 9 ? outline + 2 : 0;
  }

  void paragraph(XmlElement p) {
    final sb = StringBuffer();
    runs(p, sb);
    final text = sb.toString();
    final level = levelOf(p);
    if (level > 0 && text.trim().isNotEmpty) {
      lines.add(
        '${'#' * math.min(level, 6)} ${text.replaceAll('\n', ' ').trim()}',
      );
    } else {
      lines.add(text);
    }
  }

  void blocks(XmlElement e) {
    for (final c in e.childElements) {
      switch (c.name.local) {
        case 'p':
          paragraph(c);
          final found = List.of(boxes);
          boxes.clear();
          found.forEach(blocks);
        case 'tbl':
          for (final row in _children(c, 'tr')) {
            for (final cell in _children(row, 'tc')) {
              blocks(cell);
            }
          }
        case 'sectPr' || 'del' || 'moveFrom' || 'sdtPr':
          break;
        case 'AlternateContent':
          final pick = _child(c, 'Fallback') ?? _child(c, 'Choice');
          if (pick != null) blocks(pick);
        default:
          blocks(c);
      }
    }
  }

  final body = doc.descendants.whereType<XmlElement>().firstWhere(
    (e) => e.name.local == 'body',
    orElse: () => doc.rootElement,
  );
  blocks(body);
  return (body: lines.join('\n'), title: null);
}

// ---------------------------------------------------------------------------
// OpenDocument text (.odt — LibreOffice, Google Docs, Pages)

_Doc _fromOdt(String contentXml) {
  final doc = XmlDocument.parse(contentXml);
  final parents = <String, String>{};
  for (final s in doc.descendants.whereType<XmlElement>()) {
    if (s.name.local != 'style') continue;
    final name = _attr(s, 'name');
    final parent = _attr(s, 'parent-style-name');
    if (name != null && parent != null) parents[name] = parent;
  }
  String styleOf(String? name) {
    var at = name ?? '';
    for (var hop = 0; hop < 8 && parents.containsKey(at); hop++) {
      at = parents[at]!;
    }
    return at.replaceAll('_20_', ' ');
  }

  final lines = <String>[];
  void inline(XmlNode node, StringBuffer sb) {
    for (final c in node.children) {
      if (c is XmlText || c is XmlCDATA) {
        sb.write(c.value!.replaceAll(RegExp(r'[ \t\r\n]+'), ' '));
      } else if (c is XmlElement) {
        switch (c.name.local) {
          case 's':
            sb.write(
              ' ' * (int.tryParse(_attr(c, 'c') ?? '') ?? 1).clamp(1, 80),
            );
          case 'tab':
            sb.write(' ');
          case 'line-break':
            sb.write('\n');
          case 'note' ||
              'annotation' ||
              'annotation-end' ||
              'frame' ||
              'change' ||
              'change-start' ||
              'change-end' ||
              'ruby-text' ||
              'note-citation' ||
              'soft-page-break':
            break;
          default:
            inline(c, sb);
        }
      }
    }
  }

  void line(XmlElement e, int level) {
    final sb = StringBuffer();
    inline(e, sb);
    final text = sb.toString().trim();
    lines.add(
      level > 0 && text.isNotEmpty
          ? '${'#' * math.min(level, 6)} ${text.replaceAll('\n', ' ')}'
          : text,
    );
  }

  void blocks(XmlElement e) {
    for (final c in e.childElements) {
      switch (c.name.local) {
        case 'h':
          final outline = int.tryParse(_attr(c, 'outline-level') ?? '') ?? 1;
          line(c, outline + 1);
        case 'p':
          final style = styleOf(_attr(c, 'style-name'));
          line(c, _headingLevelFor(style) ?? 0);
        case 'list' ||
            'list-item' ||
            'list-header' ||
            'section' ||
            'table' ||
            'table-header-rows' ||
            'table-rows' ||
            'table-row-group' ||
            'table-row' ||
            'table-cell':
          blocks(c);
      }
    }
  }

  final text = doc.descendants.whereType<XmlElement>().where(
    (e) => e.name.local == 'text' && e.parentElement?.name.local == 'body',
  );
  for (final t in text) {
    blocks(t);
  }
  return (body: lines.join('\n'), title: null);
}

// ---------------------------------------------------------------------------
// Evernote (.enex): one script per note

ImportResult _fromEnex(String text, String? fileName) {
  final XmlDocument doc;
  try {
    doc = XmlDocument.parse(text.replaceFirst('\uFEFF', ''));
  } catch (_) {
    return const ImportFailed(ImportFailure.unreadable);
  }
  final notes = doc.findAllElements('note').toList();
  final scripts = <ImportedScript>[];
  ImportFailure? failure;
  for (final note in notes) {
    final html = _fromHtml(note.getElement('content')?.innerText ?? '');
    final result = _finish(
      html,
      explicitTitle: note.getElement('title')?.innerText,
      fileName: notes.length == 1 ? fileName : null,
      pasted: false,
      converted: true,
    );
    switch (result) {
      case ImportedScripts(scripts: final found):
        scripts.addAll(found);
      case ImportFailed(:final reason):
        failure ??= reason;
      case ImportedBackup():
        break;
    }
  }
  if (scripts.isNotEmpty) return ImportedScripts(scripts);
  return ImportFailed(failure ?? ImportFailure.empty);
}

// ---------------------------------------------------------------------------
// Single-file web pages (.mht, .mhtml: OneNote, Word "Save as Web Page")

ImportResult _fromMht(String text, String? title, String? fileName) {
  final source = text.replaceAll('\r\n', '\n');
  final split = source.indexOf('\n\n');
  if (split < 0) return const ImportFailed(ImportFailure.unsupportedFormat);
  final boundary = RegExp(
    r'boundary\s*=\s*"?([^"\s;]+)"?',
    caseSensitive: false,
  ).firstMatch(source.substring(0, split))?[1];
  final parts = boundary == null
      ? [source]
      : source.split('--$boundary').skip(1);
  String? plain;
  for (final raw in parts) {
    final part = raw.startsWith('\n') ? raw.substring(1) : raw;
    final end = part.indexOf('\n\n');
    if (end < 0) continue;
    // Header lines may be folded onto the next line.
    final headers = part
        .substring(0, end)
        .replaceAll(RegExp(r'\n[ \t]+'), ' ')
        .toLowerCase();
    final type = RegExp(r'content-type:\s*([\w/+.-]+)').firstMatch(headers)?[1];
    if (type != 'text/html' && type != 'text/plain') continue;
    final body = _mimeBody(part.substring(end + 2), headers);
    if (type == 'text/html') {
      return _finish(
        _fromHtml(body),
        explicitTitle: title,
        fileName: fileName,
        pasted: false,
        converted: true,
      );
    }
    plain ??= body;
  }
  if (plain == null) return const ImportFailed(ImportFailure.unsupportedFormat);
  return _finish(
    (body: plain, title: null),
    explicitTitle: title,
    fileName: fileName,
    pasted: false,
    converted: false,
  );
}

/// The text of one part of a MIME message, decoded from quoted-printable or
/// base64 in its character set.
String _mimeBody(String body, String headers) {
  final encoding = RegExp(r'content-transfer-encoding:\s*([\w-]+)')
      .firstMatch(headers)?[1];
  final charset = RegExp(r'charset\s*=\s*"?([\w-]+)').firstMatch(headers)?[1];
  final List<int> bytes;
  switch (encoding) {
    case 'quoted-printable':
      bytes = _quotedPrintable(body);
    case 'base64':
      var data = body.replaceAll(RegExp(r'[^A-Za-z0-9+/]'), '');
      data = data.padRight((data.length + 3) ~/ 4 * 4, '=');
      bytes = base64.decode(data);
    default:
      return body; // already text
  }
  if (charset == 'utf-8' || charset == 'utf8') {
    return utf8.decode(bytes, allowMalformed: true);
  }
  if (charset == 'windows-1252' ||
      charset == 'iso-8859-1' ||
      charset == 'us-ascii') {
    return _singleByte(bytes, _cp1252);
  }
  if (charset != null && charset.startsWith('windows-')) {
    final map = _codePage(int.tryParse(charset.substring(8)) ?? 1252);
    if (map != null) return _singleByte(bytes, map);
  }
  return decodeText(bytes);
}

List<int> _quotedPrintable(String s) {
  final out = <int>[];
  int? hex(int i) {
    if (i >= s.length) return null;
    final c = s.codeUnitAt(i) | 0x20; // lower case
    if (c >= 0x30 && c <= 0x39) return c - 0x30;
    if (c >= 0x61 && c <= 0x66) return c - 0x61 + 10;
    return null;
  }

  for (var i = 0; i < s.length; i++) {
    final c = s.codeUnitAt(i);
    if (c == 0x3D) {
      // =
      if (i + 1 < s.length && s.codeUnitAt(i + 1) == 0x0A) {
        i++; // soft line break
        continue;
      }
      final hi = hex(i + 1);
      final lo = hex(i + 2);
      if (hi != null && lo != null) {
        out.add(hi * 16 + lo);
        i += 2;
        continue;
      }
    }
    if (c < 0x80) {
      out.add(c);
    } else {
      out.addAll(utf8.encode(String.fromCharCode(c)));
    }
  }
  return out;
}

// ---------------------------------------------------------------------------
// Google Keep (Google Takeout .json)

_Doc? _fromKeepJson(String text) {
  try {
    final json = jsonDecode(text);
    if (json is! Map) return null;
    final title = json['title'] is String ? json['title'] as String : null;
    if (json['textContent'] is String) {
      return (body: json['textContent'] as String, title: title);
    }
    if (json['listContent'] is List) {
      final items = [
        for (final item in json['listContent'] as List)
          if (item is Map && item['text'] is String) item['text'] as String,
      ];
      return (body: items.join('\n'), title: title);
    }
  } catch (_) {
    // Not JSON after all.
  }
  return null;
}

// ---------------------------------------------------------------------------
// Subtitles (.srt, .vtt): what was said, one line per cue

final _cueTime = RegExp(
  r'(\d{1,2}:)?\d{1,2}:\d{2}[,.]\d{1,3}\s*-->\s*(\d{1,2}:)?\d{1,2}:\d{2}[,.]\d{1,3}',
);

String _fromSubtitles(String text) {
  final lines = text
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .split('\n');
  // YouTube's automatic captions roll: each cue repeats the line before,
  // with word timings like <00:00:03.000> in it.
  final rolling = RegExp(r'<\d{1,2}:\d{2}[:.]').hasMatch(text);
  final number = RegExp(r'^\d+$');
  final out = <String>[];
  var previous = <String>[];
  var i = 0;
  while (i < lines.length) {
    // Headers, NOTE and STYLE blocks and cue numbers come before a timing.
    if (!_cueTime.hasMatch(lines[i])) {
      i++;
      continue;
    }
    // The cue's text runs to a blank line or to the next timing line
    // (machine-made subtitles often have no blank lines).
    final cue = <String>[];
    var j = i + 1;
    while (j < lines.length &&
        lines[j].trim().isNotEmpty &&
        !_cueTime.hasMatch(lines[j])) {
      cue.add(lines[j].trim());
      j++;
    }
    if (j < lines.length &&
        _cueTime.hasMatch(lines[j]) &&
        cue.isNotEmpty &&
        number.hasMatch(cue.last)) {
      cue.removeLast(); // the next cue's number
    }
    i = j;
    final said = [
      for (final l in cue)
        _entities
            .decode(
              l
                  .replaceAll(RegExp(r'<[^>]{0,200}>'), '')
                  .replaceAll(RegExp(r'\{\\[^}]{0,200}\}'), ''),
            )
            .trim(),
    ].where((l) => l.isNotEmpty).toList();
    // A line said twice in a row stays twice; only captions that roll
    // (each cue repeating the one before) lose the repeat.
    final fresh = rolling
        ? said.where((l) => !previous.contains(l)).toList()
        : (said.length > 1 && previous.isNotEmpty && said.first == previous.last
              ? said.sublist(1)
              : said);
    previous = said;
    if (fresh.isNotEmpty) out.add(fresh.join(' '));
  }
  return out.join('\n');
}
