#!/bin/zsh

# History Configuration
setopt share_history
setopt hist_ignore_dups
setopt hist_ignore_all_dups
setopt HIST_IGNORE_SPACE
setopt correct
SAVEHIST=10000
HISTSIZE=10000
HISTFILE=~/.zsh_history
