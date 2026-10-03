-- touche "espace" en tant que <leader>
vim.g.mapleader = " "
vim.g.maplocalleader = " "
-- Comportement des tabulations
vim.opt.tabstop = 2       -- Une tabulation équivaut à 4 espaces visuellement
vim.opt.shiftwidth = 2    -- L'indentation automatique (avec > ou <) utilise 4 espaces
vim.opt.expandtab = true  -- Transforme l'appui sur "Tab" en vrais espaces
vim.opt.softtabstop = 2   -- Fait en sorte que la touche "Retour arrière" efface 4 espaces d'un coup

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
	spec = {
		{
      			"direnv/direnv.vim",
      			lazy = false,
    		},
        	{ import = "plugins" },
	},
  	rocks = { -- car chiant sur nix, privilégier la config de home-manager pour les trucs qui aurais besoin de luarocks
    	enabled = false,
	},
})
