vim.cmd("set autochdir")
vim.cmd("set wildmode")
vim.cmd("set formatoptions-=cro")

vim.wo.number = false
vim.wo.relativenumber = false

vim.cmd("autocmd BufWritePre * lua vim.lsp.buf.format()")

if vim.g.neovide then
  vim.o.guifont = "JetBrainsMono Nerd Font:h12"
else
  vim.opt.termguicolors = true
end

vim.g.t_Co = 256
