SuperStrict

'Import "-ldl"

Type TScreen
	Global x:Float = 400
	Global y:Float
	Global zoom:Float = 1
	Global dx:Int=800
	Global dy:Int=600
End Type

Type WORLD
	Global reibung:Float = 0.9
	Global gravitation:Float = 0.00002
End Type

Type TPoint
	Field x:Float
	Field y:Float
	
	Field vx:Float
	Field vy:Float
	
	Field mass:Float = 1
	
	Function Create:TPoint(x:Float,y:Float,mass:Float=1)
		Local p:TPoint = New TPoint
		
		p.x = x
		p.y = y
		p.mass = mass
		
		Return p
	End Function
	
	Method render(c:TCreature)
		Self.vy:-WORLD.gravitation
		
		Self.x:+Self.vx
		Self.y:+Self.vy
		
		If Self.y<0 Then
			Self.y = 0
			If Self.vy < 0 Then
				Self.y = 0
				Self.vx=Self.vx*WORLD.reibung
			End If
		End If
	End Method
	
	Method draw(c:TCreature)
		SetColor 0,0,0
		DrawOval (Self.x-TScreen.x)-5,(TScreen.dy-Self.y-TScreen.y)-5,10,10
	End Method
	
	Method copy:TPoint()
		Local p:TPoint = New TPoint
		
		p.x = Self.x
		p.y = Self.y
		p.vx = Self.vx
		p.vy = Self.vy
		p.mass = Self.mass
		
		Return p
	End Method
End Type

Type TLinker
	Field length:Float
	Field strength:Float
	
	Field p1:Int
	Field p2:Int
	
	Function Create:TLinker(p1:Int,p2:Int,length:Float,strength:Float)
		Local l:TLinker = New TLinker
		
		l.p1 = p1
		l.p2 = p2
		l.length = length
		l.strength = strength
		
		Return l
	End Function
	
	Method render(c:TCreature)
		Local distance:Float = ((c.points[p1].x-c.points[p2].x)^2+(c.points[p1].y-c.points[p2].y)^2)^0.5
		
		Self.apply_force(c, (length-distance)*strength)
	End Method
	
	Method adjust_length(c:TCreature)
		Self.length = ((c.points[p1].x-c.points[p2].x)^2+(c.points[p1].y-c.points[p2].y)^2)^0.5
	End Method
	
	Method apply_force(c:TCreature, force:Float)
		Local winkel:Float = ATan2(c.points[p1].y-c.points[p2].y, c.points[p1].x-c.points[p2].x)
		
		c.points[p1].vx:+Cos(winkel)*force/c.points[p1].mass
		c.points[p1].vy:+Sin(winkel)*force/c.points[p1].mass
		
		c.points[p2].vx:-Cos(winkel)*force/c.points[p2].mass
		c.points[p2].vy:-Sin(winkel)*force/c.points[p2].mass
	End Method
	
	Method draw(c:TCreature)
		SetColor 0,100,0
		DrawLine (c.points[p1].x-TScreen.x),(TScreen.dy-c.points[p1].y-TScreen.y), (c.points[p2].x-TScreen.x),(TScreen.dy-c.points[p2].y-TScreen.y)
	End Method
	
	Method copy:TLinker()
		Local l:TLinker= New TLinker
		
		l.length = Self.length
		l.strength = Self.strength
		
		l.p1 = Self.p1
		l.p2 = Self.p2
		
		Return l
	End Method
End Type

Type TGenom
	Field linker_nummer:Int'0-?
	Field strength:Float'minimum und maximum gegeben
	Field time:Int'minimum gegeben kein maximum
	
	Function Create:TGenom(linker_nummer:Int, strength:Float, time:Int)
		Local g:TGenom = New TGenom
		
		g.linker_nummer = linker_nummer
		g.strength = strength
		g.time = time
		
		Return g
	End Function
	
	Method copy:TGenom()
		Local g:TGenom= New TGenom
		
		g.linker_nummer = Self.linker_nummer
		g.strength = Self.strength
		g.time = Self.time
		
		Return g
	End Method
End Type

Type TCreature
	Field name:String' "1.2.6.2. ..."
	
	Field points:TPoint[]
	Field linkers:TLinker[]
	Field gencodes:TGenom[]
	Field act_gencode_reading:Int
	Field last_time:Int = MilliSecs()
	
	Field punkte:Float'so hoch wie möglich
	
	Method mutieren()
		'gencodes
		
		Local wert:Int = Rand(1,1000)
		
		If wert < 50 Then
			'insert random
			
			If Self.gencodes.length-1 > 0 Then
				Local new_place:Int = Rand(0,Self.gencodes.length)
				
				Local new_gencodes:TGenom[] = New TGenom[Self.gencodes.length+1]
				
				Local ii:Int = 0
				
				For Local i:Int = 0 To Self.gencodes.length
					If i = new_place Then
						new_gencodes[i] = Self.gencodes[ii]
						ii:+1
					Else
						new_gencodes[i] = TGenom.Create(Rand(0,Self.linkers.length-1), Rand(5,10)-5, Rand(300,1000))
					End If
				Next
				
				Self.gencodes = new_gencodes
			Else
				Self.gencodes = New TGenom[1]
				Self.gencodes[0] = TGenom.Create(Rand(0,Self.linkers.length-1), Rand(5,10)-5, Rand(300,1000))
			End If
		Else If wert < 100
			'delete random
			
			If Self.gencodes.length-1 > 0 Then
				
				Local new_gencodes:TGenom[] = New TGenom[Self.gencodes.length-1]
				
				Local to_kill:Int = Rand(0,Self.gencodes.length-1)
				
				Local ii:Int = 0
				
				For Local i:Int = 0 To Self.gencodes.length-1
					If i = to_kill Then
						'do not copy!
					Else
						new_gencodes[ii] = Self.gencodes[i]
						ii:+1
					End If
				Next
				
				Self.gencodes = new_gencodes
			End If
		Else If wert < 200
			'change linker number
			Local to_change:Int = Rand(0,Self.gencodes.length-1)
			Self.gencodes[to_change].linker_nummer = Rand(0,Self.linkers.length-1)
			
		Else If wert < 400
			'small change to strength
			Local to_change:Int = Rand(0,Self.gencodes.length-1)
			Self.gencodes[to_change].strength:+ (Rnd()-0.5)*2
		Else If wert < 600
			'random strength
			Local to_change:Int = Rand(0,Self.gencodes.length-1)
			Self.gencodes[to_change].strength=Rand(5,10)-5
		Else If wert < 800
			'small change to time
			Local to_change:Int = Rand(0,Self.gencodes.length-1)
			Self.gencodes[to_change].time:+ Rand(-100,100)
		Else
			'random time
			Local to_change:Int = Rand(0,Self.gencodes.length-1)
			Self.gencodes[to_change].time=Rand(300,1000)
		End If
		
		'linkers ?
		'points -> new linkers ???
	End Method
	
	Method render()
		
		If Self.linkers.length > 0 Then
			For Local i:Int = 0 To Self.linkers.length-1
				Self.linkers[i].render(Self)
			Next
		End If
		
		If Self.points.length > 0 Then
			For Local i:Int = 0 To Self.points.length-1
				Self.points[i].render(Self)
			Next
		End If
		
		If (MilliSecs()-Self.last_time) >= Self.gencodes[Self.act_gencode_reading].time Then
			Self.act_gencode_reading:+1
			If Self.act_gencode_reading>Self.gencodes.length-1 Then
				Self.act_gencode_reading=0
			End If
			
			Self.linkers[Self.gencodes[Self.act_gencode_reading].linker_nummer].apply_force(Self, Self.gencodes[Self.act_gencode_reading].strength)
			Self.last_time = MilliSecs()
		End If
	End Method
	
	Method draw()
		If Self.points.length > 0 Then
			For Local i:Int = 0 To Self.points.length-1
				Self.points[i].draw(Self)
			Next
		End If
		
		If Self.linkers.length > 0 Then
			For Local i:Int = 0 To Self.linkers.length-1
				Self.linkers[i].draw(Self)
			Next
		End If
	End Method
	
	Method get_mid_x:Float()
		Local x:Float
		
		If Self.points.length > 0 Then
			For Local i:Int = 0 To Self.points.length-1
				x:+Self.points[i].x
			Next
			
			Return x/Self.points.length
		End If
		
		Return 0
	End Method
	
	Method get_mid_y:Float()
		Local y:Float
		
		If Self.points.length > 0 Then
			For Local i:Int = 0 To Self.points.length-1
				y:+Self.points[i].y
			Next
			
			Return y/Self.points.length
		End If
		
		Return 0
	End Method
	
	Method copy:TCreature(child_name:String)
		Local c:TCreature = New TCreature
		
		c.name = child_name
		c.act_gencode_reading = 0
		c.last_time = MilliSecs()
		c.punkte = 0
		
		'POINTS
		c.points= New TPoint[Self.points.length]
		
		If Self.points.length > 0 Then
			For Local i:Int = 0 To Self.points.length-1
				c.points[i] = Self.points[i].copy()
			Next
		End If
		
		'Linkers
		c.linkers= New TLinker[Self.linkers.length]
		
		If Self.linkers.length>0 Then
			For Local i:Int = 0 To Self.linkers.length-1
				c.linkers[i] = Self.linkers[i].copy()
			Next
		End If
		
		'gencodes
		c.gencodes= New TGenom[Self.gencodes.length]
		
		If Self.gencodes.length>0 Then
			For Local i:Int = 0 To Self.gencodes.length-1
				c.gencodes[i] = Self.gencodes[i].copy()
			Next
		End If
		
		Return c
	End Method
End Type

Graphics TScreen.dx, TScreen.dy
SetClsColor 255,255,255

Rem
Local c:TCreature = New TCreature

c.points= New TPoint[4]
c.points[0] = TPoint.create(300,600)
c.points[1] = TPoint.create(400,600)
c.points[2] = TPoint.create(400,500)
c.points[3] = TPoint.create(300,500)

c.linkers= New TLinker[6]
c.linkers[0] = TLinker.create(0,1,50,0.1)
c.linkers[1] = TLinker.create(1,2,50,0.1)
c.linkers[2] = TLinker.create(2,3,50,0.1)
c.linkers[3] = TLinker.create(3,0,50,0.1)
c.linkers[4] = TLinker.create(0,2,50,0.1)
c.linkers[5] = TLinker.create(1,3,50,0.1)

For Local i:Int = 0 To 5
	c.linkers[i].adjust_length(c)
Next

c.gencodes = New TGenom[10]
For Local i:Int = 0 To 9
	c.gencodes[i] = TGenom.create(Rand(0,3), Rand(0,1), Rand(500,1000))
Next
End Rem

Local save_creatures:TCreature[100]
Local creatures:TCreature[100]

For Local iii:Int = 0 To 99
	Local c:TCreature = New TCreature
	
	c.name = iii
	
	c.points= New TPoint[5]
	c.points[0] = TPoint.Create(350,70)
	c.points[1] = TPoint.Create(450,70)
	c.points[2] = TPoint.Create(400,35)
	c.points[3] = TPoint.Create(330,0)
	c.points[4] = TPoint.Create(470,0)
	
	
	c.linkers= New TLinker[7]
	c.linkers[0] = TLinker.Create(0,1,50,0.05)
	c.linkers[1] = TLinker.Create(0,2,50,0.05)
	c.linkers[2] = TLinker.Create(2,1,50,0.05)
	c.linkers[3] = TLinker.Create(0,3,50,0.05)
	c.linkers[4] = TLinker.Create(3,2,50,0.05)
	c.linkers[5] = TLinker.Create(2,4,50,0.05)
	c.linkers[6] = TLinker.Create(4,1,50,0.05)
	
	For Local i:Int = 0 To 6
		c.linkers[i].adjust_length(c)
	Next
	
	c.gencodes = New TGenom[10]
	For Local i:Int = 0 To 9
		c.gencodes[i] = TGenom.Create(Rand(3,6), Rand(5,10)-5, Rand(300,1000))
	Next
	
	creatures[iii] = c
	save_creatures[iii] = c.copy(c.name)
	
	'liste.addlast(c)
	'save_liste.addlast(c.copy(c.name))
Next

Local last_generation_start:Int = MilliSecs()
Local time_for_one_generation:Int = 1000*20


Repeat
	Cls
	
	Rem
	If KeyHit(key_space) Then
		liste = New TList
		
		For Local c:TCreature = EachIn save_liste
			liste.addlast(c.copy(c.name))
		Next
	End If
	End Rem
	
	If KeyHit(key_space) Then
		creatures = New TCreature[save_creatures.length]
		
		For Local i:Int = 0 To save_creatures.length-1
			creatures[i] = save_creatures[i].copy(save_creatures[i].name)
		Next
	End If
	
	
	If KeyHit(key_n) Or (MilliSecs() > last_generation_start + time_for_one_generation) Then
		last_generation_start = MilliSecs()
		
		'get me the best!
		Local c_winner:Int
		
		For Local i:Int = 0 To creatures.length-1
			Local c:TCreature = creatures[i]
			
			If i = 0 Then
				c_winner = i
			Else
				If creatures[c_winner].get_mid_x() < c.get_mid_x() Then
					c_winner = i
				End If
			End If
			
		Next
		
		'copy to all other slots!
		Local winner:TCreature = save_creatures[c_winner].copy(save_creatures[c_winner].name)
		
		For Local i:Int = 0 To creatures.length-1
			creatures[i] = winner.copy(winner.name + "." + i)
			
			If i > 0 Then
				creatures[i].mutieren()
			End If
			
			save_creatures[i] = creatures[i].copy(creatures[i].name)
		Next
		
	End If
	
	
	For Local i:Int = 1 To 20
		For Local ii:Int = 0 To creatures.length-1
			Local c:TCreature = creatures[ii]
			c.render()
		Next
	Next
	
	'TScreen.x = c.get_mid_x() - TScreen.dx/2
	'TScreen.y = c.get_mid_y() + TScreen.dy/2
	
	
	For Local ii:Int = 0 To creatures.length-1
		Local c:TCreature = creatures[ii]
		c.draw()
		
		SetColor 0,0,0
		DrawText c.name,10,ii*100
		
		
		If c.gencodes.length>0 Then
			For Local i:Int = 0 To c.gencodes.length-1
				SetColor 100,100,100
				
				If c.act_gencode_reading = i Then
					SetColor 0,0,0
				End If
				
				DrawText c.gencodes[i].linker_nummer,10 + i*40,ii*100 + 20
				DrawText Int(c.gencodes[i].strength),10 + i*40,ii*100 + 40
				DrawText c.gencodes[i].time,10 + i*40,ii*100 + 60
			Next
		End If
	Next
	
	SetColor 0,100,0
	DrawRect 0, (TScreen.dy-TScreen.y), TScreen.dx, TScreen.dy
	
	SetColor 255,0,0
	For Local i:Int = - 10 To 10
		DrawRect (TScreen.dx-TScreen.x) + i * 100, 0, 2, TScreen.dy
	Next
	
	Flip
Until KeyHit(key_escape) Or AppTerminate()