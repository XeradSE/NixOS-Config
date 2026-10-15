return {
  {
    "oxidescheme/nvim",
    name = "oxide",
    lazy = false,    -- On veut charger le thème immédiatement au lancement
    priority = 1000, -- Haute priorité pour qu'il s'affiche avant le reste
    config = function()
      -- 1. On configure le thème pour activer la transparence
      require("oxide").setup({
        transparent_background = true, -- C'est cette ligne qui fait la magie !
      })
      -- Cette fonction s'exécute quand le plugin est chargé
      vim.cmd("colorscheme oxidescheme")
    end,
  },
}
