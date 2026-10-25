// Store review: what the app says on each platform must be true there, and
// the paywall must not promise a limit the app doesn't enforce.
import 'dart:convert';
import 'dart:io';

import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/screens/home_screen.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/entitlements.dart';
import 'package:aprompter/services/floating_prompter.dart';
import 'package:aprompter/services/purchase_service.dart';
import 'package:aprompter/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// "Android" as each language writes it.
const _androidNames = [
  'Android',
  'أندرويد',
  'اندروید',
  'אנדרואיד',
  'اینڈرائیڈ',
  'Андроид',
  'Андроїд',
  'แอนดรอยด์',
  'アンドロイド',
  '안드로이드',
  '安卓',
];

void main() {
  final arbs = {
    for (final f in Directory('lib/l10n').listSync().whereType<File>())
      if (f.path.endsWith('.arb'))
        f.uri.pathSegments.last:
            jsonDecode(f.readAsStringSync()) as Map<String, dynamic>,
  };

  test('found every language', () => expect(arbs, hasLength(28)));

  for (final MapEntry(key: name, value: arb) in arbs.entries) {
    test('$name names no platform in the layout hints and covers iPad', () {
      for (final key in ['positionHint', 'positionHintFloat']) {
        final text = arb[key] as String;
        for (final android in _androidNames) {
          expect(text, isNot(contains(android)), reason: '$name $key');
        }
      }
      final floatNotOnIos = arb['floatNotOnIos'] as String;
      expect(
        floatNotOnIos.contains('iPad') || floatNotOnIos.contains('آیپد'),
        isTrue,
        reason: '$name floatNotOnIos: $floatNotOnIos',
      );
    });

    test('$name calls the product by its name', () {
      expect(arb['upgradeTitle'], 'APrompter Unlimited');
      expect(arb['wordCapBannerText'], contains('APrompter Unlimited'));
      expect(arb['purchasePending'], contains('APrompter Unlimited'));
    });
  }

  test('the English paywall states renewal honestly and promises no cap', () {
    final en = lookupAppLocalizations(const Locale('en'));
    expect(en.subscriptionTerms('App Store'), contains('24 hours'));
    expect(en.subscriptionTerms('App Store'), contains('App Store'));
    expect(en.wordCapBannerText(maxFreeWords), isNot(contains('capped')));
    expect(en.upgradeBody, isNot(contains('length')));
  });

  testWidgets('where there is no floating window, the layout hint does not '
      'mention one', (tester) async {
    // Widget tests run on the host, which has no floating window.
    expect(FloatingPrompter.isSupported, isFalse);
    SharedPreferences.setMockInitialValues({});
    final state = AppState(await Storage.open());
    final entitlements = Entitlements(isUnlimited: true);
    await tester.pumpWidget(
      PurchaseServiceScope(
        service: PurchaseService(entitlements: entitlements),
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
    final en = lookupAppLocalizations(const Locale('en'));
    await tester.tap(find.byTooltip(en.prompterSettings));
    await tester.pumpAndSettle();
    final sheet = find.descendant(
      of: find.byType(BottomSheet),
      matching: find.byType(ListView),
    );
    for (var i = 0; i < 20; i++) {
      if (find.text(en.positionHint).evaluate().isNotEmpty) break;
      await tester.drag(sheet, const Offset(0, -300));
      await tester.pumpAndSettle();
    }
    expect(find.text(en.positionHint), findsOneWidget);
    expect(find.text(en.positionHintFloat), findsNothing);
  });
}
