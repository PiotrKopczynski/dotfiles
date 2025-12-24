return {
  {
    'nvim-treesitter/nvim-treesitter-textobjects',
    dependenciies = { 'nvim-treesitter' },
    config = function()
      require('nvim-treesitter.configs').setup {
        textobjects = {
          move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
              ['[f'] = '@function.outer',
              ['[['] = '@class.outer',
            },
            goto_next_end = {
              ['[F'] = '@function.outer',
              ['[]'] = '@class.outer',
            },
            goto_previous_start = {
              [']f'] = '@function.outer',
              [']['] = '@class.outer',
            },
            goto_previous_end = {
              [']F'] = '@function.outer',
              [']]'] = '@class.outer',
            },
          },
          select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            -- lookahead = true,
            keymaps = {
              -- Your custom capture.
              -- ["aF"] = "@custom_capture",
              -- Built-in captures.
              ['af'] = '@function.outer',
              ['if'] = '@function.inner',
            },
          },
        },
      }

      local ts_repeat_move = require 'nvim-treesitter.textobjects.repeatable_move'

      -- Repeat movement with ; and ,
      -- ensure ; goes forward and , goes backward regardless of the last direction
      vim.keymap.set({ 'n', 'x', 'o' }, ';', ts_repeat_move.repeat_last_move_next)
      vim.keymap.set({ 'n', 'x', 'o' }, ',', ts_repeat_move.repeat_last_move_previous)

      -- vim way: ; goes to the direction you were moving.
      -- vim.keymap.set({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
      -- vim.keymap.set({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

      -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
      vim.keymap.set({ 'n', 'x', 'o' }, 'f', ts_repeat_move.builtin_f_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'F', ts_repeat_move.builtin_F_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 't', ts_repeat_move.builtin_t_expr, { expr = true })
      vim.keymap.set({ 'n', 'x', 'o' }, 'T', ts_repeat_move.builtin_T_expr, { expr = true })
    end,
  },
}
