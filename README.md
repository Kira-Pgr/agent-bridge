# agent-bridge

> Connect AI agents together. Let Claude Code delegate tasks to GPT, Gemini, and more.

**agent-bridge** is a Claude Code plugin that bridges different AI agents, allowing them to collaborate on your tasks. When Claude gets stuck on a bug, needs a second opinion, or when you want a specific model's perspective — just delegate the task to another agent without leaving your workflow.

## Why?

Every AI model has strengths. GPT excels at certain reasoning tasks. Gemini brings its own perspective. Instead of switching between terminals and copy-pasting context, agent-bridge lets Claude hand off tasks directly to other AI CLIs and bring back the results.

```
You → Claude Code → agent-bridge → Codex CLI (GPT) → results back to Claude
                                  → Gemini CLI      → results back to Claude
```

## Supported Agents

| Agent | CLI | Models |
|-------|-----|--------|
| **codex** | [OpenAI Codex CLI](https://github.com/openai/codex) | gpt-5.4, gpt-5.3-codex, gpt-5.3-codex-spark |
| **gemini** | [Google Gemini CLI](https://github.com/google-gemini/gemini-cli) | gemini-2.5-pro, gemini-2.5-flash, gemini-3-pro, gemini-3-flash, gemini-3.1-pro-preview |

## Install

### From Claude Code (recommended)

```
/plugin marketplace add Kira-Pgr/agent-bridge
/plugin install agent-bridge
```

### One-liner

```bash
curl -fsSL https://raw.githubusercontent.com/Kira-Pgr/agent-bridge/main/install.sh | bash
```

### Prerequisites

- [Claude Code](https://docs.anthropic.com/en/docs/claude-code) v1.0.33+
- At least one agent CLI installed:
  - **Codex:** `npm install -g @openai/codex` then `codex login`
  - **Gemini:** `npm install -g @google/gemini-cli` then run `gemini` once to authenticate

## How It Works

1. You ask Claude to delegate a task to Codex or Gemini
2. Claude asks you which model and settings to use (via interactive prompt)
3. A bridge subagent spawns and runs the external CLI
4. Results come back to Claude, who summarizes what happened

The plugin uses a **SessionStart hook** to inject instructions into Claude's context, so Claude knows to ask for your model preferences before delegating.

## Usage

Ask Claude naturally:

- *"Run this through Codex for a second opinion"*
- *"Ask Gemini to review this function"*
- *"Delegate this bug to GPT — I'm stuck"*

Or spawn agents directly:

- `agent-bridge:codex` — delegates to OpenAI Codex CLI
- `agent-bridge:gemini` — delegates to Google Gemini CLI

## Architecture

```
agent-bridge/
├── .claude-plugin/
│   ├── plugin.json              # Plugin manifest with SessionStart hook
│   └── marketplace.json         # Marketplace metadata
├── agents/
│   ├── codex.md                 # Codex bridge agent
│   └── gemini.md                # Gemini bridge agent
├── scripts/
│   ├── session-context.sh       # Injects model selection instructions
│   └── check-deps.sh            # CLI dependency checker
└── install.sh                   # One-liner installer
```

## Adding a New Agent

Want to bridge another AI CLI? It's straightforward:

1. Create `agents/<name>.md` with the agent definition (see existing agents for the pattern)
2. Add the path to `plugin.json` agents array
3. Update `scripts/session-context.sh` with the new agent's model options
4. Submit a PR

## License

MIT
