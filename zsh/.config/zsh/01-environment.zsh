if [[ -n "$SSH_CONNECTION" ]]; then
  [[ "$TERM" == "xterm-ghostty" ]] && export TERM=xterm-256color
fi

# Load mise
eval "$(mise activate zsh)"

export PATH=$HOME/bin:/usr/local/bin:$HOME/.local/bin:$PATH

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# Mason LSP servers (Neovim)
export PATH="$HOME/.local/share/nvim-lazyvim/mason/bin:$PATH"

export XDG_CONFIG_HOME="$HOME/.config"

export NVIM_APPNAME="nvim-lazyvim"
export EDITOR="nvim"

# FZF
export FZF_DEFAULT_COMMAND="fd --type f --hidden"
source ~/.config/zsh/fzf-keybindings.zsh

export FZF_DEFAULT_OPTS="--reverse"

export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'bat -n --color=always {}'
  --bind 'ctrl-/:change-preview-window(down|hidden|)'"

FZF_CTRL_R_OPTS="
  --preview 'echo {}' --preview-window up:3:hidden:wrap
  --bind 'ctrl-/:toggle-preview'"
if [[ -n "$CLIP_COPY" ]]; then
  FZF_CTRL_R_OPTS+="
  --bind 'ctrl-y:execute-silent(echo -n {2..} | $CLIP_COPY)+abort'
  --color header:italic
  --header 'Press CTRL-Y to copy command into clipboard'"
fi
export FZF_CTRL_R_OPTS

export FZF_ALT_C_OPTS="
  --walker-skip .git,node_modules,target
  --preview 'tree -C {} | head -50'"

export FZF_TMUX_OPTS="-p90%,70%"

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
