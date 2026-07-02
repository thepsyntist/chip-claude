#!/usr/bin/env bash
# PreToolUse hook (matcher: Read|Bash). Forces an explicit approval prompt on
# any tool call that touches likely secrets material — a model that would
# happily `cat .env` or read an SSH private key gets stopped first.
#
# Deliberately NOT flagged: .env.example / .env.template / .env.sample (the
# committed-safe convention).
#
# Matching is a substring/regex scan of the raw tool-call JSON from stdin —
# no jq dependency, same approach as pre-git-push.sh. False positives (e.g. a
# path that happens to contain "credentials") just cost one extra approval
# prompt; false negatives are the real risk, so patterns stay broad.

payload="$(cat)"

flagged=0

if echo "$payload" | grep -qE '\.env([^a-zA-Z]|$)'; then
  echo "$payload" | grep -qE '\.env\.(example|template|sample)' || flagged=1
fi

pattern='id_rsa|id_ed25519|id_ecdsa|\.pem\b|credentials.*\.json|\.netrc|\.npmrc'
echo "$payload" | grep -qE "$pattern" && flagged=1

if [[ "$flagged" -eq 1 ]]; then
  echo '{"hookSpecificOutput":{"hookEventName":"PreToolUse","permissionDecision":"ask","permissionDecisionReason":"potential secrets access — requires explicit user approval"}}'
fi

exit 0
