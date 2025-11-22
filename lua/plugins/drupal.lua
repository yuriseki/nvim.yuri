-- lua/plugins/drupal.lua
-- Drupal LazyVim preset: Intelephense + PHPCS (Drupal) + Twig + YAML + manual lint/fix commands

local function is_drupal_root()
  local root = vim.fn.getcwd()
  return vim.fn.isdirectory(vim.fn.expand(root .. "/web/core/lib/Drupal")) == 1
end

local function project_root()
  -- tries to detect root by walking up until it finds web/core or .git
  local util = require("lspconfig.util")
  local root = util.root_pattern("web/core", ".git")(vim.fn.getcwd())
  return root or vim.fn.getcwd()
end

if not is_drupal_root() then
  return {}
end

-- Define the PHPCS inside the project.
local function project_phpcs()
  local root = project_root()
  -- local vendor_phpcs = root .. "/vendor/bin/phpcs"
  local vendor_phpcs = "/home/yuri/.config/composer/vendor/bin/phpcs"
  if vim.fn.executable(vendor_phpcs) == 1 then
    return vendor_phpcs
  end
  return "phpcs" -- fallback
end

-- Define the PHPBCF inside the project.
local function project_phpcbf()
  local root = project_root()
  -- local vendor_phpcbf = root .. "/vendor/bin/phpcbf"
  local vendor_phpcbf = "/home/yuri/.config/composer/vendor/bin/phpcbf"
  if vim.fn.executable(vendor_phpcbf) == 1 then
    return vendor_phpcbf
  end
  return "phpcbf" -- fallback
end

-----------------------------------------------------------
-- Paths
-----------------------------------------------------------
local ROOT = project_root()
local PATHS = {
  vendor = ROOT .. "/vendor",
  core = ROOT .. "/web/core",
  modules = ROOT .. "/web/modules",
  themes = ROOT .. "/web/themes",
}

local function existing_paths(tbl)
  local out = {}
  for _, p in ipairs(tbl) do
    if vim.fn.isdirectory(p) == 1 then
      table.insert(out, p)
    end
  end
  return out
end

-----------------------------------------------------------
-- Core Plugin Config
-----------------------------------------------------------
return {
  -- ------------------------------------------------------
  --   -- Define Drupal SubGroup in the Code group.
  -- ------------------------------------------------------
  {
    "folke/which-key.nvim",
    -- optional = true,
    opts = function()
      local wk = require("which-key")
      wk.add({
        { "\\d", group = "[D]rupal" },
      })
    end,
  },

  -- 1) LSP servers configuration (Intelephense + yaml + twig)
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason-lspconfig.nvim", "mason-org/mason.nvim" },
    opts = {
      servers = {
        -- Intelephense: configured per-project to include Drupal paths
        intelephense = {
          -- we disable formatting here and below to avoid conflicts
          on_attach = function(client, bufnr)
            -- disable formatting from the server (we want manual control)
            client.server_capabilities.documentFormattingProvider = false
            client.server_capabilities.documentRangeFormattingProvider = false
          end,
          settings = {
            intelephense = {
              files = { maxSize = 5000000 },
              environment = {
                includePaths = existing_paths({
                  PATHS.vendor,
                  PATHS.core,
                  PATHS.modules,
                  PATHS.themes,
                }),
              },
              stubs = {
                -- standard php stubs
                "apache",
                "Core",
                "curl",
                "date",
                "dom",
                "json",
                "mbstring",
                "mysqli",
                "PDO",
                "pdo_mysql",
                "SimpleXML",
                "SPL",
                "xml",
                "xmlreader",
                "xmlwriter",
                "zlib",
                -- Drupal-ish stubs (make sure intelephense has project stubs if necessary)
                "drupal-10",
                "drupal-11",
              },
            },
          },
        },

        -- YAML and Twig servers (if available)
        yaml = {
          settings = {
            yaml = {
              schemas = {
                -- common helpful schemas; you can extend
                ["https://json.schemastore.org/composer.json"] = "composer.json",
                -- Keep YAML general; project-specific schemas will be auto-detected
              },
            },
          },
        },

        -- If user has twig-language-server installed, lspconfig will try to start it
        twig = {},
      },
      setup = {
        -- default fallback for other servers
        ["*"] = function(server, opts)
          require("lspconfig")[server].setup(opts)
        end,
      },
    },
  },

  -- 2) null-ls (PHPCS diagnostics + PHPCBF formatter) but used manually
  {
    "nvimtools/none-ls.nvim",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason.nvim" },
    opts = function()
      local nls = require("null-ls")
      local sources = {}

      -- PHPCS as diagnostics (Drupal standards). Requires phpcs installed and Drupal coder
      table.insert(
        sources,
        nls.builtins.diagnostics.phpcs.with({
          command = "phpcs", -- ensure this is in PATH (composer global or project)
          args = { "--report=json", "--standard=Drupal,DrupalPractice", "-" },
          -- run via manual command; null-ls may invoke it on open/save depending on setup
        })
      )

      -- PHPCBF as formatting (manual use)
      if nls.builtins.formatting.phpcbf then
        table.insert(
          sources,
          nls.builtins.formatting.phpcbf.with({
            command = "phpcbf",
            args = { "--standard=Drupal,DrupalPractice", "-" },
          })
        )
      end

      return {
        root_dir = require("null-ls.utils").root_pattern("web/core", ".git"),
        sources = sources,
        on_attach = function(client, bufnr)
          -- prevent null-ls from auto-formatting on save (we want manual)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
      }
    end,
  },

  -- 3) helper commands, keymaps and telescope wrappers (only active in drupal projects)
  {
    "nvim-lua/plenary.nvim",
    keys = {
      { "\\dc", ":DrupalLint<CR>", desc = "Drupal: Lint file (PHPCS)" },
      { "\\df", ":DrupalFix<CR>", desc = "Drupal: Fix file (PHPCBF)" },
    },
    config = function(_, opts)
      -----------------------------------------------------
      -- PHPCS
      -----------------------------------------------------
      local function drupal_phpcs()
        local file = vim.fn.expand("%:p")
        local cmd = string.format(project_phpcs() .. " --standard=Drupal,DrupalPractice %q", file)
        vim.cmd("cexpr system('" .. cmd .. "')")
        vim.cmd("copen")
      end

      -----------------------------------------------------
      -- PHPCBF
      -----------------------------------------------------
      local function drupal_phpcbf()
        local file = vim.fn.expand("%:p")
        vim.fn.system(string.format(project_phpcbf() .. " --standard=Drupal,DrupalPractice " .. file))
        vim.cmd("edit!") -- reload buffer
      end

      -----------------------------------------------------
      -- Cache rebuild
      -----------------------------------------------------
      local function drupal_cache_rebuild()
        if vim.fn.executable("drush") == 1 then
          vim.fn.jobstart({ "drush", "cr" }, { cwd = ROOT })
          return
        end
        if vim.fn.executable(ROOT .. "/vendor/bin/drupal") == 1 then
          vim.fn.jobstart({ ROOT .. "/vendor/bin/drupal", "cache:rebuild" }, { cwd = ROOT })
          return
        end
        print("No drush or drupal console found")
      end

      -----------------------------------------------------
      -- Commands
      -----------------------------------------------------
      vim.api.nvim_create_user_command("DrupalLint", drupal_phpcs, { desc = "Run PHPCS (Drupal)" })
      vim.api.nvim_create_user_command("DrupalFix", drupal_phpcbf, { desc = "Run PHPCBF (Drupal)" })
      vim.api.nvim_create_user_command("DrupalCR", drupal_cache_rebuild, { desc = "Drupal cache rebuild" })

      -----------------------------------------------------
      -- Telescope Helpers (optional)
      -----------------------------------------------------
      local ok, telescope = pcall(require, "telescope.builtin")
      if ok then
        vim.api.nvim_create_user_command("DrupalFindTwig", function()
          telescope.live_grep({ default_text = "\\.twig$", search_dirs = { ROOT } })
        end, {})

        vim.api.nvim_create_user_command("DrupalFindServices", function()
          telescope.live_grep({ default_text = "services.yml", search_dirs = { ROOT } })
        end, {})
      end
    end,
  },
  -- {
  --   "nvim-lua/plenary.nvim",
  --   config = function()
  --     -- only configure commands/keymaps if in a Drupal project
  --     if not is_drupal_root() then
  --       return
  --     end
  --
  --     local function run_phpcs_on_file()
  --       local f = vim.fn.expand("%:p")
  --       local cmd = string.format("phpcs --standard=Drupal,DrupalPractice --report=json %q", f)
  --       -- run and parse output into quickfix
  --       local output = vim.fn.systemlist(cmd)
  --       -- if phpcs errors, open quickfix using the regular phpcs CLI parser (fallback to quickfix)
  --       if vim.v.shell_error ~= 0 then
  --         vim.cmd("cexpr system('" .. cmd .. "')")
  --         vim.cmd("copen")
  --       else
  --         print("PHPCS: no issues found for " .. f)
  --       end
  --     end
  --
  --     local function run_phpcbf_on_file()
  --       local f = vim.fn.expand("%:p")
  --       local cmd = string.format("phpcbf --standard=Drupal,DrupalPractice %q", f)
  --       vim.cmd("silent ! " .. cmd)
  --       vim.cmd("edit!") -- reload buffer after fix
  --       print("PHPCBF ran on " .. f)
  --     end
  --
  --     -- Drupal commands
  --     vim.api.nvim_create_user_command("DrupalLint", function()
  --       run_phpcs_on_file()
  --     end, { desc = "Run PHPCS (Drupal standards) on current file" })
  --
  --     vim.api.nvim_create_user_command("DrupalFix", function()
  --       run_phpcbf_on_file()
  --     end, { desc = "Run PHPCBF (Drupal) on current file" })
  --
  --     vim.api.nvim_create_user_command("DrupalCR", function()
  --       -- try drush, fallback to vendor/bin/drupal if present
  --       local root = project_root()
  --       if vim.fn.executable("drush") == 1 then
  --         vim.fn.jobstart({ "drush", "cr" }, { cwd = root })
  --         print("drush cr started")
  --       elseif vim.fn.executable(root .. "/vendor/bin/drupal") == 1 then
  --         vim.fn.jobstart({ root .. "/vendor/bin/drupal", "cache:rebuild" }, { cwd = root })
  --         print("vendor/bin/drupal cache:rebuild started")
  --       else
  --         print("No drush or drupal console found in project")
  --       end
  --     end, { desc = "Drupal cache rebuild (drush cr or drupal cache:rebuild)" })
  --
  --     -- Keymaps
  --     vim.keymap.set("n", "<leader>cl", ":DrupalLint<CR>", { desc = "Drupal: Run PHPCS on file" })
  --     vim.keymap.set("n", "<leader>cf", ":DrupalFix<CR>", { desc = "Drupal: Run PHPCBF on file" })
  --     vim.keymap.set("n", "<leader>cc", ":DrupalCR<CR>", { desc = "Drupal: Cache Rebuild" })
  --
  --     -- Telescope wrappers (if telescope is installed)
  --     if pcall(require, "telescope.builtin") then
  --       local t = require("telescope.builtin")
  --       vim.api.nvim_create_user_command("DrupalFindTwig", function()
  --         t.live_grep({ default_text = "\\.twig$", search_dirs = { project_root() } })
  --       end, { desc = "Find Twig templates" })
  --
  --       vim.api.nvim_create_user_command("DrupalFindServices", function()
  --         t.live_grep({ default_text = "services.yml", search_dirs = { project_root() } })
  --       end, { desc = "Find services.yml" })
  --     end
  --   end,
  -- },

  -- 4) Optional: ensure mason installs servers commonly used for this preset
  {
    "mason-org/mason.nvim",
    cmd = "Mason",
    opts = {
      ensure_installed = {
        "intelephense",
        "yaml-language-server",
        -- twig-language-server may not be available in mason; install manually if needed
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },

  {
    "jay-babu/mason-nvim-dap.nvim",
    opts = {
      automatic_installation = true,
      ensure_installed = {
        "php-debug-adapter",
      },
    },
  },

  {
    "mfussenegger/nvim-dap",
    dependencies = {
      --   "rcarriga/nvim-dap-ui",
      --   "nvim-neotest/nvim-nio",
      --   "theHamsta/nvim-dap-virtual-text",
    },
    optional = true,
    config = function()
      local dap = require("dap")
      -- local dapui = require("dapui")

      -- The following assumes you've installed the php-debug-adapter using mason.nvim
      dap.adapters.php = {
        type = "executable",
        command = "node",
        args = {
          vim.loop.os_homedir() .. "/.local/share/nvim/mason/packages/php-debug-adapter/extension/out/phpDebug.js",
        },
      }

      dap.configurations.php = {
        -- For DDEV place your luanch.json script in the root of your project:
        --     .vscode/launch.json file.
        -- Follow the DDEV instructions for VSCode:
        --     https://ddev.readthedocs.io/en/stable/users/debugging-profiling/step-debugging/#ide-setup
        -- If you encounter problems, see the DDEV troubleshooting guide:
        --     https://ddev.readthedocs.io/en/stable/users/debugging-profiling/step-debugging/#troubleshooting-xdebug
        -- Here are more related discussions that helped me get up an running:
        --     https://github.com/ddev/ddev/issues/5099
        --     https://github.com/LazyVim/LazyVim/discussions/645
        -- You might need to run `sudo ufw allow 9003` and then restart
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug in Lando (Lando xdebug on)",
          port = 9003,
          pathMappings = {
            ["/app"] = "${workspaceFolder}",
          },
        },
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug in DDEV (ddev xdebug on)",
          port = 9003,
          pathMappings = {
            ["/var/www/html"] = "${workspaceFolder}",
          },
        },
        {
          type = "php",
          request = "launch",
          name = "Listen for Xdebug",
          port = 9003,
        },
        {
          type = "php",
          name = "Listen for XDebug in Docksal",
          request = "launch",
          port = 9000,
          pathMappings = {
            ["/var/www/"] = "${workspaceFolder}",
          },
        },
      }
    end,
  },

  -- 5) snippets (basic Drupal snippet source using luasnip)
  {
    "L3MON4D3/LuaSnip",
    dependencies = { "rafamadriz/friendly-snippets" },
    config = function()
      if not is_drupal_root() then
        return
      end
      local ls = require("luasnip")
      -- example Drupal snippet: hook_form_alter
      ls.add_snippets("php", {
        ls.parser.parse_snippet(
          "hfa",
          [[
/**
 * Implements hook_form_alter().
 */
function ${1:MODULE}_form_alter(&$form, \\Drupal\\Core\\Form\\FormStateInterface $form_state, $form_id) {
  if ($form_id === '${2:form_id}') {
    // ...
  }
}
]]
        ),
      })
    end,
  },

  -- -- 6 Disable formatting on save:
  -- {
  --   "stevearc/conform.nvim",
  --   opts = function(_, opts)
  --     if not is_drupal_root() then
  --       return opts
  --     end
  --
  --     -- Disable format on save
  --     opts.format_on_save = false
  --
  --     -- Optional: disable specific formatters
  --     opts.formatters_by_ft.yaml = {}
  --     opts.formatters_by_ft.yml = {}
  --     opts.formatters_by_ft.php = {} -- already disabled through null-ls/intelephense
  --
  --     return opts
  --   end,
  -- }
}
