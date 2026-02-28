" Vim syntax file
" Language: picom/compton config (libconfig format)
" Source-aligned with picom options/rules parser in src/options.c and src/config_libconfig.c

if exists('b:current_syntax')
    finish
endif

syn case match
syn sync minlines=200
setlocal iskeyword+=-

syn region picomStringDQ start=/"/ skip=/\\./ end=/"/ contains=picomEscape,@Spell
syn region picomStringSQ start=/'/ skip=/\\./ end=/'/ contains=picomEscape,@Spell
syn match picomEscape /\\./ contained
syn match picomComment /#.*/ containedin=ALLBUT,picomStringDQ,picomStringSQ contains=@Spell

syn keyword picomDirective @include @include-if-exists

syn match picomSection /^\s*\zs[a-zA-Z_][a-zA-Z0-9_-]*\ze\s*:/
syn match picomKey /^\s*\zs[a-zA-Z_][a-zA-Z0-9_-]*\ze\s*=/

syn match picomDelimiter /[{}\[\](),;]/
syn match picomAssign /[:=]/
syn match picomLogic /&&\|||\|!/
syn match picomCmp /!\?\(<=\|>=\|=\|<\|>\)/
syn match picomMatch /!\?\(\*[?]\?=\|\^[?]\?=\|%[?]\?=\|\~[?]\?=\|[?]=\)/

syn keyword picomBoolean true false yes no
syn keyword picomUnredirValue default preferred passive forced terminate when-possible when-possible-else-terminate
syn match picomFloat /\v<[-+]?\d+\.\d+>/
syn match picomNumber /\v<[-+]?0x[0-9A-Fa-f]+>/
syn match picomNumber /\v<[-+]?\d+>/
syn match picomHexColor /#\x\{6\}\>/

syn keyword picomTopKey active-opacity animations backend benchmark benchmark-wid blur
syn keyword picomTopKey blur-background blur-background-exclude blur-background-fixed blur-background-frame
syn keyword picomTopKey blur-deviation blur-kern blur-method blur-size blur-strength
syn keyword picomTopKey clip-shadow-above corner-radius corner-radius-rules crop-shadow-to-monitor dbus
syn keyword picomTopKey detect-client-leader detect-client-opacity detect-rounded-corners detect-transient
syn keyword picomTopKey dithered-present fade-delta fade-exclude fade-in-step fade-out-step fading
syn keyword picomTopKey focus-exclude force-win-blend frame-opacity inactive-dim inactive-dim-fixed
syn keyword picomTopKey inactive-opacity inactive-opacity-override invert-color-include log-file log-level
syn keyword picomTopKey mark-ovredir-focused mark-wmwin-focused max-brightness no-ewmh-fullscreen
syn keyword picomTopKey no-fading-destroyed-argb no-fading-openclose no-frame-pacing no-use-damage no-vsync
syn keyword picomTopKey opacity-rule paint-exclude plugins root-pixmap-shader rounded-corners-exclude
syn keyword picomTopKey rules shadow shadow-blue shadow-color shadow-exclude shadow-green shadow-ignore-shaped
syn keyword picomTopKey shadow-offset-x shadow-offset-y shadow-opacity shadow-radius shadow-red
syn keyword picomTopKey transparent-clipping transparent-clipping-exclude unredir-if-possible
syn keyword picomTopKey unredir-if-possible-delay unredir-if-possible-exclude use-damage use-ewmh-active-win
syn keyword picomTopKey vsync window-shader-fg window-shader-fg-rule wintypes write-pid-path xrender-sync-fence

syn keyword picomRuleKey match fade paint shadow full-shadow invert-color blur-background
syn keyword picomRuleKey clip-shadow-above transparent-clipping opacity blur-opacity dim corner-radius
syn keyword picomRuleKey shadow-color unredir shader path defines animations triggers suppressions
syn keyword picomRuleKey preset direction duration delay

syn keyword picomBackend xrender glx
syn keyword picomBlurMethod none gaussian box kernel dual_kawase
syn keyword picomLogLevel trace debug info warn error TRACE DEBUG INFO WARN ERROR
syn keyword picomWinType unknown desktop dock toolbar menu utility splash dialog normal
syn keyword picomWinType dropdown_menu popup_menu tooltip notification combo dnd

syn keyword picomCondTarget x y x2 y2 width height widthb heightb border_width
syn keyword picomCondTarget fullscreen override_redirect argb focused group_focused wmwin
syn keyword picomCondTarget bounding_shaped rounded_corners window_type name class_i class_g role urgent

hi def link picomComment Comment
hi def link picomDirective PreProc
hi def link picomStringDQ String
hi def link picomStringSQ String
hi def link picomEscape SpecialChar
hi def link picomSection Statement
hi def link picomKey Identifier
hi def link picomDelimiter Delimiter
hi def link picomAssign Operator
hi def link picomLogic Operator
hi def link picomCmp Operator
hi def link picomMatch Operator
hi def link picomBoolean Boolean
hi def link picomUnredirValue Constant
hi def link picomFloat Float
hi def link picomNumber Number
hi def link picomHexColor Constant
hi def link picomTopKey Keyword
hi def link picomRuleKey Type
hi def link picomBackend Constant
hi def link picomBlurMethod Constant
hi def link picomLogLevel Constant
hi def link picomWinType Constant
hi def link picomCondTarget Special

let b:current_syntax = 'compton'

" vim: set ts=4 sw=4 et:
