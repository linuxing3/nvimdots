--- @diagnostic disable:undefined-field
--- @diagnostic disable:missing-fields

---@type lspconfig.options.clangd
local clangd_config = {
    settings = {
        clangd = {
            checkUpdates = true,
            restartAfterCrash = true,
            onConfigChanged = "restart",
        },
    },
}

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
    -- add pyright, clangd, rust_analyzer, jsonls to lspconfig
    {
        "neovim/nvim-lspconfig",
        ---@class PluginLspOpts
        opts = {
            -- options for vim.diagnostic.config()
            diagnostics = {
                underline = true,
                update_in_insert = false,
                virtual_text = {
                    spacing = 4,
                    source = "if_many",
                    prefix = "●",
                    -- this will set set the prefix to a function that returns the diagnostics icon based on the severity
                    -- this only works on a recent 0.10.0 build. Will be set to "●" when not supported
                    -- prefix = "icons",
                },
                severity_sort = true,
            },
            -- Enable this to enable the builtin LSP inlay hints on Neovim >= 0.10.0
            -- Be aware that you also will need to properly configure your LSP server to
            -- provide the inlay hints.
            inlay_hints = {
                enabled = false,
            },
            -- add any global capabilities here
            capabilities = {},
            -- options for vim.lsp.buf.format
            -- `bufnr` and `filter` is handled by the LazyVim formatter,
            -- but can be also overridden when specified
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },
            ---@type lspconfig.options
            servers = {
                clangd = {},
                rust_analyzer = {},
                bashls = {},
                gopls = {},
                pyright = {},
                astro = {},
                tailwindcss = {},
                svelte = {},
                wgsl_analyzer = {},
                zls = {},
            },
            setup = {
                eslint = function()
                    require("lazyvim.util").lsp.on_attach(function(client)
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
        "nvim-treesitter/nvim-treesitter",
        opts = function(_, opts)
            if type(opts.ensure_installed) == "table" then
                vim.list_extend(opts.ensure_installed, { "astro" })
            end
        end,
    },
    {
        "mason.nvim",
        opts = function(_, opts)
            opts.ensure_installed = opts.ensure_installed or {}
            vim.list_extend(opts.ensure_installed, { "astro-language-server" })
        end,
    },
    {
        "Civitasv/cmake-tools.nvim",
        config = function()
            require("cmake-tools").setup({})
        end,
    },
    {
        "Mythos-404/xmake.nvim",
        lazy = true,
        event = "BufReadPost xmake.lua",
        config = true,
        opts = {
            compile_command = { -- compile_command file generation configuration
                lsp = "clangd", -- generate compile_commands file for which lsp to read
                dir = ".", -- location of the generated file
            },
        },
        dependencies = { "MunifTanjim/nui.nvim", "nvim-lua/plenary.nvim" },
    },
    {
        "mfussenegger/nvim-dap",
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
