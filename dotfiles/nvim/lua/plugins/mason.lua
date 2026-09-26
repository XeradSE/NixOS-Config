return {
  {
    "mason-org/mason.nvim",
    opts = function(_, opts)
      -- Vide la liste des outils (linters/formateurs) forcés par LazyVim
      opts.ensure_installed = {}
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts = function(_, opts)
      -- Coupe l'installation automatique au chargement d'un fichier
      opts.automatic_installation = false
      -- Vide la liste des serveurs LSP forcés
      opts.ensure_installed = {}
    end,
  },
}
