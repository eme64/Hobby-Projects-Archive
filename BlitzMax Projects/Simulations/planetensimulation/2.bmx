Strict


Type ANSICHT
	Global zoom:Float=0
	
	Function render_zoom()
		ANSICHT.zoom:+KeyDown(key_up)*0.001-KeyDown(key_down)*0.001
		If ANSICHT.zoom<=0 Then ANSICHT.zoom=0.001
		SetScale ANSICHT.zoom, ANSICHT.zoom
	End Function
End Type

Type OBJEKT
	Global list:TList
	Const gavitation:Float=10^6'6.6742867*10^-11'Gravitationskonstante
	Field x:Float, vx:Float, ax:Float
	Field y:Float, vy:Float, ay:Float
	Field r:Float
	Field m:Float
	Field mark:String
	
	Field color:Int[3]
	
	Function Create:OBJEKT(x:Float, y:Float, vx:Float=0, vy:Float=0,rad:Float=10 , m:Float=10, r:Int=100, g:Int=100, b:Int=100, mark:String="")
		Local o:OBJEKT=New OBJEKT
		o.x=x
		o.y=y
		
		o.vx=vx
		o.vy=vy
		
		o.r=rad
		o.m=m
		
		o.color[0]=r
		o.color[1]=g
		o.color[2]=b
		
		o.mark=mark
		
		OBJEKT.list.addlast(o)
		
		Return o
	End Function
	
	Method draw()
		SetColor Self.color[0], Self.color[1], Self.color[2]
		DrawOval (Self.x-Self.r)*ANSICHT.zoom+800/2, (Self.y-Self.r)*ANSICHT.zoom+600/2, 2*r, 2*r
		If Self.mark<>"" Then
			SetScale 1,1
			SetColor 255,0,0
			DrawText Self.mark, (Self.x*ANSICHT.zoom+800/2)-10,(Self.y*ANSICHT.zoom+600/2)-10
			SetScale ANSICHT.zoom, ANSICHT.zoom
		End If
	End Method
	
	Method render()
		Self.ax=0
		Self.ay=0
		For Local o:OBJEKT=EachIn OBJEKT.list
			
			If o <> Self Then
				Local w:Float=ATan2(o.y-Self.y,o.x-Self.x)
				Local d:Float=Sqr((o.x-Self.x)^2+(o.y-Self.y)^2)
				
				Local a:Float=o.m*OBJEKT.gavitation/(d^2)
				
				Self.ax:+Cos(w)*a
				Self.ay:+Sin(w)*a
			End If
		Next
		Self.vx:+Self.ax
		Self.vy:+Self.ay
		
		Self.x:+Self.vx
		Self.y:+Self.vy
	End Method
End Type

OBJEKT.list=New TList

Graphics 800,600,32,30,1

SeedRnd MilliSecs()

SetBlend ALPHABLEND

Rem sonne erde mond
OBJEKT.Create(0, 0, 0, 0,50 , 1000, 255,255,100,"s")

OBJEKT.Create(10000, 0, 0, 300,30 , 5, 100,150,255,"e")

OBJEKT.Create(10500, 0, 0, 210,30 , 0.01, 100,150,255,"m")'200
End Rem

'Rem
OBJEKT.Create(-20000, 0, 0, -110,50 , 1000, 255,255,100,"s1")
OBJEKT.Create(20000, 0, 0, 110,50 , 1000, 255,255,100,"s2")

OBJEKT.Create(100000, 0, 0, 200,50 , 200, 0,100,255,"e")
OBJEKT.Create(110000, 0, 0, 400,50 , 2, 0,100,255,"m")

OBJEKT.Create(1000, 0, 0, 350,50 , 1, 100,250,250,"k")
OBJEKT.Create(1800, 0, 0, 350,50 , 0.01, 100,250,250,"x")
'End Rem
'OBJEKT.Create(0, 0, -1000, -100,50 , 1, 100,250,250)

'Create:OBJEKT(x, y, vx, vy,rad , m, r, g, b)


Repeat
	
	ANSICHT.render_zoom()
	For Local o:OBJEKT=EachIn OBJEKT.list
		o.render()
	Next
	
	For Local o:OBJEKT=EachIn OBJEKT.list
		o.draw()
	Next
	
	'WaitKey()
	Flip
	
	Cls
Until KeyDown(key_escape) Or AppTerminate()
End