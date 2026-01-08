return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed.
      -- 'nvim-telescope/telescope.nvim', -- optional
      -- 'ibhagwan/fzf-lua', -- optional
      -- 'nvim-mini/mini.pick', -- optional
      'folke/snacks.nvim', -- optional
    },
    keys = {
      {
        '<leader>gg',
        function()
          require('neogit').open { kind = 'floating' }
        end,
        desc = 'Open Neogit',
      },
    },
    config = function()
      local neogit = require 'neogit'
      neogit.setup {
        mappings = {
          status = {
            ['k'] = 'MoveDown',
            ['l'] = 'MoveUp',
          },
          popup = {
            ['j'] = 'LogPopup',
          },
        },
      }
    end,
  },
}
