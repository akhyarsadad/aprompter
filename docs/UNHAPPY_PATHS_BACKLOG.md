# APrompter — Unhappy-path backlog (all personas)

**Status:** rows marked ✅ are fixed — see [`UNHAPPY_PATHS.md`](UNHAPPY_PATHS.md)
(U20 onwards) for what changed and how it is verified. Everything else is still open.

How to read the tables:

- **Sev** — **P0** data loss, app unusable, or store rejection · **P1** blocks the job or
  misleads the creator · **P2** real friction · **P3** polish.
- **Evidence** — **Code**: confirmed by reading the current code · **Device**: depends on
  phone/OS behaviour, needs a test on real hardware · **Gap**: a capability the app does
  not have.
- **Direction** is a suggestion for later, not a decision.

---

## 1. Personas

| # | Persona | Context | Most exposed to |
|---|---|---|---|
| **P1** | **Short-form creator** | TikTok/Reels/Shorts, handheld selfie, 15–60 s, many takes per day | Hashtags vs markup, remotes, Float on OEM phones, framing |
| **P2** | **Educator / long-form YouTuber** | 5–30 min scripts, tripod, landscape, 4K | Long scripts, storage/heat, landscape lock, targets > 3 min |
| **P3** | **Brand / UGC creator** | Client scripts, exact 15/30 s ads, NDAs | Timing accuracy, confidentiality, take review |
| **P4** | **First-time creator** | Low tech confidence, nervous on camera | Permissions, jargon, discoverability, accidental loss |
| **P5** | **Pro with teleprompter rig** | Beam-splitter glass, tablet/2nd phone, Bluetooth remote | Landscape/iPad, remotes, mirror, controls behind glass |
| **P6** | **Multilingual creator** | Script language ≠ UI language, RTL, CJK, code-switching | Direction detection, timing estimates, fonts, casing |
| **P7** | **Live streamer / video caller** | Float over TikTok Live, Zoom, Meet, Instagram Live | Overlay captured in stream, can't scroll back, remote |
| **P8** | **Speaker / presenter / faith leader / podcaster** | Long continuous reading, stage or desk, second device | Screen sleep, pacing pauses, landscape, remote |
| **P9** | **Accessibility needs** | Low vision, dyslexia, screen reader, motor, stutter | Font scaling, touch targets, labels, fixed-speed pressure |
| **P10** | **Low-end device / emerging market** | Old Android, 2–3 GB RAM, low storage, OEM skins, Android Go | Overlay blocked, jank, storage full, battery |
| **P11** | **Privacy-sensitive / enterprise** | Confidential scripts, shared or managed device | Unencrypted storage, cloud backup, clipboard, gallery sync |
| **P12** | **Team / agency** | Writer ≠ talent, approvals, several devices | No sync, no import/export, no versions |
| **P13** | **Tablet & foldable user** | iPad, Android tablet, Fold/Flip | Orientation lock, multitasking, resizing, cover screen |
| **P14** | **Teen creator** | Young user, parent's phone | Privacy, accidental sharing, store age policies |

---

## 2. First run & onboarding

| ID | Who | What goes wrong | What happens today | Sev | Evidence | Direction |
|---|---|---|---|---|---|---|
| O1 | P4 | Taps **Record** first; OS asks for camera + mic with no context | Reflex "Don't allow" → error view; second ask needs system Settings on iOS | P1 | Code | Explain why before the OS prompt |
| O2 | P4 | Doesn't know `#`, `//`, `*`, `[pause]` | Only discoverable via toolbar and editor hint | P2 | Gap | 20-second interactive tour / sample script |
| O3 | P4 | "wpm" / "words per minute" jargon | Unclear what number to choose | P3 | Gap | Plain labels ("slow · normal · fast") first, numbers second |
| ✅ O4 | P4, P1 | Taps **Float** expecting it to work on iPhone | Button hidden on iOS with no explanation | P2 | Code | Show it disabled with "Not possible on iPhone — use Record" |
| O5 | P4 | Welcome script is in the phone's language at first run; user later switches app language | Welcome script stays in the old language | P3 | Code | Offer to re-create sample in new language |
| O6 | P10 | Float tapped on **Android Go** | Overlay permission doesn't exist on Go devices; settings screen may not open or permission never granted | P1 | Device | Detect low-RAM/Go and explain Float is unavailable |

## 3. Writing & editing

| ID | Who | What goes wrong | What happens today | Sev | Evidence | Direction |
|---|---|---|---|---|---|---|
| ✅ W1 | P1, P3 | Writes **hashtags** on their own line (`#fyp #viral`) | Line becomes a **section cue**, is excluded from timing and from "Copy as caption" | P1 | Code | Only treat `# ` (hash + space) as a section; or `##` |
| ✅ W2 | P1 | Uses `*` as bullets or in maths (`2*3`, `* tip`) | Text between asterisks turns into emphasis; asterisks vanish | P2 | Code | Require word boundaries; escape `\*` |
| ✅ W3 | P4 | Types Markdown `**bold**` | Renders with stray `*` on both sides | P3 | Code | Accept `**…**` as emphasis |
| ✅ W4 | P1, P4 | Select-all + delete by accident (or bad paste) | **Autosave overwrites after 1 s**; no undo history, no versions | P0 | Code | Keep last N versions per script / undo across saves |
| W5 | P2 | Pastes a 20–50k-word script | Word count, long-sentence scan and JSON save run on every keystroke → typing lag; whole library rewritten each second | P1 | Code | Debounce analysis, isolate parsing, per-script storage |
| ✅ W6 | P2 | Needs a 5/10/20-minute target | Targets stop at 3 min | P1 | Code | Custom target input |
| W7 | P3 | Pastes from Google Docs/Word/WhatsApp | Bullets, numbering, tabs, smart quotes, zero-width chars come through as-is; WhatsApp `*bold*` becomes emphasis | P2 | Code | Clean-paste option |
| ✅ W8 | P3 | Edits a script that is **currently floating** | Overlay keeps showing the old text until Float is pressed again | P2 | Code | Push updates to the overlay |
| ✅ W9 | P4 | `[ pause ]`, `[Pause.]`, `(pause)` | Not recognised; read out as words and timed | P3 | Code | Looser pause syntax |
| ✅ W10 | P1 | Empty `#` line | Section titled "Section n" appears in the list | P3 | Code | Ignore empty headings |
| ✅ W11 | P4 | Leaves the editor via the home gesture mid-sentence | Saved by autosave/lifecycle — OK; but **no "saved" feedback** so users worry | P3 | Code | Subtle "Saved" indicator |
| W12 | P12 | Writer edits on laptop, talent reads on phone | No import/export, no sync; copy-paste through chat | P1 | Gap | Import .txt/.docx, share link, cloud sync |
| W13 | P3 | Client wants tracked changes / approval | No versions or comments | P2 | Gap | Version history |
| W14 | P6 | Writes in one language, UI in another, spell-check underlines everything | Uses system keyboard language; no per-script language | P3 | Device | Per-script language hint for keyboard/timing |

## 4. Timing & pace

| ID | Who | What goes wrong | What happens today | Sev | Evidence | Direction |
|---|---|---|---|---|---|---|
| ✅ T1 | P3 | Many `//` notes, `#` headings and blank lines | Total scroll time = spoken words ÷ wpm, but notes also take scroll height → **spoken lines scroll faster than the set wpm** | P1 | Code | Time-weight only spoken lines; skip notes at speed |
| ✅ T2 | P3 | 15 s ad: "Fit to 0:15" needs > 300 wpm | Fit silently clamps to 300; timing bar still says over | P1 | Code | Say "can't fit — cut N words" instead |
| T3 | P3 | Numbers, dates, URLs, prices ("$1,299", "2025", "@brand") | Count as one word; spoken as several → estimate too short | P2 | Code | Expand numbers/symbols for timing |
| ✅ T4 | P1 | `[pause]` markers | Add no time; real pauses make takes run long | P2 | Code | Give a pause ~0.7 s |
| T5 | P5, P8 | Pace changed with **remote arrow keys** | Not saved; next session reverts | P2 | Code | Persist from keyboard too |
| T6 | P6 | Chinese/Japanese/Thai estimates use fixed weights | Off for fast/slow speakers or dense kanji; Rehearse calibrates wpm but weights stay | P2 | Code | Per-language calibration |
| T7 | P6 | Thai/Lao text with no `.` | Whole paragraph flagged as one "long sentence" | P3 | Code | Split on spaces for those scripts |
| T8 | P4 | Rehearse stopped before the end | No summary at all | P3 | Code | Summary on early stop too |
| T9 | P4 | Drags text forward while rehearsing | Read time shortens → suggests an unrealistic wpm (clamped 300) | P2 | Code | Ignore runs with manual jumps |
| T10 | P9 | Very slow readers (< 60 wpm) or very fast (> 300) | Hard limits | P3 | Code | Wider range behind "advanced" |
| T11 | P8 | Natural pauses for laughter/applause | Fixed-speed scroll keeps going | P2 | Gap | Voice-follow scrolling |

## 5. Prompter reading (Rehearse, Record, Float)

| ID | Who | What goes wrong | What happens today | Sev | Evidence | Direction |
|---|---|---|---|---|---|---|
| R1 | P1 | Grip of the phone touches the screen edge | Counts as a tap → pauses mid-take | P2 | Code | Edge dead-zone / pause via double-tap option |
| R2 | P4 | Picks **black text** colour | Black text on dark background/camera = invisible | P2 | Code | Auto-contrast or disable unsafe combos |
| R3 | P1 | Filming outdoors in sunlight | No brightness boost; low contrast | P2 | Gap | Max-brightness while prompting |
| R4 | P2, P5, P8 | Wants **landscape** (tripod, rig, tablet) | App is locked to portrait | P1 | Code | Landscape support for Rehearse/Record |
| ✅ R5 | P7 | Loses place in **Float** | Drags move the window; no manual scroll and **no section jump** in Float — only restart | P1 | Code | Scroll buttons + sections in overlay |
| R6 | P5 | Section names upper-cased | Turkish `i` → `I` (should be `İ`); other casing quirks | P3 | Code | Locale-aware upper-case or none |
| R7 | P6 | Line starts with an English brand then Arabic ("iPhone الجديد…") | Direction taken from first letter → laid out left-to-right | P2 | Code | Majority-direction detection |
| R8 | P9 | Dyslexia | No dyslexia font, letter spacing, line focus/dimming | P2 | Gap | Reading-comfort options |
| R9 | P5 | Mirror mode | Text mirrored; tap zones and on-screen controls are not, and are hard to reach behind glass | P2 | Code | Hide controls in mirror mode; rely on remote |
| R10 | P8 | Reading on a second phone/tablet for 30 min | Screen stays on (good) but continuous 60 fps repaint drains battery; no "dim but on" | P2 | Device | Lower repaint cost |
| R11 | P10 | Low-end GPU | Fade mask + per-frame scroll may stutter | P2 | Device | Performance mode (no fade) |
| R12 | P1 | Pinch accidentally while holding with two fingers | Font size jumps; saved immediately | P3 | Code | Lock pinch while recording |

## 6. Recording (camera)

| ID | Who | What goes wrong | What happens today | Sev | Evidence | Direction |
|---|---|---|---|---|---|---|
| ✅ C1 | P1 | Countdown ends while the camera is still opening/switching | **Recording silently doesn't start** | P1 | Code | Wait for camera, or show a message |
| C2 | P1 | Preview is cropped to fill the screen | **What you see ≠ what is recorded** (extra area recorded at the sides/top) | P1 | Code | Show the true recording frame / 9:16 guides |
| C3 | P1, P3 | Wants to watch the take before keeping it | No in-app playback; every take goes to the gallery | P1 | Gap | Review screen: keep / retake / delete |
| C4 | P3 | Which take belongs to which script? | Takes only counted, not linked or listed | P2 | Gap | Takes list per script |
| C5 | P2, P3 | Bluetooth/USB-C/lavalier mic | No input selection; no audio level meter → silent or wrong-mic takes go unnoticed | P1 | Gap/Device | Mic picker + level meter |
| C6 | P2 | 20-minute 4K take | Several GB; storage can fill mid-take; heat throttling/camera shutdown; no warnings | P1 | Device | Free-space + duration estimate, thermal warning |
| C7 | P10 | Storage almost full | Recording may fail late; save rescue sheet appears but share may also fail | P1 | Device | Pre-check free space |
| C8 | P1 | Phone call / notification shade during a take | Take is stopped and saved (by design) — creator loses the moment | P2 | Code | Offer "resume from section" after return |
| C9 | P1 | Front-camera preview mirrored, saved video not | Text on clothing reads backwards in preview only; confuses beginners | P3 | Device | Explain or offer mirrored export |
| C10 | P2 | No zoom, focus/exposure lock, grid, stabilisation | Exposure hunts, framing guesswork | P2 | Gap | Basic camera controls |
| C11 | P2 | 4K selected on a front camera that can't do 4K | Plugin silently uses a lower resolution; label still says 4K | P3 | Device | Show actual resolution |
| C12 | P1 | Ad-libs after the last line | Auto-stop cuts the take after 2 s | P2 | Code | Configurable tail / stop on remote |
| C13 | P5 | Can't jump sections **during** a take | Sections button disabled while recording | P3 | Code | Allow jumps, mark them |
| C14 | P1 | Camera busy (another app holds it) | Raw technical error text | P2 | Code | Friendly message |
| C15 | P1 | Low battery mid-take | Phone may shut down; partial file likely unrecoverable | P1 | Device | Battery warning before long takes |
| C16 | P1 | Do-not-disturb off | Banners/heads-up notifications distract while filming | P3 | Gap | Suggest/enable focus mode |
| C17 | P7 | iOS "Limited" photo access | Album save may fail → rescue sheet; message doesn't explain "limited" | P2 | Device | Explain and deep-link |

## 7. Float over other apps (Android)

| ID | Who | What goes wrong | What happens today | Sev | Evidence | Direction |
|---|---|---|---|---|---|---|
| ✅ F1 | P7, P11 | Screen recording / screen share / live stream | **The floating script is captured** and visible to the audience | P0 | Code | Mark the overlay window secure |
| F2 | P10, P1 | Xiaomi/Huawei/Oppo/Vivo/Samsung battery & "pop-up" restrictions | Overlay doesn't show or is killed mid-take | P1 | Device | OEM-specific guidance screen |
| F3 | P1 | Overlay covers the other app's record button | Touches on the overlay area don't reach the app below | P2 | Code | Click-through mode toggle |
| F4 | P1 | Other app shows a permission dialog while overlay is up | Android may block "screen overlay detected" or hide the dialog | P2 | Device | Auto-minimise on detection |
| F5 | P5, P7 | Bluetooth remote with Float | Keys go to the app below; overlay can't receive them | P1 | Code | Media-session/accessibility key capture |
| F6 | P1 | Must start TikTok recording and the prompter separately | Two taps; scripts and takes out of sync | P2 | Gap | Countdown-then-start helper |
| F7 | P1 | Drags the window partly off-screen | Can get "lost"; only corrected on next open | P2 | Code | Clamp on drag end; recall button in notification |
| F8 | P13 | Rotates or unfolds the phone while floating | Window keeps old pixel size/position | P2 | Device | Recompute on configuration change |
| F9 | P7 | Changes pace in the overlay | Not saved back to the app | P3 | Code | Sync settings both ways |
| F10 | P4 | Can't find how to stop the overlay | Only the ✕ in the window; notification has no action | P2 | Code | "Stop" action in the notification |
| F11 | P10 | Notification permission denied (Android 13+) | Foreground service may be killed sooner on some OEMs | P2 | Device | Ask with explanation |
| F12 | P8 | Reading over a notes/slides app | No wakelock in the overlay → screen may dim/lock | P2 | Code | Keep-awake while playing |
| ✅ F13 | P14, P11 | Notification shows the script title | Visible in the notification shade (hidden on lock screen) | P3 | Code | Generic title option |

## 8. Remotes & keyboards

| ID | Who | What goes wrong | What happens today | Sev | Evidence | Direction |
|---|---|---|---|---|---|---|
| ✅ K1 | P1, P5 | Cheap Bluetooth **selfie remote** sends Volume Up | Not handled → nothing happens (or system volume changes) | P1 | Code | Map volume keys while prompting |
| ✅ K2 | P5 | Page-turner sends Next/Previous track, `B`, `.` (presentation keys) | Not handled | P2 | Code | Configurable key mapping |
| K3 | P5 | Opens a sheet (settings/sections), closes it | Keyboard focus may not return to the prompter until a tap | P2 | Device | Restore focus |
| K4 | P5 | Remote connected as keyboard | On some phones the on-screen keyboard hides in the editor | P3 | Device | Document / toggle |

## 9. Library, data & backups

| ID | Who | What goes wrong | What happens today | Sev | Evidence | Direction |
|---|---|---|---|---|---|---|
| ✅ D1 | All | Phone lost / reset / app uninstalled | Scripts only on device; OS backup may or may not restore them | P0 | Code/Device | Export/backup, optional cloud sync |
| ✅ D2 | All | Storage full when saving | Save result ignored → **silent data loss** | P0 | Code | Check write result, warn |
| D3 | P2, P3 | Hundreds of long scripts | Whole library is one JSON value rewritten on every change; slow start and saves | P1 | Code | Per-script storage / database |
| D4 | All | Corrupt-data backups created | Kept forever, never cleaned, **no way to restore** from the app | P2 | Code | Recovery screen + cleanup |
| ✅ D5 | P4 | Undo-delete snackbar disappears | Deletion permanent | P2 | Code | Recently-deleted bin |
| ✅ D6 | P3 | Marking status / recording a take | Bumps the script to the top (order changes unexpectedly) | P3 | Code | Separate "edited" from "touched" |
| ✅ D7 | P6 | Search "cafe" doesn't find "café"; Turkish İ/i | Plain lower-case match | P3 | Code | Accent/locale-insensitive search |
| ✅ D8 | All | Future data-format change | No schema version → migrations ad hoc | P2 | Code | Versioned storage |

## 10. Settings & personalisation

| ID | Who | What goes wrong | What happens today | Sev | Evidence | Direction |
|---|---|---|---|---|---|---|
| S1 | P2, P5 | One set of settings for all situations | Switching tripod ↔ handheld changes every script | P2 | Gap | Per-script or saved custom presets |
| S2 | P4 | Changes many settings, wants defaults back | Only position reset; no "reset all" | P3 | Code | Reset to defaults |
| S3 | P6 | App language chosen in-app and also in Android/iOS per-app settings | In-app choice wins silently; confusing | P3 | Code | Show "Phone language (Español)" and explain |
| S4 | P13 | Prompter box sized on a phone, used on unfolded tablet | Fractions keep it proportional but huge on tablets | P3 | Code | Per-device-class layout |

## 11. Language & scripts

| ID | Who | What goes wrong | What happens today | Sev | Evidence | Direction |
|---|---|---|---|---|---|---|
| L1 | All non-English | Translations not reviewed by native speakers | Possible awkward/incorrect wording | P1 | Gap | Native review before launch |
| L2 | P6 | iOS system permission prompts | English only | P2 | Code | Localised InfoPlist.strings |
| L3 | P6 | Languages not in the 28 (e.g. Amharic, Hausa, Burmese, Nepali, Greek) | English UI; scripts still work if the phone has fonts | P2 | Gap | Add by demand |
| L4 | P10, P6 | Old Android without fonts for a script (e.g. Myanmar/Zawgyi, some Indic) | Tofu boxes □□□ | P2 | Device | Bundle Noto fallbacks |
| L5 | P6 | Arabic/Persian users expecting native digits | Western digits everywhere | P3 | Code | Locale digits option |
| L6 | P6 | Plural forms simplified in some languages (e.g. Arabic few/many) | Grammatically off in a few strings | P3 | Code | Native review (L1) |
| L7 | P6 | Code-switching (Hinglish in Devanagari + Latin; Taglish) | Works, but timing weights don't fit mixed scripts | P3 | Code | Calibrate (T6) |
| L8 | P6 | Vertical Japanese/Chinese | Not supported | P3 | Gap | — |

## 12. Accessibility

| ID | Who | What goes wrong | What happens today | Sev | Evidence | Direction |
|---|---|---|---|---|---|---|
| A1 | P9 | System font size 150–200 % | Layouts only tested at 100 %; chips/controls may clip | P1 | Code | Test and fix at large scales |
| A2 | P9 | Screen reader (TalkBack/VoiceOver) | Colour swatches all read "Text colour"; prompter text not navigable; gestures conflict | P1 | Code | Semantics pass |
| A3 | P9 | Motor impairment | Move grip 72×24 and resize handle 36×36 are below 48 dp targets | P2 | Code | Larger targets |
| A4 | P9 | Stutter / speech differences | Fixed-speed scroll adds pressure | P2 | Gap | Voice-follow, "advance by line" mode |
| A5 | P9 | Reduced-motion preference | Ignored (scrolling is inherent) | P3 | Code | "Advance by line" mode |
| A6 | P9 | Colour-blind | Timing bar uses green/orange/red + text — OK; colour swatches unlabelled | P3 | Code | Name colours |

## 13. Devices, OS & performance

| ID | Who | What goes wrong | What happens today | Sev | Evidence | Direction |
|---|---|---|---|---|---|---|
| X1 | P13 | iPad: Info.plist allows all orientations, app forces portrait | Odd behaviour in Split View/Stage Manager; review risk | P1 | Code | Decide iPad orientation policy |
| X2 | P13 | Android split-screen / freeform | Portrait lock ignored; prompter tiny; untested | P2 | Device | Test multi-window |
| X3 | P13 | Foldable fold/unfold mid-take | Camera may restart; layout jumps | P2 | Device | Handle configuration change |
| X4 | P10 | Android 7–8 devices (minimum) | Untested camera/overlay paths | P2 | Device | Device test matrix |
| X5 | All | Android 15 edge-to-edge enforcement | Untested; content might sit under system bars | P2 | Device | Test on Android 15/16 |
| X6 | P10 | 2–3 GB RAM | Camera + overlay engine + app engine may be killed | P2 | Device | Memory profiling |
| X7 | P2 | Long sessions | Heat/battery from wakelock + camera + repaint | P2 | Device | Battery/thermal profiling |

## 14. Privacy & security

| ID | Who | What goes wrong | What happens today | Sev | Evidence | Direction |
|---|---|---|---|---|---|---|
| Y1 | P11, P3 | Confidential client scripts | Stored unencrypted on device; no app lock | P1 | Code | Optional encryption + biometric lock |
| Y2 | P11 | Device cloud backup (Android Auto Backup, iCloud) | Scripts may be uploaded to backups automatically | P2 | Code/Device | Let user opt out / exclude |
| Y3 | P3, P11 | Takes saved to the shared gallery | Google Photos/iCloud auto-upload unreleased brand content | P1 | Code | Option to keep takes inside the app |
| Y4 | P11 | "Copy as caption" | Text lands in clipboard history / cloud keyboards | P3 | Code | Note in UI |
| ✅ Y5 | P7 | Float captured in streams | See **F1** | P0 | Code | — |
| Y6 | P14 | Teens sharing scripts/videos | No guardrails; store age rating & privacy policy needed | P2 | Gap | Policy work |

## 15. Distribution & compliance

| ID | Who | What goes wrong | What happens today | Sev | Evidence | Direction |
|---|---|---|---|---|---|---|
| ✅ Q1 | — | Release APK signed with the **debug key** | Can't publish; installs can't be updated by a Play build | P0 | Code | Release keystore + Play App Signing |
| Q2 | — | Play review of `SYSTEM_ALERT_WINDOW` + `specialUse` foreground service | Rejection risk without a declaration/video | P1 | Code | Prepare declaration |
| Q3 | — | No privacy policy | Required by both stores for camera/mic apps | P0 | Gap | Write and host one |
| Q4 | — | Full photo-library access on iOS (album saving) | Reviewer may question; users may refuse | P2 | Code | Consider add-only without album |
| Q5 | — | No crash reporting/analytics | Field failures invisible | P2 | Gap | Privacy-respecting crash reports |
| Q6 | — | No accessibility/localisation QA before launch | Store listing in 28 languages without review | P2 | Gap | Pre-launch checklist |

---

## 16. Highest-impact items

1. **F1** — floating script visible in screen recordings and live streams (P0).
2. **W4** — accidental deletion is autosaved with no history (P0).
3. **D1 / D2** — no backup/export; failed saves are silent (P0).
4. **Q1 / Q3** — release signing and privacy policy block store release (P0).
5. **W1** — hashtags on their own line become sections (P1, very common for creators).
6. **C1** — countdown can end without recording (P1).
7. **C2** — preview framing differs from the recorded video (P1).
8. **C3 / C5** — no take review, no mic check (P1).
9. **K1** — Volume-key selfie remotes don't work (P1).
10. **R4 / X1** — no landscape; iPad orientation mismatch (P1).
11. **R5 / F5** — Float can't scroll back or take remote keys (P1).
12. **T1 / T2** — notes speed up spoken lines; Fit-to-target can silently fail (P1).
13. **F2 / O6** — Float on OEM skins and Android Go (P1).
14. **A1 / A2** — large fonts and screen readers untested (P1).
15. **Y1 / Y3** — confidentiality of scripts and takes (P1).

## 17. Device test matrix (to confirm "Device" items)

| Device class | Examples | Focus |
|---|---|---|
| Recent iPhone | iPhone 15/16 | Permissions (incl. Limited photos), Record, album save, remote keys |
| iPad | iPad 10th gen | Orientation, Split View, rig use |
| Recent Pixel | Pixel 8/9, Android 15/16 | Edge-to-edge, Float, per-app language |
| Samsung | Galaxy A-series, Fold/Flip | One UI battery limits, foldable, cover screen |
| Chinese OEM | Xiaomi/Redmi, Oppo, Vivo, Huawei | Overlay/pop-up permissions, background kills |
| Low-end | 2–3 GB RAM Android 8–10, Android Go | Overlay availability, jank, memory |
| Accessories | $3 selfie remote, page-turner, BT/USB-C mic | K1, K2, C5 |
| Settings | 200 % font, TalkBack/VoiceOver, RTL language | A1, A2, L-items |
