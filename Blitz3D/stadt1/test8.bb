Graphics 800,600,32,1
SetBuffer BackBuffer()

Const bild_seite=50
Global xfeld
Global yfeld
Global xx1
Global xx2

SeedRnd MilliSecs ()
datafile$=CommandLine$()
frametimer=CreateTimer(10)

Dim m_bild(5)



If datafile$="" Then datafile$=Input$("spielname: ")
datafile$=datafile$
inifile$="maps\"+datafile$+"\"+datafile$+".ini";ini-datei
datei=OpenFile("maps\"+datafile$+"\"+datafile$+".stadt")

xfeld=ReadLine (datei) 
yfeld=ReadLine (datei)

ramen=LoadImage("bilder\ramen.bmp")

m_bild(0) = LoadAnimImage("bilder\rot.bmp",bild_seite,bild_seite,0,5)

m_bild(1) = LoadAnimImage("bilder\blau.bmp",bild_seite,bild_seite,0,5)

m_bild(2) = LoadAnimImage("bilder\gruen.bmp",bild_seite,bild_seite,0,5)

m_bild(3) = LoadAnimImage("bilder\orange.bmp",bild_seite,bild_seite,0,5)

m_bild(4) = LoadAnimImage("bilder\schlaeger.bmp",bild_seite,bild_seite,0,5)

m_bild(5) = LoadAnimImage("bilder\polizist.bmp",bild_seite,bild_seite,0,5)

For i=0 To 5
	MaskImage m_bild(i),255,255,255
Next


hindernis_bild = LoadAnimImage("bilder\hindernis.bmp",bild_seite,bild_seite,0,19)
MaskImage hindernis_bild, 255,255,255

untergrund_bild = LoadAnimImage("bilder\untergrund.bmp",bild_seite,bild_seite,0,14)
MaskImage untergrund_bild, 255,255,255

inigeg_bild = LoadAnimImage("bilder\inigeg.bmp",bild_seite,bild_seite,0,2)
MaskImage inigeg_bild, 255,255,255

For i=0 To MilliSecs()/600
	Rand (0,100)
Next

;---map(0,x,y)---
;menschen fein (bilder)

;---map(1,x,y)---
;boden,hindernis fein (bilder)

;---map(2,x,y)---
;0=nix
;1=leute
;2=angreifer
;3=fliehende
;4=hindernis
;5=du
;6=ini-mensch
;7=ini-gegenstand

;---map(3,x,y)---
;gehbefehle

;---map(4,x,y)---
;gehrichtung (für bilder)

;---map(5,x,y)---
;gehziel X

;---map(6,x,y)---
;gehziel Y


Dim map(8,xfeld-1,yfeld-1)
Dim map2(xfeld-1,yfeld-1)
Dim feld(xfeld-1,yfeld-1)
;Karte einlesen
For x=0 To xfeld-1
	For y=0 To yfeld-1
	
		txt$=ReadLine$(datei)
		p1 = Instr(txt$, ".")
		p2 = Instr(txt$, ".", p1+1)
		z1 = Left$(txt$, p1-1)
		z2 = Mid$(txt$,p1+1,p2-p1-1)
		z3 = Right$(txt$,Len(txt$)-p2)

		If z1=5 Then 
			x_du=x
			y_du=y
		End If
		
		map(2,x,y)=z1
		map(1,x,y)=z2
	Next
Next


anz_ini_ziele=0
If FileType(inifile$)=1 Then;inifile einlesen und verarbeiten
	ini=OpenFile(inifile$)
	
	While Not Eof(ini)
		trenn$="@"

		txt$=Lower(ReadLine$(ini))
		
		pos1=Instr(txt$,trenn$)
		pos2=Instr(txt$,trenn$,pos1+1)
		pos3=Instr(txt$,trenn$,pos2+1)
		pos4=Instr(txt$,trenn$,pos3+1)
		If pos1=0 Or pos2=0 Or pos3=0 Or pos4=0 Then Goto weiter1
		
		vorn$=Left$(txt$,pos1-1)
		mitte$=Mid$(txt$,pos1+1,pos2-pos1-1)
		mitte2$=Mid$(txt$,pos2+1,pos3-pos2-1)
		mitte3$=Mid$(txt$,pos3+1,pos4-pos3-1)
		hinten$=Right$(txt$,Len(txt$)-pos4)
		
		Select vorn$
			Case "set_passant"
				x=mitte$
				y=mitte2$
				map(2,x,y)=1
				map(0,x,y)=mitte3$
			Case "set_flieher"
				x=mitte$
				y=mitte2$
				map(2,x,y)=3
				map(0,x,y)=mitte3$
			Case "set_verfolger"
				x=mitte$
				y=mitte2$
				map(2,x,y)=2
				map(0,x,y)=mitte3$
			Case "set_inimensch"
				x=mitte$
				y=mitte2$
				map(2,x,y)=6
				map(0,x,y)=mitte3$
				map(7,x,y)=hinten$
			Case "send_mensch"
			Case "dim_briefe"
				Dim briefe$(mitte$)
				
			Case "set_brief"
				x=mitte$
				y=mitte2$
				map(2,x,y)=7
				map(7,x,y)=0
				map(0,x,y)=mitte3$
				briefe$(mitte3$)=hinten$
			Case "set_ziel"
				x=mitte$
				y=mitte2$
				map(2,x,y)=7
				map(7,x,y)=1
				anz_ini_ziele=anz_ini_ziele+1
			
			End Select
		
		.weiter1
	Wend
	CloseFile(ini)
End If;ende der inifile verarbeitung
end_var=0
ini_num=-1
ini_geg=-1
lesen=1
;Start der Hauptschleife
mil=MilliSecs()
FlushKeys
Repeat
	SeedRnd MilliSecs ()
	
	Cls
	If map(2,x_du+1,y_du)=7 Or map(2,x_du-1,y_du)=7 Or map(2,x_du,y_du+1)=7 Or map(2,x_du,y_du-1)=7 Or map(2,x_du+1,y_du+1)=7 Or map(2,x_du-1,y_du-1)=7 Or map(2,x_du-1,y_du+1)=7 Or map(2,x_du+1,y_du-1)=7 Then
		
		If map(2,x_du+1,y_du)=7 Then
			ini_geg=map(7,x_du+1,y_du)
			ini_num=map(0,x_du+1,y_du)
		End If
		If map(2,x_du-1,y_du)=7 Then
			ini_geg=map(7,x_du-1,y_du)
			ini_num=map(0,x_du-1,y_du)
		End If
		If map(2,x_du,y_du+1)=7 Then
			ini_geg=map(7,x_du,y_du+1)
			ini_num=map(0,x_du,y_du+1)
		End If
		If map(2,x_du,y_du-1)=7 Then
			ini_geg=map(7,x_du,y_du-1)
			ini_num=map(0,x_du,y_du-1)
		End If
				
		If map(2,x_du+1,y_du+1)=7 Then
			ini_geg=map(7,x_du+1,y_du+1)
			ini_num=map(0,x_du+1,y_du+1)
		End If
		If map(2,x_du-1,y_du-1)=7 Then
			ini_geg=map(7,x_du-1,y_du-1)
			ini_num=map(0,x_du-1,y_du-1)
		End If
		If map(2,x_du+1,y_du-1)=7 Then
			ini_geg=map(7,x_du+1,y_du-1)
			ini_num=map(0,x_du+1,y_du-1)
		End If
		If map(2,x_du-1,y_du+1)=7 Then
			ini_geg=map(7,x_du-1,y_du+1)
			ini_num=map(0,x_du-1,y_du+1)
		End If

		
		Select ini_geg
			Case 0
				If lesen=0 Then
					
					brief=0
					t$="maps\"+datafile$+"\briefe\"+briefe$(ini_num)+".brief"
					brief=OpenFile("maps\"+datafile$+"\briefe\"+briefe$(ini_num)+".brief")
					
					z=1
					Color 150,150,150
					While Not Eof(brief)
						txt$=ReadLine$(brief)
						Select txt$
							Case "#rot"
								Color 255,0,0
							Case "#blau"
								Color 0,0,255
							Case "#gelb"
								Color 255,255,0
							Case "#weiss"
								Color 255,255,255
							Case "#","#grau"
								Color 150,150,150
							Case "#gruen","#grün"
								Color 0,255,0
							Case "#violet","#pink"
								Color 255,0,255
							Case "#orange"
								Color 255,150,0
							Default
								Text 10,18*z,txt$
								z=z+1
						End Select
						
					
					Wend
					CloseFile(brief)
					Flip
					dazu=5000*z
					k_h=0
					w_t=0
					wait_time=MilliSecs()
					While k_h=0 And w_t=0
						If KeyHit(28) Then k_h=1
						If wait_time < MilliSecs()-dazu Then w_t=1
					Wend
					lesen=1
					ini_num=-1
					ini_geg=-1
				End If
			Case 1
				If map(2,x_du+1,y_du)=7 And map(7,x_du+1,y_du)=1 Then
					map(2,x_du+1,y_du)=0
					anz_ini_ziele=anz_ini_ziele-1
				End If
				If map(2,x_du-1,y_du)=7 And map(7,x_du-1,y_du)=1 Then
					map(2,x_du-1,y_du)=0
					anz_ini_ziele=anz_ini_ziele-1
				End If
				If map(2,x_du,y_du+1)=7 And map(7,x_du,y_du+1)=1 Then
					map(2,x_du,y_du+1)=0
					anz_ini_ziele=anz_ini_ziele-1
				End If
				If map(2,x_du,y_du-1)=7 And map(7,x_du,y_du-1)=1 Then
					map(2,x_du,y_du-1)=0
					anz_ini_ziele=anz_ini_ziele-1
				End If
						
				If map(2,x_du+1,y_du+1)=7 And map(7,x_du+1,y_du+1)=1 Then
					map(2,x_du+1,y_du+1)=0
					anz_ini_ziele=anz_ini_ziele-1
				End If
				If map(2,x_du-1,y_du-1)=7 And map(7,x_du-1,y_du-1)=1 Then
					map(2,x_du-1,y_du-1)=0
					anz_ini_ziele=anz_ini_ziele-1
				End If
				If map(2,x_du+1,y_du-1)=7 And map(7,x_du+1,y_du-1)=1 Then
					map(2,x_du+1,y_du-1)=0
					anz_ini_ziele=anz_ini_ziele-1
				End If
				If map(2,x_du-1,y_du+1)=7 And map(7,x_du-1,y_du+1)=1 Then
					map(2,x_du-1,y_du+1)=0
					anz_ini_ziele=anz_ini_ziele-1
				End If
			Default	
		End Select
	Else
		lesen=0
	End If
	;Tastenabfrage
	gehen=0
	If KeyDown(200) Then gehen=1
	If KeyDown(205) Then gehen=2
	If KeyDown(208) Then gehen=3
	If KeyDown(203) Then gehen=4
	If gehen >< 0 Then gehen2=gehen
	
	;Ausrechnen der Map(Befehle ausgeben)
	
	For x=0 To xfeld-1
		For y=0 To yfeld-1
			map2(x,y)=0
			If map(2,x,y)=1 Or map(2,x,y)=2 Or map(2,x,y)=3 Or map(2,x,y)=4 Or map(2,x,y)=5 Or map(2,x,y)=7 Then map2(x,y)=1
		Next
	Next
	
	For x=0 To xfeld-1
		For y=0 To yfeld-1
			Select map(2,x,y)
				Case 0
				Case 1
					If map(5,x,y)=x Or map(5,x,y)=0 Or map(6,x,y)=y Or map(6,x,y)=0 Then 
						zahl1=Rnd(1,xfeld-2)
						zahl2=Rnd(1,yfeld-2)
						If map(2,zahl1,zahl2)<>4 Then
							map(5,x,y)=zahl1
							map(6,x,y)=zahl2 
						End If
						map(3,x,y)=0
					Else
						map(3,x,y)=wegsuchen(map(5,x,y),map(6,x,y),x,y,1)
						If map(3,x,y)=0 Then 
							map(5,x,y)=0
							map(6,x,y)=0
						End If
					End If
				Case 2
					map(3,x,y)=0
					If Sqr(Abs(x-x_du)^2+Abs(y-y_du)^2) < 5 Then
					
						If Rand(0,3)><1 Then map(3,x,y)=wegsuchen(x_du,y_du,x,y,2)
						;map(3,x,y)=wegsuchen(x_du,y_du,x,y,2)

					
					Else
						zahl=Rand(1,4)
						If zahl >< map(3,x,y) Then map(3,x,y)=zahl
					End If
				Case 3
					map(3,x,y)=0
					If Sqr(Abs(x-x_du)^2+Abs(y-y_du)^2) < 5 Then
						
						If Rand(0,1)=1 Then
							If Sgn(x-x_du)=1 Then map(3,x,y)=2
							If Sgn(x-x_du)=-1 Then map(3,x,y)=4
							If Sgn(x-x_du)=0 Then
 								If Rand(0,1)=1 Then map(3,x,y)=2 Else map(3,x,y)=4
							End If
						Else
							If Sgn(y-y_du)=1 Then map(3,x,y)=3
							If Sgn(y-y_du)=-1 Then map(3,x,y)=1
							If Sgn(y-y_du)=0 Then
								If Rand(0,1)=1 Then map(3,x,y)=1 Else map(3,x,y)=3
							End If
						End If
					Else
						zahl=Rand(1,4)
						If zahl >< map(3,x,y) Then map(3,x,y)=zahl
					End If
					
					;;;;;;;;;;;;;andere fliehertech;;;;;;;;
					If 0=1 Then	
					If map(5,x,y)=x Or map(5,x,y)=0 Or map(6,x,y)=y Or map(6,x,y)=0 Or Sqr(Abs(map(5,x,y)-x_du)^2+Abs(map(6,x,y)-y_du)^2)>10 Or Sqr(Abs(x-x_du)^2+Abs(y-y_du)^2)>10 Then 
						zahl1=Rnd(1,xfeld-2)							
						zahl2=Rnd(1,yfeld-2)
					If map(2,zahl1,zahl2)<>4 Then
						map(5,x,y)=zahl1
						map(6,x,y)=zahl2 
					Else
						If map(2,zahl2,zahl1)<>4 Then
								map(5,x,y)=zahl2
							map(6,x,y)=zahl1 
						End If
					End If
						map(3,x,y)=0
					Else
						map(3,x,y)=wegsuchen(map(5,x,y),map(6,x,y),x,y,1)
						If map(3,x,y)=0 Then 
							map(5,x,y)=0
							map(6,x,y)=0
						End If
					End If
					End If
					;;;;;ende andere ftech;;;;
				Case 4
			End Select
			
		Next
	Next
	
	;Befehle sortieren
	Select gehen
		Case 1
			If map2(x_du,y_du-1)=0 Then
				map2(x_du,y_du-1)=1
			Else
				gehen=0
			End If
		Case 2
			If map2(x_du+1,y_du)=0 Then
				map2(x_du+1,y_du)=1
			Else
				gehen=0
			End If
		Case 3
			If map2(x_du,y_du+1)=0 Then
				map2(x_du,y_du+1)=1
			Else
				gehen=0
			End If
		Case 4
			If map2(x_du-1,y_du)=0 Then
				map2(x_du-1,y_du)=1
			Else
				gehen=0
			End If
	End Select
	
	For x=0 To xfeld-1
		For y=0 To yfeld-1
			
			Select map(3,x,y)
				Case 1
					If map2(x,y-1)=1 Then
						If map(3,x,y)><0 Then map(4,x,y)=map(3,x,y)						
						map(3,x,y)=0
					Else
						map2(x,y-1)=1
					End If
				Case 2
					If map2(x+1,y)=1 Then
						If map(3,x,y)><0 Then map(4,x,y)=map(3,x,y)						
						map(3,x,y)=0
					Else
						map2(x+1,y)=1
					End If
				Case 3
					If map2(x,y+1)=1 Then
						If map(3,x,y)><0 Then map(4,x,y)=map(3,x,y)						map(3,x,y)=0
					Else
						map2(x,y+1)=1
					End If
				Case 4
					If map2(x-1,y)=1 Then
						If map(3,x,y)><0 Then map(4,x,y)=map(3,x,y)						map(3,x,y)=0
					Else
						map2(x-1,y)=1
					End If
			End Select
		Next
	Next
	

	;Befehle ausführen
	map(2,x_du,y_du)=0
	
	Select gehen
		Case 1
			y_du=y_du-1
		Case 2
			x_du=x_du+1
		Case 3
			y_du=y_du+1
		Case 4
			x_du=x_du-1
	End Select
	
	map(2,x_du,y_du)=5
	
	For x=0 To xfeld-1
		For y=0 To yfeld-1
			Select map(3,x,y)
				Case 0
				Case 1
					map(2,x,y-1)=map(2,x,y)
					map(4,x,y-1)=map(4,x,y)
					map(5,x,y-1)=map(5,x,y)
					map(6,x,y-1)=map(6,x,y)
					map(3,x,y-1)=map(3,x,y)+5
					map(2,x,y)=0
					map(3,x,y)=0
				Case 2
					map(2,x+1,y)=map(2,x,y)
					map(4,x+1,y)=map(4,x,y)
					map(5,x+1,y)=map(5,x,y)
					map(6,x+1,y)=map(6,x,y)
					map(3,x+1,y)=map(3,x,y)+5
					map(2,x,y)=0
					map(3,x,y)=0
				Case 3
					map(2,x,y+1)=map(2,x,y)
					map(4,x,y+1)=map(4,x,y)
					map(5,x,y+1)=map(5,x,y)
					map(6,x,y+1)=map(6,x,y)
					map(3,x,y+1)=map(3,x,y)+5
					map(2,x,y)=0
					map(3,x,y)=0
				Case 4
					map(2,x-1,y)=map(2,x,y)
					map(4,x-1,y)=map(4,x,y)
					map(5,x-1,y)=map(5,x,y)
					map(6,x-1,y)=map(6,x,y)
					map(3,x-1,y)=map(3,x,y)+5
					map(2,x,y)=0
					map(3,x,y)=0
				Default
					
			End Select
			If map(3,x,y)=0 Then map(3,x,y)=map(3,x,y)+5
		Next
	Next

	

	;Bildaufbau
	For i=1 To 50 Step 3
		Select gehen
			Case 1
				x_move_bild=0
				y_move_bild=-50+i
			Case 2
				x_move_bild=50-i
				y_move_bild=0
			Case 3
				x_move_bild=0
				y_move_bild=50-i
			Case 4
				x_move_bild=-50+i
				y_move_bild=0
			Case 0
				x_move_bild=0
				y_move_bild=0
		End Select

		
		For x2=-2 To 12
			For y2=-2 To 12
				x=x2+x_du-5
				y=y2+y_du-5
				If -1 < x  And x < xfeld And -1 < y  And y < yfeld Then
					Select map(2,x,y)
						Case 4
							DrawImage hindernis_bild,x2*bild_seite+x_move_bild,y2*bild_seite+y_move_bild,map(1,x,y)
						Case 7
							DrawImage untergrund_bild,x2*bild_seite+x_move_bild,y2*bild_seite+y_move_bild,map(1,x,y)
							DrawImage inigeg_bild,x2*bild_seite+x_move_bild,y2*bild_seite+y_move_bild,map(7,x,y)
						Default
							DrawImage untergrund_bild,x2*bild_seite+x_move_bild,y2*bild_seite+y_move_bild,map(1,x,y)

					End Select
				End If
			Next
		Next
		
		
		
		
		For x2=-2 To 12
			For y2=-2 To 12
				x=x2+x_du-5
				y=y2+y_du-5
				If -1 < x  And x < xfeld And -1 < y  And y < yfeld Then
					
					Select map(3,x,y)-5
						Case 0
							xx=0
							yy=0
						Case 1
							xx=0
							yy=50-i
						Case 2
							xx=-50+i
							yy=0
						Case 3
							xx=0
							yy=-50+i
						Case 4
							xx=50-i
							yy=0
						
					End Select
				
					Select map(2,x,y)
						Case 1
							If map(3,x,y)>5 Then
								DrawImage m_bild(5),x2*bild_seite +x_move_bild+xx,y2*bild_seite+y_move_bild+yy,map(3,x,y)-5
							Else
								DrawImage m_bild(5),x2*bild_seite +x_move_bild,y2*bild_seite+y_move_bild,map(4,x,y)

							End If
						Case 2
							If map(3,x,y)>5 Then
								DrawImage m_bild(4),x2*bild_seite +x_move_bild+xx,y2*bild_seite+y_move_bild+yy,map(3,x,y)-5
							Else
								DrawImage m_bild(4),x2*bild_seite +x_move_bild,y2*bild_seite+y_move_bild,map(4,x,y)

							End If
						Case 3
							If map(3,x,y)>5 Then
								DrawImage m_bild(1),x2*bild_seite +x_move_bild+xx,y2*bild_seite+y_move_bild+yy,map(3,x,y)-5
							Else
								DrawImage m_bild(1),x2*bild_seite +x_move_bild,y2*bild_seite+y_move_bild,map(4,x,y)

							End If
						Case 5
							Select gehen
								Case 0
									xx=0
									yy=0
								Case 1
									xx=0
									yy=50-i
								Case 2
									xx=-50+i
									yy=0
								Case 3
									xx=0
									yy=-50+i
								Case 4
									xx=50-i
									yy=0
							End Select
							DrawImage m_bild(0),x2*bild_seite+x_move_bild+xx,y2*bild_seite+y_move_bild+yy,gehen2
					End Select

				End If
			Next
		Next
		DrawImage ramen,11*bild_seite,0
		
		Color 255,255,255
		Text 600,100,x_du
		Text 600,150,y_du	
		Text 550,200,"bildtempo: " + mil2
		Text 550,300,"Anzahl noch unerreichte Ziele: "
		Text 550,330, anz_ini_ziele
		Flip

		Cls
	Next
	mil2=MilliSecs()-mil
	mil=MilliSecs()
	If anz_ini_ziele=0 Then end_var=1
Until KeyDown(1) Or end_var=1
FreeTimer frametimer
;If end_var=1 Then
;End If
End
;;;
Function wegsuchen(x1,y1,x2,y2,option=0);start function
	If x1=x2 And y1=y2 Then Return -2
	If x1=x2 Then
		If y1+1=y2 Then Return 1
		If y1-1=y2 Then Return 3
	End If
	If y1=y2 Then
		If x1+1=x2 Then Return 4
		If x1-1=x2 Then Return 2
	End If;grundausscheidungen
	
	If x1<x2 Then;berechnen der endpunkte
		xx1=x1-2;-5
	Else
		xx1=x2-2;-5
	End If
	
	If y1<y2 Then
		yy1=y1-2;-5
	Else
		yy1=y2-2;-5
	End If
	
	xx2=xx1+Abs(x1-x2)+5+2;+5
	yy2=yy1+Abs(y1-y2)+5+2;+5
	
	If yy1<0 Then yy1=0
	If xx1<0 Then xx1=0
	
	If yy2>yfeld-1 Then yy2=yfeld-1
	If xx2>xfeld-1 Then xx2=xfeld-1
	

	
	For y=yy1 To yy2
		For x=xx1 To xx2
		
			If map(2,x,y)=0 Then feld(x,y)=0 Else feld(x,y)=-1
			;If x=xx1 Or x=xx1 Or y=yy1 Or y=yy2 Then feld(x,y)=-1
			
			If x=x1 And y=y1 Then feld(x,y)=-2
			If x=x2 And y=y2 Then feld(x,y)=-3
		Next
	Next
	
	If feld(x1+1,y1)=0 Then feld(x1+1,y1)=1
	If feld(x1-1,y1)=0 Then feld(x1-1,y1)=1
	If feld(x1,y1+1)=0 Then feld(x1,y1+1)=1
	If feld(x1,y1-1)=0 Then feld(x1,y1-1)=1
	
	z=1
	Repeat
		z=z+1
		e=0
		For y=yy1+1 To yy2-1
			For x=xx1+1 To xx2-1
				If feld(x,y)=0 Then
					If feld(x+1,y)=z-1 Or feld(x-1,y)=z-1 Or feld(x,y+1)=z-1 Or feld(x,y-1)=z-1 Then
						feld(x,y)=z
						e=1
					End If
				End If
			Next
		Next
	Until feld(x2+1,y2)>0 Or feld(x2-1,y2)>0 Or feld(x2,y2+1)>0 Or feld(x2,y2-1) > 0 Or e=0
						
		
	If feld(x2,y2-1)=z Or feld(x2,y2-1)=1 Then
		r=1
	Else
		If feld(x2+1,y2)=z Or feld(x2+1,y2)=1 Then
			r=2
		Else
			If feld(x2,y2+1)=z Or feld(x2,y2+1)=1 Then
				r=3
			Else
				If feld(x2-1,y2)=z Or feld(x2-1,y2)=1 Then r=4
			End If
		End If
	End If
	;If r=0 And e=0 Then r=-1
	
	Return r
End Function