#!/usr/bin/env bash
# install.sh — Check and install CLI dependencies for agent-bridge
#
# Usage: bash scripts/install.sh [agent...]
#   bash scripts/install.sh          # check/install all agents
#   bash scripts/install.sh codex    # check/install codex only
#   bash scripts/install.sh gemini   # check/install gemini only

set -euo pipefail

GREEN='\033[0;32m'
RED='\033[0;31m'
YELLOW='\033[0;33m'
NC='\033[0m'

ok()   { printf "${GREEN}[ok]${NC}    %s\n" "$1"; }
fail() { printf "${RED}[missing]${NC} %s\n" "$1"; }
info() { printf "${YELLOW}[info]${NC}  %s\n" "$1"; }

AGENTS=("$@")
if [ ${#AGENTS[@]} -eq 0 ]; then
  AGENTS=(codex gemini)
fi

echo "agent-bridge dependency check"
echo "=============================="
echo

MISSING=()

for agent in "${AGENTS[@]}"; do
  case "$agent" in
    codex)
      if command -v codex &>/dev/null; then
        ok "codex CLI found: $(codex --version 2>&1 | head -1)"
      else
        fail "codex CLI not found"
        MISSING+=(codex)
      fi
      ;;
    gemini)
      if command -v gemini &>/dev/null; then
        ok "gemini CLI found: $(gemini --version 2>&1 | head -1)"
      else
        fail "gemini CLI not found"
        MISSING+=(gemini)
      fi
      ;;
    *)
      info "unknown agent: $agent (skipped)"
      ;;
  esac
done

echo

if [ ${#MISSING[@]} -eq 0 ]; then
  ok "all dependencies satisfied"
  exit 0
fi

echo "Install missing dependencies?"
echo

for dep in "${MISSING[@]}"; do
  case "$dep" in
    codex)
      echo "  codex:  npm install -g @openai/codex"
      echo "          then run: codex login"
      ;;
    gemini)
      echo "  gemini: npm install -g @google/gemini-cli"
      echo "          then run: gemini  (interactive, to authenticate)"
      ;;
  esac
  echo
done

read -rp "Install now? [y/N] " answer
if [[ "$answer" != [yY]* ]]; then
  echo "Skipped. Install manually with the commands above."
  exit 1
fi

for dep in "${MISSING[@]}"; do
  case "$dep" in
    codex)
      info "installing codex CLI..."
      npm install -g @openai/codex
      ok "codex installed"
      info "run 'codex login' to authenticate"
      ;;
    gemini)
      info "installing gemini CLI..."
      npm install -g @google/gemini-cli
      ok "gemini installed"
      info "run 'gemini' interactively to authenticate"
      ;;
  esac
done

echo
ok "done"
