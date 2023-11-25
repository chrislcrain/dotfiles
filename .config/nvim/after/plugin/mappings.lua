-- vim.keymap.set('v', '<Leader>/', ':s/^/# /<CR>', { noremap = true, silent = true })
vim.keymap.set('v', '<Leader>/', ':Commentary<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<Leader>/', ':Commentary<CR>', { noremap = true, silent = true })
vim.keymap.set("n","<leader>pv", vim.cmd.Ex)
vim.keymap.set("n","<leader>u", vim.cmd.UndotreeToggle)
vim.keymap.set("n","<F2>", ':FloatermToggle<CR>', { noremap = true, silent = true })
vim.keymap.set('n', 'Ï', ':TerraformFmt<CR>', { noremap = true, silent = true })
vim.keymap.set("t","<F2>", "<C-\\><C-n>:FloatermToggle<CR>", { noremap = true, silent = true })
vim.keymap.set('i', '(','()<Esc>i', {noremap = true})
vim.keymap.set('i', '{','{}<Esc>i', {noremap = true})
vim.keymap.set('i', '{<CR>','{<CR>}<Esc>O', {noremap = true})
vim.keymap.set('i', '[','[]<Esc>i', {noremap = true})
vim.keymap.set('i', '<','<><Esc>i', {noremap = true})
vim.keymap.set('i', '\'','\'\'<Esc>i', {noremap = true})
vim.keymap.set('i', '\"','\"\"<Esc>i', {noremap = true})
