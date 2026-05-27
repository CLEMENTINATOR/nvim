vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
  callback = function()
    vim.highlight.on_yank()
  end,
})

vim.api.nvim_create_autocmd('VimResized', {
  desc = 'Resize splits when resizing the window',
  group = vim.api.nvim_create_augroup('kickstart-resize-splits', { clear = true }),
  callback = function()
    vim.cmd 'wincmd ='
  end,
})

vim.api.nvim_create_autocmd('VimEnter', {
  callback = require('session').ensure_session,
})
