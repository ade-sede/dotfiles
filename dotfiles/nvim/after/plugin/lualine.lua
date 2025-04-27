require("lualine").setup({
  -- sections = {
  --   -- Other Status Line components
  --   lualine_a = { ... },
  --   lualine_b = { ... },
  --
  --   lualine_c = {
  --     function()
  --       -- invoke `progress` here.
  --       return require("lsp-progress").progress()
  --     end,
  --   },
  --   ...,
  -- },
})

-- listen lsp-progress event and refresh lualine
vim.api.nvim_create_augroup("lualine_augroup", { clear = true })
vim.api.nvim_create_autocmd("User", {
  group = "lualine_augroup",
  pattern = "LspProgressStatusUpdated",
  callback = require("lualine").refresh,
})
