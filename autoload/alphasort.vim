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

function! EscapeLB(text)
    return substitute(a:text, '\['   , '\\\[' , 'g')
endfunction

function! Log(message)
    " Logs a message to the console if in debug mode
    " else outputs nothing
    if g:alphasort_debug_mode == 1
        echo(a:message)
    endif
endfunction

"function! LogVar(args)
"function! LogVar(...)
"function! LogVar(message, ...)
    "  Log a message and a variable to the console

    "echo(a:0)
    "Info(a:1 . ":")
    "Info(a:2)

    "let message = split(a:args' ')[0]
    "let var = split(a:args, ' ')[1]
    "Info(message . ":")
    "Info(var)

    "let message = split(a:args, '\n')[0]
    "let var = split(a:args, '\n')[1]

    "let message = split(a:args, '\,')[0]
    "let var = split(a:args, '\,')[1]

    "Info(message . ":")
    "Info(var)

    "for arg in a:args
        "Info(arg)
    "endfor

    "Info(message . ":")
    " TODO Replace with loop
    "for arg in a:args
        "Info(arg)
    "endfor
    "Info(a:1)
"endfunction

" Functions for sorting imports
function! alphasort#SortImports(start, end)
    " Sorts all selected import statements
    Info("Debug Level:")
    Info(g:alphasort_debug_mode)
    "InfoLogVar("Debug Level", g:alphasort_debug_mode)

    " Get all the lines
    let lines = s:get_visual_selection()
    Info("Selected Lines:")
    Info(lines)

    " Escape special character sequences: #, ', [
    let escaped = []
    for i in lines
        " TODO Add support for comments
        let line = substitute(i     , '#'   , '\\#' , 'g')
        let line = substitute(line  , "\'"  , "\\'" , 'g')
        let line = EscapeLB(line)
        let escaped = escaped + [line]
    endfor
    Info("Escaped Lines:")
    Info(escaped)

    let quoted = Quote(escaped)
    Info("Quoted Lines:") 
    Info(quoted)

    let joined = join(quoted, " ")
    Info("Joined Lines:")
    Info(joined)

    " Clear the screen without a Press ENTER... prompt
    silent !clear

    " Format the command to alphasort
    let command = 'alphasort' . ' ' . joined
    Info("Command:")
    Info(command)

    " Retrieve the alphabetized lines
    let alphabetized = systemlist(command)
    Info("Alphabetized Lines:")
    Info(alphabetized)

    let unquoted = Unquote(alphabetized)
    Info("Unquoted Lines:")
    Info(unquoted)
    
    " Remove the "1 " in front of the first element
    let nolinenums = RemoveCommandLN(unquoted)
    Info("Sanitized Lines:")
    Info(nolinenums)
    
    let matched = join(lines, '\n')
    Info("Matched Lines:")
    Info(matched)

    let replaced = join(nolinenums, "\r")
    Info("Replaced Lines:")
    Info(replaced)
    
    " Replace the selected lines
    let replace_command = a:start . "," . a:end . "s/" . EscapeLB(matched) ."/" . replaced. "/g"
    Info("Replace Command:")
    Info(replace_command)
    execute replace_command
endfunction
