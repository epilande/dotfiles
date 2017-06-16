# reload zsh config
alias reload!='source ~/.zshrc'

# standard terminal commmands
alias lh='ls -a'
# Switch vim to neovim
# alias v="nvim"
# alias vim="vim"
alias ":q"="exit"
alias mkdir='mkdir -p'
alias root='cd $(git rev-parse --show-cdup)'
alias path="echo $PATH | tr -s ':' '\n'"
alias finder='open -a Finder .'
alias textedit='open -a TextEdit'

# if there is neovim then use it and alias it
if type nvim > /dev/null 2>&1; then
  alias v='nvim'
fi

# Tower
alias tower="gittower ."

# tmux aliases
alias ta='tmux attach'
alias tls='tmux ls'
alias tat='tmux attach -t'
alias tns='tmux new-session -s'
alias tks='tmux kill-session -t'
# Stuff I never really use but cannot delete either because of http://xkcd.com/530/
alias stfu="osascript -e 'set volume output muted true'"
alias pumpitup="osascript -e 'set volume 7'"

# Show/Hide finder hidden files
alias showHidden="defaults write com.apple.finder AppleShowAllFiles YES; killall Finder /System/Library/CoreServices/Finder.app"
alias hideHidden="defaults write com.apple.finder AppleShowAllFiles NO; killall Finder /System/Library/CoreServices/Finder.app"

# Hide/show all desktop icons (useful when presenting)
alias hidedesktop="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
alias showdesktop="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"

# Start meteor with settings
alias meteors="meteor --settings ./config/settings.json"

# File size
alias fs="stat -f \"%z bytes\""

# IP addresses
alias ip="dig +short myip.opendns.com @resolver1.opendns.com"
alias localip="ipconfig getifaddr en0"
alias ips="ifconfig -a | grep -o 'inet6\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet6? (addr:)? ?/, \"\"); print }'"

# Kill all the tabs in Chrome to free up memory
alias killchrome="ps ux | grep '[C]hrome Helper --type=renderer' | grep -v extension-process | tr -s ' ' | cut -d ' ' -f2 | xargs kill"

