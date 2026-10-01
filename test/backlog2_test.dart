// Second round of fixes from docs/UNHAPPY_PATHS_BACKLOG.md.
import 'dart:convert';

import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/main.dart';
import 'package:aprompter/models/prompter_settings.dart';
import 'package:aprompter/models/script.dart';
import 'package:aprompter/models/script_markup.dart';
import 'package:aprompter/screens/editor_screen.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/backup.dart';
import 'package:aprompter/services/storage.dart';
import 'package:aprompter/widgets/movable_box.dart';
import 'package:aprompter/widgets/prompter_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

Script _script(String id, String body, {String title = 't'}) =>
    Script(id: id, title: title, body: body, updatedAt: DateTime(2026));

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  Future<void> pumpPrompter(
    WidgetTester tester,
    String text,
    PrompterController controller, {
    PrompterSettings settings = const PrompterSettings(),
    ValueChanged<double>? onWpmChanged,
    VoidCallback? onFinished,
  }) => tester.pumpWidget(
    MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      home: Center(
        child: SizedBox(
          width: 360,
          height: 400,
          child: PrompterView(
            text: text,
            settings: settings,
            controller: controller,
            onWpmChanged: onWpmChanged,
            onFinished: onFinished,
          ),
        ),
      ),
    ),
  );

  group('D3 one storage entry per script', () {
    test('an old single-list library is moved over and still loads', () async {
      SharedPreferences.setMockInitialValues({
        'scripts': jsonEncode([
          _script('a', 'one').toJson(),
          _script('b', 'two').toJson(),
        ]),
      });
      final storage = await Storage.open();
      expect(storage.loadScripts().map((s) => s.id), containsAll(['a', 'b']));
      await pumpEventQueue();
      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getString('scripts'), isNull);
      expect(prefs.getStringList('script_index'), ['a', 'b']);

      final again = await Storage.open();
      expect(
        again.loadScripts().map((s) => s.body),
        containsAll(['one', 'two']),
      );
    });

    test('saving one script leaves the others alone', () async {
      final state = AppState(await Storage.open());
      await state.upsert(_script('a', 'one'));
      await state.upsert(_script('b', 'two'));
      final prefs = await SharedPreferences.getInstance();
      final before = prefs.getString('script:a');
      await state.upsert(state.byId('b')!.copyWith(body: 'changed'));
      expect(prefs.getString('script:a'), before);
      await state.delete('a');
      expect(prefs.getString('script:a'), isNull);
      expect(AppState(await Storage.open()).byId('b')?.body, 'changed');
    });

    test('a damaged entry is kept aside, the rest loads', () async {
      SharedPreferences.setMockInitialValues({
        'script_index': ['a', 'b'],
        'script:a': jsonEncode(_script('a', 'fine').toJson()),
        'script:b': '{"body": "half',
      });
      final storage = await Storage.open();
      expect(storage.loadScripts().map((s) => s.id), ['a']);
      await pumpEventQueue();
      expect(storage.damagedBackups().values, ['{"body": "half']);
    });
  });

  group('D4 recovering unreadable data', () {
    test('scripts are salvaged from damaged data', () {
      final raw = jsonEncode([
        {'body': 'no id or title'},
        {'id': 'x', 'title': 'Kept', 'body': 'with id', 'status': 99},
        42,
      ]);
      final found = salvageScripts(raw);
      expect(found.map((s) => s.body), ['no id or title', 'with id']);
      expect(salvageScripts('not json at all'), isEmpty);
    });

    test('recovering adds the scripts and removes the damaged copy', () async {
      SharedPreferences.setMockInitialValues({
        'scripts_backup_1700000000000':
            '[{"id":"r","title":"Rescued","body":"hello","updatedAt":"x"}]',
      });
      final state = AppState(await Storage.open());
      expect(state.damagedData, hasLength(1));
      expect(await state.recoverDamaged(state.damagedData.keys.single), 1);
      expect(state.byId('r')?.body, 'hello');
      expect(state.damagedData, isEmpty);
    });
  });

  testWidgets('R1 a touch at the screen edge does not pause', (tester) async {
    final controller = PrompterController();
    await pumpPrompter(tester, 'Hello there', controller);
    final box = tester.getRect(find.byType(PrompterView));
    await tester.tapAt(Offset(box.left + 5, box.center.dy));
    expect(controller.playing, isFalse);
    await tester.tapAt(box.center);
    expect(controller.playing, isTrue);
    await tester.tapAt(Offset(box.right - 5, box.center.dy));
    expect(controller.playing, isTrue);
  });

  test('R2 dark text gets a light backdrop', () {
    expect(PrompterSettings.isDark(0xFF000000), isTrue);
    expect(PrompterSettings.isDark(0xFFFFFFFF), isFalse);
    expect(PrompterSettings.isDark(0xFFFFEB3B), isFalse);
  });

  testWidgets('R6 section titles keep their casing', (tester) async {
    await pumpPrompter(tester, '# istanbul\nMerhaba', PrompterController());
    expect(find.text('istanbul'), findsOneWidget);
  });

  testWidgets('A4 line by line: taps move one line, nothing scrolls', (
    tester,
  ) async {
    final controller = PrompterController(wpm: 400);
    var finished = 0;
    await pumpPrompter(
      tester,
      'First line\nSecond line\nThird line',
      controller,
      settings: const PrompterSettings(stepByLine: true),
      onFinished: () => finished++,
    );
    controller.play();
    await tester.pump(const Duration(seconds: 5));
    expect(controller.progress.value, 0, reason: 'no automatic scrolling');
    final center = tester.getCenter(find.byType(PrompterView));
    await tester.tapAt(center);
    await tester.pumpAndSettle();
    final one = controller.progress.value;
    expect(one, greaterThan(0));
    await tester.tapAt(center);
    await tester.pumpAndSettle();
    expect(controller.progress.value, greaterThan(one));
    await tester.tapAt(center);
    await tester.pumpAndSettle();
    expect(finished, 1);
  });

  testWidgets('T5 pace changed from a remote is reported to be kept', (
    tester,
  ) async {
    double? kept;
    final controller = PrompterController(wpm: 150);
    await pumpPrompter(
      tester,
      'Hello',
      controller,
      onWpmChanged: (v) => kept = v,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    expect(kept, 160);
  });

  testWidgets('T9 a run with jumps is marked', (tester) async {
    final controller = PrompterController(wpm: 150);
    await pumpPrompter(
      tester,
      '# A\n${List.filled(60, 'word').join(' ')}\n# B\nend',
      controller,
    );
    controller.play();
    await tester.pump(const Duration(milliseconds: 500));
    expect(controller.jumpedDuringRun, isFalse);
    controller.nextSection();
    expect(controller.jumpedDuringRun, isTrue);
    controller.restart();
    expect(controller.jumpedDuringRun, isFalse);
  });

  test('T3 long numbers take longer to say', () {
    expect(countWords('2025'), 2);
    expect(countWords(r'$1,299'), 3);
    expect(countWords('42 cats'), 2);
  });

  test('T7 Thai phrases are split on spaces', () {
    final phrase = 'สวัสดีครับวันนี้เราจะมาเรียน';
    final thai = List.filled(12, phrase).join(' ');
    expect(longSentenceCount(thai), 0);
  });

  test('W7 pasted text is cleaned', () {
    expect(
      cleanPastedText('• First​ point\r\n\t- Second point\n3 - 1'),
      'First point\nSecond point\n3 - 1',
    );
  });

  test('O5 the untouched welcome script follows a new language', () async {
    final state = AppState(await Storage.open());
    final en = lookupAppLocalizations(const Locale('en'));
    await state.setLocale(const Locale('en'));
    expect(state.scripts.single.title, en.welcomeTitle);
    await state.setLocale(const Locale('id'));
    final id = lookupAppLocalizations(const Locale('id'));
    expect(state.scripts.single.title, id.welcomeTitle);
    expect(state.scripts.single.body, id.welcomeBody);
  });

  test('F9 pace set in the floating window reaches the app', () async {
    final state = AppState(await Storage.open());
    final storage = await Storage.open();
    await storage.saveSettings(state.settings.copyWith(wpm: 210));
    await state.reloadSettings();
    expect(state.settings.wpm, 210);
  });

  testWidgets('A3 move and resize handles are at least 48 dp', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Stack(
          children: [
            MovablePrompterBox(
              area: const Rect.fromLTWH(0, 0, 400, 800),
              settings: const PrompterSettings(),
              onChanged: (_) {},
              child: const SizedBox.expand(),
            ),
          ],
        ),
      ),
    );
    for (final key in ['prompter-move', 'prompter-resize']) {
      final size = tester.getSize(find.byKey(ValueKey(key)));
      expect(size.height, greaterThanOrEqualTo(48), reason: key);
      expect(size.width, greaterThanOrEqualTo(48), reason: key);
    }
  });

  testWidgets('Y1 with app lock on, scripts are hidden until unlocked', (
    tester,
  ) async {
    SharedPreferences.setMockInitialValues({'app_lock': true});
    final state = AppState(await Storage.open());
    await tester.pumpWidget(AprompterApp(state: state));
    await tester.pump();
    expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    final l = lookupAppLocalizations(const Locale('en'));
    expect(find.text(l.newScript).hitTestable(), findsNothing);
  });

  testWidgets('A1 screens still fit with 200% system text on a small phone', (
    tester,
  ) async {
    tester.view.physicalSize = const Size(1080, 2220); // 360 x 740 dp
    tester.view.devicePixelRatio = 3;
    tester.platformDispatcher.textScaleFactorTestValue = 2;
    addTearDown(tester.view.reset);
    addTearDown(tester.platformDispatcher.clearTextScaleFactorTestValue);
    final state = AppState(await Storage.open());
    await tester.pumpWidget(AprompterApp(state: state));
    await tester.pumpAndSettle();
    final l = lookupAppLocalizations(const Locale('en'));

    await tester.tap(find.byTooltip(l.prompterSettings));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(Scrollable).last, const Offset(0, -6000));
    await tester.pumpAndSettle();
    await tester.tapAt(const Offset(180, 20));
    await tester.pumpAndSettle();

    await tester.tap(find.text(l.newScript));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text(l.templateReview),
      200,
      scrollable: find.byType(Scrollable).last,
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text(l.templateReview));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(BackButton));
    await tester.pumpAndSettle();

    await tester.tap(find.text(l.rehearse).first);
    await tester.pumpAndSettle();
    expect(find.byType(PrompterView), findsOneWidget);
  });
}
