return {
  "windwp/nvim-ts-autotag",
  "mbbill/undotree",
  "tpope/vim-fugitive",
  "tpope/vim-surround",
  {
    -- Pane/split navigation with <C-h/j/k/l>.
    -- On Coder, vim-herdr-navigation owns these keys, so vim-tmux-navigator's
    -- own maps must be disabled to avoid a clash. Off Coder (e.g. macOS) herdr
    -- isn't installed, so we fall back to vim-tmux-navigator's default maps —
    -- otherwise the keys would be left unmapped and navigation would break.
    "christoomey/vim-tmux-navigator",
    lazy = false,
    init = function()
      -- herdr installs plugins under a commit-hash-suffixed dir; glob for it.
      -- Resolve here (before plugin load) so we know whether to suppress the
      -- default mappings that plugin/tmux_navigator.vim installs at load time.
      vim.g._herdr_nav = vim.fn.glob(
        "~/.config/herdr/plugins/github/vim-herdr-navigation-*/editor/nvim.lua",
        true,
        true
      )[1]
      if vim.g._herdr_nav then
        vim.g.tmux_navigator_no_mappings = 1
      end
    end,
    config = function()
      if vim.g._herdr_nav then
        dofile(vim.g._herdr_nav)
      end
    end,
  },
  "voldikss/vim-floaterm",
}
