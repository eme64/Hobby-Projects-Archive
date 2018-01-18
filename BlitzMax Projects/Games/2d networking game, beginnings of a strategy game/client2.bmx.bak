SuperStrict

Framework Vertex.BNetEx
Import BRL.LinkedList
Import BRL.Max2D
'Import BRL.GLGraphics
Import BRL.PNGLoader
'Import BRL.DXGraphics
'Import BRL.D3D7Max2D
Import BRL.D3D9Max2D

Import BRL.StandardIO
Import BRL.Socket
Import BRL.Retro
Import BRL.Map
Import BRL.Audio
Import BRL.WAVLoader

Import BRL.DirectSoundAudio
'Import BRL.FreeAudioAudio
'Import BRL.OpenALAudio
'Import PUB.FreeAudio
'Import BRL.AudioSample
'Import BRL.Stream
'Import PUB.StdC

SeedRnd MilliSecs()

'#########################################################################
'##########  TOBJEKT  ####################################################
'#########################################################################

Type TOBJEKT' fehlerquelle: selectierte objekte sind zusätzlich gespeichert!!!
	Global liste:TList
	Global map:TMap
	
	Global actual_selected:TOBJ_DATA
	
	'FIELD
	Field id:Int
	
	Field typ:String
	
	Field data:TOBJ_DATA
	
	Field last_update:Int'millisecs
	Field max_delay:Int=500
	
	Method kill()
		Self.data.kill()'für animationen
		TOBJEKT.liste.remove(Self)
		TOBJEKT.map.remove(String(Self.data.id))
		
		Self.data=Null'unnötig
		If ANSICHT.actual_selected_objects.Contains(Self) Then
			ANSICHT.actual_selected_objects.remove(Self)
			
		End If
	End Method
	
	'FUNCTION
	Function get_map:TOBJEKT(id:Int)'wichtig für viele objekte
		Return TOBJEKT(TOBJEKT.map.ValueForKey(String(id)))
	End Function
	
	
	Function create:TOBJEKT(data_typ:Int, id:Int, new_data:String)
		
		Local o:TOBJEKT=TOBJEKT.get_map(id)
		
		If o Then'checken ob es den schon gibt!!!
			Return o
		Else
			o=New TOBJEKT
		End If
		
		o.last_update=MilliSecs()
		
		TOBJEKT.liste.addlast(o)
		
		o.id=id
		TOBJEKT.map.insert(String(o.id),o)
		
		'DATA initialisieren
		
		Local pos:Int=Instr(new_data, " ",1)
		
		Local typ:String=Mid(new_data, 1, pos-1)
		
		Local rest_data:String=Mid(new_data, pos+1, -1)
		
		Select Lower(typ)
			Case "soldier"
				
				o.data=TOBJ_DATA_LEBEND_UNIT_SOLDIER.create(data_typ, rest_data)
				o.data.id=o.id
				
				'o.data.sichtweite=300.0'je nach upgrade, ist ja nur für eigene units
				'o.data.sichtweite_radar=300.0
				
			Case "stone"
				o.data=TOBJ_DATA_LEBEND_STONE.create(data_typ, rest_data)
				o.data.id=o.id
			Case "ameise"
				o.data=TOBJ_DATA_LEBEND_UNIT_AMEISE.create(data_typ, rest_data)
				o.data.id=o.id
			Case "drone"
				o.data=TOBJ_DATA_LEBEND_UNIT_DRONE.create(data_typ, rest_data)
				o.data.id=o.id
			Case "mineral"
				o.data=TOBJ_DATA_MINERALS.create(data_typ, rest_data)
				o.data.id=o.id
			Case "base"
				o.data=TOBJ_DATA_LEBEND_UNIT_BASE.create(data_typ, rest_data)
				o.data.id=o.id
			Default
		End Select
		
		Return o
	End Function
	
	
	Function render_input(typ:Int, id:Int, data:String)
		
		
		Select typ
			Case 0'create-all data
				TOBJEKT.create(0, id, data)
				
			Case 1'create-other players
				TOBJEKT.create(1, id, data)
				
			Case 2'new-data all data
				Local o:TOBJEKT=TOBJEKT.get_map(id)
				
				If o Then
					o.data.set(2, data)
					
					o.last_update=MilliSecs()
				Else
					NETWORK.UDP_STREAM_OUT.WriteLine("rfo "+String(id))
					NETWORK.UDP_STREAM_OUT.SendMsg()
				End If
				
			Case 3'new-data other players
				
				Local o:TOBJEKT=TOBJEKT.get_map(id)
				
				If o Then
					o.data.set(3, data)
					
					o.last_update=MilliSecs()
				Else
					NETWORK.UDP_STREAM_OUT.WriteLine("rfo "+String(id))
					NETWORK.UDP_STREAM_OUT.SendMsg()
				End If
				
			Default
				Print "???"
		End Select
	End Function
	
	
	Function render_all()
		For Local o:TOBJEKT=EachIn TOBJEKT.liste
			o.data.render()
			If o.last_update+o.max_delay<MilliSecs() Then
				NETWORK.UDP_STREAM_OUT.WriteLine("rfo "+String(o.id))
				NETWORK.UDP_STREAM_OUT.SendMsg()
			End If
		Next
	End Function
	
	Function draw_all()
		
		TANIM.render_draw_all(1)
		
		For Local o:TOBJEKT=EachIn ANSICHT.actual_selected_objects'selectete objekte über eigene liste select-zeichnen!!!
			o.data.draw(1,1)
		Next
		
		For Local o:TOBJEKT=EachIn TOBJEKT.liste
			o.data.draw(2,0)
		Next
		
		For Local o:TOBJEKT=EachIn TOBJEKT.liste
			o.data.draw(3,0)
		Next
		
		TANIM.render_draw_all(2)
		
		For Local o:TOBJEKT=EachIn TOBJEKT.liste
			o.data.draw(4,0)
		Next
		
		TANIM.render_draw_all(3)
		
	End Function
End Type

'#########################################################################
'##########  TOBJ_DATA  ##################################################
'#########################################################################

Type TOBJ_DATA'# 1 #
	Field id:Int
	Field player_id:Int'wenn 0 oder darunter, dann keinem player
	
	Field x:Float
	Field y:Float
	Field z:Int'Field collision_group:Int'COLLISION
	'1=underground
	'2=ground
	'3=air
	
	Field w:Float
	Field r:Float
	
	Field sichtweite:Float
	Field sichtweite_radar:Float
	
	
	Function create:TOBJ_DATA(daten_typ:Int, new_data:String) Abstract
	
	Method set(daten_typ:Int, txt:String) Abstract
	
	Method render() Abstract'minimum selektieren
	
	Method draw(schritt:Int, selected:Int) Abstract
	
	Method kill() Abstract'um zb blut zeichnen, objekt muss nicht empfernt werden
End Type


'#########################################################################
'##########  TOBJ_DATA_MINERALS  #########################################
'#########################################################################

Type TOBJ_DATA_MINERALS Extends TOBJ_DATA'# 2 #
	Field material_start:Float
	Field material_left:Float
	
	Function create:TOBJ_DATA(daten_typ:Int, new_data:String)
		
		Local od:TOBJ_DATA_MINERALS=New TOBJ_DATA_MINERALS
		
		od.player_id=1
		
		Select daten_typ
			Case 0
				
				Local pos:Int
				
				
				Local txt:String=new_data
				
				pos=Instr(txt," ",1)
				od.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.w=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.r=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.material_start=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				od.material_left=Float(txt)
				
			Case 1
				
				Local pos:Int
				
				
				Local txt:String=new_data
				
				
				pos=Instr(txt," ",1)
				od.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.w=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.r=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.material_start=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				od.material_left=Float(txt)
				
			Default
				Print "????"
		End Select
		
		Return od
	End Function
	
	
	Method set(daten_typ:Int, txt:String)'daten updaten
		Select daten_typ
			Case 2
				Self.material_left=Float(txt)
				
			Case 3
				
				Self.material_left=Float(txt)
				
			Default
				Print "????"
		End Select
	End Method
	
	Method render()
	End Method
	
	Method draw(schritt:Int, selected:Int)
		
		'ist das objekt überhaupt in sichtweite?
		
		
		If Self.x+ANSICHT.x>100 And Self.y+ANSICHT.y>-100 And Self.x+ANSICHT.x<ANSICHT.screen_x+100 And Self.y+ANSICHT.y<ANSICHT.screen_y+100 Then			
			
			Select TMAPS.map.fog_of_war[Self.x/TFELD.seite,Self.y/TFELD.seite]
				Case 0
					Return
				Case 1
					Return
				Case 2
					SetColor 150,150,150
				Case 3
					SetColor 255,255,255
			End Select
			
			
			Select schritt
				Case 1'selecten
					
					
				Case 2'farbe der einheit
					
					
				Case 3'einheit bild
					
					'SetColor 255,255,255
					
					SetScale 2*Self.r/40.0,2*Self.r/40.0
					DrawImage TOBJ_DATA_MINERALS.image_mineral,Self.x+ANSICHT.x,Self.y+ANSICHT.y
					SetScale 1,1
					
					
				Case 4'leben, ...
					'durch anderes bild bei einheit bild
			End Select
		End If
	End Method
	
	Method kill()
		'TANIM_BLEND.create((New TANIM_BLEND_BLUT),Self.x, Self.y, 1, Rand(1,360), 255, 255, 255)
	End Method
	
	Function ini()
		TOBJ_DATA_MINERALS.image_mineral=LoadImage("creatures\mineral.png")
		MidHandleImage TOBJ_DATA_MINERALS.image_mineral
	End Function
	
	Global image_mineral:TImage
	
End Type


'#########################################################################
'##########  TOBJ_DATA_FORCEFIELD  #######################################
'#########################################################################

Type TOBJ_DATA_FORCEFIELD Extends TOBJ_DATA'# 2 #
	Field time:Int'millisecs
	
	Function create:TOBJ_DATA(daten_typ:Int, new_data:String) Abstract
	Method set(daten_typ:Int, txt:String) Abstract
	Method render() Abstract
	Method draw(schritt:Int, selected:Int) Abstract
End Type

'#########################################################################
'##########  TOBJ_DATA_LEBEND  ###########################################
'#########################################################################

Type TOBJ_DATA_LEBEND Extends TOBJ_DATA'# 2 #
	Field leben:Float
	Field leben_max:Float
	
	Function create:TOBJ_DATA(daten_typ:Int, new_data:String) Abstract
	Method set(daten_typ:Int, txt:String) Abstract
	Method render() Abstract
	Method draw(schritt:Int, selected:Int) Abstract
End Type


'#########################################################################
'##########  TOBJ_DATA_LEBEND_UNIT  ######################################
'#########################################################################

Type TOBJ_DATA_LEBEND_UNIT Extends TOBJ_DATA_LEBEND'# 3 #
	
	Function create:TOBJ_DATA(daten_typ:Int, new_data:String) Abstract
	Method set(daten_typ:Int, txt:String) Abstract
	Method render() Abstract
	Method draw(schritt:Int, selected:Int) Abstract
	Field mini_x:Int
	Field mini_y:Int
	Method draw_mini(x:Int,y:Int) Abstract
	Method draw_maxi(x:Int,y:Int) Abstract
	
	Method klicked_on_mini:Int(x:Int,y:Int)
		Return (ANSICHT.mx>x+Self.mini_x And ANSICHT.mx<x+Self.mini_x+30 And ANSICHT.my>y+Self.mini_y And ANSICHT.my<y+Self.mini_y+30)
	End Method
	
	Field mini_typ:Int'1=soldier, 2=ameise
	
	Function ini()
		TOBJ_DATA_LEBEND_UNIT.image_ring=LoadImage("creatures\ring.png")
		MidHandleImage TOBJ_DATA_LEBEND_UNIT.image_ring
		
		TOBJ_DATA_LEBEND_UNIT.image_warn=LoadImage("creatures\!.png")
		MidHandleImage TOBJ_DATA_LEBEND_UNIT.image_warn
	End Function
	
	Global image_ring:TImage
	Global image_warn:TImage
End Type





'#########################################################################
'##########  TOBJ_DATA_LEBEND_STONE  #####################################
'#########################################################################

Type TOBJ_DATA_LEBEND_STONE Extends TOBJ_DATA_LEBEND'# 3 #
	
	
	Function create:TOBJ_DATA(daten_typ:Int, new_data:String)
		
		Local od:TOBJ_DATA_LEBEND_STONE=New TOBJ_DATA_LEBEND_STONE
		
		od.player_id=1
		Select daten_typ
			Case 0
				
				Local pos:Int
				
				
				Local txt:String=new_data
				
				
				pos=Instr(txt," ",1)
				od.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.leben_max=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				od.leben=Float(txt)
				
			Case 1
				
				Local pos:Int
				
				
				Local txt:String=new_data
				
				
				pos=Instr(txt," ",1)
				od.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.r=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.leben_max=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				od.leben=Float(txt)
				
			Default
				Print "????"
		End Select
		
		
		Return od
	End Function
	
	
	Method set(daten_typ:Int, txt:String)'daten updaten
		Select daten_typ
			Case 2
				Self.leben=Float(txt)
				
			Case 3
				
				Self.leben=Float(txt)
				
			Default
				Print "????"
		End Select
	End Method
	
	Method render()
	End Method
	
	Method draw(schritt:Int, selected:Int)
		
		'ist das objekt überhaupt in sichtweite?
		
		If Self.x+ANSICHT.x>100 And Self.y+ANSICHT.y>-100 And Self.x+ANSICHT.x<ANSICHT.screen_x+100 And Self.y+ANSICHT.y<ANSICHT.screen_y+100 Then			
			
			Select TMAPS.map.fog_of_war[Self.x/TFELD.seite,Self.y/TFELD.seite]
				Case 0
					Return
				Case 1
					Return
				Case 2
					'markieren
					
					If schritt=3 Then
						SetColor 255,255,255
						SetAlpha 0.7
						DrawImage TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_warn,Self.x+ANSICHT.x,Self.y+ANSICHT.y
						SetAlpha 1.0
					End If
					
					Return
				Case 3
					'weitermachen
			End Select
			
			
			Select schritt
				Case 1'selecten
					
					
				Case 2'farbe der einheit
					
					SetColor 255,150,0
					
					SetScale 2*Self.r/100.0,2*Self.r/100.0
					DrawImage TOBJ_DATA_LEBEND_UNIT.image_ring,Self.x+ANSICHT.x,Self.y+ANSICHT.y
					SetScale 1,1
					
				Case 3'einheit bild
					
					SetColor 255,255,255
					SetScale 2*Self.r/100.0,2*Self.r/100.0
					DrawImage TOBJ_DATA_LEBEND_STONE.image_stein,Self.x+ANSICHT.x,Self.y+ANSICHT.y
					SetScale 1,1
					
				Case 4'leben, ...
					SetAlpha 0.3
					SetColor 0,0,0
					DrawRect Self.x+ANSICHT.x-26,Self.y+ANSICHT.y-Self.r-6,52,5
					SetAlpha 0.7
					SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
					DrawRect Self.x+ANSICHT.x-25,Self.y+ANSICHT.y-Self.r-5,50.0*Self.leben/Self.leben_max,4
					SetAlpha 1
			End Select
		End If
	End Method
	
	Method kill()
		'TANIM_BLEND.create((New TANIM_BLEND_BLUT),Self.x, Self.y, 1, Rand(1,360), 255, 255, 255)
	End Method
	
		
	Function ini()
		TOBJ_DATA_LEBEND_STONE.image_stein=LoadImage("creatures\stein.png")
		MidHandleImage TOBJ_DATA_LEBEND_STONE.image_stein
	End Function
	
	Global image_stein:TImage
End Type


'#########################################################################
'##########  TOBJ_DATA_LEBEND_UNIT_SOLDIER  ##############################
'#########################################################################

Type TOBJ_DATA_LEBEND_UNIT_SOLDIER Extends TOBJ_DATA_LEBEND_UNIT
	
	Field leben:Float
	
	Field waypoint_list:TList
	Field waypoint_string:String
	
	Field attacking_id:Int
	Field schuss:Int
	
	
	
	Function create:TOBJ_DATA(daten_typ:Int, new_data:String)
		
		Local od:TOBJ_DATA_LEBEND_UNIT_SOLDIER=New TOBJ_DATA_LEBEND_UNIT_SOLDIER
		
		
		Select daten_typ
			Case 0
				
				Local pos:Int
				
				
				Local txt:String=new_data
				
				
				pos=Instr(txt," ",1)
				od.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.w=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.r=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				pos=Instr(txt," ",1)
				od.sichtweite=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.sichtweite_radar=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				pos=Instr(txt," ",1)
				od.leben=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.leben_max=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				od.player_id=Int(txt)
				
			Case 1
				
				Local pos:Int
				
				
				Local txt:String=new_data
				
				
				pos=Instr(txt," ",1)
				od.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.w=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.r=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				pos=Instr(txt," ",1)
				od.sichtweite=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.sichtweite_radar=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				
				pos=Instr(txt," ",1)
				od.leben=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.leben_max=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				od.player_id=Int(txt)
				
			Default
				Print "????"
		End Select
		
		od.mini_typ=1
		
		Return od
	End Function
	
	Method render()
	End Method
	
	Method set(daten_typ:Int, txt:String)'daten updaten
		Select daten_typ
			Case 2
				
				Local pos:Int
				
				pos=Instr(txt," ",1)
				Self.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.w=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				
				pos=Instr(txt," ",1)
				Self.leben=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.attacking_id=Int(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				'schuss
				pos=Instr(txt," ",1)
				Self.schuss=Int(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				pos=Instr(txt," ",1)
				Local bef:String=Mid(txt,1,pos-1)
				
				
				Select Lower(bef)
					Case "non"
						If Self.waypoint_list Then
							Self.waypoint_list=Null
							
						End If
					Case "awp"
						If Self.waypoint_string=txt Then
							'nix machen, da gleich wie sonst
							
						Else
							
							
							Self.waypoint_string=txt
							
							Self.waypoint_list=New TList
							
							Local data:String=Mid(txt,pos+1,-1)
							
							Repeat
								Local posit:Int=Instr(data," ",1)
								Local act_data:String
								
								If posit=0 Then
									act_data=data
									data=""
								Else
									act_data=Mid(data,1,posit-1)
									data=Mid(data,posit+1,-1)
								End If
								
								Local pos1:Int=Instr(act_data, ":", 1)
								Local pos2:Int=Instr(act_data, ":", pos1+1)
								Local xx:Float=Float(Mid(act_data, 1, pos1-1))
								Local yy:Float=Float(Mid(act_data, pos1+1, pos2-1))
								Local rr:Float=Float(Mid(act_data, pos2+1, -1))
								
								Self.waypoint_list.addlast(TWAYPOINT.create(xx,yy))
								
							Until data=""
							
							'Self.waypoint_list.addlast(TWAYPOINT.create(x,y))
							
						End If
					Default
						If Self.waypoint_list Then
							Self.waypoint_list=Null
							
						End If
				End Select
				
			Case 3
				
				Local pos:Int
				
				pos=Instr(txt," ",1)
				Self.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.w=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.leben=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				'attack
				pos=Instr(txt," ",1)
				Self.attacking_id=Int(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				'schuss
				Self.schuss=Int(txt)
				
			Default
				Print "????"
		End Select
	End Method
	
	
	
	Method draw(schritt:Int, selected:Int)
		
		'ist das objekt überhaupt in sichtweite?
		
		If selected=1 Or (selected=0 And (Self.x+ANSICHT.x>100 And Self.y+ANSICHT.y>-100 And Self.x+ANSICHT.x<ANSICHT.screen_x+100 And Self.y+ANSICHT.y<ANSICHT.screen_y+100)) Then			
			'selecten
			'(#)
			'farbe der einheit
			'#
			'einheit bild
			'#
			'leben, ...
			
			'If Not ANSICHT.actual_selected_objects.Contains(Self.obj) Then
				Select TMAPS.map.fog_of_war[Self.x/TFELD.seite,Self.y/TFELD.seite]
					Case 0
						Return
					Case 1
						Return
					Case 2
						'markieren
						
						If schritt=3 Then
							SetColor 255,255,255
							SetAlpha 0.7
							DrawImage TOBJ_DATA_LEBEND_UNIT.image_warn,Self.x+ANSICHT.x,Self.y+ANSICHT.y
							SetAlpha 1.0
						End If
						
						Return
					Case 3
						'weitermachen
				End Select
			'End If
			
			Select schritt
				Case 1'selecten
					'If ANSICHT.actual_selected_objects.Contains(Self.obj) Then
						SetColor 255,0,0
						
						'DrawOval Self.x+ANSICHT.x-Self.r-2,Self.y+ANSICHT.y-Self.r-2,Self.r*2+4,Self.r*2+4
						
						SetScale 2*(Self.r+2)/100.0,2*(Self.r+2)/100.0
						DrawImage TOBJ_DATA_LEBEND_UNIT.image_ring,Self.x+ANSICHT.x,Self.y+ANSICHT.y
						SetScale 1,1
						
						Local last_x:Float=Self.x
						Local last_y:Float=Self.y
						
						If Self.waypoint_list Then
							For Local w:TWAYPOINT = EachIn Self.waypoint_list
								w.draw(last_x,last_y)
								last_x=w.x
								last_y=w.y
								
							Next
						End If
					'End If
				Case 2'farbe der einheit
					If TPLAYER.get_map(Self.player_id) Then
						SetColor TPLAYER.get_map(Self.player_id).color_r,TPLAYER.get_map(Self.player_id).color_g,TPLAYER.get_map(Self.player_id).color_b
					Else
						SetColor 255,255,255
					End If
					
					'DrawOval Self.x+ANSICHT.x-Self.r,Self.y+ANSICHT.y-Self.r,Self.r*2,Self.r*2
					SetScale 2*Self.r/100.0,2*Self.r/100.0
					DrawImage TOBJ_DATA_LEBEND_UNIT.image_ring,Self.x+ANSICHT.x,Self.y+ANSICHT.y
					SetScale 1,1
				Case 3'einheit bild
					SetColor 255,255,255
					SetRotation Self.w
					SetScale 2*Self.r/50.0,2*Self.r/50.0
					DrawImage TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_c1,Self.x+ANSICHT.x,Self.y+ANSICHT.y
					SetScale 1,1
					SetRotation 0
					
					'attack
					
					If Self.schuss=1 Then
						Self.schuss=0
						If Self.attacking_id>0 Then
							Local o:TOBJEKT=TOBJEKT.get_map(Self.attacking_id)
							If o Then
								TOBJ_DATA_LEBEND_UNIT_SOLDIER.sound_schuss.play()
								TANIM_BLEND.create(TANIM_BLEND_SCHUSS.init(),Self.x+Cos(Self.w)*(Self.r+10.0),Self.y+Sin(Self.w)*(Self.r+10.0), 2, Self.w+90, 255, 255, 255)
							End If
						End If
					End If
					
					Rem
					'If Self.player_id=TLOCAL_PLAYER.id Then
						
						If Self.attacking_id>0 Then
							Local o:TOBJEKT=TOBJEKT.get_map(Self.attacking_id)
							If o Then
								
								SetColor 255,255,255
								
								SetRotation ATan2(Self.y-o.data.y,Self.x-o.data.x)+90
								SetScale 1,((Self.y-o.data.y)^2+(Self.x-o.data.x)^2)^0.5/20.0
								
								DrawImage TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_blue_laser,(Self.x+o.data.x)/2+ANSICHT.x,(Self.y+o.data.y)/2+ANSICHT.y
								
								SetRotation 0
								
								SetScale 1,1
							End If
						End If
					'End If
					End Rem
					
					
				Case 4'leben, ...
					SetAlpha 0.3
					SetColor 0,0,0
					DrawRect Self.x+ANSICHT.x-26,Self.y+ANSICHT.y-Self.r-6,52,5
					SetAlpha 0.7
					SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
					DrawRect Self.x+ANSICHT.x-25,Self.y+ANSICHT.y-Self.r-5,Self.leben/Self.leben_max*50.0,4
					SetAlpha 1
			End Select
		End If
	End Method
	
	
	Method draw_mini(x:Int,y:Int)
		'Field mini_x:Field
		'Field mini_y:Field
		SetColor 255,255,255
		DrawRect x+Self.mini_x,y+Self.mini_y,30,30
		SetColor 0,0,0
		DrawRect x+Self.mini_x+1,y+Self.mini_y+1,28,28
		SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
		SetAlpha 1.0
		DrawImage TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_mini,x+Self.mini_x,y+Self.mini_y
	End Method
	
	Method draw_maxi(x:Int,y:Int)
		SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
		DrawImage TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_maxi,x+35,y+5
		
		SetColor 255,255,255
		DrawText "Soldier", x+10, y+90
		
		SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
		DrawText "Leben: "+Int(Self.leben)+"/"+Int(Self.leben_max), x+10, y+105
	End Method
	
	
	Method kill()
		TANIM_BLEND.create(TANIM_BLEND_BLUT.init(),Self.x, Self.y, 1, Rand(1,360), 255, 255, 255)
		TOBJ_DATA_LEBEND_UNIT_SOLDIER.sound_tot.play()
	End Method
	
	Function ini()
		TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_c1=LoadImage("creatures\c1.png")
		MidHandleImage TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_c1
		
		'TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_ring=LoadImage("creatures\ring.png")
		'MidHandleImage TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_ring
		
		TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_blue_laser=LoadImage("creatures\blue_laser.png")
		MidHandleImage TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_blue_laser
		
		TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_mini=LoadImage("creatures\soldier_mini.png")
		TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_maxi=LoadImage("creatures\soldier_maxi.png")
		'MidHandleImage TOBJ_DATA_LEBEND_UNIT_SOLDIER.image_mini
		'nicht, da mini
		
		
		TOBJ_DATA_LEBEND_UNIT_SOLDIER.sound_schuss=TSound.Load("sound\schuss.wav",0)
		'TOBJ_DATA_LEBEND_UNIT_SOLDIER.sound_schuss.play()
		
		TOBJ_DATA_LEBEND_UNIT_SOLDIER.sound_tot=TSound.Load("sound\tot.wav",0)
		'TOBJ_DATA_LEBEND_UNIT_SOLDIER.sound_tot.play()
		
	End Function
	
	Global sound_schuss:TSound
	Global sound_tot:TSound
	Global image_c1:TImage
	'Global image_ring:TImage
	Global image_mini:TImage
	Global image_maxi:TImage
	Global image_blue_laser:TImage
End Type



Type TOBJ_DATA_LEBEND_UNIT_AMEISE Extends TOBJ_DATA_LEBEND_UNIT
	
	Field leben:Float
	
	Field waypoint_list:TList
	Field waypoint_string:String
	
	Field attacking_id:Int
	Field schuss:Int
	
	
	
	Function create:TOBJ_DATA(daten_typ:Int, new_data:String)
		
		Local od:TOBJ_DATA_LEBEND_UNIT_AMEISE=New TOBJ_DATA_LEBEND_UNIT_AMEISE
		
		
		Select daten_typ
			Case 0
				
				Local pos:Int
				
				
				Local txt:String=new_data
				
				
				pos=Instr(txt," ",1)
				od.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.w=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.r=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				pos=Instr(txt," ",1)
				od.sichtweite=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.sichtweite_radar=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				pos=Instr(txt," ",1)
				od.leben=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.leben_max=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				od.player_id=Int(txt)
				
			Case 1
				
				Local pos:Int
				
				
				Local txt:String=new_data
				
				
				pos=Instr(txt," ",1)
				od.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.w=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.r=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				pos=Instr(txt," ",1)
				od.sichtweite=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.sichtweite_radar=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				
				pos=Instr(txt," ",1)
				od.leben=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.leben_max=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				od.player_id=Int(txt)
				
			Default
				Print "????"
		End Select
		
		od.mini_typ=2
		
		Return od
	End Function
	
	Method render()
	End Method
	
	Method set(daten_typ:Int, txt:String)'daten updaten
		Select daten_typ
			Case 2
				
				Local pos:Int
				
				pos=Instr(txt," ",1)
				Self.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.w=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				
				pos=Instr(txt," ",1)
				Self.leben=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.attacking_id=Int(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				'schuss
				pos=Instr(txt," ",1)
				Self.schuss=Int(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				pos=Instr(txt," ",1)
				Local bef:String=Mid(txt,1,pos-1)
				
				
				Select Lower(bef)
					Case "non"
						If Self.waypoint_list Then
							Self.waypoint_list=Null
							
						End If
					Case "awp"
						If Self.waypoint_string=txt Then
							'nix machen, da gleich wie sonst
							
						Else
							
							
							Self.waypoint_string=txt
							
							Self.waypoint_list=New TList
							
							Local data:String=Mid(txt,pos+1,-1)
							
							Repeat
								Local posit:Int=Instr(data," ",1)
								Local act_data:String
								
								If posit=0 Then
									act_data=data
									data=""
								Else
									act_data=Mid(data,1,posit-1)
									data=Mid(data,posit+1,-1)
								End If
								
								Local pos1:Int=Instr(act_data, ":", 1)
								Local pos2:Int=Instr(act_data, ":", pos1+1)
								Local xx:Float=Float(Mid(act_data, 1, pos1-1))
								Local yy:Float=Float(Mid(act_data, pos1+1, pos2-1))
								Local rr:Float=Float(Mid(act_data, pos2+1, -1))
								
								Self.waypoint_list.addlast(TWAYPOINT.create(xx,yy))
								
							Until data=""
							
							'Self.waypoint_list.addlast(TWAYPOINT.create(x,y))
							
						End If
					Default
						If Self.waypoint_list Then
							Self.waypoint_list=Null
							
						End If
				End Select
				
			Case 3
				
				Local pos:Int
				
				pos=Instr(txt," ",1)
				Self.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.w=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.leben=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				'attack
				pos=Instr(txt," ",1)
				Self.attacking_id=Int(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				'schuss
				Self.schuss=Int(txt)
				
			Default
				Print "????"
		End Select
	End Method
	
	
	
	Method draw(schritt:Int, selected:Int)
		
		'ist das objekt überhaupt in sichtweite?
		
		If selected=1 Or (selected=0 And (Self.x+ANSICHT.x>100 And Self.y+ANSICHT.y>-100 And Self.x+ANSICHT.x<ANSICHT.screen_x+100 And Self.y+ANSICHT.y<ANSICHT.screen_y+100)) Then			
			'selecten
			'(#)
			'farbe der einheit
			'#
			'einheit bild
			'#
			'leben, ...
			
			'If Not ANSICHT.actual_selected_objects.Contains(Self.obj) Then
				Select TMAPS.map.fog_of_war[Self.x/TFELD.seite,Self.y/TFELD.seite]
					Case 0
						Return
					Case 1
						Return
					Case 2
						'markieren
						
						If schritt=3 Then
							SetColor 255,255,255
							SetAlpha 0.7
							DrawImage TOBJ_DATA_LEBEND_UNIT.image_warn,Self.x+ANSICHT.x,Self.y+ANSICHT.y
							SetAlpha 1.0
						End If
						
						Return
					Case 3
						'weitermachen
				End Select
			'End If
			
			Select schritt
				Case 1'selecten
					'If ANSICHT.actual_selected_objects.Contains(Self.obj) Then
						SetColor 255,0,0
						
						'DrawOval Self.x+ANSICHT.x-Self.r-2,Self.y+ANSICHT.y-Self.r-2,Self.r*2+4,Self.r*2+4
						
						SetScale 2*(Self.r+2)/100.0,2*(Self.r+2)/100.0
						DrawImage TOBJ_DATA_LEBEND_UNIT.image_ring,Self.x+ANSICHT.x,Self.y+ANSICHT.y
						SetScale 1,1
						
						Local last_x:Float=Self.x
						Local last_y:Float=Self.y
						
						If Self.waypoint_list Then
							For Local w:TWAYPOINT = EachIn Self.waypoint_list
								w.draw(last_x,last_y)
								last_x=w.x
								last_y=w.y
								
							Next
						End If
					'End If
				Case 2'farbe der einheit
					If TPLAYER.get_map(Self.player_id) Then
						SetColor TPLAYER.get_map(Self.player_id).color_r,TPLAYER.get_map(Self.player_id).color_g,TPLAYER.get_map(Self.player_id).color_b
					Else
						SetColor 255,255,255
					End If
					
					'DrawOval Self.x+ANSICHT.x-Self.r,Self.y+ANSICHT.y-Self.r,Self.r*2,Self.r*2
					SetScale 2*Self.r/100.0,2*Self.r/100.0
					DrawImage TOBJ_DATA_LEBEND_UNIT.image_ring,Self.x+ANSICHT.x,Self.y+ANSICHT.y
					SetScale 1,1
				Case 3'einheit bild
					SetColor 255,255,255
					SetRotation Self.w
					SetScale 2*Self.r/50.0,2*Self.r/50.0
					DrawImage TOBJ_DATA_LEBEND_UNIT_AMEISE.image_ameise,Self.x+ANSICHT.x,Self.y+ANSICHT.y
					SetScale 1,1
					SetRotation 0
					
					'attack
					
					
					If Self.schuss=1 Then
						Self.schuss=0
						If Self.attacking_id>0 Then
							Local o:TOBJEKT=TOBJEKT.get_map(Self.attacking_id)
							If o Then
								TOBJ_DATA_LEBEND_UNIT_AMEISE.sound_beiss.play()
								'TANIM_BLEND.create(TANIM_BLEND_SCHUSS.init(),Self.x+Cos(Self.w)*(Self.r+10.0),Self.y+Sin(Self.w)*(Self.r+10.0), 2, Self.w+90, 255, 255, 255)
							End If
						End If
					End If
					
					
					
				Case 4'leben, ...
					SetAlpha 0.3
					SetColor 0,0,0
					DrawRect Self.x+ANSICHT.x-26,Self.y+ANSICHT.y-Self.r-6,52,5
					SetAlpha 0.7
					SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
					DrawRect Self.x+ANSICHT.x-25,Self.y+ANSICHT.y-Self.r-5,Self.leben/Self.leben_max*50.0,4
					SetAlpha 1
			End Select
		End If
	End Method
	
	
	Method draw_mini(x:Int,y:Int)
		'Field mini_x:Field
		'Field mini_y:Field
		SetColor 255,255,255
		DrawRect x+Self.mini_x,y+Self.mini_y,30,30
		SetColor 0,0,0
		DrawRect x+Self.mini_x+1,y+Self.mini_y+1,28,28
		SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
		SetAlpha 1.0
		DrawImage TOBJ_DATA_LEBEND_UNIT_AMEISE.image_mini,x+Self.mini_x,y+Self.mini_y
	End Method
	
	Method draw_maxi(x:Int,y:Int)
		SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
		DrawImage TOBJ_DATA_LEBEND_UNIT_AMEISE.image_maxi,x+35,y+5
		
		SetColor 255,255,255
		DrawText "Ameise", x+10, y+90
		
		SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
		DrawText "Leben: "+Int(Self.leben)+"/"+Int(Self.leben_max), x+10, y+105
	End Method
	
	
	Method kill()
		TANIM_BLEND.create(TANIM_BLEND_BLUT.init(),Self.x, Self.y, 1, Rand(1,360), 255, 255, 255)
		TOBJ_DATA_LEBEND_UNIT_AMEISE.sound_tot.play()
	End Method
	
	Function ini()
		TOBJ_DATA_LEBEND_UNIT_AMEISE.image_ameise=LoadImage("creatures\ameise.png")
		MidHandleImage TOBJ_DATA_LEBEND_UNIT_AMEISE.image_ameise
		
		
		
		TOBJ_DATA_LEBEND_UNIT_AMEISE.image_mini=LoadImage("creatures\ameise_mini.png")
		
		TOBJ_DATA_LEBEND_UNIT_AMEISE.image_maxi=LoadImage("creatures\ameise_maxi.png")
		
		
		TOBJ_DATA_LEBEND_UNIT_AMEISE.sound_beiss=TSound.Load("sound\beiss.wav",0)
		'TOBJ_DATA_LEBEND_UNIT_AMEISE.sound_beiss.play()
		
		TOBJ_DATA_LEBEND_UNIT_AMEISE.sound_tot=TSound.Load("sound\ameise_tot.wav",0)
		'TOBJ_DATA_LEBEND_UNIT_AMEISE.sound_tot.play()
		
	End Function
	
	Global sound_beiss:TSound
	Global sound_tot:TSound
	Global image_ameise:TImage
	Global image_mini:TImage
	Global image_maxi:TImage
End Type




Type TOBJ_DATA_LEBEND_UNIT_DRONE Extends TOBJ_DATA_LEBEND_UNIT
	
	Field leben:Float
	
	Field waypoint_list:TList
	Field waypoint_string:String
	
	Field attacking_id:Int
	Field schuss:Int
	
	
	
	Function create:TOBJ_DATA(daten_typ:Int, new_data:String)
		
		Local od:TOBJ_DATA_LEBEND_UNIT_DRONE=New TOBJ_DATA_LEBEND_UNIT_DRONE
		
		
		Select daten_typ
			Case 0
				
				Local pos:Int
				
				
				Local txt:String=new_data
				
				
				pos=Instr(txt," ",1)
				od.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.w=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.r=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				pos=Instr(txt," ",1)
				od.sichtweite=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.sichtweite_radar=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				pos=Instr(txt," ",1)
				od.leben=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.leben_max=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				od.player_id=Int(txt)
				
			Case 1
				
				Local pos:Int
				
				
				Local txt:String=new_data
				
				
				pos=Instr(txt," ",1)
				od.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.w=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.r=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				pos=Instr(txt," ",1)
				od.sichtweite=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.sichtweite_radar=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				
				pos=Instr(txt," ",1)
				od.leben=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.leben_max=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				od.player_id=Int(txt)
				
			Default
				Print "????"
		End Select
		
		od.mini_typ=3
		
		Return od
	End Function
	
	Method render()
	End Method
	
	Method set(daten_typ:Int, txt:String)'daten updaten
		Select daten_typ
			Case 2
				
				Local pos:Int
				
				pos=Instr(txt," ",1)
				Self.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.w=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				
				pos=Instr(txt," ",1)
				Self.leben=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.attacking_id=Int(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				'schuss
				pos=Instr(txt," ",1)
				Self.schuss=Int(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				pos=Instr(txt," ",1)
				Local bef:String=Mid(txt,1,pos-1)
				
				
				Select Lower(bef)
					Case "non"
						If Self.waypoint_list Then
							Self.waypoint_list=Null
							
						End If
					Case "awp"
						If Self.waypoint_string=txt Then
							'nix machen, da gleich wie sonst
							
						Else
							
							
							Self.waypoint_string=txt
							
							Self.waypoint_list=New TList
							
							Local data:String=Mid(txt,pos+1,-1)
							
							Repeat
								Local posit:Int=Instr(data," ",1)
								Local act_data:String
								
								If posit=0 Then
									act_data=data
									data=""
								Else
									act_data=Mid(data,1,posit-1)
									data=Mid(data,posit+1,-1)
								End If
								
								Local pos1:Int=Instr(act_data, ":", 1)
								Local pos2:Int=Instr(act_data, ":", pos1+1)
								Local xx:Float=Float(Mid(act_data, 1, pos1-1))
								Local yy:Float=Float(Mid(act_data, pos1+1, pos2-1))
								Local rr:Float=Float(Mid(act_data, pos2+1, -1))
								
								Self.waypoint_list.addlast(TWAYPOINT.create(xx,yy))
								
							Until data=""
							
							'Self.waypoint_list.addlast(TWAYPOINT.create(x,y))
							
						End If
					Default
						If Self.waypoint_list Then
							Self.waypoint_list=Null
							
						End If
				End Select
				
			Case 3
				
				Local pos:Int
				
				pos=Instr(txt," ",1)
				Self.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.w=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				Self.leben=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				'attack
				pos=Instr(txt," ",1)
				Self.attacking_id=Int(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				'schuss
				Self.schuss=Int(txt)
				
			Default
				Print "????"
		End Select
	End Method
	
	
	
	Method draw(schritt:Int, selected:Int)
		
		'ist das objekt überhaupt in sichtweite?
		
		If selected=1 Or (selected=0 And (Self.x+ANSICHT.x>100 And Self.y+ANSICHT.y>-100 And Self.x+ANSICHT.x<ANSICHT.screen_x+100 And Self.y+ANSICHT.y<ANSICHT.screen_y+100)) Then			
			'selecten
			'(#)
			'farbe der einheit
			'#
			'einheit bild
			'#
			'leben, ...
			
			'If Not ANSICHT.actual_selected_objects.Contains(Self.obj) Then
				Select TMAPS.map.fog_of_war[Self.x/TFELD.seite,Self.y/TFELD.seite]
					Case 0
						Return
					Case 1
						Return
					Case 2
						'markieren
						
						If schritt=3 Then
							SetColor 255,255,255
							SetAlpha 0.7
							DrawImage TOBJ_DATA_LEBEND_UNIT.image_warn,Self.x+ANSICHT.x,Self.y+ANSICHT.y
							SetAlpha 1.0
						End If
						
						Return
					Case 3
						'weitermachen
				End Select
			'End If
			
			Select schritt
				Case 1'selecten
					'If ANSICHT.actual_selected_objects.Contains(Self.obj) Then
						SetColor 255,0,0
						
						'DrawOval Self.x+ANSICHT.x-Self.r-2,Self.y+ANSICHT.y-Self.r-2,Self.r*2+4,Self.r*2+4
						
						SetScale 2*(Self.r+2)/100.0,2*(Self.r+2)/100.0
						DrawImage TOBJ_DATA_LEBEND_UNIT.image_ring,Self.x+ANSICHT.x,Self.y+ANSICHT.y
						SetScale 1,1
						
						Local last_x:Float=Self.x
						Local last_y:Float=Self.y
						
						If Self.waypoint_list Then
							For Local w:TWAYPOINT = EachIn Self.waypoint_list
								w.draw(last_x,last_y)
								last_x=w.x
								last_y=w.y
								
							Next
						End If
					'End If
				Case 2'farbe der einheit
					If TPLAYER.get_map(Self.player_id) Then
						SetColor TPLAYER.get_map(Self.player_id).color_r,TPLAYER.get_map(Self.player_id).color_g,TPLAYER.get_map(Self.player_id).color_b
					Else
						SetColor 255,255,255
					End If
					
					'DrawOval Self.x+ANSICHT.x-Self.r,Self.y+ANSICHT.y-Self.r,Self.r*2,Self.r*2
					SetScale 2*Self.r/100.0,2*Self.r/100.0
					DrawImage TOBJ_DATA_LEBEND_UNIT.image_ring,Self.x+ANSICHT.x,Self.y+ANSICHT.y
					SetScale 1,1
				Case 3'einheit bild
					SetColor 255,255,255
					SetRotation Self.w+90
					SetScale 2*Self.r/30.0,2*Self.r/30.0
					DrawImage TOBJ_DATA_LEBEND_UNIT_DRONE.image_drone,Self.x+ANSICHT.x,Self.y+ANSICHT.y
					SetScale 1,1
					SetRotation 0
					
					'attack
					
					If Self.schuss=1 Then
						Self.schuss=0
						If Self.attacking_id>0 Then
							Local o:TOBJEKT=TOBJEKT.get_map(Self.attacking_id)
							If o Then
								TOBJ_DATA_LEBEND_UNIT_DRONE.sound_beiss.play()
								'TANIM_BLEND.create(TANIM_BLEND_SCHUSS.init(),Self.x+Cos(Self.w)*(Self.r+10.0),Self.y+Sin(Self.w)*(Self.r+10.0), 2, Self.w+90, 255, 255, 255)
							End If
						End If
					End If
					
					
					
				Case 4'leben, ...
					SetAlpha 0.3
					SetColor 0,0,0
					DrawRect Self.x+ANSICHT.x-26,Self.y+ANSICHT.y-Self.r-6,52,5
					SetAlpha 0.7
					SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
					DrawRect Self.x+ANSICHT.x-25,Self.y+ANSICHT.y-Self.r-5,Self.leben/Self.leben_max*50.0,4
					SetAlpha 1
			End Select
		End If
	End Method
	
	
	Method draw_mini(x:Int,y:Int)
		'Field mini_x:Field
		'Field mini_y:Field
		SetColor 255,255,255
		DrawRect x+Self.mini_x,y+Self.mini_y,30,30
		SetColor 0,0,0
		DrawRect x+Self.mini_x+1,y+Self.mini_y+1,28,28
		SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
		SetAlpha 1.0
		DrawImage TOBJ_DATA_LEBEND_UNIT_DRONE.image_mini,x+Self.mini_x,y+Self.mini_y
	End Method
	
	Method draw_maxi(x:Int,y:Int)
		SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
		DrawImage TOBJ_DATA_LEBEND_UNIT_DRONE.image_maxi,x+35,y+5
		
		SetColor 255,255,255
		DrawText "Drone", x+10, y+90
		
		SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
		DrawText "Leben: "+Int(Self.leben)+"/"+Int(Self.leben_max), x+10, y+105
	End Method
	
	
	Method kill()
		TANIM_BLEND.create(TANIM_BLEND_BLUT.init(),Self.x, Self.y, 1, Rand(1,360), 255, 255, 255)
		TOBJ_DATA_LEBEND_UNIT_DRONE.sound_tot.play()
	End Method
	
	Function ini()
		TOBJ_DATA_LEBEND_UNIT_DRONE.image_drone=LoadImage("creatures\drone.png")
		MidHandleImage TOBJ_DATA_LEBEND_UNIT_DRONE.image_drone
		
		
		
		TOBJ_DATA_LEBEND_UNIT_DRONE.image_mini=LoadImage("creatures\drone.png")'ist ja schon 30*30
		
		TOBJ_DATA_LEBEND_UNIT_DRONE.image_maxi=LoadImage("creatures\drone_maxi.png")
		
		TOBJ_DATA_LEBEND_UNIT_DRONE.sound_beiss=TSound.Load("sound\beiss.wav",0)
		
		TOBJ_DATA_LEBEND_UNIT_DRONE.sound_tot=TSound.Load("sound\ameise_tot.wav",0)
		
	End Function
	
	Global sound_beiss:TSound
	Global sound_tot:TSound
	Global image_drone:TImage
	Global image_mini:TImage
	Global image_maxi:TImage
End Type







Type TOBJ_DATA_LEBEND_UNIT_BASE Extends TOBJ_DATA_LEBEND_UNIT
	
	Field leben:Float
	
	'Field waypoint_list:TList
	'Field waypoint_string:String
	
	'Field attacking_id:Int
	'Field schuss:Int
	
	
	
	Function create:TOBJ_DATA(daten_typ:Int, new_data:String)
		
		Local od:TOBJ_DATA_LEBEND_UNIT_BASE=New TOBJ_DATA_LEBEND_UNIT_BASE
		
		
		Select daten_typ
			Case 0
				
				Local pos:Int
				
				
				Local txt:String=new_data
				
				
				pos=Instr(txt," ",1)
				od.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.w=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.r=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				pos=Instr(txt," ",1)
				od.sichtweite=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.sichtweite_radar=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				pos=Instr(txt," ",1)
				od.leben=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.leben_max=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				od.player_id=Int(txt)
				
			Case 1
				
				Local pos:Int
				
				
				Local txt:String=new_data
				
				
				pos=Instr(txt," ",1)
				od.x=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.y=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.w=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.r=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				pos=Instr(txt," ",1)
				od.sichtweite=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.sichtweite_radar=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				
				
				pos=Instr(txt," ",1)
				od.leben=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				pos=Instr(txt," ",1)
				od.leben_max=Float(Mid(txt,1,pos-1))
				txt=Mid(txt,pos+1,-1)
				
				od.player_id=Int(txt)
				
			Default
				Print "????"
		End Select
		
		od.mini_typ=4
		
		Return od
	End Function
	
	Method render()
	End Method
	
	Method set(daten_typ:Int, txt:String)'daten updaten
		Select daten_typ
			Case 2
				
				Self.leben=Float(txt)
				
			Case 3
				
				Self.leben=Float(txt)
				
			Default
				Print "????"
		End Select
	End Method
	
	
	
	Method draw(schritt:Int, selected:Int)
		
		'ist das objekt überhaupt in sichtweite?
		
		If selected=1 Or (selected=0 And (Self.x+ANSICHT.x>100 And Self.y+ANSICHT.y>-100 And Self.x+ANSICHT.x<ANSICHT.screen_x+100 And Self.y+ANSICHT.y<ANSICHT.screen_y+100)) Then			
			'selecten
			'(#)
			'farbe der einheit
			'#
			'einheit bild
			'#
			'leben, ...
			
			'If Not ANSICHT.actual_selected_objects.Contains(Self.obj) Then
				Select TMAPS.map.fog_of_war[Self.x/TFELD.seite,Self.y/TFELD.seite]
					Case 0
						Return
					Case 1
						Return
					Case 2
						'markieren
						
						If schritt=3 Then
							SetColor 255,255,255
							SetAlpha 0.7
							DrawImage TOBJ_DATA_LEBEND_UNIT.image_warn,Self.x+ANSICHT.x,Self.y+ANSICHT.y
							SetAlpha 1.0
						End If
						
						Return
					Case 3
						'weitermachen
				End Select
			'End If
			
			Select schritt
				Case 1'selecten
					'If ANSICHT.actual_selected_objects.Contains(Self.obj) Then
						SetColor 255,0,0
						
						'DrawOval Self.x+ANSICHT.x-Self.r-2,Self.y+ANSICHT.y-Self.r-2,Self.r*2+4,Self.r*2+4
						
						SetScale 2*(Self.r+2)/100.0,2*(Self.r+2)/100.0
						DrawImage TOBJ_DATA_LEBEND_UNIT.image_ring,Self.x+ANSICHT.x,Self.y+ANSICHT.y
						SetScale 1,1
						
					'End If
				Case 2'farbe der einheit
					If TPLAYER.get_map(Self.player_id) Then
						SetColor TPLAYER.get_map(Self.player_id).color_r,TPLAYER.get_map(Self.player_id).color_g,TPLAYER.get_map(Self.player_id).color_b
					Else
						SetColor 255,255,255
					End If
					
					'DrawOval Self.x+ANSICHT.x-Self.r,Self.y+ANSICHT.y-Self.r,Self.r*2,Self.r*2
					SetScale 2*Self.r/100.0,2*Self.r/100.0
					DrawImage TOBJ_DATA_LEBEND_UNIT.image_ring,Self.x+ANSICHT.x,Self.y+ANSICHT.y
					SetScale 1,1
				Case 3'einheit bild
					SetColor 255,255,255
					SetRotation Self.w
					SetScale 2*Self.r/100.0,2*Self.r/100.0
					DrawImage TOBJ_DATA_LEBEND_UNIT_BASE.image_base,Self.x+ANSICHT.x,Self.y+ANSICHT.y
					SetScale 1,1
					SetRotation 0
					
				Case 4'leben, ...
					SetAlpha 0.3
					SetColor 0,0,0
					DrawRect Self.x+ANSICHT.x-26,Self.y+ANSICHT.y-Self.r-6,52,5
					SetAlpha 0.7
					SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
					DrawRect Self.x+ANSICHT.x-25,Self.y+ANSICHT.y-Self.r-5,Self.leben/Self.leben_max*50.0,4
					SetAlpha 1
			End Select
		End If
	End Method
	
	
	Method draw_mini(x:Int,y:Int)
		'Field mini_x:Field
		'Field mini_y:Field
		SetColor 255,255,255
		DrawRect x+Self.mini_x,y+Self.mini_y,30,30
		SetColor 0,0,0
		DrawRect x+Self.mini_x+1,y+Self.mini_y+1,28,28
		SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
		SetAlpha 1.0
		DrawImage TOBJ_DATA_LEBEND_UNIT_BASE.image_mini,x+Self.mini_x,y+Self.mini_y
	End Method
	
	Method draw_maxi(x:Int,y:Int)
		SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
		DrawImage TOBJ_DATA_LEBEND_UNIT_BASE.image_maxi,x+35,y+5
		
		SetColor 255,255,255
		DrawText "Base", x+10, y+90
		
		SetColor Float(1.0-Self.leben/Self.leben_max)*255.0,Float(Self.leben/Self.leben_max)*255.0,0
		DrawText "Leben: "+Int(Self.leben)+"/"+Int(Self.leben_max), x+10, y+105
	End Method
	
	
	Method kill()
		TANIM_BLEND.create(TANIM_BLEND_BLUT.init(),Self.x, Self.y, 1, Rand(1,360), 255, 255, 255)
		TOBJ_DATA_LEBEND_UNIT_BASE.sound_tot.play()
	End Method
	
	Function ini()
		TOBJ_DATA_LEBEND_UNIT_BASE.image_base=LoadImage("creatures\base.png")
		MidHandleImage TOBJ_DATA_LEBEND_UNIT_BASE.image_base
		
		
		
		TOBJ_DATA_LEBEND_UNIT_BASE.image_mini=LoadImage("creatures\base_mini.png")
		
		TOBJ_DATA_LEBEND_UNIT_BASE.image_maxi=LoadImage("creatures\base_maxi.png")
		
		TOBJ_DATA_LEBEND_UNIT_BASE.sound_tot=TSound.Load("sound\ameise_tot.wav",0)
		
	End Function
	
	Global sound_tot:TSound
	Global image_base:TImage
	Global image_mini:TImage
	Global image_maxi:TImage
End Type


'#########################################################################
'##########  TWAYPOINT ###################################################
'#########################################################################

Type TWAYPOINT
	Field x:Float
	Field y:Float
	Field w:Float
	
	Function create:TWAYPOINT(x:Float,y:Float)
		Local w:TWAYPOINT=New TWAYPOINT
		
		w.x=x
		w.y=y
		'w.w=Rand(1,360)
		
		
		Return w
	End Function
	
	Method draw(x:Float,y:Float)'from-koordinaten
		
		SetColor 255,255,255
		SetRotation Self.w+(ANSICHT.ACT_MILLISECS*0.3)
		SetScale 0.3,0.3
		DrawImage TWAYPOINT.image_w,Self.x+ANSICHT.x,Self.y+ANSICHT.y
		SetScale 1,1
		
		
		'SetColor 0,255,0
		'DrawLine Self.x+ANSICHT.x,Self.y+ANSICHT.y,x+ANSICHT.x,y+ANSICHT.y
		
		SetColor 255,255,255
		
		SetRotation ATan2(Self.y-y,Self.x-x)+90
		SetScale 1,((Self.y-y)^2+(Self.x-x)^2)^0.5/50.0
		
		DrawImage TWAYPOINT.image_c,(Self.x+x)/2+ANSICHT.x,(Self.y+y)/2+ANSICHT.y
		SetScale 1,1
		SetRotation 0
	End Method
	
	Function ini()
		TWAYPOINT.image_w=LoadImage("creatures\waypoint.png")
		MidHandleImage TWAYPOINT.image_w
		TWAYPOINT.image_c=LoadImage("creatures\connection_waypoints.png")'10*50
		MidHandleImage TWAYPOINT.image_c
	End Function
	
	Global image_w:TImage
	Global image_c:TImage
End Type

'#########################################################################
'########## TANIM  #######################################################
'#########################################################################

Type TANIM '@ 1 @
	Global liste1:TList'für die z
	Global liste2:TList
	Global liste3:TList
	
	Field x:Float
	Field y:Float
	Field z:Int
	Field w:Float
	
	Field time_created:Int
	
	Method set()
		Select Self.z
			Case 1
				TANIM.liste1.addlast(Self)
			Case 2
				TANIM.liste2.addlast(Self)
			Case 3
				TANIM.liste3.addlast(Self)
			Default
				Print "z nicht erlaubt! "+Self.z
		End Select
		Self.time_created=MilliSecs()
	End Method
	
	Method kill()
		Select Self.z
			Case 1
				TANIM.liste1.remove(Self)
			Case 2
				TANIM.liste2.remove(Self)
			Case 3
				TANIM.liste3.remove(Self)
			Default
				Print "z nicht erlaubt! "+Self.z
		End Select
		
	End Method
	
	'Function create:TANIM(x:Float,y:Float, z:int, w:float) Abstract
	
	Method visible:Int()
		Return (Self.x+ANSICHT.x>100 And Self.y+ANSICHT.y>-100 And Self.x+ANSICHT.x<ANSICHT.screen_x+100 And Self.y+ANSICHT.y<ANSICHT.screen_y+100 And TMAPS.map.fog_of_war[Self.x/TFELD.seite,Self.y/TFELD.seite]=3)
	End Method
	
	Method render_draw() Abstract'render and draw
	'if self.visible() then
	'self.kill()
	'Self.time_created=MilliSecs()
	'self.x
	'self.y
	
	Function render_draw_all(z:Int)
		Select z
			Case 1
				For Local a:TANIM= EachIn TANIM.liste1
					a.render_draw()
				Next
			Case 2
				For Local a:TANIM= EachIn TANIM.liste2
					a.render_draw()
				Next
			Case 3
				For Local a:TANIM= EachIn TANIM.liste3
					a.render_draw()
				Next
		End Select
	End Function
End Type

'#########################################################################
'########## TANIM  #######################################################
'#########################################################################

Type TANIM_BLEND Extends TANIM'@ 2 @
	Field color_r:Float
	Field color_g:Float
	Field color_b:Float
	
	Field lifetime:Int'=1000 das ist zu ändern für die objekte
	Field anz_images:Int'=2
	Field images:TImage[]' NICHT: TANIM_BLEND
	Function ini() Abstract
	Function init:TANIM_BLEND() Abstract
	
	Function create:TANIM_BLEND(obj:TANIM_BLEND,x:Float,y:Float, z:Int, w:Float, r:Float, g:Float, b:Float)
		obj.x=x
		obj.y=y
		obj.z=z
		obj.w=w
		
		obj.color_r=r
		obj.color_g=g
		obj.color_b=b
		
		obj.set()
		
		Return obj
	End Function
	
	Method render_draw()'render and draw
		If (Self.lifetime+Self.time_created)<=MilliSecs() Then
			Self.kill()
		End If
		
		If Self.visible() Then'zuerst das erste bild, immer überblenden, das letzte ausblenden-fertig
			Local act_bild:Float=Float(Float(Self.anz_images)*Float(MilliSecs()-Self.time_created)/Float(Self.lifetime))
			If act_bild>(Self.anz_images-0.01) Then act_bild=Self.anz_images-0.01
			SetColor Self.color_r, Self.color_g, Self.color_b
			SetRotation Self.w
			
			SetAlpha 1.0-(act_bild - Int(act_bild))
			
			DrawImage Self.images[Int(act_bild)],Self.x+ANSICHT.x,Self.y+ANSICHT.y
			
			
			If Int(act_bild)<Int(Self.anz_images-1)
				SetAlpha (act_bild - Int(act_bild))
				DrawImage Self.images[Int(act_bild)+1],Self.x+ANSICHT.x,Self.y+ANSICHT.y
			End If
			
			SetRotation 0
			SetColor 255,255,255
			SetAlpha 1.0
			
		End If
	End Method
End Type

'#########################################################################
'########## TANIM_BLEND_BLUT  ############################################
'#########################################################################

'TANIM_BLEND.create(TANIM_BLEND_BLUT.init(),x:Float,y:Float, z:Int, w:Float, 255, 255, 255)
Type TANIM_BLEND_BLUT Extends TANIM_BLEND'@ 3 @
	
	Global start_images:TImage[]
	
	Function init:TANIM_BLEND()
		Local obj:TANIM_BLEND_BLUT=New TANIM_BLEND_BLUT'ändern
		
		obj.images=TANIM_BLEND_BLUT.start_images'ändern
		obj.anz_images=3
		obj.lifetime=10000
		
		Return obj
	End Function
	
	Function ini()
		TANIM_BLEND_BLUT.start_images=New TImage[3]'zahlen anpassen
		
		For Local i:Int=0 To 2'zahlen anpassen
			TANIM_BLEND_BLUT.start_images[i]=LoadImage("anim\blut\"+i+".png")'40*40
			MidHandleImage TANIM_BLEND_BLUT.start_images[i]
		Next
	End Function
End Type

'#########################################################################
'########## TANIM_BLEND_SCHUSS ###########################################
'#########################################################################

'TANIM_BLEND.create(TANIM_BLEND_SCHUSS.init(),x:Float,y:Float, z:Int, w:Float, 255, 255, 255)
Type TANIM_BLEND_SCHUSS Extends TANIM_BLEND'@ 3 @
	
	Global start_images:TImage[]
	
	Function init:TANIM_BLEND()
		Local obj:TANIM_BLEND_SCHUSS=New TANIM_BLEND_SCHUSS'ändern
		
		obj.images=TANIM_BLEND_SCHUSS.start_images'ändern
		obj.anz_images=3
		obj.lifetime=500
		
		Return obj
	End Function
	
	Function ini()
		TANIM_BLEND_SCHUSS.start_images=New TImage[3]'zahlen anpassen
		
		For Local i:Int=0 To 2'zahlen anpassen
			TANIM_BLEND_SCHUSS.start_images[i]=LoadImage("anim\schuss\"+i+".png")'40*40
			MidHandleImage TANIM_BLEND_SCHUSS.start_images[i]
		Next
	End Function
End Type

'#########################################################################
'##########  DATA ########################################################
'#########################################################################

Type DATA
	Function mini_float:String(zahl:Float)
		Local s:String=String(Int(Abs(zahl)))
		
		Local pos:Int=Instr(Abs(zahl), ".")
		
		If (zahl<0) Then s="-"+s
		
		s:+"."+Mid(Abs(zahl), pos+1,2)
		
		Return s
	End Function
End Type

'#########################################################################
'##########  NETWORK #####################################################
'#########################################################################

Type NETWORK
	Global LOCAL_PLAYER_NAME:String
	
	Global SERVER_TCP_STREAM:TTCPStream
	Global SERVER_TCP_PORT:Int
	
	Global SERVER_IP:Int
	Global TIMEOUT:Int=1000
	
	Global UDP_STREAM_IN:TUDPStream
	Global UDP_STREAM_IN_PORT:Int
	Global UDP_STREAM_IN_OK:Int=0
	
	Global UDP_STREAM_OUT:TUDPStream
	Global UDP_STREAM_OUT_PORT:Int
	Global UDP_STREAM_OUT_OK:Int=0
	
	Function render()
		NETWORK.render_TCP()
		NETWORK.render_udp_in()
		NETWORK.render_udp_out()
	End Function
	
	
	Function connect_to_host(servername:String, port:Int, my_name:String)
		NETWORK.SERVER_TCP_PORT=port
		NETWORK.LOCAL_PLAYER_NAME=my_name
		
		NETWORK.SERVER_IP=TNetwork.GetHostIP(servername)
		Print DottedIP(NETWORK.SERVER_IP)
		If Not NETWORK.SERVER_IP Then Throw("server not found (ip is false)")
		
		NETWORK.SERVER_TCP_STREAM = New TTCPStream
		
		If Not NETWORK.SERVER_TCP_STREAM.Init() Then Throw("Can't create socket")
		
		NETWORK.SERVER_TCP_STREAM.SetTimeouts(NETWORK.TIMEOUT, NETWORK.TIMEOUT)
		
		If Not NETWORK.SERVER_TCP_STREAM.SetLocalPort() Then Throw("Can't set local port")
		
		NETWORK.SERVER_TCP_STREAM.SetRemoteIP(NETWORK.SERVER_IP)
		NETWORK.SERVER_TCP_STREAM.SetRemotePort(NETWORK.SERVER_TCP_PORT)
		
		If Not NETWORK.SERVER_TCP_STREAM.Connect() Then Throw("Can't connect to host")
		
		Print "connected!"
		
		NETWORK.SERVER_TCP_STREAM.WriteLine("SMN "+NETWORK.LOCAL_PLAYER_NAME)
		
		'NETWORK.SERVER_TCP_STREAM.WriteLine("SMC "+String(r)+" "+String(g)+" "+String(b))
		While NETWORK.SERVER_TCP_STREAM.SendMsg() ; Wend
		
	End Function
	
	Function render_TCP()
		
		If NETWORK.SERVER_TCP_STREAM.GetState()<>1 Then
			Print("connection lost!")
			End
		End If
		
		If NETWORK.SERVER_TCP_STREAM.RecvAvail() Then
			While NETWORK.SERVER_TCP_STREAM.RecvMsg(); Wend
			While Not NETWORK.SERVER_TCP_STREAM.Eof()
				Local txt:String=NETWORK.SERVER_TCP_STREAM.ReadLine()
				
				NETWORK.render_input(txt)
			Wend
		End If
	End Function
	
	Function INI_UDP_OUT:Int(port:Int)
		Print "ini udp out"
		NETWORK.UDP_STREAM_OUT_OK=0
		NETWORK.UDP_STREAM_OUT_PORT=port
		NETWORK.UDP_STREAM_OUT= New TUDPStream
		If Not NETWORK.UDP_STREAM_OUT.Init() Then
			Print "can't create socket."
			Return 0
		End If
		
		NETWORK.UDP_STREAM_OUT.SetRemoteIP(NETWORK.SERVER_IP)
		NETWORK.UDP_STREAM_OUT.SetRemotePort(NETWORK.UDP_STREAM_OUT_PORT)
		
		
		Return 1
	End Function
	
	Function INI_UDP_IN()
		Print "ini udp in"
		NETWORK.UDP_STREAM_IN = New TUDPStream
		If Not NETWORK.UDP_STREAM_IN.Init() Then Throw("Can't create socket")
		
		NETWORK.UDP_STREAM_IN.SetLocalPort(0)
		
		NETWORK.UDP_STREAM_IN_PORT=NETWORK.UDP_STREAM_IN.GetLocalPort()
		
		
		
		'DEM PLAYER DEN UDP-PORT zeigen
		
		NETWORK.SERVER_TCP_STREAM.WriteLine("UPI "+NETWORK.UDP_STREAM_IN_PORT)
		While NETWORK.SERVER_TCP_STREAM.SendMsg() ; Wend
		
	End Function
	
	Function render_udp_in()
		If NETWORK.UDP_STREAM_IN.RecvAvail() Then
			
			While NETWORK.UDP_STREAM_IN.RecvMsg() ; Wend
			
			If NETWORK.UDP_STREAM_IN.Size() > 0 Then
				
				While Not NETWORK.UDP_STREAM_IN.Eof()
					Local txt:String=NETWORK.UDP_STREAM_IN.ReadLine()
					
					
					NETWORK.render_input(txt)
					
				Wend
				
			EndIf
		EndIf
	End Function
	
	Function render_udp_out()
		If NETWORK.UDP_STREAM_OUT_OK=1 Then
			
			'daten können gesendet werden
			
		Else
			If NETWORK.UDP_STREAM_OUT Then
				NETWORK.UDP_STREAM_OUT.WriteLine("UO?")
				NETWORK.UDP_STREAM_OUT.SendMsg()
				
			End If
		End If
	End Function
	
	Function render_input(txt:String)
		Select Lower(Mid(txt,1,3))
			Case "uo?"
				NETWORK.SERVER_TCP_STREAM.WriteLine("UO!")'UDP OK!
				While NETWORK.SERVER_TCP_STREAM.SendMsg() ; Wend
				
				
				If Not NETWORK.UDP_STREAM_IN_OK=1 And NETWORK.UDP_STREAM_OUT_OK=1 Then
					CHAT.addline("Connection is OK",1,"[Personal]")
				End If
				
				NETWORK.UDP_STREAM_IN_OK=1
				
			Case "uo!"
				
				If Not NETWORK.UDP_STREAM_OUT_OK=1 And NETWORK.UDP_STREAM_IN_OK=1 Then
					CHAT.addline("Connection is OK",1,"[Personal]")
				End If
				
				NETWORK.UDP_STREAM_OUT_OK=1
				
			Case "upi"
				NETWORK.INI_UDP_OUT(Int(Mid(txt,5,-1)))
				'CHAT.addline("$UDP OUT PORT: "+Mid(txt,5,-1))
			Case "map"
				TMAPS.map=TMAPS.load("maps\"+Mid(txt,5,-1))
				'Print "MAP: "+Mid(txt,5,-1)
				
				'CHAT.addline("MAP: "+Mid(txt,5,-1),1,"[All]")
			Case "ypi"
				TLOCAL_PLAYER.id=Int(Mid(txt,5,-1))
				
			Case "npl"
				
				'alte objekten die genannt-variable auf 0 setzen
				For Local p:TPLAYER=EachIn TPLAYER.liste
					p.genannt=0
				Next
				
				'If TLOCAL_PLAYER.id=0 Then CHAT.addline("!!!local-player hat noch keine ID!")
				
				Local data_line:String=Mid(txt,5,-1)
				
				Repeat
					Local pos:Int=Instr(data_line," ",1)
					Local data:String=""
					
					If pos>0 Then
						data=Mid(data_line,1,pos-1)
						data_line=Mid(data_line,pos+1,-1)
					Else
						data=data_line
						data_line=""
					End If
					
					TPLAYER.render_input(data,0)
					
				Until data_line=""
			Case "sod"
				
				Local data_line:String=Mid(txt,5,-1)
				
				Local pos:Int=Instr(data_line, " ",1)
				Local pos2:Int=Instr(data_line, " ",pos+1)
				
				Local typ:Int=Int(Mid(data_line, 1, pos-1))
				Local id:Int=Int(Mid(data_line, pos+1, pos2-1))
				Local data:String=Mid(data_line, pos2+1, -1)
				
				TOBJEKT.render_input(typ, id, data)
			Case "oid"
				
				Local id:Int=Int(Mid(txt,5,-1))
				
				Local o:TOBJEKT=TOBJEKT.get_map(id)
				
				If o Then
					o.kill
				End If
				
			Case "cht"
				
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
			Case "ypd"
				If TLOCAL_PLAYER.player Then
					TLOCAL_PLAYER.player.minerals=Int(Mid(txt,5,-1))
				Else
					Print "local player existiert nicht"
				End If
			Default
				Print "unbekannt:"
				Print txt
				Print
		End Select
	End Function
End Type

'#########################################################################
'##########  TPLAYER #####################################################
'#########################################################################

Type TPLAYER
	Global liste:TList
	Global map:TMap
	
	Field ID:Int
	Field name:String
	Field team_id:Int
	
	Field typ:String
	
	Field color_r:Int
	Field color_g:Int
	Field color_b:Int
	
	Field genannt:Int=0'hiermit filtert man die alten player raus, ist noch zu implementieren
	
	Field minerals:Int
	
	Method New()
		TPLAYER.liste.addlast(Self)
	End Method
	
	Function create:TPLAYER(id:Int, name:String, team_id:Int, typ:String, c_r:Int, c_g:Int, c_b:Int)
		Local p:TPLAYER=New TPLAYER
		
		p.ID=id
		p.name=name
		p.team_id=team_id
		
		p.typ=typ
		
		p.color_r=c_r
		p.color_g=c_g
		p.color_b=c_b
		
		p.genannt=1
		
		TPLAYER.map.insert(String(p.id), p)
		
		Return p
	End Function
	
	Function get_map:TPLAYER(id:Int)'wichtig für viele objekte
		Return TPLAYER(TPLAYER.map.ValueForKey(String(id)))
	End Function
	
	Method new_data(name:String, team_id:Int, typ:String, c_r:Int, c_g:Int, c_b:Int)
		Self.name=name
		Self.team_id=team_id
		
		Self.typ=typ
		
		Self.color_r=c_r
		Self.color_g=c_g
		Self.color_b=c_b
		
		Self.genannt=1
	End Method
	
	Function render_input(data:String, from:Int)
		Select from
			Case 0'von player-liste
				
				
				Local txt:String=data
				Local pos:Int
				
				
				'id
				pos=Instr(txt, ":", 1)
				Local id:Int=Int(Mid(txt,1,pos-1))
				
				txt=Mid(txt,pos+1,-1)
				
				'name
				pos=Instr(txt, ":", 1)
				Local name:String=Mid(txt,1,pos-1)
				
				txt=Mid(txt,pos+1,-1)
				
				'team_id
				pos=Instr(txt, ":", 1)
				Local team_id:Int=Int(Mid(txt,1,pos-1))
				
				txt=Mid(txt,pos+1,-1)
				
				'typ
				pos=Instr(txt, ":", 1)
				Local typ:String=Mid(txt,1,pos-1)
				
				txt=Mid(txt,pos+1,-1)
				
				'r
				pos=Instr(txt, ":", 1)
				Local c_r:Int=Int(Mid(txt,1,pos-1))
				
				txt=Mid(txt,pos+1,-1)
				
				'g
				pos=Instr(txt, ":", 1)
				Local c_g:Int=Int(Mid(txt,1,pos-1))
				
				txt=Mid(txt,pos+1,-1)
				
				'b
				Local c_b:Int=Int(txt)
				
				
				If id=TLOCAL_PLAYER.id Then
					'Das bin ja ich!!!
					
					If TLOCAL_PLAYER.player Then
						'gibt es schon
						
						TLOCAL_PLAYER.new_data(name, team_id, typ, c_r, c_g, c_b)
					Else
						'create
						TLOCAL_PLAYER.create(name, team_id, typ, c_r, c_g, c_b)
						
					End If
				Else
					Local found:Int=0
					For Local p:TPLAYER=EachIn TPLAYER.liste
						If p.id=id Then
							'gibt es schon
							
							p.new_data(name, team_id, typ, c_r, c_g, c_b)
							
							found=1
							Exit
						End If
					Next
					If found=0 Then
						'create
						
						TPLAYER.create(id, name, team_id, typ, c_r, c_g, c_b)
						
					End If
				End If
				
			Case 1'von UDP-STREAM
		End Select
	End Function
End Type

'#########################################################################
'##########  TLOCAL_PLAYER ###############################################
'#########################################################################

Type TLOCAL_PLAYER
	Global id:Int
	Global player:TPLAYER
	
	
	Function create(name:String, team_id:Int, typ:String, c_r:Int, c_g:Int, c_b:Int)
		
		TLOCAL_PLAYER.player=TPLAYER.create(TLOCAL_PLAYER.id, name, team_id, typ, c_r, c_g, c_b)
		
	End Function
	
	Function new_data(name:String, team_id:Int, typ:String, c_r:Int, c_g:Int, c_b:Int)
		
		TLOCAL_PLAYER.player.new_data(name, team_id, typ, c_r, c_g, c_b)
		
		
		TLOCAL_PLAYER.id=TLOCAL_PLAYER.player.id
	End Function
	
	'wie beim server:
	'Rohstoffe
	
	'Einheiten-Beschränkungs-Zahl
	
	'Upgrades
End Type

Type TMAPS
	Global map:TMAPS'TMAPS.map.fog_of_war[xx,yy]'render_for_of_war(anz_felder:Int=-1)
	
	Field x:Int
	Field y:Int
	Field felder:TFELD[x,y]
	Field fog_of_war:Int[x,y]'0=schwarz, 1=gelände gesehen - grau, 2=radar-sensor-turm, 3=alles sehend(auch scann)
	Field fog_of_war_last_x:Int
	Field fog_of_war_last_y:Int
	
	
	Field tileset_name:String
	
	Field mini_map_scale:Float
	Rem
	Local scale:Float
		
		If TMAPS.map Then
			
			
			If Float(dx-4)/Float(TMAPS.map.x) > Float(dy-4)/Float(TMAPS.map.y) Then
				scale=Float(dy-4)/Float(TMAPS.map.y)
			Else
				scale=Float(dx-4)/Float(TMAPS.map.x)
			End If
	End Rem
	
	Function load:TMAPS(path:String)
		Local stream:TStream=ReadFile(path)
		
		Local m:TMAPS=New TMAPS
		
		m.tileset_name=stream.ReadLine()
		
		TFELD.load_tiles(m.tileset_name)
		
		m.x=stream.ReadInt()
		m.y=stream.ReadInt()
		
		m.felder=New TFELD[m.x,m.y]
		m.fog_of_war=New Int[m.x,m.y]
		
		For Local xx:Int=0 To m.x-1
			For Local yy:Int=0 To m.y-1
				Local number:Int=stream.ReadInt()
				
				For Local f:TFELD=EachIn TFELD.liste
					If f.number=number Then
						m.felder[xx,yy]=f
						Exit
					End If
				Next
				
				m.fog_of_war[xx,yy]=0
				
			Next
		Next
		
		stream.close()
		
		If Float(200-4)/Float(m.x) > Float(200-4)/Float(m.y) Then
			m.mini_map_scale=Float(200-4)/Float(m.y)
		Else
			m.mini_map_scale=Float(200-4)/Float(m.x)
		End If
		
		Return m
	End Function
	
	Method render_for_of_war(anz_felder:Int=-1)
		
		'self.fog_of_war[xx,yy]
		
		If anz_felder=-1 Then
			'alles berechnen
			For Local xx:Int=0 To Self.x-1
				For Local yy:Int=0 To Self.y-1
					Self.render_for_of_war_sub(xx,yy)
				Next
			Next
		Else
			For Local i:Int=1 To anz_felder
				Self.fog_of_war_last_x:+1
				
				If Self.fog_of_war_last_x>=Self.x Then
					Self.fog_of_war_last_x=0
					Self.fog_of_war_last_y:+1
					
					If Self.fog_of_war_last_y>=Self.y Then
						Self.fog_of_war_last_y=0
						
						
						
					End If
					
					
					
				End If
				
				Self.render_for_of_war_sub(Self.fog_of_war_last_x,Self.fog_of_war_last_y)
			Next
			'nur teil berechnen
			'Self.fog_of_war_last_y
		End If
	End Method
	
	Method render_for_of_war_sub(x:Int,y:Int)
		
		If Self.fog_of_war[x,y]>0 Then
			Self.fog_of_war[x,y]=1
		End If
		
		For Local o:TOBJEKT=EachIn TOBJEKT.liste
			If TLOCAL_PLAYER.id<>o.data.player_id Then
				If TPLAYER.get_map(o.data.player_id).team_id<>TLOCAL_PLAYER.player.team_id Then Continue
			End If
			
			If (o.data.x-Float(TFELD.seite)*Float(x+0.5))^2+(o.data.y-Float(TFELD.seite)*Float(y+0.5))^2<(o.data.sichtweite^2)
				Self.fog_of_war[x,y]=3
				Exit
			Else If o.data.sichtweite_radar>o.data.sichtweite And (o.data.x-Float(TFELD.seite)*Float(x+0.5))^2+(o.data.y-Float(TFELD.seite)*Float(y+0.5))^2<(o.data.sichtweite_radar^2)
				Self.fog_of_war[x,y]=2
			End If
		Next
		
	End Method
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
	'grün
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


Type ANSICHT
	Global x:Float
	Global y:Float
	
	Global mx:Int=MouseX()
	Global my:Int=MouseY()
	
	Global act_mouse_image:TImage
	
	Global screen_x:Int
	Global screen_y:Int
	
	Global md1:Int=MouseDown(1)
	Global last_md1:Int
	Global md2:Int=MouseDown(2)
	Global mh1:Int=MouseHit(1)
	Global mh2:Int=MouseHit(2)
	
	Global status_rect:Int=0
	Global start_rect_x:Int
	Global start_rect_y:Int
	Global actual_selected_objects:TList
	
	Global kd_lcontrol:Int
	
	Global group_listen:TList[10]
	
	Global ACT_MILLISECS:Int
	
	
	
	'Images:
	Global image_mouse:TImage
	Global image_mouse_select_rect:TImage
	Global image_mouse_attack:TImage
	'Global image_mouse:TImage
	'Global image_mouse:TImage
	
	Function ini(xx:Int=800,yy:Int=600,fullscreen:Int=0)
		ANSICHT.screen_x=xx
		ANSICHT.screen_y=yy
		
		If fullscreen=1 Then
			Graphics xx,yy,32,60
		Else
			Graphics xx,yy
		End If
		SetBlend ALPHABLEND
		
		ANSICHT.image_mouse=LoadImage("mouse\1.png")
		MidHandleImage ANSICHT.image_mouse
		
		ANSICHT.image_mouse_select_rect=LoadImage("mouse\select.png")
		MidHandleImage ANSICHT.image_mouse_select_rect
		
		ANSICHT.image_mouse_attack=LoadImage("mouse\attack.png")
		MidHandleImage ANSICHT.image_mouse_attack
		
		ANSICHT.act_mouse_image=ANSICHT.image_mouse
	End Function
	
	Function render()
		ANSICHT.act_mouse_image=ANSICHT.image_mouse
		
		ANSICHT.kd_lcontrol=KeyDown(key_lcontrol)
		
		ANSICHT.ACT_MILLISECS=MilliSecs()
		ANSICHT.mx=MouseX()
		ANSICHT.my=MouseY()
		
		ANSICHT.last_md1=ANSICHT.md1
		ANSICHT.md1=MouseDown(1)
		ANSICHT.md2=MouseDown(2)
		ANSICHT.mh1=MouseHit(1)
		ANSICHT.mh2=MouseHit(2)
		
		
		If KeyDown(key_up) Then ANSICHT.y:+5
		If KeyDown(key_down) Then ANSICHT.y:-5
		If KeyDown(key_left) Then ANSICHT.x:+5
		If KeyDown(key_right) Then ANSICHT.x:-5
		
		'Selecting feld
		
		Select ANSICHT.status_rect
			Case 0
				If mh1 And ANSICHT.mx>=200 Then
					ANSICHT.status_rect=1
					ANSICHT.start_rect_x=ANSICHT.mx-ANSICHT.x
					ANSICHT.start_rect_y=ANSICHT.my-ANSICHT.y
				End If
			Case 1
				If md1 Then
					If ANSICHT.mx<200
						ANSICHT.x:-ANSICHT.mx-200
						MoveMouse 200,MouseY()
					End If
				Else
					
					'auswerten
					ANSICHT.actual_selected_objects=New TList
					
					Local x1:Float
					Local y1:Float
					Local x2:Float
					Local y2:Float
					
					If ANSICHT.start_rect_x<(ANSICHT.mx-ANSICHT.x) Then
						x1=ANSICHT.start_rect_x
						x2=(ANSICHT.mx-ANSICHT.x)
					Else
						x2=ANSICHT.start_rect_x
						x1=(ANSICHT.mx-ANSICHT.x)
					End If
					
					If ANSICHT.start_rect_y<(ANSICHT.my-ANSICHT.y) Then
						y1=ANSICHT.start_rect_y
						y2=(ANSICHT.my-ANSICHT.y)
					Else
						y2=ANSICHT.start_rect_y
						y1=(ANSICHT.my-ANSICHT.y)
					End If
					
					Local mini_x:Int=5
					Local mini_y:Int=5
					
					For Local o:TOBJEKT=EachIn TOBJEKT.liste
						If o.data.player_id=TLOCAL_PLAYER.id Then
							If TOBJ_DATA_LEBEND_UNIT(o.data)
								If x1=<o.data.x+o.data.r And x2>=o.data.x-o.data.r And y1=<o.data.y+o.data.r And y2>=o.data.y-o.data.r Then
									ANSICHT.actual_selected_objects.addlast(o)
									
									TOBJ_DATA_LEBEND_UNIT(o.data).mini_x=mini_x
									TOBJ_DATA_LEBEND_UNIT(o.data).mini_y=mini_y
									
									mini_x:+32
									If mini_x>180 Then
										mini_x=5
										mini_y:+32
										If mini_y>180 Then Exit
									End If
								End If
							End If
						End If
					Next
					
					ANSICHT.status_rect=0
				End If
		End Select
		
		If mh1 And ANSICHT.mx>200 Then
			ANSICHT.status_rect=1
			ANSICHT.start_rect_x=ANSICHT.mx-ANSICHT.x
			ANSICHT.start_rect_y=ANSICHT.my-ANSICHT.y
		End If
		
		If md1 And ANSICHT.mx<200 And ANSICHT.my<200 Then
			
			ANSICHT.x=-Float(Float(ANSICHT.mx)/200.0)*TFELD.seite*TMAPS.map.x+200+0.5*Float(ANSICHT.screen_y-200)
			ANSICHT.y=-Float(Float(ANSICHT.my)/200.0)*TFELD.seite*TMAPS.map.y+0.5*ANSICHT.screen_y
			
		End If
		
		'ANSICHT.actual_selected_objects
		
		If TKEY_INPUT.chat_on=0 Then
			
			For Local i:Int=0 To 9
				If KeyHit(i+48) Then
					If ANSICHT.kd_lcontrol Then
						'einschreiben
						If ANSICHT.actual_selected_objects Then
							ANSICHT.group_listen[i]=ANSICHT.actual_selected_objects
						Else
							ANSICHT.group_listen[i]=New TList
						End If
					Else
						'auslesen
						
						ANSICHT.actual_selected_objects=New TList
						
						If ANSICHT.group_listen[i] Then
							Local mini_x:Int=5
							Local mini_y:Int=5
							
							For Local o:TOBJEKT=EachIn ANSICHT.group_listen[i]
								If TOBJ_DATA_LEBEND_UNIT(o.data)
									ANSICHT.actual_selected_objects.addlast(o)
									
									TOBJ_DATA_LEBEND_UNIT(o.data).mini_x=mini_x
									TOBJ_DATA_LEBEND_UNIT(o.data).mini_y=mini_y
									
									mini_x:+32
									If mini_x>180 Then
										mini_x=5
										mini_y:+32
										If mini_y>180 Then Exit
									End If
								End If
							Next
						End If
					End If
				End If
			Next
			
		End If
		
	End Function
	
	Function draw_mouse()
		SetColor 255,255,255
		SetAlpha 1.0
		
		DrawImage ANSICHT.act_mouse_image, ANSICHT.mx, ANSICHT.my
	End Function
	
	Function draw_select_rect()
		If ANSICHT.status_rect=1 Then
			ANSICHT.act_mouse_image=ANSICHT.image_mouse_select_rect
			
			SetAlpha 0.3
			SetColor 0,50,0
			
			DrawRect ANSICHT.start_rect_x+ANSICHT.x,ANSICHT.start_rect_y+ANSICHT.y,-ANSICHT.start_rect_x+(ANSICHT.mx-ANSICHT.x),-ANSICHT.start_rect_y+(ANSICHT.my-ANSICHT.y)
			
			SetColor 0,255,0
			SetAlpha 0.5
			DrawRect ANSICHT.start_rect_x+ANSICHT.x,ANSICHT.start_rect_y+ANSICHT.y,-ANSICHT.start_rect_x+(ANSICHT.mx-ANSICHT.x),1
			DrawRect ANSICHT.start_rect_x+ANSICHT.x,ANSICHT.start_rect_y+ANSICHT.y,1,-ANSICHT.start_rect_y+(ANSICHT.my-ANSICHT.y)
			DrawRect ANSICHT.start_rect_x+ANSICHT.x-ANSICHT.start_rect_x+(ANSICHT.mx-ANSICHT.x),ANSICHT.start_rect_y+ANSICHT.y,1,-ANSICHT.start_rect_y+(ANSICHT.my-ANSICHT.y)
			DrawRect ANSICHT.start_rect_x+ANSICHT.x,ANSICHT.start_rect_y+ANSICHT.y-ANSICHT.start_rect_y+(ANSICHT.my-ANSICHT.y),-ANSICHT.start_rect_x+(ANSICHT.mx-ANSICHT.x),1
			
			SetColor 255,255,255
			SetAlpha 1.0
		End If
	End Function
	
	Function get_selected_mini_typ:Int()
		Local mini_typ_list:Int=0
		For Local o2:TOBJEKT=EachIn ANSICHT.actual_selected_objects
			If TOBJ_DATA_LEBEND_UNIT(o2.data) Then
				If mini_typ_list=0 Then
					mini_typ_list=TOBJ_DATA_LEBEND_UNIT(o2.data).mini_typ
				ElseIf mini_typ_list<>TOBJ_DATA_LEBEND_UNIT(o2.data).mini_typ
					mini_typ_list=-1'es sind verschiedene arten dabei
				End If
			End If
		Next
		Return mini_typ_list
	End Function
	
	Function draw_selected_minis()
		If ANSICHT.actual_selected_objects.count()=1 Then
			
			For Local o:TOBJEKT=EachIn ANSICHT.actual_selected_objects
				If TOBJ_DATA_LEBEND_UNIT(o.data) Then
					TOBJ_DATA_LEBEND_UNIT(o.data).draw_maxi(0,200)
				End If
			Next
		Else
			For Local o:TOBJEKT=EachIn ANSICHT.actual_selected_objects'selectete objekte über eigene liste select-zeichnen!!!
				If TOBJ_DATA_LEBEND_UNIT(o.data) Then
					TOBJ_DATA_LEBEND_UNIT(o.data).draw_mini(0,200)
					
					If ANSICHT.mh1 And TOBJ_DATA_LEBEND_UNIT(o.data).klicked_on_mini(0,200) Then
						Local mini_typ_list:Int=ANSICHT.get_selected_mini_typ()
						
						
						
						If mini_typ_list<>-1 Then
							ANSICHT.actual_selected_objects=New TList
							ANSICHT.actual_selected_objects.addlast(o)
						Else
							Local new_list:TList=New TList
							
							For Local o2:TOBJEKT=EachIn ANSICHT.actual_selected_objects
								If TOBJ_DATA_LEBEND_UNIT(o2.data) Then
									If TOBJ_DATA_LEBEND_UNIT(o.data).mini_typ=TOBJ_DATA_LEBEND_UNIT(o2.data).mini_typ Then
										new_list.addlast(o2)
									End If
								End If
							Next
							
							ANSICHT.actual_selected_objects=new_list
						End If
						
					End If
					
					'Self.mini_typ
				End If
			Next
		End If
	End Function
	
	Function draw_mini_options(x:Int,y:Int)
		Select ANSICHT.get_selected_mini_typ()
			Case 1
				SetColor 255,255,255
				DrawText "Soldiers", x+5,y+5
			Case 2
				SetColor 255,255,255
				DrawText "Ameisen", x+5,y+5
			Case 3
				SetColor 255,255,255
				DrawText "Drone", x+5,y+5
				
				DrawText "Press Q to mine", x+5,y+25
				
				If TKEY_INPUT.chat_on=0 And KeyHit(key_q) Then
					Print "mine!!!"
					For Local o:TOBJEKT=EachIn ANSICHT.actual_selected_objects
						NETWORK.UDP_STREAM_OUT.WriteLine("SDM "+o.data.id)
						NETWORK.UDP_STREAM_OUT.SendMsg()
					Next
				End If
				
			Case 4
				SetColor 255,255,255
				DrawText "Base", x+5,y+5
		End Select
	End Function
	
	Function draw_map()
		If TMAPS.map Then
			
			Local x1:Int=(-ANSICHT.x+200)/TFELD.seite
			Local x2:Int=(-ANSICHT.x+ANSICHT.screen_x)/TFELD.seite
			
			Local y1:Int=(-ANSICHT.y)/TFELD.seite
			Local y2:Int=(-ANSICHT.y+ANSICHT.screen_y)/TFELD.seite
			
			If x1<0 Then x1=0
			If x2>TMAPS.map.x-1 Then x2=TMAPS.map.x-1
			
			If y1<0 Then y1=0
			If y2>TMAPS.map.y-1 Then y2=TMAPS.map.y-1
			
			For Local xx:Int=x1 To x2'For Local xx:Int=0 To TMAPS.map.x-1
				For Local yy:Int=y1 To y2'For Local yy:Int=0 To TMAPS.map.y-1
					
					SetColor 255,255,255
					DrawImage TMAPS.map.felder[xx,yy].image,xx*TFELD.seite+ANSICHT.x,yy*TFELD.seite+ANSICHT.y
					
					SetColor 0,0,0
					
					Select TMAPS.map.fog_of_war[xx,yy]
						Case 0
							SetAlpha 0.9
							DrawRect Float(Float(xx)*TFELD.seite+ANSICHT.x),Float(Float(yy)*TFELD.seite+ANSICHT.y),TFELD.seite,TFELD.seite
							SetAlpha 1.0
						Case 1
							SetAlpha 0.7
							DrawRect Float(Float(xx)*TFELD.seite+ANSICHT.x),Float(Float(yy)*TFELD.seite+ANSICHT.y),TFELD.seite,TFELD.seite
							SetAlpha 1.0
						Case 2
							SetAlpha 0.5
							DrawRect Float(Float(xx)*TFELD.seite+ANSICHT.x),Float(Float(yy)*TFELD.seite+ANSICHT.y),TFELD.seite,TFELD.seite
							SetAlpha 1.0
						Case 3
							
					End Select
					
				Next
			Next
		End If
	End Function
	
	Function draw_mini_map(x:Int,y:Int,dx:Int,dy:Int)
		If TMAPS.map Then
			SetViewport x,y,dx,dy
			
			SetColor 255,255,255
			DrawRect x,y,dx,dy
			
			SetColor 0,0,0
			DrawRect x+1,y+1,dx-2,dy-2
			
			Local scale:Float
			
			If TMAPS.map Then
				
				
				If Float(dx-4)/Float(TMAPS.map.x) > Float(dy-4)/Float(TMAPS.map.y) Then
					scale=Float(dy-4)/Float(TMAPS.map.y)
				Else
					scale=Float(dx-4)/Float(TMAPS.map.x)
				End If
				
				
				
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
							Case 5'nix
								SetColor 0,100,255
							Default
								SetColor 255,0,0
						End Select
						
						
						
						DrawRect Float(Float(xx)*(scale)+Float(x+2.0)),Float(Float(yy)*(scale)+Float(y+2.0)),scale,scale
						
						SetColor 0,0,0
						
						Select TMAPS.map.fog_of_war[xx,yy]
							Case 0
								SetAlpha 0.9
								DrawRect Float(Float(xx)*(scale)+Float(x+2.0)),Float(Float(yy)*(scale)+Float(y+2.0)),scale,scale
								SetAlpha 1.0
							Case 1
								SetAlpha 0.7
								DrawRect Float(Float(xx)*(scale)+Float(x+2.0)),Float(Float(yy)*(scale)+Float(y+2.0)),scale,scale
								SetAlpha 1.0
							Case 2
								SetAlpha 0.5
								DrawRect Float(Float(xx)*(scale)+Float(x+2.0)),Float(Float(yy)*(scale)+Float(y+2.0)),scale,scale
								SetAlpha 1.0
							Case 3
								
						End Select
					Next
				Next
				
			End If
			
			SetColor 255,255,255
			
			For Local o:TOBJEKT=EachIn TOBJEKT.liste
				SetAlpha 1.0
				
				Select TMAPS.map.fog_of_war[Int(o.data.x/TFELD.seite),Int(o.data.y/TFELD.seite)]
					Case 0
						Continue
					Case 1
						Continue
					Case 2
						'markieren
						
						SetAlpha 0.5
						
						
					Case 3
						'weitermachen
				End Select
				
				If TPLAYER.get_map(o.data.player_id) Then
					SetColor TPLAYER.get_map(o.data.player_id).color_r,TPLAYER.get_map(o.data.player_id).color_g,TPLAYER.get_map(o.data.player_id).color_b
				Else
					SetColor 255,255,255
				End If
				
				DrawRect Float(Float(o.data.x/TFELD.seite)*(scale)+Float(x+2.0))-0.5*Float(o.data.r/TFELD.seite)*scale*2.0,Float(Float(o.data.y/TFELD.seite)*(scale)+Float(y+2.0))-0.5*Float(o.data.r/TFELD.seite)*scale*2.0,Float(o.data.r/TFELD.seite)*scale*2.0,Float(o.data.r/TFELD.seite)*scale*2.0
				
				'DrawRect o.data.x/TFELD.seite+x,o.data.y/TFELD.seite+y,1,1
				SetAlpha 1.0
			Next
			
			
			SetColor 255,255,255
			DrawRect Float(Float((-ANSICHT.x+200)/TFELD.seite)*(scale)+Float(x+2.0)),Float(Float(-ANSICHT.y/TFELD.seite)*(scale)+Float(y+2.0)),Float(Float((ANSICHT.screen_x-200)/TFELD.seite)*(scale)),1
			DrawRect Float(Float((-ANSICHT.x+200)/TFELD.seite)*(scale)+Float(x+2.0)),Float(Float(-ANSICHT.y/TFELD.seite)*(scale)+Float(y+2.0)),1,Float(Float((ANSICHT.screen_y)/TFELD.seite)*(scale))
			DrawRect Float(Float((-ANSICHT.x+200)/TFELD.seite)*(scale)+Float(x+2.0)),Float(Float(-ANSICHT.y/TFELD.seite)*(scale)+Float(y+2.0))+Float(Float((ANSICHT.screen_y)/TFELD.seite)*(scale)),Float(Float((ANSICHT.screen_x-200)/TFELD.seite)*(scale)),1
			DrawRect Float(Float((-ANSICHT.x+200)/TFELD.seite)*(scale)+Float(x+2.0))+Float(Float((ANSICHT.screen_x-200)/TFELD.seite)*(scale)),Float(Float(-ANSICHT.y/TFELD.seite)*(scale)+Float(y+2.0)),1,Float(Float((ANSICHT.screen_y)/TFELD.seite)*(scale))
			
			SetViewport 0,0,ANSICHT.screen_x,ANSICHT.screen_y
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
		'CHAT.addline(txt, TLOCAL_PLAYER.id)
		
		If Mid(txt,1,1)="#" Then'team
			NETWORK.SERVER_TCP_STREAM.WriteLine("CHT "+TLOCAL_PLAYER.id+" 1 "+Mid(txt,2,-1))
			While NETWORK.SERVER_TCP_STREAM.SendMsg() ; Wend
		Else'all
			NETWORK.SERVER_TCP_STREAM.WriteLine("CHT "+TLOCAL_PLAYER.id+" 0 "+txt)
			While NETWORK.SERVER_TCP_STREAM.SendMsg() ; Wend
		End If
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

'INI

NETWORK.connect_to_host(Input("IP> "), 40000, Input("nickname> "))
NETWORK.INI_UDP_IN()

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

'TOBJ_DATA_SOLDIER.ini()
TWAYPOINT.ini()
TANIM_BLEND_BLUT.ini()
TANIM_BLEND_SCHUSS.ini()

TPLAYER.liste=New TList
TPLAYER.map=New TMap

TOBJEKT.liste=New TList
TOBJEKT.map=New TMap

ANSICHT.actual_selected_objects=New TList

TANIM.liste1=New TList
TANIM.liste2=New TList
TANIM.liste3=New TList

'HAUPTSCHLEIFE

Local fog_anz:Int=10
Local time_fog:Int=MilliSecs()

HideMouse()

Repeat
	Cls
	
	'RENDER
	TKEY_INPUT.render()
	NETWORK.render()
	ANSICHT.render()
	TOBJEKT.render_all()
	
	If TKEY_INPUT.chat_on=0 And KeyHit(key_n) Then
		
		NETWORK.UDP_STREAM_OUT.WriteLine("SAO "+String(ANSICHT.mx-ANSICHT.x)+" "+String(ANSICHT.my-ANSICHT.y)+" soldier")
		NETWORK.UDP_STREAM_OUT.SendMsg()
		
	End If
	
	If TKEY_INPUT.chat_on=0 And KeyHit(key_b) Then
		
		NETWORK.UDP_STREAM_OUT.WriteLine("SAO "+String(ANSICHT.mx-ANSICHT.x)+" "+String(ANSICHT.my-ANSICHT.y)+" ameise")
		NETWORK.UDP_STREAM_OUT.SendMsg()
		
	End If
	
	
	If TKEY_INPUT.chat_on=0 And KeyHit(key_m) Then
		
		NETWORK.UDP_STREAM_OUT.WriteLine("SAO "+String(ANSICHT.mx-ANSICHT.x)+" "+String(ANSICHT.my-ANSICHT.y)+" stone")
		NETWORK.UDP_STREAM_OUT.SendMsg()
		
	End If
	
	If TKEY_INPUT.chat_on=0 And KeyHit(key_l) Then
		
		NETWORK.UDP_STREAM_OUT.WriteLine("SAO "+String(ANSICHT.mx-ANSICHT.x)+" "+String(ANSICHT.my-ANSICHT.y)+" mineral")
		NETWORK.UDP_STREAM_OUT.SendMsg()
		
	End If
	
	If TKEY_INPUT.chat_on=0 And KeyHit(key_k) Then
		
		NETWORK.UDP_STREAM_OUT.WriteLine("SAO "+String(ANSICHT.mx-ANSICHT.x)+" "+String(ANSICHT.my-ANSICHT.y)+" drone")
		NETWORK.UDP_STREAM_OUT.SendMsg()
		
	End If
	
	If TKEY_INPUT.chat_on=0 And KeyHit(key_j) Then
		
		NETWORK.UDP_STREAM_OUT.WriteLine("SAO "+String(ANSICHT.mx-ANSICHT.x)+" "+String(ANSICHT.my-ANSICHT.y)+" base")
		NETWORK.UDP_STREAM_OUT.SendMsg()
		
	End If
	
	If TKEY_INPUT.chat_on=0 And KeyHit(key_t) Then
		For Local o:TOBJEKT=EachIn ANSICHT.actual_selected_objects
			NETWORK.UDP_STREAM_OUT.WriteLine("STP "+o.data.id)
			NETWORK.UDP_STREAM_OUT.SendMsg()
		Next
	End If
	
	If ANSICHT.mx>200 Then
		If ANSICHT.actual_selected_objects.count()>0 Then
			For Local o:TOBJEKT=EachIn TOBJEKT.liste
				If (o.data.x-(ANSICHT.mx-ANSICHT.x))^2+(o.data.y-(ANSICHT.my-ANSICHT.y))^2<=(o.data.r)^2 Then
					If TOBJ_DATA_LEBEND(o.data) Then
						ANSICHT.act_mouse_image=ANSICHT.image_mouse_attack
						Exit
					End If
				End If
			Next
		End If
	End If
	
	If ANSICHT.mh2 And ANSICHT.mx>200 Then
		Local anz:Int=ANSICHT.actual_selected_objects.count()
		
		'checken ob nicht eine einheit da:
		
		Local attack_unit_id:Int=0
		
		For Local o:TOBJEKT=EachIn TOBJEKT.liste
			If (o.data.x-(ANSICHT.mx-ANSICHT.x))^2+(o.data.y-(ANSICHT.my-ANSICHT.y))^2<=(o.data.r)^2 Then
				If TOBJ_DATA_LEBEND(o.data) Then
					attack_unit_id=o.data.id
				End If
			End If
		Next
		
		If attack_unit_id<>0 Then
			
			For Local o:TOBJEKT=EachIn ANSICHT.actual_selected_objects'falls nicht in sichtweite hinlaufen!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				
				If o.data.id<>attack_unit_id Then
					NETWORK.UDP_STREAM_OUT.WriteLine("ATC "+o.data.id+" "+attack_unit_id)
					NETWORK.UDP_STREAM_OUT.SendMsg()
				End If
				
			Next
		Else
			If ANSICHT.kd_lcontrol Then
				For Local o:TOBJEKT=EachIn ANSICHT.actual_selected_objects
					
					NETWORK.UDP_STREAM_OUT.WriteLine("AWP "+o.data.id+" "+String(ANSICHT.mx-ANSICHT.x)+" "+String(ANSICHT.my-ANSICHT.y)+" "+String(10+(anz*2)))
					NETWORK.UDP_STREAM_OUT.SendMsg()
					
				Next
			Else
				For Local o:TOBJEKT=EachIn ANSICHT.actual_selected_objects
					
					NETWORK.UDP_STREAM_OUT.WriteLine("SOT "+o.data.id+" "+String(ANSICHT.mx-ANSICHT.x)+" "+String(ANSICHT.my-ANSICHT.y)+" "+String(10+(anz*2)))
					NETWORK.UDP_STREAM_OUT.SendMsg()
					
				Next
			End If
		End If
	End If
	
	If ANSICHT.mh2 And ANSICHT.mx<200 And ANSICHT.my<200 Then'TMAPS.map.mini_map_scale
		Local anz:Int=ANSICHT.actual_selected_objects.count()
		
		
		If ANSICHT.kd_lcontrol Then
			For Local o:TOBJEKT=EachIn ANSICHT.actual_selected_objects
				
				NETWORK.UDP_STREAM_OUT.WriteLine("AWP "+o.data.id+" "+String((ANSICHT.mx-2)/TMAPS.map.mini_map_scale*TFELD.seite)+" "+String((ANSICHT.my-2)/TMAPS.map.mini_map_scale*TFELD.seite)+" "+String(10+(anz*2)))
				NETWORK.UDP_STREAM_OUT.SendMsg()
				
			Next
		Else
			For Local o:TOBJEKT=EachIn ANSICHT.actual_selected_objects
				
				NETWORK.UDP_STREAM_OUT.WriteLine("SOT "+o.data.id+" "+String((ANSICHT.mx-2)/TMAPS.map.mini_map_scale*TFELD.seite)+" "+String((ANSICHT.my-2)/TMAPS.map.mini_map_scale*TFELD.seite)+" "+String(10+(anz*2)))
				NETWORK.UDP_STREAM_OUT.SendMsg()
				
			Next
		End If
	End If
	
	If TMAPS.map Then
		
		time_fog=MilliSecs()
		TMAPS.map.render_for_of_war(fog_anz)
		time_fog=MilliSecs()-time_fog
		
		fog_anz:+MouseZSpeed()*10
		
		If fog_anz<10 Then fog_anz=10
	End If
	
	'DRAW
	ANSICHT.draw_map()
	
	TOBJEKT.draw_all()
	
	ANSICHT.draw_select_rect()
	
	SetColor 50,50,50
	DrawRect 0,0,200,ANSICHT.screen_y
	SetColor 200,200,200
	DrawRect 198,0,2,ANSICHT.screen_y
	
	ANSICHT.draw_mini_map(0,0,200,200)
	
	ANSICHT.draw_selected_minis()
	
	SetColor 255,255,255
	DrawRect 0,400,200,1
	
	ANSICHT.draw_mini_options(0,400)
	
	CHAT.draw(220,ANSICHT.screen_y-230)
	
	Local i:Int=0
	For Local p:TPLAYER=EachIn TPLAYER.liste
		'genannt
		SetColor p.color_r,p.color_g,p.color_b
		DrawText p.ID+" "+p.name+" "+p.typ+" "+p.team_id+" "+p.genannt+" m:"+p.minerals, 220,10+30*i
		
		i:+1
	Next
	
	SetColor 255,255,255
	
	DrawText fog_anz+"/"+(time_fog*FPS.last_count/10),200,0
	FPS.render()
	DrawText FPS.last_count,200,20
	
	ANSICHT.draw_mouse()
	
	Flip
Until KeyHit(key_escape)

ShowMouse()
End