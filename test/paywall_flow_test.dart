// The paywall against real store timing: RevenueCat answering late at
// launch, Unlimited arriving while the plans are open, pending payments,
// a plan the store account already owns, and shares that arrive in batches.
import 'package:aprompter/l10n/l10n.dart';
import 'package:aprompter/models/script.dart';
import 'package:aprompter/screens/editor_screen.dart';
import 'package:aprompter/screens/home_screen.dart';
import 'package:aprompter/screens/paywall_screen.dart';
import 'package:aprompter/services/app_state.dart';
import 'package:aprompter/services/entitlements.dart';
import 'package:aprompter/services/purchase_service.dart';
import 'package:aprompter/services/storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

final _en = lookupAppLocalizations(const Locale('en'));

Map<String, Object?> _package(String id, String type, double price) => {
  'identifier': id,
  'packageType': type,
  'product': {
    'identifier': 'aprompter_unlimited_$id',
    'description': 'Unlimited scripts',
    'title': 'Unlimited',
    'price': price,
    'priceString': '\$${price.toStringAsFixed(2)}',
    'currencyCode': 'USD',
  },
  'presentedOfferingContext': {'offeringIdentifier': 'default'},
};

/// RevenueCat's customer info, with or without the "unlimited" entitlement.
Map<String, Object?> _customerInfo({required bool unlimited}) {
  final entitlement = {
    'identifier': 'unlimited',
    'isActive': true,
    'willRenew': true,
    'latestPurchaseDate': '2026-10-01T00:00:00Z',
    'originalPurchaseDate': '2026-10-01T00:00:00Z',
    'productIdentifier': 'aprompter_unlimited_annual',
    'isSandbox': true,
  };
  final active = unlimited ? {'unlimited': entitlement} : <String, Object?>{};
  return {
    'entitlements': {'all': active, 'active': active},
    'allPurchaseDates': <String, Object?>{},
    'activeSubscriptions': <Object?>[],
    'allPurchasedProductIdentifiers': <Object?>[],
    'nonSubscriptionTransactions': <Object?>[],
    'firstSeen': '2026-01-01T00:00:00Z',
    'originalAppUserId': 'anonymous',
    'allExpirationDates': <String, Object?>{},
    'requestDate': '2026-10-25T00:00:00Z',
  };
}

Map<String, Object?> _purchased() => {
  'customerInfo': _customerInfo(unlimited: true),
  'transaction': {
    'transactionIdentifier': 't1',
    'productIdentifier': 'aprompter_unlimited_annual',
    'purchaseDate': '2026-10-25T00:00:00Z',
  },
};

PlatformException _storeError(PurchasesErrorCode code) =>
    PlatformException(code: '${code.index}', message: code.name);

/// Stands in for RevenueCat's native side: plans load; [purchase] and
/// [restore] decide what buying and restoring do.
void _store(
  WidgetTester tester, {
  Future<Object?> Function()? purchase,
  Future<Object?> Function()? restore,
}) {
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
    switch (call.method) {
      case 'getOfferings':
        return {
          'all': {'default': offering},
          'current': offering,
        };
      case 'purchasePackage':
        if (purchase == null) {
          throw _storeError(PurchasesErrorCode.unknownError);
        }
        return purchase();
      case 'restorePurchases':
        return restore == null ? _customerInfo(unlimited: false) : restore();
    }
    return null;
  });
  addTearDown(() => messenger.setMockMethodCallHandler(channel, null));
}

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

/// The library on a phone, a free account with one script of its own next
/// to the welcome script — at the free limit.
Future<(AppState, Entitlements)> _pump(
  WidgetTester tester, {
  bool known = true,
}) async {
  tester.view.physicalSize = const Size(1080, 2340);
  tester.view.devicePixelRatio = 3;
  addTearDown(tester.view.reset);
  SharedPreferences.setMockInitialValues({});
  final state = AppState(await Storage.open());
  await state.upsert(
    Script(id: 'mine', title: 'Mine', body: 'hello', updatedAt: DateTime(2026)),
  );
  final entitlements = Entitlements(known: known);
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
  return (state, entitlements);
}

Future<void> _openPlans(WidgetTester tester) async {
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  expect(find.text(_en.upgradeTitle), findsOneWidget);
}

void main() {
  group('Entitlements', () {
    test('built directly, it is known at once', () {
      expect(Entitlements().isKnown, isTrue);
      expect(Entitlements(isUnlimited: true).isKnown, isTrue);
    });

    test('at launch it waits for the store, which completes it once', () async {
      final entitlements = Entitlements(isUnlimited: true, known: false);
      expect(entitlements.isKnown, isFalse);
      var done = false;
      entitlements.whenKnown.then((_) => done = true);
      entitlements.markKnown();
      entitlements.markKnown(); // a second answer is harmless
      await Future<void>.delayed(Duration.zero);
      expect(done, isTrue);
      expect(entitlements.isKnown, isTrue);
      expect(entitlements.isUnlimited, isTrue);
    });
  });

  test('the store\'s last answer is kept for the next launch', () async {
    TestWidgetsFlutterBinding.ensureInitialized();
    SharedPreferences.setMockInitialValues({});
    final storage = await Storage.open();
    expect(storage.lastKnownUnlimited, isFalse);
    final entitlements = Entitlements();
    final service = PurchaseService(
      entitlements: entitlements,
      storage: storage,
    );

    service.applyCustomerInfo(
      CustomerInfo.fromJson(_customerInfo(unlimited: true)),
    );
    await Future<void>.delayed(Duration.zero);
    expect(entitlements.isUnlimited, isTrue);
    expect((await Storage.open()).lastKnownUnlimited, isTrue);

    // Expired or refunded: the next launch starts free again.
    service.applyCustomerInfo(
      CustomerInfo.fromJson(_customerInfo(unlimited: false)),
    );
    await Future<void>.delayed(Duration.zero);
    expect(entitlements.isUnlimited, isFalse);
    expect((await Storage.open()).lastKnownUnlimited, isFalse);
  });

  testWidgets('a subscriber who shares a note right at launch gets it in, '
      'not the paywall, once the store answers', (tester) async {
    _store(tester);
    final shares = _FakeShares(tester);
    shares.pending.add({'subject': 'Launch idea', 'text': 'Big news today.'});
    final (state, entitlements) = await _pump(tester, known: false);

    // The store hasn't answered yet: nothing is offered for sale.
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(BottomSheet), findsNothing);

    entitlements.setUnlimited(true);
    entitlements.markKnown();
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsNothing);
    expect(find.byType(EditorScreen), findsOneWidget);
    expect(state.scripts.map((s) => s.title), contains('Launch idea'));
  });

  testWidgets('when the store never answers, the plans show after a short '
      'wait', (tester) async {
    _store(tester);
    await _pump(tester, known: false);
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump(storeAnswerTimeout - const Duration(milliseconds: 500));
    expect(find.byType(BottomSheet), findsNothing);
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text(_en.upgradeTitle), findsOneWidget);
  });

  testWidgets('the open paywall closes by itself when Unlimited arrives, '
      'and only the paywall', (tester) async {
    _store(tester);
    final (_, entitlements) = await _pump(tester);
    await _openPlans(tester);

    entitlements.setUnlimited(true);
    await tester.pumpAndSettle();

    expect(find.byType(BottomSheet), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
    expect(find.text(_en.newScript), findsOneWidget);
  });

  // RevenueCat's listener can report a purchase before the purchase call
  // itself returns: just before the sheet starts closing, or while it is.
  for (final returnsAfter in const [
    Duration(milliseconds: 50),
    Duration(seconds: 1),
  ]) {
    testWidgets('a purchase that returns ${returnsAfter.inMilliseconds} ms '
        'after the store already unlocked the app closes the paywall once, '
        'not the library under it', (tester) async {
      late Entitlements entitlements;
      _store(
        tester,
        purchase: () async {
          entitlements.setUnlimited(true);
          await Future<void>.delayed(returnsAfter);
          return _purchased();
        },
      );
      (_, entitlements) = await _pump(tester);
      await _openPlans(tester);

      await tester.tap(find.text(r'Yearly · $15.99 / year'));
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 2));
      await tester.pumpAndSettle();

      expect(find.byType(BottomSheet), findsNothing);
      expect(find.byType(HomeScreen), findsOneWidget);
      expect(find.text(_en.newScript), findsOneWidget);
    });
  }

  testWidgets('a pending payment says it unlocks once approved, not that it '
      'failed, and the sheet closes when it is', (tester) async {
    _store(
      tester,
      purchase: () async =>
          throw _storeError(PurchasesErrorCode.paymentPendingError),
    );
    final (_, entitlements) = await _pump(tester);
    await _openPlans(tester);

    await tester.tap(find.text(r'Yearly · $15.99 / year'));
    await tester.pumpAndSettle();
    expect(find.text(_en.purchasePending), findsOneWidget);
    expect(find.text(_en.purchaseFailed), findsNothing);
    expect(find.byType(BottomSheet), findsOneWidget);

    // Approved later: RevenueCat's listener reports it.
    entitlements.setUnlimited(true);
    await tester.pumpAndSettle();
    expect(find.byType(BottomSheet), findsNothing);
  });

  testWidgets('buying a plan the store account already owns restores it '
      'instead of failing', (tester) async {
    var restored = 0;
    _store(
      tester,
      purchase: () async =>
          throw _storeError(PurchasesErrorCode.productAlreadyPurchasedError),
      restore: () async {
        restored++;
        return _customerInfo(unlimited: true);
      },
    );
    final (_, entitlements) = await _pump(tester);
    await _openPlans(tester);

    await tester.tap(find.text(r'Monthly · $2.99 / month'));
    await tester.pumpAndSettle();

    expect(restored, 1);
    expect(entitlements.isUnlimited, isTrue);
    expect(find.text(_en.purchaseFailed), findsNothing);
    expect(find.byType(BottomSheet), findsNothing);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('a purchase that really fails still says so', (tester) async {
    _store(
      tester,
      purchase: () async =>
          throw _storeError(PurchasesErrorCode.storeProblemError),
    );
    await _pump(tester);
    await _openPlans(tester);
    await tester.tap(find.text(r'Yearly · $15.99 / year'));
    await tester.pumpAndSettle();
    expect(find.text(_en.purchaseFailed), findsOneWidget);
    expect(find.text(_en.purchasePending), findsNothing);
  });

  testWidgets('one share that native code hands over in batches asks to '
      'upgrade once, and says once that nothing new was added', (tester) async {
    _store(tester);
    final shares = _FakeShares(tester);
    shares.pending.add({'subject': 'Part one', 'text': 'First note.'});
    final (state, _) = await _pump(tester);
    expect(find.text(_en.upgradeTitle), findsOneWidget);

    // The rest of the same share arrives while the plans are open.
    shares.pending.add({'subject': 'Part two', 'text': 'Second note.'});
    await shares.announce();
    expect(find.byType(BottomSheet), findsOneWidget);
    await tester.binding.handlePopRoute(); // back: not now
    await tester.pumpAndSettle();

    expect(shares.takes, 2);
    expect(find.byType(BottomSheet), findsNothing);
    expect(find.text(_en.upgradeTitle), findsNothing);
    expect(find.text(_en.importFreeLimit(maxFreeScripts)), findsOneWidget);
    expect(state.scripts, hasLength(2)); // welcome + their own, nothing new
  });
}
