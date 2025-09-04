-- Python development environment
-- Debugging, testing, and utilities for Python development
return {
  -- Python LSP
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.pyright = {
        settings = {
          python = {
            analysis = {
              autoSearchPaths = true,
              diagnosticMode = 'workspace',
              useLibraryCodeForTypes = true,
              typeCheckingMode = 'basic',
              autoImportCompletions = true,
              completeFunctionParens = true,
              indexing = true,
            },
          },
        },
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
        return vim.fn.exepath 'python3' or vim.fn.exepath 'python' or 'python'
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
              return vim.fn.exepath 'python3' or vim.fn.exepath 'python' or 'python'
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
        local cwd = vim.fn.getcwd()
        local uv_file = cwd .. 'pyproject.toml'
        if vim.fn.filereadable(uv_file) == 1 then
          vim.cmd 'terminal uv run python -m jupyterlab'
        else
          vim.cmd 'terminal jupyter lab'
        end
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

  -- Jupyter notebook integration with Molten
  {
    'benlubas/molten-nvim',
    version = '^1.0.0',
    dependencies = { '3rd/image.nvim' },
    build = ':UpdateRemotePlugins',
    ft = 'python',
    init = function()
      vim.g.molten_image_provider = 'image.nvim'
      vim.g.molten_output_win_max_height = 20
    end,
    config = function()
      vim.keymap.set('v', '<leader>pe', ':<C-u>MoltenEvaluateVisual<CR>gv', { desc = '[P]ython [E]valuate Selection' })
      vim.keymap.set('n', '<leader>pi', '<cmd>MoltenInit<CR>', { desc = '[P]ython Molten [I]nit' })
      vim.keymap.set('n', '<leader>pr', '<cmd>MoltenEvaluateLine<CR>', { desc = '[P]ython Molten [R]un Line' })
      vim.keymap.set('n', '<leader>po', '<cmd>MoltenShowOutput<CR>', { desc = '[P]ython Molten Show [O]utput' })
    end,
  },

  {
    '3rd/image.nvim',
    ft = 'python',
    opts = {
      backend = 'kitty',
      max_width = 100,
      max_height = 12,
      max_height_window_percentage = math.huge,
      max_width_window_percentage = math.huge,
      window_overlap_clear_enabled = true,
      window_overlap_clear_ft_ignore = { 'cmp_menu', 'cmp_docs', '' },
    },
  },

  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, { 'python' })
    end,
  },
}
