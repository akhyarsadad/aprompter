# APrompter — Product brief & user journeys

## Who we build for

| Persona | Context | What hurts today |
|---|---|---|
| **Short-form creator** (TikTok / Reels / Shorts) | Films 3–10 vertical clips a week on a phone, front camera, handheld or ring light. | Forgets lines, does 8+ takes, videos run over 60 s, looks away from the lens to read notes. |
| **Educator / explainer** (YouTube, courses) | Longer 3–10 min pieces, tripod, phone 1–2 m away. | Text too small at distance, loses place between sections, re-records whole video for one mistake. |
| **Brand / UGC creator** | Scripts from a client brief, product reviews, ad reads. | Must hit an exact length (15 / 30 s), must say key phrases word-for-word. |

**Job to be done:** *"When I have an idea for a video, help me turn it into words I can say naturally, on time, while looking into the lens — in as few takes as possible."*

## The creator workflow

```
 Idea ──▶ Write ──▶ Polish & time ──▶ Rehearse ──▶ Set up ──▶ Record ──▶ Retake ──▶ Done
          (J1)        (J2)              (J3)         (J4)       (J5)      (J6)       (J7)
```

---

### J1 — From idea to first draft

> *"I know what I want to say, I just need a structure."*

1. Creator taps **New script**.
2. Picks a **template** that matches the format: *Blank*, *Hook → Value → CTA*, *Tutorial (steps)*, *Product review*, *Storytime*.
3. Picks a **target length**: 15 s, 30 s, 60 s, 90 s, 3 min, or none.
4. Template pre-fills **sections** (`# Hook`, `# Value`, `# CTA`) with prompts written as notes (`// what problem…`), so the blank page is never blank.
5. They write or **paste** text (often drafted in Notes / ChatGPT / a client brief).

**Success:** a first draft exists within 2 minutes.

### J2 — Polish & fit the time budget

> *"Is this too long? Where do I breathe?"*

1. While typing, a live bar shows **words · spoken time · target**, e.g. `142 words · 0:57 / 1:00` — green when on target, orange when short, red when over ("8 s over — cut ~20 words").
2. A **readability hint** flags long sentences that are hard to say in one breath.
3. A writing toolbar inserts teleprompter markup without typing symbols:
   - **Section** `# Hook` — shows as a cue on the prompter and lets you jump there.
   - **Emphasis** `*word*` — highlighted so you punch the word.
   - **Pause** `[pause]` — a visible beat marker.
   - **Note** `// smile, hold product up` — direction for you; small and dimmed on the prompter, not counted as spoken.
4. Status moves **Draft → Ready**.

**Success:** script lands within ±10 % of target before the camera ever turns on.

### J3 — Rehearse & find my pace

> *"How fast should it scroll? I don't think in pixels."*

1. Creator opens **Rehearse** (full-screen prompter, no camera).
2. Speed is set in **words per minute** (the way people speak), not pixels — so changing the font size never changes the pace.
3. Quick pace presets: **Calm 120 · Natural 150 · Energetic 180 wpm**, plus fine −/+ in steps of 10.
4. **Fit to target**: one tap sets the wpm that finishes the script exactly in the target time.
5. While reading, they see **progress** and **time remaining**.
6. At the end, a summary: *"You took 1:04 for 142 words → 133 wpm. Use 130 wpm as your pace?"*

**Success:** the creator owns a personal pace that is reused for every script.

### J4 — Set up the prompter for the shot

> *"Handheld selfie vs. tripod across the room need totally different text."*

1. Settings open as a sheet with a **live preview** of the text.
2. One-tap **setups**: *Handheld selfie* (medium text, prompter near lens), *Tripod / distance* (large text, taller prompter), *Teleprompter glass* (mirrored, full screen, solid background).
3. Fine tuning grouped as **Pace** (wpm, countdown), **Text** (size, spacing, alignment, color), **Layout** (prompter height, background darkness, reading guide, mirror).
4. Settings are remembered.

### J5 — Record

> *"I want to look at the lens, not at my notes."*

1. **Record** opens the front camera with the script directly under the lens.
2. Countdown → recording and scrolling start together.
3. Hands-free control: tap the text to pause; a **Bluetooth remote / keyboard** works too (Space/Enter/PageDown = play-pause, PageUp = back one section, ↑/↓ = faster/slower).
4. Stop → the video is saved to the gallery; the script's **take count** goes up and status becomes **Recorded**.
5. On Android, **Float** shows the prompter over TikTok / Instagram / CapCut's own camera instead.

### J6 — Retake one part

> *"I messed up the CTA. I don't want to redo the whole thing."*

1. Open **Sections** and jump straight to `# CTA` (or press PageUp on the remote).
2. Record just that section; the editor cuts it together later.

**Success:** a mistake costs one section, not a full take.

### J7 — Organise the library

1. Home shows scripts with **status** (Draft / Ready / Recorded), target length and takes.
2. Filter by status and search by title or text, so "what do I film today?" = *Ready* filter.

---

## Scope of this release

| Journey | Shipped |
|---|---|
| J1 Templates + target length | ✅ |
| J2 Live timing, readability hint, markup toolbar, status | ✅ |
| J3 Speed in wpm, pace presets, fit-to-target, progress/remaining, rehearsal summary | ✅ |
| J4 Setup presets, grouped settings, live preview | ✅ |
| J5 Camera record, countdown, remote/keyboard control, take count, Android float | ✅ |
| J6 Section jump (sheet + remote) | ✅ |
| J7 Status filter + search | ✅ |

### Release 2 additions

| Area | Shipped |
|---|---|
| J5 Pinch-to-resize text while reading, video quality, auto-stop at script end, haptic countdown | ✅ |
| J7 Duplicate, share, copy as caption, undo delete | ✅ |
| Bahasa Indonesia + English UI and templates | ✅ |
| CI builds an installable Android APK on every push | ✅ |

**Later:** voice-follow scrolling (speech recognition), cloud sync, import from Google Docs, AI rewrite to fit time, per-script settings.

## Success metrics

- Time from *New script* → first recording.
- Takes per published video (goal: down).
- % of scripts that land within ±10 % of target length.
- Rehearse → Record conversion.
