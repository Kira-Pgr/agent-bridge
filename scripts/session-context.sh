#!/bin/bash
# Injects AskUserQuestion instructions into the main agent's context
# for agent-bridge model selection

cat <<'CONTEXT_EOF'
{
  "hookSpecificOutput": {
    "hookEventName": "SessionStart",
    "additionalContext": "AGENT-BRIDGE PLUGIN: Before spawning agent-bridge:codex or agent-bridge:gemini, you MUST use AskUserQuestion to ask the user which model (and reasoning effort for Codex) to use, then include their choices in the subagent prompt.\n\nCodex models: gpt-5.4 (default), gpt-5.3-codex, gpt-5.3-codex-spark (Pro only). Reasoning effort: low, medium (default), high, xhigh.\n\nGemini models: gemini-2.5-pro (default), gemini-2.5-flash, gemini-2.5-flash-lite, gemini-3-pro, gemini-3-flash, gemini-3.1-pro-preview. Aliases: pro, flash, flash-lite."
  }
}
CONTEXT_EOF
