# commands/

Personal slash commands. Each `.md` file here becomes `/filename` in Claude Code.

## Built

- `/chip-init` — scaffolds a standard project structure (CLAUDE.md, memory/, docs/, .claude/, .gitignore). Asks project type + description, then drops templates from `~/.claude/chip-templates/`.

## Planned

- `/session-log` — triggers the session-log skill with current date and a prompt for the summary.
- `/housekeeping` — runs the project's housekeeping cadence if defined; else lists what to check.
- `/onboard-new-claude` — prints `prompts/onboard-new-claude.md` for quick copy.
