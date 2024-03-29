-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local Util = require("lazyvim.util")

local function map(mode, lhs, rhs, opts)
    local keys = require("lazy.core.handler").handlers.keys
    ---@cast keys LazyKeysHandler
    -- do not create the keymap if a lazy keys handler exists
    if not keys.active[keys.parse({ lhs, mode = mode }).id] then
        opts = opts or {}
        opts.silent = opts.silent ~= false
        if opts.remap and not vim.g.vscode then
            opts.remap = nil
        end
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

-- commands panel
map("n", "<leader><leader>", "<cmd>Telescope commands<cr>", { desc = "Commands Panel" })

-- colorscheme list
map("n", "<leader>tc", "<cmd>Telescope colorscheme<cr>", { desc = "Change ColorScheme" })

-- find projects
map({ "n", "v" }, "<space>pp", "<cmd>Telescope projects<cr>", { desc = "List Projects" })
map({ "n", "v" }, "<space>pa", "<cmd>AddProject<cr>", { desc = "Add Projects" })

-- yank history
map({ "n", "v" }, "<space>sy", "<cmd>YarnRingHistory<cr>", { desc = "Yank history" })

-- cheat sheat
map({ "n", "v" }, "<space>se", "<cmd>Telescope cheat fd<cr>", { desc = "Find cheatsheat" })

-- browser_bookmarks
map({ "n", "v" }, "<space>sf", "<cmd>require('browser_bookmarks').select<cr>", { desc = "Browser Bookmarks" })

-- file explorer
map({ "n", "v" }, "<C-f3>", "<cmd>Neotree toggle<cr>", { desc = "Toggle neotree" })

-- filer broot
map("n", "<leader>fa", "<cmd>vs term://br<cr>", { desc = "broot (current dir)" })
map("n", "<leader>fg", function()
    Util.terminal.open(
        "broot",
        { cwd = Util.root.get(), esc_esc = false, ctrl_hjkl = false, float = { border = "rounded" } }
    )
end, { desc = "broot (current dir)" })

-- filer telescope
map("n", "<leader>.", "<cmd>Telescope find_files<cr>", { desc = "Find files" })
map({ "n", "v" }, "<leader>fd", "<cmd>Telescope file_browser file_browser<cr>", { desc = "Toggle file_browser" })

-- new file
map("n", "<leader>fn", "<cmd>enew<cr>", { desc = "New File" })

-- lsp
map({ "n", "v" }, "<f12>", "<cmd>Telescope lsp_definitions<cr>", { desc = "Goto Definition" })
map({ "n", "v" }, "<S-f12>", "<cmd>Telescope lsp_type_definitions<cr>", { desc = "Goto type definitions" })
map({ "n", "v" }, "<f11>", "<cmd>Telescope lsp_implementations<cr>", { desc = "Goto Implementation" })
map({ "n", "v" }, "<S-f11>", "<cmd>Telescope lsp_references<cr>", { desc = "Goto Reference" })

map({ "n", "v" }, "<f2>", vim.lsp.buf.rename, { desc = "Rename variable" })
map({ "n", "v" }, "cr", vim.lsp.buf.rename, { desc = "Rename variable" })
map({ "n", "v" }, "ca", vim.lsp.buf.code_action, { desc = "Code action" })
map({ "n", "v" }, "gh", "<cmd>ClangdSwitchSourceHeader<cr>", { desc = "Clangd Switch" })

-- Task runner
map({ "n", "i" }, "<f5>", "<cmd>AsyncTask file-buildrun<cr>", { desc = "File build run" })
map({ "n", "i" }, "<f6>", "<cmd>AsyncTask project-buildrun<cr>", { desc = "Project build run" })

-- Debug
map({ "n", "i" }, "<f7>", function()
    require("dap").toggle_breakpoint()
end, { desc = "Dap break" })

map({ "n", "i" }, "<f8>", function()
    require("dap").continue()
end, { desc = "Dap continue" })

map({ "n", "i" }, "<f9>", function()
    require("dapui").toggle()
end, { desc = "Dap UI" })

map({ "n", "i" }, "<f10>", function()
    require("dap").step_into()
end, { desc = "Dap step into" })

map({ "n", "i" }, "<f11>", function()
    require("dap").step_over()
end, { desc = "Dap step over" })

-- quick tools

-- better up/down
map({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })
map({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })

-- Move to window using the <ctrl> hjkl keys
-- map("n", "<C-h>", "<C-w>h", { desc = "Go to left window", remap = true })
-- map("n", "<C-j>", "<C-w>j", { desc = "Go to lower window", remap = true })
-- map("n", "<C-k>", "<C-w>k", { desc = "Go to upper window", remap = true })
-- map("n", "<C-l>", "<C-w>l", { desc = "Go to right window", remap = true })

-- Move to tmux pane using the <ctrl> hjkl keys
map({ "n", "i", "v", "t" }, "<C-h>", "<cmd>lua require('tmux').move_left()<cr>", { desc = "Tmux left pane" })
map({ "n", "i", "v", "t" }, "<C-l>", "<cmd>lua require('tmux').move_right()<cr>", { desc = "Tmux right pane" })
map({ "n", "i", "v", "t" }, "<C-k>", "<cmd>lua require('tmux').move_top()<cr>", { desc = "Tmux top pane" })
map({ "n", "i", "v", "t" }, "<C-j>", "<cmd>lua require('tmux').move_bottom()<cr>", { desc = "Tmux bottom pane" })

-- Resize tmux pane using the <alt> hjkl keys
map({ "n", "i", "v", "t" }, "<A-h>", "<cmd>lua require('tmux').resize_left()<cr>", { desc = "Tmux left pane" })
map({ "n", "i", "v", "t" }, "<A-l>", "<cmd>lua require('tmux').resize_right()<cr>", { desc = "Tmux right pane" })
map({ "n", "i", "v", "t" }, "<A-k>", "<cmd>lua require('tmux').resize_top()<cr>", { desc = "Tmux top pane" })
map({ "n", "i", "v", "t" }, "<A-j>", "<cmd>lua require('tmux').resize_bottom()<cr>", { desc = "Tmux bottom pane" })

-- Resize window using <ctrl> arrow keys
map("n", "<C-Up>", "<cmd>resize +2<cr>", { desc = "Increase window height" })
map("n", "<C-Down>", "<cmd>resize -2<cr>", { desc = "Decrease window height" })
map("n", "<C-Left>", "<cmd>vertical resize -2<cr>", { desc = "Decrease window width" })
map("n", "<C-Right>", "<cmd>vertical resize +2<cr>", { desc = "Increase window width" })

-- Move Lines
map("n", "<A-down>", "<cmd>m .+1<cr>==", { desc = "Move down" })
map("n", "<A-up>", "<cmd>m .-2<cr>==", { desc = "Move up" })
map("i", "<A-down>", "<esc><cmd>m .+1<cr>==gi", { desc = "Move down" })
map("i", "<A-up>", "<esc><cmd>m .-2<cr>==gi", { desc = "Move up" })
map("v", "<a-down>", ":m '>+1<cr>gv=gv", { desc = "move down" })
map("v", "<a-up>", ":m '<-2<cr>gv=gv", { desc = "move up" })

-- Duplicate Line
map({ "n", "i" }, "<S-A-down>", "<esc>yyp", { desc = "Duplicate Line" })

-- Select Line
map({ "i" }, "<C-l>", "<esc>0v$", { desc = "Select Line" })

-- buffers
if Util.has("bufferline.nvim") then
    -- map("n", "<S-tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
    -- map("n", "<tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
    map("n", "<S-h>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
    map("n", "<S-l>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
    map("n", "<C-tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
    map("n", "[b", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev buffer" })
    map("n", "]b", "<cmd>BufferLineCycleNext<cr>", { desc = "Next buffer" })
    map("n", "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", { desc = "Kill others buffer" })
    map("n", "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", { desc = "Kill left buffer" })
    map("n", "<leader>br", "<cmd>BufferLineCloseRight<cr>", { desc = "Kill right buffer" })
else
    -- map("n", "<S-tab>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    -- map("n", "<tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
    map("n", "<S-h>", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    map("n", "<S-l>", "<cmd>bnext<cr>", { desc = "Next buffer" })
    map("n", "<C-tab>", "<cmd>bnext<cr>", { desc = "Next buffer" })
    map("n", "[b", "<cmd>bprevious<cr>", { desc = "Prev buffer" })
    map("n", "]b", "<cmd>bnext<cr>", { desc = "Next buffer" })
end
map({ "n", "i", "v" }, "<C-q>", "<cmd>Bclose!<cr>", { desc = "Close buffer" })
map("n", "<leader>bb", "<cmd>e #<cr>", { desc = "Switch to Other Buffer" })

-- windows
map("n", "<leader>ww", "<C-W>p", { desc = "Other window", remap = true })

map("n", "<leader>wd", "<C-W>c", { desc = "Delete window", remap = true })
map("n", "<C-x>", "<C-W>c", { desc = "Delete window", remap = true })

map("n", "<leader>w-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>wh", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>w|", "<C-W>v", { desc = "Split window right", remap = true })
map("n", "<leader>wv", "<C-W>v", { desc = "Split window right", remap = true })

map("n", "<leader>-", "<C-W>s", { desc = "Split window below", remap = true })
map("n", "<leader>|", "<C-W>v", { desc = "Split window right", remap = true })

-- tabs
map("n", "<leader><tab>l", "<cmd>tablast<cr>", { desc = "Last Tab" })
map("n", "<leader><tab>f", "<cmd>tabfirst<cr>", { desc = "First Tab" })
map("n", "<leader><tab><tab>", "<cmd>tabnew<cr>", { desc = "New Tab" })
map("n", "<leader><tab>]", "<cmd>tabnext<cr>", { desc = "Next Tab" })
map("n", "<leader><tab>d", "<cmd>tabclose<cr>", { desc = "Close Tab" })
map("n", "<leader><tab>[", "<cmd>tabprevious<cr>", { desc = "Previous Tab" })

-- Clear search with <esc>
map({ "i", "n" }, "<esc>", "<cmd>noh<cr><esc>", { desc = "Escape and clear hlsearch" })

-- Clear search, diff update and redraw
-- taken from runtime/lua/_editor.lua
map(
    "n",
    "<leader>ur",
    "<Cmd>nohlsearch<Bar>diffupdate<Bar>normal! <C-L><CR>",
    { desc = "Redraw / clear hlsearch / diff update" }
)

map({ "n", "x" }, "gw", "*N", { desc = "Search word under cursor" })

-- https://github.com/mhinz/vim-galore#saner-behavior-of-n-and-n
map("n", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("x", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("o", "n", "'Nn'[v:searchforward]", { expr = true, desc = "Next search result" })
map("n", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("x", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })
map("o", "N", "'nN'[v:searchforward]", { expr = true, desc = "Prev search result" })

-- Add undo break-points
map("i", ",", ",<c-g>u")
map("i", ".", ".<c-g>u")
map("i", ";", ";<c-g>u")
map("i", "jj", "<esc><esc>")

-- save file
map("n", "<leader>ss", "<cmd>wa!<cr>", { desc = "Save all" })
map({ "i", "v", "n" }, "<C-s>", "<cmd>w<cr><esc>", { desc = "Save file" })

-- better indenting
map("v", "<", "<gv")
map("v", ">", ">gv")

-- lazy
map("n", "<leader>L", "<cmd>Lazy<cr>", { desc = "Lazy" })

-- list
map("n", "<leader>xl", "<cmd>lopen<cr>", { desc = "Location List" })
map("n", "<leader>xq", "<cmd>copen<cr>", { desc = "Quickfix List" })

if not Util.has("trouble.nvim") then
    map("n", "[q", vim.cmd.cprev, { desc = "Previous quickfix" })
    map("n", "]q", vim.cmd.cnext, { desc = "Next quickfix" })
end

-- stylua: ignore start

-- toggle options
map("n", "<leader>uf", function() Util.toggle("format") end, { desc = "Toggle format on Save" })
map("n", "<leader>us", function() Util.toggle("spell") end, { desc = "Toggle Spelling" })
map("n", "<leader>uw", function() Util.toggle("wrap") end, { desc = "Toggle Word Wrap" })
map("n", "<leader>ul", function() Util.toggle("relativenumber", true) Util.toggle("number") end, { desc = "Toggle Line Numbers" })
map("n", "<leader>ud", function ()
    Util.toggle("diagnostics")
end, { desc = "Toggle Diagnostics" })
local conceallevel = vim.o.conceallevel > 0 and vim.o.conceallevel or 3
map("n", "<leader>uc", function() Util.toggle("conceallevel", false, {0, conceallevel}) end, { desc = "Toggle Conceal" })
if vim.lsp.inlay_hint then
  map("n", "<leader>uh", function() vim.lsp.inlay_hint(0, nil) end, { desc = "Toggle Inlay Hints" })
end

-- lazygit
map("n", "<leader>gg", function() Util.terminal.open("lazygit", { cwd = Util.root.get(), esc_esc = false, ctrl_hjkl = false, float = { border = "rounded"}}) end, { desc = "Lazygit (root dir)" })
map("n", "<leader>G", function() Util.terminal.open("lazygit", { cwd = Util.root.get(), esc_esc = false, ctrl_hjkl = false, float = { border = "rounded"}}) end, { desc = "Lazygit (root dir)" })

-- quit
map("n", "<leader>qq", "<cmd>qa!<cr>", { desc = "Quit all" })

-- highlights under cursor
map("n", "<leader>ui", vim.show_pos, { desc = "Inspect Pos" })

-- terminal
local lazyterm = function() Util.terminal.open(nil, { cwd = Util.root.get(), float = { border =  "rounded"} }) end
map("n", "<C-`>", lazyterm, { desc = "Terminal (root dir)" })

-- floating terminal
map("n", "<leader>ft", function() Util.terminal.open("fish", { cwd = Util.root.get(), esc_esc = false, ctrl_hjkl = false, float = { border = "rounded"}}) end, { desc = "Fish (root dir)" })

-- Terminal Mappings
map("t", "<esc><esc>", "<c-\\><c-n>", { desc = "Enter Normal Mode" })
map("t", "<C-h>", "<cmd>wincmd h<cr>", { desc = "Go to left window" })
map("t", "<C-j>", "<cmd>wincmd j<cr>", { desc = "Go to lower window" })
map("t", "<C-k>", "<cmd>wincmd k<cr>", { desc = "Go to upper window" })
map("t", "<C-l>", "<cmd>wincmd l<cr>", { desc = "Go to right window" })
map("t", "<C-`>", "<cmd>close<cr>", { desc = "Hide Terminal" })
map("t", "<A-e>", "<cmd>close<cr>", { desc = "Hide Broot" })

-- Sniprun settings
map("v", "f", "<cmd>SnipRun<cr>", { desc = "SnipRun"})
map("v", "<f5>", "<cmd>SnipRun<cr>", { desc = "SnipRun"})
map("n", "<leader>rr", "<cmd>SnipRun<cr>", { desc = "SnipRun"})

-- copilot settings
-- AI Assistant
map({ "n", "v", "i" }, "<C-\\>", "<cmd>Copilot panel<cr>", { desc = "Copilot Panel" })

map({ "n" }, "cc", "<cmd>Copilot panel<cr>", { desc = "Code with copilot" })
map({ "n" }, "ce", "<cmd>Copilot enable<cr>", { desc = "Enable copilot" })
map({ "n" }, "cq", "<cmd>Copilot disable<cr>", { desc = "Disable copilot" })
vim.cmd[[
    " let g:copilot_proxy = 'http://localhost:10809'
    " imap <silent><script><expr> <tab> copilot#Accept("\<CR>")
    " let g:copilot_no_tab_map = v:false
]]
