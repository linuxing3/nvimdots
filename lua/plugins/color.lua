return {
    {

        "rose-pine/neovim",
        as = "rose-pine",
        config = function()
            -- vim.cmd("colorscheme rose-pine")
        end,
    },
    {
        -- Theme inspired by Atom
        "navarasu/onedark.nvim",
        priority = 1000,
        config = function()
            -- vim.cmd.colorscheme("onedark")
        end,
    },
    {
        "ellisonleao/gruvbox.nvim",
        config = function()
            vim.cmd("colorscheme gruvbox")
        end,
    },
    {
        "rebelot/kanagawa.nvim",
        config = function()
            -- vim.cmd.colorscheme("kanagawa")
        end,
    },
    {
        "jacoborus/tender.vim",
        config = function()
            -- vim.cmd.colorscheme("tender")
        end,
    },
}
