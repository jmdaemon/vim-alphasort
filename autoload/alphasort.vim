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
    " Returns the lines selected as an array
    let [line_start, column_start] = getpos("'<")[1:2]
    let [line_end, column_end] = getpos("'>")[1:2]
    let lines = getline(line_start, line_end)
    if len(lines) == 0
        return ''
    endif
    let lines[-1] = lines[-1][: column_end - (&selection == 'inclusive' ? 1 : 2)]
    let lines[0] = lines[0][column_start - 1:]
    "return join(lines, '\n')
    return lines
endfunction

"function! alphasort#QuoteLines(lines)
    "let quoted = []
    "let i = ''
    "for i in len(lines)
        "let line = "\'" . get(lines, i) . "\'"
        "quoted + [line]
    "endfor
    "return quoted
"endfunction

" Functions for sorting imports
function! alphasort#SortImports(start, end)
    " Sorts all selected import statements

    " Get all the lines
    let lines = s:get_visual_selection()
    echo "Selected Lines:"
    echo (lines)

    " Quote the variables
    "let quoted = s:quote_lines(lines)
    "let quoted = alphasort#QuoteLines(lines)
    "echo "Quoted Lines:"
    "echo (quoted)

    " Join the lines together
    "let joined = join(quoted, '\n')
    let joined = join(lines, '\n')
    echo "Joined Lines:"
    echo (joined)

    " Clear the screen without a Press ENTER... prompt
    silent !clear

    " Alphabetize the lines
    "let alphabetized = systemlist(command)
    "let alphabetized = ! 'alphabetize' . ' ' . joined
    "let alphabetized = split(! 'alphabetize' . ' ' . joined, '\n')
    "let alphabetized = split(! 'alphabetize' . ' ' . joined)
    let alphabetized = split((! 'alphabetize' . ' ' . joined), '\\n')
    echo "Alphabetized Lines:"
    echo (alphabetized)
    
    let length = len(alphabetized)
    
    " Remove the "1 " in front of the first element
    let first_elem = get(alphabetized, 0)
    echo "First Element"
    echo(first_elem)
    "substitute(first_elem, '1 ', '', 'g')
    "execute('s/' . '1 ' . '/' . '' . '/' . 'g')
    "execute('s/' . '[1 ]' . '/' . '' . '/' . 'g')
    "substitute(first_elem, '1 ', '', 'g')
    "alphabetized[0] = first_elem
    "let alphabetized = first_elem + alphabetized[1:len(alphabetized)]
    "let sanitized = [first_elem] + alphabetized[1:length]
    let sanitized = [substitute(first_elem, '1 ', '', 'g')] + alphabetized[1:length]
    echo "Sanitized Lines:"
    echo (sanitized)

    " Sanitize the output
    "substitute(alphabetized, "\n", '\n', 'g')

    " Replace the selected lines with the alphabetized lines
    let line_start = s:get_visual_start()
    let line_end = s:get_visual_end()

    "call setline(line_start, line_end, alphabetized)
    execute line_start . "," . line_end . "s/" . joined ."/" . alphabetized . "/g"
    "substitute (lines, alphabetized, "g")
endfunction
