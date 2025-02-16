vim.keymap.set('n', '<leader>bO', '<cmd>%bd!|e#|bd!#<cr>', { desc = 'Delete all buffers except current' })

vim.keymap.set('n', '-', '<CMD>lua MiniFiles.open();<CR>', { desc = 'Open MiniFiles' })
