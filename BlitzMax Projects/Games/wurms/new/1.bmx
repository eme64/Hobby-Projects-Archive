SuperStrict
SeedRnd MilliSecs()


Type TERRAIN
	Global image:TImage
	Global pixmap:TPixmap
	
	Global wind:Float=0, wind_abs:Float=0.1'maximale abweichung von null
	
	Function render_wind()
		TERRAIN.wind:+Rnd()*0.002-0.001
		
		If TERRAIN.wind>TERRAIN.wind_abs Then TERRAIN.wind=TERRAIN.wind_abs
		If TERRAIN.wind<-TERRAIN.wind_abs Then TERRAIN.wind=-TERRAIN.wind_abs
	End Function
	
	Function draw_wind(x:Int,y:Int)'auf bildschirm!, braucht 110x20 pixel
		SetColor 100,100,255
		DrawRect x,y,110,20
		SetColor 255-255*Abs(TERRAIN.wind)/TERRAIN.wind_abs,255*Abs(TERRAIN.wind)/TERRAIN.wind_abs,0
		DrawRect x+55,y+2,50*TERRAIN.wind/TERRAIN.wind_abs,16
	End Function
	
	Function Create(x:Int,y:Int,art:Int=0,art2:Int=0)
		TERRAIN.image=CreateImage(x,y)
		TERRAIN.pixmap=LockImage(TERRAIN.image)
		'ClearPixels(TERRAIN.pixmap)
		MaskPixmap(TERRAIN.pixmap,0,0,0)'schwarz maskieren
		
		Select art
			Case 0
				Local my:Int=PixmapHeight(TERRAIN.pixmap)/2
				Local myy:Int=0'steigung
				
				For Local xx:Int=0 To PixmapWidth(TERRAIN.pixmap)-1
					myy:+Rand(-1,1)
					If myy<-2 Then myy=-2
					If myy>2 Then myy=2
					
					my:+myy
					If my<50 Then myy=5
					If my>PixmapHeight(TERRAIN.pixmap)-50 Then myy=-5
					
					For Local yy:Int=0 To PixmapHeight(TERRAIN.pixmap)-1
						If yy>=my Then
							WritePixel(TERRAIN.pixmap,xx,yy,PIXELS.rgba(255,255,255,255))
						Else
							WritePixel(TERRAIN.pixmap,xx,yy,PIXELS.LEER)
						End If
					Next
				Next
			Case 1
				Local my:Int=PixmapHeight(TERRAIN.pixmap)/4
				Local myy:Int=0'steigung
				
				For Local xx:Int=0 To PixmapWidth(TERRAIN.pixmap)-1
					myy:+Rand(-1,1)
					If myy<-1 Then myy=-1
					If myy>1 Then myy=1
					
					my:+myy
					If my<50 Then myy=5
					If my>PixmapHeight(TERRAIN.pixmap)-50 Then myy=-5
					
					For Local yy:Int=0 To PixmapHeight(TERRAIN.pixmap)-1
						If yy>=my Then
							WritePixel(TERRAIN.pixmap,xx,yy,PIXELS.rgba(255,255,255,255))
						Else
							WritePixel(TERRAIN.pixmap,xx,yy,PIXELS.LEER)
						End If
					Next
				Next
				
				For Local i:Int=1 To Rand(20,30)
					TERRAIN.kreis(Rand(0,PixmapHeight(TERRAIN.pixmap)-1),Rand(0,PixmapHeight(TERRAIN.pixmap)-1),Rand(20,70),PIXELS.LEER)
				Next
		End Select
		
		Select art2
			Case 0
				Local my:Int=0
				For Local xx:Int=0 To PixmapWidth(TERRAIN.pixmap)-1
					my=0
					For Local yy:Int=0 To PixmapHeight(TERRAIN.pixmap)-1
						If PIXELS.rgba(255,255,255,255)=ReadPixel(TERRAIN.pixmap,xx,yy) Then
							my:+1
							If my<=9 Then
								WritePixel(TERRAIN.pixmap,xx,yy,PIXELS.rgba(0,150,0,255))
							Else
								WritePixel(TERRAIN.pixmap,xx,yy,PIXELS.rgba(50,50,50,255))
							End If
						Else
							my=0
						End If
					Next
				Next
			Case 1
				Local pixmap1:TPixmap=LoadPixmap("gfx\boden\boden_0.png")
				Local pixmap2:TPixmap=LoadPixmap("gfx\boden\gras_0.png")
				Local my:Int=0
				For Local xx:Int=0 To PixmapWidth(TERRAIN.pixmap)-1
					my=0
					For Local yy:Int=0 To PixmapHeight(TERRAIN.pixmap)-1
						If PIXELS.rgba(255,255,255,255)=ReadPixel(TERRAIN.pixmap,xx,yy) Then
							my:+1
							If my<=9 Then
								WritePixel(TERRAIN.pixmap,xx,yy,PIXELS.get(pixmap2,xx,my))
							Else
								WritePixel(TERRAIN.pixmap,xx,yy,PIXELS.get(pixmap1,xx,yy))
							End If
						Else
							my=0
						End If
					Next
				Next
		End Select
		UnlockImage(TERRAIN.image)
	End Function
	
	Global FPS:Int=0
	
	Function play()
		SetClsColor 0,255,255
		Local i:Int=0
		Local tim:Int=MilliSecs()
		Repeat
			'RENDER
			TERRAIN.pixmap=LockImage(TERRAIN.image)
			
			
			TERRAIN.render_wind()
			PLAYER.render_all()
			OBJEKT.render_all()
			
			
			'DRAW
			SetClsColor 0,0,0
			Cls
			
			
			
			p1.draw_screen(0,0,399,600)
			p2.draw_screen(401,0,399,600)
			
			'p1.draw_screen(0,0,800,300)
			'p2.draw_screen(0,300,800,300)
			
			'FPS
			
			i:+1
			If tim+1000<MilliSecs() Then
				tim=MilliSecs()
				FPS=i
				i=0
			End If
			
			
			WaitTimer(SCREEN.timer)
			Flip
			
			
			If KeyHit(key_escape) Or AppTerminate() Then Return
		Forever
	End Function
	
	
	Function read:Int(x:Int,y:Int)
		If x<0 Then Return PIXELS.LEER
		If y<0 Then Return PIXELS.LEER
		If x>PixmapWidth(TERRAIN.pixmap)-1 Then Return PIXELS.LEER
		If y>PixmapHeight(TERRAIN.pixmap)-1 Then Return PIXELS.LEER
		Return ReadPixel(TERRAIN.pixmap,x,y)
	End Function
	
	
	Function kreis(x:Int,y:Int,r:Float,c:Int)
		Local x1:Int=x-r
		Local x2:Int=x+r
		Local y1:Int=y-r
		Local y2:Int=y+r
		
		If x1<0 Then x1=0
		If y1<0 Then y1=0
		
		If x2>PixmapWidth(TERRAIN.pixmap)-1 Then x2=PixmapWidth(TERRAIN.pixmap)-1
		If y2>PixmapHeight(TERRAIN.pixmap)-1 Then y2=PixmapHeight(TERRAIN.pixmap)-1
		
		For Local xx:Int=x1 To x2
			For Local yy:Int=y1 To y2
				If r^2>(xx-x)^2+(yy-y)^2 Then
					WritePixel(TERRAIN.pixmap,xx,yy,c)
				End If
			Next
		Next
	End Function
	
	Function loch(x:Int,y:Int,ri:Float,ra:Float,c:Int)
		Local x1:Int=x-ra
		Local x2:Int=x+ra
		Local y1:Int=y-ra
		Local y2:Int=y+ra
		
		If x1<0 Then x1=0
		If y1<0 Then y1=0
		
		If x2>PixmapWidth(TERRAIN.pixmap)-1 Then x2=PixmapWidth(TERRAIN.pixmap)-1
		If y2>PixmapHeight(TERRAIN.pixmap)-1 Then y2=PixmapHeight(TERRAIN.pixmap)-1
		
		For Local xx:Int=x1 To x2
			For Local yy:Int=y1 To y2
				If ri^2>(xx-x)^2+(yy-y)^2 Then
					WritePixel(TERRAIN.pixmap,xx,yy,PIXELS.LEER)
				ElseIf ra^2>(xx-x)^2+(yy-y)^2 Then
					If TERRAIN.read(xx,yy)<>PIXELS.LEER Then
						WritePixel(TERRAIN.pixmap,xx,yy,c)
					End If
				End If
			Next
		Next
	End Function
End Type

Type PIXELS
	Const LEER:Int=0

	Function rgba:Float(rr:Byte,gg:Byte,bb:Byte,aa:Byte)
		Return aa*$1000000 + rr*$10000 + gg*$100 + bb
	End Function
	
	Function r:Byte(rgba:Int)
		Return Byte(rgba Shr 16)
	End Function
	
	Function g:Byte(rgba:Int)
		Return Byte(rgba Shr 8)
	End Function
	
	Function b:Byte(rgba:Int)
		Return Byte(rgba)
	End Function
	
	Function a:Byte(rgba:Int)
		Return Byte(rgba Shr 24)
	End Function
	
	Function get:Int(p:TPixmap,x:Int,y:Int)
		While x>=PixmapWidth(p)
			x:-PixmapWidth(p)
		Wend
		
		While y>=PixmapHeight(p)
			y:-PixmapHeight(p)
		Wend
		
		Return ReadPixel(p,x,y)
	End Function
End Type

Type PLAYER
	Global list:TList
	Global image:TImage
	Global image_gun:TImage
	Global image_herz:TImage
	Global image_kreuz:TImage
	Global image_himmel:TImage
	
	Function ini()
		PLAYER.list=New TList
		
		PLAYER.image=LoadImage("gfx\player\p_0.png")
		MidHandleImage PLAYER.image
		
		PLAYER.image_gun=LoadImage("gfx\waffen\w_0.png")
		MidHandleImage PLAYER.image_gun
		
		PLAYER.image_herz=LoadImage("gfx\sonstiges\herz.png")
		MidHandleImage PLAYER.image_herz
		
		PLAYER.image_kreuz=LoadImage("gfx\sonstiges\kreuz.png")
		MidHandleImage PLAYER.image_kreuz
		
		PLAYER.image_himmel=LoadImage("gfx\hintergrund\himmel.png")
	End Function
	
	Field x:Float, v_x:Float, a_x:Float, versch_x:Float
	Field y:Float, v_y:Float, a_y:Float, versch_y:Float
	
	Field winkel:Float, power:Float
	
	Field collided:Int[4]
	
	Field steuerung:STEUERUNG
	
	Field leben:Float=100
	
	Function Create:PLAYER(x:Int,y:Int,st:STEUERUNG)
		Local p:PLAYER=New PLAYER
		p.x=x
		p.y=y
		p.collided=New Int[4]
		p.steuerung=st
		p.steuerung.player=p
		PLAYER.list.addlast(p)
		Return p
	End Function
	
	Method render()
		Self.a_y:+0.5'gravitationskraft
		
		Self.v_x:+Self.a_x'kr�fte addieren zur geschwindigkeit
		Self.v_y:+Self.a_y
		Self.a_x=0
		Self.a_y=0
		
		Self.steuerung.render()
		
		If Self.y>PixmapHeight(TERRAIN.pixmap)-1 Then
			Self.y=PixmapHeight(TERRAIN.pixmap)-1
			Self.v_y=0
		End If
		'rechtskollision
		Self.collided[2]=0
		If Self.v_x+Self.versch_x>0 Then
			For Local yy:Int=-10 To 10
				If PIXELS.LEER<>TERRAIN.read(Self.x+5+Self.v_x+Self.versch_x,Self.y+yy) Then
					Self.collided[2]=1
					Exit
				End If
			Next
			
			If Self.collided[2]=1 Then
				Self.v_x=0
				Self.versch_x=0
			Else
				Self.x:+Self.v_x+Self.versch_x
				'Self.v_x=0
				Self.versch_x=0
				
			End If
			
		End If
		
		
		'linkskollision
		Self.collided[3]=0
		If Self.v_x+Self.versch_x<0 Then
			For Local yy:Int=-10 To 10
				If PIXELS.LEER<>TERRAIN.read(Self.x-5+Self.v_x+Self.versch_x,Self.y+yy) Then
					Self.collided[3]=1
					Exit
				End If
			Next
			If Self.collided[3]=1 Then
				Self.v_x=0
				Self.versch_x=0
			Else
				Self.x:+Self.v_x+Self.versch_x
				'Self.v_x=0
				Self.versch_x=0
				
			End If
		End If
		
		
		
		
		'bodenkollision
		Self.collided[0]=0
		If Self.v_y+Self.versch_y>0 Then
			For Local xx:Int=-5 To 5
				If PIXELS.LEER<>TERRAIN.read(Self.x+xx,Self.y+10+Self.v_y+Self.versch_y) Then
					Self.collided[0]=1
					Exit
				End If
			Next
			If Self.collided[0]=1 Then
				Self.v_y=0
			Else
				Self.y:+Self.v_y+Self.versch_y
			End If
		End If
		
		
		'deckenkollision
		Self.collided[1]=0
		If Self.v_y+Self.versch_y<0 Then
			For Local xx:Int=-5 To 5
				If PIXELS.LEER<>TERRAIN.read(Self.x+xx,Self.y-10+Self.v_y+Self.versch_y) Then
					Self.collided[1]=1
					Exit
				End If
			Next
			If Self.collided[1]=1 Then
				Self.v_y=0
			Else
				Self.y:+Self.v_y+Self.versch_y
			End If
		End If
		
		
		If Self.collided[2]=0 And Self.collided[3]=0 Then
			Self.x:+Self.v_x+Self.versch_x
		End If
		
		If Self.collided[0]=0 And Self.collided[1]=0 Then
			Self.y:+Self.v_y+Self.versch_y
		End If
		
		Self.v_x:*0.95
		
		Self.versch_x=0
		Self.versch_y=0
		
	End Method
	
	Function render_all()
		For Local p:PLAYER=EachIn PLAYER.list
			p.render()
		Next
	End Function
	
	Method draw(x:Int,y:Int)'parameter f�r verschiebungen
		SetColor 255,255,255
		DrawImage PLAYER.image,Self.x+x,Self.y+y
		SetRotation Self.winkel
		'DrawImage PLAYER.image_gun,Self.x+x,Self.y+y
		SetRotation 0
		
		DrawImage PLAYER.image_kreuz,Self.x+x+Cos(Self.winkel)*50.0,Self.y+y+Sin(Self.winkel)*50.0
	End Method
	
	
	
	Method draw_screen(x:Int,y:Int,b:Int,h:Int)
		SetViewport x,y,b,h
		
		'## hintergrund       ##
		
		SetClsColor 0,0,0
		Cls
		TileImage(PLAYER.image_himmel,Int(x+b/2-Self.x),Int(y+h/2-Self.y))
		'## terrain           ##
		
		SetColor 255,255,255
		DrawImage TERRAIN.image,Int(x+b/2-Self.x),Int(y+h/2-Self.y)
		
		'## objekte           ##
		
		For Local o:OBJEKT=EachIn OBJEKT.list
			o.draw(x+b/2-Self.x,y+h/2-Self.y)
		Next
		
		'## spieler           ##
		
		For Local p:PLAYER=EachIn PLAYER.list
			p.draw(x+b/2-Self.x,y+h/2-Self.y)
		Next
		
		'## spezielles        ##
		
		'## steueruns-anzeige ##
		
		SetColor 50,50,50
		DrawRect x+b/2-52,y+h-52,104,14
		
		SetColor 255-255*Self.power/100,255*Self.power/100,0
		DrawRect x+b/2-50,y+h-50,Self.power,10
		
		
		TERRAIN.draw_wind(x+10,y+h-30)
		
		SetColor 255,255,255
		DrawText Self.leben,x+10,y+60
		For Local i:Int=1 To Self.leben/4
			DrawImage PLAYER.image_herz,x+10+i*11,y+50
		Next
		
		
		'FPS
		SetColor 10,10,10
		DrawRect x,y,60,20
		SetColor 255,255,255
		DrawText "FPS="+TERRAIN.FPS,x+2,y+2
	End Method
	
	Function render_explosion_all(x:Int,y:Int,radius:Float,schaden_max:Float,flash_max:Float)
		For Local p:PLAYER=EachIn PLAYER.list
			p.render_explosion(x,y,radius,schaden_max,flash_max)
		Next
	End Function
	
	Method render_explosion(x:Int,y:Int,radius:Float,schaden_max:Float,flash_max:Float)
		Local d:Float=Sqr((Self.x-x)^2+(Self.y-y)^2)
		If d<radius Then
			Self.leben:-schaden_max*(1.0-d/radius)
			Local w:Float=ATan2(Self.y-y,Self.x-x)
			Self.a_x:+Cos(w)*flash_max*(1.0-d/radius)
			Self.a_y:+Sin(w)*flash_max*(1.0-d/radius)
		Else
			Return
		End If
	End Method
End Type

Type STEUERUNG
	Field player:PLAYER
	'Function Create(player:PLAYER) abstract 'hier muss unbedingt die id des zu steuernden angegeben werden!
	Method render() Abstract
End Type

Type LOCAL_STEUERUNG Extends STEUERUNG
	Field keys:Int[]'0=left, 1=right, 2=jump, 3=usebutton, 4=choose-left, 5=choose-right, 6=traget-left, 7=target-right ...
	Field last_usebutton:Int=0
	Field selected_waffe:Int=0
	
	Function Create:LOCAL_STEUERUNG(keys:Int[])
		Local ls:LOCAL_STEUERUNG=New LOCAL_STEUERUNG
		ls.keys=keys
		Return ls
	End Function
	
	Method render()
		If KeyDown(Self.keys[3]) Then
			
			Self.player.power:+4
			
			If Self.player.power>100 Then Self.player.power=100
			
			Self.last_usebutton=1
		Else
			If Self.last_usebutton=1 Then
				'TERRAIN.kreis(Self.player.x,Self.player.y,Self.player.power,PIXELS.LEER)
				'TERRAIN.loch(Self.player.x,Self.player.y,Self.player.power,Self.player.power+5,PIXELS.rgba(150,150,50,255))
				If Self.selected_waffe=0 Then
					GRANATE_NORMAL.Create(Self.player.x,Self.player.y,Self.player.winkel,Self.player.power)
				Else
					RAKETE_NORMAL.Create(Self.player.x,Self.player.y,Self.player.winkel,Self.player.power)
				End If
			End If
			
			Self.last_usebutton=0
			Self.player.power=0
		End If
		
		If KeyDown(Self.keys[0]) Then
			Self.player.versch_x:-4
		End If
		
		If KeyDown(Self.keys[1]) Then
			Self.player.versch_x:+4
		End If
		
		If KeyDown(Self.keys[6]) Then
			Self.player.winkel:-3
		End If
		
		If KeyDown(Self.keys[7]) Then
			Self.player.winkel:+3
		End If
		
		If KeyHit(Self.keys[2]) And Self.player.collided[0]=1 Then
			Self.player.a_y:-5
		End If
		
		If KeyHit(Self.keys[4]) Then
			Self.selected_waffe=1-Self.selected_waffe
		End If
	End Method
	
	
	
End Type

Type CPU_STEUERUNG Extends STEUERUNG
End Type

Type OBJEKT
	Global list:TList
	
	Function ini()
		OBJEKT.list=New TList
	End Function
	
	Field x:Float,y:Float,v_x:Float,v_y:Float
	
	Method render() Abstract
	
	Function render_all()
		For Local o:OBJEKT=EachIn OBJEKT.list
			o.render()
		Next
	End Function
	
	Method draw(x:Int,y:Int) Abstract
End Type

Type GRANATE_NORMAL Extends OBJEKT
	Field timer:Int=120
	
	Global image:TImage
	
	Function ini()
		GRANATE_NORMAL.image=LoadImage("gfx\objekte\granate_normal.png")
		MidHandleImage GRANATE_NORMAL.image
	End Function
	
	Function Create:GRANATE_NORMAL(x:Float,y:Float,w:Float,power:Float,timer:Int=60)
		Local g:GRANATE_NORMAL=New GRANATE_NORMAL
		g.x=x
		g.y=y
		g.v_x=Cos(w)*power*0.2
		g.v_y=Sin(w)*power*0.2
		g.timer=timer
		
		OBJEKT.list.addlast(g)
		
		Return g
	End Function
	
	Method render()
		
		Self.v_x:+TERRAIN.wind
		Self.v_y:+0.5
		
		'rechtskollision
		If Self.v_x>0 Then
			If PIXELS.LEER<>TERRAIN.read(Self.x+Self.v_x+1,Self.y) Then
				Self.v_x:*-0.3
			End If
		End If
		
		'linkskollision
		If Self.v_x<0 Then
			If PIXELS.LEER<>TERRAIN.read(Self.x+Self.v_x-1,Self.y) Then
				Self.v_x:*-0.3
			End If
		End If
		
		
		'bodenkollision
		
		If Self.v_y>0 Then
			If PIXELS.LEER<>TERRAIN.read(Self.x,Self.y+Self.v_y+1) Then
				Self.v_y:*-0.3
			End If
		End If
		
		
		'deckenkollision
		
		If Self.v_y<0 Then
			If PIXELS.LEER<>TERRAIN.read(Self.x,Self.y+Self.v_y-1) Then
				Self.v_y:*-0.3
			End If
		End If
		
		
		
		Self.x:+Self.v_x
		Self.y:+Self.v_y
		
		Self.timer:-1
		
		If Self.timer<=0 Then
			TERRAIN.loch(Self.x,Self.y,15,18,PIXELS.rgba(10,10,10,255))
			ListRemove(OBJEKT.list,Self)
			EXPOSIONS.Create(Self.x,Self.y,0,0,EXPOSIONS.explosion_1,15,1,1,20,255,255,100,255)
			
			PLAYER.render_explosion_all(Self.x,Self.y,100,20,10)
			
			For Local i:Int=1 To Rand(20,30)
				FEUER.Create(Self.x,Self.y,Rand(1,360),Rand(50,100))
			Next
		End If
	End Method
	
	Method draw(x:Int,y:Int)'parameter f�r verschiebungen
		SetColor 255,255,255
		'SetRotation ATan2(Self.v_y,Self.v_x)'nicht bei granate
		DrawImage GRANATE_NORMAL.image,Self.x+x,Self.y+y
		'SetRotation 0'nicht bei granate
	End Method
End Type

Type RAKETE_NORMAL Extends OBJEKT
	Global image:TImage
	
	Function ini()
		RAKETE_NORMAL.image=LoadImage("gfx\objekte\rakete_normal.png")
		MidHandleImage  RAKETE_NORMAL.image
	End Function
	
	
	Function Create:RAKETE_NORMAL(x:Float,y:Float,w:Float,power:Float)
		Local r:RAKETE_NORMAL=New RAKETE_NORMAL
		r.x=x
		r.y=y
		r.v_x=Cos(w)*power*0.3
		r.v_y=Sin(w)*power*0.3
		
		OBJEKT.list.addlast(r)
		
		Return r
	End Function
	
	Method render()
		Self.v_x:+TERRAIN.wind
		Self.v_y:+0.5
		
		Self.x:+Self.v_x
		Self.y:+Self.v_y
		
		For Local i:Int=1 To Rand(2,5)
			FEUER_PARTIKEL.Create(Self.x+Rand(0,6)-3,Self.y+Rand(0,6)-3,Rand(40,60))
		Next
		
		If PIXELS.LEER<>TERRAIN.read(Self.x,Self.y) Then
			TERRAIN.loch(Self.x,Self.y,20,23,PIXELS.rgba(24,22,20,255))
			ListRemove(OBJEKT.list,Self)
			EXPOSIONS.Create(Self.x,Self.y,0,0,EXPOSIONS.explosion_1,20,1,1,20,255,255,100,255)
			PLAYER.render_explosion_all(Self.x,Self.y,100,30,10)
		End If
	End Method
	
	Method draw(x:Int,y:Int)'parameter f�r verschiebungen
		SetColor 255,255,255
		SetRotation ATan2(Self.v_y,Self.v_x)
		DrawImage RAKETE_NORMAL.image,Self.x+x,Self.y+y
		SetRotation 0
	End Method
End Type

Type FEUER Extends OBJEKT
	Field timer:Int=200
	
	Function Create:FEUER(x:Float,y:Float,w:Float,power:Float)
		Local r:FEUER =New FEUER
		
		r.timer=300
		
		r.x=x
		r.y=y
		r.v_x=Cos(w)*power*0.05
		r.v_y=Sin(w)*power*0.05
		
		
		OBJEKT.list.addlast(r)
		
		Return r
	End Function
	
	Method render()
		Self.v_x:+TERRAIN.wind*0.1
		
		Self.v_x:*0.9
		
		Self.x:+Self.v_x
		Self.y:+Self.v_y
		
		If Rand(0,2)=1 Then FEUER_PARTIKEL.Create(Self.x,Self.y,Rand(20,30))
		
		If PIXELS.LEER<>TERRAIN.read(Self.x,Self.y+8) Then
			TERRAIN.loch(Self.x,Self.y,3,4,PIXELS.rgba(150,150,150,255))
			'ListRemove(OBJEKT.list,Self)
			'EXPOSIONS.Create(Self.x,Self.y,0,0,EXPOSIONS.explosion_1,40,1,1,20,255,255,0,255)
			PLAYER.render_explosion_all(Self.x,Self.y,10,1,3)
			Self.v_y=0.1
			Self.v_x:*0.9
		Else
			Self.v_y:+0.5
		End If
		
		timer:-1
		If timer<=0 Then ListRemove(OBJEKT.list,Self)
	End Method
	
	Method draw(x:Int,y:Int)'parameter f�r verschiebungen
		'nichts zeichnen, partikel sind SPECIALS
	End Method
End Type

Type SPECIALS Extends OBJEKT
	
	Field image:TImage
	Field x_scale:Float=1, y_scale:Float=1
	Field color:Byte[3]
	Field alpha:Float
	Field count:Int
	Field counter:Int
	Field winkel:Float
	
	Method render() Abstract
	
	Method draw(x:Int,y:Int)'parameter f�r verschiebungen
		SetColor Self.color[0],Self.color[1],Self.color[2]
		SetAlpha alpha
		SetRotation Self.winkel
		SetScale Self.x_scale,Self.y_scale
		DrawImage Self.image,Self.x+x,Self.y+y
		SetRotation 0
		SetAlpha 1
		SetScale 1,1
	End Method
End Type

Type FEUER_PARTIKEL Extends SPECIALS
	
	Global partikel_image:TImage
	
	Function ini()
		FEUER_PARTIKEL.partikel_image=LoadImage("gfx\objekte\feuer_partikel.png")
		MidHandleImage  FEUER_PARTIKEL.partikel_image
	End Function
	
	Method render()
		Self.counter:+1
		If Self.counter>=Self.count Then
			ListRemove(OBJEKT.list,Self)
		End If
		
		Self.alpha=(1.0-Float(Self.counter)/Float(Self.count))*0.5
		
		Self.x:+Self.v_x+TERRAIN.wind
		Self.y:+Self.v_y
	End Method
	
	
	Function Create:FEUER_PARTIKEL(x:Int,y:Int,count:Int)
		Local f:FEUER_PARTIKEL=New FEUER_PARTIKEL
		f.x=x
		f.y=y
		
		f.v_x=(Rnd()-0.5)*0.1
		f.v_y=-0.1-Rnd()*0.1
		
		f.alpha=0.5
		
		f.count=count
		
		f.image=FEUER_PARTIKEL.partikel_image
		
		f.color[0]=Rand(200,255)
		f.color[1]=Rand(100,150)
		f.color[2]=Rand(0,50)
		
		f.x_scale=0.5+Rnd()
		f.y_scale=0.5+Rnd()
		
		OBJEKT.list.addlast(f)
		Return f
	End Function
End Type

Type EXPOSIONS Extends SPECIALS
	
	Global explosion_1:TImage
	
	Field radius:Float
	
	Function ini()
		EXPOSIONS.explosion_1=LoadImage("gfx\objekte\explos_ring.png")
		MidHandleImage  EXPOSIONS.explosion_1
	End Function
	
	Function Create:EXPOSIONS(x:Float,y:Float,v_x:Float,v_y:Float,image:TImage,radius:Float,x_scale:Float,y_scale:Float,count:Int,r:Byte,g:Byte,b:Byte,a:Byte)
		Local s:EXPOSIONS=New EXPOSIONS
		
		s.x=x
		s.y=y
		s.v_x=v_x
		s.v_y=v_y
		
		s.image=image
		s.count=count
		s.counter=0
		
		s.radius=radius
		
		s.x_scale=x_scale
		s.y_scale=y_scale
		
		s.color[0]=r
		s.color[1]=g
		s.color[2]=b
		s.alpha=a
		
		OBJEKT.list.addlast(s)
		
		
		Return s
	End Function
	
	Method render()
		Self.counter:+1
		If Self.counter>=Self.count Then
			ListRemove(OBJEKT.list,Self)
		End If
		
		Self.alpha=1.0-Float(Self.counter)/Float(Self.count)
		
		Self.x:+Self.v_x
		Self.y:+Self.v_y
		
		'Self.x_scale=2*Self.radius*Float(Self.counter)/Float(Self.count)/Float(ImageWidth(Self.image))
		'Self.y_scale=2*Self.radius*Float(Self.counter)/Float(Self.count)/Float(ImageHeight(Self.image))
		
		Self.x_scale=2*Self.radius*(1.0-0.5*Float(Self.counter)/Float(Self.count))/Float(ImageWidth(Self.image))
		Self.y_scale=2*Self.radius*(1.0-0.5*Float(Self.counter)/Float(Self.count))/Float(ImageHeight(Self.image))
	End Method
End Type

Type SCREEN
	Global x:Int
	Global y:Int
	Global timer:TTIMER
	
	Function ini(x:Int,y:Int,mode:Int=0)
		SCREEN.timer=CreateTimer(25)
		SCREEN.x=x
		SCREEN.y=y
		AppTitle="WURMS"
		
		If mode=1 Then
			Graphics SCREEN.x, SCREEN.y,1
		Else
			Graphics SCREEN.x, SCREEN.y,0
		End If
		
		SetClsColor(0,255,255)
		SetBlend ALPHABLEND
	End Function
End Type

SCREEN.ini(800,600,1)
PLAYER.ini()
OBJEKT.ini()
GRANATE_NORMAL.ini()
RAKETE_NORMAL.ini()
EXPOSIONS.ini()
FEUER_PARTIKEL.ini()
TERRAIN.Create(1000,600,1,1)

Local st:LOCAL_STEUERUNG=LOCAL_STEUERUNG.Create([key_a,key_d,key_w,key_s,key_f,0,key_q,key_e])'0=left, 1=right, 2=jump, 3=usebutton, 4=choose-left, 5=choose-right, 6=traget-left, 7=target-right ...
Global p1:PLAYER=PLAYER.Create(100,30,st)

Local st2:LOCAL_STEUERUNG=LOCAL_STEUERUNG.Create([key_left,key_right,key_up,key_down,KEY_RSHIFT,0,KEY_RALT,KEY_RCONTROL])
Global p2:PLAYER=PLAYER.Create(700,30,st2)

TERRAIN.play()
End
