// Nothing a creator made is lost or locked away: takes survive an iOS update,
// a missing screen lock doesn't lock them out, a backup doesn't overwrite a
// newer deleted script, and nothing is deleted for good without asking.
import 'dart:convert';
import 'dart:io';

import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/main.dart';
import 'package:aprompter/models/script.dart';
import 'package:aprompter/screens/takes_screen.dart';
import 'package:aprompter/screens/trash_screen.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/entitlements.dart';
import 'package:aprompter/services/purchase_service.dart';
import 'package:aprompter/services/storage.dart';
import 'package:aprompter/widgets/app_lock.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:local_auth/local_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _en = lookupAppLocalizations(const Locale('en'));

Script _script(String id, String body, {DateTime? at, String title = 't'}) =>
    Script(id: id, title: title, body: body, updatedAt: at ?? DateTime(2026));

/// A folder standing in for `<app documents>/takes`.
Directory _takesDir() {
  final dir = Directory.systemTemp.createTempSync('takes');
  addTearDown(() {
    if (dir.existsSync()) dir.deleteSync(recursive: true);
  });
  return dir;
}

/// A take as an earlier version stored it: the full path of a folder that
/// iOS has since moved (a new container id after an App Store update).
Take _oldTake(String scriptId, String file) => Take(
  path:
      '/var/mobile/Containers/Data/Application/OLD-UUID/Documents/takes/'
      '$file',
  scriptId: scriptId,
  recordedAt: DateTime(2026, 3),
  seconds: 12,
);

File _video(Directory dir, String name) =>
    File('${dir.path}/$name')..writeAsBytesSync([0, 0, 0, 24]);

/// The phone's fingerprint / face / PIN check.
class _FakeAuth implements LocalAuthentication {
  _FakeAuth({this.screenLock = true, this.error, this.unlocks = false});

  final bool screenLock;
  final LocalAuthException? error;
  final bool unlocks;
  var prompts = 0;

  @override
  dynamic noSuchMethod(Invocation invocation) {
    switch (invocation.memberName) {
      case #isDeviceSupported:
        return Future.value(screenLock);
      case #authenticate:
        prompts++;
        final e = error;
        return e == null ? Future.value(unlocks) : Future<bool>.error(e);
    }
    return super.noSuchMethod(invocation);
  }
}

void _auth(_FakeAuth fake) {
  final before = AppLockGate.auth;
  AppLockGate.auth = fake;
  addTearDown(() => AppLockGate.auth = before);
}

Future<AppState> _pumpApp(WidgetTester tester) async {
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
  return state;
}

Future<void> _pumpScreen(
  WidgetTester tester,
  AppState state,
  Widget screen,
) async {
  await tester.pumpWidget(
    AppScope(
      state: state,
      child: MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        home: screen,
      ),
    ),
  );
  await tester.pumpAndSettle();
}

/// Lets real file operations (not faked in widget tests) finish.
Future<void> _settleFiles(WidgetTester tester) async {
  await tester.runAsync(
    () => Future<void>.delayed(const Duration(milliseconds: 50)),
  );
  await tester.pumpAndSettle();
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  group('data-4 takes are found by file name', () {
    test('a take stored with a path from before an iOS update still opens, '
        'and new takes store only the file name', () async {
      final dir = _takesDir();
      final state = AppState(
        await Storage.open(),
        takesDirectory: () async => dir,
      );
      final video = _video(dir, 'a-1.mp4');

      final old = _oldTake('a', 'a-1.mp4');
      expect(old.fileName, 'a-1.mp4');
      final file = await state.takeFile(old);
      expect(file.path, video.path);
      expect(file.existsSync(), isTrue);

      final current = Take(
        path: 'a-1.mp4',
        scriptId: 'a',
        recordedAt: DateTime(2026, 4),
        seconds: 1,
      );
      expect((await state.takeFile(current)).path, video.path);
    });

    test('deleting a take removes its entry and its video, also for a take '
        'stored with an old full path', () async {
      final dir = _takesDir();
      final state = AppState(
        await Storage.open(),
        takesDirectory: () async => dir,
      );
      final video = _video(dir, 'a-1.mp4');
      final keep = _video(dir, 'a-2.mp4');
      await state.addTake(_oldTake('a', 'a-1.mp4'));
      await state.addTake(_oldTake('a', 'a-2.mp4'));

      await state.deleteTake(
        state.takesOf('a').firstWhere((t) {
          return t.fileName == 'a-1.mp4';
        }),
      );
      expect(video.existsSync(), isFalse);
      expect(keep.existsSync(), isTrue);
      expect(state.takesOf('a').map((t) => t.fileName), ['a-2.mp4']);
    });

    test('Delete forever removes the takes of a script stored before an '
        'iOS update', () async {
      final dir = _takesDir();
      final state = AppState(
        await Storage.open(),
        takesDirectory: () async => dir,
      );
      await state.upsert(_script('a', 'hello'));
      await state.upsert(_script('a', 'hello there, a longer body'));
      final video = _video(dir, 'a-1.mp4');
      final other = _video(dir, 'b-1.mp4');
      await state.addTake(_oldTake('a', 'a-1.mp4'));
      await state.addTake(_oldTake('b', 'b-1.mp4'));
      await state.delete('a');

      await state.deleteForever('a');
      expect(video.existsSync(), isFalse);
      expect(state.takesOf('a'), isEmpty);
      expect(state.versionsOf('a'), isEmpty);
      // Another script's take stays.
      expect(other.existsSync(), isTrue);
      expect(state.takesOf('b'), hasLength(1));
    });
  });

  group('data-6 expired trash leaves nothing behind', () {
    test('versions, take entries and videos of scripts deleted more than '
        '30 days ago go when the app starts', () async {
      final dir = _takesDir();
      final oldVideo = _video(dir, 'old-1.mp4');
      final newVideo = _video(dir, 'new-1.mp4');
      final versions = jsonEncode([
        ScriptVersion(
          title: 't',
          body: 'before',
          savedAt: DateTime(2026),
        ).toJson(),
      ]);
      SharedPreferences.setMockInitialValues({
        'trash': jsonEncode([
          TrashedScript(
            _script('old', 'x'),
            DateTime.now().subtract(const Duration(days: 31)),
          ).toJson(),
          TrashedScript(_script('new', 'y'), DateTime.now()).toJson(),
        ]),
        'versions_old': versions,
        'versions_new': versions,
        'takes': jsonEncode([
          _oldTake('old', 'old-1.mp4').toJson(),
          _oldTake('new', 'new-1.mp4').toJson(),
        ]),
      });
      final state = AppState(
        await Storage.open(),
        takesDirectory: () async => dir,
      );
      await state.expiredTrashCleared;

      expect(state.trash.map((t) => t.script.id), ['new']);
      expect(state.versionsOf('old'), isEmpty);
      expect(state.takesOf('old'), isEmpty);
      expect(oldVideo.existsSync(), isFalse);
      // Still in "Recently deleted": everything kept.
      expect(state.versionsOf('new'), hasLength(1));
      expect(state.takesOf('new'), hasLength(1));
      expect(newVideo.existsSync(), isTrue);
      // Gone from storage too, so it isn't looked at again.
      expect((await Storage.open()).loadExpiredTrashIds(), isEmpty);
    });

    test('an expired entry of a script that is back in the library keeps '
        'its versions', () async {
      SharedPreferences.setMockInitialValues({
        'trash': jsonEncode([
          TrashedScript(
            _script('a', 'x'),
            DateTime.now().subtract(const Duration(days: 40)),
          ).toJson(),
        ]),
        'versions_a': jsonEncode([
          ScriptVersion(
            title: 't',
            body: 'v',
            savedAt: DateTime(2026),
          ).toJson(),
        ]),
      });
      final storage = await Storage.open();
      await storage.saveScript(_script('a', 'restored'));
      final state = AppState(storage);
      await state.expiredTrashCleared;
      expect(state.versionsOf('a'), hasLength(1));
    });
  });

  group('data-2 a backup is merged with Recently deleted too', () {
    test(
      'an older backup copy does not replace a newer deleted script',
      () async {
        final state = AppState(await Storage.open());
        await state.upsert(_script('a', 'newest words'));
        await state.delete('a');
        final deletedAt = state.trash.single.script.updatedAt;

        final older = _script('a', 'old words', at: DateTime(2020));
        expect(await state.importScripts([older]), 0);
        expect(state.byId('a'), isNull);
        expect(state.trash.single.script.body, 'newest words');
        expect(state.trash.single.script.updatedAt, deletedAt);

        // The very same copy changes nothing either.
        expect(await state.importScripts([state.trash.single.script]), 0);
        expect(state.trash, hasLength(1));
        expect(state.byId('a'), isNull);
      },
    );

    test('a newer backup copy comes back; the deleted text is kept as a '
        'version and only that entry leaves Recently deleted', () async {
      final state = AppState(await Storage.open());
      await state.upsert(_script('a', 'deleted words'));
      await state.upsert(_script('b', 'other script'));
      await state.delete('a');
      await state.delete('b');

      final newer = _script(
        'a',
        'words from the backup',
        at: DateTime.now().add(const Duration(minutes: 1)),
      );
      expect(await state.importScripts([newer]), 1);
      expect(state.byId('a')?.body, 'words from the backup');
      expect(state.trash.map((t) => t.script.id), ['b']);
      expect(state.versionsOf('a').first.body, 'deleted words');

      // Survives a restart.
      final reopened = AppState(await Storage.open());
      expect(reopened.byId('a')?.body, 'words from the backup');
      expect(reopened.trash.map((t) => t.script.id), ['b']);
    });
  });

  group('data-6 deleting for good asks first', () {
    testWidgets('Delete take asks; Cancel keeps the video', (tester) async {
      final dir = _takesDir();
      final state = AppState(
        await Storage.open(),
        takesDirectory: () async => dir,
      );
      final script = _script('a', 'hello');
      await state.upsert(script);
      final video = _video(dir, 'a-1.mp4');
      await state.addTake(_oldTake('a', 'a-1.mp4'));

      await _pumpScreen(tester, state, TakesScreen(script: script));
      await tester.tap(find.byType(ListTile));
      await tester.pumpAndSettle();

      await tester.tap(find.byTooltip(_en.deleteTake));
      await tester.pumpAndSettle();
      expect(find.text(_en.deleteTakeConfirm), findsOneWidget);
      await tester.tap(find.text('Cancel'));
      await _settleFiles(tester);
      expect(video.existsSync(), isTrue);
      expect(state.takesOf('a'), hasLength(1));

      await tester.tap(find.byTooltip(_en.deleteTake));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, _en.deleteTake));
      await _settleFiles(tester);
      expect(video.existsSync(), isFalse);
      expect(state.takesOf('a'), isEmpty);
      expect(find.text(_en.takesEmpty), findsOneWidget);
    });

    testWidgets('Delete forever asks, and says the takes go too', (
      tester,
    ) async {
      final dir = _takesDir();
      final state = AppState(
        await Storage.open(),
        takesDirectory: () async => dir,
      );
      await state.upsert(_script('a', 'hello', title: 'My video'));
      await state.upsert(_script('b', 'hello', title: 'No takes'));
      await state.addTake(_oldTake('a', 'a-1.mp4'));
      final video = _video(dir, 'a-1.mp4');
      await state.delete('a');
      await state.delete('b');

      await _pumpScreen(tester, state, const TrashScreen());
      Finder deleteButton(String title) => find.descendant(
        of: find.widgetWithText(ListTile, title),
        matching: find.byTooltip(_en.deleteForever),
      );

      await tester.tap(deleteButton('My video'));
      await tester.pumpAndSettle();
      expect(
        find.text(
          '${_en.deleteForeverConfirm('My video')}\n\n'
          '${_en.deleteForeverTakes}',
        ),
        findsOneWidget,
      );
      await tester.tap(find.text('Cancel'));
      await _settleFiles(tester);
      expect(state.trash, hasLength(2));
      expect(video.existsSync(), isTrue);

      await tester.tap(deleteButton('My video'));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, _en.deleteForever));
      await _settleFiles(tester);
      expect(state.trash.map((t) => t.script.title), ['No takes']);
      expect(video.existsSync(), isFalse);

      // Without takes the dialog doesn't mention them.
      await tester.tap(deleteButton('No takes'));
      await tester.pumpAndSettle();
      expect(find.text(_en.deleteForeverConfirm('No takes')), findsOneWidget);
      await tester.tap(find.widgetWithText(FilledButton, _en.deleteForever));
      await _settleFiles(tester);
      expect(state.trash, isEmpty);
    });

    testWidgets('throwing away unreadable data asks first', (tester) async {
      SharedPreferences.setMockInitialValues({
        'scripts_backup_1700000000000000': '{"broken',
      });
      final state = AppState(await Storage.open());
      await _pumpScreen(tester, state, const TrashScreen());

      await tester.tap(find.byTooltip(_en.deleteForever));
      await tester.pumpAndSettle();
      expect(
        find.text(_en.deleteForeverConfirm(_en.damagedData)),
        findsOneWidget,
      );
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      expect(state.damagedData, hasLength(1));

      await tester.tap(find.byTooltip(_en.deleteForever));
      await tester.pumpAndSettle();
      await tester.tap(find.widgetWithText(FilledButton, _en.deleteForever));
      await tester.pumpAndSettle();
      expect(state.damagedData, isEmpty);
    });
  });

  group('data-3 app lock never locks a creator out', () {
    testWidgets('a phone without a screen lock: app lock turns off and the '
        'app opens, saying why', (tester) async {
      SharedPreferences.setMockInitialValues({'app_lock': true});
      final auth = _FakeAuth(screenLock: false);
      _auth(auth);
      final state = await _pumpApp(tester);

      expect(state.appLock, isFalse);
      expect(find.byIcon(Icons.lock_outline), findsNothing);
      expect(find.text(_en.newScript).hitTestable(), findsWidgets);
      expect(find.text(_en.appLockTurnedOff), findsOneWidget);
      expect(auth.prompts, 0);
      expect(
        (await SharedPreferences.getInstance()).getBool('app_lock'),
        false,
      );
    });

    testWidgets('the unlock prompt saying "no screen lock set" does the same', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'app_lock': true});
      _auth(
        _FakeAuth(
          error: const LocalAuthException(
            code: LocalAuthExceptionCode.noCredentialsSet,
          ),
        ),
      );
      final state = await _pumpApp(tester);

      expect(state.appLock, isFalse);
      expect(find.text(_en.newScript).hitTestable(), findsWidgets);
      expect(find.text(_en.appLockTurnedOff), findsOneWidget);
    });

    testWidgets('a cancelled prompt keeps the app locked', (tester) async {
      SharedPreferences.setMockInitialValues({'app_lock': true});
      final auth = _FakeAuth(
        error: const LocalAuthException(
          code: LocalAuthExceptionCode.userCanceled,
        ),
      );
      _auth(auth);
      final state = await _pumpApp(tester);

      expect(auth.prompts, 1);
      expect(state.appLock, isTrue);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
      expect(find.text(_en.newScript).hitTestable(), findsNothing);
      expect(find.text(_en.appLockTurnedOff), findsNothing);
    });

    testWidgets('a failing screen-lock check is no reason to open the app', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'app_lock': true});
      // No local_auth at all: every call fails.
      final state = await _pumpApp(tester);
      expect(state.appLock, isTrue);
      expect(find.byIcon(Icons.lock_outline), findsOneWidget);
    });

    testWidgets('with a screen lock, unlocking works as before', (
      tester,
    ) async {
      SharedPreferences.setMockInitialValues({'app_lock': true});
      _auth(_FakeAuth(unlocks: true));
      final state = await _pumpApp(tester);
      expect(state.appLock, isTrue);
      expect(find.text(_en.newScript).hitTestable(), findsWidgets);
      expect(find.text(_en.appLockTurnedOff), findsNothing);
    });
  });
}
