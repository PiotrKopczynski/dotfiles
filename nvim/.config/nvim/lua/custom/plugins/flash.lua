return {
  {
    'folke/flash.nvim',
    event = 'VeryLazy',
    ---@type Flash.Config
    opts = {},
    keys = {
      {
        'zz',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').jump()
        end,
        desc = 'Flash',
      },
      {
        'ZZ',
        mode = { 'n', 'x', 'o' },
        function()
          require('flash').treesitter()
        end,
        desc = 'Flash Treesitter',
      },
      {
        'zk',
        mode = 'o',
        function()
          require('flash').remote()
        end,
        desc = 'Remote Flash',
      },
      {
        'zK',
        mode = { 'o', 'x' },
        function()
          require('flash').treesitter_search()
        end,
        desc = 'Treesitter Search',
      },
      {
        '<c-s>',
        mode = { 'c' },
        function()
          require('flash').toggle()
        end,
        desc = 'Toggle Flash Search',
      },
    },
  },
  -- Customize the highlight groups
  vim.api.nvim_set_hl(0, 'FlashCurrent', { bg = '#ff0000', fg = '#ffffff', bold = true }),
  vim.api.nvim_set_hl(0, 'FlashLabel', { bg = '#ffff00', fg = '#ff0000', bold = true }),
  vim.api.nvim_set_hl(0, 'FlashMatch', { fg = '#ff0000' }),
}
