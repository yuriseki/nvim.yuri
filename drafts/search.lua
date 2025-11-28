
-- Search in a specific directory.
vim.keymap.set("n", "\\sd", function()
  require("telescope").load_extension("file_browser")
  local fb = require("telescope").extensions.file_browser
  fb.file_browser({
    path = vim.loop.cwd(),
    select_buffer = true,
    hidden = true,
    attach_mappings = function(_, map)
      map("i", "<CR>", function(prompt_bufnr)
        local action_state = require("telescope.actions.state")
        local entry = action_state.get_selected_entry()
        require("telescope.builtin").live_grep({ cwd = entry.path })
      end)
      return true
    end,
  })
end, { desc = "Search in directory (picker)" })

--   Search in a specific directory.
vim.keymap.set("n", "\\sd", function()
  local builtin = require("telescope.builtin")
  local actions = require("telescope.actions")
  local action_state = require("telescope.actions.state")
  local Path = require("plenary.path")

  -- Use the actual working directory as root
  local root = vim.loop.cwd()

  -- Custom entry maker for folders
  local function folder_entry_maker(entry)
    local p = Path:new(entry)
    local name = p.filename  -- FIX: plenary Path uses `filename`

    -- ignore parent folder entry
    if name == ".." then
      return nil
    end

    return {
      value = entry,
      display = "  " .. name, -- nerd font folder
      ordinal = name,
      path = entry,
    }
  end

  -- Directory Picker
  builtin.find_files({
    prompt_title = "Select directory for search",
    cwd = root,
    find_command = { "fd", "--type", "d", "--hidden", "--exclude", ".git" },
    entry_maker = folder_entry_maker,

    attach_mappings = function(prompt_bufnr, map)
      local function select_dir()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        if not selection or not selection.value then return end
        local dir = selection.value

        -- Launch live_grep for that directory
        builtin.live_grep({
          cwd = dir,
          prompt_title = "Grep in: " .. dir,

          -- ESC inside grep → return to directory picker
          attach_mappings = function(grep_bufnr, grep_map)
            local function return_to_picker()
              actions.close(grep_bufnr)
              vim.schedule(function()
                vim.api.nvim_input("\\sd")
              end)
            end

            grep_map("i", "<ESC>", return_to_picker)
            grep_map("n", "<ESC>", return_to_picker)
            return true
          end,
        })
      end

      -- ENTER to select
      map("i", "<CR>", select_dir)
      map("n", "<CR>", select_dir)

      -- Mouse click behaves like ENTER (prevents NeoTree opening)
      map("i", "<LeftMouse>", select_dir)
      map("n", "<LeftMouse>", select_dir)

      return true
    end,
  })end, { desc = "Search in directory (picker)" })
