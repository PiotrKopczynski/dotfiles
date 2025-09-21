return {
  {
    'windwp/nvim-ts-autotag',
    ft = { 'html', 'javascript', 'javascriptreact', 'typescript', 'typescriptreact', 'vue', 'svelte' },
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },
}
