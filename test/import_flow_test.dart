// One step in: paste, share from another app, open a file — on the home
// screen, with the free plan and the app lock respected.
import 'dart:convert';

import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/main.dart';
import 'package:aprompter/models/script.dart';
import 'package:aprompter/screens/editor_screen.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/entitlements.dart';
import 'package:aprompter/services/purchase_service.dart';
import 'package:aprompter/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
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
    expect(
      _editorBody(tester),
      'Hey everyone! Today I show what I bought.\n\n'
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
      return call.method == 'authenticate' ? allow : null;
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
}
