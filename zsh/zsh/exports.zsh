export PATH="/usr/local/bin:$PATH"

# Language Support
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color

# neovim as default
export EDITOR="nvim"

# export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

# Load NVM
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm

# Load fzf
# export FZF_DEFAULT_COMMAND="ag --hidden --ignore .git -f -g "" -u"
export FZF_DEFAULT_COMMAND="ag -g ''"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

