-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

local opts = { noremap = true, silent = true }

-- Remaps keys that causes confusion to me
-- Remove the starting macro for now.
-- vim.keymap.set('n', 'q', '<Nop>', { noremap = true, silent = true })

-- Map for easier navigation .
vim.keymap.set("n", "L", "E", { noremap = true })
vim.keymap.set("n", "H", "B", { noremap = true })
vim.keymap.set("n", "hH", "^", { noremap = true })
vim.keymap.set("n", "lL", "$", { noremap = true })

vim.keymap.set("n", "n", "nzzzv", { desc = "Keeps the cursor at the center when navigating to the next occurence" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Keeps the cursor at the center when navigating to the previous occurence" })

-- Arrow keys exit insert mode and continue movement
-- vim.keymap.set("i", "<Left>", "<Esc>h", { silent = true })
-- vim.keymap.set("i", "<Right>", "<Esc>l", { silent = true })
vim.keymap.set("i", "<Up>", "<Esc>k", { silent = true })
vim.keymap.set("i", "<Down>", "<Esc>j", { silent = true })

-- Alt+Arrow keys keeps moving at word size.
vim.keymap.set("i", "<M-Left>", "<Esc> bi", { silent = true })
vim.keymap.set("i", "<M-Right>", "<Esc> wa", { silent = true })

-- Shift+Arrow selection (IntelliJ-style)
vim.keymap.set("n", "<S-Left>", "v<Left>", { silent = true })
vim.keymap.set("n", "<S-Right>", "v<Right>", { silent = true })
vim.keymap.set("n", "<S-Up>", "v<Up>", { silent = true })
vim.keymap.set("n", "<S-Down>", "v<Down>", { silent = true })

-- Extend selection when already in visual mode
vim.keymap.set("v", "<S-Left>", "<Left>", { silent = true })
vim.keymap.set("v", "<S-Right>", "<Right>", { silent = true })
vim.keymap.set("v", "<S-Up>", "<Up>", { silent = true })
vim.keymap.set("v", "<S-Down>", "<Down>", { silent = true })

-- Undo/Redo
vim.keymap.set("i", "<C-z>", "<Esc>ua", { silent = true, desc = "Undo" })
vim.keymap.set("i", "<C-S-z>", "<Esc><C-r>a", { silent = true, desc = "Redo" })
vim.keymap.set("n", "<C-z>", "<Esc>ua", { silent = true, desc = "Undo" })
vim.keymap.set("n", "<C-S-z>", "<Esc><C-r>a", { silent = true, desc = "Redo" })

-- Undo breakpoints on space and punctuation
vim.keymap.set("i", " ", " <C-g>u")
vim.keymap.set("i", "<CR>", "<CR><C-g>u")
vim.keymap.set("i", ",", ",<C-g>u")
vim.keymap.set("i", ".", ".<C-g>u")
vim.keymap.set("i", "!", "!<C-g>u")
vim.keymap.set("i", "?", "?<C-g>u")
vim.keymap.set("i", ">", "><C-g>u")
vim.keymap.set("i", "<", "<<C-g>u")

-- vim.keymap.set("i", "<home>", "^", { desc = "Home to the first non-blank character" })
-- vim.keymap.set("n", "<home>", "^", { desc = "Home to the first non-blank character" })
-- vim.keymap.set({ "i", "n" }, "<home><home>", "0", { desc = "Home to the first column", silent=true })

-- Clipboard things
vim.keymap.set("n", "x", '"_x', opts) -- Delete whtouht adding to Clipboard.

-- Shortcuts to <ESC>
-- vim.keymap.set("i", "hh", "<Esc>", { noremap = true })
-- vim.keymap.set("i", "ll", "<Esc>", { noremap = true })
-- vim.keymap.set("i", "jj", "<Esc>", { noremap = true })
-- vim.keymap.set("i", "kk", "<Esc>", { noremap = true })
vim.keymap.set({ "i", "n", "v" }, "<C-a>", "<Esc>ggVG", { noremap = false, silent = true, desc = "Select All" })


-- ----------------------------------------------------------------------------
-- Search
-- ----------------------------------------------------------------------------
vim.keymap.set("n", "\\sf", function()
  local folder = vim.fn.expand("%:p:h")
  require("telescope.builtin").live_grep({ cwd = folder })
end, { desc = "Search in [F]older of current file" })


vim.keymap.set("n", "\\sd", function()
  require("utils.search").directory_live_grep()
end, { desc = "Search in [D]irectory (picker)" })



-- ----------------------------------------------------------------------------
-- Diffs - changed 
-- ----------------------------------------------------------------------------
vim.keymap.set('n', '\\dc', function ()
  require("utils.diff").diff_with_clipboard()
  
end, {desc = "Diff current file with Clipboard (DiffView)"})
