-- config pour nvim-jdtls
-- Neovim exécute automatiquement les fichiers dans le dossier ftplugin/ quand un type de fichier spécifique est ouvert (ici Java).

-- Génère un nom de dossier unique pour le workspace du projet actuel
local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
local workspace_dir = vim.fn.expand('~/.cache/jdtls-workspace/') .. project_name

-- Si tu utilises nvim-cmp :
local capabilities = require('cmp_nvim_lsp').default_capabilities()

local config = {
  -- Le wrapper NixOS permet d'appeler simplement 'jdtls'
  -- On lui passe juste le dossier de travail spécifique au projet
  cmd = { 'jdtls', '-data', workspace_dir },

  -- JDTLS a besoin de savoir où se trouve la racine du projet
  root_dir = vim.fs.dirname(vim.fs.find({ 'pom.xml', '.git', 'mvnw', 'gradlew' }, { upward = true })[1]),

  capabilities = capabilities, -- AJOUTE CETTE LIGNE ICI

  -- Paramètres optionnels pour aligner JDTLS avec ton client LSP standard
  settings = {
    java = {
      signatureHelp = { enabled = true },
      saveActions = { organizeImports = true },
    }
  }
}

-- Démarre ou attache le serveur au buffer actuel
require('jdtls').start_or_attach(config)
