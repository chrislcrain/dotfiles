return {
  "nvim-treesitter/nvim-treesitter-textobjects",
  branch = "master",
  dependencies = { "nvim-treesitter/nvim-treesitter" },
  init = function()
    -- Disable entire built-in ftplugin mappings to avoid conflicts.
    -- See https://github.com/neovim/neovim/tree/master/runtime/ftplugin
    vim.g.no_plugin_maps = true
  end,
}
