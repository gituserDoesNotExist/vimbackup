
function! CompileSqlFile()
	let l:result=system(g:COMPILE_BASH_SCRIPT . " " . expand('%:p'))
	let l:messages=split(l:result,'_NEWMESSAGE_')
	let l:windowNrRecentlyEditedFile=winnr()
	let l:consoleWindowNr=bufwinnr("__CONSOLE__")
	execute	l:consoleWindowNr . "wincmd w"
	call append(0, l:messages)
	execute l:windowNrRecentlyEditedFile . "wincmd w"
endfun
