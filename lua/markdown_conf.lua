local M = {}

require('render-markdown').setup({
  enabled = false,                 -- raw on open; flip with <leader>v
  completions = { lsp = { enabled = true } },
})

require('image').setup({
  backend = 'kitty',
  processor = 'magick_cli',        -- no luarocks installed; use the magick CLI
  integrations = {
    markdown = {
      enabled = true,
      clear_in_insert_mode = false,
      download_remote_images = true,
    },
  },
  max_width = 80,
  max_height = 20,
})

-- image.nvim has no "start disabled" option, and markdown should open raw
require('image').disable()

-- Images follow render-markdown so <leader>v flips "pretty review" <-> "raw markdown" as one
function M.toggle()
  local render_markdown = require('render-markdown')
  render_markdown.toggle()
  if render_markdown.get() then
    require('image').enable()
    -- enable() only redraws images that already exist; while disabled the markdown
    -- integration never created any, so re-run its buffer render
    vim.api.nvim_exec_autocmds('BufEnter', { group = 'image.nvim:markdown', buffer = 0 })
  else
    require('image').disable()
  end
end

return M
