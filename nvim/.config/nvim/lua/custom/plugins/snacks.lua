vim.pack.add {
  'https://github.com/folke/snacks.nvim',
}

require('snacks').setup {
  scratch = {},
  bigfile = { enabled = true },
  dashboard = {
    enabled = true,
    sections = {
      { section = 'header' },
      { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
      { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
      { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
    },
  },
  picker = {
    ui_select = true,
    enabled = true,
    hidden = true,
    layout = 'telescope',
    win = {
      input = {
        keys = {
          ['k'] = { 'list_down', mode = { 'n' } },
          ['l'] = { 'list_up', mode = { 'n' } },
          ['ø'] = { 'preview_scroll_down', mode = { 'n' } },
          ['j'] = { 'preview_scroll_up', mode = { 'n' } },
          ['<C-h>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
          ['<F48>'] = { 'edit_split', mode = { 'i', 'n' } },
          ['q'] = { 'close', mode = { 'n' } },
          ['<Esc>'] = { 'stopinsert', mode = { 'i' } },
          ['<Esc>'] = { 'close', mode = { 'n' } },
          ['<C-q>'] = { 'bufdelete', mode = { 'n' } },
        },
      },
    },
    exclude = {
      'node_modules',
      'target',
      '.git',
      '.cache',
      '.local',
      'Steam',
      'Games',
      'snap',
      'timeshift',
      'dist',
      'build',
      'coverage',
    },
  },
  quickfile = { enabled = true },
  rename = { enabled = true },
  scroll = { enabled = true },
  statuscolumn = { enabled = true },
  util = { enabled = true },
  words = { enabled = true },
}

-- MiniFiles + Snacks Rename integration
vim.api.nvim_create_autocmd('User', {
  pattern = 'MiniFilesActionRename',
  callback = function(event)
    Snacks.rename.on_rename_file(event.data.from, event.data.to)
  end,
})

-- Scratch
vim.keymap.set('n', '<leader>.', function()
  Snacks.scratch()
end, { desc = 'Toggle Scratch Buffer' })
vim.keymap.set('n', '<leader>ss', function()
  Snacks.scratch.select()
end, { desc = 'Select Scratch Buffer' })
vim.keymap.set('n', '<leader>n', function()
  Snacks.scratch { name = 'notes', ft = 'markdown' }
end, { desc = 'Scratch: Notes' })

-- Files
vim.keymap.set('n', '<leader>sf', function()
  Snacks.picker.files { hidden = true, ignored = true }
end, { desc = '[S]earch [F]iles' })
vim.keymap.set('n', '<leader>sg', function()
  Snacks.picker.grep()
end, { desc = '[S]earch by [G]rep' })
vim.keymap.set('n', '<leader>sw', function()
  Snacks.picker.grep_word()
end, { desc = '[S]earch current [W]ord' })
vim.keymap.set('n', '<leader>sD', function()
  Snacks.picker.diagnostics()
end, { desc = '[S]earch [D]iagnostics' })
vim.keymap.set('n', '<leader>sd', function()
  Snacks.picker.diagnostics { filter = { buf = 0 } }
end, { desc = 'Buffer Diagnostics' })
vim.keymap.set('n', '<leader>sh', function()
  Snacks.picker.help()
end, { desc = '[S]earch [H]elp' })
vim.keymap.set('n', '<leader>sk', function()
  Snacks.picker.keymaps()
end, { desc = '[S]earch [K]eymaps' })
vim.keymap.set('n', '<leader>sr', function()
  Snacks.picker.resume()
end, { desc = '[S]earch [R]esume' })
vim.keymap.set('n', '<leader>s.', function()
  Snacks.picker.recent()
end, { desc = '[S]earch Recent Files' })
vim.keymap.set('n', '<leader><leader>', function()
  Snacks.picker.buffers()
end, { desc = 'Find existing buffers' })
vim.keymap.set('n', '<leader>sn', function()
  Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
end, { desc = '[S]earch [N]eovim files' })
vim.keymap.set('n', '<leader>/', function()
  Snacks.picker.lines()
end, { desc = 'Fuzzily search in current buffer' })

-- LSP
vim.keymap.set('n', 'gd', function()
  Snacks.picker.lsp_definitions()
end, { desc = 'Goto Definition' })
vim.keymap.set('n', 'gD', function()
  Snacks.picker.lsp_declarations()
end, { desc = 'Goto Declaration' })
vim.keymap.set('n', 'gr', function()
  Snacks.picker.lsp_references()
end, { nowait = true, desc = 'References' })
vim.keymap.set('n', 'gi', function()
  Snacks.picker.lsp_implementations()
end, { desc = 'Goto Implementation' })
vim.keymap.set('n', 'grt', function()
  Snacks.picker.lsp_type_definitions()
end, { desc = 'Goto T[y]pe Definition' })
vim.keymap.set('n', 'gO', function()
  Snacks.picker.lsp_symbols()
end, { desc = 'LSP Symbols' })
vim.keymap.set('n', 'gW', function()
  Snacks.picker.lsp_workspace_symbols()
end, { desc = 'LSP Workspace Symbols' })

-- Git
vim.keymap.set('n', '<leader>gb', function()
  Snacks.picker.git_branches()
end, { desc = 'Git Branches' })
vim.keymap.set('n', '<leader>gl', function()
  Snacks.picker.git_log()
end, { desc = 'Git Log' })
vim.keymap.set('n', '<leader>gL', function()
  Snacks.picker.git_log_line()
end, { desc = 'Git Log Line' })
vim.keymap.set('n', '<leader>gs', function()
  Snacks.picker.git_status()
end, { desc = 'Git Status' })
vim.keymap.set('n', '<leader>gS', function()
  Snacks.picker.git_stash()
end, { desc = 'Git Stash' })
vim.keymap.set('n', '<leader>gd', function()
  Snacks.picker.git_diff()
end, { desc = 'Git Diff (Hunks)' })
vim.keymap.set('n', '<leader>gf', function()
  Snacks.picker.git_log_file()
end, { desc = 'Git Log File' })
