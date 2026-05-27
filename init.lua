vim.loader.enable()

vim.g.mapleader = ' '
vim.g.maplocalleader = ' '

require 'options'
require 'commands'
require 'autocmds'
require 'keymaps'
require 'term'
require 'session'
require 'diagnostics'

vim.g.gruvbox_material_transparent_background = 1
vim.g.copilot_node_command = vim.fn.trim(vim.fn.system 'fnm exec --using=22 which node')

vim.api.nvim_create_user_command('PackClean', function()
  local orphans = vim
    .iter(vim.pack.get(nil, { info = false }))
    :filter(function(p)
      return not p.active
    end)
    :map(function(p)
      return p.spec.name
    end)
    :totable()
  if #orphans > 0 then
    vim.pack.del(orphans)
    vim.notify('Removed: ' .. table.concat(orphans, ', '))
  else
    vim.notify 'No orphaned plugins found'
  end
end, {})

vim.api.nvim_create_user_command('PackUpdate', function()
  vim.pack.update()
end, {})

vim.api.nvim_create_user_command('PackSync', function()
  vim.pack.update(nil, { target = 'lockfile' })
end, {})

vim.api.nvim_create_user_command('PackStatus', function()
  vim.pack.update(nil, { offline = true })
end, {})

vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'nvim-treesitter' and (kind == 'install' or kind == 'update') then
      if not ev.data.active then
        vim.cmd.packadd 'nvim-treesitter'
      end
      vim.cmd 'TSUpdate'
    end
  end,
})

vim.pack.add {
  -- Keep first
  'https://github.com/sainnhe/gruvbox-material',

  'https://github.com/tpope/vim-sleuth',
  'https://github.com/tpope/vim-abolish',
  'https://github.com/tpope/vim-surround',

  'https://github.com/nvim-tree/nvim-web-devicons',
  'https://github.com/ofseed/copilot-status.nvim',
  'https://github.com/folke/todo-comments.nvim',
  'https://github.com/nvim-lua/plenary.nvim',

  'https://github.com/nvim-pack/nvim-spectre',

  -- { src = 'https://github.com/mrcjkb/rustaceanvim', version = vim.version.range('8.x') },
}
