return {
	{
	    	"nvim-treesitter/nvim-treesitter",
	    	build = ":TSUpdate", -- Met à jour les parseurs automatiquement
	    	config = function()
			opts = {
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
}
