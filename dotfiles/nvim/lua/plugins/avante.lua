return {
  {
    "yetone/avante.nvim",
    enabled = false,
    event = "VeryLazy",
    build = function()
      vim.cmd("AvanteBuild")
    end,
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
      "nvim-tree/nvim-tree.lua",
    },
    keys = {
      {
        "<leader>a+",
        function()
          local tree_ext = require("avante.extensions.nvim_tree")
          tree_ext.add_file()
        end,
        desc = "Select file in NvimTree",
        ft = "NvimTree",
      },
      {
        "<leader>a-",
        function()
          local tree_ext = require("avante.extensions.nvim_tree")
          tree_ext.remove_file()
        end,
        desc = "Deselect file in NvimTree",
        ft = "NvimTree",
      },
    },
    opts = {
      provider = "gemini",
      cursor_applying_provider = "claude",
      providers = {
        gemini = {
          model = "gemini-2.0-flash",
        },
        claude = {
          model = "claude",
        },
      },
      behaviour = {
        enable_cursor_planning_mode = true,
      },
      selector = {
        exclude_auto_select = { "NvimTree" },
      },
      keymaps = {
        toggle = "<leader>aa",
        apply = "<leader>ay",
        apply_and_close = "<leader>aY",
      },
    },
  },
}