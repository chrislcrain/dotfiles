return {
  "mfussenegger/nvim-dap",
  dependencies = {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap-python",
    "nvim-lua/plenary.nvim",
    "rcarriga/nvim-dap-ui",
    "rcarriga/nvim-notify",
    "nvim-neotest/nvim-nio",
    "Willem-J-an/nvim-dap-powershell",
    "theHamsta/nvim-dap-virtual-text",
    "TheLeoP/powershell.nvim",
    {
      "m00qek/baleia.nvim",
      lazy = true,
      tag = "v1.4.0",
    },
  },
  config = function()
    local mason_registry = require("mason-registry")
    if mason_registry.is_installed("powershell-editor-services") then
      local dap_ps = require("dap-powershell")
      dap_ps.setup()
    else
      vim.notify("PowerShell Editor Services (powershell_es) is not installed.", vim.log.levels.WARN)
    end

    -- vim.print(vim.inspect(debugpy_pkg))
    -- local install_path = debugpy_pkg:get_install_path()
    local adapter_python_path = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"

    local dap = require("dap")
    local dapui = require("dapui")
    local nvdt = require("nvim-dap-virtual-text")
    local dap_py = require("dap-python")
    nvdt.setup()
    dapui.setup()

    -- Get the path to the Poetry environment for the current project
    -- local handle = io.popen("poetry env info --path")
    -- local poetry_venv_path = handle:read("*a"):gsub("\n", "") .. "/bin/python"
    -- handle:close()
    dap_py.setup(adapter_python_path)

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
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open({})
      -- dap_ps.correct_repl_colors()
    end
    vim.keymap.set("n", "<leader>dt", dapui.toggle)
    vim.keymap.set("n", "<leader>db", dap.toggle_breakpoint)
    vim.keymap.set("n", "<leader>dc", dap.continue)
    vim.keymap.set("n", "<leader>ds", dap.terminate)
    vim.keymap.set("n", "<leader>dr", dap.restart)
    -- vim.keymap.set("n", "<leader>dr", function()
    --   dapui.open({ reset = true })
    -- end)
  end,
}
