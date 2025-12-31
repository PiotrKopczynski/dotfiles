return {
  {
    'christoomey/vim-tmux-navigator',
    -- Stop this plugin from hijacking the <C-h> keybind
    lazy = false, -- This plugin usually needs to load early
    init = function()
      -- This line prevents the plugin from creating the <C-h> binding you see in :verbose
      vim.g.tmux_navigator_no_mappings = 1
    end,
    config = function()
      vim.keymap.set({ 'n', 'v' }, '<C-j>', ':TmuxNavigateLeft<CR>', { silent = true })
      vim.keymap.set({ 'n', 'v' }, '<C-k>', ':TmuxNavigateDown<CR>', { silent = true })
      vim.keymap.set({ 'n', 'v' }, '<C-l>', ':TmuxNavigateUp<CR>', { silent = true })
      vim.keymap.set({ 'n', 'v' }, '<F47>', ':TmuxNavigateRight<CR>', { silent = true })
    end,
  },
}
