-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Do not auto format on save
-- require("lazyvim.plugins.lsp.format").autoformat = false
-- require("lazyvim.plugins.lsp.format").opts.autoformat = false

-- Disable autoformat on save
-- It conflicts with auto-save
vim.g.autoformat = false

-- Use standard clipboard
vim.opt.clipboard = "unnamedplus"
