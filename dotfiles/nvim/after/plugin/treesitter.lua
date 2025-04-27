require("nvim-treesitter.configs").setup({
  sync_install = false,
  auto_install = false,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  ensure_installed = {
    "nix",
    "lua",
    "vim",
    "vimdoc",
  },
})

require("treesitter-context").setup({
  enable = false,
})
