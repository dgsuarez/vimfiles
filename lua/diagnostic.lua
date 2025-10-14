vim.diagnostic.config({
  float = {
    source = "always", -- Or "if_many"
    border = "rounded",
  },
  signs = true,
  underline = true,
  virtual_text = true,
  update_in_insert = false,
})

local diag_loclist_group = vim.api.nvim_create_augroup('DiagLoclist', { clear = true })

vim.api.nvim_create_autocmd('DiagnosticChanged', {
  group = diag_loclist_group,
  pattern = '*',
  callback = function()
    vim.diagnostic.setloclist({
      open = false,
    })
  end,
})
