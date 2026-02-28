set nocompatible
set rtp^=.
filetype plugin on

let tmpdir = tempname()
call mkdir(tmpdir, 'p')
let main_conf = tmpdir . '/picom.conf'
let extra_conf = tmpdir . '/extra.conf'

call writefile(['@include "extra.conf"'], main_conf)
call writefile(['shadow = true;'], extra_conf)

execute 'edit ' . fnameescape(main_conf)

if &l:filetype !=# 'compton'
  cquit 1
endif

if &l:include !~# '@include'
  cquit 1
endif

if &l:includeexpr !=# 'picom_compton_blocks#IncludeExpr(v:fname)'
  cquit 1
endif

let resolved = picom_compton_blocks#IncludeExpr('"extra.conf";')
if resolved !=# fnamemodify(extra_conf, ':p')
  cquit 1
endif

cquit 0
