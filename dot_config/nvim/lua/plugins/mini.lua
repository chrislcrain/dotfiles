return {
  "echasnovski/mini.diff",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  version = "false",
  config = function()
    local diff = require("mini.diff")
    diff.setup({
      -- Disabled by default
      source = diff.gen_source.none(),
    })
  end,
}
