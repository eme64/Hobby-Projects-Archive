SuperStrict
SeedRnd MilliSecs()


Type LEVEL
	
	Global map_x:Int=800
	Global map_y:Int=800
	Global map:Byte[100,100,4]
	
	Const block_s:Int=4
	
	Global wasser:TImage
	Global wasser_hoehe:Int=1000
	
	Global wind:Float=0.05'ist f�r die x-beschleunigung
	Global gravitation:Float=0.2'additor
	
	Function ini()
		LEVEL.wasser=LoadImage("gfx\wasser.png")
	End Function
	
	Function Create(x:Int=400,y:Int=300,art:Int=0)
		LEVEL.map_x=x
		LEVEL.map_y=y
		
		LEVEL.map=New Byte[LEVEL.map_x,LEVEL.map_y,4]
		
		'level beschreiben
		
		Local pixmap1:TPixmap=LoadPixmap("gfx\map\boden.bmp")
		Local pixmap2:TPixmap=LoadPixmap("gfx\map\gras.bmp")
		
		Local my:Int=LEVEL.map_y/3
		Local myy:Int=0
		
		Local unter_boden:Int=0
		
		For Local x:Int=0 To LEVEL.map_x-1
			myy:+Rand(-1,1)
			
			If myy>5 Then myy=5
			If myy<-5 Then myy=-5
			
			If my<50 Then myy:+1
			If my>LEVEL.map_y-1-50 Then myy:-1
			
			my:+myy
			
			
			For Local y:Int=0 To LEVEL.map_y-1
				If y>=my Then

					If unter_boden<5 Then
						getpixel(pixmap2,x,unter_boden,LEVEL.map[x,y,0],LEVEL.map[x,y,1],LEVEL.map[x,y,2])
						'LEVEL.map[x,y,0]=255
						'LEVEL.map[x,y,1]=255
						'LEVEL.map[x,y,2]=255
						LEVEL.map[x,y,3]=True
					Else
						getpixel(pixmap1,x,y,LEVEL.map[x,y,0],LEVEL.map[x,y,1],LEVEL.map[x,y,2])
						'LEVEL.map[x,y,0]=255
						'LEVEL.map[x,y,1]=255
						'LEVEL.map[x,y,2]=255
						LEVEL.map[x,y,3]=True
					End If
					unter_boden:+1
				Else
					LEVEL.map[x,y,0]=0
					LEVEL.map[x,y,1]=0
					LEVEL.map[x,y,2]=0
					LEVEL.map[x,y,3]=False
					unter_boden=0
				End If
			Next
		Next
	End Function
	
	Function getpixel(p:TPixmap,x:Int,y:Int,r:Byte Var,g:Byte Var,b:Byte Var)
		While x>=PixmapWidth(p)
			x:-PixmapWidth(p)
			
		Wend
		
		While y>=PixmapHeight(p)
			y:-PixmapHeight(p)
			
		Wend
		
		Local rgba:Int=ReadPixel(p,x,y)
		r= Byte(rgba Shr 16)
   		g= Byte(rgba Shr 8)
		b= Byte(rgba)
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
			
			WAFFE.render_all()
			
			PLAYER.render_1()
			PLAYER.render_2()
			
			PLAYER.draw_screen_1()
			PLAYER.draw_screen_2()
			
			SetColor 0,0,0
			DrawRect 395,0,10,600
			
			If KeyHit(key_space) Then LEVEL.kreis(PLAYER.x_1/LEVEL.block_s,PLAYER.y_1/LEVEL.block_s,5,2,2)
			
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
									LEVEL.map[xx+x,yy+y,0]:*0.7
									LEVEL.map[xx+x,yy+y,1]:*0.7
									LEVEL.map[xx+x,yy+y,2]:*0.7
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
	
	Global w_1:Float=0
	Global w_2:Float=0
	
	Global pistole:TImage
	Global mann:TImage
	
	Function ini()
		PLAYER.pistole=LoadImage("gfx\waffen\pistole.png")
		MidHandleImage PLAYER.pistole
		
		PLAYER.mann=LoadImage("gfx\mann.png")
		
	End Function
	
	Function render_1()
		If LEVEL.map[PLAYER.x_1/LEVEL.block_s,PLAYER.y_1/LEVEL.block_s+2,3]=False Then PLAYER.y_1:+2
		If LEVEL.map[PLAYER.x_1/LEVEL.block_s,PLAYER.y_1/LEVEL.block_s,3]=True Then PLAYER.y_1:+3
		
		If KeyDown(key_a) And LEVEL.map[PLAYER.x_1/LEVEL.block_s-1,PLAYER.y_1/LEVEL.block_s,3]=False Then PLAYER.x_1:-2
		If KeyDown(key_d) And LEVEL.map[PLAYER.x_1/LEVEL.block_s+1,PLAYER.y_1/LEVEL.block_s,3]=False Then PLAYER.x_1:+3
		
		PLAYER.d_y_1:-0.2
		If KeyHit(key_w) And LEVEL.map[PLAYER.x_1/LEVEL.block_s,PLAYER.y_1/LEVEL.block_s+2,3]=True Then PLAYER.d_y_1=5.0
		If PLAYER.d_y_1>0 Then PLAYER.y_1:-PLAYER.d_y_1
		
		If KeyDown(key_q) Then PLAYER.w_1:-2
		If KeyDown(key_e) Then PLAYER.w_1:+2
		
		If KeyHit(key_s) Then RAKETE_NORMAL.Create(PLAYER.x_1,PLAYER.y_1,PLAYER.w_1,100)
	End Function
	
	Function render_2()
		If LEVEL.map[PLAYER.x_2/LEVEL.block_s,PLAYER.y_2/LEVEL.block_s+2,3]=False Then PLAYER.y_2:+2
		If LEVEL.map[PLAYER.x_2/LEVEL.block_s,PLAYER.y_2/LEVEL.block_s,3]=True Then PLAYER.y_1:+1
		
		If KeyDown(key_num4) And LEVEL.map[PLAYER.x_2/LEVEL.block_s-1,PLAYER.y_2/LEVEL.block_s,3]=False Then PLAYER.x_2:-2
		If KeyDown(key_num6) And LEVEL.map[PLAYER.x_2/LEVEL.block_s+1,PLAYER.y_2/LEVEL.block_s,3]=False Then PLAYER.x_2:+2
		
		PLAYER.d_y_2:-0.2
		If KeyHit(key_num8) And LEVEL.map[PLAYER.x_2/LEVEL.block_s,PLAYER.y_2/LEVEL.block_s+2,3]=True Then PLAYER.d_y_2=5.0
		If PLAYER.d_y_2>0 Then PLAYER.y_2:-PLAYER.d_y_2
		
		If KeyDown(key_num7) Then PLAYER.w_1:-2
		If KeyDown(key_num9) Then PLAYER.w_1:+2
		
		If KeyHit(key_num5) Then RAKETE_NORMAL.Create(PLAYER.x_2,PLAYER.y_2,PLAYER.w_2,100)
	End Function
	
	Function draw_screen_1()
		
		SetViewport 0,0,400,600
		
		For Local x:Int=PLAYER.x_1-200.0 To PLAYER.x_1+200.0 Step LEVEL.block_s
			If x/LEVEL.block_s>LEVEL.map_x-1 Then Continue
			If x/LEVEL.block_s<0 Then Continue
			For Local y:Int=PLAYER.y_1-300.0 To PLAYER.y_1+300.0 Step LEVEL.block_s
				
				If y/LEVEL.block_s>LEVEL.map_y-1 Then Exit
				If y/LEVEL.block_s<0 Then Continue
				If LEVEL.map[x/LEVEL.block_s,y/LEVEL.block_s,3]=True Then
					SetColor LEVEL.map[x/LEVEL.block_s,y/LEVEL.block_s,0],LEVEL.map[x/LEVEL.block_s,y/LEVEL.block_s,1],LEVEL.map[x/LEVEL.block_s,y/LEVEL.block_s,2]
					DrawRect (x-(PLAYER.x_1-200)),(y-(PLAYER.y_1-300)),LEVEL.block_s,LEVEL.block_s
				End If
			Next
		Next
		
		SetColor 255,100,0
		DrawImage PLAYER.mann,195,290
		
		SetColor 255,255,255
		SetRotation PLAYER.w_1
		DrawImage PLAYER.pistole,200,300
		SetRotation 0
		
		SetColor 0,255,100
		DrawImage PLAYER.mann, PLAYER.x_2-PLAYER.x_1+200-5,PLAYER.y_2-PLAYER.y_1+300-10
				
		SetRotation PLAYER.w_2
		DrawImage PLAYER.pistole,PLAYER.x_2-PLAYER.x_1+200,PLAYER.y_2-PLAYER.y_1+300
		SetRotation 0
		
		WAFFE.draw_all(PLAYER.x_1,PLAYER.y_1,200,300)
		
		
		SetColor 255,255,255
		DrawImage LEVEL.wasser,0,0+LEVEL.wasser_hoehe-PLAYER.y_1+300
		
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
				If LEVEL.map[x/LEVEL.block_s,y/LEVEL.block_s,3]=True Then
					SetColor LEVEL.map[x/LEVEL.block_s,y/LEVEL.block_s,0],LEVEL.map[x/LEVEL.block_s,y/LEVEL.block_s,1],LEVEL.map[x/LEVEL.block_s,y/LEVEL.block_s,2]
					DrawRect 400+(x-(PLAYER.x_2-200)),(y-(PLAYER.y_2-300)),LEVEL.block_s,LEVEL.block_s
				End If
			Next
		Next
		
		
		SetColor 0,255,100
		DrawImage PLAYER.mann,400+195,290
		
		SetColor 255,255,255
		SetRotation PLAYER.w_2
		DrawImage PLAYER.pistole,600,300
		SetRotation 0
		
		SetColor 255,100,0
		DrawImage PLAYER.mann,PLAYER.x_1-PLAYER.x_2+200-5+400,PLAYER.y_1-PLAYER.y_2+300-10
		
		SetRotation PLAYER.w_1
		DrawImage PLAYER.pistole,PLAYER.x_1-PLAYER.x_2+600,PLAYER.y_1-PLAYER.y_2+300
		SetRotation 0
		
		WAFFE.draw_all(PLAYER.x_2,PLAYER.y_2,600,300)
		
		
		SetColor 255,255,255
		DrawImage LEVEL.wasser,400,0+LEVEL.wasser_hoehe-PLAYER.y_2+300
		
		
		SetViewport 0,0,800,600
		
		
	End Function

End Type

Type WAFFE
	Global liste:TList
	
	Function ini()
		WAFFE.liste=New TList
	End Function
	
	Field x:Float,v_x:Float,a_r_x:Float'multiplikator
	Field y:Float,v_y:Float,a_r_y:Float
	
	Method draw(pos_x:Int,pos_y:Int,x_a:Int,y_a:Int) Abstract
	
	
	Method New()
		WAFFE.liste.addlast(Self)
		Self.a_r_x=1
		Self.a_r_y=1
	End Method
	
	Method render()
		Self.v_x:+LEVEL.wind
		Self.v_x:*Self.a_r_x
		Self.x:+Self.v_x
		
		Self.v_y:+LEVEL.gravitation
		Self.v_y:*Self.a_r_y
		Self.y:+Self.v_y
		
		If Self.y>LEVEL.wasser_hoehe Then ListRemove(Self.liste,Self)'explosion
		
		If Self.x<0 Or Self.y<0 Or Self.x>LEVEL.map_x*LEVEL.block_s Or Self.y>LEVEL.map_y*LEVEL.block_s Then Return
		
		If LEVEL.map[Self.x/LEVEL.block_s,Self.y/LEVEL.block_s,3]=True Then
			ListRemove(Self.liste,Self)'explosion
			LEVEL.kreis(Self.x/LEVEL.block_s,Self.y/LEVEL.block_s,10,2,5)
			
		End If
	End Method
	
	
	Function render_all()
		For Local w:WAFFE=EachIn WAFFE.liste
			w.render()
		Next
	End Function
	
	Function draw_all(pos_x:Int,pos_y:Int,x_a:Int,y_a:Int)
		For Local w:WAFFE=EachIn WAFFE.liste
			w.draw(pos_x,pos_y,x_a,y_a)
		Next
	End Function
End Type

Type GRANATE_NORMAL Extends WAFFE
	Global image:TImage
	
	Function ini()
		GRANATE_NORMAL.image=LoadImage("gfx\waffen\granate_normal.png")
		MidHandleImage GRANATE_NORMAL.image
		If GRANATE_NORMAL.image=Null Then Print
	End Function
	
	Method draw(pos_x:Int,pos_y:Int,x_a:Int,y_a:Int)
		SetColor 255,255,255
		SetRotation ATan2(Self.v_y,Self.v_x)+90
		DrawImage GRANATE_NORMAL.image,x_a+Self.x-pos_x,y_a+Self.y-pos_y
		SetRotation 0
	End Method
	
	Function Create:GRANATE_NORMAL(x:Float,y:Float,w:Float,power:Float)'power von 1-100
		Local g:GRANATE_NORMAL=New GRANATE_NORMAL
		g.x=x
		g.y=y
		
		g.v_x=Cos(w)*power*0.1
		g.v_y=Sin(w)*power*0.1
		
		Return g
	End Function
End Type

Type RAKETE_NORMAL Extends WAFFE
	Global image:TImage
	Field power:Int=60
	
	Function ini()
		RAKETE_NORMAL.image=LoadImage("gfx\waffen\rakete_normal.png")
		MidHandleImage RAKETE_NORMAL.image
		If RAKETE_NORMAL.image=Null Then Print
	End Function
	
	Method draw(pos_x:Int,pos_y:Int,x_a:Int,y_a:Int)
		SetColor 255,255,255
		SetRotation ATan2(Self.v_y,Self.v_x)
		DrawImage RAKETE_NORMAL.image,x_a+Self.x-pos_x,y_a+Self.y-pos_y
		SetRotation 0
	End Method
	
	Function Create:RAKETE_NORMAL(x:Float,y:Float,w:Float,power:Float)'power von 1-100
		Local g:RAKETE_NORMAL=New RAKETE_NORMAL
		g.x=x
		g.y=y
		
		g.v_x=Cos(w)*power*0.05
		g.v_y=Sin(w)*power*0.05
		
		Return g
	End Function
	
	Method render()
		If Self.power>0 Then
			Self.v_x:+Cos(ATan2(Self.v_y,Self.v_x))*0.005*Self.power
			Self.v_y:+Sin(ATan2(Self.v_y,Self.v_x))*0.005*Self.power
			Self.power:-1
		End If
		
		Self.v_x:+LEVEL.wind
		Self.v_x:*Self.a_r_x
		Self.x:+Self.v_x
		
		Self.v_y:+LEVEL.gravitation
		Self.v_y:*Self.a_r_y
		Self.y:+Self.v_y
		
		If Self.y>LEVEL.wasser_hoehe Then ListRemove(Self.liste,Self)'explosion
		
		If Self.x<0 Or Self.y<0 Or Self.x>LEVEL.map_x*LEVEL.block_s Or Self.y>LEVEL.map_y*LEVEL.block_s Then Return
		
		If LEVEL.map[Self.x/LEVEL.block_s,Self.y/LEVEL.block_s,3]=True Then
			ListRemove(Self.liste,Self)'explosion
			LEVEL.kreis(Self.x/LEVEL.block_s,Self.y/LEVEL.block_s,10,2,5)
			
		End If
	End Method
End Type

Type ANZEIGE
	Global x:Int
	Global y:Int
	Function ini(x:Int=800,y:Int=600)
		ANZEIGE.x=x
		ANZEIGE.y=y
		AppTitle = "W�rmer"
		Graphics x,y
		SetClsColor(0,100,150)
		SetBlend ALPHABLEND
	End Function
End Type

ANZEIGE.ini()
LEVEL.ini()
WAFFE.ini()
PLAYER.ini()
RAKETE_NORMAL.ini()
GRANATE_NORMAL.ini()
LEVEL.Create()
LEVEL.play()

End