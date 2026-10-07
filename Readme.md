Vimfiles
========

My vimfiles, heavily leaning towards Ruby development.

Installation
------------

Neovim is the full experience. Point it at this repo from `~/.config/nvim/init.vim`:

```vim
set runtimepath^=~/.vim runtimepath+=~/.vim/after
let &packpath = &runtimepath
source ~/.vim/vimrc
```

On first start [lazy.nvim](https://github.com/folke/lazy.nvim) bootstraps itself and installs
the plugins. `:Lazy restore` installs the exact versions pinned in `lazy-lock.json`, `:Lazy update`
moves them forward (commit the updated lockfile).

Plain Vim also reads `vimrc`, but stops before the plugin section: it gets the basic settings
and mappings only.

Origins
-------

Originally a fork of [akitaonrails
vimfiles](https://github.com/akitaonrails/vimfiles), it has drifted enough to
not have much to do with it anymore.
