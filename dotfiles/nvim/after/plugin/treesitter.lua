local parser_config = require("nvim-treesitter.parsers").get_parser_configs()
parser_config.gleam = {
  install_info = {
    url = "https://github.com/gleam-lang/tree-sitter-gleam",
    files = {"src/parser.c", "src/scanner.c"},
    branch = "main",
  },
  filetype = "gleam",
}

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
    "gleam",
  },
})

require("treesitter-context").setup({
  enable = false,
})
