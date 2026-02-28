set nocompatible
set rtp^=.
filetype plugin on

execute 'edit ' . fnameescape('tests/picom.conf')

if &l:filetype !=# 'compton'
  cquit 1
endif

" backend value completion
let backend_lnum = search('^\s*backend\s*=\s*"glx"', 'n')
if backend_lnum == 0
  cquit 1
endif
call cursor(backend_lnum, strlen(getline(backend_lnum)) + 1)
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
let rules_lnum = search('^\s*rules:\s*({', 'n')
if rules_lnum == 0
  cquit 1
endif
call cursor(rules_lnum, strlen(getline(rules_lnum)) + 1)
let keys = picom_compton_blocks#Complete(0, 'ma')
let words2 = map(copy(keys), 'type(v:val) == type({}) ? v:val.word : v:val')
if index(words2, 'match') < 0
  cquit 1
endif

" boolean completion for boolean-like key
let shadow_lnum = search('^\s*shadow\s*=\s*true;', 'n')
if shadow_lnum == 0
  cquit 1
endif
call cursor(shadow_lnum, strlen(getline(shadow_lnum)) + 1)
let b = picom_compton_blocks#Complete(0, 't')
let words3 = map(copy(b), 'type(v:val) == type({}) ? v:val.word : v:val')
if index(words3, 'true') < 0
  cquit 1
endif

cquit 0
