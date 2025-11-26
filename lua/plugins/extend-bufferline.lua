return {
  "akinsho/bufferline.nvim",
  lazy = false,
  config = function()
    local bufferline = require("bufferline")
    bufferline.setup({
      options = {
        -- style_preset = bufferline.style_preset.no_italic,
        -- or you can combine these e.g.
        style_preset = {
          bufferline.style_preset.no_italic,
          bufferline.style_preset.no_bold,
        },
        themable = true,
        separator_style = "thin",
        auto_toggle_bufferline = true,
        hover = {
          enabled = true,
          delay = 20,
          reveal = { "close" },
        },
      },
    })
  end,
}
