import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/models/script.dart';
import 'package:aprompter/screens/home_screen.dart';
import 'package:aprompter/screens/paywall_screen.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/purchase_service.dart';
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
  final purchaseService = PurchaseService(entitlements: entitlements);
  // Scopes must wrap MaterialApp itself, not just `home:` — a modal bottom
  // sheet is pushed onto the Navigator's shared Overlay, a sibling of the
  // `home` route's subtree, not a descendant of it.
  await tester.pumpWidget(
    PurchaseServiceScope(
      service: purchaseService,
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

Map<String, Object?> _package(String id, String type, double price) => {
  'identifier': id,
  'packageType': type,
  'product': {
    'identifier': 'aprompter_unlimited_$id',
    'description': 'Unlimited scripts',
    'title': 'APrompter Unlimited',
    'price': price,
    'priceString': '\$${price.toStringAsFixed(2)}',
    'currencyCode': 'USD',
  },
  'presentedOfferingContext': {'offeringIdentifier': 'default'},
};

/// Stands in for RevenueCat's native side. With [plans] false, loading
/// plans fails the way an offline or misconfigured store does.
void _mockStore(WidgetTester tester, {required bool plans}) {
  final monthly = _package('monthly', 'MONTHLY', 2.99);
  final annual = _package('annual', 'ANNUAL', 15.99);
  final lifetime = _package('lifetime', 'LIFETIME', 39.99);
  final offering = {
    'identifier': 'default',
    'serverDescription': 'Default',
    'metadata': <String, Object>{},
    'availablePackages': [monthly, annual, lifetime],
    'monthly': monthly,
    'annual': annual,
    'lifetime': lifetime,
  };
  final messenger = tester.binding.defaultBinaryMessenger;
  const channel = MethodChannel('purchases_flutter');
  messenger.setMockMethodCallHandler(channel, (call) async {
    if (call.method != 'getOfferings') return null;
    if (!plans) throw PlatformException(code: '10', message: 'offline');
    return {
      'all': {'default': offering},
      'current': offering,
    };
  });
  addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
}

void main() {
  // Flutter's test binding defaults TargetPlatform to android, so the
  // paywall names Google Play as the store. RevenueCat has no platform
  // implementation in tests, so loading plans fails like a misconfigured
  // or offline store would.

  testWidgets(
    'a fresh free account can still create its first real script — the '
    'auto-seeded welcome script does not spend the one free slot',
    (tester) async {
      await _pump(tester, isUnlimited: false);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.text('APrompter Unlimited'), findsNothing);
    },
  );

  testWidgets('free account already at the real-script limit shows the upgrade '
      'sheet instead of the template picker', (tester) async {
    _mockStore(tester, plans: true);
    await _pump(tester, isUnlimited: false, extraScripts: 1);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('APrompter Unlimited'), findsOneWidget);
    expect(find.byType(BottomSheet), findsOneWidget);
  });

  testWidgets(
    'the paywall goes straight to plans (no sign-in) and carries what the '
    'stores require: renewal terms, restore, Terms and Privacy links',
    (tester) async {
      _mockStore(tester, plans: true);
      await _pump(tester, isUnlimited: false, extraScripts: 1);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.textContaining('Sign in'), findsNothing);
      expect(find.text(r'Yearly · $15.99 / year'), findsOneWidget);
      expect(find.text('Save 55%'), findsOneWidget);
      expect(find.text(r'Monthly · $2.99 / month'), findsOneWidget);
      expect(find.text(r'Lifetime · $39.99 once'), findsOneWidget);
      expect(
        find.textContaining('renew automatically', findRichText: true),
        findsOneWidget,
      );
      expect(find.textContaining('Google Play'), findsOneWidget);
      expect(find.text('Restore purchases'), findsOneWidget);
      expect(find.text('Terms of Use'), findsOneWidget);
      expect(find.text('Privacy Policy'), findsOneWidget);
    },
  );

  testWidgets(
    'plans that fail to load show an error and a retry, not an endless '
    'spinner',
    (tester) async {
      _mockStore(tester, plans: false);
      await _pump(tester, isUnlimited: false, extraScripts: 1);
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      expect(find.byType(CircularProgressIndicator), findsNothing);
      expect(
        find.text("Couldn't load plans. Check your connection and try again."),
        findsOneWidget,
      );
      expect(find.text('Try again'), findsOneWidget);
    },
  );

  test('yearly saving is shown as a whole percent, only when meaningful', () {
    expect(yearlySavingPercent(monthly: 2.99, yearly: 15.99), 55);
    expect(yearlySavingPercent(monthly: 2.99, yearly: 35.88), isNull);
    expect(yearlySavingPercent(monthly: 0, yearly: 15.99), isNull);
  });

  testWidgets('unlimited account opens the template picker normally', (
    tester,
  ) async {
    await _pump(tester, isUnlimited: true);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();
    expect(find.text('APrompter Unlimited'), findsNothing);
  });

  Finder libraryMenu() => find.descendant(
    of: find.byType(AppBar),
    matching: find.byIcon(Icons.more_vert),
  );

  testWidgets('the library menu opens the plans before any limit is hit', (
    tester,
  ) async {
    _mockStore(tester, plans: true);
    await _pump(tester, isUnlimited: false);
    await tester.tap(libraryMenu());
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.workspace_premium_outlined), findsOneWidget);
    await tester.tap(find.text('Upgrade'));
    await tester.pumpAndSettle();
    expect(find.text('APrompter Unlimited'), findsOneWidget);
    expect(find.text(r'Yearly · $15.99 / year'), findsOneWidget);
  });

  testWidgets('an unlimited account has no Upgrade in the library menu', (
    tester,
  ) async {
    await _pump(tester, isUnlimited: true);
    await tester.tap(libraryMenu());
    await tester.pumpAndSettle();
    expect(find.text('Recently deleted'), findsOneWidget);
    expect(find.text('Upgrade'), findsNothing);
  });

  testWidgets(
    'Duplicate on a free account at the limit shows the upgrade sheet '
    'instead of actually duplicating',
    (tester) async {
      _mockStore(tester, plans: true);
      final state = await _pump(tester, isUnlimited: false, extraScripts: 1);
      await tester.tap(find.byIcon(Icons.more_vert).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('Duplicate'));
      await tester.pumpAndSettle();
      expect(find.text('APrompter Unlimited'), findsOneWidget);
      expect(state.scripts, hasLength(2)); // seed + the one extra, no copy made
    },
  );
}
