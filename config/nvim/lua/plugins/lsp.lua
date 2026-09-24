-- LSP サーバーは Mason で管理する
--
-- 使う言語のサーバーをここに明示しておくことで、新しいマシンでも
-- `nvim` を起動するだけで同じ構成が揃う（システムに入れたバイナリに依存しない）。
-- Mason の bin は PATH の先頭に差し込まれるため、`~/.cargo/bin` などより優先される。
return {
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        -- Go
        "gopls",
        -- Rust (rustaceanvim が PATH 上の rust-analyzer を使う)
        "rust-analyzer",
        -- Python
        "pyright",
        "ruff",
        -- TypeScript / JavaScript
        "vtsls",
        -- Lua
        "lua-language-server",
      },
    },
  },
}
