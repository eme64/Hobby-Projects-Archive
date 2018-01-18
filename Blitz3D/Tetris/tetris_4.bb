;gfx-load
If Not GfxModeExists(800,600,16)=1 Then
	Print "zu schwache grafik... programm bitte beenden"
	Repeat
	Forever
	End
End If

Graphics 800, 600,0,2
SetBuffer BackBuffer ()

SeedRnd MilliSecs()

Global ramen_bild
ramen_bild=LoadImage("bilder\ramen.bmp")
Global rects_bilder
Global step_geschw=4
Global anzahl_rects=3
rects_bilder=LoadAnimImage("bilder\rect.bmp",50,50,0,anzahl_rects)

Global butons_bilder
butons_bilder=LoadAnimImage("bilder\butons.bmp",50,50,0,6)


Dim feld(9,12,6)

Global arial_50
arial_50=LoadFont("arial",50)
SetFont arial_50

Global arial_30
arial_30=LoadFont("arial",30)
SetFont arial_30



Global punkte_act

main_menu()

Global next_1=Rand(1,anzahl_rects)
Global next_2=Rand(1,anzahl_rects)

ClsColor 50,50,50
;main


Repeat
	
	
	If steuerung=0 Or steuerung_1=0 Then
		If steuerung_1=0 Then
			steuerung_1=1
		Else
			steuerung_1=0
			For x=0 To 9
				For y=0 To 12
					feld(x,y,1)=0
				Next
			Next
			
			feld(4,0,0)=next_1
			feld(4,0,1)=1
			
			feld(5,0,0)=next_2
			feld(5,0,1)=1
			
			next_1=Rand(1,anzahl_rects)
			next_2=Rand(1,anzahl_rects)
			
			cc=2
			steuerung=1
			step_sprint=2
		End If
	End If
	
	;checken ob spezielles ereignis
	For x=0 To 9
		If feld(x,2,0)<>0 And feld(x,2,1)=0 Then game_over=1
	Next
	
	
	
	
	;
	
	If KeyHit(208) Then step_sprint=8
	
	If KeyHit(205) Or KeyDown(205) Then ;cursor=cursor+1
		c=0
		For x=0 To 8
			For y=0 To 11
				If feld(x,y,1)=1 Then
					If feld(x+1,y,1)=1 Or feld(x+1,y+1,0)=0 Then;feld(x+1,y,0)=0
						c=c+1
					End If
				End If
			Next
		Next
		If cc=c Then
			For x=9 To 0 Step -1
				For y=12 To 0 Step -1
					If feld(x,y,1)=1 And x<9 Then
						feld(x+1,y,0)=feld(x,y,0)
						feld(x,y,0)=0
						feld(x+1,y,1)=feld(x,y,1)
						feld(x,y,1)=0
						feld(x+1,y,2)=1
						feld(x+1,y,3)=1
						feld(x,y,2)=0
					End If
				Next
			Next
		End If
	End If
	
	If KeyHit(203) Or KeyDown(203) Then ;cursor=cursor-1
		c=0
		For x=1 To 9
			For y=0 To 11
				If feld(x,y,1)=1 Then
					If feld(x-1,y,1)=1 Or feld(x-1,y+1,0)=0 Then;feld(x-1,y,0)=0
						c=c+1
					End If
				End If
			Next
		Next
		If cc=c Then
			For x=0 To 9
				For y=12 To 0 Step -1
					If feld(x,y,1)=1 And x>0 Then
						feld(x-1,y,0)=feld(x,y,0)
						feld(x,y,0)=0
						feld(x-1,y,1)=feld(x,y,1)
						feld(x,y,1)=0
						feld(x-1,y,2)=1
						feld(x-1,y,3)=-1
						feld(x,y,2)=0
					End If
				Next
			Next
		End If
	End If
	
	ok=1
	
	If ok=1 Then;noch ersetzen
		c=0
		For y=11 To 0 Step -1
			For x=9 To 0 Step -1
				If feld(x,y,1)=1 Then
					Select True
						Case feld(x,y,0)=0
						Case feld(x,y,0)>0 And feld(x,y,0)<anzahl_rects+1
							If feld(x,y+1,0)=0 Then
								c=c+1
							End If
						Case feld(x,y,0)=0
					End Select
				End If
			Next
		Next
		;If c=cc Then
			For y=11 To 0 Step -1
				For x=9 To 0 Step -1
					;If feld(x,y,1)=1 Then
						Select True
							Case feld(x,y,0)=0
							Case feld(x,y,0)>0 And feld(x,y,0)<anzahl_rects+1
								If feld(x,y+1,0)=0 Then
									falle_platz(x,y)
								End If
							Case feld(x,y,0)=0
						End Select
					;End If
				Next
			Next
		;Else
		If c<>cc Then
			;steuerung=0
			For x=0 To 9
				For y=0 To 12
					feld(x,y,1)=0
				Next
			Next
		End If
	End If
	;bildaufbau
	
	ookk=1
	For y=1 To 12
		For x=0 To 9
			If feld(x,y,2)=1 Then
				ookk=0
				steuerung_1=1
				steuerung=1
			End If
		Next
	Next
	
	If ookk=1 Then
		steuerung=0
		For y=0 To 12
			For x=0 To 9
				If feld(x,y,0)<>0 And feld(x,y,2)=0 Then
					For yy=0 To 12
						For xx=0 To 9
							feld(xx,yy,4)=0
						Next
					Next
					ccc=1
					Repeat
						ok=1
						
						feld(x,y,4)=1
						
						For yy=0 To 12
							For xx=0 To 9
								If feld(xx,yy,0)<>0 And feld(xx,yy,2)=0 And feld(x,y,0)=feld(xx,yy,0) And feld(xx,yy,4)=0 Then
									antw=0
									If xx<9 Then
										If feld(xx,yy,0)=feld(xx+1,yy,0) And feld(xx+1,yy,4)=1 And feld(xx+1,yy,2)=0 Then antw=1
									End If
									If xx>0 Then
										If feld(xx,yy,0)=feld(xx-1,yy,0) And feld(xx-1,yy,4)=1 And feld(xx-1,yy,2)=0 Then antw=1
									End If
									If yy<12 Then
										If feld(xx,yy,0)=feld(xx,yy+1,0) And feld(xx,yy+1,4)=1 And feld(xx,yy+1,2)=0 Then antw=1
									End If
									If yy>0 Then
										If feld(xx,yy,0)=feld(xx,yy-1,0) And feld(xx,yy-1,4)=1 And feld(xx,yy-1,2)=0 Then antw=1
									End If
									If antw=1 Then
										
										feld(xx,yy,4)=1
										
										ok=0
										ccc=ccc+1
									End If
								End If
							Next
						Next
					Until ok=1
					If ccc>3 Then
						For yyy=0 To 12
							For xxx=0 To 9
								If feld(xxx,yyy,4)=1 Then
									feld(xxx,yyy,0)=0
									feld(xxx,yyy,1)=0
									feld(xxx,yyy,2)=2
									feld(xxx,yyy,3)=0
								End If
							Next
						Next
					End If
				End If
			Next
		Next
	End If
	
	
	ppp=0
	For y=0 To 12
		For x=0 To 9
			If feld(x,y,2)=2 Then
				ppp=ppp+1
			End If
		Next
	Next
	punkte_act=punkte_act+ppp*ppp
	
	Select step_geschw
		Case 1
			For i=0 To 50 Step 1
				zeichne_szene(i)
			Next
		Case 2
			For i=0 To 50 Step 2
				zeichne_szene(i)
			Next
		Case 3
			For i=0 To 50 Step 3
				zeichne_szene(i)
			Next
		Case 4
			For i=0 To 50 Step 4
				zeichne_szene(i)
			Next
		Case 5
			For i=0 To 50 Step 5
				zeichne_szene(i)
			Next
		Case 6
			For i=0 To 50 Step 6
				zeichne_szene(i)
			Next
		Case 7
			For i=0 To 50 Step 7
				zeichne_szene(i)
			Next
		Case 8
			For i=0 To 50 Step 8
				zeichne_szene(i)
			Next
		Case 9
			For i=0 To 50 Step 9
				zeichne_szene(i)
			Next
		Case 10
			For i=0 To 50 Step 10
				zeichne_szene(i)
			Next
	End Select
	
	
	For x=0 To 9
		For y=0 To 12
			feld(x,y,2)=0
			feld(x,y,3)=0
			If feld(x,y,0)=0 Then
				feld(x,y,1)=0
			End If
		Next
	Next
	
	;ttt=MilliSecs()
	;Repeat
	;Until ttt+100<MilliSecs()
	
	;Flip
	;bildaufbau ende
	
Until KeyHit(1) Or game_over=1
End

;functions
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function main_menu()
	out=0
	Repeat
		m_x=MouseX()
		m_y=MouseY()
		md_1=MouseDown(1)
		mh_1=MouseHit(1)
		Cls
		
		antw=antw+draw_buton(200,200,200,m_x,m_y,"Spiel starten")*1
		
		antw=antw+draw_buton(200,300,200,m_x,m_y,"Optionen")*2
		
		antw=antw+draw_buton(200,400,200,m_x,m_y,"Spielanleitung")*3
		
		Flip
	Until antw And md_1
	
	Select antw
		Case 1
		Case 2
			options_menu()
		Case 3
			main_menu()
		Default
			main_menu()
	End Select
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function options_menu()
	step_geschw=8;1-10
	anzahl_rects=8;1-8
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function draw_buton(x_pos,y_pos,laenge,m_x,m_y,txt$)
	
	pressed=3*mouse_over(m_x,m_y,x_pos,y_pos,laenge,50)
	
	If laenge<100 Then laenge=100
	DrawBlock butons_bilder,x_pos,y_pos,0+pressed
	
	For i=1 To laenge/50-1
		DrawBlock butons_bilder,x_pos+i*50,y_pos,1+pressed
	Next
	
	DrawBlock butons_bilder,x_pos+laenge-50,y_pos,2+pressed
	
	SetFont arial_30
	Color 100,100,100
	Text x_pos+laenge/2,y_pos+25,txt$,1,1
	
	Return pressed/3
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function mouse_over(m_x,m_y,x1,y1,x2,y2)
	If m_x>x1 And m_y>y1 And m_x<x1+x2 And m_y<y1+y2 Then
		Return True
	Else
		Return False
	End If
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function zeichne_szene(i)
	Cls
	
	For y=0 To 9
		For x=0 To 9
			Select feld(x,y+3,3)
				Case -1
					iii=50-i
				Case 0
					iii=0
				Case 1
					iii=i-50
			End Select
			Select feld(x,y+3,2)
				Case 0
					ii=0
				Case 1
					ii=i-50
				Case 2
					ii=0
					Color 255,100,100
					Rect 50+50*x+i/2,50+50*y+i/2,50-i,50-i,1
					;Delay 10
			End Select
			Select True
				Case feld(x,y+3,0)=0
				Case feld(x,y+3,0)>0 And feld(x,y+3,0)<anzahl_rects+1
					xxx=feld(x,y+3,0)+1
					DrawBlock rects_bilder,50+50*x+iii,50+50*y+ii,feld(x,y+3,0)-1
				Case feld(x,y+3,0)=0
			End Select
		Next
	Next
	
	DrawImage ramen_bild,0,0
	
	DrawBlock rects_bilder,650,100,next_1-1
	DrawBlock rects_bilder,700,100,next_2-1
	
	Color 255,255,255
	Text 650,200,punkte_act
	
	
	
	Flip
End Function

Function falle_platz(x,y)
	feld(x,y+1,0)=feld(x,y,0)
	feld(x,y,0)=0
	feld(x,y+1,1)=feld(x,y,1)
	feld(x,y,1)=0
	feld(x,y+1,3)=feld(x,y,3)
	feld(x,y,3)=0
	feld(x,y+1,2)=1
	feld(x,y,2)=0
End Function
;datas