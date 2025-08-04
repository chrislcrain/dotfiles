return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    { "antosha417/nvim-lsp-file-operations", config = true },
    { "folke/neodev.nvim", opts = {} },
  },
  config = function()
    local lspconfig = require("lspconfig")
    local mason_lspconfig = require("mason-lspconfig")
    local cmp_nvim_lsp = require("cmp_nvim_lsp")
    local opts = { noremap = true, silent = true }
    local keymap = vim.keymap
    local on_attach = function(client, bufnr)
      opts.buffer = bufnr
      -- set keybinds
      opts.desc = "Show LSP references"
      keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

      opts.desc = "Go to declaration"
      keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

      opts.desc = "Show LSP definitions"
      keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

      opts.desc = "Show documentation for what is under cursor"
      keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

      opts.desc = "Restart LSP"
      keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
    end

    -- used to enable autocompletion (assign to every lsp server config)
    local capabilities = cmp_nvim_lsp.default_capabilities()

    -- Configure diagnostic signs and inline diagnostics
    vim.diagnostic.config({
      virtual_text = {
        format = function(diagnostic)
          local severity_prefix = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN] = " ",
            [vim.diagnostic.severity.INFO] = " ",
            [vim.diagnostic.severity.HINT] = " ",
          }
          -- Return the prefix and the diagnostic message
          return string.format("%s%s", severity_prefix[diagnostic.severity], diagnostic.message)
        end,
        spacing = 2, -- Add spacing between the diagnostic text and the line
      },
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.INFO] = "",
          [vim.diagnostic.severity.HINT] = "",
        },
      },
      underline = true, -- Underline diagnostics in the code
      update_in_insert = true, -- Update diagnostics while in insert mode
      severity_sort = true, -- Sort diagnostics by severity
      float = { enabled = false },
    })

    -- Default configuration for all LSP servers
    vim.lsp.config("*", {
      on_attach = on_attach,
      capabilities = capabilities,
    })

    -- pylsp with custom settings
    vim.lsp.config("pylsp", {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        pylsp = {
          plugins = {
            ruff = { enabled = true },
            mccabe = { enabled = false },
            pyflakes = { enabled = false },
            pycodestyle = {
              enabled = true,
              ignore = { "E501" },
            },
          },
        },
      },
    })

    -- Terraform Language Server with custom filetypes
    vim.lsp.config("terraformls", {
      on_attach = on_attach,
      capabilities = capabilities,
      filetypes = { "terraform" },
    })

    -- Lua Language Server with custom settings
    vim.lsp.config("lua_ls", {
      on_attach = on_attach,
      capabilities = capabilities,
      settings = {
        Lua = {
          diagnostics = {
            globals = { "vim" },
          },
          completion = {
            callSnippet = "Replace",
          },
          workspace = {
            library = {
              [vim.fn.expand("$VIMRUNTIME/lua")] = true,
              [vim.fn.stdpath("config") .. "/lua"] = true,
            },
          },
        },
      },
    })

    -- PowerShell Editor Services with custom bundle path and shell
    vim.lsp.config("powershell_es", {
      on_attach = on_attach,
      bundle_path = vim.fn.stdpath("data") .. "/mason/packages/powershell-editor-services",
      shell = "pwsh",
    })
  end,
}
