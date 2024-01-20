if vim.g.neovide then
    vim.g.neovide_theme = "auto"
    vim.o.guifont = "JetBrains Mono:h18" -- text below applies for VimScript
    -- Helper function for transparency formatting
    local alpha = function()
        return string.format("%x", math.floor(255 * (vim.g.transparency or 0.9)))
    end
    -- g:neovide_transparency should be 0 if you want to unify transparency of content and title bar.
    -- vim.g.neovide_transparency = 0.0
    vim.g.transparency = 0.9
    vim.g.neovide_background_color = "#0f1117" .. alpha()

    vim.g.neovide_floating_blur_amount_x = 2.0
    vim.g.neovide_floating_blur_amount_y = 2.0

    vim.g.neovide_remember_window_size = true
    vim.g.neovide_profiler = false
    vim.g.neovide_cursor_animation_length = 0.13
    vim.g.neovide_cursor_antialiasing = true
    vim.g.neovide_cursor_animate_in_insert_mode = true
    vim.g.neovide_cursor_animate_command_line = true
    vim.g.neovide_cursor_unfocused_outline_width = 0.125
    vim.g.neovide_cursor_vfx_mode = ""
    vim.g.neovide_cursor_vfx_mode = "railgun"

    vim.g.neovide_floating_shadow = true
    vim.g.neovide_floating_z_height = 10
    vim.g.neovide_light_angle_degrees = 45
    vim.g.neovide_light_radius = 5

    vim.g.neovide_input_ime = true

    local function set_ime(args)
        if args.event:match("Enter$") then
            vim.g.neovide_input_ime = true
        else
            vim.g.neovide_input_ime = false
        end
    end

    local ime_input = vim.api.nvim_create_augroup("ime_input", { clear = true })

    vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave" }, {
        group = ime_input,
        pattern = "*",
        callback = set_ime,
    })

    vim.api.nvim_create_autocmd({ "CmdlineEnter", "CmdlineLeave" }, {
        group = ime_input,
        pattern = "[/\\?]",
        callback = set_ime,
    })
end
