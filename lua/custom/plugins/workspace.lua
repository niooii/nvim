-- Full workspace session management - saves tabs, splits, and optionally terminals per directory
return {
  {
    'rmagatti/auto-session',
    opts = {
      -- Directory-based sessions
      log_level = 'error',
      auto_session_enable_last_session = false,
      auto_session_root_dir = vim.fn.stdpath('data') .. "/sessions/",
      auto_session_enabled = true,
      auto_save_enabled = true,
      auto_restore_enabled = true,
      
      -- Save everything: buffers, window layout, splits, etc.
      auto_session_suppress_dirs = nil,  -- Don't suppress any directories
      
      -- Include terminal sessions (optional - you can disable if you don't want terminals saved)
      session_lens = {
        buftypes_to_ignore = {}, -- Save all buffer types including terminals
        load_on_setup = true,
      },
      
      -- Hooks for custom behavior
      pre_save_cmds = {
        -- Close neo-tree before saving to avoid issues
        function()
          local neo_tree = require('neo-tree.command')
          neo_tree.execute({ action = 'close' })
        end
      },
      
      post_restore_cmds = {
        -- Reopen neo-tree after restoring if needed
        -- (uncomment if you want neo-tree to auto-open)
        -- function()
        --   require('neo-tree.command').execute({ action = 'show' })
        -- end
      },
    },
    config = function(_, opts)
      require('auto-session').setup(opts)
      
      -- Add some manual controls
      vim.keymap.set('n', '<leader>ws', '<cmd>SessionSave<CR>', { desc = '[W]orkspace [S]ave' })
      vim.keymap.set('n', '<leader>wr', '<cmd>SessionRestore<CR>', { desc = '[W]orkspace [R]estore' })
      vim.keymap.set('n', '<leader>wd', '<cmd>SessionDelete<CR>', { desc = '[W]orkspace [D]elete' })
      vim.keymap.set('n', '<leader>wl', '<cmd>Autosession search<CR>', { desc = '[W]orkspace [L]ist' })
    end,
  },
}