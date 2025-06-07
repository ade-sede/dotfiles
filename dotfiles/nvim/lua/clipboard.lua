-- OSC52 clipboard configuration for seamless remote/local clipboard access
-- This enables neovim clipboard operations to work transparently over SSH and web terminals

-- Configure clipboard to use OSC52
vim.g.clipboard = {
  name = 'OSC 52',
  copy = {
    ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
    ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
  },
  paste = {
    ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
    ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
  },
}

-- Enable unnamedplus to use system clipboard by default
vim.opt.clipboard = "unnamedplus"

-- Auto-copy yanked text to clipboard via OSC52
vim.api.nvim_create_autocmd("TextYankPost", {
  callback = function()
    vim.highlight.on_yank()
    if vim.v.event.operator == 'y' then
      local copy_to_unnamedplus = require("vim.ui.clipboard.osc52").copy("+")
      copy_to_unnamedplus(vim.v.event.regcontents)
      local copy_to_unnamed = require("vim.ui.clipboard.osc52").copy("*")
      copy_to_unnamed(vim.v.event.regcontents)
    end
  end,
})