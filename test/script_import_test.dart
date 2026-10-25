// Getting scripts in from notes apps and files, and out as text files.
import 'dart:convert';
import 'dart:typed_data';

import 'package:aprompter/models/script.dart';
import 'package:aprompter/models/script_markup.dart';
import 'package:aprompter/services/backup.dart';
import 'package:aprompter/services/script_import.dart';
import 'package:archive/archive.dart';
import 'package:flutter_test/flutter_test.dart';

ImportedScript _one(ImportResult result) {
  expect(result, isA<ImportedScripts>(), reason: '$result');
  final scripts = (result as ImportedScripts).scripts;
  expect(scripts, hasLength(1));
  return scripts.single;
}

ImportFailure? _failure(ImportResult result) =>
    result is ImportFailed ? result.reason : null;

Uint8List _zip(Map<String, String> files) {
  final archive = Archive();
  for (final MapEntry(:key, :value) in files.entries) {
    archive.addFile(ArchiveFile.bytes(key, utf8.encode(value)));
  }
  return ZipEncoder().encodeBytes(archive);
}

Uint8List _utf16le(String s, {bool bom = true}) {
  final out = <int>[
    if (bom) ...[0xFF, 0xFE],
  ];
  for (final unit in s.codeUnits) {
    out
      ..add(unit & 0xFF)
      ..add(unit >> 8);
  }
  return Uint8List.fromList(out);
}

Uint8List _utf16be(String s) {
  final out = <int>[0xFE, 0xFF];
  for (final unit in s.codeUnits) {
    out
      ..add(unit >> 8)
      ..add(unit & 0xFF);
  }
  return Uint8List.fromList(out);
}

const _w = 'http://schemas.openxmlformats.org/wordprocessingml/2006/main';

String _docxDocument(String body) =>
    '<?xml version="1.0" encoding="UTF-8" standalone="yes"?>\n'
    '<w:document xmlns:w="$_w" '
    'xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006">'
    '<w:body>$body<w:sectPr><w:pgSz w:w="11906" w:h="16838"/></w:sectPr>'
    '</w:body></w:document>';

String _p(String runs, {String? style}) =>
    '<w:p>${style == null ? '' : '<w:pPr><w:pStyle w:val="$style"/></w:pPr>'}'
    '$runs</w:p>';

String _r(String text) => '<w:r><w:t xml:space="preserve">$text</w:t></w:r>';

const _emptyParagraph = '<w:p/>';

/// A one-row Word table, one cell per paragraph.
String _table(List<String> cells) =>
    '<w:tbl><w:tblPr/><w:tr>'
    '${cells.map((c) => '<w:tc><w:tcPr/>$c</w:tc>').join()}'
    '</w:tr></w:tbl>';

void main() {
  group('plain text and paste', () {
    test('a .txt file is kept as written, cleaned up, titled by its name', () {
      final s = _one(
        importFromFile(
          'Product launch.txt',
          utf8.encode(
            '# Hook\r\nStop\u00A0scrolling\u200B — *this* changes\tall.  \r\n'
            '[pause]\u2028// smile\r\n\r\n\r\n\r\n#fyp #ad\u0007\r\n',
          ),
        ),
      );
      expect(s.title, 'Product launch');
      expect(
        s.body,
        '# Hook\nStop scrolling — *this* changes all.\n[pause]\n// smile\n\n'
        '#fyp #ad',
      );
    });

    test('hashtag lines stay hashtags, sections and pauses survive', () {
      final s = _one(
        importFromText(
          '# Intro\nHey!\n#fyp #viral\n##Value\nBuy *now* [pause] ok\n'
          '# Outro\nBye',
        ),
      );
      expect(s.title, isNull);
      expect(s.body, contains('#fyp #viral'));
      final blocks = parseScript(s.body);
      expect(blocks.where((b) => b.type == BlockType.tags), hasLength(1));
      expect(sectionTitles(s.body), ['Intro', 'Value', 'Outro']);
      expect(pauseCount(s.body), 1);
    });

    test('Apple Notes / Samsung Notes: the first line is the title', () {
      final s = _one(
        importFromText(
          'Grocery haul\nHey everyone! Today I show what I bought.\n\n'
          '# Fruit\nApples and *mangoes*.\n[pause]\n#fyp #haul',
        ),
      );
      expect(s.title, 'Grocery haul');
      expect(
        s.body,
        'Hey everyone! Today I show what I bought.\n\n'
        '# Fruit\nApples and *mangoes*.\n[pause]\n#fyp #haul',
      );
    });

    test('a lone heading on top of a pasted note (Bear) is its title', () {
      final s = _one(importFromText('# Bear note\nJust text, nothing else.'));
      expect(s.title, 'Bear note');
      expect(s.body, 'Just text, nothing else.');
    });

    test('a spoken first line is not taken as a title', () {
      final s = _one(importFromText('Hey guys, welcome back!\nToday: tips.'));
      expect(s.title, isNull);
      expect(s.body, startsWith('Hey guys, welcome back!'));
    });

    test('Google Keep: the subject is the title and is not repeated', () {
      final s = _one(
        importFromText(
          'Morning routine\n\nWake up at 5.\nStretch.',
          title: 'Morning routine',
        ),
      );
      expect(s.title, 'Morning routine');
      expect(s.body, 'Wake up at 5.\nStretch.');

      final noRepeat = _one(
        importFromText('Wake up at 5.', title: '  Ideas  '),
      );
      expect(noRepeat.title, 'Ideas');
      expect(noRepeat.body, 'Wake up at 5.');
    });

    test('a share link is not a script', () {
      expect(
        _failure(importFromText('https://www.notion.so/My-Page-0123abcd')),
        ImportFailure.linkOnly,
      );
      expect(
        _failure(
          importFromText(
            'Launch plan\nhttps://docs.google.com/document/d/1x/edit?usp=sharing',
          ),
        ),
        ImportFailure.linkOnly,
      );
      expect(
        _failure(importFromText('https://x.co/a', title: 'My page')),
        ImportFailure.linkOnly,
      );
    });

    test('empty and huge text', () {
      expect(_failure(importFromText(' \n\u200B\t\n')), ImportFailure.empty);
      expect(
        _failure(importFromText('a' * (maxImportChars + 1))),
        ImportFailure.tooLarge,
      );
      expect(
        _failure(importFromFile('big.txt', Uint8List(maxImportBytes + 1))),
        ImportFailure.tooLarge,
      );
      expect(_failure(importFromFile('empty.txt', [])), ImportFailure.empty);
    });

    test('pasted Markdown (Bear, Notion copy) is converted', () {
      final s = _one(
        importFromText(
          '# Unboxing\n\nLook at **this** [phone](https://shop.example/p).\n'
          '- [ ] film close-up\n',
        ),
      );
      expect(s.title, 'Unboxing');
      expect(s.body, 'Look at *this* phone.\nfilm close-up');
    });

    test('Persian zero-width non-joiners and emoji joiners are kept', () {
      const persian = 'می\u200Cخواهم امروز بگویم';
      const family = '👨\u200D👩\u200D👧';
      final s = _one(importFromText('$persian\n$family'));
      expect(s.title, persian);
      expect(s.body, family);
    });

    test('cleanPastedText keeps the editor paste behaviour', () {
      expect(
        cleanPastedText('• First\u200B point\r\n\t- Second point\n3 - 1'),
        'First point\nSecond point\n3 - 1',
      );
      // Pasted into the middle of a line: the trailing space stays.
      expect(cleanPastedText('hello '), 'hello ');
    });
  });

  group('encodings', () {
    const text = 'Café “quoted” – € 5\nСлово';

    test('UTF-8 with and without a byte-order mark', () {
      expect(decodeText(utf8.encode(text)), text);
      expect(decodeText([0xEF, 0xBB, 0xBF, ...utf8.encode(text)]), text);
    });

    test('UTF-16 with a byte-order mark (Windows Notepad)', () {
      expect(decodeText(_utf16le(text)), text);
      expect(decodeText(_utf16be(text)), text);
      final s = _one(importFromFile('Notepad script.txt', _utf16le(text)));
      expect(s.body, text);
    });

    test('UTF-16 without a byte-order mark is recognised by its zeros', () {
      expect(
        decodeText(_utf16le('Hello world\nSecond line', bom: false)),
        'Hello world\nSecond line',
      );
    });

    test('Windows-1252 maps 0x80–0x9F to the right characters', () {
      final bytes = [
        ...latin1.encode('Caf'), 0xE9, 0x20, 0x93, ...latin1.encode('hi'), //
        0x94, 0x20, 0x96, 0x20, 0x80, 0x20, 0x85, 0x20, 0x99,
      ];
      expect(decodeText(bytes), 'Café “hi” – € … ™');
      final s = _one(importFromFile('old.txt', bytes));
      expect(s.body, 'Café “hi” – € … ™');
    });
  });

  group('Markdown files', () {
    test('Notion export: page title, sections, links, lists, tables', () {
      final s = _one(
        importFromFile(
          'My Script 0123456789abcdef0123456789abcdef.md',
          utf8.encode('''
# My Script

## Hook

Did you know **90%** of people [skip intros](https://example.com/a_(b))? ![cover](cover%20image.png)

- [ ] Film b-roll
- [x] Write hook
* Bullet star
  + Nested bullet
1. First step
2. Second step

> Quote from a viewer

| Tool | Price |
|------|------:|
| Camera | \$500 |

---

```
code *stays* [as is](x)
```

<!-- hidden comment -->

Setext section
--------------

Follow ~~now~~ today. `#fyp` #notion __bold__ and _italic_ in snake_case_name.
'''),
        ),
      );
      expect(s.title, 'My Script');
      expect(s.body, '''
# Hook

Did you know *90%* of people skip intros?

Film b-roll
Write hook
Bullet star
Nested bullet
1. First step
2. Second step

Quote from a viewer

Tool Price
Camera \$500

code *stays* [as is](x)

# Setext section

Follow now today. #fyp #notion *bold* and *italic* in snake_case_name.''');
      expect(sectionTitles(s.body), ['Hook', 'Setext section']);
    });

    test('Obsidian: front matter title, wiki links, highlights, comments', () {
      final s = _one(
        importFromFile(
          'gym.md',
          utf8.encode('''
---
title: "Gym vlog"
aliases: [gym]
tags:
  - fitness
---
Today I [[Leg Day|train legs]] with [[Coach Mike]].
Check [[Workouts#Squats]].
![[photo.png]]
==Remember== to breathe. %%private note%%
> [!tip] Hydrate
#gym #fitness
'''),
        ),
      );
      expect(s.title, 'Gym vlog');
      expect(
        s.body,
        'Today I train legs with Coach Mike.\nCheck Workouts.\n\n'
        '*Remember* to breathe.\nHydrate\n#gym #fitness',
      );
    });

    test('a Markdown title repeated by the front matter is dropped', () {
      final s = _one(
        importFromFile(
          'x.md',
          utf8.encode('---\ntitle: Pitch\n---\n# Pitch\n\nHello there.'),
        ),
      );
      expect(s.title, 'Pitch');
      expect(s.body, 'Hello there.');
    });
  });

  group('documents', () {
    test('RTF as TextEdit writes it', () {
      const rtf = r'''{\rtf1\ansi\ansicpg1252\cocoartf2761
\cocoatextscaling0\cocoaplatform0{\fonttbl\f0\fswiss\fcharset0 Helvetica;\f1\fnil\fcharset0 HelveticaNeue;}
{\colortbl;\red255\green255\blue255;}
{\*\expandedcolortbl;;}
{\info{\title Not this}{\author Me}}
\paperw11900\paperh16840\margl1440\margr1440\vieww11520\viewh8400\viewkind0
\pard\tx566\tx1133\tx1700\pardirnatural\partightenfactor0

\f0\fs24 \cf0 # Hook\
Stop scrolling \'97 this caf\'e9 trick saves you \uc0\u8364 20.\
[pause]\
\
# CTA\
Follow for more \{daily\} tips\tab now\line and {\field{\*\fldinst{HYPERLINK "https://example.com"}}{\fldrslt my site}}\
// smile\
#fyp #coffee}''';
      final s = _one(importFromFile('Coffee script.rtf', utf8.encode(rtf)));
      expect(s.title, 'Coffee script');
      expect(
        s.body,
        '# Hook\nStop scrolling — this café trick saves you €20.\n[pause]\n\n'
        '# CTA\nFollow for more {daily} tips now\nand my site\n// smile\n'
        '#fyp #coffee',
      );
    });

    test('RTF from Word: \\u with fallback characters, Cyrillic code page', () {
      // Word writes \uN plus a one-character fallback (\uc1).
      const word =
          r"{\rtf1\ansi\ansicpg1252\uc1 {\*\generator Riched20;}"
          r"\pard \u1055\'cf\u1088\'f0\u1080\'e8\u1074\'e2\u1077\'e5"
          r"\u1090\'f2!\par}";
      expect(_one(importFromText(word)).body, 'Привет!');
      // WordPad on Russian Windows writes Cyrillic as code page 1251 bytes.
      const wordpad =
          r"{\rtf1\ansi\ansicpg1251\deff0{\fonttbl{\f0\fnil\fcharset204 Arial;}}"
          '\n'
          r"\pard\f0\fs22\'cf\'f0\'e8\'e2\'e5\'f2, \'ec\'e8\'f0!\par}";
      expect(
        _one(importFromFile('note.rtf', latin1.encode(wordpad))).body,
        'Привет, мир!',
      );
    });

    test(
      'Word .docx: title, headings, tabs, breaks, tracked changes, tables',
      () {
        final document = _docxDocument(
          _p(_r('Morning Routine'), style: 'Title') +
              _p(_r('Hook'), style: 'Heading1') +
              _p(
                '${_r('I wake up at ')}<w:r><w:rPr><w:b/></w:rPr>'
                '<w:t>5 AM</w:t></w:r>${_r('.')}<w:r><w:tab/>'
                '<w:t>Every day.</w:t></w:r>',
              ) +
              _p('<w:r><w:t>Line one</w:t><w:br/><w:t>line two</w:t></w:r>') +
              _p(
                '<w:del w:id="1" w:author="Ed"><w:r><w:delText>old words'
                '</w:delText></w:r></w:del><w:ins w:id="2" w:author="Ed">'
                '${_r('New words')}</w:ins>',
              ) +
              _p(
                '<w:r><w:fldChar w:fldCharType="begin"/></w:r><w:r>'
                '<w:instrText xml:space="preserve"> HYPERLINK "https://x.co" '
                '</w:instrText></w:r><w:r><w:fldChar w:fldCharType="separate"/>'
                '</w:r>${_r('my link')}<w:r><w:fldChar w:fldCharType="end"/>'
                '</w:r>',
              ) +
              _emptyParagraph +
              _p(_r('Steps'), style: 'berschrift1') +
              _table([_p(_r('Coffee')), _p(_r('Stretch'))]),
        );
        const styles =
            '<w:styles xmlns:w="$_w">'
            '<w:style w:type="paragraph" w:styleId="berschrift1">'
            '<w:name w:val="heading 1"/></w:style></w:styles>';
        final bytes = _zip({
          '[Content_Types].xml': '<Types/>',
          'word/document.xml': document,
          'word/styles.xml': styles,
        });
        final s = _one(importFromFile('Routine (1).docx', bytes));
        expect(s.title, 'Morning Routine');
        expect(
          s.body,
          '# Hook\nI wake up at 5 AM. Every day.\nLine one\nline two\n'
          'New words\nmy link\n\n# Steps\nCoffee\nStretch',
        );
      },
    );

    test('Word .docx without a title style is named after the file', () {
      final bytes = _zip({
        'word/document.xml': _docxDocument(
          _p(_r('Intro'), style: 'Heading1') +
              _p(_r('Hello.')) +
              _p(_r('Outro'), style: 'Heading1') +
              _p(_r('Bye.')),
        ),
      });
      final s = _one(importFromFile('Vlog 12.docx', bytes));
      expect(s.title, 'Vlog 12');
      expect(s.body, '# Intro\nHello.\n# Outro\nBye.');
    });

    test('OpenDocument .odt (LibreOffice, Google Docs)', () {
      const content = '''<?xml version="1.0" encoding="UTF-8"?>
<office:document-content xmlns:office="urn:oasis:names:tc:opendocument:xmlns:office:1.0"
  xmlns:style="urn:oasis:names:tc:opendocument:xmlns:style:1.0"
  xmlns:text="urn:oasis:names:tc:opendocument:xmlns:text:1.0"
  xmlns:table="urn:oasis:names:tc:opendocument:xmlns:table:1.0">
  <office:automatic-styles>
    <style:style style:name="P1" style:family="paragraph" style:parent-style-name="Title"/>
  </office:automatic-styles>
  <office:body>
    <office:text>
      <text:sequence-decls><text:sequence-decl text:name="Table"/></text:sequence-decls>
      <text:p text:style-name="P1">Product Review</text:p>
      <text:h text:outline-level="1">Intro</text:h>
      <text:p text:style-name="Standard">This
        <text:span text:style-name="T1">phone</text:span><text:s/>is<text:tab/>great.<text:line-break/>Really.</text:p>
      <text:list>
        <text:list-item><text:p>Battery</text:p></text:list-item>
        <text:list-item><text:p>Camera<text:note text:note-class="footnote"><text:note-citation>1</text:note-citation><text:note-body><text:p>footnote</text:p></text:note-body></text:note></text:p></text:list-item>
      </text:list>
      <table:table><table:table-row><table:table-cell><text:p>Price</text:p></table:table-cell><table:table-cell><text:p>\$999</text:p></table:table-cell></table:table-row></table:table>
      <text:h text:outline-level="1">Verdict</text:h>
      <text:p>Buy it.</text:p>
    </office:text>
  </office:body>
</office:document-content>''';
      final bytes = _zip({
        'mimetype': 'application/vnd.oasis.opendocument.text',
        'content.xml': content,
      });
      final s = _one(importFromFile('review.odt', bytes));
      expect(s.title, 'Product Review');
      expect(
        s.body,
        '# Intro\nThis phone is great.\nReally.\nBattery\nCamera\nPrice\n'
        '\$999\n# Verdict\nBuy it.',
      );
    });

    test('Google Docs HTML export with its style junk', () {
      const html =
          '<html><head><meta content="text/html; charset=UTF-8" '
          'http-equiv="content-type"><style type="text/css">'
          "@import url('https://themes.googleusercontent.com/fonts/css?kit=a');"
          'ol{margin:0;padding:0}table td,table th{padding:0}'
          '.c1{color:#000000;font-weight:400;text-decoration:none;'
          'font-size:11pt;font-family:"Arial";font-style:normal}'
          '.c4{color:#000000;font-weight:700;text-decoration:none;'
          'font-size:11pt;font-family:"Arial";font-style:normal}'
          '.c0{padding-top:0pt;line-height:1.15;text-align:left;height:11pt}'
          '.title{padding-top:0pt;color:#000000;font-size:26pt;'
          'font-family:"Arial"}h1{padding-top:20pt;font-size:20pt}'
          '</style><title>Launch video</title></head>'
          '<body class="c5 doc-content">'
          '<p class="c0 title" id="h.abc"><span class="c1">Launch video'
          '</span></p>'
          '<h1 class="c3" id="h.def"><span class="c1">Hook</span></h1>'
          '<p class="c0"><span class="c1">This is </span>'
          '<span class="c4">the</span><span class="c1">&nbsp;moment &amp; '
          'it&rsquo;s   here.</span></p>'
          '<p class="c0 c2"><span class="c1"></span></p>'
          '<h1 class="c3" id="h.ghi"><span class="c1">CTA</span></h1>'
          '<ul class="c6 lst-kix_x-0 start"><li class="c0 li-bullet-0">'
          '<span class="c1">Like</span></li><li class="c0 li-bullet-0">'
          '<span class="c1">Subscribe</span></li></ul>'
          '<ol><li>One</li><li>Two</li></ol>'
          '<p class="c0"><span class="c1">#fyp #launch</span></p>'
          '<script>alert(1)</script></body></html>';
      final s = _one(importFromFile('LaunchVideo.html', utf8.encode(html)));
      expect(s.title, 'Launch video');
      expect(
        s.body,
        '# Hook\nThis is *the* moment & it’s here.\n\n# CTA\nLike\nSubscribe\n'
        '1. One\n2. Two\n#fyp #launch',
      );
    });

    test('Apple Notes HTML: a bold first line is the title', () {
      const html =
          '<div><b><span style="font-size: 24px">Studio tour</span></b></div>'
          '<div>Welcome to my <b>new</b> studio.</div>'
          '<div><br></div><div>Let me show you around.</div>';
      final s = _one(importFromText(html));
      expect(s.title, 'Studio tour');
      expect(s.body, 'Welcome to my *new* studio.\n\nLet me show you around.');
    });

    test('Google Docs clipboard wrapper is not bold', () {
      const html =
          '<meta charset="utf-8"><b style="font-weight:normal;" '
          'id="docs-internal-guid-1"><p dir="ltr"><span>Plain words first.</span>'
          '</p><p><span style="font-weight:700">Loud</span> words.</p></b>';
      final s = _one(importFromText(html));
      expect(s.body, 'Plain words first.\n*Loud* words.');
    });

    test('Evernote .enex with two notes gives two scripts', () {
      const enex = '''<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE en-export SYSTEM "http://xml.evernote.com/pub/evernote-export4.dtd">
<en-export export-date="20261001T120000Z" application="Evernote" version="10.0">
  <note>
    <title>Episode 1</title>
    <created>20261001T100000Z</created>
    <content><![CDATA[<?xml version="1.0" encoding="UTF-8" standalone="no"?>
<!DOCTYPE en-note SYSTEM "http://xml.evernote.com/pub/enml2.dtd">
<en-note><div>Episode 1</div><div>Welcome back to the <b>channel</b>.</div><div><br/></div><div>Today: cameras.</div><div><en-todo checked="false"/>Buy tripod</div><en-media type="image/png" hash="abc"/></en-note>]]></content>
    <resource><data encoding="base64">iVBORw0KGgo=</data><mime>image/png</mime></resource>
  </note>
  <note>
    <title>Episode 2</title>
    <content><![CDATA[<en-note><div>Part two &amp; more.</div></en-note>]]></content>
  </note>
</en-export>''';
      final result = importFromFile('Notebook.enex', utf8.encode(enex));
      expect(result, isA<ImportedScripts>());
      final scripts = (result as ImportedScripts).scripts;
      expect(scripts.map((s) => s.title), ['Episode 1', 'Episode 2']);
      expect(
        scripts.first.body,
        'Welcome back to the *channel*.\n\nToday: cameras.\nBuy tripod',
      );
      expect(scripts.last.body, 'Part two & more.');
    });

    test('Google Keep Takeout notes (.json)', () {
      final s = _one(
        importFromFile(
          'Hook ideas.json',
          utf8.encode(
            jsonEncode({
              'color': 'DEFAULT',
              'isTrashed': false,
              'title': 'Hook ideas',
              'textContent': 'What if you never had to edit again?',
            }),
          ),
        ),
      );
      expect(s.title, 'Hook ideas');
      expect(s.body, 'What if you never had to edit again?');
    });

    test('a zip of notes (Notion, Bear export) gives a script per note', () {
      final bytes = _zip({
        'Export/Ideas 0123456789abcdef0123456789abcdef.md': '# Ideas\n\nOne.',
        'Export/My idea.textbundle/text.md': 'Second note.',
        'Export/image.png': 'not really',
        '__MACOSX/Export/._Ideas.md': 'junk',
      });
      final result = importFromFile('Export.zip', bytes);
      expect(result, isA<ImportedScripts>());
      final scripts = (result as ImportedScripts).scripts;
      expect(scripts.map((s) => s.title), ['Ideas', 'My idea']);
      expect(scripts.map((s) => s.body), ['One.', 'Second note.']);
    });
  });

  group('subtitles', () {
    test('SRT: one line per cue, no numbers, times or tags', () {
      const srt =
          '1\r\n00:00:01,000 --> 00:00:03,500\r\n<i>Hey</i> everyone,\r\n'
          '\r\n2\r\n00:00:03,600 --> 00:00:06,000\r\nwelcome back\r\n'
          'to my channel!\r\n\r\n3\r\n00:00:06,100 --> 00:00:08,000\r\n'
          "{\\an8}Let's go.\r\n";
      final s = _one(importFromFile('Episode 4.srt', utf8.encode(srt)));
      expect(s.title, 'Episode 4');
      expect(s.body, "Hey everyone,\nwelcome back to my channel!\nLet's go.");
    });

    test('WebVTT: header, notes, styles, voices and rolling captions', () {
      const vtt = '''WEBVTT
Kind: captions
Language: en

NOTE This is a comment

STYLE
::cue { color: yellow }

00:00:00.000 --> 00:00:02.000 align:start position:0%
<v Roger>Hello there

intro
00:00:02.000 --> 00:00:04.000
Hello there
<c.yellow>General</c> Kenobi &amp; <00:00:03.000>friends
''';
      final s = _one(importFromFile('clip.vtt', utf8.encode(vtt)));
      expect(s.body, 'Hello there\nGeneral Kenobi & friends');
    });
  });

  group('what cannot be imported says why', () {
    test('PDF', () {
      expect(
        _failure(importFromFile('a.pdf', utf8.encode('%PDF-1.7\n%âãÏÓ\n1 0'))),
        ImportFailure.pdf,
      );
      expect(
        _failure(importFromFile('scan', utf8.encode('%PDF-1.4 binary'))),
        ImportFailure.pdf,
      );
    });

    test('old Word and Pages', () {
      final ole = [0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1, 0, 0, 0];
      expect(
        _failure(importFromFile('old.doc', ole)),
        ImportFailure.binaryDocument,
      );
      expect(
        _failure(importFromFile('Budget.xls', ole)),
        ImportFailure.unsupportedFormat,
      );
      expect(
        _failure(
          importFromFile(
            'Script.pages',
            _zip({'Index/Document.iwa': 'x', 'preview.jpg': 'y'}),
          ),
        ),
        ImportFailure.binaryDocument,
      );
    });

    test('other XML documents are not imported as tags', () {
      expect(
        _failure(
          importFromFile(
            'Pilot.fdx',
            utf8.encode(
              '<?xml version="1.0"?><FinalDraft><Content><Paragraph>'
              '<Text>INT. HOUSE</Text></Paragraph></Content></FinalDraft>',
            ),
          ),
        ),
        ImportFailure.unsupportedFormat,
      );
    });

    test('photos, video and other binaries', () {
      expect(
        _failure(
          importFromFile('IMG_1.HEIC', [
            0,
            0,
            0,
            0x18,
            ...ascii.encode('ftypheic'),
          ]),
        ),
        ImportFailure.unsupportedFormat,
      );
      expect(
        _failure(importFromFile('photo.png', [0x89, 0x50, 0x4E, 0x47, 1, 2])),
        ImportFailure.unsupportedFormat,
      );
      expect(
        _failure(
          importFromFile(
            'blob.bin',
            List.generate(400, (i) => i % 7 == 0 ? 0 : i % 256),
          ),
        ),
        ImportFailure.unsupportedFormat,
      );
      expect(
        _failure(importFromFile('broken.docx', [0x50, 0x4B, 0x03, 0x04, 1])),
        ImportFailure.unreadable,
      );
    });
  });

  test('an APrompter backup picked as a file is recognised as a backup', () {
    final scripts = [
      Script(id: 'a', title: 'A', body: 'Hello', updatedAt: DateTime(2026)),
    ];
    final result = importFromFile(
      'aprompter-backup-2026-10-02.json',
      utf8.encode(Backup.encode(scripts)),
    );
    expect(result, isA<ImportedBackup>());
    expect((result as ImportedBackup).scripts.single.id, 'a');
    expect(importFromText(Backup.encode(scripts)), isA<ImportedBackup>());
  });

  group('export', () {
    test('file names work on every system', () {
      expect(
        textFileName('My video: take 2/3?', fallback: 'Untitled'),
        'My video take 2 3.txt',
      );
      expect(textFileName('  ', fallback: 'Untitled'), 'Untitled.txt');
      expect(textFileName('CON', fallback: 'x'), 'CON_.txt');
      expect(textFileName('...dots...', fallback: 'x'), 'dots.txt');
      expect(textFileName('a' * 200, fallback: 'x'), '${'a' * 80}.txt');
      expect(textFileName('Видео 🎬', fallback: 'x'), 'Видео 🎬.txt');
      // Phones allow 255 bytes per name: emoji and CJK take 3–4 each.
      for (final title in [
        '😀' * 80,
        '直播' * 30 + '🎬' * 20,
        'a${'🇺🇸' * 40}',
      ]) {
        final name = textFileName(title, fallback: 'x');
        expect(utf8.encode(name).length, lessThanOrEqualTo(204), reason: name);
        expect(name, endsWith('.txt'));
        expect(
          name.runes.where((r) => r >= 0x1F1E6 && r <= 0x1F1FF).length.isEven,
          isTrue,
        );
      }
      expect(
        textFileName('👨\u200D👩\u200D👧' * 20, fallback: 'x'),
        isNot(contains('\u200D.txt')),
      );
    });

    test('export then import gives the same title and body', () {
      const cases = [
        (
          'My video: take 2/3',
          '# Hook\nStop *scrolling*.\n[pause]\n\n'
              '# CTA\n// smile\nFollow!\n#fyp #ad',
        ),
        ('Ideas', 'Just one line'),
        ('مراجعة الهاتف', 'هذا هاتف رائع.\n\n# الخلاصة\nاشتروه.'),
        (
          'A very long title that goes on and on about the camera and the lens '
              'and the light',
          'Body text.',
        ),
        ('Review', 'Review\nThe body starts with the title word on purpose.'),
        // Dialogue dashes and typed lists stay; stars in a title stay.
        ('Диалог', '— Привет, друзья!\n— Сегодня обзор.'),
        ('Diálogo', '– ¿Listos?\n– ¡Vamos!'),
        ('Shopping', '- milk\n- eggs\n- bread'),
        ('*Big* news', 'Body with *emphasis*.'),
        // Not subtitles, not HTML: just a title that starts that way.
        ('WEBVTT tips', 'Use captions.'),
        ('<b> tags', 'Bold in HTML.'),
      ];
      for (final (title, body) in cases) {
        final name = textFileName(title, fallback: 'Untitled');
        final file = utf8.encode(scriptAsText(title, body));
        final s = _one(importFromFile(name, file));
        expect(s.title, title, reason: name);
        expect(s.body, body, reason: name);
        // Shared as text instead of a file, it comes back the same too.
        final shared = _one(
          importFromText(scriptAsText(title, body), title: title),
        );
        expect((shared.title, shared.body), (title, body));
      }
    });
  });

  group('notes as people really write them', () {
    test('Word .docx: emoji typed from the emoji panel and text boxes', () {
      const ns =
          'xmlns:w="$_w" '
          'xmlns:mc="http://schemas.openxmlformats.org/markup-compatibility/2006" '
          'xmlns:w16se="http://schemas.microsoft.com/office/word/2015/wordml/symex" '
          'xmlns:v="urn:schemas-microsoft-com:vml" '
          'xmlns:wps="http://schemas.microsoft.com/office/word/2010/wordprocessingShape"';
      const document =
          '<w:document $ns><w:body>'
          '<w:p><w:r><w:t xml:space="preserve">I love this </w:t></w:r><w:r>'
          '<mc:AlternateContent><mc:Choice Requires="w16se">'
          '<w16se:symEx w16se:font="Segoe UI Emoji" w16se:char="1F525"/>'
          '</mc:Choice><mc:Fallback><w:t>🔥</w:t></mc:Fallback>'
          '</mc:AlternateContent></w:r><w:r><w:t xml:space="preserve"> so much'
          '</w:t></w:r></w:p>'
          '<w:p><w:r><w:t>Before box</w:t></w:r><w:r><mc:AlternateContent>'
          '<mc:Choice Requires="wps"><w:drawing><wps:wsp><wps:txbx>'
          '<w:txbxContent><w:p><w:r><w:t>Box text</w:t></w:r></w:p>'
          '</w:txbxContent></wps:txbx></wps:wsp></w:drawing></mc:Choice>'
          '<mc:Fallback><w:pict><v:shape><v:textbox><w:txbxContent><w:p><w:r>'
          '<w:t>Box text</w:t></w:r></w:p></w:txbxContent></v:textbox>'
          '</v:shape></w:pict></mc:Fallback></mc:AlternateContent></w:r></w:p>'
          '<w:p><w:r><w:t>After.</w:t></w:r></w:p>'
          '<w:p><w:r><mc:AlternateContent><mc:Choice Requires="w16se">'
          '<w16se:symEx w16se:font="Segoe UI Emoji" w16se:char="1F44B"/>'
          '</mc:Choice></mc:AlternateContent></w:r></w:p>'
          '</w:body></w:document>';
      final s = _one(
        importFromFile('Emoji.docx', _zip({'word/document.xml': document})),
      );
      expect(
        s.body,
        'I love this 🔥 so much\nBefore box\nBox text\nAfter.\n👋',
      );
    });

    test('the 2 MB limit is for the text, not for photos alongside it', () {
      final photo = 'A' * (3 * 1024 * 1024); // base64 of a phone photo
      final enex =
          '<?xml version="1.0" encoding="UTF-8"?><en-export><note>'
          '<title>Shoot plan</title><content><![CDATA[<en-note><div>Short '
          'script text.</div><en-media type="image/jpeg" hash="1"/></en-note>]]>'
          '</content><resource><data encoding="base64">$photo</data>'
          '<mime>image/jpeg</mime></resource></note></en-export>';
      final note = _one(importFromFile('Notebook.enex', utf8.encode(enex)));
      expect((note.title, note.body), ('Shoot plan', 'Short script text.'));

      final html =
          '<html><body><p>Short text</p>'
          '<img src="data:image/png;base64,$photo"></body></html>';
      expect(
        _one(importFromFile('page.html', utf8.encode(html))).body,
        'Short text',
      );
      expect(
        _one(
          importFromFile(
            'a.rtf',
            utf8.encode(
              '{\\rtf1 Hello{\\pict\\pngblip ${'0' * (3 * 1024 * 1024)}}\\par}',
            ),
          ),
        ).body,
        'Hello',
      );
      // Text itself over 2 MB is still too much for one script.
      expect(
        _failure(importFromFile('long.md', utf8.encode('word ' * 500000))),
        ImportFailure.tooLarge,
      );
    });

    test('numbered list items wrapping a paragraph keep number and text '
        'together (Evernote, pasted HTML)', () {
      const enex =
          '<?xml version="1.0" encoding="UTF-8"?><en-export><note>'
          '<title>Steps</title><content><![CDATA[<en-note><div>Intro line.'
          '</div><ol><li><div>Open the app</div></li><li><div><b>Tap</b> '
          'record</div></li><li><div></div></li></ol></en-note>]]></content>'
          '</note></en-export>';
      expect(
        _one(importFromFile('n.enex', utf8.encode(enex))).body,
        'Intro line.\n1. Open the app\n2. *Tap* record\n3.',
      );
      expect(
        _one(
          importFromText(
            '<ol><li><p>First step</p></li><li><p>Second step</p></li></ol>',
          ),
        ).body,
        '1. First step\n2. Second step',
      );
    });

    test('bold inside a word is not turned into stray stars', () {
      expect(
        _one(importFromText('<p><b>Super</b>man and <b>bold</b>.</p>')).body,
        'Superman and *bold*.',
      );
      final md = _one(
        importFromFile('m.md', utf8.encode('**Super**man and **bold**.')),
      );
      expect(md.body, 'Superman and *bold*.');
      expect(parseScript(md.body).single.spans.map((s) => s.type), [
        SpanType.text,
        SpanType.emphasis,
        SpanType.text,
      ]);
    });

    test('Markdown code and escapes are not read as sections or titles', () {
      final s = _one(
        importFromFile(
          'setup.md',
          utf8.encode(
            '```bash\n# install deps\nnpm install\n```\n\nThen record.\n'
            '\\# not a heading\n',
          ),
        ),
      );
      expect(s.title, 'setup');
      expect(
        s.body,
        '\\# install deps\nnpm install\n\nThen record.\n\\# not a heading',
      );
      expect(sectionTitles(s.body), isEmpty);
    });

    test('"---" dividers around a label are not front matter', () {
      final pasted = _one(
        importFromText(
          '---\nNote: film outside\n---\nHey guys, welcome back!\n'
          'Today we talk cameras.',
        ),
      );
      expect(pasted.body, contains('Note: film outside'));
      expect(pasted.body, contains('Hey guys, welcome back!'));
      // Real front matter still goes, pasted or in a file.
      final obsidian = _one(
        importFromText('---\ntags: [vlog]\ncreated: 2026-10-01\n---\nHello.'),
      );
      expect(obsidian.body, 'Hello.');
      final file = _one(
        importFromFile('n.md', utf8.encode('---\nmood: calm\n---\nHello.')),
      );
      expect(file.body, 'Hello.');
    });

    test('SRT with Windows line ends is recognised without its name', () {
      const srt =
          '1\r\n00:00:01,000 --> 00:00:03,500\r\nHey everyone\r\n\r\n'
          '2\r\n00:00:03,600 --> 00:00:05,000\r\nwelcome back\r\n';
      expect(_one(importFromText(srt)).body, 'Hey everyone\nwelcome back');
      final file = _one(importFromFile('subs.txt', utf8.encode(srt)));
      expect((file.title, file.body), ('subs', 'Hey everyone\nwelcome back'));
      expect(
        _one(importFromFile('subs', utf8.encode(srt))).body,
        'Hey everyone\nwelcome back',
      );
    });

    test('subtitles: cues without blank lines, lines said twice', () {
      expect(
        _one(
          importFromFile(
            'm.srt',
            utf8.encode(
              '1\n00:00:01,000 --> 00:00:02,000\nHello\n'
              '2\n00:00:02,000 --> 00:00:03,000\nWorld\n',
            ),
          ),
        ).body,
        'Hello\nWorld',
      );
      expect(
        _one(
          importFromFile(
            'm.srt',
            utf8.encode(
              '1\n00:00:01,000 --> 00:00:02,000\nNo.\n\n'
              '2\n00:00:02,000 --> 00:00:03,000\nNo.\n\n'
              '3\n00:00:03,000 --> 00:00:04,000\nStop.\n',
            ),
          ),
        ).body,
        'No.\nNo.\nStop.',
      );
    });

    test('RTF lists from Word, WordPad and TextEdit', () {
      const word =
          r"{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Calibri;}"
          r"{\f3\fnil\fcharset2 Symbol;}}\pard{\pntext\f3\'b7\tab}First item\par"
          r"{\listtext\f3 \'b7\tab}Second item\par}";
      expect(
        _one(importFromFile('list.rtf', utf8.encode(word))).body,
        'First item\nSecond item',
      );
      const textEdit =
          '{\\rtf1\\ansi\\ansicpg1252\\cocoartf2761\n'
          '{\\fonttbl\\f0\\fswiss\\fcharset0 Helvetica;}\n'
          '\\pard\\f0\\fs24 \\cf0 Steps:\\\n{\\listtext\t1.\t}First\\\n'
          '{\\listtext\t2.\t}Second step\\\n{\\listtext\t\\uc0\\u8226 \t}Dot\\\n}';
      expect(
        _one(importFromFile('list.rtf', utf8.encode(textEdit))).body,
        'Steps:\n1. First\n2. Second step\nDot',
      );
    });

    test('RTF in other Windows code pages and font character sets', () {
      String body(String rtf) =>
          _one(importFromFile('n.rtf', latin1.encode(rtf))).body;
      expect(
        body(r"{\rtf1\ansi\ansicpg1250 Cze\'9c\'e6, \'b3\'f3d\'9f\par}"),
        'Cześć, łódź',
      );
      expect(
        body(r"{\rtf1\ansi\ansicpg1254 te\'feekk\'fcrler, \'f0\'fd\par}"),
        'teşekkürler, ğı',
      );
      // WordPad on an English Windows: Polish in a Central European font.
      expect(
        body(
          r"{\rtf1\ansi\ansicpg1252\deff0{\fonttbl{\f0\fnil\fcharset0 Arial;}"
          r"{\f1\fnil\fcharset238 Arial;}}\f0 Caf\'e9 \f1 \'b3\'f3d\'9f\f0 !\par}",
        ),
        'Café łódź!',
      );
      expect(body(r"{\rtf1\ansi\ansicpg1253 \'e3\'e5\'e9\'e1\par}"), 'γεια');
      // Japanese bytes can't be read one at a time: say so, no garbage.
      expect(
        _failure(
          importFromText(r"{\rtf1\ansi\ansicpg932 \'82\'b1\'82\'f1\par}"),
        ),
        ImportFailure.unreadable,
      );
    });

    test('a damaged RTF escape loses that character, not the document', () {
      expect(
        _one(importFromText(r"{\rtf1 Hello \'-1 world\par}")).body,
        'Hello -1 world',
      );
      expect(
        _one(importFromText(r'{\rtf1 Hello \u-70000? world \u9999999? x\par}'))
            .body,
        'Hello  world  x',
      );
    });

    test('encodings: stray Windows bytes, UTF-16 without a mark, zeros', () {
      final mixed = [
        ...utf8.encode('Café ‘quoted’ — naïve résumé'),
        0x96,
        ...utf8.encode(' end'),
      ];
      expect(decodeText(mixed), 'Café ‘quoted’ — naïve résumé– end');
      const ru = 'Привет, друзья! Сегодня обзор камеры.\nВторая строка.';
      const zh = '大家好，今天我们来聊聊相机。\n第二行文字在这里。';
      expect(_one(importFromFile('ru.txt', _utf16le(ru, bom: false))).body, ru);
      expect(_one(importFromFile('zh.txt', _utf16le(zh, bom: false))).body, zh);
      expect(
        _one(importFromFile('n.txt', utf8.encode('Hello\u0000 world, a note.')))
            .body,
        'Hello world, a note.',
      );
      expect(
        _one(importFromFile('pad.txt', [...utf8.encode('Padded.'), 0, 0, 0, 0]))
            .body,
        'Padded.',
      );
      // Plain text is still plain text, not "UTF-16 Chinese".
      expect(decodeText(utf8.encode('Hello world')), 'Hello world');
    });

    test('a note that starts with a tag is not HTML', () {
      final txt = _one(
        importFromFile(
          'notes.txt',
          utf8.encode('<p> tags wrap paragraphs.\nUse them well.'),
        ),
      );
      expect(txt.body, '<p> tags wrap paragraphs.\nUse them well.');
      expect(
        _one(importFromText('<b> is the bold tag in HTML, remember it')).body,
        '<b> is the bold tag in HTML, remember it',
      );
      // A whole web page saved as .txt is still read as HTML.
      expect(
        _one(
          importFromFile(
            'page.txt',
            utf8.encode('<!DOCTYPE html><html><body><p>Hi</p></body></html>'),
          ),
        ).body,
        'Hi',
      );
    });

    test(
      'a page without </head>, or with odd style sheets, keeps its text',
      () {
        final s = _one(
          importFromFile(
            'p.html',
            utf8.encode(
              '<html><head><title>Talk</title><meta charset="utf-8">'
              '<style>{font-weight:bold} .c1{font-weight:700}</style>'
              '<p>Hello <span class="c1">all</span>.</p></html>',
            ),
          ),
        );
        expect((s.title, s.body), ('Talk', 'Hello *all*.'));
      },
    );

    test('single-file web pages (.mht) from OneNote and Word', () {
      const mht =
          'MIME-Version: 1.0\r\nContent-Type: multipart/related;\r\n'
          '\tboundary="----=_NextPart_01"\r\n\r\n'
          'This is a multi-part message in MIME format.\r\n\r\n'
          '------=_NextPart_01\r\nContent-Location: file:///C:/x.htm\r\n'
          'Content-Transfer-Encoding: quoted-printable\r\n'
          'Content-Type: text/html; charset="windows-1252"\r\n\r\n'
          '<html><head><title>OneNote page</title></head><body>'
          '<p class=3DMsoNormal>Hello from OneNote, this is my scr=\r\nipt. '
          'Caf=E9 =96 <b>now</b>.</p></body></html>\r\n\r\n'
          '------=_NextPart_01\r\nContent-Location: file:///C:/image001.png\r\n'
          'Content-Transfer-Encoding: base64\r\nContent-Type: image/png\r\n\r\n'
          'iVBORw0KGgo=\r\n\r\n------=_NextPart_01--\r\n';
      final s = _one(importFromFile('Page.mht', utf8.encode(mht)));
      expect(s.title, 'OneNote page');
      expect(s.body, 'Hello from OneNote, this is my script. Café – *now*.');
      expect(
        _one(importFromFile('page', utf8.encode(mht))).body,
        s.body,
        reason: 'recognised without its extension',
      );
    });

    test('a clipboard paste never loses its first line to the title', () {
      const text = 'Hey guys\nToday we talk about lenses.';
      final pasted = _one(importFromText(text, fromClipboard: true));
      expect(pasted.title, 'Hey guys');
      expect(pasted.body, text);
      // Shared from a notes app, the same first line is the note's title.
      final shared = _one(importFromText(text));
      expect(shared.body, 'Today we talk about lenses.');
    });

    test('pasted caption-style lines keep their first line', () {
      final s = _one(
        importFromText(
          'Stop scrolling right now\nThis trick changes everything\n'
          'Here is how',
        ),
      );
      expect(s.title, 'Stop scrolling right now');
      expect(
        s.body,
        'Stop scrolling right now\nThis trick changes everything\nHere is how',
      );
      // A title line followed by prose is still the note's title.
      final notes = _one(importFromText('Grocery haul\nHey! I bought fruit.'));
      expect(
        (notes.title, notes.body),
        ('Grocery haul', 'Hey! I bought fruit.'),
      );
      // Dividers are not titles.
      expect(_one(importFromText('---\nHello there\nfriend')).title, isNull);
    });

    test('broken or hostile files are read in reasonable time', () {
      final cases = {
        'page.html': '<html>${"<a'" * 20000}',
        'quotes.html': '<html>${"<a '>' " * 20000}x',
        'deep.html': '${'<div>' * 50000}${'</span>' * 50000}',
        'scripts.html': '<html>${'<script>x ' * 20000}</p>',
        'bold.md': '**a ' * 15000,
        'brackets.md': '[' * 60000,
        'under.md': '__a ' * 15000,
        'tags.md': '<span ' * 15000,
      };
      for (final MapEntry(key: name, value: text) in cases.entries) {
        final watch = Stopwatch()..start();
        importFromFile(name, utf8.encode(text));
        // Each used to take 20–45 s on the UI thread.
        expect(
          watch.elapsed,
          lessThan(const Duration(seconds: 3)),
          reason: name,
        );
      }
    });
  });
}
