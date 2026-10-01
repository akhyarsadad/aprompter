# APrompter

A teleprompter for content creators that works on **Android and iOS**. Write your script,
then read it while you film — the text floats over the camera so you keep eye contact
with your audience.

Built with Flutter.

## Features

| Mode | Android | iOS | What it does |
|------|:------:|:---:|--------------|
| **Record** | ✅ | ✅ | Opens the camera (front by default) with your script scrolling on top of the preview, right under the lens. Records video + audio and saves it to the gallery (album "APrompter"). |
| **Float** | ✅ | — | Shows the prompter as a draggable floating window **over any other app** (TikTok, Instagram, YouTube, CapCut, Zoom, the stock camera…). Minimize, play/pause, speed, close. |
| **Read** | ✅ | ✅ | Full-screen prompter without camera — for a second device or beam-splitter glass (turn on *Mirror text*). |

Prompter controls:

- Tap the text to pause / resume, drag to scroll by hand (Record & Read).
- Speed −/+ buttons, restart, countdown before start (off / 3 / 5 / 10 s).
- Settings: text size, scroll speed, line spacing, text color, background opacity,
  prompter height, left/center alignment, mirror mode, reading guide line.
- Script library with word count and estimated reading time, stored on the device.

> **Why no floating mode on iOS?** iOS does not let apps draw over other apps, so on
> iPhone use **Record** — the built-in camera with the prompter overlaid.

## Project layout

```
lib/
  main.dart                     app entry + `overlayMain` (Android floating window entry)
  models/                       Script, PrompterSettings
  services/                     storage (shared_preferences), app state, floating prompter
  widgets/                      PrompterView (auto-scrolling text), controls, settings sheet
  screens/                      home, editor, camera recorder, full-screen reader
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
