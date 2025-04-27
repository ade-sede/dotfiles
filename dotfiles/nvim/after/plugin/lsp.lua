-- require("neodev").setup({}) -- disabled in favor of lazydev

-- https://github.com/ThePrimeagen/init.lua/blob/master/after/plugin/lsp.lua
local lsp = require("lsp-zero")

require("lspconfig").gleam.setup({})

local cmp = require("cmp")
local cmp_action = require("lsp-zero").cmp_action()
local cmp_format = require("lsp-zero").cmp_format({ details = true })

require("lspconfig").pyright.setup({
  settings = {
    python = {
      analysis = {
        diagnosticMode = "none", -- This disables diagnostic reporting to LSP
        useLibraryCodeForTypes = true,
      },
    },
  },
})

require("lspconfig").pylsp.setup({
  on_attach = on_attach,
  flags = {
    debounce_text_changes = 150,
  },
  settings = {
    pylsp = {
      plugins = {
        pyflakes = { enabled = false },
        pylint = { enabled = false },
        pycodestyle = { enabled = false },
        pydocstyle = { enabled = false },
        autopep8 = { enabled = false },
        ruff = { enabled = true },
        mccabe = { enabled = false },
        pylsp_mypy = {
          enabled = false,
          live_mode = false,
          dmypy = true,
          report_progress = true,
        },
        -- Anything rope related conflicts with other completion sources
        rope = { enabled = false },
        rope_refactor = { enabled = false },
        rope_completion = { enabled = false },
        rope_autoimport = { enabled = false },
      },
    },
  },
})

cmp.setup({
  sources = {
    { name = "nvim_lsp" },
    -- { name = "buffer" },
    { name = "luasnip" },
  },
  mapping = {
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-y>"] = cmp.mapping.confirm({ select = true }),
    ["<C-e>"] = cmp.mapping.abort(),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<Tab>"] = nil,
    ["<S-Tab>"] = nil,
    ["<C-p>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_prev_item({ behavior = "insert" })
      else
        cmp.complete()
      end
    end),
    ["<C-n>"] = cmp.mapping(function()
      if cmp.visible() then
        cmp.select_next_item({ behavior = "insert" })
      else
        cmp.complete()
      end
    end),
    ["<C-f>"] = cmp_action.luasnip_jump_forward(),
    ["<C-b>"] = cmp_action.luasnip_jump_backward(),
  },
  snippet = {
    expand = function(args)
      require("luasnip").lsp_expand(args.body)
    end,
  },
  formatting = cmp_format,
})

lsp.on_attach(function(client, bufnr)
  local opts = { buffer = bufnr, remap = false }

  vim.keymap.set("n", "gh", function()
    vim.lsp.buf.hover()
  end, opts)
  vim.keymap.set("n", "<leader>vws", function()
    vim.lsp.buf.workspace_symbol()
  end, opts)
  vim.keymap.set("n", "<leader>vd", function()
    vim.diagnostic.open_float()
  end, opts)
  vim.keymap.set("n", "<leader>vca", function()
    vim.lsp.buf.code_action()
  end, opts)
  vim.keymap.set("n", "<leader>vrr", function()
    vim.lsp.buf.references()
  end, opts)
  vim.keymap.set("n", "<leader>vrn", function()
    vim.lsp.buf.rename()
  end, opts)
  vim.keymap.set("i", "<C-h>", function()
    vim.lsp.buf.signature_help()
  end, opts)
  vim.keymap.set("n", "<space>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, opts)
  vim.keymap.set("n", "<space>f", function()
    vim.lsp.buf.format({ async = true })
  end, opts)
end)

require("mason").setup({
  ui = {
    icons = {
      package_installed = "",
      package_pending = "",
      package_uninstalled = "",
    },
  },
})

require("mason-lspconfig").setup({
  handlers = {
    lsp.default_setup,
  },
})

-- https://levelup.gitconnected.com/a-step-by-step-guide-to-configuring-lsp-in-neovim-for-coding-in-next-js-a052f500da2#502a
vim.diagnostic.config({ virtual_text = true })
vim.o.updatetime = 250
vim.cmd([[autocmd! CursorHold,CursorHoldI * lua vim.diagnostic.open_float(nil, {focus=false})]])
