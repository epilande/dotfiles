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
# Omarchy names some tools by their full mise ID rather than the command.
printf '%s\n' '#!/bin/bash' 'mise use -g "aqua:modem-dev/hunk" || exit 1' \
  'exec mise x "aqua:modem-dev/hunk" -- "hunk" "$@"' >"$test_home/.local/bin/hunk"
cp "$test_home/.local/bin/hunk" "$test_root/hunk-wrapper"
expect_status 22 env HOME="$test_home" TMPDIR="$test_root/tmp" bash "$repo/setup-ai-clis.sh"
[[ ! -e "$TEST_DOWNLOAD_MARKER" ]] || fail "partial download script was executed"
[[ -z "$(find "$test_root/tmp" -type f -print)" ]] || fail "failed download left files in TMPDIR"
cmp "$test_root/wrapper" "$test_home"/.local/bin/dotfiles-wrapper-backup.*/claude
cmp "$test_root/hunk-wrapper" "$test_home"/.local/bin/dotfiles-wrapper-backup.*/hunk
[[ ! -e "$test_home/.local/bin/hunk" ]] || fail "hunk wrapper with a backend-qualified mise ID was not removed"
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

# Model the vendor's shell-rc side effect; setup must opt out of it.
curl() {
  cat >"$4" <<'EOF'
if [[ "$1" != --no-modify-path ]]; then
  echo 'export PATH=unexpected:$PATH' >>"$HOME/.zshrc"
fi
printf '%s\n' "$@" >"$HOME/installer-args"
EOF
}
export -f curl
mkdir -p "$test_root/opencode-home/.local/bin" "$test_root/opencode-repo"
cp "$test_root/custom-launcher" "$test_root/opencode-home/.local/bin/claude"
cp "$test_root/custom-launcher" "$test_root/opencode-home/.local/bin/agent"
printf '# tracked shell config\n' >"$test_root/opencode-repo/.zshrc"
cp "$test_root/opencode-repo/.zshrc" "$test_root/original.zshrc"
ln -s "$test_root/opencode-repo/.zshrc" "$test_root/opencode-home/.zshrc"
expect_status 0 env HOME="$test_root/opencode-home" bash "$repo/setup-ai-clis.sh"
cmp "$test_root/original.zshrc" "$test_root/opencode-repo/.zshrc"
[[ "$(cat "$test_root/opencode-home/installer-args")" == --no-modify-path ]] ||
  fail "OpenCode installer did not receive --no-modify-path"
echo 'PASS: OpenCode installer leaves the stowed shell config unchanged'

# Use real stow in a copied checkout, stopping before Ghostty/runtime setup.
mkdir -p "$test_root/repo" "$test_root/linux-home/.cursor"
git archive HEAD | tar -x -C "$test_root/repo"
cp setup-linux.sh "$test_root/repo/setup-linux.sh"
cp setup-cursor.sh "$test_root/repo/setup-cursor.sh"
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

# Reproduce a legacy directory fold, including private and nested state.
mkdir -p "$test_root/legacy-home"
cp -R "$test_root/repo" "$test_root/legacy-repo"
legacy_package="$test_root/legacy-repo/cursor/.cursor"
cp "$legacy_package/statusline.sh" "$test_root/original-statusline"
command stow --dir="$test_root/legacy-repo" --target="$test_root/legacy-home" cursor
[[ -L "$test_root/legacy-home/.cursor" ]] || fail "legacy fixture did not fold"
printf 'private auth fixture\n' >"$test_root/legacy-home/.cursor/auth.json"
chmod 600 "$test_root/legacy-home/.cursor/auth.json"
mkdir "$test_root/legacy-home/.cursor/state"
printf 'session fixture\n' >"$test_root/legacy-home/.cursor/state/session"
# A failed directory move must restore the original link and preserve state.
mv() {
  if [[ "$2" == "$HOME/.cursor" && "$1" != */link ]]; then return 72; fi
  command mv "$@"
}
export -f mv
expect_status 1 env HOME="$test_root/legacy-home" bash "$test_root/legacy-repo/setup-cursor.sh"
[[ -L "$test_root/legacy-home/.cursor" ]] || fail "failed migration lost original link"
cmp "$test_root/original-statusline" "$legacy_package/statusline.sh"
[[ "$(cat "$test_root/legacy-home/.cursor/auth.json")" == 'private auth fixture' ]] ||
  fail "failed migration lost auth"
unset -f mv
# Exercise Linux's real backup order as well as the shared migration helper.
expect_status 1 env HOME="$test_root/legacy-home" bash "$test_root/legacy-repo/setup-linux.sh"
env HOME="$test_root/legacy-home" bash "$test_root/legacy-repo/setup-cursor.sh"
command stow --restow --dir="$test_root/legacy-repo" --target="$test_root/legacy-home" cursor
[[ ! -L "$test_root/legacy-home/.cursor" ]] || fail "Cursor directory remains folded"
[[ -L "$test_root/legacy-home/.cursor/statusline.sh" ]] || fail "statusline is not linked"
cmp "$test_root/original-statusline" "$legacy_package/statusline.sh"
[[ "$(cat "$test_root/legacy-home/.cursor/auth.json")" == 'private auth fixture' ]] ||
  fail "migration lost auth"
[[ "$(cat "$test_root/legacy-home/.cursor/state/session")" == 'session fixture' ]] ||
  fail "migration lost nested state"
[[ ! -e "$legacy_package/auth.json" && ! -e "$legacy_package/state" ]] ||
  fail "migration left private state in the repo"
[[ "$(find "$test_root/legacy-home/.cursor/auth.json" -perm 600 -print)" != '' ]] ||
  fail "migration changed auth permissions"
printf 'new state\n' >"$test_root/legacy-home/.cursor/new-state"
[[ ! -e "$legacy_package/new-state" ]] || fail "new state still lands in repo"
echo 'PASS: legacy Cursor fold migrates state out of repo and survives restow/repeat run'

mkdir -p "$test_root/external-home" "$test_root/external-cursor"
ln -s "$test_root/external-cursor" "$test_root/external-home/.cursor"
expect_status 1 env HOME="$test_root/external-home" bash "$test_root/legacy-repo/setup-cursor.sh"
[[ -L "$test_root/external-home/.cursor" ]] || fail "unrelated Cursor link was changed"
echo 'PASS: unrelated Cursor symlink is rejected without modification'

# stow --adopt must not replace the gated zsh/.zprofile with a home one-liner.
unset -f command stow pacman mv 2>/dev/null || true
macos_repo="$test_root/macos-repo"
macos_home="$test_root/macos-home"
mkdir -p "$macos_home" "$macos_repo" "$test_root/bin"
git archive HEAD | tar -x -C "$macos_repo"
cp setup-macos.sh "$macos_repo/setup-macos.sh"
cp setup-cursor.sh "$macos_repo/setup-cursor.sh"
printf '#!/bin/bash\nexit 0\n' >"$macos_repo/setup-common.sh"
cp "$macos_repo/zsh/.zprofile" "$test_root/gated-zprofile"
printf 'eval "$(/opt/homebrew/bin/brew shellenv)"\n' >"$macos_home/.zprofile"
cat >"$test_root/bin/brew" <<'EOF'
#!/bin/bash
exit 0
EOF
chmod +x "$test_root/bin/brew" "$macos_repo/setup-common.sh"
expect_status 0 env PATH="$test_root/bin:$PATH" HOME="$macos_home" \
  bash "$macos_repo/setup-macos.sh"
cmp "$test_root/gated-zprofile" "$macos_repo/zsh/.zprofile" ||
  fail "stow --adopt overwrote gated zsh/.zprofile"
[[ -L "$macos_home/.zprofile" ]] || fail "macOS setup did not link ~/.zprofile"
cmp "$test_root/gated-zprofile" "$macos_home/.zprofile" ||
  fail "linked ~/.zprofile is not the gated copy"
[[ "$(cat "$macos_home/.zprofile.dotfiles-backup")" == 'eval "$(/opt/homebrew/bin/brew shellenv)"' ]] ||
  fail "original ~/.zprofile was not backed up"
# Repeat run must not treat the stow symlink as a regular file to adopt.
expect_status 0 env PATH="$test_root/bin:$PATH" HOME="$macos_home" \
  bash "$macos_repo/setup-macos.sh"
cmp "$test_root/gated-zprofile" "$macos_repo/zsh/.zprofile" ||
  fail "repeat macOS setup overwrote gated zsh/.zprofile"
[[ -L "$macos_home/.zprofile" ]] || fail "repeat macOS setup lost ~/.zprofile link"
echo 'PASS: macOS stow --adopt keeps gated zsh/.zprofile'
