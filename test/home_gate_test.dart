import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/models/script.dart';
import 'package:aprompter/screens/home_screen.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/auth_service.dart';
import 'package:aprompter/services/entitlements.dart';
import 'package:aprompter/services/storage.dart';

Future<AppState> _pump(
  WidgetTester tester, {
  required bool isUnlimited,
  int extraScripts = 0,
}) async {
  SharedPreferences.setMockInitialValues({});
  final storage = await Storage.open();
  final state = AppState(storage);
  for (var i = 0; i < extraScripts; i++) {
    await state.upsert(
      Script(
        id: 'extra-$i',
        title: 'Extra $i',
        body: 'hello world',
        updatedAt: DateTime(2026),
      ),
    );
  }
  final entitlements = Entitlements(isUnlimited: isUnlimited);
  final authService = AuthService(entitlements: entitlements, storage: storage);
  // Scopes must wrap MaterialApp itself, not just `home:` — a modal bottom
  // sheet is pushed onto the Navigator's shared Overlay, a sibling of the
  // `home` route's subtree, not a descendant of it.
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
            home: const HomeScreen(),
          ),
        ),
      ),
    ),
  );
  await tester.pumpAndSettle();
  return state;
}

void main() {
  // Flutter's test binding defaults TargetPlatform to android, which is
  // exactly the platform this file cares about for the Apple-button test
  // below — so none of these tests override it.

  testWidgets(
      'a fresh free account can still create its first real script — the '
      'auto-seeded welcome script does not spend the one free slot',
      (tester) async {
    await _pump(tester, isUnlimited: false);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Continue with Google'), findsNothing);
  });

  testWidgets(
      'free account already at the real-script limit shows the upgrade '
      'sheet instead of the template picker', (tester) async {
    await _pump(tester, isUnlimited: false, extraScripts: 1);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(find.byType(BottomSheet), findsOneWidget);
  });

  testWidgets(
      'the sign-in sheet never offers Apple on Android — getAppleIDCredential '
      'throws there without web auth options this app does not configure',
      (tester) async {
    await _pump(tester, isUnlimited: false, extraScripts: 1);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Continue with Apple'), findsNothing);
    expect(find.text('Continue with Google'), findsOneWidget);
  });

  testWidgets('unlimited account opens the template picker normally',
      (tester) async {
    await _pump(tester, isUnlimited: true);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Continue with Google'), findsNothing);
  });

  testWidgets(
      'Duplicate on a free account at the limit shows the upgrade sheet '
      'instead of actually duplicating', (tester) async {
    final state = await _pump(tester, isUnlimited: false, extraScripts: 1);
    await tester.tap(find.byIcon(Icons.more_vert).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Duplicate'));
    await tester.pumpAndSettle();
    expect(find.text('Continue with Google'), findsOneWidget);
    expect(state.scripts, hasLength(2)); // seed + the one extra, no copy made
  });
}
