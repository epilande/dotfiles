eval "$(starship init zsh)"

eval "$(zoxide init zsh)"

source "$(brew --prefix)/share/forgit/forgit.plugin.zsh"

source "$(brew --prefix)/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

function zvm_after_init() {
  zvm_bindkey viins "^R" fzf-history-widget
}

source "$(brew --prefix)/share/zsh-autosuggestions/zsh-autosuggestions.zsh"

source "$(brew --prefix)/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
