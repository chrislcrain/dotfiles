return {
  "mason-org/mason-lspconfig.nvim",
  event = "BufReadPost",
  dependencies = {
    "mason-org/mason.nvim",
    -- "neovim/nvim-lspconfig",
  },
  opts = {
    ensure_installed = {
      "lua_ls",
      "powershell_es",
      "ruff",
      "pylsp",
      "terraformls",
    },
    automatic_installation = true,
  },
  -- config = function()
  --   vim.diagnostic.config({
  --     signs = {
  --       text = {
  --         [vim.diagnostic.severity.ERROR] = "",
  --         [vim.diagnostic.severity.WARN] = "",
  --         [vim.diagnostic.severity.INFO] = "",
  --         [vim.diagnostic.severity.HINT] = "",
  --       },
  --     },
  --     virtual_text = {
  --       prefix = "»",
  --     },
  --     severity_sort = true,
  --     update_in_insert = true,
  --   })
  -- end,
}
