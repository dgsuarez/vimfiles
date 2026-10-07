require('blink.cmp').setup({
  keymap = {
    preset = 'default',
    ['<CR>'] = { 'select_and_accept', 'fallback' },
    ['<Tab>'] = { 'select_next', 'fallback' },
    ['<S-Tab>'] = { 'select_prev', 'fallback' },
  },
  completion = {
    list = { selection = { preselect = false, auto_insert = true } },
    documentation = { auto_show = true },
  },
  cmdline = { enabled = false },
  sources = {
    default = { 'lsp', 'path', 'buffer', 'omni' },
    per_filetype = { gitcommit = {} },
    providers = {
      buffer = {
        opts = {
          -- Complete words from every open file, not just the visible windows
          get_bufnrs = function()
            return vim.tbl_filter(function(bufnr)
              return vim.api.nvim_buf_is_loaded(bufnr) and vim.bo[bufnr].buftype == ''
            end, vim.api.nvim_list_bufs())
          end,
        },
      },
    },
  },
})
