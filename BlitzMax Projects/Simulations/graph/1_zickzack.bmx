SuperStrict

Global a:Float=30
Global r:Float=30

Global h:Float=200
Global adw:Float=0

Type GRAPH
	Function xx:Float(x:Float)
		Return x
	End Function
	
	Function yy:Float(x:Float)
		x=(x Mod (2*h))
		Select True
			Case x<(h-r/Sqr(2))
				Return x+Sqr(2)*r
			Case x<(h+r/Sqr(2))
				Return h+Sin(ACos((x-h)/r))*r
			Default
				Return 2*h-x+Sqr(2)*r
		End Select
	End Function
	
	Function draw()
		For Local x:Float=0 To 800 Step 0.1
			Plot GRAPH.xx(x),-GRAPH.yy(x)+400
		Next
	End Function
End Type

Type GRAPH2
	Function xx:Float(x:Float)
		Return GRAPH.xx(x)+Cos(GRAPH2.ww(x))*a
	End Function
	
	Function ww:Float(x:Float)
		Local alfa:Float=Float(Int(x/(2*h)))*Float((Sqr(2.0)*h-r)*360.0/(Pi*r)+90.0)
		
		Select True
			Case (x-Int(x/(2.0*h))*2.0*h)<(h-(r/Sqr(2.0)))
				alfa:+(x-Int(x/(2.0*h))*2.0*h)*Sqr(2.0)*360/(2*Pi*r)
			Case (x-Int(x/(2.0*h))*2.0*h)<(h+(r/Sqr(2.0)))
				alfa:+(Sqr(2.0)*h-r)*360.0/(2.0*Pi*r)+135-ACos(Float(Float(x Mod (2*h))-h)/r)'??? x-h ... mod?'ACos((x-h)/r)
				'Print ACos(((x Mod (2*h))-h)/r)
			Default
				alfa:+(Sqr(2.0)*h-r)*360.0/(2.0*Pi*r)+90.0+(x-Int(x/(2.0*h))*2.0*h-(h+(r/Sqr(2.0))))*(Sqr(2.0)*360/(2.0*Pi*r))
		End Select
		Return -alfa-adw
	End Function
	
	Function yy:Float(x:Float)
		Return GRAPH.yy(x)+Sin(GRAPH2.ww(x))*a
	End Function
	
	Function draw()
		For Local x:Float=0 To 800 Step 0.1
			Plot GRAPH2.xx(x),-GRAPH2.yy(x)+400
		Next
	End Function
End Type

Graphics 800,600,0,60

Local xxx:Float
Repeat
	xxx:+1
	If xxx>800 Then xxx=0
	Cls
	SetColor 100,0,255
	DrawOval GRAPH.xx(xxx)-r,-GRAPH.yy(xxx)+400-r,r*2,r*2
	
	SetColor 255,0,0
	GRAPH.draw()
	
	SetColor 50,0,100
	DrawOval GRAPH.xx(xxx)-2,-GRAPH.yy(xxx)+400-2,4,4
	
	SetColor 255,255,0
	GRAPH2.draw()
	SetColor 0,255,0
	DrawLine 0,400,800,400
	
	SetColor 160,160,160
	DrawLine GRAPH.xx(xxx),-GRAPH.yy(xxx)+400,GRAPH2.xx(xxx),-GRAPH2.yy(xxx)+400
	
	SetColor 255,255,255
	DrawOval GRAPH2.xx(xxx)-2,-GRAPH2.yy(xxx)+400-2,4,4
	
	Local ii:Float=0
	While ii<=800.0
		DrawLine ii,400,ii+h,400-h
		DrawLine ii+h,400-h,ii+h*2,400
		ii:+2*h
	Wend
	
	SetColor 0,255,255
	DrawText "a(a+ y-)="+a,0,20
	DrawText "r(s+ x-)="+r,0,40
	DrawText "h(d+ c-)="+h,0,60
	DrawText "adw(f+ v-)="+adw,0,80
	DrawText "w="+Int(GRAPH2.ww(xxx)/10),0,110
	
	If KeyDown(key_a) Then a:+0.1
	If KeyDown(key_y) Then a:-0.1
	
	If KeyDown(key_s) Then r:+0.1
	If KeyDown(key_x) Then r:-0.1
	
	If KeyDown(key_d) Then h:+0.3
	If KeyDown(key_c) Then h:-0.3
	
	If KeyDown(key_f) Then adw:+1.0
	If KeyDown(key_v) Then adw:-1.0
	Flip
Until AppTerminate() Or KeyHit(key_escape)