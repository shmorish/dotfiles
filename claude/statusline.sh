#!/bin/sh
# Claude Code の statusLine。渡される rate_limits を Herdr の claude-limits mod 用に保存し、
# 下部にはモデル名と使用率を出す。token は読まない（Claude Code が渡す JSON だけを使う）。
input=$(cat)
rl=$(printf '%s' "$input" | jq -c '.rate_limits // empty' 2>/dev/null)
if [ -n "$rl" ]; then
  dir="${XDG_CACHE_HOME:-$HOME/.cache}"
  mkdir -p "$dir"
  printf '{"updated_at":%s,"rate_limits":%s}\n' "$(date +%s)" "$rl" >"$dir/claude-limits.json.$$" &&
    mv -f "$dir/claude-limits.json.$$" "$dir/claude-limits.json"
fi
printf '%s' "$input" | jq -r '[.model.display_name,
  (.rate_limits.five_hour.used_percentage // empty | "5h \(.)%"),
  (.rate_limits.seven_day.used_percentage // empty | "7d \(.)%")] | join("  ")' 2>/dev/null
