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
| U20 | J2 Write | Hashtags on their own line (`#fyp #viral`) — backlog W1 | Became a section cue, left out of timing *and* of "Copy as caption" | A section needs `# ` (hash + space) or `##`. Hashtag-only lines are shown dimmed, not timed, and kept in the caption. A lone `#` is ignored (W10) | P1 | `models_test` |
| U21 | J2 Write | `2*3*4`, `* tip`, `**bold**`, `\*` — W2/W3 | Asterisks vanished or stayed around bold text | Emphasis only when the asterisks hug a word; `**bold**` works; `\*` is a literal star | P2 | `models_test` |
| U22 | J2/J3 | `[ Pause. ]`, `(pause)` and real pause time — W9/T4 | Only `[pause]` recognised; pauses added no time, takes ran long | Forgiving syntax; each pause adds 0.7 s to estimates, the prompter and Fit to target | P2 | `models_test` |
| U23 | J2 Write | Select-all + delete, bad paste — W4 | Autosaved over the script after 1 s; no way back | Earlier versions are kept automatically (every 5 min while typing, always before a big deletion). Editor → History → Restore; restoring keeps the current text as a version too | P0 | `backlog_test` |
| U24 | All | Phone storage full when saving — D2 | Save result ignored → silent data loss | Every write is checked. A banner on every screen says saving failed; work stays in memory; **Try again** writes everything | P0 | `backlog_test` |
| U25 | J7 Library | Undo snackbar missed — D5 | Deletion permanent | **Recently deleted** (home menu) keeps scripts 30 days: restore or delete forever | P2 | `backlog_test` |
| U26 | All | Phone lost / reset / new phone — D1 | Scripts only on the device | Home menu → **Back up all scripts** shares one JSON file (Files, Drive, chat); **Restore from a backup** merges it, never overwriting a newer local edit | P0 | `backlog_test` |
| U27 | J7 Library | Marking Ready or recording a take — D6 | Script jumped to the top | Only writing moves a script up | P3 | `backlog_test` |
| U28 | J7 Library | Search "cafe" / "istanbul" — D7 | Didn't find "Café" / "İstanbul" | Accent- and Turkish-I-insensitive search | P3 | `backlog_test` |
| U29 | J3 Rehearse | Many `//` notes and `#` sections — T1 | Whole scroll timed by words, so spoken lines ran faster than the set wpm | Each spoken line gets exactly its words ÷ wpm (+ pauses); notes, sections and blank lines glide by | P1 | `backlog_test` |
| U30 | J4 Settings | 15 s target that needs > 300 wpm — T2 | "Fit" silently capped at 300 | Fit chip hidden; says "Even at 300 wpm this won't fit 0:15 — cut about N words" | P1 | manual |
| U31 | J2 Write | 5/10/20-minute videos — W6 | Targets stopped at 3 min | **Custom…** target (`5:00`, `4:30`, `12`) | P1 | `backlog_test` |
| U32 | J2 Write | "Did it save?" — W11 | No feedback | "✓ Saved" next to the title | P3 | manual |
| U33 | J5 Record | Countdown ends while the camera is still opening — C1 | Recording silently didn't start | Waits up to 5 s for the camera, otherwise says so | P1 | manual |
| U34 | J5/J6 | Bluetooth selfie remote (Volume Up), page-turners — K1/K2 | Nothing happened, or system volume changed | Volume keys, `B`, `.` and media play/pause toggle the prompter; next/previous track and rewind/forward jump sections (Android; iOS doesn't pass volume keys to apps) | P1 | `backlog_test` |
| U35 | J5 Float | Screen recording, screen share, live stream with Float on — F1 | **Floating script visible to the audience** | Floating window is marked secure: recordings and streams show it blank | P0 | device check needed |
| U36 | J5 Float | Lost place in Float — R5 | Only restart | ⏮ ⏭ section buttons in the floating bar | P1 | manual |
| U37 | J5 Float | Edits a script that is floating — W8 | Overlay kept the old text | Edits are pushed to the floating window, keeping the place | P2 | manual |
| U38 | J5 Float | Script title in the notification shade — F13 | Visible to anyone glancing | Generic "Tap to open APrompter" | P3 | manual |
| U39 | J5 Float | Float on iPhone — O4 | Button missing, no explanation | Greyed-out Float explains it isn't possible on iPhone and points to Record | P2 | manual |
| U40 | Release | Release APK signed with the debug key — Q1 | Couldn't publish | Release signing from `android/key.properties` (falls back to debug when absent) | P0 | CI build |
| U41 | All | Library of hundreds of long scripts — D3 | One JSON value rewritten on every keystroke-save | Each script has its own storage entry; old libraries are moved over on first start (the old copy is removed only after the move succeeds) | P1 | `backlog2_test` |
| U42 | All | Unreadable saved data — D4 | Backed up but no way to get it back; never cleaned | *Recently deleted* lists unreadable data: **Try to recover** salvages what it can, or delete it | P2 | `backlog2_test` |
| U43 | J5 Record | First tap on Record — O1 | System camera/mic prompt with no context → reflex "Don't allow" | A short explanation first; "Not now" leaves without asking | P1 | manual |
| U44 | J5 Record | Long take with little storage or battery — C6/C7/C15 | Recording failed late or phone died mid-take | Before recording: warns if the expected length won't fit in free space (by quality) or battery ≤ 15 % and not charging; *Record anyway* | P1 | manual |
| U45 | J5/J6 | Wants to watch a take before keeping it; takes per script; brand content in Google Photos — C3/C4/Y3 | Every take went straight to the gallery | **Review each take** (keep / retake — retake starts where the take started). **Save takes to the gallery** off keeps them inside the app; *Takes* on each script lists, plays, shares, saves or deletes them | P1 | manual |
| U46 | J5 Record | Preview cropped to fill the screen — C2 | What you saw ≠ what was recorded | Preview shows the true recorded frame | P1 | manual |
| U47 | J5 Record | Exposure hunting, framing — C10 | No controls | Tap to focus/expose, long-press to lock (amber), pinch to zoom | P2 | manual |
| U48 | J5 Record | Ad-libs, retakes mid-take, camera busy, pinch while filming — C12/C13/C14/R12 | Cut after 2 s; sections locked; raw error; font jumped | Auto-stop waits 2/5/10 s; sections can be jumped during a take; "another app is using the camera"; pinch resize off while recording | P2 | manual |
| U49 | J3/J5 | Tripod, rig, tablet, long-form — R4/X1 | Portrait only; iPad plist said all orientations | Rehearse and Record turn to landscape on phones; tablets allow every orientation everywhere | P1 | manual |
| U50 | J3/J5 | Edge grip, black text, sunlight, Turkish/German casing, brand name before Arabic — R1/R2/R3/R6/R7 | Paused by the grip; invisible text; dim; wrong casing; wrong direction | 24 dp edge dead-zone; dark text gets a light backdrop; optional full brightness; section titles keep their casing; direction follows most letters | P2 | `backlog2_test` |
| U51 | J3/J5 | Dyslexia, stutter, reduced motion, old phones, glass rig — R8/A4/A5/R10/R11/R9 | One fixed style; continuous scroll only; fade on every frame; controls behind glass | Letter spacing, **focus on the current line**, **line by line** (each tap/remote press = next line), **reduce effects**; controls hide while reading in mirror mode | P2 | `backlog2_test` |
| U52 | J3 Rehearse | Pace from remote, early stop, jumps, extreme readers — T5/T8/T9/T10 | Remote pace lost; no summary; jumps skewed the suggestion; 60–300 wpm only | Remote pace is saved; leaving mid-run shows a partial summary; runs with jumps don't suggest a pace; 40–400 wpm | P2 | `backlog2_test` |
| U53 | J2 Write | Numbers, Thai, long pastes, Docs/WhatsApp paste, text files — T3/T7/W5/W7/W12 | Estimates short; Thai flagged as one sentence; typing lag; invisible clutter; no import | Long numbers count as more words; Thai/Lao/Khmer/Burmese split on spaces; analysis waits for a pause on very long scripts; Paste cleans text; **Import a text file** | P2 | `backlog2_test` |
| U54 | J5 Float | Android Go, Xiaomi/Samsung/Oppo battery limits, pace sync, screen sleep — O6/F2/F9/F12 | Float silently failed or was killed; pace not kept; screen dimmed | Low-RAM phones are told to use Record; one-time per-brand tips with *Open settings*; pace set in the window reaches the app; screen stays on while floating | P1 | manual |
| U55 | All | Settings — S1/S2/S3/O5 | No own preset; no reset; "phone language" unexplained; welcome script stuck in the old language | **Save as my setup**; **Reset all settings** (keeps pace); "Phone language · Español"; untouched welcome script follows the app language | P3 | `backlog2_test` |
| U56 | All | Large text, small targets, colour names — A1/A3/A6 | Untested at 200 %; 24 dp grips; swatches all "Text colour" | Checked on a 360 dp phone at 200 %; 48 dp grips; colours are named for screen readers | P1 | `backlog2_test` |
| U57 | All | Confidential client scripts — Y1 | Anyone with the phone could open them | Optional **App lock** (fingerprint, face or phone PIN) on open and after 30 s away | P1 | `backlog2_test` |
| U58 | Release | Play declarations, privacy policy, crash reports, QA — Q2/Q3/Q5/Q6 | Nothing written | `docs/STORE_RELEASE.md` and `docs/PRIVACY.md` | P0 | docs |
| U14 | J5 Float | "Display over other apps" denied | — | Already handled: explains the permission | — | existing |
| U15 | J4 Settings | Phone language not English/Indonesian | — | Already handled: falls back to English | — | existing |

## Known limitations (not fixed)

- Pulling down the iOS Control Center during a take makes the app *inactive*, which stops
  and saves the recording (U4 behaviour). Recording cannot continue in the background on iOS.
- App lock (U57) hides the app; scripts are not encrypted on disk.
- Free-space and battery checks (U44) estimate size per minute by quality; real bitrates vary
  by phone.
- Tap-to-focus (U47) maps the tap over the whole screen, so with a letterboxed preview the
  point is approximate near the bars.
- The floating window's secure flag (U35) is set by reaching into the overlay plugin's window;
  if a plugin update renames its fields, Float still works but is no longer hidden from
  recordings. Check on a device after upgrading `flutter_overlay_window`.

More scenarios — documented, not fixed yet — are in [UNHAPPY_PATHS_BACKLOG.md](UNHAPPY_PATHS_BACKLOG.md).
