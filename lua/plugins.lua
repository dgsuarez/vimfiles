-- Opening nvim on a directory needs nvim-tree loaded at startup to hijack it
local opened_on_dir = vim.fn.argc(-1) > 0 and vim.fn.isdirectory(vim.fn.argv(0)) == 1

return {
  -- Base plugins
  'nvim-tree/nvim-web-devicons',
  {
    'nvim-tree/nvim-tree.lua',
    lazy = not opened_on_dir,
    cmd = { 'NvimTreeToggle', 'NvimTreeFindFile', 'NvimTreeOpen', 'NvimTreeFocus' },
    config = function() require('nvim_tree') end,
  },
  'bkad/CamelCaseMotion',
  'tpope/vim-endwise',
  'andymass/vim-matchup',
  'AndrewRadev/splitjoin.vim',
  'tpope/vim-surround',
  'tpope/vim-projectionist',
  { 'windwp/nvim-autopairs', config = function() require('autopairs') end },
  { 'ellisonleao/gruvbox.nvim', priority = 1000 },
  'tpope/vim-dispatch',
  'tpope/vim-eunuch',
  'mg979/vim-visual-multi',
  'tpope/vim-rsi',
  'tpope/vim-repeat',
  'dietsche/vim-lastplace',
  'ntpeters/vim-better-whitespace',
  'nvim-lualine/lualine.nvim',
  -- Shared with the shell's fzf install
  { dir = '~/.fzf', name = 'fzf' },
  'junegunn/fzf.vim',
  { 'mhinz/vim-grepper', cmd = 'Grepper' },
  { 'mbbill/undotree', cmd = { 'UndotreeToggle', 'UndotreeShow', 'UndotreeFocus' } },
  'yssl/QFEnter',
  'ludovicchabant/vim-gutentags',
  'jpalardy/vim-slime',

  'neovim/nvim-lspconfig',

  { 'saghen/blink.cmp', version = '1.*', config = function() require('completion') end },

  { 'nvim-treesitter/nvim-treesitter', branch = 'main', build = ':TSUpdate' },
  { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
  {
    'folke/trouble.nvim',
    cmd = 'Trouble',
    keys = {
      { '<leader>xx', '<cmd>Trouble diagnostics toggle<cr>' },
      { '<leader>xd', '<cmd>Trouble diagnostics toggle filter.buf=0<cr>' },
      { '<leader>xl', '<cmd>Trouble lsp toggle focus=false win.position=right<cr>' },
      { '<leader>xq', '<cmd>Trouble qflist toggle<cr>' },
    },
    opts = {},
  },
  { 'gaoDean/autolist.nvim', ft = { 'markdown', 'text' }, opts = {} },
  {
    'MeanderingProgrammer/render-markdown.nvim',
    ft = 'markdown',
    dependencies = { '3rd/image.nvim' },
    config = function() require('markdown_conf') end,
  },
  { '3rd/image.nvim', lazy = true },
  'towolf/vim-helm',

  -- SCM
  'tpope/vim-fugitive',
  {
    'lewis6991/gitsigns.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      on_attach = function(bufnr)
        local gitsigns = require('gitsigns')
        local function map(mode, lhs, rhs) vim.keymap.set(mode, lhs, rhs, { buffer = bufnr }) end

        -- ç = next, ´ = previous, like the other navigation maps
        map('n', 'çh', function() gitsigns.nav_hunk('next') end)
        map('n', '´h', function() gitsigns.nav_hunk('prev') end)
        map('n', '<leader>hp', gitsigns.preview_hunk)
        map('n', '<leader>hs', gitsigns.stage_hunk)
        map('n', '<leader>hr', gitsigns.reset_hunk)
        map({ 'o', 'x' }, 'ih', gitsigns.select_hunk)
      end,
    },
  },
  'tpope/vim-rhubarb',

  -- Js, HTML...
  'tpope/vim-ragtag',

  -- Ruby
  'vim-ruby/vim-ruby',
  'tpope/vim-rails',
  'tpope/vim-rake',
  'tpope/vim-bundler',
  {
    'janko-m/vim-test',
    cmd = { 'TestNearest', 'TestFile', 'TestClass', 'TestSuite', 'TestLast', 'TestVisit' },
  },
  { 'dgsuarez/reruby.vim', cmd = 'Reruby' },

  -- Other langs
  { 'tpope/vim-dadbod', cmd = 'DB' },

  -- Misc
  { 'dgsuarez/vim-ticard', cmd = 'Ticard' },
  { 'dgsuarez/vim-codeshot', cmd = 'Codeshot' },
  { 'dgsuarez/vim-mootes', cmd = { 'M', 'Mg', 'Ml', 'Mz' } },
  'dgsuarez/vim-checka-wah-wah',
}
