-- lazy.nvim (プラグインマネージャ) の bootstrap
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local lazyrepo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPress any key to exit..." },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    -- LazyVim 本体 + 標準プラグイン群
    -- 追加の extras は lazyvim.json 経由 (`:LazyExtras` で ON/OFF)
    { "LazyVim/LazyVim", import = "lazyvim.plugins" },
    -- 自分の設定・上書き
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false, -- 常に最新 commit を使う (LazyVim 推奨)
  },
  install = { colorscheme = { "kanagawa-dragon", "tokyonight", "habamax" } },
  -- luarocks 依存のプラグインは使っていないので無効化 (:checkhealth の警告も消える)
  rocks = { enabled = false },
  checker = {
    enabled = true, -- プラグイン更新を定期チェック
    notify = false, -- 通知はしない (:Lazy で確認)
  },
  performance = {
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
