# flutter_overlay_window 0.5.0 (patched copy)

Vendored from https://pub.dev/packages/flutter_overlay_window 0.5.0 (MIT, see LICENSE)
with one fix in `OverlayService.java`:

- When Android restarts the service after killing the app's process, it passes a `null`
  intent. 0.5.0 then crashed with a NullPointerException (`START_STICKY` + no null check),
  which shows up as a crash in Play Console "Android vitals". The service now stops itself
  in that case, and returns `START_NOT_STICKY` so Android doesn't restart a floating window
  nobody asked for. `startForeground` failures stop the service instead of crashing.

Used through `dependency_overrides` in the app's `pubspec.yaml`. Drop this folder and the
override once upstream ships the same fix.
