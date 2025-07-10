return {
  "rcarriga/nvim-notify",
  enabled = false,
  config = function()
    vim.notify = require("notify").setup({
      background_colour = "#000000",
    })
  end,
}
