declare_file("keymaps.lua")


vim.keymap.set('n', '<Space>', '<Nop>')
vim.keymap.set('n', '<Space>', ':w <CR> :source %<CR>')

vim.keymap.set('n', '<leader>y', '\"*y') -- yank in clipboard
vim.keymap.set('n', '<leader>p', '\"+p') -- paste from clipboard

-- vim.keymap.set('n', 'n', 'nzz') 
-- vim.keymap.set('n', 'N', 'Nzz')

vim.keymap.set('i', 'jk', '<Esc>')

vim.keymap.set('n', '<C-h>', '<C-w>h')
vim.keymap.set('n', '<C-j>', '<C-w>j')
vim.keymap.set('n', '<C-k>', '<C-w>k')
vim.keymap.set('n', '<C-l>', '<C-w>l')

