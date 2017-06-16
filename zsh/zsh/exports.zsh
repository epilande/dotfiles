export PATH="/usr/local/bin:$PATH"
# export PATH=$HOME/bin:/usr/local/bin:$PATH
# Update PATH variable to access yarn binaries
export PATH="$PATH:`yarn global bin`"

# Language Support
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

# Set colors to match iTerm2 Terminal Colors
export TERM=xterm-256color

# neovim as default
# export EDITOR="nvim"
# vim as default
export EDITOR="nvim"


# export HOMEBREW_CASK_OPTS="--appdir=~/Applications"

# Load NVM
export NVM_DIR="$HOME/.nvm"
. "/usr/local/opt/nvm/nvm.sh"

# Load fzf
# export FZF_DEFAULT_COMMAND="ag --hidden --ignore .git -f -g "" -u"
export FZF_DEFAULT_COMMAND="ag -g ''"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
