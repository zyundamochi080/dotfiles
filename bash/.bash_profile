# ~/.bash_profile
# 環境変数・PATH など「ログイン時に1回だけ」で良いものはここに書く

# Kiro CLI pre block. Keep at the top of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/bash_profile.pre.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/bash_profile.pre.bash"

# Homebrew (最初に PATH へ。Apple Silicon / Intel どちらでも動くように)
if [ -x /opt/homebrew/bin/brew ]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
elif [ -x /usr/local/bin/brew ]; then
    eval "$(/usr/local/bin/brew shellenv)"
fi

export PATH="/usr/local/sbin:$PATH"

# Python 2.7 (pyenv より前に置いて優先度を下げる。使うときは python2.7 / pip2.7 と明示)
PATH="/Library/Frameworks/Python.framework/Versions/2.7/bin:${PATH}"
export PATH

# pyenv (2.7 より後に置くことで shims が優先される)
# ※ pyenv init / virtualenv-init は毎シェル必要なので .bashrc 側で実行する
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$PYENV_ROOT/shims:$PATH"

# .NET (公式インストーラの配置先)
export DOTNET_ROOT="/usr/local/share/dotnet"
export PATH="$PATH:$DOTNET_ROOT"
export DOTNET_CLI_TELEMETRY_OPTOUT=1

export PATH="$HOME/.local/bin:$PATH"

# Go
export GOPATH="${HOME}/go"
export PATH="$GOPATH/bin:$PATH"

# ネットワーク系ツール (Intel Homebrew 環境のパス。無い環境では単に無視される)
export PATH="/usr/local/Cellar/mtr/0.92/sbin:$PATH"
export PATH="$PATH:/usr/local/opt/inetutils/libexec/gnubin"
export PATH="/usr/local/opt/libpcap/bin:$PATH"

# Flutter
export PATH="$PATH:$HOME/Develop/flutter/bin"

# Google Cloud SDK
export PATH="$PATH:$HOME/Develop/google-cloud-sdk/bin"
# CLOUDSDK_PYTHON は python2.7 が存在する環境 (旧Mac) でのみ設定する
[ -x /usr/bin/python2.7 ] && export CLOUDSDK_PYTHON=/usr/bin/python2.7

# nodebrew
export PATH="$PATH:$HOME/.nodebrew/current/bin"

# Android SDK
export PATH="$PATH:$HOME/Library/Android/sdk/platform-tools"

# macOS の「zsh がデフォルトです」警告を抑止
export BASH_SILENCE_DEPRECATION_WARNING=1

# 残りはすべて .bashrc に集約し、どの起動経路でも同じ設定になるようにする
[ -f ~/.bashrc ] && . ~/.bashrc

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/bash_profile.post.bash" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/bash_profile.post.bash"

# 直前の存在チェックが偽でもファイルの終了ステータスを 0 に揃える
true
