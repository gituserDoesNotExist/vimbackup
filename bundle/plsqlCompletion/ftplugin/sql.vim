"Path to folder containing sql files
let g:PATH_TO_SQL_FILES=$HOME . "/java-sht/projects/es-dietplan/additional-shit/backup-plsql-files/DIETPLAN/"
let g:BASE_PATH=$HOME . "/.vim/bundle/plsqlCompletion/ftplugin"


"#############create console window
augroup enterGroup
"	autocmd VimEnter *.sql execute winheight(0)/4 . "sp __CONSOLE__ | setlocal filetype=plsqlconsole | setlocal buftype=nofile"
""	autocmd VimEnter *.sql execute "NERDTree " . g:PATH_TO_SQL_FILES
augroup END

"############dictionary completion start
setlocal dictionary+=plsql-dictionary
setlocal iskeyword+=.
inoremap <C-K> <C-X><C-K>
"############dictionary completion end

"############plsql-autocompletion start
inoremap <c-u> <c-x><c-u>

let g:AUTOCOMPLETE_BASH_SCRIPT=g:BASE_PATH ."/autocompletion/fetch-db-object-properties.sh"
execute "source " . g:BASE_PATH . "/autocompletion/plsql-completion.vim"

setlocal completefunc=Complete

setlocal omnifunc=syntaxcomplete#Complete
inoremap <c-o> <c-x><c-o>
"############plsql-autocompletion end

"#############compiling start
let g:COMPILE_BASH_SCRIPT=g:BASE_PATH . "/compiling/compile-sql-file.sh"

nnoremap <F5> :w<cr>:CompileSql<cr>
inoremap <F5> <esc>:w<cr>:CompileSql<cr>
command! -nargs=0 CompileSql :call CompileSqlFile()
execute "source " . g:BASE_PATH . "/compiling/compile-sql-file.vim"
"#############compiling end
