set nocompatible
set rtp^=.
filetype plugin on
syntax on

new
set filetype=compton
call setline(1, 'backend = "glx";')

let out = execute('syntax list picomTopKey')
if out !~# 'backend'
  cquit 1
endif

let out2 = execute('syntax list picomRuleKey')
if out2 !~# 'match'
  cquit 1
endif

cquit 0
