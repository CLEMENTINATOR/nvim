-- enable folds
vim.o.foldmethod = 'expr'
vim.o.foldlevelstart = 99
vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
