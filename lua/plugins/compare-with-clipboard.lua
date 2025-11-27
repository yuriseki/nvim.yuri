return {
  "antosha417/nvim-compare-with-clipboard",
  config = function()
    -- Plugin setup options
    require("compare-with-clipboard").setup({
      -- by default splits are horizontal
      vertical_split = true,
    })

    -- Define the custom function to compare the current buffer with the clipboard
    local function compare_buffer_with_clipboard()
      -- 1. Select the entire buffer (ggVG)
      vim.api.nvim_feedkeys("<ESC>ggVG", "n", true)

      -- 2. Yank the selection into register 'a' ("ay)
      -- 'normal! "ay' executes normal mode commands
      vim.api.nvim_feedkeys('"by', "n", false)

      -- 3. Call the plugin's compare function for registers 'b' and '+'
      require("compare-with-clipboard").compare_registers("+", "b")
    end

    -- Map the function to a key (e.g., <leader>C) in normal mode
    vim.keymap.set("n", "\\C", compare_buffer_with_clipboard, { desc = "Compare active buffer with clipboard" })
  end,
}
