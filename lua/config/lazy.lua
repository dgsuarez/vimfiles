local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    'git', 'clone', '--filter=blob:none', '--branch=stable',
    'https://github.com/folke/lazy.nvim.git', lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({ { 'Failed to clone lazy.nvim:\n' .. out, 'ErrorMsg' } }, true, {})
    return
  end
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('plugins', {
  lockfile = vim.fn.expand('~/.vim/lazy-lock.json'),
  defaults = { lazy = false },
  install = { colorscheme = { 'gruvbox' } },
  checker = { enabled = false },
  change_detection = { notify = false },
  performance = {
    rtp = {
      -- lazy resets the rtp, which would drop ~/.vim and every lua/ module in it
      paths = { vim.fn.expand('~/.vim'), vim.fn.expand('~/.vim/after') },
    },
  },
})
