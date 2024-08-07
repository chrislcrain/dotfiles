return {
  "nvim-telescope/telescope.nvim",
  keys = {
    { "<leader>/", false },
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
    -- { "<C-p>", "<cmd>Telescope git_files <cr>", desc = "Search git files" },
    { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Live grep search" },
  },
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
    },
  },
}
