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

# Install asdf plugins and runtimes
echo "🔧 Setting up asdf plugins and runtimes..."

# Source asdf for current session
. "/opt/homebrew/opt/asdf/libexec/asdf.sh"

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
if current_golang=$(asdf current golang 2>/dev/null); then
  echo "✅ golang already installed: ${current_golang}"
else
  echo "🐹 Installing latest golang..."
  asdf install golang latest
  asdf reshim golang
  asdf global golang latest
fi

if current_nodejs=$(asdf current nodejs 2>/dev/null); then
  echo "✅ nodejs already installed: ${current_nodejs}"
else
  echo "🟢 Installing latest nodejs..."
  asdf install nodejs latest
  asdf reshim nodejs
  asdf global nodejs latest
fi

if current_python=$(asdf current python 2>/dev/null); then
  echo "✅ python already installed: ${current_python}"
else
  echo "🐍 Installing latest python..."
  asdf install python latest
  asdf reshim python
  asdf global python latest
fi

# Enable corepack for yarn and pnpm
echo "📦 Enabling corepack..."
"$(dirname "$(asdf which node)")/corepack" enable

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
