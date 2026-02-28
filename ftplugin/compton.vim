if exists('b:did_picom_compton_blocks_ftplugin')
    finish
endif
let b:did_picom_compton_blocks_ftplugin = 1

setlocal commentstring=#\ %s
setlocal omnifunc=picom_compton_blocks#Complete
setlocal include=^\s*@include\%(-if-exists\)\=\s*["']
setlocal includeexpr=picom_compton_blocks#IncludeExpr(v:fname)
setlocal suffixesadd+=.conf

command! -buffer PicomCheck call picom_compton_blocks#Check()
command! -buffer PicomLint call picom_compton_blocks#LintBuffer()
command! -buffer PicomFormat call picom_compton_blocks#Format()
command! -buffer PicomInsertRulesBlock call picom_compton_blocks#InsertRulesBlock()
command! -buffer PicomInsertWintypesBlock call picom_compton_blocks#InsertWintypesBlock()

nnoremap <silent> <buffer> ]r <Cmd>call picom_compton_blocks#NextRule()<CR>
nnoremap <silent> <buffer> [r <Cmd>call picom_compton_blocks#PrevRule()<CR>
xnoremap <silent> <buffer> ar :<C-U>call picom_compton_blocks#SelectRuleObject('around')<CR>
onoremap <silent> <buffer> ar :<C-U>call picom_compton_blocks#SelectRuleObject('around')<CR>
xnoremap <silent> <buffer> ir :<C-U>call picom_compton_blocks#SelectRuleObject('inner')<CR>
onoremap <silent> <buffer> ir :<C-U>call picom_compton_blocks#SelectRuleObject('inner')<CR>

let b:undo_ftplugin = 'setlocal commentstring< omnifunc< include< includeexpr< suffixesadd<'
let b:undo_ftplugin .= ' | silent! delcommand PicomCheck'
let b:undo_ftplugin .= ' | silent! delcommand PicomLint'
let b:undo_ftplugin .= ' | silent! delcommand PicomFormat'
let b:undo_ftplugin .= ' | silent! delcommand PicomInsertRulesBlock'
let b:undo_ftplugin .= ' | silent! delcommand PicomInsertWintypesBlock'
let b:undo_ftplugin .= ' | silent! nunmap <buffer> ]r'
let b:undo_ftplugin .= ' | silent! nunmap <buffer> [r'
let b:undo_ftplugin .= ' | silent! xunmap <buffer> ar'
let b:undo_ftplugin .= ' | silent! ounmap <buffer> ar'
let b:undo_ftplugin .= ' | silent! xunmap <buffer> ir'
let b:undo_ftplugin .= ' | silent! ounmap <buffer> ir'
