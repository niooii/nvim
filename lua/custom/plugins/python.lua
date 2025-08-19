-- Python development environment with Pylance-like functionality using pyright
-- Optimized for uv virtual environment management
return {
  -- Enhanced Python LSP with virtual environment detection
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = "workspace",
              useLibraryCodeForTypes = true,
              typeCheckingMode = "basic", -- can be "basic", "strict", or "off"
              autoImportCompletions = true,
              completeFunctionParens = true,
              indexing = true,
            },
            -- Auto-detect virtual environment from uv/pip
            venvPath = vim.fn.getcwd(),
            pythonPath = function()
              -- Check for uv .venv first, then fallback to system python
              local cwd = vim.fn.getcwd()
              local uv_venv = cwd .. '/.venv/bin/python'
              if vim.fn.executable(uv_venv) == 1 then
                return uv_venv
              end
              -- Fallback to system python
              return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
            end,
          }
        },
        before_init = function(_, config)
          -- Dynamically set python path before LSP starts
          local cwd = vim.fn.getcwd()
          local uv_venv = cwd .. '/.venv/bin/python'
          if vim.fn.executable(uv_venv) == 1 then
            config.settings.python.pythonPath = uv_venv
          end
        end,
      }
    end,
  },

  -- Python debugging with debugpy
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      { 'rcarriga/nvim-dap-ui', dependencies = { 'nvim-neotest/nvim-nio' } },
      'mfussenegger/nvim-dap-python',
    },
    ft = 'python',
    config = function()
      local dap = require 'dap'
      local dap_python = require 'dap-python'

      -- Auto-detect Python interpreter from uv venv
      local function get_python_path()
        local cwd = vim.fn.getcwd()
        local uv_venv = cwd .. '/.venv/bin/python'
        if vim.fn.executable(uv_venv) == 1 then
          return uv_venv
        end
        return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
      end

      dap_python.setup(get_python_path())

      vim.keymap.set('n', '<leader>pm', function()
        dap_python.test_method()
      end, { desc = '[P]ython Debug Test [M]ethod' })

      vim.keymap.set('n', '<leader>pc', function()
        dap_python.test_class()
      end, { desc = '[P]ython Debug Test [C]lass' })

      vim.keymap.set('v', '<leader>ps', function()
        dap_python.debug_selection()
      end, { desc = '[P]ython Debug [S]election' })
    end,
  },

  {
    'nvim-neotest/neotest',
    dependencies = {
      'nvim-neotest/nvim-nio',
      'nvim-lua/plenary.nvim',
      'antoinemadec/FixCursorHold.nvim',
      'nvim-treesitter/nvim-treesitter',
      'nvim-neotest/neotest-python',
    },
    ft = 'python',
    config = function()
      require('neotest').setup {
        adapters = {
          require 'neotest-python' {
            dap = { justMyCode = false },
            -- Auto-detect Python interpreter from uv venv
            python = function()
              local cwd = vim.fn.getcwd()
              local uv_venv = cwd .. '/.venv/bin/python'
              if vim.fn.executable(uv_venv) == 1 then
                return uv_venv
              end
              return vim.fn.exepath('python3') or vim.fn.exepath('python') or 'python'
            end,
            pytest_discover_instances = true,
          },
        },
        discovery = {
          enabled = false, -- Disabl discovery for performance
        },
      }

      -- Test keybindings
      vim.keymap.set('n', '<leader>tt', function()
        require('neotest').run.run()
      end, { desc = '[T]est: Run Nearest [T]est' })

      vim.keymap.set('n', '<leader>tf', function()
        require('neotest').run.run(vim.fn.expand '%')
      end, { desc = '[T]est: Run [F]ile' })

      vim.keymap.set('n', '<leader>td', function()
        require('neotest').run.run { strategy = 'dap' }
      end, { desc = '[T]est: [D]ebug Nearest Test' })

      vim.keymap.set('n', '<leader>to', function()
        require('neotest').output.open { enter = true }
      end, { desc = '[T]est: Show [O]utput' })

      vim.keymap.set('n', '<leader>ts', function()
        require('neotest').summary.toggle()
      end, { desc = '[T]est: Toggle [S]ummary' })
    end,
  },

  -- Python-specific utilities and features
  {
    'linux-cultist/venv-selector.nvim',
    dependencies = { 'nvim-telescope/telescope.nvim' },
    ft = 'python',
    config = function()
      require('venv-selector').setup {
        dap_enabled = true, 
        -- Look for uv venvs first
        name = {
          'venv',
          '.venv',
          'env',
          '.env',
        },
      }

      vim.keymap.set('n', '<leader>pv', '<cmd>VenvSelect<CR>', { desc = '[P]ython Select [V]env' })
      vim.keymap.set('n', '<leader>pj', function()
        vim.cmd('terminal jupyter lab')
      end, { desc = '[P]ython Start [J]upyter Lab' })
    end,
  },

  {
    'Vimjas/vim-python-pep8-indent',
    ft = 'python',
  },

  {
    'danymat/neogen',
    ft = 'python',
    config = function()
      require('neogen').setup {
        enabled = true,
        languages = {
          python = {
            template = {
              annotation_convention = 'google_docstrings',
            },
          },
        },
      }

      vim.keymap.set('n', '<leader>pd', function()
        require('neogen').generate { type = 'func' }
      end, { desc = '[P]ython Generate [D]ocstring' })
    end,
  },

  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'python' })
    end,
  },
}
