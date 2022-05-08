" Helper Functions

function! s:get_visual_selection()
    " Get all visual mode selected lines
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    return join(lines, "\n")
endfunction

" Functions for sorting imports
function! alphasort#SortImports(start, end)
    let lines = s#get_visual_selection()
    " Get all the lines
    call system('alphabetize' . ' ' . lines)
    "if a:0 > 0 && (a:1 == "d" || a:1 == "t")
        "if a:1 == "d"
            "echo strftime("%b %d")
        "elseif a:1 == "t"
            "echo strftime("%H:%M")
        "endif
    "else
        "echo strftime("%b %d %H:%M")
    "endif
endfunction
