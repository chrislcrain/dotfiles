return {
  "j-hui/fidget.nvim",
  config = function()
    require("fidget").setup({
      progress = {
        ignore = { "basedpyright" },
      },
    })
  end,
}
