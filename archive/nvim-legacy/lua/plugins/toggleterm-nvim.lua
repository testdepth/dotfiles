local M = {
  "akinsho/toggleterm.nvim",
  cmd = "ToggleTerm",
  event = "VeryLazy",
  keys = {
    { "<leader>\\f", "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm Float" },
    { "<leader>\\h", "<cmd>ToggleTerm size=20 direction=horizontal<cr>", desc = "ToggleTerm Horizontal" },
    { "<leader>\\v", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm Vertical" },
    { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" },
  },
}
function M.config()
  require("toggleterm").setup({
    size = function(term)
      if term.direction == "horizontal" then
        return 10
      elseif term.direction == "vertical" then
        return vim.o.columns * 0.4
      end
    end,
    direction = "horizontal",
    winbar = { enabled = true },
    shading_factor = "15",
  })
end

return M
