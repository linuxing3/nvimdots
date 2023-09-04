return {
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.dap.nlua" },
    { import = "lazyvim.plugins.extras.test.core" },
    -- add pyright, clangd, rust_analyzer, jsonls to lspconfig
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            ---@type lspconfig.options
            servers = {
                pyright = {},
                clangd = {
                    keys = {
                        { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
                    },
                    root_dir = function(fname)
                        return require("lspconfig.util").root_pattern(
                            "Makefile",
                            "xmake.lua",
                            "premake5.lua",
                            "pixi",
                            "build.justifile",
                            "CMakeLists.txt",
                            "configure.ac",
                            "configure.in",
                            "config.h.in",
                            "meson.build",
                            "meson_options.txt",
                            "build.ninja"
                        )(fname) or require("lspconfig.util").root_pattern(
                            "compile_commands.json",
                            "compile_flags.txt"
                        )(fname) or require("lspconfig.util").find_git_ancestor(fname)
                    end,
                    capabilities = {
                        offsetEncoding = { "utf-16" },
                    },
                    cmd = {
                        "clangd",
                        "--background-index",
                        -- "--clang-tidy",
                        "--header-insertion=iwyu",
                        "--completion-style=detailed",
                        "--function-arg-placeholders",
                        "--fallback-style=llvm",
                    },
                    init_options = {
                        usePlaceholders = true,
                        completeUnimported = true,
                        clangdFileStatus = true,
                    },
                },
                rust_analyzer = {},
                bashls = {},
                gopls = {},
                wgsl_analyzer = {},
                zls = {},
            },
            setup = {
                bashls = function()
                    require("lspconfig").bashls.setup({})
                end,
                wgsl_analyzer = function()
                    require("lspconfig").wgsl_analyzer.setup({})
                end,
                zls = function()
                    require("lspconfig").zls.setup({})
                end,
                clangd = function(_, opts)
                    opts.capabilities.offsetEncoding = { "utf-16" }
                end,
                eslint = function()
                    require("lazyvim.util").on_attach(function(client)
                        if client.name == "eslint" then
                            client.server_capabilities.documentFormattingProvider = true
                        elseif client.name == "tsserver" then
                            client.server_capabilities.documentFormattingProvider = false
                        end
                    end)
                end,
            },
        },
    },
    {
        "mfussenegger/nvim-jdtls",
    },
    {
        "Civitasv/cmake-tools.nvim",
        setup = function()
            require("cmake-tools").setup({})
        end,
    },
    -- add symbols-outline
    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
        config = true,
    },
    {
        "nvim-neorg/neorg",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-neorg/neorg-telescope",
            "max397574/neorg-zettelkasten",
            "tamton-aquib/neorg-jupyter",
            "jarvismkennedy/neorgroam.nvim",
        },
        build = ":Neorg sync-parsers",
        keys = {
            { "<leader>own", "<cmd>Neorg workspace notes<cr>", desc = "Neorg workspace notes" },
            { "<leader>owh", "<cmd>Neorg workspace home<cr>", desc = "Neorg workspace home" },
            { "<leader>ojt", "<cmd>Neorg journal today<cr>", desc = "Neorg journey today" },
            { "<leader>ojy", "<cmd>Neorg journal yesterday<cr>", desc = "Neorg journal yesterday" },
            { "<leader>ojm", "<cmd>Neorg journal tomorrow<cr>", desc = "Neorg journal tomorrow" },
        },
        config = function()
            local neorg_callbacks = require("neorg.core.callbacks")
            neorg_callbacks.on_event("core.keybinds.events.enable_keybinds", function(_, keybinds)
                keybinds.map_event_to_mode("norg", {
                    n = { -- Bind keys in normal mode
                        { "<C-l>", "core.integrations.telescope.find_linkable" },
                    },
                    i = { -- Bind in insert mode
                        { "<C-l>", "core.integrations.telescope.insert_link" },
                    },
                }, {
                    silent = true,
                    noremap = true,
                })
            end)
            require("neorg").setup({
                load = {
                    ["core.defaults"] = {},
                    ["core.concealer"] = {},
                    ["core.dirman"] = {
                        config = {
                            workspaces = {
                                notes = "~/OneDrive/org/journal",
                                home = "~/OneDrive/org/home",
                                roam = "~/OneDrive/org/roam",
                            },
                            default_workspace = "roam",
                        },
                    },
                    ["core.keybinds"] = {
                        config = {
                            hook = function(keybinds)
                                keybinds.remap_event("norg", "n", "<S-Space>", "core.qol.todo_items.todo.task_cycle")
                                keybinds.remap_key("norg", "n", "<S-Space>", "<Leader>t")
                            end,
                        },
                    },
                    ["core.integrations.telescope"] = {},
                    ["core.esupports.hop"] = {},
                    ["core.esupports.indent"] = {},
                    ["core.esupports.metagen"] = {},
                    ["core.tangle"] = {},
                    ["core.promo"] = {},
                    ["core.qol.toc"] = {},
                    ["core.qol.todo_items"] = {},
                    ["core.looking-glass"] = {},
                    ["core.summary"] = {},
                    ["core.export"] = {},
                    ["core.export.markdown"] = {},
                    ["core.autocommands"] = {},
                    ["core.fs"] = {},
                    ["core.integrations.nvim-cmp"] = {},
                    ["core.integrations.treesitter"] = {},
                    ["external.zettelkasten"] = {},
                    ["external.jupyter"] = {},
                    ["core.integrations.roam"] = {
                        -- default keymaps
                        keymaps = {
                            -- select_prompt is used to to create new note / capture from the prompt directly
                            -- instead of the telescope choice.
                            select_prompt = "<C-n>",
                            insert_link = "<leader>ni",
                            find_note = "<leader>nf",
                            capture_note = "<leader>nc",
                            capture_index = "<leader>nci",
                            capture_cancel = "<C-q>",
                            capture_save = "<C-w>",
                        },
                    },
                },
            })
        end,
    },
}
