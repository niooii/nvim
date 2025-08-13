-- IDE-like enhancements for a better development experience
return {
  -- Buffer line for tab-like interface
  {
    'akinsho/bufferline.nvim',
    event = 'VeryLazy',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      options = {
        show_buffer_close_icons = false,
        show_close_icon = false,
        separator_style = 'slant',
        always_show_bufferline = true,
        offsets = {
          {
            filetype = 'neo-tree',
            text = 'File Explorer',
            text_align = 'center',
            separator = true,
          },
        },
      },
    },
  },

  -- Enhanced window/split management
  {
    'mrjones2014/smart-splits.nvim',
    opts = {},
    config = function()
      local smart_splits = require 'smart-splits'
      smart_splits.setup()

      -- Enhanced split creation (tmux-like)
      vim.keymap.set('n', '<leader>%', '<cmd>vsplit<CR>', { desc = 'Split window vertically' })
      vim.keymap.set('n', '<leader>"', '<cmd>split<CR>', { desc = 'Split window horizontally' })

      -- Window resizing with Alt+Arrow keys
      vim.keymap.set('n', '<A-Left>', smart_splits.resize_left, { desc = 'Resize window left' })
      vim.keymap.set('n', '<A-Right>', smart_splits.resize_right, { desc = 'Resize window right' })
      vim.keymap.set('n', '<A-Up>', smart_splits.resize_up, { desc = 'Resize window up' })
      vim.keymap.set('n', '<A-Down>', smart_splits.resize_down, { desc = 'Resize window down' })

      -- Better buffer navigation (terminal-friendly alternatives to Ctrl+Tab)
      vim.keymap.set('n', ']b', '<cmd>bnext<CR>', { desc = 'Next buffer' })
      vim.keymap.set('n', '[b', '<cmd>bprevious<CR>', { desc = 'Previous buffer' })
      vim.keymap.set('n', '<leader>bn', '<cmd>bnext<CR>', { desc = '[B]uffer [N]ext' })
      vim.keymap.set('n', '<leader>bp', '<cmd>bprevious<CR>', { desc = '[B]uffer [P]revious' })
      vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[B]uffer [D]elete' })

      -- Jump to specific buffer by number (Alt+1, Alt+2, etc.)
      for i = 1, 9 do
        vim.keymap.set('n', '<A-' .. i .. '>', '<cmd>BufferLineGoToBuffer ' .. i .. '<CR>', { desc = 'Go to buffer ' .. i })
      end

      -- Quick close window
      vim.keymap.set('n', '<leader>wc', '<cmd>close<CR>', { desc = '[W]indow [C]lose' })
      vim.keymap.set('n', '<leader>wo', '<cmd>only<CR>', { desc = '[W]indow [O]nly' })
    end,
  },

  -- Better file tree integration and IDE behavior
  {
    'nvim-neo-tree/neo-tree.nvim',
    opts = {
      filesystem = {
        follow_current_file = {
          enabled = true,
          leave_dirs_open = true,
        },
        use_libuv_file_watcher = true,
        window = {
          position = 'left',
          width = 35,
          mappings = {
            ['\\'] = 'close_window',
            ['<space>'] = 'none', -- disable space mapping to avoid conflicts
          },
        },
      },
      window = {
        auto_expand_width = false,
        width = 35,
      },
      default_component_configs = {
        indent = {
          with_expanders = true,
          expander_collapsed = '',
          expander_expanded = '',
        },
        git_status = {
          symbols = {
            added = '+',
            modified = '~',
            deleted = '✖',
            renamed = '',
            untracked = '?',
            ignored = '',
            unstaged = 'U',
            staged = 'S',
            conflict = '',
          },
        },
      },
    },
  },

  -- Additional IDE quality-of-life improvements
  {
    'folke/which-key.nvim',
    opts = function(_, opts)
      -- Add our new keybinding groups to which-key
      opts.spec = vim.list_extend(opts.spec or {}, {
        { '<leader>b', group = '[B]uffer' },
        { '<leader>w', group = '[W]indow' },
        -- { '<leader>d', group = '[D]iagnostic' },
      })
      return opts
    end,
  },
}

