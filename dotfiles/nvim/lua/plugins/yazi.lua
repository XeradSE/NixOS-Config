return {
  "mikavilpas/yazi.nvim",
  event = "VeryLazy",
  keys = {
    -- Raccourci pour ouvrir Yazi dans le dossier du fichier actuel
    {
      "<leader>e", 
      "<cmd>Yazi<cr>",
      desc = "Ouvrir Yazi",
    },
    -- Raccourci pour ouvrir Yazi à la racine de ton projet entier
    {
      "<leader>cw",
      "<cmd>Yazi cwd<cr>",
      desc = "Yazi (Racine du projet)",
    },
    -- Optionnel : Raccourci pour ouvrir Yazi au-dessus de tout
    {
      "<c-up>",
      "<cmd>Yazi toggle<cr>",
      desc = "Reprendre la dernière session Yazi",
    },
  },
  opts = {
    -- Ouvre Yazi en tant qu'explorateur par défaut à la place de netrw
    open_for_directories = true,
    
    -- Le style de la fenêtre flottante
    floating_window_scaling_factor = 0.9, -- Prend 90% de l'écran
    yazi_floating_window_border = "rounded",
  },
}
