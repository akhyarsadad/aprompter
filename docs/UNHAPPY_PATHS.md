# APrompter — Unhappy-path scenarios

What can go wrong for a creator, what the app did before, and what it does now.
Severity: **P0** = data loss / app unusable, **P1** = stuck or misleading, **P2** = annoyance.

| # | Journey | Scenario | Before | Fix | Sev | Verified by |
|---|---|---|---|---|---|---|
| U1 | All | Saved data is corrupted (bad update, interrupted write, manual edit) | App crashed on launch, every time | Loading is defensive: a broken library is backed up under a separate key and the app starts; broken settings fall back to defaults | P0 | `unhappy_paths_test` |
| U2 | J5 Record | Swipe back / Android back button **while recording** | Screen closed, recording thrown away | Back is intercepted: recording is stopped and saved first, then the screen closes | P0 | manual |
| U3 | J5 Record | Recording finishes but **gallery access is denied** or saving fails (storage full) | Video file lost, only an error toast | Take is kept: a sheet offers **Try again** and **Share video** (save to Files/Drive/send to yourself) | P0 | manual |
| U4 | J5 Record | App goes to background (call, notification, app switch) and comes back | Camera released but never reopened — endless spinner | Camera is reopened on return; an in-progress recording is saved before release | P1 | manual |
| U5 | J5 Record | **Microphone** permission denied, camera allowed | Camera failed completely ("Microphone access was denied") | Falls back to recording **without sound** and says so in a banner | P1 | manual |
| U6 | J5 Record | **Camera** permission denied | Error text, no way forward | **Open settings** and **Try again** buttons | P1 | manual |
| U7 | J5 Record | No camera / camera error | Record button showed a spinner forever | Record button disabled; error explains why | P2 | manual |
| U8 | J5 Record | Tap Record during the countdown (changed my mind) | Ignored — recording started anyway | Second tap **cancels** the countdown | P2 | manual |
| U9 | J5 Record | Auto-stop, a manual stop and leaving the screen happen together | Stop could run twice | Stop is idempotent | P2 | code review |
| U10 | J3 Rehearse | Press Play again **after reaching the end** | Instantly "finished" again; summary sheet popped again | Play at the end restarts from the top | P1 | `unhappy_paths_test` |
| U11 | J2 Write | App killed / phone dies **while writing** | Everything since opening the editor lost (saved only on back) | Autosave 1 s after typing stops and when the app goes to background | P0 | `unhappy_paths_test` |
| U12 | J3/J5 | Rehearse / Record / Float a script with **no spoken words** (empty, or only `#` sections and `//` notes) | Prompter showed "(empty script)", timers at 0:00, camera opened for nothing | Actions blocked with a hint: "Add some lines to say first" | P2 | `unhappy_paths_test` |
| U13 | J7 Library | Copy as caption on a script with nothing to say | Copied an empty string, said "copied" | Same hint, nothing copied | P2 | `unhappy_paths_test` |
| U16 | J5 Record | First save on **iOS** into the "APrompter" album | App would be killed by iOS: album access needs `NSPhotoLibraryUsageDescription`, which was missing | Usage description added; access is requested for album saving | P0 | iOS CI build + manual |
| U17 | J1 Write | Open a template, look at it, go back without writing | A junk "Untitled" script was autosaved every time | Untouched templates are not saved | P2 | `world_test` |
| U18 | All | Phone set to a language the app doesn't have (e.g. Norwegian) | App fell back to **Arabic** (Flutter picks the first supported language) | Falls back to English; Chinese without a script (old Android "zh-TW") picks Traditional for TW/HK/MO | P1 | `world_test` |
| U19 | All | Long translations (German, Tamil…) on a small phone | Setup cards in Settings overflowed | Cards grow with their text; every language is checked on a 360 dp screen | P2 | `world_test` |
| U14 | J5 Float | "Display over other apps" denied | — | Already handled: explains the permission | — | existing |
| U15 | J4 Settings | Phone language not English/Indonesian | — | Already handled: falls back to English | — | existing |

## Known limitations (not fixed)

- Pulling down the iOS Control Center during a take makes the app *inactive*, which stops
  and saves the recording (U4 behaviour). Recording cannot continue in the background on iOS.
- Very large pastes (tens of thousands of words) re-count words on every keystroke; fine for
  normal scripts, sluggish for book-length text.

More scenarios — documented, not fixed yet — are in [UNHAPPY_PATHS_BACKLOG.md](UNHAPPY_PATHS_BACKLOG.md).
