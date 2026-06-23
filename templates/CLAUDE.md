# {{project_name}}

{{project_description}}

## Architecture
<!-- TODO: Backend stack, frontend stack, storage, key services. One paragraph. -->

## Quick Start

```bash
# TODO: commands to run dev locally
```

**Required env vars:** <!-- TODO -->

## Key Rules (MUST follow)

<!-- TODO: Project-specific invariants. Each is a one-liner with a why.
Example:
1. **All datetimes in UTC.** Storage is ISO strings; reads parse with `dateutil.parser.parse(...).replace(tzinfo=timezone.utc)`.
-->

## File Map

| Area | Files |
|------|-------|
<!-- TODO: fill as structure stabilizes -->

## Docs

All long-form docs live in `docs/`:
- `known-invariants.md` — rules that must never break
- `decisions.md` — architectural decisions and rationale
<!-- If backend: -->
<!-- - `api-contracts.md` — every endpoint -->
<!-- - `systems-catalog.md` — all backend systems -->
<!-- - `error-responses.md` — error contract and status codes -->
<!-- If frontend: -->
<!-- - `ui-patterns.md` — frontend conventions -->
<!-- - `design-philosophy.md` — product values and principles -->

## Memory

`memory/MEMORY.md` is the index. Rule updates live in `feedback_*.md`, project state in `project_*.md`, external pointers in `reference_*.md`.

## Housekeeping

Every ~15 days, run a housekeeping pass. See `memory/feedback_housekeeping_schedule.md`.

## Session Log

End-of-session: append to `memory/ROADMAP.md`'s session log. Older sessions overflow to `memory/session-archive.md`.
