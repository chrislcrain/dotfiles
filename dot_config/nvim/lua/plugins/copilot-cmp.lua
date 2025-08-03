return {
  enabled = true,
  "zbirenbaum/copilot-cmp",
  lazy = true,
  dependencies = { "zbirenbaum/copilot.lua" },
  config = function()
    require("copilot_cmp").setup()
  end,
}
