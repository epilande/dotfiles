#!/bin/bash

# Keep Cursor's live state outside the stow package on fresh and older installs.
set -e
cd "$(dirname "$0")"

cursor_dir="$HOME/.cursor"
cursor_package="$(pwd -P)/cursor/.cursor"
if [[ -L "$cursor_dir" ]]; then
  if [[ "$(cd "$cursor_dir" && pwd -P)" != "$cursor_package" ]]; then
    echo "❌ $cursor_dir links outside this checkout; resolve it before setup" >&2
    exit 1
  fi

  echo "🔧 Moving Cursor state out of the stow package..."
  cursor_stage=$(mktemp -d "$HOME/.cursor-migration.XXXXXX")
  trap 'if [[ $? != 0 ]]; then echo "❌ Cursor migration interrupted; recovery files: $cursor_stage" >&2; fi' EXIT
  mkdir "$cursor_stage/package"
  cp -p "$cursor_package/statusline.sh" "$cursor_stage/package/statusline.sh"

  # Retain the old link for rollback; move the directory so auth/state never
  # needs to be deleted from the checkout after copying it elsewhere.
  mv "$cursor_dir" "$cursor_stage/link"
  if ! mv "$cursor_package" "$cursor_dir"; then
    # A cross-filesystem move can leave a partial destination. Preserve both
    # directories for recovery instead of moving the link inside that state.
    if [[ ! -e "$cursor_dir" ]]; then
      mv "$cursor_stage/link" "$cursor_dir"
    fi
    exit 1
  fi
  if ! mv "$cursor_stage/package" "$cursor_package"; then
    mv "$cursor_dir" "$cursor_package"
    mv "$cursor_stage/link" "$cursor_dir"
    exit 1
  fi
  # The tracked copy is restored; stow will link just this leaf into the home.
  rm "$cursor_dir/statusline.sh"
  chmod 700 "$cursor_dir"
  rm "$cursor_stage/link"
  rmdir "$cursor_stage"
fi

mkdir -p "$cursor_dir"
