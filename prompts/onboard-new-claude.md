# Onboard prompt — paste into any stateless Claude instance

Use this to make a Claude session (claude.ai, API playground, a teammate's Cursor) adopt your working style for that conversation. It's a thin wrapper — your actual preferences live in your personal CLAUDE.md; this prompt just tells the instance to treat them as global instructions.

## Usage

1. Copy the block between the `---` below.
2. Append the full contents of your personal `~/.claude/CLAUDE.md` after the marker.
3. Paste the combined message into the target Claude instance.

---

From this message forward, work with me under the instructions below. They're the global Claude Code instructions I load on every session. Follow them for this conversation too.

Do not re-state the rules. Acknowledge with one short line ("loaded") and wait for the actual task.

---

<!-- PASTE YOUR PERSONAL CLAUDE.md CONTENT BELOW THIS LINE -->
