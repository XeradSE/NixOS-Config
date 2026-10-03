return {
  "neovim/nvim-lspconfig",
  config = function()
    local lspconfig = require("lspconfig")

    -- 1. C++ (clangd)
    lspconfig.clangd.setup({})

    -- 2. Nix (nixd)
    lspconfig.nixd.setup({})

    -- 3. Markdown (marksman)
    lspconfig.marksman.setup({})

    -- 4. Python (pyright)
    lspconfig.pyright.setup({})

    -- 5. TypeScript/JavaScript (vtsls)
    -- Lspconfig l'appelle souvent tsserver ou vtsls selon la configuration
    lspconfig.vtsls.setup({})

    -- 6. JSON - HTML - CSS - ESLint (vscode-langservers-extracted)
    -- un seul paquet mais 4 lsps différents à l'intérieur
    lspconfig.jsonls.setup({}) -- Pour JSON
    lspconfig.html.setup({})   -- Pour HTML
    lspconfig.cssls.setup({})  -- Pour CSS
    lspconfig.eslint.setup({}) -- Pour ESLint

    -- Raccourcis clavier de base quand tu es sur une erreur ou un mot-clé
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Afficher infos (Hover)" })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Aller à la définition" })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Actions de code (Fix)" })
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = "Afficher l'erreur" })
  end,
}
