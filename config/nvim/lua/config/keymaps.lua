-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Window navigation (matches Ghostty pane navigation)
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Go to left window" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Go to lower window" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Go to upper window" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Go to right window" })

-- Capture current buffer context for Claude nvim-coach MCP
vim.keymap.set("n", "<leader>nc", function()
  local buf = vim.api.nvim_get_current_buf()
  local file = vim.api.nvim_buf_get_name(buf)
  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1] -- 1-indexed
  local col = cursor[2] -- 0-indexed

  local total_lines = vim.api.nvim_buf_line_count(buf)
  local start_line = math.max(0, row - 31) -- 0-indexed for get_lines
  local end_line = math.min(total_lines, row + 30)
  local lines = vim.api.nvim_buf_get_lines(buf, start_line, end_line, false)

  local context = {
    file = file,
    filetype = vim.bo.filetype,
    cursor_line = row,
    cursor_col = col + 1,
    context_start_line = start_line + 1, -- 1-indexed for display
    lines = lines,
  }

  local ok, json = pcall(vim.fn.json_encode, context)
  if not ok then
    vim.notify("[nvim-coach] Failed to encode context", vim.log.levels.ERROR)
    return
  end

  local f = io.open("/tmp/nvim-context.json", "w")
  if f then
    f:write(json)
    f:close()
    vim.notify(string.format("[nvim-coach] Context saved (%s:%d)", vim.fn.fnamemodify(file, ":t"), row), vim.log.levels.INFO)
  else
    vim.notify("[nvim-coach] Failed to write /tmp/nvim-context.json", vim.log.levels.ERROR)
  end
end, { desc = "Save buffer context for Claude nvim-coach" })

-- Window resizing (Alt + hjkl)
vim.keymap.set("n", "<A-h>", "5<C-w><", { desc = "Decrease width" })
vim.keymap.set("n", "<A-l>", "5<C-w>>", { desc = "Increase width" })
vim.keymap.set("n", "<A-j>", "5<C-w>-", { desc = "Decrease height" })
vim.keymap.set("n", "<A-k>", "5<C-w>+", { desc = "Increase height" })

vim.keymap.set("n", "<leader>ct", function()
  require("config.alternate_test").open_vsplit()
end, { desc = "Alternate test/source (vsplit)" })
