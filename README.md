<div align="center">
  <h1>Dotfiles 🏡</h1>
</div>

<p align="center">
  Configurations for my terminal, shell, and editor managed by git and <a href="https://www.gnu.org/software/stow/">GNU Stow</a>
</p>

![output_optimized](https://github.com/user-attachments/assets/ec87df2c-9ebc-4f6e-990d-03f19e96d1c7)

## 🌟 Overview

- Terminal: [Ghostty](https://ghostty.org/) + [Tmux](https://github.com/tmux/tmux)
- Shell: [Zsh](https://www.zsh.org/) + [Starship](https://starship.rs/)
- Editor: [Neovim](https://neovim.io/) based on [LazyVim](https://www.lazyvim.org/)
- Version Manager: [mise](https://mise.jdx.dev/)
- File Manager: [Yazi](https://github.com/sxyazi/yazi)
- Theme: [Catppuccin](https://catppuccin.com/)

## 📦 Installation

### Clone the Repository

```bash
git clone https://github.com/epilande/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
```

### Automated Setup

Run the automated setup script to install and configure everything:

```bash
chmod +x ./setup*.sh && ./setup.sh
```

`setup.sh` detects the OS and dispatches to `setup-macos.sh` or `setup-linux.sh`.

#### On macOS this will:

- Install Homebrew and packages from Brewfile
- Create symlinks for all configurations using stow
- Set up runtime environments (Node.js, Python, Go, Rust) via mise
- Install and configure Tmux with plugins
- Set up package managers (yarn, pnpm) via corepack

#### On Linux (Arch-based, e.g. Omarchy) this will:

- Install packages via pacman (plus `zsh-vi-mode` and `forgit` from the AUR via yay)
- Back up any pre-existing configs (e.g. distro defaults) to `~/.config/dotfiles-backup-<timestamp>/`
- Create symlinks using stow, skipping the macOS-only `aerospace` and `karabiner` packages
- Set up mise runtimes, corepack, and Tmux plugins

Machine-specific mise tools (e.g. Omarchy's `claude`/`codex`/`gh`) can live in
`~/.config/mise/conf.d/*.toml`, which is gitignored and merged by mise alongside
the main config.

#### Platform notes

- `zsh/.config/zsh/00-platform.zsh` detects the OS and exports `$CLIP_COPY` /
  `$CLIP_PASTE` (pbcopy/pbpaste on macOS, wl-copy/wl-paste or xclip on Linux),
  which the fzf, tmux, and yazi configs use for clipboard integration.
- Ghostty keybindings use `cmd`, which maps to ⌘ on macOS and Super on Linux.
- On Omarchy, Ghostty follows the system theme via an optional `config-file`
  include; on macOS it falls back to Catppuccin Mocha.

> [!NOTE]
> If you run the automated setup you're pretty much done here.
> If you prefer to install components individually, continue reading.

### macOS System Preferences

Configure sensible MacOS defaults:

```bash
chmod +x ./macos.sh && ./macos.sh
```

## 🔗 Create Symlinks

Create symlinks for all configurations:

```bash
stow --target=$HOME */
```

Or create a symlink for a specific individual package (e.g., Neovim):

```bash
stow --target=$HOME nvim # ... and any other configuration you want
```

## 🍺 Homebrew

### Install Packages

Install [Homebrew](https://brew.sh), then run the following to install specified packages, casks, and taps listed in the [Brewfile](./Brewfile):

```bash
brew bundle
```

### Verify Dependencies

Check if all dependencies listed in the Brewfile are installed:

```bash
brew bundle check --verbose
```

### Generate Brewfile

Generate a Brewfile from the list of currently installed Homebrew packages, casks, and taps:

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

### Tmux Key Mappings

Tmux is configured with several custom key bindings to enhance productivity and ease of use. Here are the most notable mappings:

| Key Binding        | Description                                |
| ------------------ | ------------------------------------------ |
| `prefix + r`       | Reload tmux configuration                  |
| `prefix + \|`      | Split window vertically                    |
| `prefix + -`       | Split window horizontally                  |
| `prefix + h/j/k/l` | Navigate panes                             |
| `prefix + C-h/C-l` | Switch to previous/next window             |
| `prefix + T`       | Set the current pane title                 |
| `prefix + t`       | Toggle pane titles on/off (all windows)    |
| `M-t` (⌥ + t)      | Open Tmux Toolbox menu                     |
| `M-g` (⌥ + g)      | Toggle Lazygit in a popup window           |
| `M-h` (⌥ + h)      | Toggle Hunk diff viewer in a popup window  |
| `M-n` (⌥ + n)      | Toggle "notes" session in a popup window   |
| `M-c` (⌥ + c)      | Open ccmux in a popup window               |
| `prefix + C-f`     | Fuzzy find and switch between tmux windows |
| `prefix + b`       | Switch to the last active session          |

#### Key Features

1. **Tmux Toolbox** (`M-t`): A menu providing quick access to common tmux actions like creating new windows/sessions, changing layouts, and managing panes.

2. **Lazygit Integration** (`M-g`): Instantly access git operations in a popup window from anywhere within tmux. This allows you to manage your git repositories without leaving your current session, whether you're in Neovim, browsing files, or running any other process. The popup can be easily toggled, maintaining your workflow continuity.

3. **Hunk Diff Viewer** (`M-h`): Review the working tree diff in [Hunk](https://hunk.dev/) from a popup window. Lazygit is also configured with an `H` custom command to open the working tree or a selected commit in Hunk.

4. **Notes Session** (`M-n`): Toggle a dedicated "notes" tmux session accessible from anywhere. If you're in another session, this will open your notes in a popup window, allowing quick access to your notes without disrupting your current work context.

5. **ccmux** (`M-c` or `prefix + C-p`): Open [ccmux](https://github.com/epilande/ccmux) in a popup to monitor and switch between AI coding agent sessions.

6. **Fuzzy Find Windows** (`prefix + C-f`): Open a fuzzy finder to quickly switch between tmux windows using a custom `tmw` script.

For a complete list of key bindings, refer to [`tmux/.config/tmux/keymaps.conf`](./tmux/.config/tmux/keymaps.conf).

### Troubleshooting

<details>
<summary>If you're experiencing an issue where tmux repeats characters unexpectedly</summary>

```sh
infocmp -x tmux-256color >tmux-256color.src
tic -x tmux-256color.src
```

</details>

## 💻 Neovim

My primary Neovim configuration uses LazyVim as a base, located in [`nvim/.config/nvim-lazyvim`](./nvim/.config/nvim-lazyvim), and for quick access I have aliased it as `lv`.

In addition to LazyVim, I have several other Neovim configurations that I can easily switch between using the `nvims` function. This function provides a menu for selecting different configurations, allowing me to test and experiment with various Neovim setups.

<img width="841" alt="image" src="https://github.com/user-attachments/assets/ae77dede-b81a-45b7-bcb2-bc378a667b96">

## 🔠 Nerd Fonts

If you see boxes `□`, this means your current font doesn't support Powerline and Nerd Fonts. Install a Nerd Font from https://www.nerdfonts.com/ for shell and Neovim icons. After installation, you will need to configure your GUI/Terminal to use the font.

## ⌨️ Karabiner-Elements

[Karabiner-Elements](https://karabiner-elements.pqrs.org/) is a powerful keyboard customizer for MacOS. I use it to modify my keyboard behavior and improve my workflow. My configuration file is located at [`karabiner/.config/karabiner/karabiner.json`](./karabiner/.config/karabiner/karabiner.json). This setup allows me to maintain a consistent typing experience across different keyboards and computers.

### Key Modifications

1. **Caps Lock Remap**: ⇪ Caps Lock is remapped to act as ⌃ Control when held, and ⎋ Escape when tapped.
2. **Hyper Key**: Holding ⇥ Tab acts as a "Hyper" key (Command+Shift+Control+Option), while tapping Tab functions as normal.
3. **Meh Key**: Holding \\ Backslash acts as a "Meh" key (Shift+Control+Option), while tapping \\ Backslash types \\ as normal.

The Hyper and Meh keys allow me to set up a large number of unique shortcuts for various applications and system functions.

## 🖥️ Ghostty

[Ghostty](https://ghostty.org/) is a fast, feature-rich, and cross-platform terminal emulator that uses platform-native UI and GPU acceleration.

### Ghostty Key Mappings

| Key Binding       | Action                    |
| ----------------- | ------------------------- |
| `CMD + t`         | Create new tmux window    |
| `CMD + x`         | Close tmux pane           |
| `CMD + 1-9`       | Switch to tmux window 1-9 |
| `CMD + SHIFT + R` | Reload Ghostty config     |

For a complete list of key bindings, refer to [`ghostty/.config/ghostty/config`](./ghostty/.config/ghostty/config).

## ⚙️ Local Configurations

Local configurations are managed separately, kept outside of source control. This is particularly useful for storing sensitive settings or configurations that are specific to individual computers and not needed on other systems.

<details>
<summary>Directory structure of my local configurations</summary>

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

</details>
