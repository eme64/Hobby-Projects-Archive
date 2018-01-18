Graphics 800,600,32,2
SetBuffer BackBuffer()

Global game_image=CreateImage(700,500)

Type SSS;Spieler
	Field x#,y#,l_x#,l_y#,speed#,winkel,loecher_counter
	Field key_links,key_rechts
	Field spieler_farbe[2]
	Field punkte
End Type

spieler.SSS=New SSS;s1
spieler\x=10
spieler\y=10
spieler\l_x=spieler\x
spieler\l_y=spieler\y
spieler\winkel=-45
spieler\speed=5
spieler\loecher_counter=20
spieler\key_links=29
spieler\key_rechts=56
spieler\spieler_farbe[0]=255
spieler\spieler_farbe[1]=0
spieler\spieler_farbe[2]=0

spieler.SSS=New SSS;s2
spieler\x=490
spieler\y=490
spieler\l_x=spieler\x
spieler\l_y=spieler\y
spieler\winkel=125
spieler\speed=5
spieler\loecher_counter=20
spieler\key_links=203
spieler\key_rechts=205
spieler\spieler_farbe[0]=0
spieler\spieler_farbe[1]=255
spieler\spieler_farbe[2]=0

If 1=1 Then
	spieler.SSS=New SSS;s3
	spieler\x=10
	spieler\y=490
	spieler\l_x=spieler\x
	spieler\l_y=spieler\y
	spieler\winkel=225
	spieler\speed=5
	spieler\loecher_counter=20
	spieler\key_links=55
	spieler\key_rechts=74
	spieler\spieler_farbe[0]=0
	spieler\spieler_farbe[1]=0
	spieler\spieler_farbe[2]=255
End If

If 1=1 Then
	spieler.SSS=New SSS;s3
	spieler\x=100
	spieler\y=490
	spieler\l_x=spieler\x
	spieler\l_y=spieler\y
	spieler\winkel=225
	spieler\speed=5
	spieler\loecher_counter=20
	spieler\key_links=2
	spieler\key_rechts=3
	spieler\spieler_farbe[0]=255
	spieler\spieler_farbe[1]=255
	spieler\spieler_farbe[2]=255
End If

SetBuffer ImageBuffer(game_image)
Color 255,255,0
For i=0 To 5
	Rect i,i,700-2*i,500-2*i,0
Next

Color 0,1,255
Rect 200,200,150,10

Color 0,255,255
Rect 300,300,50,10

Color 254,0,255
Rect 100,300,100,10



counter=0


ttt=CreateTimer(10)
Repeat
	SetBuffer ImageBuffer(game_image)
	For spieler.SSS=Each SSS
		spieler\l_x=spieler\x
		spieler\l_y=spieler\y
		If KeyDown(spieler\key_links) Then spieler\winkel=spieler\winkel +10
		If KeyDown(spieler\key_rechts) Then spieler\winkel=spieler\winkel -10
		spieler\x=spieler\x+Cos(spieler\winkel)*spieler\speed
		spieler\y=spieler\y-Sin(spieler\winkel)*spieler\speed
		GetColor spieler\x,spieler\y
		If ColorRed()=0 And ColorGreen()=0 And ColorBlue()=0 Then
			;If spieler\loecher_counter>3 Then 
				Color spieler\spieler_farbe[0],spieler\spieler_farbe[1],spieler\spieler_farbe[2]
				Rect spieler\x-2,spieler\y-2,5,5
				Line spieler\x,spieler\y,spieler\l_x,spieler\l_y
			;End If
			spieler\loecher_counter=spieler\loecher_counter-1
			If spieler\loecher_counter=0 Then spieler\loecher_counter=Rand(3,Rand(4,Rand(5,30)))
			
		Else
			counter=counter+1
			AppTitle counter
			clear_color(spieler\spieler_farbe[0],spieler\spieler_farbe[1],spieler\spieler_farbe[2])
			spieler\x=Rand(10,490)
			spieler\y=Rand(10,490)
			spieler\l_x=spieler\x
			spieler\l_y=spieler\y
			spieler\punkte=spieler\punkte+1
		End If
	Next
	SetBuffer BackBuffer()
	Cls
	DrawBlock game_image,50,50
	i=0
	For spieler.SSS=Each SSS
		Color spieler\spieler_farbe[0],spieler\spieler_farbe[1],spieler\spieler_farbe[2]
		Rect spieler\x+49,spieler\y+49,3,3
		Text 10+i*200,10,"Verlorene Leben: "+Str(spieler\punkte)
		i=i+1
	Next
	WaitTimer ttt
	Flip
Until KeyDown(1)
End

Function clear_color(r,g,b)
	LockBuffer ImageBuffer(game_image)
	delete_color=255*$1000000 + r*$10000 + g*$100 + b
	For x=1 To 699
		For y=1 To 499
			If ReadPixelFast(x,y,ImageBuffer(game_image))=delete_color Then WritePixelFast x, y, 255*$1000000, ImageBuffer(game_image)
		Next
	Next
	UnlockBuffer ImageBuffer(game_image)
End Function