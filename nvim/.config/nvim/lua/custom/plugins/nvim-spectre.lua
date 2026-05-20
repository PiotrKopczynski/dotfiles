vim.pack.add {
  'https://github.com/nvim-lua/plenary.nvim',
  'https://github.com/nvim-pack/nvim-spectre',
}

require('spectre').setup {
  default = {
    find = {
      cmd = 'rg',
      options = { '--hidden', '--no-ignore' },
    },
  },
}

vim.keymap.set('n', '<leader>rr', '<cmd>lua require("spectre").toggle()<CR>', { desc = 'Toggle Spectre' })
vim.keymap.set('n', '<leader>rw', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', { desc = 'Search current word' })
vim.keymap.set('v', '<leader>rw', '<esc><cmd>lua require("spectre").open_visual()<CR>', { desc = 'Search visual selection' })
vim.keymap.set('n', '<leader>rp', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', { desc = 'Search on current file' })
