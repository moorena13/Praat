# This script locates break indices and labels the pitch (f0) from 1-5.
# Written by Natalie Moore, 2017

soundDirectory$ = chooseDirectory$ ("Where are the sound files located?")
tgDirectory$ = chooseDirectory$ ("Where are the text grids located?")

beginPause: "Analyze pitch from labeled points in files"
	comment: "Directory of sound files"
	sentence: "Sound Directory", soundDirectory$
	sentence: "Sound File Extension", ".wav"
	comment: "Directory of TextGrid files"
	sentence: "TextGrid Directory",  tgDirectory$
	sentence: "TextGrid File Extension", ".TextGrid"
	comment: "Which tier contains the breaks?"
	positive: "Break Tier", "1"
	comment: "Which tier contains the pitch range?"
	positive: "Pitch Tier", "2"
endPause: "Continue", 1

# Sound file listing

concat$ = sound_Directory$ + "\" + "*" + sound_File_Extension$
Create Strings as file list: "list", concat$
numberOfFiles = Get number of strings

for ifile to numberOfFiles
	filename$ = Get string... ifile
	temp$ = sound_Directory$ + "\" + filename$
	Read from file: temp$
	soundname$ = selected$ ("Sound", 1)
	To Pitch: 0.01, 75, 550
	
	#get textgrid
	gridfile$ = textGrid_Directory$ + "\" + soundname$ + textGrid_File_Extension$
	if fileReadable (gridfile$)
		Read from file: gridfile$
		breakNumber = Get number of points: break_Tier
		pitchLabel$ = Get label of interval: pitch_Tier, 2
		pitchMinimum = number(left$(pitchLabel$, 3))
		pitchMaximum = number(right$(pitchLabel$, 3))
		appendInfoLine: pitchMinimum
		appendInfoLine: pitchMaximum
		smallPitchRange = (pitchMaximum - pitchMinimum) / 3
		appendInfoLine: smallPitchRange
		bottomThird = pitchMinimum + smallPitchRange
		appendInfoLine: bottomThird
		topThird = bottomThird + smallPitchRange
		appendInfoLine: topThird

		for point to breakNumber
			time = Get time of point: break_Tier, point
			select Pitch 'soundname$'
			output = Get value at time... time Hertz Linear
			appendInfoLine: "point: ", point, output
			textGridName$ = replace$(filename$, ".wav", "", 0)
			select TextGrid 'textGridName$'

			
			numberLabel = 0

			if output < pitchMinimum
				numberLabel = 1
			elsif output < bottomThird
				numberLabel = 2
			elsif output < topThird
				numberLabel = 3
			elsif output < pitchMaximum
				numberLabel = 4
			else
				numberLabel = 5
			endif
			
			Insert point: 3, time, string$(numberLabel)
			
		endfor
		
		Save as text file: gridfile$
	endif
endfor
