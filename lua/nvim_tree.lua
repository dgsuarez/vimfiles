vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

local function on_attach(bufnr)
  local api = require("nvim-tree.api")
  api.config.mappings.default_on_attach(bufnr)

  local function opts(desc)
    return { desc = desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  local WIDTH = 30

  vim.keymap.set('n', 'A', function()
    local view = require("nvim-tree.view")
    if view.View.width == WIDTH then
      view.resize(vim.o.columns)
    else
      view.resize(WIDTH)
    end
  end, opts('Toggle Zoom'))
end

require("nvim-tree").setup({
  on_attach = on_attach,
})
