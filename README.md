# dotfiles

個人用の設定ファイル（dotfiles）をまとめたリポジトリです。
[GNU Stow](https://www.gnu.org/software/stow/) を使って、各設定ファイルをホームディレクトリへシンボリックリンクとして配置します。

## 中身

| フォルダ | 内容 |
| --- | --- |
| `zsh/` | zsh の設定（`.zshrc`, `.zprofile`） |
| `bash/` | bash の設定（`.bashrc`） |
| `vim/` | Vim の設定（`.vimrc`） |
| `git/` | Git の設定（`.gitconfig`, `.gitignore_global`） |

各フォルダ（Stow では「パッケージ」と呼びます）の中身は、**ホームディレクトリから見た相対パスと同じ構成**にしています。

```
zsh/.zshrc                  ->  ~/.zshrc
git/.gitconfig              ->  ~/.gitconfig
```

## 前提条件

- Git
- GNU Stow（未インストールの場合、`install.sh` が Homebrew / apt などで自動インストールを試みます）
  - macOS: `brew install stow`
  - Ubuntu/Debian: `sudo apt install stow`

## インストール

```sh
git clone https://github.com/zyundamochi080/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

特定の設定だけ導入したい場合は、フォルダ名を指定します。

```sh
./install.sh zsh vim      # zsh と vim だけリンク
./install.sh --unlink vim # vim のリンクを解除
```

- 既にホームディレクトリに同名の実ファイルがある場合は、上書きせず `~/.dotfiles_backup/<日時>/` に退避してからリンクします。
- `install.sh` は何度実行しても安全です（再実行するとリンクを張り直します）。

## 注意

これは私個人の環境向けの設定です。そのまま使うことは想定していないので、
参考にする場合は中身を確認し、必要な部分だけ取り入れることをおすすめします。
設定の適用は自己責任でお願いします。

また、API キーなどのシークレットはこのリポジトリには含めていません（環境変数や各ツールのキーチェーンで管理しています）。
