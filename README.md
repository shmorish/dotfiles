# DOTFILES

個人的な設定ファイル群を管理するためのリポジトリです。

TODO
- nvm submodule
- nvm setup version(node -> v12.16.1, v22.17.1, v24.12.0)
- Git, GitHub
- Node, npm
- vim, neovim
- tmux

Done
- zsh, oh-my-zsh
- Homebrew, Brewfile

## インストール方法

```bash
git clone https://github.com/shmorish/dotfiles.git --recursive
cd ~/dotfiles
make setup
```

## アンインストール方法

```bash
cd ~/dotfiles
make clean
```