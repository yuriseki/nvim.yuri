-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Add word under cursor to global dictionary
vim.keymap.set("n", "<leader>ag", ":SpellAddGlobal<CR>", {
  desc = "Add word to GLOBAL dictionary",
})

-- Add word under cursor to project dictionary
vim.keymap.set("n", "<leader>ap", ":SpellAddProject<CR>", {
  desc = "Add word to PROJECT dictionary",
})

vim.keymap.set("n", "<leader>aw", function()
  vim.cmd("CodebookAddWord")
end, { desc = "Add word to Codebook dictionary" })
