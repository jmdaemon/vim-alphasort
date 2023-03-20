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

function! EscapeAsterisk(text)
    return substitute(a:text, '\*'   , '\\*' , 'g')
endfunction

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

function! alphasort#SortImports(start, end)
    " Lexicographically orders all visually selected statements

    call LogVar("Debug Level", g:alphasort_debug_mode)

    " Get all the lines
    let lines = s:get_visual_selection()
    call LogVar("Selected Lines", lines)

    " Escape special character sequences: #, ', [
    let escaped = []
    for i in lines
        " TODO Add support for comments
        "let line = substitute(i     , '#'   , '\\#' , 'g')
        "let line = substitute(line  , '*'   , '\\*' , 'g')
        let line = substitute(i     , '\*'   , '\\\*' , 'g')
        let line = substitute(line  , '#'   , '\\#' , 'g')
        let line = substitute(line  , "\'"  , "\\'" , 'g')
        let line = EscapeLB(line)
        " Append to list
        let escaped = escaped + [line]
    endfor
    call LogVar("Escaped Lines", escaped)

    let quoted = Quote(escaped)
    call LogVar("Quoted Lines", quoted)

    let joined = join(quoted, " ")
    call LogVar("Joined Lines", joined)

    " Clear the screen without a Press ENTER... prompt
    silent !clear

    " Format the command to alphasort
    let command = 'alphasort' . ' ' . joined
    call LogVar("Command", command)

    " Retrieve the alphabetized lines
    let alphabetized = systemlist(command)
    call LogVar("Alphabetized Lines", alphabetized)

    " Since we shelled out for this command, we need to escape
    " the pattern again
    "let double_escaped = []
    "for i in alphabetized
    "    " TODO Add support for comments
    "    "let line = EscapeAsterisk(i)
    "    let line = substitute(i, '\*'   , '\\\*' , 'g')
    "    " Append to list
    "    let double_escaped = double_escaped + [line]
    "endfor
    "call LogVar("Double Escaped Lines", double_escaped)

    "let unquoted = Unquote(double_escaped)
    let unquoted = Unquote(alphabetized)
    call LogVar("Unquoted Lines", unquoted)
    
    " Remove the "1 " in front of the first element
    let nolinenums = RemoveCommandLN(unquoted)
    call LogVar("Sanitized Lines", nolinenums)
    
    let matched = join(lines, '\n')
    call LogVar("Matched Lines", matched)

    let final_escape = substitute(matched, '\*'   , '\\*' , 'g')

    let replaced = join(nolinenums, "\r")
    call LogVar("Replaced Lines", replaced)
    
    " Replace the selected lines
    let replace_command = a:start . "," . a:end . "s/" . EscapeLB(final_escape) ."/" . replaced. "/g"
    call LogVar("Replace Command", replace_command)
    execute replace_command
endfunction
