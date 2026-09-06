-- LazyVim のデフォルトキーマップに対する追加・上書きだけをここに書く
-- 一覧: https://www.lazyvim.org/keymaps  /  `<leader>sk` (キーマップ検索) でも引ける
local map = vim.keymap.set

-- Insert モードから jj で抜ける (旧設定から引き継ぎ)
map("i", "jj", "<Esc>", { desc = "Escape" })

-- :W や :Q など、Shift の押しっぱなしミスを救済するコマンド別名
for _, cmd in ipairs({ "q", "w", "qa", "wq", "wqa" }) do
  vim.api.nvim_create_user_command(cmd:upper(), cmd, {})
  if #cmd > 2 then
    vim.api.nvim_create_user_command(cmd:sub(1, 1):upper() .. cmd:sub(2), cmd, {})
  end
end

-- 日本語入力のまま押しがちなキーの救済 (全角スペース -> leader 相当)
map("n", "　", "<Space>", { remap = true })
