return {
  -- On désactive purement et simplement tout l'écosystème Mason
  { "williamboman/mason.nvim", enabled = false },
  { "mason-org/mason-lspconfig.nvim", enabled = false },

  -- Si LazyVim a ajouté d'autres ponts vers Mason, on les coupe aussi
  { "WhoIsSethDaniel/mason-tool-installer.nvim", enabled = false },
}
