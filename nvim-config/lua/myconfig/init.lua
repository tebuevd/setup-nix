vim.o.scrolloff = 5

-- press ESC to clear search result highlights when in Normal mode
vim.api.nvim_set_keymap("n", "<Esc>", ":nohlsearch<CR>", { noremap = true, silent = true })
vim.keymap.set("n", "-", "<CMD>Oil<CR>", { desc = "Open parent directory" })
