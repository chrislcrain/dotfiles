return {
  "zbirenbaum/copilot.lua",
  config = function()
    require("copilot").setup({
      panel = {
        enabled = false,
        auto_refresh = false,
        keymap = {
          jump_prev = "[[",
          jump_next = "]]",
          accept = "<CR>",
          refresh = "gr",
          open = "<M-CR>",
        },
        layout = {
          position = "bottom", -- | top | left | right | horizontal | vertical
          ratio = 0.4,
        },
      },
      suggestion = {
        enabled = false,
        auto_trigger = false,
        hide_during_completion = true,
        debounce = 75,
        keymap = {
          accept = "<M-l>",
          accept_word = false,
          accept_line = false,
          next = "<M-]>",
          prev = "<M-[>",
          dismiss = "<C-]>",
        },
      },
      filetypes = {
        yaml = false,
        markdown = false,
        help = false,
        gitcommit = false,
        gitrebase = false,
        hgcommit = false,
        svn = false,
        cvs = false,
        ["."] = false,
        python = true,
        terraform = true,
        powershell = true,
      },
      logger = {
        file = vim.fn.stdpath("log") .. "/copilot-lua.log",
        file_log_level = vim.log.levels.OFF,
        print_log_level = vim.log.levels.WARN,
        trace_lsp = "off", -- "off" | "messages" | "verbose"
        trace_lsp_progress = false,
        log_lsp_messages = false,
      },
      copilot_node_command = "node", -- Node.js version must be > 18.x
      workspace_folders = {},
      copilot_model = "", -- Current LSP default is gpt-35-turbo, supports gpt-4o-copilot
      root_dir = function()
        return vim.fs.dirname(vim.fs.find(".git", { upward = true })[1])
      end,
      should_attach = nil, -- type is fun(bufnr: integer, bufname: string): boolean
      server_opts_overrides = {},
    })
  end,
}
