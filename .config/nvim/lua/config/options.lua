-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua

local opt = vim.opt

-- Encoding
opt.encoding = "utf-8"
opt.fileencoding = "utf-8"

-- UI
opt.number = true
opt.relativenumber = true
opt.scrolloff = 5
opt.wrap = true

-- Tabs & Indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.smartindent = true

-- Search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true
opt.incsearch = true

-- Misc
opt.swapfile = false
opt.backup = false
opt.undofile = true
opt.hidden = true
