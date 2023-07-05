return {
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            -- change a keymap
            { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            -- add a keymap to browse plugin files
            {
                "<leader>fs",
                function()
                    require("telescope.builtin").colorscheme()
                end,
                desc = "Find Plugin File",
            },
        },
    },
}
