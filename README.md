<div align="center">
  <h1>Dotfiles 🏡</h1>
</div>

<p align="center">
  Configurations for my terminal, shell, and editor managed by git and <a href="https://www.gnu.org/software/stow/">GNU Stow</a>
</p>

![output_optimized](https://github.com/user-attachments/assets/ec87df2c-9ebc-4f6e-990d-03f19e96d1c7)

## 🌟 Overview

- Terminal: [WezTerm](https://wezfurlong.org/wezterm/) + [Tmux](https://github.com/tmux/tmux)
- Shell: [Zsh](https://www.zsh.org/) + [Starship](https://starship.rs/)
- Editor: [Neovim](https://neovim.io/) based on [LazyVim](https://www.lazyvim.org/)
- Theme: [Catppuccin](https://catppuccin.com/)

## 📦 Installation

### Clone the Repository

```bash
git clone https://github.com/epilande/dotfiles.git ~/.dotfiles
```

## 🍺 Homebrew

### Install Packages

Install [Homebrew](https://brew.sh), then run the following to install specified packages, casks, and taps listed in the [Brewfile](./Brewfile):

```bash
brew bundle
```

<details>
<summary><strong>Verify Dependencies</strong></summary>

Check if all dependencies listed in the Brewfile are installed:

```bash
brew bundle check --verbose
```
</details>

<details>
<summary><strong>Generate Brewfile</strong></summary>

Generate a Brewfile from the list of currently installed Homebrew pakcages, casks, and taps:

```bash
brew bundle dump
```
</details>

### Create Symlinks

Create symlinks for all configurations:

```bash
stow --target=$HOME */
```

Or create a symlink for a specific individual package (e.g., Neovim):

```bash
stow --target=$HOME nvim # ... and any other configuration you want
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
| `M-t` (⌥ + t)      | Open Tmux Toolbox menu                     |
| `M-g` (⌥ + g)      | Toggle Lazygit in a popup window           |
| `M-n` (⌥ + n)      | Toggle "notes" session in a popup window   |
| `prefix + C-f`     | Fuzzy find and switch between tmux windows |
| `prefix + b`       | Switch to the last active session          |

#### Key Features

1. **Tmux Toolbox** (`M-t`): A menu providing quick access to common tmux actions like creating new windows/sessions, changing layouts, and managing panes.

2. **Lazygit Integration** (`M-g`): Instantly access git operations in a popup window from anywhere within tmux. This allows you to manage your git repositories without leaving your current session, whether you're in Neovim, browsing files, or running any other process. The popup can be easily toggled, maintaining your workflow continuity.

3. **Notes Session** (`M-n`): Toggle a dedicated "notes" tmux session accessible from anywhere. If you're in another session, this will open your notes in a popup window, allowing quick access to your notes without disrupting your current work context.

4. **Fuzzy Find Windows** (`prefix + C-f`): Open a fuzzy finder to quickly switch between tmux windows using a custom `tmw` script.

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

## 🖥️ WezTerm

[WezTerm](https://wezfurlong.org/wezterm/) is a powerful, GPU-accelerated cross-platform terminal emulator and multiplexer. Its Lua-based configuration enables deep customization, allowing for a highly tailored and efficient terminal experience that adapts to your workflow.

### WezTerm Key Mappings

| Key Binding       | Action                     |
| ----------------- | -------------------------- |
| `CMD + t`         | Create new tmux window     |
| `CMD + x`         | Close tmux pane            |
| `CMD + [1-9,0]`   | Switch to tmux window 1-10 |
| `CMD + SHIFT + P` | Activate command palette   |

For a complete list of key bindings, refer to [`wezterm/.config/wezterm/wezterm.lua`](./wezterm/.config/wezterm/wezterm.lua).

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
