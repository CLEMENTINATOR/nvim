vim.keymap.set('n', '<leader>bO', '<cmd>%bd!|e#|bd!#<cr>', { desc = 'Delete all buffers except current' })

vim.keymap.set('n', '-', '<CMD>lua MiniFiles.open(vim.api.nvim_buf_get_name(0)); MiniFiles.reveal_cwd()<CR>', { desc = 'Open MiniFiles' })
