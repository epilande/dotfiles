<div align="center">
  <h1>Dotfiles 🏡</h1>
</div>

<p align="center">
  Configurations for my terminal, shell, and editor managed by git and <a href="https://www.gnu.org/software/stow/">GNU Stow</a>
</p>

![output_optimized](https://github.com/user-attachments/assets/4196d682-d653-4766-af77-ce31c5243f35)

## 🌟 Overview

- Terminal: [WezTerm](https://wezfurlong.org/wezterm/) + [Tmux](https://github.com/tmux/tmux)
- Shell: [Zsh](https://www.zsh.org/) + [Starship](https://starship.rs/)
- Editor: [Neovim](https://neovim.io/)

## 📦 Installation

### Clone the Repository

```bash
git clone https://github.com/epilande/dotfiles.git ~/.dotfiles
```

### Create Symlinks

Create symlinks for all configurations:

```bash
stow --target=$HOME */
```

Create a symlink for a specific individual package (e.g., Neovim):

```bash
stow --target=$HOME nvim # ... and any other configuration you want
```

## 🍺 Homebrew

### Install Packages

Install specified packages, casks, and taps listed in the [Brewfile](./Brewfile) (requires [Homebrew](https://brew.sh/)):

```bash
brew bundle
```

### Verify Dependencies

Check if all dependencies listed in the Brewfile are installed:

```bash
brew bundle check --verbose
```

### Generate Brewfile

Generate a Brewfile from the list of currently installed Homebrew pakcages, casks, and taps:

```bash
brew bundle dump
```

## 🐚 Zsh

### Sourcing Configurations

All files in `~/.config/zsh/*` are automatically sourced.

### Local Configurations

Local configuration files for sensitive settings are ignored via `.gitignore`:

```
zsh/.config/zsh/*local*.zsh
```

This allows you to have local configuration files for any sensitive configurations that should not be included in source control.

## 🪟 Tmux

### Installation

Install Tmux Plugin Manager (TPM):

```bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### Install Plugins

Once TPM is installed, press `prefix + I` to install plugins listed in [`tmux/.config/tmux/plugins.conf`](./tmux/.config/tmux/plugins.conf).

### Local Configuration

Similarly to Zsh, local Tmux configurations are sourced if `~/.config/tmux/local.conf` exists.

## ⌨️ Neovim

My primary Neovim configuration uses LazyVim as a base, located in [`nvim/.config/nvim-lazyvim`](./nvim/.config/nvim-lazyvim), and for quick access I have aliased it as `lv`.

In addition to LazyVim, I have several other Neovim configurations that I can easily switch between using the `nvims` function. This function provides a menu for selecting different configurations, allowing me to test and experiment with various Neovim setups.

<img width="841" alt="image" src="https://github.com/user-attachments/assets/b61ebb47-5fa3-4416-b9af-a592d296c4c3">

## 🔠 Nerd Fonts

If you see boxes `□`, this means your current font doesn't support Powerline and Nerd Fonts. Install a Nerd Font from https://www.nerdfonts.com/ for shell and Neovim icons. After installation, you will need to configure your GUI/Terminal to use the font.

## ⚙️ Local Configurations

Local configurations are managed separately, kept outside of source control. This is particularly useful for storing sensitive settings or configurations that are specific to individual computers and not needed on other systems.

Here is the directory structure of my local configurations:

```
❯ tree -P '*local*' --prune -aC
.
├── nvim
│   └── .config
│       └── nvim-lazyvim
│           └── lua
│               └── plugins
│                   └── local.lua
├── tmux
│   └── .config
│       └── tmux
│           └── local.conf
└── zsh
    └── .config
        └── zsh
            ├── local-aliases.zsh
            └── local.zsh
```
