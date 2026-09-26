-- Dans ton fichier lua/plugins/image.lua (ou équivalent)
return {
  {
    "3rd/image.nvim",
    opts = {
      backend = "kitty", -- Ou "ueberzug" si tu utilises un autre terminal
      integrations = {
        markdown = {
          enabled = true,
          clear_in_insert_mode = false,
          download_remote_images = true,
          only_render_image_at_cursor = false,
        },
      },
      max_width = nil,
      max_height = nil,
      max_width_window_percentage = nil,
      max_height_window_percentage = 50,
    },
  },
}
