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
      -- "ruff",
      "pylsp",
      "terraformls",
    },
    automatic_installation = true,
  },
}
