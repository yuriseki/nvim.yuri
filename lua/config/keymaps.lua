-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }

-- Map for easier navigation .
vim.keymap.set("n", "L", "E", { noremap = true })
vim.keymap.set("n", "H", "B", { noremap = true })
vim.keymap.set("n", "hH", "^", { noremap = true })
vim.keymap.set("n", "lL", "$", { noremap = true })

vim.keymap.set("n", "n", "nzzzv", { desc = "Keeps the cursor at the center when navigating to the next occurence" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Keeps the cursor at the center when navigating to the previous occurence" })


-- Clipboard things
vim.keymap.set("n", "x", '"_x', opts) -- Delete whtouht adding to Clipboard.

-- Shortcuts to <ESC>
-- vim.keymap.set("i", "hh", "<Esc>", { noremap = true })
-- vim.keymap.set("i", "ll", "<Esc>", { noremap = true })
-- vim.keymap.set("i", "jj", "<Esc>", { noremap = true })
-- vim.keymap.set("i", "kk", "<Esc>", { noremap = true })
vim.keymap.set({ "i", "n", "v" }, "<C-a>", "<Esc>ggVG", { noremap = false, silent = true, desc = "Select All" })
