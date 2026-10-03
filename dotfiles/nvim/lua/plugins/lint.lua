return {
"mfussenegger/nvim-lint",
config = function()
local lint = require("lint")

-- 1. On associe les extensions de fichiers à leurs linters
lint.linters_by_ft = {
  nix = { "statix" },
  markdown = { "markdownlint-cli2" },
}

-- 2. On dit à Neovim de lancer ces linters à la sauvegarde ou à l'ouverture d'un fichier
vim.api.nvim_create_autocmd({ "BufWritePost", "BufReadPost", "InsertLeave" }, {
  desc = "Lance les linters automatiquement",
  group = vim.api.nvim_create_augroup("Linting", { clear = true }),
  callback = function()
    lint.try_lint()
  end,
})
end,
}
