return {
  {
    "kristijanhusak/vim-dadbod-ui",
    dependencies = {
      { "tpope/vim-dadbod", lazy = true },
      { "kristijanhusak/vim-dadbod-completion", ft = { "sql", "mysql", "plsql" }, lazy = true },
    },
    cmd = {
      "DBUI",
      "DBUIToggle",
      "DBUIAddConnection",
      "DBUIFindBuffer",
    },
    init = function()
      -- Pour avoir de belles icônes dans le panneau latéral
      vim.g.db_ui_use_nerd_fonts = 1
      -- Optionnel : où sauvegarder l'historique des requêtes
      vim.g.db_ui_save_location = vim.fn.stdpath("data") .. "/db_ui"
    end,
  },
  -- 2. L'injection dans nvim-cmp
  {
    "hrsh7th/nvim-cmp",
    opts = function()
      local cmp = require("cmp")

      -- On dit à cmp de rajouter cette règle spécifique :
      -- Si le fichier est du SQL, utilise la source dadbod.
      cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
        sources = cmp.config.sources({
          { name = "vim-dadbod-completion" },
        }, {
          { name = "buffer" },
        }),
      })
    end,
  },
}
