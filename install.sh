#!/usr/bin/env bash
# install.sh — Install agent-bridge plugin for Claude Code
#
# One-liner:
#   curl -fsSL https://raw.githubusercontent.com/Kira-Pgr/agent-bridge/main/install.sh | bash
#
# Or after cloning:
#   bash install.sh

# Ensure full PATH in non-interactive shells (curl | bash)
# Add common global bin paths directly — sourcing rc files is fragile under set -e
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

REPO="https://github.com/Kira-Pgr/agent-bridge.git"
INSTALL_DIR="$HOME/.claude/plugins/agent-bridge"

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

if ! command -v git &>/dev/null; then
  fail "git not found"
  exit 1
fi
ok "git found"

# ── Step 2: Clone or update plugin ──────────────────────────
step "2. Installing plugin..."

if [ -d "$INSTALL_DIR" ]; then
  info "existing installation found, updating..."
  git -C "$INSTALL_DIR" pull --ff-only || {
    fail "could not update — remove $INSTALL_DIR and retry"
    exit 1
  }
  ok "plugin updated"
else
  mkdir -p "$(dirname "$INSTALL_DIR")"
  git clone --depth 1 "$REPO" "$INSTALL_DIR"
  ok "plugin cloned to $INSTALL_DIR"
fi

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

# ── Step 4: Register plugin permanently ──────────────────────
step "4. Registering plugin..."

SETTINGS_FILE="$HOME/.claude/settings.json"
PLUGINS_FILE="$HOME/.claude/plugins/installed_plugins.json"
PLUGIN_KEY="agent-bridge@agent-bridge"
NOW=$(date -u +"%Y-%m-%dT%H:%M:%S.000Z")
VERSION=$(grep '"version"' "$INSTALL_DIR/.claude-plugin/plugin.json" | head -1 | sed 's/.*: *"//;s/".*//')

REGISTERED=false

if command -v jq &>/dev/null; then
  # Register in installed_plugins.json
  if [ -f "$PLUGINS_FILE" ]; then
    if ! jq -e ".plugins[\"$PLUGIN_KEY\"]" "$PLUGINS_FILE" &>/dev/null; then
      jq --arg key "$PLUGIN_KEY" \
         --arg path "$INSTALL_DIR" \
         --arg ver "$VERSION" \
         --arg now "$NOW" \
         '.plugins[$key] = [{"scope":"user","installPath":$path,"version":$ver,"installedAt":$now,"lastUpdated":$now}]' \
         "$PLUGINS_FILE" > "${PLUGINS_FILE}.tmp" && mv "${PLUGINS_FILE}.tmp" "$PLUGINS_FILE"
    fi
  fi

  # Enable in settings.json
  if [ -f "$SETTINGS_FILE" ]; then
    if ! jq -e ".enabledPlugins[\"$PLUGIN_KEY\"]" "$SETTINGS_FILE" &>/dev/null; then
      jq --arg key "$PLUGIN_KEY" \
         '.enabledPlugins[$key] = true' \
         "$SETTINGS_FILE" > "${SETTINGS_FILE}.tmp" && mv "${SETTINGS_FILE}.tmp" "$SETTINGS_FILE"
    fi
  fi

  ok "plugin registered permanently"
  REGISTERED=true
else
  info "jq not found — skipping automatic registration"
fi

if [ "$REGISTERED" = false ]; then
  echo
  echo "  Register manually from inside Claude Code:"
  echo
  printf "    %s/plugin install --path %s%s\n" "$BOLD" "$INSTALL_DIR" "$NC"
fi

echo
ok "installation complete — restart Claude Code to load the plugin"
