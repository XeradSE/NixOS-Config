-- touche "espace" en tant que <leader>
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
      		"direnv/direnv.vim",
      		lazy = false,
    	},
        { import = "plugins" },
  	rocks = { -- car chiant sur nix, privilégier la config de home-manager pour les trucs qui aurais besoin de luarocks
    	enabled = false,
	},
})
