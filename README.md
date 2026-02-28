# vim-picom-compton-blocks

[![CI](https://github.com/HeLiBloks/vim-picom-compton-blocks/actions/workflows/ci.yml/badge.svg)](https://github.com/HeLiBloks/vim-picom-compton-blocks/actions/workflows/ci.yml)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](./LICENSE)

Vim/Neovim plugin for editing `picom`/`compton` config files with:

- `compton` filetype detection
- source-aligned syntax highlighting (top-level options, rules, wintypes, blur sections, condition operators)
- omnifunc completion (`<C-x><C-o>`) for keys and common value enums

## Install

### lazy.nvim (Neovim)

```lua
{
  dir = vim.fn.expand("~/.vim/dev/vim-picom-compton-blocks"),
  name = "vim-picom-compton-blocks",
  lazy = false,
}
```

### vim-plug (Vim/Neovim)

```vim
" init.vim / .vimrc
call plug#begin('~/.vim/plugged')
Plug 'HeLiBloks/vim-picom-compton-blocks'
call plug#end()
```

Then run:

```vim
:PlugInstall
```

### packer.nvim (Neovim)

```lua
use({
  "HeLiBloks/vim-picom-compton-blocks",
})
```

Then run:

```vim
:PackerSync
```

### Native packages (`pack/*/start`) (Vim 8+/Neovim)

```sh
mkdir -p ~/.vim/pack/plugins/start
git clone https://github.com/HeLiBloks/vim-picom-compton-blocks \
  ~/.vim/pack/plugins/start/vim-picom-compton-blocks
```

For Neovim, use `~/.config/nvim/pack/plugins/start` instead of `~/.vim/pack/plugins/start`.

### Filetypes covered

- `compton`
- `compton.conf`
- `picom`
- `picom.conf`

## Completion

Set automatically by `ftplugin/compton.vim`:

- `omnifunc=picom_compton_blocks#Complete`

Use in insert mode:

- `<C-x><C-o>`

## Help

After install, generate tags and open help:

```vim
:helptags ~/.vim/dev/vim-picom-compton-blocks/doc
:help vim-picom-compton-blocks
```

## License

MIT
