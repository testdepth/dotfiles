local M = {

  "williamboman/mason.nvim",
  cmd = "Mason",
  build = ":MasonUpdate",
  opts = {
    ensure_installed = {
      "bash-language-server",
      "dockerfile-language-server",
      "gopls",
      "json-lsp",
      "lua-language-server",
      "stylua",
      "flake8",
      "markdownlint",
      "netcoredbg",
      "omnisharp",
      "pyright",
      "shellcheck",
      "shfmt",
      "terraform-ls",
      "vim-language-server",
      "yaml-language-server",
    },
  },
}

return M
