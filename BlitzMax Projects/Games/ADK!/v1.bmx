SuperStrict

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

Type TERRAIN
	Global image:TImage
	Global pixmap:TPixmap
	
	Global back_image:TImage
	
	Function load(name:String)
		TERRAIN.back_image=LoadImage("map\"+name+"\back.png")
		TERRAIN.image=LoadImage("map\"+name+"\front.png")
	End Function
	
	Function draw()
		SetRotation 0
		SetColor 255,255,255
		SetAlpha 1
		DrawImage TERRAIN.back_image,0,0
		DrawImage TERRAIN.image,0,0
	End Function
	
	Function lock()
		TERRAIN.pixmap=LockImage(TERRAIN.image)
	End Function
	
	Function unlock()
		UnlockImage(TERRAIN.image)
	End Function
End Type

Type GFX
	Global image_head:TImage
	Global image_schwanz:TImage
	Global image_home:TImage
	'Global image_:TImage
	
	Function ini()
		GFX.image_head=LoadImage("gfx\head.png")
		MidHandleImage GFX.image_head
		GFX.image_schwanz=LoadImage("gfx\schwanz.png")
		MidHandleImage GFX.image_schwanz
		
		GFX.image_home=LoadImage("gfx\home.png")
		MidHandleImage GFX.image_home
	End Function
End Type

Type TPLAYER
	Global liste:TList
	
	Field x:Float
	Field y:Float
	Field w:Float
	Field speed:Float
	Field speed_w:Float
	Field color:Int[3]
	
	Field home_x:Float
	Field home_y:Float
	Field home_w:Float
	
	Field count:Float
	
	Field home_r:Float
	
	Field punkte:Int=0
	
	Field schwanz_liste:TList
	
	Field k_left:Int
	Field k_right:Int
	
	Method New()
		TPLAYER.liste.addlast(Self)
	End Method
	
	Function init(player:TPLAYER,x:Float,y:Float,w:Float,speed:Float,speed_w:Float,r:Int,g:Int,b:Int,home_r:Float,k_left:Int,k_right:Int)
		player.x=x
		player.y=y
		
		player.home_x=x
		player.home_y=y
		player.home_w=w
		player.home_r=home_r
		
		player.speed=speed
		player.speed_w=speed_w
		player.color[0]=r
		player.color[1]=g
		player.color[2]=b
		player.w=w
		player.punkte=0
		
		player.k_left=k_left
		player.k_right=k_right
		
		player.schwanz_liste=New TList
		
		player.count=0
	End Function
	
	Method go_home()
		Self.schwanz_liste=New TList
		
		Self.x=Self.home_x
		Self.y=Self.home_y
		Self.w=Self.home_w
	End Method
	
	Method render()
		If KeyDown(Self.k_left) Then Self.w:-Self.speed_w
		If KeyDown(Self.k_right) Then Self.w:+Self.speed_w
		
		Self.x:+Cos(Self.w)*Self.speed
		Self.y:+Sin(Self.w)*Self.speed
		
		Self.count:+Self.speed
		If Self.count>=8 Then
			Self.schwanz_liste.addlast(TSCHWANZ.create(Self.x,Self.y,Self.w))
			Self.count=0
		End If
		
		For Local p:TPLAYER = EachIn TPLAYER.liste
			For Local s:TSCHWANZ=EachIn p.schwanz_liste
				If Sqr((s.x-Self.x)^2+(s.y-Self.y)^2)<10 And Not (p=Self And s.counter*p.speed<15) Then
					Self.go_home()
					
					If (p=Self) Then
						Self.punkte:-2
					Else
						Self.punkte:-1
						p.punkte:+3
					End If
				End If
			Next
			
			If Not (p=Self) Then
				If Sqr((p.home_x-Self.x)^2+(p.home_y-Self.y)^2)<p.home_r Then
					Self.go_home()
					
					Self.punkte:-3
					p.punkte:+5
				End If
			End If
		Next
		
		If PIXELS.a(ReadPixel(TERRAIN.pixmap,Self.x,Self.y))>0 Then
			Self.go_home()
			Self.punkte:-1
		End If
		
		For Local s:TSCHWANZ=EachIn Self.schwanz_liste
			s.render()
		Next
		
	End Method
		
	Method draw()
		SetColor Self.color[0],Self.color[1],Self.color[2]
		
		SetRotation MilliSecs()/10.0
		SetAlpha 0.5
		DrawImage GFX.image_home,Self.home_x,Self.home_y
		
		SetRotation 0
		SetAlpha 1
		DrawText Self.punkte,Self.home_x-10,Self.home_y+2
		
		SetAlpha 0.5
		For Local s:TSCHWANZ=EachIn Self.schwanz_liste
			SetRotation s.w+90
			DrawImage GFX.image_schwanz,s.x,s.y
		Next
		
		SetAlpha 0.8
		SetRotation Self.w+90
		DrawImage GFX.image_head,Self.x,Self.y
	End Method
End Type

Type TSCHWANZ
	Field w:Float
	Field x:Float
	Field y:Float
	Field counter:Int=0
	Function create:TSCHWANZ(x:Float,y:Float,w:Float)
		Local s:TSCHWANZ=New TSCHWANZ
		s.x=x
		s.y=y
		s.w=w
		Return s
	End Function
	
	Method render()
		Self.counter:+1
	End Method
End Type

'INI #################
Graphics 800,600
SetBlend ALPHABLEND

GFX.ini()
TPLAYER.liste=New TList

'LOAD ################
TERRAIN.load("m2")

TPLAYER.init((New TPLAYER),700,100,180,1,8,255,50,50,25,key_left,key_right)
TPLAYER.init((New TPLAYER),100,100,0,1,7,0,255,0,25,key_1,key_2)
'TPLAYER.init((New TPLAYER),400,500,2,5,255,255,0,25,key_n,key_m)

'PLAY ################

Repeat
	Cls
	'RENDER
	TERRAIN.lock()
	
	For Local player:TPLAYER=EachIn TPLAYER.liste
		player.render()
	Next
	
	TERRAIN.unlock()
	'DRAW
	TERRAIN.draw()
	
	For Local player:TPLAYER=EachIn TPLAYER.liste
		player.draw()
	Next
	
	Flip
Until KeyHit(key_escape) Or AppTerminate()