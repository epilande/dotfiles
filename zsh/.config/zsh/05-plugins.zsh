eval "$(starship init zsh)"

eval "$(zoxide init zsh)"

# Plugins live under Homebrew's share dir on macOS, /usr/share on Arch/Linux
source_first \
  "$HOMEBREW_PREFIX/share/forgit/forgit.plugin.zsh" \
  "/usr/share/zsh/plugins/forgit/forgit.plugin.zsh" \
  "/usr/share/forgit/forgit.plugin.zsh"

source_first \
  "$HOMEBREW_PREFIX/share/zsh-vi-mode/zsh-vi-mode.plugin.zsh" \
  "/usr/share/zsh/plugins/zsh-vi-mode/zsh-vi-mode.plugin.zsh"
ZVM_VI_INSERT_ESCAPE_BINDKEY=jk
ZVM_LINE_INIT_MODE=$ZVM_MODE_INSERT

function zvm_after_init() {
  zvm_bindkey viins "^R" fzf-history-widget
}

source_first \
  "$HOMEBREW_PREFIX/share/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "/usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"

source_first \
  "$HOMEBREW_PREFIX/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "/usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
