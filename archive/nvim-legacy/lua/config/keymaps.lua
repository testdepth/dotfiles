-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
vim.keymap.set("n", "<leader>\\f", "<cmd>ToggleTerm direction=float<cr>", { desc = "ToggleTerm Float" })
vim.keymap.set(
  "n",
  "<leader>\\h",
  "<cmd>ToggleTerm size=30 direction=horizontal<cr>",
  { desc = "ToggleTerm Horizontal" }
)
vim.keymap.set("n", "<leader>\\v", "<cmd>ToggleTerm size=80 direction=vertical<cr>", { desc = "ToggleTerm Vertical" })
vim.keymap.set("n", "<F7>", "<cmd>ToggleTerm<cr>", { desc = "Toggle terminal" })
local opts = { noremap = true, silent = true }
vim.api.nvim_set_keymap("n", "<Leader>nf", ":lua require('neogen').generate()<CR>", opts)
vim.api.nvim_set_keymap("n", "<Leader>nc", ":lua require('neogen').generate({ type = 'class' })<CR>", opts)
