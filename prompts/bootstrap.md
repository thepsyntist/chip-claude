# Bootstrap — first-time install on a new machine

Paste this prompt into a fresh Claude Code session in **any** directory (new project or empty). Claude will: clone the framework, symlink it globally, help you set up your personal CLAUDE.md, and optionally scaffold the current repo. One conversation.

After this runs once per machine, subsequent projects only need `/chip-init` (or whatever phrasing maps to it via your personal CLAUDE.md's natural-language triggers).

---

You are bootstrapping the chip-claude framework for me in the current working directory. Walk through the steps below in order. Ask only the questions explicitly marked. Do not commit or push anything.

## Step 1: Check for global install

Run:
```bash
test -e ~/.claude/chip-templates/memory/MEMORY.md && echo INSTALLED || echo MISSING
```

(`chip-templates` is a symlink on macOS/Linux, a directory junction on Windows — so check that it *resolves*, not that it's a symlink.)

- `INSTALLED` → framework is installed. Skip to Step 3.
- `MISSING` → continue to Step 2.

## Step 2: Install the framework

Ask me (one message):

> The chip-claude framework is not installed globally on this machine. Where is the repo?
>
> 1. A GitHub URL (I'll clone to `~/code/chip-claude`; the physical location doesn't matter — install symlinks it into `~/.claude` either way).
> 2. A local path that already has the repo (give me the absolute path).
>
> Which one?

Wait for the answer.

- If a GitHub URL: `git clone <url> ~/code/chip-claude`. Verify `~/code/chip-claude/install.sh` exists.
- If a local path: verify the path exists and contains `install.sh`.

Run the install:
- Git Bash / macOS / Linux: `bash <repo>/install.sh`
- Pure PowerShell: `pwsh <repo>/install.ps1`

Verify `~/.claude/chip-templates` now resolves to `<repo>/templates` (symlink on macOS/Linux, junction on Windows).

## Step 3: Personal CLAUDE.md

Run:
```bash
ls -la ~/.claude/CLAUDE.md 2>/dev/null
```

- Exists → leave it alone. Tell me: "You already have a personal CLAUDE.md; skipping."
- Missing → ask me:

> You don't have a personal `~/.claude/CLAUDE.md` yet. Three options:
>
> 1. Copy the framework's `CLAUDE.template.md` there so I can fill it in now or later.
> 2. Point me at an existing personal file elsewhere (absolute path); I'll symlink it.
> 3. Skip for now — I'll manage it myself.
>
> Which one?

Act on the answer:
- Option 1: `cp <repo>/CLAUDE.template.md ~/.claude/CLAUDE.md`. Tell me to edit it before the next session.
- Option 2: `ln -s <path> ~/.claude/CLAUDE.md`.
- Option 3: no action.

## Step 4: Scaffold the current project (optional)

Check the cwd: does it have a `CLAUDE.md` already?

- Yes → tell me: "This directory already has a CLAUDE.md. Skipping project scaffold. Done."
- No → ask:

> Scaffold this directory as a standard project now? (yes / no)
>
> If yes, I need two things:
> 1. Project type: `web-fullstack` / `backend` / `frontend` / `cli` / `library` / `other`
> 2. One-line description (what does this project do?)

If yes: follow the `/chip-init` logic — read templates from `~/.claude/chip-templates/`, substitute placeholders (`{{project_name}}`, `{{project_description}}`, `{{project_type}}`, `{{today}}`, `{{today_plus_15}}`), write the scaffold. Refer to `~/.claude/commands/chip-init.md` for full logic if needed.

If no: skip scaffold.

## Step 5: Report

Summarise what happened in this session:
- Framework installed? (where)
- Personal CLAUDE.md: created / symlinked / skipped / already present
- Project scaffold: written / skipped

End with one note: the global CLAUDE.md loads on the **next** Claude Code session, not this one. This session won't retroactively gain the global instructions.

## Step 6: Stop

Do not commit. Do not push.
