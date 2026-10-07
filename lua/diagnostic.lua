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
