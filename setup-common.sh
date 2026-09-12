#!/bin/bash

# Steps shared by the macOS and Linux setup scripts, run after stow has
# symlinked the configs in.

# Exit on error
set -e
cd "$(dirname "$0")"

# Cursor CLI rewrites this file with per-machine state, so merge the status
# line setting instead of symlinking the whole config.
echo "🎨 Configuring Cursor CLI status line..."
cursor_cfg_dir="${CURSOR_CONFIG_DIR:-${XDG_CONFIG_HOME:+$XDG_CONFIG_HOME/cursor}}"
cursor_cfg_dir="${cursor_cfg_dir:-$HOME/.cursor}"
cursor_cfg="$cursor_cfg_dir/cli-config.json"
mkdir -p "$cursor_cfg_dir"
[ -f "$cursor_cfg" ] || echo '{}' >"$cursor_cfg"
cursor_cfg_tmp=$(mktemp)
jq '.statusLine = {type: "command", command: "~/.cursor/statusline.sh", padding: 0, timeoutMs: 2000}' \
  "$cursor_cfg" >"$cursor_cfg_tmp" && mv "$cursor_cfg_tmp" "$cursor_cfg"

# Install runtimes from the global mise config (symlinked by stow in the platform script)
echo "🔧 Installing runtimes via mise..."
mise install

# Enable corepack for yarn and pnpm
# `mise activate` only works in interactive shells, so run through `mise exec`
# Node 25+ no longer bundles corepack, so install it if missing
if ! mise exec -- sh -c 'command -v corepack' &>/dev/null; then
  echo "📦 Installing corepack (not bundled with Node 25+)..."
  mise exec -- npm install -g corepack
fi
echo "📦 Enabling corepack..."
mise exec -- corepack enable

# Install the AI coding CLIs with their vendor installers
./setup-ai-clis.sh

# Setup tmux plugin manager
echo "🖥️ Setting up tmux plugin manager..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo "✅ tmux plugin manager already installed"
fi

echo "🔌 Installing tmux plugins..."
~/.tmux/plugins/tpm/bin/install_plugins
