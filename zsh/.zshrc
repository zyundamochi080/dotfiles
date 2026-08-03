# ~/.zshrc
# エイリアス、シェル関数、プロンプトなど「シェルを開くたびに必要なもの」はここに書く

# Kiro CLI pre block. Keep at the top of this file.
# (kiro-cli 未導入のマシンでは存在チェックによりスキップされる)
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.pre.zsh"

# 日本語環境 (print_eight_bit: 補完候補などで日本語をエスケープせず表示する)
export LANG=ja_JP.UTF-8
setopt print_eight_bit

# 補完 (zsh 標準の補完システム。git などの補完も標準で含まれるため、
# bash 版と違い git-completion ファイルの読み込みは不要)
autoload -Uz compinit && compinit

# cd で自動的にディレクトリスタックに積む (cd - <Tab> で履歴から戻れる)
setopt auto_pushd

# git プロンプト (git-prompt.sh は bash/zsh 両対応)
# Homebrew (Apple Silicon: /opt/homebrew, Intel: /usr/local) と Linux 主要ディストリ
# (RHEL系: /usr/share/git-core, Debian系: /usr/lib/git-core ほか) の配置を順に探し、
# 最初に見つかったものを読み込む。どこにも無い環境ではスキップしてエラーにしない
for _f in \
    /opt/homebrew/etc/bash_completion.d/git-prompt.sh \
    /usr/local/etc/bash_completion.d/git-prompt.sh \
    /usr/share/git-core/contrib/completion/git-prompt.sh \
    /usr/lib/git-core/git-sh-prompt \
    /etc/bash_completion.d/git-prompt \
    "${HOME}/.zsh/.git-prompt.sh"; do
    [ -f "$_f" ] && { source "$_f"; break; }
done
unset _f
GIT_PS1_SHOWDIRTYSTATE=true

# プロンプト (bash 版 PS1 と同じ見た目: 青のカレントパス + git 状態 + $)
setopt PROMPT_SUBST
if typeset -f __git_ps1 > /dev/null; then
    PROMPT=$'\n%F{blue}%~%f%F{white}$(__git_ps1)%f %(!.#.$) '
else
    PROMPT=$'\n%F{blue}%~%f %(!.#.$) '
fi

# pyenv (shims の PATH 設定は .zprofile 側。init は毎シェル必要なのでここで実行)
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

# peco 連携 (peco が入っている環境でのみ有効化)
if command -v peco >/dev/null 2>&1; then
    # s コマンドで ssh 接続先を peco で絞り込んで接続
    alias s='ssh $(grep -iE "^host[[:space:]]+[^*]" ~/.ssh/config|peco|awk "{print \$2}")'

    # ctrl-r で history を peco で検索
    # tac が無い環境 (macOS 標準など) では tail -r に置き換え
    function peco-history-selection() {
        BUFFER=$(history -n 1 | (command -v tac >/dev/null 2>&1 && tac || tail -r) | awk '!a[$0]++' | peco)
        CURSOR=$#BUFFER
        zle reset-prompt
    }
    zle -N peco-history-selection
    bindkey '^R' peco-history-selection
fi

# nvm (nvm 公式の zsh 向け手順と同じ記述)
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# kiro のシェル統合
[[ "$TERM_PROGRAM" == "kiro" ]] && . "$(kiro --locate-shell-integration-path zsh)"

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zshrc.post.zsh"

# 直前の存在チェックが偽でもファイルの終了ステータスを 0 に揃える
true
