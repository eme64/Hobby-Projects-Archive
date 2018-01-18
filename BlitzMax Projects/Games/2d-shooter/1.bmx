SuperStrict
Rem

-leben
-schussrate
-super_power(schussrate)
-anz_sch�sse
-tempo

End Rem

Type TOBJEKT
	
	Field x:Float
	Field y:Float
	
	Field w:Float
	
	Field image:TImage
	
	Field color:Int[3]
	Field alpha:Float
	
	Method New()
		Self.color[0]=255
		Self.color[1]=255
		Self.color[2]=255
		
		Self.alpha=1.0
	End Method
	
	Method coloring:TOBJEKT(r:Int,g:Int,b:Int,a:Float)
		Self.color[0]=r
		Self.color[1]=g
		Self.color[2]=b
		
		Self.alpha=a
		
		Return Self
	End Method
	
	Method render()
	End Method
	
	Method draw()
	End Method
	
End Type

Type TPLAYER Extends TOBJEKT
	
	Method init:TPLAYER(x:Float,y:Float,max_tempo:Float,image:TImage)
		
		Self.x=x
		Self.y=y
		
		Self.w=0
		
		Self.max_tempo=max_tempo
		
		Self.image=image
		
		Self.leben=100
		Self.score=0
		Self.super_power=0
		Self.anz_shots=1
		
		MidHandleImage(Self.image)
		
		VERWALTUNG.PLAYER = Self
		
		Self.level=1
		
		Return Self
	End Method
	
	Field max_tempo:Float'WICHTIG
	
	Field image:TImage
	
	
	
	Field leben:Float
	Field score:Int
	
	Field super_power:Float=0'WICHTIG
	
	Field counter:Int'f�r sch�sse
	Field count_min:Int=20'WICHTIG
	
	Field anz_shots:Int=1'WICHTIG
	
	Field newcomer:Int=1
	
	Field level:Int=1
	
	Method render()
		Self.newcomer=0
		
		Local mouse_x:Int=MouseX()
		Local mouse_y:Int=MouseY()
		
		Local mouse_down_1:Int=MouseDown(1)
		Local mouse_hit_1:Int=MouseHit(1)
		
		If Self.super_power>1000 Then Self.super_power=1000
		
		Self.w=ATan2(Self.y-mouse_y,Self.x-mouse_x)+180
		
		Local d:Float=Sqr((Self.y-mouse_y)^2+(Self.x-mouse_x)^2)-30
		If d<0 Then d=0
		
		If d>Self.max_tempo Then
			Self.x:+Cos(Self.w)*Self.max_tempo
			Self.y:+Sin(Self.w)*Self.max_tempo
		Else
			Self.x:+Cos(Self.w)*d*(d/Self.max_tempo)
			Self.y:+Sin(Self.w)*d*(d/Self.max_tempo)
		End If
		
		Self.counter:+1
		
		If (((mouse_down_1 Or mouse_hit_1) And Self.super_power>0) Or Self.counter>=Self.count_min) Then
			
			If Self.counter<Self.count_min Then
				Self.super_power:-1.0
			End If
			
			Self.counter=0
			
			Local add_w_spread:Float=+Rnd()*2-1.0
			
			For Local i:Float=-(Self.anz_shots-1)+add_w_spread To (Self.anz_shots-1)+add_w_spread Step 2.0
				VERWALTUNG.LISTE.addlast(( New TSHOTS ).init(Self.x+Cos(Self.w-i)*25, Self.y+Sin(Self.w-i)*25, Self.w-i, 4.0, GFX.image_shot).coloring(Rnd()*122, Rnd()*122, Rnd()*122+123, 0.5))
			Next
		End If
	End Method
	
	Method draw()
		SetColor Self.color[0],Self.color[1],Self.color[2]
		SetAlpha Self.alpha
		SetRotation Self.w+90
		DrawImage Self.image,Self.x,Self.y
		SetAlpha 1.0
	End Method
End Type

Type TSHOTS Extends TOBJEKT
	Field tempo:Float
	Field image:TImage
	
	Method init:TSHOTS(x:Float,y:Float,w:Float,tempo:Float,image:TImage)
		Self.x=x
		Self.y=y
		
		Self.w=w
		
		Self.tempo=tempo
		
		Self.image=image
		
		MidHandleImage(Self.image)
		
		Return Self
	End Method
	
	Method render()
		Self.x:+Cos(Self.w)*Self.tempo
		Self.y:+Sin(Self.w)*Self.tempo
		
		'ListRemove(VERWALTUNG.LISTE, Self)
		
		If (Self.x < -200) Or (Self.x > 1000) Or (Self.y < -200) Or (Self.y > 800) Then
			ListRemove(VERWALTUNG.LISTE, Self)
			
		End If
		
	End Method
	
	Method draw()
		SetColor Self.color[0],Self.color[1],Self.color[2]
		SetAlpha Self.alpha
		SetRotation Self.w+90
		DrawImage Self.image,Self.x,Self.y
		SetAlpha 1.0
	End Method
End Type

Type TGEGNER Extends TOBJEKT
	Field max_tempo:Float
	Field image:TImage
	
	Field w_add:Float
	
	Field leben:Int
	Field punkte:Float
	
	Method init:TGEGNER(x:Float,y:Float,max_tempo:Float,image:TImage,leben:Int=1,punkte:Float=1)
		Self.x=x
		Self.y=y
		
		Self.w=w
		
		Self.max_tempo=max_tempo
		
		Self.image=image
		
		MidHandleImage(Self.image)
		
		Self.punkte=punkte
		
		Self.w_add=Rnd()*360.0
		
		Self.leben=leben
		
		Return Self
	End Method
	
	Method render()
		
		Self.w=ATan2(Self.y-VERWALTUNG.PLAYER.y,Self.x-VERWALTUNG.PLAYER.x)+180+Sin(MilliSecs()/5+Self.w_add)*50
		
		Local d:Float=Sqr((Self.y-VERWALTUNG.PLAYER.y)^2+(Self.x-VERWALTUNG.PLAYER.x)^2)
		
		
		If d>Self.max_tempo Then
			Self.x:+Cos(Self.w)*Self.max_tempo
			Self.y:+Sin(Self.w)*Self.max_tempo
		Else
			Self.x:+Cos(Self.w)*d
			Self.y:+Sin(Self.w)*d
		End If
		
		For Local s:TSHOTS = EachIn VERWALTUNG.LISTE
			If Sqr((Self.y-s.y)^2+(Self.x-s.x)^2)<20 Then
				
				'ListRemove(VERWALTUNG.LISTE, s)
				Self.leben:-1
				
				For Local i:Int = 1 To Rand(5, 10)
					VERWALTUNG.LISTE.addlast(( New TPARTIKEL).init(Self.x, Self.y, Rnd()*360, Rnd()+1, Rand(50,70), GFX.image_partikel).coloring (Self.color[0]*(Rnd()*0.5+0.5),Self.color[1]*(Rnd()*0.5+0.5),Self.color[2]*(Rnd()*0.5+0.5),0.3))
				Next
				
				If Self.leben<=0 Then
					ListRemove(VERWALTUNG.LISTE, Self)
					
					
					VERWALTUNG.PLAYER.score:+Self.punkte
					
					For Local i:Int = 1 To Rand(20, 30)
						VERWALTUNG.LISTE.addlast(( New TPARTIKEL).init(Self.x, Self.y, Rnd()*360, Rnd()+1, Rand(50,70), GFX.image_partikel).coloring (Self.color[0]*(Rnd()*0.5+0.5),Self.color[1]*(Rnd()*0.5+0.5),Self.color[2]*(Rnd()*0.5+0.5),0.3))
					Next
					
					Exit
				End If
				
			End If
		Next
		
		If d=<30.0 Then
			ListRemove(VERWALTUNG.LISTE, Self)
			
			VERWALTUNG.PLAYER.leben:-5.0
			
			For Local i:Int = 1 To Rand(40, 50)
				VERWALTUNG.LISTE.addlast(( New TPARTIKEL).init(Self.x, Self.y, Rnd()*360, Rnd()*1+1, Rand(100,150), GFX.image_partikel).coloring (VERWALTUNG.PLAYER.color[0]*(Rnd()*0.5+0.5),VERWALTUNG.PLAYER.color[1]*(Rnd()*0.5+0.5),VERWALTUNG.PLAYER.color[2]*(Rnd()*0.5+0.5),0.2))
			Next
		End If
		
		
		If (Self.x < -200) Or (Self.x > 1000) Or (Self.y < -200) Or (Self.y > 800) Then
			ListRemove(VERWALTUNG.LISTE, Self)
			
		End If
		
	End Method
	
	Method draw()
		SetColor Self.color[0],Self.color[1],Self.color[2]
		SetAlpha Self.alpha
		SetRotation Self.w+90
		DrawImage Self.image,Self.x,Self.y
		SetAlpha 1.0
	End Method
End Type

Type TPARTIKEL Extends TOBJEKT
	Field tempo:Float
	Field counter:Int
	Field counter_start:Int
	
	Field image:TImage
	
	Method init:TPARTIKEL(x:Float,y:Float,w:Float,tempo:Float,counter:Int,image:TImage)
		Self.x=x
		Self.y=y
		
		Self.w=w
		
		Self.tempo=tempo
		
		Self.counter=counter
		Self.counter_start=counter
		
		Self.image=image
		
		MidHandleImage(Self.image)
		
		Return Self
	End Method
	
	Method render()
		
		Self.x:+Cos(Self.w)*Self.tempo
		Self.y:+Sin(Self.w)*Self.tempo
		
		Self.counter:-1
		
		Self.alpha = Float(Self.counter) / Float(Self.counter_start)
		
		If Self.counter<=0 Then
			ListRemove(VERWALTUNG.LISTE, Self)
		End If
		
	End Method
	
	Method draw()
	
		SetColor Self.color[0],Self.color[1],Self.color[2]
		SetAlpha Self.alpha
		SetRotation Self.w+90
		DrawImage Self.image,Self.x,Self.y
		SetAlpha 1.0
		
	End Method
End Type

Type TSPECIAL Extends TOBJEKT
	
	'Field x:Float
	'Field y:Float
	
	'Field w:Float
	
	'Field image:TImage
	
	'Field color:Int[3]
	'Field alpha:Float
	
	Field counter:Int
	Field counter_start:Int
	Field typ:Int
	
	Method init:TSPECIAL(x:Float,y:Float,counter:Int,typ:Int=1)
		Self.x=x
		Self.y=y
		
		Self.w=0
		
		Self.counter=counter
		Self.counter_start=counter
		
		Self.typ=typ
		
		Select Self.typ
			Case 1
				Self.image=GFX.image_upgrade_anz
			Case 2
				Self.image=GFX.image_upgrade_health
			Case 3
				Self.image=GFX.image_upgrade_power
			Case 4
				Self.image=GFX.image_upgrade_speed
			Case 5
				Self.image=GFX.image_upgrade_tempo
		End Select
		
		MidHandleImage(Self.image)
		
		Return Self
	End Method
	
	Rem
		GFX.image_upgrade_anz=LoadImage( "gfx\anz.png" )
		GFX.image_upgrade_health=LoadImage( "gfx\health.png" )
		GFX.image_upgrade_power=LoadImage( "gfx\power.png" )
		GFX.image_upgrade_speed=LoadImage( "gfx\speed.png" )
		GFX.image_upgrade_tempo=LoadImage( "gfx\tempo.png" )
	End Rem
	
	Method render()
		Self.w:+1
		
		Self.counter:-1
		
		
		Local d:Float=Sqr((Self.y-VERWALTUNG.PLAYER.y)^2+(Self.x-VERWALTUNG.PLAYER.x)^2)
		
		
		If d<30 Then
			Select typ
				Case 1
					'Self.image=GFX.image_upgrade_anz
					VERWALTUNG.PLAYER.anz_shots:+1
				Case 2
					'Self.image=GFX.image_upgrade_health
					VERWALTUNG.PLAYER.leben:+50
				Case 3
					'Self.image=GFX.image_upgrade_power
					VERWALTUNG.PLAYER.super_power:+50
				Case 4
					'Self.image=GFX.image_upgrade_speed
					VERWALTUNG.PLAYER.count_min:*0.9
				Case 5
					'Self.image=GFX.image_upgrade_tempo
					VERWALTUNG.PLAYER.max_tempo:+1.0
			End Select
			
			ListRemove(VERWALTUNG.LISTE, Self)
		End If
		
		
		If Self.counter<120 Then
			Self.alpha=Float(Self.counter)/120.0
		ElseIf (Self.counter_start-Self.counter)<120 Then
			Self.alpha=Float(Self.counter_start-Self.counter)/120.0
		Else
			Self.alpha=1
		End If
		
		If Self.counter<=0 Then
			ListRemove(VERWALTUNG.LISTE, Self)
		End If
	End Method
	
	Method draw()
		
		SetColor Self.color[0],Self.color[1],Self.color[2]
		SetAlpha Self.alpha
		SetRotation Self.w+90
		DrawImage Self.image,Self.x,Self.y
		SetAlpha 1.0
		
	End Method

	
End Type

Type VERWALTUNG
	Global LISTE:TList
	Global PLAYER:TPLAYER
	
	Function ini()
		VERWALTUNG.LISTE=New TList
	End Function
	
	Function draw_player_info()
		
		SetColor 255*(100-VERWALTUNG.PLAYER.super_power)/100,255*(VERWALTUNG.PLAYER.super_power)/100,0
		SetScale 1,Float(VERWALTUNG.PLAYER.super_power)/100.0
		SetRotation 0
		SetAlpha 1.0
		DrawImage GFX.image_balken,770,600-10-2*VERWALTUNG.PLAYER.super_power
		
		SetColor 255*(100-VERWALTUNG.PLAYER.leben)/100,255*(VERWALTUNG.PLAYER.leben)/100,0
		SetScale 1,Float(VERWALTUNG.PLAYER.leben)/100.0
		SetRotation 0
		SetAlpha 1.0
		DrawImage GFX.image_balken,10,600-10-2*VERWALTUNG.PLAYER.leben
		
		SetScale 1,1
		SetColor 255,255,255
		'DrawText VERWALTUNG.PLAYER.score, 10,10
		GFX.draw_int(VERWALTUNG.PLAYER.score, 10, 10)
		SetScale 1,1
		
		
		
		
		If VERWALTUNG.PLAYER.leben<0.0 Then
			VERWALTUNG.ini()
			VERWALTUNG.LISTE.addlast(( New TPLAYER ).init(400, 300, 1.0, GFX.image_player))
			WaitKey()
		End If
	End Function
End Type

Type GFX
	Global image_player:TImage
	Global image_shot:TImage
	Global image_gegner:TImage
	Global image_gegner2:TImage
	Global image_gegner3:TImage
	Global image_gegner4:TImage
	Global image_gegner5:TImage
	Global image_partikel:TImage
	Global image_balken:TImage
	
	Global image_upgrade_anz:TImage
	Global image_upgrade_health:TImage
	Global image_upgrade_power:TImage
	Global image_upgrade_speed:TImage
	Global image_upgrade_tempo:TImage
	
	Global image_hintergrund:TImage
	
	Global image_numbers:TImage[10]
	
	Global image_plot:TImage
	
	Function ini()
		GFX.image_player=LoadImage( "gfx\player.png" )
		GFX.image_shot=LoadImage( "gfx\shot.png" )
		GFX.image_gegner=LoadImage( "gfx\gegner.png" )
		GFX.image_gegner2=LoadImage( "gfx\gegner2.png" )
		GFX.image_gegner3=LoadImage( "gfx\gegner3.png" )
		GFX.image_gegner4=LoadImage( "gfx\gegner4.png" )
		GFX.image_gegner5=LoadImage( "gfx\gegner5.png" )
		GFX.image_partikel=LoadImage( "gfx\partikel.png" )
		GFX.image_balken=LoadImage( "gfx\balken.png" )
		
		GFX.image_upgrade_anz=LoadImage( "gfx\anz.png" )
		GFX.image_upgrade_health=LoadImage( "gfx\health.png" )
		GFX.image_upgrade_power=LoadImage( "gfx\power.png" )
		GFX.image_upgrade_speed=LoadImage( "gfx\speed.png" )
		GFX.image_upgrade_tempo=LoadImage( "gfx\tempo.png" )
		
		GFX.image_hintergrund=LoadImage( "gfx\hg.png" )
		MidHandleImage GFX.image_hintergrund
		
		For Local i:Int=0 To 9
			GFX.image_numbers[i]=LoadImage( "gfx\letters\"+String(i)+".png" )
		Next
		
		GFX.image_plot=LoadImage( "gfx\letters\..png" )
	End Function
	
	Function draw_int(number:Int, x:Int, y:Int)
		Local txt:String=String(number)
		Local scale_x:Float
		Local scale_y:Float
		GetScale(scale_x,scale_y)
		Local rotation:Float=GetRotation()
		For Local i:Int=1 To Len(txt)
			DrawImage GFX.image_numbers[Int(Mid(txt,i,1))],x+Float(i)*25.0*scale_x*Cos(rotation),y+Float(i)*25.0*scale_y*Sin(rotation)
		Next
	End Function
	
	Function HG_draw()
	
		Local par:Float=MilliSecs()
		SetColor Cos( par/100.0)*255.0,Cos( par/100.0+120.0)*255.0,Cos( par/100.0+240.0)*255.0
		SetAlpha 0.2
		SetRotation par/500.0
		DrawImage GFX.image_hintergrund,Cos( par/100.0)*100.0+400,-Sin(par/100.0)*100.0+300
		
		par:+100
		par:*1.1
		SetColor Cos( par/100.0)*255.0,Cos( par/100.0+120.0)*255.0,Cos( par/100.0+240.0)*255.0
		SetAlpha 0.2
		SetRotation -par/500.0
		DrawImage GFX.image_hintergrund,-Cos( par/100.0)*100.0+400,Sin(par/100.0)*100.0+300
		
		par:+200
		par:*1.1
		SetColor Cos( par/100.0)*255.0,Cos( par/100.0+120.0)*255.0,Cos( par/100.0+240.0)*255.0
		SetAlpha 0.2
		SetRotation par/500.0
		DrawImage GFX.image_hintergrund,Cos( par/100.0)*100.0+400,-Sin(par/100.0)*100.0+300
	End Function
End Type

Graphics 800,600
SetBlend LIGHTBLEND

GFX.ini()
VERWALTUNG.ini()

VERWALTUNG.LISTE.addlast(( New TPLAYER ).init(400, 300, 1.0, GFX.image_player))




Local count1:Float=0
Local count2:Float=0
Local count3:Float=0
Local count4:Float=0

Repeat
	If VERWALTUNG.PLAYER.newcomer=1 Then
		count1=0
		count2=0
		count3=0
		count4=0
		
		
		
		'VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,Rand(1,5)))
		
	End If
	
	count1:+1
	count2:+1
	count3:+1
	count4:+1
	
	
	Select True
		Case VERWALTUNG.PLAYER.score<50'LEVEL 1
			VERWALTUNG.PLAYER.level=1
			If count1>=600 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count1=0
				For Local i:Int = 1 To 360 Step 60
					VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*490+400, Sin(i)*490+300, 1.0+Rnd()*0.5, GFX.image_gegner,1,1)).coloring(255,0,0,0.7))
				Next
				
			End If
			
			If count2>=500 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count2=0
				
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,3))
				
			End If
			
		Case VERWALTUNG.PLAYER.score<100'LEVEL 2
			
			If VERWALTUNG.PLAYER.level=1 Then
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,2))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,5))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,4))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,2))
			End If
			
			VERWALTUNG.PLAYER.level=2
			
			If count1>=600 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count1=0
				For Local i:Int = 1 To 360 Step 30
					VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*490+400, Sin(i)*490+300, 1.0+Rnd()*0.5, GFX.image_gegner,1,1)).coloring(255,0,0,0.7))
				Next
				
			End If
			
			
			
		Case VERWALTUNG.PLAYER.score<200'LEVEL 3
		
			If VERWALTUNG.PLAYER.level=2 Then
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,2))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,5))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,1))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,4))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,2))
			End If
			
			VERWALTUNG.PLAYER.level=3
			
			If count1>=600 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count1=0
				For Local i:Int = 1 To 360 Step 20
					VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*490+400, Sin(i)*490+300, 1.0+Rnd()*0.5, GFX.image_gegner,1,1)).coloring(255,0,0,0.7))
				Next
				
			End If
			
			If count3>=1000 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count3=0
				For Local i:Int = 1 To 360 Step 120
					VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*490+400, Sin(i)*490+300, 2.0+Rnd()*0.5, GFX.image_gegner2,1,1)).coloring(255,255,0,0.7))
				Next
				
			End If
		Case VERWALTUNG.PLAYER.score<400'LEVEL 4
			If VERWALTUNG.PLAYER.level=3 Then
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,5))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,4))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,4))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,4))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,2))
			End If
			
			VERWALTUNG.PLAYER.level=4
			
			If count1>=1000 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count1=0
				For Local i:Int = 1 To 360 Step 60
					VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*490+400, Sin(i)*490+300, 1.5+Rnd()*0.5, GFX.image_gegner3,3,5)).coloring(100,100,255,0.7))
				Next
				
			End If
			
			If count3>=1200 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count3=0
				For Local i:Int = 1 To 360 Step 120
					VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*490+400, Sin(i)*490+300, 1.0+Rnd()*0.5, GFX.image_gegner4,7,10)).coloring(255,100,255,0.7))
				Next
				
			End If
		Case VERWALTUNG.PLAYER.score<600'LEVEL 5
			If VERWALTUNG.PLAYER.level=4 Then
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,1))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,2))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,3))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,3))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,3))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,4))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,4))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,5))
			End If
			
			VERWALTUNG.PLAYER.level=5
			
			If count1>=1000 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count1=0
				For Local i:Int = 1 To 360 Step 60
					VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*490+400, Sin(i)*490+300, 1.5+Rnd()*0.5, GFX.image_gegner3,3,5)).coloring(100,100,255,0.7))
				Next
				
			End If
			
			If count3>=1200 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count3=0
				For Local i:Int = 1 To 360 Step 90
					VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*490+400, Sin(i)*490+300, 1.0+Rnd()*0.5, GFX.image_gegner4,7,10)).coloring(255,100,255,0.7))
				Next
				
			End If
		Case VERWALTUNG.PLAYER.score<1000'LEVEL 7
			If VERWALTUNG.PLAYER.level=6 Then
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,1))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,2))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,3))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,4))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,5))
			End If
			
			VERWALTUNG.PLAYER.level=7
			
			If count1>=600 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count1=0
				For Local i:Int = 1 To 360 Step 20
					VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*490+400, Sin(i)*490+300, 1.0+Rnd()*0.5, GFX.image_gegner,2,2)).coloring(0,255,0,0.7))
				Next
				
			End If
			
			If count3>=800 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count3=0
				For Local i:Int = 1 To 360 Step 60
					VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*490+400, Sin(i)*490+300, 2.0+Rnd()*0.5, GFX.image_gegner5,10,20)).coloring(255,100,0,0.7))
				Next
				
			End If
		Case VERWALTUNG.PLAYER.score<1500'LEVEL 8
			If VERWALTUNG.PLAYER.level=7 Then
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,1))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,2))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,2))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,2))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,2))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,3))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,3))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,3))
			End If
			
			VERWALTUNG.PLAYER.level=8
			
			If count1>=300 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count1=0
				For Local i:Int = 1 To 360 Step 5
					VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*490+400, Sin(i)*490+300, 0.5+Rnd()*0.5, GFX.image_gegner,1,1)).coloring(0,255,0,0.7))
				Next
				
			End If
			
			If count3>=400 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count3=0
				For Local i:Int = 1 To 360 Step 60
					VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*490+400, Sin(i)*490+300, 2.0+Rnd()*0.5, GFX.image_gegner5,15,20)).coloring(255,255,0,0.7))
				Next
				
			End If
		Case VERWALTUNG.PLAYER.score<3000'LEVEL 8
			If VERWALTUNG.PLAYER.level=7 Then
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,1))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,2))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,3))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,3))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,3))
			End If
			
			VERWALTUNG.PLAYER.level=8
			
			If count1>=300 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count1=0
				For Local i:Int = 1 To 360 Step 15
					VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*490+400, Sin(i)*490+300, 0.5+Rnd()*0.5, GFX.image_gegner5,10,10)).coloring(0,0,255,0.7))
				Next
				
			End If
			
			If count3>=400 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count3=0
				For Local i:Int = 1 To 360 Step 60
					VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*490+400, Sin(i)*490+300, 2.0+Rnd()*0.5, GFX.image_gegner2,50,10)).coloring(255,255,0,0.7))
				Next
				
			End If
		Case VERWALTUNG.PLAYER.score<5000'LEVEL 9
			If VERWALTUNG.PLAYER.level=8 Then
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,2))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,2))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,3))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,3))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,3))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,3))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,4))
				VERWALTUNG.LISTE.addlast(( New TSPECIAL ).init(Rand(10,780),Rand(10,580),6000,4))
			End If
			
			VERWALTUNG.PLAYER.level=9
			
			If count1>=60*10 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count1=0
				For Local i:Int = 1 To 360 Step 12
					VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*490+400, Sin(i)*490+300, 0.5+Rnd()*0.5, GFX.image_gegner,1,1)).coloring(255,0,0,0.7))
				Next
				
			End If
			
			If count3>=60*15 Or VERWALTUNG.PLAYER.newcomer=1 Then
				
				count3=0
				For Local i:Int = 1 To 360 Step 60
					VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*490+400, Sin(i)*490+300, 1.0+Rnd()*0.5, GFX.image_gegner2,50,100)).coloring(255,255,0,0.7))
				Next
				
			End If
	End Select
	
	Rem
	
	
				Case 1
					'Self.image=GFX.image_upgrade_anz
					VERWALTUNG.PLAYER.anz_shots:+1
				Case 2
					'Self.image=GFX.image_upgrade_health
					VERWALTUNG.PLAYER.leben:+50
				Case 3
					'Self.image=GFX.image_upgrade_power
					VERWALTUNG.PLAYER.super_power:+50
				Case 4
					'Self.image=GFX.image_upgrade_speed
					VERWALTUNG.PLAYER.count_min:*0.9
				Case 5
					'Self.image=GFX.image_upgrade_tempo
					VERWALTUNG.PLAYER.max_tempo:+1.0

	
	
	If count>=60 Or VERWALTUNG.PLAYER.newcomer=1 Then
		count=0
		VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(-100, -100, 2.0+Rnd(), GFX.image_gegner2, 5, 2)).coloring (255,255,0,1.0))
		VERWALTUNG.LISTE.addlast((( New TGEGNER ).init( -100, 700, 2.0+Rnd(), GFX.image_gegner2, 5, 2)).coloring (255,0,255,1.0))
		VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(900, 700, 2.0+Rnd(), GFX.image_gegner2, 5, 2)).coloring (0,255,255,1.0))
		VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(900, -100, 2.0+Rnd(), GFX.image_gegner2, 5, 2)).coloring (255,100,0,1.0))
	End If
	
	
	If count2>=300 Or VERWALTUNG.PLAYER.newcomer=1 Then
		count2=0
		For Local i:Int = 0 To 20
			VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(i*40, -100, 0.5+Rnd(), GFX.image_gegner,1,1)).coloring(255,0,0,0.7))
		Next
		
		For Local i:Int = 0 To 20
			VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(i*40, 700, 0.5+Rnd(), GFX.image_gegner,1,1)).coloring(100,100,255,0.7))
		Next
	End If
	
	If count3>=250 Then
		count3=0
		
		For Local i:Int = 0 To 360 Step 30
			VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*450+400, Sin(i)*450+300, 1.5+Rnd(), GFX.image_gegner,2,5)).coloring(0,255,0,1.0))
		Next
		
	End If
	
	If count4>=400 Then
		count4=0
		
		For Local i:Int = 1 To 360 Step 120
			VERWALTUNG.LISTE.addlast((( New TGEGNER ).init(Cos(i)*450+400, Sin(i)*450+300, 0.3+Rnd()*0.2, GFX.image_gegner2,20,20)).coloring(200,200,255,1.0))
		Next
		
	End If
	End Rem
	
	Cls
	GFX.HG_draw()
	
	For Local o:TOBJEKT=EachIn VERWALTUNG.LISTE
		o.render()
		o.draw()
	Next
	
	VERWALTUNG.draw_player_info()
	
	
	Flip
	
Until KeyHit(key_escape)