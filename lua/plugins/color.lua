return {
    { "rose-pine/neovim" },
    { "navarasu/onedark.nvim" },
    { "ellisonleao/gruvbox.nvim" },
    { "rebelot/kanagawa.nvim" },
    { "jacoborus/tender.vim" },
    -- Configure LazyVim to load gruvbox
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = "tender",
        },
    },
}
