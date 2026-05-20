vim.pack.add { 'https://github.com/windwp/nvim-autopairs' }
require('nvim-autopairs').setup {
  event = 'InsertEnter',
  config = function()
    local npairs = require 'nvim-autopairs'
    local Rule = require 'nvim-autopairs.rule'
    local cond = require 'nvim-autopairs.conds'

    npairs.setup {
      enable_check_bracket_line = false,
      -- This helps with blink.cmp/nvim-cmp integration
      check_ts = true,
    }

    -- Add the rule for angle brackets
    npairs.add_rules {
      Rule('<', '>', { 'java', 'kotlin' })
        -- Only pair if the character before is a letter/number (like a Class name)
        -- This prevents pairing in 'if (a < b)'
        :with_pair(
          cond.before_regex '%a+'
        )
        -- Don't pair if the next character is already a '>'
        :with_move(function(opts)
          return opts.char == '>'
        end),
    }
  end,
}
