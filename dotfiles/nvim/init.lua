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

	-- Telescope (Recherche floue)
  	{
    		"nvim-telescope/telescope.nvim",
	    	dependencies = { "nvim-lua/plenary.nvim" }, -- Plenary est une boîte à outils Lua obligatoire pour Telescope
	    	config = function()
	      		local builtin = require("telescope.builtin")
	      		-- Configuration de tes premiers raccourcis claviers !
	      		-- <space>ff pour chercher un fichier, <space>fg pour chercher du texte
	      		vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Telescope find files" })
	      		vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Telescope live grep" })
	      		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Telescope buffers" })
	    	end,
	},

	-- Treesitter (Coloration syntaxique)
	{
	    	"nvim-treesitter/nvim-treesitter",
	    	build = ":TSUpdate", -- Met à jour les parseurs automatiquement
	    	config = function()
			require("nvim-treesitter.configs").setup({
				-- Ajoute les langages que tu veux colorer ici
				ensure_installed = { "c", "cpp", "lua", "vim", "vimdoc", "query", "nix", "markdown" },
			
				-- Installe automatiquement les langages manquants quand tu ouvres un fichier
				auto_install = true,

				highlight = {
					enable = true, -- Active la coloration syntaxique Treesitter
					-- Désactive la vieille coloration de base de Vim pour ces langages
					additional_vim_regex_highlighting = false, 
				},
			})
	    	end,
	},
})
