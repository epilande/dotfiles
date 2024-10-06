# Load asdf
source "$(brew --prefix)/opt/asdf/libexec/asdf.sh"

export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH

export XDG_CONFIG_HOME="$HOME/.config"

export EDITOR='NVIM_APPNAME=nvim-lazyvim nvim'

# Go development
. ~/.asdf/plugins/golang/set-env.zsh
export ASDF_GOLANG_MOD_VERSION_ENABLED=true
export GOROOT=$(go env GOROOT)
export GOBIN=$(dirname ${GOROOT:A})/bin
export PATH=$PATH:$GOBIN

# FZF
export FZF_DEFAULT_COMMAND="fd --type f"
# export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --vimgrep --pretty --glob '!{.git,node_modules}'"
# export FZF_DEFAULT_COMMAND="rg --files --hidden --follow --vimgrep --no-ignore-vcs --pretty --glob '!{.git,node_modules}'"
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

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
