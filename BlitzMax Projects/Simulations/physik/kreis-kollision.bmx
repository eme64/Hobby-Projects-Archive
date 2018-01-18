SuperStrict

Type TOBKEKT
	Global GK:Float=-0.2
	Global GG:Float=0
	Global KP:Float=0.95
	Field x:Float
	Field y:Float
	
	Field vx:Float
	Field vy:Float
	
	Field r:Float
	
	Field m:Float'masse
	
	Field color:Int[3]
	
	Function create:TOBKEKT(x:Float,y:Float,vx:Float,vy:Float,r:Float,m:Float,c1:Int,c2:Int,c3:Int)
		Local o:TOBKEKT=New TOBKEKT
		
		o.x=x
		o.y=y
		
		o.vx=vx
		o.vy=vy
		
		o.r=r
		
		o.m=m
		
		o.color[0]=c1
		o.color[1]=c2
		o.color[2]=c3
		
		Return o
	End Function
	
	Method render()
		Const max_x:Float=800
		Const Max_y:Float=600
		
		If Self.x-Self.r<0 And Self.vx<0 Then' kollision links
			Local w:Float=ATan2(Self.vy,Self.vx)
			Local v:Float=Sqr(Self.vx^2+Self.vy^2)
			
			w:-180 'verdrehung
			w:*-1  'einfall=ausfall
			w:+180 'richtung drehen
			w:+180 'verdrehung
			
			Self.vx=v*Cos(w)*TOBKEKT.KP
			Self.vy=v*Sin(w)*TOBKEKT.KP
			'Print "rechts"
		End If
		
		If Self.x+Self.r>max_x And Self.vx>0 Then' kollision rechts
			Local w:Float=ATan2(Self.vy,Self.vx)
			Local v:Float=Sqr(Self.vx^2+Self.vy^2)
			
			'w:-180 'verdrehung
			w:*-1  'einfall=ausfall
			w:+180 'richtung drehen
			'w:+180 'verdrehung
			
			Self.vx=v*Cos(w)*TOBKEKT.KP
			Self.vy=v*Sin(w)*TOBKEKT.KP
			'Print "links"
		End If
		
		
		
		
		If Self.y-Self.r<0 And Self.vy<0 Then' kollision links
			Local w:Float=ATan2(Self.vy,Self.vx)
			Local v:Float=Sqr(Self.vx^2+Self.vy^2)
			
			w:-90 'verdrehung
			w:*-1  'einfall=ausfall
			w:+180 'richtung drehen
			w:+90 'verdrehung
			
			Self.vx=v*Cos(w)*TOBKEKT.KP
			Self.vy=v*Sin(w)*TOBKEKT.KP
			'Print "oben"
		End If
		
		If Self.y+Self.r>max_y And Self.vy>0 Then' kollision rechts
			Local w:Float=ATan2(Self.vy,Self.vx)
			Local v:Float=Sqr(Self.vx^2+Self.vy^2)
			
			w:-270 'verdrehung
			w:*-1  'einfall=ausfall
			w:+180 'richtung drehen
			w:+270 'verdrehung
			
			Self.vx=v*Cos(w)*TOBKEKT.KP
			Self.vy=v*Sin(w)*TOBKEKT.KP
			'Print "unten"
		End If
		
		
		Self.vy:+TOBKEKT.GG
		
		Self.x:+Self.vx
		Self.y:+Self.vy
	End Method
	
	Method draw()
		SetColor Self.color[0],Self.color[1],Self.color[2]
		DrawOval Self.x-Self.r,Self.y-Self.r,2*Self.r,2*Self.r
	End Method
End Type


Graphics 800,600
SeedRnd MilliSecs()
SetBlend ALPHABLEND

Local liste:TList=New TList

For Local i:Int=1 To 10
	Local r:Float=(Rnd()+0.5)*5.0+30.0
	liste.addlast(TOBKEKT.create(Rand(0,500),Rand(0,500),Rnd()-0.5,Rnd()-0.5,r,r^3,Rand(0,255),Rand(0,255),Rand(0,255)))
Next

Global last_md:Int=0
Global last_mx:Int=0
Global last_my:Int=0

Repeat
	If MouseDown(1) Then
		If last_md=0		
			last_md=1
			last_mx=MouseX()
			last_my=MouseY()
		End If
	Else
		If last_md=1 Then
			
			Local r:Float=Sqr((last_mx-MouseX())^2+(last_my-MouseY())^2)
			liste.addlast(TOBKEKT.create(last_mx,last_my,0,0,r,r^3,Rand(0,255),Rand(0,255),Rand(0,255)))
			
			last_md=0
		End If
	End If
	
	If last_md=1 Then
		Local r:Float=Sqr((last_mx-MouseX())^2+(last_my-MouseY())^2)
		SetColor 100,100,100
		DrawOval last_mx-r,last_my-r,2*r,2*r
	End If
	
	TOBKEKT.GG:+0.1*(-KeyHit(key_1)+KeyHit(key_2))
	TOBKEKT.GK:+0.1*(-KeyHit(key_3)+KeyHit(key_4))
	TOBKEKT.KP:+0.1*(-KeyHit(key_5)+KeyHit(key_6))
	
	For Local o:TOBKEKT=EachIn liste
		o.render()
		o.draw()
	Next
	
	Local liste2:TList=liste.copy()
	
	For Local o:TOBKEKT=EachIn liste2
		For Local o2:TOBKEKT=EachIn liste2
			
			If o=o2 Then Continue
			
			Local d:Float=Sqr((o.x-o2.x)^2+(o.y-o2.y)^2)
			
			Local w:Float=ATan2(o.y-o2.y,o.x-o2.x)
			
			Local f:Int=o.m*o2.m*TOBKEKT.GK/(d^2)
			
			o.vx:-Cos(w)*f/o.m
			o2.vx:+Cos(w)*f/o2.m
			
			o.vy:-Sin(w)*f/o.m
			o2.vy:+Sin(w)*f/o2.m
			
			If d <= (o.r+o2.r) Then
				liste.Remove(o)
				liste.Remove(o2)
				
				Rem
				Local o_ax:Float=0 
				Local o_ay:Float=0 
				Local o2_ax:Float=0 
				Local o2_ay:Float=0
				
				
				If o.vx>0 And o2.x>o.x Then
					
					o_ax:+ 
					o_ay:+ 
					
					o2_ax:+ 
					o2_ay:+ 
					
				End If
				End Rem
			End If
		Next
		liste2.Remove(o)
	Next
	
	SetAlpha 0.5
	SetColor 0,0,0
	DrawRect 0,0,250,50
	SetAlpha 1
	
	SetColor 0,255,0
	
	DrawText "Gravitation:  "+TOBKEKT.GG,2,2
	DrawText "Grav.konst.:  "+TOBKEKT.GK,2,15
	DrawText "Koll.Verlust: "+TOBKEKT.KP,2,28
	
	Flip
	Cls
Until KeyHit(key_escape)