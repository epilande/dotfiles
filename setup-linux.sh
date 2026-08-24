#!/bin/bash

# Setup for Arch-based Linux (tested on Omarchy)

# Exit on error
set -e
cd "$(dirname "$0")"

echo "🚀 Starting Linux setup..."

PACMAN_PACKAGES=(
  stow zsh zsh-autosuggestions zsh-syntax-highlighting
  bat cloc eza fd ffmpeg fzf git-delta gnupg imagemagick jq luarocks
  ripgrep tldr tree viu wl-clipboard
  ghostty gitui lazygit mise neovim starship tmux yazi zoxide
)
AUR_PACKAGES=(zsh-vi-mode forgit)

# Install official packages (skip sudo entirely if nothing is missing)
missing=$(pacman -T "${PACMAN_PACKAGES[@]}" || true)
if [[ -n "$missing" ]]; then
  echo "📦 Installing packages: $missing"
  # shellcheck disable=SC2086
  sudo pacman -S --needed --noconfirm $missing
else
  echo "✅ All official packages already installed"
fi

# Install AUR packages
aur_missing=()
for pkg in "${AUR_PACKAGES[@]}"; do
  pacman -Qq "$pkg" &>/dev/null || aur_missing+=("$pkg")
done
if [[ ${#aur_missing[@]} -gt 0 ]]; then
  if command -v yay &>/dev/null; then
    echo "📦 Installing AUR packages: ${aur_missing[*]}"
    yay -S --needed --noconfirm "${aur_missing[@]}"
  else
    echo "⚠️ yay not found; install AUR packages manually: ${aur_missing[*]}"
  fi
else
  echo "✅ All AUR packages already installed"
fi

# Stow packages (aerospace & karabiner are macOS-only)
STOW_PACKAGES=(bat ghostty gitui hunk lazygit lvim mise nvim starship tmux wezterm yazi zsh)

# Back up pre-existing real configs that stow would conflict with
# (e.g. distro defaults from Omarchy), instead of clobbering them
BACKUP_DIR="$HOME/.config/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
package_targets() {
  (cd "$1" &&
    find . -mindepth 1 -maxdepth 1 ! -name .config -printf '%P\n'
    if [[ -d .config ]]; then
      find .config -mindepth 1 -maxdepth 1 -printf '.config/%P\n'
    fi)
}
for pkg in "${STOW_PACKAGES[@]}"; do
  while IFS= read -r rel; do
    target="$HOME/$rel"
    if [[ -e "$target" && ! -L "$target" ]]; then
      echo "🗃️ Backing up $target -> $BACKUP_DIR/$rel"
      mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
      mv "$target" "$BACKUP_DIR/$rel"
    fi
  done < <(package_targets "$pkg")
done

# Create symlinks using stow
echo "🔗 Creating symlinks..."
stow --restow --target="$HOME" "${STOW_PACKAGES[@]}"

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

if [[ "$(getent passwd "$USER" | cut -d: -f7)" != *zsh ]]; then
  echo "💡 To make zsh your login shell: chsh -s /usr/bin/zsh"
fi

echo "✨ Setup complete!"
