# ~/.zprofile
# 環境変数・PATH など「ログイン時に1回だけ」で良いものはここに書く
# ※ bash と違い、zsh は対話シェルなら ~/.zshrc を必ず自動で読むため、
#    ここから .zshrc を source する必要はない

# Kiro CLI pre block. Keep at the top of this file.
# (kiro-cli 未導入のマシンでは存在チェックによりスキップされる)
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.pre.zsh"

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
# ※ pyenv init / virtualenv-init は毎シェル必要なので .zshrc 側で実行する
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export PATH="$PYENV_ROOT/shims:$PATH"

# .NET (macOS 公式インストーラの配置先。Linux でパッケージ導入した場合は要調整)
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

# Kiro CLI post block. Keep at the bottom of this file.
[[ -f "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh" ]] && builtin source "${HOME}/Library/Application Support/kiro-cli/shell/zprofile.post.zsh"

# 直前の存在チェックが偽でもファイルの終了ステータスを 0 に揃える
true
