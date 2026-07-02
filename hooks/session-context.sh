#!/usr/bin/env bash
# SessionStart hook. Prints a compact primer so the model doesn't start blind —
# date, cwd, git branch/dirty count, ROADMAP.md staleness. Plain stdout on a
# SessionStart hook is auto-injected into context; no JSON envelope needed.
#
# This is context, not a gate — silent-degrade on anything unexpected, never
# blocks a session from starting. mtime lookup uses a GNU/BSD stat fallback
# (`date -r <file>` is GNU-only for file mtime; BSD date -r takes epoch
# seconds instead, so it silently misbehaves on macOS).

mtime_epoch() {
  stat -c %Y "$1" 2>/dev/null || stat -f %m "$1" 2>/dev/null
}

today="$(date +%F 2>/dev/null)"
dow="$(date +%A 2>/dev/null)"
cwd_name="$(basename "$PWD" 2>/dev/null)"

lines=("Session start: $today ($dow) — $cwd_name")

if git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  branch="$(git branch --show-current 2>/dev/null)"
  dirty="$(git status --porcelain 2>/dev/null | wc -l | tr -d ' ')"
  lines+=("git: branch ${branch:-detached}, ${dirty:-0} dirty file(s)")
fi

if [[ -f ./memory/ROADMAP.md ]]; then
  now_epoch="$(date +%s 2>/dev/null)"
  file_epoch="$(mtime_epoch ./memory/ROADMAP.md)"
  if [[ -n "$now_epoch" && -n "$file_epoch" ]]; then
    age_days=$(( (now_epoch - file_epoch) / 86400 ))
    note="ROADMAP.md last touched ${age_days} day(s) ago"
    if (( age_days > 14 )); then
      note="$note — housekeeping likely overdue"
    fi
    lines+=("$note")
  fi
fi

# Surfaces a fresh pre-compact-snapshot.sh output for this cwd, if one exists.
snapshot="$HOME/.claude/scratch/precompact-$cwd_name.md"
if [[ -f "$snapshot" ]]; then
  now_epoch="${now_epoch:-$(date +%s 2>/dev/null)}"
  snap_epoch="$(mtime_epoch "$snapshot")"
  if [[ -n "$now_epoch" && -n "$snap_epoch" ]]; then
    snap_age_hours=$(( (now_epoch - snap_epoch) / 3600 ))
    if (( snap_age_hours < 24 )); then
      lines+=("precompact snapshot available: $snapshot")
    fi
  fi
fi

printf '%s\n' "${lines[@]}"
exit 0
