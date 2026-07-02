#!/usr/bin/env bash
# Stop hook. Definition-of-done #3 ("nothing extra left behind"), mechanized —
# scans this turn's added lines in CODE files only (ts/tsx/js/jsx/mjs/cjs/py)
# for common debug leftovers before the turn ends, and nudges the model to
# clean up instead of trusting it to remember. Docs/config/shell diffs are
# ignored by design — this guards app code, not prose describing this hook
# (chip-claude's own README documents these exact patterns as added lines).
#
# Respects stop_hook_active to avoid looping forever (Claude Code also caps
# consecutive blocks at 8 by default; CLAUDE_CODE_STOP_HOOK_BLOCK_CAP raises
# it if more are ever needed).
#
# Bias: never block on doubt. Single awk pass over the whole diff (not one
# grep process per added line) — this fires every turn, so per-line process
# spawn cost matters, especially on Windows.

payload="$(cat)"

echo "$payload" | grep -qE '"stop_hook_active"[[:space:]]*:[[:space:]]*true' && exit 0

git rev-parse --is-inside-work-tree >/dev/null 2>&1 || exit 0
[[ -z "$(git status --porcelain 2>/dev/null)" ]] && exit 0

diff_output="$( { git diff; git diff --cached; } 2>/dev/null)"

hits="$(printf '%s\n' "$diff_output" | awk '
  /^\+\+\+ b\// {
    file = substr($0, 7)
    ext = file
    sub(/.*\./, "", ext)
    is_code = (ext == "ts" || ext == "tsx" || ext == "js" || ext == "jsx" || ext == "mjs" || ext == "cjs" || ext == "py")
    next
  }
  /^\+\+\+/ { next }
  /^\+/ {
    if (!is_code) next
    content = substr($0, 2)
    if (content ~ /console\.log|debugger|TODO\(claude\)|FIXME\(claude\)|dump\(|print\(.*DEBUG/) {
      print file ": " content
    }
  }
')"

[[ -z "$hits" ]] && exit 0

escaped="${hits//\\/\\\\}"
escaped="${escaped//\"/\\\"}"
escaped="$(printf '%s' "$escaped" | sed ':a;N;$!ba;s/\n/\\n/g')"

printf '{"hookSpecificOutput":{"hookEventName":"Stop","decision":"block","additionalContext":"Possible debug leftovers in the current diff, clean up before finishing:\\n%s"}}' "$escaped"

exit 0
