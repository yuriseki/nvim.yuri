-- Add your custom keymaps here
-- for example:
-- vim.keymap.set('n', '<leader>f', '<cmd>echo "hello"<CR>')

local map = vim.keymap.set

map('n', ';', ':', { desc = 'CMD enter command mode' })
map('i', 'jk', '<ESC>')
map('i', '<C-s>', '<cmd> w <cr>') -- Save with crtl+s
map('n', '<C-s>', '<cmd> w <cr>') -- Save with crtl+s
