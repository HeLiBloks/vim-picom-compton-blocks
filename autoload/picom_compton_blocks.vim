if exists('g:autoloaded_picom_compton_blocks')
    finish
endif
let g:autoloaded_picom_compton_blocks = 1

let s:all_keys = [
    \ 'active-opacity', 'animations', 'backend', 'benchmark', 'benchmark-wid',
    \ 'blur', 'blur-background', 'blur-background-exclude', 'blur-background-fixed',
    \ 'blur-background-frame', 'blur-deviation', 'blur-kern', 'blur-method',
    \ 'blur-size', 'blur-strength', 'clip-shadow-above', 'corner-radius',
    \ 'corner-radius-rules', 'crop-shadow-to-monitor', 'dbus',
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

let s:value_map = {
    \ 'backend': ['xrender', 'glx'],
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
    return matchstr(a:line, '^\s*\zs[a-zA-Z_][a-zA-Z0-9_-]*\ze\s*=')
endfunction

function! s:looks_like_key_context(prefix) abort
    return a:prefix =~# '^\s*$' || a:prefix =~# '[{(,;]\s*$'
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

    if l:prefix =~# '='
        if has_key(s:value_map, l:key)
            return s:to_items(s:filter_words(s:value_map[l:key], a:base), 'v', l:key)
        endif
        if has_key(s:booleanish_keys, l:key)
            return s:to_items(s:filter_words(s:bool_values, a:base), 'b', 'boolean')
        endif
    endif

    if s:looks_like_key_context(l:prefix)
        let l:is_rules_block = l:prefix =~# '\<rules\s*=\s*('\n        if l:is_rules_block
            return s:to_items(s:filter_words(s:rule_keys, a:base), 'k', 'rule')
        endif
        return s:to_items(s:filter_words(s:all_keys, a:base), 'k', 'top')
    endif

    return s:to_items(s:filter_words(uniq(sort(copy(s:all_keys + s:rule_keys))), a:base), 'k', 'all')
endfunction

function! compton#Complete(findstart, base) abort
    return picom_compton_blocks#Complete(a:findstart, a:base)
endfunction
