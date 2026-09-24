-- 配色: kanagawa-dragon
-- 背景は透過せず、dragon 既定 (#181616) より一段暗い色を塗る
return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = false,
      dimInactive = false,
      terminalColors = true,
      colors = {
        theme = {
          dragon = {
            ui = {
              bg = "#121111", -- 本文の背景（既定 #181616）
              bg_gutter = "#121111", -- 行番号・サイン列を本文と揃える
              bg_dim = "#0e0d0d", -- 非アクティブ側の背景
            },
          },
        },
      },
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-dragon",
    },
  },
}
