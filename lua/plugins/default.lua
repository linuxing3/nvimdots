require("notify").setup({
    background_colour = "#000000",
})

return {
    "skyuplam/broot.nvim",
    "rbgrouleff/bclose.vim",
    {
        "mg979/vim-visual-multi",
        config = function()
            vim.cmd([[
let g:VM_maps = {}
let g:VM_maps['Find Under']         = '<C-d>'           " replace C-n
let g:VM_maps['Find Subword Under'] = '<C-d>'           " replace visual C-n
let g:VM_maps["Select Cursor Down"] = '<M-C-Down>'      " start selecting down
let g:VM_maps["Select Cursor Up"]   = '<M-C-Up>'        " start selecting up
           ]])
        end,
    },
    {
        "aserowy/tmux.nvim",
        opts = {
            navigation = {
                enable_default_keybinds = false,
            },
            resize = {
                enable_default_keybinds = false,
            },
        },
        config = function()
            return require("tmux").setup()
        end,
    },
    {
        "hkupty/nvimux",
        opts = {},
        config = function()
            -- Nvimux configuration
            local nvimux = require("nvimux")
            nvimux.setup({
                config = {
                    prefix = "<C-a>",
                },
                bindings = {
                    { { "n", "v", "i", "t" }, "s", nvimux.commands.horizontal_split },
                    { { "n", "v", "i", "t" }, "v", nvimux.commands.vertical_split },
                },
            })
        end,
    },
}
