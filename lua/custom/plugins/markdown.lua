-- Markdown support with live preview
return {
  -- Live markdown preview in browser
  {
    'brianhuster/live-preview.nvim',
    ft = 'markdown', -- only load for markdown files
    opts = {
      commands = {
        start = 'LivePreview',
        stop = 'StopPreview',
      },
      port = 5500,
      browser = 'default',
    },
    config = function(_, opts)
      require('livepreview').setup(opts)
      
      -- Keymaps for markdown preview
      vim.keymap.set('n', '<leader>mp', '<cmd>LivePreview<CR>', { desc = '[M]arkdown [P]review' })
      vim.keymap.set('n', '<leader>ms', '<cmd>StopPreview<CR>', { desc = '[M]arkdown [S]top preview' })
    end,
  },

  -- Enhanced markdown editing
  {
    'folke/which-key.nvim',
    opts = function(_, opts)
      -- Add markdown keybinding group to which-key
      opts.spec = vim.list_extend(opts.spec or {}, {
        { '<leader>m', group = '[M]arkdown' },
      })
      return opts
    end,
  },
}