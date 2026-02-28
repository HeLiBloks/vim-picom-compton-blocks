set nocompatible
set rtp^=.
filetype plugin on

let tmpdir = tempname()
call mkdir(tmpdir, 'p')

let p1 = tmpdir . '/.config/picom/picom.conf'
call mkdir(fnamemodify(p1, ':h'), 'p')
execute 'edit ' . fnameescape(p1)
if &l:filetype !=# 'compton'
  cquit 1
endif

let p2 = tmpdir . '/my.desktop.picom.conf'
execute 'edit ' . fnameescape(p2)
if &l:filetype !=# 'compton'
  cquit 1
endif

let p3 = tmpdir . '/my.desktop.compton.conf'
execute 'edit ' . fnameescape(p3)
if &l:filetype !=# 'compton'
  cquit 1
endif

cquit 0
