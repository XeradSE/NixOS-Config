return {
  "windwp/nvim-autopairs",
  event = "InsertEnter", -- Optimisation : charge le plugin uniquement quand tu commences à taper
  config = function()
    local autopairs = require("nvim-autopairs")

    autopairs.setup({
      check_ts = true, -- Utilise Treesitter pour éviter de fermer des paires dans du texte ou des commentaires
    })

    -- Intégration magique avec ton autocomplétion
    local cmp_autopairs = require("nvim-autopairs.completion.cmp")
    local cmp = require("cmp")
    cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
  end,
}
