#!/bin/zsh

# herdr のペイン内では、cd するたびにタブ名をカレントディレクトリ名へ自動更新する
# (手動リネーム prefix+shift+t は次の cd で上書きされる点に注意)
if [[ -n "$HERDR_TAB_ID" ]]; then
  autoload -Uz add-zsh-hook

  _herdr_rename_tab_to_cwd() {
    command herdr tab rename "$HERDR_TAB_ID" "${PWD:t}" &>/dev/null
  }

  add-zsh-hook chpwd _herdr_rename_tab_to_cwd
  # シェル起動時(新規タブ作成直後)にも反映する
  _herdr_rename_tab_to_cwd
fi
