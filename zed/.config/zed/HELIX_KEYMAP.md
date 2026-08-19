# Zed Helixモード キーバインド チートシート

`helix_mode: true` (base_keymap: VSCode) 時の主要キーバインドまとめ。
出典: [zed-industries/zed assets/keymaps/vim.json](https://github.com/zed-industries/zed/blob/main/assets/keymaps/vim.json)

このファイルは `keymap.json` の動作に影響しない、参照用ドキュメントです。

## このリポジトリで追加したもの (`keymap.json`)

git操作は `alt-g` (option+g) をリーダーキーにした2ストローク。
`(vim_mode == helix_normal || vim_mode == helix_select)` コンテキスト限定 = インサートモードでは発火しない。

| キー | アクション | 内容 |
|---|---|---|
| `alt-g g` | `git_panel::ToggleFocus` | Gitパネルを開く/フォーカス(status) |
| `alt-g d` | `git::Diff` | diff表示 |
| `alt-g b` | `git::Blame` | blame表示 |
| `alt-g m` | `git::OpenModifiedFiles` | 変更ファイル一覧を開く |
| `alt-g t` | `git::ToggleStaged` | ステージ切替 |
| `alt-g x` | `git::Restore` | restore(変更を破棄) |
| `alt-g c` | `git::Commit` | commit |
| `alt-g p` | `git::Push` | push |
| `alt-g l` | `git::Pull` | pull |
| `alt-g f` | `git::Fetch` | fetch |
| `alt-g a` | `git::StageAll` | 全ステージ |
| `alt-g u` | `git::UnstageAll` | 全アンステージ |
| `alt-g` (Gitパネルにフォーカス中のみ、単発) | `git_panel::ToggleFocus` | フォーカスをエディタに戻す(閉じる) |

補足:
- `cmd-g` / `cmd-shift-g` はmacOSの標準ショートカット(Find Next/Previous)にOSレベルで奪われるため使用不可
- `space g g` ではなく `alt-g g` にしたのは、`space`だと3ストロークになるため
- `\` (バックスラッシュ) も検討したが、インサートモードで頻繁に入力する文字のため見送り

## `space` リーダー(Helix既定・最重要)

Helixの主要な発見の入口。`(vim_mode == helix_normal || vim_mode == helix_select) && !menu` で有効。

| キー | アクション | 内容 |
|---|---|---|
| `space f` | `file_finder::Toggle` | ファジーファイル検索 |
| `space b` | `tab_switcher::ToggleAll` | バッファ/タブ切り替え |
| `space k` | `editor::Hover` | hover(ドキュメント表示) |
| `space s` | `outline::Toggle` | ファイル内アウトライン(シンボル一覧) |
| `space shift-s` | `project_symbols::Toggle` | プロジェクト全体のシンボル検索 |
| `space d` | `editor::GoToDiagnostic` | 次の診断(エラー・警告)へ移動 |
| `space r` | `editor::Rename` | シンボルのリネーム |
| `space a` | `editor::ToggleCodeActions` | コードアクション表示 |
| `space h` | `editor::SelectAllMatches` | 選択中の文字列/検索語を全部選択 |
| `space c` | `editor::ToggleComments` | 行コメントの切替 |
| `space p` | `editor::Paste` | ペースト(システムクリップボード) |
| `space y` | `editor::Copy` | コピー(システムクリップボード) |
| `space /` | `pane::DeploySearch` | プロジェクト全体検索 |
| `space w v` / `space w s` | `pane::SplitRight` / `SplitDown` | 縦/横分割 |
| `space w h/j/k/l` | ペイン間フォーカス移動 | 左/下/上/右 |
| `space w q` | `pane::CloseActiveItem` | 現在のペイン/タブを閉じる |
| `space shift-g l` | `debugger::Start` | デバッガー開始 |
| `space shift-g r` | `debugger::Restart` | デバッガー再起動 |
| `space shift-g b` | `editor::ToggleBreakpoint` | ブレークポイント切替 |
| `space shift-g c` | `debugger::Continue` | continue |
| `space shift-g i` / `o` / `n` | step into / out / over | ステップ実行 |
| `space shift-g h` | `debugger::Pause` | 一時停止 |
| `space shift-g t` | `debugger::Stop` | 停止 |

## `g` プレフィックス(goto系)

| キー | アクション | 内容 |
|---|---|---|
| `g g` / `shift-g` | 先頭 / 末尾 | ファイル先頭/末尾へ |
| `g h` / `g l` | 行頭 / 行末 | |
| `g d` / `g shift-d` | 定義 / 宣言 | |
| `g y` | 型定義へ | |
| `g r` | `FindAllReferences` | 参照をすべて検索 |
| `g i` / `g shift-i` | `GoToImplementation` | 実装へ移動 |
| `g a` | `pane::AlternateFile` | 関連ファイル(実装⇄テストなど)へ |
| `g n` / `g p` | 次/前のタブ | |
| `g t` / `g c` / `g b` | 画面上/中央/下端へスクロール | |
| `g w` | `HelixJumpToWord` | 画面内の単語へラベルジャンプ(avy的) |
| `g .` | 直前の編集位置へジャンプ | |
| `g x` | カーソル下のURLを開く | |
| `g f` | カーソル下のファイルパスを開く | |
| `g ]` / `g [` | 次/前の診断へ | |
| `g space` | `OpenExcerpts` | 該当箇所をマルチバッファで開く |
| `] X` / `[ X` | 次/前のオブジェクトへ | `z`=セクション, `d`=診断, `c`=コメント, `x`=構文ノード等 |

## 選択操作(Helixはselection-first)

| キー | アクション | 内容 |
|---|---|---|
| `v` | Selectモード切替 | |
| `;` | `HelixCollapseSelection` | 選択をカーソル1点に収束 |
| `alt-;` | `OtherEnd` | anchor/headを反転 |
| `,` | `HelixKeepNewestSelection` | 最新の選択だけ残す |
| `shift-c` | `HelixDuplicateBelow` | 下に新しいカーソルを追加 |
| `alt-shift-c` | `HelixDuplicateAbove` | 上に新しいカーソルを追加 |
| `%` | `SelectAll` | 全選択 |
| `x` | `HelixSelectLine` | 選択を行単位に拡張 |
| `s` | `HelixSelectRegex` | 選択内の正規表現一致を選択 |
| `alt-s` | 複数行選択を行ごとに分割 | |
| `n` / `shift-n` | `HelixSelectNext` / `Previous` | 次/前の検索一致を選択に追加(マルチセレクト) |
| `alt-o` / `alt-i` | 構文ノード単位で選択拡大/縮小 | |
| `alt-p` / `alt-n` | 前/次の兄弟構文ノードを選択 | |
| `m` → `m/s/r/d` | Match / Surround Add / Replace / Delete | 囲み文字操作 |

## 編集

| キー | アクション | 内容 |
|---|---|---|
| `i` / `a` | 選択前 / 後にInsert | |
| `shift-a` | 行末でInsert | |
| `o` / `shift-o` | 下/上に新規行を挿入 | |
| `d` / `alt-d` | 削除(yankあり/なし) | |
| `c` / `alt-c` | 削除して編集モード(yankあり/なし) | |
| `y` | yank(コピー) | |
| `p` / `shift-p` | paste(後/前) | |
| `shift-r` | 選択をyank内容で置換 | |
| `>` / `<` / `=` | インデント / アウトデント / 自動インデント | |
| `` ` `` / `alt-`` ` `` | 小文字化 / 大文字化 | |
| `~` | 大文字小文字トグル | |
| `shift-j` | 行結合 | |
| `ctrl-a` / `ctrl-x` | 数値をインクリメント/デクリメント | |
| `u` / `shift-u` | undo / redo(Helixは`U`がredo) | |
| `r` | 文字置換 | |
| `ctrl-c` / `space c` | 行コメント切替 | |
| `g q` | 段落の折り返し(rewrap) | |

## 検索

| キー | アクション | 内容 |
|---|---|---|
| `/` / `?` | 前方/後方検索 | |
| `n` / `shift-n` | 次/前の一致を選択に追加 | (Helixは「検索繰り返し」ではなくマルチセレクト) |
| `*` | 現在の選択を検索パターンに | |
| `g /` / `space /` | プロジェクト全体検索 | |

## ウィンドウ/ペイン管理 (`ctrl-w`, vimと共通)

| キー | 内容 |
|---|---|
| `ctrl-w h/j/k/l` | ペイン間フォーカス移動 |
| `ctrl-w shift-h/j/k/l` | ペイン自体を移動 |
| `ctrl-w v` / `ctrl-w s` | 縦/横分割 |
| `ctrl-w c` / `ctrl-w q` | 現在のペイン/タブを閉じる |
| `ctrl-w a` | 全タブを閉じる |
| `ctrl-w o` | 他のタブ/ペインを閉じる |
| `ctrl-w _` | ペイン最大化 |
| `ctrl-w =` | ペインサイズをリセット |

## マクロ・その他

| キー | アクション | 内容 |
|---|---|---|
| `q` | `ReplayLastRecording` | マクロ再生(vimと逆!) |
| `shift-q` | `ToggleRecord` | マクロ記録(vimと逆!) |
| `@` | 指定レジスタのマクロ再生 | |
| `.` | 直前の変更を繰り返す | |
| `:` | コマンドパレットを開く | |
| `'` / `` ` `` | ジャンプリスト(マーク) | |
| `ctrl-o` / `ctrl-i` | ジャンプ履歴を戻る/進む | |
| `z` + `t`/`z`/`b` | カーソル位置基準でスクロール(上/中央/下) | |
| `shift-z shift-q` / `shift-z shift-z` | 保存せず閉じる / 保存して閉じる | |
