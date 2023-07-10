return {
    {
        "telescope.nvim",
        dependencies = {
            {
                "nvim-telescope/telescope-fzf-native.nvim",
                build = "make",
                config = function()
                    require("telescope").load_extension("fzf")
                end,
            },
            {
                "nvim-telescope/telescope-arecibo.nvim",
                rocks = { "openssl", "lua-http-parser" },
                config = function()
                    require("telescope").load_extension("arecibo")
                end,
            },
            {
                "yorik1984/telescope-cheat.nvim",
                config = function()
                    require("telescope").load_extension("cheat")
                end,
            },
            {
                "nvim-telescope/telescope-github.nvim",
                config = function()
                    require("telescope").load_extension("gh")
                end,
            },
            {
                "nvim-telescope/telescope-file-browser.nvim",
                dependencies = { "nvim-telescope/telescope.nvim", "nvim-lua/plenary.nvim" },
            },
            {
                "nvim-telescope/telescope-frecency.nvim",
                config = function()
                    require("telescope").setup({
                        extensions = {
                            frecency = {
                                -- db_root = "home/vagrant/path/to/db_root",
                                show_scores = false,
                                show_unindexed = true,
                                ignore_patterns = { "*.git/*", "*/tmp/*" },
                                disable_devicons = false,
                                workspaces = {
                                    ["conf"] = "/home/vagrant/.config",
                                    ["data"] = "/home/vagrant/.local/share",
                                    ["project"] = "/home/vagrant/projects",
                                    ["wiki"] = "/home/vagrant/org",
                                },
                            },
                        },
                    })
                    require("telescope").load_extension("frecency")
                end,
                dependencies = { "kkharji/sqlite.lua" },
            },
            {
                "nvim-telescope/telescope-project.nvim",
                config = function()
                    require("telescope").load_extension("project")
                end,
            },
        },
    },
}
