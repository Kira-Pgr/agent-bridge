# agent-bridge

> Claude Code plugin: delegate tasks to external AI agents

A Claude Code plugin that lets Claude delegate tasks to external AI CLI agents for alternative perspectives, stubborn bugs, or when a different model may perform better.

## Supported Agents

| Agent | CLI | Description |
|-------|-----|-------------|
| **codex** | [OpenAI Codex CLI](https://github.com/openai/codex) | GPT-series models via `codex exec` |
| **gemini** | [Google Gemini CLI](https://github.com/google-gemini/gemini-cli) | Gemini models via `gemini -p` |

## How it works

```
Claude Code → subagent "codex" → codex exec --full-auto
```

- **Subagent** (`agents/codex.md`) — Claude auto-delegates when appropriate
- **Skill** (`skills/codex/SKILL.md`) — Manual trigger via `/agent-bridge:codex <task>`

## Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) v1.0.33+
- The CLI for whichever agent you want to use (e.g. `npm install -g @openai/codex`)

## Install

```bash
git clone https://github.com/Kira-Pgr/agent-bridge.git

# Option 1: Load for current session
claude --plugin-dir ./agent-bridge

# Option 2: Install permanently
# In Claude Code, run:
#   /plugin install --path ./agent-bridge
```

## Usage

### Automatic (subagent)

Claude will automatically delegate to an external agent when it determines a second opinion would help.

### Manual (skill)

```
/agent-bridge:codex fix the race condition in src/worker.ts
```

## Architecture

```
agent-bridge/
├── .claude-plugin/
│   └── plugin.json          # Plugin manifest
├── agents/
│   └── codex.md             # Codex subagent definition
├── skills/
│   └── codex/
│       └── SKILL.md         # Manual codex skill trigger
└── README.md
```

## Adding a new agent

1. Create `agents/<name>.md` with the agent definition
2. Create `skills/<name>/SKILL.md` for manual invocation
3. Add any required scripts to `scripts/` if needed
4. Update the supported agents table in this README

## License

MIT
