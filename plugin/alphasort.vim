" Title:        Vim-AlphaSort
" Description:  Lexicographically sorts selected lines
" Last Change:  2022-05-07
" Maintainer:   Joseph Diza <josephm.diza@gmail.com>

" Load the alphasort plugin
if exists("g:loaded_alphasort") || v:version < 700 || &cp
  finish
endif
let g:loaded_alphasort = 1
let g:alphasort_debug_mode = 0

" Plugin Functions
command! -range SortImports call alphasort#SortImports(<line1>, <line2>)
