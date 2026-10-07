local map = vim.keymap.set

-- 1. Navigation entre les "slices" (fenêtres splitées) avec Ctrl + h, j, k, l
map("n", "<C-h>", "<C-w>h", { desc = "Fenêtre gauche" })
map("n", "<C-j>", "<C-w>j", { desc = "Fenêtre bas" })
map("n", "<C-k>", "<C-w>k", { desc = "Fenêtre haut" })
map("n", "<C-l>", "<C-w>l", { desc = "Fenêtre droite" })

-- 2. Navigation entre les buffers avec Alt + h, j, k, l
-- Dans Neovim, la touche Alt s'écrit avec la lettre "M" (pour Meta)
-- Comme les buffers sont une liste horizontale, h/l et j/k font la même chose
map("n", "<M-h>", "<cmd>bprevious<cr>", { desc = "Buffer précédent" })
map("n", "<M-l>", "<cmd>bnext<cr>", { desc = "Buffer suivant" })

-- Optionnel : assigner j et k aux mêmes actions si tu veux garder la logique directionnelle
map("n", "<M-j>", "<cmd>bprevious<cr>", { desc = "Buffer précédent" })
map("n", "<M-k>", "<cmd>bnext<cr>", { desc = "Buffer suivant" })

-- Redimensionner les fenêtres (slices) avec Alt + Flèches
map("n", "<M-Up>", "<cmd>resize +2<cr>", { desc = "Augmenter la hauteur" })
map("n", "<M-Down>", "<cmd>resize -2<cr>", { desc = "Diminuer la hauteur" })
map("n", "<M-Left>", "<cmd>vertical resize -2<cr>", { desc = "Diminuer la largeur" })
map("n", "<M-Right>", "<cmd>vertical resize +2<cr>", { desc = "Augmenter la largeur" })
