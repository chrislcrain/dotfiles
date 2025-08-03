-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here
vim.cmd("let g:netrw_liststyle = 3")

local opt = vim.opt

-- Enable relative line numbers
opt.relativenumber = true
opt.number = true

-- turn on termguicolors for tokyonight colorscheme to work
-- (have to use iterm2 or any other true color terminal)
opt.termguicolors = true

-- Ensure cursorline is enabled
vim.opt.cursorline = true

-- Reapply highlight settings after colorscheme is loaded
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "CursorLineNr", { fg = "#aaff00", bold = true })
    vim.api.nvim_set_hl(0, "LineNr", { fg = "#888888" })
  end,
})

-- tabs & indentation
opt.tabstop = 2 -- 2 spaces for tabs (prettier default)
opt.shiftwidth = 2 -- 2 spaces for indent width
opt.expandtab = true -- expand tab to spaces
opt.autoindent = true -- copy indent from current line when starting new one

-- search settings
opt.ignorecase = true -- ignore case when searching
opt.smartcase = true -- if you include mixed case in your search, assumes you want case-sensitive

-- (have to use iterm2 or any other true color terminal)
opt.background = "dark" -- colorschemes that can be light or dark will be made dark
opt.signcolumn = "yes" -- show sign column so that text doesn't shift

-- backspace
opt.backspace = "indent,eol,start" -- allow backspace on indent, end of line or insert mode start position

-- clipboard
opt.clipboard:append("unnamedplus") -- use system clipboard as default register

-- split windows
opt.splitright = true -- split vertical window to the right
opt.splitbelow = true -- split horizontal window to the bottom

-- turn off swapfile
opt.swapfile = false

-- force zsh
opt.shell = "zsh"

-- enable mouse support
vim.o.mouse = "a"

-- Better line wrap
opt.wrap = false
-- opt.list = false

-- enable snacks input window
-- vim.ui.input = require("snacks").input
