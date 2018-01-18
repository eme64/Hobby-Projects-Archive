;gfx-load
If Not GfxModeExists(800,600,16)=1 Then
	Print "zu schwache grafik... programm bitte beenden"
	Repeat
	Forever
	End
End If

Global grafik_modus=2

Graphics 800, 600,0,grafik_modus

SetBuffer BackBuffer ()

SeedRnd MilliSecs()

Global step_geschw=4
Global step_geschw_normal=4
Global anzahl_rects=8

anzahl_rects=3


Global start_level=1
Global anzahl_levels=4
Global actual_level
Global time_since_last_level

Dim feld(9,12,6)

Global anzahl_hg_objecte=100
Dim hg_obj(anzahl_hg_objecte-1,4)

Global zuege_pro_sec=3
Global zuege_pro_sec_2=zuege_pro_sec
Global time_er_bildaufbau=MilliSecs()

Global arial_50
Global arial_30


Global sprint=0

Global punkte_act

Global spiel_exist=0

Global next_1
Global next_2

Const highscore_file$="tetris_hs.dat"

Global read_highscore_file_id
Global read_highscore_act_name$
Global read_highscore_act_punkte
Dim highscore_feld$(9,1)

r=255
g=255
b=255
Global rgb_weiss= r*$10000 + g*$100 + b
r=0
g=0
b=0
Global rgb_schwarz= r*$10000 + g*$100 + b
r=0
g=0
b=255
Global rgb_blau= r*$10000 + g*$100 + b
r=255
g=0
b=0
Global rgb_rot= r*$10000 + g*$100 + b
r=0
g=255
b=0
Global rgb_gruen= r*$10000 + g*$100 + b
r=255
g=255
b=0
Global rgb_gelb= r*$10000 + g*$100 + b


load_graphic()

read_in_hiscore()
ordne_highscore()




create_hg()
main_menu()

End

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function ep_input$(txt$,max=-1)
	taste=GetKey()
	Select True
		Case taste=8 And Len(txt$)>0
			txt$=Mid(txt$,1,Len(txt$)-1)
		Case taste>31 And (max>=Len(txt$) Or max=-1)
			txt$=txt$+Chr(taste)
	End Select
	Return txt$
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function load_graphic()
	arial_50=LoadFont("arial",50)
	arial_30=LoadFont("arial",30)
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function free_graphic()
	FreeFont arial_50
	FreeFont arial_30
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function draw_mouse(x,y)
	If grafik_modus<>1 Then Return False
	For i=0 To 10
		For ii=0 To i
			WritePixel x+ii,y+i,rgb_weiss
		Next
		
		WritePixel x,y+i,rgb_schwarz
		WritePixel x+i,y+i,rgb_schwarz
		
		WritePixel x+i,y+11,rgb_schwarz
	Next
	For i=11 To 20
		WritePixel x+i/2-2,y+i,rgb_schwarz
		WritePixel x+i/2-1,y+i,rgb_weiss
		WritePixel x+i/2,y+i,rgb_weiss
		WritePixel x+i/2+1,y+i,rgb_weiss
		WritePixel x+i/2+2,y+i,rgb_schwarz
	Next
End Function
;rgb_weiss
;rgb_schwarz
;rgb_blau
;rgb_rot
;rgb_gruen
;rgb_gelb
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function write_highscore(name$,punkt)
	
	If name$="" Or punkt<=0 Then Return False
	
	read_in_hiscore()
	
	ordne_highscore()
	
	
	highscore_feld$(9,0)=name$
	highscore_feld$(9,1)=punkt
	
	ordne_highscore()
	
	write_out_hiscore()
	
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function ordne_highscore()
	Repeat
		ok=1
		For i=0 To 8
			If Int(highscore_feld$(i,1))>=Int(highscore_feld$(i+1,1)) Then
				If Int(highscore_feld$(i,1))=Int(highscore_feld$(i+1,1)) And highscore_feld$(i,0)=highscore_feld$(i+1,0) And Int(highscore_feld$(i,1))<>0 Then
					highscore_feld$(i,0)=""
					highscore_feld$(i,1)=0
					ok=0
				End If
				
			Else
				ok=0
				
				zt$=highscore_feld$(i,0)
				highscore_feld$(i,0)=highscore_feld$(i+1,0)
				highscore_feld$(i+1,0)=zt$
				
				z=highscore_feld$(i,1)
				highscore_feld$(i,1)=highscore_feld$(i+1,1)
				highscore_feld$(i+1,1)=z
			End If
		Next
	Until ok=1
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function read_in_hiscore()
	
	For i=0 To 9
		highscore_feld$(i,0)=""
		highscore_feld$(i,1)=0
	Next
	f=ReadFile(highscore_file$)
	If f Then
		For i=0 To 9
			If Eof(f) Then Exit
			highscore_feld$(i,0)=ReadLine(f)
			highscore_feld$(i,1)=ReadLine(f)
		Next
		CloseFile(f)
		
	End If
	
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function write_out_hiscore()
	f=WriteFile(highscore_file$)
	For i=0 To 9
		If highscore_feld$(i,0)<>"" And highscore_feld$(i,1)<>0 Then
			WriteLine f,highscore_feld$(i,0)
			WriteLine f,highscore_feld$(i,1)
		End If
	Next
	CloseFile(f)
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function ok_for_higrscore(p)
	read_in_hiscore()
	ordne_highscore()
	x=highscore_feld$(9,1)
	If x < p Then
		Return 1
	Else
		Return 0
	End If
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function create_hg()
	For i=0 To anzahl_hg_objecte-1
		hg_obj(i,3)=0
		
		hg_obj(i,4)=Rand(1,4)
		
		hg_obj(i,0)=Rand(0,750)
		hg_obj(i,1)=Rand(0,550)
		
		hg_obj(i,2)=Rand(1,7)
	Next
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function render_hg()
	For i=0 To anzahl_hg_objecte-1
		If hg_obj(i,1)>600 Then
			hg_obj(i,1)=-50
			hg_obj(i,3)=1
			hg_obj(i,0)=Rand(0,750)
			hg_obj(i,2)=Rand(1,7)
			hg_obj(i,4)=Rand(1,4)
		End If
		If hg_obj(i,3)=1 Then
			draw_game_block(hg_obj(i,0),hg_obj(i,1),hg_obj(i,2),1)
		End If
		hg_obj(i,1)=hg_obj(i,1)+hg_obj(i,4)
	Next
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

Function draw_game_block(x,y,i,h=0)
	Select i
		Case 0
			r=255
			g=0
			b=0
		Case 1
			r=0
			g=255
			b=0
		Case 2
			r=255
			g=100
			b=0
		Case 3
			r=0
			g=0
			b=255
		Case 4
			r=255
			g=0
			b=255
		Case 5
			r=255
			g=255
			b=0
		Case 6
			r=150
			g=150
			b=150
		Case 7
			r=80
			g=80
			b=80
	End Select
	If h=0 Then
		Color r,g,b
		Rect x,y,50,50
		Color r+(255-r)/2,g+(255-g)/2,b+(255-b)/2
		breite=3
		Rect x+breite,y+breite,50-2*breite,50-2*breite
	Else
		Color r/3,g/3,b/3
		Rect x,y,50,50
		Color r/2,g/2,b/2
		breite=3
		Rect x+breite,y+breite,50-2*breite,50-2*breite
	End If
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function set_level(i)
	If i=-1 Then actual_level=actual_level+1 Else actual_level=i
	
	Select actual_level
		Case 1
			anzahl_rects=3
		Case 2
			anzahl_rects=5
		Case 3
			anzahl_rects=6
		Case 4
			anzahl_rects=8
		Default
			anzahl_rects=8
			actual_level=4
	End Select
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function game_start()
	set_level(start_level)
	
	next_1=Rand(1,anzahl_rects)
	next_2=Rand(1,anzahl_rects)
	
	For x=0 To 9
		For y=0 To 12
			For i=0 To 6
				feld(x,y,i)=0
			Next
		Next
	Next
	punkte_act=0
	
	time_since_last_level=MilliSecs()
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function game_weiter()
	ClsColor 50,50,50
	game_over=0
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
				
				step_geschw=step_geschw_normal
				
				cc=2
				zuege_pro_sec=zuege_pro_sec_2
				sprint=0
			End If
		End If
		
		;checken ob spezielles ereignis
		For x=0 To 9
			If feld(x,2,0)<>0 And feld(x,2,1)=0 Then game_over=1
		Next
		
		
		
		
		;
		
		If KeyHit(208) Then
			zuege_pro_sec=zuege_pro_sec_2*3
			sprint=1
			step_geschw=10
		End If
		
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
					zeichne_szene(i,step_geschw)
				Next
			Case 2
				For i=0 To 50 Step 2
					zeichne_szene(i,step_geschw)
				Next
			Case 3
				For i=0 To 50 Step 3
					zeichne_szene(i,step_geschw)
				Next
			Case 4
				For i=0 To 50 Step 4
					zeichne_szene(i,step_geschw)
				Next
			Case 5
				For i=0 To 50 Step 5
					zeichne_szene(i,step_geschw)
				Next
			Case 6
				For i=0 To 50 Step 6
					zeichne_szene(i,step_geschw)
				Next
			Case 7
				For i=0 To 50 Step 7
					zeichne_szene(i,step_geschw)
				Next
			Case 8
				For i=0 To 50 Step 8
					zeichne_szene(i,step_geschw)
				Next
			Case 9
				For i=0 To 50 Step 9
					zeichne_szene(i,step_geschw)
				Next
			Case 10
				For i=0 To 50 Step 10
					zeichne_szene(i,step_geschw)
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
		
		If time_since_last_level+1000*60<MilliSecs()
			time_since_last_level=MilliSecs()
			set_level(-1)
		End If
		
	Until KeyHit(1) Or game_over=1
	If game_over=1 Then ende_game()
	game_over=0
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function ende_game()
	Cls
	game_over=0
	act_spieler$=""
	
	
	spiel_exist=0
	antw=0
	Repeat
		m_x=MouseX()
		m_y=MouseY()
		md_1=MouseDown(1)
		mh_1=MouseHit(1)
		FlushMouse()
		Cls
		render_hg()
		
		SetFont arial_50
		Color 255,0,0
		Text 400,100,"GAME OVER",1,1
		
		Color 0,255,0
		Text 400,300,"PUNKTE: "+punkte_act,1,1
		
		If ok_for_higrscore(punkte_act) Then
			act_spieler$=ep_input$(act_spieler$,10)
			Text 400,400,act_spieler$+"|",1,1
		End If
		
		
		If draw_buton(250,500,300,m_x,m_y,"OK") And mh_1 Then antw=1
		draw_mouse(m_x,m_y)
		Flip
	Until antw<>0
	If ok_for_higrscore(punkte_act) Then write_highscore(act_spieler$,punkte_act)
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function main_menu()
	Repeat
		out=0
		ClsColor 0,0,0
		Repeat
			m_x=MouseX()
			m_y=MouseY()
			md_1=MouseDown(1)
			mh_1=MouseHit(1)
			Cls
			render_hg()
			SetFont arial_50
			Color 255,255,255
			Text 400,20,"TETRIS",1,1
			Color 150,150,150
			Text 400,70,"HAUPTMENU",1,1
			antw=0
			i=0
			abstand=35+50
			i=i+1
			antw=antw+draw_buton(250,abstand*i+25,300,m_x,m_y,"neues Spiel starten")*1
			
			If spiel_exist=1 Then
				i=i+1
				antw=antw+draw_buton(250,abstand*i+25,300,m_x,m_y,"Weiterspielen")*2
			End If
			i=i+1
			antw=antw+draw_buton(250,abstand*i+25,300,m_x,m_y,"Einstellungen")*3
			i=i+1
			antw=antw+draw_buton(250,abstand*i+25,300,m_x,m_y,"Rangliste")*6
			i=i+1
			antw=antw+draw_buton(250,abstand*i+25,300,m_x,m_y,"Spielanleitung")*4
			i=i+1
			antw=antw+draw_buton(250,abstand*i+25,300,m_x,m_y,"Beenden")*5
			draw_mouse(m_x,m_y)
			Flip
		Until antw>0 And mh_1
		
		Select antw
			Case 1
				spiel_exist=1
				game_start()
				game_weiter()
			Case 2
				game_weiter()
			Case 3
				options_menu()
			Case 4
				hilfe_menu()
			Case 5
				End
			Case 6
				hiscore_menu()
			Default
				
		End Select
	Forever
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function hilfe_menu()
	antw=0
	Repeat
		m_x=MouseX()
		m_y=MouseY()
		md_1=MouseDown(1)
		mh_1=MouseHit(1)
		FlushMouse()
		Cls
		render_hg()
		
		SetFont arial_50
		Color 255,255,255
		Text 400,20,"TETRIS",1,1
		Color 150,150,150
		Text 400,70,"SPIELANLEITUNG",1,1
		
		SetFont arial_30
		Color 255,255,255
		Text 400,200,"Mit den Pfeiltasten nach rechts und links",1,1
		Text 400,240,"steuert man die fallenden Bl�cke.",1,1
		Text 400,310,"Das Ziel ist es m�glichst viele Bl�cke aufzul�sen,",1,1
		Text 400,350,"wobei mindestens 4 der gleichen Farbe beieinander sein m�ssen.",1,1
		
		Text 400,420,"Tipp: Versuche dass m�glichst viele Bl�cke gleichzeitig zerplatzen,",1,1
		Text 400,460,"denn das gibt mehr Punkte!",1,1
		
		
		
		
		If draw_buton(250,530,300,m_x,m_y,"Hauptmenu") And mh_1 Then antw=1
		draw_mouse(m_x,m_y)
		Flip
	Until antw<>0

End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function hiscore_menu()
	antw=0
	Repeat
		m_x=MouseX()
		m_y=MouseY()
		md_1=MouseDown(1)
		mh_1=MouseHit(1)
		FlushMouse()
		Cls
		render_hg()
		
		SetFont arial_50
		Color 255,255,255
		Text 400,20,"TETRIS",1,1
		Color 150,150,150
		Text 400,70,"RANGLISTE",1,1
		
		SetFont arial_30
		
		For i=0 To 9
			If highscore_feld$(i,1)>0 And highscore_feld$(i,0)<>"" Then
				Color 255,200,200
				Text 250,130+i*40,Str(i+1)+".",1,1
				Color 255,255,255
				Text 350,130+i*40,highscore_feld$(i,0),1,1
				Color 200,200,255
				Text 550,130+i*40,highscore_feld$(i,1),1,1
			End If
		Next
		
		
		
		If draw_buton(250,530,300,m_x,m_y,"Hauptmenu") And mh_1 Then antw=1
		draw_mouse(m_x,m_y)
		Flip
	Until antw<>0

End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function options_menu()
	antw=0
	Repeat
		m_x=MouseX()
		m_y=MouseY()
		md_1=MouseDown(1)
		mh_1=MouseHit(1)
		FlushMouse()
		
		Cls
		
		render_hg()
		
		SetFont arial_50
		Color 255,255,255
		Text 400,20,"TETRIS",1,1
		Color 150,150,150
		Text 400,70,"EINSTELLUNGEN",1,1
		
		Color 255,255,255
		SetFont arial_30
		Text 400,115+25,"Level",1,1
		
		SetFont arial_50
		Text 400,165+25,start_level,1,1
		
		If draw_buton(300,165,50,m_x,m_y,"-",start_level<=1) And mh_1 Then
			start_level=start_level-1
		End If
		If draw_buton(450,165,50,m_x,m_y,"+",start_level>=anzahl_levels) And mh_1 Then
			start_level=start_level+1
		End If
		
		If draw_buton(430,270,300,m_x,m_y,"Fenstermodus") And mh_1 And grafik_modus<>2 Then
			free_graphic()
			grafik_modus=2
			Graphics 800, 600,0,grafik_modus
			SetBuffer BackBuffer ()
			Cls
			load_graphic()
		ElseIf draw_buton(70,270,300,m_x,m_y,"Vollbildschirm") And mh_1 And grafik_modus<>1 Then 
			free_graphic()
			grafik_modus=1
			Graphics 800, 600,0,grafik_modus
			SetBuffer BackBuffer ()
			Cls
			load_graphic()
		Else
			If draw_buton(250,500,300,m_x,m_y,"Hauptmenu") And mh_1 Then antw=1
			draw_mouse(m_x,m_y)
			Flip
		End If
		
	Until antw<>0
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function draw_buton(x_pos,y_pos,laenge,m_x,m_y,txt$,pressed=0)
	
	If laenge<10 Then laenge=10
	If pressed=1 Then
		rt=0
	Else
		If mouse_over(m_x,m_y,x_pos,y_pos,laenge,50) Then
			pressed=1
			rt=1
		Else
			pressed=0
			rt=0
		End If
	End If
	If pressed=0 Then
		r=0
		g=200
	Else
		r=255
		g=150
	End If
	
	Color r,g,0
	Rect x_pos,y_pos,laenge,50
	breite=3
	Color r+(255-r)/2,g+(255-g)/2,50
	Rect x_pos+breite,y_pos+breite,laenge-2*breite,50-2*breite
	
	
	SetFont arial_30
	Color 100,100,100
	Text x_pos+laenge/2,y_pos+25,txt$,1,1
	Return rt
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
Function zeichne_szene(i,sg)
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
					;xxx=feld(x,y+3,0)+1
					;DrawBlock rects_bilder,50+50*x+iii,50+50*y+ii,feld(x,y+3,0)-1
					draw_game_block(50+50*x+iii,50+50*y+ii,feld(x,y+3,0)-1)
				Case feld(x,y+3,0)=0
			End Select
		Next
	Next
	
	;RAMEN:
	Color 100,100,100
	Rect 0,0,600,50
	Rect 0,550,600,50
	Rect 0,50,50,500
	Rect 550,50,50,500
	Color 200,200,200
	Rect 50,50,500,500,0
	Color 150,150,150
	Rect 600,0,200,600
	
	
	draw_game_block(650,100,next_1-1)
	draw_game_block(700,100,next_2-1)
	
	
	
	Color 255,255,255
	Text 650,200,punkte_act
	
	Text 650,300,"Level: "+actual_level
	
	If zuege_pro_sec=zuege_pro_sec_2 Then
		
		While time_er_bildaufbau>MilliSecs()-1000/zuege_pro_sec/50*sg And sprint=0
		Wend
		time_er_bildaufbau=MilliSecs()
	End If
	
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