-- [[ Basic Keymaps ]]
--  See `:help vim.keymap.set()`

-- Clear highlights on search when pressing <Esc> in normal mode
--  See `:help hlsearch`
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Diagnostic keymaps
vim.keymap.set('n', 'gQ', vim.diagnostic.setloclist, { desc = 'Open diagnostic [Q]uickfix list' })
vim.keymap.set('n', 'ge', vim.diagnostic.open_float, { desc = 'Show diagnostic [E]rror' })

-- Exit terminal mode in the builtin terminal with a shortcut that is a bit easier
-- for people to discover. Otherwise, you normally need to press <C-\><C-n>, which
-- is not what someone will guess without a bit more experience.
--
-- NOTE: This won't work in all terminal emulators/tmux/etc. Try your own mapping
-- or just use <C-\><C-n> to exit terminal mode
vim.keymap.set('t', '<Esc><Esc>', '<C-\\><C-n>', { desc = 'Exit terminal mode' })

vim.keymap.set({ 'n', 'v' }, '<C-q>', ':bdelete<CR>', { desc = 'Close buffer', silent = true })

-- Keep visual selection after indenting
vim.keymap.set('v', '<', '<gv', { desc = 'Indent left and stay in visual mode' })
vim.keymap.set('v', '>', '>gv', { desc = 'Indent right and stay in visual mode' })

-- Remap pasting in command line mode
vim.keymap.set('c', '<C-p>', '<C-r>+', { desc = 'Paste in command line mode' })

-- Remap redo
vim.keymap.set('n', 'U', '<C-r>', { desc = 'Redo' })

vim.keymap.set({ 'n', 'v' }, '<C-w>J', '<C-W>H', { desc = 'Move window to the far left' })
vim.keymap.set({ 'n', 'v' }, '<C-w>K', '<C-W>J', { desc = 'Move window to the bottom' })
vim.keymap.set({ 'n', 'v' }, '<C-w>L', '<C-W>K', { desc = 'Move window to the top' })
vim.keymap.set({ 'n', 'v' }, '<C-w>Ø', '<C-W>L', { desc = 'Move window to the far right' })

vim.keymap.set({ 'n', 'v' }, '<C-h>', '<C-W>v', { desc = 'Split window vertically' })
vim.keymap.set({ 'n', 'v' }, '<F48>', '<C-W>s', { desc = 'Split window horisontally' })
vim.keymap.set({ 'n', 'v' }, '<C-q>', '<C-W>q', { desc = 'Quit window' })

-- Remap movement keys
vim.keymap.set({ 'n', 'v' }, 'j', 'h', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'k', 'j', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'l', 'k', { noremap = true })
vim.keymap.set({ 'n', 'v' }, 'ø', 'l', { noremap = true })

-- Remap moving to first nonwhite character in the line, and jumping to end of line
vim.keymap.set({ 'n', 'v', 'o' }, 'h', '^', { noremap = true })
vim.keymap.set({ 'n', 'v', 'o' }, 'æ', '$', { noremap = true })

-- Remap moving through jumlist history
vim.keymap.set({ 'n', 'v' }, '<M-j>', '<C-o>', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<M-ø>', '<C-i>', { noremap = true })

-- Neogit & fugitive
-- local neogit = require('neogit')
vim.keymap.set('n', '<leader>gB', ':G blame<CR>', { silent = true, noremap = true })

-- jdtls
vim.keymap.set({ 'n', 'v' }, '<leade>jo', '<C-i>', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<M-ø>', '<C-i>', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<M-ø>', '<C-i>', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<M-ø>', '<C-i>', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<M-ø>', '<C-i>', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<M-ø>', '<C-i>', { noremap = true })
vim.keymap.set({ 'n', 'v' }, '<M-ø>', '<C-i>', { noremap = true })

-- Close all buffers that are not visible in a window
vim.keymap.set('n', '<leader>bc', function()
  local visible = {}
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    visible[vim.api.nvim_win_get_buf(win)] = true
  end
  for _, buf in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(buf) and not visible[buf] then
      vim.api.nvim_buf_delete(buf, { force = false })
    end
  end
end, { desc = 'Clean unused buffers' })

vim.keymap.set({ 'n', 'v' }, '<leader>jo', "<Cmd> lua require('jdtls').organize_imports()<CR>", { desc = 'Java Organize Imports' })
vim.keymap.set({ 'n', 'v' }, '<leader>jv', "<Cmd> lua require('jdtls').extract_variable()<CR>", { desc = 'Java Extract Variable' })
vim.keymap.set({ 'n', 'v' }, '<leader>jc', "<Cmd> lua require('jdtls').extract_constant()<CR>", { desc = 'Java Extract Constant' })
vim.keymap.set({ 'n', 'v' }, '<leader>jm', "<Cmd> lua require('jdtls').extract_method()<CR>", { desc = 'Java Extract Method' })
vim.keymap.set({ 'n', 'v' }, '<leader>jt', "<Cmd> lua require('jdtls').test_nearest_method()<CR>", { desc = 'Java Test Method' })
vim.keymap.set({ 'n', 'v' }, '<leader>jT', "<Cmd> lua require('jdtls').test_class()<CR>", { desc = 'Java Test Class' })
-- Update project config (maven, gradle, etc)
vim.keymap.set({ 'n', 'v' }, '<leader>ju', '<Cmd> JdtUpdateConfig <CR>', { desc = 'Java Update Config' })
vim.keymap.set({ 'n', 'v' }, '<leader>jb', '<Cmd> JdtCompile <CR>', { desc = 'Java Compile' })
