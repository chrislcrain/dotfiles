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
    },
    -- v2 note: automatic_enable (default true) is what calls vim.lsp.enable()
    -- for installed servers; automatic_installation was removed in v2.
  },
}
