set nocompatible
set rtp^=.
filetype plugin on

new
set filetype=compton

" backend value completion
call setline(1, 'backend = g')
call cursor(1, 12)
let vals = picom_compton_blocks#Complete(0, 'g')
let words = map(copy(vals), 'type(v:val) == type({}) ? v:val.word : v:val')
if index(words, 'glx') < 0
  cquit 1
endif

" backend supports egl in picom next sample.conf
let vals_egl = picom_compton_blocks#Complete(0, 'e')
let words_egl = map(copy(vals_egl), 'type(v:val) == type({}) ? v:val.word : v:val')
if index(words_egl, 'egl') < 0
  cquit 1
endif

" rule key completion in rules block
call setline(1, 'rules = (')
call setline(2, '{ ma')
call cursor(2, 5)
let keys = picom_compton_blocks#Complete(0, 'ma')
let words2 = map(copy(keys), 'type(v:val) == type({}) ? v:val.word : v:val')
if index(words2, 'match') < 0
  cquit 1
endif

" rule key completion in rules: block (sample.conf style)
call setline(1, 'rules: (')
call setline(2, '{ ma')
call cursor(2, 5)
let keys_colon = picom_compton_blocks#Complete(0, 'ma')
let words_colon = map(copy(keys_colon), 'type(v:val) == type({}) ? v:val.word : v:val')
if index(words_colon, 'match') < 0
  cquit 1
endif

" boolean completion for boolean-like key
call setline(3, 'shadow = t')
call cursor(3, 10)
let b = picom_compton_blocks#Complete(0, 't')
let words3 = map(copy(b), 'type(v:val) == type({}) ? v:val.word : v:val')
if index(words3, 'true') < 0
  cquit 1
endif

cquit 0
