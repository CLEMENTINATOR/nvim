vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.g.have_nerd_font = true

vim.opt.number = true
vim.opt.mouse = 'a'
vim.opt.showmode = false
vim.opt.clipboard = 'unnamedplus'

-- Use OSC52 as clipboard provider when SSHed (copies to local clipboard).
-- When running nested inside another nvim's :terminal, the parent doesn't
-- forward OSC52 responses, so paste would hang for 10s before timing out.
if os.getenv('SSH_TTY') then
  local osc52 = require('vim.ui.clipboard.osc52')
  local register_paste = function()
    return vim.split(vim.fn.getreg(''), '\n')
  end
  local paste = require('utils').is_nested_nvim() and {
    ['+'] = register_paste,
    ['*'] = register_paste,
  } or {
    ['+'] = osc52.paste('+'),
    ['*'] = osc52.paste('*'),
  }
  vim.g.clipboard = {
    name = 'OSC 52',
    copy = {
      ['+'] = osc52.copy('+'),
      ['*'] = osc52.copy('*'),
    },
    paste = paste,
  }
end

vim.opt.breakindent = true
vim.opt.undofile = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = 'yes'
vim.opt.timeoutlen = 300
vim.opt.splitright = true
vim.opt.splitbelow = true
vim.opt.list = true
vim.opt.listchars = { tab = '╎ ', trail = '·', nbsp = '␣' }
vim.opt.iskeyword:append('-')
vim.opt.inccommand = 'split'
vim.opt.cursorline = true
vim.opt.scrolloff = 10
vim.opt.termguicolors = true
vim.opt.tabstop = 4
vim.opt.updatetime = 1000

vim.o.diffopt = 'internal,filler,closeoff,linematch:60,iwhite'
vim.o.wildignorecase = true
vim.o.swapfile = false
vim.o.autoread = true
vim.o.winborder = 'rounded'
vim.o.exrc = true

vim.o.foldmethod = 'expr'
vim.o.foldlevelstart = 99
vim.wo.foldexpr = "v:lua.require('utils').foldexpr()"

vim.o.formatexpr = "v:lua.require('conform').formatexpr()"
