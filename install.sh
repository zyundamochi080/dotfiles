#!/usr/bin/env bash
#
# install.sh - dotfiles セットアップスクリプト（GNU Stow ベース）
#
# 使い方:
#   ./install.sh              # すべてのパッケージ（トピックフォルダ）をリンク
#   ./install.sh zsh vim      # 指定したパッケージだけリンク
#   ./install.sh --unlink zsh # 指定したパッケージのリンクを解除
#
# 仕組み:
#   リポジトリ直下の各フォルダ（zsh/, vim/, git/ ...）を GNU Stow の
#   「パッケージ」として扱い、フォルダの中身をホームディレクトリへ
#   シンボリックリンクします。フォルダ内の構成は「ホームから見た
#   相対パス」と同じにしておいてください。
#     例: zsh/.zshrc            -> ~/.zshrc
#         claude/.claude/CLAUDE.md -> ~/.claude/CLAUDE.md
#
# 既存の実ファイルと衝突した場合は、上書きせずに
# ~/.dotfiles_backup/<日時>/ へ退避してからリンクします。

set -euo pipefail

# ---------------------------------------------------------------
# 設定
# ---------------------------------------------------------------

# リポジトリのルート（このスクリプトが置いてある場所）
DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Stow の対象にしないフォルダ
EXCLUDE_DIRS=("bin" "docs" "scripts")

# 既存ファイルの退避先
BACKUP_DIR="$HOME/.dotfiles_backup/$(date +%Y%m%d_%H%M%S)"

# ---------------------------------------------------------------
# ヘルパー
# ---------------------------------------------------------------

info()  { printf '\033[1;34m[info]\033[0m %s\n' "$*"; }
warn()  { printf '\033[1;33m[warn]\033[0m %s\n' "$*"; }
error() { printf '\033[1;31m[error]\033[0m %s\n' "$*" >&2; }

is_excluded() {
  local dir="$1"
  for ex in "${EXCLUDE_DIRS[@]}"; do
    [[ "$dir" == "$ex" ]] && return 0
  done
  return 1
}

# リポジトリ直下のフォルダから Stow パッケージ一覧を作る
list_packages() {
  local pkg
  for path in "$DOTFILES_DIR"/*/; do
    pkg="$(basename "$path")"
    is_excluded "$pkg" && continue
    echo "$pkg"
  done
}

# ---------------------------------------------------------------
# stow がなければインストールを試みる
# ---------------------------------------------------------------

ensure_stow() {
  if command -v stow >/dev/null 2>&1; then
    return
  fi
  warn "GNU Stow が見つかりません。インストールを試みます..."
  if command -v brew >/dev/null 2>&1; then
    brew install stow
  elif command -v apt-get >/dev/null 2>&1; then
    sudo apt-get update -qq && sudo apt-get install -y stow
  elif command -v dnf >/dev/null 2>&1; then
    sudo dnf install -y stow
  elif command -v pacman >/dev/null 2>&1; then
    sudo pacman -S --noconfirm stow
  else
    error "パッケージマネージャを検出できませんでした。手動で GNU Stow をインストールしてください。"
    exit 1
  fi
}

# ---------------------------------------------------------------
# 衝突チェック: リンク先に「実ファイル」があればバックアップへ退避
# ---------------------------------------------------------------

# 親ディレクトリのシンボリックリンクを解決した物理パスを返す（macOS でも動く）
physical_path() {
  local f="$1" d
  d="$(cd "$(dirname "$f")" 2>/dev/null && pwd -P)" || return 1
  printf '%s/%s\n' "$d" "$(basename "$f")"
}

backup_conflicts() {
  local pkg="$1"
  local repo_root
  repo_root="$(cd "$DOTFILES_DIR" && pwd -P)"

  # パッケージ内の全ファイルについて、ホーム側の対応パスを調べる
  while IFS= read -r -d '' file; do
    local rel="${file#"$DOTFILES_DIR/$pkg/"}"
    local target="$HOME/$rel"
    # シンボリックリンク以外の実ファイルが存在する場合のみ対象
    if [[ -e "$target" && ! -L "$target" && ! -d "$target" ]]; then
      # 親ディレクトリのリンク経由で既にリポジトリ内を指している場合は
      # （= 前回の実行で導入済み）何もしない
      local phys
      phys="$(physical_path "$target" || true)"
      if [[ -n "$phys" && "$phys" == "$repo_root"/* ]]; then
        continue
      fi
      mkdir -p "$BACKUP_DIR/$(dirname "$rel")"
      mv "$target" "$BACKUP_DIR/$rel"
      warn "既存ファイルを退避: ~/$rel -> $BACKUP_DIR/$rel"
    fi
  done < <(find "$DOTFILES_DIR/$pkg" -type f -print0)
}

# ---------------------------------------------------------------
# メイン
# ---------------------------------------------------------------

main() {
  local action="link"
  local -a packages=()

  for arg in "$@"; do
    case "$arg" in
      --unlink|-D) action="unlink" ;;
      -h|--help)
        sed -n '2,20p' "$0" | sed 's/^# \{0,1\}//'
        exit 0
        ;;
      *) packages+=("$arg") ;;
    esac
  done

  ensure_stow

  # 引数がなければ全パッケージを対象にする
  if [[ ${#packages[@]} -eq 0 ]]; then
    mapfile -t packages < <(list_packages)
  fi

  if [[ ${#packages[@]} -eq 0 ]]; then
    error "対象のパッケージ（フォルダ）が見つかりません。"
    exit 1
  fi

  for pkg in "${packages[@]}"; do
    if [[ ! -d "$DOTFILES_DIR/$pkg" ]]; then
      error "フォルダが存在しません: $pkg"
      continue
    fi

    if [[ "$action" == "unlink" ]]; then
      info "リンク解除: $pkg"
      stow --dir="$DOTFILES_DIR" --target="$HOME" --delete "$pkg"
    else
      backup_conflicts "$pkg"
      info "リンク作成: $pkg"
      # --restow: 既存リンクを張り直すので再実行しても安全（冪等）
      stow --dir="$DOTFILES_DIR" --target="$HOME" --restow "$pkg"
    fi
  done

  info "完了しました。"
  if [[ -d "$BACKUP_DIR" ]]; then
    warn "退避した既存ファイルがあります: $BACKUP_DIR"
  fi
}

main "$@"
 
