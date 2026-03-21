#!/bin/zsh

# ここにあるファイルを読み込む
# https://github.com/agkozak/zsh-z

autoload -U compinit; compinit
zstyle ':completion:*' menu select

source <(curl -fsSL "https://raw.githubusercontent.com/agkozak/zsh-z/refs/heads/master/zsh-z.plugin.zsh")
