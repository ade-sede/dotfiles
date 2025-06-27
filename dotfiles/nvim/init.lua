local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("set")
require("keymap")
require("clipboard")

vim.g.copilot_enabled = 0
vim.deprecate = function() end
vim.wo.scrolloff = 0

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
})
