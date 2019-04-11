
function! CompileSqlFile()
	let l:result=system(g:COMPILE_BASH_SCRIPT . " " . expand('%:p'))
	let l:messages=split(l:result,'_NEWMESSAGE_')
	for l:message in l:messages
		echom l:message
	endfor
endfun
