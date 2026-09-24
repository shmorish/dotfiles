-- ピッカー (snacks picker)
return {
  {
    "folke/snacks.nvim",
    keys = {
      -- `Space Space` を smart picker に置き換える
      -- 開いているバッファ / 最近使ったファイル / プロジェクト内のファイルを
      -- まとめて出し、使用頻度 (frecency) で並べ替える
      -- filter.cwd を外すと、他プロジェクトで最近開いたファイルも候補に入る
      {
        "<leader><space>",
        function()
          Snacks.picker.smart({ cwd = LazyVim.root(), filter = { cwd = true } })
        end,
        desc = "Smart Find Files",
      },
    },
  },
}
