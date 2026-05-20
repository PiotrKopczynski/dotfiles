vim.pack.add { 'https://github.com/folke/flash.nvim' }

require('flash').setup {}

-- Keymappings
vim.keymap.set({ 'n', 'x', 'o' }, 'zz', function()
  require('flash').jump()
end, { desc = 'Flash' })

vim.keymap.set({ 'n', 'x', 'o' }, 'ZZ', function()
  require('flash').treesitter()
end, { desc = 'Flash Treesitter' })

vim.keymap.set('o', 'zk', function()
  require('flash').remote()
end, { desc = 'Remote Flash' })

vim.keymap.set({ 'o', 'x' }, 'zK', function()
  require('flash').treesitter_search()
end, { desc = 'Treesitter Search' })

vim.keymap.set('c', '<c-s>', function()
  require('flash').toggle()
end, { desc = 'Toggle Flash Search' })

-- Customize highlight groups
vim.api.nvim_set_hl(0, 'FlashCurrent', { bg = '#ff0000', fg = '#ffffff', bold = true })
vim.api.nvim_set_hl(0, 'FlashLabel', { bg = '#ffff00', fg = '#ff0000', bold = true })
vim.api.nvim_set_hl(0, 'FlashMatch', { fg = '#ff0000' })
