return {
  "stevearc/conform.nvim",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local conform = require("conform")
    conform.setup({
      formatters_by_ft = {
        javascript = { { "prettier", args = { "--prose-wrap", "never" } } },
        typescript = { { "prettier", args = { "--prose-wrap", "never" } } },
        javascriptreact = { { "prettier", args = { "--prose-wrap", "never" } } },
        typescriptreact = { { "prettier", args = { "--prose-wrap", "never" } } },
        svelte = { { "prettier", args = { "--prose-wrap", "never" } } },
        css = { { "prettier", args = { "--prose-wrap", "never" } } },
        html = { { "prettier", args = { "--prose-wrap", "never" } } },
        json = { { "prettier", args = { "--prose-wrap", "never" } } },
        yaml = { { "prettier", args = { "--prose-wrap", "never" } } },
        markdown = { { "prettier", args = { "--prose-wrap", "never" } } },
        graphql = { { "prettier", args = { "--prose-wrap", "never" } } },
        liquid = { { "prettier", args = { "--prose-wrap", "never" } } },
        lua = { "stylua" },
        python = { "ruff" },
      },
      format_on_save = {
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      },
    })
    vim.keymap.set({ "n", "v" }, "<leader>fmt", function()
      conform.format({
        lsp_fallback = true,
        async = false,
        timeout_ms = 1000,
      })
    end, { desc = "Format file or range (in visual mode)" })
  end,
}
