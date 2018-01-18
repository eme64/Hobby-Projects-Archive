xfeld=Input("Breite: ")
yfeld=Input("Höhe: ")
datnam$=Input$("Name der Spielkarte: ")
If FileType("maps\" + datnam$+"\briefe")><2 Then
	CreateDir("maps\" + datnam$)
	CreateDir("maps\" + datnam$ + "\briefe")
End If
datei=OpenFile("maps\" + datnam$+"\"+ datnam$+".stadt")
If datei<>0 Then antw$=Input$("Datei laden?: ")
If datei<>0 And antw$="j" Then
	
	xfeld=ReadLine(datei)
	yfeld=ReadLine(datei)
	Dim map(2,xfeld-1,yfeld-1)

	
	For x=0 To xfeld-1
		For y=0 To yfeld-1
		
			txt$=ReadLine$(datei)
			p1 = Instr(txt$, ".") 
			p2 = Instr(txt$, ".", p1+1)
			z1 = Left$(txt$, p1-1)  
			z2 = Mid$(txt$,p1+1,p2-p1-1) 
			z3 = Right$(txt$,Len(txt$)-p2) 
	
			map(0,x,y)=z1
			map(1,x,y)=z2
			If x=0 Or x=xfeld-1 Or y=0 Or y=yfeld-1 Then map(0,x,y)=4

		Next
	Next
	CloseFile(datei)
Else
	Dim map(2,xfeld-1,yfeld-1)
	For x=0 To xfeld-1
		For y=0To yfeld-1
			If x=0 Or x=xfeld-1 Or y=0 Or y=yfeld-1 Then map(0,x,y)=4
		Next
	Next
End If


Graphics 1280,1024,32,1
SetBuffer BackBuffer()


Const bild_seite=50
Const max_unt=13
Const max_unbeg=18
Const max_grob=5
Const max_spec=3

du_bild = LoadAnimImage("bilder\orange.bmp",bild_seite,bild_seite,0,5)
MaskImage du_bild, 255,255,255

sel = LoadImage("bilder\select.bmp")
MaskImage sel, 255,255,255


gegner_bild = LoadAnimImage("bilder\rot.bmp",bild_seite,bild_seite,0,5)
MaskImage gegner_bild, 255,255,255

flieher_bild = LoadAnimImage("bilder\blau.bmp",bild_seite,bild_seite,0,5)
MaskImage flieher_bild, 255,255,255

mann_bild = LoadAnimImage("bilder\gruen.bmp",bild_seite,bild_seite,0,5)
MaskImage mann_bild, 255,255,255

hindernis_bild = LoadAnimImage("bilder\hindernis.bmp",bild_seite,bild_seite,0,19)
MaskImage hindernis_bild, 255,255,255

untergrund_bild = LoadAnimImage("bilder\untergrund.bmp",bild_seite,bild_seite,0,14)
MaskImage untergrund_bild, 255,255,255

ramen=LoadImage("bilder\ramen.bmp")


grob=0
unt=0
unbeg=0
spec=0
Repeat
	
	;Tastenabfrage
	If KeyHit(200) And y_act >0 Then y_act=y_act-1 ;auf
	If KeyHit(205) And x_act < xfeld-1 Then x_act=x_act+1 ;rechts
	If KeyHit(208) And y_act < yfeld-1 Then y_act=y_act+1 ;ab
	If KeyHit(203) And x_act >0 Then x_act=x_act-1;links
	If KeyHit(59) And grob > 0 Then grob=grob-1 ;F1-grob
	If KeyHit(60) And grob < max_grob Then grob=grob+1 ;F2
	If KeyHit(61) And unt > 0 Then unt=unt-1 ;F3-untergrund
	If KeyHit(62) And unt < max_unt Then unt=unt+1 ;F4
	If KeyHit(63) And unbeg > 0 Then unbeg=unbeg-1 ;F5-nicht beg.
	If KeyHit(64) And unbeg < max_unbeg Then unbeg=unbeg+1 ;F6
	If KeyHit(65) And spec > 0 Then spec=spec-1 ;F7-spec
	If KeyHit(66) And spec < max_spec Then spec=spec+1 ;F8
	
	If KeyHit(57) Then;setzen
		map(0,x_act,y_act)=grob
		If grob=4 Then map(1,x_act,y_act)=unbeg Else map(1,x_act,y_act)=unt
		map(2,x_act,y_act)=spec
	End If
	
	

	;Bildaufbau	
	Cls
	For x2=-2 To 22
		For y2=-2 To 22
			x=x2+x_act-10
			y=y2+y_act-10
			If -1 < x  And x < xfeld And -1 < y  And y < yfeld Then
				Select map(0,x,y)
					Case 0
						DrawImage untergrund_bild,x2*bild_seite,y2*bild_seite,map(1,x,y)
					Case 1
						DrawImage untergrund_bild,x2*bild_seite,y2*bild_seite,map(1,x,y)
						DrawImage mann_bild,x2*bild_seite,y2*bild_seite,1
					Case 2
						DrawImage untergrund_bild,x2*bild_seite,y2*bild_seite,map(1,x,y)
						DrawImage gegner_bild,x2*bild_seite,y2*bild_seite,1
					Case 3
						DrawImage untergrund_bild,x2*bild_seite,y2*bild_seite,map(1,x,y)
						DrawImage flieher_bild,x2*bild_seite,y2*bild_seite,1
					Case 4
						DrawImage hindernis_bild,x2*bild_seite,y2*bild_seite,map(1,x,y)
					Case 5
						DrawImage untergrund_bild,x2*bild_seite,y2*bild_seite,map(1,x,y)
						DrawImage du_bild,x2*bild_seite,y2*bild_seite,1
				End Select
				
				If x=x_act And y=y_act Then
					If grob=4 Then map1_sel=unbeg Else map1_sel=unt
					Select grob
						Case 0
							DrawImage untergrund_bild,x2*bild_seite,y2*bild_seite,map1_sel
						Case 1
							DrawImage untergrund_bild,x2*bild_seite,y2*bild_seite,map1_sel
							DrawImage mann_bild,x2*bild_seite,y2*bild_seite,1
						Case 2
							DrawImage untergrund_bild,x2*bild_seite,y2*bild_seite,map1_sel
							DrawImage gegner_bild,x2*bild_seite,y2*bild_seite,1
						Case 3
							DrawImage untergrund_bild,x2*bild_seite,y2*bild_seite,map1_sel
							DrawImage flieher_bild,x2*bild_seite,y2*bild_seite,1
						Case 4
							DrawImage hindernis_bild,x2*bild_seite,y2*bild_seite,map1_sel
						Case 5
							DrawImage untergrund_bild,x2*bild_seite,y2*bild_seite,map1_sel
							DrawImage du_bild,x2*bild_seite,y2*bild_seite,1
					End Select
					DrawImage sel,x2*bild_seite,y2*bild_seite
				End If
				
			End If
			
		Next
	Next
	;DrawImage ramen,11*bild_seite,0
		
	Color 255,255,255
	Text 600,100,x_du
	Text 600,150,y_du
	;WaitTimer (frametimer)
	Flip
	
	



		
	

	
	
	
	
Until KeyDown(1)

datei=WriteFile("maps\" + datnam$+"\"+ datnam$+".stadt")
WriteLine datei,xfeld
WriteLine datei,yfeld
For x=0 To xfeld-1
	For y=0 To yfeld-1
		WriteLine datei,map(0,x,y)+"."+map(1,x,y)+"."+map(2,x,y)
	Next
Next
CloseFile datei

End