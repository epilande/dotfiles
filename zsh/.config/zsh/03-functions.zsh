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

# Install one or more versions of specified language
# e.g. `asdfi rust` # => fzf multimode, tab to mark, enter to install
# if no plugin is supplied (e.g. `asdfi<CR>`), fzf will list them for you
function asdfi() {
  local lang=${1}

  if [[ ! $lang ]]; then
    lang=$(asdf plugin-list | fzf-tmux -p)
  fi

  if [[ $lang ]]; then
    local versions=$(asdf list-all $lang | fzf-tmux -p --tac --no-sort --multi)
    if [[ $versions ]]; then
      for version in $(echo $versions);
      do; asdf install $lang $version; done;
    fi
  fi
}

# Remove one or more versions of specified language
# e.g. `asdfc rust` # => fzf multimode, tab to mark, enter to remove
# if no plugin is supplied (e.g. `asdfc<CR>`), fzf will list them for you
function asdfc() {
  local lang=${1}

  if [[ ! $lang ]]; then
    lang=$(asdf plugin-list | fzf-tmux -p)
  fi

  if [[ $lang ]]; then
    local versions=$(asdf list $lang | fzf-tmux -p -m)
    if [[ $versions ]]; then
      for version in $(echo $versions);
      do; asdf uninstall $lang $version; done;
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
