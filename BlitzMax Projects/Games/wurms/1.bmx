SuperStrict

Type LEVEL
	
	Global map_x:Int=800
	Global map_y:Int=800
	Global map:Byte[100,100,4]
	
	Const block_s:Int=4
	
	Function Create(x:Int=400,y:Int=300,art:Int=0)
		LEVEL.map_x=x
		LEVEL.map_y=y
		
		LEVEL.map=New Byte[LEVEL.map_x,LEVEL.map_y,4]
		
		'level beschreiben
		
		Local my:Int=LEVEL.map_y/3
		
		For Local x:Int=0 To LEVEL.map_x-1
			my:+Rand(-2,2)
			If my<0 Then my=0
			If my>LEVEL.map_y-1 Then my=LEVEL.map_y-1
			
			For Local y:Int=0 To LEVEL.map_y-1
				If y>=my Then
					LEVEL.map[x,y,0]=100
					LEVEL.map[x,y,1]=y*x/4
					LEVEL.map[x,y,2]=100
					LEVEL.map[x,y,3]=True
				Else
					LEVEL.map[x,y,0]=10
					LEVEL.map[x,y,1]=0
					LEVEL.map[x,y,2]=0
					LEVEL.map[x,y,3]=False
				End If
			Next
		Next
	End Function
	
	
	Function play()
		Local i:Int=0
		
		Repeat
			Cls
			
			Rem
			For Local x:Int=0 To ANZEIGE.x/LEVEL.block_s
				If x>LEVEL.map_x-1 Then Continue
				If x<0 Then Continue
				For Local y:Int=0 To ANZEIGE.y/LEVEL.block_s
					If y>LEVEL.map_y-1 Then Exit
					If y<0 Then Continue
					SetColor LEVEL.map[x,y,0],LEVEL.map[x,y,1],LEVEL.map[x,y,2]
					DrawRect x*LEVEL.block_s,y*LEVEL.block_s,LEVEL.block_s,LEVEL.block_s
				Next
			Next
			End Rem
			
			
			PLAYER.render_1()
			PLAYER.render_2()
			
			PLAYER.draw_screen_1()
			PLAYER.draw_screen_2()
			
			SetColor 0,0,0
			DrawRect 395,0,10,600
			
			If KeyHit(key_space) Then LEVEL.kreis(PLAYER.x_1/LEVEL.block_s,PLAYER.y_1/LEVEL.block_s,10,2,5)
			
			i:+1
			SetColor 255,255,255
			DrawText i/60,0,0
			Flip
			'WaitKey()
			If KeyHit(key_escape) Then Return
		Forever
	End Function
	
	Function kreis(xx:Int,yy:Int,d:Int,art:Int=1,d2:Int=0)'x und y auf map, nicht in wirklichkeit!
		
		Select art
			Case 1
				
				For Local x:Int=-d To d
					If x+xx<0 Then Continue
					If x+xx>LEVEL.map_x-1 Then Exit
					For Local y:Int=-d To d
						If y+yy<0 Then Continue
						If y+yy>LEVEL.map_y-1 Exit
						If d^2>x^2+y^2 Then
							LEVEL.map[xx+x,yy+y,0]=0
							LEVEL.map[xx+x,yy+y,1]=0
							LEVEL.map[xx+x,yy+y,2]=0
							LEVEL.map[xx+x,yy+y,3]=False
						End If
					Next
				Next
				
			Case 2
				For Local x:Int=-d-d2 To d+d2
					If x+xx<0 Then Continue
					If x+xx>LEVEL.map_x-1 Then Exit
					For Local y:Int=-d-d2 To d+d2
						If y+yy<0 Then Continue
						If y+yy>LEVEL.map_y-1 Exit
						If (d+d2)^2>x^2+y^2 Then
							If d^2>x^2+y^2 Then
								LEVEL.map[xx+x,yy+y,0]=0
								LEVEL.map[xx+x,yy+y,1]=0
								LEVEL.map[xx+x,yy+y,2]=0
								LEVEL.map[xx+x,yy+y,3]=False
							Else
								If LEVEL.map[xx+x,yy+y,3]=True Then
									LEVEL.map[xx+x,yy+y,0]:*0.5'faktoren noch ver�ndern!
									LEVEL.map[xx+x,yy+y,1]:*0.4
									LEVEL.map[xx+x,yy+y,2]:*0.2
								End If
							End If
						End If
					Next
				Next
		End Select
		
	End Function
End Type

Type PLAYER
	Global x_1:Float=LEVEL.map_x/3
	Global y_1:Float=100
	Global x_2:Float=LEVEL.map_x/3*2
	Global y_2:Float=100
	
	Global d_y_1:Float=0
	Global d_y_2:Float=0
	
	Function render_1()
		If LEVEL.map[PLAYER.x_1/LEVEL.block_s,PLAYER.y_1/LEVEL.block_s+2,3]=False Then PLAYER.y_1:+2
		If LEVEL.map[PLAYER.x_1/LEVEL.block_s,PLAYER.y_1/LEVEL.block_s,3]=True Then PLAYER.y_1:+3
		
		If KeyDown(key_a) And LEVEL.map[PLAYER.x_1/LEVEL.block_s-1,PLAYER.y_1/LEVEL.block_s,3]=False Then PLAYER.x_1:-2
		If KeyDown(key_d) And LEVEL.map[PLAYER.x_1/LEVEL.block_s+1,PLAYER.y_1/LEVEL.block_s,3]=False Then PLAYER.x_1:+3
		
		PLAYER.d_y_1:-0.2
		If KeyHit(key_w) And LEVEL.map[PLAYER.x_1/LEVEL.block_s,PLAYER.y_1/LEVEL.block_s+2,3]=True Then PLAYER.d_y_1=5.0
		If PLAYER.d_y_1>0 Then PLAYER.y_1:-PLAYER.d_y_1
		
	End Function
	
	Function render_2()
		If LEVEL.map[PLAYER.x_2/LEVEL.block_s,PLAYER.y_2/LEVEL.block_s+2,3]=False Then PLAYER.y_2:+2
		If LEVEL.map[PLAYER.x_2/LEVEL.block_s,PLAYER.y_2/LEVEL.block_s,3]=True Then PLAYER.y_1:+1
		
		If KeyDown(key_left) And LEVEL.map[PLAYER.x_2/LEVEL.block_s-1,PLAYER.y_2/LEVEL.block_s,3]=False Then PLAYER.x_2:-2
		If KeyDown(key_right) And LEVEL.map[PLAYER.x_2/LEVEL.block_s+1,PLAYER.y_2/LEVEL.block_s,3]=False Then PLAYER.x_2:+2
		
		PLAYER.d_y_2:-0.2
		If KeyHit(key_up) And LEVEL.map[PLAYER.x_2/LEVEL.block_s,PLAYER.y_2/LEVEL.block_s+2,3]=True Then PLAYER.d_y_2=5.0
		If PLAYER.d_y_2>0 Then PLAYER.y_2:-PLAYER.d_y_2
	End Function
	
	Function draw_screen_1()
		
		SetViewport 0,0,400,600
		
		For Local x:Int=PLAYER.x_1-200.0 To PLAYER.x_1+200.0 Step LEVEL.block_s
			If x/LEVEL.block_s>LEVEL.map_x-1 Then Continue
			If x/LEVEL.block_s<0 Then Continue
			For Local y:Int=PLAYER.y_1-300.0 To PLAYER.y_1+300.0 Step LEVEL.block_s
				
				If y/LEVEL.block_s>LEVEL.map_y-1 Then Exit
				If y/LEVEL.block_s<0 Then Continue
				SetColor LEVEL.map[x/LEVEL.block_s,y/LEVEL.block_s,0],LEVEL.map[x/LEVEL.block_s,y/LEVEL.block_s,1],LEVEL.map[x/LEVEL.block_s,y/LEVEL.block_s,2]
				DrawRect (x-(PLAYER.x_1-200)),(y-(PLAYER.y_1-300)),LEVEL.block_s,LEVEL.block_s
			Next
		Next
		
		SetColor 255,0,0
		DrawRect 195,290,10,20
		
		SetColor 0,255,0
		DrawRect PLAYER.x_2-PLAYER.x_1+200-5,PLAYER.y_2-PLAYER.y_1+300-10,10,20
		
		
	End Function
	
	
	Function draw_screen_2()
		
		SetViewport 400,0,400,600
		
		For Local x:Int=PLAYER.x_2-200 To PLAYER.x_2+200 Step LEVEL.block_s
			If x/LEVEL.block_s>LEVEL.map_x-1 Then Continue
			If x/LEVEL.block_s<0 Then Continue
			For Local y:Int=PLAYER.y_2-300 To PLAYER.y_2+300 Step LEVEL.block_s
				'Print y
				If y/LEVEL.block_s>LEVEL.map_y-1 Then Exit
				If y/LEVEL.block_s<0 Then Continue
				SetColor LEVEL.map[x/LEVEL.block_s,y/LEVEL.block_s,0],LEVEL.map[x/LEVEL.block_s,y/LEVEL.block_s,1],LEVEL.map[x/LEVEL.block_s,y/LEVEL.block_s,2]
				DrawRect 400+(x-(PLAYER.x_2-200)),(y-(PLAYER.y_2-300)),LEVEL.block_s,LEVEL.block_s
			Next
		Next
		
		
		SetColor 0,255,0
		DrawRect 400+195,290,10,20
		
		SetColor 255,0,0
		DrawRect PLAYER.x_1-PLAYER.x_2+200-5+400,PLAYER.y_1-PLAYER.y_2+300-10,10,20
		
		SetViewport 0,0,800,600
	End Function

End Type

Type WEAPON
End Type

Type ANZEIGE
	Global x:Int
	Global y:Int
	Function ini(x:Int=800,y:Int=600)
		ANZEIGE.x=x
		ANZEIGE.y=y
		AppTitle = "W�rmer"
		Graphics x,y
		SetClsColor(0,0,0)
		SetBlend ALPHABLEND
	End Function
End Type

ANZEIGE.ini()
LEVEL.Create()
LEVEL.play()

End