-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here
local vim = vim
local autocmd = {}

function autocmd.nvim_create_augroups(definitions)
    for group_name, definition in pairs(definitions) do
        vim.api.nvim_command("augroup " .. group_name)
        vim.api.nvim_command("autocmd!")
        for _, def in ipairs(definition) do
            local command = table.concat(vim.tbl_flatten({ "autocmd", def }), " ")
            vim.api.nvim_command(command)
        end
        vim.api.nvim_command("augroup END")
    end
end

function autocmd.load_autocmds()
    local definitions = {
        packer = {},
        bufs = {
            {
                "BufEnter",
                "*.txt",
                "silent! set ft=markdown",
            },
            -- Reload vim config automatically
            {
                "BufWritePost",
                [[$VIM_PATH/{*.vim,*.yaml,vimrc} nested source $MYVIMRC | redraw]],
            },
            {
                "BufWritePost",
                "xmake.lua ! xmake project -k compile_commands",
            },
            {
                "BufWritePost",
                "CMakeLists.txt ! cmake -Bbuild -DCMAKE_EXPORTS_COMPIlATION_COMMANDS=1",
            },
            {
                "BufWritePost",
                "Cargo.toml !cargo check",
            },
            {
                "BufWritePost",
                "~/.local/share/chezmoi/* ! chezmoi apply --source-path '%'",
            },
            {
                "BufEnter",
                "*.wgsl",
                "silent! set ft=wgsl",
            },
            {
                "BufEnter",
                "*.plantuml",
                "silent! set ft=plantuml",
            },
            {
                "BufWritePost",
                "*.plantuml ! java -jar ~/.dotfiles/tools/plantuml.jar '%'",
            },
            {
                "BufEnter",
                "*.ditaa",
                "silent! set ft=ditaa",
            },
            {
                "BufWritePost",
                "*.ditaa ! java -jar ~/.dotfiles/tools/ditaa.jar '%' '%'.png",
            },
            -- Reload Vim script automatically if setlocal autoread
            {
                "BufWritePost,FileWritePost",
                "*.vim",
                [[nested if &l:autoread > 0 | source <afile> | echo 'source ' . bufname('%') | endif]],
            },
            { "BufWritePre", "/tmp/*", "setlocal noundofile" },
            { "BufWritePre", "COMMIT_EDITMSG", "setlocal noundofile" },
            { "BufWritePre", "MERGE_MSG", "setlocal noundofile" },
            { "BufWritePre", "*.tmp", "setlocal noundofile" },
            { "BufWritePre", "*.bak", "setlocal noundofile" },
            -- auto change directory
            { "BufEnter", "*", "silent! lcd %:p:h" },
            -- auto place to last edit
            {
                "BufReadPost",
                "*",
                [[if line("'\"") > 1 && line("'\"") <= line("$") | execute "normal! g'\"" | endif]],
            },
            {
                "BufEnter",
                "*",
                [[if winnr('$') == 1 && bufname() == 'NvimTree_' . tabpagenr() | quit | endif]],
            },
            -- Auto toggle fcitx5
            -- {"InsertLeave", "* :silent", "!fcitx5-remote -c"},
            -- {"BufCreate", "*", ":silent !fcitx5-remote -c"},
            -- {"BufEnter", "*", ":silent !fcitx5-remote -c "},
            -- {"BufLeave", "*", ":silent !fcitx5-remote -c "}
        },
        wins = {
            -- Highlight current line only on focused window
            {
                "WinEnter,BufEnter,InsertLeave",
                "*",
                [[if ! &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal cursorline | endif]],
            },
            {
                "WinLeave,BufLeave,InsertEnter",
                "*",
                [[if &cursorline && &filetype !~# '^\(dashboard\|clap_\)' && ! &pvw | setlocal nocursorline | endif]],
            },
            -- Force write shada on leaving nvim
            {
                "VimLeave",
                "*",
                [[if has('nvim') | wshada! | else | wviminfo! | endif]],
            },
            -- Check if file changed when its window is focus, more eager than 'autoread'
            { "FocusGained", "* checktime" },
            -- Equalize window dimensions when resizing vim window
            { "VimResized", "*", [[tabdo wincmd =]] },
        },
        ft = {
            { "FileType", "wgsl", "set ft=wgsl" },
            { "FileType", "plantuml", "set ft=plantuml" },
            { "FileType", "ditaa", "set ft=ditaa" },
            { "FileType", "alpha", "set showtabline=0" },
            { "FileType", "markdown", "set wrap" },
            { "FileType", "make", "set noexpandtab shiftwidth=8 softtabstop=0" },
            { "FileType", "dap-repl", "lua require('dap.ext.autocompl').attach()" },
            {
                "FileType",
                "*",
                [[setlocal formatoptions-=cro]],
            },
        },
        yank = {
            {
                "TextYankPost",
                "*",
                [[silent! lua vim.highlight.on_yank({higroup="IncSearch", timeout=300})]],
            },
        },
    }

    autocmd.nvim_create_augroups(definitions)
end

autocmd.load_autocmds()

require("notify").setup({
    background_colour = "#000000",
})
