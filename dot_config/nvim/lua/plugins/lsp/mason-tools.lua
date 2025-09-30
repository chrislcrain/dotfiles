return {
  "WhoIsSethDaniel/mason-tool-installer.nvim",
  dependencies = {
    "mason-org/mason.nvim",
  },
  opts = {
    ensure_installed = {
      "debugpy",
      "luacheck",
      "prettier",
      "stylua",
      "tflint",
      "lua_ls",
    },
    run_on_start = true,
    automatic_installation = true,
  },
}
