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

-- Toggle both the text rendering and inline images together so <leader>v gives a
-- clean "pretty review" <-> "raw markdown" flip.
local on = false
function M.toggle()
  on = not on
  require('render-markdown').toggle()
  -- image.enable()/disable() exist in recent image.nvim builds. If the installed
  -- version predates them, the pcall guard keeps text rendering working anyway.
  local ok, image = pcall(require, 'image')
  if ok and image.enable and image.disable then
    if on then image.enable() else image.disable() end
  end
end

return M
