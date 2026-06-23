# agents/

Personal subagents. Each lives in its own `.md` file at this level with YAML frontmatter (`name`, `description`, `tools`).

Claude Code auto-discovers any `.md` file here as an invokable agent at `~/.claude/agents/<name>.md`.

## Planned

- `explorer.md` — fast codebase surveyor that respects my "grep first, don't dump files" rule.
- `reviewer.md` — code reviewer that applies my invariants (scope discipline, no auto-commit, tests-with-features).
- `debug-loop.md` — structured debug loop that surfaces after 2-3 failed approaches.
- `commit-drafter.md` — drafts commit messages in my voice when asked, never executes git.

Build each one when it first becomes useful, not preemptively.
