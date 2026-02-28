augroup filetype_picom_compton_blocks
    autocmd!
    autocmd BufNewFile,BufRead compton.conf,compton,picom.conf,picom,*.compton.conf,*.picom.conf,*/picom/picom.conf,*/compton/compton.conf setfiletype compton
augroup END
