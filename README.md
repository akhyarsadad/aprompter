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
- Target length (15 s · 30 s · 60 s · 90 s · 3 min) with a live bar:
  words · spoken time vs. target, "8 s over · cut ~20 words".
- Hint for long sentences that are hard to say in one breath.
- Toolbar for prompter markup:

  | Markup | Meaning on the prompter |
  |---|---|
  | `# Hook` | Section cue — jump to it for retakes |
  | `*word*` | Emphasis (highlighted) |
  | `[pause]` | Visible beat marker |
  | `// smile` | Note to yourself — dimmed, not counted as spoken |

- Status: Draft → Ready → Recorded, with take count. Search and filter on home.

**Rehearse & pace (J3)**
- Speed is in **words per minute**, so changing the text size never changes the pace.
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
- Bluetooth remote / keyboard: Space · Enter · PageDown = play/pause, PageUp / ← = previous
  section, → = next section, ↑ / ↓ = faster / slower.

> **Why no floating mode on iOS?** iOS does not let apps draw over other apps, so on
> iPhone use **Record** — the built-in camera with the prompter overlaid.

## Project layout

```
lib/
  main.dart                     app entry + `overlayMain` (Android floating window entry)
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

Before publishing, set your own signing config in `android/app/build.gradle.kts`
and your team in Xcode (`ios/Runner.xcworkspace`).

### Permissions

- **Android:** camera, microphone, "Display over other apps" (asked when you first tap
  *Float*), notifications (the floating window runs as a foreground service).
- **iOS:** camera, microphone, add to photo library — descriptions are in `ios/Runner/Info.plist`.

### Store notes

The Android floating window uses a `specialUse` foreground service. Google Play asks you to
justify this in the Play Console (the reason is already described in the manifest).
