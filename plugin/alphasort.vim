" Load the alphasort plugin
if exists("g:loaded_alphasort") || v:version < 700 || &cp
  finish
endif
let g:loaded_alphasort = 1
