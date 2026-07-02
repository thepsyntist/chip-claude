#!/usr/bin/env bash
# PostToolUse hook (matcher: Edit|Write). Definition-of-done #1 ("typecheck
# passes"), mechanized — a model that forgets to typecheck a .ts/.tsx edit
# gets told anyway, without needing to remember to run it itself.
#
# Bias: silent-skip on any doubt. A broken/slow typecheck must never block
# editing — this is a nudge via additionalContext, not a gate. Escape hatch:
# CHIP_NO_TYPECHECK=1 skips entirely (e.g. mid-refactor with known red state).
#
# No jq dependency — same raw-stdin grep/sed approach as pre-git-push.sh.
# Windows hook payloads carry JSON-escaped backslashes (C:\\Users\\...) —
# normalize to forward slashes right after extraction so basename/-f/cd all
# behave the same on Windows and POSIX.

[[ -n "${CHIP_NO_TYPECHECK:-}" ]] && exit 0

payload="$(cat)"

file_path="$(printf '%s' "$payload" | grep -o '"file_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*:[[:space:]]*"(.*)"/\1/')"
file_path="$(printf '%s' "$file_path" | sed 's/\\\\/\//g; s/\\/\//g')"

case "$file_path" in
  *.ts|*.tsx) ;;
  *) exit 0 ;;
esac

cwd="$(printf '%s' "$payload" | grep -o '"cwd"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*:[[:space:]]*"(.*)"/\1/')"
cwd="$(printf '%s' "$cwd" | sed 's/\\\\/\//g; s/\\/\//g')"
cwd="${cwd:-$PWD}"

[[ -f "$cwd/tsconfig.json" ]] || exit 0

basename_file="${file_path##*/}"

if command -v timeout >/dev/null 2>&1; then
  output="$(cd "$cwd" && timeout 60 npx tsc --noEmit 2>&1)"
else
  output="$(cd "$cwd" && npx tsc --noEmit 2>&1)"
fi

errors="$(printf '%s\n' "$output" | grep -F "$basename_file" | head -15)"

[[ -z "$errors" ]] && exit 0

escaped="${errors//\\/\\\\}"
escaped="${escaped//\"/\\\"}"
escaped="$(printf '%s' "$escaped" | sed ':a;N;$!ba;s/\n/\\n/g')"

printf '{"hookSpecificOutput":{"hookEventName":"PostToolUse","additionalContext":"tsc --noEmit found errors in %s:\\n%s"}}' "$basename_file" "$escaped"

exit 0
