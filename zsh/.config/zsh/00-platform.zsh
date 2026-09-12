# Platform detection & abstractions (sourced first; other configs rely on these)
case "$OSTYPE" in
darwin*)
  # Cache brew prefix (only compute once per session)
  export HOMEBREW_PREFIX="${HOMEBREW_PREFIX:-$(brew --prefix)}"
  export CLIP_COPY="pbcopy"
  ;;
*)
  if command -v wl-copy &>/dev/null; then
    export CLIP_COPY="wl-copy"
  elif command -v xclip &>/dev/null; then
    export CLIP_COPY="xclip -selection clipboard"
  fi
  # SSH agent (systemd user unit: ssh-agent.socket)
  if [[ -z "$SSH_AUTH_SOCK" && -S "${XDG_RUNTIME_DIR:-/run/user/$UID}/ssh-agent.socket" ]]; then
    export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR:-/run/user/$UID}/ssh-agent.socket"
  fi
  ;;
esac

# Source the first existing file from a list of candidates
function source_first() {
  local f
  for f in "$@"; do
    if [[ -r "$f" ]]; then
      source "$f"
      return 0
    fi
  done
  print -u2 "source_first: none found: $*"
  return 1
}
