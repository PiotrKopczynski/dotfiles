-- You can add your own plugins here or in other files in this directory!
--  I promise not to create any merge conflicts in this directory :)
--
-- See the kickstart.nvim README for more information
return {
  {
    'christoomey/vim-tmux-navigator',
    config = function()
      vim.keymap.set({ 'n', 'v' }, '<C-j>', ':TmuxNavigateLeft<CR>')
      vim.keymap.set({ 'n', 'v' }, '<C-k>', ':TmuxNavigateDown<CR>')
      vim.keymap.set({ 'n', 'v' }, '<C-l>', ':TmuxNavigateUp<CR>')
      -- vim.keymap.set({ 'n', 'v' }, vim.fn.nr2char(57632), ':TmuxNavigateRight<CR>')
      vim.keymap.set({ 'n', 'v' }, '<F47>', ':TmuxNavigateRight<CR>')
    end,
  },
}
