if exists('b:did_picom_compton_blocks_ftplugin')
    finish
endif
let b:did_picom_compton_blocks_ftplugin = 1

setlocal commentstring=#\ %s
setlocal omnifunc=picom_compton_blocks#Complete

let b:undo_ftplugin = 'setlocal commentstring< omnifunc<'
