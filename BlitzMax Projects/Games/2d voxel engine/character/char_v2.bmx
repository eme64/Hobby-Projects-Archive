SuperStrict

'############################# RESOURCES
Type CHARACTER_IMG
	Global NORMAL:CHARACTER_IMG
	
	Function init()
		NORMAL = CHARACTER_IMG.Load("normal")
	End Function
	
	Field body:TImage
	Field head:TImage
	Field arm_front:TImage
	Field arm_back:TImage
	
	Field frames_per_row:Int
	Field number_rows:Int
	
	Field ticks:Int[][]
	Field arm_offset:Int[][] ' -> only affects swing-arms
	
	Field swing_arm_0_x:Int ' control point
	Field swing_arm_0_y:Int ' control point
	
	Field swing_arm_1_x:Int ' control point
	Field swing_arm_1_y:Int ' control point
	
	Field frame_size:Int
	
	Rem
		-------------   STATES
		0 = standing
		1 = running
		
	End Rem
	
	Function Load:CHARACTER_IMG(path:String)
		Local c:CHARACTER_IMG = New CHARACTER_IMG
		
		c.ticks = New Int[][4]
		c.arm_offset = New Int[][4]
		c.frames_per_row = 4
		c.number_rows = 4
		
		c.frame_size = 32
		
		c.body = LoadAnimImage(path + "\body.png",c.frame_size,c.frame_size,0,c.frames_per_row*c.number_rows, 0)
		c.head = LoadAnimImage(path + "\head.png",c.frame_size,c.frame_size,0,c.frames_per_row*c.number_rows, 0)
		c.arm_front = LoadAnimImage(path + "\arm_front.png",c.frame_size,c.frame_size,0,c.frames_per_row*c.number_rows, 0)
		c.arm_back = LoadAnimImage(path + "\arm_back.png",c.frame_size,c.frame_size,0,c.frames_per_row*c.number_rows, 0)
		
		SetImageHandle(c.body, 16,16)
		SetImageHandle(c.head, 16,16)
		SetImageHandle(c.arm_front, 16,16)
		SetImageHandle(c.arm_back, 16,16)
		
		c.ticks[0] = [1]
		c.ticks[1] = [8,8,8,8]
		c.ticks[2] = [1]
		c.ticks[3] = [1]
		
		c.arm_offset[0] = [0]
		c.arm_offset[1] = [0, -1, 0, -1]
		c.arm_offset[2] = [0]
		c.arm_offset[3] = [0]
		
		c.swing_arm_0_x = 20
		c.swing_arm_0_y = 13
		
		c.swing_arm_1_x = 14
		c.swing_arm_1_y = 13
		
		Return c
	End Function
	
	
	Function drawhandle( image:TImage,x#,y#,frame:Int, hanlde_x:Int, handle_y:Int)
		Local gc:TMax2DGraphics = TMax2DGraphics.Current()
		
		
		Local x0#=-hanlde_x,x1#=x0+image.width
		Local y0#=-handle_y,y1#=y0+image.height
		Local iframe:TImageFrame=image.Frame(frame)
		If iframe iframe.Draw x0,y0,x1,y1,x+gc.origin_x,y+gc.origin_y,0,0,image.width,image.height
	End Function
End Type

'############################# INSTANCE
Type CHARACTER
	Field char_img:CHARACTER_IMG
	
	Field state:Int
	Field frame:Int
	Field tick:Int
	
	Function Create:CHARACTER(char_img:CHARACTER_IMG)
		Local c:CHARACTER = New CHARACTER
		
		c.char_img = char_img
		
		Return c
	End Function
	
	Method draw(new_state:Int, direction:Int, arm_0:Int, arm_1:Int, x:Int,y:Int, scale:Int, aim_dx:Int,aim_dy:Int)
		' arm: 0:free, 1:carry, 2:rotate
		' direction: 0 -> , 1 <-
		
		If state <> new_state Then
			' reset
			state = new_state
			frame = 0
			tick = 0
		Else
			tick:+1
			If tick>=char_img.ticks[state][frame] Then
				tick = 0
				frame:+1
				If frame >= char_img.ticks[state].length Then
					state = 0
					frame = 0
				EndIf
			EndIf
		EndIf
		
		If direction Then
			SetScale -scale, scale
		Else
			SetScale scale, scale
		EndIf
		SetColor 255,255,255
		
		Select arm_0
			Case 0
				DrawImage char_img.arm_back, x,y, frame + state*char_img.frames_per_row
			Case 1
				DrawImage char_img.arm_back, x,y + scale*char_img.arm_offset[state][frame], 0
			Case 2
				Local xx:Int
				Local yy:Int
				Select direction
					Case 0
						xx = char_img.swing_arm_0_x*scale - char_img.frame_size*scale/2
						yy = char_img.swing_arm_0_y*scale - char_img.frame_size*scale/2 + scale*char_img.arm_offset[state][frame]
						
						SetRotation ATan2(aim_dy - yy, aim_dx - xx)
					Case 1
						xx =  - (char_img.swing_arm_0_x*scale - char_img.frame_size*scale/2)
						yy =  + char_img.swing_arm_0_y*scale - char_img.frame_size*scale/2 + scale*char_img.arm_offset[state][frame]
						
						SetRotation ATan2(aim_dy - yy, aim_dx - xx) + 180
				End Select
				
				CHARACTER_IMG.drawhandle(char_img.arm_back,x+xx,y+yy, 1, char_img.swing_arm_0_x, char_img.swing_arm_0_y)
				
				'DrawImage char_img.arm_back, x,y + scale*char_img.arm_offset[state][frame], 1
				
				SetRotation 0
		End Select
		
		DrawImage char_img.body, x,y, frame + state*char_img.frames_per_row
		DrawImage char_img.head, x,y, frame + state*char_img.frames_per_row
		
		Select arm_1
			Case 0
				DrawImage char_img.arm_front, x,y, frame + state*char_img.frames_per_row
			Case 1
				DrawImage char_img.arm_front, x,y + scale*char_img.arm_offset[state][frame], 0
			Case 2
				Local xx:Int
				Local yy:Int
				Select direction
					Case 0
						xx = char_img.swing_arm_1_x*scale - char_img.frame_size*scale/2
						yy = char_img.swing_arm_1_y*scale - char_img.frame_size*scale/2 + scale*char_img.arm_offset[state][frame]
						
						SetRotation ATan2(aim_dy - yy, aim_dx - xx)
					Case 1
						xx = - (char_img.swing_arm_1_x*scale - char_img.frame_size*scale/2)
						yy = + char_img.swing_arm_1_y*scale - char_img.frame_size*scale/2 + scale*char_img.arm_offset[state][frame]
						
						SetRotation ATan2(aim_dy - yy, aim_dx - xx) + 180
				End Select
				
				CHARACTER_IMG.drawhandle(char_img.arm_front,x+xx,y+yy, 1, char_img.swing_arm_1_x, char_img.swing_arm_1_y)
				SetRotation 0
		End Select
		
		SetScale 1,1
	End Method
EndType

Rem
Graphics 800,600
CHARACTER_IMG.init()

Local char_1:CHARACTER = CHARACTER.Create(CHARACTER_IMG.NORMAL)
Local char_2:CHARACTER = CHARACTER.Create(CHARACTER_IMG.NORMAL)
Local char_3:CHARACTER = CHARACTER.Create(CHARACTER_IMG.NORMAL)

Repeat
	SetClsColor (MilliSecs()/100) Mod 255,(MilliSecs()/100) Mod 255,(MilliSecs()/100) Mod 255
	Cls
	
	If KeyDown(KEY_D) Then
		char_1.draw(1, 0, 0,0, 50,200, 3, MouseX()-50, MouseY()-200)
	Else
		char_1.draw(1, 1, 0,0, 50,200, 3, MouseX()-50, MouseY()-200)
	EndIf
	
	If KeyDown(KEY_D) Then
		char_2.draw(1, 0, 1,1, 200,200, 3, MouseX()-200, MouseY()-200)
	Else
		char_2.draw(1, 1, 1,1, 200,200, 3, MouseX()-200, MouseY()-200)
	EndIf
	
	If KeyDown(KEY_D) Then
		char_3.draw(1, 0, 2,2, 350,200, 3, MouseX()-350, MouseY()-200)
	Else
		char_3.draw(1, 1, 2,2, 350,200, 3, MouseX()-350, MouseY()-200)
	EndIf
	
	Flip
Until KeyHit(KEY_ESCAPE)
end rem