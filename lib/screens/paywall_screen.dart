import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show PlatformException;
import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

import '../l10n/l10n.dart';
import '../services/auth_service.dart';
import '../services/entitlements.dart';

/// Shows sign-in first if needed, then the plan picker. Returns true once
/// the person ends up unlimited (bought, restored, or already was).
Future<bool> showUpgradeFlow(BuildContext context) async {
  final entitlements = EntitlementsScope.read(context);
  if (entitlements.isUnlimited) return true;
  final auth = AuthServiceScope.of(context);
  if (auth.signedInUid == null) {
    final signedIn = await showModalBottomSheet<bool>(
      context: context,
      showDragHandle: true,
      builder: (context) => const _SignInSheet(),
    );
    if (signedIn != true || !context.mounted) return entitlements.isUnlimited;
  }
  if (!context.mounted) return entitlements.isUnlimited;
  await showModalBottomSheet<void>(
    context: context,
    showDragHandle: true,
    isScrollControlled: true,
    builder: (context) => const _PaywallSheet(),
  );
  return entitlements.isUnlimited;
}

class _SignInSheet extends StatefulWidget {
  const _SignInSheet();

  @override
  State<_SignInSheet> createState() => _SignInSheetState();
}

class _SignInSheetState extends State<_SignInSheet> {
  bool _busy = false;
  String? _error;

  /// True for "the person backed out on purpose" — never shown as an error,
  /// per the spec: a cancelled sign-in returns silently, no error toast.
  static bool _isCancellation(Object error) =>
      (error is GoogleSignInException &&
          error.code == GoogleSignInExceptionCode.canceled) ||
      (error is SignInWithAppleAuthorizationException &&
          error.code == AuthorizationErrorCode.canceled);

  Future<void> _run(Future<void> Function() signIn) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await signIn();
      if (mounted) Navigator.pop(context, true);
    } catch (e) {
      if (_isCancellation(e)) {
        // Normal, frequent outcome: just stay on this sheet, no message.
      } else if (mounted) {
        setState(() => _error = context.l10n.signInFailed);
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final auth = AuthServiceScope.of(context);
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.signInTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(l.signInBody),
            const SizedBox(height: 20),
            if (_error != null) ...[
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              const SizedBox(height: 12),
            ],
            FilledButton.icon(
              onPressed: _busy ? null : () => _run(auth.signInWithApple),
              icon: const Icon(Icons.apple),
              label: Text(l.continueWithApple),
            ),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: _busy ? null : () => _run(auth.signInWithGoogle),
              icon: const Icon(Icons.g_mobiledata),
              label: Text(l.continueWithGoogle),
            ),
          ],
        ),
      ),
    );
  }
}

class _PaywallSheet extends StatefulWidget {
  const _PaywallSheet();

  @override
  State<_PaywallSheet> createState() => _PaywallSheetState();
}

class _PaywallSheetState extends State<_PaywallSheet> {
  Offering? _offering;
  String? _error;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    try {
      final offerings = await Purchases.getOfferings();
      if (mounted) setState(() => _offering = offerings.current);
    } catch (_) {
      if (mounted) setState(() => _error = context.l10n.offeringsLoadFailed);
    }
  }

  Future<void> _buy(Package package) async {
    setState(() {
      _busy = true;
      _error = null;
    });
    try {
      await Purchases.purchase(PurchaseParams.package(package));
      if (mounted) Navigator.pop(context);
    } catch (e) {
      // A cancelled purchase is a normal, frequent outcome — same rule as a
      // cancelled sign-in: stay on this sheet, no error shown.
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
      await Purchases.restorePurchases();
      if (mounted) Navigator.pop(context);
    } catch (_) {
      if (mounted) setState(() => _error = context.l10n.restoreFailed);
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l = context.l10n;
    final offering = _offering;
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(l.upgradeTitle, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 8),
            Text(l.upgradeBody),
            const SizedBox(height: 20),
            if (_error != null) ...[
              Text(_error!, style: TextStyle(color: Theme.of(context).colorScheme.error)),
              const SizedBox(height: 12),
            ],
            if (offering == null && _error == null)
              const Center(child: CircularProgressIndicator())
            else ...[
              if (offering?.monthly case final p?)
                _PlanButton(package: p, onTap: _busy ? null : () => _buy(p)),
              if (offering?.annual case final p?) ...[
                const SizedBox(height: 8),
                _PlanButton(package: p, onTap: _busy ? null : () => _buy(p)),
              ],
              if (offering?.lifetime case final p?) ...[
                const SizedBox(height: 8),
                _PlanButton(package: p, onTap: _busy ? null : () => _buy(p)),
              ],
            ],
            const SizedBox(height: 12),
            TextButton(
              onPressed: _busy ? null : _restore,
              child: Text(l.restorePurchases),
            ),
          ],
        ),
      ),
    );
  }
}

class _PlanButton extends StatelessWidget {
  const _PlanButton({required this.package, required this.onTap});

  final Package package;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) => FilledButton(
    onPressed: onTap,
    child: Text(
      '${package.storeProduct.title} — ${package.storeProduct.priceString}',
    ),
  );
}
