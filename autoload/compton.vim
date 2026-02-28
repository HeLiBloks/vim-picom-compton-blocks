function! compton#Complete(findstart, base) abort
    return picom_compton_blocks#Complete(a:findstart, a:base)
endfunction
