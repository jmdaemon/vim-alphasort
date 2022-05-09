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

function! Quote(lines)
    " Inserts quotes inbetween a line of text in a list of lines
    let quoted = []
    for i in a:lines
        let line = "\'" . i . "\'"
        let quoted = quoted + [line]
    endfor
    return quoted
endfunction

function! Unquote(lines)
    " Removes quotes in a line of text from a list of lines
    let unquoted = []
    for i in a:lines
        let line = substitute(i, "\'\'\'", "", 'g')
        let unquoted = unquoted + [line]
    endfor
    return unquoted
endfunction

function! RemoveCommandLN(elems)
    " Removes the line number associated with the result of a command
    " Remove the "1 " in front of the first element
    let first_elem  = get(a:elems, 0)
    let len_elems   = len(a:elems) 
    let sanitized   = substitute(first_elem, '1 ', '', 'g')
    let result      = [sanitized] + a:elems[1:len_elems]
    return result
endfunction

function! Log(message)
    " Logs a message to the console if in debug mode
    " else outputs nothing
    if g:alphasort_debug_mode == 1
        echo(a:message)
    endif
endfunction

" Functions for sorting imports
function! alphasort#SortImports(start, end)
    " Sorts all selected import statements
    Info("Debug Level: ")
    Info(g:alphasort_debug_mode)

    " Get all the lines
    let lines = s:get_visual_selection()
    Info("Selected Lines:")
    Info(lines)

    " Escape special character sequences: #, '
    let escaped = []
    for i in lines
        let line = substitute(i     , '#'   , '\\#' , 'g')
        let line = substitute(line  , "\'"  , "\\'" , 'g')
        let escaped = escaped + [line]
    endfor
    Info("Escaped Lines:")
    Info(escaped)

    " Quote the variables
    let quoted = Quote(lines)
    Info("Quoted Lines:")
    Info(quoted)

    " Join the lines together
    let joined = join(quoted, " ")
    Info("Joined Lines:")
    Info(joined)

    " Clear the screen without a Press ENTER... prompt
    silent !clear

    " Create the command
    let command = 'alphabetize' . ' ' . joined
    Info("Command:")
    Info(command)

    " Alphabetize the lines
    let alphabetized = systemlist(command)
    Info("Alphabetized Lines:")
    Info(alphabetized)

    " Unquote the lines
    let unquoted = Unquote(alphabetized)
    Info("Unquoted Lines:")
    Info(unquoted)
    
    " Remove the "1 " in front of the first element
    let alphabetized = RemoveCommandLN(unquoted)
    Info("Sanitized Lines:")
    Info(alphabetized)

    " Replace the selected lines with the alphabetized lines
    execute a:start . "," . a:end . "s/" . join(lines, '\n') ."/" . join(alphabetized, "\r"). "/g"
endfunction
