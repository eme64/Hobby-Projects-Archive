SuperStrict
Import Vertex.BNetEx
SeedRnd MilliSecs()

Type ZIP_DATA
	Function mini_float:String(zahl:Float)
		Local s:String=String(Int(Abs(zahl)))
		
		Local pos:Int=Instr(Abs(zahl), ".")
		
		If (zahl<0) Then s="-"+s
		
		s:+"."+Mid(Abs(zahl), pos+1,2)
		
		'Print " - "+zahl
		'Print " _ "+s
		
		Return s
	End Function
End Type

Type TOBJEKT
	Global liste:TList
	Global map:TMap
	
	Global id_counter:Int=0
	
	Field id:Int
	
	'Field typ:String'typ des TOBJ_DATA objektes (soldier, worker, base)
	'oben: UNN�TIG #######################
	
	Field data:TOBJ_DATA
	
	Method New()
		TOBJEKT.id_counter:+1
		Self.id=TOBJEKT.id_counter
		
		TOBJEKT.liste.addlast(Self)
		TOBJEKT.map.insert(String(Self.id),Self)
	End Method
	
	Method kill()
		TOBJEKT.liste.remove(Self)
		TOBJEKT.map.remove(String(Self.id))
	End Method
	
	Function get_map:TOBJEKT(id:Int)'wichtig f�r viele objekte
		Return TOBJEKT(TOBJEKT.map.ValueForKey(String(id)))
	End Function
	
	Function create:TOBJEKT(typ:String, x:Float, y:Float, player_id:Int)
		Local o:TOBJEKT=New TOBJEKT
		
		
		
		Select Lower(typ)
			Case "soldier"
				o.data=TOBJ_DATA_LEBEND_UNIT_SOLDIER.create(o.id, x, y, player_id)
				
				Local data:String=o.data.get_data(1)
				
				For Local p:TNET_PLAYER=EachIn TPLAYER.liste
					If o.data.player_id=p.id Then
						
						p.UDP_STREAM_OUT.WriteLine("SOD 0 "+o.data.get_data(0))
						p.UDP_STREAM_OUT.SendMsg()
						
					Else
						
						p.UDP_STREAM_OUT.WriteLine("SOD 1 "+data)
						p.UDP_STREAM_OUT.SendMsg()
						
					End If
				Next
			Case "ameise"
				o.data=TOBJ_DATA_LEBEND_UNIT_AMEISE.create(o.id, x, y, player_id)
				
				Local data:String=o.data.get_data(1)
				
				For Local p:TNET_PLAYER=EachIn TPLAYER.liste
					If o.data.player_id=p.id Then
						
						p.UDP_STREAM_OUT.WriteLine("SOD 0 "+o.data.get_data(0))
						p.UDP_STREAM_OUT.SendMsg()
						
					Else
						
						p.UDP_STREAM_OUT.WriteLine("SOD 1 "+data)
						p.UDP_STREAM_OUT.SendMsg()
						
					End If
				Next
				
			Case "stone"
				o.data=TOBJ_DATA_LEBEND_STONE.create(o.id, x, y, 1)'kein  player
				
				Local data:String=o.data.get_data(1)
				
				For Local p:TNET_PLAYER=EachIn TPLAYER.liste
					If o.data.player_id=p.id Then
						
						p.UDP_STREAM_OUT.WriteLine("SOD 0 "+o.data.get_data(0))
						p.UDP_STREAM_OUT.SendMsg()
						
					Else
						
						p.UDP_STREAM_OUT.WriteLine("SOD 1 "+data)
						p.UDP_STREAM_OUT.SendMsg()
						
					End If
				Next
			Case "mineral"
				
				o.data=TOBJ_DATA_MINERALS.create(o.id, x, y, 1)'kein  player
				
				Local data:String=o.data.get_data(1)
				
				For Local p:TNET_PLAYER=EachIn TPLAYER.liste
					If o.data.player_id=p.id Then
						
						p.UDP_STREAM_OUT.WriteLine("SOD 0 "+o.data.get_data(0))
						p.UDP_STREAM_OUT.SendMsg()
						
					Else
						
						p.UDP_STREAM_OUT.WriteLine("SOD 1 "+data)
						p.UDP_STREAM_OUT.SendMsg()
						
					End If
				Next
			Case "drone"
				
				o.data=TOBJ_DATA_LEBEND_UNIT_DRONE.create(o.id, x, y, player_id)
				
				Local data:String=o.data.get_data(1)
				
				For Local p:TNET_PLAYER=EachIn TPLAYER.liste
					If o.data.player_id=p.id Then
						
						p.UDP_STREAM_OUT.WriteLine("SOD 0 "+o.data.get_data(0))
						p.UDP_STREAM_OUT.SendMsg()
						
					Else
						
						p.UDP_STREAM_OUT.WriteLine("SOD 1 "+data)
						p.UDP_STREAM_OUT.SendMsg()
						
					End If
				Next
			Case "base"
				
				o.data=TOBJ_DATA_LEBEND_UNIT_BASE.create(o.id, x, y, player_id)
				
				Local data:String=o.data.get_data(1)
				
				For Local p:TNET_PLAYER=EachIn TPLAYER.liste
					If o.data.player_id=p.id Then
						
						p.UDP_STREAM_OUT.WriteLine("SOD 0 "+o.data.get_data(0))
						p.UDP_STREAM_OUT.SendMsg()
						
					Else
						
						p.UDP_STREAM_OUT.WriteLine("SOD 1 "+data)
						p.UDP_STREAM_OUT.SendMsg()
						
					End If
				Next
		End Select
		
		Return o
	End Function
	
	
	Function render_all()
		For Local o:TOBJEKT=EachIn TOBJEKT.liste
			o.data.render()
		Next
	End Function
	
	Function draw_all()
		For Local o:TOBJEKT=EachIn TOBJEKT.liste
			o.data.draw()
		Next
	End Function
	
	Function render_send_all()
		For Local o:TOBJEKT=EachIn TOBJEKT.liste
			If o.data.last_sent+o.data.data_delay<MilliSecs() Then
				o.data.last_sent=MilliSecs()
				
				Local data:String=o.data.get_data(3)
				
				For Local p:TNET_PLAYER=EachIn TPLAYER.liste
					If o.data.player_id=p.id Then
						
						p.UDP_STREAM_OUT.WriteLine("SOD 2 "+o.data.get_data(2))
						p.UDP_STREAM_OUT.SendMsg()
						
					Else
						
						p.UDP_STREAM_OUT.WriteLine("SOD 3 "+data)
						p.UDP_STREAM_OUT.SendMsg()
						
					End If
				Next
			End If
		Next
	End Function
	
	Function render_collision()
		
		For Local i:Int=1 To 1
			
			Local i1:Int=0
			For Local o1:TOBJEKT=EachIn TOBJEKT.liste
				i1:+1
				Local i2:Int=0
				For Local o2:TOBJEKT=EachIn TOBJEKT.liste
					i2:+1
					
					If i1<i2 And o1.data.mobilheit+o2.data.mobilheit>0 Then
						
						'Print o1.id+" "+o2.id
						
						Local d_x:Float=(o1.data.x+o1.data.v_x)-(o2.data.x+o2.data.v_x)
						Local d_y:Float=(o1.data.y+o1.data.v_y)-(o2.data.y+o2.data.v_y)
						Local g_r:Float=(o1.data.r+o2.data.r)
						
						Local d_r:Float=g_r-((d_x)^2+(d_y)^2)^0.5
						
						If d_r>0 Then
							'Print "collision"
							
							If d_x=0 And d_y=0 Then
								
								Print "die gleiche position"
								
								o1.data.v_x:+ 0.1
								o2.data.v_x:+ -0.1
								
								o1.data.v_y:+ 0.1
								o2.data.v_y:+ -0.1
								
							Else
								Local d_w:Float=ATan2(d_y, d_x)
								
								o1.data.v_x:+ o1.data.mobilheit/(o1.data.mobilheit+o2.data.mobilheit)*d_r*Cos(d_w)
								o2.data.v_x:+ o2.data.mobilheit/(o1.data.mobilheit+o2.data.mobilheit)*d_r*Cos(d_w+180.0)
								
								o1.data.v_y:+ o1.data.mobilheit/(o1.data.mobilheit+o2.data.mobilheit)*d_r*Sin(d_w)
								o2.data.v_y:+ o2.data.mobilheit/(o1.data.mobilheit+o2.data.mobilheit)*d_r*Sin(d_w+180.0)
								
							End If
						Else
							'Print "-"
						End If
						
					Else
						Continue
					End If
				Next
			Next
		Next
		
		
		
		For Local o:TOBJEKT=EachIn TOBJEKT.liste
			If o.data.v_x=0 Then
				'stillstand
			Else If o.data.v_x>0
				'positiv
				
				If Int(Float(o.data.x+o.data.r)/TFELD.seite)<Int(Float(o.data.x+o.data.r+o.data.v_x)/TFELD.seite) Then
					'feld-wechsel
					
					Local coll:Int=0
					
					For Local i:Int=Int((o.data.y-o.data.r)/TFELD.seite) To Int((o.data.y+o.data.r)/TFELD.seite)'wenn mit runden ecken, dann nur mittleres!!
						coll:+o.data.get_collision(TMAPS.map.felder[Int(Float(o.data.x+o.data.r+o.data.v_x)/TFELD.seite),i].typ)
					Next
					
					If coll>0 Then
						o.data.v_x=0
					End If
				Else
					'kein wechsel
					
					
				End If
				
			Else
				'negativ
				
				
				If Int(Float(o.data.x-o.data.r)/TFELD.seite)>Int(Float(o.data.x-o.data.r+o.data.v_x)/TFELD.seite) Then
					'feld-wechsel
					
					Local coll:Int=0
					
					For Local i:Int=Int((o.data.y-o.data.r)/TFELD.seite) To Int((o.data.y+o.data.r)/TFELD.seite)'wenn mit runden ecken, dann nur mittleres!!
						coll:+o.data.get_collision(TMAPS.map.felder[Int(Float(o.data.x-o.data.r+o.data.v_x)/TFELD.seite),i].typ)
					Next
					
					If coll>0 Then
						o.data.v_x=0
					End If
				Else
					'kein wechsel
					
					
				End If
				
			End If
			
			
			
			
			If o.data.v_y=0 Then
				'stillstand
			Else If o.data.v_y>0
				'positiv
				
				If Int(Float(o.data.y+o.data.r)/TFELD.seite)<Int(Float(o.data.y+o.data.r+o.data.v_y)/TFELD.seite) Then
					'feld-wechsel
					
					Local coll:Int=0
					
					For Local i:Int=Int((o.data.x-o.data.r)/TFELD.seite) To Int((o.data.x+o.data.r)/TFELD.seite)'wenn mit runden ecken, dann nur mittleres!!
						coll:+o.data.get_collision(TMAPS.map.felder[i,Int(Float(o.data.y+o.data.r+o.data.v_y)/TFELD.seite)].typ)
					Next
					
					If coll>0 Then
						o.data.v_y=0
					End If
				Else
					'kein wechsel
					
					
				End If
				
			Else
				'negativ
				
				
				If Int(Float(o.data.y-o.data.r)/TFELD.seite)>Int(Float(o.data.y-o.data.r+o.data.v_y)/TFELD.seite) Then
					'feld-wechsel
					
					Local coll:Int=0
					
					For Local i:Int=Int((o.data.x-o.data.r)/TFELD.seite) To Int((o.data.x+o.data.r)/TFELD.seite)'wenn mit runden ecken, dann nur mittleres!!
						coll:+o.data.get_collision(TMAPS.map.felder[i,Int(Float(o.data.y-o.data.r+o.data.v_y)/TFELD.seite)].typ)
					Next
					
					If coll>0 Then
						o.data.v_y=0
					End If
				Else
					'kein wechsel
					
					
				End If
				
			End If
		Next
		
	End Function
End Type


Type TOBJ_DATA'# 1 #
	Field id:Int
	Field player_id:Int
	
	Const data_delay:Int=50'millisecs()
	Field last_sent:Int'millisecs()
	
	
	
	
	
	Field x:Float'COLLISION
	Field y:Float'COLLISION
	Field z:Int'Field collision_group:Int'COLLISION
	'1=underground
	'2=ground
	'3=air
	'wenn 0 dann error bei collision!!!
	
	Field w:Float
	Field r:Float'COLLISION
	
	Field v_x:Float'COLLISION
	Field v_y:Float'COLLISION
	
	Field mobilheit:Float'COLLISION
	
	Field sichtweite:Float
	Field sichtweite_radar:Float
	
	'Field actual_command:String'macht das sinn hier???
	
	Function create:TOBJ_DATA(id:Int, x:Float, y:Float, player_id:Int) Abstract
		'Local o:TOBJEKT=New TOBJEKT
	
	Method get_collision:Int(typ:Int)'0=keine kollision, 1=kollision
		Select typ
			Case 0,1,2'ok
				Return 0
			Case 3,4,5'nope
				Return 1
			Default'nope
				Return 1
		End Select
	End Method
	
	Method render() Abstract
	Method draw() Abstract
	Method get_data:String(typ:Int=0) Abstract
End Type


Type TOBJ_DATA_LEBEND Extends TOBJ_DATA'# 2 #
	Field leben:Float
	Field leben_max:Float
	
	Method schaden(fire:Float, power:Float, bio:Float, tech:Float) Abstract
		'self.leben:-(fire*0.1+power*0.5+bio*2.0+tech*0.3)'je nach sorte und upgrade
	'end method
	
	
	Method render() Abstract
		Rem
		Self.x:+Self.v_x
		Self.y:+Self.v_y
		Self.v_x=0.0
		Self.v_y=0.0
		
		
		Self.render_leben()
	End Method
	End Rem
	
	Method render_leben() Abstract
		Rem
		'berechnen wieviel er zur�ckbekommt
		'bsp:
		Self.leben:+1.0'je nach sorte und upgrade
		If Self.leben>Self.leben_max Then Self.leben>Self.leben_max
		
		
		'berechnen, wann er stirbt
		Self.stirbt()
	End Method
	End Rem
	
	Method stirbt() Final
		If Self.leben<0 Then
			TOBJEKT.liste.remove(TOBJEKT.get_map(Self.id))
			TOBJEKT.map.remove(String(Self.id))
			
			For Local p:TNET_PLAYER=EachIn TPLAYER.liste
				p.UDP_STREAM_OUT.WriteLine("OID "+String(Self.id))
				p.UDP_STREAM_OUT.SendMsg()
			Next
			
		End If
	End Method
End Type

Type TOBJ_DATA_LEBEND_UNIT Extends TOBJ_DATA_LEBEND'# 3 #
	Field actual_command:String
	
	Field attack_id:Int'eigentlich macht es keinen sinn
	
	Method schaden(fire:Float, power:Float, bio:Float, tech:Float) Abstract
		'self.leben:-(fire*0.1+power*0.5+bio*2.0+tech*0.3)'je nach sorte und upgrade
	'end method
	
	
	Method render_actual_command() Abstract
	
	
	Method render() Abstract
		'Self.x:+Self.v_x
		'Self.y:+Self.v_y
		'Self.v_x=0.0
		'Self.v_y=0.0
		'
		'Self.render_actual_command()
		'
		'Self.render_leben()
	'End Method
	
	
	Method render_leben() Abstract
		Rem
		'berechnen wieviel er zur�ckbekommt
		'bsp:
		
		Self.leben:+1.0'je nach sorte und upgrade
		If Self.leben>Self.leben_max Then Self.leben>Self.leben_max
		
		
		'berechnen, wann er stirbt
		Self.stirbt()
	End Method
	End Rem
	
	Function ini()
		TOBJ_DATA_LEBEND_UNIT.image_ring=LoadImage("creatures\ring.png")
		MidHandleImage TOBJ_DATA_LEBEND_UNIT.image_ring
	End Function
	
	Global image_ring:TImage
End Type


Type TOBJ_DATA_LEBEND_STONE Extends TOBJ_DATA_LEBEND'# 3 #
	Const data_delay:Int=500'millisecs()
	
	
	
	Method schaden(fire:Float, power:Float, bio:Float, tech:Float)
		Self.leben:-(fire*0.6+power*0.7+bio*0.5+tech*1.0)'je nach sorte und upgrade
	End Method
	
	
	Method render()
		Self.x:+Self.v_x
		Self.y:+Self.v_y
		Self.v_x=0.0
		Self.v_y=0.0
		
		Self.render_leben()
	End Method
	
	
	Method render_leben()
		'berechnen wieviel er zur�ckbekommt
		
		'Self.leben:+1.0'je nach sorte und upgrade
		'If Self.leben>Self.leben_max Then Self.leben>Self.leben_max
		
		'berechnen, wann er stirbt
		Self.stirbt()
	End Method
	
	
	Function create:TOBJ_DATA(id:Int, x:Float, y:Float, player_id:Int)
		Local ob:TOBJ_DATA_LEBEND_STONE=New TOBJ_DATA_LEBEND_STONE
		
		ob.id=id
		ob.x=x
		ob.y=y
		ob.z=2
		
		ob.w=0.0
		ob.r=50.0
		ob.mobilheit=0
		
		ob.player_id=player_id
		
		ob.leben_max=100000.0
		ob.leben=ob.leben_max
		
		'Const data_delay:Int=50'millisecs()
		ob.last_sent=MilliSecs()
		
		ob.sichtweite=0.0'eigentlich sinnlos...
		ob.sichtweite_radar=0.0'eigentlich sinnlos...
		
		
		Return ob
	End Function
	
	Method get_collision:Int(typ:Int)'0=keine kollision, 1=kollision
		'SINNLOS
		Return 0
	End Method
	
	
	Method draw()
		SetColor 255,150,0
		
		SetScale 2*Self.r/100.0,2*Self.r/100.0
		DrawImage TOBJ_DATA_LEBEND_UNIT.image_ring,Self.x+ANSICHT.x,Self.y+ANSICHT.y
		SetScale 1,1
		
		DrawText Int(Self.leben),Self.x+ANSICHT.x-5,Self.y+ANSICHT.y+Self.r+2
		
		'@@@@@@@@@
		
		SetColor 255,255,255
		SetScale 2*Self.r/100.0,2*Self.r/100.0
		DrawImage TOBJ_DATA_LEBEND_STONE.image_stein,Self.x+ANSICHT.x,Self.y+ANSICHT.y
		SetScale 1,1
	End Method
	
	
	Method get_data:String(typ:Int=0)
		
		Local data:String=""
		Select typ
			Case 0
				data:+String(Self.id)+" "
				data:+"stone "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.r)+" "
				data:+ZIP_DATA.mini_float(Self.leben_max)+" "
				data:+ZIP_DATA.mini_float(Self.leben)
			Case 1
				data:+String(Self.id)+" "
				data:+"stone "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.r)+" "
				data:+ZIP_DATA.mini_float(Self.leben_max)+" "
				data:+ZIP_DATA.mini_float(Self.leben)
			Case 2
				data:+String(Self.id)+" "
				data:+ZIP_DATA.mini_float(Self.leben)
			Case 3
				data:+String(Self.id)+" "
				data:+ZIP_DATA.mini_float(Self.leben)
		End Select
		
		
		Return data
	End Method
	
	
	Function ini()
		TOBJ_DATA_LEBEND_STONE.image_stein=LoadImage("creatures\stein.png")
		MidHandleImage TOBJ_DATA_LEBEND_STONE.image_stein
	End Function
	
	Global image_stein:TImage
End Type



Type TOBJ_DATA_MINERALS Extends TOBJ_DATA'# 2 #
	Const data_delay:Int=200
	Field material_left:Float
	Field material_start:Float
	
	
	Function create:TOBJ_DATA(id:Int, x:Float, y:Float, player_id:Int)
		Local od:TOBJ_DATA_MINERALS=New TOBJ_DATA_MINERALS
		
		od.id=id'sehr wichtig!!!
		
		od.player_id=player_id
		
		od.x=x
		od.y=y
		od.z=2
		od.r=20
		
		od.w=Rand(1,360)
		
		od.mobilheit=0
		
		od.material_start=100
		od.material_left=od.material_start
		
		Return od
	End Function
	
	
	Method get_collision:Int(typ:Int)'0=keine kollision, 1=kollision
		Return 0
	End Method
	
	
	Method render()
		If Self.material_left>=0 Then
			
		End If
	End Method
	
	
	Method draw()
		Rem
		SetColor 255,255,255
		
		SetScale 2*Self.r/100.0,2*Self.r/100.0
		DrawImage TOBJ_DATA_LEBEND_UNIT.image_ring,Self.x+ANSICHT.x,Self.y+ANSICHT.y
		SetScale 1,1
		
		DrawText Int(Self.material_left),Self.x+ANSICHT.x-5,Self.y+ANSICHT.y+Self.r+2
		End Rem
		'@@@@@@@@@
		
		SetColor 255,255,255
		SetScale 2*Self.r/40.0,2*Self.r/40.0
		DrawImage TOBJ_DATA_MINERALS.image_mineral,Self.x+ANSICHT.x,Self.y+ANSICHT.y
		SetScale 1,1
	End Method
	
	
	Function ini()
		TOBJ_DATA_MINERALS.image_mineral=LoadImage("creatures\mineral.png")
		MidHandleImage TOBJ_DATA_MINERALS.image_mineral
	End Function
	
	Global image_mineral:TImage
	
	
	Method get_data:String(typ:Int=0)
		Local data:String=""
		
		Select typ
			Case 0'create-all data
				data:+String(Self.id)+" "
				data:+"mineral "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.w)+" "
				data:+ZIP_DATA.mini_float(Self.r)+" "
				
				data:+ZIP_DATA.mini_float(Self.material_start)+" "
				data:+ZIP_DATA.mini_float(Self.material_left)
				
				
			Case 1'create-other players
				data:+String(Self.id)+" "
				data:+"mineral "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.w)+" "
				data:+ZIP_DATA.mini_float(Self.r)+" "
				
				data:+ZIP_DATA.mini_float(Self.material_start)+" "
				data:+ZIP_DATA.mini_float(Self.material_left)
				
				
			Case 2'new-data all data
				data:+String(Self.id)+" "
				
				data:+ZIP_DATA.mini_float(Self.material_left)
				
			Case 3'new-data other players
				data:+String(Self.id)+" "
				
				data:+ZIP_DATA.mini_float(Self.material_left)
		End Select
		
		Return data
	End Method
	
End Type

Type TOBJ_DATA_FORCEFIELD Extends TOBJ_DATA'# 2 #
	Field time:Int'millisecs
End Type


Type TOBJ_DATA_LEBEND_UNIT_SOLDIER Extends TOBJ_DATA_LEBEND_UNIT'# 4 #
	Field speed:Float=2.0
	
	Field schussweite:Float
	Field schuss_last:Int
	Field schuss_delay:Int
	Field schuss:Int'wird bei schuss auf 1 gesetzt und bei senden auf 0
	Field schuss_zu_senden:Int'wird bei schuss auf 1 gesetzt und wenn schuss=0 dann auf 0
		
	'Field attack_id:Int'nicht das objekt, damit nicht gespeichert!!!
	Field shooting:Int=0
	
	Function create:TOBJ_DATA(id:Int, x:Float, y:Float, player_id:Int)
		Local od:TOBJ_DATA_LEBEND_UNIT_SOLDIER=New TOBJ_DATA_LEBEND_UNIT_SOLDIER
		
		od.id=id'sehr wichtig!!!
		
		od.player_id=player_id
		
		od.x=x
		od.y=y
		od.r=15
		
		od.mobilheit=1
		
		od.leben_max=10000
		od.leben=od.leben_max
		
		od.sichtweite=300.0
		od.sichtweite_radar=300.0
		od.schussweite=150.0
		od.speed=1.5
		
		od.schuss_delay=1000
		
		Return od
	End Function
	
	
	Method render()
		Self.x:+Self.v_x
		Self.y:+Self.v_y
		Self.v_x=0.0
		Self.v_y=0.0
		
		Self.render_actual_command()
		
		Self.render_leben()
		
		If Self.schuss=0 Then
			Self.schuss_zu_senden=0
		End If
		
	End Method
	
	Method schaden(fire:Float, power:Float, bio:Float, tech:Float)
		Self.leben:-(fire*0.5+power*0.5+bio*2.0+tech*1.0)'je nach sorte und upgrade
	End Method
	
	Method render_actual_command()
		Self.shooting=0
		
		Select Lower(Mid(Self.actual_command, 1, 3))'w�re vielleicht mit types optimierbar
			Case ""
				Self.attack_id=0
				Local act_range:Float=(Self.sichtweite)^2
				For Local o:TOBJEKT=EachIn TOBJEKT.liste
					If TOBJ_DATA_LEBEND(o.data) And Not TOBJ_DATA_LEBEND_STONE(o.data) Then
						If o.data.player_id<>Self.player_id Then
							
							If TPLAYER.get_map(o.data.player_id).team_id<>TPLAYER.get_map(Self.player_id).team_id Then
								If (o.data.x-Self.x)^2+(o.data.y-Self.y)^2<act_range Then
									act_range=(o.data.x-Self.x)^2+(o.data.y-Self.y)^2
									Self.actual_command="atc "+o.data.id
									Self.attack_id=o.data.id
								End If
							End If
							
						End If
					End If
				Next
			Case "atc"
				Local id:Int=Int(Mid(Self.actual_command, 5, -1))
				
				Local o:TOBJEKT=TOBJEKT.get_map(id)
				
				If o And TOBJ_DATA_LEBEND(o.data) Then
					If (o.data.x-Self.x)^2+(o.data.y-Self.y)^2<(Self.schussweite+o.data.r)^2 Then
						Self.shooting=1
						
						If Self.schuss_last+Self.schuss_delay<=MilliSecs()
							TOBJ_DATA_LEBEND(o.data).schaden(100,100,100,100)
							Self.schuss_last=MilliSecs()
							
							Self.schuss=1
							Self.schuss_zu_senden=1
						End If
						
						Self.w=ATan2(o.data.y-Self.y-Self.v_y, o.data.x-Self.x-Self.v_x)'k�nnte man optimieren
					Else
						If (o.data.x-Self.x)^2+(o.data.y-Self.y)^2<(Self.sichtweite+o.data.r)^2 Then
							Self.w=ATan2(o.data.y-Self.y-Self.v_y, o.data.x-Self.x-Self.v_x)'k�nnte man optimieren
							
							Self.v_x:+Cos(Self.w)*Self.speed
							Self.v_y:+Sin(Self.w)*Self.speed
						Else
							Self.actual_command=""
							Self.attack_id=0
						End If
					End If
				Else
					Self.actual_command=""
					Self.attack_id=0
				End If

				
				
			Case "sot"'send object to (x,y,r)
				Local txt:String=Mid(Self.actual_command, 5, -1)
				
				Local pos:Int=Instr(txt, " ", 1)
				Local pos2:Int=Instr(txt, " ", pos+1)
				Local xx:Float=Float(Mid(txt, 1, pos-1))
				Local yy:Float=Float(Mid(txt, pos+1, pos2-1))
				Local rr:Float=Float(Mid(txt, pos2+1, -1))
				
				Self.w=ATan2(yy-Self.y-Self.v_y, xx-Self.x-Self.v_x)'k�nnte man optimieren
				
				Self.v_x:+Cos(Self.w)*Self.speed
				Self.v_y:+Sin(Self.w)*Self.speed
				
				If (yy-Self.y-Self.v_y)^2+(xx-Self.x-Self.v_x)^2<rr^2 Then
					Self.actual_command=""
				End If
			Case "awp"'send object waypoints(x,y,r)
				'immer space zwischen den waypoints
				'x,y,r mit : getrennt
				
				
				Local txt:String=Mid(Self.actual_command, 5, -1)
				
				Local pos_fw:Int=Instr(txt, " ", 1)
				Local first_waypoint:String
				
				
				If pos_fw=0 Then
					first_waypoint=txt
				Else
					first_waypoint=Mid(txt, 1, pos_fw-1)
				End If
				
				
				Local pos:Int=Instr(first_waypoint, ":", 1)
				Local pos2:Int=Instr(first_waypoint, ":", pos+1)
				Local xx:Float=Float(Mid(first_waypoint, 1, pos-1))
				Local yy:Float=Float(Mid(first_waypoint, pos+1, pos2-1))
				Local rr:Float=Float(Mid(first_waypoint, pos2+1, -1))
				
				Self.w=ATan2(yy-Self.y-Self.v_y, xx-Self.x-Self.v_x)'k�nnte man optimieren
				
				Self.v_x:+Cos(Self.w)*Self.speed
				Self.v_y:+Sin(Self.w)*Self.speed
				
				If (yy-Self.y-Self.v_y)^2+(xx-Self.x-Self.v_x)^2<rr^2 Then
					If pos_fw=0 Then
						Self.actual_command=""
					Else
						'Print Self.actual_command
						Self.actual_command="AWP "+Mid(txt, pos_fw+1,-1)
						'Print Self.actual_command
						'Print "+"
					End If
				End If
		End Select
	End Method
	
	Method render_leben()
		'berechnen wieviel er zur�ckbekommt
		Self.leben:+1.0'je nach sorte und upgrade
		If Self.leben>Self.leben_max Then Self.leben=Self.leben_max
		
		'berechnen, wann er stirbt
		Self.stirbt()
	End Method
	
	
	
	Method draw()
		If TPLAYER.get_map(Self.player_id) Then
			SetColor TPLAYER.get_map(Self.player_id).color_r,TPLAYER.get_map(Self.player_id).color_g,TPLAYER.get_map(Self.player_id).color_b
		Else
			SetColor 255,255,255
		End If
		
		'DrawOval Self.x+ANSICHT.x-Self.r,Self.y+ANSICHT.y-Self.r,Self.r*2,Self.r*2
		
		SetScale 2*Self.r/100.0,2*Self.r/100.0
		DrawImage TOBJ_DATA_LEBEND_UNIT.image_ring,Self.x+ANSICHT.x,Self.y+ANSICHT.y
		SetScale 1,1
		
		DrawText Int(Self.leben),Self.x+ANSICHT.x-5,Self.y+ANSICHT.y+Self.r+2
		
		'@@@@@@@@@
		
		SetColor 255,255,255
		SetRotation Self.w
		SetScale 2*Self.r/50.0,2*Self.r/50.0
		DrawImage TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_c1,Self.x+ANSICHT.x,Self.y+ANSICHT.y
		SetScale 1,1
		SetRotation 0
	End Method
	
	Function ini()
		TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_c1=LoadImage("creatures\c1.png")
		MidHandleImage TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_c1
	End Function
	
	Global image_c1:TImage
	
	'@@@@@@@@
	
	Method get_data:String(typ:Int=0)
		Local data:String=""
		
		Select typ
			Case 0'create-all data
				data:+String(Self.id)+" "
				data:+"soldier "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.w)+" "
				data:+ZIP_DATA.mini_float(Self.r)+" "
				
				data:+ZIP_DATA.mini_float(Self.sichtweite)+" "
				data:+ZIP_DATA.mini_float(Self.sichtweite_radar)+" "
				
				data:+ZIP_DATA.mini_float(Self.leben)+" "
				data:+ZIP_DATA.mini_float(Self.leben_max)+" "
				data:+String(player_id)
				
			Case 1'create-other players
				data:+String(Self.id)+" "
				data:+"soldier "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.w)+" "
				data:+ZIP_DATA.mini_float(Self.r)+" "
				
				data:+ZIP_DATA.mini_float(Self.sichtweite)+" "
				data:+ZIP_DATA.mini_float(Self.sichtweite_radar)+" "
				
				data:+ZIP_DATA.mini_float(Self.leben)+" "
				data:+ZIP_DATA.mini_float(Self.leben_max)+" "
				data:+String(player_id)
				
			Case 2'new-data all data
				data:+String(Self.id)+" "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.w)+" "
				
				data:+ZIP_DATA.mini_float(Self.leben)+" "
				
				'schiesst auf
				
				If Self.shooting=1 Then
					data:+attack_id+" "
				Else
					data:+"0 "
				End If
				
				'schuss
				
				If Self.schuss_zu_senden=1 Then
					Self.schuss=0
					data:+"1 "
				Else
					data:+"0 "
				End If
				
				'befehle
				
				If Self.actual_command="" Then
					data:+"non"
				Else
					data:+Self.actual_command
				End If
				
			Case 3'new-data other players
				data:+String(Self.id)+" "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.w)+" "
				
				data:+ZIP_DATA.mini_float(Self.leben)+" "
				'schiesst auf
				
				If Self.shooting=1 Then
					data:+attack_id+" "
				Else
					data:+"0 "
				End If
				
				'schuss
				
				If Self.schuss_zu_senden=1 Then
					Self.schuss=0
					data:+"1 "
				Else
					data:+"0 "
				End If
		End Select
		
		Return data
	End Method
End Type



Type TOBJ_DATA_LEBEND_UNIT_AMEISE Extends TOBJ_DATA_LEBEND_UNIT'# 4 #
	Field speed:Float=3.0
	
	Field schussweite:Float
	Field schuss_last:Int
	Field schuss_delay:Int
	Field schuss:Int'wird bei schuss auf 1 gesetzt und bei senden auf 0
	Field schuss_zu_senden:Int'wird bei schuss auf 1 gesetzt und wenn schuss=0 dann auf 0
		
	'Field attack_id:Int'nicht das objekt, damit nicht gespeichert!!!
	Field shooting:Int=0
	
	Function create:TOBJ_DATA(id:Int, x:Float, y:Float, player_id:Int)
		Local od:TOBJ_DATA_LEBEND_UNIT_AMEISE=New TOBJ_DATA_LEBEND_UNIT_AMEISE
		
		od.id=id'sehr wichtig!!!
		
		od.player_id=player_id
		
		od.x=x
		od.y=y
		od.r=10
		
		od.mobilheit=2
		
		od.leben_max=1000
		od.leben=od.leben_max
		
		od.sichtweite=250.0
		od.sichtweite_radar=250.0
		od.schussweite=21.0
		od.speed=3.5
		
		od.schuss_delay=300
		
		Return od
	End Function
	
	
	Method render()
		Self.x:+Self.v_x
		Self.y:+Self.v_y
		Self.v_x=0.0
		Self.v_y=0.0
		
		Self.render_actual_command()
		
		Self.render_leben()
		
		If Self.schuss=0 Then
			Self.schuss_zu_senden=0
		End If
		
	End Method
	
	Method schaden(fire:Float, power:Float, bio:Float, tech:Float)
		Self.leben:-(fire*1.0+power*0.5+bio*3.0+tech*0.5)'je nach sorte und upgrade
	End Method
	
	Method render_actual_command()
		Self.shooting=0
		
		Select Lower(Mid(Self.actual_command, 1, 3))'w�re vielleicht mit types optimierbar
			Case ""
				Self.attack_id=0
				Local act_range:Float=(Self.sichtweite)^2
				For Local o:TOBJEKT=EachIn TOBJEKT.liste
					If TOBJ_DATA_LEBEND(o.data) And Not TOBJ_DATA_LEBEND_STONE(o.data) Then
						If o.data.player_id<>Self.player_id Then
							
							If TPLAYER.get_map(o.data.player_id).team_id<>TPLAYER.get_map(Self.player_id).team_id Then
								If (o.data.x-Self.x)^2+(o.data.y-Self.y)^2<act_range Then
									act_range=(o.data.x-Self.x)^2+(o.data.y-Self.y)^2
									Self.actual_command="atc "+o.data.id
									Self.attack_id=o.data.id
								End If
							End If
							
						End If
					End If
				Next
			Case "atc"
				Local id:Int=Int(Mid(Self.actual_command, 5, -1))
				
				Local o:TOBJEKT=TOBJEKT.get_map(id)
				
				If o And TOBJ_DATA_LEBEND(o.data) Then
					If (o.data.x-Self.x)^2+(o.data.y-Self.y)^2<(Self.schussweite+o.data.r)^2 Then
						Self.shooting=1
						
						If Self.schuss_last+Self.schuss_delay<=MilliSecs()
							TOBJ_DATA_LEBEND(o.data).schaden(100,100,100,100)
							Self.schuss_last=MilliSecs()
							
							Self.schuss=1
							Self.schuss_zu_senden=1
						End If
						
						Self.w=ATan2(o.data.y-Self.y-Self.v_y, o.data.x-Self.x-Self.v_x)'k�nnte man optimieren
					Else
						If (o.data.x-Self.x)^2+(o.data.y-Self.y)^2<(Self.sichtweite+o.data.r)^2 Then
							Self.w=ATan2(o.data.y-Self.y-Self.v_y, o.data.x-Self.x-Self.v_x)'k�nnte man optimieren
							
							Self.v_x:+Cos(Self.w)*Self.speed
							Self.v_y:+Sin(Self.w)*Self.speed
						Else
							Self.actual_command=""
							Self.attack_id=0
						End If
					End If
				Else
					Self.actual_command=""
					Self.attack_id=0
				End If
				
				
			Case "sot"'send object to (x,y,r)
				Local txt:String=Mid(Self.actual_command, 5, -1)
				
				Local pos:Int=Instr(txt, " ", 1)
				Local pos2:Int=Instr(txt, " ", pos+1)
				Local xx:Float=Float(Mid(txt, 1, pos-1))
				Local yy:Float=Float(Mid(txt, pos+1, pos2-1))
				Local rr:Float=Float(Mid(txt, pos2+1, -1))
				
				Self.w=ATan2(yy-Self.y-Self.v_y, xx-Self.x-Self.v_x)'k�nnte man optimieren
				
				Self.v_x:+Cos(Self.w)*Self.speed
				Self.v_y:+Sin(Self.w)*Self.speed
				
				If (yy-Self.y-Self.v_y)^2+(xx-Self.x-Self.v_x)^2<rr^2 Then
					Self.actual_command=""
				End If
			Case "awp"'send object waypoints(x,y,r)
				'immer space zwischen den waypoints
				'x,y,r mit : getrennt
				
				
				Local txt:String=Mid(Self.actual_command, 5, -1)
				
				Local pos_fw:Int=Instr(txt, " ", 1)
				Local first_waypoint:String
				
				
				If pos_fw=0 Then
					first_waypoint=txt
				Else
					first_waypoint=Mid(txt, 1, pos_fw-1)
				End If
				
				
				Local pos:Int=Instr(first_waypoint, ":", 1)
				Local pos2:Int=Instr(first_waypoint, ":", pos+1)
				Local xx:Float=Float(Mid(first_waypoint, 1, pos-1))
				Local yy:Float=Float(Mid(first_waypoint, pos+1, pos2-1))
				Local rr:Float=Float(Mid(first_waypoint, pos2+1, -1))
				
				Self.w=ATan2(yy-Self.y-Self.v_y, xx-Self.x-Self.v_x)'k�nnte man optimieren
				
				Self.v_x:+Cos(Self.w)*Self.speed
				Self.v_y:+Sin(Self.w)*Self.speed
				
				If (yy-Self.y-Self.v_y)^2+(xx-Self.x-Self.v_x)^2<rr^2 Then
					If pos_fw=0 Then
						Self.actual_command=""
					Else
						'Print Self.actual_command
						Self.actual_command="AWP "+Mid(txt, pos_fw+1,-1)
						'Print Self.actual_command
						'Print "+"
					End If
				End If
		End Select
	End Method
	
	Method render_leben()
		'berechnen wieviel er zur�ckbekommt
		Self.leben:+1.0'je nach sorte und upgrade
		If Self.leben>Self.leben_max Then Self.leben=Self.leben_max
		
		'berechnen, wann er stirbt
		Self.stirbt()
	End Method
	
	
	
	Method draw()
		If TPLAYER.get_map(Self.player_id) Then
			SetColor TPLAYER.get_map(Self.player_id).color_r,TPLAYER.get_map(Self.player_id).color_g,TPLAYER.get_map(Self.player_id).color_b
		Else
			SetColor 255,255,255
		End If
		
		'DrawOval Self.x+ANSICHT.x-Self.r,Self.y+ANSICHT.y-Self.r,Self.r*2,Self.r*2
		
		SetScale 2*Self.r/100.0,2*Self.r/100.0
		DrawImage TOBJ_DATA_LEBEND_UNIT.image_ring,Self.x+ANSICHT.x,Self.y+ANSICHT.y
		SetScale 1,1
		
		DrawText Int(Self.leben),Self.x+ANSICHT.x-5,Self.y+ANSICHT.y+Self.r+2
		
		'@@@@@@@@@
		
		SetColor 255,255,255
		SetRotation Self.w
		SetScale 2*Self.r/50.0,2*Self.r/50.0
		DrawImage TOBJ_DATA_LEBEND_UNIT_AMEISE.image_ameise,Self.x+ANSICHT.x,Self.y+ANSICHT.y
		SetScale 1,1
		SetRotation 0
	End Method
	
	Function ini()
		TOBJ_DATA_LEBEND_UNIT_AMEISE.image_ameise=LoadImage("creatures\ameise.png")
		MidHandleImage TOBJ_DATA_LEBEND_UNIT_AMEISE.image_ameise
	End Function
	
	Global image_ameise:TImage
	
	'@@@@@@@@
	
	Method get_data:String(typ:Int=0)
		Local data:String=""
		
		Select typ
			Case 0'create-all data
				data:+String(Self.id)+" "
				data:+"ameise "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.w)+" "
				data:+ZIP_DATA.mini_float(Self.r)+" "
				
				data:+ZIP_DATA.mini_float(Self.sichtweite)+" "
				data:+ZIP_DATA.mini_float(Self.sichtweite_radar)+" "
				
				data:+ZIP_DATA.mini_float(Self.leben)+" "
				data:+ZIP_DATA.mini_float(Self.leben_max)+" "
				data:+String(player_id)
				
			Case 1'create-other players
				data:+String(Self.id)+" "
				data:+"ameise "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.w)+" "
				data:+ZIP_DATA.mini_float(Self.r)+" "
				
				data:+ZIP_DATA.mini_float(Self.sichtweite)+" "
				data:+ZIP_DATA.mini_float(Self.sichtweite_radar)+" "
				
				data:+ZIP_DATA.mini_float(Self.leben)+" "
				data:+ZIP_DATA.mini_float(Self.leben_max)+" "
				data:+String(player_id)
				
			Case 2'new-data all data
				data:+String(Self.id)+" "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.w)+" "
				
				data:+ZIP_DATA.mini_float(Self.leben)+" "
				
				'schiesst auf
				
				If Self.shooting=1 Then
					data:+attack_id+" "
				Else
					data:+"0 "
				End If
				
				'schuss
				
				If Self.schuss_zu_senden=1 Then
					Self.schuss=0
					data:+"1 "
				Else
					data:+"0 "
				End If
				
				'befehle
				
				If Self.actual_command="" Then
					data:+"non"
				Else
					data:+Self.actual_command
				End If
				
			Case 3'new-data other players
				data:+String(Self.id)+" "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.w)+" "
				
				data:+ZIP_DATA.mini_float(Self.leben)+" "
				'schiesst auf
				
				If Self.shooting=1 Then
					data:+attack_id+" "
				Else
					data:+"0 "
				End If
				
				'schuss
				
				If Self.schuss_zu_senden=1 Then
					Self.schuss=0
					data:+"1 "
				Else
					data:+"0 "
				End If
		End Select
		
		Return data
	End Method
End Type


Type TOBJ_DATA_LEBEND_UNIT_DRONE Extends TOBJ_DATA_LEBEND_UNIT'# 4 #
	Field speed:Float
	
	Field schussweite:Float
	Field schuss_last:Int
	Field schuss_delay:Int
	Field schuss:Int'wird bei schuss auf 1 gesetzt und bei senden auf 0
	Field schuss_zu_senden:Int'wird bei schuss auf 1 gesetzt und wenn schuss=0 dann auf 0
		
	'Field attack_id:Int'nicht das objekt, damit nicht gespeichert!!!
	Field shooting:Int=0
	
	Function create:TOBJ_DATA(id:Int, x:Float, y:Float, player_id:Int)
		Local od:TOBJ_DATA_LEBEND_UNIT_DRONE=New TOBJ_DATA_LEBEND_UNIT_DRONE
		
		od.id=id'sehr wichtig!!!
		
		od.player_id=player_id
		
		od.x=x
		od.y=y
		od.r=10
		
		od.mobilheit=2
		
		od.leben_max=500
		od.leben=od.leben_max
		
		od.sichtweite=150.0
		od.sichtweite_radar=150.0
		od.schussweite=15.0
		od.speed=2.0
		
		od.schuss_delay=50
		
		Return od
	End Function
	
	Method render()
		Self.x:+Self.v_x
		Self.y:+Self.v_y
		Self.v_x=0.0
		Self.v_y=0.0
		
		Self.render_actual_command()
		
		Self.render_leben()
		
		If Self.schuss=0 Then
			Self.schuss_zu_senden=0
		End If
		
	End Method
	
	Method schaden(fire:Float, power:Float, bio:Float, tech:Float)
		Self.leben:-(fire*2.0+power*0.5+bio*2.0+tech*0.5)'je nach sorte und upgrade
	End Method
	
	Method render_actual_command()
		Self.shooting=0
		
		Select Lower(Mid(Self.actual_command, 1, 3))'w�re vielleicht mit types optimierbar
			Case ""
				Rem
				Self.attack_id=0
				Local act_range:Float=(Self.sichtweite)^2
				For Local o:TOBJEKT=EachIn TOBJEKT.liste
					If TOBJ_DATA_LEBEND(o.data) And Not TOBJ_DATA_LEBEND_STONE(o.data) Then
						If o.data.player_id<>Self.player_id Then
							
							If TPLAYER.get_map(o.data.player_id).team_id<>TPLAYER.get_map(Self.player_id).team_id Then
								If (o.data.x-Self.x)^2+(o.data.y-Self.y)^2<act_range Then
									act_range=(o.data.x-Self.x)^2+(o.data.y-Self.y)^2
									Self.actual_command="atc "+o.data.id
									Self.attack_id=o.data.id
								End If
							End If
							
						End If
					End If
				Next
				End Rem
			Case "atc"
				Local id:Int=Int(Mid(Self.actual_command, 5, -1))
				
				Local o:TOBJEKT=TOBJEKT.get_map(id)
				
				If o And TOBJ_DATA_LEBEND(o.data) Then
					If (o.data.x-Self.x)^2+(o.data.y-Self.y)^2<(Self.schussweite+o.data.r)^2 Then
						Self.shooting=1
						
						If Self.schuss_last+Self.schuss_delay<=MilliSecs()
							TOBJ_DATA_LEBEND(o.data).schaden(5,5,5,5)
							Self.schuss_last=MilliSecs()
							
							Self.schuss=1
							Self.schuss_zu_senden=1
						End If
						
						Self.w=ATan2(o.data.y-Self.y-Self.v_y, o.data.x-Self.x-Self.v_x)'k�nnte man optimieren
					Else
						If (o.data.x-Self.x)^2+(o.data.y-Self.y)^2<(Self.sichtweite+o.data.r)^2 Then
							Self.w=ATan2(o.data.y-Self.y-Self.v_y, o.data.x-Self.x-Self.v_x)'k�nnte man optimieren
							
							Self.v_x:+Cos(Self.w)*Self.speed
							Self.v_y:+Sin(Self.w)*Self.speed
						Else
							Self.actual_command=""
							Self.attack_id=0
						End If
					End If
				Else
					Self.actual_command=""
					Self.attack_id=0
				End If
				
				
			Case "sot"'send object to (x,y,r)
				Local txt:String=Mid(Self.actual_command, 5, -1)
				
				Local pos:Int=Instr(txt, " ", 1)
				Local pos2:Int=Instr(txt, " ", pos+1)
				Local xx:Float=Float(Mid(txt, 1, pos-1))
				Local yy:Float=Float(Mid(txt, pos+1, pos2-1))
				Local rr:Float=Float(Mid(txt, pos2+1, -1))
				
				Self.w=ATan2(yy-Self.y-Self.v_y, xx-Self.x-Self.v_x)'k�nnte man optimieren
				
				Self.v_x:+Cos(Self.w)*Self.speed
				Self.v_y:+Sin(Self.w)*Self.speed
				
				If (yy-Self.y-Self.v_y)^2+(xx-Self.x-Self.v_x)^2<rr^2 Then
					Self.actual_command=""
				End If
			Case "awp"'send object waypoints(x,y,r)
				'immer space zwischen den waypoints
				'x,y,r mit : getrennt
				
				Local txt:String=Mid(Self.actual_command, 5, -1)
				
				Local pos_fw:Int=Instr(txt, " ", 1)
				Local first_waypoint:String
				
				
				If pos_fw=0 Then
					first_waypoint=txt
				Else
					first_waypoint=Mid(txt, 1, pos_fw-1)
				End If
				
				
				Local pos:Int=Instr(first_waypoint, ":", 1)
				Local pos2:Int=Instr(first_waypoint, ":", pos+1)
				Local xx:Float=Float(Mid(first_waypoint, 1, pos-1))
				Local yy:Float=Float(Mid(first_waypoint, pos+1, pos2-1))
				Local rr:Float=Float(Mid(first_waypoint, pos2+1, -1))
				
				Self.w=ATan2(yy-Self.y-Self.v_y, xx-Self.x-Self.v_x)'k�nnte man optimieren
				
				Self.v_x:+Cos(Self.w)*Self.speed
				Self.v_y:+Sin(Self.w)*Self.speed
				
				If (yy-Self.y-Self.v_y)^2+(xx-Self.x-Self.v_x)^2<rr^2 Then
					If pos_fw=0 Then
						Self.actual_command=""
					Else
						'Print Self.actual_command
						Self.actual_command="AWP "+Mid(txt, pos_fw+1,-1)
						'Print Self.actual_command
						'Print "+"
					End If
				End If
			Case "sdm"
				Print "m"
				TPLAYER.get_map(Self.player_id).minerals:+1
		End Select
	End Method
	
	
	Method render_leben()
		'berechnen wieviel er zur�ckbekommt
		Self.leben:+1.0'je nach sorte und upgrade
		If Self.leben>Self.leben_max Then Self.leben=Self.leben_max
		
		'berechnen, wann er stirbt
		Self.stirbt()
	End Method
	
	
	Method draw()
		If TPLAYER.get_map(Self.player_id) Then
			SetColor TPLAYER.get_map(Self.player_id).color_r,TPLAYER.get_map(Self.player_id).color_g,TPLAYER.get_map(Self.player_id).color_b
		Else
			SetColor 255,255,255
		End If
		
		'DrawOval Self.x+ANSICHT.x-Self.r,Self.y+ANSICHT.y-Self.r,Self.r*2,Self.r*2
		
		SetScale 2*Self.r/100.0,2*Self.r/100.0
		DrawImage TOBJ_DATA_LEBEND_UNIT.image_ring,Self.x+ANSICHT.x,Self.y+ANSICHT.y
		SetScale 1,1
		
		DrawText Int(Self.leben),Self.x+ANSICHT.x-5,Self.y+ANSICHT.y+Self.r+2
		
		'@@@@@@@@@
		
		SetColor 255,255,255
		SetRotation Self.w+90
		SetScale 2*Self.r/30.0,2*Self.r/30.0
		DrawImage TOBJ_DATA_LEBEND_UNIT_DRONE.image_drone,Self.x+ANSICHT.x,Self.y+ANSICHT.y
		SetScale 1,1
		SetRotation 0
	End Method
	
	Function ini()
		TOBJ_DATA_LEBEND_UNIT_DRONE.image_drone=LoadImage("creatures\drone.png")
		MidHandleImage TOBJ_DATA_LEBEND_UNIT_DRONE.image_drone
	End Function
	
	Global image_drone:TImage
	
	'@@@@@@@@
	
	Method get_data:String(typ:Int=0)
		Local data:String=""
		
		Select typ
			Case 0'create-all data
				data:+String(Self.id)+" "
				data:+"drone "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.w)+" "
				data:+ZIP_DATA.mini_float(Self.r)+" "
				
				data:+ZIP_DATA.mini_float(Self.sichtweite)+" "
				data:+ZIP_DATA.mini_float(Self.sichtweite_radar)+" "
				
				data:+ZIP_DATA.mini_float(Self.leben)+" "
				data:+ZIP_DATA.mini_float(Self.leben_max)+" "
				data:+String(player_id)
				
			Case 1'create-other players
				data:+String(Self.id)+" "
				data:+"drone "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.w)+" "
				data:+ZIP_DATA.mini_float(Self.r)+" "
				
				data:+ZIP_DATA.mini_float(Self.sichtweite)+" "
				data:+ZIP_DATA.mini_float(Self.sichtweite_radar)+" "
				
				data:+ZIP_DATA.mini_float(Self.leben)+" "
				data:+ZIP_DATA.mini_float(Self.leben_max)+" "
				data:+String(player_id)
				
			Case 2'new-data all data
				data:+String(Self.id)+" "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.w)+" "
				
				data:+ZIP_DATA.mini_float(Self.leben)+" "
				
				'schiesst auf
				
				If Self.shooting=1 Then
					data:+attack_id+" "
				Else
					data:+"0 "
				End If
				
				'schuss
				
				If Self.schuss_zu_senden=1 Then
					Self.schuss=0
					data:+"1 "
				Else
					data:+"0 "
				End If
				
				'befehle
				
				If Self.actual_command="" Then
					data:+"non"
				Else
					data:+Self.actual_command
				End If
				
			Case 3'new-data other players
				data:+String(Self.id)+" "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.w)+" "
				
				data:+ZIP_DATA.mini_float(Self.leben)+" "
				'schiesst auf
				
				If Self.shooting=1 Then
					data:+attack_id+" "
				Else
					data:+"0 "
				End If
				
				'schuss
				
				If Self.schuss_zu_senden=1 Then
					Self.schuss=0
					data:+"1 "
				Else
					data:+"0 "
				End If
		End Select
		
		Return data
	End Method
End Type



Type TOBJ_DATA_LEBEND_UNIT_BASE Extends TOBJ_DATA_LEBEND_UNIT'# 4 #
	'Field speed:Float=3.0
	
	'Field schussweite:Float
	'Field schuss_last:Int
	'Field schuss_delay:Int
	'Field schuss:Int'wird bei schuss auf 1 gesetzt und bei senden auf 0
	'Field schuss_zu_senden:Int'wird bei schuss auf 1 gesetzt und wenn schuss=0 dann auf 0
		
	'Field attack_id:Int'nicht das objekt, damit nicht gespeichert!!!
	'Field shooting:Int=0
	
	Function create:TOBJ_DATA(id:Int, x:Float, y:Float, player_id:Int)
		Local od:TOBJ_DATA_LEBEND_UNIT_BASE=New TOBJ_DATA_LEBEND_UNIT_BASE
		
		od.id=id'sehr wichtig!!!
		
		od.player_id=player_id
		
		od.x=x
		od.y=y
		od.r=50
		
		od.mobilheit=0
		
		od.leben_max=10000
		od.leben=od.leben_max
		
		od.sichtweite=300.0
		od.sichtweite_radar=350.0
		'od.schussweite=21.0
		'od.speed=3.5
		
		'od.schuss_delay=300
		
		Return od
	End Function
	
	
	Method render()
		'Self.x:+Self.v_x
		'Self.y:+Self.v_y
		'Self.v_x=0.0
		'Self.v_y=0.0
		
		Self.render_actual_command()
		
		Self.render_leben()
		
	End Method
	
	Method schaden(fire:Float, power:Float, bio:Float, tech:Float)
		Self.leben:-(fire*1.0+power*0.5+bio*3.0+tech*0.5)'je nach sorte und upgrade
	End Method
	
	Method render_actual_command()
		
		Select Lower(Mid(Self.actual_command, 1, 3))'w�re vielleicht mit types optimierbar
			Case ""
		End Select
	End Method
	
	Method render_leben()
		'berechnen wieviel er zur�ckbekommt
		Self.leben:+5.0'je nach sorte und upgrade
		If Self.leben>Self.leben_max Then Self.leben=Self.leben_max
		
		'berechnen, wann er stirbt
		Self.stirbt()
	End Method
	
	
	Method draw()
		If TPLAYER.get_map(Self.player_id) Then
			SetColor TPLAYER.get_map(Self.player_id).color_r,TPLAYER.get_map(Self.player_id).color_g,TPLAYER.get_map(Self.player_id).color_b
		Else
			SetColor 255,255,255
		End If
		
		'DrawOval Self.x+ANSICHT.x-Self.r,Self.y+ANSICHT.y-Self.r,Self.r*2,Self.r*2
		
		SetScale 2*Self.r/100.0,2*Self.r/100.0
		DrawImage TOBJ_DATA_LEBEND_UNIT.image_ring,Self.x+ANSICHT.x,Self.y+ANSICHT.y
		SetScale 1,1
		
		DrawText Int(Self.leben),Self.x+ANSICHT.x-5,Self.y+ANSICHT.y+Self.r+2
		
		'@@@@@@@@@
		
		SetColor 255,255,255
		SetRotation Self.w
		SetScale 2*Self.r/100.0,2*Self.r/100.0
		DrawImage TOBJ_DATA_LEBEND_UNIT_BASE.image_base,Self.x+ANSICHT.x,Self.y+ANSICHT.y
		SetScale 1,1
		SetRotation 0
	End Method
	
	Function ini()
		TOBJ_DATA_LEBEND_UNIT_BASE.image_base=LoadImage("creatures\base.png")
		MidHandleImage TOBJ_DATA_LEBEND_UNIT_BASE.image_base
	End Function
	
	Global image_base:TImage
	
	'@@@@@@@@
	
	Method get_data:String(typ:Int=0)
		Local data:String=""
		
		Select typ
			Case 0'create-all data
				data:+String(Self.id)+" "
				data:+"base "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.w)+" "
				data:+ZIP_DATA.mini_float(Self.r)+" "
				
				data:+ZIP_DATA.mini_float(Self.sichtweite)+" "
				data:+ZIP_DATA.mini_float(Self.sichtweite_radar)+" "
				
				data:+ZIP_DATA.mini_float(Self.leben)+" "
				data:+ZIP_DATA.mini_float(Self.leben_max)+" "
				data:+String(player_id)
				
			Case 1'create-other players
				data:+String(Self.id)+" "
				data:+"base "
				data:+ZIP_DATA.mini_float(Self.x)+" "
				data:+ZIP_DATA.mini_float(Self.y)+" "
				data:+ZIP_DATA.mini_float(Self.w)+" "
				data:+ZIP_DATA.mini_float(Self.r)+" "
				
				data:+ZIP_DATA.mini_float(Self.sichtweite)+" "
				data:+ZIP_DATA.mini_float(Self.sichtweite_radar)+" "
				
				data:+ZIP_DATA.mini_float(Self.leben)+" "
				data:+ZIP_DATA.mini_float(Self.leben_max)+" "
				data:+String(player_id)
				
			Case 2'new-data all data
				data:+String(Self.id)+" "
				data:+ZIP_DATA.mini_float(Self.leben)
				
			Case 3'new-data other players
				data:+String(Self.id)+" "
				data:+ZIP_DATA.mini_float(Self.leben)
				
		End Select
		
		Return data
	End Method
End Type



Type NETWORK
	Global SERVER_MANAGER_STREAM:TTCPStream
	Global SERVER_MANAGER_STREAM_PORT:Int
	
	Function ini()
		NETWORK.SERVER_MANAGER_STREAM = New TTCPStream
		If Not NETWORK.SERVER_MANAGER_STREAM.Init() Then Throw("Can't create socket")
		If Not NETWORK.SERVER_MANAGER_STREAM.SetLocalPort(NETWORK.SERVER_MANAGER_STREAM_PORT) Then Throw("Can't set local port ("+NETWORK.SERVER_MANAGER_STREAM_PORT+")")
		If Not NETWORK.SERVER_MANAGER_STREAM.Listen() Then Throw("Can't set to listen")
	End Function
	
	Function render()
		Local new_client:TTCPStream
		
		new_client = NETWORK.SERVER_MANAGER_STREAM.Accept()
		
		If new_client Then
			Print("connected:    "+TNetwork.StringIP(new_client.GetLocalIP())+":"+new_client.GetLocalPort())
			
			'CHAT.addline("$CONNECTED "+TNetwork.StringIP(new_client.GetLocalIP()))
			
			TNET_PLAYER.create(new_client)
			
		EndIf
		
	End Function
End Type


Type TPLAYER
	Global id_count:Int=1
	Global liste:TList
	Global map:TMap
	
	Field id:Int
	Field name:String'!!ohne white-spaces!!
	Field team_id:Int
	
	Field typ:String
	
	Field color_r:Int'vom player geschickt, falls gleiche kann server �ndern
	Field color_g:Int
	Field color_b:Int
	
	Field data_ok:Int=0
	
	Field minerals:Int=100
	
	'Rohstoffe
	'Einheits-beschr�nkung
	'Upgrades
	'bitte beim client zuf�gen!!!
	
	Method init(ix:Int)
		If ix=1 Then
			Self.data_ok=1
		Else
			Self.data_ok=0
		End If
		Self.liste.addlast(Self)
		TPLAYER.id_count:+1
		Self.id=TPLAYER.id_count
		
		Self.map.insert(String(Self.id),Self)
		Self.data_ok=0
		
		Local ok:Int=1
		Local i:Int=0
		Repeat
			i:+1
			If i>100 Then Print "????"
			Self.color_r=Rand(0,2)*120
			Self.color_g=Rand(0,2)*120
			Self.color_b=Rand(0,2)*120
			
			Print Self.color_r+" "+Self.color_g+" "+Self.color_b
			ok=1
			
			For Local p:TPLAYER=EachIn TPLAYER.liste
				If p<>Self Then
					If Self.color_r=p.color_r And Self.color_g=p.color_g And Self.color_b=p.color_b Then
						ok=0
					End If
				End If
			Next
			
		Until ok=1
	End Method
	
	Function get_map:TPLAYER(id:Int)'wichtig f�r viele objekte
		Return TPLAYER(TPLAYER.map.ValueForKey(String(id)))
	End Function
	
	Function render_data_all()
		For Local p:TPLAYER=EachIn TPLAYER.liste
			p.render_data()
		Next
	End Function
	
	Method render_data()
		If Self.data_ok=0 Then'daten checken
			If Self.typ<>"" And Self.name<>"" Then
				Self.data_ok=1
				
				TNET_PLAYER.send_liste()
				
				CHAT.addline("joined the game",Self.id,"[All]")
			End If
		End If
	End Method
	
	
	Method get_data:String(typ:Int=0)
		Local data:String=""
		
		
		Select typ
			Case 0'alles f�r players
				data:+String(Self.id)+":"
				data:+Self.name+":"
				data:+Self.team_id+":"
				
				data:+Self.typ+":"
				
				data:+String(Self.color_r)+":"
				data:+String(Self.color_g)+":"
				data:+String(Self.color_b)
				
				
			Case 1'daten f�r eigener player
				'data:+String(Self.id)+":"
				data:+String(Self.minerals)
				
				'Rohstoffe
				'Einheiten-Beschr�nkungs-Zahl
				'Upgrades
				
			Case 2'daten f�r alle anderen
				data:+String(Self.id)+":"
				
				'eigentlich nix...
		End Select
		
		Return data
	End Method
	
	Function get_server_player()
		Local p:TPLAYER=(New TPLAYER)
		p.id=1
		p.data_ok=1
		p.name="[SERVER]"
		p.team_id=-1
		
		p.typ="server"
		
		p.color_r=240
		p.color_g=240
		p.color_b=240
		
		Self.liste.addlast(p)
		
		Self.map.insert(String(p.id),p)
	End Function
End Type


Type TNET_PLAYER Extends TPLAYER
	Field TCP_STREAM:TTCPStream
	Field IP:Int
	
	Field UDP_STREAM_IN:TUDPStream
	Field UDP_STREAM_IN_PORT:Int
	Field UDP_STREAM_IN_OK:Int=0
	
	Field UDP_STREAM_OUT:TUDPStream
	Field UDP_STREAM_OUT_PORT:Int
	Field UDP_STREAM_OUT_OK:Int=0
	
	Function send_liste()
		Local data:String=""
		
		For Local p:TPLAYER=EachIn TPLAYER.liste
			data:+" "+p.get_data(0)
		Next
		
		Print data
		
		For Local p:TNET_PLAYER=EachIn TPLAYER.liste
			p.TCP_STREAM.WriteLine("NPL"+data)
			While p.TCP_STREAM.SendMsg() ; Wend
		Next
		
	End Function
	
	Method INI_UDP_IN()
		'Print "ini udp in"
		Self.UDP_STREAM_IN = New TUDPStream
		If Not Self.UDP_STREAM_IN.Init() Then Throw("Can't create socket")
		
		Self.UDP_STREAM_IN.SetLocalPort(0)
		
		Self.UDP_STREAM_IN_PORT=Self.UDP_STREAM_IN.GetLocalPort()
		
		'Dem Player den UDP-PORT senden
		
		Self.TCP_STREAM.WriteLine("UPI "+Self.UDP_STREAM_IN_PORT)
		While Self.TCP_STREAM.SendMsg() ; Wend
		
		
	End Method
	
	
	Function create:TNET_PLAYER(stream:TTCPStream)
		Local p:TNET_PLAYER=(New TNET_PLAYER)
		p.init(0)
		p.TCP_STREAM = stream
		p.IP = p.TCP_STREAM.GetLocalIP()
		
		p.INI_UDP_IN()
		
		p.name=""
		
		p.typ="HUMAN"
		
		p.TCP_STREAM.WriteLine("MAP "+TMAPS.map_name)
		'While p.TCP_STREAM.SendMsg() ; Wend
		
		p.TCP_STREAM.WriteLine("YPI "+String(p.id))'p.id
		While p.TCP_STREAM.SendMsg() ; Wend
		
		Return p
	End Function
	
	Method kill()
		Local p:TPLAYER=New TPLAYER
		p.data_ok=1
		
		p.name=Self.name
		p.team_id=Self.team_id
		
		p.typ=Self.typ
		
		p.color_r=Self.color_r
		p.color_g=Self.color_g
		p.color_b=Self.color_b
		
		p.id=Self.id
		
		p.minerals=Self.minerals
		
		Self.liste.remove(Self)
		Self.map.remove(String(p.id))
		
		p.liste.addlast(p)
		p.map.insert(String(p.id),p)
	End Method
	
	Method render()
		Self.render_TCP()
		Self.render_empfang_UDP()
		Self.render_send_UDP()
	End Method
	
	Method render_TCP()
		
		
		If Self.TCP_STREAM.GetState() <> 1 Then
			'CHAT.addline("$DISCONNECT "+TNetwork.StringIP(Self.TCP_STREAM.GetLocalIP()))
			Print("disconnected: "+TNetwork.StringIP(Self.TCP_STREAM.GetLocalIP())+":"+Self.TCP_STREAM.GetLocalPort())
			Self.TCP_STREAM.Close()
			
			
			'allen mitteilen dass er gegangen!!!
			Rem
			For Local p:TPLAYER= EachIn TPLAYER.liste
				If p<>Self.player Then
					p.netz.TCP_STREAM.WriteLine("PIO "+Self.player.id)
					While p.netz.TCP_STREAM.SendMsg() ; Wend
				End If
			Next
			End Rem
			
			'verarbeiten, dass gegangen - KI oder tot?
			
			Self.kill()
			
			CHAT.addline("left the game",Self.id,"[All]")
			Print "player ist gegangen !!!!!!!!!!! allen mitteilen !!!!!"
		EndIf
		
		If Self.TCP_STREAM.RecvAvail() Then
			
			While Self.TCP_STREAM.RecvMsg() ; Wend
			
			If Self.TCP_STREAM.Size() > 0 Then
				
				While Not Self.TCP_STREAM.Eof()
					Local txt:String=Self.TCP_STREAM.ReadLine()
					
					'txt VERARBEITEN!!!!!!!!!!!!!!!!
					'Print "TCP: "+txt
					Self.render_input(txt)
					
				Wend
			EndIf
			
		EndIf
		
	End Method
	
	Method render_empfang_UDP()
		If Self.UDP_STREAM_IN.RecvAvail() Then
			While Self.UDP_STREAM_IN.RecvMsg() ; Wend
			
			If Self.UDP_STREAM_IN.Size() > 0 Then
				While Not Self.UDP_STREAM_IN.Eof()
					Local txt:String=Self.UDP_STREAM_IN.ReadLine()
					
					'txt Verarbeiten !!!!!!!!!!
					'Print "UDP: "+txt
					Self.render_input(txt)
				Wend
			EndIf
		EndIf
	End Method
	
	Method ini_send_UDP:Int(port:Int)
		'Print "ini send udp"
		Self.UDP_STREAM_OUT_OK = 0
		Self.UDP_STREAM_OUT_PORT = port
		
		Self.UDP_STREAM_OUT = New TUDPStream
		
		If Not Self.UDP_STREAM_OUT.Init() Then
			Print "can't create socket."
			Return 0
		End If
		
		Self.UDP_STREAM_OUT.SetRemoteIP(Self.IP)
		Self.UDP_STREAM_OUT.SetRemotePort(Self.UDP_STREAM_OUT_PORT)
		
		Return 1
	End Method
	
	Method render_send_UDP()
		If Self.UDP_STREAM_OUT_OK = 0 Then
			'fragen wo player ist
			
			Self.UDP_STREAM_OUT.WriteLine("UO?")
			Self.UDP_STREAM_OUT.SendMsg()'??? while-wend fehlte ???
			'Print "wo ist player?"
		Else
			'ok
			
			Self.UDP_STREAM_OUT.WriteLine("YPD "+Self.get_data(1))
			Self.UDP_STREAM_OUT.SendMsg()
		End If
	End Method
	
	Method render_input(txt:String)
		Select Lower(Mid(txt,1,3))
			Case "uo?"
				Self.TCP_STREAM.WriteLine("UO!")
				While Self.TCP_STREAM.SendMsg() ; Wend
				
				Self.UDP_STREAM_IN_OK=1
				
				
			Case "uo!"
				Self.UDP_STREAM_OUT_OK=1
				
				
			Case "upi"
				Self.ini_send_UDP(Int(Mid(txt,5,-1)))
			Case "smn"
				Self.name=Mid(txt,5,-1)
			Case "smc"
				Local pos:Int
				
				'Print txt
				txt=Mid(txt,5,-1)
				'Print txt
				
				pos=Instr(txt," ",1)
				Self.color_r=Int(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				pos=Instr(txt," ",1)
				Self.color_g=Int(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				Self.color_b=Int(txt)
				
				'CHAT.addline("color set "+Self.color_r+" "+Self.color_g+" "+Self.color_b)
			Case "rfo"
				
				Local id:Int=Int(Mid(txt,5,-1))
				
				'Print "client fragt nach objekt "+id
				
				If TOBJEKT.get_map(id) Then
					
					If Self.id=TOBJEKT.get_map(id).data.player_id Then
						Self.UDP_STREAM_OUT.WriteLine("SOD 0 "+TOBJEKT.get_map(id).data.get_data(0))
						Self.UDP_STREAM_OUT.SendMsg()
					Else
						Self.UDP_STREAM_OUT.WriteLine("SOD 1 "+TOBJEKT.get_map(id).data.get_data(1))
						Self.UDP_STREAM_OUT.SendMsg()
					End If
					
				Else
					Self.UDP_STREAM_OUT.WriteLine("OID "+String(id))
					Self.UDP_STREAM_OUT.SendMsg()
				End If
			Case "sao"
				
				Local pos:Int
				
				'Print txt
				txt=Mid(txt,5,-1)
				'Print txt
				
				pos=Instr(txt," ",1)
				Local xx:Float=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Local yy:Float=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				Local typ:String=txt
				
				
				TOBJEKT.create(typ, xx, yy, Self.id)
				
			Case "sot"
				Local pos:Int
				txt=Mid(txt,5,-1)
				
				
				pos=Instr(txt," ",1)
				Local id:Int=Int(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Local xx:Float=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Local yy:Float=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				Local rr:Float=Float(txt)
				
				If TOBJEKT.get_map(id) Then
					TOBJ_DATA_LEBEND_UNIT(TOBJEKT.get_map(id).data).actual_command="sot "+xx+" "+yy+" "+rr
				Else
					Print "objekt gibt es nicht!!!"
					
					Self.UDP_STREAM_OUT.WriteLine("OID "+String(id))
					Self.UDP_STREAM_OUT.SendMsg()
					
				End If
			Case "awp"
				Local pos:Int
				txt=Mid(txt,5,-1)
				
				
				pos=Instr(txt," ",1)
				Local id:Int=Int(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Local xx:Float=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Local yy:Float=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				Local rr:Float=Float(txt)
				
				Local o:TOBJEKT=TOBJEKT.get_map(id)
				
				If o Then
					'Print o.data.actual_command
					'o.data.actual_command="sot "+xx+" "+yy+" "+rr
					'waypoint adden
					
					If Lower(Mid(TOBJ_DATA_LEBEND_UNIT(o.data).actual_command, 1, 3))="awp" Then
						TOBJ_DATA_LEBEND_UNIT(o.data).actual_command:+" "+xx+":"+yy+":"+rr
					Else
						TOBJ_DATA_LEBEND_UNIT(o.data).actual_command="awp "+xx+":"+yy+":"+rr
					End If
					'Print o.data.actual_command
					'Print "-"
				Else
					Print "objekt gibt es nicht!!!"
				End If
			Case "atc"
				Local pos:Int
				txt=Mid(txt,5,-1)
				
				
				pos=Instr(txt," ",1)
				Local id:Int=Int(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				Local id_atc:Int=Int(txt)
				
				Print id+" "+id_atc
				
				If TOBJEKT.get_map(id) Then
					TOBJ_DATA_LEBEND_UNIT(TOBJEKT.get_map(id).data).actual_command="atc "+id_atc
					TOBJ_DATA_LEBEND_UNIT(TOBJEKT.get_map(id).data).attack_id=id_atc
				Else
					Print "objekt gibt es nicht!!!"
					
					Self.UDP_STREAM_OUT.WriteLine("OID "+String(id))
					Self.UDP_STREAM_OUT.SendMsg()
					
				End If
			Case "cht"
				
				Local start_txt:String=txt
				
				Local pos:Int
				txt=Mid(txt,5,-1)
				
				pos=Instr(txt," ",1)
				Local id:Int=Int(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Local option:Int=Int(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				Local message:String=txt
				
				If option=1 Then
					CHAT.addline(message,id,"[Team]")
				Else
					CHAT.addline(message,id,"[All]")
				End If
				
				For Local p:TNET_PLAYER=EachIn TPLAYER.liste
					If option=0 Or Self.team_id=p.team_id Then
						p.UDP_STREAM_OUT.WriteLine(start_txt)
						p.UDP_STREAM_OUT.SendMsg()
					End If
				Next
			Case "stp"
				Local id:Int=Int(Mid(txt,5,-1))
				
				If TOBJEKT.get_map(id) Then
					TOBJ_DATA_LEBEND_UNIT(TOBJEKT.get_map(id).data).actual_command=""
				Else
					Print "objekt gibt es nicht!!!"
					
					Self.UDP_STREAM_OUT.WriteLine("OID "+String(id))
					Self.UDP_STREAM_OUT.SendMsg()
					
				End If
			Case "sdm"'send drone mineral
				Local id:Int=Int(Mid(txt,5,-1))
				
				If TOBJEKT.get_map(id) Then
					If TOBJ_DATA_LEBEND_UNIT_DRONE(TOBJEKT.get_map(id).data) Then
						TOBJ_DATA_LEBEND_UNIT_DRONE(TOBJEKT.get_map(id).data).actual_command="sdm"
						Print "mine!!!"
					Else
						Print "ich bin keine drone!!"
					End If
				Else
					Print "objekt gibt es nicht!!!"
					
					Self.UDP_STREAM_OUT.WriteLine("OID "+String(id))
					Self.UDP_STREAM_OUT.SendMsg()
					
				End If
			Default
				Print "unbekannt:"
				Print txt
				Print
		End Select
	End Method
End Type


Type TMAPS
	Global map:TMAPS
	Global map_name:String
	
	Field x:Int
	Field y:Int
	Field felder:TFELD[x,y]
	
	Field tileset_name:String
	
	Function load:TMAPS(path:String)
		Local stream:TStream=ReadFile(path)
		
		Local m:TMAPS=New TMAPS
		
		m.tileset_name=stream.ReadLine()
		
		TFELD.load_tiles(m.tileset_name)
		
		m.x=stream.ReadInt()
		m.y=stream.ReadInt()
		
		m.felder=New TFELD[m.x,m.y]
		
		For Local xx:Int=0 To m.x-1
			For Local yy:Int=0 To m.y-1
				Local number:Int=stream.ReadInt()
				
				For Local f:TFELD=EachIn TFELD.liste
					If f.number=number Then
						m.felder[xx,yy]=f
						Exit
					End If
				Next
			Next
		Next
		
		stream.close()
		Return m
	End Function
End Type

Type TFELD
	Global liste:TList
	Global anzahl:Int=0
	
	Global seite:Int
	
	Field typ:Int
	
	'0=erde
	'braun
	'1=wasser-erde (wechselzone)
	'dunkelblau
	'2=wasser
	'hellblau
	'3=nur luft
	'gr�n
	'4=nix
	'grau
	
	Field number:Int'zum speichern, wie eine ID
	Field image:TImage
	
	Function load_tiles(tileset_name:String)
		TFELD.liste=New TList
		TFELD.anzahl=0
		
		Local stream:TStream=OpenFile("tilesets\"+tileset_name+"\ini.txt")
		
		TFELD.seite=Int(stream.ReadLine())
		
		While Not Eof(stream)
			TFELD.anzahl:+1
			Local f:TFELD=New TFELD
			f.number=Int(stream.ReadLine())
			f.typ=Int(stream.ReadLine())
			f.image=LoadImage("tilesets\"+tileset_name+"\"+stream.ReadLine())
			TFELD.liste.addlast(f)
			
		Wend
		
		stream.close()
	End Function
End Type

Type ANSICHT
	Global x:Float
	Global y:Float
	
	Global screen_x:Int
	Global screen_y:Int
	Global z_speed:Int
	
	Global mx:Int=MouseX()
	Global my:Int=MouseY()
	
	Global md1:Int=MouseDown(1)
	Global md2:Int=MouseDown(2)
	Global mh1:Int=MouseHit(1)
	Global mh2:Int=MouseHit(2)
	
	Function ini(xx:Int=800,yy:Int=600,fullscreen:Int=0)
		ANSICHT.screen_x=xx
		ANSICHT.screen_y=yy
		
		If fullscreen=1 Then
			Graphics xx,yy,32,60
		Else
			Graphics xx,yy
		End If
		
		SetBlend ALPHABLEND
	End Function
	
	Function render()
		ANSICHT.mx=MouseX()
		ANSICHT.my=MouseY()
		
		ANSICHT.md1=MouseDown(1)
		ANSICHT.md2=MouseDown(2)
		ANSICHT.mh1=MouseHit(1)
		ANSICHT.mh2=MouseHit(2)
		ANSICHT.z_speed=MouseZSpeed()
		
		
		If KeyDown(key_up) Then ANSICHT.y:+5
		If KeyDown(key_down) Then ANSICHT.y:-5
		If KeyDown(key_left) Then ANSICHT.x:+5
		If KeyDown(key_right) Then ANSICHT.x:-5
	End Function
	
	Function draw_map()
		If TMAPS.map Then
			For Local xx:Int=0 To TMAPS.map.x-1
				For Local yy:Int=0 To TMAPS.map.y-1
					DrawImage TMAPS.map.felder[xx,yy].image,xx*TFELD.seite+ANSICHT.x,yy*TFELD.seite+ANSICHT.y
				Next
			Next
		End If
	End Function
	
	Function draw_mini_map(x:Int,y:Int,dx:Int,dy:Int)
		
		If TMAPS.map Then
			
			For Local xx:Int=0 To TMAPS.map.x-1
				For Local yy:Int=0 To TMAPS.map.y-1
					
					Select TMAPS.map.felder[xx,yy].typ
						Case 0'erde
							SetColor 100,50,50
						Case 1'wasser-erde
							SetColor 50,50,200
						Case 2'wasser
							SetColor 20,30,70
						Case 3'nur luft
							SetColor 0,100,0
						Case 4'nix
							SetColor 50,50,50
						Default
							SetColor 255,0,0
					End Select
					
					DrawRect xx+x,yy+y,1,1
				Next
			Next
			
		End If
		
		SetColor 255,255,255
	End Function
End Type

Rem
Type TKEY_INPUT
	Global chat:Int=0'1= chat an tippen; 0=hotkeys an
	Global chat_txt:String
	
	Function render()
		
		If TKEY_INPUT.chat=1 Then
			If KeyHit(key_enter) Then
				TKEY_INPUT.chat=0
			End If
			
			
		Else
			If KeyHit(key_enter) Then
				TKEY_INPUT.chat=1
			End If
			
			
		End If
		
	End Function
	
End Type
End Rem


Type TKEY_INPUT
	Global chat_on:Int=0'1= chat an tippen; 0=hotkeys an
	Global chat_txt:String
	
	Function render()
		
		If TKEY_INPUT.chat_on=1 Then
			If KeyHit(key_enter) Then
				TKEY_INPUT.chat_on=0
				FlushKeys()
				
				If TKEY_INPUT.chat_txt<>"" And TKEY_INPUT.chat_txt<>"#" Then
					CHAT.posteline(TKEY_INPUT.chat_txt)
				End If
				
				TKEY_INPUT.chat_txt=""
			Else
				Local gc:Int=GetChar()
				
				
				Select True
					Case gc=8'return
						If TKEY_INPUT.chat_txt="" Then
						Else
							TKEY_INPUT.chat_txt=Mid(TKEY_INPUT.chat_txt,1,Len(TKEY_INPUT.chat_txt)-1)
						End If
					Case gc>31'zeichen
						TKEY_INPUT.chat_txt:+Chr(gc)
				End Select
				
			End If
		Else
			If KeyHit(key_enter) Then
				TKEY_INPUT.chat_on=1
				FlushKeys()
			End If
		End If
		
	End Function
	
End Type


Type CHAT
	Global anz_lines:Int=10
	Global lines:String[anz_lines]
	Global time:Int[anz_lines]
	Global from_player:TPLAYER[anz_lines]
	Global to_obtion:String[anz_lines]'"[All]" oder "[Team]"
	
	Function posteline(txt:String)
		CHAT.addline(txt, 1,"[All]")
		
		For Local p:TNET_PLAYER=EachIn TPLAYER.liste
			p.UDP_STREAM_OUT.WriteLine("CHT 1 0 "+txt)
			p.UDP_STREAM_OUT.SendMsg()
		Next
	End Function
	
	Function addline(txt:String, from_id:Int, to_obtion:String)
		For Local i:Int=0 To CHAT.anz_lines-2
			CHAT.lines[i]=CHAT.lines[i+1]
			CHAT.time[i]=CHAT.time[i+1]
			CHAT.to_obtion[i]=CHAT.to_obtion[i+1]
			CHAT.from_player[i]=CHAT.from_player[i+1]
		Next
		
		CHAT.lines[CHAT.anz_lines-1]=txt
		
		CHAT.to_obtion[CHAT.anz_lines-1]=to_obtion
		
		CHAT.from_player[CHAT.anz_lines-1]=TPLAYER.get_map(from_id)'kann auch null sein!
		
		CHAT.time[CHAT.anz_lines-1]=MilliSecs()
	End Function
	
	Function draw(x:Int,y:Int)
		If TKEY_INPUT.chat_on=1 Then
			SetColor 0,0,0
			SetAlpha 0.6
			DrawRect x,y,400,20*CHAT.anz_lines
			
			
			
			SetColor 255,255,255
			SetAlpha 0.3
			DrawRect x,y+205,400,20
			SetColor 0,0,0
			SetAlpha 0.5
			DrawRect x+1,y+205+1,400-2,20-2
			SetAlpha 1.0
			SetColor 255,255,255
			DrawText TKEY_INPUT.chat_txt, x+3,y+3+205
		End If
		
		SetColor 255,255,255
		SetAlpha 1
		For Local i:Int=0 To CHAT.anz_lines-1
			If CHAT.lines[i]<>"" Then
				If TKEY_INPUT.chat_on=0 Then
					If (MilliSecs()-CHAT.time[i])<1000*30 Then
						
						SetColor 255,255,255
						DrawText CHAT.to_obtion[i],x+2,y+i*20+2
						
						If CHAT.from_player[i] Then
							SetColor CHAT.from_player[i].color_r,CHAT.from_player[i].color_g,CHAT.from_player[i].color_b
							DrawText CHAT.from_player[i].name,x+4+TextWidth(CHAT.to_obtion[i]),y+i*20+2
							
							SetColor 255,255,255
							DrawText CHAT.lines[i],x+8+TextWidth(CHAT.to_obtion[i]+CHAT.from_player[i].name),y+i*20+2
						Else
							SetColor 255,255,255
							DrawText "[?]",x+4+TextWidth(CHAT.to_obtion[i]),y+i*20+2
							
							DrawText CHAT.lines[i],x+8+TextWidth(CHAT.to_obtion[i]+"[?]"),y+i*20+2
						End If
						
					End If
				Else
					
					SetColor 255,255,255
					DrawText CHAT.to_obtion[i],x+2,y+i*20+2
					
					If CHAT.from_player[i] Then
						SetColor CHAT.from_player[i].color_r,CHAT.from_player[i].color_g,CHAT.from_player[i].color_b
						DrawText CHAT.from_player[i].name,x+4+TextWidth(CHAT.to_obtion[i]),y+i*20+2
						
						SetColor 255,255,255
						DrawText CHAT.lines[i],x+8+TextWidth(CHAT.to_obtion[i]+CHAT.from_player[i].name),y+i*20+2
					Else
						SetColor 255,255,255
						DrawText "[?]",x+4+TextWidth(CHAT.to_obtion[i]),y+i*20+2
						
						DrawText CHAT.lines[i],x+8+TextWidth(CHAT.to_obtion[i]+"[?]"),y+i*20+2
					End If
					
				End If
			End If
		Next
		
		SetAlpha 1
	End Function
	
End Type

Rem
Type CHAT
	Global anz_lines:Int=10
	Global lines:String[anz_lines]
	Global time:Int[anz_lines]
	Global from_player:TPLAYER[anz_lines]
	Global to_obtion:String[anz_lines]'"[All]" oder "[Team]"
	
	
	
	Function addline(txt:String, from_id:Int, to_obtion:String)
		For Local i:Int=0 To CHAT.anz_lines-2
			CHAT.lines[i]=CHAT.lines[i+1]
			CHAT.time[i]=CHAT.time[i+1]
			CHAT.to_obtion[i]=CHAT.to_obtion[i+1]
			CHAT.from_player[i]=CHAT.from_player[i+1]
		Next
		
		CHAT.lines[CHAT.anz_lines-1]=txt
		
		CHAT.to_obtion[CHAT.anz_lines-1]=to_obtion
		
		CHAT.from_player[CHAT.anz_lines-1]=TPLAYER.get_map(from_id)'kann auch null sein!
		
		CHAT.time[CHAT.anz_lines-1]=MilliSecs()
	End Function
	
	Function draw(x:Int,y:Int)
		If TKEY_INPUT.chat=1 Then
			SetColor 0,0,0
			SetAlpha 0.6
			DrawRect x,y,400,20*CHAT.anz_lines
		End If
		
		SetColor 255,255,255
		SetAlpha 1
		For Local i:Int=0 To CHAT.anz_lines-1
			If CHAT.lines[i]<>"" Then
				If TKEY_INPUT.chat=0 Then
					If (MilliSecs()-CHAT.time[i])<1000*30 Then
						
						SetColor 255,255,255
						DrawText CHAT.to_obtion[i],x+2,y+i*20+2
						
						If CHAT.from_player[i] Then
							SetColor CHAT.from_player[i].color_r,CHAT.from_player[i].color_g,CHAT.from_player[i].color_b
							DrawText CHAT.from_player[i].name,x+4+TextWidth(CHAT.to_obtion[i]),y+i*20+2
							
							SetColor 255,255,255
							DrawText CHAT.lines[i],x+8+TextWidth(CHAT.to_obtion[i]+CHAT.from_player[i].name),y+i*20+2
						Else
							SetColor 255,255,255
							DrawText "[?]",x+4+TextWidth(CHAT.to_obtion[i]),y+i*20+2
							
							DrawText CHAT.lines[i],x+8+TextWidth(CHAT.to_obtion[i]+"[?]"),y+i*20+2
						End If
						
					End If
				Else
					
					SetColor 255,255,255
					DrawText CHAT.to_obtion[i],x+2,y+i*20+2
					
					If CHAT.from_player[i] Then
						SetColor CHAT.from_player[i].color_r,CHAT.from_player[i].color_g,CHAT.from_player[i].color_b
						DrawText CHAT.from_player[i].name,x+4+TextWidth(CHAT.to_obtion[i]),y+i*20+2
						
						SetColor 255,255,255
						DrawText CHAT.lines[i],x+8+TextWidth(CHAT.to_obtion[i]+CHAT.from_player[i].name),y+i*20+2
					Else
						SetColor 255,255,255
						DrawText "[?]",x+4+TextWidth(CHAT.to_obtion[i]),y+i*20+2
						
						DrawText CHAT.lines[i],x+8+TextWidth(CHAT.to_obtion[i]+"[?]"),y+i*20+2
					End If
					
				End If
			End If
		Next
		
		SetAlpha 1
	End Function
End Type
End Rem

Type FPS
	Global count:Int
	Global last_count:Int
	Global last_change:Int 'millisecs
	
	Function render()
		If (FPS.last_change + 1000) <=MilliSecs() Then
			FPS.last_change=MilliSecs()
			FPS.last_count=FPS.count
			FPS.count=1
		Else
			FPS.count:+1
		End If
	End Function
End Type

'### START ###
TPLAYER.liste=New TList
TPLAYER.map=New TMap
TOBJEKT.liste=New TList
TOBJEKT.map=New TMap

NETWORK.SERVER_MANAGER_STREAM_PORT=40000
NETWORK.ini()

TMAPS.map_name="4.map"

TMAPS.map=TMAPS.load("maps\"+TMAPS.map_name)

ANSICHT.ini(800,600,0)




'LISTE MIT INI
TOBJ_DATA_LEBEND_STONE.ini()
TOBJ_DATA_LEBEND_UNIT_SOLDIER.ini()
TOBJ_DATA_LEBEND_UNIT.ini()
TOBJ_DATA_LEBEND_UNIT_AMEISE.ini()
TOBJ_DATA_MINERALS.ini()
TOBJ_DATA_LEBEND_UNIT_DRONE.ini()
TOBJ_DATA_LEBEND_UNIT_BASE.ini()
'ENDE DER LISTE

TPLAYER.get_server_player()

'### HAUPTSCHLEIFE ###
Local i:Int=0

Repeat
	Cls
	TKEY_INPUT.render()
	NETWORK.render()
	TPLAYER.render_data_all()
	
	ANSICHT.render()
	
	TOBJEKT.render_all()
	TOBJEKT.render_collision()
	
	ANSICHT.draw_map()
	TOBJEKT.draw_all()
	
	SetColor 50,50,50
	DrawRect 0,0,200,ANSICHT.screen_y
	SetColor 200,200,200
	DrawRect 198,0,2,ANSICHT.screen_y
	
	If ANSICHT.mx<200 And ANSICHT.my<23 Then
		SetColor 255,100,0
		If ANSICHT.mh1 Then
			SetColor 255,255,0
			Print "send player list"
			TNET_PLAYER.send_liste()
		End If
	Else
		SetColor 20,20,20
	End If
	
	DrawRect 0,0,200,22
	
	SetColor 255,255,255
	DrawText "TNET_PLAYERS:",1,1
	DrawRect 1,22,190,1
	
	i=30
	For Local p:TNET_PLAYER=EachIn TPLAYER.liste'eigentlich nicht TNET_PLAYER wenn auch KI's
		p.render()
		
		SetColor 255,255,255
		DrawText p.name+" ("+p.id+") "+p.typ,1,i
		DrawText TNetwork.StringIP(p.IP),1,i+20
		
		If p.UDP_STREAM_IN_OK=1 Then
			SetColor 0,100,0
			DrawRect 1,i+40,30,20
			SetColor 0,255,0
			DrawText "IN", 3,i+42
		Else
			SetColor 100,0,0
			DrawRect 1,i+40,30,20
			SetColor 255,0,0
			DrawText "IN", 3,i+42
		End If
		
		If p.UDP_STREAM_OUT_OK=1 Then
			SetColor 0,100,0
			DrawRect 41,i+40,30,20
			SetColor 0,255,0
			DrawText "OUT", 43,i+42
		Else
			SetColor 100,0,0
			DrawRect 41,i+40,30,20
			SetColor 255,0,0
			DrawText "OUT", 43,i+42
		End If
		
		SetColor p.color_r,p.color_g,p.color_b
		DrawRect 81,i+40,30,20
		SetColor 120,120,120
		DrawText p.team_id, 83,i+42
		
		If (ANSICHT.mx>80 And ANSICHT.mx<110 And ANSICHT.my>i+40 And ANSICHT.my<i+60) Then
			p.team_id:+ANSICHT.z_speed
		End If
		
		'p.UDP_STREAM_IN_OK+", out="+p.UDP_STREAM_OUT_OK,1,i*20
		SetColor 255,255,255
		
		DrawRect 1,i+68,190,1
		
		
		
		i:+70
	Next
	
	'ANSICHT.draw_mini_map(10,ANSICHT.screen_y-50,50,50)
	
	
	CHAT.draw(220,ANSICHT.screen_y-230)
	
	TOBJEKT.render_send_all()
	
	FPS.render()
	DrawText FPS.last_count,200,0
	
	Flip
Until KeyHit(key_escape)