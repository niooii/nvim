-- Web development environment for TypeScript, React, Tailwind, etc.
return {
  -- TypeScript/JavaScript LSP with inlay hints
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.ts_ls = {
        settings = {
          typescript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = 'all',
              includeInlayParameterNameHintsWhenArgumentMatchesName = true,
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
              includeInlayVariableTypeHintsWhenTypeMatchesName = true,
              includeInlayPropertyDeclarationTypeHints = true,
              includeInlayFunctionLikeReturnTypeHints = true,
              includeInlayEnumMemberValueHints = true,
            },
          },
        },
      }
      opts.servers.tailwindcss = {}
      opts.servers.emmet_ls = {
        filetypes = {
          'html',
          'css',
          'scss',
          'javascript',
          'javascriptreact',
          'typescript',
          'typescriptreact',
        },
      }
      opts.servers.eslint = {
        settings = {
          workingDirectory = { mode = 'auto' },
        },
      }
    end,
  },

  -- Enable inlay hints for TypeScript/JavaScript files
  {
    'nvim-treesitter/nvim-treesitter',
    config = function()
      vim.api.nvim_create_autocmd('LspAttach', {
        callback = function(args)
          local client = vim.lsp.get_client_by_id(args.data.client_id)
          if client and client.name == 'ts_ls' then
            vim.lsp.inlay_hint.enable(true, { bufnr = args.buf })
          end
        end,
      })
    end,
  },

  -- Auto-close and auto-rename HTML tags
  {
    'windwp/nvim-ts-autotag',
    event = { 'BufReadPre', 'BufNewFile' },
    ft = {
      'html',
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
      'svelte',
      'vue',
    },
    config = function()
      require('nvim-ts-autotag').setup()
    end,
  },

  -- Tailwind CSS color highlighting
  {
    'brenoprata10/nvim-highlight-colors',
    event = { 'BufReadPre', 'BufNewFile' },
    ft = {
      'css',
      'scss',
      'html',
      'javascript',
      'javascriptreact',
      'typescript',
      'typescriptreact',
    },
    config = function()
      require('nvim-highlight-colors').setup {
        render = 'virtual',
        virtual_symbol = '■',
        enable_tailwind = true,
      }
    end,
  },

  -- TypeScript import sorting and management
  {
    'neovim/nvim-lspconfig',
    opts = function(_, opts)
      vim.api.nvim_create_autocmd('BufWritePre', {
        pattern = { '*.ts', '*.tsx', '*.js', '*.jsx' },
        callback = function()
          vim.lsp.buf.code_action {
            context = {
              only = { 'source.organizeImports' },
            },
            apply = true,
          }
        end,
      })
    end,
  },

  -- Treesitter parsers for web languages
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      vim.list_extend(opts.ensure_installed, {
        'typescript',
        'tsx',
        'javascript',
        'jsdoc',
        'html',
        'css',
        'scss',
        'json',
        'graphql',
      })
    end,
  },
}
