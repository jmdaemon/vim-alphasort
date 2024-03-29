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

" Symbol Escape Functions
function! EscapeLB(text)
    return substitute(a:text, '\['   , '\\\[' , 'g')
endfunction

function! EscapeAsterisk(text)
    return substitute(a:text, '\*'   , '\\*' , 'g')
endfunction

function! EscapePoundSign(text)
    return substitute(a:text, '#'   , '\\#' , 'g')
endfunction

function! EscapeSingleQuote(text)
    return substitute(a:text  , "\'"  , "\\'" , 'g')
endfunction

" Logging & Debug Functions
function! Log(message)
    " Logs a message to the console if in debug mode
    " else outputs nothing
    if g:alphasort_debug_mode == 1
        echo(a:message)
    endif
endfunction

function! LogVar(text, var)
    Info(a:text . ":")
    Info(a:var)
endfunction

function! LogReturn(text, var)
    " Log a message and return the variable
    call LogVar(a:text, a:var)
    return a:var
endfunction

function! alphasort#SortImports(start, end)
    " Lexicographically orders all visually selected statements

    call LogVar("Debug Level", g:alphasort_debug_mode)

    " Prepare data for sorting
    " Get all the lines
    let lines = LogReturn("Selected Lines", s:get_visual_selection())

    " Escape special character sequences: #, ', [
    let escaped = []
    for i in lines
        " TODO Add support for comments
        let line = EscapeAsterisk(i)
        let line = EscapePoundSign(line)
        let line = EscapeSingleQuote(line)
        let line = EscapeLB(line)
        " Append to list
        let escaped = escaped + [line]
    endfor
    call LogVar("Escaped Lines", escaped)

    let quoted          = LogReturn("Quoted Lines", Quote(escaped)) 
    let joined          = LogReturn("Joined Lines", join(quoted, " "))

    " Clear the screen without a Press ENTER... prompt
    silent !clear

    " Sort the visually selected text
    " Format the command to alphasort
    let command         = LogReturn("Command", 'alphasort' . ' ' . joined)

    " Retrieve the alphabetized lines
    let alphabetized    = LogReturn("Alphabetized Lines", systemlist(command))
    let unquoted        = LogReturn("Unquoted Lines", Unquote(alphabetized))
    
    " Remove the "1 " in front of the first element
    let no_linenumbers  = LogReturn("No Line Numbers", RemoveCommandLN(unquoted))
    let matched         = LogReturn("Matched Lines", join(lines, '\n'))

    " Since we shelled out for this command, we need to escape
    " the pattern again
    let no_asterisk     = EscapeAsterisk(matched)
    let no_linebreak    = EscapeLB(no_asterisk)
    let matched         = no_linebreak

    let replaced        = LogReturn("Replaced Lines", join(no_linenumbers, "\r"))
    
    " Replace the selected lines
    let replace_command = a:start . "," . a:end . "s/" .  matched . "/" . replaced. "/g"
    call LogVar("Replace Command", replace_command)
    execute replace_command
endfunction
