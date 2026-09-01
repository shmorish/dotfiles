-- ファイラ (snacks explorer / `<leader>e`)
return {
  {
    "folke/snacks.nvim",
    keys = {
      -- cwd 基準のファイラは使わないので無効化（ルート基準の `<leader>e` だけ残す）
      { "<leader>E", false },
    },
    opts = {
      picker = {
        sources = {
          explorer = {
            -- ドットファイルも .gitignore 済みのファイルも全部表示する
            -- 開いた状態で `H` (hidden) / `I` (ignored) でトグルもできる
            hidden = true,
            ignored = true,

            -- 開いたときのディレクトリを記憶しておく（`<BS>` の上限に使う）
            on_show = function(picker)
              picker.opts.explorer_root = picker.opts.explorer_root or vim.fs.normalize(picker:cwd())
            end,

            actions = {
              -- `<BS>` で親ディレクトリへ戻る動作を、開いたときのルートまでに制限する
              explorer_up = function(picker)
                local root = picker.opts.explorer_root
                local cwd = vim.fs.normalize(picker:cwd())
                if not root or cwd == root or not vim.startswith(cwd .. "/", root .. "/") then
                  return
                end
                picker:set_cwd(vim.fs.dirname(cwd))
                picker:find()
              end,
            },
          },
        },
      },
    },
  },
}
