return {
  {
    'NeogitOrg/neogit',
    dependencies = {
      'nvim-lua/plenary.nvim', -- required
      'sindrets/diffview.nvim', -- optional - Diff integration

      -- Only one of these is needed.
      -- 'nvim-telescope/telescope.nvim', -- optional
      -- 'ibhagwan/fzf-lua', -- optional
      -- 'nvim-mini/mini.pick', -- optional
      'folke/snacks.nvim', -- optional
    },
    keys = {
      {
        '<leader>gg',
        function()
          require('neogit').open { kind = 'floating' }
        end,
        desc = 'Open Neogit',
      },
    },
    config = function()
      local neogit = require 'neogit'
      neogit.setup {
        auto_refresh = true,
        auto_close_console = false,
        auto_show_console = false,
        integrations = {
          diffview = true,
          snacks = true,
        },
        mappings = {
          status = {
            ['k'] = 'MoveDown',
            ['l'] = 'MoveUp',
            ['j'] = false,
          },
          popup = {
            ['l'] = false,
            ['j'] = 'LogPopup',
          },
        },
        popup = {
          kind = 'floating',
        },
        stash = {
          kind = 'floating',
        },
        commit_editor = {
          kind = 'floating',
          staged_diff_split_kind = 'auto',
        },
        commit_view = {
          kind = 'floating',
        },
        preview_buffer = {
          kind = 'floating',
        },
      }
    end,
  },
}

-- Useful alias for git which switches to main, pulls, and deletes local branches that do not exist on remote:
--
-- [alias]
-- 	main-branch = !git symbolic-ref refs/remotes/origin/HEAD | cut -d "/" -f4
--     rm-gone = !git branch -vv | grep ': gone]' | awk '{print $1}' | xargs -r git branch -D
--     sync = !git switch $(git main-branch) && git pull --prune && git rm-gone
