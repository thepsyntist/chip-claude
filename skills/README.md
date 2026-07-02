# skills/

Reusable skills across projects. Each is a directory with a `SKILL.md` (frontmatter: `name`, `description`). Claude auto-discovers.

## Built

- `debug-protocol/` — structured reproduce → isolate → hypothesize → verify loop; surfaces an explicit escalation gate after 2-3 failed hypothesis cycles instead of thrashing.
- `verify-ui/` — mobile-viewport-first UI verification before any visual change is claimed done.

## Recommended external skills

- [anthropics/skills](https://github.com/anthropics/skills) — official docx / pdf / pptx / xlsx document-handling skills. Not vendored here: they're source-available reference implementations under more restrictive terms than this repo's framework code, not drop-in packages. If you want them, clone the repo and copy the skill directory you need into `~/.claude/skills/<name>/` yourself — check the upstream license first.

## Planned

- `visual-check/` — generic Playwright screenshot runner, not tied to a specific project's dev server path.
- `session-log/` — append a session entry to a project's session archive in the project's own format.
- `supply-chain-check/` — audit Python / JS deps for unpinned versions, CDN-loaded scripts, fonts.

Build each when the pattern has repeated across two+ projects.
