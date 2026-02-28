# vim-picom-compton-blocks

Vim/Neovim plugin for editing `picom`/`compton` config files with:

- `compton` filetype detection
- source-aligned syntax highlighting (top-level options, rules, wintypes, blur sections, condition operators)
- omnifunc completion (`<C-x><C-o>`) for keys and common value enums

## Install

### lazy.nvim local plugin

```lua
{
  dir = vim.fn.expand("~/.vim/dev/vim-picom-compton-blocks"),
  name = "vim-picom-compton-blocks",
  lazy = false,
}
```

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
