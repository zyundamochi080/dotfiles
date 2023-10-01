## lang
export LANG=ja_JP.UTF-8
setopt print_eight_bit

## prompt
setopt PROMPT_SUBST
source ~/.zsh/.git-prompt.sh

PROMPT='
%F{green}%~%f %F{red}$(__git_ps1 "(%s) " )%f$ '

## option
autoload -U compinit
compinit

setopt auto_pushd

# sコマンドでも ssh 接続先の検索が可能
alias s='ssh $(grep -iE "^host[[:space:]]+[^*]" ~/.ssh/config|peco|awk "{print \$2}")'

# ctrl-r で history を peco で検索可能
# CentOS/Ubuntuではtailの-rオプションがないのでtacコマンドに置き換え
function peco-history-selection() {
    BUFFER=`history -n 1 | tac | awk '!a[$0]++' | peco`
    CURSOR=$#BUFFER
    zle reset-prompt
}

zle -N peco-history-selection
bindkey '^R' peco-history-selection

# alias
## for macOS
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
alias dot-on='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
alias dot-off='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'

## git
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gp-o='git push origin master'
alias gp-d='git push origin develop'

## others
alias ip-check='ifconfig | grep inet'
alias diff='colordiff'
alias tailf='tail -f'
alias sudo='sudo -E '
alias ls='ls -aFG --color'
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -al'

