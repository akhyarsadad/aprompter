# APrompter

A teleprompter for content creators that works on **Android and iOS**. Write your script,
then read it while you film — the text floats over the camera so you keep eye contact
with your audience.

Built with Flutter.

## Features

Built around the creator workflow — see [`docs/USER_JOURNEYS.md`](docs/USER_JOURNEYS.md)
for personas, journeys and scope.

**Write (J1–J2)**
- Templates: *Hook → Value → CTA*, *Tutorial*, *Product review*, *Storytime*, or blank.
- Target length (15 s · 30 s · 60 s · 90 s · 3 min, or any custom length) with a live bar:
  words · spoken time vs. target, "8 s over · cut ~20 words".
- Hint for long sentences that are hard to say in one breath.
- Toolbar for prompter markup:

  | Markup | Meaning on the prompter |
  |---|---|
  | `# Hook` | Section cue — jump to it for retakes (`#` + space, or `##`) |
  | `*word*` / `**word**` | Emphasis (highlighted); `\*` is a literal star |
  | `[pause]` | Visible beat marker, adds 0.7 s (also `(pause)`, `[ Pause. ]`) |
  | `// smile` | Note to yourself — dimmed, not counted as spoken |
  | `#fyp #ad` | Hashtag line — dimmed, not timed, kept in the caption |

- Status: Draft → Ready → Recorded, with take count. Search (accent-insensitive) and
  filter on home. Paste cleans up text from Docs, Word and chats.
- Duplicate a script, share it, or **copy as caption** (spoken text without markup —
  ready to paste as the post caption, hashtags included).

**Import & export — from and to any notes app or text file**
- **Share to APrompter** from Apple Notes, Google Keep, Samsung Notes, Notion, Word, Docs,
  Mail, Files… (Android share sheet and "Open with"; iPhone share extension). The note
  becomes a new script and opens in the editor.
- **Paste as new script** in one tap, or **Import files** (several at once): `.txt`, `.md`
  (Notion / Obsidian / Bear exports), `.rtf`, `.docx`, `.odt`, `.html`, Evernote `.enex`,
  `.srt` / `.vtt` subtitles, and APrompter backups. Any text encoding; headings become
  sections, bold becomes emphasis, list bullets and links are cleaned up.
- **Save as text file** or **Share** a script to Notes, Keep, Files, Drive or email —
  importing that file again gives the same script.
- Nothing is lost by accident: autosave with a "Saved" hint, **version history** per
  script, **Recently deleted** for 30 days, a warning banner if the phone refuses to
  save (storage full), and **Back up all scripts** / **Restore from a backup** as one
  JSON file.

**Rehearse & pace (J3)**
- Speed is in **words per minute** (40–400), so changing the text size never changes the
  pace. Only spoken lines take time; notes and sections glide by.
- **Line by line** mode: each tap or remote press moves one line, nothing scrolls by itself.
- Pace presets *Calm 120 · Natural 150 · Energetic 180*, ±10 steps, and **Fit to target**.
- Progress bar and time remaining while reading.
- After a run: "You took 1:04 → 133 wpm. Use 130 wpm?"

**Set up (J4)** — settings sheet with live preview and one-tap setups:
*Handheld selfie*, *Tripod / distance*, *Teleprompter glass* (mirrored). Fine-tune pace,
countdown, text size, spacing, color, alignment, prompter height, background, guide line.

**Record & retake (J5–J6)**

| Mode | Android | iOS | |
|------|:------:|:---:|---|
| **Record** | ✅ | ✅ | Camera with the script under the lens; saves to the gallery and counts the take. |
| **Float** | ✅ | — | Draggable prompter over any app (TikTok, Instagram, CapCut, camera…). |
| **Rehearse** | ✅ | ✅ | Full-screen prompter, no camera. |

- Jump to any section to retake just that part.
- **Pinch** the prompter text to resize it on the fly; you stay on the same line.
- **Reading line near the lens:** it sits high by default (front camera on top); move it in
  *Settings → Layout* or drag its left arrow in Rehearse and Record.
- **Put the prompter anywhere:** in Record, drag the bar on top of the prompter to move
  it and the corner handle to resize it. On Android, the floating window can be dragged
  anywhere over other apps, its width is adjustable, and it reopens where you left it.
  *Settings → Layout → Reset position* puts it back at the top.
- Video quality 720p / 1080p / 4K, and **auto-stop** 2, 5 or 10 s after the last line.
- **Review each take** (keep or retake), keep takes in the gallery or **inside the app**
  (out of Google Photos / iCloud Photos and cloud backups) with a *Takes* list per script.
- Warns before recording if storage or battery may not last; tap to focus, long-press to
  lock focus/exposure, pinch to zoom. The preview shows exactly what is recorded.
- Rehearse and Record work in **landscape** too; tablets rotate everywhere.
- Reading comfort: letter spacing, focus on the current line, full brightness, reduce
  effects. Optional **app lock** (fingerprint / face / PIN).
- Haptic ticks during the countdown.
- Bluetooth remote / keyboard: Space · Enter · PageDown · `B` · `.` = play/pause, PageUp / ←
  = previous section, → = next section, ↑ / ↓ = faster / slower. Cheap selfie remotes
  (Volume Up) and media keys (play/pause, next/previous track) work too (Android).
- The floating window is hidden from screen recordings and live streams (Android).

> **Why no floating mode on iOS?** iOS does not let apps draw over other apps, so on
> iPhone use **Record** — the built-in camera with the prompter overlaid.

**Languages (28):** English, Español, Português, Français, Deutsch, Italiano, Nederlands,
Polski, Русский, Українська, Türkçe, العربية, فارسی, اردو, עברית, हिन्दी, বাংলা, தமிழ், ไทย,
Tiếng Việt, Bahasa Indonesia, Bahasa Melayu, Filipino, 简体中文, 繁體中文, 日本語, 한국어,
Kiswahili.

- Follows the phone's language, or pick one in *Settings → App → App language*
  (also in Android 13+ / iOS per-app language settings).
- **Scripts in any language:** right-to-left lines (Arabic, Hebrew, Persian, Urdu) are laid
  out right-to-left even in an English app; the editor follows what you type.
- **Timing works without spaces:** Chinese, Japanese, Thai, Lao, Khmer and Burmese are
  timed by characters, converted to word equivalents, so one pace in words per minute
  fits every language. Indic vowel signs no longer split words.
- Sentence checks understand 。！？ ؟ । ۔.
- Translations live in `lib/l10n/app_<lang>.arb`; `test/translations_test.dart` fails if a
  language misses a string or breaks a `{placeholder}`.
- Not yet translated: the iOS system permission prompts (camera, microphone, photos) are
  in English.

## Download a test build

Every push runs CI (analyze, tests, Android + iOS builds). The Android APK is attached to
each run: GitHub → **Actions** → latest **CI** run → *Artifacts* → `aprompter-android-apk`.
Unzip it and install the `.apk` on your phone (allow "install unknown apps").

## Project layout

```
lib/
  main.dart                     app entry + `overlayMain` (Android floating window entry)
  l10n/                         strings for 28 languages (ARB) + helpers
  models/                       Script, markup parser, settings & presets, templates
  services/                     storage, app state, import, purchases, floating prompter
  widgets/                      PrompterView (auto-scrolling text), controls, settings sheet
  screens/                      home, editor, camera recorder, rehearse, paywall
  overlay/overlay_app.dart      UI of the floating window over other apps
```

## Getting started

Requirements: Flutter 3.x (stable), Android Studio / Android SDK for Android, Xcode 26+ for iOS
(App Store Connect only accepts builds made with the current iOS SDK).

```bash
flutter pub get
flutter run            # pick an Android device or iPhone
flutter test           # unit + widget tests
```

Store builds are made by GitHub Actions: **Actions → Release builds → Run workflow** gives a
signed Play App Bundle (`.aab`) and uploads the iPhone build to TestFlight. Signing keys live
in repository secrets, never in the repo; the one-time setup is in
[`docs/STORE_RELEASE.md`](docs/STORE_RELEASE.md) §1.

Building a store version locally still works the usual way: Android release signing reads
`android/key.properties` (git-ignored; format in `android/app/build.gradle.kts`) and falls
back to the debug key without it (fine for testing, not for the store); for iOS, set your
team in Xcode (`ios/Runner.xcworkspace`) for both the *Runner* and *ShareExtension* targets.

### Permissions

- **Android:** camera, microphone, photos/media/files on Android 10 and older (to save takes
  to the gallery), "Display over other apps" (asked when you first tap *Float*), notifications
  (the floating window runs as a foreground service), fingerprint/face (only for App lock),
  internet (only to check purchases).
- **iOS:** camera, microphone, photo library (to create the "APrompter" album and save
  takes), Face ID (only for App lock) — descriptions are in `ios/Runner/Info.plist`.

### Store notes

The Android floating window uses a `specialUse` foreground service. Google Play asks you to
justify this in the Play Console (the reason is already described in the manifest).

### Paywall setup

Free use: 1 script (the sample script doesn't count); scripts over 500 words show a
reminder. **APrompter Unlimited** removes the limit: monthly 2.99, yearly 15.99, lifetime 39.99 (USD, before
tax), sold through the App Store / Google Play and checked with RevenueCat.

There is **no sign-in**. A purchase belongs to the store account (Apple ID / Google
account); **Restore purchases** on the upgrade screen brings it back on a new phone or
after a reinstall. APrompter never sends your scripts anywhere.

To make purchases work, fill the two RevenueCat SDK keys in
`lib/config/entitlements_config.dart`. Store products, RevenueCat setup, legal pages and
both privacy forms are described step by step in
[`docs/STORE_RELEASE.md`](docs/STORE_RELEASE.md). The keys are public SDK keys, not
secrets, so the file is tracked with placeholders and the repo always compiles; until
they're filled in, the upgrade screen says "Couldn't load plans".

Release checklist, Play declarations and review notes: [`docs/STORE_RELEASE.md`](docs/STORE_RELEASE.md).
Privacy policy and Terms of Use (linked from Settings → App, the upgrade screen and both stores):
[`docs/PRIVACY.md`](docs/PRIVACY.md), [`docs/TERMS.md`](docs/TERMS.md).
