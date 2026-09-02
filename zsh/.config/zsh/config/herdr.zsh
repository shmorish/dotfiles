#!/bin/zsh
# ---------------------------------- #
# herdr: 実行中のコマンド名をタブ名にする
# ---------------------------------- #
# herdr のペイン内でだけ有効（HERDR_TAB_ID は herdr が各ペインに渡す）

if [[ -n "$HERDR_TAB_ID" ]] && (( $+commands[herdr] )); then
  autoload -Uz add-zsh-hook

  _herdr_tab_label=""

  _herdr_set_tab() {
    [[ "$1" == "$_herdr_tab_label" ]] && return   # 同じ名前なら呼ばない
    _herdr_tab_label="$1"
    herdr tab rename "$HERDR_TAB_ID" "$1" >/dev/null 2>&1 &!
  }

  # 実行するコマンド名（sudo / env などは次の語を見る）
  _herdr_preexec() {
    local -a words
    words=(${(z)1})
    local cmd="${words[1]:t}"
    while [[ "$cmd" == (sudo|env|command|nohup|time) && ${#words} -gt 1 ]]; do
      shift words
      cmd="${words[1]:t}"
    done
    _herdr_set_tab "$cmd"
  }

  # コマンドが終わったらカレントディレクトリ名に戻す
  _herdr_precmd() {
    _herdr_set_tab "${PWD:t}"
  }

  add-zsh-hook preexec _herdr_preexec
  add-zsh-hook precmd _herdr_precmd
fi
