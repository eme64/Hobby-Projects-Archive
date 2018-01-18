SuperStrict
SeedRnd MilliSecs()

Type ENTITY
	Field x:Float
	Field y:Float
	
	Field color:Int[3]
	
	Method draw()
	End Method
	
	Method render()
	End Method
End Type

Type PARENT Extends ENTITY
	Field w:Float
	Field s:Float
	
	
	
	Function create:PARENT(x:Float,y:Float,w:Float,s:Float,r:Int,g:Int,b:Int)
		Local p:PARENT=New PARENT
		
		p.x=x
		p.y=y
		
		p.w=w
		p.s=s
		
		p.color[0]=r
		p.color[1]=g
		p.color[2]=b
				
		Return p
	End Function
	
	Method draw()
		SetColor Self.color[0],Self.color[1],Self.color[2]
		DrawOval Self.x-7,Self.y-7,14,14
	End Method
	
	Method render()
		Self.w:+Rnd()*20-10
		Self.s=Abs(Self.s+Rnd()-0.5)
		
		If Self.s<3 Then Self.s=3
		If Self.s>10 Then Self.s=10
		
		Self.x:+Cos(w)*s
		Self.y:+Sin(w)*s
		
		
		
		If Self.x<0 Then
			Self.w=0
			
			Rem
			
			Self.color[0]=Rand(0,255)
			Self.color[1]=Rand(0,255)
			Self.color[2]=Rand(0,255)
			
			End Rem
		End If
		
		If Self.x>800 Then
			Self.w=180
			
			Rem
			
			Self.color[0]=Rand(0,255)
			Self.color[1]=Rand(0,255)
			Self.color[2]=Rand(0,255)
			
			End Rem
		End If
		
		If Self.y<0 Then
			Self.w=90
			
			Rem
			
			Self.color[0]=Rand(0,255)
			Self.color[1]=Rand(0,255)
			Self.color[2]=Rand(0,255)
			
			End Rem
		End If
		
		If Self.y>600 Then
			Self.w=270
			
			Rem
			
			Self.color[0]=Rand(0,255)
			Self.color[1]=Rand(0,255)
			Self.color[2]=Rand(0,255)
			
			End Rem
		End If
	End Method
End Type

Type CHILD Extends ENTITY
	Field p:ENTITY
	
	Function create:CHILD(x:Float,y:Float,p:ENTITY,r:Int,g:Int,b:Int)
		Local c:CHILD=New CHILD
		
		c.x=x
		c.y=y
		
		c.p=p
		
		c.color[0]=r
		c.color[1]=g
		c.color[2]=b
		
		Return c
	End Function
	
	Method draw()
		SetColor Self.color[0],Self.color[1],Self.color[2]
		DrawOval Self.x-3,Self.y-3,6,6
	End Method
	
	Method render()
		Self.x:-(Self.x-Self.p.x)*0.5
		Self.y:-(Self.y-Self.p.y)*0.5
	End Method
End Type

Graphics 800,600,8,100
SetClsColor 0,0,0
SetBlend LIGHTBLEND

Local liste:TList=New TList

Local p:PARENT
Local c1:ENTITY


For Local ii:Int=1 To 3
	
	Local r:Int=255'Rand(0,255)
	Local g:Int=255'Rand(0,255)
	Local b:Int=255'Rand(0,255)
	
	p=PARENT.create(300,300,90,1,r,g,b)
	liste.addlast(p)
	
	c1=CHILD.create(200,100,p,r*Rnd(),g*Rnd(),b*Rnd())
	liste.addlast(c1)
	
	For Local i:Int=1 To Rand(400,700)
		Local c2:CHILD=CHILD.create(200,100,c1,r*Rnd(),g*Rnd(),b*Rnd())
		liste.addlast(c2)
		c1=c2
	Next
Next




Repeat
	For Local e:ENTITY=EachIn liste
		e.render()
		e.draw()
	Next
	
	
	
	Flip
	Cls
Until KeyHit(key_escape)