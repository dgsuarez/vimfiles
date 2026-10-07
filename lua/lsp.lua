vim.lsp.enable('ruby_lsp')
vim.lsp.config('ruby_lsp', {
  init_options = {
    formatter = 'rubocop_internal',
    indexing = {
      excludedPatterns = { '.claude/worktrees/**/*' },
    },
    addonSettings = {
      ["Ruby LSP Rails"] = {
        enablePendingMigrationsPrompt = false,
      },
    },
  }
})

vim.lsp.enable('helm_ls')
vim.lsp.config('helm_ls', {
  settings = {
    ['helm-ls'] = {
      yamlls = {
        path = "yaml-language-server",
      }
    }
  }
})

vim.lsp.enable('yamlls')
vim.lsp.config('yamlls', {})

vim.lsp.enable('ts_ls')
vim.lsp.config('ts_ls', {
  settings = {
    typescript = {
      tsserver = {
        watchOptions = {
          excludeDirectories = { '.claude/worktrees' },
        },
      },
    },
    javascript = {
      tsserver = {
        watchOptions = {
          excludeDirectories = { '.claude/worktrees' },
        },
      },
    },
  },
})

-- Global mappings.

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
  group = vim.api.nvim_create_augroup('UserLspConfig', {}),
  callback = function(ev)
    -- Enable completion triggered by <c-x><c-o>
    -- Ruby LSP doesn't support, disable for now
    -- vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

    -- Buffer local mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local opts = { buffer = ev.buf }
    vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', 'L', vim.diagnostic.open_float, opts)
    vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
    vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, opts)
    vim.keymap.set('n', '<leader>wl', function()
      print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    end, opts)
    vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, opts)
    vim.keymap.set('n', '<leader>f', function()
      vim.lsp.buf.format { async = true }
    end, opts)
  end,
})

