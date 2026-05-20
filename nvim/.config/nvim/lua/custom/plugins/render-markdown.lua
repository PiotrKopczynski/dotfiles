vim.pack.add {
  'https://github.com/MeanderingProgrammer/render-markdown.nvim',
  -- Dependencies (pick one set based on your icon preference):
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-mini/mini.nvim', -- if you use the mini.nvim suite
  -- 'https://github.com/nvim-mini/mini.icons',        -- if you use standalone mini plugins
  -- 'https://github.com/nvim-tree/nvim-web-devicons', -- if you prefer nvim-web-devicons
}

---@module 'render-markdown'
---@type render.md.UserConfig
require('render-markdown').setup {}
