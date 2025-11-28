-- ----------------------------------------------------------------------------
-- Uses telescope to provide a search inside a specific folder.
-- ----------------------------------------------------------------------------
local M = {}

function M.directory_live_grep()
  local builtin = require("telescope.builtin")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local Path = require("plenary.path")

  -- Use current working directory as root
  local root = vim.loop.cwd()

  -- Custom entry maker for folders
  local function folder_entry_maker(entry)
    local p = Path:new(entry)
    local name = p.filename

    if name == ".." then
      return nil
    end

    return {
      value = entry,
      display = "  " .. name,
      ordinal = name,
      path = entry,
    }
  end

  builtin.find_files({
    prompt_title = "Select directory for search",
    cwd = root,
    find_command = { "fd", "--type", "d", "--hidden", "--exclude", ".git" },
    entry_maker = folder_entry_maker,

    attach_mappings = function(prompt_bufnr, map)
      local function select_dir()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)

        if not selection or not selection.value then
          return
        end

        local dir = selection.value

        builtin.live_grep({
          cwd = dir,
          prompt_title = "Grep in: " .. dir,

          attach_mappings = function(grep_bufnr, grep_map)
            local restart_picker = function()
              actions.close(grep_bufnr)
              vim.schedule(function()
                require("utils.search").directory_live_grep()
              end)
            end

            grep_map("i", "<ESC>", restart_picker)
            grep_map("n", "<ESC>", restart_picker)

            return true
          end,
        })
      end

      map("i", "<CR>", select_dir)
      map("n", "<CR>", select_dir)
      -- TODO: Fix the mouse selection.
      -- It needs to be remaped in order to avoid oppening neotreee instead of Telescope.
      -- This current code opens the selected folder instead of selecting
      -- the correct one with the mouse.
      map("i", "<LeftMouse>", select_dir)
      map("n", "<LeftMouse>", select_dir)

      return true
    end,
  })
end

return M
