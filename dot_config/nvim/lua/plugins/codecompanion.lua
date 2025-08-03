return {
  enabled = true,
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    -- "echasnovski/mini.diff",
  },
  config = function()
    vim.keymap.set("n", "<leader>ch", "<cmd>CodeCompanionChat Toggle<CR>", opts) -- toggle chat
    require("codecompanion").setup({
      display = {
        chat = {
          start_in_insert_mode = false,
          intro_message = "Beep boop! 🤖 Happy coding!",
          show_header_separator = false,
          separator = "=",
        },
        diff = {
          enabled = true,
          -- close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
          layout = "vertical", -- vertical|horizontal split for default provider
          opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
          provider = "mini_diff", -- default|mini_diff
        },
      },
      strategies = {
        chat = {
          slash_commands = {
            ["file"] = {
              -- Location to the slash command in CodeCompanion
              callback = "strategies.chat.slash_commands.file",
              description = "Select files using Telescope",
              opts = {
                provider = "telescope", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
                contains_code = true,
                multi_select = true, -- Enable multi-selection
              },
            },
          },
          ["buffer"] = {
            description = "Select a buffer using Telescope",
            opts = {
              provider = "telescope", -- Other options include 'default', 'mini_pick', 'fzf_lua', snacks
              contains_code = true,
            },
          },
        },
        adapter = "copilot",
      },
      inline = { adapter = "copilot" },
    })
    vim.keymap.set("n", "<C-Space>", "<cmd>CodeCompanionChat Slash file<CR>", opts) -- multi-select files
  end,
}
