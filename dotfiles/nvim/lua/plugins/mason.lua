return {
  {
    "mason.nvim",
    opts = function(_, opts)
      -- On filtre la liste pour retirer clangd des installations forcées de mason
      opts.ensure_installed = vim.tbl_filter(function(name)
        return name ~= "clangd"
      end, opts.ensure_installed or {})
    end,
  },
  {
    "mason-lspconfig.nvim",
    opts = function(_, opts)
      opts.automatic_installation = false
      -- On fait pareil pour lspconfig
      opts.ensure_installed = vim.tbl_filter(function(name)
        return name ~= "clangd"
      end, opts.ensure_installed or {})
    end,
  },
}
