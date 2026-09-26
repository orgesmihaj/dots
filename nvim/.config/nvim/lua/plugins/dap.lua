return {
  "mfussenegger/nvim-dap",
  version = "0.10.0",
  keys = {
    { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
    {
      "<leader>dB",
      function()
        require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: "))
      end,
      desc = "Set conditional breakpoint",
    },
    { "<leader>dc", function() require("dap").continue() end, desc = "Debug continue or start" },
    { "<leader>dp", function() require("dap").pause() end, desc = "Debug pause" },
    { "<leader>dn", function() require("dap").step_over() end, desc = "Debug step over" },
    { "<leader>di", function() require("dap").step_into() end, desc = "Debug step into" },
    { "<leader>do", function() require("dap").step_out() end, desc = "Debug step out" },
    { "<leader>dt", function() require("dap").terminate() end, desc = "Debug terminate" },
    { "<leader>dr", function() require("dap").repl.toggle() end, desc = "Toggle debug REPL" },
    { "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Debug hover evaluation" },
  },
  config = function()
    local dap = require("dap")

    vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DiagnosticError" })
    vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DiagnosticWarn" })
    vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DiagnosticInfo", linehl = "Visual" })

    dap.adapters.php = {
      type = "executable",
      command = "php-debug-adapter",
    }

    dap.configurations.php = {
      {
        type = "php",
        request = "launch",
        name = "Listen for Xdebug",
        port = 9003,
      },
    }

    local launchjs = vim.fn.getcwd() .. "/.vscode/launch.json"
    if vim.fn.filereadable(launchjs) == 1 then
      require("dap.ext.vscode").load_launchjs(launchjs, { php = { "php" } })
    end
  end,
}
