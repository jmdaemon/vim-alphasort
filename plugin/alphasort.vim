" Title:        Vim-AlphaSort
" Description:  Lexicographically sorts selected lines
" Last Change:  2022-11-30
" Maintainer:   Joseph Diza <josephm.diza@gmail.com>

" Load the alphasort plugin
if exists("g:loaded_alphasort") || v:version < 700 || &cp
  finish
endif
let g:loaded_alphasort = 1

" Dynamically set the logging level
if exists("$VIM_LOG_LEVEL")
    let g:alphasort_debug_mode = $VIM_LOG_LEVEL
else
    let g:alphasort_debug_mode = 0
endif

" Plugin Functions
command! -range SortImports call alphasort#SortImports(<line1>, <line2>)
command! -nargs=1 Info call Log(<args>)
