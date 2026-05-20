vim.g.tmux_navigator_no_mappings = 1

vim.pack.add {
  'https://github.com/christoomey/vim-tmux-navigator',
}

vim.keymap.set({ 'n', 'v' }, '<C-j>', ':TmuxNavigateLeft<CR>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-k>', ':TmuxNavigateDown<CR>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<C-l>', ':TmuxNavigateUp<CR>', { silent = true })
vim.keymap.set({ 'n', 'v' }, '<F47>', ':TmuxNavigateRight<CR>', { silent = true })
