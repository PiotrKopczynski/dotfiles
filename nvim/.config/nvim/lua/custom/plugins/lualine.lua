return {
  {
    'nvim-lualine/lualine.nvim',
    dependencies = { 'echasnovski/mini.icons' },
    config = function()
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
    end,
  },
}
