if exists('current_compiler')
  finish
endif
let current_compiler = 'compton'

if exists(':CompilerSet') != 2
  command -nargs=* CompilerSet setlocal <args>
endif

let s:checker = executable('picom') ? 'picom' : 'compton'

" Use picom/compton diagnostics against the current buffer path.
execute 'CompilerSet makeprg=' . s:checker . '\ --config\ %:p\ --diagnostics\ 2>&1'
CompilerSet errorformat=%E%f:%l:%c:\ %m,%E%f:%l:\ %m,%E%m

unlet s:checker
