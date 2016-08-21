# Dotfiles
:house_with_garden: dotfiles configuration

![Screenshot](http://i.imgur.com/Fv4Dqdf.png)


## Installation
``` bash
git clone https://github.com/epilande/dotfiles.git ~/.dotfiles
cd ~/.dotfiles
source ./install/link.sh
```

## tmux
- `brew install tmux`
- `brew install reattach-to-user-namespace`

## vim/nvim
#### Install plugins
- Open vim OR nvim
- In command mode run `:PlugInstall`

#### Nerd fonts for vim-devicons
``` bash
git clone https://github.com/ryanoasis/nerd-fonts
cd nerd-fonts
./install.sh
```

#### Instant markdown preview
`npm -g install instant-markdown-d`


### Credits
Inspiration and code was taken from many sources, including:

- [@nicknisi](https://github.com/nicknisi) – https://github.com/nicknisi/dotfiles
- [@paulirish](https://github.com/paulirish) – https://github.com/paulirish/dotfiles
- [@mathiasbynens](https://github.com/mathiasbynens) – https://github.com/mathiasbynens/dotfiles
- [@necolas](https://github.com/necolas) – https://github.com/necolas/dotfiles
- [@cowboy](https://github.com/cowboy) – https://github.com/cowboy/dotfiles
