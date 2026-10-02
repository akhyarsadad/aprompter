# APrompter — Store release checklist

Covers backlog items Q1–Q6. Tick these before the first public release.

## 1. Signing (Q1)

- [ ] Create the Android upload keystore once (command in the README) and write
      `android/key.properties`. Never commit either; back the keystore up.
- [ ] Enrol in **Play App Signing** in the Play Console.
- [ ] iOS: set the team in Xcode, archive with `flutter build ipa`.

## 2. Google Play declarations (Q2)

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

**Data safety form**: no data collected, no data shared; camera and microphone used on device
only; data can be deleted by the user (see [PRIVACY.md](PRIVACY.md)).

## 3. Privacy policy (Q3)

- [ ] Host [PRIVACY.md](PRIVACY.md) at a public URL (e.g. GitHub Pages) and enter it in both
      stores.

## 4. iOS review notes (Q4)

- Photo library: the app asks for album access to save takes into an "APrompter" album
  (`NSPhotoLibraryUsageDescription`, `NSPhotoLibraryAddUsageDescription`). Mention this in
  the review notes, or switch to add-only saving without an album if review objects.
- Face ID: used only for the optional app lock (`NSFaceIDUsageDescription`).
- Float is Android-only; the iPhone UI explains why.

## 5. Crash reports (Q5) — open decision

The app has no crash reporting. Options, in order of privacy:
1. None (current). Rely on Play Console "Android vitals" and App Store Connect crash logs,
   which need no SDK.
2. Opt-in Sentry/Crashlytics behind a settings switch, off by default.

## 6. Pre-launch QA (Q6)

- [ ] Native-speaker review of all 28 languages (backlog L1/L6). Machine-assisted
      translations: Filipino, Swahili, Tamil, Urdu and Bengali need the most attention.
- [ ] Run the device test matrix in `UNHAPPY_PATHS_BACKLOG.md` §17.
- [ ] TalkBack / VoiceOver pass on Home, Editor, Rehearse, Record.
- [ ] Store listing screenshots per language (or at least en, es, pt, id, hi, ar).
