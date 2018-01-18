SuperStrict

SeedRnd MilliSecs()

Global team_red:Int[] = [255,50,50]
Global team_blue:Int[] = [50,50,255]
Global team_yellow:Int[] = [255,200,0]
Global team_violet:Int[] = [255,0,255]

Global team_green:Int[] = [50,255,50]

Global team_neutral:Int[] = [50,50,50]


Global graphics_x:Int = 1280'DesktopWidth()
Global graphics_y:Int = 750'DesktopHeight()

Global game_size_x:Int = 1200
Global game_size_y:Int = 1000


Graphics graphics_x,graphics_y',32,60

TPlayer.image = LoadImage("plane4.png")
MidHandleImage TPlayer.image

TBombe.image = LoadImage("rocket.png")
MidHandleImage TBombe.image

Effects.ini()

SetImageFont LoadImageFont("arial.ttf",30)

SetBlend lightblend

Global list:TList

Global game_modi:String[] = [..
"Player vs Player (splitscreen)",..
"Player vs Player (singlescreen)",..
"Player vs Computer",..
"Death Match 3 Players (splitscreen)",..
"Death Match 3 Players (singlescreen)",..
"Death Match 4 Players (splitscreen)",..
"Death Match 4 Players (singlescreen)",..
"2 Players vs 2 Computers (splitscreen)",..
"2 Players vs 2 Computers (singlescreen)",..
"Player vs the World",..
"Chaos"]

Global count_pl:Int = 0

Function load_game()
	FlushKeys()
	
	list = New TList
	
	Local play_mode:Int = 0
	
	Repeat
		SetClsColor 0,10,20
		Cls
		
		If KeyHit(key_up) Then play_mode:-1
		If KeyHit(key_down) Then play_mode:+1
		
		If play_mode < 0 Then play_mode = game_modi.length-1
		If play_mode > game_modi.length-1 Then play_mode = 0
		
		For Local i:Int = 0 To game_modi.length-1
			If i = play_mode Then
				SetColor 150+Rand(100),150+Rand(100),150+Rand(100)
			Else
				SetColor 50,100,255
			EndIf
			
			DrawText game_modi[i], 20,20+i*40
		Next
		
		Flip
		
		If KeyHit(key_escape) Then End
	Until KeyHit(key_enter)
	
	Select play_mode
		Case 0'p v p
			count_pl = 2
			
			game_size_x= 1200
			game_size_y= 1000
			
			Local p1:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_left,key_right,KEY_RCONTROL],team_red)
			list.addlast(p1)
			
			Local p2:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_1,key_3,key_2],team_blue)
			list.addlast(p2)
			
			TCamera.cam_list = New TList
			TCamera.cam_list.addlast(TCamera.Create([0,0,graphics_x/2-2,graphics_y],p2))
			TCamera.cam_list.addlast(TCamera.Create([graphics_x/2+2,0,graphics_x/2-2,graphics_y],p1))
		Case 1'p v p
			count_pl = 2
			
			game_size_x= graphics_x
			game_size_y= graphics_y
			
			Local p1:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_left,key_right,KEY_RCONTROL],team_red)
			list.addlast(p1)
			
			Local p2:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_1,key_3,key_2],team_blue)
			list.addlast(p2)
			
			TCamera.cam_list = New TList
			TCamera.cam_list.addlast(TCamera.Create([0,0,graphics_x,graphics_y],Null))
		Case 2'p v c
			game_size_x= 1400
			game_size_y= 1000
		
			count_pl = 1
			
			Local p1:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_left,key_right,KEY_RCONTROL],team_red)
			list.addlast(p1)
			
			list.addlast(TBot.Create_bot(game_size_x/2,game_size_y/2,team_blue))
			
			TCamera.cam_list = New TList
			TCamera.cam_list.addlast(TCamera.Create([0,0,graphics_x,graphics_y],p1))
			
		Case 3'p v p v p
			game_size_x= 1500
			game_size_y= 1200
			
			count_pl = 3
			
			Local p1:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_left,key_right,KEY_RCONTROL],team_red)
			list.addlast(p1)
			
			Local p2:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_1,key_3,key_2],team_blue)
			list.addlast(p2)
			
			Local p3:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_b,key_m,key_n],team_violet)
			list.addlast(p3)
			
			
			TCamera.cam_list = New TList
			TCamera.cam_list.addlast(TCamera.Create([0,0,graphics_x/3*2-2,graphics_y/2-2],p3))
			
			TCamera.cam_list.addlast(TCamera.Create([0,graphics_y/2+2,graphics_x/3*2-2,graphics_y/2-2],p2))
			
			TCamera.cam_list.addlast(TCamera.Create([graphics_x/3*2+2,0,graphics_x/3-2,graphics_y],p1))
		Case 4'p v p v p
			game_size_x= graphics_x
			game_size_y= graphics_y
			
			count_pl = 3
			
			Local p1:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_left,key_right,KEY_RCONTROL],team_red)
			list.addlast(p1)
			
			Local p2:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_1,key_3,key_2],team_blue)
			list.addlast(p2)
			
			Local p3:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_b,key_m,key_n],team_violet)
			list.addlast(p3)
			
			
			TCamera.cam_list = New TList
			TCamera.cam_list.addlast(TCamera.Create([0,0,graphics_x,graphics_y],Null))
			
		Case 5'p v p v p v p
			game_size_x= 1500
			game_size_y= 1200
			
			count_pl = 4
			
			Local p1:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_left,key_right,KEY_RCONTROL],team_red)
			list.addlast(p1)
			
			Local p2:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_1,key_3,key_2],team_blue)
			list.addlast(p2)
			
			Local p3:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_b,key_m,key_n],team_violet)
			list.addlast(p3)
			
			Local p4:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[-1,-2,-3],team_yellow)
			list.addlast(p4)
			
			
			TCamera.cam_list = New TList
			TCamera.cam_list.addlast(TCamera.Create([0,0,graphics_x/2-2,graphics_y/2-2],p2))
			
			TCamera.cam_list.addlast(TCamera.Create([graphics_x/2+2,0,graphics_x/2-2,graphics_y/2-2],p1))
			
			
			TCamera.cam_list.addlast(TCamera.Create([0,graphics_y/2+2,graphics_x/2-2,graphics_y/2-2],p3))
			
			TCamera.cam_list.addlast(TCamera.Create([graphics_x/2+2,graphics_y/2+2,graphics_x/2-2,graphics_y/2-2],p4))
			
		Case 6'p v p v p v p
			game_size_x= graphics_x
			game_size_y= graphics_y
			
			count_pl = 4
			
			Local p1:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_left,key_right,KEY_RCONTROL],team_red)
			list.addlast(p1)
			
			Local p2:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_1,key_3,key_2],team_blue)
			list.addlast(p2)
			
			Local p3:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_b,key_m,key_n],team_violet)
			list.addlast(p3)
			
			Local p4:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[-1,-2,-3],team_yellow)
			list.addlast(p4)
			
			
			TCamera.cam_list = New TList
			TCamera.cam_list.addlast(TCamera.Create([0,0,graphics_x,graphics_y],Null))
		Case 7'p v p v 2c
			game_size_x= 1500
			game_size_y= 1200
			
			count_pl = 2
			
			Local p1:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_left,key_right,KEY_RCONTROL],team_red)
			list.addlast(p1)
			
			Local p2:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_1,key_3,key_2],team_blue)
			list.addlast(p2)
			
			list.addlast(TBot.Create_bot(game_size_x/2,game_size_y/2,team_violet))
			list.addlast(TBot.Create_bot(game_size_x/2,game_size_y/2,team_violet))
			
			TCamera.cam_list = New TList
			TCamera.cam_list.addlast(TCamera.Create([0,0,graphics_x/2-2,graphics_y],p2))
			TCamera.cam_list.addlast(TCamera.Create([graphics_x/2+2,0,graphics_x/2-2,graphics_y],p1))
		Case 8'p v p v 2c
			game_size_x= graphics_x
			game_size_y= graphics_y
			
			count_pl = 2
			
			Local p1:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_left,key_right,KEY_RCONTROL],team_red)
			list.addlast(p1)
			
			Local p2:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_1,key_3,key_2],team_blue)
			list.addlast(p2)
			
			list.addlast(TBot.Create_bot(game_size_x/2,game_size_y/2,team_violet))
			list.addlast(TBot.Create_bot(game_size_x/2,game_size_y/2,team_violet))
			
			TCamera.cam_list = New TList
			TCamera.cam_list.addlast(TCamera.Create([0,0,graphics_x,graphics_y],Null))
		Case 9'p vs the world
			game_size_x= 2000
			game_size_y= 2000
			
			count_pl = 1
			
			Local p1:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_left,key_right,KEY_RCONTROL],team_red)
			list.addlast(p1)
			
			For Local i:Int = 0 To 3
				list.addlast(TBot.Create_bot(game_size_x/2,game_size_y/2,team_blue))
				
				list.addlast(TBot.Create_bot(game_size_x/2,game_size_y/2,team_violet))
				
				list.addlast(TBot.Create_bot(game_size_x/2,game_size_y/2,team_yellow))
				
				list.addlast(TBot.Create_bot(game_size_x/2,game_size_y/2,team_green))
			Next
			
			
			TCamera.cam_list = New TList
			TCamera.cam_list.addlast(TCamera.Create([0,0,graphics_x,graphics_y],p1))
		Case 10'chaos
			game_size_x= 2000
			game_size_y= 2000
			
			count_pl = 1
			
			Local p1:TPlayer = TPlayer.Create(game_size_x/2,game_size_y/2,[key_left,key_right,KEY_RCONTROL],team_red)
			list.addlast(p1)
			
			For Local i:Int = 0 To 15
				list.addlast(TBot.Create_bot(game_size_x/2,game_size_y/2,[Rand(0,255),Rand(0,255),Rand(0,255)]))
			Next
			
			
			TCamera.cam_list = New TList
			TCamera.cam_list.addlast(TCamera.Create([0,0,graphics_x,graphics_y],p1))
	End Select
	
	
	
	For Local i:Int = 0 To 30
		list.addlast(TMuni.Create(Rand(game_size_x),Rand(game_size_y),Rand(2,10)))
	Next
	
	For Local i:Int = 0 To 5
		list.addlast(TLeben.Create(Rand(game_size_x),Rand(game_size_y)))
	Next
	
	For Local i:Int = 0 To 1
		list.addlast(TBombe_muni.Create(Rand(game_size_x),Rand(game_size_y)))
	Next
	
	For Local i:Int = 0 To 12
		list.addlast(THindernis.Create(Rand(game_size_x),Rand(game_size_y),Rand(50,100),team_neutral))
	Next
	
	FlushKeys()
End Function

load_game()



Repeat
	If KeyHit(key_escape) Then load_game()
	
	SetClsColor 50,50,50
	Cls
	
	SetClsColor 5,10,20
	TCamera.clear()
	
	SetBlend alphablend
	SetColor 0,0,0
	TCamera.rect(0,0,game_size_x, game_size_y)
	SetBlend lightblend
	
	
	For Local o:TObject = EachIn list
		o.render()
	Next
	
	Local yy:Int = 0
	
	For Local o:TObject = EachIn list
		o.draw()
		
		If TPlayer(o) Then
			SetColor o.col[0],o.col[1],o.col[2]
			
			SetAlpha 0.1
			DrawRect 2,2+yy*20,200, 18
			
			SetAlpha 0.4
			DrawRect 2,2+yy*20,200*TPlayer(o).points/TPlayer(o).points_max, 18
			
			SetAlpha 0.5
			DrawRect graphics_x-10-TPlayer(o).munition*5,yy*20,TPlayer(o).munition*5,18
			
			SetAlpha 1
			
			yy:+1
		EndIf
		
		
	Next
	
	SetColor team_red[0],team_red[1],team_red[2]
	DrawText "[< Ctrl >]",10,graphics_y-40
	
	If count_pl > 1 Then
		SetColor team_blue[0],team_blue[1],team_blue[2]
		DrawText "[1 2 3]",210,graphics_y-40
	EndIf
	
	If count_pl > 2 Then
		SetColor team_violet[0],team_violet[1],team_violet[2]
		DrawText "[B N M]",410,graphics_y-40
	EndIf
	
	If count_pl > 3 Then
		SetColor team_yellow[0],team_yellow[1],team_yellow[2]
		DrawText "[MOUSE]",610,graphics_y-40
	EndIf
	
	Flip
Forever

'##############################################################################################

Type Effects
	Global schuss:TSound
	Global charge:TSound
	Global up:TSound
	Global dac:TSound
	Global duff:TSound
	Global tot:TSound
	
	Function ini()
		Effects.schuss = LoadSound("audio\schuss1.wav")
		Effects.charge = LoadSound("audio\charge1.wav")
		Effects.up = LoadSound("audio\up.wav")
		Effects.dac = LoadSound("audio\dac.wav")
		Effects.duff  = LoadSound("audio\duff.wav")
		Effects.tot  = LoadSound("audio\tot.wav")
	End Function
End Type

Type TCamera
	
	Global cam_list:TList = New TList
	
	Function Create:TCamera(coordinates:Int[], focus:TObject)
		Local c:TCamera = New TCamera
		
		c.coordinates = coordinates
		c.focus = focus
		
		Return c
	End Function
	
	Field coordinates:Int[]
	
	Field focus:TObject
	
	Function image(img:TImage,x:Float,y:Float)
		For Local c:TCamera = EachIn cam_list
			SetViewport c.coordinates[0],c.coordinates[1],c.coordinates[2],c.coordinates[3]
			
			If c.focus Then
				DrawImage img, x-c.focus.x+c.coordinates[2]/2+c.coordinates[0], y-c.focus.y+c.coordinates[3]/2+c.coordinates[1]
			Else
				DrawImage img, x+c.coordinates[0], y+c.coordinates[1]
			EndIf
		Next
		
		SetViewport 0,0, graphics_x,graphics_y
	End Function
	
	Function oval(x1:Float,y1:Float,x2:Float,y2:Float)
		For Local c:TCamera = EachIn cam_list
			SetViewport c.coordinates[0],c.coordinates[1],c.coordinates[2],c.coordinates[3]
			
			If c.focus Then
				DrawOval x1-c.focus.x+c.coordinates[2]/2+c.coordinates[0], y1-c.focus.y+c.coordinates[3]/2+c.coordinates[1], x2,y2
			Else
				DrawOval x1+c.coordinates[0], y1+c.coordinates[1], x2,y2
			EndIf
		Next
		
		SetViewport 0,0, graphics_x,graphics_y
	End Function
	
	Function rect(x1:Float,y1:Float,x2:Float,y2:Float)
		For Local c:TCamera = EachIn cam_list
			SetViewport c.coordinates[0],c.coordinates[1],c.coordinates[2],c.coordinates[3]
			
			If c.focus Then
				DrawRect x1-c.focus.x+c.coordinates[2]/2+c.coordinates[0], y1-c.focus.y+c.coordinates[3]/2+c.coordinates[1], x2,y2
			Else
				DrawRect x1+c.coordinates[0], y1+c.coordinates[1], x2,y2
			EndIf
		Next
		
		SetViewport 0,0, graphics_x,graphics_y
	End Function
	
	Function clear()
		For Local c:TCamera = EachIn cam_list
			SetViewport c.coordinates[0],c.coordinates[1],c.coordinates[2],c.coordinates[3]
			
			Cls
		Next
		
		SetViewport 0,0, graphics_x,graphics_y
	End Function
End Type

'##############################################################################################

Type TObject
	Field radius:Float
	
	Field x:Float,y:Float
	Field vx:Float,vy:Float
	
	Field col:Int[]
	
	Method draw() Abstract
	Method render() Abstract
End Type

Type TBombe Extends TObject
	Global image:TImage
	
	Global bomb_speed:Float = 10
	Global bomb_time:Int = 120
	
	Global boom_radius:Float = 100
	
	Field count_down:Int
	
	Function Create:TBombe(x:Float,y:Float,direction:Float,speed:Float,col:Int[])
		Local p:TBombe = New TBombe
		p.x = x
		p.y = y
		
		p.vx = Cos(direction)*speed
		p.vy = Sin(direction)*speed
		
		p.radius = 15
		
		p.col = col
		
		p.count_down = TBombe.bomb_time
		
		Return p
	End Function
	
	Method detonate()
		For Local i:Float = 0 To 360 Step 6
			list.addlast(TBall.Create(Self.x,Self.y,i,TBall.ball_speed-Rnd()*5,Self.col))
		Next
		
		PlaySound(Effects.duff)
		
		list.remove(Self)
	End Method
	
	Method render()
		
		Self.count_down:-1
		
		If Self.count_down <= 0 Then
			
			Self.detonate()
			
		Else
			Self.x:+ Self.vx
			Self.y:+ Self.vy
			
			If Self.x > game_size_x Then Self.vx = -Abs(Self.vx)
			If Self.y > game_size_y Then Self.vy = -Abs(Self.vy)
			If Self.x < 0 Then Self.vx = Abs(Self.vx)
			If Self.y < 0 Then Self.vy = Abs(Self.vy)
			
			
			For Local p:TPlayer = EachIn list
				
				If p And p.col <> Self.col Then
					Local distance:Float = Sqr((p.x-Self.x)^2 + (p.y-Self.y)^2)
					
					If distance < Self.radius + p.radius Then
						Self.detonate()
					EndIf
					
					'asdfasdf
					Local winkel:Float = ATan2(p.y-Self.y, p.x-Self.x)
					
					Self.vx:+ Cos(winkel)*0.5
					Self.vy:+ Sin(winkel)*0.5
					
					Local sp:Float = Sqr((Self.vx)^2 + (Self.vy)^2)
					
					If sp > TBombe.bomb_speed Then
						Self.vx:* (TBombe.bomb_speed/sp)
						Self.vy:* (TBombe.bomb_speed/sp)
					EndIf
					'asdfasdf
				End If
			Next
			
			For Local h:THindernis = EachIn list
				
				If h Then
					Local distance:Float = Sqr((h.x-Self.x)^2 + (h.y-Self.y)^2)
					
					If distance < Self.radius + h.radius Then
						Self.detonate()
					EndIf
				End If
			Next
		EndIf
	End Method
	
	Method draw()
		SetColor Rand(255),Rand(100),0
		
		SetAlpha 0.1
		TCamera.oval(Self.x-Self.radius,Self.y-Self.radius,2*Self.radius,2*Self.radius)
		SetAlpha 1
		
		SetRotation ATan2(Self.vy, Self.vx)
		TCamera.image(TBombe.image, Self.x,Self.y)
		SetRotation 0
		
		
	End Method

End Type

Type TBombe_muni Extends TObject
	Function Create:TBombe_muni(x:Float,y:Float)
		Local p:TBombe_muni = New TBombe_muni
		p.x = x
		p.y = y
		
		Local a:Float = Rand(0,360)
		Local s:Float = Rnd()*0.8+0.5
		
		p.vx = Cos(a)*s
		p.vy = Sin(a)*s
		
		p.radius = 8
		
		Return p
	End Function
	
	Method draw()
		SetColor Rand(100),Rand(50),0
		TCamera.oval(Self.x-Self.radius,Self.y-Self.radius,2*Self.radius,2*Self.radius)
	End Method
	
	Method render()
		Self.y:+ Self.vy
		Self.x:+ Self.vx
		
		If Self.x > game_size_x Then Self.vx = -Abs(Self.vx)
		If Self.y > game_size_y Then Self.vy = -Abs(Self.vy)
		If Self.x < 0 Then Self.vx = Abs(Self.vx)
		If Self.y < 0 Then Self.vy = Abs(Self.vy)
		
		For Local o:TObject = EachIn list
			Local p:TPlayer = TPlayer(o)
			
			If p Then
				Local distance:Float = Sqr((p.x-Self.x)^2 + (p.y-Self.y)^2)
				
				If distance < Self.radius + p.radius And Self.col <> p.col Then
					
					p.bomb = 1
					
					PlaySound(Effects.charge)
					
					Self.x = Rand(10,790)
					Self.y = Rand(10,590)
					
					Local a:Float = Rand(0,360)
					Local s:Float = Rnd()*0.5+0.3
					
					Self.vx = Cos(a)*s
					Self.vy = Sin(a)*s
				EndIf
			End If
		Next
	End Method
End Type

Type TLeben Extends TObject
	Function Create:TLeben(x:Float,y:Float)
		Local p:TLeben = New TLeben
		p.x = x
		p.y = y
		
		Local a:Float = Rand(0,360)
		Local s:Float = Rnd()*0.8+0.5
		
		p.vx = Cos(a)*s
		p.vy = Sin(a)*s
		
		p.radius = 8
		
		Return p
	End Function
	
	Method draw()
		SetColor 0,Rand(100),0
		TCamera.oval(Self.x-Self.radius,Self.y-Self.radius,2*Self.radius,2*Self.radius)
	End Method
	
	Method render()
		Self.y:+ Self.vy
		Self.x:+ Self.vx
		
		If Self.x > game_size_x Then Self.vx = -Abs(Self.vx)
		If Self.y > game_size_y Then Self.vy = -Abs(Self.vy)
		If Self.x < 0 Then Self.vx = Abs(Self.vx)
		If Self.y < 0 Then Self.vy = Abs(Self.vy)
		
		For Local o:TObject = EachIn list
			Local p:TPlayer = TPlayer(o)
			
			If p Then
				Local distance:Float = Sqr((p.x-Self.x)^2 + (p.y-Self.y)^2)
				
				If distance < Self.radius + p.radius And Self.col <> p.col Then
					
					p.points:+8
					
					PlaySound(Effects.up)
					
					Self.x = Rand(10,790)
					Self.y = Rand(10,590)
					
					Local a:Float = Rand(0,360)
					Local s:Float = Rnd()*0.5+0.3
					
					Self.vx = Cos(a)*s
					Self.vy = Sin(a)*s
				EndIf
			End If
		Next
	End Method
End Type

Type THindernis Extends TObject
	Function Create:THindernis(x:Float,y:Float,radius:Float,col:Int[])
		Local p:THindernis = New THindernis
		p.x = x
		p.y = y
		
		p.radius = radius
		
		p.col = col
		
		Local a:Float = Rand(0,360)
		Local s:Float = Rnd()*0.3+0.2
		
		p.vx = Cos(a)*s
		p.vy = Sin(a)*s
				
		Return p
	End Function
	
	Method draw()
		SetColor Self.col[0],Self.col[1],Self.col[2]
		TCamera.oval(Self.x-Self.radius,Self.y-Self.radius,2*Self.radius,2*Self.radius)
	End Method
	
	Method render()
		Self.y:+ Self.vy
		Self.x:+ Self.vx
		
		If Self.x > game_size_x Then Self.vx = -Abs(Self.vx)
		If Self.y > game_size_y Then Self.vy = -Abs(Self.vy)
		If Self.x < 0 Then Self.vx = Abs(Self.vx)
		If Self.y < 0 Then Self.vy = Abs(Self.vy)
		
		
		For Local o:TObject = EachIn list
			Local p:TPlayer = TPlayer(o)
			
			If p Then
				
				Local distance:Float = Sqr((p.x-Self.x)^2 + (p.y-Self.y)^2)
				
				If distance < Self.radius + p.radius Then
					
					Local winkel:Float = ATan2(p.y-Self.y, p.x-Self.x)
					
					Local speed:Float = Self.radius + p.radius-distance
					
					p.x:+ Cos(winkel)*speed
					p.y:+ Sin(winkel)*speed
				EndIf
			End If
			
			Local b:TBall = TBall(o)
			
			If b Then
				Local distance:Float = Sqr((b.x-Self.x)^2 + (b.y-Self.y)^2)
				
				If distance < Self.radius + b.radius Then
					
					list.remove(b)
				EndIf
			EndIf
		Next
	End Method
End Type

Type TMuni Extends TObject
	Field size:Int
	
	Function Create:TMuni(x:Float,y:Float,size:Int)
		Local p:TMuni = New TMuni
		p.x = x
		p.y = y
		
		Local a:Float = Rand(0,360)
		Local s:Float = Rnd()*0.5+0.3
		
		p.vx = Cos(a)*s
		p.vy = Sin(a)*s
		
		p.size = size
		
		p.radius = size/2 + 2
		
		Return p
	End Function
	
	Method draw()
		SetColor Rand(100),Rand(100),Rand(100)
		TCamera.oval(Self.x-Self.radius,Self.y-Self.radius,2*Self.radius,2*Self.radius)
	End Method
	
	Method render()
		Self.y:+ Self.vy
		Self.x:+ Self.vx
		
		If Self.x > game_size_x Then Self.vx = -Abs(Self.vx)
		If Self.y > game_size_y Then Self.vy = -Abs(Self.vy)
		If Self.x < 0 Then Self.vx = Abs(Self.vx)
		If Self.y < 0 Then Self.vy = Abs(Self.vy)
		
		For Local o:TObject = EachIn list
			Local p:TPlayer = TPlayer(o)
			
			If p Then
				Local distance:Float = Sqr((p.x-Self.x)^2 + (p.y-Self.y)^2)
				
				If distance < Self.radius + p.radius And Self.col <> p.col Then
					
					p.munition:+ Self.size
					
					Self.x = Rand(10,790)
					Self.y = Rand(10,590)
					
					Local a:Float = Rand(0,360)
					Local s:Float = Rnd()*0.5+0.3
					
					Self.vx = Cos(a)*s
					Self.vy = Sin(a)*s
					
				EndIf
			End If
		Next
	End Method
End Type

Type TBall Extends TObject
	Global ball_speed:Float = 10
	
	Function Create:TBall(x:Float,y:Float,direction:Float,speed:Float,col:Int[])
		Local p:TBall = New TBall
		p.x = x
		p.y = y
		
		p.vx = Cos(direction)*speed
		p.vy = Sin(direction)*speed
		
		p.col = col
		
		p.radius = 2
		
		Return p
	End Function
	
	Method render()
		Self.x:+ Self.vx
		Self.y:+ Self.vy
		
		If Self.x > game_size_x Then list.remove(Self)
		If Self.y > game_size_y Then list.remove(Self)
		If Self.x < 0 Then list.remove(Self)
		If Self.y < 0 Then list.remove(Self)
		
		For Local o:TObject = EachIn list
			Local p:TPlayer = TPlayer(o)
			
			If p Then
				Local distance:Float = Sqr((p.x-Self.x)^2 + (p.y-Self.y)^2)
				
				If distance < Self.radius + p.radius And Self.col <> p.col Then
					
					p.points:- 1
					
					list.remove(Self)
				EndIf
			End If
		Next
	End Method
	
	Method draw()
		SetColor Self.col[0],Self.col[1],Self.col[2]
		TCamera.oval(Self.x-Self.radius,Self.y-Self.radius,2*Self.radius,2*Self.radius)
	End Method
End Type

Type TPlayer Extends TObject
	Global image:TImage
	
	Global radius:Float = 20
	Global brakes_factor:Float = 0.9
	Global acceleration:Float = 0.5
	Global angle_acceleration:Float = 1.0
	Global angle_brakes_factor:Float = 0.9
	
	'Global velo_max:Float = 100
	
	Function Create:TPlayer(x:Float,y:Float,keyes:Int[],col:Int[])
		Local p:TPlayer = New TPlayer
		
		p.x = x
		p.y = y
		p.keyes = keyes
		p.col = col
		
		p.r = Rand(0,360)
		
		Return p
	End Function
	
	Field points_max:Int = 100
	Field points:Float = points_max
	
	Field r:Float
	Field vr:Float
	
	Field keyes:Int[]
	
	Field shoot_countdown:Int = 0
	
	Field munition:Int = 0
	
	Field bomb:Int = 0
	
	Method render()
		
		If Self.munition > 30 Then Self.munition = 30
		If Self.points > Self.points_max Then Self.points = Self.points_max
		
		Self.vx:+ Cos(Self.r)*Self.acceleration
		Self.vy:+ Sin(Self.r)*Self.acceleration
		
		If (Self.keyes[0]=-1 And MouseDown(1)) Or (Self.keyes[0]>0 And KeyDown(Self.keyes[0])) Then
			Self.vr:- Self.angle_acceleration
		EndIf
		
		If (Self.keyes[1]=-2 And MouseDown(2)) Or (Self.keyes[1]>0 And KeyDown(Self.keyes[1])) Then
			Self.vr:+ Self.angle_acceleration
		EndIf
		
		
		If (Self.keyes[2]=-3 And MouseDown(3)) Or (Self.keyes[2]>0 And KeyDown(Self.keyes[2])) Then
			
			Self.shoot()
		EndIf
		
		Self.shoot_countdown:-1
		
		Local velo:Float = Sqr(Self.vx^2+Self.vy^2)
		
		
		Self.vx:*0.92
		Self.vy:*0.92
		Self.vr:*0.8
		
		
		Self.r:+ Self.vr
		Self.x:+ Self.vx
		Self.y:+ Self.vy
		
		
		If Self.x > game_size_x Then Self.vx = -1
		If Self.y > game_size_y Then Self.vy = -1
		If Self.x < 0 Then Self.vx = 1
		If Self.y < 0 Then Self.vy = 1
		
		If Self.points < 1 Then
			list.remove(Self)
			PlaySound(Effects.tot)
		EndIf
	End Method
	
	Method shoot()
		If Self.bomb = 1 Then
			
			Self.bomb = 0
			
			list.addlast(TBombe.Create(Self.x,Self.y,Self.r,TBombe.bomb_speed, Self.col))
			
			PlaySound(Effects.schuss)
			
		ElseIf Self.munition > 0 Then
			
			If Self.shoot_countdown < 0 Then
				Self.shoot_countdown = 5
				Self.munition:-1
				
				For Local i:Int = -6 To 6 Step 2
					list.addlast(TBall.Create(Self.x,Self.y,Self.r+i,TBall.ball_speed,Self.col))
				Next
			EndIf
		EndIf
	End Method
	
	Method draw()
		SetColor Self.col[0],Self.col[1],Self.col[2]
		
		SetAlpha 0.05
		TCamera.oval(x-Self.radius,y-Self.radius,2*Self.radius,2*Self.radius)
		
		SetAlpha 1
		SetRotation Self.r
		TCamera.image(TPlayer.image,Self.x,Self.y)
		'TPoly.jet.draw(Self.x,Self.y,Self.r,Self.radius)
		
		SetRotation 0
		
		'DrawLine x,y,x+Cos(Self.r)*Self.radius,y+Sin(Self.r)*Self.radius
	End Method
End Type

Type TBot Extends TPlayer
	
	Function Create_bot:TBot(x:Float,y:Float,col:Int[])
		Local p:TBot = New TBot
		
		p.x = x
		p.y = y
		p.col = col
		
		p.r = Rand(0,360)
		
		Return p
	End Function
	
	Method sensor_player:Float()
		Local sens_1:Float = 100000
		Local sens_2:Float = 100000
		
		Local sens_1_x:Float = Self.x + Cos(Self.r+90)*0.5
		Local sens_1_y:Float = Self.y + Sin(Self.r+90)*0.5
		
		Local sens_2_x:Float = Self.x + Cos(Self.r-90)*0.5
		Local sens_2_y:Float = Self.y + Sin(Self.r-90)*0.5
		
		For Local p:TPlayer = EachIn list
			If p.col <> Self.col Then
				Local d1:Float = Sqr((p.x-sens_1_x)^2 + (p.y-sens_1_y)^2)
				Local d2:Float = Sqr((p.x-sens_2_x)^2 + (p.y-sens_2_y)^2)
				
				If d1 < sens_1 Then sens_1 = d1
				If d2 < sens_2 Then sens_2 = d2
				
			EndIf
		Next
		
		Return sens_1 - sens_2
	End Method
	
	Method sensor_player_distance:Float()
		Local sens_1:Float = 100000
		
		Local sens_1_x:Float = Self.x
		Local sens_1_y:Float = Self.y
		
		For Local p:TPlayer = EachIn list
			If p.col <> Self.col Then
				Local d1:Float = Sqr((p.x-sens_1_x)^2 + (p.y-sens_1_y)^2)
				
				If d1 < sens_1 Then sens_1 = d1
				
			EndIf
		Next
		
		Return sens_1
	End Method
	
	
	
	Method sensor_muni:Float()
		Local sens_1:Float = 100000
		Local sens_2:Float = 100000
		
		Local sens_1_x:Float = Self.x + Cos(Self.r+90)*0.5
		Local sens_1_y:Float = Self.y + Sin(Self.r+90)*0.5
		
		Local sens_2_x:Float = Self.x + Cos(Self.r-90)*0.5
		Local sens_2_y:Float = Self.y + Sin(Self.r-90)*0.5
		
		For Local p:TMuni = EachIn list
			If p.col <> Self.col Then
				Local d1:Float = Sqr((p.x-sens_1_x)^2 + (p.y-sens_1_y)^2)
				Local d2:Float = Sqr((p.x-sens_2_x)^2 + (p.y-sens_2_y)^2)
				
				If d1 < sens_1 Then sens_1 = d1
				If d2 < sens_2 Then sens_2 = d2
				
			EndIf
		Next
		
		Return sens_1 - sens_2
	End Method
	
	Method sensor_leben:Float()
		Local sens_1:Float = 100000
		Local sens_2:Float = 100000
		
		Local sens_1_x:Float = Self.x + Cos(Self.r+90)*0.5
		Local sens_1_y:Float = Self.y + Sin(Self.r+90)*0.5
		
		Local sens_2_x:Float = Self.x + Cos(Self.r-90)*0.5
		Local sens_2_y:Float = Self.y + Sin(Self.r-90)*0.5
		
		For Local p:TLeben = EachIn list
			If p.col <> Self.col Then
				Local d1:Float = Sqr((p.x-sens_1_x)^2 + (p.y-sens_1_y)^2)
				Local d2:Float = Sqr((p.x-sens_2_x)^2 + (p.y-sens_2_y)^2)
				
				If d1 < sens_1 Then sens_1 = d1
				If d2 < sens_2 Then sens_2 = d2
				
			EndIf
		Next
		
		Return sens_1 - sens_2
	End Method
	
	Method sensor_bombe:Float()
		Local sens_1:Float = 100000
		Local sens_2:Float = 100000
		
		Local sens_1_x:Float = Self.x + Cos(Self.r+90)*0.5
		Local sens_1_y:Float = Self.y + Sin(Self.r+90)*0.5
		
		Local sens_2_x:Float = Self.x + Cos(Self.r-90)*0.5
		Local sens_2_y:Float = Self.y + Sin(Self.r-90)*0.5
		
		For Local p:TBombe = EachIn list
			If p.col <> Self.col Then
				Local d1:Float = Sqr((p.x-sens_1_x)^2 + (p.y-sens_1_y)^2)
				Local d2:Float = Sqr((p.x-sens_2_x)^2 + (p.y-sens_2_y)^2)
				
				If d1 < sens_1 Then sens_1 = d1
				If d2 < sens_2 Then sens_2 = d2
				
			EndIf
		Next
		
		Return sens_1 - sens_2
	End Method
	
	Method sensor_bombe_distance:Float()
		Local sens_1:Float = 100000
		
		Local sens_1_x:Float = Self.x
		Local sens_1_y:Float = Self.y
		
		For Local p:TBombe = EachIn list
			If p.col <> Self.col Then
				Local d1:Float = Sqr((p.x-sens_1_x)^2 + (p.y-sens_1_y)^2)
				
				If d1 < sens_1 Then sens_1 = d1
				
			EndIf
		Next
		
		Return sens_1
	End Method
	
	Method sensor_bombmuni:Float()
		Local sens_1:Float = 100000
		Local sens_2:Float = 100000
		
		Local sens_1_x:Float = Self.x + Cos(Self.r+90)*0.5
		Local sens_1_y:Float = Self.y + Sin(Self.r+90)*0.5
		
		Local sens_2_x:Float = Self.x + Cos(Self.r-90)*0.5
		Local sens_2_y:Float = Self.y + Sin(Self.r-90)*0.5
		
		For Local p:TBombe_muni = EachIn list
			If p.col <> Self.col Then
				Local d1:Float = Sqr((p.x-sens_1_x)^2 + (p.y-sens_1_y)^2)
				Local d2:Float = Sqr((p.x-sens_2_x)^2 + (p.y-sens_2_y)^2)
				
				If d1 < sens_1 Then sens_1 = d1
				If d2 < sens_2 Then sens_2 = d2
				
			EndIf
		Next
		
		Return sens_1 - sens_2
	End Method
	
	Field mode:Int = 0
	
	'0 = find muni
	'1 = shoot player
	'2 = bomb attack
	'3 = find bomb muni
	'4 = lebens suchen
	'5 = avoid bomb - does not work!
	
	Method render()
		
		If Self.points > Self.points_max Then Self.points = Self.points_max
		
		Self.vx:+ Cos(Self.r)*Self.acceleration
		Self.vy:+ Sin(Self.r)*Self.acceleration
		
		If Self.munition < 1 Then Self.mode = 3*Rand(0,1)
		If Self.munition > 10 Then Self.mode = 1
		If Self.bomb Then Self.mode = 2
		If Self.points < 50 Then Self.mode = 4
		
		If Self.sensor_bombe_distance() < 300 Or (Abs(Self.sensor_bombe()) < 0.2 And Self.sensor_bombe_distance() < 500) Then Self.mode = 5
		
		Select Self.mode
			Case 0
				If Self.sensor_muni() > 0 Then
					Self.vr:- Self.angle_acceleration
				Else
					Self.vr:+ Self.angle_acceleration
				EndIf
			Case 1
				If Self.sensor_player() > 0 Then
					Self.vr:- Self.angle_acceleration
				Else
					Self.vr:+ Self.angle_acceleration
				EndIf
				
				If Abs(Self.sensor_player())<0.05 Then Self.shoot()
			Case 2
				If Self.sensor_player() > 0 Then
					Self.vr:- Self.angle_acceleration
				Else
					Self.vr:+ Self.angle_acceleration
				EndIf
				
				If Abs(Self.sensor_player())<0.2 And Abs(Self.sensor_player_distance())<400 Then Self.shoot()
			Case 3
				If Self.sensor_bombmuni() > 0 Then
					Self.vr:- Self.angle_acceleration
				Else
					Self.vr:+ Self.angle_acceleration
				EndIf
			Case 4
				If Self.sensor_leben() > 0 Then
					Self.vr:- Self.angle_acceleration
				Else
					Self.vr:+ Self.angle_acceleration
				EndIf
			Case 5
				If Self.sensor_bombe() > 0 Then
					Self.vr:+ Self.angle_acceleration
				Else
					Self.vr:- Self.angle_acceleration
				EndIf
		End Select
		
		Self.shoot_countdown:-1
		
		Self.vx:*0.92
		Self.vy:*0.92
		Self.vr:*0.8
		
		
		Self.r:+ Self.vr
		Self.x:+ Self.vx
		Self.y:+ Self.vy
		
		
		If Self.x > game_size_x Then Self.vx = -1
		If Self.y > game_size_y Then Self.vy = -1
		If Self.x < 0 Then Self.vx = 1
		If Self.y < 0 Then Self.vy = 1
		
		
		If Self.points < 1 Then
			list.remove(Self)
			PlaySound(Effects.tot)
		EndIf
		
	End Method
End Type