# Contributing — agent-bridge

## Adding a New Agent

1. Create `agents/<name>.md` — subagent definition with clear, direct invocation instructions
2. Create `skills/<name>/SKILL.md` — manual skill trigger
3. Test that the agent runs the external CLI on its first turn without fumbling
4. Update the supported agents table in README.md

## Guidelines

- Agent definitions should be **direct and minimal** — tell the agent exactly what command to run
- Avoid wrapper scripts unless absolutely necessary — call the external CLI directly
- Don't rely on environment variables that may not be set (e.g. `CLAUDE_PLUGIN_ROOT`)
- Keep `maxTurns` low (3-5) since agents should just run a command and report results

## Issues & PRs

- File an issue before opening a PR unless the fix is trivial
- Review before merge
