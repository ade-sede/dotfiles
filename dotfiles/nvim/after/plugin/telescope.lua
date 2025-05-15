local telescope = require("telescope")

telescope.setup({
  defaults = {
    preview = false,
  },
  extensions = {
    fzf = {
      fuzzy = true,
      override_generic_sorter = true,
      override_file_sorter = true,
      case_mode = "smart_case",
    }
  }
})

-- Always load projects extension
telescope.load_extension("projects")

-- Defer fzf loading until it's built
vim.defer_fn(function()
  pcall(require('telescope').load_extension, 'fzf')
end, 0)

local builtin = require("telescope.builtin")
vim.keymap.set("n", "<c-Space>", function() 
  pcall(telescope.extensions.projects.projects)
end, {})
vim.keymap.set("n", "<c-p>", builtin.find_files, {})
vim.keymap.set("n", "<leader>ff", builtin.find_files, {})
vim.keymap.set("n", "<c-x>b", builtin.buffers, {})
vim.keymap.set("n", "<leader>fg", builtin.live_grep, {})
vim.keymap.set("n", "<leader>fh", builtin.help_tags, {})
