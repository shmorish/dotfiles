-- ステータスライン左端のモード表示を、旧設定と同じ「色付きの記号」に戻す
-- NORMAL / INSERT の文字ではなく、記号の色でモードを判別する
-- 旧設定 (main ブランチの lualine.lua) と同じ配色
local colors = {
  red = "#ec5f67",
  green = "#98be65",
  blue = "#51afef",
  violet = "#a9a1e1",
  magenta = "#c678dd",
  gray = "#625e5a",
}

-- lualine が mode ごとに作るハイライトグループ名 → 記号の色
local mode_hl = {
  lualine_a_normal = colors.red,
  lualine_a_insert = colors.green,
  lualine_a_visual = colors.blue,
  lualine_a_replace = colors.violet,
  lualine_a_command = colors.magenta,
  lualine_a_terminal = colors.red,
  lualine_a_inactive = colors.gray,
}

-- 記号が色付きのブロックにならないよう、背景をステータスラインに合わせて塗り直す
local function paint()
  local sl = vim.api.nvim_get_hl(0, { name = "StatusLine", link = false })
  local bg = sl.bg and string.format("#%06x", sl.bg) or "#0d0c0c"
  for group, fg in pairs(mode_hl) do
    vim.api.nvim_set_hl(0, group, { fg = fg, bg = bg, bold = true })
  end
end

return {
  {
    "nvim-lualine/lualine.nvim",
    opts = function(_, opts)
      opts.sections = opts.sections or {}
      opts.sections.lualine_a = {
        {
          function()
            return "\u{f30c}" -- ● 旧設定と同じ記号
          end,
          padding = { left = 1, right = 1 },
        },
      }
    end,
    config = function(_, opts)
      require("lualine").setup(opts)
      paint()
      -- カラースキーム変更で lualine がハイライトを作り直すので、その後に塗り直す
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("lualine_mode_symbol", { clear = true }),
        callback = function()
          vim.schedule(paint)
        end,
      })
    end,
  },
}
