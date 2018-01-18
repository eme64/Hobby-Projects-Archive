SuperStrict

Type TGrid
	Field x:Int
	Field y:Int
	Field map:String[0]
	
	Function Create:TGrid(plan:String[])
		Local g:TGrid = New TGrid
		
		g.y = plan.length
		g.x = Len(plan[0])
		
		g.map = New String[0]
		
		For Local yy:Int = 0 To g.y-1
			For Local xx:Int = 0 To g.x-1
				Local txt:String = Mid(plan[yy],xx+1,1)
				
				g.map:+ [txt]
			Next
		Next
		
		Return g
	End Function
	
	Method draw()
		For Local yy:Int = 0 To Self.y-1
			For Local xx:Int = 0 To Self.x-1
				Select Self.map[yy*Self.x + xx]
					Case " "
						SetColor 50,50,50
					Case "#"
						SetColor 50,150,255
					Case "o"
						SetColor 255,150,0
				End Select
				
				DrawRect xx*10, yy*10,9,9
			Next
		Next
	End Method
	
	Method turn()
		Local new_map:String[] = New String[0]
		
		For Local yy:Int = 0 To Self.y-1
			For Local xx:Int = 0 To Self.x-1
				Select Self.map[yy*Self.x + xx]
					Case " "
						new_map:+[" "]
					Case "#"
						new_map:+["#"]
					Case "o"
						new_map:+[" "]
				End Select
			Next
		Next
		
		For Local yy:Int = 0 To Self.y-1
			For Local xx:Int = 0 To Self.x-1
				Select Self.map[yy*Self.x + xx]
					Case "o"
						Local vx:Int = Rand(-1,1)
						Local vy:Int = Rand(-1,1)
						
						If new_map[(yy + vy)*Self.x + xx + vx] = " " And Self.map[(yy + vy)*Self.x + xx + vx] = " " Then
							new_map[(yy + vy)*Self.x + xx + vx] = "o"
						Else
							new_map[yy*Self.x + xx] = "o"
						End If
						
				End Select
			Next
		Next
		
		Self.map = new_map
	End Method
End Type


'##########################################################

Local plan:String[] = [..
"######################################",..
"#         #                          #",..
"#                             o      #",..
"#           o          o             #",..
"#      ooo         #            o    #",..
"#   o              #                 #",..
"#         o  #############      o    #",..
"#                  #                 #",..
"#        #       o       #####       #",..
"#        #              o            #",..
"######################################"]


Local grid:TGrid = TGrid.Create(plan)

'-------------------------------------------------

Graphics 800,600

Repeat
	Cls
	
	If KeyHit(key_space) Or KeyDown(key_enter) Then grid.turn()
	
	grid.draw()
	
	Flip
Until KeyHit(key_escape)