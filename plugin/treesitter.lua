vim.pack.add {
  { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
}

require('nvim-treesitter').setup()

local ensure_installed = { 'bash', 'c', 'html', 'lua', 'markdown', 'vim', 'vimdoc', 'rust', 'typescript', 'go' }
require('nvim-treesitter').install(ensure_installed)

vim.api.nvim_create_autocmd('FileType', {
  callback = function(ev)
    local lang = vim.treesitter.language.get_lang(ev.match) or ev.match
    if pcall(vim.treesitter.language.inspect, lang) then
      if not vim.b[ev.buf].ts_highlight then
        vim.treesitter.start(ev.buf)
      end
    elseif vim.list_contains(require('nvim-treesitter').get_available(), lang) then
      vim.print('Installing treesitter parser for ' .. lang)
      require('nvim-treesitter').install(lang)
    end
  end,
})

vim.keymap.set('n', '<C-space>', function()
  vim.cmd 'normal! v'
  require('vim.treesitter._select').select_parent(1)
end, { desc = 'Start treesitter incremental selection' })

vim.keymap.set('x', '<C-space>', function()
  require('vim.treesitter._select').select_parent(1)
end, { desc = 'Expand treesitter selection to parent node' })

vim.keymap.set('x', '<bs>', function()
  require('vim.treesitter._select').select_child(1)
end, { desc = 'Shrink treesitter selection to child node' })

vim.treesitter.language.register('markdown', { 'mdx' })

require('treesitter-context').setup { max_lines = 8 }

require('nvim-treesitter-textobjects').setup {
  move = {
    enable = true,
    set_jumps = true,
    goto_next_start = { [']m'] = '@function.outer' },
    goto_previous_start = { ['[m'] = '@function.outer' },
  },
}
