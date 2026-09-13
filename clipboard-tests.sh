#!/bin/bash
# Test backend selection without accessing a real clipboard or tmux server.
set -euo pipefail
cd "$(dirname "$0")"
repo="$PWD"
zsh_bin=$(command -v zsh)
tmux_bin=$(command -v tmux)
test_root=$(mktemp -d)
cleanup() {
  "$tmux_bin" -S "$test_root/tmux.sock" kill-server 2>/dev/null || true
  rm -rf "$test_root"
}
trap cleanup EXIT
mkdir -p "$test_root/bin" "$test_root/home"
cp "$repo/tmux/.config/tmux/keymaps.conf" "$test_root/keymaps.conf"
printf '\nwait-for -S clipboard-ready\n' >>"$test_root/keymaps.conf"
for tool in wl-copy xclip; do
  printf '#!/bin/sh\nexit 0\n' >"$test_root/bin/$tool"
  chmod +x "$test_root/bin/$tool"
done

check_clipboard() {
  local wayland="$1" expected="$2" ostype="${3:-linux-gnu}" binding
  # shellcheck disable=SC2016
  env PATH="$test_root/bin" WAYLAND_DISPLAY="$wayland" HOMEBREW_PREFIX=/test \
    "$zsh_bin" -fc 'OSTYPE="$3"; source "$1"; [[ "$CLIP_COPY" == "$2" ]]' \
    -- "$repo/zsh/.config/zsh/00-platform.zsh" "$expected" "$ostype"
  env -u TMUX HOME="$test_root/home" SHELL=/bin/sh PATH="$test_root/bin" \
    WAYLAND_DISPLAY="$wayland" "$tmux_bin" -S "$test_root/tmux.sock" \
    -f /dev/null new-session -d -s clipboard /bin/sh
  "$tmux_bin" -S "$test_root/tmux.sock" source-file "$test_root/keymaps.conf"
  "$tmux_bin" -S "$test_root/tmux.sock" wait-for clipboard-ready
  binding=$("$tmux_bin" -S "$test_root/tmux.sock" list-keys -T copy-mode-vi | awk '$4 == "y"')
  if [[ "$binding" != *"$expected"* ]]; then
    printf 'FAIL: expected %s, got %s\n' "$expected" "$binding" >&2
    exit 1
  fi
  "$tmux_bin" -S "$test_root/tmux.sock" kill-server
}

check_clipboard wayland-0 wl-copy
check_clipboard '' 'xclip -selection clipboard'
rm "$test_root/bin/wl-copy"
check_clipboard wayland-0 'xclip -selection clipboard'
cp "$test_root/bin/xclip" "$test_root/bin/pbcopy"
check_clipboard '' pbcopy darwin
echo 'PASS: zsh and tmux select Wayland, X11, fallback, and macOS clipboard backends'
