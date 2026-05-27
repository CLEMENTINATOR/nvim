vim.pack.add({
  'https://github.com/stevearc/conform.nvim',
})

require('conform').setup({
  notify_on_error = true,
  format_on_save = true,
  default_format_opts = {
    timeout_ms = 1000,
    lsp_format = 'fallback',
  },
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'isort', lsp_format = 'last' },
    javascript = { 'prettier', timeout_ms = 2000 },
    typescript = { 'prettier', timeout_ms = 2000 },
    typescriptreact = { 'prettier', timeout_ms = 2000 },
    cmake = { 'gersemi' },
    markdown = { 'prettier' },
    mdx = { 'prettier', timeout_ms = 2000 },
    toml = { 'taplo' },
  },
})

vim.keymap.set('', '<leader>f', function()
  require('conform').format({ async = true, lsp_format = 'fallback' })
end, { desc = '[F]ormat buffer' })
