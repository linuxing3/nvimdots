local Util = require("lazyvim.util")

return {
    {
        "nvim-telescope/telescope.nvim",
        keys = {
            { "<leader>,", "<cmd>Telescope buffers show_all_buffers=true<cr>", desc = "Switch Buffer" },
            { "<leader>/", Util.telescope("live_grep"), desc = "Grep (root dir)" },
            { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
            { "<leader>\\", Util.telescope("files"), desc = "Find Files (root dir)" },
            -- find
            { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
            { "<leader>ff", Util.telescope("files"), desc = "Find Files (root dir)" },
            { "<leader>f.", Util.telescope("files", { cwd = false }), desc = "Find Files (cwd)" },
            { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
            { "<leader>fR", Util.telescope("oldfiles", { cwd = vim.loop.cwd() }), desc = "Recent (cwd)" },
            -- git
            { "<leader>gc", "<cmd>Telescope git_commits<CR>", desc = "commits" },
            { "<leader>gs", "<cmd>Telescope git_status<CR>", desc = "status" },
            -- search
            { '<leader>s"', "<cmd>Telescope registers<cr>", desc = "Registers" },
            { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
            { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
            { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
            { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
            { "<leader>sd", "<cmd>Telescope diagnostics bufnr=0<cr>", desc = "Document diagnostics" },
            { "<leader>sD", "<cmd>Telescope diagnostics<cr>", desc = "Workspace diagnostics" },
            { "<leader>sg", Util.telescope("live_grep"), desc = "Grep (root dir)" },
            { "<leader>s.", Util.telescope("live_grep", { cwd = false }), desc = "Grep (cwd)" },
            { "<leader>sh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
            { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
            { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
            { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
            { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
            { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
            { "<leader>sR", "<cmd>Telescope resume<cr>", desc = "Resume" },
            { "<leader>sw", Util.telescope("grep_string", { word_match = "-w" }), desc = "Word (root dir)" },
            { "<leader>sW", Util.telescope("grep_string", { cwd = false, word_match = "-w" }), desc = "Word (cwd)" },
            { "<leader>sw", Util.telescope("grep_string"), mode = "v", desc = "Selection (root dir)" },
            { "<leader>sW", Util.telescope("grep_string", { cwd = false }), mode = "v", desc = "Selection (cwd)" },
            {
                "<leader>uC",
                Util.telescope("colorscheme", { enable_preview = true }),
                desc = "Colorscheme with preview",
            },
            {
                "<leader>ss",
                Util.telescope("lsp_document_symbols", {
                    symbols = {
                        "Class",
                        "Function",
                        "Method",
                        "Constructor",
                        "Interface",
                        "Module",
                        "Struct",
                        "Trait",
                        "Field",
                        "Property",
                    },
                }),
                desc = "Goto Symbol",
            },
            {
                "<leader>sS",
                Util.telescope("lsp_dynamic_workspace_symbols", {
                    symbols = {
                        "Class",
                        "Function",
                        "Method",
                        "Constructor",
                        "Interface",
                        "Module",
                        "Struct",
                        "Trait",
                        "Field",
                        "Property",
                    },
                }),
                desc = "Goto Symbol (Workspace)",
            },
        },
    },
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
        config = function()
            require("telescope").load_extension("file_browser")
        end,
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
    {
        "nvim-neo-tree/neo-tree.nvim",
        keys = {
            {
                "<leader>fe",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = require("lazyvim.util").get_root() })
                end,
                desc = "Explorer NeoTree (root dir)",
            },
            {
                "<leader>fE",
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
                end,
                desc = "Explorer NeoTree (cwd)",
            },
            { "<leader>e", "<leader>fe", desc = "Explorer NeoTree (root dir)", remap = true },
            { "<leader>E", "<leader>fE", desc = "Explorer NeoTree (cwd)", remap = true },
        },
        opts = {
            filesystem = {
                bind_to_cwd = true,
            },
        },
    },
}
