-- lua/plugins/blink.lua
return {
  "saghen/blink.cmp",

  dependencies = {
    "L3MON4D3/LuaSnip",
    "rafamadriz/friendly-snippets",
  },

  -- we use config to ensure we call setup() and have full control
  config = function()
    -- load snippets
    local ok_ls, luasnip = pcall(require, "luasnip")
    if not ok_ls then
      vim.notify("blink.lua: LuaSnip not found. Install L3MON4D3/LuaSnip", vim.log.levels.WARN)
      return
    end
    require("luasnip.loaders.from_vscode").lazy_load()

    -- default blink options we want (IntelliJ-like)
    local blink_opts = {
      completion = {
        -- show popup while typing
        trigger = {
          show_in_snippet = true,
          show_on_insert = true,
          show_on_keyword = true,
          show_on_trigger_character = true,
        },
      },

      -- sorting / fuzzy-ish behavior
      sort = {
        comparators = {
          "kind",
          "score",
          "sort_text",
          "length",
          "exact",
          "recency",
          "locality",
        },
      },

      -- prevent preset interfering with our custom tab behavior
      keymap = {
        preset = "none",
      },

      -- confirm behavior: select when pressing Enter
      confirm = {
        select = true,
      },
    }

    -- try to setup blink.cmp
    local ok_blink, blink = pcall(require, "blink.cmp")
    if not ok_blink then
      vim.notify("blink.cmp module not found. Did lazy install the plugin? Run :Lazy sync", vim.log.levels.ERROR)
      return
    end

    -- call setup
    if blink.setup then
      blink.setup(blink_opts)
    else
      vim.notify("blink.cmp doesn't expose setup(), check version", vim.log.levels.ERROR)
    end

    -- Helper wrapper to check snippet jumpability in a safe way
    local function snippet_can_expand_or_jump()
      -- luasnip API differs between versions; try a few safe calls
      if not luasnip then
        return false
      end
      if luasnip.expand_or_locally_jumpable then
        return luasnip.expand_or_locally_jumpable()
      elseif luasnip.expand_or_jumpable then
        return luasnip.expand_or_jumpable()
      else
        return false
      end
    end

    local function snippet_jumpable_backward()
      if not luasnip then
        return false
      end
      if luasnip.locally_jumpable then
        return luasnip.locally_jumpable(-1)
      elseif luasnip.jumpable then
        -- not exact API; best-effort
        return false
      else
        return false
      end
    end

    -- Keymaps (use Blink's API where available)
    local function tab_handler(fallback)
      local ok, b = pcall(require, "blink.cmp")
      if ok and b.is_visible and b.is_visible() then
        b.select_next()
      elseif snippet_can_expand_or_jump() then
        -- use luasnip safe expansion
        if luasnip.expand_or_locally_jumpable then
          luasnip.expand_or_jump()
        else
          -- fallback: try expand then jump
          pcall(luasnip.expand)
        end
      else
        fallback()
      end
    end

    local function s_tab_handler(fallback)
      local ok, b = pcall(require, "blink.cmp")
      if ok and b.is_visible and b.is_visible() then
        b.select_prev()
      elseif snippet_jumpable_backward() then
        luasnip.jump(-1)
      else
        fallback()
      end
    end

    -- Use vim.keymap.set as a robust fallback; this will run alongside blink's keymaps.
    vim.keymap.set({ "i", "s" }, "<Tab>", function()
      tab_handler(function()
        return vim.api.nvim_replace_termcodes("<Tab>", true, true, true)
      end)
    end, { silent = true, expr = false })
    vim.keymap.set({ "i", "s" }, "<S-Tab>", function()
      s_tab_handler(function()
        return vim.api.nvim_replace_termcodes("<S-Tab>", true, true, true)
      end)
    end, { silent = true, expr = false })

    -- Enter confirm
    vim.keymap.set("i", "<CR>", function()
      local ok, b = pcall(require, "blink.cmp")
      if ok and b.confirm then
        b.confirm({ select = true })
      else
        return vim.api.nvim_replace_termcodes("<CR>", true, true, true)
      end
    end, { expr = false, silent = true })

    -- Manual trigger (Ctrl-Space)
    vim.keymap.set("i", "<C-Space>", function()
      local ok, b = pcall(require, "blink.cmp")
      if ok and b.show then
        b.show()
      end
    end, { silent = true })

    -- small debug commands to inspect state quickly
    vim.api.nvim_create_user_command("BlinkState", function()
      local ok, b = pcall(require, "blink.cmp")
      if not ok then
        print("blink.cmp module not found")
        return
      end
      print("blink visible:", b.is_visible and b.is_visible())
      print("blink menu item count:", b.get_menu and #b.get_menu() or "unknown")
    end, { desc = "Show blink state for debugging" })

    -- Informational message
    vim.defer_fn(function()
      vim.notify("blink.cmp: IntelliJ-style keymaps loaded", vim.log.levels.INFO)
    end, 200)
  end,
}
