require("oil").setup()

vim.api.nvim_set_keymap("n", "<M-a>", "<CMD>Oil<CR>", { noremap = true, silent = true, desc = "Open parent directory" })
