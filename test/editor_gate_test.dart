import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/models/script.dart';
import 'package:aprompter/screens/editor_screen.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/auth_service.dart';
import 'package:aprompter/services/entitlements.dart';
import 'package:aprompter/services/storage.dart';

Future<AppState> _pump(
  WidgetTester tester, {
  required Script script,
  required bool isUnlimited,
  bool runMigrationBeforeEditing = false,
}) async {
  SharedPreferences.setMockInitialValues({});
  final storage = await Storage.open();
  final state = AppState(storage);
  await state.upsert(script);
  // Simulates this script already existing, already over the cap, at the
  // moment the paywall gate shipped — the grandfathering snapshot runs
  // once, before any further editing.
  if (runMigrationBeforeEditing) await state.runWordCapMigrationIfNeeded();
  final entitlements = Entitlements(isUnlimited: isUnlimited);
  final authService = AuthService(entitlements: entitlements, storage: storage);
  // Scopes must wrap MaterialApp itself, not just `home:` — the upgrade
  // button's showUpgradeFlow pushes a modal bottom sheet onto the
  // Navigator's shared Overlay, a sibling of the `home` route's subtree.
  await tester.pumpWidget(
    AuthServiceScope(
      service: authService,
      child: EntitlementsScope(
        entitlements: entitlements,
        child: AppScope(
          state: state,
          child: MaterialApp(
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            supportedLocales: AppLocalizations.supportedLocales,
            home: EditorScreen(script: script),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return state;
}

Script _script({required int words}) => Script(
  id: 'script-1',
  title: 'Test',
  body: List.filled(words, 'word').join(' '),
  updatedAt: DateTime(2026),
);

void main() {
  testWidgets('free account sees the upgrade banner past the word cap',
      (tester) async {
    await _pump(tester, script: _script(words: 501), isUnlimited: false);
    expect(find.text('Upgrade'), findsOneWidget);
  });

  testWidgets('free account under the cap sees no banner', (tester) async {
    await _pump(tester, script: _script(words: 10), isUnlimited: false);
    expect(find.text('Upgrade'), findsNothing);
  });

  testWidgets('unlimited account never sees the banner', (tester) async {
    await _pump(tester, script: _script(words: 501), isUnlimited: true);
    expect(find.text('Upgrade'), findsNothing);
  });

  testWidgets(
      'a script already over the cap before the gate shipped is '
      'grandfathered: no banner even on a free account', (tester) async {
    await _pump(
      tester,
      script: _script(words: 501),
      isUnlimited: false,
      runMigrationBeforeEditing: true,
    );
    expect(find.text('Upgrade'), findsNothing);
  });
}
