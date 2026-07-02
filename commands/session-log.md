---
description: Append a session log entry to memory/ROADMAP.md, archiving overflow past 5
---

Log the current session into the project's `memory/ROADMAP.md`, in its existing format. Deterministic structure — the entry shape doesn't drift session to session.

## Process

### 1. Pre-flight
- Read `./memory/ROADMAP.md`. If it doesn't exist → STOP. Print: "No memory/ROADMAP.md — not a scaffolded project? Run /chip-init first."
- Find the `## Session Log` heading and every `### Session N (...)` entry beneath it. Let `N_max` be the highest N found (0 if none — e.g. the file still has the scaffold placeholder line and no real entries yet).

### 2. Compose the entry
Use the exact template already embedded in the file's `## Session Log` section:

```
### Session <N_max + 1> (<today, YYYY-MM-DD>) -- <one-line focus>
**Branch:** <current git branch, via `git branch --show-current`; "main" if not a repo>
- <bullet per notable change this session — dense, not a transcript>
**Files changed:** <files touched this session, comma-separated>
```

Derive the focus line and bullets from this session's actual work. Ask the user only if the focus is genuinely ambiguous (e.g. a long, multi-topic session) — otherwise infer and flag the inference in your final report, don't block on a question.

### 3. Insert
- If the placeholder line `_Scaffolded ... the first real working session is Session 1._` is still present, replace it with the new entry (this session IS Session 1).
- Otherwise, insert the new entry directly under the `## Session Log` heading (and its HTML-comment template block, if still present), above all existing `### Session` entries — newest on top.

### 4. Archive overflow
Count `### Session` entries after insertion. If more than 5:
- Take the oldest entries beyond the 5 most recent.
- Append each (oldest last, in original chronological order) under the `---` divider at the bottom of `./memory/session-archive.md`.
- Remove them from `ROADMAP.md`, leaving exactly the 5 most recent.

### 5. Report
One line: which session number was logged, whether anything was archived, and any inferred details the user should double check.

### 6. Stop
Do not commit. Do not push.
