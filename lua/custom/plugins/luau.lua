-- Luau / Roblox development: luau-lsp.nvim with Roblox/Rojo integrations
--
-- Note: This plugin manages luau_lsp automatically. Do NOT use lspconfig.luau_lsp.setup()

-- Ensure .luau files are detected
vim.filetype.add {
  extension = {
    luau = 'luau',
  },
}

return {
  -- Ensure Treesitter has the Luau parser
  {
    'nvim-treesitter/nvim-treesitter',
    opts = function(_, opts)
      opts.ensure_installed = opts.ensure_installed or {}
      if not vim.tbl_contains(opts.ensure_installed, 'luau') then
        table.insert(opts.ensure_installed, 'luau')
      end
    end,
  },

  -- Luau LSP with Roblox/Rojo integrations
  {
    'lopi-py/luau-lsp.nvim',
    dependencies = { 'nvim-lua/plenary.nvim' },
    ft = { 'luau' },
    opts = {
      platform = {
        type = 'roblox',
      },
      types = {
        roblox_security_level = 'PluginSecurity',
      },
      sourcemap = {
        enabled = true,
        autogenerate = true, -- runs rojo sourcemap --watch automatically
        rojo_project_file = 'default.project.json',
        sourcemap_file = 'sourcemap.json',
      },
    },
    config = function(_, opts)
      require('luau-lsp').setup(opts)
    end,
  },

  -- Selene linting for Lua/Luau via nvim-lint
  {
    'mfussenegger/nvim-lint',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local lint = require 'lint'
      lint.linters_by_ft = lint.linters_by_ft or {}
      lint.linters_by_ft.lua = lint.linters_by_ft.lua or { 'selene' }
      lint.linters_by_ft.luau = lint.linters_by_ft.luau or { 'selene' }

      local grp = vim.api.nvim_create_augroup('lint-luau', { clear = true })
      vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost', 'InsertLeave' }, {
        group = grp,
        callback = function()
          if vim.bo.modifiable then
            lint.try_lint()
          end
        end,
      })
    end,
  },
}
