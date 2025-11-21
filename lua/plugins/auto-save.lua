return {
  "pocco81/auto-save.nvim",
  config = function()
    require("auto-save").setup({
      enabled = true, -- Enable auto-save on startup
      debounce_delay = 30000, -- Saves the file at most every 1000 milliseconds (1 second)
      trigger_events = { "InsertLeave", "TextChanged", "BufLeave" },
      -- Other configuration options can be added here
      -- For example, to exclude certain filetypes:
      excluded_filetypes = { "gitcommit", "gitrebase" },
    })
  end,
  keys = {
    {
      "<leader>cw",
      "<cmd>ASToggle<CR>",
      desc = "Toggle Auto-save",
    },
  },
}
