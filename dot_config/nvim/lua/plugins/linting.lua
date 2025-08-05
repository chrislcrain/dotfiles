return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local lint = require("lint")
    lint.linters_by_ft = {
      -- python = { "ruff" },
      lua = { "luacheck" },
      terraform = { "tflint" },
    }

    vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
      group = lint_augroup,
      callback = function()
        lint.try_lint()
      end,
    })

    vim.keymap.set("n", "<leader>l", function()
      lint.try_lint()
    end, { desc = "Trigger linting for current file" })

    -- lint.linters.pylint.cmd = "poetry run pylint"
    -- lint.linters.pylint.args = { "-f", "json" }
  end,
}
