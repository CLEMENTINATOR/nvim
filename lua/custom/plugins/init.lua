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
  {
    "OXY2DEV/markview.nvim",
    lazy = false,
    dependencies = {
        "nvim-treesitter/nvim-treesitter",
        "nvim-tree/nvim-web-devicons"
    }
  },
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = {
        "nvim-treesitter/nvim-treesitter"
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
            },
          }
        }
      }
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
        options = { theme = 'gruvbox' }
    }
  },
  {
    'sindrets/diffview.nvim'
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons', 'ofseed/copilot-status.nvim' },
    opts = {
      options = {
        icons_enabled = true,
        theme = 'auto',
        component_separators = { left = '', right = '' },
        section_separators = { left = '', right = '' },
        disabled_filetypes = {
          statusline = {},
          winbar = {},
        },
        ignore_focus = {},
        always_divide_middle = true,
        always_show_tabline = true,
        globalstatus = false,
        refresh = {
          statusline = 100,
          tabline = 100,
          winbar = 100,
        },
      },
      sections = {
        lualine_a = { 'mode' },
        lualine_b = {
          {
            'branch',
            fmt = function(branch_name)
              local max_len = 20
              if #branch_name <= max_len then
                return branch_name
              end

              return branch_name:sub(1, max_len - 3) .. '..'
            end,
          },
          'diff',
          'diagnostics',
        },
        lualine_c = { { 'filename', path = 1, shorting_target = 70 } },
        lualine_x = {
          {
            'copilot',
            show_running = true,
            symbols = {
              status = {
                enabled = ' ',
                disabled = ' ',
              },
              spinners = {
                '⠋',
                '⠙',
                '⠹',
                '⠸',
                '⠼',
                '⠴',
                '⠦',
                '⠧',
                '⠇',
                '⠏',
              },
            },
          },
          'encoding',
          'filetype',
        },
        lualine_y = { 'progress' },
        lualine_z = { 'location' },
      },
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { { 'filename', path = 1 } },
        lualine_x = { 'location' },
        lualine_y = {},
        lualine_z = {},
      },
      tabline = {},
      winbar = {},
      inactive_winbar = {},
      extensions = {},
    },
  },
}
