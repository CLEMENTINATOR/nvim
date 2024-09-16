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
}
