local function allow_snacks_indent_scope(buf)
  local ft = vim.bo[buf].filetype
  if ft ~= "" and ft:find("^snacks_", 1, true) then
    return false
  end
  return true
end

return {
  {
    "folke/snacks.nvim",
    opts = {
      indent = {
        filter = function(buf, win)
          if not allow_snacks_indent_scope(buf) then
            return false
          end
          return vim.g.snacks_indent ~= false
            and vim.b[buf].snacks_indent ~= false
            and vim.bo[buf].buftype == ""
        end,
      },
      picker = {
        sources = {
          explorer = {
            exclude = { "CLAUDE.md" },
          },
        },
      },
      scope = {
        filter = function(buf)
          if not allow_snacks_indent_scope(buf) then
            return false
          end
          return vim.bo[buf].buftype == ""
            and vim.b[buf].snacks_scope ~= false
            and vim.g.snacks_scope ~= false
        end,
      },
    },
  },
}
