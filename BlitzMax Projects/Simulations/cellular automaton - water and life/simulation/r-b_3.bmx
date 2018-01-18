SuperStrict

'asd�lfhjalsk�dfj�
'problem -> fish both on same place


Global xmax:Int = 160
Global ymax:Int = 120

Global dx:Int = 800/xmax
Global dy:Int = 600/ymax

Global ramen:Int = 1

Global feld:TAanimal[xmax,ymax]
Global f2:TAanimal[xmax,ymax]
Global borders:Int = 1

' ------------------------ Constants -------------
Global fish_rep_alter:Int = 10
Global fish_laich:Int = 5

Global hai_rep_alter:Int = 25
Global hai_laich:Int = 5
Global hai_hunger_max:Int = 10

'-------------- STATISTICS ----------------------
Global fish_stats:Int[400]' fish_stats[fish_stats_pos]
Global fish_stats_pos:Int = 0

Global hai_stats:Int[400]
Global hai_stats_pos:Int = 0

Global stats_delay:Int = 3
Global stats_delay_count:Int = 0

Global hai_stats_scale:Int = 0

'-------------------- RENDERING -----------------

Type DIRECTION
	Global render_direction:Int = 0
	
	Function render()
		render_direction:+1
		If render_direction>3 Then render_direction=0
	End Function
	
	
	Function x_start:Int()
		If render_direction<2 Then
			Return -1
		Else
			Return xmax
		End If
	End Function
	
	Function x_end:Int()
		If render_direction<2 Then
			Return xmax-1
		Else
			Return 0
		End If
	End Function
	
	Function y_start:Int()
		If (render_direction Mod 2)=1 Then
			Return -1
		Else
			Return ymax
		End If
	End Function
	
	Function y_end:Int()
		If (render_direction Mod 2)=1 Then
			Return ymax-1
		Else
			Return 0
		End If
	End Function
	
	Function x_step:Int()
		If render_direction<2 Then
			Return 1
		Else
			Return -1
		End If
	End Function
	
	Function y_step:Int()
		If (render_direction Mod 2)=1 Then
			Return 1
		Else
			Return -1
		End If
	End Function
End Type


' ################ TYPES #########################
Type TAanimal
	Field alter:Int
	Field laichalter:Int
End Type

Type TDead Extends TAanimal
End Type

Type THai Extends TAanimal
	Field hunger:Int
	
	Function count_fish:Int(x:Int,y:Int)
		Local counter:Int = 0
		For Local p:Int = -1 To 1
			For Local q:Int = -1 To 1
				If p=0 And q=0 Then
				Else
					If borders = 1 Then
						
						Local xx:Int = (x+p+xmax) Mod xmax
						Local yy:Int = (y+q+ymax) Mod ymax
						
						
						'here
						If TFish(f2[xx,yy]) Then counter:+1
						
					Else
						Local xx:Int = x+p
						Local yy:Int = y+q
						
						If xx < 0 Or yy < 0 Or xx >= xmax Or yy >= ymax Then
							'nothing - empty
						Else
							'here
							If TFish(f2[xx,yy]) Then counter:+1
						End If
					End If
				End If
			Next
		Next
		Return counter
	End Function
	
	Function give_fish(x:Int,y:Int,n:Int,x_res:Int Var, y_res:Int Var)
		Local counter:Int = 0
		For Local p:Int = -1 To 1
			For Local q:Int = -1 To 1
				If p=0 And q=0 Then
				Else
					If borders = 1 Then
						
						Local xx:Int = (x+p+xmax) Mod xmax
						Local yy:Int = (y+q+ymax) Mod ymax
						
						
						'here
						If TFish(f2[xx,yy]) Then
							counter:+1
							If counter = n Then
								x_res=xx
								y_res=yy
								Return
							End If
						End If
						
					Else
						Local xx:Int = x+p
						Local yy:Int = y+q
						
						If xx < 0 Or yy < 0 Or xx >= xmax Or yy >= ymax Then
							'nothing - empty
						Else
							'here
							If TFish(f2[xx,yy]) Then
								counter:+1
								If counter = n Then
									x_res=xx
									y_res=yy
									Return
								End If
							End If
						End If
					End If
				End If
			Next
		Next
		Return
	End Function
	
	Function count_free:Int(x:Int,y:Int)
		Local counter:Int = 0
		For Local p:Int = -1 To 1
			For Local q:Int = -1 To 1
				If p=0 And q=0 Then
				Else
					If borders = 1 Then
						
						Local xx:Int = (x+p+xmax) Mod xmax
						Local yy:Int = (y+q+ymax) Mod ymax
						
						
						'here
						If feld[xx,yy] = Null And f2[xx,yy] = Null Then counter:+1
						
					Else
						Local xx:Int = x+p
						Local yy:Int = y+q
						
						If xx < 0 Or yy < 0 Or xx >= xmax Or yy >= ymax Then
							'nothing - empty
						Else
							'here
							If feld[xx,yy] = Null And f2[xx,yy] = Null Then counter:+1
						End If
					End If
				End If
			Next
		Next
		Return counter
	End Function
	
	Function give_free(x:Int,y:Int,n:Int,x_res:Int Var, y_res:Int Var)
		Local counter:Int = 0
		For Local p:Int = -1 To 1
			For Local q:Int = -1 To 1
				If p=0 And q=0 Then
				Else
					If borders = 1 Then
						
						Local xx:Int = (x+p+xmax) Mod xmax
						Local yy:Int = (y+q+ymax) Mod ymax
						
						
						'here
						If feld[xx,yy] = Null And f2[xx,yy] = Null Then
							counter:+1
							If counter = n Then
								x_res=xx
								y_res=yy
								Return
							End If
						End If
						
					Else
						Local xx:Int = x+p
						Local yy:Int = y+q
						
						If xx < 0 Or yy < 0 Or xx >= xmax Or yy >= ymax Then
							'nothing - empty
						Else
							'here
							If feld[xx,yy] = Null And f2[xx,yy] = Null Then
								counter:+1
								If counter = n Then
									x_res=xx
									y_res=yy
									Return
								End If
							End If
						End If
					End If
				End If
			Next
		Next
		Return
	End Function
End Type

Type TFish Extends TAanimal
	Function count_free:Int(x:Int,y:Int)
		Local counter:Int = 0
		For Local p:Int = -1 To 1
			For Local q:Int = -1 To 1
				If p=0 And q=0 Then
				Else
					If borders = 1 Then
						
						Local xx:Int = (x+p+xmax) Mod xmax
						Local yy:Int = (y+q+ymax) Mod ymax
						
						
						'here
						If feld[xx,yy] = Null And f2[xx,yy] = Null Then counter:+1
						
					Else
						Local xx:Int = x+p
						Local yy:Int = y+q
						
						If xx < 0 Or yy < 0 Or xx >= xmax Or yy >= ymax Then
							'nothing - empty
						Else
							'here
							If feld[xx,yy] = Null And f2[xx,yy] = Null Then counter:+1
						End If
					End If
				End If
			Next
		Next
		Return counter
	End Function
	
	
	Function give_free(x:Int,y:Int,n:Int,x_res:Int Var, y_res:Int Var)
		Local counter:Int = 0
		For Local p:Int = -1 To 1
			For Local q:Int = -1 To 1
				If p=0 And q=0 Then
				Else
					If borders = 1 Then
						
						Local xx:Int = (x+p+xmax) Mod xmax
						Local yy:Int = (y+q+ymax) Mod ymax
						
						
						'here
						If feld[xx,yy] = Null And f2[xx,yy] = Null Then
							counter:+1
							If counter = n Then
								x_res=xx
								y_res=yy
								Return
							End If
						End If
						
					Else
						Local xx:Int = x+p
						Local yy:Int = y+q
						
						If xx < 0 Or yy < 0 Or xx >= xmax Or yy >= ymax Then
							'nothing - empty
						Else
							'here
							If feld[xx,yy] = Null And f2[xx,yy] = Null Then
								counter:+1
								If counter = n Then
									x_res=xx
									y_res=yy
									Return
								End If
							End If
						End If
					End If
				End If
			Next
		Next
		Return
	End Function
End Type
' ################ END TYPES ######################


Function render_settings()
	If KeyHit(key_f1) Then
		xmax = 20
		ymax = 15
		
		dx = 800/xmax
		dy = 600/ymax
		
		ramen:Int = 1
		
		feld = New TAanimal[xmax,ymax]
	End If
	
	If KeyHit(key_f2) Then
		xmax = 40
		ymax = 30
		
		dx = 800/xmax
		dy = 600/ymax
		
		ramen:Int = 1
		
		feld = New TAanimal[xmax,ymax]
	End If
	
	If KeyHit(key_f3) Then
		xmax = 80
		ymax = 60
		
		dx = 800/xmax
		dy = 600/ymax
		
		ramen:Int = 1
		
		feld = New TAanimal[xmax,ymax]
	End If
	
	If KeyHit(key_f4) Then
		xmax = 200
		ymax = 150
		
		dx = 800/xmax
		dy = 600/ymax
		
		ramen:Int = 1
		
		feld = New TAanimal[xmax,ymax]
	End If
	
	If KeyHit(key_f5) Then
		xmax = 400
		ymax = 300
		
		dx = 800/xmax
		dy = 600/ymax
		
		ramen:Int = 0
		
		feld = New TAanimal[xmax,ymax]
	End If
End Function


' ############################# START ###################################
feld = New TAanimal[xmax,ymax]
f2 = New TAanimal[xmax,ymax]

Graphics 800,800
SetBlend alphablend

Repeat
	If KeyHit(key_f8) Then' SET RANDOM
		For Local x:Int = 0 To xmax-1
			For Local y:Int = 0 To ymax-1
				
				Local r:Int = Rand(1,1000)
				
				Select True
					Case r>900
						feld[x,y] = New THai
					Case r>600
						feld[x,y] = New TFish
					Default
						feld[x,y] = Null
				End Select
			Next
		Next
	End If
	
	render_settings()
	
	If KeyHit(key_b) Then
		borders = 1 - borders
	End If
	
	DIRECTION.render()
	
	If KeyHit(key_u) Or KeyDown(key_r) Then
		f2 = New TAanimal[xmax,ymax]
		
		fish_stats[fish_stats_pos]=0
		
		' -------------------- BEUTE ------------
		Local x:Int = DIRECTION.x_start()
		
		While x <> DIRECTION.x_end()
			x:+DIRECTION.x_step()
			
			Local y:Int = DIRECTION.y_start()
			
			While y <> DIRECTION.y_end()
				y:+DIRECTION.y_step()
				'------------------
				
				If TDead(feld[x,y]) Then
					f2[x,y] = feld[x,y]
				End If
				
				If TFish(feld[x,y]) Then
					' start
					fish_stats[fish_stats_pos]:+1
					
					TFish(feld[x,y]).alter:+1
					If TFish(feld[x,y]).alter >= fish_rep_alter Then TFish(feld[x,y]).laichalter:+1
					
					
					Local counter:Int = TFish.count_free(x,y)
					
					If counter=0 Then
						f2[x,y] = feld[x,y]
					Else
						Local chosen:Int = Rand(1,counter)'Rand(0,counter)
						
						If chosen=0 Then
							f2[x,y] = feld[x,y]
						Else
							Local x_res:Int
							Local y_res:Int
							TFish.give_free(x,y,chosen,x_res, y_res)
							
							
							If TFish(feld[x,y]).laichalter >= fish_laich Then
								f2[x,y] = New TFish
								TFish(feld[x,y]).laichalter = 0
							End If
							
							f2[x_res,y_res] = feld[x,y]
						End If
						
					End If
				End If
			Wend
		Wend
		
		
		' --------------------- R�UBER ----------
		hai_stats[hai_stats_pos]=0
		
		'------------------
		x = DIRECTION.x_start()
		
		While x <> DIRECTION.x_end()
			x:+DIRECTION.x_step()
			
			Local y:Int = DIRECTION.y_start()
			
			While y <> DIRECTION.y_end()
				y:+DIRECTION.y_step()
				'------------------
				
				If THai(feld[x,y]) Then
					
					hai_stats[hai_stats_pos]:+1
					
					
					THai(feld[x,y]).hunger:+1
					If THai(feld[x,y]).hunger>hai_hunger_max Then feld[x,y] = Null
				End If
				
				If THai(feld[x,y]) Then
					THai(feld[x,y]).alter:+1
					If THai(feld[x,y]).alter >= hai_rep_alter Then THai(feld[x,y]).laichalter:+1
					
					Local f_counter:Int = THai.count_fish(x,y)
					
					If f_counter = 0 Then
						
						
						Local counter:Int = THai.count_free(x,y)
						
						If counter=0 Then
							f2[x,y] = feld[x,y]
						Else
							Local chosen:Int = Rand(1,counter)'Rand(0,counter)
							
							If chosen=0 Then
								f2[x,y] = feld[x,y]
							Else
								Local x_res:Int
								Local y_res:Int
								THai.give_free(x,y,chosen,x_res, y_res)
								
								
								
								If THai(feld[x,y]).laichalter >= hai_laich Then
									f2[x,y] = New THai
									THai(feld[x,y]).laichalter = 0
								End If
								
								f2[x_res,y_res] = feld[x,y]
							End If
							
						End If
						
					Else
						Local chosen:Int = Rand(1,f_counter)'Rand(0,f_counter)
						
						If chosen=0 Then
							f2[x,y] = feld[x,y]
						Else
							Local x_res:Int
							Local y_res:Int
							THai.give_fish(x,y,chosen,x_res, y_res)
							
							THai(feld[x,y]).hunger = 0
							
							If THai(feld[x,y]).laichalter >= hai_laich Then
								f2[x,y] = New THai
								THai(feld[x,y]).laichalter = 0
							End If
							
							f2[x_res,y_res] = feld[x,y]
						End If
					End If
				End If
			Wend
		Wend
		
		
		stats_delay_count:+1
		If stats_delay_count>=stats_delay Then
			stats_delay_count = 0
			
			fish_stats_pos = (fish_stats_pos+1) Mod fish_stats.length
			hai_stats_pos = (hai_stats_pos+1) Mod hai_stats.length
		End If
		
		feld = f2
	End If
	
	If MouseX()<xmax*dx And MouseY()<ymax*dy And MouseX() > 0 And MouseY()>0 Then
		If MouseDown(1) Then feld[MouseX()/dx,MouseY()/dy] = New THai
		If MouseDown(2) Then feld[MouseX()/dx,MouseY()/dy] = New TFish
		
		
		If MouseDown(3) Then
			For Local p:Int = -1 To 1
				For Local q:Int = -1 To 1
					feld[(MouseX()/dx+p) Mod xmax,(MouseY()/dy+q) Mod ymax] = New TDead
				Next
			Next
			
		End If
	End If
	
	Local new_raster:Int = 0
	
	
	If KeyHit(key_f9) Then new_raster = 10
	If KeyHit(key_f10) Then new_raster = 20
	If KeyHit(key_f11) Then new_raster = 30
	If KeyHit(key_f12) Then new_raster = 50
	
	If new_raster>0 Then
		For Local x:Int = 0 To xmax-1
			For Local y:Int = 0 To ymax-1
				feld[x,y] = New TDead
			Next
		Next
		
		fish_stats_pos = 0
		hai_stats_pos = 0
		stats_delay_count = 0
		
		For Local i:Int = 1 To new_raster'horizontal
			Local x0:Int = Rand(0,xmax-1)
			Local y0:Int = Rand(0,ymax-1)
			
			For Local xx:Int = 0 To Rand(xmax*0.3,xmax)
				feld[(x0+xx) Mod xmax,y0 Mod ymax]=Null
			Next
		Next
		
		For Local i:Int = 1 To new_raster'vertikal
			Local x0:Int = Rand(0,xmax-1)
			Local y0:Int = Rand(0,ymax-1)
			
			For Local yy:Int = 0 To Rand(ymax*0.3,ymax)
				feld[x0 Mod xmax,(y0+yy) Mod ymax]=Null
			Next
		Next
	End If
	
	
	If KeyHit(key_space) Then
		For Local x:Int = 0 To xmax-1
			For Local y:Int = 0 To ymax-1
				If Not TDead(feld[x,y]) Then feld[x,y]=Null
			Next
		Next
		
		fish_stats_pos = 0
		hai_stats_pos = 0
		stats_delay_count = 0
		
		fish_stats = New Int[400]
		hai_stats = New Int[400]
	End If
	
	If KeyHit(key_enter) Then
		feld = New TAanimal[xmax,ymax]
		fish_stats_pos = 0
		hai_stats_pos = 0
		stats_delay_count = 0
		
		fish_stats = New Int[400]
		hai_stats = New Int[400]
	End If
	
	Cls
	
	For Local x:Int = 0 To xmax-1
		For Local y:Int = 0 To ymax-1
			If THai(feld[x,y]) Then' ------------- HAI
				SetColor 100,0,0
				
				If THai(feld[x,y]).alter >= hai_rep_alter Then
					SetColor 200,0,0
				End If
			Else If TFish(feld[x,y]) Then' ------- FISH
				SetColor 0,100,0
				
				If TFish(feld[x,y]).alter >= fish_rep_alter Then
					SetColor 0,200,0
				End If
			Else If TDead(feld[x,y]) Then' ------- DEAD
				SetColor 255,255,255
			Else' -------------------------------- WATER
				SetColor 20,20,40
			End If
			
			DrawRect dx*x,dy*y,dx-ramen,dy-ramen
		Next
	Next
	
	
	SetAlpha 0.5
	SetColor 0,0,100
	DrawRect 0,0,280,150
	SetAlpha 0.8
	SetColor 255,255,255
	
	DrawText "[R] and [U] to render",10,10
	DrawText "[SPACE] clean     [ENTER] new",10,40
	DrawText "Mouse-Right and Left to draw",10,70
	DrawText "[F1] to [F5] for size",10,100
	DrawText "[B] to toggle borders property: " + borders,10,130
	
	Rem
	Global fish_rep_alter:Int = 10
	Global fish_laich:Int = 5
	
	Global hai_rep_alter:Int = 25
	Global hai_laich:Int = 5
	Global hai_hunger_max:Int = 10
	End Rem
	
	Local m_x:Int = MouseX()
	Local m_y:Int = MouseY()
	Local m_s:Int = MouseZSpeed()
	
	SetAlpha 0.8
	
	If m_x>0 And m_x<125 And m_y>160 And m_y<190 Then' FISH REP AGE
		SetColor 20,20,20
		fish_rep_alter:+m_s
		If fish_rep_alter<1 Then fish_rep_alter=1
	Else
		SetColor 0,0,0
	End If
	
	DrawRect 0,160,125,30
	SetColor 0,255,0
	DrawText "rep age: "+fish_rep_alter,5,165' end
	
	If m_x>0 And m_x<125 And m_y>200 And m_y<230 Then' FISH LAICH
		SetColor 20,20,20
		fish_laich:+m_s
		If fish_laich<1 Then fish_laich=1
	Else
		SetColor 0,0,0
	End If
	
	DrawRect 0,200,125,30
	SetColor 0,255,0
	DrawText "rep cycle: "+fish_laich,5,205' end
	
	If m_x>0 And m_x<125 And m_y>240 And m_y<270 Then' HAI REP AGE
		SetColor 20,20,20
		hai_rep_alter:+m_s
		If hai_rep_alter<1 Then hai_rep_alter=1
	Else
		SetColor 0,0,0
	End If
	
	DrawRect 0,240,125,30
	SetColor 255,0,0
	DrawText "rep age: "+hai_rep_alter,5,245' end
	
	If m_x>0 And m_x<125 And m_y>280 And m_y<310 Then' HAI LAICH
		SetColor 20,20,20
		hai_laich:+m_s
		If hai_laich<1 Then hai_laich=1
	Else
		SetColor 0,0,0
	End If
	
	DrawRect 0,280,125,30
	SetColor 255,0,0
	DrawText "rep cycle: "+hai_laich,5,285' end
	
	If m_x>0 And m_x<125 And m_y>320 And m_y<350 Then' HAI HUNGER
		SetColor 20,20,20
		hai_hunger_max:+m_s
		If hai_hunger_max<1 Then hai_hunger_max=1
	Else
		SetColor 0,0,0
	End If
	
	DrawRect 0,320,125,30
	SetColor 255,0,0
	DrawText "hunger max: "+hai_hunger_max,5,325' end
	
	
	SetAlpha 1
	
	Local distance:Int = 800/fish_stats.length
	Local scale:Float = 200.0/xmax/ymax
	SetColor 0,255,0
	For Local i:Int = 0 To fish_stats.length-2
		DrawRect i*distance,800-fish_stats[i]*scale-1,distance,2
	Next
	
	If m_y > 600 Then hai_stats_scale:+m_s
	
	SetColor 255,0,0
	For Local i:Int = 0 To hai_stats.length-2
		DrawRect i*distance,800-hai_stats[i]*scale*(1.1^hai_stats_scale)-1,distance,2
	Next
	
	SetColor 100,100,100
	DrawRect (fish_stats_pos+1)*distance,600,1,200
	
	SetColor 150,150,150
	DrawText hai_stats_scale,5,605
	
	Flip
Until KeyHit(key_escape) Or AppTerminate()