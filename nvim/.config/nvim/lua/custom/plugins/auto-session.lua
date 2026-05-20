vim.pack.add { 'https://github.com/rmagatti/auto-session' }
require('nvim-autopairs').setup {
  ---@module "auto-session"
  ---@type AutoSession.Config
  suppressed_dirs = { '~/', '~/Projects', '~/Downloads', '/' },
  bypass_save_filetypes = {},
}
