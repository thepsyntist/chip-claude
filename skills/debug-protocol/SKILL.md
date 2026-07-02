---
name: debug-protocol
description: Structured debugging protocol — use when a bug resists the first fix attempt, before trying a second approach.
---

A bug that survives one fix attempt gets a protocol, not another guess. Work through these steps in order; don't skip ahead.

1. **Reproduce deterministically.** Exact command/steps, exact observed output vs. expected. No reliable repro → stop here and say so — don't debug blind.
2. **Isolate.** Binary-search the surface: `git bisect`, comment out halves, build a minimal repro. Name the smallest unit that still fails.
3. **One hypothesis, written down.** State it in one sentence before touching any code.
4. **One change.** The smallest edit that tests the hypothesis. Never stack multiple changes — you won't know which one mattered.
5. **Verify.** Rerun the repro.
   - Fixed → remove any debug instrumentation added along the way, then done.
   - Not fixed → revert the change, go back to step 3 with what you just learned.
6. **Escalation gate.** After 2-3 failed hypothesis cycles: stop. Report what you tried, what's blocking, what you think is next. Do not silently attempt a 4th guess.

## Anti-thrash rules
- No shotgun edits — one change per cycle, always.
- No "let me also try this" stacking on top of an unverified change.
- Debug instrumentation (console logs, temporary asserts) comes out before the fix is called done.
