-- since this is just an example spec, don't actually load anything here and return an empty spec
-- stylua: ignore

-- every spec file under config.plugins will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
return {
  -- add gruvbox
  { "ellisonleao/gruvbox.nvim" },
  {
    "danymat/neogen",
    dependencies = "nvim-treesitter/nvim-treesitter",
    config = true,
    init = function()
      require('neogen').setup {
        enabled = true,
        languages = {
            python = {
                template = {
                    annotation_convention = "numpydoc" -- for a full list of annotation_conventions, see supported-languages below,
                    }
            },
        }
      }
    end,
  },

  -- add conda nvim
  --{ "cjrh/vim-conda", build = 'CondaChangeEnv' },
  --{ "kkoomen/vim-doge", run = ':call doge#install()',
      --init = function()
        --require("lazyvim.util").on_attach(function(_, buffer)
          -- stylua: ignore
          --vim.keymap.set( "n", "<leader>cd", "DogeGenerateNumpy", { buffer = buffer, desc = "Generate Numpy Docstring" } )
        --end)
      --end,
  --},

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "catppuccin",
    },
  },

  -- change trouble config
  {
    "folke/trouble.nvim",
    -- opts will be merged with the parent spec
    opts = { use_diagnostic_signs = true },
  },

  -- disable trouble
  { "folke/trouble.nvim", enabled = false },

  -- add symbols-outline
  {
    "simrat39/symbols-outline.nvim",
    cmd = "SymbolsOutline",
    keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
    config = true,
  },

  -- override nvim-cmp and add cmp-emoji
  {
    "hrsh7th/nvim-cmp",
    dependencies = { "hrsh7th/cmp-emoji" },
    ---@param opts cmp.ConfigSchema
    opts = function(_, opts)
      local cmp = require("cmp")
      opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" } }))
    end,
  },

  -- change some telescope options and a keymap to browse plugin files
  {
    "nvim-telescope/telescope.nvim",
    keys = {
      -- add a keymap to browse plugin files
      -- stylua: ignore
      {
        "<leader>fp",
        function() require("telescope.builtin").find_files({ cwd = require("lazy.core.config").options.root }) end,
        desc = "Find Plugin File",
      },
    },
    -- change some options
    opts = {
      defaults = {
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
        sorting_strategy = "ascending",
        winblend = 0,
      },
      extensions = {
        conda = {anaconda_path = "/opt/miniconda3/"}
      },
    },
  },

  --telescope conda setup
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { { "IllustratedMan-code/telescope-conda.nvim", build = "make" } },
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("conda")
    end,
    keys = {
      {
        "<leader>fc",
        function() require("telescope").extensions.conda.conda{}  end,
        desc = "Find Conda Env",
      }
    }
  },

  -- add telescope-fzf-native
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { { "nvim-telescope/telescope-fzf-native.nvim", build = "make" } },
    -- apply the config and additionally load fzf-native
    config = function(_, opts)
      local telescope = require("telescope")
      telescope.setup(opts)
      telescope.load_extension("fzf")
    end,
  },


  -- the opts function can also be used to change the default opts:
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function(_, opts)
      table.insert(opts.sections.lualine_x, "😄")
    end,
  },

  -- or you can return new options to override all the defaults
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = function()
      return {
        --[[add your custom lualine config here]]
      }
    end,
  },

  -- use mini.starter instead of alpha
  { import = "lazyvim.plugins.extras.ui.mini-starter" },


}
--   {
--     "folke/edgy.nvim",
--     event = "VeryLazy",
--     keys = {
--       -- stylua: ignore
--       { "<leader>ue", function() require("edgy").select() end, desc = "Edgy Select Window" },
--     },
--     opts = {
--       bottom = {
--         {
--           ft = "toggleterm",
--           size = { height = 0.4 },
--           filter = function(buf, win)
--             return vim.api.nvim_win_get_config(win).relative == ""
--           end,
--         },
--         {
--           ft = "noice",
--           -- size = { height = 0.4 },
--           filter = function(buf, win)
--             return vim.api.nvim_win_get_config(win).relative == ""
--           end,
--         },
--         {
--           ft = "lazyterm",
--           title = "LazyTerm",
--           size = { height = 0.4 },
--           filter = function(buf)
--             return not vim.b[buf].lazyterm_cmd
--           end,
--         },
--         "Trouble",
--         { ft = "qf", title = "QuickFix" },
--         {
--           ft = "help",
--           size = { height = 20 },
--           -- don't open help files in edgy that we're editing
--           filter = function(buf)
--             return vim.bo[buf].buftype == "help"
--           end,
--         },
--         { ft = "spectre_panel", size = { height = 0.4 } },
--       },
--       left = {
--         {
--           title = "Neo-Tree",
--           ft = "neo-tree",
--           filter = function(buf)
--             return vim.b[buf].neo_tree_source == "filesystem"
--           end,
--           size = { height = 0.5 },
--         },
--         {
--           title = "Neo-Tree Git",
--           ft = "neo-tree",
--           filter = function(buf)
--             return vim.b[buf].neo_tree_source == "git_status"
--           end,
--           pinned = true,
--           open = "Neotree position=right git_status",
--         },
--         {
--           title = "Neo-Tree Buffers",
--           ft = "neo-tree",
--           filter = function(buf)
--             return vim.b[buf].neo_tree_source == "buffers"
--           end,
--           pinned = true,
--           open = "Neotree position=top buffers",
--         },
--         {
--           ft = "Outline",
--           pinned = true,
--           open = "SymbolsOutline",
--         },
--         "neo-tree",
--       },
--     },
--   },

--   -- prevent neo-tree from opening files in edgy windows
--   {
--     "nvim-neo-tree/neo-tree.nvim",
--     optional = true,
--     opts = function(_, opts)
--       opts.open_files_do_not_replace_types = opts.open_files_do_not_replace_types
--         or { "terminal", "Trouble", "qf", "Outline" }
--       table.insert(opts.open_files_do_not_replace_types, "edgy")
--     end,
--   },

--   -- Fix bufferline offsets when edgy is loaded
--   {
--     "akinsho/bufferline.nvim",
--     optional = true,
--     opts = function()
--       local Offset = require("bufferline.offset")
--       if not Offset.edgy then
--         local get = Offset.get
--         Offset.get = function()
--           if package.loaded.edgy then
--             local layout = require("edgy.config").layout
--             local ret = { left = "", left_size = 0, right = "", right_size = 0 }
--             for _, pos in ipairs({ "left", "right" }) do
--               local sb = layout[pos]
--               if sb and #sb.wins > 0 then
--                 local title = " Sidebar" .. string.rep(" ", sb.bounds.width - 8)
--                 ret[pos] = "%#EdgyTitle#" .. title .. "%*" .. "%#WinSeparator#│%*"
--                 ret[pos .. "_size"] = sb.bounds.width
--               end
--             end
--             ret.total_size = ret.left_size + ret.right_size
--             if ret.total_size > 0 then
--               return ret
--             end
--           end
--           return get()
--         end
--         Offset.edgy = true
--       end
--     end,
--   },
-- }
