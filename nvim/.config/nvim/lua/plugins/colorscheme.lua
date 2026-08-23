-- 配色: kanagawa-dragon
-- WezTerm 側で背景を透過 (opacity 0.75) しているので transparent を有効にする。
-- 補完メニューなどのフロートは読みやすさ優先で背景を残す。
return {
  {
    "rebelot/kanagawa.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
      dimInactive = false,
      terminalColors = true,
    },
  },
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanagawa-dragon",
    },
  },
}
