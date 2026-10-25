// Import edge cases: a saved text file comes back as it was, shares fall
// back to their text, unreadable shares say so, and zip bombs are refused.
import 'dart:convert';
import 'dart:io' show ZLibCodec;
import 'dart:typed_data';

import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/main.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/entitlements.dart';
import 'package:aprompter/services/incoming_shares.dart';
import 'package:aprompter/services/purchase_service.dart';
import 'package:aprompter/services/script_import.dart';
import 'package:aprompter/services/storage.dart';
import 'package:archive/archive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _en = lookupAppLocalizations(const Locale('en'));

ImportedScript _single(ImportResult result) {
  expect(result, isA<ImportedScripts>());
  return (result as ImportedScripts).scripts.single;
}

ImportFailure? _failure(ImportResult result) =>
    result is ImportFailed ? result.reason : null;

/// One file in a zip written by hand, so the sizes it claims can lie.
class _Entry {
  _Entry(this.name, this.packed, this.crc, this.size, {this.link = false})
    : method = 8;

  /// [packed] is bzip2 data that unpacks to [size] bytes with [crc].
  _Entry.bzip2(this.name, this.packed, this.crc, this.size, {this.link = false})
    : method = 12;

  /// [chunks] deflated one after another, as one file of their total size.
  factory _Entry.of(
    String name,
    Iterable<List<int>> chunks, {
    int? claimedSize,
    bool link = false,
  }) {
    final deflated = BytesBuilder(copy: false);
    final sink = ZLibCodec(raw: true).encoder
        .startChunkedConversion(ByteConversionSink.withCallback(deflated.add));
    var size = 0;
    var crc = 0;
    for (final chunk in chunks) {
      sink.add(chunk);
      size += chunk.length;
      crc = getCrc32(chunk, crc);
    }
    sink.close();
    return _Entry(
      name,
      deflated.takeBytes(),
      crc,
      claimedSize ?? size,
      link: link,
    );
  }

  final String name;
  final Uint8List packed;
  final int crc;
  final int size;

  /// A Unix symbolic link.
  final bool link;

  /// 8 deflate, 12 bzip2.
  final int method;
}

Uint8List _zip(List<_Entry> entries) {
  final out = BytesBuilder(copy: false);
  final central = BytesBuilder(copy: false);
  void u16(BytesBuilder b, int v) => b.add([v & 0xFF, (v >> 8) & 0xFF]);
  void u32(BytesBuilder b, int v) =>
      b.add([v & 0xFF, (v >> 8) & 0xFF, (v >> 16) & 0xFF, (v >> 24) & 0xFF]);
  for (final e in entries) {
    final name = utf8.encode(e.name);
    final offset = out.length;
    u32(out, 0x04034b50);
    u16(out, 20); // version needed
    u16(out, 0); // flags
    u16(out, e.method);
    u16(out, 0); // time
    u16(out, 0); // date
    u32(out, e.crc);
    u32(out, e.packed.length);
    u32(out, e.size);
    u16(out, name.length);
    u16(out, 0);
    out.add(name);
    out.add(e.packed);

    u32(central, 0x02014b50);
    u16(central, e.link ? 0x0314 : 20); // made by (Unix for a link)
    u16(central, 20);
    u16(central, 0);
    u16(central, e.method);
    u16(central, 0);
    u16(central, 0);
    u32(central, e.crc);
    u32(central, e.packed.length);
    u32(central, e.size);
    u16(central, name.length);
    u16(central, 0); // extra
    u16(central, 0); // comment
    u16(central, 0); // disk
    u16(central, 0); // internal attributes
    u32(central, e.link ? 0xA1FF << 16 : 0); // external attributes
    u32(central, offset);
    central.add(name);
  }
  final centralOffset = out.length;
  final centralBytes = central.takeBytes();
  out.add(centralBytes);
  u32(out, 0x06054b50);
  u16(out, 0);
  u16(out, 0);
  u16(out, entries.length);
  u16(out, entries.length);
  u32(out, centralBytes.length);
  u32(out, centralOffset);
  u16(out, 0);
  return out.takeBytes();
}

/// [megabytes] MB of spaces, a megabyte at a time.
Iterable<List<int>> _spaces(int megabytes) sync* {
  final mb = Uint8List(1024 * 1024)..fillRange(0, 1024 * 1024, 0x20);
  for (var i = 0; i < megabytes; i++) {
    yield mb;
  }
}

/// bzip2 of 100 MB of spaces: 113 bytes.
final _bzip2Bomb = base64.decode(
  'QlpoOTFBWSZTWbUiZb8BX44QAMAAAAggADCATUZCoCWpCoCXMUFZJlNZtSJlvwFfjhAAwAAACC'
  'AAMIBNRkKgJakKgJcxQVkmU1kGgnYGAGQGFADAABAAAAggADDMBSmmKARbEoBF4u5IpwoSFwnl'
  'cOA=',
);
const _bzip2BombSize = 100 * 1024 * 1024;
const _bzip2BombCrc = 3819605932;

_Entry _bzip2Note(String name, String text) {
  final bytes = utf8.encode(text);
  return _Entry.bzip2(
    name,
    BZip2Encoder().encodeBytes(bytes),
    getCrc32(bytes),
    bytes.length,
  );
}

const _wordNs =
    'xmlns:w="http://schemas.openxmlformats.org/wordprocessingml/2006/main"';

void main() {
  group('imp-3 Save as text file, then import, gives the same script', () {
    for (final title in [
      'Top 10 tips (2024)',
      'Notes (2)',
      'Plain title',
      'Q&A: the (1) thing',
      '(2024)',
      '(1)',
    ]) {
      test(title, () {
        const body = 'Hook goes here.\n\nThen the point, and a call to action.';
        final name = textFileName(title, fallback: 'Script');
        final text = scriptAsText(title, body);
        final script = _single(importFromFile(name, utf8.encode(text)));
        expect(script.title, title);
        expect(script.body, body);
      });
    }

    test('a downloaded copy "(1)" still finds the title', () {
      final script = _single(
        importFromFile(
          'Notes (2) (1).txt',
          utf8.encode(scriptAsText('Notes (2)', 'Body text here.')),
        ),
      );
      expect(script.title, 'Notes (2)');
      expect(script.body, 'Body text here.');
    });

    test('the download counter still goes from a file named after nothing '
        'in it', () {
      final script = _single(
        importFromFile('Ideas (1).txt', utf8.encode('Just one line of text.')),
      );
      expect(script.title, 'Ideas');
      expect(script.body, 'Just one line of text.');
    });

    test('a file named after nothing but a counter gets no title from it', () {
      final script = _single(
        importFromFile('(1).txt', utf8.encode('Hook first.\n\nThen more.')),
      );
      expect(script.title, isNull);
      expect(script.body, 'Hook first.\n\nThen more.');
    });
  });

  group('imp-4 a share falls back to its text', () {
    final png = Uint8List.fromList([0x89, 0x50, 0x4E, 0x47, 1, 2, 3, 4]);

    test('a file that cannot be imported: the text sent along is', () async {
      final result = await importShare(
        IncomingShare(
          name: 'photo.png',
          mimeType: 'image/png',
          bytes: png,
          text: 'Caption idea: show the before and after.',
        ),
      );
      expect(_single(result).body, 'Caption idea: show the before and after.');
    });

    test("when the text fails too, the file's reason is told", () async {
      final result = await importShare(
        IncomingShare(
          name: 'photo.png',
          bytes: png,
          text: 'https://example.com/photo',
        ),
      );
      expect(_failure(result), ImportFailure.unsupportedFormat);
    });

    test('a file that imports still wins over its text', () async {
      final result = await importShare(
        IncomingShare(
          name: 'Plan.txt',
          bytes: Uint8List.fromList(utf8.encode('From the file.')),
          text: 'Shared from Files',
        ),
      );
      expect(_single(result).body, 'From the file.');
    });
  });

  group('imp-5 a file native code could not read', () {
    test('is read from the queue and reported as unreadable', () async {
      final share = IncomingShare.fromMap({
        'name': 'Script.docx',
        'mimeType': 'application/msword',
        'unreadable': true,
      });
      expect(share.unreadable, isTrue);
      expect(share.bytes, isNull);
      expect(_failure(await importShare(share)), ImportFailure.unreadable);

      final nameless = IncomingShare.fromMap({'name': '', 'unreadable': true});
      expect(_failure(await importShare(nameless)), ImportFailure.unreadable);
      expect(IncomingShare.fromMap({'name': 'a.txt'}).unreadable, isFalse);
    });

    testWidgets('the home screen says it could not be read', (tester) async {
      SharedPreferences.setMockInitialValues({});
      const channel = MethodChannel('aprompter/import');
      final messenger = tester.binding.defaultBinaryMessenger;
      var pending = <Object?>[
        {'name': '', 'unreadable': true},
      ];
      messenger.setMockMethodCallHandler(channel, (call) async {
        if (call.method != 'takePending') return null;
        final out = pending;
        pending = [];
        return out;
      });
      addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
      tester.view.physicalSize = const Size(1080, 2340);
      tester.view.devicePixelRatio = 3;
      addTearDown(tester.view.reset);
      final state = AppState(await Storage.open());
      final entitlements = Entitlements(isUnlimited: true);
      await tester.pumpWidget(
        AprompterApp(
          state: state,
          entitlements: entitlements,
          purchaseService: PurchaseService(entitlements: entitlements),
        ),
      );
      await tester.pumpAndSettle();
      expect(find.text(_en.importUnreadable), findsOneWidget);
      expect(state.scripts, hasLength(1)); // just the welcome script
    });
  });

  group('play-6 zip bombs are refused without inflating them', () {
    test('a Word file whose text claims 2 KB but inflates to 100 MB', () {
      final docx = _zip([
        _Entry.of('[Content_Types].xml', [utf8.encode('<Types/>')]),
        _Entry.of('word/document.xml', [
          utf8.encode('<w:document $_wordNs><w:body><w:p><w:r><w:t>Hi'),
          ..._spaces(100),
          utf8.encode('</w:t></w:r></w:p></w:body></w:document>'),
        ], claimedSize: 2048),
      ]);
      expect(docx.length, lessThan(maxImportBytes));
      expect(
        _failure(importFromFile('bomb.docx', docx)),
        ImportFailure.tooLarge,
      );
    });

    test('a notes zip: the bomb is skipped, the real note comes in', () {
      final zip = _zip([
        _Entry.of('bomb.txt', _spaces(50), claimedSize: 10),
        _Entry.of('Idea.txt', [utf8.encode('A real note to film.')]),
      ]);
      final result = importFromFile('notes.zip', zip);
      expect(_single(result).body, 'A real note to film.');
    });

    test('a zip of nothing but bombs says it is too large', () {
      final bomb = _Entry.of('bomb.md', _spaces(12), claimedSize: 10);
      final zip = _zip([
        for (var i = 0; i < 12; i++)
          _Entry('bomb$i.md', bomb.packed, bomb.crc, bomb.size),
      ]);
      expect(
        _failure(importFromFile('notes.zip', zip)),
        ImportFailure.tooLarge,
      );
    });

    test('a symbolic link that inflates to 100 MB is refused before the zip '
        'is opened', () {
      final zip = _zip([
        _Entry.of('link', _spaces(100), claimedSize: 10, link: true),
        _Entry.of('Idea.txt', [utf8.encode('A real note to film.')]),
      ]);
      expect(
        _failure(importFromFile('notes.zip', zip)),
        ImportFailure.tooLarge,
      );
    });

    test('a bzip2 symbolic link is refused before the zip is opened', () {
      // bzip2 packs 100 MB into 113 bytes, well under the size a deflated
      // link is allowed; opening the zip would unpack all of it.
      final zip = _zip([
        _Entry.bzip2(
          'link',
          _bzip2Bomb,
          _bzip2BombCrc,
          _bzip2BombSize,
          link: true,
        ),
        _Entry.of('Idea.txt', [utf8.encode('A real note to film.')]),
      ]);
      expect(zip.length, lessThan(1024));
      expect(
        _failure(importFromFile('notes.zip', zip)),
        ImportFailure.tooLarge,
      );
    });

    test('a short ordinary symbolic link does not stop the zip', () {
      final zip = _zip([
        _Entry.of('link', [utf8.encode('Idea.txt')], link: true),
        _Entry.of('Idea.txt', [utf8.encode('A real note to film.')]),
      ]);
      expect(
        _single(importFromFile('notes.zip', zip)).body,
        'A real note to film.',
      );
    });

    test('bzip2 notes still import; a bzip2 bomb among them is skipped', () {
      final zip = _zip([
        _Entry.bzip2('bomb.txt', _bzip2Bomb, _bzip2BombCrc, 10),
        _bzip2Note('b.txt', 'bzip note'),
        _Entry.of('Idea.md', [utf8.encode('A real note to film.')]),
      ]);
      final result = importFromFile('notes.zip', zip);
      expect(
        (result as ImportedScripts).scripts.map((s) => '${s.title}|${s.body}'),
        ['b|bzip note', 'Idea|A real note to film.'],
      );
    });

    test('a zip of nothing but a bzip2 bomb says it is too large', () {
      final zip = _zip([
        _Entry.bzip2('bomb.md', _bzip2Bomb, _bzip2BombCrc, 10),
      ]);
      expect(
        _failure(importFromFile('notes.zip', zip)),
        ImportFailure.tooLarge,
      );
    });

    test('ordinary documents still import', () {
      final docx = _zip([
        _Entry.of('word/document.xml', [
          utf8.encode(
            '<w:document $_wordNs><w:body><w:p><w:r><w:t>Hello from Word.'
            '</w:t></w:r></w:p></w:body></w:document>',
          ),
        ]),
      ]);
      expect(
        _single(importFromFile('Talk.docx', docx)).body,
        'Hello from Word.',
      );

      final archive = Archive()
        ..addFile(ArchiveFile.string('a.md', 'First note.'))
        ..addFile(ArchiveFile.string('b.txt', 'Second note.'));
      final result = importFromFile(
        'notes.zip',
        ZipEncoder().encodeBytes(archive),
      );
      expect((result as ImportedScripts).scripts.map((s) => s.body), [
        'First note.',
        'Second note.',
      ]);
    });
  });
}
