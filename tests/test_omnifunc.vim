set nocompatible
set rtp^=.
filetype plugin on

new
set filetype=compton

if &l:omnifunc !=# 'picom_compton_blocks#Complete'
  cquit 1
endif

call setline(1, 'ba')
call cursor(1, 3)
let s = picom_compton_blocks#Complete(1, '')
let c = picom_compton_blocks#Complete(0, 'ba')
let words = map(copy(c), 'type(v:val) == type({}) ? v:val.word : v:val')
if index(words, 'backend') < 0
  cquit 1
endif

call setline(1, 'backend = g')
call cursor(1, 12)
let c2 = picom_compton_blocks#Complete(0, 'g')
let words2 = map(copy(c2), 'type(v:val) == type({}) ? v:val.word : v:val')
if index(words2, 'glx') < 0
  cquit 1
endif

cquit 0
