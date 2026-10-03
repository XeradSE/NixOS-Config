return {
	"hrsh7th/nvim-cmp",
	dependencies = {
	"hrsh7th/cmp-nvim-lsp", -- Connecte cmp à tes LSP
	"hrsh7th/cmp-buffer",   -- Suggère les mots déjà écrits dans le fichier
	"hrsh7th/cmp-path",     -- Suggère les chemins de fichiers sous Linux
	"L3MON4D3/LuaSnip",     -- Le moteur de snippets obligatoire
	"saadparwaiz1/cmp_luasnip", -- Connecte le moteur de snippets à cmp
},
config = function()
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  -- Obligatoire : indiquer à cmp comment étendre les snippets du LSP
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  
  -- Configuration des touches du menu
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(), -- Forcer l'ouverture du menu (Ctrl+Espace)
    ["<CR>"] = cmp.mapping.confirm({ select = true }), -- Entrée valide la sélection
    
    -- Tabulation descend dans la liste
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      else
        fallback() -- Si le menu est fermé, Tab fait une vraie tabulation
      end
    end, { "i", "s" }),

    -- Maj+Tabulation remonte dans la liste
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      else
        fallback()
      end
    end, { "i", "s" }),
  }),

  -- Ordre de priorité des suggestions
  sources = cmp.config.sources({
    { name = "nvim_lsp" }, -- Suggestions intelligentes du LSP en premier
    { name = "luasnip" },  -- Puis les snippets
    { name = "path" },     -- Puis les chemins de fichiers
  }, {
    { name = "buffer" },   -- Et enfin les mots du texte actuel en dernier recours
  })
})
end,
}
