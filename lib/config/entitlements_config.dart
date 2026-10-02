/// Copy this file to `entitlements_config.dart` in the same folder
/// (git-ignored) and fill in your own identifiers. See README.md →
/// "Paywall setup" for where each value comes from.
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

  /// Google OAuth web client id (Google Cloud Console → Credentials →
  /// OAuth 2.0 Client IDs → Web client), required by google_sign_in.
  static const googleServerClientId =
      'REPLACE_WITH_GOOGLE_WEB_CLIENT_ID.apps.googleusercontent.com';
}
