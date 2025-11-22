return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "theHamsta/nvim-dap-virtual-text",
    },

    keys = {
      {
        "<F4>",
        function()
          require("dap").toggle_breakpoint()
        end,
        desc = "DAP Toggle Breakpoint",
      },
      {
        "<F5>",
        function()
          require("dap").continue()
        end,
        desc = "DAP Continue / Play",
      },
      {
        "<F9>",
        function()
          require("dap").step_over()
        end,
        desc = "DAP Step Over",
      },
      {
        "<F10>",
        function()
          require("dap").step_into()
        end,
        desc = "DAP Step Into",
      },
      {
        "<S-F10>",
        function()
          require("dap").step_out()
        end,
        desc = "DAP Step Out",
      }
    },
    -- -- Configure the UI
    -- opts = function(_, opts)
    --   opts.layouts = {
    --     {
    --       position = "bottom",
    --       size = 15,
    --       elements = {
    --         { id = "scopes", size = 1.0 },
    --       },
    --     },
    --     {
    --       position = "right",
    --       size = 40,
    --       elements = {
    --         "repl",
    --         "breakpoints",
    --         "stacks",
    --         "watches",
    --       },
    --     },
    --   }
    -- end,

    opts = function(_, opts)
      local dap = require("dap")
      local dapui = require("dapui")

      -- ---------------------------------------------------------
      -- 🔥 GLOBAL DAP ICONS (Apply to ALL languages)
      -- ---------------------------------------------------------
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticError", linehl = "Visual" })

      -- ---------------------------------------------------------
      -- 🖥️ DAP UI + virtual text (global)
      -- ---------------------------------------------------------
      -- dapui.setup()
      -- require("nvim-dap-virtual-text").setup({
      --   enabled = true,
      --   enabled_commands = true, -- enable commands like DapVirtualTextEnable
      --   highlight_changed_variables = true,
      --   highlight_new_as_changed = true,
      --   show_stop_reason = true,
      --   commented = false, -- create virtual text using comment string
      -- })
      --
      -- dap.listeners.after.event_initialized["dapui_config"] = function()
      --   dapui.open()
      -- end
      -- dap.listeners.before.event_terminated["dapui_config"] = function()
      --   dapui.close()
      -- end
      -- dap.listeners.before.event_exited["dapui_config"] = function()
      --   dapui.close()
      -- end

      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end

      -- ---------------------------------------------------------
      -- ⌨ GLOBAL DAP KEYMAPS (Apply to any adapter)
      -- ---------------------------------------------------------
      -- local map = vim.keymap.set
      --
      -- map("n", "<F4>", function()
      --   dap.toggle_breakpoint()
      -- end, { desc = "DAP Toggle Breakpoint" })
      --
      -- map("n", "<F5>", function()
      --   dap.continue()
      -- end, { desc = "DAP Continue - Play" })
      --
      -- map("n", "<F9>", function()
      --   dap.step_over()
      -- end, { desc = "DAP Step Over" })
      --
      -- map("n", "<F10>", function()
      --   dap.step_into()
      -- end, { desc = "DAP Step Into" })
      --
      -- map("n", "<S-F10>", function()
      --   dap.step_out()
      -- end, { desc = "DAP Step Out" })

      -- map("n", "<leader>dl", function()
      --   dap.run_last()
      -- end, { desc = "DAP Run Last" })
    end,
  },
}
