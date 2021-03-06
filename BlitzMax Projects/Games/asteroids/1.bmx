Strict
Graphics 800,600,0

'ASTEROIDEN

Global asteroiden_liste:TList=New TList

Type asteroid
	Field x:Float,y:Float
	Field s_x:Float,s_y:Float
	Field winkel:Float
	Field add_winkel:Float
	Field ecken[12,4]
	Method New()
		Self.x=Rand(800)
		Self.y=Rand(600)
		Self.winkel=Rand(360)
		Self.add_winkel=Rnd()*2
		Self.s_x=Cos(Self.winkel)*Rnd()*2
		Self.s_y=Sin(Self.winkel)*Rnd()*2
		For Local i:Int=0 To 11
			Self.ecken[i,0]=Rand(5,15)
			Self.ecken[i,1]=i*30+Rand(-10,10)
		Next
	End Method
	Method render()
		Self.y:+Self.s_y
		Self.x:+Self.s_x
		If Self.y<0 Or Self.y>600 Then Self.s_y=-Self.s_y
		If Self.x<0 Or Self.x>800 Then Self.s_x=-Self.s_x
		Self.winkel:+Self.add_winkel
		For Local i:Int=0 To 11
			Self.ecken[i,2]=Cos(Self.winkel+Self.ecken[i,1])*Self.ecken[i,0]+Self.x
			Self.ecken[i,3]=Sin(Self.winkel+Self.ecken[i,1])*Self.ecken[i,0]+Self.y
		Next
	End Method
	Method draw()
		SetColor 200,150,150
		For Local i:Int=0 To 10
			DrawLine Self.ecken[i,2],Self.ecken[i,3],Self.ecken[i+1,2],Self.ecken[i+1,3]
		Next
		DrawLine Self.ecken[11,2],Self.ecken[11,3],Self.ecken[0,2],Self.ecken[0,3]
	End Method
End Type

For Local i:Int=1 To 20
	Local a:asteroid=New asteroid
	asteroiden_liste.addlast(a)
Next


'SPIELER
Global spieler_liste:TList=New TList

Type spieler Abstract
	Field x:Float,y:Float
	Field s_x:Float,s_y:Float
	Field winkel:Float,add_winkel:Float
	Field speed:Float
	Field ecken[9,4]
	Field keys[5]'rechts,links,gas,bremse,schuss
	Field color[3]
	Field shot_counter
	Field shot_abstand
	
	Method render()
		If KeyDown(Self.keys[0]) Then Self.add_winkel:+1.1
		If KeyDown(Self.keys[1]) Then Self.add_winkel:-1.1
		
		If KeyDown(Self.keys[2]) Then
			Self.speed:+0.1
			Local k:kreise=New kreise
			k.set(Self.x,Self.y,Self.winkel-180+Rand(-30,30),3,255,100,0,1,Rand(2,20),100)
			kreise_liste.addlast(k)
		End If
		
		If KeyDown(Self.keys[3]) Then
			Self.speed:/2
			Self.s_x:/1.1
			Self.s_y:/1.1
		End If
		
		Self.shot_counter:+1
		
		If KeyDown(Self.keys[4]) Then
			If Self.shot_counter>=Self.shot_abstand Then
				
				For Local i:Int=0 To 0
					Local s:shot_green=New shot_green
					s.set(Self.x,Self.y,Self.winkel+i*5,5+Sqr(Self.s_x^2+Self.s_y^2))
					shot_liste.addlast(s)
				Next
				
				Self.shot_counter=0
			End If
		End If
		
		
		Self.s_x:+Cos(Self.winkel)*Self.speed
		Self.s_y:+Sin(Self.winkel)*Self.speed
		Self.speed:/2
		
		Self.y:+Self.s_y
		Self.x:+Self.s_x
		If Self.y<0 Or Self.y>600 Then Self.s_y=-Self.s_y
		If Self.x<0 Or Self.x>800 Then Self.s_x=-Self.s_x
		Self.winkel:+Self.add_winkel
		add_winkel:/2
		For Local i:Int=0 To 8
			Self.ecken[i,2]=Cos(Self.winkel+Self.ecken[i,1])*Self.ecken[i,0]+Self.x
			Self.ecken[i,3]=Sin(Self.winkel+Self.ecken[i,1])*Self.ecken[i,0]+Self.y
		Next
		
		For Local a:asteroid = EachIn asteroiden_liste
			If (a.x-Self.x)^2+(a.y-Self.y)^2<15^2 Then
				
				Local k:kreise=New kreise
				k.set(Self.x,Self.y,0,0,200,100,50,2,50,20)
				kreise_liste.addlast(k)
				
				ListRemove(asteroiden_liste,a:asteroid)
				ListRemove(spieler_liste,Self)
			End If
		Next
		
		
	End Method
	
	Method draw()
		SetColor Self.color[0],Self.color[1],Self.color[2]
		For Local i:Int=0 To 7
			DrawLine Self.ecken[i,2],Self.ecken[i,3],Self.ecken[i+1,2],Self.ecken[i+1,3]
		Next
		DrawLine Self.ecken[8,2],Self.ecken[8,3],Self.ecken[0,2],Self.ecken[0,3]
	End Method
End Type

Type s_1 Extends spieler
	Method New()
		Self.x=100
		Self.y=300
		
		Self.ecken[0,0]=20
		Self.ecken[0,1]=0
		
		Self.ecken[1,0]=6
		Self.ecken[1,1]=90
		
		Self.ecken[2,0]=11
		Self.ecken[2,1]=120
		
		
		Self.ecken[3,0]=8
		Self.ecken[3,1]=170
		
		Self.ecken[4,0]=12
		Self.ecken[4,1]=160
		
		Self.ecken[5,0]=12
		Self.ecken[5,1]=200
		
		Self.ecken[6,0]=8
		Self.ecken[6,1]=190
		
		
		Self.ecken[7,0]=11
		Self.ecken[7,1]=240
		
		Self.ecken[8,0]=6
		Self.ecken[8,1]=270
		
		Self.keys[0]=key_d
		Self.keys[1]=key_a
		Self.keys[2]=key_w
		Self.keys[3]=key_s
		Self.keys[4]=KEY_f
		
		Self.color[0]=255
		Self.color[1]=0
		Self.color[2]=0
		
		Self.shot_abstand=25
	End Method
End Type

Type s_2 Extends spieler
	Method New()
		Self.x=700
		Self.y=300
		
		Self.ecken[0,0]=20
		Self.ecken[0,1]=0
		
		Self.ecken[1,0]=6
		Self.ecken[1,1]=90
		
		Self.ecken[2,0]=11
		Self.ecken[2,1]=120
		
		
		Self.ecken[3,0]=8
		Self.ecken[3,1]=170
		
		Self.ecken[4,0]=12
		Self.ecken[4,1]=160
		
		Self.ecken[5,0]=12
		Self.ecken[5,1]=200
		
		Self.ecken[6,0]=8
		Self.ecken[6,1]=190
		
		
		Self.ecken[7,0]=11
		Self.ecken[7,1]=240
		
		Self.ecken[8,0]=6
		Self.ecken[8,1]=270
		
		Self.keys[0]=key_right
		Self.keys[1]=key_left
		Self.keys[2]=key_up
		Self.keys[3]=key_down
		Self.keys[4]=KEY_NUM0
		
		Self.color[0]=0
		Self.color[1]=255
		Self.color[2]=0
		
		Self.shot_abstand=25
	End Method
End Type

Local s1:s_1=New s_1
Local s2:s_2=New s_2
spieler_liste.addlast(s1)
spieler_liste.addlast(s2)

Global shot_liste:TList=New TList
Type shot Abstract
	Field x:Float,y:Float
	Field s_x:Float,s_y:Float
	Field winkel:Float
	Field speed:Float
	Field color[3]
	
	Method render()
		Self.x:+Self.s_x
		Self.y:+Self.s_y
		
		For Local a:asteroid = EachIn asteroiden_liste
			If (a.x-Self.x)^2+(a.y-Self.y)^2<15^2 Then
				Local k:kreise=New kreise
				k.set(Self.x,Self.y,0,0,200,100,50,2,30,20)
				kreise_liste.addlast(k)
				
				ListRemove(asteroiden_liste,a:asteroid)
				ListRemove(shot_liste,Self)
			End If
		Next
		For Local s:spieler = EachIn spieler_liste
			If (s.x-Self.x)^2+(s.y-Self.y)^2<15^2 Then
				
				Local k:kreise=New kreise
				k.set(Self.x,Self.y,0,0,200,100,50,2,50,20)
				kreise_liste.addlast(k)
				
				ListRemove(spieler_liste,s:spieler)
				ListRemove(shot_liste,Self)
			End If
		Next
		
	End Method
	
	Method draw()
		SetColor Self.color[0],Self.color[1],Self.color[2]
		DrawLine Self.x,Self.y,Self.x+Cos(Self.winkel+180)*speed*2,Self.y+Sin(Self.winkel+180)*speed*2
	End Method
	
	Method set(x,y,w,s)
		Self.winkel=w
		Self.speed=s
		Self.s_x=Cos(Self.winkel)*Self.speed
		Self.s_y=Sin(Self.winkel)*Self.speed
		Self.x=x+Cos(Self.winkel)*20
		Self.y=y+Sin(Self.winkel)*20
	End Method
End Type

Type shot_red Extends shot
	Method New()
		Self.color[0]=255
		Self.color[1]=0
		Self.color[2]=0
	End Method
End Type

Type shot_green Extends shot
	Method New()
		Self.color[0]=0
		Self.color[1]=0
		Self.color[2]=255
	End Method
End Type

Global kreise_liste:TList=New TList

Type kreise
	Field x:Float,y:Float
	Field s_x:Float,s_y:Float
	Field count:Float,count_bis:Float
	Field wachsen_von:Float,wachsen_bis:Float
	Field zoom:Float
	Field color[0]
	
	Method render()
		Self.count:+1
		If Self.count>=Self.count_bis Then
			ListRemove(kreise_liste,Self)
		End If
		Self.x:+Self.s_x
		Self.y:+Self.s_y
	End Method
	Method draw()
		SetAlpha((1-Self.count/Self.count_bis))
		
		'SetColor Self.color[0]*(1-Self.count/Self.count_bis),Self.color[1]*(1-Self.count/Self.count_bis),Self.color[2]*(1-Self.count/Self.count_bis)
		SetColor Self.color[0],Self.color[1],Self.color[2]
		
		Self.zoom=((Self.wachsen_bis-Self.wachsen_von)*1.0*(Self.count/Self.count_bis))+Self.wachsen_von
		DrawOval Self.x-Self.zoom/2,Self.y-Self.zoom/2,Self.zoom,Self.zoom
		
		SetAlpha(1)
	End Method
	Method set(x,y,w,s,r,g,b,gr_v,gr_b,c_b)
		Self.x=x
		Self.y=y
		Self.s_x=Cos(w)*s
		Self.s_y=Sin(w)*s
		Self.count_bis=c_b
		Self.wachsen_von=gr_v
		Self.wachsen_bis=gr_b
		
		Self.color[0]=r
		Self.color[1]=g
		Self.color[2]=b
		
		Self.count=0
	End Method
End Type

'LIGHTBLEND
'ALPHABLEND

SetBlend(ALPHABLEND)


Repeat
	Cls
	For Local k:kreise = EachIn kreise_liste
		k.render()
		k.draw()
	Next
	
	For Local a:asteroid = EachIn asteroiden_liste
		a.render()
		a.draw()
	Next
	
	For Local s:spieler = EachIn spieler_liste
		s.render()
		s.draw()
	Next
	
	For Local s:shot = EachIn shot_liste
		s.render()
		s.draw()
	Next
	
	Flip
Until KeyHit(key_escape) Or AppTerminate()
End