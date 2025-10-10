-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'olimorris/persisted.nvim',
    config = function()
      require('persisted').setup {
        use_git_branch = true, -- create session files based on the branch of the git enabled repository
        autosave = true, -- automatically save session files when exiting Neovim
        autoload = true, -- automatically load the session for the cwd on Neovim startup
        on_autoload_no_session = function()
          vim.notify 'No existing session to load.'
        end,
      }
    end,
  },
  { 'nvim-treesitter/nvim-treesitter-context', dependencies = { 'nvim-treesitter/nvim-treesitter' }, opts = { max_lines = 8 } },
  {
    'OXY2DEV/markview.nvim',
    lazy = false,
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
  },
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
    },
    config = function()
      require('nvim-treesitter.configs').setup {
        textobjects = {
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              [']m'] = '@function.outer',
            },
            goto_previous_start = {
              ['[m'] = '@function.outer',
            },
          },
        },
      }
    end,
  },
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = { theme = 'gruvbox' },
    },
  },
  {
    'sindrets/diffview.nvim',
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
