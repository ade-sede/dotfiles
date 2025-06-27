local plugins = {
  "EdenEast/nightfox.nvim",
  "ayu-theme/ayu-vim",
  { "projekt0n/github-nvim-theme", name = "github-theme" },
  "navarasu/onedark.nvim",
  "wbthomason/packer.nvim",
  "Mofiqul/dracula.nvim",
  "editorconfig/editorconfig-vim",
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "kyazdani42/nvim-web-devicons" },
  },
  {
    "nvim-treesitter/nvim-treesitter",
  },
  "nvim-treesitter/playground",
  "nvim-treesitter/nvim-treesitter-context",
  {
    "VonHeikemen/lsp-zero.nvim",
    branch = "v3.x",
    dependencies = {
      "neovim/nvim-lspconfig",
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/nvim-cmp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
  },
  "github/copilot.vim",
  {
    "nvim-telescope/telescope.nvim",
    tag = "0.1.6",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  "ahmedkhalf/project.nvim",
  {
    "folke/trouble.nvim",
    dependencies = "nvim-tree/nvim-web-devicons",
  },
  {
    "nvim-telescope/telescope-fzf-native.nvim",
    build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
  },
  "gpanders/editorconfig.nvim",
  "numToStr/Comment.nvim",
  "gelguy/wilder.nvim",
  "eandrju/cellular-automaton.nvim",
  {
    "NeogitOrg/neogit",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "sindrets/diffview.nvim",
      "ibhagwan/fzf-lua",
    },
  },
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = require("plugins.dashboard"),
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "windwp/nvim-autopairs",
    config = require("plugins.autopairs"),
  },
  "ggandor/leap.nvim",
  {
    "ruifm/gitlinker.nvim",
    dependencies = "nvim-lua/plenary.nvim",
    config = require("plugins.gitlinker"),
  },
  "saadparwaiz1/cmp_luasnip",
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  "stevearc/conform.nvim",
  "mfussenegger/nvim-lint",
  {
    "linrongbin16/lsp-progress.nvim",
    config = require("plugins.lsp-progress"),
  },
  "mfussenegger/nvim-dap",
  "mfussenegger/nvim-dap-python",
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = require("plugins.lazydev"),
  },
  {
    "hrsh7th/nvim-cmp",
    opts = require("plugins.cmp"),
  },
}

local ok, avante = pcall(require, "plugins.avante")
if ok then
  table.insert(plugins, avante[1])
end

return plugins
