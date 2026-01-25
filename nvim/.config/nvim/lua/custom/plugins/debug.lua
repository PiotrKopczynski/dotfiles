return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- ui plugins to simplify debugging
      'rcarriga/nvim-dap-ui',
      'nvim-neotest/nvim-nio',
    },
    config = function()
      -- gain access to the plugins and their functions
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- Setup the dap ui with default configuration
      dapui.setup {
        element_mappings = {
          stacks = {
            open = '<CR>',
            expand = 'o',
          },
        },
      }

      -- setup an event listener for when the debugger is launched or attached
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end

      -- dap.listeners.before.event_terminated['dapui_config'] = function()
      --   dapui.close()
      -- end
      --
      -- dap.listeners.before.event_exited['dapui_config'] = function()
      --   dapui.close()
      -- end

      -- Configure how the debugger attaches
      dap.configurations.java = {
        {
          type = 'java',
          request = 'attach',
          name = 'Remote Debug',
          hostName = 'localhost',
          port = 5005,
        },
      }

      -- Define the sign for breakpoints
      vim.fn.sign_define('DapBreakpoint', {
        text = '●',
        texthl = 'DapBreakpoint',
        linehl = '',
        numhl = '',
      })
      vim.api.nvim_set_hl(0, 'DapBreakpoint', { link = 'DiagnosticError' })
      vim.fn.sign_define('DapBreakpointCondition', { text = '', texthl = 'DapBreakpoint', linehl = '', numhl = '' })
      vim.api.nvim_set_hl(0, 'DapBreakpointCondition', { link = 'DiagnosticError' })

      -- Open and close the DAP UI
      vim.keymap.set('n', '<leader>du', function()
        local dapui = require 'dapui'

        -- Check if any dapui window is currently open
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local buf = vim.api.nvim_win_get_buf(win)
          local ft = vim.api.nvim_get_option_value('filetype', { buf = buf })
          if ft:match '^dapui_' then
            -- Found a dapui window, so close the UI
            dapui.close()
            return
          end
        end

        -- No dapui windows found, so open the UI
        dapui.open()
      end, { desc = 'Toggle DAP UI' })

      -- set keymapping to toggle a breakpoint at the line where the cursor is currently at
      vim.keymap.set({ 'n', 'v' }, '<leader>db', dap.toggle_breakpoint, { desc = '[Debug] Toggle [B]reakpoint' })
      -- start debugger and launch the debugging ui
      vim.keymap.set({ 'n', 'v' }, '<leader>dd', dap.continue, { desc = 'Debug Start' })
      -- close the debugging ui
      vim.keymap.set('n', '<F9>', dap.continue, { desc = 'Debug: Start/Continue' })
      vim.keymap.set('n', '<F8>', dap.step_over, { desc = 'Debug: Step Over' })
      vim.keymap.set('n', '<F10>', dap.step_into, { desc = 'Debug: Step Into' })
      vim.keymap.set('n', '<11>', dap.step_out, { desc = 'Debug: Step Out' })
      vim.keymap.set('n', '<leader>dB', function()
        dap.set_breakpoint(vim.fn.input 'Breakpoint condition: ')
      end, { desc = 'Debug: Set Conditional Breakpoint' })
      vim.keymap.set('n', '<F12>', dap.run_to_cursor, { desc = 'Debug: Run to Cursor' })
      vim.keymap.set('n', '<F7>', dap.terminate, { desc = 'Debug: Terminate' })
      -- Stop dap and close the dap ui
      vim.keymap.set({ 'n', 'v' }, '<leader>dc', function()
        require('dap').close()
        require('dapui').close()
      end, { desc = '[D]ebug [C]lose (Session & UI)' })
      -- Disconnect from remote debugging
      vim.keymap.set({ 'n', 'v' }, '<leader>dD', function()
        require('dap').disconnect()
        require('dapui').close()
      end, { desc = 'Debug: [D]isconnect and Close UI' })
      -- Evaluate expression
      vim.keymap.set('n', '<leader>dE', function()
        local dap = require 'dap'

        -- Check if we're in a debug session
        if not dap.session() then
          vim.notify('Not in a debug session', vim.log.levels.WARN)
          return
        end

        -- Create a floating scratch buffer for input
        local input_buf = vim.api.nvim_create_buf(false, true)
        local output_buf = vim.api.nvim_create_buf(false, true)

        local width = math.floor(vim.o.columns * 0.6)
        local input_height = 8
        local output_height = math.floor(vim.o.lines * 0.4) - input_height - 2
        local row = math.floor((vim.o.lines - (input_height + output_height + 2)) / 2)
        local col = math.floor((vim.o.columns - width) / 2)

        -- Create input window (top)
        local input_win = vim.api.nvim_open_win(input_buf, true, {
          relative = 'editor',
          width = width,
          height = input_height,
          row = row,
          col = col,
          style = 'minimal',
          border = 'rounded',
          title = ' Evaluate Expression (Press <CR> to evaluate, <Esc> to close) ',
          title_pos = 'center',
        })

        -- Create output window (bottom)
        local output_win = vim.api.nvim_open_win(output_buf, false, {
          relative = 'editor',
          width = width,
          height = output_height,
          row = row + input_height + 2,
          col = col,
          style = 'minimal',
          border = 'rounded',
          title = ' Results ',
          title_pos = 'center',
        })

        -- Set filetype to java for LSP support in input buffer
        vim.api.nvim_set_option_value('filetype', 'java', { buf = input_buf })
        vim.api.nvim_set_option_value('buftype', 'nofile', { buf = input_buf })

        -- Make output buffer read-only
        vim.api.nvim_set_option_value('buftype', 'nofile', { buf = output_buf })
        vim.api.nvim_set_option_value('modifiable', false, { buf = output_buf })

        -- Function to evaluate and show results
        local function evaluate()
          local lines = vim.api.nvim_buf_get_lines(input_buf, 0, -1, false)
          local expr = table.concat(lines, '\n'):gsub('^%s+', ''):gsub('%s+$', '')

          if expr == '' then
            return
          end

          -- Evaluate the expression
          dap.session():evaluate(expr, function(err, result)
            vim.schedule(function()
              -- Make output buffer temporarily modifiable
              vim.api.nvim_set_option_value('modifiable', true, { buf = output_buf })

              -- Get existing content
              local existing = vim.api.nvim_buf_get_lines(output_buf, 0, -1, false)

              -- Add separator if buffer has content
              if #existing > 0 and existing[1] ~= '' then
                table.insert(existing, '')
                table.insert(existing, '---')
                table.insert(existing, '')
              end

              -- Add expression (split by newlines)
              for _, line in ipairs(vim.split(expr, '\n', { plain = true })) do
                table.insert(existing, '> ' .. line)
              end

              -- Add result (split by newlines to handle multi-line results)
              if err then
                local err_str = type(err) == 'string' and err or vim.inspect(err)
                for _, line in ipairs(vim.split(err_str, '\n', { plain = true })) do
                  table.insert(existing, 'Error: ' .. line)
                end
              elseif result then
                local result_str = result.result or vim.inspect(result)
                for _, line in ipairs(vim.split(result_str, '\n', { plain = true })) do
                  table.insert(existing, '= ' .. line)
                end
              end

              -- Set all lines at once
              vim.api.nvim_buf_set_lines(output_buf, 0, -1, false, existing)

              -- Scroll to bottom
              local line_count = vim.api.nvim_buf_line_count(output_buf)
              vim.api.nvim_win_set_cursor(output_win, { line_count, 0 })

              -- Make read-only again
              vim.api.nvim_set_option_value('modifiable', false, { buf = output_buf })
            end)
          end)

          -- Clear input buffer for next expression
          -- vim.api.nvim_buf_set_lines(input_buf, 0, -1, false, { '' })
        end

        -- Keybindings for input buffer
        vim.keymap.set('n', '<CR>', evaluate, { buffer = input_buf, desc = 'Evaluate' })
        vim.keymap.set('i', '<C-CR>', function()
          vim.cmd 'stopinsert'
          evaluate()
          vim.cmd 'startinsert'
        end, { buffer = input_buf, desc = 'Evaluate and continue' })

        -- Close both windows
        vim.keymap.set('n', '<Esc>', function()
          vim.api.nvim_win_close(input_win, true)
          vim.api.nvim_win_close(output_win, true)
        end, { buffer = input_buf, desc = 'Close' })

        -- Also add Esc to output buffer
        vim.keymap.set('n', '<Esc>', function()
          vim.api.nvim_win_close(input_win, true)
          vim.api.nvim_win_close(output_win, true)
        end, { buffer = output_buf, desc = 'Close' })

        -- Switch between windows
        vim.keymap.set('n', '<Tab>', function()
          vim.api.nvim_set_current_win(output_win)
        end, { buffer = input_buf, desc = 'Go to results' })

        vim.keymap.set('n', '<Tab>', function()
          vim.api.nvim_set_current_win(input_win)
        end, { buffer = output_buf, desc = 'Go to input' })

        -- Start in insert mode
        vim.cmd 'startinsert'
      end, { desc = 'Debug: Evaluate Expression' })
    end,
  },
  {
    'jay-babu/mason-nvim-dap.nvim',
    config = function()
      require('mason-nvim-dap').setup {
        ensure_installed = { 'java-debug-adapter', 'java-test' },
      }
    end,
  },
}
