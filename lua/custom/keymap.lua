-- Add your custom keymaps here
-- for example:
-- vim.keymap.set('n', '<leader>f', '<cmd>echo "hello"<CR>')

local map = vim.keymap.set

map('n', ';', ':', { desc = 'CMD enter command mode' })
map('i', 'jk', '<ESC>')
map('i', '<C-s>', '<cmd> w <cr>') -- Save with crtl+s
map('n', '<C-s>', '<cmd> w <cr>') -- Save with crtl+s

-- Move highlighted content up and down
map('v', 'J', ":m '>+1<CR>gv=gv")
map('v', 'K', ":m '<-2<CR>gv=gv")

--
-- a
--b
--c
-- test
--d
