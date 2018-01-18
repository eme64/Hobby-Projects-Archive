SuperStrict

'IDEAS:
'
'drone ability slots
'
'enemies -> check if navigation is proper, if can move to all room with algorythm, draw in map for check
'motion / sensor
'
'
'interface
'special function accessible over interface (defence, teleporter, ...)

'Import "-ldl"
Import "lights.bmx"

'########################################################################################
'###########################              ###############################################
'###########################    GAME      ###############################################
'###########################              ###############################################
'########################################################################################

Type GAME
	Global level:TLevel
	
	Global tiles:TImage[]
	Global tiles_small:TImage[]
	Global tile_number:Int = 16
	Global tile_side:Int = 128
	Global tile_side_small:Int = 32
	
	Function ini()
		GAME.tiles = New TImage[GAME.tile_number]
		GAME.tiles_small = New TImage[GAME.tile_number]
		
		For Local i:Int = 0 To GAME.tile_number-1
			GAME.tiles[i] = ImageLoader.Load("tiles\" + i + ".png", GAME.tile_side, GAME.tile_side)
			GAME.tiles_small[i] = ImageLoader.Load("tiles\small\" + i + ".png", GAME.tile_side_small, GAME.tile_side_small)
		Next
	End Function
	
	Function run()
		'load level
		
		GAME.level = TLevel.Create()
		
		'run level
		
		GAME.level.run()
		
	End Function
	
End Type


'########################################################################################
'###########################              ###############################################
'########################### Image Loader ###############################################
'###########################              ###############################################
'########################################################################################

Type ImageLoader
	Function Load:TImage(path:String,x:Int,y:Int)
		Local image:TImage = LoadImage(path)'loading image
		
		If Not image Then
			GAME_ERROR_HANDLER.error("ImageLoader -> image could not be loaded! " + path)
			Return Null
		End If
		
		If image.width >= 2*x Then'loading if anim image
			image = LoadAnimImage(path, x, y, 0, image.width/x)
		End If
		
		If Not image Then'check again
			GAME_ERROR_HANDLER.error("ImageLoader -> anim-image could not be loaded! " + path)
			Return Null
		End If
		
		Return image
	End Function
End Type

'########################################################################################
'###########################       ######################################################
'########################### LEVEL ######################################################
'###########################       ######################################################
'########################################################################################

Type TLevel
	'blocks
	Field table_x:Int
	Field table_y:Int
	
	Field table:TBlock[table_x, table_y]
	
	'To toggle Map-view or narmal-view
	Field draw_map:Int = 0
	Field map_offset_x:Int = 0
	Field map_offset_y:Int = 0
	
	'objects
	Field objects:TList
	
	Field active_player:TPlayer
	
	Method set_active_player(id:Int)
		' does exist?
		
		Local new_active:TPlayer
		
		For Local p:TPlayer= EachIn Self.objects
			If p.id = id Then new_active = p
		Next
		
		' set
		If new_active Then
			active_player = new_active
		Else
			'rint "does not exist"
		EndIf
		
	End Method
	
	Method get_player:TPlayer(id:Int)
		For Local p:TPlayer= EachIn Self.objects
			If p.id = id Then Return p
		Next
	End Method
	
	'numbering doors, rooms, airlocks ...
	Field door_counter:Int = 0
	Field airlock_counter:Int = 0
	Field room_counter:Int = 1
	
	Method next_door_id:Int()
		door_counter:+1
		Return door_counter
	End Method
	
	Method next_airlock_id:Int()
		airlock_counter:+1
		Return airlock_counter
	End Method
	
	Method next_room_id:Int()
		room_counter:+1
		Return room_counter
	End Method
	
	'ansicht
	Field ansicht_act_x:Int
	Field ansicht_act_y:Int
	
	Field ansicht_ziel_x:Int
	Field ansicht_ziel_y:Int
	
	Method get_ansicht_d:Float()
		Return ((Self.ansicht_act_x-Self.ansicht_ziel_x)^2+(Self.ansicht_act_y-Self.ansicht_ziel_y)^2)^0.5
	End Method
	
	'Lights - Brightness
	Field lights_on:Int = 1
	Field brightness_r:Int = 0
	Field brightness_g:Int = 0
	Field brightness_b:Int = 0
	
	Method set_brightness(r:Int,g:Int,b:Int)
		Self.brightness_r = r
		Self.brightness_g = g
		Self.brightness_b = b
		
		If Self.brightness_r = 255 And Self.brightness_g = 255 And Self.brightness_b = 255 Then
			Self.lights_on = 0
		Else
			Self.lights_on = 1
		End If
		
	End Method
	
	Field blocks:TBlock[]
	Field rooms:TList
	Field room_items:TList
	
	
	
	Method get_power_inlet:TRoom_Item_Power_Inlet(room_id:Int)
		For Local a:TRoom_Item_Power_Inlet = EachIn Self.room_items
			If a.room.id = room_id Then Return a
		Next
	End Method
	
	Method get_airlock:TRoom_Item_Airlock(id:Int)
		For Local a:TRoom_Item_Airlock = EachIn Self.room_items
			If a.id = id Then Return a
		Next
	End Method
	
	Method get_airlock_from_xy:TRoom_Item_Airlock(x:Int,y:Int)
		For Local a:TRoom_Item_Airlock = EachIn Self.room_items
			If a.x = x And a.y = y Then Return a
		Next
	End Method
	
	Method get_door_from_xy:TRoom_Item_Door(x:Int,y:Int)
		For Local a:TRoom_Item_Door = EachIn Self.room_items
			If a.x = x And a.y = y Then Return a
		Next
	End Method
	
	Method get_door:TRoom_Item_Door(id:Int)
		For Local a:TRoom_Item_Door = EachIn Self.room_items
			If a.id = id Then Return a
		Next
	End Method
	
	Method get_room:LEVEL_GENERATOR_ROOM(id:Int)
		For Local r:LEVEL_GENERATOR_ROOM = EachIn Self.rooms
			If r.id = id Then Return r
		Next
	End Method
	
	Method get_door_from_rooms:TRoom_Item_Door(r1:LEVEL_GENERATOR_ROOM, r2:LEVEL_GENERATOR_ROOM)
		For Local i:TRoom_Item_Door = EachIn room_items
			If i.links_rooms(r1, r2) Then Return i
		Next
	End Method
	
	Field console:CONSOLE
	
	Function Create:TLevel()
		Local l:TLevel = New TLevel
		
		GAME.level = l
		
		l.console = CONSOLE.Create(Graphics_Handler.x-600, Graphics_Handler.y-800,600,800)
		
		'--- rethinking the level-generation:
		'
		' 1) generate rooms
		' 2) connect to all possible neighbours with doors
		' 3) put in other items
		'
		'
		' ---- codes:
		' -1 space
		' 0 Default - error
		' 1 room
		' 2 wall
		' 3 door
		' 4 airlock
		' 6 power inlet
		
		Local lvlgen:LEVEL_GENERATOR = LEVEL_GENERATOR.Create(5,5)
		
		l.rooms = lvlgen.room_list
		l.room_items = lvlgen.room_items
		
		l.table_x = lvlgen.dx
		l.table_y = lvlgen.dy
		
		l.table = New TBlock[l.table_x, l.table_y]
		
		l.objects = New TList
		
		'fill table
		
		Local first_airlock_x:Int = 0
		Local first_airlock_y:Int = 0
		
		l.blocks = New TBlock[7]
		
		l.blocks[0] = TBlock.Create(1, 1, 1, 0)'wall
		l.blocks[1] = TBlock.Create(0, 0, 2, 0)'room
		l.blocks[2] = TBlock.Create(0, 0, 3, 0)'corridor
		l.blocks[3] = TBlock.Create(1, 0, 7, 6)'door
		l.blocks[4] = TBlock.Create(1, 0, 7, 6)'airlock
		l.blocks[5] = TBlock.Create(0, 0, 8, 0)'space
		l.blocks[6] = TBlock.Create(0, 0, 15, 14)'room - power inlet
		
		For Local x:Int = 0 To l.table_x-1
			For Local y:Int = 0 To l.table_y-1
				If x = 0 Or x = l.table_x-1 Or y = 0 Or y = l.table_y-1 Then
					l.table[x,y] = l.blocks[0].copy()'wall
					l.table[x,y].obj_type = 0
				ElseIf x < 4 Or x > l.table_x-5 Or y < 4 Or y > l.table_y-5 Then
					l.table[x,y] = l.blocks[5].copy()'space
					l.table[x,y].obj_type = 5
				Else
					Select lvlgen.grid[x,y]
						Case 1'room
							l.table[x,y] = l.blocks[1].copy()
							l.table[x,y].obj_type = 1
						Case 3,4'door - airlock
							
							If x = 4 Or x = l.table_x-5 Or y = 4 Or y = l.table_y-5 Then
								l.table[x,y] = l.blocks[4].copy()
								l.table[x,y].obj_type = 3 ' AIRLOCK
																
								If first_airlock_x = 0 Or Rand(0,10) = 1 Then
									first_airlock_x = x
									first_airlock_y = y
								EndIf
								
								If l.get_airlock_from_xy(x,y).updown Then
									l.table[x,y].taco_image_number = 9
								Else
									l.table[x,y].taco_image_number = 10
								EndIf
							Else
								l.table[x,y] = l.blocks[3].copy()
								l.table[x,y].obj_type = 2 ' DOOR
								
								If l.get_door_from_xy(x,y).updown Then
									l.table[x,y].taco_image_number = 9
								Else
									l.table[x,y].taco_image_number = 10
								EndIf
							EndIf
						Case 6' power inlet
							l.table[x,y] = l.blocks[6].copy()
							l.table[x,y].obj_type = 1
						Default
							l.table[x,y] = l.blocks[0].copy()
					End Select
				EndIf
				
				l.table[x,y].obj_id = lvlgen.grid_info[x,y]
			Next
		Next
		
			
		'docking procedure
		If first_airlock_x = 0 Then Print "no airlock found, this should not happen, coding error!"
		Local docking_room_xy:Int[] = l.build_docking_at(first_airlock_x,first_airlock_y)
		
		'add objects
		
		TPlayer.Create(docking_room_xy[0]*GAME.tile_side,docking_room_xy[1]*GAME.tile_side,l, 1, "Alpha")
		TPlayer.Create(docking_room_xy[0]*GAME.tile_side,docking_room_xy[1]*GAME.tile_side,l, 2, "Bravo")
		TPlayer.Create(docking_room_xy[0]*GAME.tile_side,docking_room_xy[1]*GAME.tile_side,l, 3, "Charlie")
		TPlayer.Create(docking_room_xy[0]*GAME.tile_side,docking_room_xy[1]*GAME.tile_side,l, 4, "Delta")
		
		TEnemy.Create(docking_room_xy[0]*GAME.tile_side,docking_room_xy[1]*GAME.tile_side,l)
		TEnemy.Create(docking_room_xy[0]*GAME.tile_side,docking_room_xy[1]*GAME.tile_side,l)
		
		Rem
		For Local i:Int = 1 To 10
			TLamp.Create(Rand(100, l.table_x*GAME.tile_side-100),Rand(100, l.table_y*GAME.tile_side-100),[Rand(255),Rand(255),Rand(255)],TLight.source_treasure,l)
		Next
		End Rem
		
		l.redo_powered_status()
		
		Return l
	End Function
	
	
	Method run:Int()
		'##########################################################################################
		'################################       MAIN LOOP          ################################
		'##########################################################################################
		
		Repeat
			'############## RENDER ###############
			KeyboardInput.render()
			
			Self.render()
			
			'################ DRAW Level #########
			
			Self.draw()
			
			
			'################ FLIP ##########
			Rem
			SetColor 255,255,255
			DrawText KeyboardInput.text, 10,100
			DrawText KeyboardInput.numb, 10,150
			DrawText KeyboardInput.command_to_execute, 10,200
			End Rem
			
			DrawText TLight.frame_rendered, 10,10
			TLight.frame_rendered = 0
			
			Flip
			
		Until KeyHit(key_escape) Or AppTerminate()
		
		'##########################################################################################
		'################################    END OF MAIN LOOP      ################################
		'##########################################################################################
		
	End Method
	
	
	Method goto_ansicht_ziel()
		Self.ansicht_act_x = Self.ansicht_ziel_x
		Self.ansicht_act_y = Self.ansicht_ziel_y
	End Method
	
	Method render()
		If Self.ansicht_ziel_x > 0 Then'x
			Self.ansicht_ziel_x = 0
		End If
		
		If Self.ansicht_act_x > 0 Then
			Self.ansicht_act_x = 0
		End If
		
		If Self.ansicht_ziel_y > 0 Then'y
			Self.ansicht_ziel_y = 0
		End If
		
		If Self.ansicht_act_y > 0 Then
			Self.ansicht_act_y = 0
		End If
		
		If Self.ansicht_ziel_x < - GAME.level.table_x*GAME.tile_side + Graphics_Handler.x Then'x
			Self.ansicht_ziel_x = - GAME.level.table_x*GAME.tile_side + Graphics_Handler.x
		End If
		
		If Self.ansicht_act_x < - GAME.level.table_x*GAME.tile_side + Graphics_Handler.x Then
			Self.ansicht_act_x = - GAME.level.table_x*GAME.tile_side + Graphics_Handler.x
		End If
		
		If Self.ansicht_ziel_y < - GAME.level.table_y*GAME.tile_side + Graphics_Handler.y Then'y
			Self.ansicht_ziel_y = - GAME.level.table_y*GAME.tile_side + Graphics_Handler.y
		End If
		
		If Self.ansicht_act_y < - GAME.level.table_y*GAME.tile_side + Graphics_Handler.y Then
			Self.ansicht_act_y = - GAME.level.table_y*GAME.tile_side + Graphics_Handler.y
		End If
		
		Local ver_x:Float = (Float(Self.ansicht_act_x) - Float(Self.ansicht_ziel_x))*0.1
		Local ver_y:Float = (Float(Self.ansicht_act_y) - Float(Self.ansicht_ziel_y))*0.1
		
		Self.ansicht_act_x:- ver_x
		Self.ansicht_act_y:- ver_y
		
		Self.render_tiles()
		
		For Local o:TObject = EachIn Self.objects
			o.render()
		Next
		
		
		For Local i:TRoom_Item = EachIn Self.room_items
			i.render()
		Next
		' do not switch top and down !!!
		For Local r:LEVEL_GENERATOR_ROOM = EachIn Self.rooms
			r.render()
		Next
		
		console.render()
	End Method
	
	Method draw()
		SetClsColor 0,0,0
		Cls
		SetColor 255,255,255
		
		'Change from normal view to map view and back
		If KeyHit(key_tab) Then Self.draw_map = 1 - Self.draw_map
		
		If Self.draw_map Then
			SetImageFont Graphics_Handler.font_15
			
			Self.draw_bg_small()
			
			For Local o:TObject = EachIn Self.objects
				o.draw_small()
			Next
			
			Self.draw_fg_small()
			
			For Local o:TObject = EachIn Self.objects
				o.draw_taco_small()
			Next
			
			Self.draw_taco_small()
			
			SetImageFont Graphics_Handler.font_30
		Else
			
			Self.draw_bg()
			
			For Local o:TObject = EachIn Self.objects
				o.draw()
			Next
			
			Self.draw_fg()
			
			' DRAW LIGHTS
			If KeyHit(KEY_LCONTROL) Then GAME.level.lights_on = 1-GAME.level.lights_on
			
			SetBlend shadeblend
			SetColor 255,255,255
			If GAME.level.lights_on Then TBuffer.light_mix.draw(0,0)
			SetBlend alphablend
			TBuffer.light_mix.cls_me(Self.brightness_r/255.0,Self.brightness_g/255.0,Self.brightness_b/255.0)
			
			' Tactical overlay - taco
			For Local o:TObject = EachIn Self.objects
				o.draw_taco()
			Next
			
			Self.draw_taco()
		EndIf
		
		Rem
		'draw room chart
		SetImageFont Graphics_Handler.font_15
		SetColor 255,0,255
		
		Local i:Int = 0
		For Local r:LEVEL_GENERATOR_ROOM = EachIn Self.rooms
			i=i+1
			Draw_Text r.id, 10, 150+20*i
			Draw_Text r.algo_n, 60, 150+20*i
		Next
		
		SetImageFont Graphics_Handler.font_30
		End Rem
		
		console.draw()
	End Method
	
	Method distance_algo_get_closest_open:LEVEL_GENERATOR_ROOM(room:LEVEL_GENERATOR_ROOM)
		'finds room with lowest number <> 0
		Local result:LEVEL_GENERATOR_ROOM
		
		For Local r:LEVEL_GENERATOR_ROOM = EachIn room.neighbours
			If r <> room Then
				If r.algo_n > 0 Then
					If result Then
						If r.algo_n < result.algo_n Then
							'check if door open
							Local d:TRoom_Item_Door = Self.get_door_from_rooms(room, r)
							
							If d Then
								If d.open() Then result = r
							Else
								'check for airlock
								Local airlock:TRoom_Item_Airlock = Self.get_airlock_from_xy(Self.docking_x,Self.docking_y)
								
								If airlock.open() Then result = r
							EndIf
						EndIf
					Else
						Local d:TRoom_Item_Door = Self.get_door_from_rooms(room, r)
						
						If d Then
							If d.open() Then result = r
						Else
							'check for airlock
							Local airlock:TRoom_Item_Airlock = Self.get_airlock_from_xy(Self.docking_x,Self.docking_y)
							
							If airlock.open() Then result = r
						EndIf
					EndIf
				EndIf
			EndIf
		Next
		
		Return result
	End Method
	
	Method distance_algo(room:LEVEL_GENERATOR_ROOM)
		' - - idea:
		'reset all numbers
		'start with room -> 1
		'repeat loop and mark neighbours if not yet marked with +1
		
		
		For Local r:LEVEL_GENERATOR_ROOM = EachIn Self.rooms' - reset algo_n
			r.algo_n = 0
		Next
		
		room.algo_n = 1' - start with room -> 1
		
		Local action:Int = 0
		Local count:Int = 1
		
		If room.id = 1 Then'dock room special case
			count = 2
			
			If Self.table[docking_x,docking_y].obj_id > 0 And Self.get_airlock_from_xy(docking_x,docking_y).open() Then
				Local a:TRoom_Item_Airlock = Self.get_airlock(Self.table[docking_x,docking_y].obj_id)
				If a Then
					a.room.algo_n = 2
				EndIf
			End If
		EndIf
		
		Repeat
			action = 0
			
			For Local r:LEVEL_GENERATOR_ROOM = EachIn Self.rooms
				If r.algo_n = 0 And r.id <> -1 Then
					' a not yet marked and available room
					For Local n:LEVEL_GENERATOR_ROOM = EachIn r.neighbours
						If n <> r And n.algo_n = count
							
							Local d:TRoom_Item_Door = Self.get_door_from_rooms(r,n)
							
							If Not d Then
								'rint "not found door: " + r.id + " " + n.id
							Else
								If d.open() Then
									r.algo_n = count+1
									action = 1
									
									'rint "added r" + r.id
								EndIf
							EndIf
						EndIf
					Next
				EndIf
			Next
			
			count:+1
		Until action = 0
		
	EndMethod
	
	Method draw_bg()
		
		Local x1:Int = 0
		Local x2:Int = Self.table_x - 1
		
		If x1 < (0 - GAME.level.ansicht_act_x)/GAME.tile_side Then
			x1 = (0 - GAME.level.ansicht_act_x)/GAME.tile_side
		End If
		
		If x2 > (Graphics_Handler.x - GAME.level.ansicht_act_x)/GAME.tile_side Then
			x2 = (Graphics_Handler.x - GAME.level.ansicht_act_x)/GAME.tile_side
		End If
		
		Local y1:Int = 0
		Local y2:Int = Self.table_y - 1
		
		If y1 < (0 - GAME.level.ansicht_act_y)/GAME.tile_side Then
			y1 = (0 - GAME.level.ansicht_act_y)/GAME.tile_side
		End If
		
		If y2 > (Graphics_Handler.y - GAME.level.ansicht_act_y)/GAME.tile_side Then
			y2 = (Graphics_Handler.y - GAME.level.ansicht_act_y)/GAME.tile_side
		End If
		
		For Local x:Int = x1 To x2
			For Local y:Int = y1 To y2
				
				table[x,y].block_draw(x*GAME.tile_side + Self.ansicht_act_x, y*GAME.tile_side + Self.ansicht_act_y, table[x,y].bg_image_number, table[x,y].bg_frame)
				
			Next
		Next
		
	End Method
	
	Method draw_bg_small()
				
		For Local x:Int = 0 To Self.table_x - 1
			For Local y:Int = 0 To Self.table_y - 1
				
				If table[x,y].visible > 0 Then
					table[x,y].block_draw_small(x*GAME.tile_side_small + Self.map_offset_x, y*GAME.tile_side_small + Self.map_offset_y, table[x,y].bg_image_number)
				EndIf
			Next
		Next
		
	End Method
	
	Method draw_fg()
		
		Local x1:Int = 0
		Local x2:Int = Self.table_x - 1
		
		If x1 < (0 - GAME.level.ansicht_act_x)/GAME.tile_side Then
			x1 = (0 - GAME.level.ansicht_act_x)/GAME.tile_side
		End If
		
		If x2 > (Graphics_Handler.x - GAME.level.ansicht_act_x)/GAME.tile_side Then
			x2 = (Graphics_Handler.x - GAME.level.ansicht_act_x)/GAME.tile_side
		End If
		
		Local y1:Int = 0
		Local y2:Int = Self.table_y - 1
		
		If y1 < (0 - GAME.level.ansicht_act_y)/GAME.tile_side Then
			y1 = (0 - GAME.level.ansicht_act_y)/GAME.tile_side
		End If
		
		If y2 > (Graphics_Handler.y - GAME.level.ansicht_act_y)/GAME.tile_side Then
			y2 = (Graphics_Handler.y - GAME.level.ansicht_act_y)/GAME.tile_side
		End If
		
		For Local x:Int = x1 To x2
			For Local y:Int = y1 To y2
				
				table[x,y].block_draw(x*GAME.tile_side + Self.ansicht_act_x, y*GAME.tile_side + Self.ansicht_act_y, table[x,y].fg_image_number, table[x,y].fg_frame)
				
			Next
		Next
		
	End Method
	
	Method draw_fg_small()
				
		For Local x:Int = 0 To Self.table_x - 1
			For Local y:Int = 0 To Self.table_y - 1
				
				If table[x,y].visible > 0 Then
					table[x,y].block_draw_small(x*GAME.tile_side_small + Self.map_offset_x, y*GAME.tile_side_small + Self.map_offset_y, table[x,y].fg_image_number)
				EndIf
			Next
		Next
		
	End Method

	
	Method draw_taco()
		
		Local x1:Int = 0
		Local x2:Int = Self.table_x - 1
		
		If x1 < (0 - GAME.level.ansicht_act_x)/GAME.tile_side Then
			x1 = (0 - GAME.level.ansicht_act_x)/GAME.tile_side
		End If
		
		If x2 > (Graphics_Handler.x - GAME.level.ansicht_act_x)/GAME.tile_side Then
			x2 = (Graphics_Handler.x - GAME.level.ansicht_act_x)/GAME.tile_side
		End If
		
		Local y1:Int = 0
		Local y2:Int = Self.table_y - 1
		
		If y1 < (0 - GAME.level.ansicht_act_y)/GAME.tile_side Then
			y1 = (0 - GAME.level.ansicht_act_y)/GAME.tile_side
		End If
		
		If y2 > (Graphics_Handler.y - GAME.level.ansicht_act_y)/GAME.tile_side Then
			y2 = (Graphics_Handler.y - GAME.level.ansicht_act_y)/GAME.tile_side
		End If
		
		For Local x:Int = x1 To x2
			For Local y:Int = y1 To y2
				
				Local c_up:Int = 0
				Local c_down:Int = 0
				Local c_left:Int = 0
				Local c_right:Int = 0
				
				If y>0 Then c_up = table[x,y-1].collision
				If x>0 Then c_left = table[x-1,y].collision
				
				If y<Self.table_y-1 Then c_down = table[x,y+1].collision
				If x<Self.table_x-1 Then c_right = table[x+1,y].collision
				
				table[x,y].block_draw_taco(x*GAME.tile_side + Self.ansicht_act_x, y*GAME.tile_side + Self.ansicht_act_y, c_up, c_down, c_left, c_right)
				
			Next
		Next
		
	End Method
	
	Method draw_taco_small()
				
		For Local x:Int = 0 To Self.table_x - 1
			For Local y:Int = 0 To Self.table_y - 1
				
				If table[x,y].visible > 0 Then
					Local c_up:Int = 0
					Local c_down:Int = 0
					Local c_left:Int = 0
					Local c_right:Int = 0
					
					If y>0 Then c_up = table[x,y-1].collision
					If x>0 Then c_left = table[x-1,y].collision
					
					If y<Self.table_y-1 Then c_down = table[x,y+1].collision
					If x<Self.table_x-1 Then c_right = table[x+1,y].collision
					
					table[x,y].block_draw_taco_small(x*GAME.tile_side_small + Self.map_offset_x, y*GAME.tile_side_small + Self.map_offset_y, c_up, c_down, c_left, c_right)
				EndIf
			Next
		Next
		
	End Method
	
	Method render_tiles_commands()
		Local cmd:String = KeyboardInput.command_to_execute
		
		KeyboardInput.command_to_execute = ""
		
		While cmd <> ""
			'CMD PARSEN
			'idee: erstes wort abtrennen und überprüfen
			
			Local pos:Int = Instr(cmd," ")
			Local pre:String = Mid(cmd,1,pos-1)
			Local post:String = Mid(cmd,pos+1,-1)
			
			If pos = 0 Then post = ""
			
			Select pre
				Case "dock"
					cmd = ""
					If Mid(post, 1,1) = "a" Then
						Local id:Int = Int(Mid(post, 2,-1))
						Local coords:Int[] = get_airlock_xy(id)
						
						If coords.length > 1 Then
							Self.console.put("")
							Self.console.put("%green%REDOCK-PROCEDURE...")
							Self.console.put("%grey%closing down old airlock")
							Self.console.put("%grey%docking to new airlock")
							Self.console.put("%white%done.")
							Self.console.put("")
							
							'close current airlock
							close_door_airlock(docking_x,docking_y)
							
							'knock old down
							destroy_dock()
							
							'create teleport list
							Local teleport_list:TList = New TList
							
							For Local o:TObject = EachIn Self.objects
								If o.x > (docking_center_x-1)*GAME.tile_side And o.y > (docking_center_y-1)*GAME.tile_side And o.x < (docking_center_x+2)*GAME.tile_side And o.y < (docking_center_y+2)*GAME.tile_side Then
									teleport_list.addlast(o)
								End If
							Next
							
							Local old_c_x:Int = docking_center_x
							Local old_c_y:Int = docking_center_y
							
							'build up new room
							Local docking_room_xy:Int[] = build_docking_at(coords[0], coords[1])
							
							'teleport all objects
							For Local o:TObject = EachIn teleport_list
								o.x :+ (docking_room_xy[0] - old_c_x)*GAME.tile_side
								o.y :+ (docking_room_xy[1] - old_c_y)*GAME.tile_side
							Next
							
							Self.redo_powered_status()
						Else
							'rint "a-dock *" + id + "* not found!"
							Self.console.put("%red%a-dock *" + id + "* not found!")
						EndIf
					Else
						'rint "can't dock at *" + post + "*"
						Self.console.put("%red%can't dock at *" + post + "*")
					EndIf
				
				Case "remote", "r"
					cmd = ""
					If Mid(post, 1,1) = "r" Then
						Local id:Int = Int(Mid(post, 2,-1))
						Local inlet:TRoom_Item_Power_Inlet = get_power_inlet(id)
						
						If inlet Then
							Self.remote_power(inlet)
						Else
							Self.console.put("%red%did not find power inlet at *" + post + "*")
						EndIf
					Else
						'rint "can't dock at *" + post + "*"
						Self.console.put("%red%can't remote power at *" + post + "*")
					EndIf
				Case "navigate","n","navi"
					cmd = ""
					
					Local drones:Int[] = New Int[0]
					Local room_id:Int
					Local all_flag:Int = 0
					
					'cut off integers -> drones
					Repeat
						Local pp:Int = Instr(post," ")
						
						Local cc:String = Mid(post,1,pp-1)
						
						post = Mid(post,pp+1,-1)
						If pp = 0 Then post = ""
						
						If Int(cc) > 0 Then
							drones = drones + [Int(cc)]' add new entry to drone list
							
							'rint "add " + Int(cc)
						Else
							'see if room
							If Mid(cc,1,1) = "r" Then
								room_id = Int(Mid(cc,2,-1))
								
								'rint "room: " + room_id
							ElseIf cc = "all"
								all_flag = 1
							Else
								'rint "improper syntax for *navigate* (2)"
								Self.console.put("%red%improper syntax for *navigate* (2)")
								Return
							EndIf
						EndIf
						
					Until post = ""
					
					'find room:
					Local r:LEVEL_GENERATOR_ROOM = Self.get_room(room_id)
					
					If Not r Then
						Self.console.put("%red%room *" + room_id + "* not found")
						Return
					EndIf
					
					Local drone_list:TList = New TList
					
					If all_flag Then
						For Local d:TPlayer = EachIn Self.objects
							drone_list.addlast(d)
						Next
					Else
						If drones.length = 0 Then
							Self.console.put("%red%error: no drones listed")
							Return
						EndIf
												
						For Local i:Int = 0 To drones.length-1
							Local d:TPlayer = get_player(drones[i])
							
							If Not d Then
								'rint "error: drone *" + drones[i] + "* not found"
								Self.console.put("%red%error: drone *" + drones[i] + "* not found")
								Return
							Else
								drone_list.addlast(d)
							EndIf
						Next
					EndIf
					
					For Local d:TPlayer = EachIn drone_list
						d.send_to_room(r)
					Next
				Case "reroute"
					cmd = ""
					
					Local rooms:Int[] = New Int[0]
					
					Repeat
						Local pp:Int = Instr(post," ")
						
						Local cc:String = Mid(post,1,pp-1)
						
						post = Mid(post,pp+1,-1)
						If pp = 0 Then post = ""
						
						If Mid(cc,1,1) = "r" Then
							rooms:+ [Int(Mid(cc,2,-1))]
						Else
							'rint "improper syntax for *navigate* (2)"
							Self.console.put("%red%improper syntax for *reroute* (2)")
							Return
						EndIf
						
					Until post = ""
					
					Self.reroute_power(rooms)
										
				Case "close"
					cmd = ""
				Case "open"
					cmd = ""
				Default
					If Mid(pre, 1,1) = "d" ' door
						Local id:Int = Int(Mid(pre, 2,-1))
						Self.toggle_door(id)
						cmd = post
					ElseIf Mid(pre, 1,1) = "a"
						Local id:Int = Int(Mid(pre, 2,-1))
						Self.toggle_airlock(id)
						cmd = post
					Else
						Self.console.put("%red%command not understood:")
						Self.console.put("%red%*" + cmd + "*")
						'rint "command not understood:"
						'rint "*" + cmd + "*"
						cmd = ""
					EndIf
			End Select	
		Wend
		
	End Method
	
	Method get_door_xy:Int[](id:Int)
		For Local x:Int = 0 To Self.table_x - 1
			For Local y:Int = 0 To Self.table_y - 1
				If table[x,y].obj_type = 2 And table[x,y].obj_id = id Then
					Return [x,y]
				EndIf
			Next
		Next
	End Method
	
	Method get_airlock_xy:Int[](id:Int)
		For Local x:Int = 0 To Self.table_x - 1
			For Local y:Int = 0 To Self.table_y - 1
				If table[x,y].obj_type = 3 And table[x,y].obj_id = id Then
					Return [x,y]
				EndIf
			Next
		Next
	End Method
	
	Method open_door_airlock(x:Int,y:Int)
		Local item:TRoom_Item_DA
		
		item = Self.get_door_from_xy(x,y)
		If Not item Then item = Self.get_airlock_from_xy(x,y)
		
		If item.powered Then
			table[x,y].collision = 0
			
			If item.updown Then
				table[x,y].taco_image_number = 11
			Else
				table[x,y].taco_image_number = 12
			EndIf
		Else
			Self.console.put("%red%not powered!")
		EndIf
	End Method
	
	Method close_door_airlock(x:Int,y:Int)
		Local item:TRoom_Item_DA
		
		item = Self.get_door_from_xy(x,y)
		If Not item Then item = Self.get_airlock_from_xy(x,y)
		
		If item.powered Then
			table[x,y].collision = 1
			
			If item.updown Then
				table[x,y].taco_image_number = 9
			Else
				table[x,y].taco_image_number = 10
			EndIf
		Else
			Self.console.put("%red%not powered!")
		EndIf
	End Method
	
	Method toggle_door(id:Int)
		Local coords:Int[] = get_door_xy(id)
		If coords.length > 1 Then
			Local x:Int = coords[0]
			Local y:Int = coords[1]
			
			If table[x,y].collision = 1 Then
				open_door_airlock(x,y)
			Else
				close_door_airlock(x,y)
			EndIf
		Else
			Self.console.put("%red%door *" + id + "* not found!")
		EndIf
	End Method
	
	Method toggle_airlock(id:Int)
		Local coords:Int[] = get_airlock_xy(id)
		If coords.length > 1 Then
			Local x:Int = coords[0]
			Local y:Int = coords[1]
			
			If table[x,y].collision = 1 Then
				open_door_airlock(x,y)
			Else
				close_door_airlock(x,y)
			EndIf
		Else
			Self.console.put("%red%airlock *" + id + "* Not found!")
		EndIf

	End Method
	
	Field remote_power_inlet:TRoom_Item_Power_Inlet
	
	Method remote_power(inlet:TRoom_Item_Power_Inlet)
		If inlet = remote_power_inlet Then
			remote_power_inlet = Null
			Self.console.put("%grey%turned %red%off %grey%remote power inlet in r" + inlet.room.id)
		ElseIf remote_power_inlet = Null Then
			remote_power_inlet = inlet
			Self.console.put("%grey%turned %green%on %grey%remote power inlet in r" + inlet.room.id)
		Else
			Self.console.put("%red%remote power already used in r" + remote_power_inlet.room.id)
		EndIf
		
		Self.redo_powered_status()
	End Method
	
	Method reroute_power(rooms:Int[])
		If rooms.length = 0 Then
			Self.console.put("%red%can not reroute without specification of rooms")
			Return
		EndIf
		
		If remote_power_inlet = Null Then
			Self.console.put("%red%can not reroute without active power inlet")
			Return
		EndIf
		
		remote_power_inlet.reach = New TList
		remote_power_inlet.reach.addlast(remote_power_inlet.room)
		
		For Local i:Int = 0 To rooms.length-1
			Print rooms[i]
			If remote_power_inlet.reach.contains(get_room(rooms[i])) Then
				' already in list
				Print "ok"
			Else
				'check if neighbouring any listed ones
				Local ok:Int = 0
				For Local nr:LEVEL_GENERATOR_ROOM = EachIn get_room(rooms[i]).neighbours
					If remote_power_inlet.reach.contains(nr) Then
						ok = 1
						remote_power_inlet.reach.addlast(get_room(rooms[i]))
						Print "add " + rooms[i]
					EndIf
				Next
				
				If ok = 0 Then
					Self.console.put("%red%cannot reroute with r" + rooms[i])
					Self.redo_powered_status()
					Return
				EndIf
			EndIf
		Next
		Rem
		
		While d.reach.count() <= d.max_reach And tries < 200
			
			tries:+1
			
			Local random:Int = Rand(1,d.reach.count())
			Local i:Int = 0
			
			For Local r:LEVEL_GENERATOR_ROOM = EachIn d.reach
				i:+1
				If i = random Then
					
					Local random2:Int = Rand(1, r.neighbours.count())
					Local ii:Int = 0
					For Local rr:LEVEL_GENERATOR_ROOM = EachIn r.neighbours
						ii:+1
						If ii = random2 Then
							d.reach.addlast(rr)
						EndIf
					Next
					
				EndIf
			Next
		Wend
		End Rem
		
		Self.redo_powered_status()
	End Method
	
	Method redo_powered_status()
		' - - -  redo powered status in rooms
		For Local r:LEVEL_GENERATOR_ROOM = EachIn Self.rooms
			r.powered = 0 ' reset all
		Next
		
		For Local a:TRoom_Item_DA = EachIn Self.room_items
			a.powered = 0
		Next
		
		For Local a:TRoom_Item_Power_Inlet = EachIn Self.room_items
			a.powered = 0
			table[a.x,a.y].taco_image_number = 14
		Next
		
		' add remote power:
		If remote_power_inlet Then
			Self.remote_power_inlet.powered = 1
			table[Self.remote_power_inlet.x,Self.remote_power_inlet.y].taco_image_number = 13
			
			For Local r:LEVEL_GENERATOR_ROOM = EachIn Self.remote_power_inlet.reach
				r.powered = 1
			Next
		EndIf
		
		For Local a:TRoom_Item_Airlock = EachIn Self.room_items
			If a.room.powered Then a.powered = 1
		Next
		
		For Local a:TRoom_Item_Door = EachIn Self.room_items
			If a.room1.powered Then a.powered = 1
			If a.room2.powered Then a.powered = 1
		Next
		
		
		Local dock:TRoom_Item_Airlock = get_airlock_from_xy(docking_x,docking_y)
		
		If dock Then
			dock.powered = 1
		EndIf
		' 
	End Method
	
	Method render_tiles()
		Self.render_tiles_commands()
		
		For Local x:Int = 1 To Self.table_x - 2
			For Local y:Int = 1 To Self.table_y - 2
				'check visibility
				
				If table[x,y].collision = 0 And table[x,y].visible > 0 And table[x-1,y].obj_type <> 5 Then
					If table[x,y].visible = 2 Then
						If table[x+1,y].visible = 0 Then table[x+1,y].visible = 1
						If table[x-1,y].visible = 0 Then table[x-1,y].visible = 1
						If table[x,y+1].visible = 0 Then table[x,y+1].visible = 1
						If table[x,y-1].visible = 0 Then table[x,y-1].visible = 1
					EndIf
					
					If table[x,y].obj_type <> 2 And table[x,y].obj_type <> 3 Then
						table[x,y].visible = 2
					EndIf
				EndIf
				
				If table[x,y].visible > 0 Then
					Select table[x,y].obj_type
						Case 2' door
							If table[x,y].obj_id < 1 Then
								table[x,y].obj_id = Self.next_door_id()
								table[x,y].taco_disp = 1
							EndIf
						Case 1' room
							If table[x,y].obj_id < 1 Then
								'check around for room number
								
								If table[x-1,y].obj_type = 1 And table[x-1,y].obj_id > 0 Then table[x,y].obj_id = table[x-1,y].obj_id
								If table[x+1,y].obj_type = 1 And table[x+1,y].obj_id > 0 Then table[x,y].obj_id = table[x+1,y].obj_id
								
								If table[x,y-1].obj_type = 1 And table[x,y-1].obj_id > 0 Then table[x,y].obj_id = table[x,y-1].obj_id
								If table[x,y+1].obj_type = 1 And table[x,y+1].obj_id > 0 Then table[x,y].obj_id = table[x,y+1].obj_id
							End If
							
							If table[x,y].obj_id = -1 Then
								table[x,y].obj_id = Self.next_room_id()
								table[x,y].taco_disp = 1
							EndIf
						Case 3'airlock
							If table[x,y].obj_id < 1 Then
								table[x,y].obj_id = Self.next_airlock_id()
								table[x,y].taco_disp = 1
							EndIf
					End Select
				EndIf
			Next
		Next
		
	End Method
	
	Method has_collision:Int(x:Int,y:Int)
		If x < 0 Then Return 1
		If y < 0 Then Return 1
		
		If x > Self.table_x-1 Then Return 1
		If y > Self.table_y-1 Then Return 1
		
		Return Self.table[x,y].collision
	End Method
	
		
	Field docking_x:Int'current airlock
	Field docking_y:Int
	Field docking_center_x:Int
	Field docking_center_y:Int
	
	Method build_docking_at:Int[](dock_x:Int,dock_y:Int)
		' returns center of 3*3 room
		
		Local center_x:Int
		Local center_y:Int
		
		If dock_x = 4 Then
			center_x = dock_x-2
			center_y = dock_y
			
		ElseIf dock_y = 4
			center_x = dock_x
			center_y = dock_y-2
			
		ElseIf dock_x = table_x-5
			center_x = dock_x+2
			center_y = dock_y
			
		ElseIf dock_y = table_y-5
			center_x = dock_x
			center_y = dock_y+2
			
		Else
			Print "failed to build, can't be an airlock !??"
			Return [-1,-1]'nonsense values
		EndIf
		
		For Local x:Int = -2 To 2
			For Local y:Int = -2 To 2
				If Abs(x) < 2 And Abs(y) < 2 Then
					'floor
					Self.table[x + center_x,y + center_y] = blocks[1].copy()
					Self.table[x + center_x,y + center_y].obj_type = 1
					Self.table[x + center_x,y + center_y].obj_id = 1 ' room 1
					If x = 0 And y = 0 Then
						Self.table[x + center_x,y + center_y].taco_disp = 1 ' center
						Self.table[x + center_x,y + center_y].visible = 2
					EndIf
				Else
					'build walls if nothing else there
					
					If Self.table[x + center_x,y + center_y].obj_type = 5 Then
						Self.table[x + center_x,y + center_y] = blocks[0].copy()
						Self.table[x + center_x,y + center_y].obj_type = 0
					EndIf
				EndIf
			Next
		Next
		
		
		Self.docking_x = dock_x
		Self.docking_y = dock_y
		
		Self.docking_center_x = center_x
		Self.docking_center_y = center_y
		
		'Add r1 to room list
		Local room:LEVEL_GENERATOR_ROOM = New LEVEL_GENERATOR_ROOM
		room.center_x = center_x
		room.center_y = center_y
		room.id = 1
		room.neighbours = New TList
		room.x = dock_x
		room.y = dock_y
		
		Self.rooms.addlast(room)
		
		Local airlock:TRoom_Item_Airlock = Self.get_airlock_from_xy(dock_x,dock_y)
		airlock.docked = 1
		airlock.room.neighbours.addlast(room)
		
		room.neighbours.addlast(airlock.room)
		
		Return [center_x,center_y]
	End Method
	
	Method destroy_dock()
		'kill r1 out of list
		Local airlock:TRoom_Item_Airlock = Self.get_airlock_from_xy(Self.docking_x,Self.docking_y)
		airlock.docked = 0
		airlock.room.neighbours.remove(Self.get_room(1))
		
		Self.rooms.remove(Self.get_room(1))
		
		close_door_airlock(Self.docking_x,Self.docking_y)
		
		For Local x:Int = -1 To 1
			For Local y:Int = -1 To 1
				Self.table[x + Self.docking_center_x,y + Self.docking_center_y] = blocks[5].copy() ' fill room with space
				Self.table[x + Self.docking_center_x,y + Self.docking_center_y].obj_type = 5
			Next
		Next

	End Method
End Type

Type CONSOLE
	Field lines:String[]
	
	Field x:Int'drawing coordinates
	Field y:Int
	Field dx:Int
	Field dy:Int
	
	Function Create:CONSOLE(x:Int,y:Int,dx:Int,dy:Int)
		Local c:CONSOLE = New CONSOLE
		
		c.x = x
		c.y = y
		c.dx = dx
		c.dy = dy
		
		c.lines = [..
		"+ - - - - - - - - SYSTEM BOOT - - - - - - - - +",..
		"¦                                             ¦",..
		"¦ Operating System:                %g%Loaded     %w%¦",..
		"¦ %b%Drones:                          %g%Functional %w%¦",..
		"¦ %b%Power:                           %g%ON         %w%¦",..
		"¦                                             ¦",..
		"¦ Subsystems:                      %g%Running... %w%¦",..
		"¦                                             ¦",..
		"¦ %y%Initial Docking Procedure:       %g%Complete   %w%¦",..
		"¦                                             ¦",..
		"+ - - - - - - - - - - - - - - - - - - - - - - +",..
		""]
		
		Return c
	End Function
	
	Method render()
	End Method
	
	Method put(txt:String)
		Local max_line:Int = (dy/20)-3
		
		If lines.length > max_line-1 Then
			For Local i:Int = 1 To max_line-1
				lines[i-1] = lines[i]
			Next
			
			lines[max_line-1] = txt
		Else
			lines:+[txt]
		EndIf
		
	End Method
	
	Method draw()
		'draw frame
		
		SetAlpha 0.2
		SetColor 255,255,255
		Draw_Rect Self.x,Self.y,Self.dx,Self.dy
		SetAlpha 0.7
		SetColor 0,0,0
		Draw_Rect x+2,y+2,dx-4,dy-4
		
		SetAlpha 1.0
		
		SetImageFont Graphics_Handler.font_20
		
		For Local i:Int = 0 To lines.length-1
			SetColor 255,255,255
			
			Local txt_ln:String = lines[i] + "%"
			Local draw_x:Int = 0
			Local current_txt:String=""
			Local draw_mode:Int=0
			
			
			For Local ii:Int = 1 To Len(txt_ln)
				If draw_mode=0 Then
					Select Mid(txt_ln,ii,1)
						Case "%"
							draw_mode=1
							
							'Draw_Text current_txt, 170+dx,470 + 25*i
							'Draw_Text lines[i],x+10,y+10+i*20
							Draw_Text current_txt,x+10+draw_x,y+10+i*20
							
							draw_x:+TextWidth(current_txt)
							current_txt=""
						Default
							current_txt:+Mid(txt_ln,ii,1)
					End Select
				Else
					Select Mid(txt_ln,ii,1)
						Case "%"
							draw_mode=0
							
							Select Lower(current_txt)
								Case "red","r"
									SetColor 255,50,50
								Case "blue","b"
									SetColor 50,100,255
								Case "green","g"
									SetColor 70,200,70
								Case "white","w"
									SetColor 255,255,255
								Case "black"
									SetColor 0,0,0
								Case "orange","o"
									SetColor 255,150,50
								Case "yellow","y"
									SetColor 255,255,0
								Case "pink","p"
									SetColor 255,50,255
								Case "grey"
									SetColor 150,150,150
								Default
									SetColor 100,0,0
							End Select
							
							current_txt=""
						Default
							current_txt:+Mid(txt_ln,ii,1)
					End Select
				End If
			Next
		Next
		
		SetColor 255,255,255
		
		Local cursor:String
		
		If (MilliSecs() Mod 800)<400 Then
			cursor = "¦"
		EndIf
		
		Draw_Text KeyboardInput.text + cursor,x+10,y+dy-25
		
		SetImageFont Graphics_Handler.font_30
	End Method
End Type

Type LEVEL_GENERATOR
	Field dx:Int'final size
	Field dy:Int
	
	Field room_list:TList
	Field room_items:TList
	
	Field grid:Int[,]
	Field grid_info:Int[,] ' -1 for id-showing
	' - - idea:
	'
	' create room in middle
	' slit rooms up
	' put rooms to grid
	' put doors in, also airlocks
	' put in power inlets
	
	Function Create:LEVEL_GENERATOR(x:Int,y:Int)'input size
		Local lvlgen:LEVEL_GENERATOR = New LEVEL_GENERATOR
		
		lvlgen.dx = 8 + x*2 + 1 ' 2*4 (border), 2*x for grid, +1 for wall on other side
		lvlgen.dy = 8 + y*2 + 1
		
		lvlgen.grid = New Int[lvlgen.dx,lvlgen.dy]
		lvlgen.grid_info = New Int[lvlgen.dx,lvlgen.dy]
		
		lvlgen.room_list = New TList
		lvlgen.room_items = New TList
		
		Local root_room:LEVEL_GENERATOR_ROOM = LEVEL_GENERATOR_ROOM.Create(0,0,x,y)
		lvlgen.room_list.addlast(root_room)
		root_room.split(lvlgen.room_list) ' recursive splitting
		
		'from rooms to grid
		
		For Local r:LEVEL_GENERATOR_ROOM = EachIn lvlgen.room_list
			Local offset_x:Int = 4+2*r.x
			Local offset_y:Int = 4+2*r.y
			
			For Local ix:Int = 0 To r.dx*2
				For Local iy:Int = 0 To r.dy*2
					If ix = 0 Or iy = 0 Or ix = r.dx*2 Or iy = r.dy*2 Then
						'walls
						lvlgen.grid[ix + offset_x,iy + offset_y] = 2
					Else
						'room
						lvlgen.grid[ix + offset_x,iy + offset_y] = 1
					EndIf
				Next
			Next
			
			'put down center
			lvlgen.grid_info[r.dx + offset_x,r.dy + offset_y] = -1
			
			r.center_x = r.dx + offset_x
			r.center_y = r.dy + offset_y
		Next
		
		'put in doors + airlocks
		
		For Local r:LEVEL_GENERATOR_ROOM = EachIn lvlgen.room_list
			Local offset_x:Int = 4+2*r.x
			Local offset_y:Int = 4+2*r.y
			
			For Local i:LEVEL_GENERATOR_ROOM = EachIn lvlgen.room_list
				If i <> r And (Not r.neighbours.contains(i)) Then'And i.doors_generated = 0 Then
					
					If r.x = i.x+i.dx Then 'on top
						If r.y < i.y+i.dy And i.y < r.y+r.dy Then
							
							'Max(r.y,i.y)*2+1+4
							'Min(r.y+r.dy,i.y+i.dy)*2-2+5
							Local pos:Int = Rand(Max(r.y,i.y)*2+1+4,  Min(r.y+r.dy,i.y+i.dy)*2-2+5)
							
							'Rand(Max(r.y,i.y)*2+1, Min(r.y+r.dy,i.y+i.dy)*2-1)+4
							
							lvlgen.grid[offset_x,pos] = 3
							lvlgen.grid_info[offset_x,pos] = -1
							
							lvlgen.room_items.addlast(TRoom_Item_Door.Create(offset_x,pos,r, i))
							
							r.neighbours.addlast(i)
							i.neighbours.addlast(r)
						EndIf
					EndIf
					
					If r.y = i.y+i.dy Then 'on top
						If r.x < i.x+i.dx And i.x < r.x+r.dx Then
							'Local pos:Int = Max(r.x,i.x)*2+1+4
							
							Local pos:Int = Rand(Max(r.x,i.x)*2+1+4,  Min(r.x+r.dx,i.x+i.dx)*2-2+5)
							
							lvlgen.grid[pos,offset_y] = 3
							lvlgen.grid_info[pos,offset_y] = -1
							
							lvlgen.room_items.addlast(TRoom_Item_Door.Create(pos,offset_y,r, i))
							
							r.neighbours.addlast(i)
							i.neighbours.addlast(r)
						EndIf
					EndIf
					
				EndIf
			Next
			
			r.doors_generated = 1
			
			If r.x = 0 Then ' put in a randomizer ? - or kill airlocks later ?
				Local pos:Int = Rand(1,r.dy*2-1)
				
				lvlgen.grid[offset_x,offset_y + pos] = 3
				lvlgen.grid_info[offset_x,offset_y + pos] = -1
				
				lvlgen.room_items.addlast(TRoom_Item_Airlock.Create(offset_x,offset_y + pos,r))
			ElseIf r.y = 0 Then
				Local pos:Int = Rand(1,r.dx*2-1)
				
				lvlgen.grid[offset_x + pos,offset_y] = 3
				lvlgen.grid_info[offset_x + pos,offset_y] = -1
								
				lvlgen.room_items.addlast(TRoom_Item_Airlock.Create(offset_x + pos,offset_y,r))
			ElseIf r.x+r.dx = x Then
				Local pos:Int = Rand(1,r.dy*2-1)
				
				lvlgen.grid[offset_x + r.dx*2,offset_y + pos] = 3
				lvlgen.grid_info[offset_x + r.dx*2,offset_y + pos] = -1
				
				lvlgen.room_items.addlast(TRoom_Item_Airlock.Create(offset_x + r.dx*2,offset_y + pos,r))
			ElseIf r.y+r.dy = y Then
				Local pos:Int = Rand(1,r.dx*2-1)
				
				lvlgen.grid[offset_x + pos,offset_y + r.dy*2] = 3
				lvlgen.grid_info[offset_x + pos,offset_y + r.dy*2] = -1
				
				lvlgen.room_items.addlast(TRoom_Item_Airlock.Create(offset_x + pos,offset_y + r.dy*2,r))
			EndIf
			
			
		Next
		
		' - - - - Put in Power Inlets
		For Local r:LEVEL_GENERATOR_ROOM = EachIn lvlgen.room_list
			If r.dx*r.dy > 1 Then
				
				Local i:Int = 0
				Local done:Int = 0
				
				While i < 5 And done = 0
					Local offset_x:Int = 4+2*r.x
					Local offset_y:Int = 4+2*r.y
					
					Local xx:Int = Rand(1, r.dx*2-1)
					Local yy:Int = Rand(1, r.dy*2-1)
					
					If lvlgen.grid_info[offset_x + xx,offset_y + yy] = 0 Then
						lvlgen.room_items.addlast(TRoom_Item_Power_Inlet.Create(offset_x + xx,offset_y + yy,r))
						lvlgen.grid[offset_x + xx,offset_y + yy] = 6
						done = 1
					EndIf
				Wend
				
			EndIf
		Next
		
		Return lvlgen
	End Function
End Type

Type TRoom_Item
	Field x:Int
	Field y:Int
	
	
	
	Method render()
	End Method
End Type

Type TRoom_Item_Power_Inlet Extends TRoom_Item
	Field room:LEVEL_GENERATOR_ROOM
	Field powered:Int
	
	Field reach:TList ' rooms that the inlet can power
	Field max_reach:Int ' amount of rooms maximally powered
	
	Method render()
	End Method
	
	Function Create:TRoom_Item_Power_Inlet(x:Int,y:Int,room:LEVEL_GENERATOR_ROOM)
		Local d:TRoom_Item_Power_Inlet = New TRoom_Item_Power_Inlet
		
		d.x = x
		d.y = y
				
		d.room = room
		
		d.max_reach = Rand(4,10)
		d.reach = New TList
		d.reach.addlast(room)
		
		Local tries:Int = 0
		
		While d.reach.count() <= d.max_reach And tries < 200
			
			tries:+1
			
			Local random:Int = Rand(1,d.reach.count())
			Local i:Int = 0
			
			For Local r:LEVEL_GENERATOR_ROOM = EachIn d.reach
				i:+1
				If i = random Then
					
					Local random2:Int = Rand(1, r.neighbours.count())
					Local ii:Int = 0
					For Local rr:LEVEL_GENERATOR_ROOM = EachIn r.neighbours
						ii:+1
						If ii = random2 Then
							d.reach.addlast(rr)
						EndIf
					Next
					
				EndIf
			Next
		Wend
		
		Return d
	End Function
End Type

Type TRoom_Item_DA Extends TRoom_Item  'Door / Airlock
	Field updown:Int
	Field powered:Int
	
	Method open:Int()
		Return (GAME.level.table[x,y].collision = 0)
	EndMethod
	
	Method get_pre:Int[](r:LEVEL_GENERATOR_ROOM)
		If updown = 0 Then
			If r.center_x < x Then
				Return [x-1,y]
			Else
				Return [x+1,y]
			EndIf
		Else
			If r.center_y < y Then
				Return [x,y-1]
			Else
				Return [x,y+1]
			EndIf
		EndIf
	End Method
End Type

Type TRoom_Item_Door Extends TRoom_Item_DA
	
	
	Field id:Int = -1
	
	Field room1:LEVEL_GENERATOR_ROOM
	Field room2:LEVEL_GENERATOR_ROOM
	
	Method links_room:Int(r:LEVEL_GENERATOR_ROOM)
		If r = room1 Then Return True
		If r = room2 Then Return True
		Return False
	End Method
	
	Method links_rooms:Int(r1:LEVEL_GENERATOR_ROOM, r2:LEVEL_GENERATOR_ROOM)
		If r1 = room1 And r2 = room2 Then Return True
		If r2 = room1 And r1 = room2 Then Return True
		Return False
	End Method
		
	Method render()
		If id = -1 Then
			id = GAME.level.table[x,y].obj_id
			'If id <> -1 Then
				'rint "found door: " + id
			'EndIf
		EndIf
	End Method
	
	Function Create:TRoom_Item_Door(x:Int,y:Int,room1:LEVEL_GENERATOR_ROOM, room2:LEVEL_GENERATOR_ROOM)
		Local d:TRoom_Item_Door = New TRoom_Item_Door
		
		d.x = x
		d.y = y
				
		d.room1 = room1
		d.room2 = room2
		
		If room1.x = room2.x + room2.dx Or room2.x = room1.x + room1.dx Then
			d.updown = 0
		Else
			d.updown = 1
		EndIf
		
		Return d
	End Function
End Type

Type TRoom_Item_Airlock Extends TRoom_Item_DA
	Field id:Int = -1
	
	Field room:LEVEL_GENERATOR_ROOM
	Field docked:Int = 0
	
	Method links_room:Int(r:LEVEL_GENERATOR_ROOM)
		If r = room Then Return True
		Return False
	End Method
		
	Method render()
		If id = -1 Then
			id = GAME.level.table[x,y].obj_id
			'If id <> -1 Then
				'rint "found airlock: " + id
			'EndIf
		EndIf
	End Method
	
	Function Create:TRoom_Item_Airlock (x:Int,y:Int,room:LEVEL_GENERATOR_ROOM)
		Local d:TRoom_Item_Airlock = New TRoom_Item_Airlock
		
		d.x = x
		d.y = y
		
		If x = 4 Or x = (room.x+room.dx)*2+4 Then
			d.updown = 0
		Else
			d.updown = 1
		EndIf
		
		d.room = room
		
		Return d
	End Function
End Type

Type LEVEL_GENERATOR_ROOM
	Field x:Int'input size - except r1 -> docking
	Field y:Int
	
	Field dx:Int'input size
	Field dy:Int
	
	Field doors_generated:Int = 0
	
	' - Game content
	Field id:Int
	
	Field center_x:Int'output unit
	Field center_y:Int
	
	Field neighbours:TList ' neighbouring rooms, connected through doors
	
	Field algo_n:Int = 0 'number used for algorythms (pathfinding - distance)
	
	Field powered:Int
	' - - - - - - - -
	
	Function Create:LEVEL_GENERATOR_ROOM(x:Int,y:Int,dx:Int,dy:Int)
		Local r:LEVEL_GENERATOR_ROOM = New LEVEL_GENERATOR_ROOM
		
		r.x = x
		r.y = y
		r.dx = dx
		r.dy = dy
		
		r.id = -1
		
		r.neighbours = New TList
		
		Return r
	End Function
	
	Method render()
		If id = -1 Then' room not yet found
			id = GAME.level.table[center_x,center_y].obj_id
			'If id <> -1 Then
				'rint "found room: " + id
			'EndIf
		EndIf
		
		If Self.powered Then
			GAME.level.table[center_x,center_y].visible = 2
		EndIf
	End Method
	
	Method split(list:TList)
		'assess direction of split
		
		'create split room, put in list, recursive splitting
		
		'resize local room, split again
		
		Local stop_splitting:Int = 0
		
		Repeat
			If dx > dy Or (dx = dy And Rand(0,1)=0) Then
				If dx > 2 And dx*dy > 3 And (dx > 4 Or Rand(1,4)<2) Then
					'split up
					
					Local remaining_dx:Int = Rand(1,dx-1)
					
					Local nr:LEVEL_GENERATOR_ROOM = LEVEL_GENERATOR_ROOM.Create(x+remaining_dx,y,dx-remaining_dx,dy)
					list.addlast(nr)
					nr.split(list)
					
					dx = remaining_dx
				Else
					stop_splitting = 1
				EndIf
			Else
				If dy > 1 And dx*dy > 3 And (dy > 4 Or Rand(1,4)<4) Then
					'split up
					
					Local remaining_dy:Int = Rand(1,dy-1)
					
					Local nr:LEVEL_GENERATOR_ROOM = LEVEL_GENERATOR_ROOM.Create(x,y+remaining_dy,dx,dy-remaining_dy)
					list.addlast(nr)
					nr.split(list)
					
					dy = remaining_dy
				Else
					stop_splitting = 1
				EndIf
			EndIf
		Until stop_splitting = 1
	End Method
End Type


'########################################################################################
'###########################       ######################################################
'########################### BLOCK ######################################################
'###########################       ######################################################
'########################################################################################

Type TBlock
	Field collision:Int'0 = off, 1 = on
	
	Function Create:TBlock(collision:Int=0, fg:Int=0, bg:Int=0, taco:Int=0, obj_type:Int=0, obj_id:Int=0)
		Local b:TBlock = New TBlock
		
		b.collision = collision
		
		'foreground
		b.fg_image_number = fg
		
		'background
		b.bg_image_number = bg
		
		'tactical overview - taco
		b.taco_image_number = taco
		
		b.obj_type = obj_type
		b.obj_id= obj_id
		Return b
	End Function
	
	Method copy:TBlock()
		Local b:TBlock = New TBlock
		
		b.collision = Self.collision
		
		'foreground
		b.fg_image_number = Self.fg_image_number
		b.fg_frame = Rand(0,GAME.tiles[Self.fg_image_number].frames.length-1)
		
		'background
		b.bg_image_number = Self.bg_image_number
		b.bg_frame = Rand(0,GAME.tiles[Self.bg_image_number].frames.length-1)
		
		'tactical overview - taco
		b.taco_image_number = Self.taco_image_number
		
		b.obj_type = Self.obj_type
		b.obj_id= Self.obj_id
		Return b
	End Method
	
	'FOREGROUND
	Field fg_image_number:Int
	Field fg_frame:Int
	
	'BACKGROUND
	Field bg_image_number:Int
	Field bg_frame:Int
	
	Method block_draw(x:Float, y:Float, img_n:Int, frame:Int)
		
		SetColor 255,255,255
		Draw_Image GAME.tiles[img_n], x, y, frame
		SetScale 1,1
	End Method
	
	Method block_draw_small(x:Float, y:Float, img_n:Int)
		SetColor 255,255,255
		Draw_Image GAME.tiles_small[img_n], x, y, 0
		SetScale 1,1
	End Method
	
	Method block_draw_taco(x:Float, y:Float, c_up:Int=0, c_down:Int=0, c_left:Int=0, c_right:Int=0)
		If visible = 0 Then Return
		
		SetColor 255,255,255
		'DrawRect x+10,y+10,visible*5 ,visible*5
		
		Draw_Image GAME.tiles[Self.taco_image_number], x, y, 0
		
		If Self.obj_id > 0 Then
			Select Self.obj_type
				Case 1,6'room
					Draw_Image GAME.tiles[Self.taco_image_number], x, y, 0
					
					If Self.taco_disp Then
						If GAME.level.get_room(Self.obj_id).powered Then
							SetColor 0,255,0
						Else
							SetColor 150,150,150
						EndIf
						Local txt:String = "r" + Self.obj_id
						
						Draw_Text txt, x + GAME.tile_side/2 - TextWidth(txt)/2,y + GAME.tile_side/2 - TextHeight(txt)/2
					EndIf
					
					If GAME.level.get_room(Self.obj_id).powered Then
						SetColor 50,80,50
					Else
						SetColor 50,50,50
					EndIf
					
					If c_up Then
						Draw_Rect x,y,GAME.tile_side,1
					EndIf
					
					If c_down Then
						Draw_Rect x,y+GAME.tile_side,GAME.tile_side,-1
					EndIf
					
					If c_left Then
						Draw_Rect x,y,1,GAME.tile_side
					EndIf
					
					If c_right Then
						Draw_Rect x+GAME.tile_side,y,-1,GAME.tile_side
					EndIf
					
					
				Case 2'door
					If GAME.level.get_door(Self.obj_id).powered Then
						SetColor 0,100,100
					Else
						SetColor 60,60,60
					EndIf
					Draw_Image GAME.tiles[Self.taco_image_number], x, y, 0
					
					If Self.taco_disp Then
						If GAME.level.get_door(Self.obj_id).powered Then
							SetColor 0,255,255
						Else
							SetColor 100,200,200
						EndIf
						Local txt:String = "d" + Self.obj_id
						
						Draw_Text txt, x + GAME.tile_side/2 - TextWidth(txt)/2,y + GAME.tile_side/2 - TextHeight(txt)/2
					EndIf
				Case 3'airlock
					If GAME.level.get_airlock(Self.obj_id).powered Then
						SetColor 100,100,0
					Else
						SetColor 70,70,50
					EndIf
					
					Draw_Image GAME.tiles[Self.taco_image_number], x, y, 0
					
					If Self.taco_disp Then
						If GAME.level.get_airlock(Self.obj_id).powered Then
							SetColor 255,255,0
						Else
							SetColor 200,200,100
						EndIf
						
						Local txt:String = "a" + Self.obj_id
						
						Draw_Text txt, x + GAME.tile_side/2 - TextWidth(txt)/2,y + GAME.tile_side/2 - TextHeight(txt)/2
					EndIf
				Default
					Draw_Image GAME.tiles[Self.taco_image_number], x, y, 0
			End Select
		EndIf
	End Method
	
	Method block_draw_taco_small(x:Float, y:Float, c_up:Int=0, c_down:Int=0, c_left:Int=0, c_right:Int=0)
		If visible = 0 Then Return
		
		SetColor 255,255,255
		'DrawRect x+10,y+10,visible*5 ,visible*5
		
		
		
		If Self.obj_id > 0 Then
			
			Select Self.obj_type
				Case 1,6'room
					Draw_Image GAME.tiles_small[Self.taco_image_number], x, y, 0
					
					If Self.taco_disp Then
						If GAME.level.get_room(Self.obj_id).powered Then
							SetColor 0,255,0
						Else
							SetColor 150,150,150
						EndIf
						
						Local txt:String = "r" + Self.obj_id
						
						Draw_Text txt, x + GAME.tile_side_small/2 - TextWidth(txt)/2,y + GAME.tile_side_small/2 - TextHeight(txt)/2
					EndIf
					
					If GAME.level.get_room(Self.obj_id).powered Then
						SetColor 100,255,100
					Else
						SetColor 150,150,150
					EndIf
					
					If c_up Then
						Draw_Rect x,y,GAME.tile_side_small,1
					EndIf
					
					If c_down Then
						Draw_Rect x,y+GAME.tile_side_small,GAME.tile_side_small,-1
					EndIf
					
					If c_left Then
						Draw_Rect x,y,1,GAME.tile_side_small
					EndIf
					
					If c_right Then
						Draw_Rect x+GAME.tile_side_small,y,-1,GAME.tile_side_small
					EndIf
					
				Case 2'door
					If GAME.level.get_door(Self.obj_id).powered Then
						SetColor 0,255,255
					Else
						SetColor 100,100,100
					EndIf
					Draw_Image GAME.tiles_small[Self.taco_image_number], x, y, 0
					
					If Self.taco_disp Then
						
						SetColor 0,255,255
						Local txt:String = "d" + Self.obj_id
						
						Draw_Text txt, x + GAME.tile_side_small/2 - TextWidth(txt)/2,y + GAME.tile_side_small/2 - TextHeight(txt)/2
					EndIf
				Case 3'airlock
					If GAME.level.get_airlock(Self.obj_id).powered Then
						SetColor 255,255,0
					Else
						SetColor 70,70,50
					EndIf
					
					Draw_Image GAME.tiles_small[Self.taco_image_number], x, y, 0
					
					If Self.taco_disp Then
						SetColor 255,255,0
						Local txt:String = "a" + Self.obj_id
						
						Draw_Text txt, x + GAME.tile_side_small/2 - TextWidth(txt)/2,y + GAME.tile_side_small/2 - TextHeight(txt)/2
					EndIf
				Default
					Draw_Image GAME.tiles_small[Self.taco_image_number], x, y, 0
			End Select
		EndIf
	End Method
	
	'Tactical Overlay - taco
	Field taco_image_number:Int
	
	' Objec ID - door, room, airlock, ...
	Field obj_id:Int
	Field obj_type:Int
	Field taco_disp:Int ' important so not the whole room is spammed full with numbers
	
	' ------ spread-values:
	Field visible:Int
	Field depressured:Int
	Field radiation:Int
End Type

'########################################################################################
'###########################        #####################################################
'########################### OBJECT #####################################################
'###########################        #####################################################
'########################################################################################

Type TObject
	Field x:Float
	Field y:Float
	
	Field kill_me:Int = 0 '1 = kill it definately
	
	Method render()
		If Self.kill_me = 1 Then
			Self.kill()'kill definately !
			
			Return
		End If
		
	End Method
	
	Method draw()
	End Method

	Method draw_taco()
	End Method
	
	Method draw_small()
	End Method

	Method draw_taco_small()
	End Method
	
	Method kill()'delete from memory
		GAME.level.objects.remove(Self)
	End Method
End Type

'########################################################################################
'###########################        #####################################################
'########################### TLamp  #####################################################
'###########################        #####################################################
'########################################################################################

Type TLamp Extends TObject
	
	Global image:TImage
	
	Function ini()
		TLamp.image = ImageLoader.Load("gfx\torch.png",32,32)
		MidHandleImage TLamp.image
	End Function
	
	Field light:TLight
	
	Field w:Float
	
	Function Create:TLamp(x:Float,y:Float,col:Int[],l_img:TImage,l:TLevel)
		Local p:TLamp = New TLamp
		
		p.x = x
		p.y = y
		
		p.w = Rnd(360)
		
		l.objects.addfirst(p)
		
		p.light = TLight.Create(l_img,0,0)
		p.light.set_color(col[0],col[1],col[2])
		
		Return p
	End Function
	
	Method render()
		Super.render()
		
		'Self.w:+2.5
		
		'Self.light.image = Self.light_image
		Self.light.x = Self.x
		Self.light.y = Self.y
		Self.light.w = Self.w
		
		Self.light.render()
		'Self.light.draw_to_buffer()
		
	End Method
	
	Method draw()
		SetColor 255,255,255
		Draw_Image TLamp.image, GAME.level.ansicht_act_x + Self.x, GAME.level.ansicht_act_y + Self.y, (Abs(MilliSecs()) / 500) Mod 4
	End Method
	
End Type

'########################################################################################
'###########################        #####################################################
'########################### TShot  #####################################################
'###########################        #####################################################
'########################################################################################

Type TShot Extends TMob
	
	Global image:TImage
	
	Function ini()
		TShot.image = ImageLoader.Load("gfx\shot.png",20,20)
		MidHandleImage TShot.image
	End Function
	
	Field speed:Float = 8
	
	Field light:TLight
	
	Field w:Float
	
	Function Create:TShot(x:Float,y:Float,w:Float,l:TLevel)
		Local p:TShot = New TShot
		
		p.x = x
		p.y = y
		
		p.r = 10
		
		p.w = w+Rnd(-3,3)
		
		p.vx = p.speed*Cos(p.w)
		p.vy = p.speed*Sin(p.w)
		
		l.objects.addlast(p)
		
		p.light = TLight.Create(TLight.source_shot,0,0)
		p.light.set_color(100,50,20)
		p.light.shadow = 0
		
		Return p
	End Function
	
	Method render()
		Super.render()
		
		Self.calc_collision()
		
		Self.light.set_color(Rand(50,150),Rand(20,70),Rand(0,40))
		
		If coll_ground Or coll_l Or coll_r Or coll_up Then
			Self.kill()
			Self.light.set_color(255,150,100)
		EndIf
		
		For Local b:TBot = EachIn GAME.level.objects
			If ((b.x - Self.x)^2 + (b.y - Self.y)^2) < (b.r + Self.r)^2 Then
				Self.kill()
				b.kill()
			EndIf
		Next
		
		Self.x:+Self.vx
		Self.y:+Self.vy
		
		'Self.light.image = Self.light_image
		Self.light.x = Self.x
		Self.light.y = Self.y
		Self.light.w = Self.w
		
		Self.light.render()
		'Self.light.draw_to_buffer()
		
	End Method
	
	Method draw()
		SetColor 255,255,255
		SetRotation Self.w
		Draw_Image TShot.image, GAME.level.ansicht_act_x + Self.x, GAME.level.ansicht_act_y + Self.y
		SetRotation 0
	End Method
	
End Type


'########################################################################################
'###########################        #####################################################
'###########################  Mob   #####################################################
'###########################        #####################################################
'########################################################################################

Type TMob Extends TObject
	Field r:Float
	
	Field w:Float
	
	Field vx:Float = 0
	Field vy:Float = 0	
	
	Field coll_ground:Int = 0
	Field coll_l:Int = 0
	Field coll_r:Int = 0
	Field coll_up:Int = 0
	
	Method calc_collision()
		
		'--------------- collision --------------
		Self.coll_ground = 0
		Self.coll_l = 0
		Self.coll_r = 0
		Self.coll_up = 0
		
		
		'---------------- ground + andti wall climber
		If Ceil((Self.y + Self.r)/GAME.tile_side) < Ceil((Self.y+Self.r + Self.vy)/GAME.tile_side) Then
			'going one down
			
			If Ceil((Self.x + Self.r)/GAME.tile_side) < Ceil((Self.x+Self.r + Self.vx)/GAME.tile_side) Then
				'going one to the right
				
				Local iy:Int = Ceil((Self.y+Self.r  + Self.vy)/GAME.tile_side)-1
				Local ix:Int = Ceil((Self.x+Self.r)/GAME.tile_side)
				If GAME.level.has_collision(ix, iy) And GAME.level.has_collision(ix, iy - 1) Then
					Self.vx = (Ceil((Self.x+Self.r)/GAME.tile_side)*GAME.tile_side) - (Self.x+Self.r)
					
					If Self.vx = 0 Then Self.coll_r = 1
				End If
				
			End If
			
			If Floor((Self.x - Self.r)/GAME.tile_side) > Floor((Self.x - Self.r + Self.vx)/GAME.tile_side) Then
				'going one to the left
				
				
				Local iy:Int = Ceil((Self.y+Self.r + Self.vy)/GAME.tile_side)-1
				Local ix:Int = Floor((Self.x-Self.r)/GAME.tile_side) - 1
				If GAME.level.has_collision(ix, iy) And GAME.level.has_collision(ix, iy - 1) Then
					Self.vx = (Floor((Self.x-Self.r)/GAME.tile_side)*GAME.tile_side) - (Self.x-Self.r)
					If Self.vx = 0 Then Self.coll_l = 1
				End If
				
			End If
			
			
			'---------------- ground:
			'you have just entered a new row of blocks!
			
			'muss +vx haben, damit keine strunen wenn genau auf ecke des blockes fllt
			For Local ix:Int = Floor((Self.x - Self.r + Self.vx)/GAME.tile_side) To Ceil((Self.x+Self.r + Self.vx)/GAME.tile_side)-1
				If GAME.level.has_collision(ix,Ceil((Self.y+Self.r)/GAME.tile_side)) Then
					Self.vy = (Ceil((Self.y+Self.r)/GAME.tile_side)*GAME.tile_side) - (Self.y+Self.r)
					
					If Self.vy = 0 Then Self.coll_ground = 1
				End If
			Next
			
		End If
		
		
		
		'---------------- top + andti wall stop jumping
		If Floor((Self.y - Self.r)/GAME.tile_side) > Floor((Self.y - Self.r + Self.vy)/GAME.tile_side) Then
			'going one up
			
			
			If Ceil((Self.x + Self.r)/GAME.tile_side) < Ceil((Self.x+Self.r + Self.vx)/GAME.tile_side) Then
				'going one to the right
				
				Local iy:Int = Floor((Self.y - Self.r)/GAME.tile_side)
				Local ix:Int = Ceil((Self.x+Self.r)/GAME.tile_side)
				If GAME.level.has_collision(ix, iy) And GAME.level.has_collision(ix, iy - 1) Then
					Self.vx = (Ceil((Self.x+Self.r)/GAME.tile_side)*GAME.tile_side) - (Self.x+Self.r)
					
					If Self.vx = 0 Then Self.coll_r = 1
				End If
				
			End If
			
			If Floor((Self.x - Self.r)/GAME.tile_side) > Floor((Self.x - Self.r + Self.vx)/GAME.tile_side) Then
				'going one to the left
				
				
				Local iy:Int = Floor((Self.y - Self.r)/GAME.tile_side)
				Local ix:Int = Floor((Self.x-Self.r)/GAME.tile_side) - 1
				If GAME.level.has_collision(ix, iy) And GAME.level.has_collision(ix, iy - 1) Then
					Self.vx = (Floor((Self.x-Self.r)/GAME.tile_side)*GAME.tile_side) - (Self.x-Self.r)
					If Self.vx = 0 Then Self.coll_l = 1
				End If
				
			End If
			
			
			'---------------- top:
			'you have just entered a new row of blocks!
			
			For Local ix:Int = Floor((Self.x - Self.r + Self.vx)/GAME.tile_side) To Ceil((Self.x+Self.r + Self.vx)/GAME.tile_side)-1
				If GAME.level.has_collision(ix, Floor((Self.y-Self.r)/GAME.tile_side) - 1) Then
					Self.vy = (Floor((Self.y-Self.r)/GAME.tile_side)*GAME.tile_side) - (Self.y-Self.r)
					If Self.vy = 0 Then Self.coll_up = 1
				End If
			Next
			
			
		End If
		
		'---------------- r:
		If Ceil((Self.x + Self.r)/GAME.tile_side) < Ceil((Self.x+Self.r + Self.vx)/GAME.tile_side) Then
			'you have just entered a new row of blocks!
			
			For Local iy:Int = Floor((Self.y - Self.r  + Self.vy)/GAME.tile_side) To Ceil((Self.y+Self.r  + Self.vy)/GAME.tile_side)-1
				If GAME.level.has_collision(Ceil((Self.x+Self.r)/GAME.tile_side), iy) Then
					Self.vx = (Ceil((Self.x+Self.r)/GAME.tile_side)*GAME.tile_side) - (Self.x+Self.r)
					
					If Self.vx = 0 Then Self.coll_r = 1
				End If
			Next
		End If
		
		'---------------- l:
		If Floor((Self.x - Self.r)/GAME.tile_side) > Floor((Self.x - Self.r + Self.vx)/GAME.tile_side) Then
			'you have just entered a new row of blocks!
			
			For Local iy:Int = Floor((Self.y - Self.r + Self.vy)/GAME.tile_side) To Ceil((Self.y+Self.r + Self.vy)/GAME.tile_side)-1
				If GAME.level.has_collision(Floor((Self.x-Self.r)/GAME.tile_side) - 1, iy) Then
					Self.vx = (Floor((Self.x-Self.r)/GAME.tile_side)*GAME.tile_side) - (Self.x-Self.r)
					If Self.vx = 0 Then Self.coll_l = 1
				End If
			Next
		End If
	End Method
	
End Type

'########################################################################################
'###########################        #####################################################
'########################### PLAYER #####################################################
'###########################        #####################################################
'########################################################################################

Type TPlayer Extends TMob
	
	Global image:TImage
	Global image_taco:TImage
	Global image_small:TImage
	Global image_taco_small:TImage
	
	Field light:TLight
	
	Field level:TLevel
	
	Field name:String
	Field id:Int
	
	Function Create:TPlayer(x:Float,y:Float,l:TLevel, id:Int, name:String)
		Local p:TPlayer = New TPlayer
		
		p.r = 30
		
		p.x = x
		p.y = y
		
		l.objects.addlast(p)
		
		p.light = TLight.Create(TLight.source_spot_big,0,0)'source_big
		
		Local r:Int = 0
		Local g:Int = 0
		Local b:Int = 0
		
		For Local i:Int = 0 To 1
			Select Rand(0,2)
				Case 0
					r:+255
				Case 1
					g:+255
				Case 2
					g:+100
					b:+255
			End Select
		Next
		p.light.set_color(Min(r,255),Min(g,255),Min(b,255))
		
		p.level = l
		
		p.id = id
		p.name = name
		
		p.level.active_player = p
		
		Return p
	End Function
	
	Function ini()
		TPlayer.image = ImageLoader.Load("gfx\player.png",64,64)
		MidHandleImage TPlayer.image
		
		TPlayer.image_small = ImageLoader.Load("gfx\player_small.png",16,16)
		MidHandleImage TPlayer.image_small
		
		TPlayer.image_taco = ImageLoader.Load("gfx\player_taco.png",64,64)
		MidHandleImage TPlayer.image_taco
		
		TPlayer.image_taco_small = ImageLoader.Load("gfx\player_taco_small.png",16,16)
		MidHandleImage TPlayer.image_taco_small
	End Function
	
	Method render()
		Super.render()
		
		Local dw:Float = 0
		Local v:Float = 0
		
		'steering
		If Self.level.active_player = Self Then
			GAME.level.ansicht_ziel_x = - Self.x + Graphics_Handler.x/5*2
			GAME.level.ansicht_ziel_y = - Self.y + Graphics_Handler.y/2
			
			dw = KeyDown(key_right) - KeyDown(key_left)
			
			v = KeyDown(key_up) - 0.7*KeyDown(key_down)
			
			If KeyboardInput.space_hit() Then
				TLamp.Create(Self.x,Self.y,[Rand(200,255),Rand(100,200),Rand(0,100)],TLight.source_normal,GAME.level)
			EndIf
			
			'change players?
			
			Local new_player_id:Int = KeyboardInput.last_numb()
			If new_player_id > -1 Then
				Self.level.set_active_player(new_player_id)
				Self.level.draw_map = 0
			EndIf
		EndIf
		
		If v <> 0 Or dw <> 0 Then' abbort navigate command
			Self.navigate_end_room = Null
			Self.navigate_next_room = Null
			Self.navigate_next_step = Null
		EndIf
		
		If Self.navigate_end_room And Not Self.level.rooms.contains(Self.navigate_end_room) Then
			Self.level.console.put("%orange%(" + Self.id + ") navigate abbort:%grey% dock changed")
			Self.navigate_end_room = Null
			Self.navigate_next_room = Null
			Self.navigate_next_step = Null
		EndIf
		
		If Self.navigate_end_room <> Null Then
			If Self.navigate_next_room = Null Then' reassign next room
				If last_room = navigate_end_room Then
					Self.navigate_next_room = navigate_end_room
					navigate_next_step = Null
				ElseIf last_room <> Null
					' get next room
					Self.level.distance_algo(Self.navigate_end_room)
					
					Self.navigate_next_room = Self.level.distance_algo_get_closest_open(last_room)
					
					If Self.navigate_next_room = Null Then
						'rint "no next room found !"
						Self.level.console.put("%orange%(" + Self.id + ") navigate abbort:%grey% no next room found.")
						
						Self.navigate_end_room = Null
						Self.navigate_next_room = Null
						Self.navigate_next_step = Null
					EndIf
				ElseIf last_room_item <> Null' assuming we are in airlock or door
					' get next room
					
					'check if door or airlock
					Local door:TRoom_Item_Door = TRoom_Item_Door(last_room_item)
					Local airlock:TRoom_Item_Airlock = TRoom_Item_Airlock(last_room_item)
					
					Self.level.distance_algo(Self.navigate_end_room)
					
					If door Then
						If door.room1.algo_n > 0 Then
							If door.room2.algo_n > 0 And door.room2.algo_n < door.room1.algo_n Then
								Self.navigate_next_room = door.room2
							Else
								Self.navigate_next_room = door.room1
							EndIf
						Else
							If door.room2.algo_n > 0 Then
								Self.navigate_next_room = door.room2
							EndIf
						EndIf
						
						navigate_next_step = Null
					ElseIf airlock Then
						' for now only if docked
						If airlock.docked Then
							
							Local room1:LEVEL_GENERATOR_ROOM = Self.level.get_room(1)
							
							If airlock.room.algo_n > 0 Then
								If room1.algo_n > 0 And room1.algo_n < airlock.room.algo_n Then
									Self.navigate_next_room = room1
								Else
									Self.navigate_next_room = airlock.room
								EndIf
							Else
								If room1.algo_n > 0 Then
									Self.navigate_next_room = room1
								EndIf
							EndIf
							
							Self.navigate_next_step = Null
						Else
							'rint "this one is not docked !"
							Self.navigate_end_room = Null
							Self.navigate_next_room = Null
							Self.navigate_next_step = Null
						EndIf
					Else
						'rint "do not understand !!! (2)"
					EndIf
				Else
					'rint "do not understand !!! (1)"
				EndIf
			Else
				'check if valid, if reached, if reachable, ...
				
				If Self.navigate_next_room = last_room Then
					Self.navigate_next_step = Null
					If Self.navigate_end_room <> last_room Then Self.navigate_next_room = Null
				EndIf
				
				'reached ?
				If Self.navigate_end_room = last_room Then
					' navigate to center of room
					
					If last_room.center_x = Int(Self.x/GAME.tile_side) And last_room.center_y = Int(Self.y/GAME.tile_side) Then
						Self.navigate_end_room = Null
						Self.navigate_next_room = Null
						Self.navigate_next_step = Null
					EndIf
					
					Local so:Float[] = Self.steer(last_room.center_x, last_room.center_y)
					dw = so[0]
					v = so[1]*2
				Else
					If last_room <> Null Then
						'in room -> find next_step -> navigate there
						
						If navigate_next_step Then
							' navigate there
							
							If navigate_next_step_pre.length = 2 Then
								Local so:Float[] = Self.steer(navigate_next_step_pre[0], navigate_next_step_pre[1])
								dw = so[0]
								v = so[1]*2
								
								If navigate_next_step_pre[0] = Int(Self.x/GAME.tile_side) And navigate_next_step_pre[1] = Int(Self.y/GAME.tile_side) Then
									navigate_next_step_pre = [0]
								EndIf
							Else
								Local so:Float[] = Self.steer(navigate_next_step.x, navigate_next_step.y)
								dw = so[0]
								v = so[1]*2
							EndIf
							
							If Not navigate_next_step.open() Then
								navigate_next_step = Null
								navigate_next_room = Null
							EndIf
						Else
							' find next_step
							
							Local d:TRoom_Item_Door = Self.level.get_door_from_rooms(last_room, navigate_next_room)
							
							If d Then
								navigate_next_step = d
								
								navigate_next_step_pre = navigate_next_step.get_pre(last_room)
							Else
								'check for airlock !!!
								
								If last_room.id = 1 Then
									navigate_next_step = Self.level.get_airlock_from_xy(Self.level.docking_x,Self.level.docking_y)
									navigate_next_step_pre = navigate_next_step.get_pre(last_room)
								Else
									If navigate_next_room Then
										If navigate_next_room.id = 1 Then
											navigate_next_step = Self.level.get_airlock_from_xy(Self.level.docking_x,Self.level.docking_y)
											navigate_next_step_pre = navigate_next_step.get_pre(last_room)
										EndIf
									EndIf
								EndIf
								
								'rint "door not found"
							EndIf
						EndIf
					Else
						'in airlock / door -> navigate to center until in room -> navigate to next door
						
						Local so:Float[] = Self.steer(navigate_next_room.center_x, navigate_next_room.center_y)
						dw = so[0]
						v = so[1]*2
					EndIf
				EndIf
			EndIf
		EndIf
						
		Self.w = ((Self.w + (dw*4)) Mod 360)
		Self.vx:+ Cos(Self.w)*v*0.8
		Self.vy:+ Sin(Self.w)*v*0.8
		
		Self.calc_collision()
		
		Self.x:+ Self.vx
		Self.y:+ Self.vy
		
		If GAME.level.draw_map=0 Then
			
			'Self.light.image = Self.light_image
			Self.light.x = Self.x+Rnd()
			Self.light.y = Self.y+Rnd()
			Self.light.w = Self.w
			Self.light.render()
			'Self.light.draw_to_buffer()
		EndIf
		
		'If Rand(100) = 1 Then Self.light.set_color(Rand(150,255),Rand(100,200),Rand(50,100))
		
		Self.vx:*0.8
		Self.vy:*0.8
		
		
		Self.level.table[Self.x/GAME.tile_side,Self.y/GAME.tile_side].visible = 2
		
		Self.last_room = Null
		Self.last_room_item = Null
		
		Select Self.level.table[Self.x/GAME.tile_side,Self.y/GAME.tile_side].obj_type
			Case 1' room
				Self.last_room = Self.level.get_room(Self.level.table[Self.x/GAME.tile_side,Self.y/GAME.tile_side].obj_id)
			Case 2' door
				Self.last_room_item = Self.level.get_door(Self.level.table[Self.x/GAME.tile_side,Self.y/GAME.tile_side].obj_id)
			Case 3' airlock
				Self.last_room_item = Self.level.get_airlock(Self.level.table[Self.x/GAME.tile_side,Self.y/GAME.tile_side].obj_id)
		EndSelect
	End Method
	
	Method steer:Float[](x:Int,y:Int)
		
		x = x*GAME.tile_side + GAME.tile_side/2 ' transforming to drone coordinates
		y = y*GAME.tile_side + GAME.tile_side/2
		Local dw:Float = 0
		Local s:Float = 0
		
		Local angle:Float = (ATan2(y-Self.y, x - Self.x)+360) Mod 360
		Self.w = ((Self.w) + 360) Mod 360
		
		Print "a:" + angle + ", w:" + Self.w
		
		
		
		If angle > Self.w Then
			If (angle-Self.w) < 180 Then
				dw = 1
				If (angle - Self.w) < 5 Then s = 1
			Else
				dw = -1
			EndIf
		Else
			If (angle-Self.w) > -180 Then
				dw = -1
				If (Self.w - angle) < 5 Then s = 1
			Else
				dw = 1
			EndIf
		EndIf
		
		Rem
		
		If (angle - Self.w) > 0 Or (angle - Self.w) < 180 Then
			' stear positive: angle - Self.w
			dw = 1
			If (angle - Self.w) > 5 Then
				dw = 1
			Else
				s = 1
			EndIf
		Else
			' stear negative:
			dw = -1
			If (Self.w - angle) > 5 Then
				dw = -1
			Else
				s = 1
			EndIf
		EndIf
		End Rem
		
		Rem
		If Abs( (angle - Self.w + 360.0) Mod 360) < 5 Then s = 1
		
		If angle < Self.w Then dw = -1
		If angle > Self.w Then dw = 1
		End Rem
		'dw = 1
		
		Return [dw,s]
	End Method
	
	Field last_room:LEVEL_GENERATOR_ROOM' used for positioning
	Field last_room_item:TRoom_Item_DA
	
	Field navigate_end_room:LEVEL_GENERATOR_ROOM
	Field navigate_next_room:LEVEL_GENERATOR_ROOM
	Field navigate_next_step:TRoom_Item_DA' airlock or door that connects current to next room
	Field navigate_next_step_pre:Int[]
	
	Method send_to_room(r:LEVEL_GENERATOR_ROOM)
		Self.level.console.put("%green%(" + Self.id + ") navigate r" + r.id)
		
		Self.navigate_end_room = r
		Self.navigate_next_room = Null
		Self.navigate_next_step = Null
	End Method
	
	Method draw()
		SetColor 255,255,255
		SetRotation Self.w
		Draw_Image TPlayer.image, GAME.level.ansicht_act_x + Self.x, GAME.level.ansicht_act_y + Self.y
		SetRotation 0
		
	End Method
	
	Method draw_small()
		
		Local scaling:Float = Float(GAME.tile_side_small)/Float(GAME.tile_side)
		
		SetColor 255,255,255
		SetRotation Self.w
		Draw_Image TPlayer.image_small, GAME.level.map_offset_x + (Self.x*scaling), GAME.level.map_offset_y + (Self.y*scaling)
		SetRotation 0
		
	End Method
	
	Method draw_taco()
		
		
		SetColor 255,255,255
		SetRotation Self.w
		Draw_Image TPlayer.image_taco, GAME.level.ansicht_act_x + Self.x, GAME.level.ansicht_act_y + Self.y
		SetRotation 0
		
		SetColor 100,255,255
		Local txt:String = id		
		Draw_Text txt, GAME.level.ansicht_act_x + Self.x - TextWidth(txt)/2,20+GAME.level.ansicht_act_y + Self.y - TextHeight(txt)/2
		
		If Self.navigate_end_room Then
			SetColor 255,0,0
			Local rx:Int = GAME.level.ansicht_act_x + Self.navigate_end_room.center_x*GAME.tile_side
			Local ry:Int = GAME.level.ansicht_act_y + Self.navigate_end_room.center_y*GAME.tile_side
			
			Draw_Line GAME.level.ansicht_act_x + Self.x, GAME.level.ansicht_act_y + Self.y, rx, ry
		EndIf
		
		If Self.navigate_next_room Then
			SetColor 255,255,0
			Local rx:Int = GAME.level.ansicht_act_x + Self.navigate_next_room.center_x*GAME.tile_side
			Local ry:Int = GAME.level.ansicht_act_y + Self.navigate_next_room.center_y*GAME.tile_side
			
			Draw_Line GAME.level.ansicht_act_x + Self.x, GAME.level.ansicht_act_y + Self.y, rx, ry
		EndIf
		
		If Self.navigate_next_step Then
			SetColor 255,0,255
			Local rx:Int = GAME.level.ansicht_act_x + Self.navigate_next_step.x*GAME.tile_side
			Local ry:Int = GAME.level.ansicht_act_y + Self.navigate_next_step.y*GAME.tile_side
			
			Draw_Line GAME.level.ansicht_act_x + Self.x, GAME.level.ansicht_act_y + Self.y, rx, ry
		EndIf
		
	End Method
	
	Method draw_taco_small()
		Local scaling:Float = Float(GAME.tile_side_small)/Float(GAME.tile_side)
		
		SetColor 255,255,255
		SetRotation Self.w
		Draw_Image TPlayer.image_taco_small, GAME.level.map_offset_x + (Self.x*scaling), GAME.level.map_offset_y + (Self.y*scaling)
		SetRotation 0
		
		SetColor 100,255,255
		Local txt:String = id
		Draw_Text txt, GAME.level.map_offset_y + (Self.x*scaling) - TextWidth(txt)/2,10+GAME.level.map_offset_y + (Self.y*scaling) - TextHeight(txt)/2
	End Method
	
End Type

'########################################################################################
'###########################        #####################################################
'###########################  ENEMY #####################################################
'###########################        #####################################################
'########################################################################################

Type TEnemy Extends TMob
	
	Global image:TImage
		
	Field level:TLevel
	
	Function Create:TEnemy(x:Float,y:Float,l:TLevel)
		Local p:TEnemy = New TEnemy
		
		p.r = 20
		
		p.x = x
		p.y = y
		
		l.objects.addlast(p)
		
		p.level = l
		
		Return p
	End Function
	
	Function ini()
		TEnemy.image = ImageLoader.Load("gfx\enemy.png",64,64)
		MidHandleImage TEnemy.image
	End Function
	
	Method render()
		Super.render()
		
		Local dw:Float = 0
		Local v:Float = 0
				
		If v <> 0 Or dw <> 0 Then' abbort navigate command
			Self.navigate_end_room = Null
			Self.navigate_next_room = Null
			Self.navigate_next_step = Null
		EndIf
		
		If Self.navigate_end_room And Not Self.level.rooms.contains(Self.navigate_end_room) Then
			'Self.level.console.put("%p%(enemy) navigate abbort:%grey% dock changed")
			Self.navigate_end_room = Null
			Self.navigate_next_room = Null
			Self.navigate_next_step = Null
		EndIf
		
		If Self.navigate_end_room <> Null Then
			If Self.navigate_next_room = Null Then' reassign next room
				If last_room = navigate_end_room Then
					Self.navigate_next_room = navigate_end_room
					navigate_next_step = Null
				ElseIf last_room <> Null
					' get next room
					Self.level.distance_algo(Self.navigate_end_room)
					
					Self.navigate_next_room = Self.level.distance_algo_get_closest_open(last_room)
					
					If Self.navigate_next_room = Null Then
						'rint "no next room found !"
						'Self.level.console.put("%p%(enemy) navigate abbort:%grey% no next room found.")
						
						Self.navigate_end_room = Null
						Self.navigate_next_room = Null
						Self.navigate_next_step = Null
					EndIf
				ElseIf last_room_item <> Null' assuming we are in airlock or door
					' get next room
					
					'check if door or airlock
					Local door:TRoom_Item_Door = TRoom_Item_Door(last_room_item)
					Local airlock:TRoom_Item_Airlock = TRoom_Item_Airlock(last_room_item)
					
					Self.level.distance_algo(Self.navigate_end_room)
					
					If door Then
						If door.room1.algo_n > 0 Then
							If door.room2.algo_n > 0 And door.room2.algo_n < door.room1.algo_n Then
								Self.navigate_next_room = door.room2
							Else
								Self.navigate_next_room = door.room1
							EndIf
						Else
							If door.room2.algo_n > 0 Then
								Self.navigate_next_room = door.room2
							EndIf
						EndIf
						
						navigate_next_step = Null
					ElseIf airlock Then
						' for now only if docked
						If airlock.docked Then
							
							Local room1:LEVEL_GENERATOR_ROOM = Self.level.get_room(1)
							
							If airlock.room.algo_n > 0 Then
								If room1.algo_n > 0 And room1.algo_n < airlock.room.algo_n Then
									Self.navigate_next_room = room1
								Else
									Self.navigate_next_room = airlock.room
								EndIf
							Else
								If room1.algo_n > 0 Then
									Self.navigate_next_room = room1
								EndIf
							EndIf
							
							Self.navigate_next_step = Null
						Else
							'rint "this one is not docked !"
							Self.navigate_end_room = Null
							Self.navigate_next_room = Null
							Self.navigate_next_step = Null
						EndIf
					Else
						'rint "do not understand !!! (2)"
					EndIf
				Else
					'rint "do not understand !!! (1)"
				EndIf
			Else
				'check if valid, if reached, if reachable, ...
				
				If Self.navigate_next_room = last_room Then
					Self.navigate_next_step = Null
					If Self.navigate_end_room <> last_room Then Self.navigate_next_room = Null
				EndIf
				
				'reached ?
				If Self.navigate_end_room = last_room Then
					' navigate to center of room
					
					If last_room.center_x = Int(Self.x/GAME.tile_side) And last_room.center_y = Int(Self.y/GAME.tile_side) Then
						Self.navigate_end_room = Null
						Self.navigate_next_room = Null
						Self.navigate_next_step = Null
					EndIf
					
					Local so:Float[] = Self.steer(last_room.center_x, last_room.center_y)
					dw = so[0]
					v = so[1]*2
				Else
					If last_room <> Null Then
						'in room -> find next_step -> navigate there
						
						If navigate_next_step Then
							' navigate there
							
							If navigate_next_step_pre.length = 2 Then
								Local so:Float[] = Self.steer(navigate_next_step_pre[0], navigate_next_step_pre[1])
								dw = so[0]
								v = so[1]*2
								
								If navigate_next_step_pre[0] = Int(Self.x/GAME.tile_side) And navigate_next_step_pre[1] = Int(Self.y/GAME.tile_side) Then
									navigate_next_step_pre = [0]
								EndIf
							Else
								Local so:Float[] = Self.steer(navigate_next_step.x, navigate_next_step.y)
								dw = so[0]
								v = so[1]*2
							EndIf
							
							If Not navigate_next_step.open() Then
								navigate_next_step = Null
								navigate_next_room = Null
							EndIf
						Else
							' find next_step
							
							Local d:TRoom_Item_Door = Self.level.get_door_from_rooms(last_room, navigate_next_room)
							
							If d Then
								navigate_next_step = d
								
								navigate_next_step_pre = navigate_next_step.get_pre(last_room)
							Else
								'check for airlock !!!
								
								If last_room.id = 1 Then
									navigate_next_step = Self.level.get_airlock_from_xy(Self.level.docking_x,Self.level.docking_y)
									navigate_next_step_pre = navigate_next_step.get_pre(last_room)
								Else
									If navigate_next_room Then
										If navigate_next_room.id = 1 Then
											navigate_next_step = Self.level.get_airlock_from_xy(Self.level.docking_x,Self.level.docking_y)
											navigate_next_step_pre = navigate_next_step.get_pre(last_room)
										EndIf
									EndIf
								EndIf
								
								'rint "door not found"
							EndIf
						EndIf
					Else
						'in airlock / door -> navigate to center until in room -> navigate to next door
						
						Local so:Float[] = Self.steer(navigate_next_room.center_x, navigate_next_room.center_y)
						dw = so[0]
						v = so[1]*2
					EndIf
				EndIf
			EndIf
		EndIf
						
		Self.w = ((Self.w + (dw*4)) Mod 360)
		Self.vx:+ Cos(Self.w)*v*0.8
		Self.vy:+ Sin(Self.w)*v*0.8
		
		Self.calc_collision()
		
		Self.x:+ Self.vx
		Self.y:+ Self.vy
				
		'If Rand(100) = 1 Then Self.light.set_color(Rand(150,255),Rand(100,200),Rand(50,100))
		
		Self.vx:*0.8
		Self.vy:*0.8
		
		
		Self.level.table[Self.x/GAME.tile_side,Self.y/GAME.tile_side].visible = 2
		
		Self.last_room = Null
		Self.last_room_item = Null
		
		Select Self.level.table[Self.x/GAME.tile_side,Self.y/GAME.tile_side].obj_type
			Case 1' room
				Self.last_room = Self.level.get_room(Self.level.table[Self.x/GAME.tile_side,Self.y/GAME.tile_side].obj_id)
			Case 2' door
				Self.last_room_item = Self.level.get_door(Self.level.table[Self.x/GAME.tile_side,Self.y/GAME.tile_side].obj_id)
			Case 3' airlock
				Self.last_room_item = Self.level.get_airlock(Self.level.table[Self.x/GAME.tile_side,Self.y/GAME.tile_side].obj_id)
		EndSelect
		
		If Self.navigate_end_room = Null Then
			'reassing random new room
			Local ran:Int = Rand(0,Self.level.rooms.count()-1)
			
			Local i:Int = 0
			For Local rr:LEVEL_GENERATOR_ROOM = EachIn Self.level.rooms
				If i = ran Then
					Self.send_to_room(rr)
				EndIf
				
				i:+1
			Next
		EndIf
	End Method
	
	Method steer:Float[](x:Int,y:Int)
		
		x = x*GAME.tile_side + GAME.tile_side/2 ' transforming to drone coordinates
		y = y*GAME.tile_side + GAME.tile_side/2
		Local dw:Float = 0
		Local s:Float = 0
		
		Local angle:Float = ATan2(y-Self.y, x - Self.x)
		
		If Abs( (angle - Self.w + 360.0) Mod 360) < 5 Then s = 1
		
		If angle < Self.w Then dw = -1
		If angle > Self.w Then dw = 1
		'dw = 1
		
		Return [dw,s]
	End Method
	
	Field last_room:LEVEL_GENERATOR_ROOM' used for positioning
	Field last_room_item:TRoom_Item_DA
	
	Field navigate_end_room:LEVEL_GENERATOR_ROOM
	Field navigate_next_room:LEVEL_GENERATOR_ROOM
	Field navigate_next_step:TRoom_Item_DA' airlock or door that connects current to next room
	Field navigate_next_step_pre:Int[]
	
	Method send_to_room(r:LEVEL_GENERATOR_ROOM)
		'Self.level.console.put("%pink%(enemy) navigate r" + r.id)
		
		Self.navigate_end_room = r
		Self.navigate_next_room = Null
		Self.navigate_next_step = Null
	End Method
	
	Method draw()
		SetColor 255,255,255
		SetRotation Self.w
		Draw_Image TEnemy.image, GAME.level.ansicht_act_x + Self.x, GAME.level.ansicht_act_y + Self.y
		SetRotation 0
		
	End Method
	
	Method draw_small()
	End Method
	
	Method draw_taco()
	End Method
	
	Method draw_taco_small()
	End Method
	
End Type


'########################################################################################
'###########################        #####################################################
'###########################  BOT   #####################################################
'###########################        #####################################################
'########################################################################################

Type TBot Extends TMob
	
	Global image:TImage
	
	Field light:TLight
	
	Field w:Float
	
	Field aim_x:Int = -1
	Field aim_y:Int = -1
	Field aim_direction:Int
	
	Function Create:TBot(x:Float,y:Float,l:TLevel)
		Local p:TBot = New TBot
		
		p.r = 20
		
		p.x = x
		p.y = y
		
		p.aim_x = p.x
		p.aim_y = p.y
		
		l.objects.addlast(p)
		
		p.light = TLight.Create(TLight.source_bot1,0,0)
		p.light.set_color(Rand(0,255),Rand(0,255),Rand(0,255))
		p.light.shadow = 0
		
		Return p
	End Function
	
	Function ini()
		TBot.image = ImageLoader.Load("gfx\bot1.png",64,64)
		MidHandleImage TBot.image
	End Function
	
	Method render()
		Super.render()
		
		If ((Self.aim_x-Self.x)^2 + (Self.aim_y-Self.y)^2) < 25 Then
			
			Local cur_x:Int = Floor(Self.x/GAME.tile_side)
			Local cur_y:Int = Floor(Self.y/GAME.tile_side)
			
			
			
			Select Self.aim_direction
				Case 0
					If GAME.level.has_collision(cur_x+1, cur_y) = 0 Then
						Self.aim_x = (cur_x + 1)*GAME.tile_side + GAME.tile_side/2
						Self.aim_y = cur_y*GAME.tile_side + GAME.tile_side/2
						
						Self.aim_direction = [0,0,0,0,0,0,1,2,3][Rand(0,8)]
					Else
						Self.aim_direction = [1,2,3][Rand(0,2)]
					EndIf
				Case 1
					If GAME.level.has_collision(cur_x-1, cur_y) = 0 Then
						Self.aim_x = (cur_x - 1)*GAME.tile_side + GAME.tile_side/2
						Self.aim_y = cur_y*GAME.tile_side + GAME.tile_side/2
						
						Self.aim_direction = [1,1,1,1,1,1,0,2,3][Rand(0,8)]
					Else
						Self.aim_direction = [0,2,3][Rand(0,2)]
					EndIf
				Case 2
					If GAME.level.has_collision(cur_x, cur_y+1) = 0 Then
						Self.aim_x = cur_x*GAME.tile_side + GAME.tile_side/2
						Self.aim_y = (cur_y + 1)*GAME.tile_side + GAME.tile_side/2
						
						Self.aim_direction = [2,2,2,2,2,2,0,1,3][Rand(0,8)]
					Else
						Self.aim_direction = [0,1,3][Rand(0,2)]
					EndIf
				Case 3
					If GAME.level.has_collision(cur_x, cur_y-1) = 0 Then
						Self.aim_x = cur_x*GAME.tile_side + GAME.tile_side/2
						Self.aim_y = (cur_y - 1)*GAME.tile_side + GAME.tile_side/2
						
						Self.aim_direction = [3,3,3,3,3,3,0,1,2][Rand(0,8)]
					Else
						Self.aim_direction = [0,1,2][Rand(0,2)]
					EndIf
			End Select
		EndIf
		
		Local ww:Float = ATan2(Self.y - Self.aim_y, Self.x - Self.aim_x)-180
		
		Self.vx:+Cos(ww)*0.5
		Self.vy:+Sin(ww)*0.5
		
		Self.w = ATan2(Self.vy, Self.vx)
		
		Self.calc_collision()
		
		Self.x:+ Self.vx
		Self.y:+ Self.vy
		
		
		
		'Self.light.image = Self.light_image
		Self.light.x = Self.x
		Self.light.y = Self.y
		Self.light.w = Self.w
		Self.light.render()
		'Self.light.draw_to_buffer()
		
		
		Self.vx:*0.9
		Self.vy:*0.9
	End Method
	
	Method draw()
		SetColor 255,255,255
		SetRotation Self.w
		Draw_Image TBot.image, GAME.level.ansicht_act_x + Self.x, GAME.level.ansicht_act_y + Self.y
		SetRotation 0
	End Method
	
End Type

'########################################################################################
'###########################                    #########################################
'########################### GAME ERROR HANDLER #########################################
'###########################                    #########################################
'########################################################################################

Type GAME_ERROR_HANDLER
	Function error(txt:String)
		Print "### ERROR ###"
		Print
		Print txt
		Print
		Print "#############"
		Print
		
		Notify(txt,True)
	End Function
End Type
'########################################################################################
'###########################            #################################################
'########################### GFUNCTIONS #################################################
'###########################            #################################################
'########################################################################################

Function Draw_Image(image:TImage,x#,y#,frame:Int=0)
	DrawImage(image,x+Graphics_Handler.origin_x,y+Graphics_Handler.origin_y,frame)
End Function

Function Draw_Poly(a:Float[],x:Float,y:Float)
	Local aa:Float[]
	
	For Local i:Int = 0 To a.length/2-1
		aa:+ [a[2*i] + x+Graphics_Handler.origin_x + GAME.level.ansicht_act_x, a[2*i+1] + y+Graphics_Handler.origin_y + GAME.level.ansicht_act_y]
	Next
	
	DrawPoly aa
End Function

Function Draw_Text( t$,x#,y# )
	DrawText(t,x+Graphics_Handler.origin_x,y+Graphics_Handler.origin_y)
End Function

Function Draw_Rect( x#,y#,width#,height# )
	DrawRect(x+Graphics_Handler.origin_x,y+Graphics_Handler.origin_y,width#,height# )
End Function

Function Draw_Line( x#,y#,x2#,y2# )
	DrawLine(x+Graphics_Handler.origin_x,y+Graphics_Handler.origin_y,x2+Graphics_Handler.origin_x,y2+Graphics_Handler.origin_y)
End Function

'########################################################################################
'###########################                   ##########################################
'########################### Graphics Handler  ##########################################
'###########################                   ##########################################
'########################################################################################

Type Graphics_Handler
	Global origin_x:Int = 0
	Global origin_y:Int = 0
	
	Global x:Int
	Global y:Int
	
	Global mode:Int
		
	Function get_max_x:Int()
		Local x:Int = 0
		For Local g:TGraphicsMode = EachIn GraphicsModes()
			If g.width > x Then x = g.width
		Next
		Return x
	End Function
	
	Function get_max_y:Int()
		Local y:Int = 0
		For Local g:TGraphicsMode = EachIn GraphicsModes()
			If g.height > y Then y = g.height
		Next
		Return y
	End Function
	
	Global font_30:TImageFont
	Global font_15:TImageFont
	Global font_20:TImageFont
	
	Function set_graphics(x:Int,y:Int,mode:Int=0)
		
		SetGraphicsDriver(GLMax2DDriver())
		
		Graphics_Handler.mode = mode
		Graphics_Handler.x = x
		Graphics_Handler.y = y
		Select mode
			Case 0
				Graphics(x,y)
				Graphics_Handler.origin_x = 0
				Graphics_Handler.origin_y = 0
			Case 1
				Graphics(x,y,32)
				Graphics_Handler.origin_x = 0
				Graphics_Handler.origin_y = 0
			Case 2
				Graphics_Handler.origin_x = (Graphics_Handler.get_max_x()-x)/2
				Graphics_Handler.origin_y = (Graphics_Handler.get_max_y()-y)/2
				
				Graphics(Graphics_Handler.get_max_x(), Graphics_Handler.get_max_y(),32)
				SetOrigin(Graphics_Handler.origin_x,Graphics_Handler.origin_y)
				SetViewport(Graphics_Handler.origin_x,Graphics_Handler.origin_y,x,y)
		End Select
		
		glewInit()
		
		SetBlend ALPHABLEND
		SetClsColor 255,255,255
		
		TBuffer.light_mix = TBuffer.Create(Graphics_Handler.x)'1024
		
		
		
		Graphics_Handler.font_30 = LoadImageFont("incbin::font2.ttf", 30,SMOOTHFONT)' # LOAD FONT #
		Graphics_Handler.font_15 = LoadImageFont("incbin::font2.ttf", 15,SMOOTHFONT)
		
		Graphics_Handler.font_20 = LoadImageFont("incbin::font2.ttf", 20,SMOOTHFONT)
		
		SetImageFont Graphics_Handler.font_30
		
	End Function
	
	Function set_normal()
		
		Select Graphics_Handler.mode
			Case 0
				SetOrigin(0,0)
				SetViewport(0,0,Graphics_Handler.x,Graphics_Handler.y)
			Case 1
				SetOrigin(0,0)
				SetViewport(0,0,Graphics_Handler.x,Graphics_Handler.y)
			Case 2
				SetOrigin(Graphics_Handler.origin_x,Graphics_Handler.origin_y)
				SetViewport(Graphics_Handler.origin_x,Graphics_Handler.origin_y,Graphics_Handler.x,Graphics_Handler.y)
		End Select
		
		SetBlend ALPHABLEND
		SetClsColor 255,255,255
	End Function
	
	
End Type

'########################################################################################
'###########################                   ##########################################
'########################### Graphics Handler  ##########################################
'###########################                   ##########################################
'########################################################################################

Type TBuffer
	'lights buffer - buffer
	
	'light list - buffers
	
	Global light_mix:TBuffer'final mix
	
	Field buffer_image:TImage
	Field buffer:TImageBuffer
	
	Field side:Int
	
	
	Function Create:TBuffer(s:Int)
		Local b:TBuffer = New TBuffer
		
		b.side = s
		
		b.buffer_image = CreateImage(b.side,b.side)
		
		b.buffer = TImageBuffer.SetBuffer(b.buffer_image)
		
		b.set_normal()
		
		Return b
	End Function
	
	Method set_me()
		Self.buffer.BindBuffer()
	End Method
	
	Method set_normal()
		Self.buffer.UnBindBuffer()
		
		Graphics_Handler.set_normal()
	End Method
	
	Method cls_me(r:Float = 0.0, g:Float = 0.0, b:Float = 0.0, a:Float = 1.0)
		Self.set_me()
		Self.buffer.Cls(r,g,b,a)
		Self.set_normal()
	End Method
	
	Method draw(x:Float,y:Float)
		
		SetScale 1,-1
		DrawImage Self.buffer_image,x,y + Self.side
		SetScale 1,1
		
	End Method
End Type

'########################################################################################
'###########################                   ##########################################
'###########################       TLIGHT      ##########################################
'###########################                   ##########################################
'########################################################################################

Type TLight
	Global frame_rendered:Int = 0
	
	Field x:Float
	Field y:Float
	
	Field last_x:Float
	Field last_y:Float
	Field last_w:Float
	
	Field last_r:Float
	Field last_g:Float
	Field last_b:Float
	
	Field w:Float = 0.0
	
	Field image:TImage
	Field r:Float
	
	Field shadow:Int = 1
	
	Field buffer:TBuffer
	
	Global source_normal:TImage
	Global source_spot:TImage
	Global source_treasure:TImage
	Global source_big:TImage
	Global source_super_big:TImage
	Global source_small:TImage
	Global source_shot:TImage
	Global source_bot1:TImage
	Global source_spot_big:TImage

	Field rot:Float = 255
	Field gruen:Float = 255
	Field blau:Float = 255
	
	Method set_color(r:Int,g:Int,b:Int)
		Self.rot = r
		Self.gruen = g
		Self.blau = b
	End Method
	
	Function init()
		TLight.source_normal = LoadImage("lights\normal.png")
		MidHandleImage TLight.source_normal
		TLight.source_spot = LoadImage("lights\spot.png")
		MidHandleImage TLight.source_spot
		TLight.source_treasure = LoadImage("lights\treasure.png")
		MidHandleImage TLight.source_treasure
		
		TLight.source_big = LoadImage("lights\big.png")
		MidHandleImage TLight.source_big
		
		TLight.source_super_big = LoadImage("lights\super_big.png")
		MidHandleImage TLight.source_super_big
		
		TLight.source_small = LoadImage("lights\small.png")
		MidHandleImage TLight.source_small
		
		TLight.source_shot = LoadImage("lights\shot.png")
		MidHandleImage TLight.source_shot
		
		TLight.source_bot1 = LoadImage("lights\bot1.png")
		MidHandleImage TLight.source_bot1
		
		TLight.source_spot_big = LoadImage("lights\spot_big.png")
		MidHandleImage TLight.source_spot_big
		
		
	End Function
	
	Function Create:TLight(image:TImage,x:Float,y:Float)
		Local l:TLight = New TLight
		
		l.x = x
		l.y = y
		
		l.image = image
		l.r = image.width/2
		
		l.buffer = TBuffer.Create(image.width)
		
		Return l
	End Function
	
	Method render()
		
		If Rand(0,10)>0 And Self.x = Self.last_x And Self.y = Self.last_y And Self.w = Self.last_w And Self.rot = Self.last_r And Self.gruen = Self.last_g And Self.blau = Self.last_b Then
			'nothing
		Else
			TLight.frame_rendered:+1
			
			Self.last_x = Self.x
			Self.last_y = Self.y
			Self.last_w = Self.w
			
			Self.last_r = Self.rot
			Self.last_g = Self.gruen
			Self.last_b = Self.blau
			
			Self.buffer.set_me()
			
			SetColor Self.rot, Self.gruen, Self.blau
			SetBlend alphablend
			SetRotation Self.w
			DrawImage Self.image,Self.r,Self.r
			SetRotation 0
			SetBlend solidblend
			SetColor 255,255,255
			'TRIANGLES.set_tex(LockImage(Self.image))
			'UnlockImage(Self.image)
			
			If Self.shadow Then
				
				Local x1:Int = (Self.x - Self.r)/GAME.tile_side
				Local x2:Int = (Self.x + Self.r)/GAME.tile_side
				
				Local y1:Int = (Self.y - Self.r)/GAME.tile_side
				Local y2:Int = (Self.y + Self.r)/GAME.tile_side
				
				If x1 < 0 Then x1 = 0
				If y1 < 0 Then y1 = 0
				
				If x2 > GAME.level.table_x-1 Then x2 = GAME.level.table_x-1
				If y2 > GAME.level.table_y-1 Then y2 = GAME.level.table_y-1
				
				For Local x:Int = x1 To x2
					For Local y:Int = y1 To y2
						
						If GAME.level.table[x,y].collision = 1 Then
							Local b_x:Float = Self.r-Self.x + x*GAME.tile_side
							Local b_y:Float = Self.r-Self.y + y*GAME.tile_side
							
							If b_x < Self.r And b_x + GAME.tile_side > Self.r Then
								
								If b_y > Self.r Then
									
									Local w1:Float = ATan2(b_y - Self.r, b_x - Self.r)
									Local w2:Float = ATan2(b_y - Self.r, b_x + GAME.tile_side - Self.r)
									
									SetColor 0,0,0
									
									Local a:Float [] = [b_x + GAME.tile_side, b_y, b_x, b_y, Float(Self.r + Cos(w1)*Self.r*2.0), Float(Self.r + Sin(w1)*Self.r*2.0), Float(Self.r + Cos(w2)*Self.r*2.0), Float(Self.r + Sin(w2)*Self.r*2.0)]
									
									DrawPoly a
								Else
									
									
									Local w2:Float = ATan2(b_y  + GAME.tile_side - Self.r, b_x - Self.r)
									Local w1:Float = ATan2(b_y  + GAME.tile_side  - Self.r, b_x  + GAME.tile_side - Self.r)
									
									SetColor 0,0,0
									
									Local a:Float [] = [b_x, b_y  + GAME.tile_side, b_x  + GAME.tile_side, b_y  + GAME.tile_side, Float(Self.r + Cos(w1)*Self.r*2.0), Float(Self.r + Sin(w1)*Self.r*2.0), Float(Self.r + Cos(w2)*Self.r*2.0), Float(Self.r + Sin(w2)*Self.r*2.0)]
									
									DrawPoly a
								End If
								
							ElseIf b_y < Self.r And b_y + GAME.tile_side > Self.r Then
								
								If b_x > Self.r Then
									
									Local w2:Float = ATan2(b_y - Self.r, b_x - Self.r)
									Local w1:Float = ATan2(b_y + GAME.tile_side - Self.r, b_x - Self.r)
									
									SetColor 0,0,0
									
									Local a:Float [] = [b_x, b_y, b_x, b_y + GAME.tile_side, Float(Self.r + Cos(w1)*Self.r*2.0), Float(Self.r + Sin(w1)*Self.r*2.0), Float(Self.r + Cos(w2)*Self.r*2.0), Float(Self.r + Sin(w2)*Self.r*2.0)]
									
									DrawPoly a
								Else
									
									Local w1:Float = ATan2(b_y - Self.r, b_x + GAME.tile_side - Self.r)
									Local w2:Float = ATan2(b_y + GAME.tile_side - Self.r, b_x + GAME.tile_side - Self.r)
									
									SetColor 0,0,0
									
									Local a:Float [] = [b_x + GAME.tile_side, b_y + GAME.tile_side, b_x + GAME.tile_side, b_y, Float(Self.r + Cos(w1)*Self.r*2.0), Float(Self.r + Sin(w1)*Self.r*2.0), Float(Self.r + Cos(w2)*Self.r*2.0), Float(Self.r + Sin(w2)*Self.r*2.0)]
									
									DrawPoly a
								End If
								
							ElseIf b_x > Self.r Then
								
								If b_y > Self.r Then
									
									Local w1:Float = ATan2(b_y + GAME.tile_side - Self.r, b_x - Self.r)
									Local w2:Float = ATan2(b_y - Self.r, b_x + GAME.tile_side - Self.r)
									
									SetColor 0,0,0
									
									Local a:Float [] = [b_x + GAME.tile_side, b_y, b_x, b_y, b_x, b_y + GAME.tile_side, Float(Self.r + Cos(w1)*Self.r*2.0), Float(Self.r + Sin(w1)*Self.r*2.0), Float(Self.r + Cos(w2)*Self.r*2.0), Float(Self.r + Sin(w2)*Self.r*2.0)]
									
									DrawPoly a
								Else
									Local w2:Float = ATan2(b_y - Self.r, b_x - Self.r)
									Local w1:Float = ATan2(b_y + GAME.tile_side - Self.r, b_x + GAME.tile_side - Self.r)
									
									SetColor 0,0,0
									
									Local a:Float [] = [b_x, b_y, b_x, b_y + GAME.tile_side, b_x + GAME.tile_side, b_y + GAME.tile_side, Float(Self.r + Cos(w1)*Self.r*2.0), Float(Self.r + Sin(w1)*Self.r*2.0), Float(Self.r + Cos(w2)*Self.r*2.0), Float(Self.r + Sin(w2)*Self.r*2.0)]
									
									DrawPoly a
								End If
								
							Else
								
								If b_y > Self.r Then
									
									Local w2:Float = ATan2(b_y + GAME.tile_side - Self.r, b_x +  + GAME.tile_side - Self.r)
									Local w1:Float = ATan2(b_y - Self.r, b_x - Self.r)
									
									SetColor 0,0,0
									
									Local a:Float [] = [b_x +  + GAME.tile_side, b_y +  + GAME.tile_side, b_x +  + GAME.tile_side, b_y, b_x, b_y, Float(Self.r + Cos(w1)*Self.r*2.0), Float(Self.r + Sin(w1)*Self.r*2.0), Float(Self.r + Cos(w2)*Self.r*2.0), Float(Self.r + Sin(w2)*Self.r*2.0)]
									
									DrawPoly a
								Else
									Local w1:Float = ATan2(b_y - Self.r, b_x + GAME.tile_side - Self.r)
									Local w2:Float = ATan2(b_y + GAME.tile_side - Self.r, b_x - Self.r)
									
									SetColor 0,0,0
									
									Local a:Float [] = [b_x, b_y + GAME.tile_side, b_x + GAME.tile_side, b_y + GAME.tile_side, b_x + GAME.tile_side, b_y, Float(Self.r + Cos(w1)*Self.r*2.0), Float(Self.r + Sin(w1)*Self.r*2.0), Float(Self.r + Cos(w2)*Self.r*2.0), Float(Self.r + Sin(w2)*Self.r*2.0)]
									
									DrawPoly a
								End If
								
							End If
							
							
							'DrawRect b_x, b_y, GAME.tile_side, GAME.tile_side
							
						End If
						
					Next
				Next
			EndIf
		EndIf
		
		'Self.buffer.set_normal()
		TBuffer.light_mix.set_me()
		
		SetBlend lightblend
		SetColor 255,255,255
		Self.buffer.draw( GAME.level.ansicht_act_x + Self.x - Self.r, GAME.level.ansicht_act_y + Self.y - Self.r)
		
		SetBlend alphablend
		
		TBuffer.light_mix.set_normal()
	End Method
	
	Rem
	Method draw_to_buffer()
		TBuffer.light_mix.set_me()
		
		SetBlend lightblend
		SetColor 255,255,255
		Self.buffer.draw( GAME.level.ansicht_act_x + Self.x - Self.r, GAME.level.ansicht_act_y + Self.y - Self.r)
		
		SetBlend alphablend
		
		TBuffer.light_mix.set_normal()
	End Method
	End Rem
End Type

'########################################################################################
'###########################                   ##########################################
'###########################   GLTRIANGLES     ##########################################
'###########################                   ##########################################
'########################################################################################

Type TRIANGLES
	Global act_pix:TPixmap
	
	Function start()
		glBegin GL_TRIANGLE_STRIP'GL_TRIANGLES
	End Function
	
	Function set(x:Float,y:Float,r:Int,g:Int,b:Int)
		glColor3ub(r,g,b)
		
		If TRIANGLES.act_pix Then glTexCoord2f( x/TRIANGLES.act_pix.width, y/TRIANGLES.act_pix.height)
		
		glVertex2f (x/256.0), (y/256.0)
	End Function
	
	Function stop()
		glEnd
	End Function
	
	Function set_tex(pixmap:TPixmap)
		TRIANGLES.act_pix = pixmap
		glbindtexture(GL_TEXTURE_2D, GLTexFromPixmap( pixmap ))
		glenable GL_TEXTURE_2D
	End Function
End Type

'########################################################################################
'###########################                   ##########################################
'###########################  Loading Screen   ##########################################
'###########################                   ##########################################
'########################################################################################

Type LoadingScreen
	
	Function init()
		AppTitle = "GAME Loading ..."
		Graphics 300,300
		
		'SetClsColor 100,50,20
	End Function
	
	Function render_image()
		Cls
		
		SetColor 255,255,255
		
		DrawRect (MilliSecs()/5 Mod 250), 100, 50, 100
		
		If KeyHit(key_escape) Then End
		If AppTerminate() Then End
		
		Flip
	End Function
	
	Function run_loader:Object( data:Object )
		SetMaskColor(255,0,255)
		
		KeyboardInput.init()
		
		TLight.init()
		
		TPlayer.ini()
		TEnemy.ini()
		
		TBot.ini()
		
		TLamp.ini()
		
		TShot.ini()
		
		GAME.ini()
		
		HideMouse()
	End Function
End Type


'########################################################################################
'###########################                   ##########################################
'###########################  Keyboard Input   ##########################################
'###########################                   ##########################################
'########################################################################################

Type KeyboardInput
	Global alphabet:TMap
	Global numbers:TMap
	
	Global text:String
	Global numb:String
	
	Global command_to_execute:String
	
	Global hit_space:Int = 0
	Global hit_enter:Int = 0
	
	Function space_hit:Int()
		If hit_space = 1 Then
			hit_space = 0
			Return True
		EndIf
		
		Return False
	End Function
	
	Function last_numb:Int()'returns -1 if none stored
		If numb <> "" Then
			'rint "old: " + numb
			Local r:Int = Int(Mid(numb, 1, 1))
			
			'rint "ret: " + r
			numb = Mid(numb, 2, -1)
			
			'rint "new: " + numb
			
			Return r
		Else
			Return -1
		EndIf
	End Function
		
	Function init()
		alphabet = New TMap
		numbers = New TMap
		
		MapInsert(alphabet,String(key_a),"a")
		MapInsert(alphabet,String(key_b),"b")
		MapInsert(alphabet,String(key_c),"c")
		MapInsert(alphabet,String(key_d),"d")
		MapInsert(alphabet,String(key_e),"e")
		MapInsert(alphabet,String(key_f),"f")
		MapInsert(alphabet,String(key_g),"g")
		MapInsert(alphabet,String(key_h),"h")
		MapInsert(alphabet,String(key_i),"i")
		MapInsert(alphabet,String(key_j),"j")
		MapInsert(alphabet,String(key_k),"k")
		MapInsert(alphabet,String(key_l),"l")
		MapInsert(alphabet,String(key_m),"m")
		MapInsert(alphabet,String(key_n),"n")
		MapInsert(alphabet,String(key_o),"o")
		MapInsert(alphabet,String(key_p),"p")
		MapInsert(alphabet,String(key_q),"q")
		MapInsert(alphabet,String(key_r),"r")
		MapInsert(alphabet,String(key_s),"s")
		MapInsert(alphabet,String(key_t),"t")
		MapInsert(alphabet,String(key_u),"u")
		MapInsert(alphabet,String(key_v),"v")
		MapInsert(alphabet,String(key_w),"w")
		MapInsert(alphabet,String(key_x),"x")
		MapInsert(alphabet,String(key_y),"y")
		MapInsert(alphabet,String(key_z),"z")
		
		MapInsert(numbers ,String(key_1),"1")
		MapInsert(numbers ,String(key_2),"2")
		MapInsert(numbers ,String(key_3),"3")
		MapInsert(numbers ,String(key_4),"4")
		MapInsert(numbers ,String(key_5),"5")
		MapInsert(numbers ,String(key_6),"6")
		MapInsert(numbers ,String(key_7),"7")
		MapInsert(numbers ,String(key_8),"8")
		MapInsert(numbers ,String(key_9),"9")
		MapInsert(numbers ,String(key_0),"0")
	End Function
	
	Function render()
		'look at alphabet
		For Local alp:String = EachIn MapKeys(alphabet)
			If KeyHit(Int(alp)) Then text:+String(MapValueForKey(alphabet,alp))
		Next
		
		'look at numbers
		For Local nmb:String = EachIn MapKeys(numbers)
			
			If KeyHit(Int(nmb)) Then
				If Len(text) > 0 Then
					text:+String(MapValueForKey(numbers,nmb))
				Else
					numb:+String(MapValueForKey(numbers,nmb))
				EndIf
			EndIf
		Next
		
		If KeyHit(key_space) Then
			If Len(text) > 0 Then
				text:+" "
			Else
				hit_space = 1
			EndIf
		EndIf
		
		If KeyHit(KEY_BACKSPACE) Then
			If Len(text) > 0 Then text = Mid(text, 1, Len(text)-1)
		EndIf
		
		If KeyHit(KEY_Return) Then
			If Len(text) > 0 Then
				command_to_execute = text
				text = ""
			Else
				hit_enter = 1
			EndIf
		EndIf
		
		Global text:String
		Global numb:String
	End Function
End Type

'##########################################################################################
'###############################      END OF TYPES         ################################
'##########################################################################################
'###############################          MAIN             ################################
'##########################################################################################

SetMaskColor(255,0,255)

SeedRnd MilliSecs()

LoadingScreen.init()


Incbin "font2.ttf"'"font.ttf"

Local thread:TThread=CreateThread(LoadingScreen.run_loader,"run it biach !!")

Repeat
	LoadingScreen.render_image()
Until Not ThreadRunning(Thread)
WaitThread(Thread)


AppTitle = "GAME"
Graphics_Handler.set_graphics(DesktopWidth()-60,DesktopHeight()-100,0)'DesktopWidth(),DesktopHeight(),1)' ## INIT GRAPHICS ##'800,600,0)'

GAME.run()

End