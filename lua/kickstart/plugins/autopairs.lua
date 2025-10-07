-- autopairs
-- https://github.com/windwp/nvim-autopairs

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  opts = {
    -- Enable bracket expansion on Enter
    enable_check_bracket_line = false,
    ignored_next_char = "[%w%.]", -- will ignore alphanumeric and `.` symbol
    check_ts = true, -- use treesitter to check for a pair
    ts_config = {
      lua = { 'string', 'comment' },
      javascript = { 'template_string' },
      typescript = { 'template_string' },
      java = false,
      c = {},
      cpp = {},
    },
    -- Handle Enter key for braces
    map_cr = true, -- map <CR> to insert enter if nothing after cursor
    map_complete = true, -- it will auto insert `end` or closing bracket
    auto_select = false, -- automatically select the text to complete
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
  },
  config = function(_, opts)
    local npairs = require('nvim-autopairs')
    npairs.setup(opts)

    -- Configure specific rules for better C++ brace handling
    local Rule = require('nvim-autopairs.rule')
    local cond = require('nvim-autopairs.conds')

    -- Add rule for {} expansion on Enter in C++ files
    npairs.add_rules({
      Rule('{', '}')
        :with_pair(cond.not_after_regex(' '))
        :with_move(cond.none())
        :with_del(cond.none())
        :with_cr(cond.done()),
    })
  end,
}
