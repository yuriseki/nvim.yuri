-- Creates a global and a project level dictionaries
-- Path to the global dictionary inside your nvim config
local global_dict = vim.fn.stdpath("config") .. "/spell/en.utf-8.add"

-- Path to the project dictionary (stored in the project root)
local project_dict = ".spell/en.utf-8.add"

-- Ensure directories exist
local function ensure_dir(path)
  local dir = vim.fn.fnamemodify(path, ":h")
  if vim.fn.isdirectory(dir) == 0 then
    vim.fn.mkdir(dir, "p")
  end
end

ensure_dir(global_dict)
ensure_dir(project_dict)

-- Load dictionaries
vim.opt.spell = true
vim.opt.spelllang = { "en" }
vim.opt.spellfile = { global_dict, project_dict }

-- Function to append a word to a dictionary file
local function trim(s)
  return (s:gsub("^%s*(.-)%s*$", "%1"))
end

local function normalize(word)
  -- remove punctuation at start/end
  word = word:gsub("^[%p]+", ""):gsub("[%p]+$", "")
  -- trim and lowercase
  word = trim(word):lower()
  return word
end

local function add_word(dict)
  local raw_word = vim.fn.expand("<cword>")
  if not raw_word or raw_word == "" then
    print("No word under cursor")
    return
  end

  local word = normalize(raw_word)
  if word == "" then
    print("Invalid word")
    return
  end

  ensure_dir(dict)

  -- Read dictionary
  local words = {}
  local f = io.open(dict, "r")
  if f then
    for line in f:lines() do
      line = normalize(line)
      words[line] = true
    end
    f:close()
  end

  -- Check duplication
  if words[word] then
    print("Word '" .. word .. "' already exists in: " .. dict)
    return
  end

  -- Append word
  local fd = io.open(dict, "a")
  if fd then
    fd:write(word .. "\n")
    fd:close()
    vim.cmd("silent! spellgood " .. word)
    print("Added word '" .. word .. "' to: " .. dict)
  else
    print("Error: Could not open dictionary file: " .. dict)
  end
end

local function add_word2(dict)
  local word = vim.fn.expand("<cword>")
  if word == nil or word == "" then
    print("No word under cursor")
    return
  end

  ensure_dir(dict)

  -- Read current dictionary content
  local words = {}
  local f = io.open(dict, "r")
  if f then
    for line in f:lines() do
      words[line] = true
    end
    f:close()
  end

  -- Check for duplication
  if words[word] then
    print("Word '" .. word .. "' already exists in: " .. dict)
    return
  end

  -- Append word
  local fd = io.open(dict, "a")
  if fd then
    fd:write(word .. "\n")
    fd:close()
    vim.cmd("silent! spellgood " .. word)
    print("Added word '" .. word .. "' to: " .. dict)
  else
    print("Error: Could not open dictionary file: " .. dict)
  end
end

-- Create user commands
vim.api.nvim_create_user_command("SpellAddGlobal", function()
  add_word(global_dict)
end, {})

vim.api.nvim_create_user_command("SpellAddProject", function()
  add_word(project_dict)
end, {})

-- Optional: Command to create the project dictionary manually
vim.api.nvim_create_user_command("SpellCreateProjectDict", function()
  ensure_dir(project_dict)
  local f = io.open(project_dict, "a")
  if f then
    f:close()
    print("Project dictionary ensured at: " .. project_dict)
  end
end, {})
