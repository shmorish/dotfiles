#!/bin/zsh

RC_FUNC_DIR="$HOME/dotfiles/.config/zsh/rc/functions"

source "$RC_FUNC_DIR/docker"
source "$RC_FUNC_DIR/utils"

ZSH_THEME="shmorish"

# History Configuration
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt HIST_IGNORE_SPACE
setopt correct
SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.zsh_history

# Utils
setopt auto_cd
