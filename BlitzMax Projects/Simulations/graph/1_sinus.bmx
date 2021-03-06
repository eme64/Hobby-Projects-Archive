SuperStrict

Global a:Float=20
Global r:Float=20

Global h:Float=50
Global b:Float=50



Global approx:Float=1.0

Type GRAPH
	Function xx:Float(x:Float)
		'Local m:Float=-1.0/(h*Cos(x*90.0/b)/b)
		Return GRAPH2.xx(x)+Cos(ATan(Pi/2*h/b*Cos(x*90.0/b))+90)*r'-r/Sqr(1.0+m^2)
	End Function
	
	Function yy:Float(x:Float)
		'Local m:Float=-1.0/(h*Cos(x*90.0/b)/b)
		Return GRAPH2.yy(x)+Sin(ATan(Pi/2*h/b*Cos(x*90.0/b))+90)*r'+r*m/Sqr(1.0+m^2)
	End Function
	
	Function draw()
		For Local x:Float=0 To 800 Step 0.1
			Plot GRAPH.xx(x),-GRAPH.yy(x)+300
		Next
	End Function
End Type

Type GRAPH2
	Function xx:Float(x:Float)'
		Return x
	End Function
	
	Function yy:Float(x:Float)
		Return Sin(x/b*90.0)*h
	End Function
	
	Function draw()
		For Local x:Float=0 To 800 Step 0.1
			Plot GRAPH2.xx(x),-GRAPH2.yy(x)+300
		Next
	End Function
End Type

Type GRAPH3
	Function xx:Float(x:Float)'
		Return GRAPH.xx(x)+Cos(-GRAPH3.ss(x)*360.0/(2.0*Pi*r))*a
	End Function
	
	Function yy:Float(x:Float)
		Return GRAPH.yy(x)+Sin(-GRAPH3.ss(x)*360.0/(2.0*Pi*r))*a
	End Function
	
	Function ss:Float(x:Float)
		Local s:Float=0
		
		Local i:Int=0
		While x-approx>=i
			s:+Sqr( (h*Sin(i*90.0/b)-h*Sin((i+approx)*90.0/b))^2.0 + approx^2.0 )
			i:+approx
		Wend
		Return s
	End Function
	
	Function draw()
		For Local x:Float=0 To 800 Step 1
			Plot GRAPH3.xx(x),-GRAPH3.yy(x)+300
		Next
	End Function
End Type

Graphics 800,600,0,60

Local xxx:Float
Repeat
	xxx:+3
	If xxx>800 Then xxx=0
	Cls
	
	SetColor 100,0,255
	DrawOval GRAPH.xx(xxx)-r,-GRAPH.yy(xxx)+300-r,r*2,r*2
	
	SetColor 150,0,0
	GRAPH.draw()
	SetColor 255,0,0
	DrawOval GRAPH.xx(xxx)-2,-GRAPH.yy(xxx)+300-2,4,4
	
	SetColor 150,150,0
	GRAPH2.draw()
	SetColor 255,255,0
	DrawOval GRAPH2.xx(xxx)-2,-GRAPH2.yy(xxx)+300-2,4,4
	
	SetColor 0,150,0
	GRAPH3.draw()
	SetColor 0,255,0
	DrawOval GRAPH3.xx(xxx)-2,-GRAPH3.yy(xxx)+300-2,4,4
	
	SetColor 255,255,255
	DrawLine GRAPH.xx(xxx),-GRAPH.yy(xxx)+300, GRAPH3.xx(xxx),-GRAPH3.yy(xxx)+300
	
	SetColor 0,255,0
	DrawLine 0,300,800,300
	SetColor 0,255,255
	DrawText "a(a+ y-)="+a,0,20
	DrawText "r(s+ x-)="+r,0,40
	DrawText "h(d+ c-)="+h,0,60
	DrawText "b(f+ v-)="+b,0,80
	
	
	DrawText "m="+((h*Cos(xxx*90.0/b)/b)),500,10
	DrawText "s="+Int(GRAPH3.ss(xxx)),500,30
	DrawText "w="+Int(GRAPH3.ss(xxx)*360/(2.0*Pi*r)),500,50
	
	If KeyDown(key_a) Then a:+1
	If KeyDown(key_y) Then a:-1
	
	If KeyDown(key_s) Then r:+1
	If KeyDown(key_x) Then r:-1
	
	If KeyDown(key_d) Then h:+1
	If KeyDown(key_c) Then h:-1
	
	If KeyDown(key_f) Then b:+1
	If KeyDown(key_v) Then b:-1
	
	
	Flip
Until AppTerminate() Or KeyHit(key_escape)