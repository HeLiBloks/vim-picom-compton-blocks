set nocompatible
set rtp^=.
filetype plugin on

execute 'edit ' . fnameescape('tests/picom.conf')

if &l:filetype !=# 'compton'
  cquit 1
endif

if exists(':PicomCheck') != 2 || exists(':PicomLint') != 2 || exists(':PicomFormat') != 2
  cquit 1
endif

if exists(':PicomInsertRulesBlock') != 2 || exists(':PicomInsertWintypesBlock') != 2
  cquit 1
endif

if empty(maparg(']r', 'n')) || empty(maparg('[r', 'n'))
  cquit 1
endif

if empty(maparg('ar', 'x')) || empty(maparg('ir', 'x'))
  cquit 1
endif

" rules context completion
let rules_lnum = search('^\s*rules:\s*({', 'n')
if rules_lnum == 0
  cquit 1
endif
call cursor(rules_lnum + 1, 1)
let rule_keys = picom_compton_blocks#Complete(0, 'ma')
let rule_words = map(copy(rule_keys), 'type(v:val) == type({}) ? v:val.word : v:val')
if index(rule_words, 'match') < 0
  cquit 1
endif

" wintypes context completion (names + keys)
call append(line('$'), [
  \ '',
  \ 'wintypes: {',
  \ '  ',
  \ '  tooltip = {',
  \ '    ',
  \ '  };',
  \ '};',
\ ])

let wintypes_lnum = search('^\s*wintypes:\s*{', 'n')
call cursor(wintypes_lnum + 1, 3)
let wt_names = picom_compton_blocks#Complete(0, 'to')
let wt_name_words = map(copy(wt_names), 'type(v:val) == type({}) ? v:val.word : v:val')
if index(wt_name_words, 'tooltip') < 0
  cquit 1
endif

call cursor(wintypes_lnum + 3, 5)
let wt_keys = picom_compton_blocks#Complete(0, 'sh')
let wt_key_words = map(copy(wt_keys), 'type(v:val) == type({}) ? v:val.word : v:val')
if index(wt_key_words, 'shadow') < 0
  cquit 1
endif

" linting (duplicate + unknown top-level key)
let first_backend = search('^\s*backend\s*=', 'n')
call append(line('$'), ['backend = "xrender";', 'totally-unknown-key = true;'])
let lint_qf = picom_compton_blocks#CollectLint()
let lint_texts = map(copy(lint_qf), 'v:val.text')
let dup_text = 'Duplicate top-level key "backend" (first seen at line ' . first_backend . ')'
if index(lint_texts, dup_text) < 0
  cquit 1
endif
if index(lint_texts, 'Unknown top-level key "totally-unknown-key"') < 0
  cquit 1
endif

" formatting helper
enew
set filetype=compton
call setline(1, ['shadow=true;', ' rules:({', '{', 'match = "x";', '}', ');'])
PicomFormat
if getline(1) !=# 'shadow = true;'
  cquit 1
endif
if getline(2) !=# 'rules: ({'
  cquit 1
endif

" snippet commands
enew
set filetype=compton
call setline(1, '# test')
call cursor(1, 1)
PicomInsertRulesBlock
if search('^\s*rules:\s*({', 'n') == 0
  cquit 1
endif
PicomInsertWintypesBlock
if search('^\s*wintypes:\s*{', 'n') == 0
  cquit 1
endif

cquit 0
