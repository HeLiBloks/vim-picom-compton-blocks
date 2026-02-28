set nocompatible
set rtp^=.
filetype plugin on

execute 'edit ' . fnameescape('tests/picom.conf')

if &l:filetype !=# 'compton'
  cquit 1
endif

compiler compton

if &l:makeprg !~# '--config'
  cquit 1
endif

if &l:makeprg !~# '%:p'
  cquit 1
endif

if &l:makeprg !~# 'picom\|compton'
  cquit 1
endif

if empty(&l:errorformat)
  cquit 1
endif

cquit 0
