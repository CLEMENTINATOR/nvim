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
    {
        'olimorris/persisted.nvim',
        config = function()
            require('persisted').setup {
                use_git_branch = true, -- create session files based on the branch of the git enabled repository
                autosave = true,       -- automatically save session files when exiting Neovim
                autoload = true,       -- automatically load the session for the cwd on Neovim startup
                on_autoload_no_session = function()
                    vim.notify 'No existing session to load.'
                end,
            }
        end,
    },
    {
      'github/copilot.vim',
      lazy = false,
      init = function()
          vim.keymap.set('i', '<M-w>', '<Plug>(copilot-accept-word)', { desc = 'Accept copilot word' })
          vim.keymap.set('i', '<M-l>', '<Plug>(copilot-accept-line)', { desc = 'Accept copilot line' })
          vim.keymap.set('n', '<leader>uc', function()
              if vim.b.copilot_enabled == nil or vim.b.copilot_enabled then
                  vim.b.copilot_enabled = false
              else
                  vim.b.copilot_enabled = true
              end
          end, { desc = 'Toggle Copilot' })
      end,
  },
  { 'HiPhish/rainbow-delimiters.nvim', dependencies = { 'nvim-treesitter/nvim-treesitter' } },
  {
    'lukas-reineke/indent-blankline.nvim',
    -- Enable `lukas-reineke/indent-blankline.nvim`
    -- See `:help ibl`
    main = 'ibl',
    opts = {},

    config = function(_, opts)
      local highlight = {
        'RainbowRed',
        'RainbowYellow',
        'RainbowBlue',
        'RainbowOrange',
        'RainbowGreen',
        'RainbowViolet',
        'RainbowCyan',
      }
      local hooks = require('ibl.hooks')
      -- create the highlight groups in the highlight setup hook, so they are reset
      -- every time the colorscheme changes
      hooks.register(hooks.type.HIGHLIGHT_SETUP, function()
        vim.api.nvim_set_hl(0, 'RainbowRed', { fg = '#E06C75' })
        vim.api.nvim_set_hl(0, 'RainbowYellow', { fg = '#E5C07B' })
        vim.api.nvim_set_hl(0, 'RainbowBlue', { fg = '#61AFEF' })
        vim.api.nvim_set_hl(0, 'RainbowOrange', { fg = '#D19A66' })
        vim.api.nvim_set_hl(0, 'RainbowGreen', { fg = '#98C379' })
        vim.api.nvim_set_hl(0, 'RainbowViolet', { fg = '#C678DD' })
        vim.api.nvim_set_hl(0, 'RainbowCyan', { fg = '#56B6C2' })
      end)

      vim.g.rainbow_delimiters = { highlight = highlight }
      require('ibl').setup({ scope = { highlight = highlight, show_start = false, show_end = false } })

      hooks.register(hooks.type.SCOPE_HIGHLIGHT, hooks.builtin.scope_highlight_from_extmark)
    end,
  },
  { 'nvim-treesitter/nvim-treesitter-context', dependencies = { 'nvim-treesitter/nvim-treesitter' }, opts = { max_lines = 8 } },
}
