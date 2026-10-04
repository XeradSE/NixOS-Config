return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      -- On définit Ctrl + \ comme raccourci universel pour ouvrir/fermer
      open_mapping = [[<leader>t]], 
      
      direction = "float", -- Peut aussi être "horizontal" ou "vertical"
      
      -- Style de la fenêtre flottante
      float_opts = {
        border = "curved",
      },
      
      -- Le terminal s'ouvre directement prêt à écrire (mode insertion)
      start_in_insert = true,
      
      -- Ferme la fenêtre proprement quand tu tapes 'exit'
      close_on_exit = true, 
    })

    -- LE CODE LE PLUS IMPORTANT : Comment sortir du terminal
    -- Sans ça, tu es prisonnier du terminal. Ici on dit : "Quand je suis
    -- dans le terminal et que j'appuie sur Echap, remets-moi en mode normal Neovim"
    vim.api.nvim_create_autocmd("TermOpen", {
      pattern = "term://*",
      callback = function()
        local opts = { buffer = 0 }
        -- Echap pour sortir du mode terminal
        vim.keymap.set('t', '<esc>', [[<C-\><C-n>]], opts)
        
        -- Si tu veux aussi utiliser jk pour sortir (très commun)
        vim.keymap.set('t', 'jk', [[<C-\><C-n>]], opts)
        
        -- Raccourcis pour naviguer entre les fenêtres si le terminal n'est pas flottant
        vim.keymap.set('t', '<C-h>', [[<Cmd>wincmd h<CR>]], opts)
        vim.keymap.set('t', '<C-j>', [[<Cmd>wincmd j<CR>]], opts)
        vim.keymap.set('t', '<C-k>', [[<Cmd>wincmd k<CR>]], opts)
        vim.keymap.set('t', '<C-l>', [[<Cmd>wincmd l<CR>]], opts)
      end,
    })
  end,
}
