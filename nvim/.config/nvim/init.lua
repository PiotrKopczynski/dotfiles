do
  -- Enable faster startup by caching compiled Lua modules
  vim.loader.enable()

  vim.g.mapleader = ' '
  vim.g.maplocalleader = ' '
  -- Set to true if you have a Nerd Font installed and selected in the terminal
  vim.g.have_nerd_font = true

  -- [[ Setting options ]]
  -- See `:help vim.o`
  -- NOTE: You can change these options as you wish!
  --  For more options, you can see `:help option-list`

  -- Make line numbers default
  vim.o.number = true
  -- You can also add relative line numbers, to help with jumping.
  --  Experiment for yourself to see if you like it!
  vim.o.relativenumber = true

  -- Enable mouse mode, can be useful for resizing splits for example!
  vim.o.mouse = 'a'

  -- Don't show the mode, since it's already in the status line
  vim.o.showmode = false

  -- Define what is stored in sessions
  vim.o.sessionoptions = 'blank,buffers,curdir,folds,help,tabpages,winsize,winpos,localoptions'

  -- Sync clipboard between OS and Neovim.
  --  Schedule the setting after `UiEnter` because it can increase startup-time.
  --  Remove this option if you want your OS clipboard to remain independent.
  --  See `:help 'clipboard'`
  vim.schedule(function()
    vim.o.clipboard = 'unnamedplus'
  end)
  -- Enable break indent
  vim.o.breakindent = true

  -- Save undo history
  vim.o.undofile = true

  -- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
  vim.o.ignorecase = true
  vim.o.smartcase = true

  -- Keep signcolumn on by default
  vim.o.signcolumn = 'yes'

  -- Decrease update time
  vim.o.updatetime = 450

  -- Decrease mapped sequence wait time
  vim.o.timeoutlen = 300

  -- Configure how new splits should be opened
  vim.o.splitright = true
  vim.o.splitbelow = true

  -- Sets how neovim will display certain whitespace characters in the editor.
  --  See `:help 'list'`
  --  and `:help 'listchars'`
  --
  --  Notice listchars is set using `vim.opt` instead of `vim.o`.
  --  It is very similar to `vim.o` but offers an interface for conveniently interacting with tables.
  --   See `:help lua-options`
  --   and `:help lua-options-guide`
  vim.o.list = true
  vim.opt.listchars = { tab = '» ', trail = '·', nbsp = '␣' }

  -- Set default tabstop and shiftwidth
  vim.opt.expandtab = true -- convert tabs to spaces
  vim.opt.tabstop = 4 -- number of spaces inserted for tab character
  vim.opt.softtabstop = 4 -- number of spaces inserted for the <Tab> key
  vim.opt.shiftwidth = 4 -- number of spaces inserted for each indentation level
  vim.opt.smartindent = true -- Insert indents automatically
  vim.opt.breakindent = true -- enable line breaking indentation

  -- Disable swap files
  vim.opt.swapfile = false

  -- Disable line wrapping
  vim.opt.wrap = false

  -- vim.opt.writebackup = false -- prevent editing of files being edited elsewhere

  -- Force terminal capabilities
  vim.opt.termguicolors = true
  vim.g.terminal_ansi_colors = vim.g.terminal_ansi_colors or {}

  -- Ensure undercurl works
  vim.cmd [[
  let &t_Cs = "\e[4:3m"
  let &t_Ce = "\e[4:0m"
]]

  -- Preview substitutions live, as you type!
  vim.o.inccommand = 'split'

  -- Show which line your cursor is on
  vim.o.cursorline = false

  -- Minimal number of screen lines to keep above and below the cursor.
  vim.o.scrolloff = 8

  -- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
  -- instead raise a dialog asking if you wish to save the current file(s)
  -- See `:help 'confirm'`
  vim.o.confirm = true

  -- Import keymaps
  require 'custom.keymaps'
  -- Import java file creation integration
  require 'custom.mini-files-java-integration'

  -- Set GitSigns colors
  vim.api.nvim_set_hl(0, 'GitSignsAdd', { fg = '#00ff00', bg = 'NONE' }) -- Bright green for additions
  vim.api.nvim_set_hl(0, 'GitSignsChange', { fg = '#ffff00', bg = 'NONE' }) -- Bright yellow for changes
  vim.api.nvim_set_hl(0, 'GitSignsDelete', { fg = '#ff0000', bg = 'NONE' }) -- Bright red for deletions
  vim.api.nvim_set_hl(0, 'GitSignsChangeDelete', { fg = '#ff8800', bg = 'NONE' }) -- Orange for change+delete
  vim.api.nvim_set_hl(0, 'GitSignsTopDelete', { fg = '#ff0000', bg = 'NONE' }) -- Red for top delete

  -- [[ Basic Autocommands ]]
  --  See `:help lua-guide-autocommands`

  -- Highlight when yanking (copying) text
  --  Try it with `yap` in normal mode
  --  See `:help vim.hl.on_yank()`
  vim.api.nvim_create_autocmd('TextYankPost', {
    desc = 'Highlight when yanking (copying) text',
    group = vim.api.nvim_create_augroup('kickstart-highlight-yank', { clear = true }),
    callback = function()
      vim.hl.on_yank()
    end,
  })

  -- Automatically reload the file when it changes outside Neovim (like after a stash)
  vim.opt.autoread = true

  -- Trigger checktime whenever you change focus or enter a buffer
  vim.api.nvim_create_autocmd({ 'FocusGained', 'BufEnter', 'CursorHold' }, {
    callback = function()
      if vim.fn.mode() ~= 'c' then
        vim.cmd 'checktime'
      end
    end,
  })

  -- Correct way of attaching jdtls
  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'java',
    callback = function(args)
      require('custom.jdtls.jdtls_setup').setup()
    end,
  })

  -- Force no wrap. Without it some panes open with wrap
  vim.api.nvim_create_autocmd('WinNew', {
    callback = function()
      vim.opt_local.wrap = false
    end,
  })

  -- Diagnostic Config
  -- See :help vim.diagnostic.Opts
  vim.diagnostic.config {
    update_in_insert = false,
    severity_sort = true,
    float = { border = 'rounded', source = 'if_many', max_width = 100, wrap = true },
    underline = { severity = { min = vim.diagnostic.severity.WARN } },
    signs = vim.g.have_nerd_font and {
      text = {
        [vim.diagnostic.severity.ERROR] = '󰅚 ',
        [vim.diagnostic.severity.WARN] = '󰀪 ',
        [vim.diagnostic.severity.INFO] = '󰋽 ',
        [vim.diagnostic.severity.HINT] = '󰌶 ',
      },
    } or {},
    virtual_text = {
      source = 'if_many',
      spacing = 2,
      format = function(diagnostic)
        local max_length = 50 -- Adjust this to fit your screen
        local message = diagnostic.message
        if #message > max_length then
          return string.sub(message, 1, max_length) .. '...'
        end
        return message
      end,
    },
  }
end

do
  local function run_build(name, cmd, cwd)
    local result = vim.system(cmd, { cwd = cwd }):wait()
    if result.code ~= 0 then
      local stderr = result.stderr or ''
      local stdout = result.stdout or ''
      local output = stderr ~= '' and stderr or stdout
      if output == '' then
        output = 'No output from build command.'
      end
      vim.notify(('Build failed for %s:\n%s'):format(name, output), vim.log.levels.ERROR)
    end
  end

  -- This autocommand runs after a plugin is installed or updated and
  --  runs the appropriate build command for that plugin if necessary.
  --
  -- See `:help vim.pack-events`
  vim.api.nvim_create_autocmd('PackChanged', {
    callback = function(ev)
      local name = ev.data.spec.name
      local kind = ev.data.kind
      if kind ~= 'install' and kind ~= 'update' then
        return
      end

      if name == 'telescope-fzf-native.nvim' and vim.fn.executable 'make' == 1 then
        run_build(name, { 'make' }, ev.data.path)
        return
      end

      if name == 'LuaSnip' then
        if vim.fn.has 'win32' ~= 1 and vim.fn.executable 'make' == 1 then
          run_build(name, { 'make', 'install_jsregexp' }, ev.data.path)
        end
        return
      end

      if name == 'nvim-treesitter' then
        if not ev.data.active then
          vim.cmd.packadd 'nvim-treesitter'
        end
        vim.cmd 'TSUpdate'
        return
      end
    end,
  })
end

---Because most plugins are hosted on GitHub, you can use the helper
---function to have less repetition in the following sections.
---@param repo string
---@return string
local function gh(repo)
  return 'https://github.com/' .. repo
end

do
  -- [[ Installing and Configuring Plugins ]]
  --
  -- To install a plugin simply call `vim.pack.add` with its git url.
  -- This will download the default branch of the plugin, which will usually be `main` or `master`
  -- You can also have more advanced specs, which we will talk about later.
  --
  -- For most plugins its not enough to install them, you also need to call their `.setup()` to start them.
  --
  -- For example, lets say we want to install `guess-indent.nvim` - a plugin for
  -- automatically detecting and setting the indentation.
  --
  -- We first install it from https://github.com/NMAC427/guess-indent.nvim
  -- and then call its `setup()` function to start it with default settings.
  vim.pack.add { gh 'NMAC427/guess-indent.nvim' }
  require('guess-indent').setup {}

  --if vim.g.have_nerd_font then vim.pack.add { gh 'nvim-tree/nvim-web-devicons' } end
  vim.pack.add { gh 'lewis6991/gitsigns.nvim' }
  require('gitsigns').setup {
    -- signs = {
    --   add = { text = '+' }, ---@diagnostic disable-line: missing-fields
    --   change = { text = '~' }, ---@diagnostic disable-line: missing-fields
    --   delete = { text = '_' }, ---@diagnostic disable-line: missing-fields
    --   topdelete = { text = '‾' }, ---@diagnostic disable-line: missing-fields
    --   changedelete = { text = '~' }, ---@diagnostic disable-line: missing-fields
    -- },
  }

  vim.pack.add { gh 'folke/which-key.nvim' }
  require('which-key').setup {
    delay = 0,
    icons = { mappings = vim.g.have_nerd_font },
    -- Document existing key chains
    spec = {
      { '<leader>s', group = '[S]earch', mode = { 'n', 'v' } },
      { '<leader>t', group = '[T]oggle' },
      { '<leader>h', group = 'Git [H]unk', mode = { 'n', 'v' } }, -- Enable gitsigns recommended keymaps first
      { 'g', group = 'LSP Actions', mode = { 'n' } },
    },
  }

  vim.pack.add { gh 'ellisonleao/gruvbox.nvim' }
  ---@diagnostic disable-next-line: missing-fields
  require('gruvbox').setup {
    styles = {
      comments = { italic = false }, -- disable italics in comments
      priority = 1000,
      config = true,
      palette_overrides = {
        dark0_hard = '#252525',
      },
      contrast = 'hard',
    },
  }
  vim.cmd.colorscheme 'gruvbox'

  -- {
  --   'ellisonleao/gruvbox.nvim',
  --   priority = 1000,
  --   config = true,
  --   opts = {
  --     palette_overrides = {
  --       dark0_hard = '#252525',
  --     },
  --     contrast = 'hard',
  --   },
  -- },
  --
  vim.pack.add { gh 'folke/todo-comments.nvim' }
  require('todo-comments').setup { signs = false }
  -- Highlight todo, notes, etc in comments
  -- { 'folke/todo-comments.nvim', event = 'VimEnter', dependencies = { 'nvim-lua/plenary.nvim' }, opts = { signs = false } },
  --
  vim.pack.add { gh 'nvim-mini/mini.nvim' }
  -- Stop mini.files from opening menu when starting neovim
  vim.g.mini_files_disable_autocmds = true

  require('mini.ai').setup {
    -- NOTE: Avoid conflicts with the built-in incremental selection mappings on Neovim>=0.12 (see `:help treesitter-incremental-selection`)
    mappings = {
      around_next = 'aa',
      inside_next = 'ii',
    },
    n_lines = 500,
  }

  require('mini.surround').setup()

  require('mini.move').setup {
    mappings = {
      -- Move visual selection in Visual mode. Defaults are Alt (Meta) + hjkl.
      left = 'J',
      right = 'Ø',
      down = 'K',
      up = 'L',

      -- Move current line in Normal mode
      line_left = 'J',
      line_right = 'Ø',
      line_down = 'K',
      line_up = 'L',
    },
  }

  require('mini.icons').setup {
    mock_nvim_web_devicons = true,
  }

  require('mini.files').setup {
    mappings = {
      close = 'q',
      go_in = 'ø',
      go_in_plus = '<CR>',
      go_out = 'j',
      go_out_plus = 'J',
      reset = '<BS>',
      reveal_cwd = '@',
      show_help = 'g?',
      synchronize = '=',
      trim_left = '<',
      trim_right = '>',
    },
  }

  vim.keymap.set('n', '-', function()
    require('mini.files').open(vim.api.nvim_buf_get_name(0))
  end, { desc = 'Open mini.files (current file)' })
end

--LSP
do
  vim.pack.add { gh 'j-hui/fidget.nvim' }
  require('fidget').setup {}

  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('kickstart-lsp-attach', { clear = true }),
    callback = function(event)
      -- In this case, we create a function that lets us more easily define mappings specific
      -- for LSP related items. It sets the mode, buffer and description for us each time.
      local map = function(keys, func, desc, mode)
        mode = mode or 'n'
        vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = 'LSP: ' .. desc })
      end

      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client.name == 'ltex' then
        client.handlers['$/progress'] = function() end
      end

      -- Rename the variable under your cursor.
      --  Most Language Servers support renaming across files, etc.
      map('gR', vim.lsp.buf.rename, '[R]e[n]ame')

      -- Execute a code action, usually your cursor needs to be on top of an error
      -- or a suggestion from your LSP for this to activate.
      map('ga', vim.lsp.buf.code_action, '[G]oto Code [A]ction', { 'n', 'x' })

      -- Find references for the word under your cursor.
      -- map('gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')

      -- Jump to the implementation of the word under your cursor.
      --  Useful when your language has ways of declaring types without an actual implementation.
      -- map('gi', require('telescope.builtin').lsp_implementations, '[G]oto [I]mplementation')

      -- Jump to the definition of the word under your cursor.
      --  This is where a variable was first declared, or where a function is defined, etc.
      --  To jump back, press <C-t>.
      -- map('gd', require('telescope.builtin').lsp_definitions, '[G]oto [D]efinition')

      -- WARN: This is not Goto Definition, this is Goto Declaration.
      --  For example, in C this would take you to the header.
      -- map('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')

      -- Fuzzy find all the symbols in your current document.
      --  Symbols are things like variables, functions, types, etc.
      -- map('gO', require('telescope.builtin').lsp_document_symbols, 'Open Document Symbols')

      -- Fuzzy find all the symbols in your current workspace.
      --  Similar to document symbols, except searches over your entire project.
      -- map('gW', require('telescope.builtin').lsp_dynamic_workspace_symbols, 'Open Workspace Symbols')

      -- Jump to the type of the word under your cursor.
      --  Useful when you're not sure what type a variable is and you want to see
      --  the definition of its *type*, not where it was *defined*.
      -- map('grt', require('telescope.builtin').lsp_type_definitions, '[G]oto [T]ype Definition')

      -- View documentation
      map('gq', vim.lsp.buf.hover, 'Hover Documentation')

      -- The following two autocommands are used to highlight references of the
      -- word under your cursor when your cursor rests there for a little while.
      --    See `:help CursorHold` for information about when this is executed
      --
      -- When you move your cursor, the highlights will be cleared (the second autocommand).
      local client = vim.lsp.get_client_by_id(event.data.client_id)
      if client and client:supports_method('textDocument/documentHighlight', event.buf) then
        local highlight_augroup = vim.api.nvim_create_augroup('kickstart-lsp-highlight', { clear = false })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.document_highlight,
        })

        vim.api.nvim_create_autocmd({ 'CursorMoved', 'CursorMovedI' }, {
          buffer = event.buf,
          group = highlight_augroup,
          callback = vim.lsp.buf.clear_references,
        })

        vim.api.nvim_create_autocmd('LspDetach', {
          group = vim.api.nvim_create_augroup('kickstart-lsp-detach', { clear = true }),
          callback = function(event2)
            vim.lsp.buf.clear_references()
            vim.api.nvim_clear_autocmds { group = 'kickstart-lsp-highlight', buffer = event2.buf }
          end,
        })
      end

      -- The following code creates a keymap to toggle inlay hints in your
      -- code, if the language server you are using supports them
      --
      -- This may be unwanted, since they displace some of your code
      if client and client:supports_method('textDocument/inlayHint', event.buf) then
        map('<leader>th', function()
          vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled { bufnr = event.buf })
        end, '[T]oggle Inlay [H]ints')
      end
    end,
  })

  -- Enable the following language servers
  --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
  --  See `:help lsp-config` for information about keys and how to configure
  ---@type table<string, vim.lsp.Config>
  local servers = {
    -- clangd = {},
    -- gopls = {},
    -- pyright = {},
    -- rust_analyzer = {},
    postgres_lsp = {
      settings = {
        postgres_lsp = {
          keywordCase = 'lowercase',
        },
      },
    },
    jsonls = {},
    bashls = {},
    dockerls = {},
    yamlls = {},
    pyright = {}, -- Python lsp
    ruff = {}, -- Python linter + formatter
    lemminx = { -- XML lsp
      settings = {
        xml = {
          format = {
            enabled = true,
            splitAttributes = true,
          },
          completion = {
            autoCloseTags = true,
          },
        },
      },
    },
    docker_compose_language_service = {},
    ts_ls = {
      settings = {
        typescript = {
          preferences = {
            importModuleSpecifier = 'non-relative',
            includeCompletionsForModuleExports = true,
          },
        },
      },
    },
    html = {},
    cssls = {},
    tailwindcss = {},
    emmet_language_server = {}, -- LSP for jsx and tsx
    marksman = {}, --Markdown LSP
    ltex = {},
    jdtls = {},
    -- kotlin_lsp = {}, --try this one in the future. For now it is pretty bad
    oxlint = {},
    stylua = {},
    lua_ls = {
      on_init = function(client)
        client.server_capabilities.documentFormattingProvider = false -- Disable formatting (formatting is done by stylua)

        if client.workspace_folders then
          local path = client.workspace_folders[1].name
          if path ~= vim.fn.stdpath 'config' and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc')) then
            return
          end
        end

        client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
          runtime = {
            version = 'LuaJIT',
            path = { 'lua/?.lua', 'lua/?/init.lua' },
          },
          workspace = {
            checkThirdParty = false,
            -- NOTE: this is a lot slower and will cause issues when working on your own configuration.
            --  See https://github.com/neovim/nvim-lspconfig/issues/3189
            library = vim.tbl_extend('force', vim.api.nvim_get_runtime_file('', true), {
              '${3rd}/luv/library',
              '${3rd}/busted/library',
            }),
          },
        })
      end,
      ---@type lspconfig.settings.lua_ls
      settings = {
        Lua = {
          format = { enable = false }, -- Disable formatting (formatting is done by stylua)
        },
      },
    },
  }

  vim.pack.add {
    gh 'neovim/nvim-lspconfig',
    gh 'mason-org/mason.nvim',
    gh 'mason-org/mason-lspconfig.nvim',
    gh 'WhoIsSethDaniel/mason-tool-installer.nvim',
  }

  require('mason').setup {}

  local ensure_installed = vim.tbl_keys(servers or {})
  vim.list_extend(ensure_installed, {
    -- You can add other tools here that you want Mason to install
  })
  require('mason-tool-installer').setup { ensure_installed = ensure_installed }

  for name, server in pairs(servers) do
    vim.lsp.config(name, server)
    vim.lsp.enable(name)
  end
end

-- FORMATTING
do
  -- [[ Formatting ]]
  vim.pack.add { gh 'stevearc/conform.nvim' }
  require('conform').setup {
    notify_on_error = false,
    format_on_save = function(bufnr)
      -- You can specify filetypes to autoformat on save here:
      local enabled_filetypes = {
        lua = true,
        -- python = true,
      }
      if enabled_filetypes[vim.bo[bufnr].filetype] then
        return { timeout_ms = 500 }
      else
        return nil
      end
    end,
    default_format_opts = {
      lsp_format = 'fallback', -- Use external formatters if configured below, otherwise use LSP formatting. Set to `false` to disable LSP formatting entirely.
    },
    -- You can also specify external formatters in here.
    formatters_by_ft = {
      lua = { 'stylua' },
      html = { 'oxfmt' },
      css = { 'oxfmt' },
      scss = { 'oxfmt' },
      javascript = { 'oxfmt' },
      javascriptreact = { 'oxfmt' },
      typescript = { 'oxfmt' },
      typescriptreact = { 'oxfmt' },
      json = { 'oxfmt' },
      jsonc = { 'oxfmt' },
      yaml = { 'oxfmt' },
      markdown = { 'oxfmt' },
      sql = { 'sqlfluff' },
      kotlin = { 'ktlint' },
      -- For java use xml files extracted from intellij
      -- java = { 'google-java-format' },
      -- Conform can also run multiple formatters sequentially
      python = { 'ruff' },
      --
      -- You can use 'stop_after_first' to run the first available formatter from the list
      -- javascript = { "oxlintd", "prettier", stop_after_first = true },
    },
  }

  vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
    require('conform').format { async = true }
  end, { desc = '[F]ormat buffer' })
end

-- AUTOCOMPLETE & SNIPPETS
do
  -- [[ Snippet Engine ]]
  vim.pack.add { { src = gh 'L3MON4D3/LuaSnip', version = vim.version.range '2.*' } }
  require('luasnip').setup {}
  vim.pack.add { gh 'rafamadriz/friendly-snippets' }
  require('luasnip.loaders.from_vscode').lazy_load()

  vim.pack.add { { src = gh 'saghen/blink.cmp', version = vim.version.range '1.*' } }
  require('blink.cmp').setup {
    keymap = {
      ['<CR>'] = { 'accept', 'fallback' },
      -- Override Tab to add bracket jumping functionality
      ['<Tab>'] = {
        function(cmp)
          -- Check if completion menu is visible
          -- if cmp.is_visible() then
          --   return cmp.accept()
          -- end
          if cmp.is_visible() then
            return cmp.cancel()
          end

          -- Check if we're right before a closing character
          local col = vim.fn.col '.'
          local line = vim.api.nvim_get_current_line()
          local char = line:sub(col, col)

          if char:match '[%)%]%}"\'>%`´]' then
            -- Move cursor right to jump out
            vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<Right>', true, true, true), 'n', true)
            return true
          end

          -- Check if we're in a snippet and can jump forward
          local luasnip = require 'luasnip'
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
            return true
          end

          -- Fall back to normal tab
          return false
        end,
        'fallback',
      },
    },

    appearance = {
      nerd_font_variant = 'mono',
    },

    completion = {
      documentation = { auto_show = false, auto_show_delay_ms = 500 },
      list = {
        selection = { preselect = false, auto_insert = false },
      },
    },

    sources = {
      default = { 'lsp', 'path', 'snippets' },
    },

    snippets = { preset = 'luasnip' },

    fuzzy = { implementation = 'lua' },
    signature = { enabled = true },
  }
end

-- TREESITTER
do
  vim.pack.add { { src = gh 'nvim-treesitter/nvim-treesitter', version = 'main' } }

  -- Ensure basic parsers are installed
  local parsers = {
    'bash',
    'c',
    'diff',
    'html',
    'lua',
    'luadoc',
    'markdown',
    'markdown_inline',
    'query',
    'vim',
    'vimdoc',
    'javascript',
    'typescript',
    'tsx',
    'json',
    'json5',
    'css',
    'scss',
    'java',
    'kotlin',
    'sql',
  }

  require('nvim-treesitter').install(parsers)

  ---@param buf integer
  ---@param language string
  local function treesitter_try_attach(buf, language)
    -- Check if a parser exists and load it
    if not vim.treesitter.language.add(language) then
      return
    end
    -- Enable syntax highlighting and other treesitter features
    vim.treesitter.start(buf, language)

    -- Enable treesitter based folds
    -- For more info on folds see `:help folds`
    -- vim.wo.foldexpr = 'v:lua.vim.treesitter.foldexpr()'
    -- vim.wo.foldmethod = 'expr'

    -- Check if treesitter indentation is available for this language, and if so enable it
    -- in case there is no indent query, the indentexpr will fallback to the vim's built in one
    local has_indent_query = vim.treesitter.query.get(language, 'indents') ~= nil

    -- Enable treesitter based indentation
    if has_indent_query then
      vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end

  local available_parsers = require('nvim-treesitter').get_available()
  vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
      local buf, filetype = args.buf, args.match

      local language = vim.treesitter.language.get_lang(filetype)
      if not language then
        return
      end

      local installed_parsers = require('nvim-treesitter').get_installed 'parsers'

      if vim.tbl_contains(installed_parsers, language) then
        -- Enable the parser if it is already installed
        treesitter_try_attach(buf, language)
      elseif vim.tbl_contains(available_parsers, language) then
        -- If a parser is available in `nvim-treesitter`, auto-install it and enable it after the installation is done
        require('nvim-treesitter').install(language):await(function()
          treesitter_try_attach(buf, language)
        end)
      else
        -- Try to enable treesitter features in case the parser exists but is not available from `nvim-treesitter`
        treesitter_try_attach(buf, language)
      end
    end,
  })
end

do
  --  Here are some example plugins that I've included in the Kickstart repository.
  require 'kickstart.plugins.indent_line'
  require 'kickstart.plugins.lint'
  require 'kickstart.plugins.autopairs'
  require 'kickstart.plugins.gitsigns' -- adds gitsigns recommend keymaps

  require 'custom.plugins'
end

-- { -- Highlight, edit, and navigate code
--   'nvim-treesitter/nvim-treesitter',
--   main = 'nvim-treesitter.configs', -- Sets main module to use for opts
--   branch = 'master',
--   build = ':TSUpdate',
--   -- [[ Configure Treesitter ]] See `:help nvim-treesitter`
--     -- Autoinstall languages that are not installed
--     auto_install = true,
--     highlight = {
--       enable = true,
--       additional_vim_regex_highlighting = { 'ruby' },
--     },
--     indent = { enable = true, disable = { 'ruby', 'java' } },
--   },
-- },

vim.o.background = 'dark'
-- Adjust treesitter highlight for the gruvbox theme
local class_blue = '#8ec07c' -- A muted, reader-friendly blue
local groups = {
  '@type', -- Class names and general types
  '@constructor', -- 'new ClassName' calls
  '@type.builtin', -- int, double, etc. (Keep if you want them blue too)
  '@lsp.type.class', -- Semantic tokens from JDTLS
  '@lsp.type.interface',
}

for _, group in ipairs(groups) do
  vim.api.nvim_set_hl(0, group, { fg = class_blue, bold = true, force = true })
end

-- Change lsp highlighting color so it is not
vim.api.nvim_set_hl(0, 'LspReferenceText', { bg = '#4a4a4a', underline = true })
vim.api.nvim_set_hl(0, 'LspReferenceRead', { bg = '#4a4a4a', underline = true })
vim.api.nvim_set_hl(0, 'LspReferenceWrite', { bg = '#4a4a4a', underline = true })

-- Mute lsp progress notifications
vim.lsp.handlers['$/progress'] = function() end

-- vim.api.nvim_set_hl(0, "@variable.member", { fg = "#83a598", bold = false })
-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
