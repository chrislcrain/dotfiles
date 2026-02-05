return {
  enabled = true,
  version = "18.5.1",
  "olimorris/codecompanion.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-treesitter/nvim-treesitter",
    "echasnovski/mini.diff",
    "j-hui/fidget.nvim",
  },
  config = function()
    vim.keymap.set("n", "<leader>ch", "<cmd>CodeCompanionChat Toggle<CR>") -- toggle chat
    require("fidget").setup({
      progress = {
        ignore = { "basedpyright" },
      },
    })
    require("codecompanion").setup({
      rules = {
        default = {
          description = "Collection of common files for all projects",
          files = {
            ".clinerules",
            ".cursorrules",
            ".goosehints",
            ".rules",
            ".windsurfrules",
            ".github/copilot-instructions.md",
            "AGENT.md",
            "AGENTS.md",
            { path = "CLAUDE.md", parser = "claude" },
            { path = "CLAUDE.local.md", parser = "claude" },
            -- { path = "~/.claude/CLAUDE.md", parser = "claude" },
          },
        },
      },
      display = {
        chat = {
          variables = {
            ["buffer"] = {
              opts = {
                -- Always sync the buffer by sharing its "diff"
                -- Or choose "all" to share the entire buffer
                default_params = "diff",
              },
            },
          },
          icons = {
            chat_context = "📎️",
            chat_fold = " ",
          },
          auto_scroll = true,
          show_context = true,
          fold_context = false,
          show_reasoning = true,
          fold_reasoning = true,
          show_settings = true,
          start_in_insert_mode = false,
          intro_message = "Beep boop! 🤖 Happy coding!",
          show_header_separator = false,
          show_tools_processing = true,
          show_token_count = true,
          separator = "-",
          keymaps = {
            choose_adapter = "<leader>ca",
          },
        },
        diff = {
          enabled = true,
          -- close_chat_at = 240, -- Close an open chat buffer if the total columns of your display are less than...
          layout = "vertical", -- vertical|horizontal split for default provider
          opts = { "internal", "filler", "closeoff", "algorithm:patience", "followwrap", "linematch:120" },
          provider = "default", -- default|mini_diff
        },
      },
      interactions = {
        chat = {
          default_context = { "buffer" },
          adapter = "copilot",
        },
        inline = { adapter = "copilot" },
      },
    })
  end,
}
