SuperStrict


SeedRnd MilliSecs()

Type TPLANT
	Global liste:TList=New TList
	
	Global image:TImage
	
	Function ini()
		TPLANT.image=LoadImage("gfx/pflanze.png")
		MidHandleImage TPLANT.image
	End Function
	
	Global r:Float=3
	Field x:Float
	Field y:Float
	Field w:Float
	
	Field status:Int
	Field status_end:Int
	
	Function create:TPLANT(x:Float,y:Float)
		
		If x<105 Then Return Null
		If y<105 Then Return Null
		
		If x>695 Then Return Null
		If y>495 Then Return Null
		
		Local p:TPLANT=New TPLANT
		TPLANT.liste.addlast(p)
		p.x=x
		p.y=y
		p.status_end=Rand(100,150)
		p.status=0
		p.w=Rnd()*360.0
		
		For Local pp:TPLANT=EachIn TPLANT.liste
			If pp><p Then
				If (pp.x-p.x)^2+(pp.y-p.y)^2<(pp.r+p.r)^2 Then
					TPLANT.liste.remove(p)
					Return Null
				End If
			End If
		Next
		
		Return p
	End Function
	
	Method render()
		Self.status:+3
		
		'Self.w:+(Rnd()*10.0-5.0)
		
		'If Self.x<0 Then Self.w=0
		'If Self.x>800 Then Self.w=180
		'If Self.y<0 Then Self.w=90
		'If Self.y>600 Then Self.w=270
		
		'Self.x:+Cos(Self.w)*0.12
		'Self.y:+Sin(Self.w)*0.12
		
		Rem
		If Rand(1,20)=1
			For Local p:TPLANT=EachIn TPLANT.liste
				If p><Self Then
					If (Self.x-p.x)^2+(Self.y-p.y)^2<(Self.r+p.r)^2 Then
						
						If (Self.status/Self.status_end)>(p.status/p.status_end) Then
							TPLANT.liste.remove(p)
						Else
							TPLANT.liste.remove(Self)
						End If
						
					End If
				End If
			Next
		End If
		End Rem
		
		If Self.status>=Self.status_end Then
			For Local i:Int=1 To Rand(2,3)
				TPLANT.create(Self.x+Rand(-20,20),Self.y+Rand(-20,20))
			Next
			
			Self.status_end=Rand(100,150)
			Self.status=0
		End If
		
	End Method
	
	Method draw()
		Rem
		SetColor 255,255,255
		DrawOval Self.x-Self.r,Self.y-Self.r,2*Self.r,2*Self.r
		
		SetColor 0,100,0
		DrawOval Self.x-Self.r+1,Self.y-Self.r+1,2*Self.r-2,2*Self.r-2
		
		SetColor 255-(255*Self.status/Self.status_end),255,255-(255*Self.status/Self.status_end)
		DrawOval Self.x-Self.r+2,Self.y-Self.r+2,2*Self.r-4,2*Self.r-4
		End Rem
		
		SetColor 255-(255*Self.status/Self.status_end),255,255-(255*Self.status/Self.status_end)
		DrawImage TPLANT.image,Self.x,Self.y
		
		
	End Method
End Type

Type TTIER
	Global liste:TList=New TList
	
	Field r:Float
	Field x:Float
	Field y:Float
	Field w:Float
	Field gender:Int'1=m,2=w
	Field nahrung:Float
	
	Field anz_paarungen:Int
	
	Field paarend:TTIER
	Field time_to_paarung:Int
	
	Field status:Int'0=ei,1=kind,2=erwachsen,3-6=erwachsen und schon mal gepaart,7=alt
	Field last_status_time:Int
	
	Function create:TTIER(x:Float,y:Float,gender:Int,r:Float)
		Local t:TTIER=New TTIER
		t.x=x
		t.y=y
		t.gender=gender
		
		If t.gender=1 Then t.anz_paarungen=10 Else t.anz_paarungen=5
		
		t.r=r
		t.w=Rnd()*360
		t.nahrung=0
		t.status=0
		t.last_status_time=Rand(1,60)
		TTIER.liste.addlast(t)
		Return t
	End Function
	
	Method render()
		Select Self.status
			Case 0
				Self.last_status_time:+1
				If Self.last_status_time>5*60 Then
					Self.status=1
					Self.nahrung=50.0
					Self.last_status_time=0
				End If
			Case 1
				Self.nahrung:-0.12
				
				Self.w:+(Rnd()*10.0-5.0)
				Self.hunting()
				
				If Self.x<0 Then Self.w=0
				If Self.x>800 Then Self.w=180
				If Self.y<0 Then Self.w=90
				If Self.y>600 Then Self.w=270
				
				Self.x:+Cos(Self.w)*0.5
				Self.y:+Sin(Self.w)*0.5
				
				If Self.nahrung<0 Then TTIER.liste.remove(Self)
				
				If Self.nahrung>70 Then
					Self.status=2
					Self.nahrung:-50
				End If
				
			Default
				If Self.nahrung>100 Then Self.nahrung=100
				
				
				If Self.anz_paarungen+1>Self.status Then
					
					Self.nahrung:-0.3'0.3
					Self.time_to_paarung:-1
					
					Local dd:Float=((Self.x-Self.paarend.x)^2+(Self.y-Self.paarend.y)^2)^0.5
					
					If Self.nahrung>50 Then
						
						Self.w:+(Rnd()*10.0-5.0)
						Self.hunting()
						
						If Rand(1,20) Then
							If Self.gender=1 And Self.time_to_paarung<0 Then
								If Self.nahrung>70 Then'And Self.paarend=Null Then
									Local d:Float=1000.0
									
									Local ddd:Float=((Self.x-Self.paarend.x)^2+(Self.y-Self.paarend.y)^2)^0.5
									
									For Local t:TTIER=EachIn TTIER.liste
										If t.time_to_paarung<0 And t.anz_paarungen+1>t.status And t.time_to_paarung<0 And t.gender<>Self.gender And t.nahrung>70 Then
											
											If ddd<d Then
												Self.paarend=t
												d=ddd
												dd=ddd
											End If
										End If
									Next
								End If
							End If
						End If
						
						If TTIER.liste.contains(Self.paarend) And Self.paarend.anz_paarungen+1>Self.paarend.status Then
							If Self.paarend.nahrung>50 Then
								Self.w=ATan2(Self.y-Self.paarend.y,Self.x-Self.paarend.x)+180
								
								Self.x:+Cos(Self.w)*0.5
								Self.y:+Sin(Self.w)*0.5
								
								If dd<Self.r+Self.paarend.r Then
									Self.status:+1
									Self.nahrung=40
									'Self.time_to_paarung=60*5
									
									Self.paarend.status:+1
									Self.paarend.nahrung=40
									'Self.paarend.time_to_paarung=60*20
									
									For Local i:Int=1 To Rand(1,Rand(1,5))
										TTIER.create(Self.paarend.x+Rnd()*30-15,Self.paarend.y+Rnd()*30-15,Rand(Rand(1,Rand(1,2)),2),(Self.paarend.r+Self.r)*0.5+Rnd()*2.0-1.0)
									Next
								End If
							Else
								Self.paarend=Null
							End If
						Else
							Self.paarend=Null
							
						End If
					Else
						Self.paarend=Null
						Self.w:+(Rnd()*10.0-5.0)
						
						Self.hunting()
					End If
					
					If Self.x<0 Then Self.w=0
					If Self.x>800 Then Self.w=180
					If Self.y<0 Then Self.w=90
					If Self.y>600 Then Self.w=270
					
					Self.x:+Cos(Self.w)*0.8
					Self.y:+Sin(Self.w)*0.8
					
					If Self.nahrung<0 Then TTIER.liste.remove(Self)
					
				Else
					Self.nahrung:-0.1
					
					Self.w:+(Rnd()*10.0-5.0)
					
					If Self.x<0 Then Self.w=0
					If Self.x>800 Then Self.w=180
					If Self.y<0 Then Self.w=90
					If Self.y>600 Then Self.w=270
					
					Self.x:+Cos(Self.w)*0.5
					Self.y:+Sin(Self.w)*0.5
					
					If Self.nahrung<0 Then TTIER.liste.remove(Self)
				End If
		End Select
	End Method
	
	Method hunting()
		If Rand(1,3)=1 Then
			Local d:Float=350.0
			
			For Local p:TPLANT=EachIn TPLANT.liste
				Local dd:Float=((Self.x-p.x)^2+(Self.y-p.y)^2)^0.5
				If Float(p.status)/Float(p.status_end)>0.2 Then
					If dd<Self.r+p.r Then
						TPLANT.liste.remove(p)
						Self.nahrung:+2.0
					ElseIf dd<d Then
						d=dd
						Self.w=ATan2(Self.y-p.y,Self.x-p.x)+180
					End If
				End If
			Next
		End If
	End Method
	
	Method draw()
		Select Self.status
			Case 0
				SetColor 200,255,200
				DrawOval Self.x-Self.r,Self.y-Self.r,2*Self.r,2*Self.r
				
			Case 1
				If Self.gender=1 Then SetColor 100,100,255 Else SetColor 255,100,100
				DrawOval Self.x-Self.r,Self.y-Self.r,2*Self.r,2*Self.r
				
				SetColor 50,50,100
				DrawOval Self.x-Self.r+2,Self.y-Self.r+2,2*Self.r-4,2*Self.r-4
				
				SetColor 0,0,0
				DrawLine Self.x,Self.y,Self.x+Cos(Self.w)*Self.r,Self.y+Sin(Self.w)*Self.r
				
			Default
				If Self.gender=1 Then SetColor 100,100,255 Else SetColor 255,100,100
				DrawOval Self.x-Self.r,Self.y-Self.r,2*Self.r,2*Self.r
				
				SetColor (Self.status-2.0)*255/Self.anz_paarungen,255-(Self.status-2.0)*255/Self.anz_paarungen,0
				DrawOval Self.x-Self.r+2,Self.y-Self.r+2,2*Self.r-4,2*Self.r-4
				
				SetColor 0,0,0
				DrawLine Self.x,Self.y,Self.x+Cos(Self.w)*Self.r,Self.y+Sin(Self.w)*Self.r
		End Select
	End Method
End Type

Type TGRAPH
	Field feld:Float[]
	Field anz_werte:Int
	Field color:Int[3]
	
	Function create:TGRAPH(anz_werte:Int,r:Int,gg:Int,b:Int)
		Local g:TGRAPH=New TGRAPH
		g.anz_werte=anz_werte
		g.feld=New Float[g.anz_werte]
		g.color[0]=r
		g.color[1]=gg
		g.color[2]=b
		Return g
	End Function
	
	Method add(number:Float)
		For Local i:Int=0 To Self.anz_werte-2
			Self.feld[i]=Self.feld[i+1]
		Next
		Self.feld[Self.anz_werte-1]=number
	End Method
	
	Method draw(x:Float,y:Float,dx:Float,dy:Float)
		
		SetColor Self.color[0],Self.color[1],Self.color[2]
		For Local i:Int=0 To Self.anz_werte-2
			DrawLine x+i*dx,y-dy*Self.feld[i],x+(i+1)*dx,y-dy*Self.feld[i+1]
		Next
		
	End Method
End Type

Graphics 800,600
SetBlend alphablend

TPLANT.ini()

TPLANT.create(150,150)
TPLANT.create(150,450)
TPLANT.create(650,150)
TPLANT.create(650,450)

TPLANT.create(250,250)
TPLANT.create(250,350)
TPLANT.create(550,250)
TPLANT.create(550,350)

TTIER.create(200,150,1,6)
TTIER.create(200,450,2,6)
TTIER.create(600,150,1,6)
TTIER.create(600,450,2,6)

Local tier_graph:TGRAPH=TGRAPH.create(800,255,0,0)
Local pflanzen_graph:TGRAPH=TGRAPH.create(800,0,255,255)

tier_graph.add(TTIER.liste.count())
pflanzen_graph.add(TPLANT.liste.count())

Local graph_time:Int=0

Repeat
	graph_time:+1
	Cls
	
	Local time:Int
	
	time=MilliSecs()
	
	For Local p:TPLANT=EachIn TPLANT.liste
		If Rand(1,5)=1 Then p.render()
	Next
	
	Print (MilliSecs()-time)
	time=MilliSecs()
	
	For Local t:TTIER=EachIn TTIER.liste
		t.render()
	Next
	
	Print (MilliSecs()-time)
	time=MilliSecs()
	
	For Local p:TPLANT=EachIn TPLANT.liste
		p.draw()
	Next
	
	Print (MilliSecs()-time)
	time=MilliSecs()
	
	For Local t:TTIER=EachIn TTIER.liste
		t.draw()
	Next
	
	Print (MilliSecs()-time)
	
	Print "---"
	
	
	
	SetColor 0,0,0
	SetAlpha 0.5
	DrawRect 5,5,200,100
	SetAlpha 1
	SetColor 255,255,255
	DrawText TPLANT.liste.count()+" Pflanzen",10,10
	DrawText TTIER.liste.count()+" Tiere",10,40
	
	tier_graph.draw(0,300,1,2)
	pflanzen_graph.draw(0,300,1,0.04)
	
	If graph_time>60*1 Then
		graph_time=0
		tier_graph.add(TTIER.liste.count())
		pflanzen_graph.add(TPLANT.liste.count())
	End If
	
	Flip
Until KeyHit(key_escape)