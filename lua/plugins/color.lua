local auto_switch_colorscheme = function()
    local hour = tonumber(os.date("%H"))
    if hour > 6 and hour < 18 then
        return "github_light"
    end
    return "tokyonight"
end

local colorscheme = auto_switch_colorscheme()

return {
    {
        "folke/tokyonight.nvim",
        opts = {
            transparent = true,
            styles = {
                sidebars = "transparent",
                floats = "transparent",
            },
        },
    },
    { "tanvirtin/monokai.nvim" },
    { "rose-pine/neovim" },
    { "navarasu/onedark.nvim" },
    { "ellisonleao/gruvbox.nvim" },
    { "rebelot/kanagawa.nvim" },
    { "jacoborus/tender.vim" },
    { "projekt0n/github-nvim-theme" },
    -- Configure LazyVim to load gruvbox
    {
        "LazyVim/LazyVim",
        opts = {
            colorscheme = colorscheme,
        },
    },
}
