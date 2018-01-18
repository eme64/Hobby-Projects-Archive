SuperStrict

'############################# RESOURCES
Type CHARACTER_IMG
	Global NORMAL:CHARACTER_IMG
	
	Function init()
		NORMAL = CHARACTER_IMG.Load("normal")
	End Function
	
	Field body:TImage[]
	Field body_ticks:Int[][]
	Rem
		-------------   STATES
		0 = standing
		1 = running
		
	End Rem
	
	Function Load:CHARACTER_IMG(path:String)
		Local c:CHARACTER_IMG = New CHARACTER_IMG
		
		c.body = New TImage[2]
		c.body_ticks = New Int[][2]
		
		c.body[0] = LoadAnimImage(path + "\stand.png",16,32,0,1, 0)
		c.body_ticks[0] = [1]
		
		c.body[1] = LoadAnimImage(path + "\run.png",16,32,0,4, 0)
		c.body_ticks[1] = [8,8,8,8]
		
		Return c
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
	
	Method draw(new_state:Int, x:Int,y:Int, scale:Int)
		If state <> new_state Then
			' reset
			state = new_state
			frame = 0
			tick = 0
		Else
			tick:+1
			If tick>=char_img.body_ticks[state][frame] Then
				tick = 0
				frame:+1
				If frame >= char_img.body_ticks[state].length Then
					state = 0
					frame = 0
				EndIf
			EndIf
		EndIf
		
		SetScale scale, scale
		SetColor 255,255,255
		
		DrawImage char_img.body[state], x,y, frame
		
		SetScale 1,1
	End Method
EndType


Graphics 800,600
CHARACTER_IMG.init()

Local char:CHARACTER = CHARACTER.Create(CHARACTER_IMG.NORMAL)

Repeat
	SetClsColor (MilliSecs()/100) Mod 255,(MilliSecs()/100) Mod 255,(MilliSecs()/100) Mod 255
	Cls
	
	If KeyDown(KEY_D) Then
		char.draw(1,200,200, 3)
	Else
		char.draw(0,200,200, 3)
	EndIf
	
	Flip
Until KeyHit(KEY_ESCAPE)