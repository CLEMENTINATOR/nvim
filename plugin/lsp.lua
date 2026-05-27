vim.pack.add {
  'https://github.com/neovim/nvim-lspconfig',
  'https://github.com/folke/lazydev.nvim',
}

require('lazydev').setup {
  library = {
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
    { path = '~/nvim' },
  },
}

vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
  callback = function(event)
    local map = function(keys, func, desc, mode)
      mode = mode or 'n'
      vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
    end

    map('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
    map('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction', { 'n', 'x' })
    map('K', vim.lsp.buf.hover, 'Hover Documentation')
    map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

    map('<C-w>]', function()
      vim.cmd 'vsplit'
      local key = vim.api.nvim_replace_termcodes('<C-]>', true, true, true)
      vim.api.nvim_feedkeys(key, 'n', true)
    end, 'Goto Definition in vsplit')

    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.server_capabilities.documentHighlightProvider then
      local highlight_augroup = vim.api.nvim_create_augroup('lsp-highlight', { clear = false })
      vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
        buffer = event.buf,
        group = highlight_augroup,
        callback = vim.lsp.buf.clear_references,
      })
      vim.api.nvim_create_autocmd('LspDetach', {
        group = vim.api.nvim_create_augroup('lsp-detach', { clear = true }),
        callback = function(event2)
          vim.lsp.buf.clear_references()
          vim.api.nvim_clear_autocmds { group = 'lsp-highlight', buffer = event2.buf }
        end,
      })
    end
  end,
})

vim.lsp.config('*', {
  capabilities = require('blink.cmp').get_lsp_capabilities(),
})

vim.lsp.config.lua_ls = {
  settings = {
    Lua = {
      diagnostics = {
        disable = { 'redefined-local' },
      },
    },
  },
}
vim.lsp.enable 'lua_ls'

vim.lsp.enable 'ts_ls'
vim.lsp.enable 'gopls'

vim.lsp.config.clangd = {
  filetypes = { 'c', 'cpp', 'objc', 'objcpp', 'cuda' },
}
vim.lsp.enable 'clangd'

vim.lsp.config.pyright = {
  cmd = { 'uv', 'run', 'pyright-langserver', '--stdio' },
}
vim.lsp.enable 'pyright'

-- Auto-stop idle LSP clients to free memory, restart them on activity.
do
  local uv = vim.uv or vim.loop
  local STOP_TIMEOUT_MS = 1000 * 60 * 10
  local shutting_down = false
  local stop_timer = nil
  local stopped = {}

  local function clear_timer(timer)
    if timer then
      timer:stop()
      timer:close()
    end
  end

  vim.api.nvim_create_autocmd('CursorHold', {
    callback = function()
      clear_timer(stop_timer)
      stop_timer = uv.new_timer()
      if not stop_timer then
        return
      end
      stop_timer:start(
        STOP_TIMEOUT_MS,
        0,
        vim.schedule_wrap(function()
          shutting_down = true
          for _, lsp in ipairs(vim.lsp.get_clients()) do
            stopped[lsp.name] = true
            lsp:stop(true)
          end
          shutting_down = false
          clear_timer(stop_timer)
          stop_timer = nil
        end)
      )
    end,
  })

  vim.api.nvim_create_autocmd({ 'CursorMoved', 'InsertEnter', 'BufEnter' }, {
    callback = function()
      if shutting_down then
        return
      end
      if stop_timer then
        clear_timer(stop_timer)
        stop_timer = nil
      end
      if vim.tbl_isempty(stopped) then
        return
      end
      vim.lsp.enable(vim.tbl_keys(stopped), true)
      stopped = {}
    end,
  })
end
