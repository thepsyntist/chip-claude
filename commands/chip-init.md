---
description: Scaffold a standard project (CLAUDE.md, memory/, docs/, .claude/, .gitignore)
---

Initialize the current project with the framework's standard structure. Templates live at `~/.claude/chip-templates/` (symlinked from `<repo>/templates/`).

## Process

### 1. Pre-flight
- `ls` the current working directory.
- If `CLAUDE.md` already exists at root → STOP. Print one line: "CLAUDE.md already exists — aborting. Delete or rename it first if you want to re-scaffold."
- If the dir is empty AND not a git repo → flag it: "Not a git repo. Want me to run `git init` first, or proceed without?" Wait for answer.
- Detect project type hints from files present:
  - `package.json` → JS/TS. Check `dependencies` for Next.js / React / Vue / Express / Vite to guess frontend/backend/fullstack.
  - `pyproject.toml` / `requirements.txt` → Python backend likely.
  - `Cargo.toml` → Rust.
  - `go.mod` → Go.
  - `apps/` or `packages/` → monorepo (treat as fullstack).

### 2. One load-bearing question
Ask the user exactly one message:

```
Detected: <inferred type or "empty repo">.

1. Project type? Pick one: `web-fullstack` / `backend` / `frontend` / `cli` / `library` / `other`
2. One-line description (what does this project do?)
```

Wait for the answer. Do not proceed without both.

### 3. Scaffold

Read each template with the Read tool, substitute placeholders, Write to the target path.

**Placeholders** (apply to every template):
- `{{project_name}}` → basename of the current working directory
- `{{project_description}}` → one-liner from step 2
- `{{project_type}}` → answer from step 2
- `{{today}}` → today's date in `YYYY-MM-DD` format
- `{{today_plus_15}}` → today + 15 days in `YYYY-MM-DD` format

**Always create:**
| Template | Target |
|---|---|
| `~/.claude/chip-templates/CLAUDE.md` | `./CLAUDE.md` |
| `~/.claude/chip-templates/memory/MEMORY.md` | `./memory/MEMORY.md` |
| `~/.claude/chip-templates/memory/ROADMAP.md` | `./memory/ROADMAP.md` |
| `~/.claude/chip-templates/memory/session-archive.md` | `./memory/session-archive.md` |
| `~/.claude/chip-templates/memory/feedback_housekeeping_schedule.md` | `./memory/feedback_housekeeping_schedule.md` |
| `~/.claude/chip-templates/docs/common/decisions.md` | `./docs/decisions.md` |
| `~/.claude/chip-templates/docs/common/known-invariants.md` | `./docs/known-invariants.md` |
| `~/.claude/chip-templates/claude-settings.json` | `./.claude/settings.json` |

**If `project_type` is `backend` or `web-fullstack`:** also copy `docs/backend/*` into `./docs/` (api-contracts.md, error-responses.md, systems-catalog.md).

**If `project_type` is `frontend` or `web-fullstack`:** also copy `docs/frontend/*` into `./docs/` (ui-patterns.md, design-philosophy.md).

**.gitignore handling:**
- If `./.gitignore` exists: read it, check if it contains the marker `# Claude Code artifacts`. If not, append the content of `~/.claude/chip-templates/gitignore-additions.txt`.
- If `./.gitignore` does not exist: write the template content as the new file.

### 4. Report

Print a tree of what was created:

```
Scaffolded <project_name> (<project_type>):

  CLAUDE.md
  memory/
    MEMORY.md
    ROADMAP.md
    session-archive.md
    feedback_housekeeping_schedule.md
  docs/
    decisions.md
    known-invariants.md
    <backend or frontend files as applicable>
  .claude/
    settings.json
  .gitignore (updated)

TODOs to fill in before the next session:
- CLAUDE.md: Architecture, Quick Start, Key Rules, File Map
- memory/MEMORY.md: Architecture, Key Rules, Key File Paths
- memory/ROADMAP.md: Stages Overview, Next Actions
- memory/feedback_housekeeping_schedule.md: File weight thresholds (once structure stabilizes)
- docs/decisions.md: Any decisions already made before scaffold
- docs/known-invariants.md: First invariants as they surface
```

### 5. Stop

Do not commit. Do not push. The user reviews and commits themselves.
