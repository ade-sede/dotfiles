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
    config = function()
      require("dashboard").setup({
        theme = "hyper",
        week_header = {
          enable = true,
        },
        config = {
          shortcut = {
            { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
            {
              icon = " ",
              icon_hl = "@variable",
              desc = "Files",
              group = "Label",
              action = "Telescope find_files",
              key = "f",
            },
            {
              desc = " Apps",
              group = "DiagnosticHint",
              action = "Telescope app",
              key = "a",
            },
            {
              desc = " dotfiles",
              group = "Number",
              action = "Telescope dotfiles",
              key = "d",
            },
          },
        },
      })
    end,
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  {
    "windwp/nvim-autopairs",
    config = function()
      require("nvim-autopairs").setup({})
    end,
  },
  "ggandor/leap.nvim",
  "saadparwaiz1/cmp_luasnip",
  {
    "stevearc/oil.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
  },
  "stevearc/conform.nvim",
  "mfussenegger/nvim-lint",
  {
    "linrongbin16/lsp-progress.nvim",
    config = function()
      require("lsp-progress").setup()
    end,
  },
  "mfussenegger/nvim-dap",
  "mfussenegger/nvim-dap-python",
  { "rcarriga/nvim-dap-ui", dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "hrsh7th/nvim-cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      table.insert(opts.sources, {
        name = "lazydev",
        group_index = 0,
      })
    end,
  },
}

local ok, avante = pcall(require, "plugins.avante")
if ok then
  table.insert(plugins, avante[1])
end

return plugins
