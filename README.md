# chip-claude

A Claude Code framework: scaffolding, commands, skills, agents, hooks, and prompt templates for building **your** Claude Code setup. Open-source-friendly — no personal content in the repo.

## What it gives you

- **`/chip-init`** — scaffold any new project with a standard structure (CLAUDE.md, memory/, docs/, .claude/, .gitignore). Asks project type + description, drops opinionated templates, prints TODOs.
- **Project templates** — generic `memory/` (MEMORY.md, ROADMAP.md, session-archive.md, feedback_housekeeping_schedule.md), `docs/` (decisions.md, known-invariants.md, optional api-contracts / ui-patterns / etc.), `.claude/settings.json`, `.gitignore`.
- **`CLAUDE.template.md`** — a starter you copy to `~/.claude/CLAUDE.md` and fill in with how **you** want Claude to work.
- **Prompts** for onboarding fresh Claude instances, mining active sessions for preferences you haven't written down, auditing your personal CLAUDE.md.
- **Agents** — reusable subagents in `agents/`, linked in globally. Ships with `reviewer` (independent, read-only code review against whatever `CLAUDE.md` rules are loaded).
- **Install scripts** that link framework pieces into `~/.claude/` (symlinks on macOS/Linux, junctions on Windows) and leave your personal CLAUDE.md alone.

## What it does NOT do

- Does not ship with anyone's personal CLAUDE.md. The repo is a framework; your rules are yours.
- Does not overwrite `~/.claude/CLAUDE.md`. Install checks for it and skips.
- Does not include memory / feedback files specific to any one person's projects.

## Layout

```
chip-claude/
├── CLAUDE.template.md          starter for your personal ~/.claude/CLAUDE.md
├── settings.template.json      settings skeleton (perms, effort, update channel)
├── mcp.template.json           MCP server config (pinned) for .mcp.json / claude mcp add
├── install.sh / install.ps1    links framework into ~/.claude/ (symlinks on macOS/Linux, junctions on Windows; leaves your CLAUDE.md alone)
├── agents/                     global subagents — includes `reviewer` (read-only code review)
├── skills/                     cross-project skills (extend as needed)
├── commands/                   slash commands (includes /chip-init)
├── hooks/                      event hook scripts (extend as needed)
├── templates/                  /chip-init project scaffold templates
└── prompts/
    ├── bootstrap.md            paste into a fresh Claude on a new machine → installs + scaffolds in one chat
    ├── onboard-new-claude.md   wrapper to carry your CLAUDE.md into any stateless Claude (claude.ai, etc.)
    ├── extract-feedback.md     mine an active Claude session for preferences you haven't written down
    └── critique-claude-md.md   audit your personal CLAUDE.md for gaps / over-specification
```

## Your personal stuff — where it lives

Your `~/.claude/CLAUDE.md` is **yours** — the framework never touches it. Options, simplest to most portable:

- **Standalone** at `~/.claude/CLAUDE.md` (simplest; single machine).
- **Private repo + `@import` stub** (recommended for multi-machine). Keep the real rules in a separate private repo, and make `~/.claude/CLAUDE.md` a one-line stub that imports them:
  ```
  @~/path/to/your-private-repo/CLAUDE.md
  ```
  Edit/commit/push from any machine, `git pull` to sync — the stub auto-loads the updated content next session. On Windows this beats a file symlink: `@import` needs no admin / Developer Mode, and it survives `git pull` (hardlinks don't).
- **Private repo + symlink** — same idea via a symlink (macOS/Linux, or Windows with Developer Mode).
- **`personal/` dir inside this repo** (gitignored), imported or symlinked into `~/.claude/CLAUDE.md`.

The framework doesn't prescribe; it just promises not to touch `~/.claude/CLAUDE.md`.

## Install — three flows

### 1. First time ever on a machine (Claude-driven, recommended)
Open a Claude Code session in any directory. Paste `prompts/bootstrap.md`. Claude will:
1. Ask where the framework repo is (GitHub URL or local path).
2. Clone if needed, run `install.sh`.
3. Help you set up `~/.claude/CLAUDE.md` (copy template / symlink an existing file / skip).
4. Optionally scaffold the current project.

One conversation. No manual terminal steps beyond paste + answer.

### 2. Scripted install
```bash
bash install.sh        # macOS / Linux / Git Bash
# or
pwsh install.ps1       # Windows PowerShell
```

Links `agents/`, `skills/`, `commands/`, `hooks/` into `~/.claude/`, and `templates/` into `~/.claude/chip-templates/` — symlinks on macOS/Linux, directory junctions on Windows (no admin / Developer Mode needed). Does **not** touch `~/.claude/CLAUDE.md`. Prints a hint if you don't have one yet.

Merge `settings.template.json` into `~/.claude/settings.json` by hand. MCP servers don't go in settings.json — put them in `.mcp.json` / `~/.claude.json` or use `claude mcp add` (see `mcp.template.json` for a pinned context7 example).

### 3. New project on an already-set-up machine — just say it
In a fresh Claude Code session in a new repo:

> setup chip claude for project mynewthing, it's a backend service that does X

Your personal CLAUDE.md's natural-language triggers map that phrase to `/chip-init` and Claude runs it.

## If you fork this

- Rename the repo to match your identity (e.g. `alice-claude`).
- Rename `/chip-init` in `commands/` if you want (and update the natural-language triggers in your personal CLAUDE.md).
- Replace `~/.claude/CLAUDE.md` with your own. Don't commit it here.
- The `chip-templates` symlink name is hardcoded in `install.sh` / `install.ps1` and referenced in `commands/chip-init.md` + `prompts/bootstrap.md` — rename those too if you rebrand the prefix.

## Mining your working style

Run `prompts/extract-feedback.md` periodically in active Claude sessions — it dumps corrections and patterns you haven't codified yet. Fold the output back into your personal CLAUDE.md. Repeat every ~15 days or whenever something feels "we keep having this conversation."
