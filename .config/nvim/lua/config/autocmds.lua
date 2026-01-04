-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua

-- Add any additional autocmds here

-- Highlight Zenkaku (full-width) spaces
vim.api.nvim_create_autocmd({ "VimEnter", "WinEnter" }, {
  pattern = "*",
  callback = function()
    vim.fn.matchadd("ZenkakuSpace", "　")
  end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
  pattern = "*",
  callback = function()
    vim.api.nvim_set_hl(0, "ZenkakuSpace", { underline = true, fg = "darkgrey" })
  end,
})
