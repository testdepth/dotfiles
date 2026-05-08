return {
  {
    "Elmonade/pi-mono.nvim",
    dependencies = {
      {
        "folke/snacks.nvim",
        opts = function(_, opts)
          opts.input = opts.input or {}
          opts.picker = opts.picker or {}
          opts.terminal = opts.terminal or {}
        end,
      },
    },
    keys = {
      {
        "<leader>pa",
        function()
          require("pi-mono").ask("@this: ", { submit = true })
        end,
        mode = { "n", "x" },
        desc = "Pi Ask",
      },
      {
        "<leader>pp",
        function()
          require("pi-mono").select()
        end,
        mode = { "n", "x" },
        desc = "Pi Prompt Picker",
      },
      {
        "<leader>pt",
        function()
          require("pi-mono").toggle()
        end,
        mode = { "n", "t" },
        desc = "Pi Toggle",
      },
    },
    init = function()
      vim.g.pi_opts = {
        binary = "pi",
        provider = {
          enabled = "snacks",
          snacks = {
            win = {
              position = "right",
              enter = true,
            },
          },
        },
        prompts = {
          explain = { prompt = "Explain @this and its context", submit = true },
          review = { prompt = "Review @this for correctness and readability", submit = true },
          fix = { prompt = "Fix @diagnostics", submit = true },
          test = { prompt = "Add tests for @this", submit = true },
        },
      }
    end,
  },
}
