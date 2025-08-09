-- A collection of plugins to create a CLion-like C++ development environment
return {
  -- LSP-based syntax highlighting (not treesitter its bugged???)
  {
    'jackguo380/vim-lsp-cxx-highlight',
    event = { 'BufReadPre', 'BufNewFile' },
    dependencies = { 'neovim/nvim-lspconfig' },
  },

  {
    'mfussenegger/nvim-dap',
    dependencies = {
      { 'rcarriga/nvim-dap-ui', dependencies = { 'nvim-neotest/nvim-nio' } },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      -- Keymaps for debugging
      vim.keymap.set('n', '<leader>db', dap.toggle_breakpoint, { desc = '[D]ebug: Toggle [B]reakpoint' })
      vim.keymap.set('n', '<leader>dc', dap.continue, { desc = '[D]ebug: [C]ontinue' })
      vim.keymap.set('n', '<leader>do', dap.step_over, { desc = '[D]ebug: Step [O]ver' })
      vim.keymap.set('n', '<leader>di', dap.step_into, { desc = '[D]ebug: Step [I]nto' })
      vim.keymap.set('n', '<leader>du', dap.step_out, { desc = '[D]ebug: Step O[u]t' })
      vim.keymap.set('n', '<leader>dt', dapui.toggle, { desc = '[D]ebug: [T]oggle UI' })

      dapui.setup()

      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end
    end,
  },

  {
    'Civitasv/cmake-tools.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('cmake-tools').setup {
        cmake_command = 'cmake',
        cmake_build_directory = function()
          return 'build'
        end,
        cmake_generate_options = { '-DCMAKE_EXPORT_COMPILE_COMMANDS=ON' },
        cmake_soft_link_compile_commands = true, -- Auto creates symlink
      }

      -- Auto-generate on project open
      -- Only regenerate if CMakeLists.txt was modified after compile_commands.json
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          local cmake_file = 'CMakeLists.txt'
          local compile_commands = 'compile_commands.json'

          if vim.fn.filereadable(cmake_file) == 0 then
            return -- not cmake
          end

          if vim.fn.filereadable(compile_commands) == 0 then
            vim.notify('No compile_commands.json found, generating...', vim.log.levels.INFO)
            vim.cmd 'CMakeGenerate'
            return
          end

          -- Check modification times (only regen if its newer than before)
          local cmake_mtime = vim.fn.getftime(cmake_file)
          local cc_mtime = vim.fn.getftime(compile_commands)

          if cmake_mtime > cc_mtime then
            vim.notify('CMakeLists.txt changed, regenerating...', vim.log.levels.INFO)
            vim.cmd 'CMakeGenerate'
          end
        end,
      })
    end,
  },

  -- a sidebar with a navigable tree of symbols in the current file.
  {
    'stevearc/aerial.nvim',
    opts = {},
    dependencies = {
      'nvim-treesitter/nvim-treesitter',
      'nvim-tree/nvim-web-devicons',
    },
    config = function()
      require('aerial').setup()
      vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle<CR>', { desc = 'Toggle [A]erial (Code Outline)' })
    end,
  },
}
