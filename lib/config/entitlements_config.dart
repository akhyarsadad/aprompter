/// Store and paywall identifiers. None of these are secrets (a RevenueCat
/// public SDK key is meant to ship inside the app), so this file is tracked
/// in git. Fill in the placeholders before a release — see README.md →
/// "Paywall setup" and docs/STORE_RELEASE.md.
class EntitlementsConfig {
  /// RevenueCat public SDK key for iOS (RevenueCat dashboard → Project →
  /// API keys → Apple App Store).
  static const revenueCatApiKeyIos = 'REPLACE_WITH_IOS_REVENUECAT_API_KEY';

  /// RevenueCat public SDK key for Android (…→ API keys → Google Play).
  static const revenueCatApiKeyAndroid =
      'REPLACE_WITH_ANDROID_REVENUECAT_API_KEY';

  /// The RevenueCat entitlement identifier that means "unlimited" (set up
  /// under Project → Entitlements in the RevenueCat dashboard).
  static const entitlementId = 'unlimited';

  /// Shown on the paywall; both stores require working links to these
  /// before an app with subscriptions is approved.
  static const termsUrl =
      'https://github.com/akhyarsadad/aprompter/blob/main/docs/TERMS.md';
  static const privacyUrl =
      'https://github.com/akhyarsadad/aprompter/blob/main/docs/PRIVACY.md';
}
