local function on_attach(bufnr)
  local api = require("nvim-tree.api")
  api.config.mappings.default_on_attach(bufnr)

  local function opts(desc)
    return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  local WIDTH = 30

  vim.keymap.set('n', 'A', function()
    if vim.api.nvim_win_get_width(api.tree.winid()) == WIDTH then
      api.tree.resize({ absolute = vim.o.columns })
    else
      api.tree.resize({ absolute = WIDTH })
    end
  end, opts('Toggle Zoom'))
end

require("nvim-tree").setup({
  on_attach = on_attach,
})
