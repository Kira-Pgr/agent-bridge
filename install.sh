#!/usr/bin/env bash
# install.sh — Install agent-bridge plugin for Claude Code
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/Kira-Pgr/agent-bridge/main/install.sh | bash
#
# Or just use the Claude Code plugin system directly:
#   /plugin marketplace add Kira-Pgr/agent-bridge
#   Then install from the Discover tab

# Ensure full PATH in non-interactive shells (curl | bash)
export PATH="/opt/homebrew/bin:/usr/local/bin:$HOME/.npm-global/bin:$HOME/.local/bin:$PATH"

set -euo pipefail

GREEN=$'\033[0;32m'
RED=$'\033[0;31m'
YELLOW=$'\033[0;33m'
CYAN=$'\033[0;36m'
BOLD=$'\033[1m'
NC=$'\033[0m'

ok()   { printf "%s[ok]%s    %s\n" "$GREEN" "$NC" "$1"; }
fail() { printf "%s[fail]%s  %s\n" "$RED" "$NC" "$1"; }
info() { printf "%s[info]%s  %s\n" "$YELLOW" "$NC" "$1"; }
step() { printf "\n%s%s%s%s\n" "$CYAN" "$BOLD" "$1" "$NC"; }

echo
printf "%sagent-bridge installer%s\n" "$BOLD" "$NC"
echo "======================"
echo "Delegate tasks to external AI agents (Codex, Gemini, ...)"
echo

# ── Step 1: Check prerequisites ─────────────────────────────
step "1. Checking prerequisites..."

if ! command -v claude &>/dev/null; then
  fail "Claude Code CLI not found"
  echo "  Install from: https://docs.anthropic.com/en/docs/claude-code"
  exit 1
fi
ok "Claude Code CLI found"

# ── Step 2: Add marketplace and install plugin ───────────────
step "2. Installing plugin..."

info "adding agent-bridge marketplace..."
claude plugin marketplace add Kira-Pgr/agent-bridge 2>&1 || true

info "installing agent-bridge plugin..."
claude plugin install agent-bridge 2>&1 || {
  fail "automatic install failed"
  echo
  echo "  Try installing manually from inside Claude Code:"
  echo
  printf "    %s/plugin marketplace add Kira-Pgr/agent-bridge%s\n" "$BOLD" "$NC"
  echo "    Then go to Discover tab and install agent-bridge"
  echo
  exit 1
}
ok "plugin installed"

# ── Step 3: Check agent CLI dependencies ────────────────────
step "3. Checking agent CLIs..."

MISSING=()

if command -v codex &>/dev/null; then
  ok "codex CLI found: $(codex --version 2>&1 | head -1)"
else
  info "codex CLI not found (optional)"
  MISSING+=(codex)
fi

if command -v gemini &>/dev/null; then
  ok "gemini CLI found: $(gemini --version 2>&1 | head -1)"
else
  info "gemini CLI not found (optional)"
  MISSING+=(gemini)
fi

if [ ${#MISSING[@]} -gt 0 ]; then
  echo
  echo "  Install missing agent CLIs to use them:"
  for dep in "${MISSING[@]}"; do
    case "$dep" in
      codex)  echo "    npm install -g @openai/codex  && codex login" ;;
      gemini) echo "    npm install -g @google/gemini-cli" ;;
    esac
  done

  echo
  read -rp "  Install missing CLIs now? [y/N] " answer
  if [[ "$answer" == [yY]* ]]; then
    for dep in "${MISSING[@]}"; do
      case "$dep" in
        codex)
          info "installing codex..."
          npm install -g @openai/codex
          ok "codex installed — run 'codex login' to authenticate"
          ;;
        gemini)
          info "installing gemini..."
          npm install -g @google/gemini-cli
          ok "gemini installed — run 'gemini' once to authenticate"
          ;;
      esac
    done
  fi
fi

echo
ok "installation complete — restart Claude Code to load the plugin"
