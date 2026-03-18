require('trouble').setup({})

vim.keymap.set('n', '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>')
vim.keymap.set('n', '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>')
vim.keymap.set('n', '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>')
vim.keymap.set('n', '<leader>xq', '<cmd>Trouble qflist toggle<cr>')
