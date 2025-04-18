return {
  "nvim-telescope/telescope.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  keys = {
    { "<leader>/", false },
    { "<leader>ff", "<cmd>Telescope find_files hidden=true no_ignore=true<cr>", desc = "Find Files" },
    -- { "<C-p>", "<cmd>Telescope git_files <cr>", desc = "Search git files" },
    { "<leader>fs", "<cmd>Telescope live_grep<cr>", desc = "Live grep search" },
  },
  opts = {
    defaults = {
      layout_strategy = "horizontal",
      layout_config = { prompt_position = "top" },
      sorting_strategy = "ascending",
      winblend = 0,
      mappings = {
        i = {
          ["<C-a>"] = require("telescope.actions").toggle_selection,
        },
        n = {
          ["<C-a>"] = require("telescope.actions").toggle_selection,
        },
      },
    },
  },
  pickers = {
    find_files = {
      find_command = { "fd", "--type", "f", "--hidden", "--exclude", ".git", "--no-ignore-vcs" },
    },
  },
}
