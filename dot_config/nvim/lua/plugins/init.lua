return {
  "windwp/nvim-ts-autotag",
  "mbbill/undotree",
  "tpope/vim-fugitive",
  "tpope/vim-surround",
  {
    -- vim-herdr-navigation owns <C-h/j/k/l>; it falls back to tmux/wincmd
    -- outside herdr, so vim-tmux-navigator's own maps stay disabled.
    "christoomey/vim-tmux-navigator",
    lazy = false,
    init = function()
      vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
      -- herdr installs plugins under a commit-hash-suffixed dir; glob for it
      local nav = vim.fn.glob(
        "~/.config/herdr/plugins/github/vim-herdr-navigation-*/editor/nvim.lua",
        true,
        true
      )[1]
      if nav then
        dofile(nav)
      end
    end,
  },
  "voldikss/vim-floaterm",
}
