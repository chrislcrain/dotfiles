return {
  "nvim-treesitter/nvim-treesitter",
  lazy = false,
  branch = "main",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate",
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local ts_langs = {
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
    }

    local treesitter = require("nvim-treesitter")

    for _, lang in ipairs(ts_langs) do
      local ok = pcall(vim.treesitter.language.inspect, lang)
      if not ok then
        -- Parser not available; install just this one.
        treesitter.install({ lang })
      end
    end

    -- require("nvim-treesitter").install(ts_langs, {
    --   summary = false,
    -- })

    -- Tree-sitter folds
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
    vim.opt.foldenable = true
    vim.opt.foldlevel = 99

    -- Autocmd group for starting Tree-sitter via vim.treesitter API
    local ts_group = vim.api.nvim_create_augroup("MyTreesitterMain", { clear = true })

    vim.api.nvim_create_autocmd("FileType", {
      group = ts_group,
      pattern = ts_langs,
      callback = function(args)
        vim.treesitter.start(args.buf)
      end,
    })

    -- nvim-ts-autotag defaults.
    require("nvim-ts-autotag").setup()
  end,
}
