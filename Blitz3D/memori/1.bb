Graphics3D 800,600,0,2
SetBuffer BackBuffer()
;HidePointer()
AppTitle "MEMORI"

Local Camera=CreateCamera()
CameraClsColor Camera,0,0,0

Include "Includes\Draw3D.bb"
DrawInit3D(Camera)

Origin3D(1280,1024)

SeedRnd MilliSecs()



Local font_standard=LoadFont3D("Fonts\standard.png",2,2,0)

Local black_handle=LoadImage3D("Natives\metall.png",2,2,1)
Local karte_bild=LoadImage3D("bilder\karte.png",2,2,0)
Local button_glow=LoadImage3D("bilder\Glow.png",2,2,0)
Local button_trash=LoadImage3D("bilder\trash.png",2,2,0)



Const anzahl_bilder=24
Dim bilder_3d(anzahl_bilder-1,1)

For i=0 To anzahl_bilder-1
	bilder_3d(i,0)=LoadImage3D("bilder\"+Str(i)+".png")
	If bilder_3d(i,0)=0 Then Stop
Next

Local feld_breite=8
Local feld_hoehe=6

If feld_breite*feld_hoehe>anzahl_bilder*2 Then End

Dim feld(feld_breite-1,feld_hoehe-1,3)

Local karte_open=0
Local offen_2_karten=0
Dim open_karte(1,1)

.menu_goto

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;menu
	CameraClsColor Camera,0,50,0
	antw=0
	Repeat
		
		
		SetFont3D(4,1,0,0)
		ColorT3D 255,150,0,150
		Text3D font_standard,0,400,"memori",1,0
		
		SetFont3D(2,1,0,0)
		ColorT3D 150,150,150,150
		Text3D font_standard,0,250,"klein",1,button_glow
		If MouseHit3D Then antw=1
		
		Text3D font_standard,0,50,"mittel",1,button_glow
		If MouseHit3D Then antw=2
		
		Text3D font_standard,0,-150,"gross",1,button_glow
		If MouseHit3D Then antw=3
		
		If game_in_gange=1 Then
			Text3D font_standard,0,-300,"weiterspielen",1,button_glow
			If MouseHit3D Then antw=4
		End If
		
		ColorT3D 50,50,50,150
		Text3D font_standard,0,-450,"beenden",1,button_glow
		If MouseHit3D Then End
		;ColorT3D 50,100,50,150
		;DrawMouse3D (font_standard,-25,2)
		RenderWorld
		Clear3D()
		Flip
	Until antw<>0
	CameraClsColor Camera,0,0,50
	Select antw
		Case 1
			game_in_gange=1
			feld_breite=4
			feld_hoehe=3
		Case 2
			game_in_gange=1
			feld_breite=6
			feld_hoehe=4
		Case 3
			game_in_gange=1
			feld_breite=8
			feld_hoehe=6
		Case 4
			Goto weiter_spiel
	End Select


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;




For i=0 To anzahl_bilder-1
	bilder_3d(i,1)=0
Next


For x=0 To feld_breite-1
	For y=0 To feld_hoehe-1
		feld(x,y,0)=-1
		feld(x,y,1)=0
		feld(x,y,2)=0
		feld(x,y,3)=0
	Next
Next

Repeat
	i=Rand(0,anzahl_bilder-1)
	If bilder_3d(i,1)=0 Then
		bilder_3d(i,1)=1
		Repeat
			x=Rand(0,feld_breite-1)
			y=Rand(0,feld_hoehe-1)
		Until feld(x,y,0)=-1
		feld(x,y,0)=i
		Repeat
			x=Rand(0,feld_breite-1)
			y=Rand(0,feld_hoehe-1)
		Until feld(x,y,0)=-1
		feld(x,y,0)=i
	End If
	ok=1
	For x=0 To feld_breite-1
		For y=0 To feld_hoehe-1
			If feld(x,y,0)=-1 Then ok=0
		Next
	Next
Until ok=1


karte_open=0
offen_2_karten=0

.weiter_spiel

Repeat
	
	
	
	For x=0 To feld_breite-1
		For y=0 To feld_hoehe-1
			xx=x*1000/feld_breite-500+500/feld_breite
			yy=y*1000/feld_hoehe-500+500/feld_hoehe
			Select True
				Case feld(x,y,1)=-1
				Case feld(x,y,1)=0
					DrawImage3D (karte_bild,xx,yy,button_glow,0,2)
					If MouseHit3D And karte_open<2 Then
						feld(x,y,1)=1
						feld(x,y,2)=1
						open_karte(karte_open,0)=x
						open_karte(karte_open,1)=y
						karte_open=karte_open+1
					End If
				Case feld(x,y,1)=100
					If feld(x,y,2)=1 Then
						feld(x,y,2)=0
						offen_2_karten=offen_2_karten+1
					End If
					DrawImage3D (karte_bild,xx,yy,0,0,2)
					DrawImage3D (bilder_3d(feld(x,y,0),0),xx,yy,0,0,2)
				Default
					
					feld(x,y,1)=feld(x,y,1)+feld(x,y,2)
					
					If feld(x,y,1)>50 Then
						DrawImage3D (karte_bild,xx,yy,0,0,(feld(x,y,1)-50.0)/25.0)
						DrawImage3D (bilder_3d(feld(x,y,0),0),xx,yy,0,0,(feld(x,y,1)-50.0)/25.0)
					Else
						DrawImage3D (karte_bild,xx,yy,0,0,(feld(x,y,1)-50.0)/25.0)
					End If
			End Select
			
		Next
	Next
	
	If offen_2_karten=2 And karte_open=2 Then
		offen_2_karten=0
		karte_open=0
		;Stop
		If feld(open_karte(0,0),open_karte(0,1),0)=feld(open_karte(1,0),open_karte(1,1),0) Then
			feld(open_karte(0,0),open_karte(0,1),1)=-1
			feld(open_karte(1,0),open_karte(1,1),1)=-1
		Else
			feld(open_karte(0,0),open_karte(0,1),2)=-1
			feld(open_karte(1,0),open_karte(1,1),2)=-1
			
			feld(open_karte(0,0),open_karte(0,1),1)=99
			feld(open_karte(1,0),open_karte(1,1),1)=99
		End If
	End If
	
	SetFont3D(8,1,0,0)
	ColorT3D 100,50,0,20
	Text3D font_standard,0,300,"memori",1,0
	
	;ColorT3D 100,100,255,255
	;DrawMouse3D (font_standard,-25,2)
	
	
	RenderWorld
	Clear3D()
	
	Flip
	ok=1
	For x=0 To feld_breite-1
		For y=0 To feld_hoehe-1
			If feld(x,y,1)<>-1 Then ok=0
		Next
	Next
Until ok=1 Or KeyHit(1)
a#=0
CameraClsColor Camera,100,0,0
If ok=1 Then
	game_in_gange=0
	t=MilliSecs()
	Repeat
		a=a+0.5
		
		SetFont3D (Sin(a-240)+1)
		ColorT3D (Sin(a-240)+1)*100,(Sin(a-240)+1)*100,(Sin(a-240)+1)*100,(Sin(a-240)+1)/2
		Text3D(font_standard,0,-500,"bravo! du hast es geschafft!",1,0,0)
		
		SetFont3D (Sin(a-210)+1)
		ColorT3D (Sin(a-210)+1)*100,(Sin(a-210)+1)*100,(Sin(a-210)+1)*100,(Sin(a-210)+1)/2
		Text3D(font_standard,0,-400,"bravo! du hast es geschafft!",1,0,0)
		
		SetFont3D (Sin(a-180)+1)
		ColorT3D (Sin(a-180)+1)*100,(Sin(a-180)+1)*100,(Sin(a-180)+1)*100,(Sin(a-180)+1)/2
		Text3D(font_standard,0,-300,"bravo! du hast es geschafft!",1,0,0)
		
		SetFont3D (Sin(a-150)+1)
		ColorT3D (Sin(a-150)+1)*100,(Sin(a-150)+1)*100,(Sin(a-150)+1)*100,(Sin(a-150)+1)/2
		Text3D(font_standard,0,-200,"bravo! du hast es geschafft!",1,0,0)
		
		SetFont3D (Sin(a-120)+1)
		ColorT3D (Sin(a-120)+1)*100,(Sin(a-120)+1)*100,(Sin(a-120)+1)*100,(Sin(a-120)+1)/2
		Text3D(font_standard,0,-100,"bravo! du hast es geschafft!",1,0,0)
		
		SetFont3D (Sin(a-90)+1)
		ColorT3D (Sin(a-90)+1)*100,(Sin(a-90)+1)*100,(Sin(a-90)+1)*100,(Sin(a-90)+1)/2
		Text3D(font_standard,0,0,"bravo! du hast es geschafft!",1,0,0)
		
		SetFont3D (Sin(a-60)+1)
		ColorT3D (Sin(a-60)+1)*100,(Sin(a-60)+1)*100,(Sin(a-60)+1)*100,(Sin(a-60)+1)/2
		Text3D(font_standard,0,100,"bravo! du hast es geschafft!",1,0,0)
		
		SetFont3D (Sin(a-30)+1)
		ColorT3D (Sin(a-30)+1)*100,(Sin(a-30)+1)*100,(Sin(a-30)+1)*100,(Sin(a-30)+1)/2
		Text3D(font_standard,0,200,"bravo! du hast es geschafft!",1,0,0)
		
		SetFont3D (Sin(a)+1)
		ColorT3D (Sin(a)+1)*100,(Sin(a)+1)*100,(Sin(a)+1)*100,(Sin(a)+1)/2
		Text3D(font_standard,0,300,"bravo! du hast es geschafft!",1,0,0)
		
		SetFont3D (Sin(a+30)+1)
		ColorT3D (Sin(a+30)+1)*100,(Sin(a+30)+1)*100,(Sin(a+30)+1)*100,(Sin(a+30)+1)/2
		Text3D(font_standard,0,400,"bravo! du hast es geschafft!",1,0,0)
		
		SetFont3D (Sin(a+60)+1)
		ColorT3D (Sin(a+60)+1)*100,(Sin(a+60)+1)*100,(Sin(a+60)+1)*100,(Sin(a+60)+1)/2
		Text3D(font_standard,0,500,"bravo! du hast es geschafft!",1,0,0)
		
		
		RenderWorld
		Clear3D()
		
		Flip
	Until t+1000*30<MilliSecs() Or KeyHit(1)
	
End If
Goto menu_goto