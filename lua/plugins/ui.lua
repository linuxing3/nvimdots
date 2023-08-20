return {
    {
        "nvim-lualine/lualine.nvim",
        optional = true,
        event = "VeryLazy",
        opts = function(_, opts)
            local Util = require("lazyvim.util")
            local colors = {
                [""] = Util.fg("Special"),
                ["Normal"] = Util.fg("Special"),
                ["Warning"] = Util.fg("DiagnosticError"),
                ["InProgress"] = Util.fg("DiagnosticWarn"),
            }
            table.insert(opts.sections.lualine_x, 2, {
                function()
                    local icon = require("lazyvim.config").icons.kinds.Copilot
                    local status = require("copilot.api").status.data
                    return icon .. (status.message or "")
                end,
                cond = function()
                    local ok, clients = pcall(vim.lsp.get_active_clients, { name = "copilot", bufnr = 0 })
                    return ok and #clients > 0
                end,
                color = function()
                    if not package.loaded["copilot"] then
                        return
                    end
                    local status = require("copilot.api").status.data
                    return colors[status.status] or colors[""]
                end,
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
                -- {
                --     ft = "Outline",
                --     pinned = true,
                --     open = "SymbolsOutlineOpen",
                -- },
                -- any other neo-tree windows
                "neo-tree",
            },
        },
    },
}
