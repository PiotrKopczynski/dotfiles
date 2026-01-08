return {
  {
    'sindrets/diffview.nvim',
    opts = {
      -- This section fixes the overlapping icons
      signs = {
        fold_closed = '> ',
        fold_open = 'v ',
      },
      keymaps = {
        -- File panel
        file_panel = {
          -- In the side panel (file list)
          { 'n', 'k', 'j', { desc = 'Next file' } },
          { 'n', 'l', 'k', { desc = 'Prev file' } },
        },
      },
    },
    cmd = { 'DiffviewOpen', 'DiffviewClose', 'DiffviewToggle', 'DiffviewFocusPanel' },
    keys = {
      {
        '<leader>gD',
        function()
          local lib = require 'diffview.lib'
          local view = lib.get_current_view()
          if view then
            vim.cmd 'DiffviewClose'
          else
            vim.cmd 'DiffviewOpen'
          end
        end,
        desc = 'Toggle Diffview',
      },
    },
  },
}
