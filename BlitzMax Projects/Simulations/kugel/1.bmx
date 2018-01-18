SuperStrict

Type PUNKT
	Global plot_in:Int
	Global plot_anz:Int
	
	Const scale:Int=100
	
	Field x:Float
	Field y:Float
	Field z:Float
	
	Function Create:PUNKT(x:Float,y:Float,z:Float)
		Local p:PUNKT=New PUNKT
		
		p.x=x
		p.y=y
		p.z=z
		
		PUNKT.plot_anz:+1
		PUNKT.plot_in:+((p.x^2+p.y^2+p.z^2)=<1)
		
		Return p
	End Function
	
	Global feld:PUNKT[100,100,100]
	
	Method draw()
		If ((Self.x^2+Self.y^2+Self.z^2)=<1) Or (Abs(Self.x)>0.95) + (Abs(Self.y)>0.95) + (Abs(Self.z)>0.95)>1 Then
			DrawRect Self.x*PUNKT.scale-0.4*Self.z*PUNKT.scale+400,Self.y*PUNKT.scale-0.3*Self.z*PUNKT.scale+300,2,2
		End If
	End Method
End Type


Graphics 800,600


For Local x:Int=-50 Until 50 
	For Local y:Int=-50 Until 50 
		For Local z:Int=-50 Until 50 
			PUNKT.feld[x+50 ,y+50 ,z+50 ]=PUNKT.Create(Float(x)/50 ,Float(y)/50 ,Float(z)/50 )
		Next
	Next
Next

Repeat
	For Local x:Int=49 To -50 Step -1
		For Local y:Int=49 To -50 Step -1
			For Local z:Int=49 To -50 Step -1
				SetColor 255*(x+50 )/100,255*(y+50 )/100,255*(z+50)/100
				PUNKT.feld[x+50 ,y+50 ,z+50 ].draw()
			Next
		Next
	Next
	
	SetColor 255,255,255
	DrawText PUNKT.plot_in,10,500
	DrawText PUNKT.plot_anz,10,530
	DrawText Float(PUNKT.plot_in)/Float(PUNKT.plot_anz)*8.0*3.0/4.0,10,560
	Flip
	Cls
Until KeyHit(key_escape)

End