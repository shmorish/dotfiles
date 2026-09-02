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

  # ジョブ指定 (%1, %+, %vim など) から元のコマンド行を REPLY に入れる
  # サブシェルではジョブテーブルが見えないため $(...) は使わない
  _herdr_job_text() {
    local spec="${1:-%+}" n
    REPLY=""
    case "$spec" in
      ""|%%|%+)
        for n in ${(k)jobstates}; do
          [[ "${${(s.:.)jobstates[$n]}[2]}" == "+" ]] && { REPLY="${jobtexts[$n]}"; return }
        done ;;
      %-)
        for n in ${(k)jobstates}; do
          [[ "${${(s.:.)jobstates[$n]}[2]}" == "-" ]] && { REPLY="${jobtexts[$n]}"; return }
        done ;;
      %<->|<->)
        REPLY="${jobtexts[${spec#%}]}" ;;
      %*)
        for n in ${(k)jobtexts}; do
          [[ "${jobtexts[$n]}" == "${spec#%}"* ]] && { REPLY="${jobtexts[$n]}"; return }
        done ;;
    esac
  }

  _herdr_preexec() {
    local -a words
    words=(${(z)1})

    # fg / %1 は再開するジョブのコマンド名を使う
    if [[ "${words[1]}" == "fg" || "${words[1]}" == %* ]]; then
      if [[ "${words[1]}" == %* ]]; then
        _herdr_job_text "${words[1]}"
      else
        _herdr_job_text "${words[2]}"
      fi
      [[ -n "$REPLY" ]] && words=(${(z)REPLY})
    fi

    # sudo / env などは読み飛ばして実体のコマンド名を取る
    local cmd="${words[1]:t}"
    while [[ "$cmd" == (sudo|env|command|nohup|time) && ${#words} -gt 1 ]]; do
      shift words
      cmd="${words[1]:t}"
    done

    [[ -n "$cmd" ]] && _herdr_set_tab "$cmd"
  }

  # コマンドが終わったらカレントディレクトリ名に戻す
  _herdr_precmd() {
    _herdr_set_tab "${PWD:t}"
  }

  add-zsh-hook preexec _herdr_preexec
  add-zsh-hook precmd _herdr_precmd
fi
