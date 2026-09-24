-- 自動保存 (Zed の autosave.after_delay 相当)
--
-- 既定では編集が止まってから 1 秒後に保存し、バッファを離れる / 他アプリへ移る /
-- 終了する / Ctrl-z で中断する時は即保存する。Insert 中は発火しない。
-- 通常の `:write` を通るので conform の保存時整形もそのまま効く。
-- 一時的に止めたいときは `:ASToggle`。
return {
  {
    "okuuva/auto-save.nvim",
    version = "^1",
    event = { "InsertLeave", "TextChanged" },
    opts = {
      debounce_delay = 1000,
      condition = function(buf)
        -- 通常のファイルバッファのみ対象（ターミナル・quickfix・hunk.nvim などを除外）
        if vim.bo[buf].buftype ~= "" then
          return false
        end
        -- コミットメッセージなど、書き込み時点が意味を持つものは対象外
        local ft = vim.bo[buf].filetype
        return ft ~= "gitcommit" and ft ~= "gitrebase"
      end,
    },
  },
}
