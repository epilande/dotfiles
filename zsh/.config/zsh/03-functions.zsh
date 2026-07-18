# tm - create new tmux session, or switch to existing one.
function tm() {
  [[ -n "$TMUX" ]] && change="switch-client" || change="attach-session"
  if [ $1 ]; then
    tmux $change -t "$1" 2>/dev/null || (tmux new-session -d -s $1 && tmux $change -t "$1"); return
  fi
  session=$(tmux list-sessions -F "#{session_name}" 2>/dev/null | fzf-tmux -p --exit-0) && tmux $change -t "$session" || echo "No sessions found."
}

# tmw - fuzzy find window switcher
function tmw() {
  session=$(tmux list-windows -a | fzf | sed 's/: .*//g')
  if [[ -z $session ]]; then
    echo "No session selected."
    return 0
  fi
  tmux switch-client -t "$session"
}

# Install one or more versions of specified tool
# e.g. `misei go` # => fzf multimode, tab to mark, enter to install
# if no tool is supplied (e.g. `misei<CR>`), fzf will list them for you
function misei() {
  local tool=${1}

  if [[ ! $tool ]]; then
    # `mise registry` includes core tools (go, node, ...); `mise plugins` does not
    tool=$(mise registry | awk '{print $1}' | fzf-tmux -p)
  fi

  if [[ $tool ]]; then
    local versions=$(mise ls-remote $tool | fzf-tmux -p --tac --no-sort --multi)
    if [[ $versions ]]; then
      for version in $(echo $versions);
      do; mise install $tool@$version; done;
    fi
  fi
}

# Remove one or more versions of specified tool
# e.g. `misec go` # => fzf multimode, tab to mark, enter to remove
# if no tool is supplied (e.g. `misec<CR>`), fzf will list them for you
function misec() {
  local tool=${1}

  if [[ ! $tool ]]; then
    tool=$(mise ls --installed | awk '{print $1}' | sort -u | fzf-tmux -p)
  fi

  if [[ $tool ]]; then
    local versions=$(mise ls --installed $tool | awk '{print $2}' | fzf-tmux -p -m)
    if [[ $versions ]]; then
      for version in $(echo $versions);
      do; mise uninstall $tool@$version; done;
    fi
  fi
}


function nvims() {
  items=("default" "Kickstart" "LazyVim" "LunarVim" "NvChad")
  config=$(printf "%s\n" "${items[@]}" | fzf --prompt=" Neovim Config 󰄾 " --height=~50% --layout=reverse --border --exit-0)

  if [[ -z $config ]]; then
    echo "Nothing selected"
    return 0
  elif [[ $config == "default" ]]; then
    config="nvim"
  fi
  eval $config $@
}

function gcbm {
    if [ -z "$1" ]; then
        echo "Please provide a branch name."
        return 1
    fi
    git checkout -b "$1" master
}

# Create a git worktree for a feature branch, carrying over local-only files
function wt() {
  if [ -z "$1" ]; then
    echo "❌ Usage: wt <feature-name>"
    return 1
  fi

  local feature_name="$1"
  local current_dir=$(pwd)
  local project_name=$(basename "$current_dir")
  local parent_dir=$(dirname "$current_dir")
  local worktrees_dir="$parent_dir/$project_name-worktrees"

  mkdir -p "$worktrees_dir"

  local worktree_path="$worktrees_dir/$feature_name"

  echo "🌿 Creating worktree and branch: $feature_name"
  if ! git worktree add -b "$feature_name" "$worktree_path"; then
    echo "❌ Failed to create git worktree"
    return 1
  fi

  # Copy untracked files to the new worktree
  git ls-files --others --exclude-standard | while read -r file; do
    mkdir -p "$worktree_path/$(dirname "$file")"
    cp "$file" "$worktree_path/$file"
  done

  # Copy modified files (staged and unstaged) to the new worktree
  git diff HEAD --name-only | while read -r file; do
    mkdir -p "$worktree_path/$(dirname "$file")"
    cp "$file" "$worktree_path/$file"
  done

  # Local files the loops above miss because they are gitignored (.env,
  # .claude/settings.local.json, ...); copying tracked ones is a no-op
  local files_to_copy=(
    ".claude/"
    "AGENTS.md"
    "CLAUDE.md"
    ".env"
    "Configurations"
  )

  for item in "${files_to_copy[@]}"; do
    if [ -d "$item" ]; then
      cp -r "${item%/}" "$worktree_path/"
      echo "📁 Copied directory: $item"
    elif [ -f "$item" ]; then
      cp "$item" "$worktree_path/"
      echo "📄 Copied file: $item"
    fi
  done

  if [ -n "$TMUX" ]; then
    tmux new-window -n "$feature_name"
    tmux send-keys -t "$feature_name" "cd '$worktree_path'" Enter
    echo "🪟 Opened new tmux window: $feature_name"
  else
    echo "✅ Worktree created at: $worktree_path"
    echo "💡 To switch to the new worktree, run: cd '$worktree_path'"
  fi
}

# Remove the current worktree and its branch once the work is merged
function wtr() {
  local current_dir=$(pwd)

  if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
    echo "❌ Error: Not in a git repository"
    return 1
  fi

  local current_branch=$(git branch --show-current)

  if [ "$current_branch" = "main" ] || [ "$current_branch" = "master" ]; then
    echo "🚫 Error: Cannot remove main/master branch worktree"
    return 1
  fi

  if ! git diff --quiet || ! git diff --cached --quiet; then
    echo "⚠️  Error: There are uncommitted changes. Please commit or stash them first."
    echo "📝 Uncommitted files:"
    git status --porcelain
    return 1
  fi

  if [ -n "$(git ls-files --others --exclude-standard)" ]; then
    echo "⚠️  Error: There are untracked files. Please handle them first."
    echo "📄 Untracked files:"
    git ls-files --others --exclude-standard
    return 1
  fi

  # In a worktree .git is a file pointing at the main repo, not a directory
  if [ -d ".git" ]; then
    echo "❌ Error: Current directory appears to be the main repository, not a worktree"
    return 1
  fi

  local tmux_window=""
  if [ -n "$TMUX" ]; then
    tmux_window=$(tmux display-message -p '#W')
  fi

  # Main repo path per the wt() layout: <parent>/<project>-worktrees/<branch>
  local main_repo="${current_dir%-worktrees/*}"

  if ! cd "$main_repo"; then
    echo "❌ Error: Failed to change to main repository: $main_repo"
    return 1
  fi

  echo "🗑️ Removing worktree and branch: $current_branch"
  if git worktree remove "$current_dir"; then
    echo "✅ Successfully removed worktree: $current_dir"

    local main_branch=""
    if git show-ref --verify --quiet refs/heads/main; then
      main_branch="main"
    elif git show-ref --verify --quiet refs/heads/master; then
      main_branch="master"
    fi

    # Only delete the branch once it is merged into main/master
    if [ -n "$main_branch" ]; then
      if git merge-base --is-ancestor "$current_branch" "$main_branch"; then
        echo "🔀 Branch '$current_branch' is merged into '$main_branch', deleting branch"
        git branch -d "$current_branch"
      else
        echo "⚠️ Branch '$current_branch' is NOT merged into '$main_branch', keeping branch"
        echo "💡 To manually delete: git branch -D '$current_branch'"
      fi
    else
      echo "⚠️  No main/master branch found, keeping branch '$current_branch'"
      echo "💡 To manually delete: git branch -D '$current_branch'"
    fi

    if [ -n "$TMUX" ]; then
      echo "🪟 Closing tmux window: $tmux_window"
      tmux kill-window
    fi
  else
    echo "❌ Failed to remove worktree"
    cd "$current_dir"
    return 1
  fi
}
