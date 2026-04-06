return {
  { "saghen/blink.cmp", enabled = false, optional = true },
  { "folke/noice.nvim", enabled = false },
  {
    "folke/snacks.nvim",
    keys = {
      { "<leader>n", false },
      {
        "<leader>xN",
        function()
          local Snacks = require("snacks")
          if Snacks.config.picker and Snacks.config.picker.enabled then
            Snacks.picker.notifications()
          else
            Snacks.notifier.show_history()
          end
        end,
        desc = "Notification History",
      },
    },
  },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "marilari88/neotest-vitest",
      "nvim-neotest/neotest-jest",
    },
    opts = function(_, opts)
      opts.adapters = vim.tbl_deep_extend("force", opts.adapters or {}, {
        ["neotest-vitest"] = {},
        ["neotest-jest"] = { jestCommand = "npm test --" },
      })
    end,
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        graphql = {
          filetypes = { "graphql", "typescriptreact", "javascriptreact", "typescript", "javascript" },
        },
      },
    },
  },
  {
    "nvim-treesitter/nvim-treesitter",
    opts = function(_, opts)
      vim.list_extend(opts.ensure_installed or {}, { "graphql" })
      local hl = opts.highlight or {}
      local prev_disable = hl.disable
      hl.disable = function(lang, buf)
        if type(lang) == "string" and lang:find("^snacks_", 1, true) then
          return true
        end
        local ft = vim.bo[buf].filetype
        if ft ~= "" and ft:find("^snacks_", 1, true) then
          return true
        end
        if type(prev_disable) == "function" then
          return prev_disable(lang, buf)
        end
        if type(prev_disable) == "table" and lang then
          return vim.tbl_contains(prev_disable, lang)
        end
        return false
      end
      opts.highlight = hl
    end,
  },
}
