autoload -Uz compinit
# shellcheck disable=SC1009,SC1036,SC1072,SC1073
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit -i
else
  compinit -C -i
fi

# Load configs
for config in ~/.config/zsh/*; do
  source "$config"
done

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _files _correct _approximate
zstyle ':completion:*' format '%F{blue}Completing %d%f'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true
zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command "ps -u $USER -o pidcpu,tty,cputime,cmd"

# opencode
export PATH="$HOME/.opencode/bin:$PATH"

# Mason LSP servers (Neovim)
export PATH="$HOME/.local/share/nvim-lazyvim/mason/bin:$PATH"

set -o ignoreeof

# bun completions
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"
