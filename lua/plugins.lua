return {
  -- Base plugins
  'tpope/vim-commentary',
  'nvim-tree/nvim-web-devicons',
  'nvim-tree/nvim-tree.lua',
  'bkad/CamelCaseMotion',
  'tpope/vim-endwise',
  'andymass/vim-matchup',
  'AndrewRadev/splitjoin.vim',
  'tpope/vim-surround',
  'tpope/vim-projectionist',
  'windwp/nvim-autopairs',
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
  'mhinz/vim-grepper',
  'mbbill/undotree',
  'yssl/QFEnter',
  'ludovicchabant/vim-gutentags',
  'jpalardy/vim-slime',

  'neovim/nvim-lspconfig',

  'hrsh7th/cmp-nvim-lsp',
  'hrsh7th/cmp-buffer',
  'hrsh7th/cmp-path',
  'hrsh7th/cmp-cmdline',
  'hrsh7th/nvim-cmp',
  'hrsh7th/cmp-omni',

  { 'nvim-treesitter/nvim-treesitter', branch = 'main', build = ':TSUpdate' },
  { 'nvim-treesitter/nvim-treesitter-textobjects', branch = 'main' },
  'folke/trouble.nvim',
  'gaoDean/autolist.nvim',
  'MeanderingProgrammer/render-markdown.nvim',
  '3rd/image.nvim',
  'yasuhiroki/github-actions-yaml.vim',
  'towolf/vim-helm',

  -- SCM
  'tpope/vim-fugitive',
  'tpope/vim-git',
  'tpope/vim-rhubarb',

  -- Js, HTML...
  'tpope/vim-ragtag',

  -- Ruby
  'vim-ruby/vim-ruby',
  'tpope/vim-rails',
  'tpope/vim-rake',
  'tpope/vim-bundler',
  'janko-m/vim-test',
  'dgsuarez/reruby.vim',

  -- Other langs
  'tpope/vim-dadbod',

  -- Misc
  'dgsuarez/vim-ticard',
  'dgsuarez/vim-codeshot',
  'dgsuarez/vim-mootes',
  'dgsuarez/vim-checka-wah-wah',
}
