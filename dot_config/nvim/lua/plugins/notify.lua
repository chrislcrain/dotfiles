return {
  "rcarriga/nvim-notify",
  enabled = true,
  config = function()
    vim.notify = require("notify").setup({
      background_colour = "#000000",
    })
  end,
}
