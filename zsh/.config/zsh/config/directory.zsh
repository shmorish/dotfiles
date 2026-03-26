#!/bin/zsh

setopt auto_cd
setopt auto_pushd
setopt pushd_ignore_dups
setopt pushdminus

alias -g ...='../..'
alias -g ....='../../..'
alias -g .....='../../../..'
alias -g ......='../../../../..'

# Directory Navigation
alias -- -='cd -'
alias 1='cd -1'
alias 2='cd -2'
alias 3='cd -3'
alias 4='cd -4'
alias 5='cd -5'
alias 6='cd -6'
alias 7='cd -7'
alias 8='cd -8'
alias 9='cd -9'

function mkcd() {
  if [[ -n $1 ]]; then
    mkdir -p "$1" && cd "$1"
  else
    echo "Usage: mkcd <directory_name>"
  fi
}

function d () {
  if [[ -n $1 ]]; then
    dirs "$@"
  else
    dirs -v | head -n 10
  fi
}
compdef _dirs d

# List directory contents
alias ls='ls --color=auto'
alias l='ls -lah'
alias ll='ls -lh'
alias la='ls -lAh'

# Remove the current directory
rmcu () {
  local current_dir="$PWD"
  local parent_dir="$(dirname "$current_dir")"
  cd "$parent_dir" || {
    echo "Error: Failed to change directory to '$parent_dir'." >&2
    return 1
  }
  command rm -rf "$current_dir"
}
