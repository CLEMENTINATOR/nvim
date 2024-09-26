-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'akinsho/toggleterm.nvim',
    version = '*',
    opts = {
      open_mapping = [[<C-\>]],
      persist_mode = false, -- does not play nice with auto insert mode autocmds
      direction = 'float',
      float_opts = {
        border = 'curved',
      },
    },
  },
}
