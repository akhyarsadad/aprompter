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
/// share's subject (Google Keep sends the note title there).
ImportResult importFromText(String text, {String? title}) {
  if (text.length > maxImportChars) {
    return const ImportFailed(ImportFailure.tooLarge);
  }
  if (cleanPastedText(text).trim().isEmpty) {
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
const _backgroundBytes = 256 * 1024;

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
Future<ImportResult> importFromTextAsync(String text, {String? title}) async {
  if (text.length < _backgroundBytes) {
    return importFromText(text, title: title);
  }
  try {
    return await Isolate.run(() => importFromText(text, title: title));
  } catch (_) {
    return importFromText(text, title: title);
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
    final runes = name.runes.toList();
    if (runes.length > 80) {
      name = String.fromCharCodes(runes.take(80))
          .replaceAll(RegExp(r'[.\s]+$'), '');
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

/// Removes what pasting from Google Docs, Word, Notes or WhatsApp brings
/// along: Windows and Unicode line ends, zero-width spaces, byte-order marks,
/// soft hyphens, non-breaking spaces, tabs, control characters, list bullets
/// and spaces at line ends. Zero-width joiners stay: Persian, Indic scripts
/// and emoji need them.
String cleanPastedText(String text) => text
    .replaceAll('\r\n', '\n')
    .replaceAll(RegExp('[\r\u2028\u2029\u000B\u000C\u0085]'), '\n')
    .replaceAll(RegExp('[\u200B\u2060\uFEFF\u00AD]'), '')
    .replaceAll(RegExp('[\u00A0\u202F\t]'), ' ')
    .replaceAll(RegExp('[\u0000-\u0008\u000E-\u001F\u007F-\u009F]'), '')
    .replaceAll(RegExp(r'^[ ]*[•◦▪▫●○■□‣⁃–—-][ ]+', multiLine: true), '')
    .replaceAll(RegExp(r'[ ]+\n'), '\n');

/// [cleanPastedText], then at most one blank line in a row and no blank
/// lines or spaces around the whole text.
String normalizeScriptText(String text) =>
    cleanPastedText(text).replaceAll(RegExp(r'\n{3,}'), '\n\n').trim();

// ---------------------------------------------------------------------------
// Bytes to text

/// Decodes a text file: UTF-8 (with or without a byte-order mark), UTF-16
/// (with a byte-order mark, or recognised by its zero bytes), otherwise
/// Windows-1252, the encoding of old Windows text files.
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
  final sample = math.min(bytes.length, 4096);
  var even = 0;
  var odd = 0;
  for (var i = 0; i < sample; i++) {
    if (bytes[i] != 0) continue;
    if (i.isEven) {
      even++;
    } else {
      odd++;
    }
  }
  if (even + odd > sample ~/ 8) {
    if (odd > even * 3) return _utf16(bytes, 0, littleEndian: true);
    if (even > odd * 3) return _utf16(bytes, 0, littleEndian: false);
  }
  try {
    return utf8.decode(bytes);
  } on FormatException {
    return _singleByte(bytes, _cp1252);
  }
}

String _utf16(List<int> bytes, int start, {required bool littleEndian}) {
  final units = <int>[];
  for (var i = start; i + 1 < bytes.length; i += 2) {
    units.add(
      littleEndian
          ? bytes[i] | (bytes[i + 1] << 8)
          : (bytes[i] << 8) | bytes[i + 1],
    );
  }
  return String.fromCharCodes(units);
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

/// Mostly control characters: a binary file, not text.
bool _looksBinary(String text) {
  final n = math.min(text.length, 8192);
  var bad = 0;
  for (var i = 0; i < n; i++) {
    final c = text.codeUnitAt(i);
    if (c == 0) return true;
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

enum _Format { plain, markdown, html, rtf, enex, srt, vtt }

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
    case 'text/plain':
      return _Format.plain;
  }
  return null;
}

final _srtStart = RegExp(
  r'^\s*\d+[ \t]*\n[ \t]*(\d{1,2}:)?\d{1,2}:\d{2}[,.]\d{1,3}[ \t]*-->',
);
final _htmlStart = RegExp(
  r'^<(!doctype html|html|head|body|meta|div|p|span|h[1-6]|table|ul|ol|br|b|strong|font|style)\b',
);

/// Formats recognised from the text itself, whatever the file is called.
_Format? _sniff(String text, {bool allowHtml = true}) {
  final head = text
      .substring(0, math.min(text.length, 4096))
      .replaceFirst('\uFEFF', '')
      .trimLeft();
  final lower = head.toLowerCase();
  if (lower.startsWith(r'{\rtf')) return _Format.rtf;
  if (head.startsWith('WEBVTT')) return _Format.vtt;
  if ((lower.startsWith('<?xml') ||
          lower.startsWith('<!doctype en-export') ||
          lower.startsWith('<en-export')) &&
      lower.contains('<en-export')) {
    return _Format.enex;
  }
  if (allowHtml &&
      (_htmlStart.hasMatch(lower) ||
          (lower.startsWith('<?xml') && lower.contains('<html')))) {
    return _Format.html;
  }
  if (_srtStart.hasMatch(head)) return _Format.srt;
  return null;
}

final _tableSeparator = RegExp(r'^\|?\s*:?-+:?\s*(\|\s*:?-+:?\s*)*\|?\s*$');

/// Strong signs of Markdown in shared or pasted text — things APrompter
/// markup would otherwise show as clutter.
bool _looksLikeMarkdown(String text) {
  if (_frontMatter.hasMatch(text)) return true;
  final signals = [
    RegExp(r'!?\[[^\]\n]*\]\((https?:|mailto:|/|\.|#)[^)\n]*\)'),
    RegExp(r'\[\[[^\]\n]+\]\]'),
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

    final text = decodeText(bytes);
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
    if (text.length > maxImportChars) {
      return const ImportFailed(ImportFailure.tooLarge);
    }

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
    final sniffed = _sniff(text, allowHtml: byName != _Format.markdown);
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
    zip = ZipDecoder().decodeBytes(bytes);
  } catch (_) {
    return const ImportFailed(ImportFailure.unreadable);
  }
  if (zip.files.isEmpty) return const ImportFailed(ImportFailure.unreadable);
  String? entryText(String path) {
    final file = zip.findFile(path);
    if (file == null || !file.isFile) return null;
    if (file.size > _maxXmlBytes) throw const _TooLarge();
    return decodeText(file.content);
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
    budget -= file.size;
    if (file.size > maxImportBytes || budget < 0) {
      failure ??= ImportFailure.tooLarge;
      continue;
    }
    final result = _importFile(
      _entryName(parts, ext, zipName),
      file.content,
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
}) {
  final backup = _backupIn(text);
  if (backup != null) return ImportedBackup(backup);
  if (format == _Format.enex) return _fromEnex(text, fileName);
  final _Doc doc = switch (format) {
    _Format.plain => (body: text, title: null),
    _Format.markdown => _fromMarkdown(text),
    _Format.html => _fromHtml(text),
    _Format.rtf => (body: _fromRtf(text), title: null),
    _Format.srt => (body: _fromSubtitles(text), title: null),
    _Format.vtt => (body: _fromSubtitles(text), title: null),
    _Format.enex => (body: '', title: null),
  };
  return _finish(
    doc,
    explicitTitle: explicitTitle,
    fileName: fileName,
    pasted: pasted,
    converted: format != _Format.plain,
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

String _stripEmphasis(String s) => s.replaceAllMapped(
  RegExp(
    r'(?<![\\*\p{L}\p{N}])\*\*?(?![\s*])(.+?)(?<![\s\\*])\*\*?(?![\p{L}\p{N}*])',
    unicode: true,
  ),
  (m) => m[1]!,
);

String? _cleanTitle(String? raw) {
  if (raw == null) return null;
  final t = _stripEmphasis(
    cleanPastedText(raw)
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim()
        .replaceFirst(RegExp(r'^#+\s+'), ''),
  ).trim();
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
  final title = _cleanTitle(m[2]);
  if (rest.isEmpty || title == null) return null;
  return (title, rest);
}

/// The title of a file named [fileName]: no folder, no extension, no
/// " (1)" download counter, no Notion page id.
String? _fileTitle(String fileName) {
  final base = fileName
      .split(RegExp(r'[/\\]'))
      .last
      .replaceFirst(RegExp(r'(?<=.)\.[A-Za-z0-9]{1,8}$'), '')
      .replaceFirst(RegExp(r'\s+[0-9a-f]{32}$'), '')
      .replaceFirst(RegExp(r'\s*\(\d+\)$'), '');
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

/// A short first line of shared or pasted text that reads like a title:
/// Apple Notes and Samsung Notes put the note title there.
(String, String)? _firstLineTitle(String body) {
  final split = _splitFirstLine(body);
  if (split == null) return null;
  var (line, rest) = split;
  // A wholly bold first line (Apple Notes' title style) is still a title.
  final bold = RegExp(r'^\*([^*\s][^*]*)\*$').firstMatch(line);
  if (bold != null) line = bold[1]!.trim();
  if (rest.isEmpty || line.length > 60) return null;
  if (RegExp(r'[.!?…。！？؟।۔:;,]$').hasMatch(line)) return null;
  if (line.startsWith('#') ||
      line.startsWith('//') ||
      line.contains('*') ||
      _pauseMark.hasMatch(line) ||
      _urlLine.hasMatch(line) ||
      RegExp(r'^\d+[.)]\s').hasMatch(line)) {
    return null;
  }
  return (line, rest);
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
}) {
  var body = normalizeScriptText(doc.body);
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
      if (split != null &&
          split.$2.isNotEmpty &&
          _namesFile(split.$1, fromName)) {
        title = _cleanTitle(split.$1);
        body = split.$2;
        fromBody = true;
      } else {
        title = fromName;
      }
    }
  }
  if (title == null && fileName == null && pasted) {
    if (_firstLineTitle(body) case (final t, final rest)) {
      title = _cleanTitle(t);
      body = rest;
      fromBody = true;
    }
  }
  if (converted) {
    body = body.replaceAll(RegExp(r'^#{2,6}(?=[ ])', multiLine: true), '#');
  }
  if (title != null && !fromBody) {
    final split = _splitFirstLine(body);
    if (split != null && _squash(split.$1) == _squash(title)) body = split.$2;
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

_Doc _fromMarkdown(String source) {
  var text = source.replaceAll('\r\n', '\n').replaceAll('\r', '\n');
  String? title;
  final fm = _frontMatter.firstMatch(text);
  if (fm != null && (fm[1] == '+++') == (fm[3] == '+++')) {
    final meta = fm[2]!;
    if (meta.trim().isEmpty ||
        RegExp(r'^[\w"\x27 -]+\s*[:=]', multiLine: true).hasMatch(meta)) {
      final t = RegExp(
        r'^title\s*[:=]\s*(.+)$',
        multiLine: true,
        caseSensitive: false,
      ).firstMatch(meta);
      if (t != null) {
        title = t[1]!.trim().replaceAll(RegExp(r'''^["']|["']$'''), '');
      }
      text = text.substring(fm.end);
    }
  }
  text = text
      .replaceAll(RegExp(r'<!--[\s\S]*?-->'), '')
      .replaceAll(RegExp(r'%%[\s\S]*?%%'), '');

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
        out.add(raw.trimRight());
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

String _mdInline(String input) {
  // Backslash escapes (not \*, which APrompter reads as a literal star).
  var s = input.replaceAllMapped(
    RegExp(r'''\\([!"#$%&'()+,\-./:;<=>?@\[\]^_`{|}~])'''),
    (m) => String.fromCharCode(_escapeBase + m[1]!.codeUnitAt(0)),
  );
  // Code spans keep their text exactly.
  final code = <String>[];
  s = s.replaceAllMapped(RegExp(r'(`+)(.+?)\1'), (m) {
    code.add(m[2]!.trim());
    return '$_codeOpen${code.length - 1}$_codeClose';
  });
  const link =
      r'\((?:[^()\s]|\([^()\s]*\))*(?:\s+(?:"[^"]*"|'
      "'[^']*'"
      r'|\([^)]*\)))?\s*\)';
  s = s
      .replaceAll(RegExp(r'!\[\[[^\]]*\]\]'), '')
      .replaceAll(RegExp(r'!\[[^\]]*\]' + link), '')
      .replaceAll(RegExp(r'!\[[^\]]*\]\[[^\]]*\]'), '')
      .replaceAllMapped(RegExp(r'\[\[([^\]|]*)(?:\|([^\]]*))?\]\]'), (m) {
        final alias = m[2]?.trim() ?? '';
        if (alias.isNotEmpty) return alias;
        final target = m[1]!.trim();
        final hash = target.indexOf('#');
        if (hash < 0) return target;
        final page = target.substring(0, hash).trim();
        return page.isNotEmpty
            ? page
            : target.substring(hash + 1).replaceAll('^', '').trim();
      })
      .replaceAllMapped(RegExp(r'\[([^\]]*)\]' + link), (m) => m[1]!)
      .replaceAllMapped(RegExp(r'\[([^\]]+)\]\[[^\]]*\]'), (m) => m[1]!)
      .replaceAllMapped(
        RegExp(r'<((?:https?|mailto):[^>\s]+)>', caseSensitive: false),
        (m) => m[1]!,
      )
      .replaceAll(RegExp(r'\[\^[^\]\s]+\]'), '')
      .replaceAll(RegExp(r'<br\s*/?>', caseSensitive: false), '\n')
      .replaceAll(RegExp(r'</?(b|strong)>', caseSensitive: false), '**')
      .replaceAll(RegExp(r'</?(i|em)>', caseSensitive: false), '*')
      .replaceAll(
        RegExp(
          r'</?(u|ins|mark|span|div|p|sup|sub|kbd|font|small|big|center|a|img|abbr|cite|q|s|strike|del|details|summary)\b[^>]*>',
          caseSensitive: false,
        ),
        '',
      )
      .replaceAllMapped(RegExp(r'~~(.+?)~~'), (m) => m[1]!)
      .replaceAllMapped(RegExp(r'==(?=\S)(.+?)(?<=\S)=='), (m) => '*${m[1]}*')
      .replaceAllMapped(
        RegExp(r'(?<![\\*])\*\*\*(?=\S)(.+?)(?<=\S)\*\*\*(?!\*)'),
        (m) => '*${m[1]}*',
      )
      .replaceAllMapped(
        RegExp(r'(?<![\\*])\*\*(?=\S)(.+?)(?<=\S)\*\*(?!\*)'),
        (m) => '*${m[1]}*',
      )
      .replaceAllMapped(
        RegExp(r'(?<![\w\\])___(?=\S)(.+?)(?<=\S)___(?!\w)'),
        (m) => '*${m[1]}*',
      )
      .replaceAllMapped(
        RegExp(r'(?<![\w\\])__(?=\S)(.+?)(?<=\S)__(?!\w)'),
        (m) => '*${m[1]}*',
      )
      .replaceAllMapped(
        RegExp(r'(?<![\w\\])_(?=[^\s_])(.+?)(?<=[^\s_])_(?!\w)'),
        (m) => '*${m[1]}*',
      )
      .replaceAllMapped(
        RegExp('$_codeOpen(\\d+)$_codeClose'),
        (m) => code[int.parse(m[1]!)],
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

_Doc _fromHtml(String source) {
  String? title;
  final t = RegExp(
    r'<title[^>]*>([\s\S]*?)</title\s*>',
    caseSensitive: false,
  ).firstMatch(source);
  if (t != null) {
    title = _entities
        .decode(t[1]!.replaceAll(RegExp(r'<[^>]*>'), ''))
        .replaceAll(RegExp(r'\s+'), ' ')
        .trim();
  }
  final boldClasses = <String>{};
  for (final style in RegExp(
    r'<style[^>]*>([\s\S]*?)</style\s*>',
    caseSensitive: false,
  ).allMatches(source)) {
    for (final rule in RegExp(r'([^{}]+)\{([^}]*)\}').allMatches(style[1]!)) {
      if (!_isBoldStyle(rule[2]!)) continue;
      for (final selector in rule[1]!.split(',')) {
        final m = RegExp(r'^[\w-]*\.([\w-]+)$').firstMatch(selector.trim());
        if (m != null) boldClasses.add(m[1]!);
      }
    }
  }
  final html = source
      .replaceAll(RegExp(r'<!--[\s\S]*?-->'), '')
      .replaceAll(
        RegExp(
          r'<(head|script|style|noscript|template|svg|math|iframe|object|title|en-crypt|xml)\b[\s\S]*?</\1\s*>',
          caseSensitive: false,
        ),
        '',
      );

  final out = _HtmlWriter();
  final open = <_HtmlElement>[];
  final tag = RegExp(
    r'''<(/?)([a-zA-Z][\w:-]*)((?:[^>"']|"[^"]*"|'[^']*')*)>|<![^>]*>|<\?[^>]*>''',
  );
  var at = 0;
  for (final m in tag.allMatches(html)) {
    if (m.start > at) out.text(html.substring(at, m.start));
    at = m.end;
    final name = m[2]?.toLowerCase();
    if (name == null) continue; // doctype, CDATA, processing instruction
    final attrs = m[3] ?? '';
    if (m[1] == '/') {
      final i = open.lastIndexWhere((e) => e.name == name);
      if (i < 0) continue;
      while (open.length > i) {
        out.end(open.removeLast());
      }
      continue;
    }
    final selfClosing = attrs.trimRight().endsWith('/');
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
    }
  }
  if (at < html.length) out.text(html.substring(at));
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
    _writes++;
  }

  void lineBreak() {
    final marks = _bold > 0 && _heading == 0;
    if (marks) _out.write(_boldOff);
    _out.write('\n');
    if (marks) _out.write(_boldOn);
    _lineHasText = false;
    _writes++;
  }

  void block() {
    if (_lineHasText) lineBreak();
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
    }
    if (e.name == 'li' && ordered && _lists.isNotEmpty) {
      _out.write('${++_lists.last.number}. ');
      _lineHasText = true;
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
    if (e.block) {
      final empty = _writes == e.textMark;
      block();
      // An empty paragraph (Google Docs, Word) is a blank line.
      if (empty && (e.name == 'p' || e.name == 'div')) _out.write('\n');
    }
  }

  String result() => _out
      .toString()
      .split('\n')
      .map(_emphasis)
      .map((l) => l.replaceAllMapped(RegExp(r'(\S) {2,}'), (m) => '${m[1]} '))
      .join('\n');

  static String _emphasis(String line) {
    final plain = line.replaceAll(RegExp('[$_boldOn$_boldOff]'), '');
    if (plain.trimLeft().startsWith('#')) return plain;
    return line
        .replaceAllMapped(RegExp('$_boldOff(\\s*)$_boldOn'), (m) => m[1]!)
        .replaceAllMapped(
          RegExp('$_boldOn(\\s*)([^$_boldOn$_boldOff]*?)(\\s*)$_boldOff'),
          (m) => m[2]!.isEmpty ? '${m[1]}${m[3]}' : '${m[1]}*${m[2]}*${m[3]}',
        )
        .replaceAll(RegExp('[$_boldOn$_boldOff]'), '');
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
  final stack = <(bool, int)>[];
  var skip = false;
  var uc = 1;
  var pending = 0; // fallback characters to drop after \uN
  var groupStart = false;
  var codePage = _cp1252;
  final n = rtf.length;
  var i = 0;

  bool isLetter(int c) => (c >= 65 && c <= 90) || (c >= 97 && c <= 122);
  bool isDigit(int c) => c >= 48 && c <= 57;
  void emit(String s) {
    if (skip) return;
    if (pending > 0) {
      pending--;
      return;
    }
    out.write(s);
  }

  while (i < n) {
    final c = rtf.codeUnitAt(i);
    if (c == 0x7B) {
      // {
      stack.add((skip, uc));
      groupStart = true;
      pending = 0;
      i++;
      continue;
    }
    if (c == 0x7D) {
      // }
      if (stack.isNotEmpty) (skip, uc) = stack.removeLast();
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
              out.writeCharCode(param < 0 ? param + 65536 : param);
              pending = uc;
            }
          case 'uc':
            uc = math.max(0, param ?? 1);
          case 'ansicpg':
            codePage = param == 1251 ? _cp1251 : _cp1252;
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
          final hex = i + 2 <= n
              ? int.tryParse(rtf.substring(i, i + 2), radix: 16)
              : null;
          i += 2;
          if (hex != null) emit(String.fromCharCode(codePage(hex)));
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
  return out.toString();
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
        case 'del' ||
            'moveFrom' ||
            'delText' ||
            'instrText' ||
            'pPr' ||
            'rPr' ||
            'drawing' ||
            'pict' ||
            'object' ||
            'AlternateContent' ||
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
  final blocks = text
      .replaceAll('\r\n', '\n')
      .replaceAll('\r', '\n')
      .split(RegExp(r'\n[ \t]*\n'));
  final out = <String>[];
  var previous = <String>[];
  for (final block in blocks) {
    final lines = [
      for (final l in block.split('\n'))
        if (l.trim().isNotEmpty) l.trim(),
    ];
    if (lines.isEmpty) continue;
    final first = lines.first;
    if (first.startsWith('WEBVTT') ||
        first.startsWith('NOTE') ||
        first.startsWith('STYLE') ||
        first.startsWith('REGION')) {
      continue;
    }
    final at = lines.indexWhere(_cueTime.hasMatch);
    if (at < 0) continue;
    final cue = [
      for (final l in lines.skip(at + 1))
        _entities
            .decode(
              l
                  .replaceAll(RegExp(r'<[^>]*>'), '')
                  .replaceAll(RegExp(r'\{\\[^}]*\}'), ''),
            )
            .trim(),
    ].where((l) => l.isNotEmpty).toList();
    // Rolling captions (YouTube) repeat the previous cue's line.
    final fresh = cue.where((l) => !previous.contains(l)).toList();
    previous = cue;
    if (fresh.isNotEmpty) out.add(fresh.join(' '));
  }
  return out.join('\n');
}
