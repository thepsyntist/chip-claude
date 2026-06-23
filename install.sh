#!/usr/bin/env bash
# Links chip-claude framework into ~/.claude/
# Does NOT touch your personal ~/.claude/CLAUDE.md — that file is yours alone.
# Safe to re-run. Backs up existing non-link files/dirs to ~/.claude/backups/.
#
# Linking strategy:
#   - macOS / Linux        -> symlinks (ln -s)
#   - Windows (Git Bash)   -> directory junctions (mklink /J), because MSYS
#     ln -s silently DEEP-COPIES directories unless Developer Mode + a special
#     MSYS flag are set. Junctions need no elevation and are fully transparent.

set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
CLAUDE_DIR="${HOME}/.claude"
BACKUP_DIR="${CLAUDE_DIR}/backups/install-$(date +%Y%m%d-%H%M%S)"

case "$(uname -s)" in
  MINGW*|MSYS*|CYGWIN*) IS_WINDOWS=1 ;;
  *)                    IS_WINDOWS=0 ;;
esac

mkdir -p "$CLAUDE_DIR" "$BACKUP_DIR"

# Is $1 a Windows reparse point (junction/symlink) as opposed to a real dir?
# Note: cmd.exe args are passed UNWRAPPED — wrapping the whole command in one
# quoted string makes cmd mis-parse the nested quotes ("syntax is incorrect").
is_junction() {
  MSYS_NO_PATHCONV=1 cmd.exe /c fsutil reparsepoint query "$(cygpath -w "$1")" >/dev/null 2>&1
}

link() {
  local src="$1" dst="$2"

  if [[ $IS_WINDOWS -eq 1 ]]; then
    # Remove an existing link we manage; back up anything real.
    if [[ -e "$dst" || -L "$dst" ]]; then
      if [[ -L "$dst" ]] || is_junction "$dst"; then
        # NEVER rm -rf a junction in MSYS — it can recurse into the target.
        MSYS_NO_PATHCONV=1 cmd.exe /c rmdir "$(cygpath -w "$dst")" >/dev/null
      else
        echo "  backing up: $dst -> $BACKUP_DIR/"
        mv "$dst" "$BACKUP_DIR/"
      fi
    fi
    MSYS_NO_PATHCONV=1 cmd.exe /c mklink /J "$(cygpath -w "$dst")" "$(cygpath -w "$src")" >/dev/null
    echo "  junction: $dst -> $src"
  else
    if [[ -e "$dst" && ! -L "$dst" ]]; then
      echo "  backing up: $dst -> $BACKUP_DIR/"
      mv "$dst" "$BACKUP_DIR/"
    fi
    [[ -L "$dst" ]] && rm "$dst"
    ln -s "$src" "$dst"
    echo "  linked:   $dst -> $src"
  fi
}

echo "Linking framework into $CLAUDE_DIR"
link "$REPO_DIR/agents"    "$CLAUDE_DIR/agents"
link "$REPO_DIR/skills"    "$CLAUDE_DIR/skills"
link "$REPO_DIR/commands"  "$CLAUDE_DIR/commands"
link "$REPO_DIR/hooks"     "$CLAUDE_DIR/hooks"
link "$REPO_DIR/templates" "$CLAUDE_DIR/chip-templates"

echo ""
echo "Personal CLAUDE.md: not touched."
if [[ ! -e "$CLAUDE_DIR/CLAUDE.md" ]]; then
  echo "  You don't have one yet. Copy the template as a starting point:"
  echo "    cp \"$REPO_DIR/CLAUDE.template.md\" \"$CLAUDE_DIR/CLAUDE.md\""
  echo "  Then edit to reflect how you actually want Claude to work."
else
  echo "  You already have one at $CLAUDE_DIR/CLAUDE.md — leaving it alone."
fi

echo ""
echo "Settings: $CLAUDE_DIR/settings.json — not touched."
echo "  Merge bits from $REPO_DIR/settings.template.json by hand if useful."
echo ""
# Remove the backup dir if nothing was actually displaced into it.
rmdir "$BACKUP_DIR" 2>/dev/null && echo "Done. (No files displaced.)" || echo "Done. Backups: $BACKUP_DIR"
