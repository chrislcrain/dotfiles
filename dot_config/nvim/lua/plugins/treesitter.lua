-- nvim-treesitter `main` branch (the rewrite).
-- Requires Neovim 0.12+ and the tree-sitter CLI (parsers are compiled locally).
-- The old `require("nvim-treesitter.configs").setup()` API is gone: parsers are
-- installed explicitly and highlighting/folds attach natively per buffer.
return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  lazy = false,
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  config = function()
    -- Async install; missing parsers land shortly after first launch.
    require("nvim-treesitter").install({
      "regex",
      "json",
      "javascript",
      "typescript",
      "tsx",
      "yaml",
      "html",
      "css",
      "prisma",
      "markdown",
      "markdown_inline",
      "svelte",
      "graphql",
      "bash",
      "lua",
      "vim",
      "dockerfile",
      "gitignore",
      "query",
      "vimdoc",
      "c",
      "python",
      "powershell",
      "hcl",
      "terraform", -- .tf highlighting was previously provided by vim-terraform
    })

    -- Fold behavior previously configured via nvim-ufo
    vim.o.foldcolumn = "0"
    vim.o.foldlevel = 99
    vim.o.foldlevelstart = 99
    vim.o.foldenable = true

    -- Attach treesitter highlighting + folds whenever a parser exists for the
    -- buffer's filetype (vim.treesitter.start errors when there is none).
    vim.api.nvim_create_autocmd("FileType", {
      group = vim.api.nvim_create_augroup("treesitter_attach", { clear = true }),
      callback = function(ev)
        if pcall(vim.treesitter.start, ev.buf) then
          vim.wo.foldmethod = "expr"
          vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
        end
      end,
    })

    require("nvim-ts-autotag").setup()
  end,
}
