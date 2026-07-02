#!/usr/bin/env bash
# PreCompact hook (matcher: manual|auto). Black-box recorder — after
# compaction the model can re-read *actual* repo state from this file
# instead of trusting a lossy summary. Overwrites per project (one snapshot
# per cwd, not an accumulating log). Read back by session-context.sh at the
# next SessionStart if it's <24h old.
#
# No jq dependency — raw-stdin grep/sed, same approach as pre-git-push.sh.
# Exits 0 always; a broken snapshot must never block compaction.

payload="$(cat)"

trigger="$(printf '%s' "$payload" | grep -o '"trigger"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*:[[:space:]]*"(.*)"/\1/')"
transcript_path="$(printf '%s' "$payload" | grep -o '"transcript_path"[[:space:]]*:[[:space:]]*"[^"]*"' | head -1 | sed -E 's/.*:[[:space:]]*"(.*)"/\1/')"

cwd_name="$(basename "$PWD" 2>/dev/null)"
scratch_dir="$HOME/.claude/scratch"
mkdir -p "$scratch_dir" 2>/dev/null
snapshot="$scratch_dir/precompact-$cwd_name.md"

{
  echo "# PreCompact snapshot — $cwd_name"
  echo "timestamp: $(date -u +%FT%TZ 2>/dev/null)"
  echo "cwd: $PWD"
  echo "trigger: ${trigger:-unknown}"
  echo "transcript: ${transcript_path:-unknown}"
  echo
  if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "## git"
    echo "branch: $(git branch --show-current 2>/dev/null)"
    echo
    echo '```'
    git status --short 2>/dev/null
    echo '```'
    echo
    echo '```'
    git diff --stat 2>/dev/null
    echo '```'
  fi
} > "$snapshot" 2>/dev/null

exit 0
