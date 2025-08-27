-- Discord Rich Presence support
return {
  {
    'vyfor/cord.nvim',
    build = ':Cord update',
    opts = {
      idle = {
        enabled = false,
      },
      workspace = {
          enabled = true, 
      },
      text = {
      
      },
      buttons = {
          label = "View Repository",
          url = function(opts)
            return opts.repo_url
          end,
      },
    },
  },
}
