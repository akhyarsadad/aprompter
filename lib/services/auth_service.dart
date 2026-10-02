import 'package:google_sign_in/google_sign_in.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:flutter/widgets.dart';

import '../config/entitlements_config.dart';
import 'entitlements.dart';
import 'storage.dart';

/// Signs in with Apple or Google purely to give RevenueCat a stable
/// identity, so a purchase is recognized across devices and across the
/// App Store / Play Store boundary. Not used for cloud sync of scripts.
class AuthService {
  AuthService({required this.entitlements, required this.storage});

  final Entitlements entitlements;
  final Storage storage;

  String? _uid;
  String? get signedInUid => _uid;

  bool _googleInitialized = false;

  Future<void> _ensureGoogleInitialized() async {
    if (_googleInitialized) return;
    await GoogleSignIn.instance.initialize(
      serverClientId: EntitlementsConfig.googleServerClientId,
    );
    _googleInitialized = true;
  }

  /// Call once at startup: if a session was persisted, re-establish it with
  /// RevenueCat silently, no user action.
  Future<void> restoreSession() async {
    final uid = storage.loadSignedInUid();
    if (uid == null) return;
    await _logIn(uid);
  }

  Future<void> signInWithGoogle() async {
    await _ensureGoogleInitialized();
    if (!GoogleSignIn.instance.supportsAuthenticate()) return;
    final account = await GoogleSignIn.instance.authenticate();
    await _logIn(account.id);
  }

  Future<void> signInWithApple() async {
    final credential = await SignInWithApple.getAppleIDCredential(
      scopes: const [AppleIDAuthorizationScopes.email],
    );
    final uid = credential.userIdentifier;
    if (uid == null) return;
    await _logIn(uid);
  }

  Future<void> _logIn(String uid) async {
    _uid = uid;
    await storage.saveSignedInUid(uid);
    final result = await Purchases.logIn(uid);
    applyCustomerInfo(result.customerInfo);
  }

  Future<void> signOut() async {
    _uid = null;
    await storage.saveSignedInUid(null);
    try {
      await GoogleSignIn.instance.signOut();
    } catch (_) {
      // Not signed in with Google, or already signed out — fine either way.
    }
    final info = await Purchases.logOut();
    applyCustomerInfo(info);
  }

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

/// Makes a single, app-lifetime [AuthService] available to the widget tree.
/// Plain [InheritedWidget], not [InheritedNotifier]: the service's identity
/// never changes — entitlement changes flow through [Entitlements] instead.
class AuthServiceScope extends InheritedWidget {
  const AuthServiceScope({
    super.key,
    required this.service,
    required super.child,
  });

  final AuthService service;

  @override
  bool updateShouldNotify(AuthServiceScope oldWidget) => false;

  static AuthService of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<AuthServiceScope>()!.service;
}
