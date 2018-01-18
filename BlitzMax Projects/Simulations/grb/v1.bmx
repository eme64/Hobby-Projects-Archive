SuperStrict

'Import "-ldl"


Graphics 800,600,32,0

Local gr:TGrid = TGrid.Create(200,200)

Repeat
	If KeyDown(key_enter) Then gr = TGrid.Create(200,200)	
	If KeyDown(key_space) Then gr.render()
	
	Cls
	
	gr.draw(3)
	
	Flip
Until KeyHit(key_escape) Or AppTerminate()

'######################################3

Type TGrid
	Field x:Int
	Field y:Int
	
	Field data:Int[x,y]
	
	Function Create:TGrid(x:Int,y:Int)
		Local g:TGrid = New TGrid
		
		g.x = x
		g.y = y
		
		g.data = New Int[x,y]
		
		For Local xx:Int = 0 To x-1
			For Local yy:Int = 0 To y-1
				g.data[xx,yy] = 0'Rand(0,2)
			Next
		Next
		
		Return g
	End Function
	
	Method get:Int(x:Int,y:Int)
		Return Self.data[(x+Self.x) Mod Self.x,(y+Self.y) Mod Self.y]
	End Method
	
	Method get_new:Int(x:Int,y:Int)
		Local c:Int[3]
		
		For Local xx:Int = -1 To 1
			For Local yy:Int = -1 To 1
				If Not (xx = 0 And yy = 0) Then c[Self.get(x+xx,y+yy)]:+1
			Next
		Next
		
		Select Self.get(x,y)
			Case 0
				If c[1] > c[2] Then Return 1
			Case 1
				If c[2] > c[0] Then Return 2
			Case 2
				If c[0] > c[1] Then Return 0
		End Select
		
		Return Self.get(x,y)
	End Method
	
	Method render()
		Local ndata:Int[,] = New Int[x,y]
		
		For Local xx:Int = 0 To x-1
			For Local yy:Int = 0 To y-1
				ndata[xx,yy] = Self.get_new(xx,yy)
			Next
		Next
		
		Self.data = ndata
	End Method
	
	Method draw(side:Int)
		For Local xx:Int = 0 To Self.x-1
			For Local yy:Int = 0 To Self.y-1
				Select Self.data[xx,yy]
					Case 0
						SetColor 255,0,0
					Case 1
						SetColor 0,255,0
					Case 2
						SetColor 0,0,255
				End Select
				
				DrawRect xx*side, yy*side, side,side
			Next
		Next
		
		
		
		If MouseDown(3) Then Self.data[MouseX()/side, MouseY()/side] = 0
		If MouseDown(1) Then Self.data[MouseX()/side, MouseY()/side] = 1
		If MouseDown(2) Then Self.data[MouseX()/side, MouseY()/side] = 2
	End Method
End Type