-- Execute the following command to start uvicorn and allow nvim-dap-python to attach the debugger:
-- python -m debugpy --listen 5678 --wait-for-client -m uvicorn app.main:app --host 0.0.0.0 --port 8000 --reload
-- In nvim, use the command `VenvSelect` to select the virtual environment.

return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "mfussenegger/nvim-dap-python",
    "linux-cultist/venv-selector.nvim",
  },
  config = function()
    local dap = require("dap")
    local venv = require("venv-selector")

    -- Dynamically resolve Python interpreter
    local python_path = venv.python() or "python"

    -- Set the breakpoint
    vim.cmd("highlight DapBreakpointText guifg=#E82424")
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DapBreakpointText", linehl = "", numhl = "" })
    -- 🔥 CUSTOM DEBUG ICONS
    vim.fn.sign_define("DapBreakpoint", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "", texthl = "DiagnosticWarn", linehl = "", numhl = "" })
    vim.fn.sign_define("DapBreakpointRejected", { text = "", texthl = "DiagnosticError", linehl = "", numhl = "" })
    vim.fn.sign_define("DapStopped", { text = "", texthl = "DiagnosticInfo", linehl = "Visual", numhl = "" })

    dap.adapters.python = {
      type = "server",
      host = "127.0.0.1",
      port = 5678,
      executable = {
        command = python_path,
        args = { "-m", "debugpy.adapter" },
      },
    }

    dap.configurations.python = {
      {
        name = "Attach to FastAPI",
        type = "python",
        request = "attach",
        justMyCode = false,
        host = "127.0.0.1",
        port = 5678,
        pathMappings = {
          { localRoot = vim.fn.getcwd(), remoteRoot = "." },
        },
      },
    }

    -- Auto-reload DAP python path whenever selecting a new venv
    vim.api.nvim_create_autocmd("User", {
      pattern = "VenvSelectActivated",
      callback = function()
        local new_path = venv.python()
        if new_path then
          dap.adapters.python.executable.command = new_path
          print("DAP Python updated to: " .. new_path)
        end
      end,
    })
  end,
}
