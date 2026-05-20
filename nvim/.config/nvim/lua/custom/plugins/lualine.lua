vim.pack.add {
  'https://github.com/nvim-lualine/lualine.nvim',
  'https://github.com/echasnovski/mini.icons',
}

require('lualine').setup {
  options = {
    icons_enabled = true,
    theme = 'auto',
    path = 1,
  },
  sections = {
    lualine_b = {
      'diff',
      'diagnostics',
    },
    lualine_x = { 'branch', 'encoding', 'fileformat', 'filetype' },
    lualine_y = {},
  },
}
