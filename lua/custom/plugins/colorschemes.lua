return {
  {
    'ellisonleao/gruvbox.nvim',
    opts = { transparent_mode = true },
    priority = 1000, -- Make sure to load this before all the other start plugins.
    init = function()
      vim.cmd.colorscheme 'gruvbox'
    end,
  },
  {
    'folke/tokyonight.nvim',
    lazy = false,
    priority = 1000,
    opts = {},
  },
}
