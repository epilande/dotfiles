# Cache brew prefix (only compute once per session)
export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"

# Load asdf
source "$HOMEBREW_PREFIX/opt/asdf/libexec/asdf.sh"

export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH

export XDG_CONFIG_HOME="$HOME/.config"

export EDITOR='env NVIM_APPNAME=nvim-lazyvim nvim'

# Go development
. ~/.asdf/plugins/golang/set-env.zsh
export ASDF_GOLANG_MOD_VERSION_ENABLED=true
# Cache GOROOT - only compute if not set or directory doesn't exist
if [[ -z "$GOROOT" ]] || [[ ! -d "$GOROOT" ]]; then
  export GOROOT=$(go env GOROOT)
fi
export GOBIN=$(dirname ${GOROOT:A})/bin
export PATH=$PATH:$GOBIN

# FZF
export FZF_DEFAULT_COMMAND="fd --type f --hidden"
source ~/.config/zsh/fzf-keybindings.zsh

export FZF_DEFAULT_OPTS="--reverse"

export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

export FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'
  --bind 'ctrl-y:execute-silent(echo -n {2..} | pbcopy)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"

export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {} | head -50'"

export FZF_TMUX_OPTS="-p90%,70%"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
