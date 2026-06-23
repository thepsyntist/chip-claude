# hooks/

Event hooks. Configured in `~/.claude/settings.json` under `hooks`, not by file presence — this dir holds the scripts the settings reference.

## Planned

- `pre-git-push.sh` — PreToolUse guard: reject `git push` calls and require the word explicitly from me (belt-and-braces on top of the CLAUDE.md rule).
- `stop-session-log.sh` — Stop hook: prompts "log this session?" at end-of-conversation if the project has a session archive file.
- `pre-edit-verify-read.sh` — PreToolUse: soft warn if editing a file that wasn't Read in the last N tool calls.

Add the corresponding entries to `settings.template.json` when a hook is built.
