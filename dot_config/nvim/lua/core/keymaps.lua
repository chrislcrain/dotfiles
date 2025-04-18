vim.g.mapleader = " "

local map = vim.keymap.set
map("v", "<Leader>/", ":Commentary<CR>", { noremap = true, silent = true })
map("n", "<Leader>/", ":Commentary<CR>", { noremap = true, silent = true })
map("n", "<Leader>csr", '"+y<CR>', { noremap = true, silent = true })
map("v", "<Leader>csr", '"+y<CR>', { noremap = true, silent = true })
map("n", "<leader>u", vim.cmd.UndotreeToggle)
map("n", "tff", ":TerraformFmt<CR>", { noremap = true, silent = true })

-- -- Floaterm keymaps
_G.toggle_floaterm = function()
  vim.cmd("FloatermToggle")
end
-- Toggle Floaterm with F2 in normal mode
map("n", "<F2>", ":FloatermToggle<CR>", { noremap = true, silent = true })
-- Toggle Floaterm with F2 in terminal mode
map("t", "<F2>", "<C-\\><C-n>:lua _G.toggle_floaterm()<CR>", { noremap = true, silent = true })

-- Move line up with Option + k
map("n", "<A-k>", ":m .-2<CR>==", { noremap = true, silent = true })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })
--
-- Move line down with Option + j
map("n", "<A-j>", ":m .+1<CR>==", { noremap = true, silent = true })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })

-- Remove highlights after using find
map("n", "<Leader>cc", ":nohl<CR>", { noremap = true, silent = true })

-- Indent text
map("v", "<Tab>", ">gv", { noremap = true, silent = true })
map("v", "<S-Tab>", "<gv", { noremap = true, silent = true })
