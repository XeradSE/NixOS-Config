return {
  -- add gruvbox
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 1000,
  },

  -- Configure LazyVim to load gruvbox
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "kanso-zen",
    },
  },
}
