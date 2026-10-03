return {
	{
		"catppuccin/nvim",
		lazy = false,    -- On veut charger le thème immédiatement au lancement
		priority = 1000, -- Haute priorité pour qu'il s'affiche avant le reste
		config = function()
			-- Cette fonction s'exécute quand le plugin est chargé
			vim.cmd("colorscheme catppuccin-mocha")
		end,
	},
}
