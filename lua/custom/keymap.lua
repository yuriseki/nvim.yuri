-- Add your custom keymaps here
-- for example:
-- vim.keymap.set('n', '<leader>f', '<cmd>echo "hello"<CR>')

local map = vim.keymap.set

-- For conciseness
local opts = { noremap = true, silent = true }

map('n', ';', ':', { desc = 'CMD enter command mode' })
map('i', 'jk', '<ESC>')

-- File manipulation
map('i', '<C-s>', '<cmd> w <cr><esc>') -- Save with crtl+s and go to normal mode
map('n', '<C-s>', '<cmd> w <cr>') -- Save with crtl+s

local function CopyRelativePathToClipboard()
  -- Get the relative path of the current buffer
  local file_path = vim.fn.expand '%:.'

  -- Check if a path was found
  if file_path and file_path ~= '' then
    -- Copy the path to the system clipboard (register '+')
    vim.fn.setreg('+', file_path)
    vim.notify('Copied relative path: ' .. file_path, vim.log.levels.INFO, { title = 'File Path' })
  else
    vim.notify('No file path to copy', vim.log.levels.WARN, { title = 'File Path' })
  end
end
map('n', '<leader>cp', CopyRelativePathToClipboard, { desc = 'Copy relative path to clipboard' })

-- Delete single character without copying into register.
map('n', 'x', '"_x', { desc = 'Delete a single character without copying into register' })

-- Move highlighted content up and down
map('v', 'J', ":m '>+1<CR>gv=gv", { desc = 'Move line up' })
map('v', 'K', ":m '<-2<CR>gv=gv", { desc = 'Move line down' })

-- Buffers (tabs in InteliJ)
vim.keymap.set('n', '<Tab>', ':bnext<CR>', opts)
vim.keymap.set('n', '<S-Tab>', ':bprevious<CR>', opts)
vim.keymap.set('n', '<leader>x', ':bdelete!<CR>', opts) -- close buffer
vim.keymap.set('n', '<leader>b', '<cmd> enew <CR>', opts) -- new buffer

-- Text manipulation

-- Keymaps for Plugins
map('n', '<leader>mp', ':MarkdownPreviewToggle<cr>', { desc = 'Open the markdown preview in the default browser' })
--
map({ 'n', 'v' }, '<leader>/', ':CommentToggle<cr>', { desc = 'Open the markdown preview in the default browser' })
--
-- a
--b
--c
-- test
--d
--
