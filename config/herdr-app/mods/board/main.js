// 案件ボード: 案件フォルダ配下の repo と、その全 checkout（本体・worktree）を一覧する。
// 各行: ブランチ、未コミット数、ahead/behind、そこで動く Claude の状態、PR。
// props: { folder } 案件フォルダ。無ければ表示中の space の場所から決め、space を移ると追従する。

import { View, div } from "gpui-kit";
import { v_flex, h_flex } from "gpui-base";
import * as fs from "fs/promises";
import { exec, panes, props, run, theme, home, focused } from "herdr";

const RANK = { blocked: 3, done: 2, working: 1, idle: 0 };
const worst = (list) => list.reduce((a, s) => ((RANK[s] ?? -1) > (RANK[a] ?? -1) ? s : a), null);
const tilde = (p) => (p.startsWith(home()) ? `~${p.slice(home().length)}` : p);
const git = (cwd, args) => exec("git", ["--no-optional-locks", "-c", "core.fsmonitor=false", ...args], { cwd });

// `git status --porcelain=v2 --branch` -> { branch, ahead, behind, dirty }
function status(out) {
  const s = { branch: null, ahead: 0, behind: 0, dirty: 0 };
  for (const line of out.split("\n")) {
    if (line.startsWith("# branch.head ")) s.branch = line.slice(14);
    else if (line.startsWith("# branch.ab ")) {
      const [a, b] = line.slice(12).split(" ");
      s.ahead = Math.abs(parseInt(a, 10)) || 0;
      s.behind = Math.abs(parseInt(b, 10)) || 0;
    } else if (line && !line.startsWith("#")) s.dirty++;
  }
  return s;
}

export default class Board extends View {
  init(_props, cx) {
    this.repos = null; // [{ name, path, checkouts: [{ path, main, branch, ahead, behind, dirty }] }]
    this.prs = {}; // repo path -> { branch -> { number, state, draft } }
    this.error = null;
    this.dir = props()?.folder ?? null;
    this.width = Infinity;
    if (this.dir) this.refresh(cx);
    else {
      this.follow(cx);
      cx.timer.every(1000, (cx) => this.follow(cx));
    }
    // ponytail: 定期取得。repo が多くて重くなったら watchFolder に替える
    cx.timer.every(15000, (cx) => this.refresh(cx));
    cx.timer.every(120000, (cx) => this.refreshPrs(cx));
  }

  folder() {
    return this.dir;
  }

  // 表示中の space が変わったら、その案件を出し直す。
  follow(cx) {
    const space = focused()?.space ?? null;
    if (space === this.space) return;
    this.space = space;
    cx.spawn(async (cx) => {
      const dir = await this.guess();
      if (dir === this.dir) return;
      Object.assign(this, { dir, repos: null, prs: {}, prNote: null });
      cx.notify();
      this.refresh(cx);
    });
  }

  // フォーカス中の場所 -> 出すフォルダ。projects.json の案件の中ならそれ、
  // その案件の repo の worktree ならその案件、それ以外の repo なら repo 単体、どれでもなければその場所。
  async guess() {
    const cwd = focused()?.cwd;
    if (!cwd) return null;
    let list = [];
    try { list = JSON.parse(await fs.readFile(`${home()}/.config/herdr-app/projects.json`, "utf8")).map((d) => d.replace(/^~/, home())); } catch {}
    const hit = list.find((d) => cwd === d || cwd.startsWith(`${d}/`));
    if (hit) return hit;
    try {
      const r = await exec("git", ["rev-parse", "--path-format=absolute", "--git-common-dir"], { cwd });
      if (r.code === 0) {
        // 案件一覧の案件の repo（別の場所の worktree 含む）ならその案件、そうでなければ repo 単体
        const main = r.stdout.trim().replace(/\/\.git$/, "");
        const parent = main.slice(0, main.lastIndexOf("/")) || "/";
        return list.includes(parent) ? parent : main;
      }
    } catch {}
    return cwd;
  }


  refresh(cx) {
    cx.spawn(async (cx) => {
      const dir = this.folder();
      if (!dir) return;
      try {
        const ls = await exec("sh", ["-c", 'if [ -d .git ]; then echo .; else for d in */; do [ -d "$d.git" ] && echo "${d%/}"; done; fi'], { cwd: dir });
        const repos = [];
        for (const name of ls.stdout.split("\n").filter(Boolean)) {
          const path = name === "." ? dir : `${dir}/${name}`;
          const wl = await git(path, ["worktree", "list", "--porcelain"]);
          const checkouts = [];
          for (const block of wl.stdout.split(/\n\n+/)) {
            const p = block.split("\n").find((l) => l.startsWith("worktree "))?.slice(9);
            if (!p || /\n(bare|prunable)/.test(`\n${block}`)) continue;
            const st = await git(p, ["status", "--porcelain=v2", "--branch"]);
            if (st.code === 0) checkouts.push({ path: p, main: p === path, ...status(st.stdout) });
          }
          repos.push({ name: path.split("/").pop(), path, checkouts });
        }
        const first = !this.repos;
        this.repos = repos;
        this.error = null;
        if (first) this.refreshPrs(cx);
      } catch (e) {
        this.error = String(e.message ?? e);
      }
      cx.notify();
    });
  }

  // Herdr の PATH に nix の bin が入らないことがあるので、見つからなければそちらを試す。
  async gh(args, cwd) {
    for (const bin of this.ghBin ? [this.ghBin] : ["gh", `${home()}/.nix-profile/bin/gh`, "/opt/homebrew/bin/gh"]) {
      try { const r = await exec(bin, args, { cwd }); this.ghBin = bin; return r; } catch (e) { if (this.ghBin) throw e; }
    }
    throw new Error("gh が見つかりません");
  }

  // gh が無い・認証切れ・remote が GitHub でない repo は PR 欄が空になるだけ。
  refreshPrs(cx) {
    cx.spawn(async (cx) => {
      this.prNote = null;
      for (const r of this.repos ?? []) {
        try {
          const res = await this.gh(["pr", "list", "--state", "all", "--limit", "50", "--json", "number,state,isDraft,headRefName"], r.path);
          if (res.code !== 0) { this.prNote = `PR: ${(res.stderr || res.stdout).trim().split("\n")[0]}`; continue; }
          const by = {};
          for (const p of JSON.parse(res.stdout)) by[p.headRefName] ??= { number: p.number, state: p.isDraft ? "DRAFT" : p.state };
          this.prs[r.path] = by;
        } catch (e) { this.prNote = `PR: ${e.message ?? e}`; }
      }
      cx.notify();
    });
  }

  // worktree を消し、マージ済みのブランチも消す。未コミットの変更があれば git が断るのでそのまま残る。
  remove(r, c, cx) {
    this.arming = null;
    cx.spawn(async (cx) => {
      const res = await git(r.path, ["worktree", "remove", c.path]);
      if (res.code !== 0) this.prNote = `削除できません: ${(res.stderr || res.stdout).trim().split("\n")[0]}`;
      else if (c.branch) await git(r.path, ["branch", "-D", c.branch]);
      cx.notify();
      this.refresh(cx);
    });
  }

  row(r, c, t, ps) {
    const here = ps.filter((p) => p.terminal && p.cwd && (p.cwd === c.path || p.cwd.startsWith(`${c.path}/`)));
    const agents = here.filter((p) => p.status);
    const s = worst(agents.map((p) => p.status));
    const target = agents.find((p) => p.status === s) ?? here[0];
    const pr = c.branch && this.prs[r.path]?.[c.branch];
    const prColor = { OPEN: t.ansi2, DRAFT: t.dim, MERGED: t.ansi5, CLOSED: t.ansi1 }[pr?.state];
    const label = c.main ? c.branch ?? "(detached)" : `${c.branch ?? "(detached)"}  ${c.path.split("/").pop()}`;
    const git = h_flex().gap(6).flex_none()
      .child(div().text_color(c.dirty ? t.ansi3 : t.dim).child(c.dirty ? `✎${c.dirty}` : "clean"))
      .when(c.ahead > 0, (el) => el.child(div().text_color(t.ansi2).child(`↑${c.ahead}`)))
      .when(c.behind > 0, (el) => el.child(div().text_color(t.ansi1).child(`↓${c.behind}`)));
    const agent = target
      ? div().flex_none().text_color(s ? t[s] ?? t.unknown : t.muted).child(s ? `● ${s}${agents.length > 1 ? ` ×${agents.length}` : ""}` : "shell")
      : div().id(`start-${c.path}`).flex_none().px(6).rounded(4).text_color(t.muted).cursor_pointer()
        .hover((st) => st.bg(t.raised).text_color(t.foreground))
        .on_click((_e, cx) => { cx.stop_propagation(); run("space.new", { folder: c.path, argv: ["claude"] }); })
        .child("+ Claude");
    const prEl = div().flex_none().text_color(prColor ?? t.dim).child(pr ? `#${pr.number} ${pr.state.toLowerCase()}` : "");
    // PR がマージ済みで、そこで何も動いていない worktree だけ消せる。1 回目で確認表示、2 回目で実行
    const removable = !c.main && !target && pr?.state === "MERGED";
    const armed = this.arming === c.path;
    const rm = div().id(`rm-${c.path}`).flex_none().px(6).rounded(4).text_size(11.5).cursor_pointer()
      .text_color(armed ? t.ansi1 : t.dim).when(armed, (el) => el.bg(t.raised))
      .hover((st) => st.bg(t.raised).text_color(t.ansi1))
      .on_click((_e, cx) => { cx.stop_propagation(); armed ? this.remove(r, c, cx) : (this.arming = c.path, cx.notify()); })
      .child(armed ? "本当に削除" : "削除");
    const name = div().flex_1().min_w(0).truncate().text_color(t.foreground).child(label);
    // 狭い（右パネル）ときは 名前 / 状態 の 2 段にする
    const narrow = this.width < 560;
    const meta = (narrow
      ? h_flex().gap(12).text_size(11.5).child(git).child(agent).child(prEl)
      : h_flex().flex_none().gap(12).text_size(11.5).child(git.w(90)).child(div().w(110).child(agent)).child(prEl.w(80)))
      .when(removable, (el) => el.child(rm));
    return h_flex().id(`co-${c.path}`).px(10).py(5).gap(8).items_start().rounded(6)
      .when(Boolean(target), (el) => el.cursor_pointer().hover((st) => st.bg(t.hover)).on_click(() => run("pane.focus", { pane: target.pane })))
      .child(div().w(14).flex_none().text_color(t.dim).child(c.main ? "" : "└"))
      .child(narrow
        ? v_flex().flex_1().min_w(0).gap(2).child(name).child(meta)
        : h_flex().flex_1().min_w(0).gap(12).items_center().child(name).child(meta));
  }

  render() {
    const t = theme();
    const dir = this.folder();
    const ps = panes();
    const head = h_flex().h(40).px(14).gap(10).items_center().border_b(1).border_color(t.border)
      .child(div().text_size(14).font_semibold().text_color(t.foreground).child(dir ? dir.split("/").pop() : "案件ボード"))
      .child(div().flex_1().truncate().text_size(11.5).text_color(t.dim).child(dir ? tilde(dir) : ""))
      .when(Boolean(this.prNote), (el) => el.child(div().max_w(260).truncate().text_size(11.5).text_color(t.ansi3).child(this.prNote)))
      .child(div().id("reload").px(6).rounded(4).text_color(t.muted).cursor_pointer()
        .hover((st) => st.bg(t.hover).text_color(t.foreground))
        .on_click((_e, cx) => { this.refresh(cx); this.refreshPrs(cx); })
        .child("⟳"));
    const body = !dir ? [div().p(14).text_color(t.dim).child("フォーカス中の場所が分かりません")]
      : this.error ? [div().p(14).text_color(t.blocked).child(this.error)]
      : !this.repos ? [div().p(14).text_color(t.dim).child("読み込み中…")]
      : !this.repos.length ? [div().p(14).text_color(t.dim).child("repo がありません")]
      : this.repos.flatMap((r) => [
        div().pt(10).pb(2).px(10).text_size(12).font_semibold().text_color(t.muted).child(r.name),
        ...r.checkouts.map((c) => this.row(r, c, t, ps)),
      ]);
    return v_flex().id("root").size_full().bg(t.background).text_size(13)
      .on_size_change((size, cx) => { if (size.width !== this.width) { this.width = size.width; cx.notify(); } })
      .child(head)
      .child(v_flex().flex_1().min_h(0).px(6).pb(14).overflow_y_scrollbar().children(body));
  }
}
