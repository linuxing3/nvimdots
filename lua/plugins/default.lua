require("notify").setup({
    background_colour = "#000000",
})

return {
    {
        "hrsh7th/nvim-cmp",
        dependencies = { "hrsh7th/cmp-emoji" },
        ---@param opts cmp.ConfigSchema
        opts = function(_, opts)
            local cmp = require("cmp")
            opts.sources = cmp.config.sources(vim.list_extend(opts.sources, { { name = "emoji" } }))
        end,
    },
    {
        "NoahTheDuke/vim-just",
    },
    {
        "IndianBoy42/tree-sitter-just",
    },
    "skyuplam/broot.nvim",
    "rbgrouleff/bclose.vim",
}
