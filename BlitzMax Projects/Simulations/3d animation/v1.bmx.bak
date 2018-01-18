SuperStrict

Type TPoint
	Function init()
		TPoint.img = LoadImage("img.png")
	End Function
	
	Global img:TImage
	
	Field x:Double
	Field y:Double
	Field z:Double
	
	Field res_h:Double
	Field res_d:Double
	Field res_w:Double
	
	Field r:Int
	Field g:Int
	Field b:Int
	
	Function Create:TPoint(x:Double,y:Double,z:Double, r:Int,g:Int,b:Int)
		Local p:TPoint = New TPoint
		
		p.x = x
		p.y = y
		p.z = z
		
		p.r = r
		p.g = g
		p.b = b
		
		p.res_h = p.y
		
		p.res_d = (p.x^2.0 + p.z^2)^0.5
		p.res_w = ATan2(p.z, p.x)
		
		Return p
	End Function
	
	Method draw(w:Double, scale:Double)
		SetColor Self.r, Self.g, Self.b
		
		DrawImage Self.img, 400+scale*Self.res_d*Cos(Self.res_w+w), 300+scale*Self.res_h + scale*Self.res_d*Sin(Self.res_w+w)*0.5
	End Method
End Type


Graphics 800,600
SetBlend LIGHTBLEND

TPoint.init()

Local list:TList = New TList

For Local i:Double = 0 To 1 Step 0.0001
	list.addlast(TPoint.Create( ..
	500.0*Cos(i*360.0*2.0), ..
	500.0*Cos(i*360.0*3.0), ..
	500.0*Cos(i*360.0*5.0),..
	10.0+10.0*Sin(i*360.0*3.0)+10.0+10.0*Cos(i*360.0*5.0),..
	10.0+10.0*Cos(i*360.0*5.0),..
	0))'10.0-10.0*Cos(i*360.0*5.0)
Next

For Local i:Double = -1 To 1 Step 0.003
	list.addlast(TPoint.Create( ..
	600.0*i, ..
	0, ..
	0,..
	10+i*10.0,..
	10-i*10.0,..
	0))
Next

For Local i:Double = -1 To 1 Step 0.003
	list.addlast(TPoint.Create( ..
	0, ..
	600.0*i, ..
	0,..
	10+i*10.0,..
	0,..
	10-i*10.0))
Next

For Local i:Double = -1 To 1 Step 0.003
	list.addlast(TPoint.Create( ..
	0, ..
	0, ..
	600.0*i,..
	0,..
	10-i*10.0,..
	10+i*10.0))
Next

Repeat
	Cls
	
	Local tim:Int = MilliSecs()
	
	For Local p:TPoint = EachIn list
		p.draw(tim/10,2.0^(Float(MouseZ())*0.1))
	Next
	Flip
Until KeyHit(key_escape)