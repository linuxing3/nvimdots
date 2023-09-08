return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-emoji",
        },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            local cmp = require("cmp")
            opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" } }))

            local has_words_before = function()
                unpack = unpack or table.unpack
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                return col ~= 0
                    and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
            end
            -- local has_words_before = function()
            --   if vim.api.nvim_buf_get_option(0, "buftype") == "prompt" then return false end
            --   local line, col = unpack(vim.api.nvim_win_get_cursor(0))
            --   return col ~= 0 and vim.api.nvim_buf_get_text(0, line-1, 0, line-1, col, {})[1]:match("^%s*$") == nil
            -- end
            local luasnip = require("luasnip")

            opts.sources = vim.tbl_extend("force", opts.sources, {
                -- Copilot Source
                { name = "copilot", group_index = 2 },
                -- Other Sources
                { name = "nvim_lsp", group_index = 2 },
                { name = "path", group_index = 2 },
                { name = "luasnip", group_index = 2 },
            })

            opts.formatting = vim.tbl_extend("force", opts.formatting, {
                format = require("lspkind").cmp_format({
                    mode = "symbol",
                    max_width = 50,
                    symbol_map = { Copilot = "" },
                }),
            })

            opts.mapping = vim.tbl_extend("force", opts.mapping, {
                ["<Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() and has_words_before() then
                        cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                    elseif cmp.visible() then
                        -- NOTE: You could replace select_next_item() with confirm({ select = true }) to get VS Code autocompletion behavior
                        -- cmp.select_next_item()
                        cmp.confirm({ select = true })
                    elseif luasnip.expand_or_locally_jumpable() then
                        -- NOTE: You could replace the expand_or_jumpable() calls with expand_or_locally_jumpable()
                        -- this way you will only jump inside the snippet region
                        luasnip.expand_or_locally_jump()
                    else
                        fallback()
                    end
                end, { "i", "s" }),
                ["<S-Tab>"] = cmp.mapping(function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    elseif luasnip.jumpable(-1) then
                        luasnip.jump(-1)
                    else
                        fallback()
                    end
                end, { "i", "s" }),
            })

            vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
        end,
    },
    {
        "L3MON4D3/LuaSnip",
        setup = function()
            local snippet_path = os.getenv("HOME") .. "/.config/nvim/my-snippets"
            if not vim.tbl_contains(vim.opt.rtp:get(), snippet_path) then
                vim.opt.rtp:append(snippet_path)
            end

            require("luasnip").config.set_config({
                history = true,
                updateevents = "TextChanged,TextChangedI",
                delete_check_events = "TextChanged,InsertLeave",
            })
            require("luasnip.loaders.from_lua").lazy_load()
            require("luasnip.loaders.from_vscode").lazy_load()
            require("luasnip.loaders.from_snipmate").lazy_load()
        end,
    },
    -- { "github/copilot.vim", event = "BufEnter" },
    {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({})
        end,
    },
    {
        "zbirenbaum/copilot-cmp",
        event = "InsertEnter",
        config = function()
            require("copilot_cmp").setup()
        end,
    },
    -- { "Exafunction/codeium.vim", event = "BufEnter" },
}
