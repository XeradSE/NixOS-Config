local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	{
		"catppuccin/nvim",
		lazy = false,    -- On veut charger le thème immédiatement au lancement
		priority = 1000, -- Haute priorité pour qu'il s'affiche avant le reste
		config = function()
			-- Cette fonction s'exécute quand le plugin est chargé
			vim.cmd("colorscheme catppuccin-mocha")
		end,
	},
})
