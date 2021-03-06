Const graphics_x=500
Const graphics_y=700
Graphics graphics_x+100,graphics_y,0,2
SetBuffer BackBuffer()
SeedRnd MilliSecs()
AppTitle "JUMPI"

Global boden_normal=LoadImage("bilder\boden.bmp")

Global bruechig_bilder=LoadAnimImage("bilder\br�chig.bmp",50,20,0,2)

Global mann_bild=LoadImage("bilder\mann.bmp")

Global spick_bild=LoadImage("bilder\spick.bmp")

Global kiste_bild=LoadImage("bilder\kiste.bmp")

Global schieb_bild=LoadImage("bilder\schieb.bmp")

Global power_bild=LoadImage("bilder\power.bmp")

Global pilz_bild=LoadImage("bilder\pilz.bmp")

Global hust_sound=LoadSound("sound\hust.wav")

Global waa_sound=LoadSound("sound\waa.wav")

Global doing_sound=LoadSound("sound\doing.wav")

Global ss_sound=LoadSound("sound\ss.wav")

Global k_sound=LoadSound("sound\k.wav")

Global hg_music=LoadSound("sound\hg.wav")

Global bing_sound=LoadSound("sound\bing.wav")

Global dogg_sound=LoadSound("sound\dogg.wav")

LoopSound hg_music
;PlaySound hg_music

ClsColor 100,0,0

Type BODEN
	Field x#
	Field y
	Field art
	Field count
	Field z
	Field z2
End Type

Type SPECIAL
	Field x#
	Field y#
	Field art
	Field z
	Field z2
End Type

Global mann_x=250
Global mann_y=200
Global mann_y_max=mann_y
Global speed_mann#=0

Global entity_abstand=50

Global game_over=0

Global speed_zu_gut#=255

Global wischi_waschi=0

Global wischi_waschi_x#=0

Global act_level
Global arial_font=LoadFont("arial",50)
SetFont arial_font

Repeat
	speed_zu_gut#=0
	act_level=1
	
	start_game(0)
	
	tim=MilliSecs()
	
	mann_x=250
	mann_y=200
	mann_y_max=mann_y
	speed_mann#=0
	
	entity_abstand=50
	
	wischi_waschi_x#=0
	wischi_waschi=0
	game_over=0
	Repeat
		Cls
		
		render_game()
		draw_game()
		
		act_level=render_level((mann_y_max-200)/20)
		
		Repeat
		Until tim<MilliSecs()-10
		tim=MilliSecs()
		Color 100,100,100
		Rect graphics_x,0,100,graphics_y
		Color 255,0,0
		Text graphics_x+50,20,(mann_y_max-200)/20,1,1
		For i=1 To speed_zu_gut
			Color 255-i,i,0
			Rect graphics_x+25,200+i,50,1
		Next
		
		Flip
	Until KeyDown(1) Or game_over=1
	If game_over=0 Then End
	ende_game()
Forever
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function render_level(pp)
	Return pp/100+1
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function start_game(level)
	anz=1000/entity_abstand
	art=2
	Select level
		Case 1
		Case 2
		Default
	End Select
	
	For i=1 To anz
		b.BODEN=New BODEN
		b\x=Rand(0,450)
		b\y=i*entity_abstand-100
		b\art=rand_art(act_level)
		b\count=0
		b\z=Rand(0,360)
		b\z2=Rand(0,360)
	Next
	game_over=0
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function render_game()
	
	
	If Rand(0,1000)=0 Then
		s.SPECIAL=New SPECIAL
		s\x=Rand(0,450)
		s\y=mann_y_max+700
		s\art=0
	End If
	
	If Rand(0,500)=0 Then
		s.SPECIAL=New SPECIAL
		s\x=Rand(0,450)
		s\y=mann_y_max+700
		s\art=1
	End If
	
	For s.SPECIAL=Each SPECIAL
		If s\y>mann_y-40 And s\y-20<mann_y And s\x+50>mann_x And s\x-20<mann_x Then
			Select s\art
				Case 0
					Delete s.SPECIAL
					speed_zu_gut=speed_zu_gut+20
					PlaySound bing_sound
				Case 1
					Delete s.SPECIAL
					wischi_waschi=100
					PlaySound hust_sound
			End Select
		End If
	Next
	
	speed_mann=speed_mann-0.1
	
	If KeyDown(200) And speed_zu_gut>0 Then
		speed_zu_gut=speed_zu_gut-0.5
		speed_mann=speed_mann+0.5
		PlaySound ss_sound
	End If
	
	If speed_zu_gut<0 Then speed_zu_gut=0
	
	If speed_zu_gut>255 Then speed_zu_gut=255
	
	If KeyDown(208) Then speed_mann=speed_mann-0.2
	If speed_mann<-10 Then speed_mann=-10
	mann_y=mann_y+speed_mann
	
	wischi_waschi=wischi_waschi-1
	If wischi_waschi<0 Then wischi_waschi=0
	
	wischi_waschi_x#=wischi_waschi_x#*wischi_waschi/150
	
	mann_x=mann_x+wischi_waschi_x#
	
	If KeyDown(205) Then
		mann_x=mann_x+3
		If wischi_waschi>0 Then wischi_waschi_x#=wischi_waschi_x#+3
	End If
	
	If KeyDown(203) Then
		mann_x=mann_x-3
		If wischi_waschi>0 Then wischi_waschi_x#=wischi_waschi_x#-3
	End If
	
	If mann_x<0 Then mann_x=graphics_x-20
	If mann_x>graphics_x-20 Then mann_x=0
	
	For b.BODEN=Each BODEN
		If b\y>mann_y-40 And b\y-20<mann_y-40 And b\x+50>mann_x And b\x-20<mann_x And speed_mann<0 Then
			If Not (b\art=1 And b\count>1)
				Select b\art
					Case 0
						speed_mann=5
					Case 1
						speed_mann=5
						PlaySound k_sound
					Case 2
						speed_mann=Abs(speed_mann)+0.5
						PlaySound doing_sound
					Case 3
						b\z=100
						speed_mann=5
					Case 4
						speed_mann=5
				End Select
				b\count=b\count+1
			End If
		Else If b\y<mann_y-400
			b\x=Rand(0,450)
			b\y=(b\y+graphics_y+200)
			b\art=rand_art(act_level)
			b\count=0
			b\z=0
			b\z2=0
		End If
		
		
		
		If b\art=4 Then
			b\z=b\z+1
			b\z2=b\z2+1
			b\x=b\x+Sin(b\z)
			b\y=b\y+Sin(b\z2)
		ElseIf b\art=3
			
			
			If b\y>mann_y And b\y-20<mann_y And b\x+50>mann_x And b\x-20<mann_x And speed_mann>0 Then
				b\z2=40
				speed_mann=speed_mann*3/4
				PlaySound dogg_sound
			End If
			b\z=b\z-1
			If b\z<0 Then b\z=0
			b\y=b\y-Sin(b\z)
			
			b\z2=b\z2-1
			If b\z2<0 Then b\z2=0
			b\y=b\y+Sin(b\z2)
		End If
		If b\x<0 Then b\x=0
		If b\x>graphics_x-50 Then b\x=graphics_x-50
	Next
	
	If mann_y<0 Then
		speed_mann=5
	End If
	
	If mann_y>mann_y_max Then
		mann_y_max=mann_y
	Else If mann_y<mann_y_max-320
		If game_over=0 Then PlaySound waa_sound
		game_over=2
		speed_zu_gut=0
		mann_y=mann_y-10
		If mann_y<mann_y_max-1000 Then game_over=1
	End If
	
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function draw_game()
	For b.BODEN=Each BODEN
		Select b\art
			Case 0
				DrawImage boden_normal,b\x,graphics_y - b\y+mann_y_max-350
			Case 1
				If b\count<2 Then DrawImage bruechig_bilder,b\x,graphics_y - b\y+mann_y_max-350,b\count
			Case 2
				DrawImage spick_bild,b\x,graphics_y - b\y+mann_y_max-350
			Case 3 
				DrawImage kiste_bild,b\x,graphics_y - b\y+mann_y_max-350
			Case 4
				DrawImage schieb_bild,b\x,graphics_y - b\y+mann_y_max-350
		End Select
		
	Next
	
	For s.SPECIAL=Each SPECIAL
		Select s\art
			Case 0
				DrawImage power_bild,s\x,graphics_y - s\y+mann_y_max-350
			Case 1
				DrawImage pilz_bild,s\x,graphics_y - s\y+mann_y_max-350
		End Select
	Next
	
	If Rand(1,100)>wischi_waschi Then DrawImage mann_bild,mann_x,graphics_y - mann_y+mann_y_max-350
	Color 100,100,100
	If mann_y_max<600 Then Rect 0,graphics_y+mann_y_max-350+40,graphics_x,150
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
Function ende_game()

	For b.BODEN=Each BODEN
		Delete b.BODEN
	Next
	
	For s.SPECIAL=Each SPECIAL
		Delete s.SPECIAL
	Next
	
	Cls
	Text 50,350,"GAME OVER"
	Flip
	
End Function
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;0=normal
;1=br�chig
;2=spick
;3=kiste
;4=kreise
Function rand_art(level=1)
	r= Rand(0,1000)
	Select level
		Case 1
			Select True
				Case r<900
					Return 0
				Default
					Return 1
			End Select
		Case 2
			Select True
				Case r<300
					Return 0
				Default
					Return 1
			End Select
		Case 3
			Select True
				Case r<400
					Return 0
				Case r<800
					Return 1
				Default
					Return 2
			End Select

		Case 4
			Select True
				Case r<300
					Return 0
				Case r<700
					Return 1
				Case r<900
					Return 2
				Default
					Return 3
			End Select
		Case 5
			Select True
				Case r<100
					Return 0
				Case r<200
					Return 1
				Case r<400
					Return 2
				Case r<600
					Return 3
				Default
					Return 4
			End Select
		Case 6
			Select True
				Case r<10
					Return 0
				Case r<20
					Return 1
				Case r<200
					Return 2
				Case r<300
					Return 3
				Default
					Return 4
			End Select
		Default
			Select True
				Case r<300
					Return 3
				Default
					Return 4
			End Select
	End Select
	
	
End Function