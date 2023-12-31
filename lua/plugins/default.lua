require("notify").setup({
    background_colour = "#000000",
})

return {
    "skyuplam/broot.nvim",
    "rbgrouleff/bclose.vim",
    {
        "mg979/vim-visual-multi",
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
