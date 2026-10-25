import 'dart:async' show unawaited;

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import 'config/entitlements_config.dart';
import 'l10n/l10n.dart';
import 'overlay/overlay_app.dart';
import 'screens/home_screen.dart';
import 'services/app_state.dart';
import 'services/purchase_service.dart';
import 'services/entitlements.dart';
import 'services/orientation.dart';
import 'services/storage.dart';
import 'widgets/app_lock.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Content is filmed vertically (Reels, TikTok, Shorts); prompting screens
  // also allow landscape, tablets allow everything.
  await Orientations.app();
  final storage = await Storage.open();
  final state = AppState(storage);
  await state.runWordCapMigrationIfNeeded();

  // Starts from what the store said last time, so a subscriber who shares
  // a note right at launch doesn't meet the paywall; RevenueCat corrects it
  // either way once it answers (see _initPurchases).
  final entitlements = Entitlements(
    isUnlimited: storage.lastKnownUnlimited,
    known: false,
  );
  final purchaseService = PurchaseService(
    entitlements: entitlements,
    storage: storage,
  );

  runApp(
    AprompterApp(
      state: state,
      entitlements: entitlements,
      purchaseService: purchaseService,
    ),
  );

  // Never block the first frame on this: offline, a misconfigured key, or
  // any other RevenueCat/network failure must leave the app fully usable
  // on the free tier, not stuck before `runApp` ever shows anything.
  unawaited(_initPurchases(purchaseService));
}

Future<void> _initPurchases(PurchaseService purchaseService) async {
  try {
    await Purchases.setLogLevel(LogLevel.warn);
    await Purchases.configure(
      PurchasesConfiguration(
        defaultTargetPlatform == TargetPlatform.iOS
            ? EntitlementsConfig.revenueCatApiKeyIos
            : EntitlementsConfig.revenueCatApiKeyAndroid,
      ),
    );
    // Fires after any entitlement-changing event (purchase, restore,
    // renewal, expiry) for as long as the app runs, so a purchase or
    // restore made from paywall_screen.dart unlocks the app with no restart.
    Purchases.addCustomerInfoUpdateListener(purchaseService.applyCustomerInfo);
    // A subscription bought earlier on this store account unlocks at launch.
    purchaseService.applyCustomerInfo(await Purchases.getCustomerInfo());
  } catch (_) {
    // Keeps the last known answer until the next successful launch.
  } finally {
    // Whatever happened, the paywall stops waiting for an answer.
    purchaseService.entitlements.markKnown();
  }
}

/// Entry point for the Android floating prompter window.
@pragma('vm:entry-point')
void overlayMain() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const OverlayApp());
}

class AprompterApp extends StatelessWidget {
  const AprompterApp({
    super.key,
    required this.state,
    required this.entitlements,
    required this.purchaseService,
  });

  final AppState state;
  final Entitlements entitlements;
  final PurchaseService purchaseService;

  @override
  Widget build(BuildContext context) {
    const seed = Color(0xFF7C4DFF);
    return PurchaseServiceScope(
      service: purchaseService,
      child: EntitlementsScope(
        entitlements: entitlements,
        child: AppScope(
          state: state,
          child: ListenableBuilder(
            listenable: state,
            builder: (context, _) => MaterialApp(
              onGenerateTitle: (context) => context.l10n.appTitle,
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              locale: state.locale,
              localeListResolutionCallback: (locales, _) =>
                  resolveAppLocale(locales),
              debugShowCheckedModeBanner: false,
              theme: ThemeData(colorSchemeSeed: seed, useMaterial3: true),
              darkTheme: ThemeData(
                colorSchemeSeed: seed,
                brightness: Brightness.dark,
                useMaterial3: true,
              ),
              home: const HomeScreen(),
              builder: (context, child) => Column(
                children: [
                  if (state.saveFailed) const _SaveFailedBanner(),
                  Expanded(
                    // The banner already sits under the status bar.
                    child: MediaQuery.removePadding(
                      context: context,
                      removeTop: state.saveFailed,
                      child: AppLockGate(child: child!),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown on every screen while writes to the phone fail, so a full phone
/// never loses work silently.
class _SaveFailedBanner extends StatelessWidget {
  const _SaveFailedBanner();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l = context.l10n;
    return Material(
      color: theme.colorScheme.errorContainer,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsetsDirectional.fromSTEB(16, 8, 8, 8),
          child: Row(
            children: [
              Icon(Icons.sd_card_alert, color: theme.colorScheme.error),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  l.storageSaveFailed,
                  style: TextStyle(color: theme.colorScheme.onErrorContainer),
                ),
              ),
              TextButton(
                onPressed: AppScope.read(context).retrySave,
                child: Text(l.tryAgain),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
