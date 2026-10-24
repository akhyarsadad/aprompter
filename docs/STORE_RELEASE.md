# APrompter — Store release checklist

Everything in the code is ready for review. What's left needs your accounts, so only you can
do it. Work top to bottom; each step says where.

## 0. Accounts

- [ ] **Apple Developer Program** (paid) and, in App Store Connect → *Business*, the
      **Paid Apps Agreement** active with bank and tax info. In-app purchases don't work in
      review until it is.
- [ ] **Google Play Console** developer account, with a **payments profile** (Settings →
      Payments profile) so you can sell in-app products.
- [ ] **RevenueCat** account (free tier is enough to start).

## 1. Signing

- [ ] **Android:** create the upload keystore once and write `android/key.properties`
      (format in `android/app/build.gradle.kts`). Never commit either; back the keystore up.
      Without it, release builds are signed with the debug key and Play rejects them.
- [ ] Enrol in **Play App Signing** when you create the app in the Play Console.
- [ ] **iOS:** open `ios/Runner.xcworkspace` in Xcode. For **both** targets, *Runner* and
      *ShareExtension*: *Signing & Capabilities* → pick your Team (automatic signing).
      Both already declare the App Group `group.com.akhyarsadad.aprompter`; Xcode registers it
      for both app ids on first build. Archive with `flutter build ipa`.

## 2. Products and prices

Create these in both stores, with the same prices:

| Plan | App Store (App Store Connect → *Monetization*) | Google Play (Play Console → *Monetize*) | Price (USD, before tax) |
|---|---|---|---|
| Monthly | Auto-renewable subscription `aprompter_unlimited_monthly`, 1 month, in a subscription group "APrompter Unlimited" | Subscription `aprompter_unlimited`, base plan `monthly`, auto-renewing, 1 month | **2.99** |
| Yearly | Auto-renewable subscription `aprompter_unlimited_yearly`, 1 year, same group | Same subscription, base plan `yearly`, auto-renewing, 1 year | **15.99** |
| Lifetime | Non-consumable `aprompter_unlimited_lifetime` | One-time product `aprompter_unlimited_lifetime` | **39.99** |

About "excluding tax": both stores take your USD price as the base. In the US, sales tax is
added at checkout. In countries where the law requires prices to include tax (EU, UK,
Australia, Japan, India, Indonesia…), the stores show a local price **with** VAT/GST
included and pay you the net amount. Both stores work this way and you can't switch it off.
For the same net income everywhere, adjust prices per country in each console after the
first save.

The yearly plan works out to 55 % less than 12 months of the monthly plan; the paywall shows
"Save 55%" on it automatically.

App Store only: each product needs a display name, a description and a **review
screenshot** of the paywall (the upgrade screen: create a second script on a free install,
see §6). Submit the three products **together with** the first app version.

## 3. RevenueCat

- [ ] Create a project and add both apps (bundle id / package `com.akhyarsadad.aprompter`).
      Connect App Store Connect (in-app purchase key) and Google Play (service account).
- [ ] *Entitlements*: create `unlimited` and attach all five store products.
- [ ] *Offerings*: make the `default` offering **current**, with packages **Monthly**
      (`$rc_monthly`), **Annual** (`$rc_annual`) and **Lifetime** (`$rc_lifetime`). The app
      reads exactly these three slots.
- [ ] Copy the two **public** SDK keys into `lib/config/entitlements_config.dart`
      (`revenueCatApiKeyIos`, `revenueCatApiKeyAndroid`). Until then the upgrade screen says
      "Couldn't load plans" — expected in test builds.

## 4. Legal pages

- [ ] Make the Terms of Use and Privacy Policy reachable at the URLs in
      `lib/config/entitlements_config.dart` (`termsUrl`, `privacyUrl`). They point to
      `docs/TERMS.md` and `docs/PRIVACY.md` on the `main` branch of this public repo, so
      **merge to `main` before you submit**. Alternatively, publish them with GitHub Pages and
      update both URLs.
- [ ] Enter the Privacy Policy URL in both stores. On the App Store, either keep Apple's
      standard EULA (*App Information → License Agreement*) or paste the Terms; also put the
      Terms URL in the app description, which App Review checks for subscription apps.

## 5. Google Play declarations

**Display over other apps (`SYSTEM_ALERT_WINDOW`)**

> APrompter is a teleprompter for creators. The *Float* feature shows the creator's own
> script in a small window on top of the camera app they film with (TikTok, Instagram,
> CapCut, the system camera), so they can read while looking at the lens. The window is
> only shown after the user taps *Float* and is closed with its ✕ button. It is marked
> secure so it never appears in screen recordings or streams.

**Foreground service type `specialUse`**

> Subtype: *floating teleprompter*. The service keeps the user-started prompter window
> alive while the user films in another app. It runs only while the window is visible,
> shows an ongoing notification, and stops when the user closes the window.

Prepare a 30-second screen recording: open a script → tap *Float* → allow the permission →
open the camera app → the prompter scrolls over it → close it with ✕.

**Data safety form** (Play Console → *App content*):

| Question | Answer |
|---|---|
| Does your app collect or share user data? | **Yes** (only for purchases, via RevenueCat) |
| Data types collected | **Financial info → Purchase history** and **Device or other IDs** (RevenueCat's random app-instance id) — nothing else |
| Purpose | App functionality (both) |
| Shared with third parties? | **No** — RevenueCat is a service provider acting for you, which Play doesn't count as sharing |
| Processed ephemerally? | No |
| Required or optional? | Required (needed to know whether Unlimited is active) |
| Encrypted in transit? | Yes |
| Can users ask for deletion? | Yes — through the contact in the privacy policy (delete the customer in RevenueCat) |
| Camera, microphone, files, scripts | **Not collected** — processed on the phone only, never sent |

Also: *Ads* → No. *Target audience* → 13+ is the simplest choice (lower ages bring Families
policy requirements). *Content rating* questionnaire → no objectionable content.

## 6. App Store Connect

**App Privacy** (*App Privacy → Get Started*):

- Data collected: **Purchases → Purchase History** and **Identifiers → User ID** (RevenueCat's
  random id), both for **App Functionality**, **not used for tracking**.
- Linked to identity: there's no account and the id is random, so *Not linked* is
  defensible. If in doubt choose *Linked*: declaring more than you collect is never a
  rejection reason, declaring less is. Re-check RevenueCat's current "Apple App Privacy"
  guide before submitting.
- Everything else: not collected. The app ships a privacy manifest
  (`ios/Runner/PrivacyInfo.xcprivacy`) declaring the one required-reason API it uses
  (free disk space, checked before recording).

**Review notes** (paste into *App Review Information → Notes*):

> No account or login is needed. The free tier holds one script (besides the sample). To see
> the paywall: tap + to create a script, then tap + again. Plans: monthly, yearly, lifetime;
> "Restore purchases" is on the same screen. Camera and microphone are used only when the user
> taps Record; photos access is used to save takes into an "APrompter" album. Face ID is used
> only for the optional app lock. The share extension imports text and text files shared
> from other apps as new scripts; nothing is uploaded. Float is Android-only; the iPhone UI
> explains why.

## 7. Crash reports — open decision

The app has no crash reporting. Options, in order of privacy:
1. None (current). Rely on Play Console "Android vitals" and App Store Connect crash logs,
   which need no SDK.
2. Opt-in Sentry/Crashlytics behind a settings switch, off by default (update both privacy
   forms if you add it).

## 8. Pre-launch QA

- [ ] **Purchases:** iOS sandbox tester + Play license tester. Buy monthly → app unlocks
      without a restart; reinstall → *Restore purchases* unlocks; restore on an account with
      nothing → "No earlier purchase found…"; cancel in the store → locks again after expiry.
- [ ] **Import:** share a note from Apple Notes / Google Keep / Samsung Notes / Notion to
      APrompter; open a `.docx`, `.md`, `.rtf` and `.txt` from Files/Drive/Mail with
      APrompter; *Paste as new script*; *Save as text file* → re-import gives the same script.
- [ ] Native-speaker review of all 28 languages (backlog L1/L6). Machine-assisted
      translations: Filipino, Swahili, Tamil, Urdu and Bengali need the most attention.
- [ ] Run the device test matrix in `UNHAPPY_PATHS_BACKLOG.md` §17.
- [ ] TalkBack / VoiceOver pass on Home, Editor, Rehearse, Record, Upgrade.
- [ ] Store listing screenshots per language (or at least en, es, pt, id, hi, ar).
