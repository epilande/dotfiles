#!/bin/bash

# Exit on error
set -e
cd "$(dirname "$0")"

echo "🚀 Starting macOS setup..."

# Install Homebrew if not installed
if ! command -v brew &>/dev/null; then
  echo "🍺 Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  # Fresh install is not on PATH until shellenv runs; Apple Silicon path.
  eval "$(/opt/homebrew/bin/brew shellenv)"
else
  echo "✅ Homebrew already installed"
  eval "$(brew shellenv)"
fi

# Install packages from Brewfile
echo "📦 Installing packages from Brewfile..."
brew bundle --no-upgrade

# Create symlinks using stow
echo "🔗 Creating symlinks..."
# Prepare a real Cursor directory, including migration from older folded links.
bash ./setup-cursor.sh
# A regular ~/.zprofile (Homebrew's installer, or the one-liner this script
# used to write) would be --adopt'ed into zsh/.zprofile and drop the Linux
# brew guard. Move it aside so stow links the tracked copy.
if [[ -e "$HOME/.zprofile" && ! -L "$HOME/.zprofile" ]]; then
  echo "🗃️ Backing up $HOME/.zprofile so stow can link the tracked copy"
  mv "$HOME/.zprofile" "$HOME/.zprofile.dotfiles-backup"
fi
# Finder drops .DS_Store files into the package dirs and stow would otherwise
# try to adopt ~/.config/.DS_Store into several packages and abort on the conflict.
stow --adopt --ignore='\.DS_Store' --target="$HOME" --restow */

./setup-common.sh

echo "✨ Setup complete!"
