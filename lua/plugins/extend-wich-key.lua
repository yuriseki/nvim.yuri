return {
  "folke/which-key.nvim",
  -- optional = true,
  opts = function()
    local wk = require("which-key")
    wk.add({
      { "\\", group = "Custom Backslask Mappings" },
      -- Pressing '\w' will save the file
      { "\\w", "<cmd>w<cr>", desc = "[W]rite File" },
    }) -- backslash as prefix
  end,
}
