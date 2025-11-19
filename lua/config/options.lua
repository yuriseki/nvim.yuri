-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Do not auto format on save
-- require("lazyvim.plugins.lsp.format").autoformat = false
-- require("lazyvim.plugins.lsp.format").opts.autoformat = false


-- Hide the Codebook spellcheck - I did not found a better way to just toggle it out.
vim.diagnostic.config({
  virtual_text = {
    format = function(diagnostic)
      if diagnostic.source == "Codebook" then
        return nil -- hide it
      end
      return diagnostic.message
    end,
  },
  signs = {
    text = {
      -- also hide signs from Codebook
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
})
