-- hunk.nvim: 差分を hunk / 行単位で選択して分割するエディタ
-- `:DiffEditor <left> <right> [output]` で起動する（git difftool や jj の diff-editor 用）
return {
  {
    "julienvincent/hunk.nvim",
    cmd = { "DiffEditor" },
    dependencies = { "MunifTanjim/nui.nvim" },
    opts = {
      ui = {
        -- 左右に並べる（横に割りたいなら "horizontal"）
        layout = "vertical",
        tree = { mode = "nested", width = 35 },
        confirm_before_quit = true,
      },
    },
    config = function(_, opts)
      require("hunk").setup(opts)
    end,
  },
}
