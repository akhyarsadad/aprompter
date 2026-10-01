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
  filter on home. **Import a text file** (.txt / .md) as a new script; Paste cleans up
  text from Docs, Word and chats.
- Duplicate a script, share it, or **copy as caption** (spoken text without markup —
  ready to paste as the post caption, hashtags included).
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
- **Put the prompter anywhere:** in Record, drag the bar on top of the prompter to move
  it and the corner handle to resize it. On Android, the floating window can be dragged
  anywhere over other apps, its width is adjustable, and it reopens where you left it.
  *Settings → Layout → Reset position* puts it back at the top.
- Video quality 720p / 1080p / 4K, and **auto-stop** 2, 5 or 10 s after the last line.
- **Review each take** (keep or retake), keep takes in the gallery or **inside the app**
  (out of Google Photos / iCloud) with a *Takes* list per script.
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
  l10n/                         English & Indonesian strings (ARB) + helpers
  models/                       Script, markup parser, settings & presets, templates
  services/                     storage (shared_preferences), app state, floating prompter
  widgets/                      PrompterView (auto-scrolling text), controls, settings sheet
  screens/                      home, editor, camera recorder, rehearse
  overlay/overlay_app.dart      UI of the floating window over other apps
```

## Getting started

Requirements: Flutter 3.x (stable), Android Studio / Android SDK for Android, Xcode 15+ for iOS.

```bash
flutter pub get
flutter run            # pick an Android device or iPhone
flutter test           # unit + widget tests
```

Release builds:

```bash
flutter build apk --release      # or: flutter build appbundle
flutter build ipa --release      # needs an Apple developer account / signing team
```

Android release signing reads `android/key.properties` (git-ignored):

```properties
storeFile=/absolute/path/to/upload-keystore.jks
storePassword=…
keyAlias=upload
keyPassword=…
```

Create the keystore once with
`keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload`
and keep it safe — Play updates must be signed with it. Without `key.properties`,
release builds fall back to the debug key (fine for testing, not for the store).
For iOS, set your team in Xcode (`ios/Runner.xcworkspace`).

### Permissions

- **Android:** camera, microphone, "Display over other apps" (asked when you first tap
  *Float*), notifications (the floating window runs as a foreground service).
- **iOS:** camera, microphone, add to photo library — descriptions are in `ios/Runner/Info.plist`.

### Store notes

The Android floating window uses a `specialUse` foreground service. Google Play asks you to
justify this in the Play Console (the reason is already described in the manifest).

Release checklist, Play declarations and review notes: [`docs/STORE_RELEASE.md`](docs/STORE_RELEASE.md).
Privacy policy (host it and link it in both stores): [`docs/PRIVACY.md`](docs/PRIVACY.md).
