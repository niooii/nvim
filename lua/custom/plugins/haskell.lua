-- Haskell development environment with LSP and Cabal support
-- HLS is handled by haskell-tools.nvim automatically
return {

  {
    'mrcjkb/haskell-tools.nvim',
    version = '^4', -- Use latest stable version
    lazy = false, -- Load immediately for Haskell files
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    config = function()
      -- haskell-tools.nvim auto-configures itself, just set up keybindings
      vim.api.nvim_create_autocmd('FileType', {
        pattern = { 'haskell', 'lhaskell', 'cabal', 'cabalproject' },
        callback = function()
          local ht = require 'haskell-tools'
          local bufnr = vim.api.nvim_get_current_buf()

          -- Haskell-tools specific keybindings
          vim.keymap.set('n', '<leader>hb', ht.repl.toggle, { desc = '[H]askell REPL toggle', buffer = bufnr })
          vim.keymap.set('n', '<leader>hh', ht.hoogle.hoogle_signature, { desc = '[H]oogle signature', buffer = bufnr })
          vim.keymap.set('n', '<leader>he', ht.lsp.buf_eval_all, { desc = '[H]askell [E]val all', buffer = bufnr })

          -- Build system commands
          local root_dir = vim.fn.getcwd()
          if vim.fn.filereadable(root_dir .. '/cabal.project') == 1 or vim.fn.glob(root_dir .. '/*.cabal') ~= '' then
            vim.keymap.set('n', '<leader>hc', '<cmd>!cabal build<CR>', { desc = '[H]askell [C]ompile (Cabal)', buffer = bufnr })
            vim.keymap.set('n', '<leader>hr', '<cmd>!cabal run<CR>', { desc = '[H]askell [R]un (Cabal)', buffer = bufnr })
            vim.keymap.set('n', '<leader>ht', '<cmd>!cabal test<CR>', { desc = '[H]askell [T]est (Cabal)', buffer = bufnr })
          elseif vim.fn.filereadable(root_dir .. '/stack.yaml') == 1 then
            vim.keymap.set('n', '<leader>hc', '<cmd>!stack build<CR>', { desc = '[H]askell [C]ompile (Stack)', buffer = bufnr })
            vim.keymap.set('n', '<leader>hr', '<cmd>!stack run<CR>', { desc = '[H]askell [R]un (Stack)', buffer = bufnr })
            vim.keymap.set('n', '<leader>ht', '<cmd>!stack test<CR>', { desc = '[H]askell [T]est (Stack)', buffer = bufnr })
          end
        end,
      })
    end,
  },

  -- Better Cabal file support
  {
    'Twinside/vim-haskellConceal',
    ft = 'haskell',
    config = function()
      -- Enable concealing for better readability (optional)
      vim.g.haskell_conceal_wide = 1
      vim.g.haskell_conceal_enumerations = 1
    end,
  },
}

