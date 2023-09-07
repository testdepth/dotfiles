local M = {
    "akinsho/toggleterm.nvim",
    cmd = "ToggleTerm",
    event="VeryLazy",
    keys = { { "<leader>\\f", "<cmd>ToggleTerm direction=float<cr>", desc = "ToggleTerm Float" },
            { "<leader>\\h", "<cmd>ToggleTerm size=20 direction=horizontal<cr>", desc = "ToggleTerm Horizontal" },
            { "<leader>\\v", "<cmd>ToggleTerm size=80 direction=vertical<cr>", desc = "ToggleTerm Vertical" },
            { "<cmd>ToggleTerm<cr>", desc = "Toggle terminal" }
        }
    }
    function M.config()
    require("toggleterm").setup()

    end


    return M
