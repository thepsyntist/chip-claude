#!/usr/bin/env bash
# PreToolUse hook (matcher: Bash). Forces an explicit approval prompt on any
# git command that mutates repo state, on top of the CLAUDE.md git-discipline
# rule — a model that ignores prose still can't push without the user seeing it.
#
# Deliberately NOT flagged: plain `git pull` (routine user-initiated sync) and
# all read-only git (status/diff/log/show/branch/ls-files/ls-remote/remote -v/
# fetch). `git pull --rebase` IS flagged (rebase semantics).
#
# Matching is a substring/regex scan of the raw tool-call JSON from stdin —
# no jq dependency. False positives (e.g. a commit message that happens to
# contain "git push") just cost one extra approval prompt; false negatives
# are the real risk, so patterns stay broad on purpose.

payload="$(cat)"

pattern='git[[:space:]]+(commit|push|rebase|merge|reset[[:space:]]+--hard|checkout[[:space:]]+--[[:space:]]|commit[[:space:]]+--amend|stash[[:space:]]+(drop|clear)|pull[[:space:]]+--rebase)'

if echo "$payload" | grep -qE "$pattern"; then
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"git state change — requires explicit user approval (CLAUDE.md git discipline)"}}'
fi

exit 0
