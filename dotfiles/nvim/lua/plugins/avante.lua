return {
  {
    "yetone/avante.nvim",
    event = "VeryLazy",
    build = function()
      vim.cmd("AvanteBuild")
    end,
    dependencies = {
      "neovim/nvim-lspconfig",
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "MunifTanjim/nui.nvim",
    },
    opts = {
      provider = "claude",
      keymaps = {
        toggle = "<leader>aa",
        apply = "<leader>ay",
        apply_and_close = "<leader>aY",
      },
    },
  },
}