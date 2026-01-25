return {
  {
    'folke/snacks.nvim',
    priority = 1000,
    lazy = false,
    ---@type snacks.Config
    opts = {
      -- your configuration comes here
      -- or leave it empty to use the default settings
      -- refer to the configuration section below
      bigfile = { enabled = true },
      dashboard = {
        enabled = true,
        sections = {
          { section = 'header' },
          { icon = ' ', title = 'Keymaps', section = 'keys', indent = 2, padding = 1 },
          { icon = ' ', title = 'Recent Files', section = 'recent_files', indent = 2, padding = 1 },
          { icon = ' ', title = 'Projects', section = 'projects', indent = 2, padding = 1 },
          { section = 'startup' },
        },
      },
      -- explorer = { enabled = true },
      -- indent = { enabled = true },
      -- input = { enabled = true },
      picker = {
        enabled = true,
        hidden = true,
        -- Styling it to look like a modern dropdown
        layout = 'telescope',
        win = {
          -- Customizing the input window behavior
          input = {
            keys = {
              -- 1. YOUR CUSTOM NAVIGATION (jklø)
              ['k'] = { 'list_down', mode = { 'n' } },
              ['l'] = { 'list_up', mode = { 'n' } },
              ['ø'] = { 'preview_scroll_down', mode = { 'n' } },
              ['j'] = { 'preview_scroll_up', mode = { 'n' } },

              -- 2. SPLITS
              ['<C-h>'] = { 'edit_vsplit', mode = { 'i', 'n' } },
              ['<F48>'] = { 'edit_split', mode = { 'i', 'n' } },

              -- 3. OTHER ACTIONS
              ['q'] = { 'close', mode = { 'n' } },
              ['<Esc>'] = { 'stopinsert', mode = { 'i' } },
              ['<Esc>'] = { 'close', mode = { 'n' } },
              ['<C-q>'] = { 'bufdelete', mode = { 'n' } },
            },
          },
        },
        -- 4. FILE IGNORES (Translated from your Telescope list)
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

      -- notifier = { enabled = true },
      quickfile = { enabled = true },
      rename = { enabled = true },
      -- scope = { enabled = true },
      scroll = { enabled = true },
      statuscolumn = { enabled = true },
      util = { enabled = true },
      words = { enabled = true },
      --
    },
    config = function(_, opts)
      require('snacks').setup(opts) -- This is required to apply your 'opts'

      -- The autocmd for MiniFiles + Snacks Rename
      vim.api.nvim_create_autocmd('User', {
        pattern = 'MiniFilesActionRename',
        callback = function(event)
          Snacks.rename.on_rename_file(event.data.from, event.data.to)
        end,
      })
    end,
    keys = {
      -- 5. THE KEYBINDINGS (Replicating your leader maps)
      {
        '<leader>sf',
        function()
          Snacks.picker.files {
            hidden = true,
            ignored = true,
          }
        end,
        desc = '[S]earch [F]iles',
      },
      {
        '<leader>sg',
        function()
          Snacks.picker.grep()
        end,
        desc = '[S]earch by [G]rep',
      },
      {
        '<leader>sw',
        function()
          Snacks.picker.grep_word()
        end,
        desc = '[S]earch current [W]ord',
      },
      {
        '<leader>sd',
        function()
          Snacks.picker.diagnostics()
        end,
        desc = '[S]earch [D]iagnostics',
      },
      {
        '<leader>sh',
        function()
          Snacks.picker.help()
        end,
        desc = '[S]earch [H]elp',
      },
      {
        '<leader>sk',
        function()
          Snacks.picker.keymaps()
        end,
        desc = '[S]earch [K]eymaps',
      },
      {
        '<leader>sr',
        function()
          Snacks.picker.resume()
        end,
        desc = '[S]earch [R]esume',
      },
      {
        '<leader>s.',
        function()
          Snacks.picker.recent()
        end,
        desc = '[S]earch Recent Files',
      },
      {
        '<leader><leader>',
        function()
          Snacks.picker.buffers()
        end,
        desc = 'Find existing buffers',
      },

      -- SEARCH NEOVIM CONFIG (Your specific <leader>sn)
      {
        '<leader>sn',
        function()
          Snacks.picker.files { cwd = vim.fn.stdpath 'config' }
        end,
        desc = '[S]earch [N]eovim files',
      },

      -- FUZZY SEARCH CURRENT BUFFER (Your <leader>/)
      {
        '<leader>/',
        function()
          Snacks.picker.lines()
        end,
        desc = 'Fuzzily search in current buffer',
      },
      -- LSP
      {
        'gd',
        function()
          Snacks.picker.lsp_definitions()
        end,
        desc = 'Goto Definition',
      },
      {
        'gD',
        function()
          Snacks.picker.lsp_declarations()
        end,
        desc = 'Goto Declaration',
      },
      {
        'gr',
        function()
          Snacks.picker.lsp_references()
        end,
        nowait = true,
        desc = 'References',
      },
      {
        'gi',
        function()
          Snacks.picker.lsp_implementations()
        end,
        desc = 'Goto Implementation',
      },
      {
        'grt',
        function()
          Snacks.picker.lsp_type_definitions()
        end,
        desc = 'Goto T[y]pe Definition',
      },
      -- { "gai", function() Snacks.picker.lsp_incoming_calls() end, desc = "C[a]lls Incoming" },
      -- { "gao", function() Snacks.picker.lsp_outgoing_calls() end, desc = "C[a]lls Outgoing" },
      {
        'gO',
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = 'LSP Symbols',
      },
      {
        'gW',
        function()
          Snacks.picker.lsp_workspace_symbols()
        end,
        desc = 'LSP Workspace Symbols',
      },
      -- git
      {
        '<leader>gb',
        function()
          Snacks.picker.git_branches()
        end,
        desc = 'Git Branches',
      },
      {
        '<leader>gl',
        function()
          Snacks.picker.git_log()
        end,
        desc = 'Git Log',
      },
      {
        '<leader>gL',
        function()
          Snacks.picker.git_log_line()
        end,
        desc = 'Git Log Line',
      },
      {
        '<leader>gs',
        function()
          Snacks.picker.git_status()
        end,
        desc = 'Git Status',
      },
      {
        '<leader>gS',
        function()
          Snacks.picker.git_stash()
        end,
        desc = 'Git Stash',
      },
      {
        '<leader>gd',
        function()
          Snacks.picker.git_diff()
        end,
        desc = 'Git Diff (Hunks)',
      },
      {
        '<leader>gf',
        function()
          Snacks.picker.git_log_file()
        end,
        desc = 'Git Log File',
      },
    },
  },
}
