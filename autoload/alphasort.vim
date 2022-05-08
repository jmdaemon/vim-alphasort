" Helper Functions
function! s:get_visual_start()
    " Get the first selected line in visual mode
    let [line_start, column_start] = getpos("'<")[1:2]
    return line_start
endfunction

function! s:get_visual_end()
    " Get the last selected line in visual mode
    let [line_end, column_end] = getpos("'>")[1:2]
    return line_end
endfunction

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
    "return join(lines, "\n")
    return join(lines, '\n')
endfunction

" Functions for sorting imports
function! alphasort#SortImports(start, end)
    " Get all the lines
    let lines = s:get_visual_selection()
    echo "Selected Lines:"
    echo (lines)

    " Replace ASCII NUL with newlines
    "substitute(lines, "^@", "\r\n", "")

    " Clear the screen without a Press ENTER... prompt
    silent !clear

    " Build the command
    "let command = 'alphabetize' . ' ' . lines
    "echo "Command:"
    "echo(command)

    " Alphabetize the lines
    "let alphabetized = systemlist(command)
    "let alphabetized = ! command
    let alphabetized = ! 'alphabetize' . ' ' . lines
    echo "Alphabetized Lines:"
    echo (alphabetized)

    " Replace the selected lines with the alphabetized lines
    let line_start = s:get_visual_start()
    let line_end = s:get_visual_end()

    "call setline(line_start, line_end, alphabetized)
    execute line_start . "," . line_end . "s/" . lines ."/" . alphabetized . "/g"
    "substitute (lines, alphabetized, "g")
endfunction
