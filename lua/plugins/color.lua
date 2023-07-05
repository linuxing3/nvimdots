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
}
