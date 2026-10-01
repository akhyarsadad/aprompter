// Unhappy-path scenarios from docs/UNHAPPY_PATHS.md.
import 'dart:convert';

import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/main.dart';
import 'package:aprompter/models/prompter_settings.dart';
import 'package:aprompter/models/script.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/storage.dart';
import 'package:aprompter/widgets/prompter_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  Future<AppState> pumpApp(WidgetTester tester) async {
    tester.view.physicalSize = const Size(1080, 2340);
    tester.view.devicePixelRatio = 3;
    addTearDown(tester.view.reset);
    final state = AppState(await Storage.open());
    await tester.pumpWidget(AprompterApp(state: state));
    return state;
  }

  Map<String, Object?> scriptJson(String id, String title, String body) =>
      Script(
        id: id,
        title: title,
        body: body,
        updatedAt: DateTime(2026),
      ).toJson();

  group('U1 corrupted data', () {
    test('unreadable library does not crash and is backed up', () async {
      SharedPreferences.setMockInitialValues({
        'scripts': '{not json',
        'settings': '{"fontSize": "huge", "textColor": 1.5}',
      });
      final storage = await Storage.open();
      expect(storage.loadScripts(), isEmpty);
      expect(
        storage.loadSettings().fontSize,
        const PrompterSettings().fontSize,
      );

      final prefs = await SharedPreferences.getInstance();
      final backups = prefs.getKeys().where(
        (k) => k.startsWith('scripts${Storage.backupSuffix}'),
      );
      expect(backups, hasLength(1));
      expect(prefs.getString(backups.single), '{not json');
    });

    test('one bad entry does not take the good ones down', () async {
      SharedPreferences.setMockInitialValues({
        'scripts': jsonEncode([
          scriptJson('a', 'Good one', 'hello'),
          {'title': 42},
          scriptJson('b', 'Good two', 'world'),
        ]),
      });
      final storage = await Storage.open();
      expect(
        storage.loadScripts().map((s) => s.title),
        containsAll(['Good one', 'Good two']),
      );
    });
  });

  testWidgets('U10 play after the end restarts instead of re-finishing', (
    tester,
  ) async {
    var finished = 0;
    final controller = PrompterController(wpm: 300);
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: SizedBox(
          height: 300,
          child: PrompterView(
            text: List.filled(50, 'word').join(' '),
            settings: const PrompterSettings(),
            controller: controller,
            onFinished: () => finished++,
          ),
        ),
      ),
    );
    controller.play();
    await tester.pump();
    await tester.pump(const Duration(seconds: 15));
    expect(finished, 1);
    expect(controller.progress.value, 1);

    controller.play();
    await tester.pump();
    await tester.pump(const Duration(seconds: 1));
    expect(finished, 1, reason: 'must not finish again immediately');
    expect(controller.playing, isTrue);
    expect(controller.progress.value, lessThan(0.5));
  });

  testWidgets('U11 editor autosaves while typing', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final state = await pumpApp(tester);
    await tester.tap(find.text('New script'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Blank'));
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField).first, 'Draft idea');
    await tester.enterText(find.byType(TextField).last, 'Some words here');
    await tester.pump(const Duration(milliseconds: 500));
    expect(state.scripts.where((s) => s.title == 'Draft idea'), isEmpty);
    await tester.pump(const Duration(seconds: 1));
    // Saved without leaving the editor.
    expect(
      state.scripts.singleWhere((s) => s.title == 'Draft idea').body,
      'Some words here',
    );
  });

  testWidgets('U12 cannot record a script with nothing to say', (tester) async {
    SharedPreferences.setMockInitialValues({
      'scripts': jsonEncode([
        scriptJson('a', 'Only notes', '# Hook\n// smile'),
      ]),
    });
    await pumpApp(tester);
    await tester.tap(find.text('Record'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Add some lines to say first'), findsOneWidget);
    expect(find.text('Only notes'), findsOneWidget, reason: 'still on home');

    await tester.tap(find.text('Rehearse'));
    await tester.pumpAndSettle();
    expect(find.text('Only notes'), findsOneWidget);
  });

  testWidgets('U13 copy as caption on an empty script copies nothing', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({
      'scripts': jsonEncode([scriptJson('a', 'Empty', '')]),
    });
    final copied = <String>[];
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'Clipboard.setData') {
          copied.add((call.arguments as Map)['text'] as String);
        }
        return null;
      },
    );
    await pumpApp(tester);
    await tester.tap(find.byIcon(Icons.more_vert));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Copy as caption'));
    await tester.pumpAndSettle();
    expect(copied, isEmpty);
    expect(find.textContaining('Add some lines to say first'), findsOneWidget);
  });
}
