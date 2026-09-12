#!/bin/bash

# Setup for Arch-based Linux (tested on Omarchy)

# Exit on error
set -e
cd "$(dirname "$0")"

if ! command -v pacman &>/dev/null; then
  echo "❌ pacman not found; this setup requires an Arch-based distro"
  exit 1
fi

echo "🚀 Starting Linux setup..."

PACMAN_PACKAGES=(
  stow zsh zsh-autosuggestions zsh-syntax-highlighting
  bat cloc eza fd ffmpeg fzf git-delta gnupg imagemagick jq luarocks
  ripgrep tldr tree viu wl-clipboard xclip
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
    echo "❌ Install yay or install these AUR packages before rerunning setup: ${aur_missing[*]}" >&2
    exit 1
  fi
else
  echo "✅ All AUR packages already installed"
fi

# Stow packages (aerospace & karabiner are macOS-only)
STOW_PACKAGES=(bat cursor ghostty gitui hunk lazygit lvim mise nvim starship tmux wezterm yazi zsh)

# Back up pre-existing real configs that stow would conflict with
# (e.g. distro defaults from Omarchy), instead of clobbering them
BACKUP_DIR="$HOME/.config/dotfiles-backup-$(date +%Y%m%d-%H%M%S)"
package_targets() {
  (
    cd "$1" || exit 1
    find . -mindepth 1 -maxdepth 1 ! -name .config ! -name .cursor -printf '%P\n'
    # Only the managed status line may be moved; preserve Cursor auth/state.
    if [[ -f .cursor/statusline.sh ]]; then
      printf '%s\n' '.cursor/statusline.sh'
    fi
    if [[ -d .config ]]; then
      find .config -mindepth 1 -maxdepth 1 -printf '.config/%P\n'
    fi
  )
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
# Pre-create ~/.cursor so stow links per-file instead of folding the whole
# directory, which other tools keep live state in
mkdir -p "$HOME/.cursor"
if ! stow --restow --target="$HOME" "${STOW_PACKAGES[@]}"; then
  echo "❌ stow failed"
  [[ -d "$BACKUP_DIR" ]] && echo "💡 Pre-existing configs were moved to $BACKUP_DIR"
  exit 1
fi

# Keep Linux-specific Ghostty settings out of the macOS-first tracked config.
ghostty_local="$HOME/.config/ghostty/local.conf"
if [[ ! -f "$ghostty_local" ]]; then
  cat >"$ghostty_local" <<'EOF'
# Omarchy/Linux overrides
config-file = ?"~/.local/state/omarchy/current/theme/ghostty.conf"
font-family = ""
font-family = JetBrainsMono Nerd Font Mono
font-family-bold = ""
font-family-italic = ""
font-size = 10
EOF
fi

./setup-common.sh

if [[ "$(getent passwd "$USER" | cut -d: -f7)" != *zsh ]]; then
  echo "💡 To make zsh your login shell: chsh -s /usr/bin/zsh"
fi

echo "✨ Setup complete!"
