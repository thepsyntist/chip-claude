#!/usr/bin/env bash
# Deterministic /chip-init scaffold. Run from the target project root:
#   bash ~/.claude/chip-templates/scaffold.sh <project_type> "<one-line description>"
#
# Mirrors commands/chip-init.md §3-4 exactly — a script can't drift on
# placeholder substitution or file selection the way a model re-deriving it
# from prose each time can. Pre-flight (CLAUDE.md-exists check, project-type
# detection, the one clarifying question) still lives in chip-init.md; this
# script is the deterministic "write the files" half.

set -euo pipefail

TEMPLATE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Framework identity — see framework.config. `if -f && source` (not
# `[[ -f x ]] && source x`) because the latter dies under set -e when the
# file is absent.
FRAMEWORK_PREFIX="chip"
if [[ -f "$TEMPLATE_DIR/framework.config" ]]; then
  # shellcheck source=/dev/null
  source "$TEMPLATE_DIR/framework.config"
fi
FRAMEWORK_CMD="${FRAMEWORK_PREFIX}-init"

PROJECT_TYPE="${1:-}"
PROJECT_DESCRIPTION="${2:-}"
PROJECT_NAME="$(basename "$PWD")"

usage() {
  echo "Usage: bash scaffold.sh <project_type> \"<one-line description>\"" >&2
  echo "  project_type: web-fullstack | backend | frontend | cli | library | other" >&2
}

case "$PROJECT_TYPE" in
  web-fullstack|backend|frontend|cli|library|other) ;;
  "") usage; exit 2 ;;
  *) echo "Unknown project_type: $PROJECT_TYPE" >&2; usage; exit 2 ;;
esac

if [[ -z "$PROJECT_DESCRIPTION" ]]; then
  usage
  exit 2
fi

if [[ -e ./CLAUDE.md ]]; then
  echo "CLAUDE.md already exists — aborting. Delete or rename it first if you want to re-scaffold." >&2
  exit 1
fi

# Toolchain detection (backend/#2) — union of every stack detected in the
# target cwd. Empty if none match; renders "allow": [] which is valid JSON.
# `if` blocks, not `[[ -f x ]] && { ...; }` — same set -e trap as the
# framework.config sourcing above.
TOOLCHAIN_PERMS=""
add_perm() {
  [[ -n "$TOOLCHAIN_PERMS" ]] && TOOLCHAIN_PERMS="$TOOLCHAIN_PERMS, "
  TOOLCHAIN_PERMS="$TOOLCHAIN_PERMS\"$1\""
}
if [[ -f ./package.json ]]; then
  add_perm "Bash(npm run typecheck)"
  add_perm "Bash(npm test:*)"
  add_perm "Bash(npx tsc:*)"
fi
if [[ -f ./Cargo.toml ]]; then
  add_perm "Bash(cargo check:*)"
  add_perm "Bash(cargo test:*)"
  add_perm "Bash(cargo clippy:*)"
fi
if [[ -f ./go.mod ]]; then
  add_perm "Bash(go build:*)"
  add_perm "Bash(go test:*)"
  add_perm "Bash(go vet:*)"
fi
if [[ -f ./pyproject.toml || -f ./requirements.txt ]]; then
  add_perm "Bash(pytest:*)"
  add_perm "Bash(ruff check:*)"
  add_perm "Bash(mypy:*)"
fi

TODAY="$(date +%F)"
TODAY_PLUS_15="$(date -d '+15 days' +%F 2>/dev/null || date -v+15d +%F 2>/dev/null)"

# Escape backslash, &, and | (sed replacement + our chosen delimiter) via
# plain bash substitution — avoids sed-escaping-sed quoting hell.
escape_repl() {
  local s="$1"
  s="${s//\\/\\\\}"
  s="${s//&/\\&}"
  s="${s//|/\\|}"
  printf '%s' "$s"
}

NAME_ESC="$(escape_repl "$PROJECT_NAME")"
DESC_ESC="$(escape_repl "$PROJECT_DESCRIPTION")"
TYPE_ESC="$(escape_repl "$PROJECT_TYPE")"
CMD_ESC="$(escape_repl "$FRAMEWORK_CMD")"
PERMS_ESC="$(escape_repl "$TOOLCHAIN_PERMS")"

substitute() {
  local src="$1" dest="$2"
  mkdir -p "$(dirname "$dest")"
  sed \
    -e "s|{{project_name}}|$NAME_ESC|g" \
    -e "s|{{project_description}}|$DESC_ESC|g" \
    -e "s|{{project_type}}|$TYPE_ESC|g" \
    -e "s|{{today}}|$TODAY|g" \
    -e "s|{{today_plus_15}}|$TODAY_PLUS_15|g" \
    -e "s|{{framework_cmd}}|$CMD_ESC|g" \
    -e "s|{{toolchain_perms}}|$PERMS_ESC|g" \
    "$src" > "$dest"
}

# Always-create set (commands/chip-init.md §3).
substitute "$TEMPLATE_DIR/CLAUDE.md"                                  "./CLAUDE.md"
substitute "$TEMPLATE_DIR/memory/MEMORY.md"                           "./memory/MEMORY.md"
substitute "$TEMPLATE_DIR/memory/ROADMAP.md"                          "./memory/ROADMAP.md"
substitute "$TEMPLATE_DIR/memory/session-archive.md"                  "./memory/session-archive.md"
substitute "$TEMPLATE_DIR/memory/feedback_housekeeping_schedule.md"   "./memory/feedback_housekeeping_schedule.md"
substitute "$TEMPLATE_DIR/docs/common/decisions.md"                   "./docs/decisions.md"
substitute "$TEMPLATE_DIR/docs/common/known-invariants.md"            "./docs/known-invariants.md"
substitute "$TEMPLATE_DIR/claude-settings.json"                       "./.claude/settings.json"

DOC_LIST="    decisions.md
    known-invariants.md"

# Doc presets = directory convention (#3): preset name is just a directory
# under docs/. web-fullstack unions backend + frontend; every other type
# maps to itself. Add docs/<type>/ to give that project type extra docs —
# no script change needed.
case "$PROJECT_TYPE" in
  web-fullstack) PRESETS="backend frontend" ;;
  *)             PRESETS="$PROJECT_TYPE" ;;
esac

for preset in $PRESETS; do
  preset_dir="$TEMPLATE_DIR/docs/$preset"
  [[ -d "$preset_dir" ]] || continue
  for tpl in "$preset_dir"/*.md; do
    [[ -e "$tpl" ]] || continue
    fname="$(basename "$tpl")"
    substitute "$tpl" "./docs/$fname"
    DOC_LIST="$DOC_LIST
    $fname"
  done
done

# .gitignore handling (commands/chip-init.md §3).
GITIGNORE_MARKER="# Claude Code artifacts"
if [[ -f ./.gitignore ]]; then
  if grep -qF "$GITIGNORE_MARKER" ./.gitignore; then
    GITIGNORE_ACTION="already present — left untouched"
  else
    cat "$TEMPLATE_DIR/gitignore-additions.txt" >> ./.gitignore
    GITIGNORE_ACTION="updated"
  fi
else
  cp "$TEMPLATE_DIR/gitignore-additions.txt" ./.gitignore
  GITIGNORE_ACTION="created"
fi

cat <<REPORT
Scaffolded $PROJECT_NAME ($PROJECT_TYPE):

  CLAUDE.md
  memory/
    MEMORY.md
    ROADMAP.md
    session-archive.md
    feedback_housekeeping_schedule.md
  docs/
$DOC_LIST
  .claude/
    settings.json
  .gitignore ($GITIGNORE_ACTION)

TODOs to fill in before the next session:
- CLAUDE.md: Architecture, Quick Start, Key Rules, File Map
- memory/MEMORY.md: Architecture, Key Rules, Key File Paths
- memory/ROADMAP.md: Stages Overview, Next Actions
- memory/feedback_housekeeping_schedule.md: File weight thresholds (once structure stabilizes)
- docs/decisions.md: Any decisions already made before scaffold
- docs/known-invariants.md: First invariants as they surface
REPORT
