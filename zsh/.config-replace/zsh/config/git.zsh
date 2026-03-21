#!/bin/zsh

# Git
alias g='git'
alias gs='git status'
alias gss='git status -s'
alias gp='git push'
alias gl='git pull'
alias gf='git fetch'
alias gba='git branch -a'
alias gbd='git branch -D'
alias gbnuke="git branch | grep -v '^\*' | xargs -n 1 git branch -D"
alias gwip='git add -A; git rm $(git ls-files --deleted) 2> /dev/null; git commit --no-verify --no-gpg-sign --message "--wip-- [skip ci]"'
