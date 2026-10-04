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

    -- On entre dans le dossier 'render' avant de lancer npm
    build = "cd render && npm install",

    ft = 'markdown',
    keys = { { '<leader>mp', '<cmd>Vellum<cr>', desc = 'Markdown preview' } },
    opts = {},
  }
}
