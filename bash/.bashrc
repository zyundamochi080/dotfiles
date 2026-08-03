source /usr/local/etc/bash_completion.d/git-prompt.sh
source /usr/local/etc/bash_completion.d/git-completion.bash
GIT_PS1_SHOWDIRTYSTATE=true

export PS1='\n\[\e[34m\]\w\[\e[37m\]$(__git_ps1) \$ \[\e[0m\]'

alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
alias ip-check='ifconfig | grep inet'
alias dot-on='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
alias dot-off='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gp-o='git push origin master'
alias gp-d='git push origin develop'
alias diff='colordiff'
alias tailf='tail -f'
alias sudo='sudo -E '
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -al'
