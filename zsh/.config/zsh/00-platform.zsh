# Platform detection & abstractions (sourced first; other configs rely on these)
case "$OSTYPE" in
darwin*)
  export DOTFILES_OS="macos"
  # Cache brew prefix (only compute once per session)
  export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"
  export CLIP_COPY="pbcopy"
  export CLIP_PASTE="pbpaste"
  ;;
*)
  export DOTFILES_OS="linux"
  if command -v wl-copy &>/dev/null; then
    export CLIP_COPY="wl-copy"
    export CLIP_PASTE="wl-paste --no-newline"
  elif command -v xclip &>/dev/null; then
    export CLIP_COPY="xclip -selection clipboard"
    export CLIP_PASTE="xclip -selection clipboard -o"
  fi
  ;;
esac

# Source the first existing file from a list of candidates
function source_first() {
  local f
  for f in "$@"; do
    [[ -r "$f" ]] && source "$f" && return 0
  done
  return 1
}
