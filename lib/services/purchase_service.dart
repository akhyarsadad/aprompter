import 'package:flutter/widgets.dart';
import 'package:purchases_flutter/purchases_flutter.dart';

import '../config/entitlements_config.dart';
import 'entitlements.dart';

/// Turns RevenueCat's customer info into the app's [Entitlements].
///
/// There is no sign-in: RevenueCat keeps an anonymous id per install, and a
/// purchase belongs to the store account (Apple ID / Google account). On a
/// new phone or after a reinstall, "Restore purchases" brings it back.
class PurchaseService {
  PurchaseService({required this.entitlements});

  final Entitlements entitlements;

  /// Updates [entitlements] from the latest known entitlement state. Public
  /// so it can also be registered as RevenueCat's customer-info listener
  /// (fires after a purchase, a restore, or any other entitlement change —
  /// see `main.dart`) and called directly after a purchase/restore in
  /// `paywall_screen.dart`, so the gate lifts immediately either way,
  /// without waiting for the next app launch.
  void applyCustomerInfo(CustomerInfo info) {
    entitlements.setUnlimited(
      info.entitlements.active.containsKey(EntitlementsConfig.entitlementId),
    );
  }
}

/// Makes a single, app-lifetime [PurchaseService] available to the widget
/// tree. Plain [InheritedWidget], not [InheritedNotifier]: the service's
/// identity never changes — entitlement changes flow through
/// [Entitlements] instead.
class PurchaseServiceScope extends InheritedWidget {
  const PurchaseServiceScope({
    super.key,
    required this.service,
    required super.child,
  });

  final PurchaseService service;

  @override
  bool updateShouldNotify(PurchaseServiceScope oldWidget) => false;

  static PurchaseService of(BuildContext context) => context
      .dependOnInheritedWidgetOfExactType<PurchaseServiceScope>()!
      .service;
}
