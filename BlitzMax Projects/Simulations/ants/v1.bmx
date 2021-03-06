SuperStrict

Type TGrid
	Field x:Int,y:Int
	Field data:TData[x,y]
	
	Field cycle:Int
	
	Field delivery:Int
	
	Method draw(side:Int)
		For Local xx:Int = 0 To Self.x-1
			For Local yy:Int = 0 To Self.y-1
				Self.data[xx,yy].draw(side-1, xx*side,yy*side)
			Next
		Next
		
		SetColor 255,255,255
		DrawText Self.delivery,2,2
	End Method
	
	Method render()
		Self.cycle:+ 1
		
		Select Rand(0,1)
			Case 0
				Select Rand(0,1)
					Case 0
						For Local xx:Int = 0 To Self.x-1
							For Local yy:Int = 0 To Self.y-1
								Self.data[xx,yy].render(Self,xx,yy)
							Next
						Next
					Case 1
						For Local xx:Int = Self.x-1 To 0 Step -1
							For Local yy:Int = 0 To Self.y-1
								Self.data[xx,yy].render(Self,xx,yy)
							Next
						Next
				End Select
			Case 1
				Select Rand(0,1)
					Case 0
						For Local xx:Int = 0 To Self.x-1
							For Local yy:Int = Self.y-1 To 0 Step -1
								Self.data[xx,yy].render(Self,xx,yy)
							Next
						Next
					Case 1
						For Local xx:Int = Self.x-1 To 0 Step -1
							For Local yy:Int = Self.y-1 To 0 Step -1
								Self.data[xx,yy].render(Self,xx,yy)
							Next
						Next
				End Select
		End Select
		
		
	End Method
	
	Function Create:TGrid(x:Int,y:Int, food:Int, ants:Int)
		Local g:TGrid = New TGrid
		
		g.x = x
		g.y = y
		
		g.data = New TData[g.x, g.y]
		
		For Local xx:Int = 0 To g.x-1
			For Local yy:Int = 0 To g.y-1
				g.data[xx,yy] = New TData
			Next
		Next
		
		'home
		
		Local home_count:Int
		
		While home_count < 5
			Local xx:Int = x/5 + Rand(-4,4)
			Local yy:Int = y/5 + Rand(-4,4)
			
			If g.data[xx,yy].actor = Null
				g.data[xx,yy].actor = New THome
				home_count:+1
			EndIf
		Wend
		
		'food
		
		Local food_count:Int
		
		While food_count < 5
			Local xx:Int = x*4/5 + Rand(-4,4)
			Local yy:Int = y*4/5 + Rand(-4,4)
			If g.data[xx,yy].actor = Null
				g.data[xx,yy].actor = New TFood
				food_count:+1
			EndIf
		Wend
		
		'ants
		
		Local ant_count:Int
		
		While ant_count < ants
			Local xx:Int = Rand(0,g.x-1)
			Local yy:Int = Rand(0,g.y-1)
			If g.data[xx,yy].actor = Null
				g.data[xx,yy].actor = New TAnt
				ant_count:+1
			EndIf
		Wend
		
		Return g
	End Function
End Type

Type TData
	Field m_food:Double
	Field m_home:Double
	
	Field actor:TActor
	
	Method draw(side:Int, x:Int, y:Int)
		SetColor Self.m_food+30,Self.m_home+30,30
		DrawRect x,y, side, side
		
		If Self.actor <> Null Then
			Self.actor.draw(side,x,y)
		EndIf
	End Method
	
	Method render(g:TGrid,x:Int,y:Int)
		
		Rem
		If Self.m_food > 0 And Self.m_home > 0 Then
			Local small:Double = Min(Self.m_food,Self.m_home)
			
			Self.m_food:- small/10.0
			Self.m_home:- small/10.0
		EndIf
		End Rem
		
		Self.m_food:*0.995
		If Self.m_food < 0 Then Self.m_food = 0
		If Self.m_food > 255 Then Self.m_food = 255
		
		Self.m_home:*0.995
		If Self.m_home < 0 Then Self.m_home = 0
		If Self.m_home > 255 Then Self.m_home = 255
		
		If Self.actor <> Null Then Self.actor.render(g,x,y)
		
	End Method
End Type

Type TActor
	Method draw(side:Int, x:Int, y:Int)
		'empty
	End Method
	
	Method render(g:TGrid,x:Int,y:Int)
		'empty
	End Method
End Type

Type THome Extends TActor
	Method draw(side:Int, x:Int, y:Int)
		SetColor 0,255,255
		DrawRect x+1,y+1, side-2, side-2
	End Method
	
	Method render(g:TGrid,x:Int,y:Int)
		
		
		For Local xx:Int = x-3 To x+3
			For Local yy:Int = y-3 To y+3
				If xx >= 0 And yy >= 0 And xx < g.x And yy < g.y Then
					Local d:Float = (x-xx)^2 + (y-yy)^2
					
					If d<=9 Then
						g.data[xx,yy].m_home:+0.1/d
					EndIf
				EndIf
			Next
		Next
		
	End Method
End Type

Type TFood Extends TActor
	Method draw(side:Int, x:Int, y:Int)
		SetColor 255,255,255
		DrawRect x+1,y+1, side-2, side-2
	End Method
	
	Method render(g:TGrid,x:Int,y:Int)
		
		For Local xx:Int = x-3 To x+3
			For Local yy:Int = y-3 To y+3
				If xx >= 0 And yy >= 0 And xx < g.x And yy < g.y Then
					Local d:Float = (x-xx)^2 + (y-yy)^2
					
					If d<=9 Then
						g.data[xx,yy].m_food:+0.1/d
					EndIf
				EndIf
			Next
		Next
		
	End Method
End Type

Type TAnt Extends TActor
	Method New()
		Self.task = Rand(0,1)
	End Method
	
	Global min_value:Double = 0.2
	Global add_value:Double = 5.0
	
	
	Field task:Int'0 = food, 1 = home
	Field cycle:Int
	
	Field last_dir:Int = -1
	
	Method draw(side:Int, x:Int, y:Int)
		Select Self.task
			Case 0
				SetColor 50+Rand(0,205),50,50
			Case 1
				SetColor 50,50+Rand(0,205),50
		End Select
		DrawRect x+1,y+1, side-2, side-2
	End Method
	
	Method render(g:TGrid,x:Int,y:Int)
		If g.cycle > Self.cycle Then
			Self.cycle = g.cycle
			
			Local dir:Float[4]' = [0,0,0,0]
			
			Select Self.task
				Case 0
					g.data[x,y].m_food:+TAnt.add_value
					
					'up
					If y > 0 Then
						dir[0] = g.data[x,y-1].m_food + TAnt.min_value
						
						If g.data[x,y-1].actor <> Null Then
							If TFood(g.data[x,y-1].actor) Then
								Self.task = 1
							EndIf
							
							dir[0] = 0
						EndIf
					Else
						dir[0] = 0
					EndIf
					
					
					'right
					If x < g.x-1 Then
						dir[1] = g.data[x+1,y].m_food + TAnt.min_value
						
						If g.data[x+1,y].actor <> Null Then
							If TFood(g.data[x+1,y].actor) Then
								Self.task = 1
							EndIf
							
							dir[1] = 0
						EndIf
					Else
						dir[1] = 0
					EndIf
					
					'down
					If y < g.y-1 Then
						dir[2] = g.data[x,y+1].m_food + TAnt.min_value
						
						If g.data[x,y+1].actor <> Null Then
							If TFood(g.data[x,y+1].actor) Then
								Self.task = 1
							EndIf
							
							dir[2] = 0
						EndIf
					Else
						dir[2] = 0
					EndIf
					
					'left
					If x > 0 Then
						dir[3] = g.data[x-1,y].m_food + TAnt.min_value
						
						If g.data[x-1,y].actor <> Null Then
							If TFood(g.data[x-1,y].actor) Then
								Self.task = 1
							EndIf
							
							dir[3] = 0
						EndIf
					Else
						dir[3] = 0
					EndIf
					
					
				Case 1
					g.data[x,y].m_home:+TAnt.add_value
					
					'up
					If y > 0 Then
						dir[0] = g.data[x,y-1].m_home + TAnt.min_value
						
						If g.data[x,y-1].actor <> Null Then
							If THome(g.data[x,y-1].actor) Then
								Self.task = 0
								g.delivery:+1
							EndIf
							
							dir[0] = 0
						EndIf
					Else
						dir[0] = 0
					EndIf
					
					
					'right
					If x < g.x-1 Then
						dir[1] = g.data[x+1,y].m_home + TAnt.min_value
						
						If g.data[x+1,y].actor <> Null Then
							If THome(g.data[x+1,y].actor) Then
								Self.task = 0
								g.delivery:+1
							EndIf
							
							dir[1] = 0
						EndIf
					Else
						dir[1] = 0
					EndIf
					
					'down
					If y < g.y-1 Then
						dir[2] = g.data[x,y+1].m_home + TAnt.min_value
						
						If g.data[x,y+1].actor <> Null Then
							If THome(g.data[x,y+1].actor) Then
								Self.task = 0
								g.delivery:+1
							EndIf
							
							dir[2] = 0
						EndIf
					Else
						dir[2] = 0
					EndIf
					
					'left
					If x > 0 Then
						dir[3] = g.data[x-1,y].m_home + TAnt.min_value
						
						If g.data[x-1,y].actor <> Null Then
							If THome(g.data[x-1,y].actor) Then
								Self.task = 0
								g.delivery:+1
							EndIf
							
							dir[3] = 0
						EndIf
					Else
						dir[3] = 0
					EndIf
			End Select
			
			If Self.last_dir >=0 And Self.last_dir =< 3 Then
				dir[Self.last_dir] = 0
			EndIf
			
			Local total:Float = dir[0] + dir[1] + dir[2] + dir[3]
			
			Local choice:Float = Rnd(0,total)
			
			Select True
				Case total = 0
					'nothing
				Case choice < dir[0]
					'0
					
					g.data[x,y-1].actor = Self
					g.data[x,y].actor = Null
					
					Self.last_dir = 2
					
				Case choice < dir[0] + dir[1]
					'1
					
					g.data[x+1,y].actor = Self
					g.data[x,y].actor = Null
					
					Self.last_dir = 3
					
				Case choice < dir[0] + dir[1] + dir[2]
					'2
					
					g.data[x,y+1].actor = Self
					g.data[x,y].actor = Null
					
					Self.last_dir = 0
					
				Default
					'3
					
					g.data[x-1,y].actor = Self
					g.data[x,y].actor = Null
					
					Self.last_dir = 1
					
			End Select
			
		End If
	End Method
End Type

'##########################################################

Graphics 800,600

Local grid:TGrid = TGrid.Create(50,50, 10, 200)

Local count:Int = 0

Repeat
	'render
	
	grid.render()
	count:+1
	
	
	
	If Not KeyDown(key_space)
		
		Cls
		
		'draw
		
		grid.draw(10)
		
		SetColor 255,255,255
		DrawText count/60, 5,30
		
		Flip
		
	EndIf
	
	
Until KeyHit(key_escape)