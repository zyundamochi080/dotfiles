# ~/.bashrc
# エイリアス、シェル関数、プロンプトなど「シェルを開くたびに必要なもの」はここに書く

# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.pre.bash"

# git プロンプト・補完
# Homebrew (Apple Silicon: /opt/homebrew, Intel: /usr/local) と Linux 主要ディストリ
# (RHEL系: /usr/share/git-core, Debian系: /usr/lib/git-core ほか) の配置を順に探し、
# 最初に見つかったものを読み込む。どこにも無い環境ではスキップしてエラーにしない
for _f in \
    /opt/homebrew/etc/bash_completion.d/git-prompt.sh \
    /usr/local/etc/bash_completion.d/git-prompt.sh \
    /usr/share/git-core/contrib/completion/git-prompt.sh \
    /usr/lib/git-core/git-sh-prompt \
    /etc/bash_completion.d/git-prompt; do
    [ -f "$_f" ] && { source "$_f"; break; }
done
for _f in \
    /opt/homebrew/etc/bash_completion.d/git-completion.bash \
    /usr/local/etc/bash_completion.d/git-completion.bash \
    /usr/share/git-core/contrib/completion/git-completion.bash \
    /usr/share/bash-completion/completions/git; do
    [ -f "$_f" ] && { source "$_f"; break; }
done
unset _f
GIT_PS1_SHOWDIRTYSTATE=true

# プロンプト (__git_ps1 が無い環境でも動くようにフォールバック)
if type __git_ps1 >/dev/null 2>&1; then
    export PS1='\n\[\e[34m\]\w\[\e[37m\]$(__git_ps1) \$ \[\e[0m\]'
else
    export PS1='\n\[\e[34m\]\w\[\e[37m\] \$ \[\e[0m\]'
fi

# pyenv (shims の PATH 設定は .bash_profile 側。init は毎シェル必要なのでここで実行)
if command -v pyenv >/dev/null 2>&1; then
    eval "$(pyenv init -)"
    eval "$(pyenv virtualenv-init -)"
fi

# エイリアス
alias airport="/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport"
alias dot-on='defaults write com.apple.finder AppleShowAllFiles TRUE && killall Finder'
alias dot-off='defaults write com.apple.finder AppleShowAllFiles FALSE && killall Finder'
alias emacs='vim'
alias ip-check='ifconfig | grep inet'
alias gs='git status'
alias gd='git diff'
alias ga='git add'
alias gc='git commit -m'
alias gp='git push'
alias gp-o='git push origin master'
alias gp-d='git push origin develop'
alias gogo='cd ~/go/'
# GitHub のアカウント名がローカルのユーザ名と異なる場合は $USER を書き換えること
alias gogogo='cd ~/go/src/github.com/$USER'
# 注意: colordiff が入っていない環境ではこのエイリアスにより diff 自体が使えなくなる
alias diff='colordiff'
alias tailf='tail -f'
alias sudo='sudo -E '
alias la='ls -a'
alias ll='ls -l'
alias lla='ls -al'

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# kiro のシェル統合
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path bash)"

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.post.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/bashrc.post.bash"

# 直前の存在チェックが偽でもファイルの終了ステータスを 0 に揃える
true
