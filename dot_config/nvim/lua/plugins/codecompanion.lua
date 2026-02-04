return {
  enabled = true,
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.diff",
    "j-hui/fidget.nvim",
  },
  config = function()
    -- Keymap: toggle chat
    vim.keymap.set("n", "<leader>ch", "<cmd>CodeCompanionChat Toggle<CR>")

    -- Fidget (LSP progress)
    require("fidget").setup({
      progress = {
        ignore = { "basedpyright" },
      },
    })

    require("codecompanion").setup({
      display = {
        chat = {
          start_in_insert_mode = false,
          intro_message = "Beep boop! 🤖 Happy coding!",
          show_header_separator = false,
          separator = "=",
          keymaps = {
            choose_adapter = "<leader>ca",
          },
        },
        diff = {
          enabled = true,
          layout = "vertical", -- vertical|horizontal
          opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
          provider = "mini_diff", -- default|mini_diff
        },
      },

      strategies = {
        adapter = "copilot",

        chat = {
          -- Automatically include the current file in context
          default_context = { "file" },

          slash_commands = {
            file = {
              description = "Select files using Telescope",
              opts = {
                provider = "telescope", -- or 'default', 'mini_pick', 'fzf_lua', 'snacks'
                contains_code = true,
                multi_select = true,
              },
            },

            buffer = {
              description = "Select a buffer using Telescope",
              opts = {
                provider = "telescope",
                contains_code = true,
              },
            },
          },
        },
      },

      inline = {
        adapter = "copilot",
      },
    })
  end,
}
