targetFileType$ = "*.TextGrid"
targetDirectory$ = chooseDirectory$ ("Hi, Natalie! Where are the files you'd like to modify?")

Create Strings as file list... fileList 'targetDirectory$'/'targetFileType$'
fileListID = selected ("Strings")
numberOfFiles = Get number of strings

clearinfo
printline 'targetDirectory$'
for fileNumber to numberOfFiles
	select fileListID
	currentFile$ = Get string... 'fileNumber'
	printline 'currentFile$'
	Read from file... 'targetDirectory$'/'currentFile$'
	nameAndType$ = selected$ ()
	fileType$ = extractWord$ (nameAndType$, "")
	currentFileID = selected (fileType$)
	printline 'fileNumber' 'tab$' 'currentFile$'

	Insert point tier... 1 tones
	Insert point tier... 4 breaks
	Insert point tier... 5 misc
	Save as text file... 'targetDirectory$'/'currentFile$'

	beginPause ("What next?")
	buttonClicked = endPause ("Cancel", if fileNumber = numberOfFiles then "Done" else "Next file" fi, 2, 1)
	select currentFileID
	Remove
	goto CANCEL buttonClicked = 1
endfor
label CANCEL
select fileListID
Remove