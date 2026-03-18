require('nvim-treesitter').setup({
  ensure_installed = {
    'ruby', 'javascript', 'typescript', 'html', 'css', 'json', 'yaml',
    'lua', 'vim', 'vimdoc', 'markdown', 'markdown_inline', 'bash',
    'dockerfile', 'sql', 'go', 'python',
  },
})
