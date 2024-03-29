-- local plantuml = require("ftp.plantuml")
-- plantuml.setup({ renderer = "text" })

local my_org_capture_templates = {
    l = {
        description = "links",
        template = "* [[%x][%(return string.match('%x', '([^/]+)$'))]]%?",
        target = "~/OneDrive/org/links.org",
    },
    T = {
        description = "Todo",
        template = "* TODO %?\n %u",
        target = "~/OneDrive/org/inbox.agenda.org",
    },
    a = {
        description = "Agenda",
        template = "\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?",
        target = "~/OneDrive/org/note.agenda.org",
    },
    j = {
        description = "Journal",
        template = "\n*** %<%Y-%m-%d> %<%A>\n**** %U\n\n%?",
        target = "~/OneDrive/org/journal/%<%Y-%m>.org",
    },
    e = {
        description = "Event",
        subtemplates = {
            r = {
                description = "recurring",
                template = "** %?\n %T",
                target = "~/OneDrive/org/inbox.agenda.org",
                headline = "recurring",
            },
            o = {
                description = "one-time",
                template = "** %?\n %T",
                target = "~/OneDrive/org/inbox.agenda.org",
                headline = "one-time",
            },
        },
    },
    d = {
        description = "Dairy",
        template = '* %(return vim.fn.getreg "w")',
        -- get the content of register "w"
        target = "~/OneDrive/org/dairy.org",
    },
}

local neorg_config = {
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
        { "<leader>on", "<cmd>Neorg workspace notes<cr>", desc = "Neorg workspace notes" },
        { "<leader>oh", "<cmd>Neorg workspace home<cr>", desc = "Neorg workspace home" },
        { "<leader>ot", "<cmd>Neorg journal today<cr>", desc = "Neorg journey today" },
        { "<leader>oy", "<cmd>Neorg journal yesterday<cr>", desc = "Neorg journal yesterday" },
        { "<leader>om", "<cmd>Neorg journal tomorrow<cr>", desc = "Neorg journal tomorrow" },
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
}

return {
    {
        "nvim-orgmode/orgmode",
        config = function()
            local org = require("orgmode")
            org.setup_ts_grammar()
            org.setup({
                org_agenda_files = { "~/OneDrive/org/*.agenda.org" },
                org_default_note_file = "~/OneDrive/org/inbox.agenda.org",
                org_capture_templates = my_org_capture_templates,
            })
        end,
    },
    {
        "ixru/nvim-markdown",
    },
    {
        "iamcco/markdown-preview.nvim",
        config = function()
            -- vim.fn["mkdp#util#install"]()
        end,
    },
    -- {
    --     "3rd/image.nvim",
    --     disabled = true,
    --     event = "VeryLazy",
    --     opts = {
    --         backend = "kitty",
    --         integrations = {
    --             markdown = {
    --                 enabled = true,
    --                 clear_in_insert_mode = false,
    --                 download_remote_images = true,
    --                 only_render_image_at_cursor = false,
    --                 filetypes = { "markdown", "vimwiki" }, -- markdown extensions (ie. quarto) can go here
    --             },
    --             neorg = {
    --                 enabled = true,
    --                 clear_in_insert_mode = false,
    --                 download_remote_images = true,
    --                 only_render_image_at_cursor = false,
    --                 filetypes = { "norg" },
    --             },
    --         },
    --         max_width = nil,
    --         max_height = nil,
    --         max_width_window_percentage = nil,
    --         max_height_window_percentage = 50,
    --         kitty_method = "normal",
    --         hijack_file_patterns = { "*.png", "*.jpg", "*.jpeg", "*.gif", "*.webp" }, -- render image files as images when opened
    --     },
    -- },
    {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {
            plugins = { spelling = true },
            defaults = {
                mode = { "n", "v" },
                ["g"] = { name = "+goto" },
                ["gz"] = { name = "+surround" },
                ["]"] = { name = "+next" },
                ["["] = { name = "+prev" },
                ["<leader><tab>"] = { name = "+tabs" },
                ["<leader>a"] = { name = "+action" },
                ["<leader>b"] = { name = "+buffer" },
                ["<leader>c"] = { name = "+code" },
                ["<leader>d"] = { name = "+document" },
                ["<leader>e"] = { name = "+extensions" },
                ["<leader>f"] = { name = "+file/find" },
                ["<leader>g"] = { name = "+git" },
                ["<leader>h"] = { name = "+helper" },
                ["<leader>o"] = { name = "+org" },
                ["<leader>gh"] = { name = "+hunks" },
                ["<leader>n"] = { name = "+new" },
                ["<leader>p"] = { name = "+project" },
                ["<leader>q"] = { name = "+quit/session" },
                ["<leader>r"] = { name = "+task" },
                ["<leader>s"] = { name = "+search" },
                ["<leader>u"] = { name = "+ui" },
                ["<leader>w"] = { name = "+windows" },
                ["<leader>x"] = { name = "+diagnostics/quickfix" },
            },
        },
        config = function(_, opts)
            local wk = require("which-key")
            wk.setup(opts)
            wk.register(opts.defaults)
        end,
    },
}
