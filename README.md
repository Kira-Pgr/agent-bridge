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
Claude Code → subagent "gemini" → gemini -p --approval-mode yolo
```

## Install

### From Claude Code (recommended)

```
/plugin marketplace add Kira-Pgr/agent-bridge
```

Then go to the **Discover** tab and install **agent-bridge**.

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/Kira-Pgr/agent-bridge/main/install.sh | bash
```

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) v1.0.33+
- At least one agent CLI installed:
  - `npm install -g @openai/codex` for Codex
  - `npm install -g @google/gemini-cli` for Gemini

## Architecture

```
agent-bridge/
├── .claude-plugin/
│   ├── plugin.json          # Plugin manifest
│   └── marketplace.json     # Marketplace definition
├── agents/
│   ├── codex.md             # Codex subagent
│   └── gemini.md            # Gemini subagent
├── scripts/
│   └── check-deps.sh        # CLI dependency checker
└── install.sh               # One-liner installer
```

## Adding a new agent

1. Create `agents/<name>.md` with the agent definition
2. Add the path to `plugin.json` agents array
3. Update the supported agents table in this README

## License

MIT
