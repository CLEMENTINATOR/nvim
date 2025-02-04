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
    {
        "OXY2DEV/markview.nvim",
        lazy = false,
        dependencies = {
            "nvim-treesitter/nvim-treesitter",
            "nvim-tree/nvim-web-devicons"
        }
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
}
