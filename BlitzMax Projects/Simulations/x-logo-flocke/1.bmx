SuperStrict
'X-LOGO-FAKE

Type DRAW
	Global start_pos_x:Float=400
	Global start_pos_y:Float=300
	Global start_w:Float=0
	
	Global act_x:Float
	Global act_y:Float
	Global act_w:Float
	
	Function home(x:Float=0,y:Float=0)
		DRAW.act_x=DRAW.start_pos_x+x
		DRAW.act_y=DRAW.start_pos_y-y
		DRAW.act_w=DRAW.start_w
	End Function
	
	Function turn(w:Float)
		DRAW.act_w:+w
	End Function
	
	Function forward(s:Float)
		DrawLine DRAW.act_x, DRAW.act_y, DRAW.act_x+Sin(DRAW.act_w)*s, DRAW.act_y-Cos(DRAW.act_w)*s
		DRAW.act_x:+Sin(DRAW.act_w)*s
		DRAW.act_y:-Cos(DRAW.act_w)*s
	End Function
End Type


Type BILDER
	Function quadrat(s:Float)
		DRAW.home()
		DRAW.forward(s)
		DRAW.turn(90)
		DRAW.forward(s)
		DRAW.turn(90)
		DRAW.forward(s)
		DRAW.turn(90)
		DRAW.forward(s)
		DRAW.turn(90)
	End Function
	
	Function flocke(s:Float,g:Int)
		BILDER.unter_flocke(s,g,1)
		DRAW.turn(-120)
		BILDER.unter_flocke(s,g,1)
		DRAW.turn(-120)
		BILDER.unter_flocke(s,g,1)
		DRAW.turn(-120)
	End Function
	
	Function unter_flocke(s:Float,g:Int,i:Int)
		If i=g Then
			DRAW.forward(s)
		Else
			BILDER.unter_flocke(s,g,i+1)
			DRAW.turn(60)
			BILDER.unter_flocke(s,g,i+1)
			DRAW.turn(-120)
			BILDER.unter_flocke(s,g,i+1)
			DRAW.turn(60)
			BILDER.unter_flocke(s,g,i+1)
		End If
	End Function
	
	Function recke(s:Float,g:Int)
		BILDER.unter_recke(s,g,1)
		DRAW.turn(-90)
		BILDER.unter_recke(s,g,1)
		DRAW.turn(-90)
		BILDER.unter_recke(s,g,1)
		DRAW.turn(-90)
		BILDER.unter_recke(s,g,1)
		DRAW.turn(-90)
	End Function
	
	Function unter_recke(s:Float,g:Int,i:Int)
		If i=g Then
			DRAW.forward(s)
		Else
			BILDER.unter_recke(s,g,i+1)
			DRAW.turn(90)
			BILDER.unter_recke(s,g,i+1)
			DRAW.turn(-90)
			BILDER.unter_recke(s,g,i+1)
			DRAW.turn(-90)
			BILDER.unter_recke(s,g,i+1)
			DRAW.turn(90)
			BILDER.unter_recke(s,g,i+1)
		End If
	End Function
End Type

Graphics 800,600
SetColor 0,100,0
SetClsColor 255,255,255


Repeat
	Cls
	DRAW.home(0,-290)
	'BILDER.quadrat(100)
	'SetColor 255,0,0
	Local time:Int=MilliSecs()
	BILDER.flocke(2,6)
	'Print MilliSecs()-time
	Flip
Until KeyHit(key_escape)