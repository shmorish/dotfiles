-- LazyVim のデフォルト options に対する差分だけをここに書く
-- デフォルト値: https://www.lazyvim.org/configuration/general
-- (この Lua は VeryLazy より前に自動で読み込まれる)

-- 使っていない言語プロバイダを無効化 (:checkhealth の警告を減らす)
vim.g.loaded_perl_provider = 0
vim.g.loaded_ruby_provider = 0

local opt = vim.opt

-- 相対行番号は LazyVim デフォルトで ON。`<leader>uL` でトグルできる
opt.relativenumber = true

-- 長い行を折り返さない (折り返したいときは `<leader>uw` でトグル)
opt.wrap = false

-- 常にサインカラムを出して、行がガタつかないようにする
opt.signcolumn = "yes"

-- 日本語などの全角記号を含む行でカーソルがずれないようにする
opt.ambiwidth = "single"

-- 検索まわり (LazyVim デフォルトと同じだが、明示しておく)
opt.ignorecase = true
opt.smartcase = true

-- undo をファイルに永続化 (保存先は ~/.local/state/nvim/undo)
opt.undofile = true
opt.undolevels = 10000

-- スクロール時に上下に残す行数
opt.scrolloff = 4

-- インデント幅。LazyVim は 2、言語ごとの設定が優先される
opt.shiftwidth = 2
opt.tabstop = 2
opt.expandtab = true
