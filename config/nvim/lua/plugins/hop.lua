-- hop.nvim: 候補にラベルを出して 1 打で飛ぶ
-- f / F / t / T を「画面内ジャンプ」に置き換える（行内限定ではない）
local function hop(dir, offset)
  return function()
    require("hop").hint_char1({
      direction = require("hop.hint").HintDirection[dir],
      hint_offset = offset,
    })
  end
end

return {
  {
    "smoka7/hop.nvim",
    version = "*",
    keys = {
      { "f", hop("AFTER_CURSOR"), mode = { "n", "x", "o" }, desc = "Hop: 画面内の文字へ（前方）" },
      { "F", hop("BEFORE_CURSOR"), mode = { "n", "x", "o" }, desc = "Hop: 画面内の文字へ（後方）" },
      { "t", hop("AFTER_CURSOR", -1), mode = { "n", "x", "o" }, desc = "Hop: 画面内の文字の手前へ（前方）" },
      { "T", hop("BEFORE_CURSOR", 1), mode = { "n", "x", "o" }, desc = "Hop: 画面内の文字の手前へ（後方）" },
    },
    opts = {
      -- ラベルに使う文字（ホームポジション優先）
      keys = "etovxqpdygfblzhckisuran",
      -- 分割している他のウィンドウにも飛べるようにする
      multi_windows = true,
    },
  },

  -- flash.nvim も f/t/F/T/;/, を拡張するため、二重にならないよう char モードだけ無効化する
  -- `s`（2 文字ジャンプ）や `S`（Treesitter ジャンプ）はそのまま使える
  {
    "folke/flash.nvim",
    opts = {
      modes = { char = { enabled = false } },
    },
  },
}
