if exists('g:autoloaded_picom_compton_blocks')
    finish
endif
let g:autoloaded_picom_compton_blocks = 1

let s:all_keys = [
    \ 'active-opacity', 'animations', 'backend', 'benchmark', 'benchmark-wid',
    \ 'blur', 'blur-background', 'blur-background-exclude', 'blur-background-fixed',
    \ 'blur-background-frame', 'blur-deviation', 'blur-kern', 'blur-method',
    \ 'blur-size', 'blur-strength', 'clip-shadow-above', 'corner-radius',
    \ 'corner-radius-rules', 'crop-shadow-to-monitor', 'daemon', 'dbus',
    \ 'detect-client-leader', 'detect-client-opacity', 'detect-rounded-corners',
    \ 'detect-transient', 'dithered-present', 'fade-delta', 'fade-exclude',
    \ 'fade-in-step', 'fade-out-step', 'fading', 'focus-exclude',
    \ 'force-win-blend', 'frame-opacity', 'inactive-dim', 'inactive-dim-fixed',
    \ 'inactive-opacity', 'inactive-opacity-override', 'invert-color-include',
    \ 'log-file', 'log-level', 'mark-ovredir-focused', 'mark-wmwin-focused',
    \ 'max-brightness', 'no-ewmh-fullscreen', 'no-fading-destroyed-argb',
    \ 'no-fading-openclose', 'no-frame-pacing', 'no-use-damage', 'no-vsync',
    \ 'opacity-rule', 'paint-exclude', 'plugins', 'root-pixmap-shader',
    \ 'rounded-corners-exclude', 'rules', 'shadow', 'shadow-blue', 'shadow-color',
    \ 'shadow-exclude', 'shadow-green', 'shadow-ignore-shaped', 'shadow-offset-x',
    \ 'shadow-offset-y', 'shadow-opacity', 'shadow-radius', 'shadow-red',
    \ 'transparent-clipping', 'transparent-clipping-exclude', 'unredir-if-possible',
    \ 'unredir-if-possible-delay', 'unredir-if-possible-exclude', 'use-damage',
    \ 'use-ewmh-active-win', 'vsync', 'window-shader-fg', 'window-shader-fg-rule',
    \ 'wintypes', 'write-pid-path', 'xrender-sync-fence',
\ ]

let s:rule_keys = [
    \ 'match', 'opacity', 'dim', 'blur-opacity', 'corner-radius', 'shadow-color',
    \ 'unredir', 'shader', 'path', 'defines', 'animations', 'triggers',
    \ 'suppressions', 'preset', 'direction', 'duration', 'delay',
    \ 'fade', 'paint', 'shadow', 'full-shadow', 'invert-color',
    \ 'blur-background', 'clip-shadow-above', 'transparent-clipping',
\ ]

let s:wintype_names = [
    \ 'tooltip', 'dock', 'dnd', 'popup_menu', 'dropdown_menu',
    \ 'menu', 'utility', 'dialog', 'normal', 'desktop',
\ ]

let s:wintype_keys = [
    \ 'fade', 'shadow', 'opacity', 'focus', 'full-shadow',
    \ 'clip-shadow-above', 'redir-ignore',
\ ]

let s:value_map = {
    \ 'backend': ['xrender', 'glx', 'egl'],
    \ 'blur-method': ['none', 'gaussian', 'box', 'kernel', 'dual_kawase'],
    \ 'log-level': ['trace', 'debug', 'info', 'warn', 'error', 'TRACE', 'DEBUG', 'INFO', 'WARN', 'ERROR'],
    \ 'unredir': ['true', 'false', 'yes', 'no', 'default', 'preferred', 'passive', 'forced', 'when-possible', 'when-possible-else-terminate', 'terminate'],
    \ 'window_type': ['"unknown"', '"desktop"', '"dock"', '"toolbar"', '"menu"', '"utility"', '"splash"', '"dialog"', '"normal"', '"dropdown_menu"', '"popup_menu"', '"tooltip"', '"notification"', '"combo"', '"dnd"'],
    \ 'vsync': ['true', 'false'],
\ }

let s:booleanish_keys = {
    \ 'dbus': 1, 'detect-client-leader': 1, 'detect-client-opacity': 1,
    \ 'detect-rounded-corners': 1, 'detect-transient': 1, 'dithered-present': 1,
    \ 'fading': 1, 'force-win-blend': 1, 'inactive-dim-fixed': 1,
    \ 'inactive-opacity-override': 1, 'mark-ovredir-focused': 1,
    \ 'mark-wmwin-focused': 1, 'no-ewmh-fullscreen': 1,
    \ 'no-fading-destroyed-argb': 1, 'no-fading-openclose': 1,
    \ 'no-frame-pacing': 1, 'no-use-damage': 1, 'no-vsync': 1,
    \ 'shadow': 1, 'shadow-ignore-shaped': 1, 'transparent-clipping': 1,
    \ 'unredir-if-possible': 1, 'use-damage': 1, 'use-ewmh-active-win': 1,
    \ 'vsync': 1, 'fade': 1, 'paint': 1, 'full-shadow': 1,
    \ 'invert-color': 1, 'blur-background': 1, 'clip-shadow-above': 1,
    \ 'focus': 1, 'redir-ignore': 1,
\ }

let s:bool_values = ['true', 'false']

function! s:filter_words(words, base) abort
    if empty(a:base)
        return copy(a:words)
    endif
    let l:needle = '^' . escape(a:base, '\')
    return filter(copy(a:words), 'v:val =~? l:needle')
endfunction

function! s:to_items(words, kind, menu) abort
    return map(copy(a:words), '{"word": v:val, "kind": a:kind, "menu": a:menu}')
endfunction

function! s:current_key(line) abort
    return matchstr(a:line, '^\s*\zs[a-zA-Z_][a-zA-Z0-9_-]*\ze\s*[=:]')
endfunction

function! s:looks_like_key_context(prefix) abort
    return a:prefix =~# '^\s*$' || a:prefix =~# '[{(,;]\s*$'
endfunction

function! s:strip_comment(line) abort
    return substitute(a:line, '#.*$', '', '')
endfunction

function! s:line_delta(line) abort
    let l:text = s:strip_comment(a:line)
    let l:opens = strlen(substitute(l:text, '[^({]', '', 'g'))
    let l:closes = strlen(substitute(l:text, '[^)}]', '', 'g'))
    return l:opens - l:closes
endfunction

function! picom_compton_blocks#IncludeExpr(fname) abort
    let l:name = trim(a:fname)
    if !empty(l:name) && (l:name[0] ==# '"' || l:name[0] ==# "'")
        let l:name = l:name[1:]
    endif
    let l:name = trim(l:name)
    if !empty(l:name) && l:name[-1:] ==# ';'
        let l:name = trim(l:name[:-2])
    endif
    if !empty(l:name) && (l:name[-1:] ==# '"' || l:name[-1:] ==# "'")
        let l:name = l:name[:-2]
    endif
    let l:name = expand(l:name)

    if stridx(l:name, '/') == 0 || stridx(l:name, '~') == 0 || (strlen(l:name) > 1 && l:name[1] ==# ':')
        return l:name
    endif

    let l:buf_dir = expand('%:p:h')
    if !empty(l:buf_dir)
        let l:local_path = fnamemodify(l:buf_dir . '/' . l:name, ':p')
        if filereadable(l:local_path)
            return l:local_path
        endif
    endif

    return l:name
endfunction

function! s:is_in_block(name) abort
    let l:depth = 0
    let l:in_block = 0
    let l:start_pat = '\<' . a:name . '\s*[=:]\s*[({]'

    for lnum in range(1, line('.'))
        let l:text = s:strip_comment(getline(lnum))
        if !l:in_block && l:text =~# l:start_pat
            let l:in_block = 1
        endif

        let l:depth += s:line_delta(l:text)
        if l:in_block && l:depth <= 0
            let l:in_block = 0
            let l:depth = 0
        endif
    endfor

    return l:in_block
endfunction

function! picom_compton_blocks#Complete(findstart, base) abort
    let l:line = getline('.')

    if a:findstart
        let l:col = col('.') - 1
        while l:col > 0 && l:line[l:col - 1] =~# '[@A-Za-z0-9_:\-]'
            let l:col -= 1
        endwhile
        return l:col
    endif

    let l:prefix = strpart(l:line, 0, col('.') - 1)
    let l:key = s:current_key(l:line)
    let l:context = 'top'
    if s:is_in_block('rules')
        let l:context = 'rules'
    elseif s:is_in_block('wintypes')
        let l:context = 'wintypes'
    endif

    if l:prefix =~# '[=:]'
        if has_key(s:value_map, l:key)
            return s:to_items(s:filter_words(s:value_map[l:key], a:base), 'v', l:key)
        endif
        if has_key(s:booleanish_keys, l:key)
            return s:to_items(s:filter_words(s:bool_values, a:base), 'b', 'boolean')
        endif
    endif

    if s:looks_like_key_context(l:prefix)
        if l:context ==# 'rules'
            return s:to_items(s:filter_words(s:rule_keys, a:base), 'k', 'rule')
        endif
        if l:context ==# 'wintypes'
            if l:prefix =~# '^\s*$' || l:prefix =~# '[{,]\s*$'
                if indent('.') <= 2
                    return s:to_items(s:filter_words(s:wintype_names, a:base), 'w', 'wintype')
                endif
                return s:to_items(s:filter_words(s:wintype_keys, a:base), 'k', 'wintype-key')
            endif
            return s:to_items(s:filter_words(s:wintype_keys, a:base), 'k', 'wintype-key')
        endif
        return s:to_items(s:filter_words(s:all_keys, a:base), 'k', 'top')
    endif

    return s:to_items(s:filter_words(uniq(sort(copy(s:all_keys + s:rule_keys + s:wintype_keys))), a:base), 'k', 'all')
endfunction

function! picom_compton_blocks#CollectLint() abort
    let l:seen = {}
    let l:qf = []
    let l:depth = 0
    let l:known = {}

    for l:key in s:all_keys
        let l:known[l:key] = 1
    endfor

    for lnum in range(1, line('$'))
        let l:text = s:strip_comment(getline(lnum))
        let l:key = matchstr(l:text, '^\s*\zs[A-Za-z_][A-Za-z0-9_-]*\ze\s*[=:]')

        if l:depth == 0 && !empty(l:key)
            if has_key(l:seen, l:key)
                call add(l:qf, {
                    \ 'bufnr': bufnr('%'),
                    \ 'lnum': lnum,
                    \ 'col': 1,
                    \ 'type': 'W',
                    \ 'text': 'Duplicate top-level key "' . l:key . '" (first seen at line ' . l:seen[l:key] . ')',
                \ })
            else
                let l:seen[l:key] = lnum
            endif

            if !has_key(l:known, l:key)
                call add(l:qf, {
                    \ 'bufnr': bufnr('%'),
                    \ 'lnum': lnum,
                    \ 'col': 1,
                    \ 'type': 'W',
                    \ 'text': 'Unknown top-level key "' . l:key . '"',
                \ })
            endif
        endif

        let l:depth += s:line_delta(l:text)
        if l:depth < 0
            let l:depth = 0
        endif
    endfor

    return l:qf
endfunction

function! picom_compton_blocks#LintBuffer() abort
    let l:qf = picom_compton_blocks#CollectLint()
    call setqflist(l:qf, 'r')
    if empty(l:qf)
        cclose
    else
        cwindow
    endif
    return len(l:qf)
endfunction

function! picom_compton_blocks#Check() abort
    compiler compton
    silent! make!
    let l:qf = getqflist()
    let l:lint = picom_compton_blocks#CollectLint()
    if !empty(l:lint)
        let l:qf = l:qf + l:lint
    endif
    call setqflist(l:qf, 'r')
    if empty(l:qf)
        cclose
    else
        cwindow
    endif
endfunction

function! picom_compton_blocks#InsertRulesBlock() abort
    call append(line('.'), [
        \ 'rules: ({',
        \ '  match = "";',
        \ '  shadow = false;',
        \ '});',
    \ ])
endfunction

function! picom_compton_blocks#InsertWintypesBlock() abort
    call append(line('.'), [
        \ 'wintypes: {',
        \ '  tooltip = { fade = true; shadow = false; };',
        \ '  dock = { shadow = false; };',
        \ '};',
    \ ])
endfunction

function! picom_compton_blocks#NextRule() abort
    call search('^\s*match\s*=', 'W')
endfunction

function! picom_compton_blocks#PrevRule() abort
    call search('^\s*match\s*=', 'bW')
endfunction

function! picom_compton_blocks#SelectRuleObject(kind) abort
    if !s:is_in_block('rules')
        return
    endif

    let l:start = searchpairpos('{', '', '}', 'bnW')
    let l:end = searchpairpos('{', '', '}', 'nW')
    if l:start[0] == 0 || l:end[0] == 0
        return
    endif

    if a:kind ==# 'inner'
        let l:sline = l:start[0] + 1
        let l:eline = l:end[0] - 1
    else
        let l:sline = l:start[0]
        let l:eline = l:end[0]
    endif

    if l:sline <= 0 || l:eline <= 0 || l:sline > l:eline
        return
    endif

    call cursor(l:sline, 1)
    normal! v
    call cursor(l:eline, strlen(getline(l:eline)) + 1)
endfunction

function! picom_compton_blocks#Format() abort
    let l:sw = &l:shiftwidth > 0 ? &l:shiftwidth : 2
    let l:depth = 0

    for lnum in range(1, line('$'))
        let l:line = substitute(getline(lnum), '\s\+$', '', '')
        let l:text = substitute(l:line, '^\s*', '', '')
        let l:indent_depth = l:depth
        if l:text =~# '^[)}]'
            let l:indent_depth -= 1
        endif
        if l:indent_depth < 0
            let l:indent_depth = 0
        endif

        if l:text !~# '^#' && !empty(l:text)
            let l:text = substitute(l:text, '^\([A-Za-z_][A-Za-z0-9_-]*\)\s*=\s*', '\1 = ', '')
            let l:text = substitute(l:text, '^\([A-Za-z_][A-Za-z0-9_-]*\)\s*:\s*', '\1: ', '')
            call setline(lnum, repeat(' ', l:sw * l:indent_depth) . l:text)
        else
            call setline(lnum, repeat(' ', l:sw * l:indent_depth) . l:text)
        endif

        let l:depth += s:line_delta(l:text)
        if l:depth < 0
            let l:depth = 0
        endif
    endfor
endfunction
