return {
  -- Markview
  {
    -- For `plugins/markview.lua` users.
    "OXY2DEV/markview.nvim",
    lazy = false,

    -- Completion for `blink.cmp`
    -- dependencies = { "saghen/blink.cmp" },
  },
  -- Vellum
  {
    'blackhat-7/vellum.nvim',
    
    -- C'EST CETTE LIGNE QUI EST CRUCIALE POUR NODE.JS :
    build = "npm install",
    
    ft = 'markdown',
    keys = { { '<leader>mp', '<cmd>Vellum<cr>', desc = 'Markdown preview' } },
    opts = {},
  }
}
