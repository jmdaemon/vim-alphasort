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

"function! QuoteLines(lines)
"function! s:quote_lines(lines)
    "let quoted = []
    ""let i = ''
    ""for i in len(lines)
        ""let line = "\'" . get(lines, i) . "\'"
    "for i in a:lines
        "let line = "\'" . i . "\'"
        ""quoted + [line]
        "let quoted = append(line, quoted)
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


    " Escape special character sequences (#, ')
    let escaped = []
    for i in lines
        let line = substitute(i     , '#'   , '\\#' , 'g')
        let line = substitute(line  , "\'"  , "\\'" , 'g')
        "let line = substitute(line  , '"'   , '\\"' , 'g')
        let escaped = escaped + [line]
    endfor
    "let escaped = alphasort#QuoteLines(lines)
    "let escaped = QuoteLines(lines)
    echo "Escaped Lines:"
    echo (escaped)

    " Quote the variables
    "let quoted = s:quote_lines(lines)
    let quoted = []
    ""for i in lines
    for i in escaped
        "let line = substitute(i, "\'", "\\'", 'g')
        let line = "\'" . i . "\'"
        ""let line = "\'" . i
        ""let line = "\'" .. i .. "\'"
        ""let line = '\' . i . '\'
        ""let line = '\"' . i . '\"'
        ""let line = \" . i . \"
        let quoted = quoted + [line]
        ""echo(i)
        ""quoted + [line]
        ""let quoted = append(line, quoted)
    endfor
    ""let quoted = alphasort#QuoteLines(lines)
    ""let quoted = QuoteLines(lines)
    echo "Quoted Lines:"
    echo (quoted)

    " Join the lines together
    "let joined = join(quoted, '\\n')
    "let joined = join(lines, '\r')
    "let joined = join(escaped, '\r')
    "let joined = join(quoted, '\n')
    "let joined = join(escaped, '\r')
    "let joined = join(escaped, ' ')
    let joined = join(quoted, " ")
    "let joined = join(escaped, " ")
    echo "Joined Lines:"
    echo (joined)

    " Clear the screen without a Press ENTER... prompt
    silent !clear

    " Create the command
    let command = 'alphabetize' . ' ' . joined
    echo "Command:"
    echo (command)

    " Alphabetize the lines
    "let alphabetized = split((! 'alphabetize' . ' ' . joined), '\\n')
    "let alphabetized = split((! 'alphabetize' . ' ' . joined), '\r')
    "let alphabetized = split((! command), '\\n')
    "let alphabetized = split((! command), '\\n')
    "let alphabetized = split((system(['alphabetize', joined])), '\\n')
    "let alphabetized = split(system(['alphabetize', joined]), '\\n')
    "let alphabetized = systemlist(['alphabetize', joined)])
    "let alphabetized = systemlist(['alphabetize', escaped])
    let alphabetized = systemlist(command)
    echo "Alphabetized Lines:"
    echo (alphabetized)

    " Unquote the lines
    let unquoted = []
    for i in alphabetized
        "let line = substitute(i, "\'\'", "", 'g')
        "let line = substitute(i, "\\'\\'", "", 'g')
        let line = substitute(i, "\'\'\'", "", 'g')
        let unquoted = unquoted + [line]
        "echo(i)
        ""quoted + [line]
        "let quoted = append(line, quoted)
    endfor
    echo "Unquoted Lines:"
    echo (unquoted)
    
    " Remove the "1 " in front of the first element
    "let first_elem = substitute(get(alphabetized, 0), '1 ', '', 'g')
    let first_elem = substitute(get(unquoted, 0), '1 ', '', 'g')
    "let first_elem = substitute(get(alphabetized, 0), '\'1 ', "\'", 'g')
    "let alphabetized = [first_elem] + alphabetized[1:len(alphabetized)]
    let alphabetized = [first_elem] + unquoted[1:len(unquoted)]
    echo "Sanitized Lines:"
    echo (alphabetized)

    " Replace the selected lines with the alphabetized lines
    let line_start = s:get_visual_start()
    let line_end = s:get_visual_end()
    "execute line_start . "," . line_end . "s/" . joined ."/" . join(alphabetized, "\r"). "/g"
    execute line_start . "," . line_end . "s/" . join(lines, '\n') ."/" . join(alphabetized, "\r"). "/g"
    "execute line_start . "," . line_end . "s/" . join(lines, '\r') ."/" . join(alphabetized, "\r"). "/g"
endfunction
