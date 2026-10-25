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
      for both app ids on first build. Archive with `flutter build ipa` using **Xcode 26 or
      later** (App Store Connect only accepts builds made with the current iOS SDK).
- [ ] **Android upload:** build with `flutter build appbundle --release` and upload
      `build/app/outputs/bundle/release/app-release.aab`. Play doesn't accept APKs for new apps;
      the APK from CI is only for installing on your own phone.

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
screenshot** of the paywall (the upgrade screen: *⋮ menu → Upgrade* on the home screen). Submit
the three products **together with** the first app version.

## 3. RevenueCat

- [ ] Create a project and add both apps (bundle id / package `com.akhyarsadad.aprompter`).
      Connect App Store Connect (in-app purchase key) and Google Play (service account).
- [ ] *Entitlements*: create `unlimited` and attach all **six** store products: App Store
      `aprompter_unlimited_monthly`, `aprompter_unlimited_yearly`, `aprompter_unlimited_lifetime`,
      and Google Play `aprompter_unlimited:monthly`, `aprompter_unlimited:yearly` (RevenueCat
      lists each base plan as its own product) and `aprompter_unlimited_lifetime`.
- [ ] *Product catalog → Products*: set **`aprompter_unlimited_lifetime`** to
      **Non-consumable** (both stores, Google Play especially). The app has no sign-in, and a
      one-time purchase RevenueCat treats as consumable is consumed on Google Play and can then
      never be restored.
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
> alive while the user films in another app. It runs only while the window is visible, has
> the standard foreground-service notification (in the notification shade when notifications
> are allowed, otherwise in Android's task manager), and stops when the user closes the window.

Prepare a 30-second screen recording: open a script → tap *Float* → allow the permission →
open the camera app → the prompter scrolls over it → close it with ✕.

**Data safety form** (Play Console → *App content*):

| Question | Answer |
|---|---|
| Does your app collect or share user data? | **Yes** (only for purchases, via RevenueCat) |
| Data types collected | **Financial info → Purchase history**, **Device or other IDs** (RevenueCat's random app-instance id) and **App info and performance → Diagnostics** (RevenueCat's purchase-check timings and store error codes, which RevenueCat can switch on remotely) — nothing else. Re-check RevenueCat's current "Google Play Data safety" guide before submitting |
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

> No account or login is needed. To see the paywall: on the home screen open the ⋮ menu →
> Upgrade. (It also opens on its own when a free user, who can keep one script besides the
> sample, tries to add a second one.) Plans: monthly, yearly, lifetime; "Restore purchases" is
> on the same screen. Camera and microphone are used only when the user
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
      **Android Lifetime:** buy it → uninstall → reinstall (or a second phone, same Google
      account) → *Restore purchases* unlocks. If it doesn't, Lifetime isn't Non-consumable (§3).
- [ ] **Import:** share a note from Apple Notes / Google Keep / Samsung Notes / Notion to
      APrompter; open a `.docx`, `.md`, `.rtf` and `.txt` from Files/Drive/Mail with
      APrompter; *Paste as new script*; *Save as text file* → re-import gives the same script.
- [ ] Native-speaker review of all 28 languages (backlog L1/L6). Machine-assisted
      translations: Filipino, Swahili, Tamil, Urdu and Bengali need the most attention.
- [ ] Run the device test matrix in `UNHAPPY_PATHS_BACKLOG.md` §17.
- [ ] TalkBack / VoiceOver pass on Home, Editor, Rehearse, Record, Upgrade.
- [ ] Store listing screenshots per language (or at least en, es, pt, id, hi, ar). The app
      runs on iPad, so App Store Connect needs **iPhone 6.9" and iPad 13"** screenshots. In
      *Pricing and Availability*, untick Apple-silicon Mac / Apple Vision Pro unless you have
      tested there.
- [ ] Put a **support email** on both store listings: the privacy policy sends data-deletion
      requests there.

## 9. Known and accepted for launch

Found in the pre-release review and deliberately left for later — none blocks review:

- **Notification permission (Android 13+):** the app never asks for `POST_NOTIFICATIONS`, so
  the Float service's notification shows only in Android's task manager unless the user
  allows notifications in Settings (backlog F11). Float itself works.
- **Free limit and your own scripts:** restoring from *Recently deleted*, *Undo* after a
  delete, and *Restore from a backup* never count against the one free script — bringing back
  your own work is never paywalled.
- **Shared notes:** when text is shared from a notes app without a title, a short first line
  becomes the title and leaves the body (Apple Notes / Samsung Notes put the title there).
  *Paste as new script* always keeps every line.
- **Translations:** the new paywall and import strings are machine-assisted in all 28
  languages; see the native-speaker review in §8.
