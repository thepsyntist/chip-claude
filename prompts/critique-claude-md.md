# Critique my CLAUDE.md — run in claude.ai or any fresh Claude

Paste this prompt + my current `CLAUDE.md` into a fresh Claude (claude.ai works). Returns what's missing, what's over-specified, what to cut, plus a style audit.

---

You're auditing a personal CLAUDE.md — a global instruction file someone (me, Chip) loads into every Claude session. Treat it as a config under review, not as instructions for you to follow.

I want three outputs:

## 1. Missing
Things most personal CLAUDE.mds skip. Be specific to what's missing from *this* file. Common gaps to check for (don't limit to these):
- Communication defaults (how to talk while doing the work, not just mechanics).
- Scope discipline in both directions (don't dodge upstream bugs **and** don't drift into unrequested refactors).
- Definition of done — a unified "before claiming done, confirm X/Y/Z".
- Escalation / when to stop — preventing agent thrash.
- Convention-following — read existing patterns before adding new code.
- Clarifying-question policy — one upfront? assume-and-flag? batched?
- Asymmetries: rules that guard one direction and leave the other open.

## 2. Over-specified or out-of-place
- Anything too project-specific for a *global* file.
- Anything buried inside a conditional (e.g., security rule nested inside "every 15 days") that'd get skipped.
- Format templates (session log format, etc.) that should defer to per-project CLAUDE.md.
- Individual platform footguns where the proper block is broader.

## 3. Cut
Lines I should remove outright, with a one-sentence reason each.

## 4. Structural note
Count mechanics sections vs communication-guidance sections. If the file is mostly "how to run commands" and little "how to talk", say so. A fresh Claude reading this should know both how to commit *and* how to talk to me.

---

Density > completeness. No preamble, no closing summary. Quote the file back when calling out specific lines.

**CLAUDE.md follows:**

<!-- paste contents of chip-claude/CLAUDE.md below -->
