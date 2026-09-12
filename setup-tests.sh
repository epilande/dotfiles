#!/bin/bash
# Isolated regression checks; no installers or live user configs are touched.
# Exported stubs are invoked by child setup scripts.
# shellcheck disable=SC2317,SC2329
set -euo pipefail
cd "$(dirname "$0")"

test_root=$(mktemp -d)
trap 'rm -rf "$test_root"' EXIT
repo="$PWD"
test_home="$test_root/home"
mkdir -p "$test_home" "$test_root/tmp"

# Stop shared setup after the config update, before runtime installation.
mise() { return 91; }
export -f mise
run_common() {
  env -u XDG_CONFIG_HOME -u CURSOR_CONFIG_DIR HOME="$test_home" \
    bash "$repo/setup-common.sh" >"$test_root/output" 2>&1
}
expect_status() {
  local expected="$1" actual=0
  shift
  "$@" || actual=$?
  if [[ "$actual" != "$expected" ]]; then
    printf 'Expected exit %s, got %s\n' "$expected" "$actual" >&2
    cat "$test_root/output" >&2
    exit 1
  fi
}
# bash 3.2 (macOS /bin/bash) does not apply errexit to a failing bare `[[ ]]`,
# so every assertion below must fail explicitly.
fail() {
  printf 'FAIL: %s\n' "$*" >&2
  exit 1
}
expect_status 91 run_common
cfg="$test_home/.config/cursor/cli-config.json"
jq -e '.statusLine.command == "~/.cursor/statusline.sh"' "$cfg" >/dev/null
[[ ! -e "$test_home/.cursor/cli-config.json" ]] ||
  fail "Cursor CLI config was written to the legacy ~/.cursor path"
printf '{"permissions":{"keep":true}}\n' >"$cfg"
expect_status 91 run_common
jq -e '.permissions.keep and .statusLine.type == "command"' "$cfg" >/dev/null
cp "$cfg" "$test_root/valid.json"
expect_status 91 run_common
cmp "$cfg" "$test_root/valid.json"
for invalid in '{broken' '[]' 'null' ''; do
  printf '%s' "$invalid" >"$cfg"
  cp "$cfg" "$test_root/original.json"
  expect_status 1 run_common
  cmp "$cfg" "$test_root/original.json"
  [[ -z "$(find "$(dirname "$cfg")" -name '.cli-config.*' -print)" ]] ||
    fail "invalid JSON run left a .cli-config.* temp file behind"
done
expect_status 91 env HOME="$test_home" CURSOR_CONFIG_DIR="$test_home/custom" \
  bash "$repo/setup-common.sh"
[[ -f "$test_home/custom/cli-config.json" ]] ||
  fail "CURSOR_CONFIG_DIR override did not create cli-config.json"
echo 'PASS: Cursor defaults, overrides, preservation, repeat run, invalid JSON cleanup'

# Simulate a failed download that wrote a partial script. It must never execute.
curl() {
  printf 'touch "%s"\n' "$TEST_DOWNLOAD_MARKER" >"$4"
  return 22
}
mise() { return 0; }
export -f curl mise
export TEST_DOWNLOAD_MARKER="$test_root/download-executed"
mkdir -p "$test_home/.local/bin"
printf '%s\n' '#!/bin/bash' 'mise use -g "claude" || exit 1' \
  'exec mise x "claude" -- "claude" "$@"' >"$test_home/.local/bin/claude"
cp "$test_home/.local/bin/claude" "$test_root/wrapper"
expect_status 22 env HOME="$test_home" TMPDIR="$test_root/tmp" bash "$repo/setup-ai-clis.sh"
[[ ! -e "$TEST_DOWNLOAD_MARKER" ]] || fail "partial download script was executed"
[[ -z "$(find "$test_root/tmp" -type f -print)" ]] || fail "failed download left files in TMPDIR"
cmp "$test_root/wrapper" "$test_home"/.local/bin/dotfiles-wrapper-backup.*/claude
# A custom launcher mentioning mise is not an Omarchy wrapper.
printf '%s\n' '#!/bin/bash' '# promise: unrelated custom launcher' 'exit 0' \
  >"$test_home/.local/bin/claude"
chmod +x "$test_home/.local/bin/claude"
cp "$test_home/.local/bin/claude" "$test_root/custom-launcher"
expect_status 22 env HOME="$test_home" TMPDIR="$test_root/tmp" bash "$repo/setup-ai-clis.sh"
cmp "$test_root/custom-launcher" "$test_home/.local/bin/claude"
mkdir -p "$test_home/.opencode/bin"
cp "$test_home/.local/bin/claude" "$test_home/.opencode/bin/opencode"
expect_status 22 env HOME="$test_home" TMPDIR="$test_root/tmp" bash "$repo/setup-ai-clis.sh"
[[ ! -e "$TEST_DOWNLOAD_MARKER" ]] ||
  fail "opencode wrapper run executed the partial download script"
echo 'PASS: failed downloads stop setup, partial scripts never execute, wrappers are preserved'

# Use real stow in a copied checkout, stopping before Ghostty/runtime setup.
mkdir -p "$test_root/repo" "$test_root/linux-home/.cursor"
git archive HEAD | tar -x -C "$test_root/repo"
cp setup-linux.sh "$test_root/repo/setup-linux.sh"
printf 'old status line\n' >"$test_root/linux-home/.cursor/statusline.sh"
printf 'auth fixture\n' >"$test_root/linux-home/.cursor/auth.json"
pacman() { [[ "$1" == '-T' ]]; }
command() {
  if [[ "$*" == '-v yay' ]]; then return 1; fi
  builtin command "$@"
}
export -f pacman command
expect_status 1 env HOME="$test_root/linux-home" bash "$test_root/repo/setup-linux.sh"
[[ ! -L "$test_root/linux-home/.cursor/statusline.sh" ]] ||
  fail "Cursor status line was symlinked despite the missing AUR helper"
[[ ! -d "$test_root/linux-home/.config" ]] ||
  fail "\$HOME/.config was created despite the missing AUR helper"
unset -f command
echo 'PASS: missing AUR helper stops setup before moving configs'
pacman() { return 0; }
stow() {
  command stow "$@" || return
  touch "$TEST_STOW_MARKER"
  return 91
}
export TEST_STOW_MARKER="$test_root/stow-succeeded"
export -f pacman stow
expect_status 1 env HOME="$test_root/linux-home" bash "$test_root/repo/setup-linux.sh"
[[ -f "$TEST_STOW_MARKER" ]] || fail "stow never ran"
[[ -L "$test_root/linux-home/.cursor/statusline.sh" ]] ||
  fail "Cursor status line was not symlinked by stow"
[[ "$(cat "$test_root/linux-home/.cursor/auth.json")" == 'auth fixture' ]] ||
  fail "Cursor auth.json was not preserved"
[[ "$(cat "$test_root/linux-home"/.config/dotfiles-backup-*/.cursor/statusline.sh)" == 'old status line' ]] ||
  fail "old Cursor status line was not backed up"
echo 'PASS: real stow backs up Cursor status line and preserves auth'
