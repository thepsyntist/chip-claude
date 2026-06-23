# agents/

Personal subagents. Each lives in its own `.md` file at this level with YAML frontmatter (`name`, `description`, `tools`).

Claude Code auto-discovers any `.md` file here as an invokable agent at `~/.claude/agents/<name>.md`.

## Built

- `reviewer.md` — independent, read-only code reviewer. Sources the active rules from the project + global `CLAUDE.md`, reviews only the diff, returns a PASS / NEEDS-WORK punch list. Never edits or touches git.

## Planned

- `debug-loop.md` — structured debug loop that surfaces after 2-3 failed approaches.
- ~~`explorer.md`~~ — dropped; the built-in **Explore** agent already covers grep-first surveying.
- ~~`commit-drafter.md`~~ — dropped; drafting a message is an inline task, not worth a separate agent context.

Build each one when it first becomes useful, not preemptively.
