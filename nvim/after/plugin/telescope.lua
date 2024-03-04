local telescope = require("telescope")

telescope.setup({
  require("telescope").setup({}),
})

telescope.load_extension("projects")
telescope.load_extension("fzf")

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<c-Space>", telescope.extensions.projects.projects, {})
vim.keymap.set("n", "<c-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<c-x>b", builtin.buffers, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
