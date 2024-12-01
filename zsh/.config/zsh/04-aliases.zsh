alias aliases='bat ~/.config/zsh/04-aliases.zsh --pager never 2>/dev/null'
alias all-functions='functions | bat --language zsh'

alias reload="source ~/.zshrc"

alias gst="git status"
alias gpull="git branch --show-current | xargs -I {} sh -c 'echo \"\nRunning git pull origin {}...\n\" && git pull origin {}'"
alias gpullm="git fetch && git pull origin master"
alias gpush="git branch --show-current | xargs -I {} sh -c 'echo \"\nRunning git push origin {}...\n\" && git push origin {}'"
alias greset="git fetch origin && git branch --show-current | xargs -I {} sh -c 'echo \"\nRunning git reset --hard origin/{}...\n\" && git reset --hard origin/{}'"
alias gresetm="git fetch origin && git reset --hard origin/master"

alias fvim="fzf-tmux -p --preview 'bat -n --color=always {}' | xargs -r env NVIM_APPNAME=nvim-lazyvim nvim"

alias ls="eza --icons --group-directories-first"
alias ll="ls -lah"

alias LazyVim="NVIM_APPNAME=nvim-lazyvim nvim"
alias lv="LazyVim"
alias Kickstart="NVIM_APPNAME=nvim-kickstart nvim"
alias NvChad="NVIM_APPNAME=nvim-nvchad nvim"
alias LunarVim="lvim"

alias pt="SKIP_JEST_RETRY=1 pnpm test"
