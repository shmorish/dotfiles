-- LazyVim のデフォルト autocmds に対する追加だけをここに書く
-- デフォルト: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- 外部でファイルが書き換わったら読み直す
vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
  group = vim.api.nvim_create_augroup("checktime_extra", { clear = true }),
  command = "checktime",
})
