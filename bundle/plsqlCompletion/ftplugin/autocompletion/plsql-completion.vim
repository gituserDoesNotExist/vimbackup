let b:baseDir=g:PATH_TO_SQL_FILES
let b:bashScriptAutocompletion=g:AUTOCOMPLETE_BASH_SCRIPT


function! Complete(findstart,base)
	if a:findstart
		return FindWordStartColumn()
	else
		if IsDbQuery()
			return FindMatchingProposalsForQuery(a:base)
		endif
		if DoesUserWantToSearchForFile(a:base)
			return FindMatchingFiles(a:base)
		endif
		if DoesUserWantsToSearchForAttrsAndMethodsOfObjectTypeOrPackage(a:base)
			return FindMatchingAttributesInFile(a:base)
		endif
		if DoesUserWantsToSearchForProcedureOrFunction(a:base)
			return FindParametersForProcedure(a:base)
		endif
		return ["no","match","found","for:",a:base]
	endif
endfun

function! FindWordStartColumn()
    let l:line = GetCurrentLine()
    let l:start = GetColumnOfCursor() - 1
    while start > 0 && (l:line[l:start - 1] !~ "\\s")
    	let l:start -= 1
    endwhile
    return l:start
endfun


function! IsDbQuery()
	return GetCurrentLine()=~".*select.*"
endfun

function! FindMatchingProposalsForQuery(partOfUserInput)
	"muss angehaengt werden, da der Cursor zurueckspringt beim Ermitteln der Spalte
	let l:currentline=GetCurrentLine() . a:partOfUserInput
	let l:linepart=GetLineFromStartToCursorPosition()
	let l:tablename=ExtractTablenameFromQuery(l:currentline)
	if UserWantsToFindTable(l:linepart)
		return FindMatchingFilesInSubfolder(l:tablename,'tables')
	else
		return FindFieldsInTable(l:tablename,a:partOfUserInput)
	endif
	return ["so","a","db","query"]
endfun


function! FindFieldsInTable(tablename,partOfUserInput)
	if len(a:tablename)==0
		return []
	endif
	let l:allColumnNamesOfTable=CallPlsqlEngine(a:tablename)
	let l:result=[]
	for l:colname in l:allColumnNamesOfTable
		if toupper(l:colname)=~toupper(a:partOfUserInput)
			call add(l:result,l:colname)
		endif
	endfor
	return l:result
endfun


function! UserWantsToFindTable(linepart)
	return toupper(a:linepart)=~"FROM" && toupper(a:linepart)!~"WHERE"
endfun

function! ExtractTablenameFromQuery(line)
	return substitute(toupper(a:line),".*SELECT\\s.*\\sFROM\\s\\+\\(\\w*\\).*","\\1","g")
endfun

function! DoesUserWantToSearchForFile(userInput)
	return a:userInput !~ "\\." && a:userInput !~ "("
endfun


function! FindMatchingFilesInSubfolder(name,partOfPath)
	let l:matchingFileNames=[]
	let l:pathnames=split(globpath(b:baseDir,"**" . a:partOfPath . "**/*.sql"),"\\n")
	for l:filepath in l:pathnames
		let l:filename=fnamemodify(l:filepath, ':t:r')
		if toupper(l:filepath) =~ toupper(a:name)
			call add(l:matchingFileNames,l:filename)
		endif
	endfor
	return l:matchingFileNames
endfun

function! FindMatchingFiles(name)
	return FindMatchingFilesInSubfolder(a:name,'')
endfun



function! DoesUserWantsToSearchForAttrsAndMethodsOfObjectTypeOrPackage(userinput)
	return a:userinput =~ "\\w\\+\\.\\w*"
endfun


"corresponds to that what user entered, e.g. base_entity.enti
function! FindMatchingAttributesInFile(userInput)
	let l:dbObjectName=substitute(a:userInput,"\\(\\w\\+\\)\\.\\(\\w*\\)","\\1","g")
	let l:partOfAttribute=substitute(a:userInput,"\\(\\w\\+\\)\\.\\(\\w*\\)","\\2","g")

    let l:metadata = CallPlsqlEngine(l:dbObjectName)

	let l:matchingAttributes=["..."]
	for l:attribute in l:metadata
		if toupper(l:attribute) =~ toupper(l:partOfAttribute)
			call add(l:matchingAttributes,l:dbObjectName . '.' . l:attribute)
		endif
	endfor
    return l:matchingAttributes
endfun

function! CallPlsqlEngine(dbObjectName)
    let l:resultstring = system(b:bashScriptAutocompletion . ' ' . toupper(a:dbObjectName))
    let l:metadata = split(l:resultstring,";")
	return l:metadata
endfun


function! DoesUserWantsToSearchForProcedureOrFunction(userinput)
	return a:userinput =~ "\\w\\+("
endfun

function! FindParametersForProcedure(userInput)
	let l:procedureName=substitute(a:userInput,"\\(\\w\\+\\)(","\\1","g")
    let l:resultstring = system(b:bashScriptAutocompletion . ' ' . toupper(l:procedureName))
	return [l:resultstring]
endfun


function! GetLineFromStartToCursorPosition()
	return strpart(GetCurrentLine(),0,GetColumnOfCursor())
endfun

function! GetCurrentLine()
	return getline('.')
endfun


function! GetColumnOfCursor()
	return col('.')
endfun

