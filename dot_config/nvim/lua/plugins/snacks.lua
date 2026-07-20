return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile = { enabled = true },
    indent = {
      enabled = true,
      indent = { char = "┊" }, -- match the old indent-blankline glyph
      scope = { char = "┊" },
    },
    input = { enabled = true },
    notifier = { enabled = true }, -- vim.notify UI (replaced nvim-notify/noice)
  },
  keys = {
    {
      "<leader>dn",
      function()
        require("snacks").notifier.hide()
      end,
      desc = "Dismiss all notifications",
    },
  },
}
