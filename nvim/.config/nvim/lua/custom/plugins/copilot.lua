vim.pack.add { 'https://github.com/zbirenbaum/copilot.lua' }
require('copilot').setup {
  suggestion = {
    enabled = true,
    auto_trigger = false,
    -- debounce = 3000, Delay the suggestion
    keymap = {
      -- accept = '<M-CR>',
      accept_word = false,
      accept_line = false,
      next = '<M-n>',
      prev = '<M-p>',
      dismiss = '<M-c>',
    },
  },
  filetypes = {
    ['*'] = true,
  },
}

vim.pack.add { 'https://github.com/nvim-lua/plenary.nvim' }
vim.pack.add { 'https://github.com/CopilotC-Nvim/CopilotChat.nvim' }
require('CopilotChat').setup {
  model = 'claude-sonnet-4.6',
  prompts = {
    Explain = 'Explain how this code works.',
    Review = 'Review this code and suggest improvements.',
    Tests = 'Generate unit tests for this code.',
    Refactor = 'Refactor this code to improve clarity.',
    Fix = 'Fix any bugs or issues in this code.',
    Optimize = 'Optimize this code for performance.',
    Docs = 'Add documentation comments to this code.',
  },
}

vim.keymap.set({ 'n', 'v' }, '<leader>cc', '<cmd>CopilotChatToggle<CR>', { desc = 'Toggle Copilot Chat' })
vim.keymap.set({ 'n', 'v' }, '<leader>ce', '<cmd>CopilotChatExplain<CR>', { desc = 'Explain code) ' })
vim.keymap.set({ 'n', 'v' }, '<leader>ct', '<cmd>CopilotChatTests<CR>', { desc = 'Generate tests) ' })
vim.keymap.set({ 'n', 'v' }, '<leader>cr', '<cmd>CopilotChatReview<CR>', { desc = 'Review code' })
vim.keymap.set({ 'n', 'v' }, '<leader>cf', '<cmd>CopilotChatFix<CR>', { desc = 'Fix code' })
vim.keymap.set({ 'n', 'v' }, '<leader>co', '<cmd>CopilotChatOptimize<CR>', { desc = 'Optimize code' })
vim.keymap.set({ 'n', 'v' }, '<leader>cd', '<cmd>CopilotChatDocs<CR>', { desc = 'Document code' })
vim.keymap.set({ 'n', 'v' }, '<leader>ca', ':CopilotChat ', { desc = 'CopilotChat with selection' })
