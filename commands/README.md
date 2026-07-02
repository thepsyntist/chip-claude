# commands/

Personal slash commands. Each `.md` file here becomes `/filename` in Claude Code.

## Built

- `/chip-init` — scaffolds a standard project structure (CLAUDE.md, memory/, docs/, .claude/, .gitignore). Asks project type + description, then drops templates from `~/.claude/chip-templates/`.
- `/session-log` — appends today's session to `memory/ROADMAP.md` in its existing format; archives overflow past 5 entries into `memory/session-archive.md`.
- `/housekeeping` — runs the project's housekeeping cadence against `memory/feedback_housekeeping_schedule.md` if it's due; reports read-only findings, asks before any edit-requiring fix.
- `/onboard-new-claude` — prints `prompts/onboard-new-claude.md` verbatim for quick copy into a stateless Claude instance.
