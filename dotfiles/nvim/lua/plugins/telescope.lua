return {
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
}
