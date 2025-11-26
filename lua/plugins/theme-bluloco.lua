return {
  "uloco/bluloco.nvim",
  lazy = false,
  priority = 1000,
  dependencies = { "rktjmp/lush.nvim" },
  config = function()
    require("bluloco").setup({
      style = "auto", -- "auto" | "dark" | "light"
      transparent = false,
      italics = true,
      terminal = vim.fn.has("gui_running") == 0, -- bluoco colors are enabled in gui terminals per default.
      guicursor = true,
      rainbow_headings = true, -- if you want different colored headings for each heading level
      bold = true,
      -- italic = true,
      underline = true,
      -- underlineline = true,
      -- underdouble = true,
      -- undercurl = true,
      -- underdot = true,
      -- underdotted = true,
      -- underdash = true,
      -- underdashed = true,
      -- strikethrough = true,
      -- reverse = true,
      -- standout = true,
      -- nocombine = true,
    })

    vim.cmd("colorscheme bluloco")
  end,
}
