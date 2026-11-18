---
name: herdr-lead
description: Herdr の案件フォルダ（複数 repo をまとめたディレクトリ）で動く Claude が、各 repo の worktree に作業役の Claude を立てて仕事を振り、見張り、結果をまとめるときに使う。「案件を統括して」「各 repo に振って」「worktree 立てて Claude に任せて」と言われたとき、または /herdr-lead で使う。
---

# herdr-lead

自分は案件の統括役。repo を直接いじらず、作業役の Claude に振って結果をまとめる。
`hc` の細かい使い方は `hc --skill` が正。最初に 1 回読む。

## 前提

- `$HC_TERMINAL_ID` が空なら Herdr の外。止めてユーザーに伝える。
- 作業ディレクトリ（`$PWD`）が案件フォルダ。配下の各ディレクトリが repo。
- 起動前の確認は取らない（任せきり）。人に聞くのは下の「人に回すもの」だけ。

## 手順

1. **把握**: 配下の repo と既存の worktree、動いている作業役を見る。
   ```sh
   for d in */; do [ -e "$d/.git" ] && echo "$d $(git -C "$d" branch --show-current)"; done
   git -C <repo> worktree list
   hc ls
   ```
2. **分割**: 依頼を「repo × 1 トピック」の作業に分ける。1 作業 = 1 作業役 = 1 worktree。同じ repo の同じファイルを 2 人に触らせない。
3. **worktree**: 案件フォルダ直下に `wt-<repo>-<slug>` で作る（本体 repo の隣）。ベースは最新の既定ブランチ。
   ```sh
   git -C <repo> fetch -q origin
   base=$(git -C <repo> symbolic-ref --short refs/remotes/origin/HEAD)   # 例: origin/main
   git -C <repo> worktree add "$PWD/wt-<repo>-<slug>" -b <type>/<slug> "$base"
   ```
4. **起動**: 作業役は Herdr の space として見えるように、未知の space/tab ID のラベルを付けて起動する（新しい space になり、親は自分として記録される）。続けて space に名前を付ける。
   ```sh
   repo=<repo>; slug=<slug>; n="${repo}-${slug}"   # 変数は必ず ${} で囲む（zsh だと "$repo:c..." の :c が修飾子として消える）
   hc run --bg --outlive-parent --name "$n" --cwd "$PWD/wt-$n" \
     --label herdr.space="sp-$n" --label herdr.tab="tb-$n" \
     claude "<タスク>"
   # space ができるまで数秒かかるので、成功するまで試す
   for i in 1 2 3 4 5 6 7 8 9 10; do herdr-app do space.rename --id "sp-$n" --name "${repo}:${slug}" >/dev/null 2>&1 && break; sleep 1; done
   ```
   起動直後に「このフォルダを信頼するか」で止まることがある（`hc read` で `trust this folder` が見える）。自分で作った worktree なので `hc keys "$n" down enter` で信頼して進める。タスクはその後に届く。
   `<タスク>` は次の順で書く: やること / 触ってよい範囲 / 完了条件（例: このブランチにコミットまで、push と PR はしない）/「作業役を増やさない」/「終わったら、または詰まったら hc send $HC_TERMINAL_ID で報告」。
   起動結果の `first_message.sent` が false なら、`hc read` で状態を見てから送り直す。
5. **見張り**: 全員が終わるまで繰り返す。sleep で待たない。
   ```sh
   hc wait --children any      # 誰かの報告・終了・blocked で戻る
   hc read <name> --lines 60
   ```
   - 報告が来た / done: 結果を読み、完了条件を満たしているか `git -C wt-<name> log --oneline -3` などで確かめる。足りなければ `hc send <name> "..."`。
   - blocked（権限確認など）: 画面を読み、タスクの範囲内なら自分で答える（`hc keys <name> enter` など）。範囲外なら人に回す。
6. **まとめ**: 作業役ごとに「ブランチ・コミット・残課題」を 1 行ずつ報告する。worktree と作業役はユーザーが確認できるよう残す（消すのは頼まれたとき）。

## 人に回すもの

止めずに他の作業役は見張り続け、まとめて報告する。

- 依頼の範囲外の変更、削除、force push、本番やクラウドへの操作の許可
- 作業役どうしで方針がぶつかったとき

## よくある間違い

| 間違い | 正しくは |
|---|---|
| Agent ツールの subagent に振る | `hc run` で作業役を立てる。Herdr に見えないし、後から人が触れない |
| 本体 repo のチェックアウトで作業させる | 必ず worktree。並行作業がぶつかる |
| `--bg` を付けずに `hc run` | 画面が全部自分の出力に流れ込む |
| 起動後に `hc send` でタスクを渡す | 起動時の引数で渡す。起動中の send は落ちることがある |
| `--outlive-parent` を付けない | 統括役が終わると作業役も道連れになる |
| `hc send` 直後の `hc wait <name>` で終わったと判断 | 前のターンの done が返ることがある。`turn` が増えたか見る |
