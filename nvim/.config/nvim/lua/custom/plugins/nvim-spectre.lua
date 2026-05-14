return {
  {
    'nvim-pack/nvim-spectre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = {
      default = {
        find = {
          cmd = 'rg',
          options = { '--hidden', '--no-ignore' },
        },
      },
    },
    keys = {
      {
        '<leader>rr',
        '<cmd>lua require("spectre").toggle()<CR>',
        desc = 'Toggle Spectre',
      },
      {
        '<leader>rw',
        '<cmd>lua require("spectre").open_visual({select_word=true})<CR>',
        mode = 'n',
        desc = 'Search current word',
      },
      {
        '<leader>rw',
        '<esc><cmd>lua require("spectre").open_visual()<CR>',
        mode = 'v',
        desc = 'Search visual selection',
      },
      {
        '<leader>rp',
        '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>',
        desc = 'Search on current file',
      },
    },
  },
}
