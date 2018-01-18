SuperStrict

Global a:Float=20
Global r:Float=30

Type GRAPH
	Function xx:Float(x:Float)'
		Return x+ Cos(360*x/(2*Pi*r))*a
	End Function
	
	Function yy:Float(x:Float)
		Return r- Sin(360*x/(2*Pi*r))*a
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
		Return r
	End Function
	
	Function draw()
		For Local x:Float=0 To 800 Step 0.1
			Plot GRAPH2.xx(x),-GRAPH2.yy(x)+300
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
	DrawOval GRAPH2.xx(xxx)-r,-GRAPH2.yy(xxx)+300-r,r*2,r*2
	
	SetColor 255,0,0
	GRAPH.draw()
	SetColor 255,255,0
	GRAPH2.draw()
	
	SetColor 50,0,100
	DrawOval GRAPH2.xx(xxx)-2,-GRAPH2.yy(xxx)+300-2,4,4
	
	SetColor 160,160,160
	DrawLine GRAPH.xx(xxx),-GRAPH.yy(xxx)+300,GRAPH2.xx(xxx),-GRAPH2.yy(xxx)+300
	
	SetColor 255,255,255
	DrawOval GRAPH.xx(xxx)-2,-GRAPH.yy(xxx)+300-2,4,4
	
	
	
	SetColor 0,255,0
	DrawLine 0,300,800,300
	SetColor 0,255,255
	DrawText "a(a+ y-)="+a,0,20
	DrawText "r(s+ x-)="+r,0,40
	If KeyDown(key_a) Then a:+0.1
	If KeyDown(key_y) Then a:-0.1
	
	If KeyDown(key_s) Then r:+0.1
	If KeyDown(key_x) Then r:-0.1
	Flip
Until AppTerminate() Or KeyHit(key_escape)