return {
  "akinsho/toggleterm.nvim",
  version = "*",
  config = function()
    require("toggleterm").setup({
      -- On définit Ctrl + \ comme raccourci universel pour ouvrir/fermer
      open_mapping = [[<C-t>]], 
      
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
    
    -- === INTÉGRATION DE YAZI SANS NEOVIM-CEPTION ===
    local Terminal = require('toggleterm.terminal').Terminal
    
    -- 1. On crée un chemin vers un fichier temporaire unique
    local yazi_tmpfile = vim.fn.tempname()

    local yazi = Terminal:new({
      -- 2. On lance Yazi en mode "sélecteur" (il écrira le fichier choisi ici)
      cmd = string.format("yazi --chooser-file='%s'", yazi_tmpfile),
      hidden = true,
      direction = "float",
      float_opts = {
        border = "curved",
        width = math.floor(vim.o.columns * 0.9),
        height = math.floor(vim.o.lines * 0.9),
      },
      -- 3. Que faire quand la fenêtre se ferme ?
      on_close = function()
        -- Si Yazi a écrit quelque chose dans le fichier temporaire
        if vim.fn.filereadable(yazi_tmpfile) == 1 then
          local selected_files = vim.fn.readfile(yazi_tmpfile)
          
          if #selected_files > 0 then
            -- vim.schedule garantit qu'on attend que le terminal soit bien fermé 
            -- avant d'ouvrir le fichier dans Neovim
            vim.schedule(function()
              for _, file in ipairs(selected_files) do
                vim.cmd("edit " .. vim.fn.fnameescape(file))
              end
            end)
          end
          -- 4. On nettoie le fichier temporaire pour la prochaine fois
          vim.fn.delete(yazi_tmpfile)
        end
      end,
    })

    function _G._yazi_toggle()
      yazi:toggle()
    end

    vim.keymap.set("n", "<leader>e", "<cmd>lua _G._yazi_toggle()<CR>", { noremap = true, silent = true, desc = "Yazi (Terminal)" })
  end,
}
