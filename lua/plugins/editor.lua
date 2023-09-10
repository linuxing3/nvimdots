return {
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
            end, function(_) end)
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
