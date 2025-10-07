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

      -- Buffer movement between windows (without changing window layout)
      local function move_buffer_to_window(direction)
        local current_win = vim.api.nvim_get_current_win()
        local current_buf = vim.api.nvim_get_current_buf()
        local current_win_config = vim.api.nvim_win_get_config(current_win)

        -- Get window positions for all windows (except floating)
        local windows = {}
        for _, win in ipairs(vim.api.nvim_list_wins()) do
          local config = vim.api.nvim_win_get_config(win)
          if not config.relative or config.relative == '' then -- Skip floating windows
            table.insert(windows, {
              id = win,
              winnr = vim.fn.win_id2win(win),
              row = vim.fn.win_screenpos(win)[1],
              col = vim.fn.win_screenpos(win)[2],
              width = config.width,
              height = config.height
            })
          end
        end

        -- Find current window in the list
        local current_info = nil
        for _, win_info in ipairs(windows) do
          if win_info.id == current_win then
            current_info = win_info
            break
          end
        end

        if not current_info then
          vim.notify('Current window not found', vim.log.levels.ERROR)
          return
        end

        -- Find target window based on visual position
        local target_win = nil
        local best_score = -1

        local current_center_y = current_info.row + current_info.height / 2
        local current_center_x = current_info.col + current_info.width / 2

        for _, win_info in ipairs(windows) do
          if win_info.id ~= current_win then
            local target_center_y = win_info.row + win_info.height / 2
            local target_center_x = win_info.col + win_info.width / 2
            local score = 0

            if direction == 'left' then
              -- Target must be to the left and have overlapping vertical range
              if target_center_x < current_center_x then
                local vertical_overlap = math.min(current_center_y, target_center_y + win_info.height/2) -
                                       math.max(current_center_y - current_info.height/2, target_center_y - win_info.height/2)
                local horizontal_distance = current_center_x - target_center_x
                score = vertical_overlap / horizontal_distance
              end
            elseif direction == 'right' then
              -- Target must be to the right and have overlapping vertical range
              if target_center_x > current_center_x then
                local vertical_overlap = math.min(current_center_y, target_center_y + win_info.height/2) -
                                       math.max(current_center_y - current_info.height/2, target_center_y - win_info.height/2)
                local horizontal_distance = target_center_x - current_center_x
                score = vertical_overlap / horizontal_distance
              end
            elseif direction == 'up' then
              -- Target must be above and have overlapping horizontal range
              if target_center_y < current_center_y then
                local horizontal_overlap = math.min(current_center_x, target_center_x + win_info.width/2) -
                                        math.max(current_center_x - current_info.width/2, target_center_x - win_info.width/2)
                local vertical_distance = current_center_y - target_center_y
                score = horizontal_overlap / vertical_distance
              end
            elseif direction == 'down' then
              -- Target must be below and have overlapping horizontal range
              if target_center_y > current_center_y then
                local horizontal_overlap = math.min(current_center_x, target_center_x + win_info.width/2) -
                                        math.max(current_center_x - current_info.width/2, target_center_x - win_info.width/2)
                local vertical_distance = target_center_y - current_center_y
                score = horizontal_overlap / vertical_distance
              end
            elseif direction == 'prev' then
              target_win = vim.fn.win_getid(vim.fn.winnr('#'))
              break
            end

            -- Keep the window with the best score
            if score > best_score then
              best_score = score
              target_win = win_info.id
            end
          end
        end

        -- Only proceed if we found a valid target window
        if target_win and target_win ~= current_win then
          -- Get the buffer in the target window
          local target_buf = vim.api.nvim_win_get_buf(target_win)

          -- Swap the buffers between windows
          vim.api.nvim_win_set_buf(current_win, target_buf)
          vim.api.nvim_win_set_buf(target_win, current_buf)

          -- Focus moves to the target window with our buffer
          vim.api.nvim_set_current_win(target_win)
        else
          vim.notify('No window in that direction', vim.log.levels.WARN)
        end
      end

      -- Keybindings for moving buffers between windows
      vim.keymap.set('n', '<leader>wm', function()
        vim.ui.select({'left', 'right', 'up', 'down', 'prev'}, {
          prompt = 'Move buffer to window:',
        }, function(choice)
          if choice then
            move_buffer_to_window(choice)
          end
        end)
      end, { desc = '[W]indow [M]ove buffer (interactive)' })

    
      -- Alt+Shift+hjkl for moving buffers between windows (no leader needed)
      vim.keymap.set('n', '<A-S-h>', function() move_buffer_to_window('left') end, { desc = 'Move buffer to left window', silent = true })
      vim.keymap.set('n', '<A-S-l>', function() move_buffer_to_window('right') end, { desc = 'Move buffer to right window', silent = true })
      vim.keymap.set('n', '<A-S-j>', function() move_buffer_to_window('down') end, { desc = 'Move buffer to window below', silent = true })
      vim.keymap.set('n', '<A-S-k>', function() move_buffer_to_window('up') end, { desc = 'Move buffer to window above', silent = true })
      vim.keymap.set('n', '<A-S-p>', function() move_buffer_to_window('prev') end, { desc = 'Move buffer to previous window', silent = true })

      -- Window highlighting for current window
      vim.api.nvim_create_autocmd('WinEnter', {
        callback = function()
          vim.wo.winhighlight = 'Normal:Normal,NormalNC:NormalNC'
        end,
        desc = 'Highlight current window'
      })

      vim.api.nvim_create_autocmd('WinLeave', {
        callback = function()
          vim.wo.winhighlight = 'Normal:NormalNC,NormalNC:NormalNC'
        end,
        desc = 'Dim inactive windows'
      })

      -- Define the highlight groups with moderate dimming
      local normal_bg = vim.api.nvim_get_hl(0, { name = 'Normal' }).bg or '#000000'
      local normal_fg = vim.api.nvim_get_hl(0, { name = 'Normal' }).fg or '#ffffff'
      vim.api.nvim_set_hl(0, 'NormalNC', {
        bg = normal_bg,
        -- Dim the foreground for inactive windows (less drastic than before)
        fg = normal_fg - 0x202020,
        bold = false,
        italic = false,
      })

      -- Also set window separator highlights to make borders more visible
      vim.api.nvim_set_hl(0, 'WinSeparator', {
        fg = '#444444',
        bg = 'NONE',
      })

      -- Highlight for vertical and horizontal window separators
      vim.api.nvim_set_hl(0, 'VertSplit', {
        fg = '#444444',
        bg = 'NONE',
      })
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

  -- Multi-file search and replace
  {
    'nvim-pack/nvim-spectre',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('spectre').setup {
        color_devicons = true,
        highlight = {
          ui = 'String',
          search = 'DiffChange',
          replace = 'DiffDelete',
        },
        mapping = {
          ['toggle_line'] = {
            map = 'dd',
            cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
            desc = 'toggle current item',
          },
          ['enter_file'] = {
            map = '<cr>',
            cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
            desc = 'goto current file',
          },
          ['send_to_qf'] = {
            map = '<leader>q',
            cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
            desc = 'send all item to quickfix',
          },
          ['replace_cmd'] = {
            map = '<leader>c',
            cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
            desc = 'input replace vim command',
          },
          ['show_option_menu'] = {
            map = '<leader>o',
            cmd = "<cmd>lua require('spectre').show_options()<CR>",
            desc = 'show option',
          },
          ['run_current_replace'] = {
            map = '<leader>rc',
            cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
            desc = 'replace current line',
          },
          ['run_replace'] = {
            map = '<leader>R',
            cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
            desc = 'replace all',
          },
          ['change_view_mode'] = {
            map = '<leader>v',
            cmd = "<cmd>lua require('spectre').change_view()<CR>",
            desc = 'change result view mode',
          },
        },
      }

      -- Keymaps for multi-file search and replace
      vim.keymap.set('n', '<leader>sR', '<cmd>lua require("spectre").toggle()<CR>', {
        desc = '[S]earch and [R]eplace in files',
      })
      vim.keymap.set('n', '<leader>sp', '<cmd>lua require("spectre").open_visual({select_word=true})<CR>', {
        desc = '[S]earch and replace current word in [P]roject',
      })
      vim.keymap.set('v', '<leader>sp', '<esc><cmd>lua require("spectre").open_visual()<CR>', {
        desc = '[S]earch and replace selection in [P]roject',
      })
      vim.keymap.set('n', '<leader>sc', '<cmd>lua require("spectre").open_file_search({select_word=true})<CR>', {
        desc = '[S]earch and replace in [C]urrent file',
      })
    end,
  },

  -- Additional IDE quality-of-life improvements
  {
    'folke/which-key.nvim',
    opts = function(_, opts)
      -- Add our new keybinding groups to which-key
      opts.spec = vim.list_extend(opts.spec or {}, {
        { '<leader>b', group = '[B]uffer' },
        { '<leader>w', group = '[W]indow' },
        { '<leader>s', group = '[S]earch' },
      })
      return opts
    end,
  },
}

