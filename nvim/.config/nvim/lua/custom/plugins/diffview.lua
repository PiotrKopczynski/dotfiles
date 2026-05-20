vim.pack.add {
  'https://github.com/sindrets/diffview.nvim',
}

require('diffview').setup {
  enhanced_diff_hl = true,
  signs = {
    fold_closed = '> ',
    fold_open = 'v ',
  },
  keymaps = {
    file_panel = {
      { 'n', 'k', 'j', { desc = 'Next file' } },
      { 'n', 'l', 'k', { desc = 'Prev file' } },
    },
  },
}

vim.keymap.set('n', '<leader>gD', function()
  local lib = require 'diffview.lib'
  local view = lib.get_current_view()
  if view then
    vim.cmd 'DiffviewClose'
  else
    vim.cmd 'DiffviewOpen'
  end
end, { desc = 'Toggle Diffview' })
