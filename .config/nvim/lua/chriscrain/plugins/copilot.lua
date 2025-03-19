return {
  "zbirenbaum/copilot.lua",
  config = function()
    require("copilot").setup({
      suggestion = { enabled = false },
      panel = { enabled = false },
      filetypes = {
        python = true,
        powershell = true,
        lua = true,
        ["*"] = false,
      },
    })
  end,
}
