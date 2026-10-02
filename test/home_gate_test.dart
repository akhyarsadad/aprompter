import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/screens/home_screen.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/auth_service.dart';
import 'package:aprompter/services/entitlements.dart';
import 'package:aprompter/services/storage.dart';

Future<void> _pump(
  WidgetTester tester, {
  required bool isUnlimited,
}) async {
  SharedPreferences.setMockInitialValues({});
  final storage = await Storage.open();
  final state = AppState(storage);
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
}

void main() {
  testWidgets('free account at the script limit shows the upgrade sheet '
      'instead of the template picker', (tester) async {
    await _pump(tester, isUnlimited: false);
    // The fresh app seeds one welcome script, already at the free limit.
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Continue with Apple'), findsOneWidget);
    expect(find.byType(BottomSheet), findsOneWidget);
  });

  testWidgets('unlimited account opens the template picker normally',
      (tester) async {
    await _pump(tester, isUnlimited: true);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('Continue with Apple'), findsNothing);
  });
}
