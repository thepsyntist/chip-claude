---
description: Run the project's housekeeping cadence if defined; else list what to check
---

Run the current project's housekeeping pass against `./memory/feedback_housekeeping_schedule.md`. Deterministic structure — same checklist logic every time, not re-derived from prose.

## Process

### 1. Pre-flight
- Read `./memory/feedback_housekeeping_schedule.md`. If it doesn't exist → STOP. Print: "No memory/feedback_housekeeping_schedule.md — not a scaffolded project? Run /chip-init first."
- Read the file's "## Last housekeeping" section to find the last-run date (or the scaffold placeholder due-date if none has run yet).

### 2. Determine overdue
Compare today's date against the cadence stated at the top of the file (the scaffold default is "every ~15 days"; respect whatever the project's own file says if it's been edited).
- Not yet due → report that and stop. Don't run checks early just because you were asked.
- Overdue → proceed.

### 3. Run the checklist
Walk every section under "## What to check" in the file (File weight, Security checklist, Code efficiency, Dependency / supply chain, and any project-specific sections added since scaffold).

For each item:
- **Pure read/report** (line counts, grep for patterns, checking for unpinned deps) → just do it, note the finding.
- **Would require an edit** (removing dead code, pinning a version, extracting a handler) → list the finding and what the fix would be; do NOT make the edit without asking first.

### 4. Update the schedule file
Replace the "## Last housekeeping" line with today's date and a one-line summary of what ran. Do not touch the checklist sections themselves unless the user asks you to add a new check.

### 5. Report
One dense line per checklist item: clean / N findings (with file:line). End with the overdue-or-not verdict from step 2 and today's date written back.

### 6. Stop
Do not commit. Do not push.
