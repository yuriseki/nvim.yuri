return {
  "folke/which-key.nvim",
  -- optional = true,
  opts = function()
    local wk = require("which-key")
    wk.add({
      { "\\", group = "Custom Backslask Mappings" },
      -- Add GitHuk to the regular <Leader>g group.
      -- { "<leader>gh", group = "Git [H]unk" },
      -- Pressing '\w' will save the file
      -- { "\\w", "<cmd>w<cr>", desc = "[W]rite File" },
    }) -- backslash as prefix

    -- wk.setup({
    --   layout = {
    --     sort = "icase",
    --   },
    -- })
  end,
}
