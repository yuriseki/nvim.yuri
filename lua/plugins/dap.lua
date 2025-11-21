return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "theHamsta/nvim-dap-virtual-text",
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

    config = function()
      local dap = require("dap")
      local dapui = require("dapui")

      -- ---------------------------------------------------------
      -- 🔥 GLOBAL DAP ICONS (Apply to ALL languages)
      -- ---------------------------------------------------------
      vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn" })
      vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError" })
      vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticInfo", linehl = "Visual" })

      -- ---------------------------------------------------------
      -- 🖥️ DAP UI + virtual text (global)
      -- ---------------------------------------------------------
      dapui.setup()
      require("nvim-dap-virtual-text").setup({
        enabled = true,
        enabled_commands = true, -- enable commands like DapVirtualTextEnable
        highlight_changed_variables = true,
        highlight_new_as_changed = true,
        show_stop_reason = true,
        commented = false, -- create virtual text using comment string
      })

      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end

      -- ---------------------------------------------------------
      -- ⌨ GLOBAL DAP KEYMAPS (Apply to any adapter)
      -- ---------------------------------------------------------
      local map = vim.keymap.set
      map("n", "<F5>", function()
        dap.continue()
      end, { desc = "DAP Continue" })
      map("n", "<F10>", function()
        dap.step_over()
      end, { desc = "DAP Step Over" })
      map("n", "<F11>", function()
        dap.step_into()
      end, { desc = "DAP Step Into" })
      map("n", "<S-F11>", function()
        dap.step_out()
      end, { desc = "DAP Step Out" })
      map("n", "<F9>", function()
        dap.toggle_breakpoint()
      end, { desc = "DAP Toggle Breakpoint" })

      map("n", "<leader>db", function()
        dap.toggle_breakpoint()
      end, { desc = "DAP Toggle Breakpoint" })
      map("n", "<leader>dB", function()
        dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end, { desc = "DAP Conditional Breakpoint" })

      map("n", "<leader>du", function()
        dapui.toggle()
      end, { desc = "DAP UI Toggle" })
      map("n", "<leader>dr", function()
        dap.repl.open()
      end, { desc = "DAP REPL" })
      map("n", "<leader>dl", function()
        dap.run_last()
      end, { desc = "DAP Run Last" })
    end,
  },
}
