return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = 'InsertEnter',
    config = function()
      require('copilot').setup {
        suggestion = {
          enabled = true,
          auto_trigger = false,
          -- debounce = 3000, Delay the suggestion
          keymap = {
            accept = '<M-CR>',
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
    end,
  },
  {
    'CopilotC-Nvim/CopilotChat.nvim',
    dependencies = {
      { 'zbirenbaum/copilot.lua' },
      { 'nvim-lua/plenary.nvim' },
    },
    build = 'make tiktoken',
    opts = {
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
    },
    keys = {
      { '<leader>cc', '<cmd>CopilotChatToggle<CR>', desc = 'Toggle Copilot Chat' },
      { '<leader>ce', '<cmd>CopilotChatExplain<CR>', mode = { 'n', 'v' }, desc = 'Explain code' },
      { '<leader>ct', '<cmd>CopilotChatTests<CR>', mode = { 'n', 'v' }, desc = 'Generate tests' },
      { '<leader>cr', '<cmd>CopilotChatReview<CR>', mode = { 'n', 'v' }, desc = 'Review code' },
      { '<leader>cf', '<cmd>CopilotChatFix<CR>', mode = { 'n', 'v' }, desc = 'Fix code' },
      { '<leader>co', '<cmd>CopilotChatOptimize<CR>', mode = { 'n', 'v' }, desc = 'Optimize code' },
      { '<leader>cd', '<cmd>CopilotChatDocs<CR>', mode = { 'n', 'v' }, desc = 'Document code' },
      { '<leader>ca', ':CopilotChat ', mode = { 'v' }, desc = 'CopilotChat with selection' },
    },
  },
}
