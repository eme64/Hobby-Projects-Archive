SuperStrict

Type TObjekt
	Global liste:TList
	Global counter:Int=0
	Field mass:Float
	Field charge:Float
	Field r:Float
	Field x:Float
	Field y:Float
	
	Field vx:Float
	Field vy:Float
	
	Field id:Int
	
	Function Create:TObjekt(x:Float,y:Float,r:Float,mass:Float,charge:Float,vx:Float,vy:Float)
		Local o:TObjekt=New TObjekt
		
		TObjekt.liste.addlast(o)
		TObjekt.counter:+1
		o.id=TObjekt.counter
		
		o.x=x
		o.y=y
		o.vx=vx
		o.vy=vy
		
		o.r=r
		o.mass=mass
		o.charge=charge
		
		Return o
	End Function
	
	Method render_v_1()
		For Local o:TObjekt=EachIn TObjekt.liste
			If o<>Self Then
				Local d:Float=((o.x-Self.x)^2+(o.y-Self.y)^2)^0.5
				Local w:Float=ATan2(o.y-Self.y,o.x-Self.x)
				
				Local fg:Float=o.mass*Self.mass/(d^2)
				Local fe:Float=-o.charge*Self.charge/(d^2)
				
				
				Self.vx:+Cos(w)*(fg+fe)/Self.mass
				Self.vy:+Sin(w)*(fg+fe)/Self.mass
			End If
		Next
	End Method
	
	
	Method render_v_2()
		Self.x:+Self.vx
		Self.y:+Self.vy
		
	End Method
	
	Function render()
		For Local o:TObjekt=EachIn TObjekt.liste
			o.render_v_1()
		Next
		For Local o:TObjekt=EachIn TObjekt.liste
			o.render_v_2()
		Next
	End Function
End Type

TObjekt.liste=New TList
Rem
TObjekt.create(340,300,10,700,0,0,-2.2)
TObjekt.create(450,300,10,700,0,0,2.2)
EndRem

Rem
TObjekt.create(340,300,10,500,0,0,-1.5)
TObjekt.create(450,300,10,500,0,0,1.5)

TObjekt.create(100,300,5,100,0,0,1.5)
EndRem


TObjekt.Create(2000,2000,50,10000,0,0,0)
TObjekt.Create(1500,2000,20,1000,0,0,5)
TObjekt.Create(1450,2000,10,100,0,0,10)

TObjekt.Create(2500,2000,20,1000,0,0,-5)
TObjekt.Create(2550,2000,10,100,0,0,-10)


Rem
TObjekt.Create(2200,2000,50,1000,0,0,2)
TObjekt.Create(2000,2200,50,1000,0,-2,0)
TObjekt.Create(1800,2000,50,1000,0,0,-2)
TObjekt.Create(2000,1800,50,1000,0,2,0)
EndRem
'create:TObjekt(x:Float,y:Float,r:Float,mass:Float,charge:Float,vx:Float,vy:Float)

Graphics 800,600,0,120

SetBlend(ALPHABLEND)

Local scale:Float=0.2
Local x_pos:Float=0
Local y_pos:Float=0

Repeat
	scale:+MouseZSpeed()*0.02
	Cls
	TObjekt.render()
	For Local o:TObjekt=EachIn TObjekt.liste
		SetColor 255,255,255
		DrawOval (o.x-o.r)*scale,(o.y-o.r)*scale,2*o.r*scale,2*o.r*scale
		SetColor 0,0,255
		DrawText o.id,o.x*scale-5,o.y*scale-5
	Next
	
	'WaitKey()
	
	Flip
Until KeyHit(key_escape)