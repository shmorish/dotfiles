// ステータスバー右端の Claude 使用量。~/.claude/statusline.sh が保存する
// ~/.cache/claude-limits.json（Claude Code が statusline に渡す rate_limits）を読む。
// マウスを乗せると、各枠のリセット時刻・残り時間・ペースをカードで出す。
import { View, div } from "gpui-kit";
import { h_flex, v_flex, HoverCard } from "gpui-base";
import * as fs from "fs/promises";
import { theme, home } from "herdr";

const FILE = () => `${home()}/.cache/claude-limits.json`;
const WINDOWS = [["five_hour", "5h", "5 時間枠", 5 * 3600], ["seven_day", "7d", "7 日間枠", 7 * 86400]];
const when = (s) => { const d = new Date(s * 1000); return `${d.getMonth() + 1}/${d.getDate()} ${d.getHours()}:${String(d.getMinutes()).padStart(2, "0")}`; };
const span = (sec) => {
  const m = Math.max(0, Math.round(sec / 60)), d = Math.floor(m / 1440), h = Math.floor((m % 1440) / 60);
  return d ? `${d}日${h}時間` : h ? `${h}時間${m % 60}分` : `${m}分`;
};

export default class ClaudeLimits extends View {
  init(_props, cx) {
    this.data = null;
    this.load(cx);
    cx.timer.every(10000, (cx) => this.load(cx));
  }

  load(cx) {
    cx.spawn(async (cx) => {
      try { this.data = JSON.parse(await fs.readFile(FILE(), "utf8")); } catch { this.data = null; }
      cx.notify();
    });
  }

  render() {
    const t = theme();
    const now = Date.now() / 1000;
    const rl = this.data?.rate_limits ?? {};
    const wins = WINDOWS.filter(([k]) => rl[k]).map(([k, short, long, len]) => {
      const w = rl[k];
      // リセット時刻を過ぎていれば、次の応答までは 0% とみなす
      const over = w.resets_at && w.resets_at < now;
      const pct = over ? 0 : Math.round(w.used_percentage ?? 0);
      // 枠のうち経過した割合。使用率がこれを上回っていれば、このままだと枠を使い切る
      const elapsed = w.resets_at && !over ? Math.min(100, Math.max(0, 100 - ((w.resets_at - now) / len) * 100)) : null;
      const color = pct >= 90 ? t.ansi1 : pct >= 70 ? t.ansi3 : elapsed != null && pct > elapsed + 10 ? t.ansi3 : t.ansi2;
      return { k, short, long, w, pct, elapsed, color, over };
    });

    const bar = (pct, width, height, color, tick) => div().relative().w(width).h(height).rounded(height / 2).bg(t.border)
      .child(div().h_full().rounded(height / 2).bg(color).w((width * Math.min(pct, 100)) / 100))
      .when(tick != null, (el) => el.child(div().absolute().top(-2).w(1.5).h(height + 4).bg(t.foreground).left((width * tick) / 100)));

    const strip = h_flex().id("limits").size_full().pr(14).gap(12).items_center().justify_end().text_size(11.8)
      .child(div().text_color(t.dim).child(wins.length ? "Claude" : "Claude —"))
      .children(wins.map((x) => h_flex().gap(5).items_center()
        .child(div().text_color(t.dim).child(x.short))
        .child(bar(x.pct, 36, 5, x.pct >= 70 ? x.color : t.muted))
        .child(div().w(30).text_color(x.pct >= 70 ? x.color : t.muted).child(`${x.pct}%`))));

    const card = v_flex().w(300).p(14).gap(14).rounded(10).bg(t.surface ?? t.background).border(1).border_color(t.border).text_size(12).text_color(t.foreground)
      .child(h_flex().items_center()
        .child(div().flex_1().font_semibold().text_size(13).child("Claude の使用量"))
        .child(div().text_color(t.dim).text_size(11).child(this.data?.updated_at ? (now - this.data.updated_at < 60 ? "たった今更新" : `${span(now - this.data.updated_at)}前に更新`) : "")))
      .children(wins.length ? wins.map((x) => v_flex().gap(6)
        .child(h_flex().items_end()
          .child(div().flex_1().text_color(t.muted).child(x.long))
          .child(div().text_size(20).font_semibold().text_color(x.color).child(`${x.pct}%`)))
        .child(bar(x.pct, 272, 8, x.color, x.elapsed))
        .child(h_flex().text_size(11).text_color(t.dim)
          .child(div().flex_1().child(x.over ? "リセット済み（次の応答で更新）" : `あと ${span(x.w.resets_at - now)}（${when(x.w.resets_at)}）`))
          .when(x.elapsed != null, (el) => el.child(div().text_color(x.pct > x.elapsed + 10 ? t.ansi3 : t.dim)
            .child(x.pct > x.elapsed + 10 ? "ペース速め" : `経過 ${Math.round(x.elapsed)}%`)))))
        : [div().text_color(t.dim).child("まだデータがありません。Claude Code が一度応答すると表示されます。")])
      .child(div().text_size(10.5).text_color(t.dim).child("縦線は枠の経過時間。Claude が応答するたびに更新"));

    return div().size_full().bg(t.chrome).border_t(1).border_color(t.border)
      .child(HoverCard.new("claude-limits").anchor("bottom_right").open_delay(250).trigger(strip).content(card));
  }
}
