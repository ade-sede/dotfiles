return {
  "hrsh7th/nvim-cmp",
  config = function(_, opts)
    opts.sources = opts.sources or {}
    table.insert(opts.sources, {
      name = "lazydev",
      group_index = 0,
    })
  end,
}
