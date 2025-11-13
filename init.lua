-- set leader key to space
vim.g.mapleader = ' '
vim.g.maplocalleader = ' '



-- Load core options
require 'core.options'

-- Load keymaps
require 'core.keymaps'

-- Setup plugin manager
require 'core.plugins'

-- Load custom theme
require 'custom.themes'

-- Load custom options
require 'custom.options'

-- Load custom keymaps
require 'custom.keymap'
