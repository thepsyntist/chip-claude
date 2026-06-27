# TODO — parameterization backlog

Surfaced 2026-06-27 (framework audit + follow-up). **None of these are bugs.** They're
single-user assumptions that are implied rather than parameterized: the framework
generalizes its *mechanics* (installer, `@import` stub, `reviewer` agent are all portable)
but not its *identity, stack, or workflow*.

**ROI note:** invisible while the one author is the one user. Only matters the day someone
forks this expecting the README's "rename to match your identity" promise. Pick up only if
a fork lands (or for the satisfaction of making the README honest). If touching just one
thing, do #1 — it's the highest-leverage and makes the rebrand claim true.

---

## 1. `chip-` identity is threaded through, not parameterized
The README pitches a 3-step rebrand; it's actually a find-replace across ~11 files. The
prefix lives in the command name (`/chip-init`), the `chip-templates` symlink (hardcoded in
`install.sh` + `install.ps1`), and — worst — *inside the scaffold templates copied into
every user project*:
- `templates/memory/MEMORY.md:3` — "Scaffolded via `/chip-init`"
- `templates/memory/ROADMAP.md:41` — same
- `templates/docs/common/decisions.md:7` — same

So a forker who renames the repo + command still stamps every scaffolded project with
"via /chip-init".

- [ ] Add a single `framework.config` (name, command, prefix, gh user).
- [ ] Have `install.sh` / `install.ps1` / `chip-init` / scaffold templates substitute from it
      (e.g. `{{framework_cmd}}`, `{{framework_prefix}}`) so rebrand = edit one file.

## 2. Global settings template is JS/TS-only, but the framework claims polyglot
`settings.template.json:5-7` allowlists `npm run typecheck` / `npx tsc` / `npx next build`
(Node/Next). But `chip-init.md:14` detects Python/Rust/Go and offers `cli`/`library`/`backend`.
A Rust user gets three dead allow-rules and nothing for `cargo check`/`cargo test`.
(The `reviewer` agent is already stack-agnostic — `reviewer.md:23` — so the pattern exists.)

- [ ] Make settings perms stack-aware: emit toolchain perms by detected project type
      (`cargo`/`pytest`/`go test`/…), not just npm.

## 3. Doc taxonomy is web-dev shaped
`templates/docs/` ships `backend/{api-contracts, error-responses, systems-catalog}` and
`frontend/{ui-patterns, design-philosophy}` — a SaaS/web mental model presented as *the*
universal scaffold. A CLI / data pipeline / game / firmware project maps onto none of it.
`chip-init` only branches docs for backend/frontend/fullstack.

- [ ] Add doc presets for non-web project types (cli, library, data), or make the doc set
      a selectable preset rather than a fixed backend/frontend split.

## 4. Workflow cadence is one person's rhythm, shipped as structure
Every scaffolded project inherits "every ~15 days housekeeping" (`templates/CLAUDE.md:48`),
"session log (last 5 sessions)", overflow to `session-archive.md`, and the
feedback/project/reference memory taxonomy. Reasonable — but assumes solo, session-based work,
framed as the framework's shape rather than one preset.

- [ ] Tag the cadence / session model / memory taxonomy as swappable presets, not
      load-bearing structure (or document them as "the default rhythm — change freely").

## 5. Preferences shipped as neutral defaults
`settings.template.json` ships `effortLevel: high` and `autoUpdatesChannel: latest` — cost
and stability *calls*, not defaults. A forker copying the skeleton silently adopts the
author's risk posture.

- [ ] Comment these as opinionated choices in the template, or drop to conservative defaults.
