---
name: Housekeeping schedule
description: Code review cadence and what to check every ~15 days for {{project_name}}
type: feedback
---

Every ~15 days, do a housekeeping pass over the main files.

**Why:** Files grow incrementally and never get reviewed holistically. Debt compounds quietly.

**How to apply:** At session start, check the date against last housekeeping. If 15+ days have passed, surface it and offer to run the pass. Don't silently run one.

## What to check

### File weight (line counts)

<!-- TODO: fill in per-file alert thresholds once structure stabilizes.
Example:
| File | Alert at |
|---|---|
| `src/routes/auth.ts` | >500 lines → extract handlers |
-->

### Security checklist
- All user input goes through parameterized queries / safe escaping.
- Auth guard on every non-public route.
- Ownership check on every mutation (`doc.user_id == auth_id`).
- No secrets in logs.
- Rate limits on abusable endpoints.
- Regex on user input goes through escape.

### Code efficiency
- Duplicate queries within the same request.
- N+1 patterns in list endpoints.
- Unbounded list fetches (no `.limit()` / `.take()`).
- Dead variables / unused imports.
- Duplicated logic that should be lifted into a helper.

### Dependency / supply chain
- Any unpinned deps (`^`, `>=`) in prod files.
- CDN-loaded scripts / fonts that should be self-hosted.
- Unused deps in lockfiles.

## Last housekeeping
(none yet — first pass due {{today_plus_15}})
