# skills/

Reusable skills across projects. Each is a directory with a `SKILL.md` (frontmatter: `name`, `description`). Claude auto-discovers.

## Planned

- `visual-check/` — generic Playwright screenshot runner, not tied to a specific project's dev server path.
- `session-log/` — append a session entry to a project's session archive in the project's own format.
- `supply-chain-check/` — audit Python / JS deps for unpinned versions, CDN-loaded scripts, fonts.

Build each when the pattern has repeated across two+ projects.
