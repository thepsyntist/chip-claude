#!/usr/bin/env bash
# statusLine command. Reads the JSON Claude Code feeds on stdin, prints ONE
# line: model | cwd | branch(*dirty) | ctx%. No jq dependency — grep/sed
# extraction, same approach as the hooks. Git branch/dirty info isn't in the
# native payload, so this script computes it itself (two cheap git calls).
#
# Must never crash or hang — degrade to whatever fields are present and keep
# the line short. Runtime budget: <300ms. Windows payloads carry JSON-escaped
# backslashes in cwd (C:\\Users\\...) — normalized to forward slashes right
# after extraction so basename/git -C both behave the same as on POSIX.

payload="$(cat)"

model="$(printf '%s' "$payload" | grep -o '"display_name"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*:[[:space:]]*"(.*)"/\1/')"
cwd="$(printf '%s' "$payload" | grep -o '"cwd"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*:[[:space:]]*"(.*)"/\1/')"
cwd="$(printf '%s' "$cwd" | sed 's/\\\\/\//g; s/\\/\//g')"
pct="$(printf '%s' "$payload" | grep -o '"used_percentage"[[:space:]]*:[[:space:]]*[0-9.]*' | head -1 | sed -E 's/.*:[[:space:]]*//')"

cwd_name="$(basename "${cwd:-$PWD}" 2>/dev/null)"

parts=()
[[ -n "$model" ]] && parts+=("$model")
[[ -n "$cwd_name" ]] && parts+=("$cwd_name")

if [[ -n "$cwd" ]] && git -C "$cwd" rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch="$(git -C "$cwd" branch --show-current 2>/dev/null)"
  dirty="$(git -C "$cwd" status --porcelain 2>/dev/null | head -1)"
  if [[ -n "$branch" ]]; then
    if [[ -n "$dirty" ]]; then
      parts+=("${branch}*")
    else
      parts+=("$branch")
    fi
  fi
fi

[[ -n "$pct" ]] && parts+=("ctx ${pct}%")

result=""
for p in "${parts[@]}"; do
  if [[ -z "$result" ]]; then
    result="$p"
  else
    result="$result | $p"
  fi
done

echo "${result:-claude}"
exit 0
