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

# Install packages from Brewfile
echo "📦 Installing packages from Brewfile..."
brew bundle

# Create symlinks using stow
echo "🔗 Creating symlinks..."
stow --target=$HOME --restow */

# Install asdf plugins and runtimes
echo "🔧 Setting up asdf plugins and runtimes..."

# Install asdf plugins if not already installed
declare -a plugins=("golang" "nodejs" "python")

for plugin in "${plugins[@]}"; do
  if ! asdf plugin list | grep -q "^$plugin$"; then
    echo "🔌 Installing asdf plugin: $plugin"
    asdf plugin add "$plugin"
  else
    echo "✅ asdf plugin $plugin already installed"
  fi
done

# Install latest versions and set global
echo "🐹 Installing latest golang..."
asdf install golang latest
asdf reshim golang
asdf global golang latest

echo "🟢 Installing latest nodejs..."
asdf install nodejs latest
asdf reshim nodejs
asdf global nodejs latest

echo "🐍 Installing latest python..."
asdf install python latest
asdf reshim python
asdf global python latest

# Enable corepack for yarn and pnpm
echo "📦 Enabling corepack..."
corepack enable

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
