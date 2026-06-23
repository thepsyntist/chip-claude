# Global Claude Instructions — Template

> Copy this file to `~/.claude/CLAUDE.md` and fill it in. It becomes the global instructions loaded into every Claude Code session on your machine.
>
> Keep it tight — everything here rides in every session's context. Cut aggressively. Delete sections you don't care about.

## About you

<!-- One line: what Claude should call you, where you're based, your role. -->
<!-- Example: Call me Sam. Based in Amsterdam (CET). Solo dev on a payments platform. -->

## Communication

<!-- How you want Claude to talk. Common defaults: -->
<!-- - Direct, no preamble, no "great question", no closing recap. -->
<!-- - Match my density — dense paste gets dense reply. -->
<!-- - Match my register — casual in, casual back. -->
<!-- - Push back when warranted. Sycophancy is noise. -->
<!-- - If uncertain, name what's uncertain — don't disclaim generally. -->

## Division of labor

<!-- What you handle yourself vs delegate. Examples: -->
<!-- - I run dev servers myself — don't offer. -->
<!-- - I commit and push myself — never auto-git. -->
<!-- - You grep + summarize; don't dump file contents on me. -->

## Scope discipline

<!-- Examples: -->
<!-- - Do what I asked, nothing adjacent. Mention noticed cleanup; don't silently fold in. -->
<!-- - Numbered asks = numbered scope. -->

## Clarifying questions

<!-- Common approach: -->
<!-- - Trivial ambiguity → assume, act, flag the assumption. -->
<!-- - Intent/scope ambiguity that changes what gets built → one question upfront, load-bearing. Never batch 3+. -->

## Terminology

<!-- Phrases that confuse Claude in your workflow. Examples: -->
<!-- - "Ship it" / "update docs" / "fix it" → edit files, stop. Not git commit. -->
<!-- - "Update docs" = edit docs/memory files only. -->

## Definition of done

<!-- Your "before claiming done" checklist. Common items: -->
<!-- 1. Typecheck / tests pass. -->
<!-- 2. UI changes → screenshot described. -->
<!-- 3. Nothing extra left behind. -->
<!-- 4. Docs/memory updated if invariants touched. -->
<!-- 5. Git state still yours. -->

## Escalation

<!-- - 2-3 failed approaches → stop, surface what you tried and what's blocking. -->
<!-- - Same friction twice → propose hardening the tool, not another instance fix. -->

## Convention-following

<!-- - Read existing patterns before adding code. Match shape. -->
<!-- - Modularize > copy-paste. -->
<!-- - No new libraries/abstractions without asking. -->

## Git discipline

<!-- - Never auto-commit or auto-push. -->
<!-- - "Commit" = git commit only. "Push" = commit + push. -->

## Verification

<!-- - Small string/CSS edits → typecheck only, not full build. -->
<!-- - Full build = dep changes, config edits, pre-deploy. -->

## Tests

<!-- - Tests grow with features. -->
<!-- - New tests go in matching existing file. -->

## Session rhythm

<!-- If projects have a session log / KB: -->
<!-- - Update at session end. Format lives in project CLAUDE.md. -->

## Memory writes

<!-- - Follow feedback/project/reference/user template. -->
<!-- - Update existing entries instead of duplicating. -->

## Platform

<!-- Your OS, shell, language-specific footguns. Examples: -->
<!-- Windows 11 + Git Bash (MSYS). Unix shell syntax; MSYS_NO_PATHCONV=1 when passing paths to node scripts. -->

## Natural-language triggers

<!-- Map common phrases to commands. Examples: -->
<!-- - "setup [framework-name]" / "init this project" → run /chip-init -->
<!-- - Replace /chip-init with your renamed command if you forked this framework. -->
