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

/// Shows the plan picker. Returns true once the person ends up unlimited
/// (bought, restored, or already was). There is no sign-in: a purchase
/// belongs to the store account and comes back with "Restore purchases".
Future<bool> showUpgradeFlow(BuildContext context) async {
  final entitlements = EntitlementsScope.read(context);
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

class _PaywallSheetState extends State<_PaywallSheet> {
  Offering? _offering;
  bool _loading = true;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
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
    });
    try {
      final result = await Purchases.purchase(PurchaseParams.package(package));
      // The customer-info listener in main.dart also applies this, but
      // doing it here too means the gate lifts before this sheet even
      // closes, with no dependence on listener timing.
      if (!mounted) return;
      PurchaseServiceScope.of(context).applyCustomerInfo(result.customerInfo);
      Navigator.pop(context);
    } catch (e) {
      // A cancelled purchase is a normal, frequent outcome: stay on this
      // sheet, no error shown.
      final cancelled =
          e is PlatformException &&
          PurchasesErrorHelper.getErrorCode(e) ==
              PurchasesErrorCode.purchaseCancelledError;
      if (!cancelled && mounted) {
        setState(() => _error = context.l10n.purchaseFailed);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _restore() async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      final info = await Purchases.restorePurchases();
      if (!mounted) return;
      PurchaseServiceScope.of(context).applyCustomerInfo(info);
      if (EntitlementsScope.read(context).isUnlimited) {
        Navigator.pop(context);
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
