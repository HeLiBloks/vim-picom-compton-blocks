set nocompatible
set rtp^=.
filetype plugin on

execute 'edit ' . fnameescape('tests/picom.conf')

if &l:filetype !=# 'compton'
  cquit 1
endif

if &l:omnifunc !=# 'picom_compton_blocks#Complete'
  cquit 1
endif

let blank_lnum = search('^$', 'n')
if blank_lnum == 0
  cquit 1
endif
call cursor(blank_lnum, 1)
let c = picom_compton_blocks#Complete(0, 'ba')
let words = map(copy(c), 'type(v:val) == type({}) ? v:val.word : v:val')
if index(words, 'backend') < 0
  cquit 1
endif

let backend_lnum = search('^\s*backend\s*=\s*"glx"', 'n')
if backend_lnum == 0
  cquit 1
endif
call cursor(backend_lnum, strlen(getline(backend_lnum)) + 1)
let c2 = picom_compton_blocks#Complete(0, 'g')
let words2 = map(copy(c2), 'type(v:val) == type({}) ? v:val.word : v:val')
if index(words2, 'glx') < 0
  cquit 1
endif

cquit 0
