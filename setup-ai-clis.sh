#!/bin/bash

# Install the AI coding CLIs with their vendor installers.
#
# Omarchy preinstalls claude/codex/opencode as mise-backed wrappers in
# ~/.local/bin (see /usr/share/omarchy/install/user/mise.sh). Each wrapper runs
# `mise use -g <tool>` on every invocation, which writes the tool into
# ~/.config/mise/config.toml -- the file stow symlinks in from this repo, so a
# plain `claude` run dirties the working tree -- and leaves each CLI's own
# self-update path dead (`codex doctor` reports "install method: other").
# Install them the vendor way instead, so `claude update`, `codex update`, and
# `opencode upgrade` all work.

set -e

echo "🤖 Installing AI coding CLIs..."

# Drop Omarchy's mise wrappers and any mise entries they left behind
for cmd in claude codex opencode; do
  wrapper="$HOME/.local/bin/$cmd"
  if [[ -f "$wrapper" ]] && grep -q 'mise use -g' "$wrapper"; then
    echo "🧹 Removing Omarchy mise wrapper: $cmd"
    rm -f "$wrapper"
  fi
  mise unuse "$cmd" &>/dev/null || true
done

# Claude Code: native build, self-updates via `claude update`
if [[ -x "$HOME/.local/bin/claude" ]]; then
  echo "✅ Claude Code already installed"
else
  echo "📦 Installing Claude Code..."
  curl -fsSL https://claude.ai/install.sh | bash
fi

# Codex: npm is OpenAI's documented install and what `codex update` drives.
# It lands in mise's node prefix, so a node version bump loses it -- the check
# below reinstalls on the next setup run (same as the corepack handling).
if mise exec -- npm ls -g --depth=0 @openai/codex &>/dev/null; then
  echo "✅ Codex already installed"
else
  echo "📦 Installing Codex..."
  mise exec -- npm install -g @openai/codex
fi

# opencode: installs to ~/.opencode/bin, which zsh/01-environment.zsh puts on
# PATH; self-updates via `opencode upgrade`
if [[ -x "$HOME/.opencode/bin/opencode" ]]; then
  echo "✅ opencode already installed"
else
  echo "📦 Installing opencode..."
  curl -fsSL https://opencode.ai/install | bash
fi

# Cursor Agent: no mise backend exists for it, so there was never an Omarchy
# wrapper to clean up. Installs a versioned build under
# ~/.local/share/cursor-agent and symlinks both `agent` (primary) and
# `cursor-agent` (legacy) into ~/.local/bin; self-updates via `agent update`.
if [[ -x "$HOME/.local/bin/agent" ]]; then
  echo "✅ Cursor Agent already installed"
else
  echo "📦 Installing Cursor Agent..."
  curl -fsS https://cursor.com/install | bash
fi
