return {
  "neovim/nvim-lspconfig",
  config = function()
    -- vim.lsp.blabla est de base intégré, mais sans le plugin je devrais écrire tout ça pour chaque lsp
    --
    -- vim.lsp.config.bashls = {
    -- cmd = { "bash-language-server", "start" },
    -- filetypes = { "sh", "bash" },
    -- -- Il faudrait aussi écrire une fonction complexe pour détecter
    -- -- la racine de ton projet (root_dir) à chaque ouverture de fichier...
    -- }
    -- vim.lsp.enable("bashls")

    -- 1. C++ (clangd)
    vim.lsp.enable("clangd")

    -- 2. Nix (nixd)
    vim.lsp.config.nixd = {
      settings = {
        nixd = {
          formatting = { command = { "nixfmt" } },
        },
      },
    }
    vim.lsp.enable("nixd")

    -- 3. Markdown (marksman)
    vim.lsp.enable("marksman")

    -- 4. Python (pyright (lsp) + ruff (formatage))
    vim.lsp.enable("pyright")
    vim.lsp.enable("ruff")

    -- 5. TypeScript/JavaScript (vtsls)
    -- Lspconfig l'appelle souvent tsserver ou vtsls selon la configuration
    vim.lsp.enable("vtsls")

    -- 6. JSON - HTML - CSS - ESLint (vscode-langservers-extracted)
    -- un seul paquet mais 4 lsps différents à l'intérieur
    vim.lsp.enable("jsonls") -- Pour JSON
    vim.lsp.enable("html")   -- Pour HTML
    vim.lsp.enable("cssls")  -- Pour CSS
    vim.lsp.enable("eslint") -- Pour ESLint

    vim.lsp.enable("bashls")
    vim.lsp.config.lua_ls = {
      settings = {
        Lua = {
          diagnostics = {
            -- Indique au serveur que "vim" est une variable globale valide
            globals = { "vim" },
          },
          workspace = {
            -- Rend le serveur conscient des fichiers runtime de Neovim
            library = vim.api.nvim_get_runtime_file("", true),
          },
        },
      },
    }
    vim.lsp.enable("lua_ls")
    vim.lsp.enable("ols")

    -- Raccourcis clavier de base quand tu es sur une erreur ou un mot-clé
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "Afficher infos (Hover)" })
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "Aller à la définition" })
    vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = "Actions de code (Fix)" })
    vim.keymap.set('n', 'gl', vim.diagnostic.open_float, { desc = "Afficher l'erreur" })

    -- Formatage automatique à la sauvegarde via le LSP
    vim.api.nvim_create_autocmd("BufWritePre", {
      desc = "Demande au LSP de formater avant de sauvegarder",
      pattern = "*",
      callback = function(args)
        vim.lsp.buf.format({ bufnr = args.buf })
      end,
    })
  end,
}
