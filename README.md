# Dotfiles
:house_with_garden: dotfiles configuration

![Screenshot](http://i.imgur.com/Fv4Dqdf.png)


## Installation
#### Clone this repo
First step, clone the dotfiles repository to your computer. This can be placed anywhere, and symbolic links will be created to reference it from your home directory.
``` bash
$ git clone https://github.com/epilande/dotfiles.git ~/.dotfiles
$ cd ~/.dotfiles
```

#### Symlink
Every file with a `.symlink` extension will be symlinked to the `~/` home directory with a `.` in front of it. For example, `vimrc.symlink` will be symlinked in the home directory as `~/.vimrc`. Additionally, all files in the `$DOTFILES/config` directory will be symlinked to the `~/.config/` directory for applications that follow the XDG base directory specification, such as neovim.
``` bash
$ source ./install/link.sh
```

#### Install Homebrew formulae
Install homebrew if it is not currently installed, then install the homebrew packages listed in [`brew.sh`](install/brew.sh).
```bash
$ source ./install/brew.sh
```

#### Install native apps
Use brew cask to install native apps listed in [`brew-cask.sh`](install/brew-cask.sh).
```bash
$ source ./install/brew-cask.sh
```


## Neovim
#### Install plugins
Vim plugins are managed by [vim-plug](https://github.com/junegunn/vim-plug), when opening vim for the first time run:
```bash
$ nvim +PlugInstall
```

##### Nerd fonts for vim-devicons
If you're seeing boxes `□`, this means your current font does not support
powerline & nerd fonts. Install [nerd-fonts](https://github.com/ryanoasis/nerd-fonts#font-installation) and configure your gui/terminal, in my case iTerm, to use a patched font for non-ascii characters. If you prefer not to do this, then simply remove the `Plug 'ryanoasis/vim-devicons'` plugin from [`plugins.vim`](vim/vim.symlink/plugins.vim).

My default font is currently `Monaco`, and for non-ascii characters I'm using `Droid Sans Mono Nerd Font`.


### Node packages
```bash
$ npm install -g instant-markdown-d eslint jsonlint stylelint
```


### Credits
Inspiration and code was taken from many sources, including:

- [@nicknisi](https://github.com/nicknisi) – https://github.com/nicknisi/dotfiles
- [@paulirish](https://github.com/paulirish) – https://github.com/paulirish/dotfiles
- [@mathiasbynens](https://github.com/mathiasbynens) – https://github.com/mathiasbynens/dotfiles
- [@necolas](https://github.com/necolas) – https://github.com/necolas/dotfiles
- [@cowboy](https://github.com/cowboy) – https://github.com/cowboy/dotfiles
