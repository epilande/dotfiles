#!/bin/bash

# Exit on error
set -e

echo "🚀 Starting setup script..."

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "✅ Homebrew already installed"
fi

# Create .zprofile if it doesn't exist
if [ ! -f "$HOME/.zprofile" ]; then
  echo "📝 Creating .zprofile..."
  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >"$HOME/.zprofile"
fi

# Source Homebrew for the current session
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install packages from Brewfile
echo "📦 Installing packages from Brewfile..."
brew bundle

# Create symlinks using stow
echo "🔗 Creating symlinks..."
stow --adopt --target=$HOME --restow */

# Cursor CLI status line
# The CLI resolves its config as $CURSOR_CONFIG_DIR → $XDG_CONFIG_HOME/cursor → ~/.cursor.
# cli-config.json holds per-machine state (auth, permissions) and the CLI rewrites it,
# so we merge the statusLine key instead of symlinking the file.
echo "🎨 Configuring Cursor CLI status line..."
cursor_cfg_dir="${CURSOR_CONFIG_DIR:-${XDG_CONFIG_HOME:+$XDG_CONFIG_HOME/cursor}}"
cursor_cfg_dir="${cursor_cfg_dir:-$HOME/.cursor}"
cursor_cfg="$cursor_cfg_dir/cli-config.json"
mkdir -p "$cursor_cfg_dir"
[ -f "$cursor_cfg" ] || echo '{}' >"$cursor_cfg"
cursor_cfg_tmp=$(mktemp)
jq '.statusLine = {type: "command", command: "~/.cursor/statusline.sh", padding: 0, timeoutMs: 2000}' \
  "$cursor_cfg" >"$cursor_cfg_tmp" && mv "$cursor_cfg_tmp" "$cursor_cfg"

# Install runtimes from the global mise config (symlinked by stow above)
echo "🔧 Installing runtimes via mise..."
mise install

# Enable corepack for yarn and pnpm
# `mise activate` only works in interactive shells, so run through `mise exec`
echo "📦 Enabling corepack..."
mise exec -- corepack enable

# Setup tmux plugin manager
echo "🖥️ Setting up tmux plugin manager..."
if [ ! -d ~/.tmux/plugins/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
else
  echo "✅ tmux plugin manager already installed"
fi

echo "🔌 Installing tmux plugins..."
~/.tmux/plugins/tpm/bin/install_plugins

echo "✨ Setup complete!"
