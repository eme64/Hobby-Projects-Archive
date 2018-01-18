SuperStrict

'Framework BRL.Audio
'Import BRL.FileSystem
'Import BRL.StandardIO
'Import BRL.Retro





Type SOUNDS
	Global sample:TSound[256]
	Global special:TSound[256]'0=eu oder �u, 1=ei, 2=ie, 3=ch, 4=sch, 5=ck, 6=ss, 7=mm, 8=sp, 9=tz, 10=st, 11=ng, 12=ll, 13=nn, 14=au, 15=tt, 16=tio, 17=ist
	
	Function ini()
		For Local i:Int=0 To 255
			If FileType("buchstaben\"+Chr(i)+".wav")=1 Then
				SOUNDS.sample[i]=LoadSound("buchstaben\"+Chr(i)+".wav")
				'PlaySound(SOUNDS.sample[i])
				Print "buchstaben\"+Chr(i)+".wav"
				Print i
			End If
			
			If FileType("buchstaben\spec"+String(i)+".wav")=1 Then
				SOUNDS.special[i]=LoadSound("buchstaben\spec"+String(i)+".wav")
				Print "buchstaben\spec"+String(i)+".wav"
				Print i
			End If
		Next
	End Function
	
	Function read_text(txt:String, speed:Float)
		
		While txt<>""
			Select True
				Case "eu"=Lower(Mid(txt,1,2))
					Print "eu"
					Print 0
					Local channel:TChannel=PlaySound(SOUNDS.special[0])
					SetChannelRate channel,speed
					Delay 200/speed
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
				Case "�u"=Lower(Mid(txt,1,2))
					Print "�u"
					Print 0
					Local channel:TChannel=PlaySound(SOUNDS.special[0])
					SetChannelRate channel,speed
					Delay 200/speed
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
				Case "ei"=Lower(Mid(txt,1,2))
					Print "ei"
					Print 1
					Local channel:TChannel=PlaySound(SOUNDS.special[1])
					SetChannelRate channel,speed
					Delay 200/speed*1.5
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
				Case "ie"=Lower(Mid(txt,1,2))
					Print "ie"
					Print 2
					Local channel:TChannel=PlaySound(SOUNDS.special[2])
					SetChannelRate channel,speed
					Delay 200/speed*1.5
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
				Case "ch"=Lower(Mid(txt,1,2))
					Print "ch"
					Print 3
					Local channel:TChannel=PlaySound(SOUNDS.special[3])
					SetChannelRate channel,speed
					Delay 200/speed
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
				Case "sch"=Lower(Mid(txt,1,3))
					Print "sch"
					Print 4
					Local channel:TChannel=PlaySound(SOUNDS.special[4])
					SetChannelRate channel,speed
					Delay 200/speed
					PauseChannel(channel)
					txt=Mid(txt,4,-1)
				Case "ck"=Lower(Mid(txt,1,2))
					Print "ck"
					Print 5
					Local channel:TChannel=PlaySound(SOUNDS.special[5])
					SetChannelRate channel,speed
					Delay 200/speed
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
				Case "ss"=Lower(Mid(txt,1,2))
					Print "ss"
					Print 6
					Local channel:TChannel=PlaySound(SOUNDS.special[6])
					SetChannelRate channel,speed
					Delay 200/speed
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
				Case "�"=Lower(Mid(txt,1,2))
					Print "�"
					Print 6
					Local channel:TChannel=PlaySound(SOUNDS.special[6])
					SetChannelRate channel,speed
					Delay 200/speed
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
				Case "mm"=Lower(Mid(txt,1,2))
					Print "mm"
					Print 7
					Local channel:TChannel=PlaySound(SOUNDS.special[7])
					SetChannelRate channel,speed
					Delay 200/speed
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
				Case "sp"=Lower(Mid(txt,1,2))
					Print "sp"
					Print 8
					Local channel:TChannel=PlaySound(SOUNDS.special[8])
					SetChannelRate channel,speed
					Delay 200/speed
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
				Case "tz"=Lower(Mid(txt,1,2))
					Print "tz"
					Print 9
					Local channel:TChannel=PlaySound(SOUNDS.special[9])
					SetChannelRate channel,speed
					Delay 200/speed
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
				Case "st"=Lower(Mid(txt,1,2))
					Print "st"
					Print 10
					Local channel:TChannel=PlaySound(SOUNDS.special[10])
					SetChannelRate channel,speed
					Delay 200/speed
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
					
				Case "ng"=Lower(Mid(txt,1,2))
					Print "ng"
					Print 11
					Local channel:TChannel=PlaySound(SOUNDS.special[11])
					SetChannelRate channel,speed
					Delay 200/speed
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
				Case "ll"=Lower(Mid(txt,1,2))
					Print "ll"
					Print 12
					Local channel:TChannel=PlaySound(SOUNDS.special[12])
					SetChannelRate channel,speed
					Delay 200/speed
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
				Case "nn"=Lower(Mid(txt,1,2))
					Print "nn"
					Print 13
					Local channel:TChannel=PlaySound(SOUNDS.special[13])
					SetChannelRate channel,speed
					Delay 200/speed
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
				Case "au"=Lower(Mid(txt,1,2))
					Print "au"
					Print 14
					Local channel:TChannel=PlaySound(SOUNDS.special[14])
					SetChannelRate channel,speed
					Delay 200/speed
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
				Case "tt"=Lower(Mid(txt,1,2))
					Print "tt"
					Print 15
					Local channel:TChannel=PlaySound(SOUNDS.special[15])
					SetChannelRate channel,speed
					Delay 200/speed
					PauseChannel(channel)
					txt=Mid(txt,3,-1)
				Case "tio"=Lower(Mid(txt,1,3))
					Print "tio"
					Print 16
					Local channel:TChannel=PlaySound(SOUNDS.special[16])
					SetChannelRate channel,speed
					Delay 200/speed*1.5
					PauseChannel(channel)
					txt=Mid(txt,4,-1)
				Case "ist"=Lower(Mid(txt,1,3))
					Print "ist"
					Print 17
					Local channel:TChannel=PlaySound(SOUNDS.special[17])
					SetChannelRate channel,speed
					Delay 400/speed
					PauseChannel(channel)
					txt=Mid(txt,4,-1)
				Default
					Print Mid(txt,1,1)
					Print Asc(Mid(txt,1,1))
					If SOUNDS.sample[Asc(Mid(txt,1,1))]<>Null Then
						Local channel:TChannel=PlaySound(SOUNDS.sample[Asc(Mid(txt,1,1))])
						SetChannelRate channel,speed
						Delay 200/speed
						PauseChannel(channel)
						txt=Mid(txt,2,-1)
						Print "ok"
					Else
						Delay 200/speed
						txt=Mid(txt,2,-1)
						Print "no"
					End If
			End Select
		Wend
	End Function
End Type

SOUNDS.ini()

Repeat
	SOUNDS.read_text("hallo g�tti   ",0.8)
Forever



