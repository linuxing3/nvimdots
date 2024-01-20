return {
    { import = "lazyvim.plugins.extras.lang.python" },
    { import = "lazyvim.plugins.extras.lang.markdown" },
    { import = "lazyvim.plugins.extras.lang.clangd" },
    { import = "lazyvim.plugins.extras.lang.cmake" },
    { import = "lazyvim.plugins.extras.lang.rust" },
    { import = "lazyvim.plugins.extras.lang.go" },
    { import = "lazyvim.plugins.extras.lang.typescript" },
    { import = "lazyvim.plugins.extras.lang.java" },
    { import = "lazyvim.plugins.extras.lang.json" },
    { import = "lazyvim.plugins.extras.lang.tex" },
    { import = "lazyvim.plugins.extras.lang.yaml" },
    { import = "lazyvim.plugins.extras.lang.docker" },
    { import = "lazyvim.plugins.extras.lang.tailwind" },
    { import = "lazyvim.plugins.extras.linting.eslint" },
    { import = "lazyvim.plugins.extras.formatting.prettier" },
    { import = "lazyvim.plugins.extras.dap.core" },
    { import = "lazyvim.plugins.extras.dap.nlua" },
    { import = "lazyvim.plugins.extras.test.core" },
    -- Ai assistant
    -- { import = "lazyvim.plugins.extras.coding.copilot" },
    -- { "Exafunction/codeium.vim", event = "BufEnter" },
    { import = "lazyvim.plugins.extras.coding.yanky" },
    {
        "folke/neodev.nvim",
        opts = {
            library = {
                enabled = true, -- when not enabled, neodev will not change any settings to the LSP server
                -- these settings will be used for your Neovim config directory
                runtime = true, -- runtime path
                types = true, -- full signature, docs and completion of vim.api, vim.treesitter, vim.lsp and others
                plugins = true, -- installed opt or start plugins in packpath
                -- you can also specify the list of plugins to make available as a workspace library
                -- plugins = { "nvim-treesitter", "plenary.nvim", "telescope.nvim" },
            },
            setup_jsonls = true, -- configures jsonls to provide completion for project specific .luarc.json files
            -- for your Neovim config directory, the config.library settings will be used as is
            -- for plugin directories (root_dirs having a /lua directory), config.library.plugins will be disabled
            -- for any other directory, config.library.enabled will be set to false
            override = function(root_dir, options) end,
            -- With lspconfig, Neodev will automatically setup your lua-language-server
            -- If you disable this, then you have to set {before_init=require("neodev.lsp").before_init}
            -- in your lsp start options
            lspconfig = true,
            -- much faster, but needs a recent built of lua-language-server
            -- needs lua-language-server >= 3.6.0
            pathStrict = true,
        },
    },
    {
        "folke/neoconf.nvim",
        setup = function()
            require("neoconf").setup({
                -- name of the local settings files
                local_settings = ".neoconf.json",
                -- name of the global settings file in your Neovim config directory
                global_settings = "neoconf.json",
                -- import existing settings from other plugins
                import = {
                    vscode = true, -- local .vscode/settings.json
                    coc = true, -- global/local coc-settings.json
                    nlsp = true, -- global/local nlsp-settings.nvim json settings
                },
                -- send new configuration to lsp clients when changing json settings
                live_reload = true,
                -- set the filetype to jsonc for settings files, so you can use comments
                -- make sure you have the jsonc treesitter parser installed!
                filetype_jsonc = true,
                plugins = {
                    -- configures lsp clients with settings in the following order:
                    -- - lua settings passed in lspconfig setup
                    -- - global json settings
                    -- - local json settings
                    lspconfig = {
                        enabled = true,
                    },
                    -- configures jsonls to get completion in .nvim.settings.json files
                    jsonls = {
                        enabled = true,
                        -- only show completion in json settings for configured lsp servers
                        configured_servers_only = true,
                    },
                    -- configures lua_ls to get completion of lspconfig server settings
                    lua_ls = {
                        -- by default, lua_ls annotations are only enabled in your neovim config directory
                        enabled_for_neovim_config = true,
                        -- explicitely enable adding annotations. Mostly relevant to put in your local .nvim.settings.json file
                        enabled = true,
                    },
                },
            })
        end,
    },
    {
        "neovim/nvim-lspconfig",
        opts = {
            servers = {
                pyright = {},
                bashls = {},
                jdtls = {},
                rust_analyzer = {},
                -- Ensure mason installs the server
                clangd = {
                    keys = {
                        { "<leader>cR", "<cmd>ClangdSwitchSourceHeader<cr>", desc = "Switch Source/Header (C/C++)" },
                    },
                    root_dir = function(fname)
                        return require("lspconfig.util").root_pattern(
                            "Makefile",
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
                        "--compile-commands-dir=build",
                        "--background-index",
                        "--clang-tidy",
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
            },
            setup = {
                clangd = function(_, opts)
                    local clangd_ext_opts = require("lazyvim.util").opts("clangd_extensions.nvim")
                    require("clangd_extensions").setup(
                        vim.tbl_deep_extend("force", clangd_ext_opts or {}, { server = opts })
                    )
                    return false
                end,
            },
        },
    },
    {
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, {
                    "astro",
                    "bash",
                    "html",
                    "javascript",
                    "json",
                    "lua",
                    "markdown",
                    "markdown_inline",
                    "python",
                    "query",
                    "regex",
                    "tsx",
                    "typescript",
                    "vim",
                    "yaml",
                })
            end
        end,
    },
    {
        "mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(
                opts.ensure_installed,
                { "astro-language-server", "stylua", "shellcheck", "shfmt", "flake8" }
            )
        end,
    },
    {
        "Civitasv/cmake-tools.nvim",
        config = function()
            require("cmake-tools").setup({})
        end,
    },
    -- {
    --     "Mythos-404/xmake.nvim",
    --     disable = true,
    --     lazy = true,
    --     event = "BufReadPost xmake.lua",
    --     config = true,
    --     opts = {
    --         compile_command = { -- compile_command file generation configuration
    --             lsp = "clangd", -- generate compile_commands file for which lsp to read
    --             dir = "build", -- location of the generated file
    --         },
    --         work_dir = require("lspconfig.util").root_pattern("xmake.lua") or vim.fn.getcwd(),
    --     },
    --     dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    -- },
    {
        "mfussenegger/nvim-dap",
        keys = {},
        config = function()
            local dap = require("dap")
            dap.configurations.cpp = {
                {
                    name = "Launch file",
                    type = "codelldb",
                    request = "launch",
                    program = function()
                        return require("xmake.project_config").info.target.exec_path
                    end,
                    cwd = "${workspaceFolder}",
                    stopOnEntry = false,
                },
            }
        end,
    },
    {
        "Badhi/nvim-treesitter-cpp-tools",
        config = function()
            require("nt-cpp-tools").setup({})
        end,
    },
    {
        "mfussenegger/nvim-jdtls",
    },
    -- add symbols-outline
    {
        "simrat39/symbols-outline.nvim",
        cmd = "SymbolsOutline",
        keys = { { "<leader>cs", "<cmd>SymbolsOutline<cr>", desc = "Symbols Outline" } },
        config = true,
    },
    {
        "ziontee113/syntax-tree-surfer",
        config = function()
            -- Syntax Tree Surfer
            local opts = { noremap = true, silent = true }

            -- Normal Mode Swapping:
            -- Swap The Master Node relative to the cursor with it's siblings, Dot Repeatable
            vim.keymap.set("n", "vU", function()
                vim.opt.opFunc = "v:lua.STSSwapUpNormal_Dot"
                return "g@l"
            end, { silent = true, expr = true })
            vim.keymap.set("n", "vD", function()
                vim.opt.opfunc = "v:lua.STSSwapDownNormal_Dot"
                return "g@l"
            end, { silent = true, expr = true })

            -- Swap Current Node at the Cursor with it's siblings, Dot Repeatable
            vim.keymap.set("n", "vd", function()
                vim.opt.opfunc = "v:lua.STSSwapCurrentNodeNextNormal_Dot"
                return "g@l"
            end, { silent = true, expr = true })
            vim.keymap.set("n", "vu", function()
                vim.opt.opfunc = "v:lua.STSSwapCurrentNodePrevNormal_Dot"
                return "g@l"
            end, { silent = true, expr = true })

            --> If the mappings above don't work, use these instead (no dot repeatable)
            -- vim.keymap.set("n", "vd", '<cmd>STSSwapCurrentNodeNextNormal<cr>', opts)
            -- vim.keymap.set("n", "vu", '<cmd>STSSwapCurrentNodePrevNormal<cr>', opts)
            -- vim.keymap.set("n", "vD", '<cmd>STSSwapDownNormal<cr>', opts)
            -- vim.keymap.set("n", "vU", '<cmd>STSSwapUpNormal<cr>', opts)

            -- Visual Selection from Normal Mode
            vim.keymap.set("n", "vx", "<cmd>STSSelectMasterNode<cr>", opts)
            vim.keymap.set("n", "vn", "<cmd>STSSelectCurrentNode<cr>", opts)

            -- Select Nodes in Visual Mode
            vim.keymap.set("x", "J", "<cmd>STSSelectNextSiblingNode<cr>", opts)
            vim.keymap.set("x", "K", "<cmd>STSSelectPrevSiblingNode<cr>", opts)
            vim.keymap.set("x", "H", "<cmd>STSSelectParentNode<cr>", opts)
            vim.keymap.set("x", "L", "<cmd>STSSelectChildNode<cr>", opts)

            -- Swapping Nodes in Visual Mode
            vim.keymap.set("x", "<A-j>", "<cmd>STSSwapNextVisual<cr>", opts)
            vim.keymap.set("x", "<A-k>", "<cmd>STSSwapPrevVisual<cr>", opts)
        end,
    },
    { "onsails/lspkind.nvim" },
    { "skywind3000/asynctasks.vim" },
    { "skywind3000/asyncrun.vim" },
    { "NoahTheDuke/vim-just" },
    { "IndianBoy42/tree-sitter-just" },
}
