SuperStrict

'*************** TOBJEKT ****************************
Type TOBJEKT
	Global liste:TList
	
	Function ini()
		TOBJEKT.liste=New TList
	End Function
	
	Field x:Float
	Field vx:Float
	Field y:Float
	Field vy:Float
	Field r:Float
	Field m:Float
	
	Method init(x:Float,y:Float,r:Float,m:Float)
		Self.x=x
		Self.y=y
		Self.vx=0
		Self.vy=0
		Self.r=r
		Self.m=m
	End Method
	
	Method render()
		Self.x:+Self.vx
		Self.y:+Self.vy
		
		Self.vy:+0.03
		
		'Self.vx:*0.999
		'Self.vy:*0.999
		
		If Self.y>600-Self.r Then
			Self.y=600-Self.r
			Self.vy=0'-Abs(Self.vy)*0.9
			Self.vx:*0.8
		End If
		
		If Self.x>800-Self.r Then
			Self.x=800-Self.r
			Self.vx=0'-Abs(Self.vx)*0.9
			Self.vy:*0.9
		End If
		
		If Self.x<Self.r Then
			Self.x=Self.r
			Self.vx=0'Abs(Self.vx)*0.9
			Self.vy:*0.9
		End If
	End Method
	
	Method draw()
		SetColor 255,255,255
		DrawOval Self.x-Self.r,Self.y-Self.r,Self.r*2,Self.r*2
	End Method
End Type

'*************** TFEDER ****************************
Type TFEDER
	Global liste:TList
	
	Function ini()
		TFEDER.liste=New TList
	End Function
	
	Field o1:TOBJEKT
	Field o2:TOBJEKT
	
	Field s:Float
	Field D:Float
	
	Function create:TFEDER(o1:TOBJEKT,o2:TOBJEKT,s:Float,D:Float)
		Local f:TFEDER = New TFEDER
		f.o1=o1
		f.o2=o2
		f.s=s
		f.D=D
		
		TFEDER.liste.addlast(f)
		
		Return f
	End Function
	
	Method render()
		Local d:Float=((Self.o1.x-Self.o2.x)^2+(Self.o1.y-Self.o2.y)^2)^0.5
		Local f:Float=-Self.D*(Self.s-d)
		Local w:Float=ATan2(Self.o1.y-Self.o2.y,Self.o1.x-Self.o2.x)
		
		Self.o1.vx:-Cos(w)*f/Self.o1.m
		Self.o1.vy:-Sin(w)*f/Self.o1.m
		
		Self.o2.vx:+Cos(w)*f/Self.o2.m
		Self.o2.vy:+Sin(w)*f/Self.o2.m
	End Method
	
	Method draw()
		Local d:Float=((Self.o1.x-Self.o2.x)^2+(Self.o1.y-Self.o2.y)^2)^0.5
		Local c:Float=Abs((Self.s-d))/Self.s*1000.0
		SetColor c,255-c,0
		DrawLine Self.o1.x,Self.o1.y,Self.o2.x,Self.o2.y
	End Method
End Type

'##################### INIT ##########################
Graphics 800,600
TOBJEKT.ini()
TFEDER.ini()

'##################### START #########################
Repeat
	Cls
	
	If KeyHit(key_space) Then
		TOBJEKT.ini()
		TFEDER.ini()
	End If
	
	If MouseHit(1) Or MouseDown(2) Then
		Local o:TOBJEKT=New TOBJEKT
		Local mass:Float=Rand(0,5)
		o.init(MouseX(),MouseY(),5+mass,1+0.2*mass)
		
		Local ok:Int=1
		For Local o2:TOBJEKT=EachIn TOBJEKT.liste
			If ((o.x-o2.x)^2+(o.y-o2.y)^2)^0.5<50 Then
				ok=0
			End If
		Next
		
		If ok=1 Then
			For Local o2:TOBJEKT=EachIn TOBJEKT.liste
				Local s:Float=((o.x-o2.x)^2+(o.y-o2.y)^2)^0.5
				If s<100 Then
					TFEDER.create(o,o2,70,0.05)'TFEDER.create(o,o2,s,0.09)
				End If
			Next
		End If
		
		TOBJEKT.liste.addlast(o)
	End If
	
	For Local o:TOBJEKT=EachIn TOBJEKT.liste
		o.render()
	Next
	
	SetColor 50,50,50
	DrawOval MouseX()-100,MouseY()-100,200,200
	SetColor 100,100,100
	DrawOval MouseX()-50,MouseY()-50,100,100
	
	For Local f:TFEDER=EachIn TFEDER.liste
		f.render()
	Next
	
	For Local f:TFEDER=EachIn TFEDER.liste
		f.draw()
	Next
	
	For Local o:TOBJEKT=EachIn TOBJEKT.liste
		o.draw()
	Next
	Flip
Until KeyHit(key_escape)
End