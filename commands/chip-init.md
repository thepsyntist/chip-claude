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

Run the script — one Bash call, quote the description:

```bash
bash ~/.claude/chip-templates/scaffold.sh <project_type> "<one-line description>"
```

It substitutes all placeholders (`{{project_name}}` from the cwd basename, `{{project_description}}`, `{{project_type}}`, `{{today}}`, `{{today_plus_15}}`, `{{framework_cmd}}` from `framework.config`, `{{toolchain_perms}}` detected from files in the target cwd), writes the always-create set plus preset doc extras per project type, and handles `.gitignore` (append the `# Claude Code artifacts` marker block if missing, create the file if absent). Deterministic — same inputs, same output, on any model.

**Fallback (script missing — e.g. an old install predates it):** read each template with the Read tool, substitute the seven placeholders above by hand (`{{framework_cmd}}` defaults to `chip-init` if `framework.config` isn't present; `{{toolchain_perms}}` defaults to empty — `"allow": []`), Write to the target path.

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

Doc presets are a directory convention: any `docs/<project_type>/*.md` in the template dir is copied into `./docs/`; `web-fullstack` unions `docs/backend/*` + `docs/frontend/*`. Ships with `backend` (api-contracts.md, error-responses.md, systems-catalog.md) and `frontend` (ui-patterns.md, design-philosophy.md) — add a `docs/<type>/` directory to give another project type its own extras, no script change needed. `.gitignore`: if it exists and lacks the `# Claude Code artifacts` marker, append `gitignore-additions.txt`; if missing, write it as the new file.

### 4. Report

Print the script's own output verbatim — it already reports the created tree and the TODO list in the format below. If you ran the fallback path, reproduce this shape by hand:

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
