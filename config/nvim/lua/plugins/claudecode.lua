-- claudecode.nvim: Claude Code CLI と Neovim を繋ぐ IDE 連携
-- キーマップは LazyVim の ai.claudecode extra 側で定義済み（`<leader>a` プレフィックス）
return {
  {
    "coder/claudecode.nvim",
    dependencies = { "folke/snacks.nvim" },
    keys = {
      -- ファイラ (snacks explorer) 上でも `<leader>as` でファイルを Claude に渡せるようにする
      -- extra 側の ft 一覧は NvimTree / neo-tree / oil のみで snacks が入っていないため補う
      {
        "<leader>as",
        "<cmd>ClaudeCodeTreeAdd<cr>",
        desc = "Add file",
        ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw", "snacks_picker_list" },
      },
    },
  },
}
