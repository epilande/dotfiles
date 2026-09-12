#!/bin/bash

# Exit on error
set -e
cd "$(dirname "$0")"

echo "🚀 Starting macOS setup..."

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
# Pre-create ~/.cursor so stow links per-file instead of folding the whole
# directory, which other tools keep live state in
mkdir -p "$HOME/.cursor"
stow --adopt --target=$HOME --restow */

./setup-common.sh

echo "✨ Setup complete!"
