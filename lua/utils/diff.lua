local M = {}

-- Try to get a sensible clipboard/yank content from common registers.
local function get_clipboard_lines()
  local regs = { "+", "*", "0", '"' }
  for _, r in ipairs(regs) do
    local content = vim.fn.getreg(r)
    if content and content ~= "" then
      local lines = vim.split(content, "\n", { plain = true })
      return lines, r
    end
  end
  return nil, nil
end

-- Create a scratch buffer and fill it with lines, with safe options.
local function make_scratch_buffer(lines, filetype)
  local buf = vim.api.nvim_create_buf(false, true)

  -- Set lines
  vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

  -- Replace deprecated buf_set_option with set_option_value
  vim.api.nvim_set_option_value("buftype", "nofile", { buf = buf })
  vim.api.nvim_set_option_value("bufhidden", "wipe", { buf = buf })
  vim.api.nvim_set_option_value("swapfile", false, { buf = buf })
  vim.api.nvim_set_option_value("modifiable", true, { buf = buf })

  if filetype and filetype ~= "" then
    vim.api.nvim_set_option_value("filetype", filetype, { buf = buf })
  end

  return buf
end

-- Public: Open a tab with a vertical diff comparing clipboard vs current buffer
function M.diff_with_clipboard()
  local current_buf = vim.api.nvim_get_current_buf()

  local filetype = vim.api.nvim_get_option_value("filetype", { buf = current_buf })

  local lines, used_reg = get_clipboard_lines()
  if not lines then
    vim.notify("No clipboard/yank content found in registers (+,*,0,\").", vim.log.levels.WARN)
    return
  end

  vim.cmd("tabnew")
  local left_win = vim.api.nvim_get_current_win()

  -- Scratch buffer with clipboard content
  local scratch_buf = make_scratch_buffer(lines, filetype)
  vim.api.nvim_win_set_buf(left_win, scratch_buf)

  -- Right window with original buffer
  vim.cmd("vsplit")
  local right_win = vim.api.nvim_get_current_win()
  vim.api.nvim_win_set_buf(right_win, current_buf)

  -- Ensure scratch is modifiable (safe for diff)
  vim.api.nvim_set_option_value("modifiable", true, { buf = scratch_buf })

  -- Enable diff mode
  vim.api.nvim_set_current_win(left_win)
  vim.cmd("diffthis")

  vim.api.nvim_set_current_win(right_win)
  vim.cmd("diffthis")

  --------------------------------------------------------------------
  --  DIFF-LOCAL KEYMAPS.
  --------------------------------------------------------------------

  local function map_diff_keys(win)
    -- Accept hunk from left: Alt+Left
    vim.keymap.set("n", "<M-Left>", function()
      vim.api.nvim_set_current_win(win)
      vim.cmd("diffget")
    end, { buffer = vim.api.nvim_win_get_buf(win), silent = true })

    -- Accept hunk from right: Alt+Right
    vim.keymap.set("n", "<M-Right>", function()
      vim.api.nvim_set_current_win(win)
      vim.cmd("diffput")
    end, { buffer = vim.api.nvim_win_get_buf(win), silent = true })
  end

  -- Apply mappings to both the left and right windows
  map_diff_keys(left_win)
  map_diff_keys(right_win)

  vim.notify(("Clipboard diff opened (register '%s')"):format(used_reg), vim.log.levels.INFO)
end

return M

