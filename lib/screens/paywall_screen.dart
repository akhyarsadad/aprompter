import 'dart:async' show TimeoutException;

import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import '../config/entitlements_config.dart';
import '../l10n/l10n.dart';
import '../services/entitlements.dart';
import '../services/purchase_service.dart';

/// How long [showUpgradeFlow] waits for RevenueCat's first answer after
/// launch before showing the plans anyway.
const storeAnswerTimeout = Duration(seconds: 3);

/// The upgrade flow under way for an [Entitlements], waiting for the store
/// or showing the plans. Keyed by the instance, so each app (and each
/// widget test) has its own.
final _flowsUnderWay = Expando<Future<bool>>();

/// Shows the plan picker. Returns true once the person ends up unlimited
/// (bought, restored, or already was), for the caller to carry on with what
/// it was doing. There is no sign-in: a purchase belongs to the store
/// account and comes back with "Restore purchases".
///
/// A call while the flow is already under way (a second tap during the
/// wait for the store, a share arriving meanwhile) joins it instead of
/// stacking a second sheet: it waits for that flow to end and returns
/// false, as the first caller is the one that carries on.
Future<bool> showUpgradeFlow(BuildContext context) {
  final entitlements = EntitlementsScope.read(context);
  final underWay = _flowsUnderWay[entitlements];
  if (underWay != null) return underWay.then((_) => false);
  final flow = _upgradeFlow(context, entitlements);
  _flowsUnderWay[entitlements] = flow;
  return flow.whenComplete(() => _flowsUnderWay[entitlements] = null);
}

Future<bool> _upgradeFlow(
  BuildContext context,
  Entitlements entitlements,
) async {
  if (!entitlements.isKnown) {
    // Right after launch RevenueCat may not have answered yet: a subscriber
    // who shares a note or taps quickly mustn't be offered what they own.
    try {
      await entitlements.whenKnown.timeout(storeAnswerTimeout);
    } on TimeoutException {
      // Still no answer: show the plans. The sheet closes itself if
      // Unlimited arrives while it is open.
    }
    if (!context.mounted) return entitlements.isUnlimited;
  }
  if (entitlements.isUnlimited) return true;
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => const _PaywallSheet(),
  );
  return entitlements.isUnlimited;
}

/// The store that handles billing and cancellation on this phone.
String get _storeName =>
    defaultTargetPlatform == TargetPlatform.iOS ? 'App Store' : 'Google Play';

/// Whole-percent saving of the yearly plan over twelve months, or null when
/// it can't be computed or isn't worth showing.
int? yearlySavingPercent({required double monthly, required double yearly}) {
  if (monthly <= 0 || yearly <= 0) return null;
  final percent = ((1 - yearly / (monthly * 12)) * 100).floor();
  return percent >= 5 ? percent : null;
}

class _PaywallSheet extends StatefulWidget {
  const _PaywallSheet();

  @override
  State<_PaywallSheet> createState() => _PaywallSheetState();
}

/// RevenueCat's error code for [error], or null when it isn't one.
PurchasesErrorCode? _purchasesErrorCode(Object error) {
  if (error is! PlatformException) return null;
  try {
    return PurchasesErrorHelper.getErrorCode(error);
  } on FormatException {
    return null;
  }
}

class _PaywallSheetState extends State<_PaywallSheet> {
  Offering? _offering;
  bool _loading = true;
  String? _error;
  bool _busy = false;

  /// A purchase is waiting for the store or a bank to approve it.
  bool _pending = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Unlimited can arrive while the plans are open: RevenueCat answering
    // after launch, a pending payment approved, a purchase made elsewhere.
    // Nothing is left to buy then, so the sheet goes away by itself.
    if (EntitlementsScope.of(context).isUnlimited) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) _close();
      });
    }
  }

  /// Closes this sheet, once: a purchase, a restore and RevenueCat's own
  /// update can all report Unlimited at the same moment, and a second pop
  /// would close the screen underneath. (The route's own `isCurrent` turns
  /// false the moment it is popped; `ModalRoute.isCurrentOf` would only
  /// catch up on the next frame.)
  void _close() {
    final route = ModalRoute.of(context);
    if (route != null && route.isCurrent) Navigator.pop(context);
  }

  void _retry() {
    setState(() {
      _loading = true;
      _error = null;
    });
    _load();
  }

  Future<void> _load() async {
    Offering? offering;
    try {
      offering = (await Purchases.getOfferings()).current;
    } catch (_) {
      offering = null;
    }
    if (!mounted) return;
    // No current offering (or one without plans) is a setup problem, not a
    // reason to spin forever: say so and offer a retry.
    final usable = offering != null && offering.availablePackages.isNotEmpty;
    setState(() {
      _loading = false;
      _offering = usable ? offering : null;
      if (!usable) _error = context.l10n.offeringsLoadFailed;
    });
  }

  Future<void> _buy(Package package) async {
    setState(() {
      _busy = true;
      _error = null;
      _pending = false;
    });
    var restore = false;
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      // The customer-info listener in main.dart also applies this, but
      // doing it here too means the gate lifts before this sheet even
      // closes, with no dependence on listener timing.
      if (!mounted) return;
      PurchaseServiceScope.of(context).applyCustomerInfo(result.customerInfo);
      _close();
    } catch (e) {
      if (!mounted) return;
      switch (_purchasesErrorCode(e)) {
        case PurchasesErrorCode.purchaseCancelledError:
          // A normal, frequent outcome: stay on this sheet, no error shown.
          break;
        case PurchasesErrorCode.paymentPendingError:
          // Cash, bank transfer, a parent's approval: not failed, just not
          // done yet. The customer-info listener in main.dart unlocks the
          // app, and closes this sheet, once the store approves it.
          setState(() => _pending = true);
        case PurchasesErrorCode.productAlreadyPurchasedError:
          // The store account already owns it (another phone, before a
          // reinstall): bring it back instead of saying it failed.
          restore = true;
        default:
          setState(() => _error = context.l10n.purchaseFailed);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
    if (restore && mounted) await _restore();
  }

  Future<void> _restore() async {
    setState(() {
      _busy = true;
      _error = null;
      _pending = false;
    });
    try {
      final info = await Purchases.restorePurchases();
      if (!mounted) return;
      PurchaseServiceScope.of(context).applyCustomerInfo(info);
      if (EntitlementsScope.read(context).isUnlimited) {
        _close();
      } else {
        setState(() => _error = context.l10n.nothingToRestore(_storeName));
      }
    } catch (_) {
      if (mounted) setState(() => _error = context.l10n.restoreFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _open(String url) async {
    try {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } catch (_) {
      // No browser available — nothing useful to show in a sheet.
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final theme = Theme.of(context);
    final offering = _offering;
    final monthly = offering?.monthly;
    final annual = offering?.annual;
    final lifetime = offering?.lifetime;
    final saving = monthly == null || annual == null
        ? null
        : yearlySavingPercent(
            monthly: monthly.storeProduct.price,
            yearly: annual.storeProduct.price,
          );
    final plans = [
      if (annual != null)
        _PlanButton(
          label: l.planYearly(annual.storeProduct.priceString),
          badge: saving == null ? null : l.planSave(saving),
          primary: true,
          onTap: _busy ? null : () => _buy(annual),
        ),
      if (monthly != null)
        _PlanButton(
          label: l.planMonthly(monthly.storeProduct.priceString),
          onTap: _busy ? null : () => _buy(monthly),
        ),
      if (lifetime != null)
        _PlanButton(
          label: l.planLifetime(lifetime.storeProduct.priceString),
          onTap: _busy ? null : () => _buy(lifetime),
        ),
    ];
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.upgradeTitle, style: theme.textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(l.upgradeBody),
            const SizedBox(height: 20),
            if (_error != null) ...[
              Text(_error!, style: TextStyle(color: theme.colorScheme.error)),
              const SizedBox(height: 12),
            ],
            if (_pending) ...[
              Text(
                l.purchasePending,
                style: TextStyle(color: theme.colorScheme.primary),
              ),
              const SizedBox(height: 12),
            ],
            if (_loading)
              const Center(child: CircularProgressIndicator())
            else if (offering == null)
              OutlinedButton(
                onPressed: _busy ? null : _retry,
                child: Text(l.tryAgain),
              )
            else
              for (final (i, plan) in plans.indexed) ...[
                if (i > 0) const SizedBox(height: 8),
                plan,
              ],
            const SizedBox(height: 16),
            // Store rules: price, length and auto-renewal stated next to
            // the buy buttons, plus working Terms and Privacy links.
            Text(
              l.subscriptionTerms(_storeName),
              style: theme.textTheme.bodySmall,
            ),
            const SizedBox(height: 8),
            TextButton(
              onPressed: _busy ? null : _restore,
              child: Text(l.restorePurchases),
            ),
            Wrap(
              alignment: WrapAlignment.center,
              children: [
                TextButton(
                  onPressed: () => _open(EntitlementsConfig.termsUrl),
                  child: Text(l.termsOfUse),
                ),
                TextButton(
                  onPressed: () => _open(EntitlementsConfig.privacyUrl),
                  child: Text(l.privacyPolicy),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanButton extends StatelessWidget {
  const _PlanButton({
    required this.label,
    required this.onTap,
    this.badge,
    this.primary = false,
  });

  final String label;
  final VoidCallback? onTap;
  final String? badge;
  final bool primary;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final child = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Wrap(
        alignment: WrapAlignment.center,
        crossAxisAlignment: WrapCrossAlignment.center,
        spacing: 8,
        runSpacing: 4,
        children: [
          Text(label, textAlign: TextAlign.center),
          if (badge != null)
            DecoratedBox(
              decoration: BoxDecoration(
                color: scheme.tertiaryContainer,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Text(
                  badge!,
                  style: TextStyle(
                    color: scheme.onTertiaryContainer,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
    return primary
        ? FilledButton(onPressed: onTap, child: child)
        : FilledButton.tonal(onPressed: onTap, child: child);
  }
}
