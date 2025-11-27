vim.g.mapleader = " "
local map = vim.keymap.set

-- Better window navigation
map("n", "<C-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
map("n", "<C-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
map("n", "<C-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
map("n", "<C-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

-- Resize with arrows when using multiple windows
map("n", "<C-Up>", ":resize -2<CR>", { desc = "Horizontal resize (shrink)" })
map("n", "<C-down>", ":resize +2<CR>", { desc = "Horizontal resize (enlarge)" })
map("n", "<C-right>", ":vertical resize -2<CR>", { desc = "Vertical resize (shrink)" })
map("n", "<C-left>", ":vertical resize +2<CR>", { desc = "Vertical resize (shrink)" })

-- Clear search highlights
map("n", "<leader>nh", ":nohlsearch<CR>", { desc = "Clear search highlights" })

-- System clipboard
map("v", "<leader>y", [["+y]], { desc = "Copy to system clipboard" })
map("n", "<leader>p", [["+p]], { desc = "Paste from system clipboard" })

