// One step in: paste, share from another app, open a file — on the home
// screen, with the free plan and the app lock respected.
import 'dart:convert';

import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/main.dart';
import 'package:aprompter/models/script.dart';
import 'package:aprompter/screens/editor_screen.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/backup.dart';
import 'package:aprompter/services/entitlements.dart';
import 'package:aprompter/services/purchase_service.dart';
import 'package:aprompter/services/script_import.dart';
import 'package:aprompter/services/storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _en = lookupAppLocalizations(const Locale('en'));

/// Stands in for the native side of `aprompter/import`.
class _FakeShares {
  _FakeShares(this.tester) {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(_channel, (
      call,
    ) async {
      if (call.method != 'takePending') return null;
      takes++;
      final out = List.of(pending);
      pending.clear();
      return out;
    });
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        _channel,
        null,
      ),
    );
  }

  static const _channel = MethodChannel('aprompter/import');
  final WidgetTester tester;
  final pending = <Map<String, Object?>>[];
  var takes = 0;

  /// Native code saying "something new was shared" while the app is open.
  Future<void> announce() async {
    await tester.binding.defaultBinaryMessenger.handlePlatformMessage(
      _channel.name,
      const StandardMethodCodec().encodeMethodCall(
        const MethodCall('incoming'),
      ),
      (_) {},
    );
    await tester.pumpAndSettle();
  }
}

/// RevenueCat has no native side in tests: loading plans fails like an
/// offline store, so the paywall shows its error instead of hanging.
void _offlineStore(WidgetTester tester) {
  const channel = MethodChannel('purchases_flutter');
  final messenger = tester.binding.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(channel, (call) async {
    throw PlatformException(code: '10', message: 'offline');
  });
  addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
}

/// A file the system picker hands back.
base class _Picked extends PlatformFile {
  _Picked(this.name, String text, {this.size})
    : bytes = Uint8List.fromList(utf8.encode(text));

  _Picked.bytes(this.name, this.bytes) : size = null;

  @override
  final String name;
  final Uint8List bytes;

  /// The size the picker reports, when it differs from [bytes].
  final int? size;

  @override
  Uri get uri => Uri(scheme: 'memory', path: name);

  @override
  XFile get xFile => XFile.fromData(bytes, name: name);

  @override
  int? lengthSync() => size ?? bytes.length;

  @override
  Future<int?> length() async => lengthSync();

  @override
  Future<Uint8List> readAsBytes() async => bytes;

  @override
  Stream<Uint8List> readAsByteStream() => Stream.value(bytes);
}

/// Stands in for the system file picker.
class _FakePicker extends FilePickerPlatform {
  _FakePicker(this.pick);

  final Future<List<PlatformFile>> Function() pick;

  @override
  Future<List<PlatformFile>> pickFiles({
    String? dialogTitle,
    String? initialDirectory,
    FileType type = FileType.any,
    List<String>? allowedExtensions,
    Function(FilePickerStatus)? onFileLoading,
    int compressionQuality = 0,
    AndroidOptions androidOptions = const AndroidOptions(),
    DarwinOptions darwinOptions = const DarwinOptions(),
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) => pick();
}

void _picker(Future<List<PlatformFile>> Function() pick) {
  final previous = FilePickerPlatform.instance;
  FilePickerPlatform.instance = _FakePicker(pick);
  addTearDown(() => FilePickerPlatform.instance = previous);
}

Future<void> _tapImportFiles(WidgetTester tester) async {
  await tester.tap(find.text(_en.newScript));
  await tester.pumpAndSettle();
  await tester.tap(find.text(_en.importFiles));
  await tester.pumpAndSettle();
}

Uint8List _backup(List<Script> scripts) =>
    Uint8List.fromList(utf8.encode(Backup.encode(scripts)));

void _clipboard(WidgetTester tester, String? text) {
  final messenger = tester.binding.defaultBinaryMessenger;
  messenger.setMockMethodCallHandler(SystemChannels.platform, (call) async {
    if (call.method == 'Clipboard.getData') {
      return text == null ? null : {'text': text};
    }
    return null;
  });
  addTearDown(
    () => messenger.setMockMethodCallHandler(SystemChannels.platform, null),
  );
}

Future<AppState> _pumpApp(
  WidgetTester tester, {
  bool unlimited = true,
  int extraScripts = 0,
  bool appLock = false,
}) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  final storage = await Storage.open();
  if (appLock) await storage.setAppLock(true);
  final state = AppState(storage);
  for (var i = 0; i < extraScripts; i++) {
    await state.upsert(
      Script(
        id: 'mine-$i',
        title: 'Mine $i',
        body: 'hello world',
        updatedAt: DateTime(2026),
      ),
    );
  }
  final entitlements = Entitlements(isUnlimited: unlimited);
  await tester.pumpWidget(
    AprompterApp(
      state: state,
      entitlements: entitlements,
      purchaseService: PurchaseService(entitlements: entitlements),
    ),
  );
  await tester.pumpAndSettle();
  return state;
}

String _editorTitle(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField).first).controller!.text;

String _editorBody(WidgetTester tester) =>
    tester.widget<TextField>(find.byType(TextField).last).controller!.text;

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('Paste as new script: copied note opens in the editor', (
    tester,
  ) async {
    _clipboard(
      tester,
      'Grocery haul\r\nHey everyone!\u00A0Today I show what I bought.\r\n\r\n'
      '# Fruit\r\nApples [pause] and *mangoes*.\r\n#fyp #haul',
    );
    final state = await _pumpApp(tester, unlimited: false);
    await tester.tap(find.text(_en.newScript));
    await tester.pumpAndSettle();
    expect(find.text(_en.pasteAsNewScript), findsOneWidget);
    expect(find.text(_en.importFiles), findsOneWidget);
    await tester.tap(find.text(_en.pasteAsNewScript));
    await tester.pumpAndSettle();

    expect(find.byType(EditorScreen), findsOneWidget);
    expect(_editorTitle(tester), 'Grocery haul');
    // A paste keeps every line it copied; the first one also names it.
    expect(
      _editorBody(tester),
      'Grocery haul\nHey everyone! Today I show what I bought.\n\n'
      '# Fruit\nApples [pause] and *mangoes*.\n#fyp #haul',
    );
    final saved = state.scripts.firstWhere((s) => s.title == 'Grocery haul');
    expect(saved.sections, ['Fruit']);
  });

  testWidgets('Paste as new script with nothing copied says so', (
    tester,
  ) async {
    _clipboard(tester, null);
    final state = await _pumpApp(tester);
    await tester.tap(find.text(_en.newScript));
    await tester.pumpAndSettle();
    await tester.tap(find.text(_en.pasteAsNewScript));
    await tester.pumpAndSettle();
    expect(find.text(_en.clipboardEmpty), findsOneWidget);
    expect(find.byType(EditorScreen), findsNothing);
    expect(state.scripts, hasLength(1)); // just the welcome script
  });

  testWidgets('a note shared from Google Keep while the app is open becomes '
      'a script in the editor', (tester) async {
    final shares = _FakeShares(tester);
    final state = await _pumpApp(tester);
    expect(shares.takes, 1); // looked once the home screen was up

    shares.pending.add({
      'subject': 'Morning routine',
      'text': 'Morning routine\n\nWake up at 5.\nStretch. [pause]\n#morning',
    });
    await shares.announce();

    expect(find.byType(EditorScreen), findsOneWidget);
    expect(_editorTitle(tester), 'Morning routine');
    expect(_editorBody(tester), 'Wake up at 5.\nStretch. [pause]\n#morning');
    expect(state.scripts.map((s) => s.title), contains('Morning routine'));

    // Shared again by mistake: the same script opens, no duplicate.
    await tester.pageBack();
    await tester.pumpAndSettle();
    shares.pending.add({
      'subject': 'Morning routine',
      'text': 'Wake up at 5.\nStretch. [pause]\n#morning',
    });
    await shares.announce();
    expect(find.byType(EditorScreen), findsOneWidget);
    expect(
      state.scripts.where((s) => s.title == 'Morning routine'),
      hasLength(1),
    );
  });

  testWidgets('files shared before the app started come in on the home '
      'screen: several scripts are counted, failures explained', (
    tester,
  ) async {
    final shares = _FakeShares(tester);
    shares.pending.addAll([
      {
        'name': 'Hook ideas.md',
        'mimeType': 'text/markdown',
        'bytes': Uint8List.fromList(
          utf8.encode(
            '# Hook ideas\n\n- **Stop** scrolling\n- [Link](https://x.co)',
          ),
        ),
      },
      {
        'name': 'Outro.txt',
        'bytes': Uint8List.fromList(utf8.encode('Thanks for watching!')),
      },
      {'name': 'Huge.docx', 'tooLarge': true},
    ]);
    final state = await _pumpApp(tester);

    final hooks = state.scripts.firstWhere((s) => s.title == 'Hook ideas');
    expect(hooks.body, '*Stop* scrolling\nLink');
    expect(state.scripts.map((s) => s.title), contains('Outro'));
    expect(find.byType(EditorScreen), findsNothing);
    expect(find.text(_en.importTooLarge), findsOneWidget);
    // The failure is shown first, then the count.
    await tester.pump(const Duration(seconds: 9));
    await tester.pumpAndSettle();
    expect(find.text(_en.importedNewScripts(2)), findsOneWidget);
  });

  testWidgets('the free plan: a share past the limit shows the upgrade sheet '
      'once, then explains that nothing was lost', (tester) async {
    _offlineStore(tester);
    final shares = _FakeShares(tester);
    shares.pending.add({'text': 'One more idea for a video, please.'});
    final state = await _pumpApp(tester, unlimited: false, extraScripts: 1);

    expect(find.text(_en.upgradeTitle), findsOneWidget);
    expect(find.byType(BottomSheet), findsOneWidget);
    await tester.tapAt(const Offset(20, 20)); // close the sheet
    await tester.pumpAndSettle();

    expect(find.text(_en.importFreeLimit(maxFreeScripts)), findsOneWidget);
    expect(find.byType(EditorScreen), findsNothing);
    expect(state.scripts, hasLength(2)); // welcome + the one they had
  });

  testWidgets('with app lock on, a share waits until the app is unlocked', (
    tester,
  ) async {
    var allow = false;
    const auth = MethodChannel('plugins.flutter.io/local_auth');
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(auth, (
      call,
    ) async {
      return switch (call.method) {
        'authenticate' => allow,
        'isDeviceSupported' => true, // the phone has a screen lock
        _ => null,
      };
    });
    addTearDown(
      () => tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
        auth,
        null,
      ),
    );
    final shares = _FakeShares(tester);
    shares.pending.add({'subject': 'Secret plan', 'text': 'Launch on Friday.'});
    final state = await _pumpApp(tester, appLock: true);

    expect(find.text(_en.unlock), findsOneWidget);
    expect(shares.takes, 0);
    expect(state.scripts.map((s) => s.title), isNot(contains('Secret plan')));

    allow = true;
    await tester.tap(find.text(_en.unlock));
    await tester.pumpAndSettle();

    expect(shares.takes, 1);
    expect(find.byType(EditorScreen), findsOneWidget);
    expect(_editorTitle(tester), 'Secret plan');
  });

  testWidgets('every script can be saved as a text file', (tester) async {
    await _pumpApp(tester);
    await tester.tap(find.byIcon(Icons.more_vert).first);
    await tester.pumpAndSettle();
    expect(find.text(_en.saveAsTextFile), findsOneWidget);
    expect(find.text(_en.share), findsOneWidget);
  });

  testWidgets('a note shared again while its editor is open keeps one '
      'editor, and the edits made in it', (tester) async {
    final shares = _FakeShares(tester);
    final state = await _pumpApp(tester);
    shares.pending.add({'subject': 'Plan', 'text': 'Plan\n\nFirst line.'});
    await shares.announce();
    expect(find.byType(EditorScreen), findsOneWidget);

    shares.pending.add({'subject': 'Plan', 'text': 'Plan\n\nFirst line.'});
    await shares.announce();
    expect(find.byType(EditorScreen, skipOffstage: false), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, 'Edited here.');
    await tester.pump(const Duration(seconds: 2));
    await tester.pageBack();
    await tester.pumpAndSettle();
    expect(find.byType(EditorScreen, skipOffstage: false), findsNothing);
    final plan = state.scripts.where((s) => s.title == 'Plan');
    expect(plan.map((s) => s.body), ['Edited here.']);
  });

  testWidgets('a note without a title shared twice is not added twice', (
    tester,
  ) async {
    final shares = _FakeShares(tester);
    final state = await _pumpApp(tester, unlimited: false);
    shares.pending.add({'text': 'Just one line of text'});
    await shares.announce();
    expect(find.byType(EditorScreen), findsOneWidget);
    await tester.pageBack(); // the editor saves it as "Untitled"
    await tester.pumpAndSettle();
    expect(
      state.scripts
          .where((s) => s.body == 'Just one line of text')
          .single
          .title,
      _en.untitled,
    );

    shares.pending.add({'text': 'Just one line of text'});
    await shares.announce();
    // The copy already here opens: no duplicate, no upgrade sheet.
    expect(find.text(_en.upgradeTitle), findsNothing);
    expect(find.byType(EditorScreen), findsOneWidget);
    expect(
      state.scripts.where((s) => s.body == 'Just one line of text'),
      hasLength(1),
    );
  });

  testWidgets('past the free plan the rest of a batch still comes in: a '
      'backup is restored and both messages are shown', (tester) async {
    _offlineStore(tester);
    final shares = _FakeShares(tester);
    shares.pending.addAll([
      {'text': 'New idea, please. It is a good one.'},
      {
        'name': 'aprompter-backup-2026-10-02.json',
        'mimeType': 'application/json',
        'bytes': _backup([
          Script(
            id: 'b1',
            title: 'Old 1',
            body: 'One.',
            updatedAt: DateTime(2026),
          ),
          Script(
            id: 'b2',
            title: 'Old 2',
            body: 'Two.',
            updatedAt: DateTime(2026),
          ),
        ]),
      },
      {
        'name': 'scan.pdf',
        'bytes': Uint8List.fromList(utf8.encode('%PDF-1.7')),
      },
    ]);
    final state = await _pumpApp(tester, unlimited: false, extraScripts: 1);

    expect(find.text(_en.upgradeTitle), findsOneWidget);
    await tester.tapAt(const Offset(20, 20)); // close the sheet
    await tester.pumpAndSettle();

    expect(state.scripts.map((s) => s.id), containsAll(['b1', 'b2']));
    expect(state.scripts.where((s) => s.body.startsWith('New idea')), isEmpty);
    expect(find.text(_en.importedScripts(2)), findsOneWidget);
    await tester.pump(const Duration(seconds: 5));
    await tester.pumpAndSettle();
    expect(find.text(_en.importFreeLimit(maxFreeScripts)), findsOneWidget);
    await tester.pump(const Duration(seconds: 9));
    await tester.pumpAndSettle();
    expect(find.text(_en.importPdf), findsOneWidget);
  });

  testWidgets('Import files: several files at once, each one handled', (
    tester,
  ) async {
    _picker(
      () async => [
        _Picked('Intro.txt', 'Intro\n\nHey, welcome back!'),
        _Picked('Hooks.md', '# Hooks\n\n- **Stop** scrolling'),
        _Picked('Scan.pdf', '%PDF-1.7 binary'),
        _Picked('Huge.txt', 'x', size: maxImportBytes + 1),
      ],
    );
    final state = await _pumpApp(tester);
    await _tapImportFiles(tester);

    expect(
      state.scripts.firstWhere((s) => s.title == 'Intro').body,
      'Hey, welcome back!',
    );
    expect(
      state.scripts.firstWhere((s) => s.title == 'Hooks').body,
      '*Stop* scrolling',
    );
    expect(find.byType(EditorScreen), findsNothing);
    expect(find.text(_en.importPdf), findsOneWidget);
    await tester.pump(const Duration(seconds: 9));
    await tester.pumpAndSettle();
    expect(find.text(_en.importedNewScripts(2)), findsOneWidget);
  });

  testWidgets('Import files: one file opens in the editor; a backup picked '
      'there is restored', (tester) async {
    var files = <PlatformFile>[_Picked('Outro.txt', 'Thanks for watching!')];
    _picker(() async => files);
    final state = await _pumpApp(tester);
    await _tapImportFiles(tester);
    expect(find.byType(EditorScreen), findsOneWidget);
    expect(_editorTitle(tester), 'Outro');
    await tester.pageBack();
    await tester.pumpAndSettle();

    files = [
      _Picked.bytes(
        'aprompter-backup-2026-10-02.json',
        _backup([
          Script(
            id: 'r1',
            title: 'Restored',
            body: 'Hi.',
            updatedAt: DateTime(2026),
          ),
        ]),
      ),
    ];
    await _tapImportFiles(tester);
    expect(state.scripts.map((s) => s.title), contains('Restored'));
    expect(find.text(_en.importedScripts(1)), findsOneWidget);
  });

  testWidgets('Import files: a picker error is explained, nothing changes', (
    tester,
  ) async {
    _picker(() async {
      throw PlatformException(code: 'unknown_path', message: 'no MIME type');
    });
    final state = await _pumpApp(tester);
    final before = state.scripts.length;
    await _tapImportFiles(tester);
    expect(find.text(_en.importUnreadable), findsOneWidget);
    expect(state.scripts, hasLength(before));
  });

  testWidgets('Save as text file says so when the file can\'t be made', (
    tester,
  ) async {
    await _pumpApp(tester); // no share sheet in tests: sharing fails
    await tester.tap(find.byIcon(Icons.more_vert).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text(_en.saveAsTextFile));
    await tester.pumpAndSettle();
    // share_plus writes the file with real I/O before it fails.
    await tester.runAsync(
      () => Future<void>.delayed(const Duration(milliseconds: 200)),
    );
    await tester.pumpAndSettle();
    expect(find.text(_en.saveTextFileFailed), findsOneWidget);
  });
}
