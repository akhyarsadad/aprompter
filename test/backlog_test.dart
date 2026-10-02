// Fixes for items in docs/UNHAPPY_PATHS_BACKLOG.md.
import 'dart:convert';

import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/main.dart';
import 'package:aprompter/models/prompter_settings.dart';
import 'package:aprompter/models/script.dart';
import 'package:aprompter/models/templates.dart';
import 'package:aprompter/screens/home_screen.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/auth_service.dart';
import 'package:aprompter/services/backup.dart';
import 'package:aprompter/services/entitlements.dart';
import 'package:aprompter/services/storage.dart';
import 'package:aprompter/widgets/prompter_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';

/// A phone whose storage is full: every write is refused.
class _FullStore extends InMemorySharedPreferencesStore {
  _FullStore() : super.empty();
  bool full = true;

  @override
  Future<bool> setValue(String valueType, String key, Object value) async =>
      full ? false : super.setValue(valueType, key, value);
}

Script _script(String id, String body, {DateTime? at, String title = 't'}) =>
    Script(id: id, title: title, body: body, updatedAt: at ?? DateTime(2026));

void main() {
  Future<int Function()> pumpPrompter(
    WidgetTester tester,
    String text,
    PrompterController controller, {
    VoidCallback? onTap,
  }) async {
    var finished = 0;
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        home: SizedBox(
          height: 400,
          child: PrompterView(
            text: text,
            settings: const PrompterSettings(),
            controller: controller,
            onTap: onTap,
            onFinished: () => finished++,
          ),
        ),
      ),
    );
    return () => finished;
  }

  testWidgets('T1 notes do not make spoken lines scroll faster', (
    tester,
  ) async {
    final controller = PrompterController(wpm: 300);
    final words = List.filled(30, 'word').join(' '); // 6 s at 300 wpm
    final notes = List.filled(40, '// a note to myself').join('\n');
    final finished = await pumpPrompter(tester, '$words\n$notes', controller);
    controller.play();
    await tester.pump();
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    // Halfway through the spoken line, and the notes are most of the height.
    expect(controller.progress.value, lessThan(0.4));
    for (var i = 0; i < 28; i++) {
      await tester.pump(const Duration(milliseconds: 100));
    }
    expect(finished(), 0, reason: 'spoken words need their full 6 s');
    await tester.pump(const Duration(seconds: 10));
    expect(finished(), 1);
  });

  testWidgets('K1 volume keys from a selfie remote play and pause', (
    tester,
  ) async {
    final controller = PrompterController(wpm: 150);
    await pumpPrompter(tester, 'Hello there', controller);
    await tester.sendKeyEvent(LogicalKeyboardKey.audioVolumeUp);
    expect(controller.playing, isTrue);
    await tester.sendKeyEvent(LogicalKeyboardKey.audioVolumeDown);
    expect(controller.playing, isFalse);
  });

  testWidgets('K2 page-turner keys move between sections', (tester) async {
    final controller = PrompterController(wpm: 150);
    await pumpPrompter(
      tester,
      '# One\n${List.filled(80, 'word').join(' ')}\n# Two\nend',
      controller,
    );
    await tester.sendKeyEvent(LogicalKeyboardKey.mediaTrackNext);
    await tester.pump();
    expect(controller.progress.value, greaterThan(0.5));
    await tester.sendKeyEvent(LogicalKeyboardKey.mediaTrackPrevious);
    await tester.pump();
    expect(controller.progress.value, lessThan(0.1));
    await tester.sendKeyEvent(LogicalKeyboardKey.keyB);
    expect(controller.playing, isTrue);
  });

  group('data safety', () {
    setUp(() => SharedPreferences.setMockInitialValues({}));

    test(
      'D2 a refused write is reported, kept in memory and retried',
      () async {
        final store = _FullStore();
        SharedPreferencesStorePlatform.instance = store;
        final state = AppState(await Storage.open());
        await state.upsert(_script('a', 'hello'));
        expect(state.saveFailed, isTrue);
        expect(state.byId('a')?.body, 'hello');

        store.full = false;
        await state.retrySave();
        expect(state.saveFailed, isFalse);
        final reopened = AppState(await Storage.open());
        expect(reopened.byId('a')?.body, 'hello');
      },
    );

    testWidgets('D2 a banner tells the creator when saving fails', (
      tester,
    ) async {
      SharedPreferencesStorePlatform.instance = _FullStore();
      final state = AppState(await Storage.open());
      final entitlements = Entitlements(isUnlimited: true);
      await tester.pumpWidget(
        AprompterApp(
          state: state,
          entitlements: entitlements,
          authService: AuthService(
            entitlements: entitlements,
            storage: state.storage,
          ),
        ),
      );
      expect(find.byIcon(Icons.sd_card_alert), findsNothing);
      await state.upsert(_script('a', 'hello'));
      await tester.pump();
      expect(find.byIcon(Icons.sd_card_alert), findsOneWidget);
    });

    test('W4 select-all + delete keeps the old text as a version', () async {
      final state = AppState(await Storage.open());
      await state.upsert(
        _script('a', 'My whole long script, carefully written'),
      );
      await state.upsert(state.byId('a')!.copyWith(body: ''));
      final versions = state.versionsOf('a');
      expect(versions, hasLength(1));
      expect(versions.single.body, 'My whole long script, carefully written');

      final restored = await state.restoreVersion('a', versions.single);
      expect(restored?.body, 'My whole long script, carefully written');
      // The emptied text is itself kept, so restoring can be undone too.
      expect(state.versionsOf('a').first.body, '');
    });

    test('W4 typing does not create a version on every save', () async {
      final state = AppState(await Storage.open());
      await state.upsert(_script('a', 'Hello'));
      await state.upsert(state.byId('a')!.copyWith(body: 'Hello w'));
      await state.upsert(state.byId('a')!.copyWith(body: 'Hello wo'));
      await state.upsert(state.byId('a')!.copyWith(body: 'Hello world'));
      expect(state.versionsOf('a'), hasLength(1));
    });

    test(
      'D5 deleted scripts go to Recently deleted and can come back',
      () async {
        final state = AppState(await Storage.open());
        await state.upsert(_script('a', 'hello'));
        await state.delete('a');
        expect(state.byId('a'), isNull);
        expect(state.trash.single.script.id, 'a');

        // Survives a restart.
        final reopened = AppState(await Storage.open());
        expect(reopened.trash.single.script.body, 'hello');
        await reopened.restore(reopened.trash.single.script);
        expect(reopened.byId('a')?.body, 'hello');
        expect(reopened.trash, isEmpty);

        await reopened.delete('a');
        await reopened.deleteForever('a');
        expect(reopened.trash, isEmpty);
      },
    );

    test('D5 Recently deleted forgets scripts after 30 days', () async {
      SharedPreferences.setMockInitialValues({
        'trash': jsonEncode([
          TrashedScript(
            _script('old', 'x'),
            DateTime.now().subtract(const Duration(days: 31)),
          ).toJson(),
          TrashedScript(_script('new', 'y'), DateTime.now()).toJson(),
        ]),
      });
      final storage = await Storage.open();
      expect(storage.loadTrash().map((t) => t.script.id), ['new']);
    });

    test('D1 a backup restores on a fresh phone and merges by date', () async {
      final state = AppState(await Storage.open());
      await state.upsert(_script('a', 'one', title: 'A'));
      await state.upsert(_script('b', 'two', title: 'B'));
      final file = Backup.encode(state.scripts);

      SharedPreferences.setMockInitialValues({});
      final fresh = AppState(await Storage.open());
      final scripts = Backup.decode(file)!;
      // Both scripts plus the welcome script of the first phone.
      expect(await fresh.importScripts(scripts), 3);
      expect(fresh.byId('a')?.body, 'one');
      // Importing again changes nothing.
      expect(await fresh.importScripts(scripts), 0);

      // A newer local edit is not overwritten by an older backup.
      await fresh.upsert(fresh.byId('a')!.copyWith(body: 'edited'));
      await fresh.importScripts(scripts);
      expect(fresh.byId('a')?.body, 'edited');

      expect(Backup.decode('{"hello": 1}'), isNull);
      expect(Backup.decode('not json'), isNull);
    });

    test('D6 marking ready or counting a take keeps the order', () async {
      final state = AppState(await Storage.open());
      await state.upsert(_script('a', 'one'));
      await state.upsert(_script('b', 'two'));
      List<String> order() => [
        for (final s in state.scripts)
          if (s.id == 'a' || s.id == 'b') s.id,
      ];
      expect(order(), ['b', 'a']);
      await state.recordTake('a');
      await state.upsert(state.byId('a')!.copyWith(status: ScriptStatus.ready));
      expect(order(), ['b', 'a']);
      expect(state.byId('a')?.takes, 1);
    });
  });

  test('D7 search ignores accents and Turkish dotted I', () {
    expect(foldForSearch('Café Crème'), contains(foldForSearch('cafe creme')));
    expect(foldForSearch('İSTANBUL'), foldForSearch('istanbul'));
    expect(foldForSearch('Tiếng Việt'), 'tieng viet');
  });

  test('W6 custom target lengths', () {
    expect(parseTargetInput('5:00'), 300);
    expect(parseTargetInput('4:30'), 270);
    expect(parseTargetInput('12'), 720);
    expect(parseTargetInput('1,5'), 90);
    expect(parseTargetInput('0'), isNull);
    expect(parseTargetInput('2:75'), isNull);
    expect(parseTargetInput('abc'), isNull);
    final l = lookupAppLocalizations(const Locale('en'));
    expect(targetLabel(l, 270), '4:30');
    expect(targetLabel(l, 600), targetLabel(l, 600));
  });
}
