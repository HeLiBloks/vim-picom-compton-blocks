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
- `*.compton.conf`
- `*.picom.conf`
- common XDG paths like `~/.config/picom/picom.conf`

## Completion

Set automatically by `ftplugin/compton.vim`:

- `omnifunc=picom_compton_blocks#Complete`

Use in insert mode:

- `<C-x><C-o>`

## Syntax checking with `:make`

This plugin includes a Vim compiler for picom/compton config diagnostics.

```vim
:compiler compton
:make
```

(`:compiler picom` also works.)

It runs:

- `picom --config %:p --diagnostics` (preferred)
- `compton --config %:p --diagnostics` (fallback)

Errors are collected in the quickfix list.

## Commands

- `:PicomCheck` runs compiler diagnostics and lint checks, then opens quickfix.
- `:PicomLint` checks for duplicate/unknown top-level keys.
- `:PicomFormat` applies basic whitespace/indent/assignment formatting.
- `:PicomInsertRulesBlock` inserts a starter `rules` block.
- `:PicomInsertWintypesBlock` inserts a starter `wintypes` block.

## Motions and Text Objects

- `]r` / `[r` jump to next/previous rule (`match = ...`) entry.
- `ar` / `ir` select around/inside the current rule object block.

## Help

After install, generate tags and open help:

```vim
:helptags ~/.vim/dev/vim-picom-compton-blocks/doc
:help vim-picom-compton-blocks
```

## Contributing

Contributions are welcome.

1. Fork the repo and create a feature branch.
2. Make focused changes with tests when applicable.
3. Run the local test scripts before opening a PR:

```sh
# Neovim
nvim -Nu NONE -n -es -S tests/test_omnifunc.vim
nvim -Nu NONE -n -es -S tests/test_syntax.vim
nvim -Nu NONE -n -es -S tests/test_completion_values.vim
nvim -Nu NONE -n -es -S tests/test_compiler.vim
nvim -Nu NONE -n -es -S tests/test_features.vim
nvim -Nu NONE -n -es -S tests/test_filetype_paths.vim

# Vim
vim -Nu NONE -n -es -S tests/test_omnifunc.vim
vim -Nu NONE -n -es -S tests/test_syntax.vim
vim -Nu NONE -n -es -S tests/test_completion_values.vim
vim -Nu NONE -n -es -S tests/test_compiler.vim
vim -Nu NONE -n -es -S tests/test_features.vim
vim -Nu NONE -n -es -S tests/test_filetype_paths.vim
```

Please include a clear PR description and update docs/help text if behavior changes.

## License

MIT
