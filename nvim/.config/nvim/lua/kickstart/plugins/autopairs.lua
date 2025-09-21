-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    local npairs = require 'nvim-autopairs'
    npairs.setup {}

    -- Integration with blink.cmp
    npairs.setup {
      enable_check_bracket_line = false,
    }
  end,
}
