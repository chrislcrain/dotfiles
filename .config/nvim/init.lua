require("plugins")
require("set")

vim.g.mapleader = " "

-- vim.cmd.colorscheme("catppuccin-mocha")
-- vim.cmd [[hi Normal guibg=NONE ctermbg=NONE]]

require('lualine').setup {
  options = {
    theme = 'powerline_dark',  -- Replace with your theme
  },
  sections = {
    lualine_a = {'mode'},
    lualine_b = {'branch'},
    lualine_c = {{'filename', file_status = true, path = 1}},
  },
}

 --require("nvim-tree").setup({
 --  sort_by = "case_sensitive",
 --  view = {
 --    width = 30,
 --  },
 --  renderer = {
 --    group_empty = true,
 --  },
 --  filters = {
 --    dotfiles = true,
 --  },
 --})

require'nvim-web-devicons'.setup {
 color_icons = true;
 default = true;
 strict = true;
 override_by_filename = {
  [".gitignore"] = {
    icon = "",
    color = "#f1502f",
    name = "Gitignore"
  }
 };
 override_by_extension = {
  ["log"] = {
    icon = "",
    color = "#81e043",
    name = "Log"
  }
 };
}

vim.api.nvim_create_autocmd("FileType", {
    pattern = "sql",
    callback = function()
        vim.opt_local.commentstring = "-- %s"
    end,
})
