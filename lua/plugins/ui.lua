return {
    {
        "nvim-lualine/lualine.nvim",
        optional = true,
        event = "VeryLazy",
        config = function()
            local xmake_component = {
                function()
                    local xmake = require("xmake.project_config").info
                    if xmake.target.tg == "" then
                        return ""
                    end
                    return xmake.target.tg .. "(" .. xmake.mode .. ")"
                end,

                cond = function()
                    return vim.o.columns > 100
                end,

                on_click = function()
                    require("xmake.project_config._menu").init() -- Add the on-click ui
                end,
            }

            require("lualine").setup({
                sections = {
                    lualine_y = {
                        xmake_component,
                    },
                },
            })
        end,
    },
    { import = "lazyvim.plugins.extras.ui.edgy" },
    {
        "folke/edgy.nvim",
        event = "VeryLazy",
        init = function()
            vim.opt.laststatus = 3
            vim.opt.splitkeep = "screen"
        end,
        opts = {
            bottom = {
                -- toggleterm / lazyterm at the bottom with a height of 40% of the screen
                {
                    ft = "toggleterm",
                    size = { height = 0.4 },
                    -- exclude floating windows
                    filter = function(buf, win)
                        return vim.api.nvim_win_get_config(win).relative == ""
                    end,
                },
                {
                    ft = "lazyterm",
                    title = "LazyTerm",
                    size = { height = 0.4 },
                    filter = function(buf)
                        return not vim.b[buf].lazyterm_cmd
                    end,
                },
                "Trouble",
                { ft = "qf", title = "QuickFix" },
                {
                    ft = "help",
                    size = { height = 20 },
                    -- only show help buffers
                    filter = function(buf)
                        return vim.bo[buf].buftype == "help"
                    end,
                },
                { ft = "spectre_panel", size = { height = 0.4 } },
            },
            left = {
                -- Neo-tree filesystem always takes half the screen height
                {
                    title = "Neo-Tree",
                    ft = "neo-tree",
                    filter = function(buf)
                        return vim.b[buf].neo_tree_source == "filesystem"
                    end,
                    -- size = { height = 0.5 },
                },
                -- {
                --     title = "Neo-Tree Git",
                --     ft = "neo-tree",
                --     filter = function(buf)
                --         return vim.b[buf].neo_tree_source == "git_status"
                --     end,
                --     pinned = true,
                --     open = "Neotree position=right git_status",
                -- },
                -- {
                --     title = "Neo-Tree Buffers",
                --     ft = "neo-tree",
                --     filter = function(buf)
                --         return vim.b[buf].neo_tree_source == "buffers"
                --     end,
                --     pinned = true,
                --     open = "Neotree position=top buffers",
                -- },
                {
                    ft = "Outline",
                    pinned = true,
                    open = "SymbolsOutlineOpen",
                },
                -- any other neo-tree windows
                "neo-tree",
            },
        },
    },
}
