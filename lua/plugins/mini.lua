return {
    {
        "echasnovski/mini.align",
        config = function(_, config)
            require("mini.align").setup({})
        end,
    },
    {
        "echasnovski/mini.map",
        config = function(_, config)
            require("mini.map").setup({})
        end,
    },
    {
        "echasnovski/mini.move",
        config = function(_, config)
            require("mini.move").setup({})
        end,
        opts = {
            mappings = {
                -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
                left = "<A-h>",
                right = "<A-l>",
                down = "<A-j>",
                up = "<A-k>",

                -- Move current line in Normal mode
                line_left = "<A-h>",
                line_right = "A-l>",
                line_down = "<A-j>",
                line_up = "<A-k>",
            },
        },
    },
    {
        "echasnovski/mini.surround",
        keys = function(_, keys)
            -- Populate the keys based on the user's options
            local plugin = require("lazy.core.config").spec.plugins["mini.surround"]
            local opts = require("lazy.core.plugin").values(plugin, "opts", false)
            local mappings = {
                { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
                { opts.mappings.delete, desc = "Delete surrounding" },
                { opts.mappings.find, desc = "Find right surrounding" },
                { opts.mappings.find_left, desc = "Find left surrounding" },
                { opts.mappings.highlight, desc = "Highlight surrounding" },
                { opts.mappings.replace, desc = "Replace surrounding" },
                { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
            }
            mappings = vim.tbl_filter(function(m)
                return m[1] and #m[1] > 0
            end, mappings)
            return vim.list_extend(mappings, keys)
        end,
        opts = {
            mappings = {
                add = "gsa", -- Add surrounding in Normal and Visual modes
                delete = "gsd", -- Delete surrounding
                find = "gsf", -- Find surrounding (to the right)
                find_left = "gsF", -- Find surrounding (to the left)
                highlight = "gsh", -- Highlight surrounding
                replace = "gsr", -- Replace surrounding
                update_n_lines = "gsn", -- Update `n_lines`
            },
        },
    },
    {
        "echasnovski/mini.comment",
        event = "VeryLazy",
        keys = {
            comment = "gc",
            comment_line = "gcc",
            textobject = "gc",
        },
        opts = {
            options = {
                custom_commentstring = function()
                    return require("ts_context_commentstring.internal").calculate_commentstring()
                        or vim.bo.commentstring
                end,
            },
        },
    },
}
