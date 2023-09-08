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
    { "onsails/lspkind.nvim" },
    { "skywind3000/asynctasks.vim" },
    { "skywind3000/asyncrun.vim" },
}
