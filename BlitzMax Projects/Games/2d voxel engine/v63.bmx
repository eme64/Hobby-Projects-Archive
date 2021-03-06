SuperStrict

Import brl.blitz
Import vertex.bnetex
Import BRL.Map
Import "imagebuffer.bmx"
Include "font.bmx"

Rem
--------------------------------------------------------------- CHANGE LOG
- seperate rendering of image layers
- reduce calculation on light (only if necessary)
- moved drawing lights to small buffers, smooth appearence
- full screen light buffer, seperated rendering to rendering :)
- recycling light buffers
- seperated light data from block data
- merged blocks and back_blocks onto one buffer
- water
- layers: lights || liquids | objects | blocks : back_blocks | back ground
- redone surface
- fast removal from block_update if outside range
- added lava, water-lava = obsidian
- liquids smoothed out
- moved all data to super_chunk (tons of work...)
- loading / unloading super_chunks, dependent on use
- loading / storing through bank, is faster !
- data compression for super_chunks (~ factor 200, could do better with other pack...)
- changed liquids to buffered, limited per frame
- changing block-copy stuff for draw block (performance improved ?)
- reduce rendering on single block change
- implementing texture tiles (simple, 4-extension-rule)
- also need to revert to 2 buffer for blocks !
- layers: lights || blocks | liquids | objects | back_blocks | back ground
- extra render buffer -> keep lighting from affecting background + remove chunk-border artefacts
- for now chunk (10) and block (24 - 8*3)
- added color for flood-light, exponential decay
- let lava update light when it moves
- did some raytracing -> flashlight. blockwise. but: slow + see block borders...
- changed blocks and liquids to only-buffers, lights are still arrays (need not to be saved !)
- added object_map, simple npc for testing.

- added server-client comms:
   - server sends chunk data (now all of super_chunk at once)
   - both ways objects sync

- block changes (instant)
   - user: put to update_array
   - server: blocks to update_array
   - array of tuples: (x,y b0, b1, lq, lp, lt, stamp)
   - array has max size, wrap around ?
   - stamps count up, so that server can see what he has done before
   - attach that array with clients object info.

- fixed liquid-bug -> TBank's were not zeroed out at their creation !!!
- fixed liquid-alpha-value-light-bug. Now also textured !
- unloading super_chunk only after a certain time unused
- added shadow to blocks !
.. animating player (stand, walk, jump, tools), network !
-> fix block/light stuff
-> put objects in chunks -> client does not have to render all, server can turn it off when all players have left ?

------------------------------------------ ITEMS:
	- item_array, updated from server
	- drag and drop gui (basics)
	- send change commands to server for inventory (CONDITIONAL)
	- addet hotbar (top-bar) -> item selection
	- added block place + break -> get / lose items
	- item "drop" objects, chest drops items when broken.
	- improved numbering / type system
	-> liquid !
	
----------------------------------------- BLOCK-OBJECTS (CHEST, TREE, ...)
	- chest item, can place (incl. blocker blocks)
	- chests item_array is not synced with clients (every second)
	- breakable
	-> dependent on blocks below ? -> disallow breaking block below blocker-block ?

------------------------------------------ MULTI WORLD:
	- spawn-world, list of loaded worlds, rest on disk
	- each world (super_grid) has an id
	- can teleport to other world
	
------------------------------------------ SERVER - CLIENT STUFF:
	- server renders water around client -> also makes server load necessary chunks.
	- letting objects time out
	- chat + commands
	
- block updates:
	- server per super_chunk -> player looks at it's stamp, compares to super_chunk data.
	- player sends CONDITIONAL commands -> server accepts/rejects them silently -> can be used with items later !

 -> stamps for object_update
 -> improve printing for data-loading and stuff...


 -> implement more efficient server-gui, local-only-mode, share-mode ?

 -> should do reliability test for package size of udp.

 -> look again at package-generation -> can optimize, bundle ?

--------------------------------------------------------------- TODO / IDEAS
 -> new level generation:
		super-chunks (n*n chunks)					ok
		world-size (x, y in super-chunks)			ok
		
		generation steps:
			landmass, bioms, caves					X
			dungeons								X
			liquids -> density?						X
			plants, other formations				X
		
		in each step:
			load data from disk						X
			manipuate								X
			save to disk							X
			-> optimize so that save local data ?	X
			
		-> do it all with LUA ?

 -> change torch-raycasting -> render all white first, color after !

 -> only make obsidian when enough lava, else evaporate water ?
 -> add acid, ... other liquids ?
 -> bioms, different blocks schemes
 -> plants, rock formations, ... other things :)


End Rem

'----------------------------------------------------------------------------------------
'---------------------------                    -----------------------------------------
'---------------------------  VOXEL_SUPER_GRID  -----------------------------------------
'---------------------------                    -----------------------------------------
'----------------------------------------------------------------------------------------
Type VOXEL_UNIVERSE
	' ----------------------------- HOSTS ONLY
	Field name:String
	Field file_path:String
	Field worlds_id_counter:Int = 0
	
	Method get_next_id:Int()
		worlds_id_counter:+1
		Return worlds_id_counter
	End Method
	
	Field worlds_map:TMap ' key is id of world
		
	'----------------------------- ALL
	Field netw_man:NETWORK_MANAGER
	
	Field cons:CONSOLE
	Field gui:EG_BASE
		
	Function Generate_and_Save(name:String, netw_man:NETWORK_MANAGER, overwrite:Int = False)
		Local u:VOXEL_UNIVERSE = New VOXEL_UNIVERSE
		
		u.name = name
		u.file_path = "universe\" + u.name + "\"
		
		
		If FileType(u.file_path) Then
			If overwrite = 0 Then
				' reject
				RuntimeError("tried to overwrite existing world !")
			EndIf
			
			' delete all files ?
			Print("deleting old files...")
			DeleteDir(u.file_path, True)
			
			Print("done.")
		EndIf
		
		If Not CreateDir(u.file_path, True) Then
			RuntimeError("(CREATE-GRID) could not create: " + u.file_path)
		End If
				
		u.netw_man = netw_man
		
		'--------------------------- generate some worlds:
		For Local i:Int = 1 To 2
			Local new_world:VOXEL_SUPER_GRID = VOXEL_SUPER_GRID.Create(u, i, 16, VOXEL_GRID.chunk_size_blocks, 1,1, overwrite)
			
			new_world.deconstruct()
		Next
	End Function
	
	Function Load:VOXEL_UNIVERSE(name:String, netw_man:NETWORK_MANAGER)
		Local u:VOXEL_UNIVERSE = New VOXEL_UNIVERSE
		
		u.name = name
		u.file_path = "universe\" + u.name + "\"
		
		u.netw_man = netw_man
		netw_man.universe = u
		
		u.worlds_map = CreateMap()
		
		' depends if you are server!
		'Local grid:VOXEL_GRID = VOXEL_GRID..Create(super_grid)
		
		'RuntimeError("not implemented: load universe")
		
		u.cons = CONSOLE.Create(0, 100, 400, Graphics_Handler.y-100)
		
		u.gui = EG_BASE.Create(0,0,Graphics_Handler.x,Graphics_Handler.y)
		
		Return u
	End Function
		
	Function Join:VOXEL_UNIVERSE(netw_man:NETWORK_MANAGER)
		Local u:VOXEL_UNIVERSE = New VOXEL_UNIVERSE
		
		u.cons = CONSOLE.Create(0, 100, 400, Graphics_Handler.y-100)
		
		u.gui = EG_BASE.Create(0,0,Graphics_Handler.x,Graphics_Handler.y)
		
		u.netw_man = netw_man
		u.netw_man.universe = u
		
		If Not (u.netw_man.mode = NETWORK_MANAGER.CLIENT) Then
			RuntimeError("You can only join universe in client_mode")
		EndIf
		
		u.worlds_map = CreateMap()
		
		u.netw_man.join_fetch_metadata_universe(u)
		
		netw_man.client_connector.world = VOXEL_SUPER_GRID.Join(u, u.netw_man.client_connector.my_start_world_id)
		
		Return u
	End Function
	
	Method get_spawn_world:VOXEL_SUPER_GRID()
		Return find_world_or_load(1)
	End Method
	
	Method add_world(world:VOXEL_SUPER_GRID)
		Local key:UNIVERSE_KEY = UNIVERSE_KEY.Create(world.id)
		Local w:VOXEL_SUPER_GRID = VOXEL_SUPER_GRID(worlds_map.ValueForKey(key))
		
		If w Then
			RuntimeError("(add world) world already exists !")
		Else
			worlds_map.Insert(key, world)
		EndIf
	End Method
	
	Method remove_world(world:VOXEL_SUPER_GRID)
		
		Local key:UNIVERSE_KEY = UNIVERSE_KEY.Create(world.id)
		Local w:VOXEL_SUPER_GRID = VOXEL_SUPER_GRID(worlds_map.ValueForKey(key))
		
		If Not w Then
			RuntimeError("(add world) world to remove not found !")
		Else
			w.deconstruct()
			worlds_map.Remove(key)
		EndIf
		
	End Method
	
	Method remove_all_worlds()
		For Local w:VOXEL_SUPER_GRID = EachIn MapValues(worlds_map)
			remove_world(w)
		Next
	End Method
	
	Method find_item_array:ITEMS_ARRAY(identifyer:Int[])
		Select identifyer[0]
			Case 1
				' player.
				
				Local player_id:Int = identifyer[1]
				
				Select netw_man.mode
					Case NETWORK_MANAGER.CLIENT
						If player_id = netw_man.my_id Then
							Return netw_man.client_connector.inventory ' my inventory
						Else
							RuntimeError("item array -> why do I get someone else's array ?")	
						EndIf
					Case NETWORK_MANAGER.SERVER
						' find player:
						
						Local cl:T_S_Client = T_S_Client.get_id(player_id)
						
						If cl Then
							Return cl.inventory
						Else
							Print "find_item_array: client not found !"
							Return Null
						EndIf
						
					Default
						RuntimeError("item array -> bad netw_man mode !")	
				End Select
			Case 2
				'[2, super_grid.id, -1,-1, p.id]
				
				Local world_id:Int = identifyer[1]
				Local scx:Int = identifyer[2]
				Local scy:Int = identifyer[3]
				Local chest_id:Int = identifyer[4]
				
				If scx <> -1 Or scy <> -1 Then RuntimeError "need to implement super_chunk finder here !"
				
				Local w:VOXEL_SUPER_GRID = find_world_if_loaded:VOXEL_SUPER_GRID(world_id)
				
				If w Then
					Local key:OBJECT_KEY = OBJECT_KEY.Create(chest_id)
					Local c:T_CHEST = T_CHEST(w.object_map.ValueForKey(key))
					
					If c Then
						Return c.item_array
					Else
						Print "chest not found ! (chest-move-command)"
					EndIf
				Else
					Print "world not found for world id ! (chest-move-command)"
				End If
				RuntimeError("chest !")
			Default
				RuntimeError("item array type not defined !")			
		End Select
	End Method
	
	Method find_world_if_loaded:VOXEL_SUPER_GRID(id:Int)
		Local key:UNIVERSE_KEY = UNIVERSE_KEY.Create(id)
		Local w:VOXEL_SUPER_GRID = VOXEL_SUPER_GRID(worlds_map.ValueForKey(key))
		
		Return w
	EndMethod
	
	Method find_world_or_load:VOXEL_SUPER_GRID(id:Int)
		Local key:UNIVERSE_KEY = UNIVERSE_KEY.Create(id)
		Local w:VOXEL_SUPER_GRID = VOXEL_SUPER_GRID(worlds_map.ValueForKey(key))
		
		If Not w Then
			w = VOXEL_SUPER_GRID.fetch(Self, id)
			
			add_world(w)
		EndIf
		
		Return w
	EndMethod
	
	Method see_if_world_on_disk:Int(id:Int)
		Return VOXEL_SUPER_GRID.see_if_world_on_disk(Self, id)
	EndMethod
	
	Method render()
		Select netw_man.mode
			Case NETWORK_MANAGER.CLIENT
				
				netw_man.client_connector.world.grid.render_blocks()
				netw_man.client_connector.world.grid.render_liquids()
				netw_man.client_connector.world.grid.render_data()
				netw_man.client_connector.world.grid.render_lights()
				netw_man.client_connector.world.render_objects(netw_man)
				
				key_input(netw_man.client_connector.world)
				
				If Not gui.inventory Then
					gui.add_player_inventory(netw_man.client_connector.inventory)
				EndIf
				
				If Not gui.debug_window Then
					gui.add_debug_window(netw_man)
				EndIf
				
			Case NETWORK_MANAGER.SERVER
			
				If Not gui.debug_window Then
					gui.add_debug_window(netw_man)
				EndIf
				
				For Local w:VOXEL_SUPER_GRID = EachIn MapValues(worlds_map)
					'w.grid.render_blocks() ' not as server !
					w.grid.render_liquids(False) ' not fill liquid_list yourself, I do that below
					w.grid.render_data()
					'w.grid.render_lights()
					w.render_objects(netw_man)
					
					' see if LIQUIDS need rendering:
					If w.grid.last_liquid_refill + VOXEL_GRID.liquid_render_delay < MilliSecs() Then
						w.grid.last_liquid_refill = MilliSecs()
						For Local o:TPLAYER = EachIn MapValues(w.object_map)
							'Print("player " + o.id)
							Local x1:Int = o.x/w.grid.chunk_size - 2 -w.grid.chunks_done_outside_screen_liquids - 4
							Local y1:Int = o.y/w.grid.chunk_size - 2 -w.grid.chunks_done_outside_screen_liquids - 4
							
							Local x2:Int = o.x/w.grid.chunk_size + 2 +w.grid.chunks_done_outside_screen_liquids + 4
							Local y2:Int = o.y/w.grid.chunk_size + 2 +w.grid.chunks_done_outside_screen_liquids + 4
							
							For Local xx:Int = x1 To x2
								For Local yy:Int = y1 To y2
									w.grid.chunk_at(xx,yy).require_update_liquids()
								Next
							Next
						Next
					EndIf
				Next
				
			Default
				RuntimeError("(world render) mode not implemented !")
		End Select
	End Method
	
	Method draw()
		Select netw_man.mode
			Case NETWORK_MANAGER.CLIENT
				
				netw_man.client_connector.world.grid.draw()
				
				cons.draw()
				
				gui.draw(0,0)
				
			Case NETWORK_MANAGER.SERVER
				
				Local y_offset:Int = 100
				Local w_counter:Int = 0
				For Local w:VOXEL_SUPER_GRID = EachIn MapValues(worlds_map)
					SetColor 50,50,50
					EFONT.draw("ID: " + w.id + " :: lq: " + w.grid.liquids_list.count(), 50,y_offset, 2)
					
					w.time_draw(350,y_offset,20)
					
					If KeyDown(KEY_F4) Then w.draw_status(50,y_offset, 4*w.super_chunk_size_chunks)
					If KeyDown(KEY_F5) Then w.grid.draw_status(50,y_offset,4)
					
					y_offset:+100
					w_counter:+1
				Next
				
				SetColor 0,0,50
				EFONT.draw("# worlds: " + w_counter, 50,y_offset,2)
				
				T_S_Client.draw_all(400,5)
				
				cons.draw()
				
				gui.draw(0,0)
				
			Default
				RuntimeError("(world render) mode not implemented !")
		End Select
		
	End Method	
	
	
	
	Method key_input(world:VOXEL_SUPER_GRID)
		Local grid:VOXEL_GRID = world.grid
		
		Rem
		If KInput.K1.down Then
			grid.conditional_break_block_front_pixel_screen(KInput.MX,KInput.MY,0)
		EndIf
		
		If KInput.M1.down Then
			grid.conditional_break_block_front_pixel_screen(KInput.MX,KInput.MY,2)
		EndIf
		
		If KInput.M2.down Then
			grid.conditional_break_block_back_pixel_screen(KInput.MX,KInput.MY,2)
		EndIf
		
		If KInput.K2.down Then
			grid.conditional_put_block_front_pixel_screen(KInput.MX,KInput.MY,2,  0)
		EndIf
		
		If KInput.K3.down Then
			grid.conditional_put_block_front_pixel_screen(KInput.MX,KInput.MY,3,  0)
		EndIf
		
		If KInput.K4.down Then
			grid.conditional_put_block_front_pixel_screen(KInput.MX,KInput.MY,4,  0)
		EndIf
		
		If KInput.K5.down Then
			grid.conditional_put_block_front_pixel_screen(KInput.MX,KInput.MY,6,  0)
		EndIf
		
		If KInput.K6.down Then
			grid.conditional_put_block_front_pixel_screen(KInput.MX,KInput.MY,7,  0)
		EndIf
		
		If KInput.K0.down Then
			grid.conditional_put_liquid_pixel_screen(KInput.MX,KInput.MY,80,1,  0)
		EndIf
		
		If KInput.K9.down Then
			grid.conditional_put_liquid_pixel_screen(KInput.MX,KInput.MY,5000,1,  0)
		EndIf
		
		If KInput.K8.down Then
			grid.conditional_put_liquid_pixel_screen(KInput.MX,KInput.MY,100,2,  0)
		EndIf
		
		If KInput.K7.down Then
			grid.conditional_put_liquid_pixel_screen(KInput.MX,KInput.MY,5000,2,  0)
		EndIf
		
				
		If KInput.K0.hit Then
			Print("Pressed 0")
		EndIf
		End Rem
	End Method
	
End Type

Type UNIVERSE_KEY
	Field id:Int
	
	Function Create:UNIVERSE_KEY(id:Int)
		Local k:UNIVERSE_KEY = New UNIVERSE_KEY
		
		k.id = id
		
		Return k
	End Function
	
	Method Compare:Int(other:Object)
		Local o2:UNIVERSE_KEY = UNIVERSE_KEY(other)
		
		If o2 = Null Then Return Super.Compare(other)
		
		If o2.id < id Then Return -1
		If o2.id > id Then Return 1
		
		Return 0
	End Method
End Type

'----------------------------------------------------------------------------------------
'---------------------------                    -----------------------------------------
'---------------------------  VOXEL_SUPER_GRID  -----------------------------------------
'---------------------------                    -----------------------------------------
'----------------------------------------------------------------------------------------
Type VOXEL_SUPER_GRID
	Const super_chunks_keep_dependent:Int = 2000 ' how long one wants to keep the super_chunks even if they are not used by chunks (in-dependent)
	Const super_chunks_keep:Int = 2000 ' keep global
	
	Field chunk_size_blocks:Int ' in blocks
	Field super_chunk_size_chunks:Int ' in chunks
	Field super_chunk_size_blocks:Int ' in blocks -> calculated
	
	Field id:Int
	
	Field size_x:Int, size_y:Int ' in super_chunks
	Field world_name:String
	Field world_path:String
	Field super_chunks:VOXEL_SUPER_CHUNK[,] ' contains the loaded super_chunks - no direct access !
	Field empty_super_chunk:VOXEL_SUPER_CHUNK ' if off the map
	
	Field object_map:TMap
	Field block_object_map:TMap
	
	Field universe:VOXEL_UNIVERSE
	
	Field grid:VOXEL_GRID ' circular !?
	
	'------------------------------------------- TIMING STUFF	
	Const time_iteration_openness:Int = 10
	Const time_iteration_factor:Float = Float(time_iteration_openness-1)/Float(time_iteration_openness)
	
	' *** BLOCKS ***
	Field time_blocks:Int
	Field time_average_blocks:Float
	Method time_blocks_start()
		time_blocks = MilliSecs()
	End Method
	Method time_blocks_stop()
		time_blocks = MilliSecs() - time_blocks
		time_average_blocks = (time_average_blocks*time_iteration_factor + time_blocks/time_iteration_openness)
	End Method
	
	' *** Liquids ***
	Field time_liquids:Int
	Field time_average_liquids:Float
	Method time_liquids_start()
		time_liquids = MilliSecs()
	End Method
	Method time_liquids_stop()
		time_liquids= MilliSecs() - time_liquids
		time_average_liquids = (time_average_liquids*time_iteration_factor + time_liquids/time_iteration_openness)
	End Method
	
	' *** DATA ***
	Field time_data:Int
	Field time_average_data:Float
	Method time_data_start()
		time_data = MilliSecs()
	End Method
	Method time_data_stop()
		time_data = MilliSecs() - time_data
		time_average_data = (time_average_data*time_iteration_factor + time_data/time_iteration_openness)
	End Method
	
	' *** lights ***
	Field time_lights:Int
	Field time_average_lights:Float
	Method time_lights_start()
		time_lights = MilliSecs()
	End Method
	Method time_lights_stop()
		time_lights = MilliSecs() - time_lights
		time_average_lights = (time_average_lights*time_iteration_factor + time_lights/time_iteration_openness)
	End Method
	
	' *** objects ***
	Field time_objects:Int
	Field time_average_objects:Float
	Method time_objects_start()
		time_objects = MilliSecs()
	End Method
	Method time_objects_stop()
		time_objects = MilliSecs() - time_objects
		time_average_objects = (time_average_objects*time_iteration_factor + time_objects/time_iteration_openness)
	End Method
	
	Method time_draw(x:Int,y:Int, resolution:Int)
		SetAlpha 0.8
		SetColor 0,0,0
		DrawRect x,y,16*resolution,31
		
		'blocks
		SetColor 0,255,0
		DrawRect x+1,y+1, time_blocks*resolution+1, 2
		DrawRect x+1,y+3, time_average_blocks*resolution+1, 3
		
		'liquids
		SetColor 100,100,255
		DrawRect x+1,y+1 + 6, time_liquids*resolution+1, 2
		DrawRect x+1,y+3 + 6, time_average_liquids*resolution+1, 3
		
		'data
		SetColor 255,0,0
		DrawRect x+1,y+1 + 12, time_data*resolution+1, 2
		DrawRect x+1,y+3 + 12, time_average_data*resolution+1, 3
		
		'lights
		SetColor 255,255,0
		DrawRect x+1,y+1 + 18, time_lights*resolution+1, 2
		DrawRect x+1,y+3 + 18, time_average_lights*resolution+1, 3
		
		'objects
		SetColor 0,255,255
		DrawRect x+1,y+1 + 24, time_objects*resolution+1, 2
		DrawRect x+1,y+3 + 24, time_average_objects*resolution+1, 3
		
		SetAlpha 1.0
	End Method
	
	
	'  [ sum ((x-1)/x)^j, j=0..infinity ] = x
	'-------------------------------------------
	
	
	
	Method render_objects(netw_man:NETWORK_MANAGER)
		time_objects_start() ' timer
		
		For Local o:TOBJECT = EachIn MapValues(object_map)
			o.render(netw_man)
			
			If o.owner <> netw_man.my_id Then
				If o.last_update + TOBJECT.keep_time < MilliSecs() Then
					' object timed out.
					o.remove(netw_man)
				EndIf
			EndIf
		Next
		
		time_objects_stop() ' timer
	End Method
	
	Method draw_objects(grid:VOXEL_GRID)
		For Local o:TOBJECT = EachIn MapValues(object_map)
			o.draw(grid)
		Next
	End Method
	
	Method super_chunk_exists:Int(x:Int,y:Int)
		
		If x < 0 Or y < 0 Or x >= size_x Or y >= size_y Then Return False
		
		If Not super_chunks[x,y] Then
			' go fetch
			
			Return False
		EndIf
		
		Return True
	End Method
	
	Method get_super_chunk:VOXEL_SUPER_CHUNK(x:Int,y:Int, need_exist:Int = True)
		
		If x < 0 Or y < 0 Or x >= size_x Or y >= size_y Then Return empty_super_chunk ' outside !
		
		If Not super_chunks[x,y] Then
			' go fetch
			
			super_chunks[x,y] = VOXEL_SUPER_CHUNK.fetch(Self, x,y, need_exist)
		EndIf
		
		super_chunks[x,y].time_since_last_use = MilliSecs()
		
		Return super_chunks[x,y]
	End Method
	
	Method super_chunk_data_loaded:Int(x:Int,y:Int) ' checks if data loaded	
		If x < 0 Or y < 0 Or x >= size_x Or y >= size_y Then Return True ' outside -> empty data !
		
		Return (super_chunks[x,y] <> Null)
	End Method
	
	Method ensure_super_chunk_data_loaded:Int(x:Int,y:Int) ' checks if data loaded	
		If x < 0 Or y < 0 Or x >= size_x Or y >= size_y Then Return True ' outside -> empty data !
		
		Return (get_super_chunk(x,y) <> Null)
	End Method
	
	Method get_block_truncated:Short(x:Int,y:Int, layer:Int) ' x,y abs blocks, may crash
		If x < 0 Or y < 0 Or x >= size_x*super_chunk_size_blocks Or y >= size_y*super_chunk_size_blocks Then Return VOXEL_BLOCK.AIR ' had to change for speed
		
		Local sc:VOXEL_SUPER_CHUNK = super_chunks[x/super_chunk_size_blocks, y/super_chunk_size_blocks]
		Return sc.get_block(x Mod super_chunk_size_blocks, y Mod super_chunk_size_blocks, layer)
	End Method
	
	Method get_chunk_with_border_blocks:Int[,](x:Int,y:Int, layer:Int) 'x,y in chunks
		Local bn:Int[,] = New Int[chunk_size_blocks+2,chunk_size_blocks+2]
		
		Local sc:VOXEL_SUPER_CHUNK = get_super_chunk(Floor(Float(x)/super_chunk_size_chunks), Floor(Float(y)/super_chunk_size_chunks))
		Local x_off:Int = (((x*chunk_size_blocks) Mod super_chunk_size_blocks) + super_chunk_size_blocks) Mod super_chunk_size_blocks
		Local y_off:Int = (((y*chunk_size_blocks) Mod super_chunk_size_blocks) + super_chunk_size_blocks) Mod super_chunk_size_blocks
		
		
		' ---------------------------------------------------- Top / bottom
		Local sc_top:VOXEL_SUPER_CHUNK = get_super_chunk(Floor(Float(x)/super_chunk_size_chunks), Floor(Float(y-1)/super_chunk_size_chunks))
		Local y_off_top:Int = (y_off-1 + super_chunk_size_blocks) Mod super_chunk_size_blocks
		Local sc_down:VOXEL_SUPER_CHUNK = get_super_chunk(Floor(Float(x)/super_chunk_size_chunks), Floor(Float(y+1)/super_chunk_size_chunks))
		Local y_off_down:Int = (y_off + chunk_size_blocks + super_chunk_size_blocks) Mod super_chunk_size_blocks
		
		For Local xx:Int = 0 To chunk_size_blocks-1
			bn[xx + 1, 0] = sc_top.get_block(x_off + xx, y_off_top, layer)
			
			bn[xx + 1, chunk_size_blocks+1] = sc_down.get_block(x_off + xx, y_off_down, layer)
		Next
		' ---------------------------------------------------- left / right
		Local sc_left:VOXEL_SUPER_CHUNK = get_super_chunk(Floor(Float(x-1)/super_chunk_size_chunks), Floor(Float(y)/super_chunk_size_chunks))
		Local x_off_left:Int = (x_off-1 + super_chunk_size_blocks) Mod super_chunk_size_blocks
		Local sc_right:VOXEL_SUPER_CHUNK = get_super_chunk(Floor(Float(x+1)/super_chunk_size_chunks), Floor(Float(y)/super_chunk_size_chunks))
		Local x_off_right:Int = (x_off + chunk_size_blocks + super_chunk_size_blocks) Mod super_chunk_size_blocks
		
		For Local yy:Int = 0 To chunk_size_blocks-1
			bn[0, yy + 1] = sc_left.get_block(x_off_left, y_off + yy, layer)
			
			bn[chunk_size_blocks+1, yy + 1] = sc_right.get_block(x_off_right, y_off + yy, layer)
		Next
		
		
		' ---------------------------------------------------- Middle
		For Local xx:Int = 0 To chunk_size_blocks-1
			For Local yy:Int = 0 To chunk_size_blocks-1
				bn[xx + 1, yy + 1] = sc.get_block(x_off + xx, y_off + yy, layer)
			Next
		Next
		'---------------------------------------------------------- CORNER CASES LEFT OUT !
		
		Return bn

	End Method
	
	Method set_block_truncated(x:Int,y:Int, layer:Int, block:Short) ' x,y abs blocks, may crash
		If x < 0 Or y < 0 Or x >= size_x*super_chunk_size_blocks Or y >= size_y*super_chunk_size_blocks Then Return
		
		Local sc:VOXEL_SUPER_CHUNK = super_chunks[x/super_chunk_size_blocks, y/super_chunk_size_blocks]
		sc.set_block(x Mod super_chunk_size_blocks, y Mod super_chunk_size_blocks, layer, block)
		
		If VOXEL_BLOCK.collision[block] Then
			sc.set_liquid_plus(x Mod super_chunk_size_blocks, y Mod super_chunk_size_blocks, 0) ' kill all liquids
			sc.set_liquid(x Mod super_chunk_size_blocks, y Mod super_chunk_size_blocks, 0)
			sc.set_liquid_type(x Mod super_chunk_size_blocks, y Mod super_chunk_size_blocks, 0)
		EndIf
	End Method

	
	Method get_light_truncated:Short[](x:Int,y:Int) ' x,y abs blocks
		If x < 0 Or y < 0 Or x >= size_x*super_chunk_size_blocks Or y >= size_y*super_chunk_size_blocks Then Return [Short 0,Short 0,Short 0]
		
		Local sc:VOXEL_SUPER_CHUNK = super_chunks[x/super_chunk_size_blocks, y/super_chunk_size_blocks]
		
		Return [..
		sc.light[x Mod super_chunk_size_blocks, y Mod super_chunk_size_blocks,0],..
		sc.light[x Mod super_chunk_size_blocks, y Mod super_chunk_size_blocks,1],..
		sc.light[x Mod super_chunk_size_blocks, y Mod super_chunk_size_blocks,2]]
		'Return sc.light[x Mod super_chunk_size_blocks, y Mod super_chunk_size_blocks]
	End Method
	
	Method get_liquid_truncated:Int(x:Int,y:Int) ' x,y abs blocks
		If x < 0 Or y < 0 Or x >= size_x*super_chunk_size_blocks Or y >= size_y*super_chunk_size_blocks Then Return 0
		
		Local sc:VOXEL_SUPER_CHUNK = super_chunks[x/super_chunk_size_blocks, y/super_chunk_size_blocks]
		Return sc.get_liquid(x Mod super_chunk_size_blocks, y Mod super_chunk_size_blocks)
	End Method
	
	Method get_liquid_plus_truncated:Int(x:Int,y:Int) ' x,y abs blocks
		If x < 0 Or y < 0 Or x >= size_x*super_chunk_size_blocks Or y >= size_y*super_chunk_size_blocks Then Return 0
		
		Local sc:VOXEL_SUPER_CHUNK = super_chunks[x/super_chunk_size_blocks, y/super_chunk_size_blocks]
		Return sc.get_liquid_plus(x Mod super_chunk_size_blocks, y Mod super_chunk_size_blocks)
	End Method

	
	Method get_liquid_type_truncated:Byte(x:Int,y:Int) ' x,y abs blocks
		If x < 0 Or y < 0 Or x >= size_x*super_chunk_size_blocks Or y >= size_y*super_chunk_size_blocks Then Return 0
		
		Local sc:VOXEL_SUPER_CHUNK = super_chunks[x/super_chunk_size_blocks, y/super_chunk_size_blocks]
		Return sc.get_liquid_type(x Mod super_chunk_size_blocks, y Mod super_chunk_size_blocks)
	End Method


	Method add_liquid_plus_truncated(x:Int,y:Int, amount:Int) ' x,y abs blocks
		If x < 0 Or y < 0 Or x >= size_x*super_chunk_size_blocks Or y >= size_y*super_chunk_size_blocks Then Return
		
		Local sc:VOXEL_SUPER_CHUNK = super_chunks[x/super_chunk_size_blocks, y/super_chunk_size_blocks]
		
		sc.add_liquid_plus(x Mod super_chunk_size_blocks, y Mod super_chunk_size_blocks, amount)
	End Method

	
	Method set_liquid_type_truncated(x:Int,y:Int, typ:Byte) ' x,y abs blocks
		If x < 0 Or y < 0 Or x >= size_x*super_chunk_size_blocks Or y >= size_y*super_chunk_size_blocks Then Return
		
		Local sc:VOXEL_SUPER_CHUNK = super_chunks[x/super_chunk_size_blocks, y/super_chunk_size_blocks]
		sc.set_liquid_type(x Mod super_chunk_size_blocks, y Mod super_chunk_size_blocks, typ)
	End Method
	
	Method action_set_full_block_truncated(network_only_if_host:Int , x:Int, y:Int, block_0:Int, block_1:Int, liquid:Int, liquid_plus:Int, liquid_type:Int) ' x,y abs blocks
		If x < 0 Or y < 0 Or x >= size_x*super_chunk_size_blocks Or y >= size_y*super_chunk_size_blocks Then Return
		
		Local sc:VOXEL_SUPER_CHUNK = super_chunks[x/super_chunk_size_blocks, y/super_chunk_size_blocks]
		If Not sc Then Return
		
		sc.action_set_full_block(network_only_if_host, x, y, block_0, block_1, liquid, liquid_plus, liquid_type)
	End Method
	
	Function Create:VOXEL_SUPER_GRID(universe:VOXEL_UNIVERSE, world_name:String, super_chunk_size_chunks:Int, chunk_size_blocks:Int, size_x:Int, size_y:Int, overwrite:Int = False)
		Local sg:VOXEL_SUPER_GRID = New VOXEL_SUPER_GRID
		
		sg.id = universe.get_next_id()
		sg.universe = universe
		
		Select sg.universe.netw_man.mode
			Case NETWORK_MANAGER.CLIENT
				RuntimeError("should not create worlds as client !")
			Case NETWORK_MANAGER.SERVER
				sg.grid = VOXEL_GRID.Create(sg, False) ' no graphics
			Default
				RuntimeError("mode not implemented csg")
		End Select
		
		
		sg.object_map = CreateMap()
		sg.block_object_map = CreateMap()
		
		If Not (universe.netw_man.mode = NETWORK_MANAGER.SERVER) Then
			RuntimeError("You can only create a world in server_mode")
		EndIf
		
		sg.world_name = world_name
		sg.super_chunk_size_chunks = super_chunk_size_chunks
		sg.chunk_size_blocks = chunk_size_blocks
		sg.super_chunk_size_blocks = super_chunk_size_chunks * chunk_size_blocks
		
		sg.size_x = size_x
		sg.size_y = size_y
		
		
		
		' return null if already exists, unless overwrite = 1
		sg.world_path = universe.file_path + sg.world_name
		
		If FileType(sg.world_path) Then
			If overwrite = 0 Then
				' reject
				Print("tried to overwrite existing world !")
				End
			EndIf
			
			' delete all files ?
			Print("Deleting old save-files:")
			Local files:String[] = LoadDir(sg.world_path)
			
			For Local f:String = EachIn files
				Print("  > " + f)
				DeleteFile(sg.world_path + "/" + f)
			Next
			
			Print("done.")
		Else
			' create folder
			If Not CreateDir("world") Then
				Print("(CREATE-GRID) could not create: " + "world")
				End
			End If
			
			If Not CreateDir(sg.world_path) Then
				Print("(CREATE-GRID) could not create: " + sg.world_path)
				End
			End If
		EndIf
		
		sg.super_chunks = New VOXEL_SUPER_CHUNK[sg.size_x,sg.size_y]
		sg.empty_super_chunk = VOXEL_SUPER_CHUNK.make_empty(sg)
		
		sg.generation() ' call level generation
		
		sg.save_metadata()
		sg.super_chunk_cleanup(True) ' save all, eject all (because none in use by chunks by now ! )
				
		Return sg
	End Function
	
	Function see_if_world_on_disk:Int(universe:VOXEL_UNIVERSE, world_name:String)
		Local path:String = universe.file_path + world_name
		Return FileType(path)
	End Function
	
	Function fetch:VOXEL_SUPER_GRID(universe:VOXEL_UNIVERSE, world_name:String)
		Local sg:VOXEL_SUPER_GRID = New VOXEL_SUPER_GRID
		' load from disk
		
		sg.universe = universe
		
		Select sg.universe.netw_man.mode
			Case NETWORK_MANAGER.CLIENT
				RuntimeError("should not create worlds as client !")
			Case NETWORK_MANAGER.SERVER
				sg.grid = VOXEL_GRID.Create(sg, False) ' no graphics
			Default
				RuntimeError("mode not implemented csg")
		End Select
		
		sg.object_map = CreateMap()
		sg.block_object_map = CreateMap()
		
		If Not (universe.netw_man.mode = NETWORK_MANAGER.SERVER) Then
			RuntimeError("You can only load a world from DISK in server_mode")
		EndIf
		
		Print("(GRID-FETCH) name: " + world_name)
		
		sg.world_name = world_name
		sg.world_path = universe.file_path + sg.world_name
		
		' load metadata
		sg.fetch_metadata()
		
		sg.super_chunks = New VOXEL_SUPER_CHUNK[sg.size_x,sg.size_y]
		sg.empty_super_chunk = VOXEL_SUPER_CHUNK.make_empty(sg)
		
		' --------------- generate some objects -> better load !
		'TPLAYER.Create(100,100, sg, NETWORK_MANAGER.SERVER_ID)
		
		For Local i:Int = 1 To 10
			T_NPC.Create(150+100*i,100, sg, NETWORK_MANAGER.SERVER_ID, False, Null)
		Next
		
		Print("(GRID-FETCH) done.")
		
		Return sg
	End Function
	
	Function Join:VOXEL_SUPER_GRID(universe:VOXEL_UNIVERSE, world_id:Int)
		Local sg:VOXEL_SUPER_GRID = New VOXEL_SUPER_GRID
		
		
		
		sg.id = world_id
		universe.add_world(sg)
		
		sg.universe = universe
		
		Select sg.universe.netw_man.mode
			Case NETWORK_MANAGER.CLIENT
				sg.grid = VOXEL_GRID.Create(sg, True) ' with graphics
				universe.netw_man.client_connector.my_world_id = world_id
			Case NETWORK_MANAGER.SERVER
				RuntimeError("cannot join world as server !")
			Default
				RuntimeError("mode not implemented csg")
		End Select
		
		sg.object_map = CreateMap()
		sg.block_object_map = CreateMap()
		
		sg.universe.netw_man.join_fetch_metadata(sg)
		
		'sg.super_chunks = New VOXEL_SUPER_CHUNK[sg.size_x,sg.size_y]
		'sg.empty_super_chunk = VOXEL_SUPER_CHUNK.make_empty(sg)
		' -> moved to receive metadata !
		
		Return sg
	End Function
	
	Method save()
		Print("(grid-save) world: " + world_name)
		
		' store super_grid metadata
		save_metadata()
		
		' stores all active super_chunks
		For Local xx:Int = 0 To size_x-1
			For Local yy:Int = 0 To size_y-1
				If super_chunks[xx,yy] Then
					super_chunks[xx,yy].save()
				EndIf
			Next
		Next
		
		Print("(grid-save) done.")
	End Method
	
	Method deconstruct() ' does not save !
		' just to make sure, and remove cyclical datastructures:
		super_chunks = Null
		empty_super_chunk = Null
		object_map = Null
		universe = Null
		grid = Null
	End Method
	
	Method save_metadata()
		
		If Not FileType(world_path) Then
			Print("(save_metadata) did not exist: " + world_path)
			End
		EndIf
		
		Local file:TStream = WriteFile(world_path + "\meta.data")
		
		file.WriteInt(super_chunk_size_chunks)
		file.WriteInt(chunk_size_blocks)
		file.WriteInt(size_x)
		file.WriteInt(size_y)
		file.WriteInt(id)
				
		CloseFile(file)
	End Method
	
	Method fetch_metadata()
		
		' -------------- ! if change this must also change for network_manager !
		
		Print("(fetch-metadata) path: " + world_path + "\meta.data")
		
		If Not FileType(world_path) Then
			Print("(fetch_metadata) did not exist: " + world_path)
			End
		EndIf
		
		Local file:TStream = ReadFile(world_path + "\meta.data")
		
		If Not file Then
			Print("(fetch_metadata) did not exist: " + world_path + "\meta.data")
			End
		EndIf
		
		If Eof(file) Then'super_chunk_size_chunks
			Print("(fetch_metadata) missing: super_chunk_size")
			End
		Else
			super_chunk_size_chunks = file.ReadInt()
		End If
		
		If Eof(file) Then'chunk_size_blocks
			Print("(fetch_metadata) missing: chunk_size_blocks")
			End
		Else
			chunk_size_blocks = file.ReadInt()
		End If
		
		super_chunk_size_blocks = super_chunk_size_chunks * chunk_size_blocks
		
		If Eof(file) Then'size_x
			Print("(fetch_metadata) missing: size_x")
			End
		Else
			size_x = file.ReadInt()
		End If
		
		If Eof(file) Then'super_chunk_size
			Print("(fetch_metadata) missing: size_y")
			End
		Else
			size_y = file.ReadInt()
		End If
		
		If Eof(file) Then'id
			Print("(fetch_metadata) missing: id")
			End
		Else
			id = file.ReadInt()
		End If
		
		CloseFile(file)
		
		Print("(fetch-metadata) done.")
	End Method
	
	' ----------------------------------------------------------  PROCEDURAL GENERATION
	
	Method generation() ' main function
		' in first run data will not exist -> create on the fly !
		' call all sub-routines
		
		' loop through all, test neighbours, eject unused super_chunks
		
		Print("(generation_land) ...")
		generation_land(False)
		Print("(generation_land) done")
	End Method
	
	Method generation_land(cne:Int = False) ' cne= chunks_need_exist
		' x,y for super-chunks
		' xx, yy blocks in superchunk
		' xx_a, yy_a blocks absolute
		Local xx_a:Int, yy_a:Int
		
		Local rnd1:Byte[,] = RANDOM_GEN.get_noise_field(2^6) ' all only temporary !
		
		'Local rnd_terrain:RANDOM_GEN = RANDOM_GEN.Create([[1.0,1.0],[2.0,4.0],[4.0,8.0],[16.0,8.0],[64.0,16.0]], 2^6, rnd1)
		'Local rnd_surface:RANDOM_GEN = RANDOM_GEN.Create([[4.0,0.5],[7.0,1.0],[17.0,8.0],[31.0,16.0],[61.0,32.0]], 2^6, rnd1)
		Local rnd_surface_outline:RANDOM_GEN = RANDOM_GEN.Create([[7.0,1.0],[17.0,3.0],[31.0,4.0],[61.0,5.0]], 2^6, rnd1)
		
		Const surface_differences:Int = 500
		Const surface_min:Int = 0
		
		For Local x:Int = 0 To size_x-1
			For Local y:Int = 0 To size_y-1
				Local sc:VOXEL_SUPER_CHUNK = get_super_chunk(x,y, cne) ' need do more here !
				
				For Local xx:Int = 0 To super_chunk_size_blocks-1
					For Local yy:Int = 0 To super_chunk_size_blocks-1
						xx_a = xx + super_chunk_size_blocks*x ' absolute blocks
						yy_a = yy + super_chunk_size_blocks*y
						
						Local sfc_out:Float = rnd_surface_outline.get_2d(xx_a, yy_a)
						
						Local sfc_res:Float = Float(yy_a)/200.0 + sfc_out
						
						If sfc_res < 1.0 Then
							sc.set_block(xx,yy,0, VOXEL_BLOCK.AIR)
							sc.set_block(xx,yy,1, VOXEL_BLOCK.AIR)
						ElseIf sfc_res < 1.05
							sc.set_block(xx,yy,0, VOXEL_BLOCK.GRASS_GREEN) ' grass
							sc.set_block(xx,yy,1, VOXEL_BLOCK.GRASS_GREEN)
						ElseIf sfc_res < 1.2
							sc.set_block(xx,yy,0, VOXEL_BLOCK.STONE) ' stone
							sc.set_block(xx,yy,1, VOXEL_BLOCK.STONE)
						ElseIf sfc_res < 1.5
							sc.set_block(xx,yy,0, VOXEL_BLOCK.STONE) ' ore
							sc.set_block(xx,yy,1, VOXEL_BLOCK.GOLD)
						Else
							sc.set_block(xx,yy,0, VOXEL_BLOCK.STONE) ' glow
							sc.set_block(xx,yy,1, VOXEL_BLOCK.GLOWSTONE)
						EndIf
					Next
				Next
			Next
		Next
		
	EndMethod
	
	Method draw_status(x:Int,y:Int, size:Int)
		For Local xx:Int = 0 To size_x-1
			For Local yy:Int = 0 To size_y-1
				If super_chunks[xx,yy] Then
					SetColor 100,255,100
					DrawRect x+size*xx, y+size*yy, size-1,size-1
					
					SetColor 0,0,0
					EFONT.draw(super_chunks[xx,yy].chunks_dependent, x+size*xx+2, y+size*yy+2,2)
				Else
					SetColor 255,100,100
					DrawRect x+size*xx, y+size*yy, size-1, size-1
				EndIf
			Next
		Next
	End Method
	
	
	Field last_cleanup:Int
	
	Method super_chunk_cleanup(full_cleanup:Int = False) ' sees if any super_chunks can be moved to disk -> free up memory !
		
		If last_cleanup + 1111 < MilliSecs() Or full_cleanup Then
			last_cleanup = MilliSecs()
		Else
			Return
		EndIf
		
		If full_cleanup Then
			'Print("(super-chunk-cleanup) full...")
		Else
			'Print("(super-chunk-cleanup) ...")
		EndIf
		
		For Local xx:Int = 0 To size_x-1
			For Local yy:Int = 0 To size_y-1
				If super_chunks[xx,yy] Then
					If super_chunks[xx,yy].chunks_dependent = 0 Then
						If super_chunks[xx,yy].time_since_independent + super_chunks_keep_dependent < MilliSecs() Or super_chunks[xx,yy].time_since_independent = 0 Then
							
							If full_cleanup Or super_chunks[xx,yy].time_since_last_use + super_chunks_keep < MilliSecs() Then
								Select universe.netw_man.mode
									Case NETWORK_MANAGER.CLIENT
										' not deconstruct !
									Case NETWORK_MANAGER.SERVER
										super_chunks[xx,yy].save()
									Default
										RuntimeError("not implemented")
								End Select
								
								super_chunks[xx,yy].deconstruct()
								super_chunks[xx,yy] = Null
								
								If Not full_cleanup Then
									Print("(super-chunk-cleanup) done (ms: " + (MilliSecs()-last_cleanup) + ")")
									Return
								EndIf
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		Next
		
		'Print("(super-chunk-cleanup) done (ms: " + (MilliSecs()-last_cleanup) + ")")
	End Method
	
	Field last_update_network:Int
	
	Method super_chunk_update_network() ' sees if any super_chunks can be moved to disk -> free up memory !
		
		If last_update_network + 1111 < MilliSecs() Then
			last_update_network = MilliSecs()
		Else
			Return
		EndIf
		
		'Print(" -> update network:")
		
		For Local xx:Int = 0 To size_x-1
			For Local yy:Int = 0 To size_y-1
				If super_chunks[xx,yy] Then
					super_chunks[xx,yy].update_network()
				EndIf
			Next
		Next
		
		'Print(" -> done.")
		
		'Print("(super-chunk-cleanup) done (ms: " + (MilliSecs()-last_cleanup) + ")")
	End Method

	
	
End Type

'----------------------------------------------------------------------------------------
'---------------------------                    -----------------------------------------
'---------------------------  VOXEL_SUPER_CHUNK -----------------------------------------
'---------------------------                    -----------------------------------------
'----------------------------------------------------------------------------------------
Type VOXEL_SUPER_CHUNK
	' META DATA
	Field x:Int, y:Int ' in super_chunks
	Field super_grid:VOXEL_SUPER_GRID
	Field chunks_dependent:Int = 0 ' used to count. managed through functions, no direct write access !
	Field time_since_independent:Int ' in millisecs() -> can free up super_chunk once no dependent and long enough waited
	Field time_since_last_use:Int = MilliSecs()
	
	' DATA
	Field light:Short[,,] ' x,y,rgb
	
	' -> col-major format ! (x,y accessing)
	Field blocks:TBank[] 'Short[,,] ' x,y, layer (2)
	Field liquid:TBank 'Int[,] ' x,y
	Field liquid_plus:TBank 'Int[,] ' x,y
	Field liquid_type:TBank 'Byte[,] ' x,y
	
	Const blocks_size_t:Int = 2
	Const liquid_size_t:Int = 4
	Const liquid_type_size_t:Int = 1
	
	'------------------------------------------ BLOCK UPDATE
	Field block_update:BLOCK_UPDATE_ARRAY
	Field rcv_last_data_stamp:Int = 0
	Field rcv_last_block_update_stamp:Int = 0 ' data_receive can also increment this !
	
	Method write_block_update(only_if_host:Int, x:Int, y:Int, block_0:Short, block_1:Short, liquid:Int, liquid_plus:Int, liquid_type:Byte)
		If only_if_host Then
			Select super_grid.universe.netw_man.mode
				Case NETWORK_MANAGER.SERVER
					block_update.write(x,y,block_0,block_1,liquid,liquid_plus,liquid_type)
				Case NETWORK_MANAGER.CLIENT
					'nothing
				Default
					RuntimeError("not implemented")
			End Select
		Else
			If super_grid.universe.netw_man.mode = NETWORK_MANAGER.CLIENT Then
				RuntimeError("must remove !")
			EndIf
			block_update.write(x,y,block_0,block_1,liquid,liquid_plus,liquid_type)
		EndIf
	End Method
	
	Method read_block_update_from_stream(Stream:TStream, size:Int)
		
		For Local i:Int = 1 To size
			Local stamp:Int
			
			Local xx:Int
			Local yy:Int
			
			Local block_0:Short
			Local block_1:Short
			
			Local liquid:Int
			Local liquid_plus:Int
			Local liquid_type:Byte
			
			block_update.get_next_from_stream(Stream, stamp, xx, yy, block_0, block_1, liquid, liquid_plus, liquid_type)
						
			xx = xx + Self.x*super_grid.super_chunk_size_blocks ' convert to global, for grid !
			yy = yy + Self.y*super_grid.super_chunk_size_blocks
			
			Select super_grid.universe.netw_man.mode
				Case NETWORK_MANAGER.SERVER
					If stamp > rcv_last_block_update_stamp Then
						rcv_last_block_update_stamp = stamp
						super_grid.grid.action_set_full_block(True , xx, yy, block_0, block_1, liquid, liquid_plus, liquid_type)
					EndIf
				Case NETWORK_MANAGER.CLIENT
					If stamp > rcv_last_block_update_stamp Then
						rcv_last_block_update_stamp = stamp
						super_grid.grid.action_set_full_block(True , xx, yy, block_0, block_1, liquid, liquid_plus, liquid_type)
					EndIf
				Default
					RuntimeError("not implemented")
			End Select
		Next
		
	End Method
	
	Function ignore_block_update_from_stream(Stream:TStream, size:Int)
		
		For Local i:Int = 1 To size
			Local stamp:Int
			
			Local x:Int
			Local y:Int
			
			Local block_0:Short
			Local block_1:Short
			
			Local liquid:Int
			Local liquid_plus:Int
			Local liquid_type:Byte
			
			BLOCK_UPDATE_ARRAY.get_next_from_stream(Stream, stamp, x, y, block_0, block_1, liquid, liquid_plus, liquid_type)
		Next
		
	End Function
	
	'------------------------------------------ CLIENT ONLY
	Field last_receive_blocks:Int[] = [0,0]
	Field last_receive_liquids:Int
	Field last_receive_liquids_plus:Int
	Field last_receive_liquids_type:Int
	
	Field last_receive_full_data:Int
	
	Field last_update_required:Int
	
	'------------------------------------------ NETWORKING
	Method update_network()
		
		Select super_grid.universe.netw_man.mode
			Case NETWORK_MANAGER.CLIENT
				Local s_stream:TUDPStream = super_grid.universe.netw_man.client_connector.send_stream
				
				If (MilliSecs() - last_update_required) > 500 Then
					last_update_required = MilliSecs()
					
					If Not last_receive_full_data Or (MilliSecs() - last_receive_full_data) > 3000
						Package_Manager.send_request_full_data(s_stream, super_grid.id, x,y)
					EndIf					
				EndIf
			Default
				'nothing ?
				'send accumulated updates ?
		End Select
	End Method
	
	'------------------------------------------------------------- BLOCK ACCESS
	Method get_block:Short(x:Int, y:Int, layer:Int)
		?Debug
			If(x<0 Or y<0 Or x>=super_grid.super_chunk_size_blocks Or y>=super_grid.super_chunk_size_blocks) Then RuntimeError("out of bounds " + x + " " + y)
		?
		Local offset:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.blocks_size_t
		
		Return blocks[layer].PeekShort(offset)
	End Method
	
	Method set_block(x:Int, y:Int, layer:Int, block:Short)
		?Debug
			If(x<0 Or y<0 Or x>=super_grid.super_chunk_size_blocks Or y>=super_grid.super_chunk_size_blocks) Then RuntimeError("out of bounds " + x + " " + y)
		?
		Local offset:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.blocks_size_t
		
		blocks[layer].PokeShort(offset, block)
	End Method
	
	'------------------------------------------------------------- LIQUID ACCESS
	Method get_liquid:Int(x:Int, y:Int)
		?Debug
			If(x<0 Or y<0 Or x>=super_grid.super_chunk_size_blocks Or y>=super_grid.super_chunk_size_blocks) Then RuntimeError("out of bounds " + x + " " + y)
		?
		Local offset:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_size_t
		
		Return liquid.PeekInt(offset)
	End Method
	
	Method set_liquid(x:Int, y:Int, amount:Int)
		?Debug
			If(x<0 Or y<0 Or x>=super_grid.super_chunk_size_blocks Or y>=super_grid.super_chunk_size_blocks) Then RuntimeError("out of bounds " + x + " " + y)
		?
		Local offset:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_size_t
		
		liquid.PokeInt(offset, amount)
	End Method
	
	Method sub_liquid(x:Int, y:Int, amount:Int)
		?Debug
			If(x<0 Or y<0 Or x>=super_grid.super_chunk_size_blocks Or y>=super_grid.super_chunk_size_blocks) Then RuntimeError("out of bounds " + x + " " + y)
		?
		Local offset:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_size_t
		
		liquid.PokeInt(offset, liquid.PeekInt(offset) - amount)
	End Method
	
	'------------------------------------------------------------- LIQUID_plus ACCESS
	Method get_liquid_plus:Int(x:Int, y:Int)
		?Debug
			If(x<0 Or y<0 Or x>=super_grid.super_chunk_size_blocks Or y>=super_grid.super_chunk_size_blocks) Then RuntimeError("out of bounds " + x + " " + y)
		?
		Local offset:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_size_t
		
		Return liquid_plus.PeekInt(offset)
	End Method
	
	Method set_liquid_plus(x:Int, y:Int, amount:Int)
		?Debug
			If(x<0 Or y<0 Or x>=super_grid.super_chunk_size_blocks Or y>=super_grid.super_chunk_size_blocks) Then RuntimeError("out of bounds " + x + " " + y)
		?
		Local offset:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_size_t
		
		liquid_plus.PokeInt(offset, amount)
	End Method
	
	Method add_liquid_plus(x:Int, y:Int, amount:Int)
		?Debug
			If(x<0 Or y<0 Or x>=super_grid.super_chunk_size_blocks Or y>=super_grid.super_chunk_size_blocks) Then RuntimeError("out of bounds " + x + " " + y)
		?
		Local offset:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_size_t
		
		liquid_plus.PokeInt(offset, liquid_plus.PeekInt(offset) + amount)
	End Method
	
	'------------------------------------------------------------- LIQUID_type ACCESS
	Method get_liquid_type:Byte(x:Int, y:Int)
		?Debug
			If(x<0 Or y<0 Or x>=super_grid.super_chunk_size_blocks Or y>=super_grid.super_chunk_size_blocks) Then RuntimeError("out of bounds " + x + " " + y)
		?
		Local offset:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_type_size_t
		
		Return liquid_type.PeekByte(offset)
	End Method
		
	Method set_liquid_type(x:Int, y:Int, typ:Byte)
		?Debug
			If(x<0 Or y<0 Or x>=super_grid.super_chunk_size_blocks Or y>=super_grid.super_chunk_size_blocks) Then RuntimeError("out of bounds " + x + " " + y)
		?
		Local offset:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_type_size_t
		
		liquid_type.PokeByte(offset, typ)
	End Method	
	
	' updates over the network
	Method action_set_full_block(network_only_if_host:Int , x:Int, y:Int, block_0:Int, block_1:Int, liquid:Int, liquid_plus:Int, liquid_type:Int)
		?Debug
			If(x<0 Or y<0 Or x>=super_grid.super_chunk_size_blocks Or y>=super_grid.super_chunk_size_blocks) Then RuntimeError("out of bounds " + x + " " + y)
		?
		
		Local offset_b:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.blocks_size_t
		Local offset_l:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_size_t
		Local offset_lt:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_type_size_t
		
		Local need_network_update:Int = False
		
		Select super_grid.universe.netw_man.mode
			Case NETWORK_MANAGER.SERVER
				need_network_update = True
			Case NETWORK_MANAGER.CLIENT
				If Not network_only_if_host Then need_network_update = True
			Default
				RuntimeError("not implemented")
		End Select
		
		If need_network_update Then
			' read, modify, update
			
			If block_0 < 0 Then
				block_0 = Self.blocks[0].PeekShort(offset_b)
			Else
				Self.blocks[0].PokeShort(offset_b, block_0)
			EndIf
			
			If block_1 < 0 Then
				block_1 = Self.blocks[1].PeekShort(offset_b)
			Else
				Self.blocks[1].PokeShort(offset_b, block_1)
			EndIf
			
			If liquid < 0 Then
				liquid = Self.liquid.PeekInt(offset_l)
			Else
				Self.liquid.PokeShort(offset_l, liquid)
			EndIf
			
			If liquid_plus < 0 Then
				liquid_plus = Self.liquid_plus.PeekInt(offset_l)
			Else
				Self.liquid_plus.PokeShort(offset_l, liquid_plus)
			EndIf
			
			If liquid_type < 0 Then
				liquid_type = Self.liquid_type.PeekByte(offset_lt)
			Else
				Self.liquid_type.PokeByte(offset_lt, liquid_type)
			EndIf
			'----------
			
			write_block_update(False, x, y, block_0, block_1, liquid, liquid_plus, liquid_type)
			'super_grid.universe.netw_man.write_block_update(False, super_grid.id, Self.x*super_grid.super_chunk_size_blocks + x, Self.y*super_grid.super_chunk_size_blocks + y, block_0, block_1, liquid, liquid_plus, liquid_type)
		Else
			' only local, no network update
			If block_0 >= 0 Then
				Self.blocks[0].PokeShort(offset_b, block_0)
			EndIf
			
			If block_1 >= 0 Then
				Self.blocks[1].PokeShort(offset_b, block_1)
			EndIf
			
			If liquid >= 0 Then
				Self.liquid.PokeShort(offset_l, liquid)
			EndIf
			
			If liquid_plus >= 0 Then
				Self.liquid_plus.PokeShort(offset_l, liquid_plus)
			EndIf
			
			If liquid_type >= 0 Then
				Self.liquid_type.PokeByte(offset_lt, liquid_type)
			EndIf
			
		EndIf
		
	End Method
	
	' updates over the network
	Method conditional_break_block_back(x:Int, y:Int)
		?Debug
			If(x<0 Or y<0 Or x>=super_grid.super_chunk_size_blocks Or y>=super_grid.super_chunk_size_blocks) Then RuntimeError("out of bounds " + x + " " + y)
		?
		Local offset_b:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.blocks_size_t
		
		If Not (super_grid.universe.netw_man.mode = NETWORK_MANAGER.CLIENT) Then
			RuntimeError("cannot action as non-client")
		EndIf
		
		Local block_0:Short = Self.blocks[0].PeekShort(offset_b)
		Local block_1:Short = Self.blocks[1].PeekShort(offset_b)
		
		super_grid.universe.netw_man.client_connector.condact_array..
			.write_break_block_back(super_grid.id, Self.x*super_grid.super_chunk_size_blocks + x, Self.y*super_grid.super_chunk_size_blocks + y, block_0, block_1)
		
		If VOXEL_BLOCK.item_when_breaking[block_0] > -1 Then
			Local kind_:Int = VOXEL_BLOCK.item_when_breaking[block_0]
			Local amount_:Int = 1
			Local info_:Int[] = New Int[0]
			super_grid.universe.netw_man.client_connector.inventory.add_item(kind_,amount_,info_) ' what if does not take ?
		EndIf
		
		Self.blocks[0].PokeShort(offset_b, 0)		
	End Method
	
	Method conditional_break_block_front(x:Int, y:Int)
		?Debug
			If(x<0 Or y<0 Or x>=super_grid.super_chunk_size_blocks Or y>=super_grid.super_chunk_size_blocks) Then RuntimeError("out of bounds " + x + " " + y)
		?
		Local offset_b:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.blocks_size_t
		
		If Not (super_grid.universe.netw_man.mode = NETWORK_MANAGER.CLIENT) Then
			RuntimeError("cannot action as non-client")
		EndIf
		
		Local block_0:Short = Self.blocks[0].PeekShort(offset_b)
		Local block_1:Short = Self.blocks[1].PeekShort(offset_b)
		
		super_grid.universe.netw_man.client_connector.condact_array..
			.write_break_block_front(super_grid.id, Self.x*super_grid.super_chunk_size_blocks + x, Self.y*super_grid.super_chunk_size_blocks + y, block_0, block_1)
		
		If VOXEL_BLOCK.item_when_breaking[block_1] > -1 Then
			Local kind_:Int = VOXEL_BLOCK.item_when_breaking[block_1]
			Local amount_:Int = 1
			Local info_:Int[] = New Int[0]
			super_grid.universe.netw_man.client_connector.inventory.add_item(kind_,amount_,info_) ' what if does not take ?
		EndIf
		
		Self.blocks[1].PokeShort(offset_b, 0)		
	End Method
	
	Method conditional_put_block_front(x:Int, y:Int, block:Int, inventory_index:Int)
		?Debug
			If(x<0 Or y<0 Or x>=super_grid.super_chunk_size_blocks Or y>=super_grid.super_chunk_size_blocks) Then RuntimeError("out of bounds " + x + " " + y)
		?
		Local offset_b:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.blocks_size_t
		Local offset_l:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_size_t
		Local offset_lt:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_type_size_t
		
		If Not (super_grid.universe.netw_man.mode = NETWORK_MANAGER.CLIENT) Then
			RuntimeError("cannot action as non-client")
		EndIf
		
		Local block_0:Short = Self.blocks[0].PeekShort(offset_b)
		Local block_1:Short = Self.blocks[1].PeekShort(offset_b)
		
		super_grid.universe.netw_man.client_connector.condact_array..
			.write_put_block_front(super_grid.id, Self.x*super_grid.super_chunk_size_blocks + x, Self.y*super_grid.super_chunk_size_blocks + y, block_0, block_1, block, inventory_index)
		
		Self.blocks[1].PokeShort(offset_b, block)
		
		Self.liquid.PokeShort(offset_l, 0)
		Self.liquid_plus.PokeShort(offset_l, 0)
		Self.liquid_type.PokeByte(offset_lt, 0)
	End Method
	Method conditional_put_block_back(x:Int, y:Int, block:Int, inventory_index:Int)
		?Debug
			If(x<0 Or y<0 Or x>=super_grid.super_chunk_size_blocks Or y>=super_grid.super_chunk_size_blocks) Then RuntimeError("out of bounds " + x + " " + y)
		?
		Local offset_b:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.blocks_size_t
		
		If Not (super_grid.universe.netw_man.mode = NETWORK_MANAGER.CLIENT) Then
			RuntimeError("cannot action as non-client")
		EndIf
		
		Local block_0:Short = Self.blocks[0].PeekShort(offset_b)
		Local block_1:Short = Self.blocks[1].PeekShort(offset_b)
		
		super_grid.universe.netw_man.client_connector.condact_array..
			.write_put_block_back(super_grid.id, Self.x*super_grid.super_chunk_size_blocks + x, Self.y*super_grid.super_chunk_size_blocks + y, block_0, block_1, block, inventory_index)
		
		Self.blocks[0].PokeShort(offset_b, block)		
	End Method
	
	Method conditional_put_liquid(x:Int, y:Int, amount:Int, typ:Byte, inventory_index:Int)
		?Debug
			If(x<0 Or y<0 Or x>=super_grid.super_chunk_size_blocks Or y>=super_grid.super_chunk_size_blocks) Then RuntimeError("out of bounds " + x + " " + y)
		?
		Local offset_b:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.blocks_size_t
		Local offset_l:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_size_t
		Local offset_lt:Int = (x + super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_type_size_t
		
		If Not (super_grid.universe.netw_man.mode = NETWORK_MANAGER.CLIENT) Then
			RuntimeError("cannot action as non-client")
		EndIf
		
		Local block_0:Short = Self.blocks[0].PeekShort(offset_b)
		Local block_1:Short = Self.blocks[1].PeekShort(offset_b)
		
		super_grid.universe.netw_man.client_connector.condact_array..
			.write_put_liquid(super_grid.id, Self.x*super_grid.super_chunk_size_blocks + x, Self.y*super_grid.super_chunk_size_blocks + y, block_0, block_1, amount, typ, inventory_index)
		
		Self.liquid.PokeShort(offset_l, amount)
		Self.liquid_plus.PokeShort(offset_l, 0)
		Self.liquid_type.PokeByte(offset_lt, typ)
	End Method
			
	Method deconstruct()
		' kill all dependencies ! -> or recycle eventually ?
		
		blocks = Null
		light = Null
		liquid = Null
		liquid_plus = Null
		liquid_type = Null
	End Method
	
	Function make_empty:VOXEL_SUPER_CHUNK(super_grid:VOXEL_SUPER_GRID)
		Local sc:VOXEL_SUPER_CHUNK = New VOXEL_SUPER_CHUNK
		
		sc.x = -1
		sc.y = -1
		sc.super_grid = super_grid
		
		'data fields:
		sc.blocks = New TBank[2] 'New Short[super_grid.super_chunk_size_blocks, super_grid.super_chunk_size_blocks, 2]
		sc.blocks[0] = TBANK_CONSTRUCTOR.Create(blocks_size_t   *  super_grid.super_chunk_size_blocks*super_grid.super_chunk_size_blocks, True)
		sc.blocks[1] = TBANK_CONSTRUCTOR.Create(blocks_size_t   *  super_grid.super_chunk_size_blocks*super_grid.super_chunk_size_blocks, True)
		sc.light = New Short[super_grid.super_chunk_size_blocks, super_grid.super_chunk_size_blocks, 3]
		sc.liquid = TBANK_CONSTRUCTOR.Create(liquid_size_t   *  super_grid.super_chunk_size_blocks*super_grid.super_chunk_size_blocks, True)
		sc.liquid_plus = TBANK_CONSTRUCTOR.Create(liquid_size_t   *  super_grid.super_chunk_size_blocks*super_grid.super_chunk_size_blocks, True)
		sc.liquid_type = TBANK_CONSTRUCTOR.Create(liquid_type_size_t   *  super_grid.super_chunk_size_blocks*super_grid.super_chunk_size_blocks, True)
		
		For Local xx:Int = 0 To super_grid.super_chunk_size_blocks-1
			For Local yy:Int = 0 To super_grid.super_chunk_size_blocks-1
				sc.set_block(xx,yy,0, VOXEL_BLOCK.OBSIDIAN)
				sc.set_block(xx,yy,1, VOXEL_BLOCK.OBSIDIAN)
			Next
		Next
		
		sc.block_update = BLOCK_UPDATE_ARRAY.Create(2, super_grid.id, sc.x, sc.y)
				
		Return sc
	End Function
	
	' DISK - ACCESS
	Function fetch:VOXEL_SUPER_CHUNK(super_grid:VOXEL_SUPER_GRID, x:Int,y:Int, need_exist:Int = True)
		Local sc:VOXEL_SUPER_CHUNK = New VOXEL_SUPER_CHUNK
		
		sc.x = x
		sc.y = y
		sc.super_grid = super_grid
		
		Select super_grid.universe.netw_man.mode
			Case NETWORK_MANAGER.CLIENT
				
				sc.blocks = New TBank[2] 'New Short[super_grid.super_chunk_size_blocks, super_grid.super_chunk_size_blocks, 2]
				sc.blocks[0] = TBANK_CONSTRUCTOR.Create(blocks_size_t   *  super_grid.super_chunk_size_blocks*super_grid.super_chunk_size_blocks, True)
				sc.blocks[1] = TBANK_CONSTRUCTOR.Create(blocks_size_t   *  super_grid.super_chunk_size_blocks*super_grid.super_chunk_size_blocks, True)
				sc.light = New Short[super_grid.super_chunk_size_blocks, super_grid.super_chunk_size_blocks, 3]
				sc.liquid = TBANK_CONSTRUCTOR.Create(liquid_size_t   *  super_grid.super_chunk_size_blocks*super_grid.super_chunk_size_blocks, True)
				sc.liquid_plus = TBANK_CONSTRUCTOR.Create(liquid_size_t   *  super_grid.super_chunk_size_blocks*super_grid.super_chunk_size_blocks, True)
				sc.liquid_type = TBANK_CONSTRUCTOR.Create(liquid_type_size_t   *  super_grid.super_chunk_size_blocks*super_grid.super_chunk_size_blocks, True)
				
				For Local xx:Int = 0 To super_grid.super_chunk_size_blocks-1
					For Local yy:Int = 0 To super_grid.super_chunk_size_blocks-1
						sc.set_block(xx,yy,0, VOXEL_BLOCK.OBSIDIAN)
						sc.set_block(xx,yy,1, VOXEL_BLOCK.OBSIDIAN)
					Next
				Next
				
				sc.block_update = BLOCK_UPDATE_ARRAY.Create(30, super_grid.id, sc.x, sc.y) ' will have to be removed / replaced !
				
			Default
				'data fields:
				sc.blocks = New TBank[2]
				
				sc.blocks[0] = fetch_bank(super_grid, x,y, need_exist, ("b0"), 2)
				sc.blocks[1] = fetch_bank(super_grid, x,y, need_exist, ("b1"), 2)
				
				sc.light = New Short[super_grid.super_chunk_size_blocks, super_grid.super_chunk_size_blocks, 3]
				
				sc.liquid = fetch_bank(super_grid, x,y, need_exist, ("lq"), 4)
				sc.liquid_plus = fetch_bank(super_grid, x,y, need_exist, ("lp"), 4)
				sc.liquid_type = fetch_bank(super_grid, x,y, need_exist, ("lt"), 1)
				
				sc.block_update = BLOCK_UPDATE_ARRAY.Create(100, super_grid.id, sc.x, sc.y)
		End Select
				
		Return sc
	End Function
	
	Function fetch_bank:TBank(super_grid:VOXEL_SUPER_GRID, x:Int,y:Int, need_exist:Int, subname:String, el_size_t:Int)
		' fetches compressed bank, decompresses it
				
		Local file_name:String = super_grid.world_path + "\" + x + "_" + y + "_" + subname + ".cpr"
		
		Local bank_cpr:TBank = LoadBank(file_name)
		
		If bank_cpr Then
			Print("  >  file (" + file_name+  ")")
			
			Local bank_size_expected:Int = el_size_t * super_grid.super_chunk_size_blocks * super_grid.super_chunk_size_blocks
			Local bank:TBank = uncompress_Bank(bank_cpr, bank_size_expected)
			
			Print("    -> got: " + bank.Size() + "/" + bank_size_expected + ", cpr: " + bank_cpr.Size())
			
			Return bank
		Else
			If need_exist Then
				RuntimeError("(fetch_bank) need_exist but did not (" + x + " " + y + ")")
			EndIf
			
			Print("(fetch_bank) create empty (" + x + " " + y + ")")
			
			Return TBANK_CONSTRUCTOR.Create(el_size_t * super_grid.super_chunk_size_blocks * super_grid.super_chunk_size_blocks, True)
		EndIf
	End Function
	
	Method save_bank(bank:TBank, subname:String, el_size_t:Int)
		' need to have written back all chunks first !
		' overwrite file if exists - "save/super_grid.world_name/x y.sc"
		Local file_name:String = super_grid.world_path + "\" + x + "_" + y + "_" + subname + ".cpr"
		
		Print("        (super-chunk-save-bank) save (" + file_name + ")")
				
		Local bank_cpr:TBank = compress_Bank(bank)
		
		bank_cpr.save(file_name)
		
		Print("        (super-chunk-save-bank) done. (cpr: " + bank_cpr.Size() + "/" + bank.Size() + ")")
	End Method
	
	Method get_cpr_bank:TBank(typ:Int) ' used for network !
		
		
		Local src:TBank
		
		Select typ
			Case 1
				src = blocks[0]
			Case 2
				src = blocks[1]
			Case 3
				src = liquid
			Case 4
				src = liquid_plus
			Case 5
				src = liquid_type
			Default
				RuntimeError("false type for get_cpr_bank")
		End Select
		
		If Not src Then RuntimeError("src not found (get_cpr_bank)")
		
		Return compress_Bank(src)
	End Method
	
	Method set_cpr_bank(bank_cpr:TBank, typ:Int) ' used for network !
		
		Local el_size_t:Int
		
		Select typ
			Case 1
				el_size_t = 2
			Case 2
				el_size_t = 2
			Case 3
				el_size_t = 4
			Case 4
				el_size_t = 4
			Case 5
				el_size_t = 1
		End Select
		
		Local bank_size_expected:Int = el_size_t * super_grid.super_chunk_size_blocks * super_grid.super_chunk_size_blocks
		Local bank:TBank = uncompress_Bank(bank_cpr, bank_size_expected)
		
		Select typ
			Case 1
				blocks[0] = bank
				last_receive_blocks[0] = MilliSecs()
			Case 2
				blocks[1] = bank
				last_receive_blocks[1] = MilliSecs()
			Case 3
				liquid = bank
				last_receive_liquids = MilliSecs()
			Case 4
				liquid_plus = bank
				last_receive_liquids_plus = MilliSecs()
			Case 5
				liquid_type = bank
				last_receive_liquids_type = MilliSecs()
			Default
				RuntimeError("false data typ!")
		End Select
		
		update_chunks_on_data_change(typ)
	End Method
	
	Method update_chunks_on_data_change(typ:Int)
		Local layer:Int = 0
		
		Select typ
			Case 1
				'blocks[0]
				layer = 0
			Case 2
				'blocks[1]
				layer = 1
			Case 3
				'liquid
				Return
			Case 4
				'liquid_plus
				Return
			Case 5
				'liquid_type
				Return
			Default
				RuntimeError("(update_chunks_on_data_change) false data typ!")
		End Select
		
		Local x1:Int = x*super_grid.super_chunk_size_chunks -1
		Local y1:Int = y*super_grid.super_chunk_size_chunks -1
		
		Local x2:Int = (x+1)*super_grid.super_chunk_size_chunks
		Local y2:Int = (y+1)*super_grid.super_chunk_size_chunks
		
		For Local cx:Int = x1 To x2
			For Local cy:Int = y1 To y2
				super_grid.grid.chunk_at_update_blocks(cx, cy, layer)
			Next
		Next
	End Method
	
	Method save()		
		Print("    (super-chunk-save) " + x + " " + y)
		
		save_bank(blocks[0], ("b0"), 2)
		save_bank(blocks[1], ("b1"), 2)
		
		save_bank(liquid, ("lq"), 4)
		save_bank(liquid_plus, ("lp"), 4)
		save_bank(liquid_type, ("lt"), 1)
				
		Print("    (super-chunk-save) done.")
	End Method
	
	Function compress_Bank:TBank(sourceBank:TBank, level:Int = 9)
		Local destBankSize:Int = Ceil(sourceBank.Size() * 1.001) + 12
		Local destBank:TBank = TBANK_CONSTRUCTOR.Create(destBankSize, True)
		
		compress2(destBank.Buf(), destBankSize, sourceBank.Buf(), sourceBank.Size(), level) ' crash count 1
		
		'resize bank to it's compressed size
		destBank.Resize(destBankSize)
		
		Return destBank
	End Function

	Function uncompress_Bank:TBank(sourceBank:TBank, destBankSize:Int)
	'destBankSize holds size of the uncompressed data saved previously
		Local destBank:TBank = TBANK_CONSTRUCTOR.Create(destBankSize, True)
		
		uncompress(destBank.Buf(), destBankSize, sourceBank.Buf(), sourceBank.Size())
		
		Return destBank
	End Function
	
	Method chunk_logon()
		chunks_dependent:+1
	End Method
	
	Method chunk_logoff()
		chunks_dependent:-1
		
		If chunks_dependent = 0 Then
			time_since_independent = MilliSecs()
			' after some time super_chunk may be unloaded !
		EndIf
	EndMethod
End Type


'----------------------------------------------------------------------------------------
'---------------------------                    -----------------------------------------
'---------------------------     Random Gen     -----------------------------------------
'---------------------------                    -----------------------------------------
'----------------------------------------------------------------------------------------
Type RANDOM_GEN
	Field offset:Long = 0
	
	Field scale:Float[][] ' power of 2 ?
	
	Field noise_size:Int
	Field noise:Byte[,]
	
	Function Create:RANDOM_GEN(scale:Float[][], noise_size:Int = 0, noise:Byte[,] = Null)
		Local r:RANDOM_GEN = New RANDOM_GEN
		
		r.scale = scale
		
		r.noise_size = noise_size
		r.noise = noise
		
		If r.noise_size = 0 Then
			r.noise_size = 2^6
			r.noise = RANDOM_GEN.get_noise_field(r.noise_size)
		EndIf
		
		Return r
	End Function
	
	Function get_noise_field:Byte[,](size:Int)
		Local n:Byte[,] = New Byte[size,size]
		
		For Local x:Int = 0 To size-1
			For Local y:Int = 0 To size-1
				n[x,y] = Rand(0,255)
			Next
		Next
		
		Return n
	End Function
	
	Method get_2d:Float(x:Float,y:Float)
		Local sum:Float = 0
		Local sum_weight:Float = 0
		For Local i:Int = 0 To scale.length-1
			Local x1:Int = Floor(x/scale[i][0])
			Local y1:Int = Floor(y/scale[i][0])
			
			Local x_side:Float = x/scale[i][0]-x1
			Local y_side:Float = y/scale[i][0]-y1
			
			Local typ:Int = 2 ' interpol typ: 0 linear, 1 hermite, 2 quintic
			
			Local x_s:Float = interpolate(x_side,typ)
			Local x_s_i:Float = interpolate(1.0-x_side,typ)
			Local y_s:Float = interpolate(y_side,typ)
			Local y_s_i:Float = interpolate(1.0-y_side,typ)
			
			Local a:Float = get_2d_int(x1,y1,scale[i][0])*x_s_i + get_2d_int(x1+1,y1,scale[i][0])*x_s
			Local b:Float = get_2d_int(x1,y1+1,scale[i][0])*x_s_i + get_2d_int(x1+1,y1+1,scale[i][0])*x_s
			sum:+ (a*y_s_i + b*y_s)*scale[i][1]
			sum_weight:+scale[i][1]
		Next
		Return sum / sum_weight
	End Method
	
	Method get_2d_int:Float(x:Int,y:Int,scale:Float)
		x = x + offset
		y = y + offset
		
		'If y<0 Or x < 0 Then Return 0.0
		
		x = ((x Mod noise_size) + noise_size) Mod noise_size
		y = ((y Mod noise_size) + noise_size) Mod noise_size 
		
		Return noise[x,y]/256.0
	End Method
	
	Method get_1d:Float(x:Float)
		Local sum:Float = 0
		Local sum_weight:Float = 0
		For Local i:Int = 0 To scale.length-1
			Local x1:Int = Floor(x/scale[i][0])
			
			Local x_side:Float = x/scale[i][0]-x1
			
			Local typ:Int = 2 ' interpol typ: 0 linear, 1 hermite, 2 quintic
			
			Local x_s:Float = interpolate(x_side,typ)
			Local x_s_i:Float = interpolate(1.0-x_side,typ)
			
			Local a:Float = get_1d_int(x1,scale[i][0])*x_s_i + get_1d_int(x1+1, scale[i][0])*x_s
			
			sum:+ a
			sum_weight:+scale[i][1]
		Next
		Return sum / sum_weight
	End Method
	
	Method plot_1d(step_size:Float,vertical:Float)
		SetColor 255,255,0
		
		For Local x:Int = 0 To Graphics_Handler.x-1
			DrawRect x, vertical*get_1d(step_size*x),1,1
		Next
	End Method
	
	Method get_1d_int:Float(x:Int,scale:Float)
		x = x + offset
		
		'If y<0 Or x < 0 Then Return 0.0
		Local n2:Int = noise_size*noise_size
		
		x = ((x Mod n2) +n2) Mod n2
		
		Return noise[x Mod noise_size,x/noise_size]/256.0
	End Method

		
	Method interpolate:Float(t:Float, typ:Int = 0)
		' t from 0 to 1
		Select typ
			Case 0
				Return t
			Case 1 ' Hermite
				Return (t*t*(3.0-2.0*t))
			Case 2 ' Quintic
				Return t*t*t*(t*(t*6.0-15.0)+10.0)
			Default
				Return t
		End Select
	End Method
End Type

'----------------------------------------------------------------------------------------
'---------------------------                    -----------------------------------------
'---------------------------     Coord Key      -----------------------------------------
'---------------------------                    -----------------------------------------
'----------------------------------------------------------------------------------------
Type COORD_KEY
	Field x:Int
	Field y:Int
	
	Function Create:COORD_KEY(x:Int, y:Int)
		Local k:COORD_KEY = New COORD_KEY
		
		k.x = x
		k.y = y
		
		Return k
	End Function
	
	Method Compare:Int(other:Object)
		Local o2:COORD_KEY = COORD_KEY(other)
		
		If o2 = Null Then Return Super.Compare(other)
		
		If o2.x < x Then Return -1
		If o2.x > x Then Return 1
		
		If o2.y < y Then Return -1
		If o2.y > y Then Return 1
		
		Return 0
	End Method
End Type
'----------------------------------------------------------------------------------------
'---------------------------                    -----------------------------------------
'---------------------------     Voxel Dig      -----------------------------------------
'---------------------------                    -----------------------------------------
'----------------------------------------------------------------------------------------
Type VOXEL_DIG
	Global img:TImage
	Global sel:TImage
	
	Function init()
		img = LoadAnimImage("tiles\dig.png", 8,8, 0,16, 0)
		sel = LoadAnimImage("tiles\select.png", 8,8, 0,2, 0)
	End Function
	
	Field size:Int
	Field radius:Int
	Field table:Int[,,]'x,y,level
	
	Field grid:VOXEL_GRID
	
	Field zero_x:Int
	Field zero_y:Int
	
	Method deconstruct()
			table = Null
			grid = Null
	End Method
	
	Function Create:VOXEL_DIG(radius:Int, grid:VOXEL_GRID)
		Local d:VOXEL_DIG = New VOXEL_DIG
		
		d.size = radius*2
		d.radius = radius
		d.table = New Int[d.size,d.size,2]
		
		d.grid = grid
		
		For Local x:Int = 0 To d.size-1
			For Local y:Int = 0 To d.size-1
				d.table[x,y,0] = 0
				d.table[x,y,1] = 0
			Next
		Next
		
		Return d
	End Function
		
	Method render_and_draw()
		render_and_draw_interact_block_objects()
		render_and_draw_place_objects()
		render_and_draw_dig()
		render_and_draw_place_blocks()
	End Method
	
	Method render_and_draw_interact_block_objects() ' interacting with block objects
		Local x:Int = Floor(Float(KInput.MX-grid.view_x)/Float(grid.block_size))
		Local y:Int = Floor(Float(KInput.MY-grid.view_y)/Float(grid.block_size))
		
		If KInput.Ke.hit Then
			
			If BLOCK_OBJECT_PATTERN.find_origin(grid.super_grid, x,y) Then
				Print("origin: " + x + " " + y)
				
				Local c:T_CHEST = T_CHEST(grid.super_grid.block_object_map.ValueForKey(COORD_KEY.Create(x,y)))
				
				If c Then
					Print "id: " + c.id
					grid.super_grid.universe.gui.add_chest_viewer(c)
				Else
					Print "X"
				EndIf
			Else
				Print "nothing here."
			EndIf
		EndIf
	End Method
	
	Method render_and_draw_place_objects()
		Local side:Int = 0
		Local inventory:ITEMS_ARRAY = grid.super_grid.universe.gui.top_bar.slot_left.item_array
		Local ind:Int = 0
		Local place_block_object_kind:Int = 0
		
		If Not KInput.M_captured Then
			If True Then ' LEFT
				Local slot:EG_ITEM_SLOT = grid.super_grid.universe.gui.top_bar.slot_left
				Local item_kind:Int = slot.item_array.array_kind[slot.index]
				
				If item_kind > -1 Then
					If ITEM.typ[item_kind] = ITEM.TYPE_BO Then
						ind = slot.index
						side = 1
						
						place_block_object_kind = ITEM.get_bo_nr(item_kind)
					EndIf
					
					Rem
					place_block_object_kind = ITEM.is_block_object[item_kind]
					
					If place_block_object_kind Then
						ind = slot.index
						side = 1
					EndIf
					EndRem
				EndIf
			EndIf
			
			If Not place_block_object_kind Then ' RIGHT
				Local slot:EG_ITEM_SLOT = grid.super_grid.universe.gui.top_bar.slot_right
				Local item_kind:Int = slot.item_array.array_kind[slot.index]
				
				If item_kind > -1 Then
					If ITEM.typ[item_kind] = ITEM.TYPE_BO Then
						ind = slot.index
						side = 2
						
						place_block_object_kind = ITEM.get_bo_nr(item_kind)
					EndIf
					
					Rem
					place_block_object_kind = ITEM.is_block_object[item_kind]
					
					If place_block_object_kind Then
						ind = slot.index
						side = 2
					EndIf
					End Rem
				EndIf
			EndIf
			
			If place_block_object_kind Then
				If BLOCK_OBJECT_MANAGER.draw_place_preview(place_block_object_kind, grid.super_grid) Then
					
						Select side
							Case 1
								If KInput.M1.down Then
									BLOCK_OBJECT_MANAGER.place_it_client(place_block_object_kind, grid.super_grid, ind)
								EndIf
							Case 2
								If KInput.M2.down Then
									BLOCK_OBJECT_MANAGER.place_it_client(place_block_object_kind, grid.super_grid, ind)
								EndIf
						End Select
				EndIf
			EndIf
		EndIf		
	End Method
	
	
	Method render_and_draw_place_blocks()
		' ---------------------------------- PLACE BLOCKS
		'take_item:Int(index:Int, amount:Int)
		Local side_1:Int = False
		Local side_2:Int = False
		Local layer:Int = 0
		Local inventory:ITEMS_ARRAY = grid.super_grid.universe.gui.top_bar.slot_left.item_array
		Local ind_1:Int = 0
		Local ind_2:Int = 0
		Local place_block_left:Int = 0
		Local place_block_right:Int = 0
		
		If Not KInput.M_captured Then
			
			If KInput.Klshift.down Then
				layer = 0
			Else
				layer = 1
			EndIf
			
			If True Then ' LEFT
				Local slot:EG_ITEM_SLOT = grid.super_grid.universe.gui.top_bar.slot_left
				Local item_kind:Int = slot.item_array.array_kind[slot.index]
				
				If item_kind > -1 Then
					If ITEM.typ[item_kind] = ITEM.TYPE_BLOCK Then
						ind_1 = slot.index
						side_1 = True
						
						place_block_left = ITEM.get_block(item_kind)
					EndIf
					
					Rem
					place_block = ITEM.block_placable[item_kind]
					
					If place_block Then
						ind = slot.index
						side = 1
					EndIf
					End Rem
				EndIf
			EndIf
			
			If True Then ' RIGHT
				Local slot:EG_ITEM_SLOT = grid.super_grid.universe.gui.top_bar.slot_right
				Local item_kind:Int = slot.item_array.array_kind[slot.index]
				
				If item_kind > -1 Then
					If ITEM.typ[item_kind] = ITEM.TYPE_BLOCK Then
						ind_2 = slot.index
						side_2 = True
						
						place_block_right = ITEM.get_block(item_kind)
					EndIf
					
					Rem
					place_block = ITEM.block_placable[item_kind]
					
					If place_block Then
						ind = slot.index
						side = 2
					EndIf
					End Rem
				EndIf
			EndIf
			
			If place_block_left Or place_block_right Then
				Local dgx1:Int, dgx2:Int, dgy1:Int, dgy2:Int
				If size_place_blocks Mod 2 Then
					dgx1 = Floor(Float(KInput.MX-grid.view_x)/Float(grid.block_size)) - size_place_blocks/2
					dgy1 = Floor(Float(KInput.MY-grid.view_y)/Float(grid.block_size)) - size_place_blocks/2
					
					dgx2 = dgx1 + size_place_blocks
					dgy2 = dgy1 + size_place_blocks
				Else
					dgx1 = Floor(Float(KInput.MX-grid.view_x+grid.block_size/2)/Float(grid.block_size)) - size_place_blocks/2
					dgy1 = Floor(Float(KInput.MY-grid.view_y+grid.block_size/2)/Float(grid.block_size)) - size_place_blocks/2
					
					dgx2 = dgx1 + size_place_blocks
					dgy2 = dgy1 + size_place_blocks
				EndIf

				
				SetScale 3,3
								
				For Local x:Int = dgx1 To dgx2-1
					For Local y:Int = dgy1 To dgy2-1
												
						Local blk:Short[] = [grid.super_grid.get_block_truncated(x,y, 0), grid.super_grid.get_block_truncated(x,y, 1)]				
						
						If side_1 And place_block_left Then
								'place_block_left
								
								If VOXEL_BLOCK.can_overplace[blk[layer]] And place_block_left Then
									SetColor 100,100,255
									DrawImage sel, grid.view_x+x*grid.block_size, grid.view_y+y*grid.block_size, layer
									
									If KInput.M1.down Then
										If inventory.take_item(ind_1, 1) Then
											Select layer
												Case 0
													grid.conditional_put_block_back(x,y, place_block_left, ind_1)
												Case 1
													grid.conditional_put_block_front(x,y, place_block_left, ind_1)
											End Select
										EndIf
									EndIf
								EndIf
						EndIf
						
						If side_2 And place_block_right Then
								If VOXEL_BLOCK.can_overplace[blk[layer]] And place_block_right Then
									SetColor 255,100,100
									DrawImage sel, grid.view_x+x*grid.block_size, grid.view_y+y*grid.block_size, layer
									
									If KInput.M2.down And (Not KInput.M1.down) Then
										If inventory.take_item(ind_2, 1) Then
											Select layer
												Case 0
													grid.conditional_put_block_back(x,y, place_block_right, ind_2)
												Case 1
													grid.conditional_put_block_front(x,y, place_block_right, ind_2)
											End Select
										EndIf
									EndIf
								EndIf
						EndIf
					Next
				Next
			EndIf
			
			Rem
			If KInput.M1.down Then				
			ElseIf KInput.M2.down Then
			EndIf
			End Rem
		EndIf
	End Method
	
	Global size_place_blocks:Int = 2
	Global size_place_blocks_max:Int = 2
	
	Method render_and_draw_dig()
		' ---------------------------------- DIG
		Local left_is_digging:Int = 0
		Local right_is_digging:Int = 0
		
		Local layer:Int = 0
		
		Local diameter:Int = 2
				
		size_place_blocks_max = 2
		
		If Not KInput.M_captured Then
			
			If True Then
				Local slot:EG_ITEM_SLOT = grid.super_grid.universe.gui.top_bar.slot_left
				Local item_kind:Int = slot.item_array.array_kind[slot.index]
				'Local item_amount:Int = slot.item_array.array_amount[slot.index]
				'Local item_info:Int[] = slot.item_array.array_info[slot.index]
				
				If item_kind > -1 And ITEM.typ[item_kind] = ITEM.TYPE_TOOL_DIGGING Then
					left_is_digging = ITEM.get_dig_value(item_kind)
					diameter = Max(ITEM.get_dig_diameter(item_kind), diameter)
				EndIf
			EndIf
			
			If True Then
				Local slot:EG_ITEM_SLOT = grid.super_grid.universe.gui.top_bar.slot_right
				Local item_kind:Int = slot.item_array.array_kind[slot.index]
				'Local item_amount:Int = slot.item_array.array_amount[slot.index]
				'Local item_info:Int[] = slot.item_array.array_info[slot.index]
				
				If item_kind > -1 And ITEM.typ[item_kind] = ITEM.TYPE_TOOL_DIGGING Then
					right_is_digging = ITEM.get_dig_value(item_kind)
					diameter = Max(ITEM.get_dig_diameter(item_kind), diameter)
				EndIf
			EndIf
		EndIf
		
		
		If KInput.Klshift.down Then
			layer = 0
		Else
			layer = 1
		EndIf
		
		size_place_blocks_max = Max(diameter, size_place_blocks_max)
		size_place_blocks  = Min(size_place_blocks, size_place_blocks_max)
		If KInput.KControl.hit Then
			size_place_blocks = (size_place_blocks Mod size_place_blocks_max) + 1
		EndIf
		
		diameter = size_place_blocks
		
		Local gx:Int = Floor(Float(KInput.MX-grid.view_x)/Float(grid.block_size)) ' global blocks
		Local gy:Int = Floor(Float(KInput.MY-grid.view_y)/Float(grid.block_size))
		
		Local dgx1:Int, dgx2:Int, dgy1:Int, dgy2:Int
		If diameter Mod 2 Then
			dgx1 = Floor(Float(KInput.MX-grid.view_x)/Float(grid.block_size)) - diameter/2
			dgy1 = Floor(Float(KInput.MY-grid.view_y)/Float(grid.block_size)) - diameter/2
			
			dgx2 = dgx1 + diameter
			dgy2 = dgy1 + diameter
		Else
			dgx1 = Floor(Float(KInput.MX-grid.view_x+grid.block_size/2)/Float(grid.block_size)) - diameter/2
			dgy1 = Floor(Float(KInput.MY-grid.view_y+grid.block_size/2)/Float(grid.block_size)) - diameter/2
			
			dgx2 = dgx1 + diameter
			dgy2 = dgy1 + diameter
		EndIf
		
		
		SetScale 3,3
		
		Local dx:Int = gx - zero_x
		Local dy:Int = gy - zero_y
		
		For Local x:Int = 0 To size-1
			For Local y:Int = 0 To size-1
				
				Local xx:Int = x-radius + gx
				Local yy:Int = y-radius + gy
				
				Local tx:Int = ((xx Mod size)+size) Mod size
				Local ty:Int = ((yy Mod size)+size) Mod size
				
				
				If x+dx > size-1 Then
					table[tx,ty,0] = 0
					table[tx,ty,1] = 0
				EndIf
				If y+dy > size-1 Then
					table[tx,ty,0] = 0
					table[tx,ty,1] = 0
				EndIf
				
				If x+dx < 0 Then
					table[tx,ty,0] = 0
					table[tx,ty,1] = 0
				EndIf
				If y+dy < 0 Then
					table[tx,ty,0] = 0
					table[tx,ty,1] = 0
				EndIf
				
				Local blk:Short[] = [grid.super_grid.get_block_truncated(xx,yy, 0), grid.super_grid.get_block_truncated(xx,yy, 1)]				
				
				
				Local blk_brk_form:Int = 4*((xx+yy*4) Mod 4)
				
				If (Not VOXEL_BLOCK.collision[blk[1]]) And table[tx,ty,0] > 0  And  VOXEL_BLOCK.durability[blk[0]] > -1 Then
					SetColor 255,255,255
					Local lvl:Int = Min(3, 4*table[tx,ty,0]/VOXEL_BLOCK.durability[blk[0]])
					DrawImage img, grid.view_x+xx*grid.block_size, grid.view_y+yy*grid.block_size, lvl + blk_brk_form
				ElseIf table[tx,ty,1] > 0 And  VOXEL_BLOCK.durability[blk[1]] > -1 Then
					SetColor 255,255,255
					Local lvl:Int = Min(3, 4*table[tx,ty,1]/VOXEL_BLOCK.durability[blk[1]])
					DrawImage img, grid.view_x+xx*grid.block_size, grid.view_y+yy*grid.block_size, lvl + blk_brk_form
				EndIf
				
				If xx >= dgx1 And xx < dgx2 And yy >= dgy1 And yy < dgy2 Then
					
					If KInput.M1.down Then
							SetColor 100,100,255
							DrawImage sel, grid.view_x+xx*grid.block_size, grid.view_y+yy*grid.block_size, layer
					ElseIf KInput.M2.down Then
							SetColor 255,100,100
							DrawImage sel, grid.view_x+xx*grid.block_size, grid.view_y+yy*grid.block_size, layer
					EndIf
					
					If VOXEL_BLOCK.durability[blk[layer]] > -1 Then
						
						If KInput.M1.down Then
							table[tx,ty, layer]:+left_is_digging
						ElseIf KInput.M2.down Then
							table[tx,ty, layer]:+right_is_digging
						EndIf
						
						If table[tx,ty, layer] > VOXEL_BLOCK.durability[blk[layer]] Then
							' break block !
							
							Select layer
								Case 0
									grid.conditional_break_block_back(xx,yy)
								Case 1
									grid.conditional_break_block_front(xx,yy)
							End Select
							
							table[tx,ty, layer] = 0
						EndIf
					ElseIf VOXEL_BLOCK.durability[blk[layer]] = -2 Then ' block_object
						
						Local bo_attack:Int = 0
						
						If KInput.M1.down Then
							bo_attack = left_is_digging
						ElseIf KInput.M2.down Then
							bo_attack = right_is_digging
						EndIf
						
						If bo_attack Then
							Local x_:Int = xx
							Local y_:Int = yy
							
							If BLOCK_OBJECT_PATTERN.find_origin(grid.super_grid, x_,y_) Then
								Local c:T_CHEST = T_CHEST(grid.super_grid.block_object_map.ValueForKey(COORD_KEY.Create(x_,y_)))
								
								If c Then
									Print "id: " + c.id
									c.mine_me(bo_attack)
								Else
									Print "block object not found -> cannot mine it ! (2)"
								EndIf
	
							Else
								Print "block object not found -> cannot mine it ! (1)"
							EndIf
						EndIf
					EndIf
				EndIf
			Next
		Next
		
		SetScale 1,1
		zero_x = gx
		zero_y = gy
	End Method

End Type

'----------------------------------------------------------------------------------------
'---------------------------                    -----------------------------------------
'---------------------------   BLOCK OBJECTS    -----------------------------------------
'---------------------------                    -----------------------------------------
'----------------------------------------------------------------------------------------
Type BLOCK_OBJECT_MANAGER
	
	Const TYPE_CHEST:Int = 1
	
	'Local images:TImage[] = [TImage(Null), T_CHEST.img]
	
	Rem
		---- KIND:
		
		
		1 -> chest, pattern 1
	End Rem
	
	Function draw_place_preview:Int(kind:Int, world:VOXEL_SUPER_GRID) ' returns if ok
		Select kind
			Case TYPE_CHEST
				' test if free:
				Local x:Int = Floor(Float(KInput.MX-world.grid.view_x)/Float(world.grid.block_size))-1 ' offset !
				Local y:Int = Floor(Float(KInput.MY-world.grid.view_y)/Float(world.grid.block_size))
				
				If BLOCK_OBJECT_PATTERN.test(BLOCK_OBJECT_PATTERN.THREE_BY_TWO_C, world, x,y) Then
					DrawImage T_CHEST.img, world.grid.view_x+x*world.grid.block_size, world.grid.view_y+y*world.grid.block_size
					Return True
				EndIf
				Return False
			Default
				RuntimeError("blk obj man: kind not found !")
		End Select
	End Function
	
	' assumes NOT that test has been performed
	Function place_it_client(kind:Int, world:VOXEL_SUPER_GRID, item_index:Int)
		Select kind
			Case TYPE_CHEST
				' test if free:
				Local x:Int = Floor(Float(KInput.MX-world.grid.view_x)/Float(world.grid.block_size))-1 ' offset !
				Local y:Int = Floor(Float(KInput.MY-world.grid.view_y)/Float(world.grid.block_size))
				
				If BLOCK_OBJECT_PATTERN.test(BLOCK_OBJECT_PATTERN.THREE_BY_TWO_C, world, x,y) Then
					BLOCK_OBJECT_PATTERN.set(BLOCK_OBJECT_PATTERN.THREE_BY_TWO_C, world, x,y)
					
					' network it !
					world.universe.netw_man.client_connector.condact_array..
						.write_put_blk_obj(world.id, x, y, kind, item_index, world.universe.netw_man.client_connector.inventory.array_kind[item_index])
					
					world.universe.netw_man.client_connector.inventory.take_item(item_index, 1)
					
					Print("client: put down that chest !")
				EndIf
			Default
				RuntimeError("blk obj man: kind not found !")
		End Select
	End Function
	
	
	Function place_server:Int(kind:Int, world:VOXEL_SUPER_GRID, x:Int, y:Int) ' tries to place
		Select kind
			Case TYPE_CHEST
				' test if free:
				
				If BLOCK_OBJECT_PATTERN.test(BLOCK_OBJECT_PATTERN.THREE_BY_TWO_C, world, x,y) Then
					
					Select world.universe.netw_man.mode
						Case NETWORK_MANAGER.CLIENT
							RuntimeError("client cannot use this, must use client version !")
						Case NETWORK_MANAGER.SERVER
							
							BLOCK_OBJECT_PATTERN.set(BLOCK_OBJECT_PATTERN.THREE_BY_TWO_C, world, x,y)
							T_CHEST.Create(x*world.grid.block_size,y*world.grid.block_size, x,y, world, NETWORK_MANAGER.SERVER_ID, False, Null)
						Default
							RuntimeError("blk obj man: netw_man mode not implemented !")
					End Select
				EndIf
				
			Default
				RuntimeError("blk obj man: kind not found !")
		End Select
	End Function
	
	Function break_it_client(x:Int, y:Int, block_obj_type:Int, world:VOXEL_SUPER_GRID)
		
		Select block_obj_type
			Case TYPE_CHEST
				world.universe.netw_man.client_connector.condact_array..
						.write_break_blk_obj(world.id, x, y, block_obj_type)
			Default
				RuntimeError("blk obj man: kind not found !")
		End Select
		
	End Function
	
	Function break_server(block_obj_type:Int, world:VOXEL_SUPER_GRID, x:Int, y:Int)
		' test if really there:
		Local x_:Int = x
		Local y_:Int = y
		
		If BLOCK_OBJECT_PATTERN.find_origin(world, x_, y_) Then
			If x <> x_ Or y <> y_ Then
				Print "break block object: something found, but coordinates do not match. -> abort"
				Return
			EndIf
			
			Print "break block object: grid ok"
			
			' find object behind:
			Select block_obj_type
				Case TYPE_CHEST
					Local c:T_CHEST = T_CHEST(world.block_object_map.ValueForKey(COORD_KEY.Create(x,y)))
					
					If c Then
						' drop content :
						Local d_x:Int = x*world.grid.block_size+world.grid.block_size/2*3
						Local d_y:Int = y*world.grid.block_size+world.grid.block_size/2*3
						
						For Local i:Int = 0 To c.item_array.array_kind.length-1
							
							If c.item_array.array_kind[i] > -1 Then
								Local kind_:Int = c.item_array.array_kind[i]
								Local amount_:Int = c.item_array.array_amount[i]
								Local info_:Int[] = c.item_array.array_info[i]
								
								TITEM_DROP.Create(d_x,d_y, kind_,amount_,info_, world, NETWORK_MANAGER.SERVER_ID, False, Null)
							EndIf
						Next
						
						Local kind_:Int = ITEM.BO_CHEST
						Local amount_:Int = 1
						Local info_:Int[] = New Int[0]
						
						TITEM_DROP.Create(d_x,d_y, kind_,amount_,info_, world, NETWORK_MANAGER.SERVER_ID, False, Null)
						
						' destroy box itself
						c.remove(world.universe.netw_man)
						BLOCK_OBJECT_PATTERN.remove(BLOCK_OBJECT_PATTERN.THREE_BY_TWO_C, world, x,y)
					Else
						Print "break block object: not found in objects -> abort"
						Return
					EndIf
				Default
					RuntimeError("blk obj man: kind not found !")
			End Select
		Else
			Print "break block object: not found on grid ! -> abort"
			Return
		EndIf		
	End Function
End Type


Type BLOCK_OBJECT_PATTERN
	Const THREE_BY_TWO_C:Int = 1
	
	Function test:Int(pattern:Int, world:VOXEL_SUPER_GRID, x:Int,y:Int) ' x,y in blocks
		' see if space available
		
		Select pattern
			Case THREE_BY_TWO_C ' 2 high, 3 wide, topleft origin, with collision
				
				For Local xx:Int = 0 To 2
					For Local yy:Int = 0 To 1
						Local blk:Short = world.get_block_truncated(x+xx,y+yy, 1)
						
						If Not VOXEL_BLOCK.can_overplace[blk] Then Return False
					Next
				Next
				
				Return True
			Default
				RuntimeError("pattern not known !")
		End Select
		
	End Function 
	
	Function set(pattern:Int, world:VOXEL_SUPER_GRID, x:Int,y:Int) ' x,y in blocks
		' generate object
		
		Select pattern
			Case THREE_BY_TWO_C ' 2 high, 3 wide, topleft origin, with collision
				
				For Local xx:Int = 0 To 2
					For Local yy:Int = 0 To 1
						If xx = 0 And yy = 0 Then
							world.action_set_full_block_truncated(True , x+xx,y+yy, -1, VOXEL_BLOCK.OBJ_X_C, -1,-1,-1)
						ElseIf yy = 0 Then
							world.action_set_full_block_truncated(True , x+xx,y+yy, -1, VOXEL_BLOCK.OBJ_L_C, -1,-1,-1)
						Else
							world.action_set_full_block_truncated(True , x+xx,y+yy, -1, VOXEL_BLOCK.OBJ_U_C, -1,-1,-1)
						EndIf
					Next
				Next
				
			Default
				RuntimeError("pattern not known !")
		End Select
	End Function 
	
	Function remove(pattern:Int, world:VOXEL_SUPER_GRID, x:Int,y:Int) ' x,y in blocks
		
		Select pattern
			Case THREE_BY_TWO_C ' 2 high, 3 wide, topleft origin, with collision
				
				For Local xx:Int = 0 To 2
					For Local yy:Int = 0 To 1
						world.action_set_full_block_truncated(True , x+xx,y+yy, -1, VOXEL_BLOCK.AIR, -1,-1,-1)
					Next
				Next
				
			Default
				RuntimeError("pattern not known !")
		End Select
	End Function 
	
	Function find_origin:Int(world:VOXEL_SUPER_GRID, x:Int Var, y:Int Var) ' changes x,y to origin, in blocks
		Local step_counter:Int = 0
		
		Repeat
			step_counter:+1
			
			If step_counter > 1000 Then RuntimeError("goal not found !")
			
			Local blk:Short = world.get_block_truncated(x,y, 1)
			
			Select blk
				Case VOXEL_BLOCK.OBJ_X_C, VOXEL_BLOCK.OBJ_X_NC
					Return True
				Case VOXEL_BLOCK.OBJ_R_C, VOXEL_BLOCK.OBJ_R_NC
					x:+1
				Case VOXEL_BLOCK.OBJ_L_C, VOXEL_BLOCK.OBJ_L_NC
					x:-1
				Case VOXEL_BLOCK.OBJ_D_C, VOXEL_BLOCK.OBJ_D_NC
					y:+1
				Case VOXEL_BLOCK.OBJ_U_C, VOXEL_BLOCK.OBJ_U_NC
					y:-1
				Default
					Return False
			End Select
		Forever
		
	End Function
End Type



'----------------------------------------------------------------------------------------
'---------------------------                    -----------------------------------------
'---------------------------     Voxel Grid     -----------------------------------------
'---------------------------                    -----------------------------------------
'----------------------------------------------------------------------------------------

Type VOXEL_GRID
	'Global active:VOXEL_GRID
	
	Global draw_chunk_debug:Int = 0 		' for debugging
	Global draw_chunk_debug_water:Int = 0 	' for debugging
	
	Const chunk_size_blocks:Int = 10'4   ' input, power 2
	Const block_size_bitsel:Int = 24'4 
	Const bitsel_size_pixel:Int = 1'8
	
	Const chunk_size:Int = VOXEL_GRID.chunk_size_blocks * VOXEL_GRID.block_size_bitsel * VOXEL_GRID.bitsel_size_pixel ' calculated, in pixel
	Const block_size:Int = VOXEL_GRID.block_size_bitsel * VOXEL_GRID.bitsel_size_pixel
	
	Const chunks_done_outside_screen_blocks:Int = 1 ' 0 enough, more nice but expensive
	Const chunks_done_outside_screen_liquids:Int = 1 ' 0 enough, more nice but expensive
	Const chunks_done_outside_screen_lights:Int = 0 ' 0 enough, more nice but expensive
	Const chunks_kept_outside_screen:Int = 6 ' max of others or more, ensures data is loaded
	
	Field super_grid:VOXEL_SUPER_GRID
	
	Field view_x:Float = 0'-2^11 ' camera position
	Field view_y:Float = 0'-2^11
	Field view_x_aim:Float = 0'-2^11
	Field view_y_aim:Float = 0'-2^11
	
	'Field player:TPLAYER
	
	' The random functions
	Field random_blocks_frames:RANDOM_GEN ' for choice of frame of block
	
	' Data Structure - using map:
	Field chunk_map:TMap ' key: long, encodes 2 ints for coords
	Field block_lists:TList[] = New TList[2]
	Field liquids_list:TList
	Field create_data_list:TList
	
	Global draw_lights_enabled:Int = 1
	Field light_flood_buffer:TBuffer
	
	Field raycast_buffer:TBuffer
	Field raycast_x_block:Int ' block where raycasting starts
	Field raycast_y_block:Int
	
	Field light_final_buffer:TBuffer
	
	Field scene_render_buffer:TBuffer ' used to keep scene seperate from background (lighting) and prevent chunk-border-artefacts
	
	Field with_graphics:Int
	
	Field dig:VOXEL_DIG
	
	Function Create:VOXEL_GRID(super_grid:VOXEL_SUPER_GRID, with_graphics:Int = True)
		Local g:VOXEL_GRID = New VOXEL_GRID
		
		g.super_grid = super_grid
		g.super_grid.grid = g
		
		'VOXEL_GRID.active = g ' set this to active for camera
		
		g.with_graphics = with_graphics
		
		If with_graphics Then
			Local rnd1:Byte[,] = RANDOM_GEN.get_noise_field(2^6)
			
			g.random_blocks_frames = RANDOM_GEN.Create([[1.0,1.0]], 2^6, rnd1)
			
			g.light_flood_buffer = TBuffer.Create((Graphics_Handler.x / g.block_size) + g.chunk_size_blocks*2)
			g.raycast_buffer = TBuffer.Create((Graphics_Handler.x / g.block_size) + 2)
			
			g.light_final_buffer = TBuffer.Create(Graphics_Handler.x)
		
			g.scene_render_buffer = TBuffer.Create(Graphics_Handler.x)
		EndIf
		
		g.chunk_map = CreateMap()
		g.block_lists[0] = New TList
		g.block_lists[1] = New TList
		g.liquids_list = New TList
		g.create_data_list = New TList
		g.dig = VOXEL_DIG.Create(4, g)
		
		Return g
	End Function
	
	
	
	Method chunk_at:VOXEL_CHUNK(x:Int, y:Int)
		' retrieves if exists
		' otherwise marks to be created, returns null
		' returns "empty chunk" if y negative
		
		'If y < 0 Then Return empty_chunk
		
		Local key:COORD_KEY = COORD_KEY.Create(x,y)
		Local c:VOXEL_CHUNK = VOXEL_CHUNK(chunk_map.ValueForKey(key))
		
		If Not c Then
			Local ch:VOXEL_CHUNK = VOXEL_CHUNK.Create(Self, x, y)
			chunk_map.Insert(COORD_KEY.Create(x, y), ch)
			
			Return ch
		EndIf
		
		Return c
	End Method
	
	Method chunk_at_update_blocks(x:Int, y:Int, layer:Int) ' if exists
		Local key:COORD_KEY = COORD_KEY.Create(x,y)
		Local c:VOXEL_CHUNK = VOXEL_CHUNK(chunk_map.ValueForKey(key))
		
		If c Then c.require_update_blocks(layer)
	End Method
	
	Method chunk_at_update_blocks_single(x:Int, y:Int, change_x:Int, change_y:Int, layer:Int) ' if exists
		Local key:COORD_KEY = COORD_KEY.Create(x,y)
		Local c:VOXEL_CHUNK = VOXEL_CHUNK(chunk_map.ValueForKey(key))
		
		If c Then c.require_update_blocks_single(change_x, change_y, layer)
	End Method

	
	Method chunk_at_update_lights(x:Int, y:Int) ' if exists
		Local key:COORD_KEY = COORD_KEY.Create(x,y)
		Local c:VOXEL_CHUNK = VOXEL_CHUNK(chunk_map.ValueForKey(key))
		
		If c Then c.require_update_lights()
	End Method

	
	Method chunk_exists:Int(x:Int, y:Int)
		
		Local key:COORD_KEY = COORD_KEY.Create(x,y)
		Local c:VOXEL_CHUNK = VOXEL_CHUNK(chunk_map.ValueForKey(key))
		
		If c Then Return True
		Return False
	End Method
	
	Method draw_blocks(layer:Int)
		' draw unstretched at coordinates x,y
		Local x1:Int = -view_x/chunk_size-1  -chunks_done_outside_screen_blocks
		Local y1:Int = -view_y/chunk_size-1  -chunks_done_outside_screen_blocks
		
		Local x2:Int = (Graphics_Handler.x-view_x)/chunk_size  +chunks_done_outside_screen_blocks
		Local y2:Int = (Graphics_Handler.y-view_y)/chunk_size  +chunks_done_outside_screen_blocks
		
		For Local xx:Int = x1 To x2
			For Local yy:Int = y1 To y2
				Local c:VOXEL_CHUNK = chunk_at(xx,yy)
				If c Then
					c.draw_buffer_blocks(view_x+xx*chunk_size, view_y+yy*chunk_size, layer)
				Else
					' Draw something else ???
				EndIf
				
			Next
		Next
	End Method
	
	
	Method draw_liquids()
		' draw unstretched at coordinates x,y
		Local x1:Int = -view_x/chunk_size-1  -chunks_done_outside_screen_liquids
		Local y1:Int = -view_y/chunk_size-1  -chunks_done_outside_screen_liquids
		
		Local x2:Int = (Graphics_Handler.x-view_x)/chunk_size  +chunks_done_outside_screen_liquids
		Local y2:Int = (Graphics_Handler.y-view_y)/chunk_size  +chunks_done_outside_screen_liquids
		
		SetColor 255,255,255
		
		For Local xx:Int = x1 To x2
			For Local yy:Int = y1 To y2
				Local c:VOXEL_CHUNK = chunk_at(xx,yy)
				If c Then
					c.draw_buffer_liquids(view_x+xx*chunk_size, view_y+yy*chunk_size)
				Else
					' Draw something else ???
				EndIf
			Next
		Next
	End Method
	
	
	Method render_lights()
		If Not draw_lights_enabled Then Return
		
		super_grid.time_lights_start() ' timer
		
		' draw unstretched at coordinates x,y
		Local x1:Int = -view_x/chunk_size-1  -chunks_done_outside_screen_lights
		Local y1:Int = -view_y/chunk_size-1  -chunks_done_outside_screen_lights
		
		Local x2:Int = (Graphics_Handler.x-view_x)/chunk_size  +chunks_done_outside_screen_lights
		Local y2:Int = (Graphics_Handler.y-view_y)/chunk_size  +chunks_done_outside_screen_lights
		
		For Local xx:Int = x1 To x2
			For Local yy:Int = y1 To y2
				Local c:VOXEL_CHUNK = chunk_at(xx,yy)
				If c Then
					
					c.render_lights()
				Else
					' Draw something else ???
				EndIf
				
			Next
		Next
		
		super_grid.time_lights_stop() ' timer
	End Method
	
	Method draw_lights(render_buffer:TBuffer)
		If Not draw_lights_enabled Then Return
		
		' draw unstretched at coordinates x,y
		Local x1:Int = -view_x/chunk_size-1  -chunks_done_outside_screen_lights
		Local y1:Int = -view_y/chunk_size-1  -chunks_done_outside_screen_lights
		
		Local x2:Int = (Graphics_Handler.x-view_x)/chunk_size  +chunks_done_outside_screen_lights
		Local y2:Int = (Graphics_Handler.y-view_y)/chunk_size  +chunks_done_outside_screen_lights
		
		light_flood_buffer.set_me()
		light_flood_buffer.buffer.Cls(0,0,0,1)
		
		For Local xx:Int = x1 To x2
			For Local yy:Int = y1 To y2
				Local c:VOXEL_CHUNK = chunk_at(xx,yy)
				If c Then
					c.draw_lights((xx-x1)*chunk_size_blocks, (yy-y1)*chunk_size_blocks)
				Else
					' Draw something else ???
				EndIf
			Next
		Next
		
		light_final_buffer.set_me()
		light_final_buffer.buffer.Cls(0,0,0,1)
		
		SetBlend lightblend
		SetColor 255,255,255
		light_flood_buffer.draw(view_x+x1*chunk_size,  view_y+y1*chunk_size,  block_size)
		raycast_buffer.draw(view_x+raycast_x_block*block_size-12,   view_y+raycast_y_block*block_size-12,   block_size) 
		
		render_buffer.set_me()
		
		SetBlend shadeblend
		
		SetColor 255,255,255
		light_final_buffer.draw(0,0)
		SetBlend alphablend
	End Method
	
	Method prepare_raycast()
		raycast_buffer.set_me()
		raycast_buffer.buffer.Cls(0,0,0,1)
		raycast_buffer.set_normal()
		
		raycast_x_block = (-view_x)/block_size
		raycast_y_block = (-view_y)/block_size
	End Method
	
	Method perform_raycast(x:Float,y:Float, r:Float, g:Float, b:Float, w:Float, rw:Float)
		' coords in pixels, colors 0-255
		Local start_x:Float = x/Float(block_size) ' position in blocks
		Local start_y:Float = y/Float(block_size)
		
		Const ray_n:Int = 70
		Const step_size:Float = 0.3
		
		Local ray_vx:Float[] = New Float[ray_n]
		Local ray_vy:Float[] = New Float[ray_n]
		
		For Local i:Int = 0 To ray_n-1
			ray_vx[i] = -Cos(w - rw  + 2*rw*Float(i)/Float(ray_n))*step_size
			ray_vy[i] = -Sin(w - rw + 2*rw*Float(i)/Float(ray_n))*step_size
		Next
		
		raycast_buffer.set_me() ' ----------------------------- start drawing
		SetBlend lightblend
		
		For Local i:Int = 0 To ray_vx.length-1
			Local ray_x:Float = 0
			Local ray_y:Float = 0
			
			Local rr:Float = r / 32
			Local gg:Float = g / 32
			Local bb:Float = b / 32
			
			For Local k:Int = 0 To 150
				ray_x:+ ray_vx[i]
				ray_y:+ ray_vy[i]
				
				'rr:*0.98
				'gg:*0.98
				'bb:*0.98
				
				Local blk:Int = super_grid.get_block_truncated(ray_x + start_x, ray_y + start_y,1)
				
				If VOXEL_BLOCK.collision[blk] Then
					rr:*0.8
					gg:*0.8
					bb:*0.8
				EndIf
				
				SetColor rr,gg,bb ' totally flawed ...
				DrawRect ray_x + start_x - raycast_x_block, ray_y + start_y - raycast_y_block, 1,1
				
				'SetColor rr*0.1,gg*0.1,bb*0.1 ' totally flawed ...
				'DrawRect ray_x + start_x - raycast_x_block-1, ray_y + start_y - raycast_y_block-1, 3,3
			Next
		Next
		
		
		SetBlend alphablend
		raycast_buffer.set_normal() ' ------------------------- end drawing
	End Method
	
	Global show_chunk_data:Int = False
	
	Method draw()
		
		' temporarily set view to integers:
		
		Local view_x_temp:Float = view_x ' super cheaty way to get rid of chunk-border-artefacts :)
		Local view_y_temp:Float = view_y
		
		view_x = Int view_x
		view_y = Int view_y
		
		scene_render_buffer.set_me()
		scene_render_buffer.buffer.Cls(0,0,0,0) ' set transpartent !
		
		'lighted background ?
		
		SetColor 0,0,0
		draw_blocks(0) ' 
		
		SetColor 255,255,255
		super_grid.draw_objects(Self)
		'player.draw(Self) ' objects
		
		draw_liquids() ' do together ?
		draw_blocks(1)
		
		dig.render_and_draw()
		
		draw_lights(scene_render_buffer) ' do as latest
		
		scene_render_buffer.set_normal()
		
		'SetBlend shadeblend
		SetColor 255,255,255
		scene_render_buffer.draw(view_x_temp - view_x, view_y_temp - view_y)
		'SetBlend alphablend
		
		view_x = view_x_temp
		view_y = view_y_temp
		
		If show_chunk_data Then
			super_grid.draw_status(150,150, 10* super_grid.super_chunk_size_chunks)
			draw_status(150,150,10)
		EndIf
	End Method
	
	Method set_light(x:Int,y:Int, r:Short, g:Short, b:Short)
		' x,y in blocks from absolute origin
		Local cx:Int = Floor(Float(x)/Float(chunk_size_blocks))
		Local cy:Int = Floor(Float(y)/Float(chunk_size_blocks))
		
		Local c:VOXEL_CHUNK = chunk_at(cx, cy) ' find chunk
		
		c.set_light(x-cx*chunk_size_blocks, y-cy*chunk_size_blocks, r,g,b)
	End Method
	
	Method set_light_pixel(x:Float, y:Float, r:Short, g:Short, b:Short)
		' x,y in pixel of screen
		Local xx:Int = Floor(Float(x)/Float(block_size))
		Local yy:Int = Floor(Float(y)/Float(block_size))
		set_light(xx,yy, r,g,b)
	End Method
	
	
	Method render_blocks()
		super_grid.time_blocks_start() ' timer
		
		'rendering chunks
		Local render_counter:Int = 0
		Local c:VOXEL_CHUNK
		Repeat
			c = VOXEL_CHUNK(block_lists[0].RemoveFirst())
			If c Then
				render_counter:+c.render_buffer_blocks(0)
			EndIf
		Until(Not c Or render_counter > 5)
		
		Repeat
			c = VOXEL_CHUNK(block_lists[1].RemoveFirst())
			If c Then
				render_counter:+c.render_buffer_blocks(1)
			EndIf
		Until(Not c Or render_counter > 5)
		
		super_grid.time_blocks_stop() ' timer
	End Method
	
	Method render_liquids(fill_liquid_list_myself:Int = True)
		super_grid.time_liquids_start() ' timer
		
		Local c:VOXEL_CHUNK
		Local render_counter_liquids:Int = 0
		Repeat
			c = VOXEL_CHUNK(liquids_list.RemoveFirst())
			If c Then
				render_counter_liquids:+c.render_buffer_liquids()
			EndIf
		Until(Not c Or render_counter_liquids > super_grid.universe.netw_man.render_liquid_per_frame)
		
		If fill_liquid_list_myself Then
			If render_counter_liquids=0 Then refill_liquid_render_list()
		EndIf
		
		super_grid.time_liquids_stop() ' timer
	End Method
	
	Field last_liquid_refill:Int
	Const liquid_render_delay:Int = 100 ' in millisecs, between render-calls
	
	Method refill_liquid_render_list() ' does not work for server !
		
		If last_liquid_refill + VOXEL_GRID.liquid_render_delay > MilliSecs() Then Return
		'Print("--- liquid refill...")
		last_liquid_refill = MilliSecs()
		
		Local x1:Int = -view_x/chunk_size-1 - 2 -chunks_done_outside_screen_liquids
		Local y1:Int = -view_y/chunk_size-1 - 2 -chunks_done_outside_screen_liquids
		
		Local x2:Int = (Graphics_Handler.x-view_x)/chunk_size + 2  +chunks_done_outside_screen_liquids
		Local y2:Int = (Graphics_Handler.y-view_y)/chunk_size + 2  +chunks_done_outside_screen_liquids
		
		For Local c:VOXEL_CHUNK = EachIn MapValues(chunk_map)
			If Not (c.x < x1 Or c.y < y1 Or c.x > x2 Or c.y > y2) Then
				c.require_update_liquids()
			EndIf
		Next
	End Method
	
	Method render_data()
		super_grid.time_data_start() ' timer
		
		chunks_cleanup()
		super_grid.super_chunk_cleanup()
		super_grid.super_chunk_update_network()
		
		'camera position
		view_x = (view_x_aim*0.1 + 0.9*view_x)
		view_y = (view_y_aim*0.1 + 0.9*view_y)
		
		super_grid.time_data_stop() ' timer
	End Method

	
	Method draw_status(x:Int,y:Int, scale:Int)
		SetColor 255,255,255
		DrawRect x-1,y-1,1,800
		DrawRect x-1,y-1,800,1
		
		For Local c:VOXEL_CHUNK = EachIn MapValues(chunk_map)
			If c.is_deleted Then
				SetColor 255,0,0 ' should not happen !
			ElseIf Not c.block_buffers[0] Or Not c.block_buffers[1] Then
				SetColor 50,50,50
			ElseIf Not c.liquids_buffer
				SetColor 200,0,200
			ElseIf c.need_update_lights
				SetColor 200,200,0
			Else
				SetColor 0,255,0
			EndIf
			
			DrawRect x+c.x*scale,y+c.y*scale, scale-1,scale-1
		Next
		
		SetColor 0,0,0
		DrawRect x + -view_x*scale/chunk_size,y + -view_y*scale/chunk_size, Graphics_Handler.x*scale/chunk_size, 1
		DrawRect x + -view_x*scale/chunk_size,y + -view_y*scale/chunk_size, 1, Graphics_Handler.y*scale/chunk_size
		
		DrawRect x + -view_x*scale/chunk_size,y + -view_y*scale/chunk_size + Graphics_Handler.y*scale/chunk_size, Graphics_Handler.x*scale/chunk_size, 1
		DrawRect x + -view_x*scale/chunk_size + Graphics_Handler.x*scale/chunk_size,y + -view_y*scale/chunk_size, 1, Graphics_Handler.y*scale/chunk_size
	End Method
	
	Field last_cleanup:Int = MilliSecs()
	
	Method chunks_cleanup()
		
		If last_cleanup + 2000 > MilliSecs() Then Return
		'Print("--- Cleanup...")
		last_cleanup = MilliSecs()
		
		
		Select super_grid.universe.netw_man.mode
			Case NETWORK_MANAGER.CLIENT
				
				Local x1:Int = -view_x/chunk_size-1 - 2 -chunks_done_outside_screen_blocks
				Local y1:Int = -view_y/chunk_size-1 - 2 -chunks_done_outside_screen_blocks
				
				Local x2:Int = (Graphics_Handler.x-view_x)/chunk_size + 2  +chunks_done_outside_screen_blocks
				Local y2:Int = (Graphics_Handler.y-view_y)/chunk_size + 2  +chunks_done_outside_screen_blocks
				
				Local keep_x1:Int = -view_x/chunk_size-1 - 2 -chunks_kept_outside_screen
				Local keep_y1:Int = -view_y/chunk_size-1 - 2 -chunks_kept_outside_screen
				
				Local keep_x2:Int = (Graphics_Handler.x-view_x)/chunk_size + 2  +chunks_kept_outside_screen
				Local keep_y2:Int = (Graphics_Handler.y-view_y)/chunk_size + 2  +chunks_kept_outside_screen
				
				Local xx1:Int = 10000
				Local xx2:Int = 0
				Local yy1:Int = 10000
				Local yy2:Int = 0
				
				For Local c:VOXEL_CHUNK = EachIn MapValues(chunk_map)
					If c.block_buffers[0] Then
						If c.x < x1 Or c.y < y1 Or c.x > x2 Or c.y > y2 Then
							c.remove_all_buffers()
						EndIf
						
						xx1 = Min(xx1,c.x)
						xx2 = Max(xx2,c.x)
						yy1 = Min(yy1,c.x)
						yy2 = Max(yy2,c.x)
					EndIf
					
					If c.x < keep_x1 Or c.y < keep_y1 Or c.x > keep_x2 Or c.y > keep_y2 Then
						c.eject_me()
					EndIf
				Next
				
			Case NETWORK_MANAGER.SERVER
				For Local c:VOXEL_CHUNK = EachIn MapValues(chunk_map)					
					If c.last_used + VOXEL_CHUNK.keep_chunk < MilliSecs() Then
						c.eject_me()
					EndIf
				Next
				
			Default
				RuntimeError("not implemented !")
		End Select
		
		'Print(xx1 + " " + xx2 + " " + yy1 + " " + yy2)
	End Method
	
	
	Method has_collision:Int(x:Int, y:Int)
		Local cx:Int = Floor(Float(x)/Float(chunk_size_blocks))
		Local cy:Int = Floor(Float(y)/Float(chunk_size_blocks))
		
		Local c:VOXEL_CHUNK = chunk_at(cx, cy)
		
		Return c.has_collision(x-cx*chunk_size_blocks, y-cy*chunk_size_blocks)
	End Method
	
	
	'------------------- ACTION FULL BLOCK
	
	Method action_set_full_block_pixel_screen(network_only_if_host:Int , x:Int, y:Int, block_0:Int, block_1:Int, liquid:Int, liquid_plus:Int, liquid_type:Int, radius:Int = 0)
		' x,y in pixel of screen
		Local xx:Int = Floor(Float(x-view_x)/Float(block_size))
		Local yy:Int = Floor(Float(y-view_y)/Float(block_size))
		
		For Local rx:Int = -radius To radius
			For Local ry:Int = -radius To radius
				action_set_full_block(network_only_if_host, xx + rx,yy + ry, block_0, block_1, liquid, liquid_plus, liquid_type)
			Next
		Next
	End Method
	
	Method action_set_full_block(network_only_if_host:Int , x:Int, y:Int, block_0:Int, block_1:Int, liquid:Int, liquid_plus:Int, liquid_type:Int)
		' x,y in blocks from absolute origin
		Local cx:Int = Floor(Float(x)/Float(chunk_size_blocks))
		Local cy:Int = Floor(Float(y)/Float(chunk_size_blocks))
		
		Local c:VOXEL_CHUNK = chunk_at(cx, cy) ' find chunk
		
		c.action_set_full_block(network_only_if_host, x-cx*chunk_size_blocks, y-cy*chunk_size_blocks, block_0, block_1, liquid, liquid_plus, liquid_type)
	End Method
	
	'------------------- ACTION BREACK BACK
	Rem
	Method conditional_break_block_back_pixel_screen(x:Int, y:Int, radius:Int = 0)
		' x,y in pixel of screen
		Local xx:Int = Floor(Float(x-view_x)/Float(block_size))
		Local yy:Int = Floor(Float(y-view_y)/Float(block_size))
		
		For Local rx:Int = -radius To radius
			For Local ry:Int = -radius To radius
				conditional_break_block_back(xx + rx,yy + ry)
			Next
		Next
	End Method
	End Rem
	
	Method conditional_break_block_back(x:Int, y:Int)
		' x,y in blocks from absolute origin
		Local cx:Int = Floor(Float(x)/Float(chunk_size_blocks))
		Local cy:Int = Floor(Float(y)/Float(chunk_size_blocks))
		
		Local c:VOXEL_CHUNK = chunk_at(cx, cy) ' find chunk
		
		c.conditional_break_block_back(x-cx*chunk_size_blocks, y-cy*chunk_size_blocks)
	End Method
	
	'------------------- ACTION BREACK FRONT
	Rem
	Method conditional_break_block_front_pixel_screen(x:Int, y:Int, radius:Int = 0)
		' x,y in pixel of screen
		Local xx:Int = Floor(Float(x-view_x)/Float(block_size))
		Local yy:Int = Floor(Float(y-view_y)/Float(block_size))
		
		For Local rx:Int = -radius To radius
			For Local ry:Int = -radius To radius
				conditional_break_block_front(xx + rx,yy + ry)
			Next
		Next
	End Method
	End Rem
	
	Method conditional_break_block_front(x:Int, y:Int)
		' x,y in blocks from absolute origin
		Local cx:Int = Floor(Float(x)/Float(chunk_size_blocks))
		Local cy:Int = Floor(Float(y)/Float(chunk_size_blocks))
		
		Local c:VOXEL_CHUNK = chunk_at(cx, cy) ' find chunk
		
		c.conditional_break_block_front(x-cx*chunk_size_blocks, y-cy*chunk_size_blocks)
	End Method
	
	'------------------- ACTION PUT FRONT
	Rem
	Method conditional_put_block_front_pixel_screen(x:Int, y:Int, block:Int, radius:Int = 0)
		' x,y in pixel of screen
		Local xx:Int = Floor(Float(x-view_x)/Float(block_size))
		Local yy:Int = Floor(Float(y-view_y)/Float(block_size))
		
		For Local rx:Int = -radius To radius
			For Local ry:Int = -radius To radius
				conditional_put_block_front(xx + rx,yy + ry, block)
			Next
		Next
	End Method
	End Rem
	
	Method conditional_put_block_front(x:Int, y:Int, block:Int, inventory_index:Int)
		' x,y in blocks from absolute origin
		Local cx:Int = Floor(Float(x)/Float(chunk_size_blocks))
		Local cy:Int = Floor(Float(y)/Float(chunk_size_blocks))
		
		Local c:VOXEL_CHUNK = chunk_at(cx, cy) ' find chunk
		
		c.conditional_put_block_front(x-cx*chunk_size_blocks, y-cy*chunk_size_blocks, block, inventory_index)
	End Method
	
	'------------------- ACTION PUT BACK
	Rem
	Method conditional_put_block_back_pixel_screen(x:Int, y:Int, block:Int, radius:Int = 0)
		' x,y in pixel of screen
		Local xx:Int = Floor(Float(x-view_x)/Float(block_size))
		Local yy:Int = Floor(Float(y-view_y)/Float(block_size))
		
		For Local rx:Int = -radius To radius
			For Local ry:Int = -radius To radius
				conditional_put_block_back(xx + rx,yy + ry, block)
			Next
		Next
	End Method
	End Rem
	
	Method conditional_put_block_back(x:Int, y:Int, block:Int, inventory_index:Int)
		' x,y in blocks from absolute origin
		Local cx:Int = Floor(Float(x)/Float(chunk_size_blocks))
		Local cy:Int = Floor(Float(y)/Float(chunk_size_blocks))
		
		Local c:VOXEL_CHUNK = chunk_at(cx, cy) ' find chunk
		
		c.conditional_put_block_back(x-cx*chunk_size_blocks, y-cy*chunk_size_blocks, block, inventory_index)
	End Method
	
	'------------------- ACTION PUT Liquid
	Rem
	Method conditional_put_liquid_pixel_screen(x:Int, y:Int, amount:Int, typ:Byte, radius:Int = 0)
		' x,y in pixel of screen
		Local xx:Int = Floor(Float(x-view_x)/Float(block_size))
		Local yy:Int = Floor(Float(y-view_y)/Float(block_size))
		
		For Local rx:Int = -radius To radius
			For Local ry:Int = -radius To radius
				conditional_put_liquid(xx + rx,yy + ry, amount, typ)
			Next
		Next
	End Method
	End Rem
	
	Method conditional_put_liquid(x:Int, y:Int, amount:Int, typ:Byte, inventory_index:Int)
		' x,y in blocks from absolute origin
		Local cx:Int = Floor(Float(x)/Float(chunk_size_blocks))
		Local cy:Int = Floor(Float(y)/Float(chunk_size_blocks))
		
		Local c:VOXEL_CHUNK = chunk_at(cx, cy) ' find chunk
		
		c.conditional_put_liquid(x-cx*chunk_size_blocks, y-cy*chunk_size_blocks, amount, typ, inventory_index)
	End Method

End Type

'----------------------------------------------------------------------------------------
'---------------------------                    -----------------------------------------
'---------------------------     Voxel Chunk    -----------------------------------------
'---------------------------                    -----------------------------------------
'----------------------------------------------------------------------------------------
Type VOXEL_CHUNK
	' Drawing chunk - multi layer ?
	Global number_of_buffers:Int = 0
	Global number_of_buffers_active:Int = 0
	Global buffer_recycle:TList = New TList
	
	Global number_of_light_buffers:Int = 0
	Global number_of_light_buffers_active:Int = 0
	Global light_buffer_recycle:TList = New TList
	
	Field grid:VOXEL_GRID ' backwards link
	
	Field x:Int ' on grid
	Field y:Int
	
	Field super_chunk:VOXEL_SUPER_CHUNK
	Field sc_off_x_blocks:Int ' offset in superchunk in blocks
	Field sc_off_y_blocks:Int ' offset in superchunk in blocks
	
	Field was_drawn_blocks_buffer:Int[] = [0,0]
	Field need_update_blocks_buffer:Int[] = [0,0]
	'Field last_update_block:Int = -1 ' ---------debug stats
	'Field last_update_block_attempt:Int = -1
	'Field last_update_block_require:Int = -1
	
	Field need_update_lights:Int = 0
	
	Field block_buffers:TBuffer[] = New TBuffer[2]
	Field light_buffer:TBuffer
	Field liquids_buffer:TBuffer
	
	Field need_update_liquids:Int = 0
	
	Field is_deleted:Int = 0 ' to detect if still hanging around !
	
	Field last_used:Int ' used for server's cleenup
	Const keep_chunk:Int = 2000
	
	'Field blocks:Short[,,] ' x,y, layer -> 0 back, 1 front
	Method get_blocks:Short(x:Int,y:Int,layer:Int)
		Return super_chunk.get_block(x + sc_off_x_blocks,y + sc_off_y_blocks, layer)
	End Method
	
	Method get_blocks_truncated:Short(x:Int,y:Int,layer:Int) ' if not inside chunk sees if available outside chunk
		If x < 0 Or y < 0 Or x >= grid.chunk_size_blocks Or y >= grid.chunk_size_blocks Then
			Local xx_a:Int = x + Self.x*grid.chunk_size_blocks ' absolute
			Local yy_a:Int = y + Self.y*grid.chunk_size_blocks
			
			Return grid.super_grid.get_block_truncated(xx_a, yy_a, layer)
		Else
			Return super_chunk.get_block(x + sc_off_x_blocks,y + sc_off_y_blocks, layer)
		EndIf
	End Method
		
	Method set_block(x:Int,y:Int, layer:Int, block:Int, req_update:Int = True)
			
			If super_chunk.get_block(x + sc_off_x_blocks,y + sc_off_y_blocks,layer) <> block Then
				super_chunk.set_block(x + sc_off_x_blocks,y + sc_off_y_blocks,layer, block)
				
				If VOXEL_BLOCK.collision[block] Then
					super_chunk.set_liquid_plus(x + sc_off_x_blocks,y + sc_off_y_blocks, 0) ' kill all liquids
					super_chunk.set_liquid(x + sc_off_x_blocks,y + sc_off_y_blocks, 0)
					super_chunk.set_liquid_type(x + sc_off_x_blocks,y + sc_off_y_blocks, 0)
				EndIf
				
				If req_update Then
					'If neighbours Then
						
						If x = 0 Then
							grid.chunk_at_update_blocks_single(Self.x-1, Self.y, grid.chunk_size_blocks, y, layer)
							'neighbours[0,1].require_update_blocks()
							
							If y = 0 Then
								grid.chunk_at_update_blocks_single(Self.x-1, Self.y-1, grid.chunk_size_blocks, grid.chunk_size_blocks, layer)
								'neighbours[0,0].require_update_blocks()
								grid.chunk_at_update_blocks_single(Self.x, Self.y-1, x, grid.chunk_size_blocks, layer)
								'neighbours[1,0].require_update_blocks()
							ElseIf y = grid.chunk_size_blocks-1 Then
								grid.chunk_at_update_blocks_single(Self.x, Self.y+1, x, -1, layer)
								'neighbours[1,2].require_update_blocks()
								grid.chunk_at_update_blocks_single(Self.x-1, Self.y+1, grid.chunk_size_blocks, -1, layer)
								'neighbours[0,2].require_update_blocks()
							EndIf
						ElseIf x = grid.chunk_size_blocks-1 Then
							grid.chunk_at_update_blocks_single(Self.x+1, Self.y, -1, y, layer)
							'neighbours[2,1].require_update_blocks()
							
							If y = 0 Then
								grid.chunk_at_update_blocks_single(Self.x, Self.y-1, x, grid.chunk_size_blocks, layer)
								'neighbours[1,0].require_update_blocks()
								grid.chunk_at_update_blocks_single(Self.x+1, Self.y-1, -1, grid.chunk_size_blocks, layer)
								'neighbours[2,0].require_update_blocks()
							ElseIf y = grid.chunk_size_blocks-1 Then
								grid.chunk_at_update_blocks_single(Self.x, Self.y+1, x, -1, layer)
								'neighbours[1,2].require_update_blocks()
								grid.chunk_at_update_blocks_single(Self.x+1, Self.y+1, -1, -1, layer)
								'neighbours[2,2].require_update_blocks()
							EndIf
						ElseIf y = 0 Then
							grid.chunk_at_update_blocks_single(Self.x, Self.y-1, x, grid.chunk_size_blocks, layer)
							'neighbours[1,0].require_update_blocks()
						ElseIf y = grid.chunk_size_blocks-1 Then
							grid.chunk_at_update_blocks_single(Self.x, Self.y+1, x, -1, layer)
							'neighbours[1,2].require_update_blocks()
						EndIf
					'EndIf
				
					require_update_blocks_single(x,y, layer)
				EndIf
			EndIf
	End Method
	
	' this is only networked, but NOT conditional !
	Method action_set_block(network_only_if_host:Int, x:Int,y:Int, layer:Int, block:Int, req_update:Int = True)
			
			If super_chunk.get_block(x + sc_off_x_blocks,y + sc_off_y_blocks,layer) <> block Then
				
				Local block_0:Int = -1
				Local block_1:Int = -1
				
				Select layer
					Case 0
						block_0 = block
					Case 1
						block_1 = block
					Default
						RuntimeError("not implemented")
				End Select
				
				super_chunk.action_set_full_block(network_only_if_host, x + sc_off_x_blocks,y + sc_off_y_blocks, block_0, block_1, 0,0,0)
				
				Rem
				super_chunk.set_block(x + sc_off_x_blocks,y + sc_off_y_blocks,layer, block)
				
				If VOXEL_BLOCK.collision[block] Then
					super_chunk.set_liquid_plus(x + sc_off_x_blocks,y + sc_off_y_blocks, 0) ' kill all liquids
					super_chunk.set_liquid(x + sc_off_x_blocks,y + sc_off_y_blocks, 0)
					super_chunk.set_liquid_type(x + sc_off_x_blocks,y + sc_off_y_blocks, 0)
				EndIf
				End Rem
				
				If req_update Then
					'If neighbours Then
						
						If x = 0 Then
							grid.chunk_at_update_blocks_single(Self.x-1, Self.y, grid.chunk_size_blocks, y, layer)
							'neighbours[0,1].require_update_blocks()
							
							If y = 0 Then
								grid.chunk_at_update_blocks_single(Self.x-1, Self.y-1, grid.chunk_size_blocks, grid.chunk_size_blocks, layer)
								'neighbours[0,0].require_update_blocks()
								grid.chunk_at_update_blocks_single(Self.x, Self.y-1, x, grid.chunk_size_blocks, layer)
								'neighbours[1,0].require_update_blocks()
							ElseIf y = grid.chunk_size_blocks-1 Then
								grid.chunk_at_update_blocks_single(Self.x, Self.y+1, x, -1, layer)
								'neighbours[1,2].require_update_blocks()
								grid.chunk_at_update_blocks_single(Self.x-1, Self.y+1, grid.chunk_size_blocks, -1, layer)
								'neighbours[0,2].require_update_blocks()
							EndIf
						ElseIf x = grid.chunk_size_blocks-1 Then
							grid.chunk_at_update_blocks_single(Self.x+1, Self.y, -1, y, layer)
							'neighbours[2,1].require_update_blocks()
							
							If y = 0 Then
								grid.chunk_at_update_blocks_single(Self.x, Self.y-1, x, grid.chunk_size_blocks, layer)
								'neighbours[1,0].require_update_blocks()
								grid.chunk_at_update_blocks_single(Self.x+1, Self.y-1, -1, grid.chunk_size_blocks, layer)
								'neighbours[2,0].require_update_blocks()
							ElseIf y = grid.chunk_size_blocks-1 Then
								grid.chunk_at_update_blocks_single(Self.x, Self.y+1, x, -1, layer)
								'neighbours[1,2].require_update_blocks()
								grid.chunk_at_update_blocks_single(Self.x+1, Self.y+1, -1, -1, layer)
								'neighbours[2,2].require_update_blocks()
							EndIf
						ElseIf y = 0 Then
							grid.chunk_at_update_blocks_single(Self.x, Self.y-1, x, grid.chunk_size_blocks, layer)
							'neighbours[1,0].require_update_blocks()
						ElseIf y = grid.chunk_size_blocks-1 Then
							grid.chunk_at_update_blocks_single(Self.x, Self.y+1, x, -1, layer)
							'neighbours[1,2].require_update_blocks()
						EndIf
					'EndIf
				
					require_update_blocks_single(x,y, layer)
				EndIf
			EndIf
	End Method
	
	Method require_update_blocks_single_neighbours(x:Int,y:Int, layer:Int)
		If x = 0 Then
			grid.chunk_at_update_blocks_single(Self.x-1, Self.y, grid.chunk_size_blocks, y, layer)
			If y = 0 Then
				grid.chunk_at_update_blocks_single(Self.x-1, Self.y-1, grid.chunk_size_blocks, grid.chunk_size_blocks, layer)
				grid.chunk_at_update_blocks_single(Self.x, Self.y-1, x, grid.chunk_size_blocks, layer)
			ElseIf y = grid.chunk_size_blocks-1 Then
				grid.chunk_at_update_blocks_single(Self.x, Self.y+1, x, -1, layer)
				grid.chunk_at_update_blocks_single(Self.x-1, Self.y+1, grid.chunk_size_blocks, -1, layer)
			EndIf
		ElseIf x = grid.chunk_size_blocks-1 Then
			grid.chunk_at_update_blocks_single(Self.x+1, Self.y, -1, y, layer)
			
			If y = 0 Then
				grid.chunk_at_update_blocks_single(Self.x, Self.y-1, x, grid.chunk_size_blocks, layer)
				grid.chunk_at_update_blocks_single(Self.x+1, Self.y-1, -1, grid.chunk_size_blocks, layer)
			ElseIf y = grid.chunk_size_blocks-1 Then
				grid.chunk_at_update_blocks_single(Self.x, Self.y+1, x, -1, layer)
				grid.chunk_at_update_blocks_single(Self.x+1, Self.y+1, -1, -1, layer)
			EndIf
		ElseIf y = 0 Then
			grid.chunk_at_update_blocks_single(Self.x, Self.y-1, x, grid.chunk_size_blocks, layer)
		ElseIf y = grid.chunk_size_blocks-1 Then
			grid.chunk_at_update_blocks_single(Self.x, Self.y+1, x, -1, layer)
		EndIf
		require_update_blocks_single(x,y, layer)
	End Method
	
	Method action_set_full_block(network_only_if_host:Int , x:Int, y:Int, block_0:Int, block_1:Int, liquid:Int, liquid_plus:Int, liquid_type:Int)
			
			Local please_send:Int = False
			
			' blocks_0
			If block_0 >= 0 Then
				If super_chunk.get_block(x + sc_off_x_blocks,y + sc_off_y_blocks,0) <> block_0 Then				
					require_update_blocks_single_neighbours(x,y, 0)
					
					please_send = True
				EndIf
			EndIf
			
			' blocks_1
			If block_1 >= 0 Then
				If super_chunk.get_block(x + sc_off_x_blocks,y + sc_off_y_blocks,1) <> block_1 Then				
					require_update_blocks_single_neighbours(x,y, 1)
					
					please_send = True
				EndIf
			EndIf
			
			
			If super_chunk.get_liquid(x + sc_off_x_blocks,y + sc_off_y_blocks) <> liquid And liquid >=0 Then
				please_send = True
			ElseIf super_chunk.get_liquid_plus(x + sc_off_x_blocks,y + sc_off_y_blocks) <> liquid_plus And liquid_plus>=0 Then
				please_send = True
			ElseIf super_chunk.get_liquid_type(x + sc_off_x_blocks,y + sc_off_y_blocks) <> liquid_type And liquid_type>=0 Then
				please_send = True
			EndIf
			
			If liquid > 0 Or liquid_plus > 0 Or liquid_type > 0 Then
				please_send = True
			EndIf
			
			If please_send = True Then
				super_chunk.action_set_full_block(network_only_if_host, x + sc_off_x_blocks,y + sc_off_y_blocks, block_0, block_1, liquid, liquid_plus, liquid_type)
			EndIf
	End Method
	
	Method conditional_break_block_back(x:Int, y:Int)
			Local please_send:Int = False
			
			If super_chunk.get_block(x + sc_off_x_blocks,y + sc_off_y_blocks,0) <> 0 Then				
				require_update_blocks_single_neighbours(x,y, 0)
				please_send = True
			EndIf			
						
			If please_send = True Then
				super_chunk.conditional_break_block_back(x + sc_off_x_blocks,y + sc_off_y_blocks)
			EndIf
	End Method
	Method conditional_break_block_front(x:Int, y:Int)
			Local please_send:Int = False
			
			If super_chunk.get_block(x + sc_off_x_blocks,y + sc_off_y_blocks,1) <> 0 Then				
				require_update_blocks_single_neighbours(x,y, 1)
				please_send = True
			EndIf			
						
			If please_send = True Then
				super_chunk.conditional_break_block_front(x + sc_off_x_blocks,y + sc_off_y_blocks)
			EndIf
	End Method
	
	Method conditional_put_block_back(x:Int, y:Int, block:Int, inventory_index:Int)
			Local please_send:Int = False
			
			If super_chunk.get_block(x + sc_off_x_blocks,y + sc_off_y_blocks,0) <> block Then				
				require_update_blocks_single_neighbours(x,y, 0)
				please_send = True
			EndIf			
						
			If please_send = True Then
				super_chunk.conditional_put_block_back(x + sc_off_x_blocks,y + sc_off_y_blocks, block, inventory_index)
			EndIf
	End Method
	Method conditional_put_block_front(x:Int, y:Int, block:Int, inventory_index:Int)
			Local please_send:Int = False
			
			If super_chunk.get_block(x + sc_off_x_blocks,y + sc_off_y_blocks,1) <> block Then				
				require_update_blocks_single_neighbours(x,y, 1)
				please_send = True
			EndIf			
						
			If please_send = True Then
				super_chunk.conditional_put_block_front(x + sc_off_x_blocks,y + sc_off_y_blocks, block, inventory_index)
			EndIf
	End Method
	
	Method conditional_put_liquid(x:Int, y:Int, amount:Int, typ:Byte, inventory_index:Int)
			Local please_send:Int = False
			
			If super_chunk.get_block(x + sc_off_x_blocks,y + sc_off_y_blocks,1) = 0 Then				
				please_send = True
			EndIf			
						
			If please_send = True Then
				super_chunk.conditional_put_liquid(x + sc_off_x_blocks,y + sc_off_y_blocks, amount, typ, inventory_index)
			EndIf
	End Method
	
	
	Method get_light:Short[](x:Int,y:Int)
		Return [super_chunk.light[x + sc_off_x_blocks,y + sc_off_y_blocks,0],..
				super_chunk.light[x + sc_off_x_blocks,y + sc_off_y_blocks,1],..
				super_chunk.light[x + sc_off_x_blocks,y + sc_off_y_blocks,2]]
	End Method
	
	Method set_light(x:Int,y:Int, r:Short, g:Short, b:Short)
		Local rr:Short = super_chunk.light[x + sc_off_x_blocks,y + sc_off_y_blocks,0]
		Local gg:Short = super_chunk.light[x + sc_off_x_blocks,y + sc_off_y_blocks,1]
		Local bb:Short = super_chunk.light[x + sc_off_x_blocks,y + sc_off_y_blocks,2]
		
		If (r > rr Or g > gg Or b > bb) Then
			require_update_lights()
			
			super_chunk.light[x + sc_off_x_blocks,y + sc_off_y_blocks,0] = Max(rr, r)
			super_chunk.light[x + sc_off_x_blocks,y + sc_off_y_blocks,1] = Max(gg, g)
			super_chunk.light[x + sc_off_x_blocks,y + sc_off_y_blocks,2] = Max(bb, b)
		EndIf
	End Method
	
	Method set_light_hard(x:Int,y:Int, r:Short, g:Short, b:Short) ' no update, no max
		super_chunk.light[x + sc_off_x_blocks,y + sc_off_y_blocks,0] = r
		super_chunk.light[x + sc_off_x_blocks,y + sc_off_y_blocks,1] = g
		super_chunk.light[x + sc_off_x_blocks,y + sc_off_y_blocks,2] = b
	End Method
	
	Method get_liquid:Int(x:Int,y:Int)
		Return super_chunk.get_liquid(x + sc_off_x_blocks,y + sc_off_y_blocks)
	End Method
	
	Method sub_liquid:Int(x:Int,y:Int, amount:Int) ' subtracts
		super_chunk.sub_liquid(x + sc_off_x_blocks,y + sc_off_y_blocks, amount)
	End Method
	
	Method set_liquid:Int(x:Int,y:Int, amount:Int)
		super_chunk.set_liquid(x + sc_off_x_blocks,y + sc_off_y_blocks, amount)
	End Method

	
	Method get_liquid_plus:Int(x:Int,y:Int)
		Return super_chunk.get_liquid_plus(x + sc_off_x_blocks,y + sc_off_y_blocks)
	End Method
	
	Method get_liquid_type:Int(x:Int,y:Int)
		Return super_chunk.get_liquid_type(x + sc_off_x_blocks,y + sc_off_y_blocks)
	End Method
	
	Method set_liquid_type(x:Int,y:Int, typ:Byte)
		super_chunk.set_liquid_type(x + sc_off_x_blocks,y + sc_off_y_blocks,   typ)
	End Method
	
	Method do_plus_liquid(x_:Int,y_:Int)
		'liquid[xx,yy]:+liquid_plus[xx,yy]
		'liquid_plus[xx,yy] = 0
		
		Local x:Int = x_ + sc_off_x_blocks
		Local y:Int = y_ + sc_off_y_blocks
		
		Local offset:Int = (x + super_chunk.super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_size_t
		Local offset_type:Int = (x + super_chunk.super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_type_size_t
		
		Local typ:Byte = super_chunk.liquid_type.PeekByte(offset_type)
		
		Local old_lqd:Int = super_chunk.liquid.PeekInt(offset)
		Local plus_lqd:Int = super_chunk.liquid_plus.PeekInt(offset)
		
		If typ = 2 Then ' lava
			If old_lqd = 0 And plus_lqd > 0 Then
				require_update_lights()
			EndIf
		EndIf
		
		super_chunk.liquid.PokeInt(offset, old_lqd + plus_lqd)
		super_chunk.liquid_plus.PokeInt(offset, 0)
	End Method
	
	Method set_liquid_useful(x_:Int,y_:Int, amount:Int, typ:Byte)
		
		Local x:Int = x_ + sc_off_x_blocks
		Local y:Int = y_ + sc_off_y_blocks
		
		Local offset:Int = (x + super_chunk.super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_size_t
		Local offset_type:Int = (x + super_chunk.super_grid.super_chunk_size_blocks*y)*VOXEL_SUPER_CHUNK.liquid_type_size_t
		
		super_chunk.liquid.PokeInt(offset, amount)
		super_chunk.liquid_plus.PokeInt(offset, 0)
		super_chunk.liquid_type.PokeByte(offset_type, typ)
	End Method
	
	Function Create:VOXEL_CHUNK(grid:VOXEL_GRID, x:Int, y:Int)
		Local c:VOXEL_CHUNK = New VOXEL_CHUNK
		
		c.grid = grid
		c.x = x
		c.y = y
		
		Local sc_x:Int = Floor(Float(x)/grid.super_grid.super_chunk_size_chunks)
		Local sc_y:Int = Floor(Float(y)/grid.super_grid.super_chunk_size_chunks)
		c.super_chunk = grid.super_grid.get_super_chunk(sc_x,sc_y)
		c.super_chunk.chunk_logon()
		
		Local scsb:Int = grid.super_grid.super_chunk_size_blocks ' just a shorthand
		c.sc_off_x_blocks = (((c.x*grid.chunk_size_blocks) Mod scsb) + scsb) Mod scsb
		c.sc_off_y_blocks = (((c.y*grid.chunk_size_blocks) Mod scsb) + scsb) Mod scsb
		
		grid.block_lists[0].AddLast(c)
		grid.block_lists[1].AddLast(c)
		
		c.need_update_lights = 1
		
		Return c
	End Function
	
	
	Method check_on_chunk_neighbours_data:Int() ' does not ensure existence of neighbour chunks, but of data thereof
		
		
		Local scsc:Int = grid.super_grid.super_chunk_size_chunks ' just a shorthand
		Local sc_off_inc_x:Int = ((Self.x Mod scsc) + scsc) Mod scsc' offset within super_chunks, in chunks
		Local sc_off_inc_y:Int = ((Self.y Mod scsc) + scsc) Mod scsc
		
		Local sc_x:Int = Floor(Float(Self.x)/scsc)
		Local sc_y:Int = Floor(Float(Self.y)/scsc)
		
		If sc_off_inc_x = 0 Then
			'Print("x=0")
			
			If Not grid.super_grid.ensure_super_chunk_data_loaded(sc_x-1, sc_y) Then Return False
			If sc_off_inc_y = 0 Then
				If Not grid.super_grid.ensure_super_chunk_data_loaded(sc_x-1, sc_y-1) Then Return False
				If Not grid.super_grid.ensure_super_chunk_data_loaded(sc_x, sc_y-1) Then Return False
			ElseIf sc_off_inc_y = grid.super_grid.super_chunk_size_chunks-1 Then
				If Not grid.super_grid.ensure_super_chunk_data_loaded(sc_x-1, sc_y+1) Then Return False
				If Not grid.super_grid.ensure_super_chunk_data_loaded(sc_x, sc_y+1) Then Return False
			EndIf
		ElseIf sc_off_inc_x = grid.super_grid.super_chunk_size_chunks-1 Then
			'Print("x=top")
			
			If Not grid.super_grid.ensure_super_chunk_data_loaded(sc_x+1, sc_y) Then Return False
			'Print("x.")
			If sc_off_inc_y = 0 Then
				'Print("y=0")
				If Not grid.super_grid.ensure_super_chunk_data_loaded(sc_x+1, sc_y-1) Then Return False
				If Not grid.super_grid.ensure_super_chunk_data_loaded(sc_x, sc_y-1) Then Return False
			ElseIf sc_off_inc_y = grid.super_grid.super_chunk_size_chunks-1 Then
				'Print("y=full")
				If Not grid.super_grid.ensure_super_chunk_data_loaded(sc_x+1, sc_y+1) Then Return False
				If Not grid.super_grid.ensure_super_chunk_data_loaded(sc_x, sc_y+1) Then Return False
			EndIf
		ElseIf sc_off_inc_y = 0 Then
			If Not grid.super_grid.ensure_super_chunk_data_loaded(sc_x, sc_y-1) Then Return False
		ElseIf sc_off_inc_y = grid.super_grid.super_chunk_size_chunks-1 Then
			If Not grid.super_grid.ensure_super_chunk_data_loaded(sc_x, sc_y+1) Then Return False
		EndIf
		
		Return True
	End Method
	
	Method draw_blocks:Int(x:Int,y:Int, layer:Int) ' actually builds the picture up -> draw it on buffer
		
		If Not check_on_chunk_neighbours_data() Return False
		
		' draw unstretched at coordinates x,y
		
		Select layer
			Case 0
				Local blk_neighbours:Int[,] = grid.super_grid.get_chunk_with_border_blocks(Self.x, Self.y, 0)
				For Local xx:Int = 0 To grid.chunk_size_blocks-1
					For Local yy:Int = 0 To grid.chunk_size_blocks-1
						VOXEL_BLOCK.draw(grid, Self, blk_neighbours, xx,yy , x+xx*grid.block_size, y+yy*grid.block_size,  xx+Self.x*grid.chunk_size_blocks, yy+Self.y*grid.chunk_size_blocks)
					Next
				Next
				SetBlend shadeblend
				Local blk_neighbours_shadow:Int[,] = grid.super_grid.get_chunk_with_border_blocks(Self.x, Self.y, 1)
				For Local xx:Int = 0 To grid.chunk_size_blocks-1
					For Local yy:Int = 0 To grid.chunk_size_blocks-1
						VOXEL_BLOCK.draw_shadow(grid, x+xx*grid.block_size, y+yy*grid.block_size,  blk_neighbours_shadow, xx,yy,  xx+Self.x*grid.chunk_size_blocks, yy+Self.y*grid.chunk_size_blocks)
					Next
				Next
				SetBlend alphablend
			Case 1
				Local blk_neighbours:Int[,] = grid.super_grid.get_chunk_with_border_blocks(Self.x, Self.y, layer)
				
				For Local xx:Int = 0 To grid.chunk_size_blocks-1
					For Local yy:Int = 0 To grid.chunk_size_blocks-1
						VOXEL_BLOCK.draw(grid, Self, blk_neighbours, xx,yy , x+xx*grid.block_size, y+yy*grid.block_size,  xx+Self.x*grid.chunk_size_blocks, yy+Self.y*grid.chunk_size_blocks)
					Next
				Next
		End Select
		
		
		Return True
		
		'draw_shadow
	End Method
	
	Rem
	Method draw_blocks:Int(x:Int,y:Int, layer:Int) ' actually builds the picture up -> draw it on buffer
		
		If Not check_on_chunk_neighbours_data() Return False
			
		' draw unstretched at coordinates x,y
		Local blk_neighbours:Int[,] = grid.super_grid.get_chunk_with_border_blocks(Self.x, Self.y, layer)
		
		For Local xx:Int = 0 To grid.chunk_size_blocks-1
			For Local yy:Int = 0 To grid.chunk_size_blocks-1
				VOXEL_BLOCK.draw(grid, Self, blk_neighbours, xx,yy , x+xx*grid.block_size, y+yy*grid.block_size,  xx+Self.x*grid.chunk_size_blocks, yy+Self.y*grid.chunk_size_blocks)
			Next
		Next
		Return True
		
		'draw_shadow
	End Method
	End Rem
	
	Method draw_blocks_changed:Int(x:Int,y:Int, change_x:Int, change_y:Int, buffer:TBuffer, layer:Int) ' patch
		
		If Not check_on_chunk_neighbours_data() Return False
		
		Local x1:Int = Max(0, change_x-1)
		Local x2:Int = Min(grid.chunk_size_blocks-1, change_x+1)
		
		Local y1:Int = Max(0, change_y-1)
		Local y2:Int = Min(grid.chunk_size_blocks-1, change_y+1)
		
		' draw unstretched at coordinates x,y
		
		Select layer
			Case 0
				Local blk_neighbours:Int[,] = grid.super_grid.get_chunk_with_border_blocks(Self.x, Self.y, layer)
				
				For Local xx:Int = x1 To x2
					For Local yy:Int = y1 To y2
						Local xxx:Int = x+xx*grid.block_size
						Local yyy:Int = y+yy*grid.block_size
						buffer.buffer.cls_part(xxx, yyy, grid.block_size, grid.block_size, 0,0,0,0)
						
						VOXEL_BLOCK.draw(grid, Self, blk_neighbours, xx,yy , x+xx*grid.block_size, y+yy*grid.block_size,  xx+Self.x*grid.chunk_size_blocks, yy+Self.y*grid.chunk_size_blocks)
					Next
				Next
				
				SetBlend shadeblend
				Local blk_neighbours_shadow:Int[,] = grid.super_grid.get_chunk_with_border_blocks(Self.x, Self.y, 1)
				For Local xx:Int = x1 To x2
					For Local yy:Int = y1 To y2						
						VOXEL_BLOCK.draw_shadow(grid, x+xx*grid.block_size, y+yy*grid.block_size,  blk_neighbours_shadow, xx,yy,  xx+Self.x*grid.chunk_size_blocks, yy+Self.y*grid.chunk_size_blocks)
					Next
				Next
				SetBlend alphablend
				
			Case 1
				Local blk_neighbours:Int[,] = grid.super_grid.get_chunk_with_border_blocks(Self.x, Self.y, layer)
				
				For Local xx:Int = x1 To x2
					For Local yy:Int = y1 To y2
						Local xxx:Int = x+xx*grid.block_size
						Local yyy:Int = y+yy*grid.block_size
						buffer.buffer.cls_part(xxx, yyy, grid.block_size, grid.block_size, 0,0,0,0)
						
						VOXEL_BLOCK.draw(grid, Self, blk_neighbours, xx,yy , x+xx*grid.block_size, y+yy*grid.block_size,  xx+Self.x*grid.chunk_size_blocks, yy+Self.y*grid.chunk_size_blocks)
					Next
				Next
		End Select
		
		Return True
	End Method
	
	Rem
	Method draw_blocks_changed:Int(x:Int,y:Int, change_x:Int, change_y:Int, buffer:TBuffer, layer:Int) ' patch
		
		If Not check_on_chunk_neighbours_data() Return False
		
		Local x1:Int = Max(0, change_x-1)
		Local x2:Int = Min(grid.chunk_size_blocks-1, change_x+1)
		
		Local y1:Int = Max(0, change_y-1)
		Local y2:Int = Min(grid.chunk_size_blocks-1, change_y+1)
		
		' draw unstretched at coordinates x,y
		Local blk_neighbours:Int[,] = grid.super_grid.get_chunk_with_border_blocks(Self.x, Self.y, layer)
		
		For Local xx:Int = x1 To x2
			For Local yy:Int = y1 To y2
				Local xxx:Int = x+xx*grid.block_size
				Local yyy:Int = y+yy*grid.block_size
				buffer.buffer.cls_part(xxx, yyy, grid.block_size, grid.block_size, 0,0,0,0)
				'glRecti(xxx, yyy, xxx+grid.block_size, yyy+grid.block_size)
				VOXEL_BLOCK.draw(grid, Self, blk_neighbours, xx,yy , x+xx*grid.block_size, y+yy*grid.block_size,  xx+Self.x*grid.chunk_size_blocks, yy+Self.y*grid.chunk_size_blocks)
			Next
		Next
		Return True
	End Method
	End Rem
	
	Method has_collision:Int(x:Int, y:Int)
		Return VOXEL_BLOCK.collision[get_blocks(x,y,1)]
	End Method
	
	Method require_update_blocks(layer:Int) ' 0, 1, -> -1 both
		'last_update_block_require = MilliSecs()/1000
		If is_deleted Then Return
		
		need_update_lights = 1
		
		Select layer
			Case 0
				If need_update_blocks_buffer[0] = 0 Then grid.block_lists[0].AddLast(Self)
				need_update_blocks_buffer[0] = 1
				update_block_numbers[0] = 2 ' more than one !
			Case 1
				If need_update_blocks_buffer[1] = 0 Then grid.block_lists[1].AddLast(Self)
				need_update_blocks_buffer[1] = 1
				update_block_numbers[1] = 2 ' more than one !
			Case -1
				If need_update_blocks_buffer[0] = 0 Then grid.block_lists[0].AddLast(Self)
				need_update_blocks_buffer[0] = 1
				update_block_numbers[0] = 2 ' more than one !
				
				If need_update_blocks_buffer[1] = 0 Then grid.block_lists[1].AddLast(Self)
				need_update_blocks_buffer[1] = 1
				update_block_numbers[1] = 2 ' more than one !
		End Select
		
		
	EndMethod
	
	Field update_block_numbers:Int[] = [0,0]
	Field update_block_xs:Int[] = [0,0]
	Field update_block_ys:Int[] = [0,0]
	
	Method require_update_blocks_single(x:Int, y:Int, layer:Int) ' block to update, layer: 0, 1, -> -1 both
		If is_deleted Then Return
		
		need_update_lights = 1
		
		Select layer
			Case 0
				If need_update_blocks_buffer[0] = 0 Then grid.block_lists[0].AddLast(Self)
				need_update_blocks_buffer[0] = 1
				update_block_numbers[0]:+ 1
				update_block_xs[0] = x
				update_block_ys[0] = y
			Case 1
				' because of the shadow...
				If need_update_blocks_buffer[0] = 0 Then grid.block_lists[0].AddLast(Self)
				need_update_blocks_buffer[0] = 1
				update_block_numbers[0]:+ 1
				update_block_xs[0] = x
				update_block_ys[0] = y
				
				If need_update_blocks_buffer[1] = 0 Then grid.block_lists[1].AddLast(Self)
				need_update_blocks_buffer[1] = 1
				update_block_numbers[1]:+ 1
				update_block_xs[1] = x
				update_block_ys[1] = y
			Case -1
				If need_update_blocks_buffer[0] = 0 Then grid.block_lists[0].AddLast(Self)
				need_update_blocks_buffer[0] = 1
				update_block_numbers[0]:+ 1
				update_block_xs[0] = x
				update_block_ys[0] = y
				
				If need_update_blocks_buffer[1] = 0 Then grid.block_lists[1].AddLast(Self)
				need_update_blocks_buffer[1] = 1
				update_block_numbers[1]:+ 1
				update_block_xs[1] = x
				update_block_ys[1] = y
		End Select
	End Method
	
	Method require_update_liquids()
		'last_update_block_require = MilliSecs()/1000
		If is_deleted Then Return
		
		last_used = MilliSecs()
		
		If need_update_liquids = 0 Then grid.liquids_list.AddLast(Self)
		need_update_liquids = 1
	EndMethod
		
	Method require_update_lights()
		need_update_lights = 1
	End Method
	
	Method remove_all_buffers()
		
		was_drawn_blocks_buffer[0] = 0
		was_drawn_blocks_buffer[1] = 0
		need_update_blocks_buffer[0] = 0
		need_update_blocks_buffer[1] = 0
		
		If block_buffers[0] Then
			VOXEL_CHUNK.buffer_recycle.addlast( block_buffers[0] )
			block_buffers[0] = Null
			number_of_buffers_active:-1
		EndIf
		
		If block_buffers[1] Then
			VOXEL_CHUNK.buffer_recycle.addlast( block_buffers[1] )
			block_buffers[1] = Null
			number_of_buffers_active:-1
		EndIf
		
		' light buffer
		If light_buffer Then
			need_update_lights = 1
			VOXEL_CHUNK.light_buffer_recycle.addlast( light_buffer )
			light_buffer = Null
			number_of_light_buffers_active:-1
		EndIf
		
		If liquids_buffer Then
			VOXEL_CHUNK.buffer_recycle.addlast( liquids_buffer )
			liquids_buffer = Null
			number_of_buffers_active:-1
		EndIf
		
	End Method
	
	Method eject_me() ' delete me !
		remove_all_buffers() ' just to make sure the buffers are recycled
		
		is_deleted = 1
		
		grid.chunk_map.Remove(COORD_KEY.Create(x, y))
		
		super_chunk.chunk_logoff()
		
		' remove all dependencies -> prevent memory leak
		super_chunk = Null
		grid = Null
		block_buffers[0] = Null
		block_buffers[1] = Null
		light_buffer = Null
		liquids_buffer = Null
	End Method
	
	Method render_buffer_blocks:Int(layer:Int) ' returns false if it aborted because out of viewing range
		
		
		If is_deleted Then Return False
		
		SetColor 255,255,255
		
		'last_update_block_attempt = MilliSecs()/1000
				
		Local x1:Int = -grid.view_x/grid.chunk_size-1  -grid.chunks_done_outside_screen_blocks
		Local y1:Int = -grid.view_y/grid.chunk_size-1  -grid.chunks_done_outside_screen_blocks
		
		Local x2:Int = (Graphics_Handler.x-grid.view_x)/grid.chunk_size  +grid.chunks_done_outside_screen_blocks
		Local y2:Int = (Graphics_Handler.y-grid.view_y)/grid.chunk_size  +grid.chunks_done_outside_screen_blocks
		
		If x < x1 Or x > x2 Or y < y1 Or y > y2 Then
			need_update_blocks_buffer[layer] = 0
			was_drawn_blocks_buffer[layer] = 0
			Return False
		EndIf
		
		
		If Not block_buffers[layer] Then
			block_buffers[layer] = TBuffer(buffer_recycle.RemoveLast())
			If Not block_buffers[layer] Then
				block_buffers[layer] = TBuffer.Create(grid.chunk_size)
				number_of_buffers:+1
			EndIf
			
			number_of_buffers_active:+1
			
			was_drawn_blocks_buffer[layer] = 0
		EndIf
				
		If need_update_blocks_buffer[layer] = 1 Then
			' Field update_block_number:Int = 0
			' Field update_block_x:Int = 0
			' Field update_block_y:Int = 0

			If update_block_numbers[layer] = 1 Then
				' only change single block
				Self.block_buffers[layer].set_me()
				
				draw_blocks_changed(0,0, update_block_xs[layer], update_block_ys[layer], Self.block_buffers[layer], layer)
				
				Self.block_buffers[layer].set_normal()
				
				was_drawn_blocks_buffer[layer] = 1
				need_update_blocks_buffer[layer] = 0
				
				update_block_numbers[layer] = 0
			Else
				Self.block_buffers[layer].set_me()
				Self.block_buffers[layer].buffer.Cls(0,0,0,0)
				Local a:Int = draw_blocks(0,0, layer)
				'Local b:Int = draw_blocks(0,0,1)
				Self.block_buffers[layer].set_normal()
				
				If a Then
					was_drawn_blocks_buffer[layer] = 1
					need_update_blocks_buffer[layer] = 0
					
					update_block_numbers[layer] = 0
					'last_update_block = MilliSecs()/1000
				EndIf
			EndIf
		EndIf
		
		Return True
	End Method
	
	Method draw_buffer_blocks(x:Float,y:Float, layer:Int)
		' draw unstretched at coordinates x,y
		If was_drawn_blocks_buffer[layer] Then
			SetColor 100+155*layer,100+155*layer,100+155*layer
			block_buffers[layer].draw(x,y)
		Else
			require_update_blocks(layer)
			
			SetColor 0,0,0
			DrawRect x,y, grid.chunk_size, grid.chunk_size
		EndIf
		
		If grid.draw_chunk_debug Then
			If sc_off_x_blocks = 0 Then
				SetColor 255,0,0
				
				DrawRect x,y, 3, grid.chunk_size
			Else
				SetColor 0,0,0
				
				DrawRect x,y, 1, grid.chunk_size
			EndIf
			
			If sc_off_y_blocks = 0 Then
				SetColor 255,0,0
				
				DrawRect x,y, grid.chunk_size, 3
			Else
				SetColor 0,0,0
				
				DrawRect x,y, grid.chunk_size, 1
			EndIf
			
			SetColor 255,0,255
			EFONT.draw("sc: (" + super_chunk.x + ", " + super_chunk.y + "), [" +sc_off_x_blocks + "," + sc_off_y_blocks + "]",x+5,y+5,2)
		EndIf
		
	End Method
	
	
	Method render_lights:Int()
		
		If is_deleted Then Return False
		
		If Not check_on_chunk_neighbours_data() Return False
		
		If Not light_buffer Then
			light_buffer = TBuffer(light_buffer_recycle.RemoveFirst())
			If Not light_buffer Then
				light_buffer = TBuffer.Create(grid.chunk_size_blocks)
				number_of_light_buffers:+1
			EndIf
			number_of_light_buffers_active:+1
		EndIf
		
		' draw unstretched at coordinates x,y
		'If neighbours Then
			Local change_light_somewhere:Int = 0 ' stop recalculating if possible
			Local change_light:Int[,] = New Int[3,3] ' signal neighbours			
			
			
			If need_update_lights = 1 Then' ------------ ***
			
			
			light_buffer.set_me()
			light_buffer.buffer.Cls(0,0,0,1)
			
			
			Rem
			-------------------------------   Jitter is too strong -> why?
			Local xx:Int
			Local step_x:Int
			
			If Rand(0,1) = 0 Then
				xx = -1
				step_x = 1
			Else
				xx = grid.chunk_size_blocks
				step_x = -1
			EndIf
			
			While (step_x = 1 And xx < grid.chunk_size_blocks-1) Or (step_x = -1 And xx > 0)
				xx:+ step_x
				
				Local yy:Int
				Local step_y:Int
				
				If Rand(0,1) = 0 Then
					yy= -1
					step_y = 1
				Else
					yy = grid.chunk_size_blocks
					step_y = -1
				EndIf
				
				
				While (step_y = 1 And yy < grid.chunk_size_blocks-1) Or (step_y = -1 And yy > 0)
					yy:+ step_y
			End Rem
			
			For Local xx:Int = 0 To grid.chunk_size_blocks-1
				For Local yy:Int = 0 To grid.chunk_size_blocks-1
					
										
					Local max_light_edge:Short[] = [Short 0,Short 0, Short 0]
					Local max_light_corner:Short[] = [Short 0,Short 0, Short 0]
					
					Local xx_a:Int = xx + Self.x*grid.chunk_size_blocks
					Local yy_a:Int = yy + Self.y*grid.chunk_size_blocks
					
					For Local ix:Int = -1 To 1
						For Local iy:Int = -1 To 1
							If ix = 0 And iy = 0 Then
								' me, leave out
							Else
								Local loc_light:Short[] = grid.super_grid.get_light_truncated(xx_a + ix, yy_a + iy)
								
								If ix = 0 Or iy = 0 Then
									' on edge
									max_light_edge[0] = Max(max_light_edge[0], loc_light[0])
									max_light_edge[1] = Max(max_light_edge[1], loc_light[1])
									max_light_edge[2] = Max(max_light_edge[2], loc_light[2])
								Else
									' corner
									max_light_corner[0] = Max(max_light_corner[0], loc_light[0])
									max_light_corner[1] = Max(max_light_corner[1], loc_light[1])
									max_light_corner[2] = Max(max_light_corner[2], loc_light[2])
								EndIf
								
							EndIf
						Next
					Next
					
					
					Local old_l:Short[] = get_light(xx,yy)
					Local new_l:Short[] = [Short 0,Short 0, Short 0]
					
					'new_l[0] = Max(Max(old_l[0]-10, max_light_corner[0] - 28), Max(0, max_light_edge[0] - 20))
					'new_l[1] = Max(Max(old_l[1]-10, max_light_corner[1] - 28), Max(0, max_light_edge[1] - 20))
					'new_l[2] = Max(Max(old_l[2]-10, max_light_corner[2] - 28), Max(0, max_light_edge[2] - 20))
					new_l[0] = Max(Max(old_l[0]*0.5, max_light_corner[0]*0.82), Max(0, max_light_edge[0]*0.92))
					new_l[1] = Max(Max(old_l[1]*0.5, max_light_corner[1]*0.82), Max(0, max_light_edge[1]*0.92))
					new_l[2] = Max(Max(old_l[2]*0.5, max_light_corner[2]*0.82), Max(0, max_light_edge[2]*0.92))
					
					
					Local block_0:Short = get_blocks(xx,yy,0)
					Local block_1:Short = get_blocks(xx,yy,1)
					
					If VOXEL_BLOCK.collision[block_1] Then
						new_l[0] = Max(0, new_l[0]-600)
						new_l[1] = Max(0, new_l[1]-600)
						new_l[2] = Max(0, new_l[2]-600)
						
						Rem
						If get_blocks(xx,yy,1) = 7 Then
							new_l[0] = Max(new_l[0], 4100)
							new_l[1] = Max(new_l[1], 3100)
							new_l[2] = Max(new_l[2], 0)
						EndIf
						End Rem
					Else
						If block_0 = VOXEL_BLOCK.AIR Then
							new_l[0] = Max(new_l[0], 4100)
							new_l[1] = Max(new_l[1], 4100)
							new_l[2] = Max(new_l[2], 4100)
						ElseIf get_liquid_type(xx,yy) = 2 Then						
							new_l[0] = Max(new_l[0], 4100)
							new_l[1] = Max(new_l[1], 2000)
							new_l[2] = Max(new_l[2], 2000)
						EndIf
					EndIf
					
					new_l[0] = Max(VOXEL_BLOCK.light_r[block_1], new_l[0]) ' block light
					new_l[1] = Max(VOXEL_BLOCK.light_g[block_1], new_l[1])
					new_l[2] = Max(VOXEL_BLOCK.light_b[block_1], new_l[2])
					
					'new_l[0] = Max(VOXEL_BLOCK.light_r[block_0]*0.8, new_l[0])
					'new_l[1] = Max(VOXEL_BLOCK.light_g[block_0]*0.8, new_l[1])
					'new_l[2] = Max(VOXEL_BLOCK.light_b[block_0]*0.8, new_l[2])
					
					If new_l[0] <> old_l[0] Or new_l[1] <> old_l[1] Or new_l[2] <> old_l[2] Then
						set_light_hard(xx,yy, new_l[0], new_l[1], new_l[2])
						change_light_somewhere = 1
						
						'change_light
						
						
						If yy = 0 Then
							change_light[1,0]  = 1
							
							If xx = 0 Then
								change_light[0,1] = 1
							ElseIf xx = grid.chunk_size_blocks-1 Then
								change_light[2,1] = 1
							EndIf
							
						ElseIf yy = grid.chunk_size_blocks-1 Then
							change_light[1,2]  = 1
							
							If xx = 0 Then
								change_light[0,1] = 1
							ElseIf xx = grid.chunk_size_blocks-1 Then
								change_light[2,1] = 1
							EndIf
		
						ElseIf xx = 0 Then
							change_light[0,1] = 1
						ElseIf xx = grid.chunk_size_blocks-1 Then
							change_light[2,1] = 1
						EndIf
					EndIf
					
					
					Local scol:Short[] = get_light(xx,yy)
					SetColor scol[0] Shr 4, scol[1] Shr 4, scol[2] Shr 4
					
					'DrawRect x + xx*grid.block_size,y + yy*grid.block_size,grid.block_size,grid.block_size
					DrawRect xx,yy,1,1
				Next
			Next
			'	Wend
			'Wend
			
			light_buffer.set_normal()
			
			'End If ' ------------ ***
			EndIf' ------------ ***
			
			If Not change_light_somewhere Then
				need_update_lights = 0
			Else
				' require neighbours to update !
				
				For Local ix:Int = 0 To 2
					For Local iy:Int = 0 To 2
						If change_light[ix,iy] Then grid.chunk_at_update_lights(Self.x + ix -1, Self.y + iy -1) 'neighbours[ix,iy].need_update_lights = 1
					Next
				Next
			EndIf
			
			Return True
		'EndIf
		'Return False
	End Method
	
	Method draw_lights:Int(x:Float,y:Float)
		SetColor 255,255,255
		If light_buffer Then light_buffer.draw(x,y) ' used to work without check ... !
	End Method
	
	
	Const liq_pressure_water:Int = 8 ' per level
	
	Const liq_pressure_lava:Int = 16
	Const liq_viscosity_lava:Int = 1 ' min amount of lava until moves to side
	
	Method draw_liquid:Int(x:Float,y:Float)
		
		If Not check_on_chunk_neighbours_data() Return False
		
		'If neighbours Then
			Local x_step_mode:Int = (Rand(0,100) > 50)*2-1
			
			Local xx:Int
			
			If x_step_mode = -1 Then
				xx = grid.chunk_size_blocks-1
			Else
				xx = 0
			EndIf
			
			While (x_step_mode=1 And xx < grid.chunk_size_blocks) Or (x_step_mode=-1 And xx >= 0) ' for equal distribution
			'For Local xx:Int = 0 To grid.chunk_size_blocks-1
				For Local yy:Int = 0 To grid.chunk_size_blocks-1
					
					If get_liquid_type(xx,yy) > 0 Then ' ---------------------------------�������
					
						Local xx_a:Int = xx + Self.x*grid.chunk_size_blocks
						Local yy_a:Int = yy + Self.y*grid.chunk_size_blocks
						
						Local water_flow_down:Int = 0 ' if at the end no water left, draw water none the less !
						' stores amount that flows down
						
						' --------------------------------- read
						Local old_down:Int
						Local coll_down:Int
						Local type_down:Int
						Local setblock_down:Int = 0
						
						old_down = grid.super_grid.get_liquid_truncated(xx_a, yy_a+1) + grid.super_grid.get_liquid_plus_truncated(xx_a, yy_a+1)
						coll_down = VOXEL_BLOCK.collision[grid.super_grid.get_block_truncated(xx_a, yy_a+1,1)]
						type_down = grid.super_grid.get_liquid_type_truncated(xx_a, yy_a+1)
	
						Rem
						If yy = grid.chunk_size_blocks-1 Then
							old_down = neighbours[1,2].liquid[xx,0]+neighbours[1,2].liquid_plus[xx,0]
							coll_down = VOXEL_BLOCK.has_collision(neighbours[1,2].get_blocks(xx,0,1))
							type_down = neighbours[1,2].liquid_type[xx,0]
						Else
							old_down = liquid[xx,yy+1]+liquid_plus[xx,yy+1]
							coll_down = VOXEL_BLOCK.has_collision(get_blocks(xx,yy+1,1))
							type_down = liquid_type[xx,yy+1]
						EndIf
						End Rem
						
						Local new_down:Int = old_down
						
						' - right
						Local old_right:Int 
						Local coll_right:Int
						Local type_right:Int
						Local setblock_right:Int = 0
						
						old_right = grid.super_grid.get_liquid_truncated(xx_a+1, yy_a) + grid.super_grid.get_liquid_plus_truncated(xx_a+1, yy_a)
						coll_right = VOXEL_BLOCK.collision[grid.super_grid.get_block_truncated(xx_a+1, yy_a,1)]
						type_right = grid.super_grid.get_liquid_type_truncated(xx_a+1, yy_a)
						
						Rem
						If xx = grid.chunk_size_blocks-1 Then
							old_right = neighbours[2,1].liquid[0,yy]+neighbours[2,1].liquid_plus[0,yy]
							coll_right = VOXEL_BLOCK.has_collision(neighbours[2,1].get_blocks(0,yy,1))
							type_right = neighbours[2,1].liquid_type[0,yy]
						Else
							old_right = liquid[xx+1,yy]+liquid_plus[xx+1,yy]
							coll_right = VOXEL_BLOCK.has_collision(get_blocks(xx+1,yy,1))
							type_right = liquid_type[xx+1,yy]
						EndIf
						End Rem
						
						Local new_right:Int = old_right
						
						' - left
						Local old_left:Int 
						Local coll_left:Int 
						Local type_left:Int
						Local setblock_left:Int = 0
						
						old_left = grid.super_grid.get_liquid_truncated(xx_a-1, yy_a) + grid.super_grid.get_liquid_plus_truncated(xx_a-1, yy_a)
						coll_left = VOXEL_BLOCK.collision[grid.super_grid.get_block_truncated(xx_a-1, yy_a,1)]
						type_left = grid.super_grid.get_liquid_type_truncated(xx_a-1, yy_a)
						
						Rem
						If xx = 0 Then
							old_left = neighbours[0,1].liquid[grid.chunk_size_blocks-1,yy]+neighbours[0,1].liquid_plus[grid.chunk_size_blocks-1,yy]
							coll_left = VOXEL_BLOCK.has_collision(neighbours[0,1].get_blocks(grid.chunk_size_blocks-1,yy,1))
							type_left = neighbours[0,1].liquid_type[grid.chunk_size_blocks-1,yy]
						Else
							old_left = liquid[xx-1,yy]+liquid_plus[xx-1,yy]
							coll_left = VOXEL_BLOCK.has_collision(get_blocks(xx-1,yy,1))
							type_left = liquid_type[xx-1,yy]
						EndIf
						End Rem
						
						Local new_left:Int = old_left
						
						' - up
						Local old_up:Int 
						Local coll_up:Int 
						Local type_up:Int
						Local setblock_up:Int = 0
						
						old_up = grid.super_grid.get_liquid_truncated(xx_a, yy_a-1) + grid.super_grid.get_liquid_plus_truncated(xx_a, yy_a-1)
						coll_up = VOXEL_BLOCK.collision[grid.super_grid.get_block_truncated(xx_a, yy_a-1,1)]
						type_up = grid.super_grid.get_liquid_type_truncated(xx_a, yy_a-1)
						
						Rem
						If yy = 0 Then
							old_up = neighbours[1,0].liquid[xx,grid.chunk_size_blocks-1]+neighbours[1,0].liquid_plus[xx,grid.chunk_size_blocks-1]
							coll_up = VOXEL_BLOCK.has_collision(neighbours[1,0].get_blocks(xx,grid.chunk_size_blocks-1,1))
							type_up = neighbours[1,0].liquid_type[xx,grid.chunk_size_blocks-1]
						Else
							old_up = liquid[xx,yy-1]+liquid_plus[xx,yy-1]
							coll_up = VOXEL_BLOCK.has_collision(get_blocks(xx,yy-1,1))
							type_up = liquid_type[xx,yy-1]
						EndIf
						End Rem
						
						Local new_up:Int = old_up
						
						' --------------------------------- modify
						Select get_liquid_type(xx,yy)
							Case 1
								If (Not coll_down) And get_liquid(xx,yy)>0 Then
									Select type_down
										Case 0,1
											If (get_liquid(xx,yy) - new_down + liq_pressure_water)>0 Then
												Local sh:Int = Min(get_liquid(xx,yy)-new_down + liq_pressure_water, get_liquid(xx,yy))'Min((get_liquid(xx,yy)-new_down + liq_pressure_water), 100)
												new_down:+sh
												sub_liquid(xx,yy,sh)
												
												water_flow_down:+sh
											EndIf
										Case 2
											' obsidian !
											setblock_down = 8
										Default
											Print("bad interaction: water and " + type_down + " (down)")
									End Select
									
								EndIf
								
								'If new_down = old_down
									If Rand(0,1) = 1 Then
										Select type_right
											Case 0,1
												If (Not coll_right) And get_liquid(xx,yy)>0 Then
													If (get_liquid(xx,yy) - new_right)>0 Then
														Local sh:Int = Max((get_liquid(xx,yy)-new_right)/2,1)
														new_right :+sh
														sub_liquid(xx,yy,sh)
													EndIf
												EndIf
											Case 2
												' obsidian
												setblock_right = 8
											Default
												Print("bad interaction: water and " + type_down + " (right)")
										End Select
										
										Select type_left
											Case 0,1
												If (Not coll_left) And get_liquid(xx,yy)>0 Then
													If (get_liquid(xx,yy) - new_left)>0 Then
														Local sh:Int = Max((get_liquid(xx,yy)-new_left)/2,1)
														new_left:+sh
														sub_liquid(xx,yy,sh)
													EndIf
												EndIf
											Case 2
												' obsidian
												setblock_left = 8
											Default
												Print("bad interaction: water and " + type_down + " (left)")
										End Select
									Else
										Select type_left
											Case 0,1
												If (Not coll_left) And get_liquid(xx,yy)>0 Then
													If (get_liquid(xx,yy) - new_left)>0 Then
														Local sh:Int = Max((get_liquid(xx,yy)-new_left)/2,1)
														new_left:+sh
														sub_liquid(xx,yy,sh)
													EndIf
												EndIf
											Case 2
												' obsidian
												setblock_left = 8
											Default
												Print("bad interaction: water and " + type_down + " (left)")
										End Select
										
										Select type_right
											Case 0,1
												If (Not coll_right) And get_liquid(xx,yy)>0 Then
													If (get_liquid(xx,yy) - new_right)>0 Then
														Local sh:Int = Max((get_liquid(xx,yy)-new_right)/2,1)
														new_right :+sh
														sub_liquid(xx,yy,sh)
													EndIf
												EndIf
											Case 2
												' obsidian
												setblock_right = 8
											Default
												Print("bad interaction: water and " + type_down + " (right)")
										End Select
									EndIf
								'EndIf
								
								'If new_left = old_left And new_right = old_right And new_down = old_down Then
									
									Select type_up
										Case 0,1
											If (Not coll_up) And get_liquid(xx,yy)>0 Then
												If (get_liquid(xx,yy) - new_up - liq_pressure_water)>0 Then
													Local sh:Int = Max((get_liquid(xx,yy) - new_up - liq_pressure_water)/2,1)
													new_up :+sh
													sub_liquid(xx,yy,sh)
												EndIf
											EndIf
										Case 2
											' obsidian
											setblock_up = 8
										Default
											Print("bad interaction: water and " + type_down + " (up)")
									End Select
									
								'EndIf
							Case 2
								'set light
								set_light(xx,yy,255,0,0)
								
								'do movement
								If (Not coll_down) And get_liquid(xx,yy)>0 Then
									Select type_down
										Case 0,2
											If (get_liquid(xx,yy) - new_down + liq_pressure_lava)>0 Then
												Local sh:Int = Min((get_liquid(xx,yy)-new_down + liq_pressure_lava)/3, get_liquid(xx,yy))
												new_down:+sh
												sub_liquid(xx,yy,sh)
												
												water_flow_down:+sh
											EndIf
										Case 1
											' obsidian !
											action_set_block(True, xx,yy,1,VOXEL_BLOCK.OBSIDIAN)
										Default
											Print("bad interaction: lava and " + type_down + " (down)")
									End Select
									
								EndIf
								
								If new_down = old_down
									If Rand(0,1) = 1 Then
										Select type_right
											Case 0,2
												If (Not coll_right) And get_liquid(xx,yy)>0 Then
													If (get_liquid(xx,yy) - new_right) > liq_viscosity_lava Or (new_down>0 And (get_liquid(xx,yy) - new_right) > 0) Then
														Local sh:Int = Max((get_liquid(xx,yy)-new_right)/3,1)
														new_right :+sh
														sub_liquid(xx,yy,sh)
													EndIf
												EndIf
											Case 1
												' obsidian
												action_set_block(True, xx,yy,1,VOXEL_BLOCK.OBSIDIAN)
											Default
												Print("bad interaction: lava and " + type_down + " (right)")
										End Select
									Else
										Select type_left
											Case 0,2
												If (Not coll_left) And get_liquid(xx,yy)>0 Then
													If (get_liquid(xx,yy) - new_left) > liq_viscosity_lava Or (new_down>0 And (get_liquid(xx,yy) - new_left) > 0) Then
														Local sh:Int = Max((get_liquid(xx,yy)-new_left)/3,1)
														new_left:+sh
														sub_liquid(xx,yy,sh)
													EndIf
												EndIf
											Case 1
												' obsidian
												action_set_block(True, xx,yy,1,VOXEL_BLOCK.OBSIDIAN)
											Default
												Print("bad interaction: lava and " + type_down + " (left)")
										End Select
										
									EndIf
								EndIf
								
								If new_left = old_left And new_right = old_right And new_down = old_down Then
									
									Select type_up
										Case 0,2
											If (Not coll_up) And get_liquid(xx,yy)>0 Then
												If (get_liquid(xx,yy) - new_up - liq_pressure_lava)>0 Then
													Local sh:Int = Max((get_liquid(xx,yy) - new_up - liq_pressure_lava)/3,1)
													new_up :+sh
													sub_liquid(xx,yy,sh)
												EndIf
											EndIf
										Case 1
											' obsidian
											action_set_block(True, xx,yy,1,VOXEL_BLOCK.OBSIDIAN)
										Default
											Print("bad interaction: lava and " + type_down + " (up)")
									End Select
									
								EndIf
								
								' ----------------- LAVA CAN GO AWAY IF LOW ENOUGH
								If coll_down And get_liquid(xx,yy) = 1 And Rand(0,20)=0 Then set_liquid(xx,yy,0)
							Default
								
								RuntimeError("unknown liquid: " + get_liquid_type(xx,yy))
								Print("draw water with unknown type: " + get_liquid_type(xx,yy))
						End Select
						
						' --------------------------------- write back
						If new_down <> old_down Then
							grid.super_grid.add_liquid_plus_truncated(xx_a, yy_a+1, new_down-old_down)
							grid.super_grid.set_liquid_type_truncated(xx_a, yy_a+1, get_liquid_type(xx,yy))
							
							Rem
							If yy = grid.chunk_size_blocks-1 Then
								neighbours[1,2].liquid_plus[xx,0]:+new_down-old_down
								neighbours[1,2].liquid_type[xx,0] = liquid_type[xx,yy]
							Else
								liquid_plus[xx,yy+1]:+new_down-old_down
								liquid_type[xx,yy+1] = liquid_type[xx,yy]
							EndIf
							End Rem
						EndIf
						
						If setblock_down Then
							If yy = grid.chunk_size_blocks-1 Then
								grid.super_grid.set_block_truncated(xx_a,yy_a+1,1,setblock_down)
							Else
								action_set_block(True, xx,yy+1,1,setblock_down)
							EndIf
						EndIf
						
						' - right
						If new_right <> old_right Then
							grid.super_grid.add_liquid_plus_truncated(xx_a+1, yy_a, new_right -old_right)
							grid.super_grid.set_liquid_type_truncated(xx_a+1, yy_a, get_liquid_type(xx,yy))
							
							Rem
							If xx = grid.chunk_size_blocks-1 Then
								neighbours[2,1].liquid_plus[0,yy]:+new_right-old_right
								neighbours[2,1].liquid_type[0,yy] = liquid_type[xx,yy]
							Else
								liquid_plus[xx+1,yy]:+new_right-old_right
								liquid_type[xx+1,yy] = liquid_type[xx,yy]
							EndIf
							End Rem
						EndIf
						
						If setblock_right Then
							If xx = grid.chunk_size_blocks-1 Then
								grid.super_grid.set_block_truncated(xx_a+1,yy_a,1,setblock_right)
							Else
								action_set_block(True, xx+1,yy,1,setblock_right)
							EndIf
						EndIf
						
						' - left
						If new_left <> old_left Then
							grid.super_grid.add_liquid_plus_truncated(xx_a-1, yy_a, new_left -old_left)
							grid.super_grid.set_liquid_type_truncated(xx_a-1, yy_a, get_liquid_type(xx,yy))
							
							Rem
							If xx = 0 Then
								neighbours[0,1].liquid_plus[grid.chunk_size_blocks-1,yy]:+new_left-old_left
								neighbours[0,1].liquid_type[grid.chunk_size_blocks-1,yy] = liquid_type[xx,yy]
							Else
								liquid_plus[xx-1,yy]:+new_left-old_left
								liquid_type[xx-1,yy] = liquid_type[xx,yy]
							EndIf
							End Rem
						EndIf
						
						If setblock_left Then
							If xx = 0 Then
								grid.super_grid.set_block_truncated(xx_a-1,yy_a,1,setblock_left)
							Else
								action_set_block(True, xx-1,yy,1,setblock_left)
							EndIf
						EndIf
						
						' - up
						If new_up <> old_up Then
							grid.super_grid.add_liquid_plus_truncated(xx_a, yy_a-1, new_up -old_up)
							grid.super_grid.set_liquid_type_truncated(xx_a, yy_a-1, get_liquid_type(xx,yy))
							
							Rem
							If yy = 0 Then
								neighbours[1,0].liquid_plus[xx,grid.chunk_size_blocks-1]:+new_up-old_up
								neighbours[1,0].liquid_type[xx,grid.chunk_size_blocks-1] = liquid_type[xx,yy]
							Else
								liquid_plus[xx,yy-1]:+new_up-old_up
								liquid_type[xx,yy-1] = liquid_type[xx,yy]
							EndIf
							End Rem
						EndIf
						
						If setblock_up Then
							If yy = 0 Then
								grid.super_grid.set_block_truncated(xx_a,yy_a-1,1,setblock_up)
							Else
								action_set_block(True, xx,yy-1,1,setblock_up)
							EndIf
						EndIf
						
						Local water_draw:Int = (get_liquid(xx,yy)+water_flow_down)
						
						If water_draw+get_liquid_plus(xx,yy) <= 0 Then
							set_liquid_type(xx,yy,0)
						EndIf
						
						If grid.with_graphics Then
							
							If water_draw > 0 Then
								Local color:Byte[]
								Local liq_dr_lvls:Int = 1
								
								Select get_liquid_type(xx,yy)
									Case 1
										liq_dr_lvls = liq_pressure_water
									Case 2
										liq_dr_lvls = liq_pressure_lava
									Default
										RuntimeError("not implemented liquid")
								End Select
								
								Local brightness:Float = Min(Max(0.6, (300.0-water_draw/3)/300.0),1.0)
								
								'SetColor color[0]*brightness, color[1]*brightness,color[2]*brightness
								
								Local draw_x:Float = x + xx*grid.block_size
								Local draw_y:Float = y + yy*grid.block_size
								
								If water_draw > liq_dr_lvls Then
									
									SetColor 255*brightness,255*brightness,255*brightness
									VOXEL_BLOCK.draw_liquid(grid, Self, get_liquid_type(xx,yy), grid.block_size, draw_x,draw_y, xx+11, yy+11) ' 11 need to get global coordinates...
								Else
									Local lvl:Float = water_draw * Float(grid.block_size) / Float(liq_dr_lvls)
									
									SetColor 255*brightness,255*brightness,255*brightness
									VOXEL_BLOCK.draw_liquid(grid, Self, get_liquid_type(xx,yy), lvl, draw_x,draw_y, xx+11, yy+11)
								EndIf
								
								If grid.draw_chunk_debug_water Then ' remove for speedup !
									SetColor 255,255,255
									EFONT.draw(water_draw, x + xx*grid.block_size,y + yy*grid.block_size,2)
								EndIf
		
							EndIf
							
							If water_draw < 0 Then ' remove for speedup !
								RuntimeError("negative liquid is never good !")
								SetColor 255,150,150
								EFONT.draw(water_draw, x + xx*grid.block_size,y + yy*grid.block_size,2)
							EndIf
						EndIf
					
					End If ' ---------------------------------�������
					
					If grid.with_graphics Then
						If grid.draw_chunk_debug_water Then ' remove for speedup !
							SetColor 0,0,0
							EFONT.draw(get_liquid_type(xx,yy), x + xx*grid.block_size,y + yy*grid.block_size+10, 2)
						EndIf
					EndIf
					
					do_plus_liquid(xx,yy)
					'liquid[xx,yy]:+liquid_plus[xx,yy]
					'liquid_plus[xx,yy] = 0

				Next
				
				xx:+x_step_mode
			Wend
			'Next
			
			
			If grid.with_graphics Then
				SetAlpha 1.0 ' because liquids at times transparent :)
			EndIf
			
			Return True
		'EndIf
		'Return False
		
	End Method
	
	Method render_buffer_liquids:Int() ' returns false if it aborted because out of viewing range
		
		'Print("rl " + x + " " + y)
		
		If is_deleted Then Return False
		
		'Print("rl_2 " + x + " " + y)
		
		If grid.with_graphics Then
			Local x1:Int = -grid.view_x/grid.chunk_size-1  -grid.chunks_done_outside_screen_liquids
			Local y1:Int = -grid.view_y/grid.chunk_size-1  -grid.chunks_done_outside_screen_liquids
			
			Local x2:Int = (Graphics_Handler.x-grid.view_x)/grid.chunk_size  +grid.chunks_done_outside_screen_liquids
			Local y2:Int = (Graphics_Handler.y-grid.view_y)/grid.chunk_size  +grid.chunks_done_outside_screen_liquids
			
			If x < x1 Or x > x2 Or y < y1 Or y > y2 Then
				'Print("rej")
				need_update_liquids = 0
				Return False
			EndIf
			
			If Not liquids_buffer Then
				liquids_buffer = TBuffer(buffer_recycle.RemoveLast())
				If Not liquids_buffer Then
					liquids_buffer = TBuffer.Create(grid.chunk_size)
					number_of_buffers:+1
				EndIf
				
				number_of_buffers_active:+1
			EndIf
			
			liquids_buffer.set_me()
			liquids_buffer.buffer.Cls(0,0,0,0)
			
			Local a:Int = draw_liquid(0,0)
			
			liquids_buffer.set_normal()
			
			need_update_liquids = 0
			
			If Not a Then Print("not drawn !")
		Else
			draw_liquid(0,0)
			
			need_update_liquids = 0
		EndIf
		
		Return True
	End Method
	
	Method draw_buffer_liquids(x:Float,y:Float)
		' draw unstretched at coordinates x,y
		
		' SPECIAL BLEND MODE, fixes alpha stuff!
		glEnable GL_BLEND		
		glBlendFuncSeparate(GL_SRC_ALPHA, GL_ONE_MINUS_SRC_ALPHA, GL_ONE, GL_ONE)
		glDisable GL_ALPHA_TEST
		
		If liquids_buffer Then
			SetColor 255,255,255
			liquids_buffer.draw(x,y)
		Else
			require_update_liquids()
			
			SetColor Rand(0,255),Rand(0,255),Rand(0,255)
			DrawRect x,y, grid.chunk_size, grid.chunk_size
		EndIf
		
		SetBlend alphablend
		
	End Method
End Type
'----------------------------------------------------------------------------------------
'---------------------------                    -----------------------------------------
'---------------------------     Voxel Block    -----------------------------------------
'---------------------------                    -----------------------------------------
'----------------------------------------------------------------------------------------
Type VOXEL_BLOCK
	
	
	Global tile_water:TImage[]
	Global tile_lava:TImage[]
	Global tile_shadow:TImage[]
	
	Global collision:Int[]
		
	Global gives_shadow:Int[]
		
	Global covers_block:Int[]
		
	Global importance:Int[]
		
	Global expanded:Int[]
	
	Global durability:Int[] ' -2 = block_obj, -1 = not minable, pos = mineable
		
	Global item_when_breaking:Int[]
	
	Global light_r:Int[]
	Global light_g:Int[]
	Global light_b:Int[]
	
	Global can_overplace:Int[]
	
	Const reserve_blocks:Int = 30
	Global set_pos:Int = 0
	
	Global tile_set:TImage[][]
	
	Function add_block:Int(tile:TImage[], coll:Int, shade:Int, covers:Int, important:Int, expands:Int, durable:Int, gives_item:Int, light_r:Int, light_g:Int, light_b:Int, can_overplace:Int)
		If set_pos > reserve_blocks-1 Then RuntimeError("need bigger reserve !")
		
		VOXEL_BLOCK.tile_set[set_pos] = tile
		VOXEL_BLOCK.collision[set_pos] = coll
		VOXEL_BLOCK.gives_shadow[set_pos] = shade
		VOXEL_BLOCK.covers_block[set_pos] = covers
		VOXEL_BLOCK.importance[set_pos] = important
		VOXEL_BLOCK.expanded[set_pos] = expands
		VOXEL_BLOCK.durability[set_pos] = durable
		VOXEL_BLOCK.item_when_breaking[set_pos] = gives_item
		
		VOXEL_BLOCK.light_r[set_pos] = light_r
		VOXEL_BLOCK.light_g[set_pos] = light_g
		VOXEL_BLOCK.light_b[set_pos] = light_b
		
		VOXEL_BLOCK.can_overplace[set_pos] = can_overplace
		
		set_pos:+1
		
		Return set_pos-1
	End Function
	
	Global AIR:Int
	
	Global OBJ_X_NC:Int
	Global OBJ_U_NC:Int
	Global OBJ_D_NC:Int
	Global OBJ_L_NC:Int
	Global OBJ_R_NC:Int
	
	Global OBJ_X_C:Int
	Global OBJ_U_C:Int
	Global OBJ_D_C:Int
	Global OBJ_L_C:Int
	Global OBJ_R_C:Int
	
	Global DIRT_BROWN:Int
	Global DIRT_BLUE:Int
	Global DIRT_PINK:Int
	
	Global GRASS_GREEN:Int
	
	Global STONE:Int
	Global GOLD:Int
	Global GLOWSTONE:Int
	Global OBSIDIAN:Int
	
	Function tile_init()
		' ------------------- reserve arrays:
		tile_set = New TImage[][reserve_blocks]
		collision = New Int[reserve_blocks]
		gives_shadow = New Int[reserve_blocks]
		covers_block = New Int[reserve_blocks]
		importance = New Int[reserve_blocks]
		expanded = New Int[reserve_blocks]
		durability = New Int[reserve_blocks]
		item_when_breaking = New Int[reserve_blocks]
		can_overplace  = New Int[reserve_blocks]
		
		light_r = New Int[reserve_blocks]
		light_g = New Int[reserve_blocks]
		light_b = New Int[reserve_blocks]
		
		' ------------------ load the arrays:
		Local t_dirt:TImage[] = tile_load_expanded_rule("dirt")
		Local t_pink_dirt:TImage[] = tile_load_expanded_rule("pink_dirt")
		Local t_blue_dirt:TImage[] = tile_load_expanded_rule("blue_dirt")
		
		Local t_grass:TImage[] = tile_load_expanded_rule("grass")
		
		Local t_stone:TImage[] = tile_load_expanded_rule("stone")
		Local t_gold:TImage[] = tile_load_expanded_rule("gold")
		
		Local t_dbg_blkr:TImage[] = tile_load_expanded_rule("blocker")
		
		Local t_glow:TImage[] = tile_load_expanded_rule("glow")
		Local t_obsidian:TImage[] = tile_load_expanded_rule("obsidian")
		
		'							tile			collision		shade			covers			importance		expanded		durability		item							r		g		b,			can_overplace
		' air:
		AIR 			=add_block(TImage[](Null),	0, 				0,				0,				0,				0,				-1,				-1,							0,		0,		0,			True)
		
		' OBJECT ref No collision:
		OBJ_X_NC		=add_block(t_dbg_blkr,		0, 				0,				0,				0,				0,				-2,				-2,							0,		0,		0,			False)
		OBJ_U_NC		=add_block(t_dbg_blkr,		0, 				0,				0,				0,				0,				-2,				-2,							0,		0,		0,			False)
		OBJ_D_NC		=add_block(t_dbg_blkr,		0, 				0,				0,				0,				0,				-2,				-2,							0,		0,		0,			False)
		OBJ_L_NC		=add_block(t_dbg_blkr,		0, 				0,				0,				0,				0,				-2,				-2,							0,		0,		0,			False)
		OBJ_R_NC		=add_block(t_dbg_blkr,		0, 				0,				0,				0,				0,				-2,				-2,							0,		0,		0,			False)
		
		' OBJECT ref COLLISION:
		OBJ_X_C			=add_block(t_dbg_blkr,		1, 				0,				0,				0,				0,				-2,				-2,							0,		0,		0,			False)
		OBJ_U_C			=add_block(t_dbg_blkr,		1, 				0,				0,				0,				0,				-2,				-2,							0,		0,		0,			False)
		OBJ_D_C			=add_block(t_dbg_blkr,		1, 				0,				0,				0,				0,				-2,				-2,							0,		0,		0,			False)
		OBJ_L_C			=add_block(t_dbg_blkr,		1, 				0,				0,				0,				0,				-2,				-2,							0,		0,		0,			False)
		OBJ_R_C			=add_block(t_dbg_blkr,		1, 				0,				0,				0,				0,				-2,				-2,							0,		0,		0,			False)
		
		DIRT_BROWN		=add_block(t_dirt,			1, 				1,				1,				1000,			1,				200,			ITEM.BLOCK_DIRT_BROWN,	0,		0,		0,			False)
		DIRT_BLUE		=add_block(t_blue_dirt,		1, 				1,				1,				1001,			1,				200,			ITEM.BLOCK_DIRT_BROWN,	0,		0,		0,			False)
		DIRT_PINK		=add_block(t_blue_dirt,		1, 				1,				1,				1002,			1,				200,			ITEM.BLOCK_DIRT_BROWN,	0,		0,		0,			False)
		
		GRASS_GREEN		=add_block(t_grass,		1, 				1,				1,				2000,			1,				200,			ITEM.BLOCK_GRASS_GREEN,	0,		0,		0,			False)
		
		STONE			=add_block(t_stone,			1, 				1,				1,				4000,			1,				400,			ITEM.BLOCK_STONE,			0,		0,		0,			False)
		GOLD			=add_block(t_gold,			1, 				1,				1,				3000,			1,				600,			ITEM.BLOCK_GOLD,			0,		0,		0,			False)
		GLOWSTONE		=add_block(t_glow,			1, 				0,				1,				5000,			1,				100,			ITEM.BLOCK_GLOWSTONE,		4000,	3000,	2000,		False)
		OBSIDIAN		=add_block(t_obsidian,		1, 				1,				1,				9999,			1,				1000,			-1,							0,		0,		0,			False)
		
		tile_water = tile_load_simple("water")
		tile_lava = tile_load_simple("lava")
		
		
		tile_shadow = tile_load_expanded_rule("block_shadow")
	End Function
	
	Function tile_load_dynamic:TImage(path:String)
		Local img:TImage = LoadImage(path)
		
		If img.width > img.height Then
			img = LoadAnimImage(path, img.height, img.height, 0, (img.width / img.height))
		EndIf
		
		If Not img Then
			Print(" > did not find: " + path)
		EndIf
		
		Return img
	End Function
	
	Function tile_load_simple:TImage[](tile_name:String)
		Local tile:TImage[] = New TImage[1]
		
		tile[0] = tile_load_dynamic("tiles/" + tile_name + "/0.png")
		
		Return tile
	End Function
	
	Function tile_load_expanded_rule:TImage[](tile_name:String)
		Local tile:TImage[] = New TImage[17]
		
		' face
		tile[0] = tile_load_dynamic("tiles/" + tile_name + "/0.png")
		
		' top left
		tile[1] = tile_load_dynamic("tiles/" + tile_name + "/tl_0.png")
		tile[2] = tile_load_dynamic("tiles/" + tile_name + "/tl_1.png")
		tile[3] = tile_load_dynamic("tiles/" + tile_name + "/tl_2.png")
		tile[4] = tile_load_dynamic("tiles/" + tile_name + "/tl_3.png")
		
		' top right
		tile[5] = tile_load_dynamic("tiles/" + tile_name + "/tr_0.png")
		tile[6] = tile_load_dynamic("tiles/" + tile_name + "/tr_1.png")
		tile[7] = tile_load_dynamic("tiles/" + tile_name + "/tr_2.png")
		tile[8] = tile_load_dynamic("tiles/" + tile_name + "/tr_3.png")
		
		' bottom left
		tile[9] = tile_load_dynamic("tiles/" + tile_name + "/bl_0.png")
		tile[10] = tile_load_dynamic("tiles/" + tile_name + "/bl_1.png")
		tile[11] = tile_load_dynamic("tiles/" + tile_name + "/bl_2.png")
		tile[12] = tile_load_dynamic("tiles/" + tile_name + "/bl_3.png")
		
		' bottom right
		tile[13] = tile_load_dynamic("tiles/" + tile_name + "/br_0.png")
		tile[14] = tile_load_dynamic("tiles/" + tile_name + "/br_1.png")
		tile[15] = tile_load_dynamic("tiles/" + tile_name + "/br_2.png")
		tile[16] = tile_load_dynamic("tiles/" + tile_name + "/br_3.png")
		
		Return tile
	End Function
	
	Function draw_liquid(grid:VOXEL_GRID, chunk:VOXEL_CHUNK, typ:Byte, level:Int, draw_x:Int,draw_y:Int, pos_x:Int, pos_y:Int)
		
		Local tile_liquid:TImage[]
		
		Select typ
			Case 1 ' water
				tile_liquid = tile_water
			Case 2 ' lava
				tile_liquid = tile_lava
			Default
				RuntimeError("draw_liquid not implemented " + typ)
		End Select
		
		Local f:Int = tile_liquid[0].frames.length * grid.random_blocks_frames.get_2d(pos_x, pos_y)
		
		If level < grid.block_size Then
		'If h_left < grid.block_size Or h_right < grid.block_size Then
			Rem
			Local pixmap:TPixmap = LockImage(tile_liquid[0],f)
			glbindtexture(GL_TEXTURE_2D, GLTexFromPixmap( pixmap ))
			glenable GL_TEXTURE_2D
			
			glBegin GL_TRIANGLE_STRIP
			glColor3ub(255,255,255) ' is this right ?
			
			'glTexCoord2f( x/TRIANGLES.act_pix.width, y/TRIANGLES.act_pix.height)
			
			'---------------------------------- top left
			glVertex2f draw_x,draw_y+grid.block_size-h_left
			
			'---------------------------------- bottom left
			glVertex2f draw_x,draw_y+grid.block_size
			
			'---------------------------------- top right
			glVertex2f draw_x+grid.block_size,draw_y+grid.block_size-h_right
			
			'---------------------------------- bottom right
			glVertex2f draw_x+grid.block_size,draw_y+grid.block_size
			
			glEnd
			UnlockImage(tile_liquid[0],f)
			End Rem
			
			DrawSubImageRect(tile_liquid[0],  draw_x, draw_y+grid.block_size-level,grid.block_size,level,  0,grid.block_size-level,grid.block_size,level,  0,0,  f)
		Else
			'Print("cheaper")
			DrawImage(tile_liquid[0], draw_x,draw_y, f)
		EndIf
	End Function
	
	Function draw(grid:VOXEL_GRID, chunk:VOXEL_CHUNK, blk_neighbours:Int[,], x_off:Int, y_off:Int, draw_x:Int,draw_y:Int, pos_x:Int, pos_y:Int)
		' draw unstretched at coordinates x,y  - pos_x used for frame choice
		'x_off, y_off -> offset in neighbours
		
		draw_expanded_rule(grid, draw_x, draw_y, blk_neighbours,x_off, y_off, pos_x, pos_y)
	End Function
	
	Function draw_simple(grid:VOXEL_GRID, x:Int,y:Int, blk_neighbours:Int[,], x_off:Int, y_off:Int, pos_x:Int, pos_y:Int)' draw at x,y
		Local b:Int = blk_neighbours[1 + x_off,1 + y_off]
		
		If VOXEL_BLOCK.tile_set[b] Then
			Local f:Int = VOXEL_BLOCK.tile_set[b][0].frames.length * grid.random_blocks_frames.get_2d(pos_x, pos_y)
			
			DrawImage(VOXEL_BLOCK.tile_set[b][0], x,y, f)
		EndIf
	End Function
	
	Function draw_expanded_rule(grid:VOXEL_GRID, x:Int,y:Int, blk_neighbours:Int[,], x_off:Int, y_off:Int, pos_x:Int, pos_y:Int)' draw at x,y
		
		Local b:Int = blk_neighbours[1 + x_off,1 + y_off]
		
		Local block_random:Float = grid.random_blocks_frames.get_2d(pos_x, pos_y)
		
		If VOXEL_BLOCK.tile_set[b] Then
			Local f:Int = VOXEL_BLOCK.tile_set[b][0].frames.length * block_random
			
			DrawImage(VOXEL_BLOCK.tile_set[b][0], x,y, f)
		EndIf
		
		' ------------------------------------------------------------ top left
		Local b_0:Int = blk_neighbours[1 + x_off - 1,1 + y_off - 1] ' diag
		Local b_1:Int = blk_neighbours[1 + x_off,1 + y_off - 1] ' up
		Local b_2:Int = blk_neighbours[1 + x_off - 1,1 + y_off] ' left
		
		draw_expand_rule_sub(1, 0, 0,  b_0, b_1, b_2,  b,   block_random, x,y) ' all ok
		
		' ------------------------------------------------------------ top right
		b_0 = blk_neighbours[1 + x_off + 1,1 + y_off - 1] ' diag
		b_1 = blk_neighbours[1 + x_off,1 + y_off - 1] ' up
		b_2 = blk_neighbours[1 + x_off + 1,1 + y_off] ' right
		
		draw_expand_rule_sub(5, grid.block_size/2, 0,  b_0, b_1, b_2,  b,   block_random, x,y)
		
		' ------------------------------------------------------------ bottom left
		b_0 = blk_neighbours[1 + x_off - 1,1 + y_off + 1] ' diag
		b_1 = blk_neighbours[1 + x_off - 1,1 + y_off] ' left
		b_2 = blk_neighbours[1 + x_off,1 + y_off + 1] ' down
		
		draw_expand_rule_sub(9, 0, grid.block_size/2,  b_0, b_1, b_2,  b,   block_random, x,y)

		' ------------------------------------------------------------ bottom right
		b_0 = blk_neighbours[1 + x_off + 1,1 + y_off + 1] ' diag
		b_1 = blk_neighbours[1 + x_off + 1,1 + y_off] ' right
		b_2 = blk_neighbours[1 + x_off,1 + y_off + 1] ' down
		
		draw_expand_rule_sub(13, grid.block_size/2, grid.block_size/2,  b_0, b_1, b_2,  b,   block_random, x,y)
	End Function
	
	Function draw_expand_rule_sub(toft:Int, toft_x:Int, toft_y:Int,   b_0:Int, b_1:Int, b_2:Int, b:Int,   block_random:Float,  x:Int,y:Int)	
		' all names according to top left !
		Local choice:Int = (expanded[b_1] And importance[b_1] > importance[b]) + 2*(expanded[b_2] And importance[b_2] > importance[b]) + 4*(expanded[b_0] And importance[b_0] > importance[b])
		
		Select choice
			Case 0
				' nothing
			Case 1
				' up
				Local f:Int = VOXEL_BLOCK.tile_set[b_1][0].frames.length * block_random
				DrawImage(VOXEL_BLOCK.tile_set[b_1][toft + 1], x + toft_x,y + toft_y, f)
			Case 2
				' left
				Local f:Int = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
				DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 2], x + toft_x,y + toft_y, f)
			Case 3
				' up + left
				If b_1 = b_2 Then
					Local f:Int = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
					DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 3], x + toft_x,y + toft_y, f)
				ElseIf importance[b_1] > importance[b_2] Then
					Local f:Int = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
					DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 2], x + toft_x,y + toft_y, f)
					
					f = VOXEL_BLOCK.tile_set[b_1][0].frames.length * block_random
					DrawImage(VOXEL_BLOCK.tile_set[b_1][toft + 1], x + toft_x,y + toft_y, f)
				Else
					Local f:Int = VOXEL_BLOCK.tile_set[b_1][0].frames.length * block_random
					DrawImage(VOXEL_BLOCK.tile_set[b_1][toft + 1], x + toft_x,y + toft_y, f)
					
					f = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
					DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 2], x + toft_x,y + toft_y, f)
				EndIf
			Case 4
				' diag
				Local f:Int = VOXEL_BLOCK.tile_set[b_0][0].frames.length * block_random
				DrawImage(VOXEL_BLOCK.tile_set[b_0][toft + 0], x + toft_x,y + toft_y, f)
			Case 5
				' diag + up
				If b_1 = b_0 Then
					Local f:Int = VOXEL_BLOCK.tile_set[b_1][0].frames.length * block_random
					DrawImage(VOXEL_BLOCK.tile_set[b_1][toft + 1], x + toft_x,y + toft_y, f)
				ElseIf importance[b_1] > importance[b_0] Then
					Local f:Int = VOXEL_BLOCK.tile_set[b_0][0].frames.length * block_random
					DrawImage(VOXEL_BLOCK.tile_set[b_0][toft + 0], x + toft_x,y + toft_y, f)
					
					f = VOXEL_BLOCK.tile_set[b_1][0].frames.length * block_random
					DrawImage(VOXEL_BLOCK.tile_set[b_1][toft + 1], x + toft_x,y + toft_y, f)
				Else
					Local f:Int = VOXEL_BLOCK.tile_set[b_1][0].frames.length * block_random
					DrawImage(VOXEL_BLOCK.tile_set[b_1][toft + 1], x + toft_x,y + toft_y, f)
					
					f = VOXEL_BLOCK.tile_set[b_0][0].frames.length * block_random
					DrawImage(VOXEL_BLOCK.tile_set[b_0][toft + 0], x + toft_x,y + toft_y, f)
				EndIf
			Case 6
				' diag + left
				If b_2 = b_0 Then
					Local f:Int = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
					DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 2], x + toft_x,y + toft_y, f)
				ElseIf importance[b_2] > importance[b_0] Then
					Local f:Int = VOXEL_BLOCK.tile_set[b_0][0].frames.length * block_random
					DrawImage(VOXEL_BLOCK.tile_set[b_0][toft + 0], x + toft_x,y + toft_y, f)
					
					f = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
					DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 2], x + toft_x,y + toft_y, f)
				Else
					Local f:Int = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
					DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 2], x + toft_x,y + toft_y, f)
					
					f = VOXEL_BLOCK.tile_set[b_0][0].frames.length * block_random
					DrawImage(VOXEL_BLOCK.tile_set[b_0][toft + 0], x + toft_x,y + toft_y, f)
				EndIf

			Case 7
				' all
				If importance[b_0] >= importance[b_1] Then
					' 0 >= 1
					If importance[b_1] >= importance[b_2] Then
						' 0 >= 1 >= 2
						If importance[b_0] > importance[b_1] Then
							' 0 > 1 >= 2
							If importance[b_1] > importance[b_2] Then
								' 0 > 1 > 2
								Local f:Int = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
								DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 2], x + toft_x,y + toft_y, f)
								
								f = VOXEL_BLOCK.tile_set[b_1][0].frames.length * block_random
								DrawImage(VOXEL_BLOCK.tile_set[b_1][toft + 1], x + toft_x,y + toft_y, f)
								
								f = VOXEL_BLOCK.tile_set[b_0][0].frames.length * block_random
								DrawImage(VOXEL_BLOCK.tile_set[b_0][toft + 0], x + toft_x,y + toft_y, f)
							Else
								' 0 > 1 = 2
								Local f:Int = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
								DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 3], x + toft_x,y + toft_y, f)
								
								f = VOXEL_BLOCK.tile_set[b_0][0].frames.length * block_random
								DrawImage(VOXEL_BLOCK.tile_set[b_0][toft + 0], x + toft_x,y + toft_y, f)
							EndIf
						Else
							' 0 = 1 >= 2
							If importance[b_1] > importance[b_2] Then
								' 0 = 1 > 2
								Local f:Int = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
								DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 2], x + toft_x,y + toft_y, f)
								
								f = VOXEL_BLOCK.tile_set[b_1][0].frames.length * block_random
								DrawImage(VOXEL_BLOCK.tile_set[b_1][toft + 1], x + toft_x,y + toft_y, f)
							Else
								' 0 = 1 = 2
								Local f:Int = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
								DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 3], x + toft_x,y + toft_y, f)
							EndIf
						EndIf
					ElseIf importance[b_0] >= importance[b_2] Then
						' 0 >= 2 > 1
						If importance[b_0] > importance[b_2] Then
							' 0 > 2 > 1
							Local f:Int = VOXEL_BLOCK.tile_set[b_1][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_1][toft + 1], x + toft_x,y + toft_y, f)
							
							f = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 2], x + toft_x,y + toft_y, f)
							
							f = VOXEL_BLOCK.tile_set[b_0][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_0][toft + 0], x + toft_x,y + toft_y, f)
						Else
							' 0 = 2 > 1
							Local f:Int = VOXEL_BLOCK.tile_set[b_1][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_1][toft + 1], x + toft_x,y + toft_y, f)
							
							f = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 2], x + toft_x,y + toft_y, f)
						EndIf
					Else
						' 2 > 0 >= 1
						If importance[b_0] > importance[b_1] Then
							' 2 > 0 > 1
							Local f:Int = VOXEL_BLOCK.tile_set[b_1][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_1][toft + 1], x + toft_x,y + toft_y, f)
							
							f = VOXEL_BLOCK.tile_set[b_0][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_0][toft + 0], x + toft_x,y + toft_y, f)
							
							f = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 2], x + toft_x,y + toft_y, f)
						Else
							' 2 > 0 = 1
							Local f:Int = VOXEL_BLOCK.tile_set[b_1][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_1][toft + 1], x + toft_x,y + toft_y, f)
														
							f = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 2], x + toft_x,y + toft_y, f)
						EndIf
					EndIf
				Else
					' 1 > 0
					If importance[b_0] >= importance[b_2] Then
						' 1 > 0 >= 2
						If importance[b_0] > importance[b_2] Then
							' 1 > 0 > 2
							Local f:Int = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 2], x + toft_x,y + toft_y, f)
							
							f = VOXEL_BLOCK.tile_set[b_0][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_0][toft + 0], x + toft_x,y + toft_y, f)
							
							f = VOXEL_BLOCK.tile_set[b_1][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_1][toft + 1], x + toft_x,y + toft_y, f)
						Else
							' 1 > 0 = 2
							Local f:Int = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 2], x + toft_x,y + toft_y, f)
							
							f = VOXEL_BLOCK.tile_set[b_1][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_1][toft + 1], x + toft_x,y + toft_y, f)

						EndIf
					ElseIf importance[b_1] >= importance[b_2] Then
						' 1 >= 2 > 0
						If importance[b_1] > importance[b_2] Then
							' 1 > 2 > 0
							Local f:Int = VOXEL_BLOCK.tile_set[b_0][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_0][toft + 0], x + toft_x,y + toft_y, f)
							
							f = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 2], x + toft_x,y + toft_y, f)
							
							f = VOXEL_BLOCK.tile_set[b_1][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_1][toft + 1], x + toft_x,y + toft_y, f)
						Else
							' 1 = 2 > 0
							Local f:Int = VOXEL_BLOCK.tile_set[b_0][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_0][toft + 0], x + toft_x,y + toft_y, f)
							
							f = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
							DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 3], x + toft_x,y + toft_y, f)
						EndIf
					Else
						' 2 > 1 > 0
						Local f:Int = VOXEL_BLOCK.tile_set[b_0][0].frames.length * block_random
						DrawImage(VOXEL_BLOCK.tile_set[b_0][toft + 0], x + toft_x,y + toft_y, f)
						
						f = VOXEL_BLOCK.tile_set[b_1][0].frames.length * block_random
						DrawImage(VOXEL_BLOCK.tile_set[b_1][toft + 1], x + toft_x,y + toft_y, f)
						
						f = VOXEL_BLOCK.tile_set[b_2][0].frames.length * block_random
						DrawImage(VOXEL_BLOCK.tile_set[b_2][toft + 2], x + toft_x,y + toft_y, f)
					EndIf
				EndIf
			Default
				Print("fail :" + choice)
				End
		End Select
		
	End Function
	
	
	Function draw_shadow(grid:VOXEL_GRID, x:Int,y:Int, blk_neighbours:Int[,], x_off:Int, y_off:Int, pos_x:Int, pos_y:Int)' draw at x,y
		
		Local b:Int = blk_neighbours[1 + x_off,1 + y_off]
		
		If covers_block[b] Then Return
		
		' ------------------------------------------------------------ top left
		Local b_0:Int = gives_shadow[blk_neighbours[1 + x_off - 1,1 + y_off - 1]] ' diag
		Local b_1:Int = gives_shadow[blk_neighbours[1 + x_off,1 + y_off - 1]] ' up
		Local b_2:Int = gives_shadow[blk_neighbours[1 + x_off - 1,1 + y_off]] ' left
		
		draw_shadow_sub(1, 0, 0,  b_0, b_1, b_2, x,y) ' all ok
		
		' ------------------------------------------------------------ top right
		b_0 = gives_shadow[blk_neighbours[1 + x_off + 1,1 + y_off - 1]] ' diag
		b_1 = gives_shadow[blk_neighbours[1 + x_off,1 + y_off - 1]] ' up
		b_2 = gives_shadow[blk_neighbours[1 + x_off + 1,1 + y_off]] ' right
		
		draw_shadow_sub(5, grid.block_size/2, 0,  b_0, b_1, b_2, x,y)
		
		' ------------------------------------------------------------ bottom left
		b_0 = gives_shadow[blk_neighbours[1 + x_off - 1,1 + y_off + 1]] ' diag
		b_1 = gives_shadow[blk_neighbours[1 + x_off - 1,1 + y_off]] ' left
		b_2 = gives_shadow[blk_neighbours[1 + x_off,1 + y_off + 1]] ' down
		
		draw_shadow_sub(9, 0, grid.block_size/2,  b_0, b_1, b_2,  x,y)

		' ------------------------------------------------------------ bottom right
		b_0 = gives_shadow[blk_neighbours[1 + x_off + 1,1 + y_off + 1]] ' diag
		b_1 = gives_shadow[blk_neighbours[1 + x_off + 1,1 + y_off]] ' right
		b_2 = gives_shadow[blk_neighbours[1 + x_off,1 + y_off + 1]] ' down
		
		draw_shadow_sub(13, grid.block_size/2, grid.block_size/2,  b_0, b_1, b_2,  x,y)
	End Function
	
	Function draw_shadow_sub(toft:Int, toft_x:Int, toft_y:Int,   b_0:Int, b_1:Int, b_2:Int,  x:Int,y:Int)	
		' all names according to top left !
		Local choice:Int = b_1 + 2*b_2 + 4*b_0
		
		Select choice
			Case 0
				' nothing
			Case 1
				' up
				DrawImage(VOXEL_BLOCK.tile_shadow[toft + 1], x + toft_x,y + toft_y)
			Case 2
				' left
				DrawImage(VOXEL_BLOCK.tile_shadow[toft + 2], x + toft_x,y + toft_y)
			Case 3
				' up + left
				DrawImage(VOXEL_BLOCK.tile_shadow[toft + 3], x + toft_x,y + toft_y)
			Case 4
				' diag
				DrawImage(VOXEL_BLOCK.tile_shadow[toft + 0], x + toft_x,y + toft_y)
			Case 5
				' diag + up
				DrawImage(VOXEL_BLOCK.tile_shadow[toft + 1], x + toft_x,y + toft_y)
			Case 6
				' diag + left
				DrawImage(VOXEL_BLOCK.tile_shadow[toft + 2], x + toft_x,y + toft_y)
			Case 7
				' all
				DrawImage(VOXEL_BLOCK.tile_shadow[toft + 3], x + toft_x,y + toft_y)
			Default
				Print("fail :" + choice)
				End
		End Select
		
	End Function

End Type
'----------------------------------------------------------------------------------------
'---------------------------                    -----------------------------------------
'---------------------------       Object       -----------------------------------------
'---------------------------                    -----------------------------------------
'----------------------------------------------------------------------------------------
Type OBJECT_KEY
	Field id:Int
	
	Function Create:OBJECT_KEY(id:Int)
		Local k:OBJECT_KEY = New OBJECT_KEY
		
		k.id = id
		
		Return k
	End Function
	
	Method Compare:Int(other:Object)
		Local o2:OBJECT_KEY = OBJECT_KEY(other)
		
		If o2 = Null Then Return Super.Compare(other)
		
		If o2.id < id Then Return -1
		If o2.id > id Then Return 1
		
		Return 0
	End Method
End Type



Type TOBJECT
	Global id_counter:Int = 0
	Function get_next_id:Int()
		id_counter:+1
		Return id_counter
	End Function
	
	Field id:Int ' only set by server !
	Field owner:Int ' see network manager
	
	Field last_update:Int = MilliSecs()' relevant for networking.
	Const keep_time:Int = 5000
	
	Field typ:Int = -1
	Const TYPE_PLAYER:Int = 1 ' add them also for reading from stream !
	Const TYPE_NPS:Int = 2
	Const TYPE_CHEST:Int = 3
	Const TYPE_ITEM_DROP:Int = 4
	
	Field super_grid:VOXEL_SUPER_GRID
	
	Field x:Float ' position
	Field y:Float
	
	Field vx:Float ' speed
	Field vy:Float
	
	Field rx:Float ' size
	Field ry:Float
	
	Field to_be_removed:Byte = False
	Field to_be_removed_timer:Int = 0
	
	Field coll_r:Int = 0
	Field coll_l:Int = 0
	Field coll_ground:Int = 0
	Field coll_up:Int = 0
	
	Method remove(netw_man:NETWORK_MANAGER)
		Select netw_man.mode
			Case NETWORK_MANAGER.CLIENT
				super_grid.object_map.Remove( OBJECT_KEY.Create(id) )
			Case NETWORK_MANAGER.SERVER
				to_be_removed = True
				If to_be_removed_timer = 0 Then to_be_removed_timer = MilliSecs() + 15000
			Default
				RuntimeError("mode not implemented (remove object)")
		End Select
	End Method
	
	Method render(netw_man:NETWORK_MANAGER)
		If to_be_removed Then
			
			Select netw_man.mode
				Case NETWORK_MANAGER.CLIENT
					super_grid.object_map.Remove( OBJECT_KEY.Create(id) )
				Case NETWORK_MANAGER.SERVER
					If to_be_removed_timer < MilliSecs() Then
						super_grid.object_map.Remove( OBJECT_KEY.Create(id) )
					EndIf
				Default
					RuntimeError("mode not implemented (remove object)")
			End Select
		EndIf
	End Method
	
	Method draw(grid:VOXEL_GRID)
		Rem
		SetColor 0,0,0
		EFONT.draw(owner,grid.view_x + Self.x, grid.view_y + Self.y,2)
		End Rem
	End Method
	
	Method render_collision()
			' the following is old collision code from the "DINKO PROJECT"
			
			coll_r= 0
			coll_l= 0
			coll_ground= 0
			coll_up= 0
			
			'---------------- ground + andti wall climber
			If Ceil((Self.y + Self.ry)/VOXEL_GRID.block_size) < Ceil((Self.y+Self.ry + Self.vy)/VOXEL_GRID.block_size) Then
				'going one down
				
				If Ceil((Self.x + Self.rx)/VOXEL_GRID.block_size) < Ceil((Self.x+Self.rx + Self.vx)/VOXEL_GRID.block_size) Then
					'going one to the right
					
					Local iy:Int = Ceil((Self.y+Self.ry  + Self.vy)/VOXEL_GRID.block_size)-1
					Local ix:Int = Ceil((Self.x+Self.rx)/VOXEL_GRID.block_size)
					If super_grid.grid.has_collision(ix, iy) And super_grid.grid.has_collision(ix, iy - 1) Then
						Self.vx = (Ceil((Self.x+Self.rx)/VOXEL_GRID.block_size)*VOXEL_GRID.block_size) - (Self.x+Self.rx)
						
						If Self.vx = 0 Then Self.coll_r = 1
					End If
					
				End If
				
				If Floor((Self.x - Self.rx)/VOXEL_GRID.block_size) > Floor((Self.x - Self.rx + Self.vx)/VOXEL_GRID.block_size) Then
					'going one to the left
					
					
					Local iy:Int = Ceil((Self.y+Self.ry + Self.vy)/VOXEL_GRID.block_size)-1
					Local ix:Int = Floor((Self.x-Self.rx)/VOXEL_GRID.block_size) - 1
					If super_grid.grid.has_collision(ix, iy) And super_grid.grid.has_collision(ix, iy - 1) Then
						Self.vx = (Floor((Self.x-Self.rx)/VOXEL_GRID.block_size)*VOXEL_GRID.block_size) - (Self.x-Self.rx)
						If Self.vx = 0 Then Self.coll_l = 1
					End If
					
				End If
				
				
				'---------------- ground:
				'you have just entered a new row of blocks!
				
				'muss +vx haben, damit keine st�runen wenn genau auf ecke des blockes f�llt
				For Local ix:Int = Floor((Self.x - Self.rx + Self.vx)/VOXEL_GRID.block_size) To Ceil((Self.x+Self.rx + Self.vx)/VOXEL_GRID.block_size)-1
					If super_grid.grid.has_collision(ix,Ceil((Self.y+Self.ry)/VOXEL_GRID.block_size)) Then
						Self.vy = (Ceil((Self.y+Self.ry)/VOXEL_GRID.block_size)*VOXEL_GRID.block_size) - (Self.y+Self.ry)
						
						If Self.vy = 0 Then Self.coll_ground = 1
					End If
				Next
				
			End If
			
			
			
			'---------------- top + andti wall stop jumping
			If Floor((Self.y - Self.ry)/VOXEL_GRID.block_size) > Floor((Self.y - Self.ry + Self.vy)/VOXEL_GRID.block_size) Then
				'going one up
				
				
				If Ceil((Self.x + Self.rx)/VOXEL_GRID.block_size) < Ceil((Self.x+Self.rx + Self.vx)/VOXEL_GRID.block_size) Then
					'going one to the right
					
					Local iy:Int = Floor((Self.y - Self.ry)/VOXEL_GRID.block_size)
					Local ix:Int = Ceil((Self.x+Self.rx)/VOXEL_GRID.block_size)
					If super_grid.grid.has_collision(ix, iy) And super_grid.grid.has_collision(ix, iy - 1) Then
						Self.vx = (Ceil((Self.x+Self.rx)/VOXEL_GRID.block_size)*VOXEL_GRID.block_size) - (Self.x+Self.rx)
						
						If Self.vx = 0 Then Self.coll_r = 1
					End If
					
				End If
				
				If Floor((Self.x - Self.rx)/VOXEL_GRID.block_size) > Floor((Self.x - Self.rx + Self.vx)/VOXEL_GRID.block_size) Then
					'going one to the left
					
					
					Local iy:Int = Floor((Self.y - Self.ry)/VOXEL_GRID.block_size)
					Local ix:Int = Floor((Self.x-Self.rx)/VOXEL_GRID.block_size) - 1
					If super_grid.grid.has_collision(ix, iy) And super_grid.grid.has_collision(ix, iy - 1) Then
						Self.vx = (Floor((Self.x-Self.rx)/VOXEL_GRID.block_size)*VOXEL_GRID.block_size) - (Self.x-Self.rx)
						If Self.vx = 0 Then Self.coll_l = 1
					End If
					
				End If
				
				
				'---------------- top:
				'you have just entered a new row of blocks!
				
				For Local ix:Int = Floor((Self.x - Self.rx + Self.vx)/VOXEL_GRID.block_size) To Ceil((Self.x+Self.rx + Self.vx)/VOXEL_GRID.block_size)-1
					If super_grid.grid.has_collision(ix, Floor((Self.y-Self.ry)/VOXEL_GRID.block_size) - 1) Then
						Self.vy = (Floor((Self.y-Self.ry)/VOXEL_GRID.block_size)*VOXEL_GRID.block_size) - (Self.y-Self.ry)
						If Self.vy = 0 Then Self.coll_up = 1
					End If
				Next
			End If
			
			
			'---------------- r:
			If Ceil((Self.x + Self.rx)/VOXEL_GRID.block_size) < Ceil((Self.x+Self.rx + Self.vx)/VOXEL_GRID.block_size) Then
				'you have just entered a new row of blocks!
				
				For Local iy:Int = Floor((Self.y - Self.ry  + Self.vy)/VOXEL_GRID.block_size) To Ceil((Self.y+Self.ry  + Self.vy)/VOXEL_GRID.block_size)-1
					If super_grid.grid.has_collision(Ceil((Self.x+Self.rx)/VOXEL_GRID.block_size), iy) Then
						Self.vx = (Ceil((Self.x+Self.rx)/VOXEL_GRID.block_size)*VOXEL_GRID.block_size) - (Self.x+Self.rx)
						
						If Self.vx = 0 Then Self.coll_r = 1
					End If
				Next
			End If
			
			'---------------- l:
			If Floor((Self.x - Self.rx)/VOXEL_GRID.block_size) > Floor((Self.x - Self.rx + Self.vx)/VOXEL_GRID.block_size) Then
				'you have just entered a new row of blocks!
				
				For Local iy:Int = Floor((Self.y - Self.ry + Self.vy)/VOXEL_GRID.block_size) To Ceil((Self.y+Self.ry + Self.vy)/VOXEL_GRID.block_size)-1
					If super_grid.grid.has_collision(Floor((Self.x-Self.rx)/VOXEL_GRID.block_size) - 1, iy) Then
						Self.vx = (Floor((Self.x-Self.rx)/VOXEL_GRID.block_size)*VOXEL_GRID.block_size) - (Self.x-Self.rx)
						If Self.vx = 0 Then Self.coll_l = 1
					End If
				Next
			End If
		
	End Method
	
	Method get_super_chunks(diameter:Int, x1:Int Var, x2:Int Var, y1:Int Var, y2:Int Var)
		Local sc_size:Int = super_grid.super_chunk_size_blocks*VOXEL_GRID.block_size
		
		If (diameter Mod 2) = 1 Then
			x1 = (Self.x/sc_size) - (diameter/2)
			x2 = x1+diameter-1
			
			y1 = (Self.y/sc_size) - (diameter/2)
			y2 = y1+diameter-1
		Else
			x1 = ((Self.x+sc_size/2)/sc_size) - (diameter/2)
			x2 = x1+diameter-1
			
			y1 = ((Self.y+sc_size/2)/sc_size) - (diameter/2)
			y2 = y1+diameter-1
		EndIf
	End Method
	
	' -------------------------------------------------------------------- NETWORKING:
	Method to_stream(stream:TStream) ' only body
		stream.WriteFloat(x)
		stream.WriteFloat(y)
		stream.WriteFloat(vx)
		stream.WriteFloat(vy)
		
		stream.WriteByte(to_be_removed)
	End Method
	Method from_stream(stream:TStream) ' only body
		x = stream.ReadFloat()
		y = stream.ReadFloat()
		vx = stream.ReadFloat()
		vy = stream.ReadFloat()
		
		Local remo:Byte = stream.ReadByte()
		to_be_removed = to_be_removed Or remo
		
		last_update = MilliSecs()
	End Method
	Method from_stream_discard(stream:TStream) ' only body -> discard data.
		stream.ReadFloat()
		stream.ReadFloat()
		stream.ReadFloat()
		stream.ReadFloat()
		
		Local remo:Byte = stream.ReadByte()
		to_be_removed = to_be_removed Or remo
	End Method
	
	Function map_to_stream(map:TMap, stream:TStream, netw_man:NETWORK_MANAGER)
		
		Select netw_man.mode
			Case NETWORK_MANAGER.CLIENT
				For Local o:TOBJECT = EachIn MapValues(map)
					If o.owner = netw_man.my_id Then
						stream.WriteInt(o.id)	' HEADER
						stream.WriteInt(o.owner)
						stream.WriteInt(o.typ)
						
						o.to_stream(stream)		' BODY
					EndIf
				Next
			Case NETWORK_MANAGER.SERVER
				For Local o:TOBJECT = EachIn MapValues(map)
					stream.WriteInt(o.id)	' HEADER
					stream.WriteInt(o.owner)
					stream.WriteInt(o.typ)
					
					o.to_stream(stream)		' BODY
				Next
			Default
				RuntimeError("not implemented !")
		End Select
		
		stream.WriteInt(-1) ' finish
	End Function
	
	Function stream_to_map(map:TMap, stream:TStream, netw_man:NETWORK_MANAGER, super_grid:VOXEL_SUPER_GRID)
		Repeat
			Local rcv_id:Int = stream.ReadInt()
			
			If rcv_id = -1 Then ' finish
				Return
			EndIf
			
			Local rcv_owner:Int = stream.ReadInt()
			Local rcv_typ:Int = stream.ReadInt()
			
			Local key:OBJECT_KEY = OBJECT_KEY.Create(rcv_id)
			Local o:TOBJECT = TOBJECT(map.ValueForKey(key))
			
			If rcv_owner = 0 Then
				RuntimeError("object typ 0 invalid !")
			EndIf
			
			Select netw_man.mode
				Case NETWORK_MANAGER.CLIENT
					If o Then
						If rcv_owner = netw_man.my_id Then
							' my object -> ignore.
							o.from_stream_discard(stream)
						Else
							' other's object
							o.from_stream(stream)
						EndIf
					Else
						If rcv_owner = netw_man.my_id Then
							' my object
							o = TOBJECT.create_from_stream(map, stream, rcv_id, rcv_owner, rcv_typ, super_grid)
							map.Insert(key, o)
						Else
							' other's object
							o = TOBJECT.create_from_stream(map, stream, rcv_id, rcv_owner, rcv_typ, super_grid)
							map.Insert(key, o)
						EndIf
					EndIf
				Case NETWORK_MANAGER.SERVER
					If o Then
						If rcv_owner = netw_man.my_id Then
							' my object -> how dare you?
							RuntimeError(" someone tried to change my objects !")
							'o.from_stream_discard(stream)
						Else
							' other's object
							o.from_stream(stream)
						EndIf
					Else
						RuntimeError("server only creates objects himself !")
					EndIf
				Default
					RuntimeError("not implemented !")
			End Select
			
		Forever
	End Function
	
	Function create_from_stream:TOBJECT(map:TMap, stream:TStream, id:Int, owner:Int, typ:Int, super_grid:VOXEL_SUPER_GRID)
		Select typ
			Case TOBJECT.TYPE_PLAYER
				
				Local p:TPLAYER = TPLAYER.Create(0,0, super_grid, owner, Null, id, stream)
				
				If p And super_grid And super_grid.universe.netw_man.my_id = owner And super_grid.universe.netw_man.mode = NETWORK_MANAGER.CLIENT Then
					super_grid.universe.netw_man.client_connector.player = p
				EndIf
				
				Return p
			Case TOBJECT.TYPE_NPS
				Local p:T_NPC = T_NPC.Create(0,0, super_grid, owner, id, stream)
								
				Return p
			Case TOBJECT.TYPE_CHEST
				Local p:T_CHEST = T_CHEST.Create(0,0, 0,0, super_grid, owner, id, stream)
				
				Return p
			Case TOBJECT.TYPE_ITEM_DROP
				Local p:TITEM_DROP = TITEM_DROP.Create(0,0, 0,1, New Int[0], super_grid, owner, id, stream)
				
				Return p
			Default
				RuntimeError("not implemented")
		End Select
	End Function
End Type



Type TITEM_DROP Extends TOBJECT
	Field item_kind:Int
	Field item_amount:Int
	Field item_info:Int[]
	
	Field claimed_for:Int ' player id
	
	Function Create:TITEM_DROP(x:Float,y:Float, item_kind:Int, item_amount:Int, item_info:Int[], super_grid:VOXEL_SUPER_GRID, owner:Int, given_id:Int, stream:TStream)
		Local p:TITEM_DROP = New TITEM_DROP
		
		p.typ = TOBJECT.TYPE_ITEM_DROP
		
		p.super_grid = super_grid
		If given_id Then
			p.id = given_id
		Else
			p.id = TOBJECT.get_next_id()
		EndIf
		p.owner = owner
		
		p.x = x
		p.y = y
		
		p.vx = (Rnd()-0.5)*3.0
		p.vy = (Rnd()-0.5)*3.0
		
		p.rx = 10
		p.ry = 10
		
		p.item_kind = item_kind
		p.item_amount = item_amount
		p.item_info = item_info
		
		p.claimed_for = -1
		
		If stream Then
			p.from_stream(stream)
		EndIf
		
		If p.to_be_removed Then Return Null
		
		Print "item kind: " + p.item_kind + " " + p.id
		
		If super_grid Then ' else we don't care about the data anyway!
			super_grid.object_map.Insert(OBJECT_KEY.Create(p.id), p)
		EndIf
		
		Return p
	End Function
	
	Method to_stream(stream:TStream) ' only body
		Super.to_stream(stream)
		
		stream.WriteInt(claimed_for)
		
		stream.WriteInt(item_kind)
		stream.WriteInt(item_amount)
		stream.WriteInt(item_info.length)
		
		For Local i:Int = 0 To item_info.length-1
			stream.WriteInt(item_info[i])
		Next
	End Method
	
	Method from_stream(stream:TStream) ' only body
		Super.from_stream(stream)
		
		claimed_for = stream.ReadInt()
		
		item_kind = stream.ReadInt()
		item_amount = stream.ReadInt()
		Local item_info_size:Int = stream.ReadInt()
		item_info = New Int[item_info_size]
		
		For Local i:Int = 0 To item_info.length-1
			item_info[i] = stream.ReadInt()
		Next
	End Method
	
	Method from_stream_discard(stream:TStream) ' only body -> discard data.
		Super.from_stream_discard(stream)
		
		stream.ReadInt()
		
		stream.ReadInt()
		stream.ReadInt()
		Local item_info_size:Int = stream.ReadInt()
		
		For Local i:Int = 0 To item_info_size-1
			stream.ReadInt()
		Next
	End Method
	
	Method render(netw_man:NETWORK_MANAGER)
		Super.render(netw_man)
		
		' ------    physics and other stuff
		
		vx = vx*0.8
		vy = vy*0.99 + 0.6
		render_collision()
		
		If coll_ground Then vx:*0.5
		
		Self.x:+ Self.vx
		Self.y:+ Self.vy
		
		' --------- see if being picked up
		
		For Local player:TPLAYER = EachIn MapValues(super_grid.object_map) ' maybe have extra player list for efficiency ?
			Local d_x:Float = player.x - Self.x
			Local d_y:Float = player.y - Self.y
			Local dist_2:Float = (d_x*d_x + d_y*d_y)
			
			If dist_2 < 40000 Then ' 200
				vx:+d_x/dist_2*200.0
				vy:+d_y/dist_2*200.0
				
				If dist_2 < 400 And claimed_for = -1 Then ' 20
					'claim it !
					
					Select netw_man.mode
						Case NETWORK_MANAGER.CLIENT
							'nothing...
							vx = 0 ' prevent overshoot.
							vy = 0
						Case NETWORK_MANAGER.SERVER
							claimed_for = player.id
							
							Local c:T_S_Client = T_S_Client(T_S_Client.name_map.ValueForKey(player.name))
							
							If c Then
								Local i_k_:Int = item_kind
								Local i_a_:Int = item_amount
								Local i_i_:Int[] = item_info
								c.inventory.add_item(i_k_, i_a_, i_i_)
							EndIf
							
							remove(netw_man)
					End Select
				EndIf
			EndIf
		Next
		
		
		
		If netw_man.mode = NETWORK_MANAGER.SERVER And ITEM.countable[item_kind] And (Not to_be_removed) Then
			' see if there are others alike -> unify
			
			For Local drop:TITEM_DROP = EachIn MapValues(super_grid.object_map) ' maybe have extra player list for efficiency ?
				If drop = Self Continue
				If drop.to_be_removed Then Continue
				If Not (drop.item_kind = item_kind) Then Continue
				
				Local d_x:Float = drop.x - Self.x
				Local d_y:Float = drop.y - Self.y
				Local dist_2:Float = (d_x*d_x + d_y*d_y)
				
				If dist_2 < 400 Then ' 20
					vx:+d_x/dist_2*200.0
					vy:+d_y/dist_2*200.0
					
					' merge them
					item_amount:+drop.item_amount
					
					drop.claimed_for = -3 ' invalid !
					drop.remove(netw_man)
					
					Exit
				EndIf
			Next
			
		EndIf
		
	End Method
	
	Method draw(grid:VOXEL_GRID)
		ITEM.draw_drop(item_kind, item_amount, item_info, grid.view_x + Self.x, grid.view_y + Self.y)
		
		Super.draw(grid)
	End Method
	
	Method remove(netw_man:NETWORK_MANAGER)
		Print "rem: " + item_kind
		Select netw_man.mode
			Case NETWORK_MANAGER.CLIENT
				' see if mine:
				
				If claimed_for = netw_man.client_connector.player.id Then
					' get the items !
					
					Local i_k_:Int = item_kind
					Local i_a_:Int = item_amount
					Local i_i_:Int[] = item_info
					netw_man.client_connector.inventory.add_item(i_k_, i_a_, i_i_)
				EndIf
			Case NETWORK_MANAGER.SERVER
				' nothing more
			Default
				RuntimeError("mode not implemented (remove object)")
		End Select
		
		Super.remove(netw_man)
	End Method
End Type


'----------------------------------------------------------------------------------------
'---------------------------                    -----------------------------------------
'---------------------------       Player       -----------------------------------------
'---------------------------                    -----------------------------------------
'----------------------------------------------------------------------------------------

Type TPLAYER Extends TOBJECT
	Field name:String
	Field draw_char:CHARACTER
	
	Field mouse_dx:Int ' character drawing stuff
	Field mouse_dy:Int
	Field arm_0_obj:Int
	Field arm_0_mode:Int
	Field arm_1_obj:Int
	Field arm_1_mode:Int
	
	Function Create:TPLAYER(x:Float,y:Float, super_grid:VOXEL_SUPER_GRID, owner:Int, name:String, given_id:Int, stream:TStream)
		Local p:TPLAYER = New TPLAYER
		
		p.typ = TOBJECT.TYPE_PLAYER
		
		p.name = name
		
		p.super_grid = super_grid
		If given_id Then
			p.id = given_id
		Else
			p.id = TOBJECT.get_next_id()
		EndIf
		p.owner = owner
		
		p.x = x
		p.y = y
		
		p.rx = 20
		p.ry = 43
		
		If stream Then
			p.from_stream(stream)
		EndIf
		
		If p.to_be_removed Then Return Null
		
		If super_grid Then ' else we don't care about the data anyway!
			super_grid.object_map.Insert(OBJECT_KEY.Create(p.id), p)
		EndIf
		
		p.draw_char = CHARACTER.Create(CHARACTER_IMG.NORMAL)
		
		Return p
	End Function
	
	Field control_style:Int = 0
	Field key_down_left:Int = False
	Field key_down_right:Int = False
	Field key_down_up:Int = False
	Field key_down_down:Int = False
	Field key_down_lshift:Int = False
	Field key_down_q:Int = False
	
	Method to_stream(stream:TStream) ' only body
		Super.to_stream(stream)
		
		stream.WriteByte(control_style)
		stream.WriteByte(key_down_left)
		stream.WriteByte(key_down_right)
		stream.WriteByte(key_down_up)
		stream.WriteByte(key_down_down)
		stream.WriteByte(key_down_lshift)
		stream.WriteByte(key_down_q)
		
		stream.WriteInt(Len(name))
		stream.WriteString(name)
		
		stream.WriteInt(mouse_dx) ' character
		stream.WriteInt(mouse_dy)
		stream.WriteInt(arm_0_obj)
		stream.WriteInt(arm_0_mode)
		stream.WriteInt(arm_1_obj)
		stream.WriteInt(arm_1_mode)
	End Method
	Method from_stream(stream:TStream) ' only body
		Super.from_stream(stream)
		
		control_style = stream.ReadByte()
		key_down_left = stream.ReadByte()
		key_down_right = stream.ReadByte()
		key_down_up = stream.ReadByte()
		key_down_down = stream.ReadByte()
		key_down_lshift = stream.ReadByte()
		key_down_q = stream.ReadByte()
		
		Local name_size:Int = stream.ReadInt()
		name = stream.ReadString(name_size)
		
		mouse_dx = stream.ReadInt()' character
		mouse_dy = stream.ReadInt()
		arm_0_obj = stream.ReadInt()
		arm_0_mode = stream.ReadInt()
		arm_1_obj = stream.ReadInt()
		arm_1_mode = stream.ReadInt()
	End Method
	Method from_stream_discard(stream:TStream) ' only body -> discard data.
		Super.from_stream_discard(stream)
		
		stream.ReadByte()
		stream.ReadByte()
		stream.ReadByte()
		stream.ReadByte()
		stream.ReadByte()
		stream.ReadByte()
		stream.ReadByte()
		
		Local name_size:Int = stream.ReadInt()
		stream.ReadString(name_size)
		
		stream.ReadInt()' character
		stream.ReadInt()
		stream.ReadInt()
		stream.ReadInt()
		stream.ReadInt()
		stream.ReadInt()
	End Method
	
	
	Method render(netw_man:NETWORK_MANAGER)
		Super.render(netw_man)
		' ------------------------------------------------ controls and stuff
		If owner = netw_man.my_id Then
			key_down_left = KInput.Kleft.down
			key_down_right = KInput.Kright.down
			key_down_up = KInput.Kup.down
			key_down_down = KInput.Kdown.down
			key_down_lshift = KInput.Klshift.down
			key_down_q = KInput.Kq.down
			
			If KeyHit(KEY_F12) Then control_style = Not control_style
			
			If control_style Then
				vx:+ key_down_right*5.0 - key_down_left*5.0
				vy:+ key_down_down*5.0 - key_down_up*5.0
			Else
				If (coll_r Or coll_l) And vy>0 And key_down_lshift Then vy:*0.1
				
				vx:+ key_down_right*2.0 - key_down_left*2.0
				vy:- (KInput.Kup.hit And (coll_ground Or coll_r Or coll_l))*20.0 + 2.4*key_down_q
			EndIf
						
			mouse_dx = MouseX()-  (super_grid.grid.view_x + Self.x)
			mouse_dy = MouseY()-  (super_grid.grid.view_y + Self.y)
			
			If netw_man.mode = NETWORK_MANAGER.CLIENT And super_grid.universe.gui.top_bar Then
				arm_0_obj = 0
				arm_0_mode = 0
				arm_1_obj = 0
				arm_1_mode = 0
				
				If True Then
					Local slot:EG_ITEM_SLOT = super_grid.universe.gui.top_bar.slot_left
					Local item_kind:Int = slot.item_array.array_kind[slot.index]
					
					If item_kind > -1 And ITEM.typ[item_kind] = ITEM.TYPE_TOOL_DIGGING Then	
						arm_1_obj = ITEM.get_dig_tool_nr(item_kind)
						
						arm_1_mode = KInput.M1.down
					EndIf
				EndIf
				
				If True Then
					Local slot:EG_ITEM_SLOT = super_grid.universe.gui.top_bar.slot_right
					Local item_kind:Int = slot.item_array.array_kind[slot.index]
					
					If item_kind > -1 And ITEM.typ[item_kind] = ITEM.TYPE_TOOL_DIGGING Then	
						arm_0_obj = ITEM.get_dig_tool_nr(item_kind)
						
						arm_0_mode = KInput.M2.down
					EndIf
				EndIf
			EndIf
						
		Else
			' from network data:
			
			If control_style Then
				vx:+ key_down_right*5.0 - key_down_left*5.0
				vy:+ key_down_down*5.0 - key_down_up*5.0
			Else
				If (coll_r Or coll_l) And vy>0 And key_down_lshift Then vy:*0.1
				
				vx:+ key_down_right*2.0 - key_down_left*2.0
				vy:- 2.4*key_down_q
			EndIf
		EndIf
		
		
		' ------------------------------------------------ physics and other stuff
		If control_style Then
			vx = vx*0.9
			vy = vy*0.9
			
			' no collision !
		Else
			
			vx = vx*0.8
			vy = vy*0.9999 + 1.2			
			render_collision()
		EndIf
		
		Self.x:+ Self.vx
		Self.y:+ Self.vy
		
		If owner = netw_man.my_id Then
			super_grid.grid.view_x_aim = -Self.x+Graphics_Handler.x*0.5
			super_grid.grid.view_y_aim = -Self.y+Graphics_Handler.y*0.5
		EndIf
		
		'VOXEL_GRID.active.prepare_raycast()
		
		'VOXEL_GRID.active.perform_raycast(Self.x, Self.y, 255,200,100, ATan2(VOXEL_GRID.active.view_y + Self.y-MouseY(), VOXEL_GRID.active.view_x + Self.x-MouseX()), 12)
	End Method
	
	Method draw(grid:VOXEL_GRID)
		Rem
		SetColor 200,100,80
		DrawRect grid.view_x + Self.x-Self.rx, grid.view_y + Self.y-Self.ry, 2*Self.rx, Self.ry
		SetColor 50,100,150
		DrawRect grid.view_x + Self.x-Self.rx, grid.view_y + Self.y, 2*Self.rx, Self.ry
		End Rem
		
		Local xres:Int = grid.view_x + Self.x
		Local yres:Int = grid.view_y + Self.y
		
		Local direction:Int = 0
		If mouse_dx < 0 Then direction = 1
		
		Local state:Int = 0
		
		If coll_ground Then
			If Abs(vx) > 0.1 Then
				state = 1
			Else
				state = 0
			EndIf
		Else
			If vy > 0 Then
				state = 3
			Else
				state = 2
			EndIf
		EndIf
		
		draw_char.draw(state, direction, HAND_OBJ.hands[arm_0_obj], arm_0_mode, HAND_OBJ.hands[arm_1_obj], arm_1_mode, xres,yres-3, 3, mouse_dx, mouse_dy)
		
		SetColor 30,30,30
		EFONT.draw(name, grid.view_x + Self.x - TextWidth(name)/2+1, grid.view_y + Self.y-Self.ry - 17+2,2)
		SetColor 200,200,200
		EFONT.draw(name, grid.view_x + Self.x - TextWidth(name)/2, grid.view_y + Self.y-Self.ry - 17,2)
		
		grid.set_light_pixel(Self.x, Self.y, 2000, 1000, 0)
		
		Super.draw(grid)
	End Method

End Type


'----------------------------------------------------------------------------------------
'---------------------------                    -----------------------------------------
'---------------------------    Simple  NPC     -----------------------------------------
'---------------------------                    -----------------------------------------
'----------------------------------------------------------------------------------------
Type T_NPC Extends TOBJECT
	Function Create:T_NPC(x:Float,y:Float, super_grid:VOXEL_SUPER_GRID, owner:Int, given_id:Int, stream:TStream)
		Local p:T_NPC = New T_NPC
		
		p.typ = TOBJECT.TYPE_NPS
		
		p.super_grid = super_grid
		If given_id Then
			p.id = given_id
		Else
			p.id = TOBJECT.get_next_id()
		EndIf
		p.owner = owner
		
		p.x = x
		p.y = y
		
		p.rx = 10
		p.ry = 20
		
		If stream Then
			p.from_stream(stream)
		EndIf
		
		If p.to_be_removed Then Return Null
		
		If super_grid Then ' else we don't care about the data anyway!
			super_grid.object_map.Insert(OBJECT_KEY.Create(p.id), p)
		EndIf
		
		Return p
	End Function
			
	Method render(netw_man:NETWORK_MANAGER)
		Super.render(netw_man)
		
		' ------------------------------------------------ controls and stuff
		If owner = netw_man.my_id Then
			If coll_ground Then
				vy:-20.0
				vx:+ (Rnd()-0.5)*30.0
			EndIf
		Else
			' minimum prediction:
			If coll_ground Then
				vy:-20.0
			EndIf
		EndIf
		
		
		' ------------------------------------------------ physics and other stuff
		vx = vx*0.8' + KeyDown(KEY_D)*2.0 - KeyDown(KEY_A)*2.0
		vy = vy*0.9999 + 1.2' - (KeyHit(KEY_W) And (coll_ground Or coll_r Or coll_l))*20.0 - 2.4*KeyDown(KEY_E)
		
		render_collision()
		
		Self.x:+ Self.vx
		Self.y:+ Self.vy
	End Method
	
	Method draw(grid:VOXEL_GRID)
		SetColor 100,50,40
		DrawRect grid.view_x + Self.x-Self.rx, grid.view_y + Self.y-Self.ry, 2*Self.rx, Self.ry
		SetColor 50,200,50
		DrawRect grid.view_x + Self.x-Self.rx, grid.view_y + Self.y, 2*Self.rx, Self.ry
				
		Super.draw(grid)
	End Method

End Type


Type T_CHEST Extends TOBJECT
	Global img:TImage
	
	Function init()
		img = LoadImage("objects\chest\chest.png")
	End Function
	
	Field block_x:Int
	Field block_y:Int
	Field item_array:ITEMS_ARRAY ' fixed size: 4x4
	Field durability:Int
	Field block_object_type:Int
	
	Field has_viewer_open:Int = False ' strictly local, for gui purposes
	Field local_minig_value:Int ' starts at durability, decreases to 0
	Field local_max_mining_last_cycle:Int
	
	Method remove(netw_man:NETWORK_MANAGER)
		super_grid.block_object_map.Remove(COORD_KEY.Create(block_x, block_y))
		
		Super.remove(netw_man)
	End Method
	
	Function Create:T_CHEST(x:Float,y:Float, block_x:Int, block_y:Int, super_grid:VOXEL_SUPER_GRID, owner:Int, given_id:Int, stream:TStream)
		Local p:T_CHEST = New T_CHEST
		
		p.typ = TOBJECT.TYPE_CHEST
		
		p.super_grid = super_grid
		If given_id Then
			p.id = given_id
		Else
			p.id = TOBJECT.get_next_id()
		EndIf
		p.owner = owner
		
		p.x = x
		p.y = y
		p.block_x = block_x
		p.block_y = block_y
		
		p.rx = super_grid.grid.block_size*3
		p.ry = super_grid.grid.block_size*2
		
		p.durability = 400
		p.block_object_type = BLOCK_OBJECT_MANAGER.TYPE_CHEST
		p.local_minig_value = p.durability
		
		If stream Then
			p.from_stream(stream)
		EndIf
		
		If p.to_be_removed Then Return Null
		
		If super_grid Then ' else we don't care about the data anyway!
			super_grid.object_map.Insert(OBJECT_KEY.Create(p.id), p)
			
			' ##################### also replace info for item array below ########################
			super_grid.block_object_map.Insert(COORD_KEY.Create(p.block_x, p.block_y), p)
			' ##################### also replace info for item array below ########################
			
			' standard size: 4x4
			p.item_array = ITEMS_ARRAY.Create(16, [2, super_grid.id, -1,-1, p.id], super_grid.universe.netw_man)
		EndIf
		
		Return p
	End Function
			
	Method render(netw_man:NETWORK_MANAGER)
		Super.render(netw_man)
		
		' we might do something here
		
		If local_max_mining_last_cycle Then
			local_minig_value:-local_max_mining_last_cycle
			
			If local_minig_value <= 0 And local_minig_value > -500 Then
				Print "I die !"
				
				BLOCK_OBJECT_MANAGER.break_it_client(block_x, block_y, block_object_type, super_grid)
				
				local_minig_value = -1000 ' to protect from re-breaking too fast
			EndIf
		Else
			local_minig_value = Min(local_minig_value + 5, durability)
		EndIf
				
		local_max_mining_last_cycle = 0
	End Method
	
	Method draw(grid:VOXEL_GRID)
		If local_minig_value > 0 Then
			SetColor 255,255,255
			DrawImage img, grid.view_x + Self.x + 3.0*(Rnd()-0.5)*Float(durability-local_minig_value)/durability, grid.view_y + Self.y + 3.0*(Rnd()-0.5)*Float(durability-local_minig_value)/durability
		EndIf
		
		Super.draw(grid)
	End Method
	
	Method mine_me(dig_value:Int)
		If dig_value <= 0 Then Return
		
		local_max_mining_last_cycle = Max(local_max_mining_last_cycle, dig_value)
	End Method
	
	Method to_stream(stream:TStream) ' only body
		Super.to_stream(stream)
		
		stream.WriteInt(block_x)
		stream.WriteInt(block_y)
	End Method
	
	Method from_stream(stream:TStream) ' only body
		Super.from_stream(stream)
		
		block_x = stream.ReadInt()
		block_y = stream.ReadInt()
	End Method
	
	Method from_stream_discard(stream:TStream) ' only body -> discard data.
		Super.from_stream_discard(stream)
		
		stream.ReadInt()
		stream.ReadInt()
		
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
	
	Global font:EFONT
	
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
		
		Graphics_Handler.font = EFONT.Create("font.png", 8)
		EFONT.set_font(Graphics_Handler.font)
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
	End Function
End Type

'########################################################################################
'###########################                   ##########################################
'########################### Graphics Handler  ##########################################
'###########################                   ##########################################
'########################################################################################

Type TBuffer
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
	
	Method draw(x:Float,y:Float,scale:Float = 1.0)
		SetScale scale,-scale
		DrawImage Self.buffer_image,x,y + Self.side*scale
		SetScale 1,1
	End Method
End Type

Type TBANK_CONSTRUCTOR
	Function Create:TBank(size:Int, set_to_zero:Int = False)
		Local bank:TBank = CreateBank(size)
		
		If set_to_zero Then
			MemClear(bank.Lock(), bank.Size())
			bank.Unlock()
		EndIf
		
		Return bank
	End Function
End Type

'########################################################################################
'###########################                   ##########################################
'###########################  Keyboard Input   ##########################################
'###########################                   ##########################################
'########################################################################################
Type KInputKey
	Field key:Int
	Field hit:Int
	Field down:Int
	
	Function Create:KInputKey(key:Int)
		Local k:KInputKey = New KInputKey
		k.key = key
		
		KInput.key_list.addlast(k)
		
		Return k
	End Function
	
	Method render()
		If KeyDown(key) Then
			down = True
		Else
			down = False
		EndIf
		
		If KeyHit(key) Then
			hit = True
			down = True
		Else
			hit = False
		EndIf
	End Method
End Type

Type KInputMouse
	Field key:Int
	Field hit:Int
	Field down:Int
	
	Function Create:KInputMouse(key:Int)
		Local k:KInputMouse = New KInputMouse
		k.key = key
		
		'KInput.key_list.addlast(k)
		
		Return k
	End Function
	
	Method render()
		If MouseDown(key) Then
			down = True
		Else
			down = False
		EndIf
		
		If MouseHit(key) Then
			hit = True
			down = True
		Else
			hit = False
		EndIf
	End Method
End Type

Type KInput
	Global mode:Int = 0 ' 0 = playing, 1 = console
	Global text:String
	Global command_to_execute:String
	
	Global key_list:TList = New TList
	
	Global Kup:KInputKey = KInputKey.Create(KEY_W)
	Global Kdown:KInputKey  = KInputKey.Create(KEY_S)
	Global Kleft:KInputKey  = KInputKey.Create(KEY_A)
	Global Kright:KInputKey  = KInputKey.Create(KEY_D)
	
	Global Ktab:KInputKey  = KInputKey.Create(KEY_TAB)
	Global Ke:KInputKey  = KInputKey.Create(KEY_E)
	Global Kq:KInputKey  = KInputKey.Create(KEY_Q)
	Global Klshift:KInputKey  = KInputKey.Create(KEY_LSHIFT)
	Global KControl:KInputKey = KInputKey.Create(KEY_LCONTROL)
	
	Global Kn:KInputKey[] = [..
	KInputKey.Create(KEY_0),..
	KInputKey.Create(KEY_1),..
	KInputKey.Create(KEY_2),..
	KInputKey.Create(KEY_3),..
	KInputKey.Create(KEY_4),..
	KInputKey.Create(KEY_5),..
	KInputKey.Create(KEY_6),..
	KInputKey.Create(KEY_7),..
	KInputKey.Create(KEY_8),..
	KInputKey.Create(KEY_9)]
		
	Global M1:KInputMouse = KInputMouse.Create(1)
	Global M2:KInputMouse = KInputMouse.Create(2)
	Global MX:Int
	Global MY:Int
	
	Global M_captured:Int
	
	Function init()
		' nothing so far !
	End Function
	
	Function render(netw_man:NETWORK_MANAGER, gui:EG_BASE)
		'look at alphabet
		
		Select mode
			Case 0 ' playing
				
				For Local k:KInputKey = EachIn key_list
					k.render()
				Next
				
				MX = MouseX()
				MY = MouseY()
				
				M1.render()
				M2.render()
				
				'-------------------------------------------------------------------- GUI
				Local e:EG_MOUSE_DRAG = EG_MOUSE_DRAG.render_and_get(MX, MY, M1.down, M1.hit)
				If gui.event(e, 0,0) Then
					M1.down = 0
					M1.hit = 0
					
					M_captured = True
				Else
					M_captured = False
				EndIf
				
				If Ktab.hit Then
					If gui.event(EG_TAB.Create(), 0,0) Then
						Ktab.hit = False
					EndIf
				EndIf
				
				If KeyHit(KEY_F1) Then
					gui.event(EG_F1.Create(), 0,0)
				EndIf
				
				For Local i:Int = 0 To 9
					If Kn[i].hit Then
						If gui.event(EG_KEY_NUMBER.Create(i), 0,0) Then
							Kn[i].hit = False
						EndIf
					EndIf
				Next
				
				If KeyHit(KEY_T) Then
					mode = 1 ' change mode
					FlushKeys()
					FlushMouse()
				End If
				
			Case 1 ' console
				Local cc:Int
				Repeat
					cc = GetChar()
					
					Select cc
						Case 0
							'no character
						Case 9
							' tab
							Const tab_size:Int = 5
							Local tab_len:Int = Len(text)/tab_size+1
							
							While Len(text)<tab_len*tab_size
								text:+" "
							Wend
						Case 8, 127
							'backspace, del
							If Len(text) > 0 Then text = Mid(text, 1, Len(text)-1)
						Case 13
							'return
							
							If Len(text) > 0 Then
								command_to_execute = text
								text = ""
								
								mode = 0  ' change mode
								FlushKeys()
								FlushMouse()
								
								netw_man.console_input(command_to_execute)
							Else
								mode = 0  ' change mode
								FlushKeys()
								FlushMouse()
							EndIf

						Default
							If cc >= 32 And cc <= 126 Then
								text:+Chr(cc)
							ElseIf cc >= 128 And cc <= 255 Then
								text:+Chr(cc)
							Else
								' no character
								Print("rogue char: '" + Chr(cc) + "' -> " + cc)
							EndIf
					End Select
				Until cc = 0
				
			Default
				RuntimeError("not implemented !")
		End Select
		
	End Function
End Type



Type CONSOLE
	Field lines:String[]
	
	Field x:Int'drawing coordinates
	Field y:Int
	Field dx:Int
	Field dy:Int
	
	Const line_dy:Int = 15
	
	Function Create:CONSOLE(x:Int,y:Int,dx:Int,dy:Int)
		Local c:CONSOLE = New CONSOLE
		
		c.x = x
		c.y = y
		c.dx = dx
		c.dy = dy
		
		c.lines = [""]
		
		For Local i:Int = 1 To (c.dy/line_dy)-3
			c.put("")
		Next
		
		c.put("%o%+ - - - - - - - -   %g%WELCOME%o%   - - - - - - - - +")
		c.put("")
		
		Return c
	End Function
	
	Method put(txt:String)
		Local max_line:Int = (dy/line_dy)-3
		
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
		
		If KInput.mode Then
			SetAlpha 0.2
			SetColor 255,255,255
			Draw_Rect Self.x,Self.y,Self.dx,Self.dy
			SetAlpha 0.7
			SetColor 0,0,0
			Draw_Rect x+2,y+2,dx-4,dy-4
		EndIf
		
		SetAlpha 1.0
		
		
		For Local i:Int = 0 To lines.length-1
			SetColor 200,200,200 ' std color -> also below
			
			Local txt_ln:String = lines[i] + "%"
			Local draw_x:Int = 0
			Local current_txt:String=""
			Local draw_mode:Int=0
			
			
			For Local ii:Int = 1 To Len(txt_ln)
				If draw_mode=0 Then
					Select Mid(txt_ln,ii,1)
						Case "%"
							draw_mode=1
							
							EFONT.draw(current_txt,x+10+draw_x,y+10+i*line_dy,2)
							
							draw_x:+EFONT.get_width(current_txt,2)
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
								Case "std"
									SetColor 200,200,200 ' std color -> also above
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
		
		If KInput.mode Then
			SetColor 0,0,0
			SetAlpha 0.3
			Draw_Rect x+6,y+dy-29, dx-16, 20'x+2,y+2,dx-4,dy-4
			
			SetAlpha 1.0
			SetColor 150,150,150
			
			Local cursor:String
			
			If (MilliSecs() Mod 600)<300 Then
				cursor = "|"
			EndIf
			
			EFONT.draw(KInput.text + cursor,x+10,y+dy-25, 2)
		EndIf
	End Method
End Type

Type COMMAND
	Function disect:String[](txt:String)
		Local cmd:String[] = New String[0]
		
		Local pos:Int
		Repeat
			pos = Instr(txt," ")
			If pos > 0 Then
				cmd:+ [Mid(txt,1,pos-1)]
				txt = Mid(txt,pos+1,-1)
			EndIf
		Until pos = 0
		
		cmd:+[txt]
		
		Return cmd
	End Function
	
	Function is_cmd:String(txt:String)
		' returns "" if is not
		' returns command without / if is
		
		If Mid(txt, 1, 1) = "/" Then
			Return Mid(txt, 2, -1)
		Else
			Return ""
		EndIf
	End Function
	
	Function execute:Int(txt:String, cons:CONSOLE, netw_man:NETWORK_MANAGER, client:T_S_Client)
		' command without /
		' returns true if was processed
		' returns false if need be passed on
		
		Local cmd:String[] = disect(txt)
		
		If cmd.length = 0 Then
			cons.put("%r%<!> no command?")
			Return True
		EndIf
		
		Select cmd[0]
			Case "echo"
				cons.put("%green%echo:")
				For Local i:Int = 1 To cmd.length-1
					cons.put("%grey%  (" + i + ") '" + cmd[i] + "'")
				Next
				Return True
				
			Case "help"
				cons.put("%red%there is no help!")
				Return True
				
			Case "teleport"
				Select netw_man.mode
					Case NETWORK_MANAGER.CLIENT
						Return False
					Case NETWORK_MANAGER.SERVER
						' syntax: world, players... (also client if exists)
						If cmd.length = 1 Then
							If client Then
								client.msg_send_array.write("%r%<!> use: %o%teleport <world_id> [list: names]")
								Return True
							Else
								cons.put("%r%<!> use: %o%teleport <world_id> [list: names]")
								Return True
							EndIf
						EndIf
						
						
						' find the world:
						Local cmd_world_id:Int = Int(cmd[1])
						If cmd_world_id > 0 Then
							Local w:VOXEL_SUPER_GRID = netw_man.universe.find_world_if_loaded(cmd_world_id)
							
							If Not w Then
								' see if on disk:
								If netw_man.universe.see_if_world_on_disk(cmd_world_id) Then
									Print("-> not loaded, but on disk")
									w = netw_man.universe.find_world_or_load(cmd_world_id)
								EndIf
							Else
								Print("-> already loaded")
							EndIf
							
							If w Then
								Local client_list:TList = New TList
								Local complaint_list:String = ""
								
								If client And cmd.length = 2 Then
									client_list.addlast(client)
								EndIf
								
								For Local i:Int=2 To cmd.length-1
									
									Local c:T_S_Client = T_S_Client(T_S_Client.name_map.ValueForKey(cmd[i]))
									If c Then
										client_list.addlast(c)
									Else
										complaint_list:+ cmd[i] + "; "
									EndIf
									
								Next
								
								If complaint_list<>"" Then
									If client Then
										client.msg_send_array.write("%r%<!> not found: " + complaint_list)
									Else
										cons.put("%r%<!> not found: " + complaint_list)
									EndIf
								EndIf
								
								For Local c:T_S_Client = EachIn client_list
									c.teleport(w)
								Next
								
								If client Then
									client.msg_send_array.write("%green%<!> teleport send " + client_list.Count() + " Player(s)")
									Return True
								Else
									cons.put("%green%<!> teleport send " + client_list.Count() + " Player(s)")
									Return True
								EndIf
							Else
								If client Then
									client.msg_send_array.write("%r%<!> teleport: world no found: " + cmd_world_id)
									Return True
								Else
									cons.put("%r%<!> teleport: world no found: " + cmd_world_id)
									Return True
								EndIf

							EndIf
						EndIf
						
						Return True
					Default
						RuntimeError("cmd exec -> mode not implemented")
				End Select
			Case "teleport_world"
				If Not (netw_man.mode = NETWORK_MANAGER.CLIENT) Or cmd.length <> 2 Then
					cons.put("%r% someone tried to teleport_world you !?!")
					Return True
				EndIf
				
				Local new_world_id:Int = Int(cmd[1])
				cons.put("%g% teleporting: " + new_world_id)
				
				netw_man.client_connector.new_world_id = new_world_id
				Return True
			Default
				cons.put("%r%<!> do not know command:")
				cons.put("  %r%'%o%" + txt + "%r%'")
				Return True
		End Select
	End Function
End Type

'##########################################################################################
'###############################      END OF TYPES         ################################
'##########################################################################################
'###############################          MAIN             ################################
'##########################################################################################

Type GAME
	'------------------------------------- content
	Field universe:VOXEL_UNIVERSE
	Field netw_man:NETWORK_MANAGER
	
	'------------------------------------- functions / methods
	Function run(universe:VOXEL_UNIVERSE, netw_man:NETWORK_MANAGER)
		Local g:GAME = New GAME
		
		g.universe = universe
		g.netw_man = netw_man
		
		Repeat
			KInput.render(netw_man, g.universe.gui)
			
			g.netw_man.update()
			
			g.universe.render()
			
			SetClsColor(200,255,255)
			Cls
			
			g.universe.draw()
			
			EG_MOUSE_DRAG.draw_drag(KInput.MX, KInput.MY)
			
			
			SetScale 2,2
			SetColor 255,255,255
			DrawImage EG_GRAPHICS.currsor, KInput.MX, KInput.MY
			SetScale 1,1
			
			Flip
			
		Until KeyHit(KEY_ESCAPE)
	End Function 
	
End Type

Type FPS_AND_DATA
	Global last_ps:Int = MilliSecs()
	Global fps:Int = 0
	Global fps_sum:Int = 0
	
	Function draw(x:Int,y:Int)
		fps_sum:+1
		
		If last_ps+1000 < MilliSecs() Then
			last_ps = MilliSecs()
			
			fps = fps_sum
			fps_sum=0
		EndIf
		
		SetAlpha 0.7
		SetColor 0,0,0
		DrawRect x,y,500,50
		SetAlpha 1.0
		
		SetColor 255,200,150
		EFONT.draw("FPS " + fps, x+5,y+5, 2)
		EFONT.draw("buffers " + VOXEL_CHUNK.number_of_buffers + ",   active " + VOXEL_CHUNK.number_of_buffers_active + ",   light_buffers " + VOXEL_CHUNK.number_of_light_buffers + ",   active " + VOXEL_CHUNK.number_of_light_buffers_active, x+5,y+20, 2)
		EFONT.draw("memory: " + GCMemAlloced()/1000 + " kB", x+5,y+35, 2)
	End Function	
End Type

'######################################################################################################################################################################################################

SeedRnd MilliSecs()
KInput.init()

'--------------------------------------------------------- INPUT
Local inp:String = Input("IP / server > ")

'--------------------------------------------------------- NETWORK / WORLD
Local netw_man:NETWORK_MANAGER
Local universe:VOXEL_UNIVERSE' Create:VOXEL_UNIVERSE(name:String, netw_man:NETWORK_MANAGER, overwrite:Int = False)

If inp = "s" Or inp = "server" Then
	netw_man = NETWORK_MANAGER.Create_Server()
	
	'----------------------------- GRAPHICS
	AppTitle = "GAME Blockiania"
	Graphics_Handler.set_graphics(800,600,0)
	SetBlend ALPHABLEND
	VOXEL_BLOCK.tile_init()
	EG_GRAPHICS.init()
	ITEM.init()
	VOXEL_DIG.init()
	T_CHEST.init()
	'CHARACTER_IMG.init()
	'TOOL_IMG.init()
	'-----------------------------
	
	VOXEL_UNIVERSE.Generate_and_Save("universia", netw_man, True)
	
	
	universe = VOXEL_UNIVERSE.Load("universia", netw_man)
Else
	If inp = "" Then inp = "127.0.0.1" ' local
	If inp = " " Then inp = "192.168.1.34" ' lan
	
	Local name:String = "u" + Rand(0,1000)
	
	'----------------------------- GRAPHICS
	AppTitle = "GAME Blockiania"
	Graphics_Handler.set_graphics(1200,800,0)
	SetBlend ALPHABLEND
	VOXEL_BLOCK.tile_init()
	EG_GRAPHICS.init()
	ITEM.init()
	VOXEL_DIG.init()
	T_CHEST.init()
	CHARACTER_IMG.init()
	TOOL_IMG.init()
	'-----------------------------
	netw_man = NETWORK_MANAGER.Create_Client(inp, name)
	
	netw_man.join_establish_connection() ' counld move to create ?
	
	universe = VOXEL_UNIVERSE.Join(netw_man)
EndIf

'--------------------------------------------------------- RUN
GAME.run(universe, netw_man)

End



' ######################################################################################################################################################################################################



Type EG_EVENT
	Const KIND_MOUSE_DRAG:Int = 3
	Const KIND_KEY_TAB:Int = 1
	Const KIND_KEY_F1:Int = 2
	Const KIND_KEY_NUMBER:Int = 4
	Field kind:Int
	Field x:Int,y:Int
End Type

Type EG_TAB Extends EG_EVENT
	Function Create:EG_TAB()
		Local e:EG_TAB = New EG_TAB
		e.kind = KIND_KEY_TAB
		Return e
	End Function
End Type

Type EG_F1 Extends EG_EVENT
	Function Create:EG_F1()
		Local e:EG_F1 = New EG_F1
		e.kind = KIND_KEY_F1
		Return e
	End Function
End Type

Type EG_KEY_NUMBER Extends EG_EVENT
	Field number:Int
	Function Create:EG_KEY_NUMBER(number:Int)
		Local e:EG_KEY_NUMBER = New EG_KEY_NUMBER
		e.kind = KIND_KEY_NUMBER
		e.number = number
		Return e
	End Function
End Type

Type EG_MOUSE_DRAG Extends EG_EVENT
	Global state:Int = 0 ' 0=off, 1=initiate, 2=active, 3=release
	
	Global start_area:EG_AREA
	Global drag_obj:EG_DRAG_OBJ
	Global delta_x:Int
	Global delta_y:Int
	
	Global last_x:Int
	Global last_y:Int
	
	Global captured:Int
	
	Function draw_drag(x:Int, y:Int)
		If drag_obj Then
			If drag_obj.draw(x,y) = False Then
				drag_obj = Null
			EndIf
		EndIf
	End Function
	
	Function render_and_get:EG_MOUSE_DRAG(x:Int,y:Int, M1down:Int, M1hit:Int)
		
		Select state
			Case 0, 3 ' off or release
				If M1down Or M1hit Then
					
					' init
					state = 1
					captured = False
					start_area = Null
					drag_obj = Null
					last_x = x
					last_y = y
					delta_x = 0
					delta_y = 0
					
					Return EG_MOUSE_DRAG.Create(x,y)
				Else
					' off -> mouse over
					state = 0
					captured = False
					start_area = Null
					drag_obj = Null
					last_x = x
					last_y = y
					delta_x = 0
					delta_y = 0
					
					Return EG_MOUSE_DRAG.Create(x,y)
				EndIf
			Case 1,2 ' init or active
				If M1down Then
					'active
					state = 2
					delta_x = x-last_x
					delta_y = y-last_y
					last_x = x
					last_y = y
					
					Return EG_MOUSE_DRAG.Create(x,y)
				Else
					'release
					state = 3
					delta_x = x-last_x
					delta_y = y-last_y
					last_x = x
					last_y = y
					
					Return EG_MOUSE_DRAG.Create(x,y)
				EndIf
			End Select
	End Function
	
	Function Create:EG_MOUSE_DRAG(x:Int,y:Int)
		Local e:EG_MOUSE_DRAG = New EG_MOUSE_DRAG
		e.x = x
		e.y = y
		e.kind = KIND_MOUSE_DRAG
		Return e
	End Function
End Type

Type EG_DRAG_OBJ
	Const ITEM:Int = 1
	
	Method draw:Int(x:Int,y:Int) ' below mouse, can return false if not valid any more
		SetColor 255,0,0
		DrawRect x,y,50,50
		Return True
	End Method
End Type

Type EG_DRAG_ITEM Extends EG_DRAG_OBJ
	Field from_slot:EG_ITEM_SLOT
	
	Field kind:Int ' to keep track
	Field amount:Int
	
	Function Create:EG_DRAG_ITEM(from_slot:EG_ITEM_SLOT, kind:Int, amount:Int)
		Local di:EG_DRAG_ITEM = New EG_DRAG_ITEM
		
		di.from_slot = from_slot
		di.kind = kind
		di.amount = amount
		
		Return di
	End Function
	
	Method draw:Int(x:Int,y:Int) ' below mouse
		If from_slot.deconstructed Then Return False
		If from_slot.item_array.array_kind[from_slot.index] <> kind Then Return False
		
		SetColor 255,255,255
		ITEM_draw(kind, amount, from_slot.item_array.array_info[from_slot.index], x-18,y-18)
		
		Return True
	End Method
End Type

Type EG_GRAPHICS
	Const area_count:Int = 2
	Global area:TImage[]
	Global area_size:Int[]
	
	Global interact:TImage[] = New TImage[1]
	
	Global item_slot:TImage[] = New TImage[1]
	
	Global currsor:TImage
	
	Global top_bar:TImage
	
	Function init()
		area = New TImage[area_count]
		area_size = New Int[area_count]
		
		area[0] = LoadAnimImage("gui\window.png", 8,8,0,9,0)
		area_size[0] = 8
		area[1] = LoadAnimImage("gui\button.png", 4,4,0,9,0)
		area_size[1] = 4
		
		interact[0] = LoadAnimImage("gui\close.png", 12,12,0,3,0)
		
		item_slot[0] = LoadAnimImage("gui\slot.png", 18,18,0,4,0)
		
		currsor = LoadImage("currsor.png", 0)
		
		top_bar = LoadImage("gui\top_bar.png", 0)
		HideMouse()
	End Function
	
	Function draw_interact(number:Int, x:Int,y:Int, state:Int)
		SetScale 2,2
		DrawImage interact[number],x,y, state
		SetScale 1,1
	End Function
	
	Function draw_slot(number:Int, x:Int,y:Int, form:Int)
		SetScale 2,2
		DrawImage item_slot[number],x,y, form
		SetScale 1,1
	End Function
	
	Function draw_area(number:Int, x:Int,y:Int,dx:Int,dy:Int)
		SetScale 2,2
		
		DrawImage area[number],x,y, 0
		DrawImage area[number],x+dx-area_size[number]*2,y, 2
		
		DrawImage area[number],x,y+dy-area_size[number]*2, 6
		DrawImage area[number],x+dx-area_size[number]*2,y+dy-area_size[number]*2, 8
		
		DrawImageRect(area[number],x+area_size[number]*2,y,dx/2-area_size[number]*2,area_size[number], 1)
		DrawImageRect(area[number],x,y+area_size[number]*2,area_size[number],dy/2-area_size[number]*2, 3)
		
		DrawImageRect(area[number],x+dx-area_size[number]*2,y+area_size[number]*2,area_size[number],dy/2-area_size[number]*2, 5)
		DrawImageRect(area[number],x+area_size[number]*2,y+dy-area_size[number]*2,dx/2-area_size[number]*2,area_size[number], 7)
		
		DrawImageRect(area[number],x+area_size[number]*2,y+area_size[number]*2,dx/2-area_size[number]*2,dy/2-area_size[number]*2, 4)
		
		SetScale 1,1
	End Function
End Type

Type EG_AREA
	Field x:Int,y:Int,dx:Int,dy:Int ' relative, within last area
	Field parent:EG_AREA
	
	Field children:TList
	
	Method draw(off_x:Int,off_y:Int) ' add to relative x,y
		' my own stuff
		
		' children
		For Local c:EG_AREA = EachIn children
			c.draw(off_x + x,off_y + y)
		Next
	End Method
	
	Method event:Int(e:EG_EVENT, off_x:Int,off_y:Int)
		' my own stuff
		
		' children
		children.reverse()
		For Local c:EG_AREA = EachIn children
			If c.event(e, off_x + x,off_y + y) Then
				children.reverse()
				Return True ' captured
			EndIf
		Next
		children.reverse()
		
		Return False ' not captured
	End Method
	
	Method isinside:Int(xx:Int,yy:Int, off_x:Int, off_y:Int)
		Return (xx >= off_x + x And yy >= off_y + y And xx < off_x+x+dx And yy < off_y+y+dy)
	End Method
	
	Method put_me_top(a:EG_AREA)
		If children Then
			children.remove(a)
			children.addfirst(a)
		EndIf
	End Method
	
	Field deconstructed:Int = False
	
	Method deconstruct()' recursive
		For Local c:EG_AREA = EachIn children
			c.deconstruct()
		Next
		
		If parent Then
			parent.children.remove(Self)
		EndIf
		
		children = Null
		parent = Null
		
		deconstructed = True
	End Method

End Type

Type EG_BASE Extends EG_AREA
	Field inventory:EG_WINDOW
	Field top_bar:EG_TOP_BAR
	
	Field debug_window:EG_WINDOW
	
	Method deconstruct()
		Super.deconstruct()
		inventory = Null
	End Method
	
	Function Create:EG_BASE(x:Int,y:Int,dx:Int,dy:Int)
		Local a:EG_BASE = New EG_BASE
		
		a.parent = New EG_AREA ' just not to run into problems...
				
		a.x = x
		a.y = y
		a.dx = dx
		a.dy = dy
		a.children = New TList
				
		Return a
	End Function
	
	Method add_chest_viewer(chest:T_CHEST)
		If chest.has_viewer_open Then Return
		
		Local cv:EG_CHEST_VIEWER = EG_CHEST_VIEWER.Create_CV(300,200, chest, Self)
		children.addlast(cv)
	End Method
	
	Method add_player_inventory(inv:ITEMS_ARRAY)
		If inventory Then RuntimeError("already have inventory !")
		'--------------------------------------------------------------------------------------------------- INVENTORY WINDOW
		inventory = EG_WINDOW.Create(100,100,390,220, "INVENTORY [TAB]", [Byte 0,Byte 100,Byte 0], Self)
		children.addlast(inventory)
				
		Const inv_x:Int = 10
		Const inv_y:Int = 4
		
		For Local yy:Int = 0 To inv_y-1
			For Local xx:Int = 0 To inv_x-1
				Local is:EG_ITEM_SLOT
				If xx + yy*inv_x < 10 Then
					is = EG_ITEM_SLOT.Create(6 + xx*38,50+6 + yy*38, inv, xx + yy*inv_x, (xx + yy*inv_x + 1) Mod 10, inventory)
				Else
					is = EG_ITEM_SLOT.Create(6 + xx*38,50+6 + yy*38, inv, xx + yy*inv_x, "", inventory)
				EndIf
				
				inventory.children.addlast(is)
			Next
		Next
		
		'---------------------------------------------------------------------------------------------------- TOP BAR
		top_bar = EG_TOP_BAR.Create(inv, Self)
		children.addlast(top_bar)
	End Method
	
	Method add_debug_window(netw_man:NETWORK_MANAGER)
		If debug_window Then RuntimeError("already have debug_window !")
		
		Select netw_man.mode
			Case NETWORK_MANAGER.CLIENT
				debug_window = EG_WINDOW.Create(Graphics_Handler.x-300,Graphics_Handler.y-100,520,300, "DEBUG WINDOW [F1]", [Byte 50,Byte 50,Byte 50], Self)
				children.addlast(debug_window)
				
				debug_window.children.addlast(EG_DEBUG_FPS_AND_DATA.Create(10,50, debug_window))
				
				debug_window.children.addlast(EG_BUTTON.Create(10,120, 200,24, "Toggle Lights", toggle_lights, "", debug_window))
				debug_window.children.addlast(EG_BUTTON.Create(230,120, 200,24, "Toggle Grid", toggle_grid, "", debug_window))
				debug_window.children.addlast(EG_BUTTON.Create(230,145, 200,24, "Toggle Water Numbers", toggle_water_numbers, "", debug_window))
				
				debug_window.children.addlast(EG_BUTTON.Create(10,145, 200,24, "Toggle Chunk Data", toggle_show_chunk_debug, "", debug_window))
				
				debug_window.children.addlast(EG_DEBUG_DRAW_WORLD_BENCHMARK.Create(10,180, 30, netw_man.client_connector.world , debug_window))
				
			Case NETWORK_MANAGER.SERVER
				debug_window = EG_WINDOW.Create(Graphics_Handler.x-300,Graphics_Handler.y-100,520,150, "DEBUG WINDOW", [Byte 50,Byte 50,Byte 50], Self)
				children.addlast(debug_window)
				
				debug_window.children.addlast(EG_DEBUG_FPS_AND_DATA.Create(10,50, debug_window))
				
			Default
				RuntimeError("netw_man mode: debug window not implemented !")
		End Select
	End Method
	
	Function toggle_lights(b:EG_BUTTON, _self:Object)
		VOXEL_GRID.draw_lights_enabled = Not VOXEL_GRID.draw_lights_enabled
	End Function
		
	Function toggle_grid(b:EG_BUTTON, _self:Object)
		VOXEL_GRID.draw_chunk_debug = Not VOXEL_GRID.draw_chunk_debug
	End Function
	
	Function toggle_water_numbers(b:EG_BUTTON, _self:Object)
		VOXEL_GRID.draw_chunk_debug_water = Not VOXEL_GRID.draw_chunk_debug_water
	End Function
	
	Function toggle_show_chunk_debug(b:EG_BUTTON, _self:Object)
		VOXEL_GRID.show_chunk_data = Not VOXEL_GRID.show_chunk_data
	End Function

	
	Method event:Int(e:EG_EVENT, off_x:Int,off_y:Int)
		' my own stuff
		
		' children
		If Super.event(e, off_x,off_y) Then Return True
		
		Select e.kind
			Case EG_EVENT.KIND_KEY_TAB
				' toggle inventory if available
				If inventory Then inventory.active = (Not inventory.active)
				
				Return True
			Case EG_EVENT.KIND_KEY_F1
				If debug_window Then debug_window.active = (Not debug_window.active)
		End Select
		
		
		Return False
	End Method
End Type

Type EG_DEBUG_FPS_AND_DATA Extends EG_AREA
	Function Create:EG_DEBUG_FPS_AND_DATA(x:Int,y:Int, parent:EG_AREA)
		Local a:EG_DEBUG_FPS_AND_DATA = New EG_DEBUG_FPS_AND_DATA
		
		a.x = x
		a.y = y
		a.dx = -1
		a.dy = -1
		a.children = New TList
		
		a.parent = parent
		
		Return a
	End Function
	
	
	Method draw(off_x:Int,off_y:Int) ' add to relative x,y
		FPS_AND_DATA.draw(x + off_x,y + off_y)
	End Method
End Type

Type EG_DEBUG_DRAW_WORLD_BENCHMARK Extends EG_AREA
	Field world:VOXEL_SUPER_GRID
	
	Function Create:EG_DEBUG_DRAW_WORLD_BENCHMARK(x:Int,y:Int, dx:Int, world:VOXEL_SUPER_GRID, parent:EG_AREA)
		Local a:EG_DEBUG_DRAW_WORLD_BENCHMARK = New EG_DEBUG_DRAW_WORLD_BENCHMARK
		
		a.x = x
		a.y = y
		a.dx = dx ' stands for resolution, well ...
		a.dy = -1
		a.children = New TList
		
		a.parent = parent
		
		a.world = world
		
		Return a
	End Function
	
	
	Method draw(off_x:Int,off_y:Int) ' add to relative x,y
		world.time_draw(x+off_x,y+off_y, dx)
	End Method
End Type

Type EG_WINDOW Extends EG_AREA
	Field name:String
	Field active:Int = True
	Field close_interact:EG_INTERACT
	
	Field color:Byte[]
	
	Method deconstruct()
		Super.deconstruct()
		close_interact = Null
	End Method
	
	Function Create:EG_WINDOW(x:Int,y:Int,dx:Int,dy:Int, name:String, color:Byte[], parent:EG_AREA)
		Local a:EG_WINDOW = New EG_WINDOW
		
		a.x = x
		a.y = y
		a.dx = dx
		a.dy = dy
		a.children = New TList
		a.name = name
		
		a.color = color
		a.parent = parent
		
		a.close_interact = EG_INTERACT.Create_INTERACT(dx-30,8, 0, call_deactivate, a, a)
		a.children.addlast(a.close_interact)
		
		Return a
	End Function
	
	Method draw(off_x:Int,off_y:Int) ' add to relative x,y
		If active Then
			SetColor color[0],color[1],color[2]
			SetAlpha 0.8
			EG_GRAPHICS.draw_area(0, off_x + x,off_y + y, dx, dy)
			SetAlpha 1.0
			
			SetColor 0,0,0
			EFONT.draw(name, off_x + x+10,off_y + y+10+2, 2)
			SetColor 255,255,255
			EFONT.draw(name, off_x + x+10,off_y + y+10, 2)
			
			Super.draw(off_x,off_y)
		EndIf
	End Method
	
	Method event:Int(e:EG_EVENT, off_x:Int,off_y:Int)
		If active Then
			' my own stuff
						
			Select e.kind
				Case EG_EVENT.KIND_MOUSE_DRAG
					Local d:EG_MOUSE_DRAG = EG_MOUSE_DRAG(e)
					
					If d.state = 1 And isinside(e.x,e.y, off_x, off_y) Then
						parent.put_me_top(Self)
						' not return
					EndIf
			EndSelect
			
			' children
			children.reverse()
			For Local c:EG_AREA = EachIn children
				If c.event(e, off_x + x,off_y + y) Then
					children.reverse()
					Return True ' captured
				EndIf
			Next
			children.reverse()
			
			Select e.kind
				Case EG_EVENT.KIND_MOUSE_DRAG
					Local d:EG_MOUSE_DRAG = EG_MOUSE_DRAG(e)
					
					
					Select d.state
						Case 0
							If isinside(e.x,e.y, off_x, off_y) Then
								Return True ' capture it
							EndIf
						Case 1
							If isinside(e.x,e.y, off_x, off_y) Then
								d.captured = True
								d.start_area = Self
								parent.put_me_top(Self)
								Return True ' capture it
							EndIf
						Case 2
							'If isinside(e.x,e.y, off_x, off_y) Then -> also if outside !
							If d.start_area = Self Then
								' it's mine !
								
								x:+d.delta_x
								y:+d.delta_y
								
								Return True ' capture it
							Else
								'leave alone !
							EndIf
						Case 3
							'If isinside(e.x,e.y, off_x, off_y) Then -> also if outside !
							If d.start_area = Self Then
								' it's mine !
								
								x:+d.delta_x
								y:+d.delta_y
								
								Return True ' capture it
							Else
								'leave alone !
							EndIf
					End Select
			EndSelect
			
			Return False
		EndIf
	End Method
	
	Function call_deactivate(b:EG_BUTTON, _self:Object)
		Local w:EG_WINDOW = EG_WINDOW(_self)
		w.active = False
	End Function
End Type


Type EG_CHEST_VIEWER Extends EG_WINDOW
	Rem
	Field name:String
	Field active:Int = True
	Field close_interact:EG_INTERACT
	
	Field color:Byte[]
	End Rem
	
	Field chest:T_CHEST
	
	
	Method deconstruct()
		Super.deconstruct()
		chest.has_viewer_open = False
		
		chest.super_grid.universe.netw_man.client_connector.item_array_demand.remove(chest.item_array.identifyer)
		chest = Null
	End Method
	
	Function Create_CV:EG_CHEST_VIEWER(x:Int,y:Int, chest:T_CHEST, parent:EG_AREA)
		Local a:EG_CHEST_VIEWER = New EG_CHEST_VIEWER
		
		a.x = x
		a.y = y
		a.dx = 180
		a.dy = 230
		a.children = New TList
		a.name = "CHEST   (" + chest.block_x + " " + chest.block_y + ")"
		
		a.color = [Byte 100, Byte 100, Byte 100]
		a.parent = parent
		
		a.chest = chest
		a.chest.has_viewer_open = True
		a.chest.super_grid.universe.netw_man.client_connector.item_array_demand.add(chest.item_array.identifyer)
		
		a.close_interact = EG_INTERACT.Create_INTERACT(a.dx-30,8, 0, call_deactivate, a, a)
		a.children.addlast(a.close_interact)
		
		Const inv_x:Int = 4 ' standard size.
		Const inv_y:Int = 4
		
		For Local yy:Int = 0 To inv_y-1
			For Local xx:Int = 0 To inv_x-1
				Local is:EG_ITEM_SLOT
				
				is = EG_ITEM_SLOT.Create(6 + xx*38,50+6 + yy*38, chest.item_array, xx + yy*inv_x, "", a)
				
				a.children.addlast(is)
			Next
		Next		
		
		Return a
	End Function
	
		
	Method event:Int(e:EG_EVENT, off_x:Int,off_y:Int)
		
		 ' ############# this will crash if you are not client !
		Local player:TPLAYER = chest.super_grid.universe.netw_man.client_connector.player
		
		If Not player Then
			Print "chest viewer deconstruct: no player"
			deconstruct()
			Return False
		EndIf
		
		If chest.super_grid <> player.super_grid Then' different world
			Print "chest viewer deconstruct: false grid"
			deconstruct()
			Return False
		EndIf
		
		If Abs(player.x - chest.x) > 300 Or Abs(player.y - chest.y) > 300 Then' distance to player
			Print "chest viewer deconstruct: distance"
			deconstruct()
			Return False
		EndIf
		
		If chest.to_be_removed Then
			Print "chest viewer deconstruct: chest removed"
			deconstruct()
			Return False
		EndIf
		
		If Not active Then
			Print "chest viewer deconstruct: window closed"
			deconstruct()
			Return False
		EndIf
		
		Return Super.event(e, off_x, off_y)
	End Method
	
End Type


Type EG_TOP_BAR Extends EG_AREA
	Field inventory:ITEMS_ARRAY
	
	Field number_slots:EG_ITEM_SLOT[]
	
	Field slot_left:EG_ITEM_SLOT
	Field slot_right:EG_ITEM_SLOT
	
	Function Create:EG_TOP_BAR(inv:ITEMS_ARRAY, parent:EG_AREA)
		Local a:EG_TOP_BAR = New EG_TOP_BAR
		
		a.x = Graphics_Handler.x/2 - 300
		a.y = 0
		a.dx = 600
		a.dy = 50
		
		a.children = New TList
		
		a.parent = parent
		
		a.inventory = inv
		
		a.number_slots = New EG_ITEM_SLOT[10]
		
		For Local i:Int = 0 To 4
			a.number_slots[i] = EG_ITEM_SLOT.Create(20 + 40*i, 8, a.inventory, i, ((i+1) Mod 10), a)
			a.children.addlast(a.number_slots[i])
		Next
		
		For Local i:Int = 0 To 4
			a.number_slots[i+5] = EG_ITEM_SLOT.Create(384 + 40*i, 8, a.inventory, i+5, ((i+1+5) Mod 10), a)
			a.children.addlast(a.number_slots[i+5])
		Next
		
		'130,152 -20
		a.slot_left = EG_ITEM_SLOT_SELECTED.Create(260, 20, a.inventory, 0, "L", a)
		a.children.addlast(a.slot_left)
		
		a.slot_right = EG_ITEM_SLOT_SELECTED.Create(304, 20, a.inventory, 9, "R", a)
		a.children.addlast(a.slot_right)
		
		Return a
	End Function
	
	Method draw(off_x:Int,off_y:Int) ' add to relative x,y
		
		SetColor 255,255,255
		SetScale 2,2
		DrawImage EG_GRAPHICS.top_bar, off_x + x, off_y + y
		SetScale 1,1
		
		Super.draw(off_x,off_y)
	End Method
	
	
	Method event:Int(e:EG_EVENT, off_x:Int,off_y:Int)
		' my own stuff
		
		' children
		If Super.event(e, off_x,off_y) Then Return True
		
		Select e.kind
			Case EG_EVENT.KIND_KEY_NUMBER
				
				' select slot
				Local nn:EG_KEY_NUMBER = EG_KEY_NUMBER(e)
				
				If nn.number > 0 And nn.number < 6 Then
					slot_left.index = nn.number-1
				Else
					slot_right.index = (nn.number+9) Mod 10
				EndIf
				
				Return True
		End Select
		
		Return False
	End Method
End Type

Type EG_BUTTON Extends EG_AREA
	Field name:String
	Field func(b:EG_BUTTON, _self:Object)
	Field func_self:Object
	Field state:Int = 0 ' 0=off, 1=over, 2=pressed/drag -> only cosmetic !
	
	Function Create:EG_BUTTON(x:Int,y:Int,dx:Int,dy:Int, name:String, func(b:EG_BUTTON, _self:Object), func_self:Object, parent:EG_AREA)
		Local a:EG_BUTTON = New EG_BUTTON
		
		a.x = x
		a.y = y
		a.dx = dx
		a.dy = dy
		a.children = New TList
		a.name = name
		a.func = func
		a.func_self = func_self
		
		a.parent = parent
		
		Return a
	End Function
	
	Method draw(off_x:Int,off_y:Int) ' add to relative x,y
		SetColor 255,255,255
		EG_GRAPHICS.draw_area(1, off_x + x,off_y + y, dx, dy)
		state = 0
		
		Local center:Int = EFONT.get_width(name, 2)/2
		
		SetColor 255,255,255
		EFONT.draw(name, off_x + x + dx/2 -center,off_y + y+8, 2)
		
		Super.draw(off_x,off_y)
	End Method
	
	Method event:Int(e:EG_EVENT, off_x:Int,off_y:Int)
		' my own stuff
		
		Select e.kind
			Case EG_EVENT.KIND_MOUSE_DRAG
				Local d:EG_MOUSE_DRAG = EG_MOUSE_DRAG(e)
				
				If isinside(e.x,e.y, off_x, off_y) Then
					state = Max(state, 1)
					
					Select d.state
						Case 0
							parent.put_me_top(Self)
							Return True ' capture it
						Case 1
							d.captured = True
							d.start_area = Self
							parent.put_me_top(Self)
							
							state = Max(state, 2)
							
							Return True ' capture it
						Case 2
							If d.start_area = Self Then
								' it's mine !
								
								state = Max(state, 2)
								
								Return True ' capture it
							Else
								'leave alone !
							EndIf
						Case 3
							If d.start_area = Self Then
								' it's mine !
								
								state = Max(state, 2)
								If func Then func(Self, func_self)
																
								Return True ' capture it
							Else
								'leave alone !
							EndIf
					End Select
				EndIf
		EndSelect
		
		Return False
	End Method
End Type

Type EG_INTERACT Extends EG_BUTTON
	Field number:Int
	
	Function Create_INTERACT:EG_INTERACT(x:Int,y:Int, number:Int, func(b:EG_BUTTON, _self:Object), func_self:Object, parent:EG_AREA)
		Local a:EG_INTERACT = New EG_INTERACT
		
		a.x = x
		a.y = y
		a.dx = EG_GRAPHICS.interact[number].width*2
		a.dy = EG_GRAPHICS.interact[number].width*2
		a.children = New TList
		a.name = "interact_" + number
		a.number = number
		a.func = func
		a.func_self = func_self
		
		a.parent = parent
		
		Return a
	End Function
	
	Method draw(off_x:Int,off_y:Int) ' add to relative x,y
		SetColor 255,255,255
		EG_GRAPHICS.draw_interact(number, off_x + x,off_y + y, state)
		state = 0
		
		'children not drawn !
	End Method
End Type

Type EG_ITEM_SLOT Extends EG_AREA
	Field number:Int ' appearance
	Field item_array:ITEMS_ARRAY
	Field index:Int
	Field background_test:String = ""
	
	Method deconstruct()
		Super.deconstruct()
		item_array = Null
	End Method
	
	Function Create:EG_ITEM_SLOT(x:Int,y:Int, item_array:ITEMS_ARRAY, index:Int, background_test:String, parent:EG_AREA)
		Local a:EG_ITEM_SLOT = New EG_ITEM_SLOT
		
		a.x = x
		a.y = y
		a.dx = EG_GRAPHICS.item_slot[0].width*2+2
		a.dy = EG_GRAPHICS.item_slot[0].width*2+2
		a.children = New TList
		a.number = 0
				
		a.parent = parent
		
		a.item_array = item_array
		a.index = index
		
		a.background_test = background_test
		
		Return a
	End Function
	
	Method draw(off_x:Int,off_y:Int) ' add to relative x,y
		Local kind:Int = item_array.array_kind[index]
		Local amount:Int = item_array.array_amount[index]
		Local info:Int[] = item_array.array_info[index]
		
		Local di:EG_DRAG_ITEM = EG_DRAG_ITEM(EG_MOUSE_DRAG.drag_obj)
		If di And di.from_slot.item_array = item_array And di.from_slot.index = index Then
			If di.kind = kind Then
				If di.amount > amount Then
					di.amount = amount
				EndIf
				
				If di.amount = 0 Then
					EG_MOUSE_DRAG.drag_obj = Null
				Else
					' reduce local amount - only cosmetics
					
					amount:-di.amount
					If amount = 0 Then
						kind = -1
					EndIf
				EndIf
			Else
				EG_MOUSE_DRAG.drag_obj = Null
			EndIf
		EndIf
		
		SetColor 255,255,255
		
		If kind <> -1 Then
			EG_GRAPHICS.draw_slot(number, off_x + x,off_y + y, 1)
		Else
			EG_GRAPHICS.draw_slot(number, off_x + x,off_y + y, 0)
		EndIf
		
		SetColor 70,70,70
		EFONT.draw(background_test, off_x + x + dx/2 - EFONT.get_width(background_test,4)/2-1, off_y + y + 8 , 4)
		
		SetColor 0,0,0
		EFONT.draw(background_test, off_x + x, off_y + y+2, 2)
		SetColor 255,255,255
		EFONT.draw(background_test, off_x + x, off_y + y, 2)
		
		ITEM.draw(kind, amount, info, off_x + x,off_y + y)
		'children not drawn !
	End Method
	
	Method event:Int(e:EG_EVENT, off_x:Int,off_y:Int)
		' my own stuff
		
		'Create:EG_DRAG_ITEM(from_slot:EG_ITEM_SLOT, kind:Int, amount:Int)'drag_obj
		
		Select e.kind
			Case EG_EVENT.KIND_MOUSE_DRAG
				Local d:EG_MOUSE_DRAG = EG_MOUSE_DRAG(e)
				
				Select d.state
					Case 0
						If isinside(e.x,e.y, off_x, off_y) Then
							Return True ' capture it
						EndIf
					Case 1
						If isinside(e.x,e.y, off_x, off_y) Then
							If item_array.array_kind[index] >= 0 Then
								d.captured = True
								d.start_area = Self
								parent.put_me_top(Self)
								
								Local amount_:Int = item_array.array_amount[index]
								
								If KInput.Klshift.down Then
									amount_ = (amount_+1)/2
								EndIf
								
								d.drag_obj = EG_DRAG_ITEM.Create(Self, item_array.array_kind[index], amount_)
							EndIf
							
							Return True ' capture it
						EndIf
					Case 2
						'If isinside(e.x,e.y, off_x, off_y) Then -> also if outside !
						If d.start_area = Self Then
							' it's mine !
							
							Return True ' capture it
						Else
							'leave alone !
						EndIf
					Case 3
						If isinside(e.x,e.y, off_x, off_y) Then
							If d.start_area = Self Then
								' discard action.
							Else
								Local do:EG_DRAG_ITEM = EG_DRAG_ITEM(d.drag_obj)
								If do Then
									' see if transaction possible
										
									' still valid ?
									do.amount = ITEMS_ARRAY.adjust_transaction(do.from_slot.item_array, do.from_slot.index, item_array, index, do.amount)
									
									If do.amount > 0 Then
										
										Select item_array.netw_man.mode ' NETWORK ! must do first, server also has old data !
											Case NETWORK_MANAGER.CLIENT
												item_array.netw_man.client_connector.condact_array.write_move_items(do.from_slot.item_array.identifyer, do.from_slot.index, do.kind, item_array.identifyer, index, item_array.array_kind[index], do.amount)
											Case NETWORK_MANAGER.SERVER
												RuntimeError("action not supported (item slot)")
											Default
												RuntimeError("mode not implemented (item slot)")
										End Select
										
										ITEMS_ARRAY.do_transaction(do.from_slot.item_array, do.from_slot.index, item_array, index, do.amount)
									EndIf
									
									Return True ' capture it
								EndIf
							EndIf
							
							Return True ' capture it
						EndIf
				End Select
		EndSelect
				
		Return False
	End Method
End Type

Type EG_ITEM_SLOT_SELECTED Extends EG_ITEM_SLOT
		
	Function Create:EG_ITEM_SLOT_SELECTED(x:Int,y:Int, item_array:ITEMS_ARRAY, index:Int, background_test:String, parent:EG_AREA)
		Local a:EG_ITEM_SLOT_SELECTED = New EG_ITEM_SLOT_SELECTED
		
		a.x = x
		a.y = y
		a.dx = EG_GRAPHICS.item_slot[0].width*2+2
		a.dy = EG_GRAPHICS.item_slot[0].width*2+2
		a.children = New TList
		a.number = 0
		
		a.parent = parent
		
		a.item_array = item_array
		a.index = index
		
		a.background_test = background_test
		
		Return a
	End Function
	
	Method event:Int(e:EG_EVENT, off_x:Int,off_y:Int)
		' my own stuff
		
		'Create:EG_DRAG_ITEM(from_slot:EG_ITEM_SLOT, kind:Int, amount:Int)'drag_obj
		
		Select e.kind
			Case EG_EVENT.KIND_MOUSE_DRAG
				Local d:EG_MOUSE_DRAG = EG_MOUSE_DRAG(e)
				
				Select d.state
					Case 0
						If isinside(e.x,e.y, off_x, off_y) Then
							Return True ' capture it
						EndIf
					Case 1
						If isinside(e.x,e.y, off_x, off_y) Then
							Rem
							If item_array.array_kind[index] >= 0 Then
								d.captured = True
								d.start_area = Self
								parent.put_me_top(Self)
								
								Local amount_:Int = item_array.array_amount[index]
								
								If KInput.Klshift.down Then
									amount_ = (amount_+1)/2
								EndIf
								
								d.drag_obj = EG_DRAG_ITEM.Create(Self, item_array.array_kind[index], amount_)
							EndIf
							End Rem
							
							'can't take from here !
							
							Return True ' capture it
						EndIf
					Case 2
						'If isinside(e.x,e.y, off_x, off_y) Then -> also if outside !
						If d.start_area = Self Then
							' it's mine !
							
							Return True ' capture it
						Else
							'leave alone !
						EndIf
					Case 3
						If isinside(e.x,e.y, off_x, off_y) Then
							If d.start_area = Self Then
								' discard action.
							Else
								Local do:EG_DRAG_ITEM = EG_DRAG_ITEM(d.drag_obj)
								If do Then
									' see if transaction possible
										
									' still valid ?
									'do.amount = ITEMS_ARRAY.adjust_transaction(do.from_slot.item_array, do.from_slot.index, item_array, index, do.amount)
									
									If do.amount > 0 Then
										
										If do.from_slot.item_array = item_array And do.from_slot.index < 10 Then
											index = do.from_slot.index
										EndIf
										
										Rem
										Select item_array.netw_man.mode ' NETWORK ! must do first, server also has old data !
											Case NETWORK_MANAGER.CLIENT
												item_array.netw_man.client_connector.condact_array.write_move_items(do.from_slot.item_array.identifyer, do.from_slot.index, do.kind, item_array.identifyer, index, item_array.array_kind[index], do.amount)
											Case NETWORK_MANAGER.SERVER
												RuntimeError("action not supported (item slot)")
											Default
												RuntimeError("mode not implemented (item slot)")
										End Select
										
										ITEMS_ARRAY.do_transaction(do.from_slot.item_array, do.from_slot.index, item_array, index, do.amount)
										End Rem
									EndIf
									
									Return True ' capture it
								EndIf
							EndIf
							
							Return True ' capture it
						EndIf
				End Select
		EndSelect
				
		Return False
	End Method
End Type


'##############################################################################################
'Import brl.blitz
'Import vertex.bnetex

'#######################################  SERVER SIDE   #########################################
Type T_S_Client
	Global map:TMap
	Global name_map:TMap
	Global id_map:TMap
	Global id_counter:Int = 1
	
	Function init()
		T_S_Client.map = CreateMap()
		T_S_Client.name_map = CreateMap()
		T_S_Client.id_map = CreateMap()
	End Function
	
	Function get:T_S_Client(ip:Int, port:Int)
		Local key:T_S_CLIENT_KEY = T_S_CLIENT_KEY.Create(ip, port)
		Local c:T_S_Client = T_S_Client(T_S_Client.map.ValueForKey(key))
		
		Return c
	End Function
	
	Function get_id:T_S_Client(id:Int)
		Local c:T_S_Client = T_S_Client(T_S_Client.id_map.ValueForKey(String(id)))
		
		Return c
	End Function
		
	Function update_all(universe:VOXEL_UNIVERSE)
		For Local c:T_S_Client = EachIn MapValues(T_S_Client.map)
			c.update(universe)
		Next
	End Function
	
	Function msg_send_all(txt:String)
		For Local c:T_S_Client = EachIn MapValues(T_S_Client.map)
			c.msg_send_array.write(txt)
		Next
	End Function
	
	Function draw_all(x:Int, y:Int)
		Local y_off:Int = 0
		SetColor 0,0,0
		For Local c:T_S_Client = EachIn MapValues(T_S_Client.map)
			DrawText c.name + ": IP: " + c.ip_str + ":" + c.port + "/" + c.clientside_port + ", ID: " + c.id, x, y+y_off
			
			y_off:+15
		Next
	End Function
	
	Function Create:T_S_Client(ip:Int, port:Int, world:VOXEL_SUPER_GRID)
		Local c:T_S_Client = New T_S_Client
		
		c.id = T_S_Client.id_counter
		T_S_Client.id_counter:+1
		
		c.ip = ip
		c.ip_str = TNetwork.StringIP(ip)
		c.port = port
		c.last_update_from = MilliSecs()
		
		c.world = world
		
		T_S_Client.map.Insert(T_S_CLIENT_KEY.Create(ip, port), c)
		T_S_Client.id_map.Insert(String(c.id), c)
		
		c.msg_send_array =  MESSAGE_UPDATE_ARRAY.Create(20)
		c.msg_send_array.write("%y%<Server> %green%WELCOME !")
		
		c.inventory = ITEMS_ARRAY.Create(ITEMS_ARRAY.PLAYER_SIZE, [1, c.id], world.universe.netw_man)
		
		Local kind:Int
		Local amount:Int
		Local info:Int[] = New Int[0]
		
		For Local i:Int = 0 To 3
			kind = i
			amount = 100 + 5*i
			c.inventory.add_item(kind,amount,info)
		Next
		
		kind = 4
		amount = 1
		c.inventory.add_item(kind,amount,info)
		
		kind = 5
		amount = 1
		c.inventory.add_item(kind,amount,info)
		
		kind = 6
		amount = 1
		c.inventory.add_item(kind,amount,info)
		
		kind = 7
		amount = 1
		c.inventory.add_item(kind,amount,info)
		
		kind = 8
		amount = 20
		c.inventory.add_item(kind,amount,info)
		
		kind = ITEM.BLOCK_GLOWSTONE
		amount = 100
		c.inventory.add_item(kind,amount,info)
		
		
		c.item_array_demand = ITEM_ARRAY_DEMAND.Create()
						
		Return c
	End Function
	
	Method deconstruct(netw_man:NETWORK_MANAGER)
		If player Then
			player.remove(netw_man)
		EndIf
		
		If name_map.Contains(name) Then
			name_map.Remove(name)
		EndIf
		
		world = Null
		
		T_S_Client.map.Remove(T_S_CLIENT_KEY.Create(ip, port))
	End Method
	
	' ------------------- receiving from client
	Field ip:Int
	Field ip_str:String
	Field port:Short
	Field last_update_from:Int
	Field highest_block_stamp:Int = 0
	Field msg_last_stamp_receive:Int = 0
	Field latest_action_stamp:Int = 0
	
	' ------------------- send to client
	Field clientside_port:Short
	Field send_stream:TUDPStream
	Field last_update_objects_to:Int
	Field msg_send_array:MESSAGE_UPDATE_ARRAY
	Field last_update_inventory_to:Int
	
	'------------------- game data
	Field id:Int
	Field name:String = "#noname#"
	Field player:TOBJECT
	Field world:VOXEL_SUPER_GRID
	Field must_kick:Int = False
	Field inventory:ITEMS_ARRAY
	Field item_array_demand:ITEM_ARRAY_DEMAND
	
	Method update(universe:VOXEL_UNIVERSE)
		If MilliSecs() - last_update_from > 10000 Then
			Print("timed out: " + ip_str + ":" + port)
			T_S_Client.map.remove(T_S_CLIENT_KEY.Create(ip, port))
			
			deconstruct(universe.netw_man)
			Return
		EndIf
		
		If clientside_port And (MilliSecs() - last_update_objects_to > 100) Then
			last_update_objects_to = MilliSecs()
			
			If player Then
				Local x1:Int, x2:Int, y1:Int, y2:Int
				
				player.get_super_chunks(2, x1, x2, y1, y2)
				For Local xx:Int = x1 To x2
					For Local yy:Int = y1 To y2
						Local sc:VOXEL_SUPER_CHUNK = world.get_super_chunk(xx,yy, False)
						Package_Manager.write_block_update(send_stream, sc.block_update)
					Next
				Next
			EndIf
			
			Package_Manager.write_msg_update(send_stream, msg_send_array)
			
			If last_update_inventory_to + 1000 < MilliSecs() Then ' don't send too often
				last_update_inventory_to = MilliSecs()
				Package_Manager.write_item_array(send_stream, inventory)
				
				item_array_demand.write_all_item_arrays(send_stream, universe)
			EndIf
			
			If must_kick Then
				Package_Manager.write_kick(send_stream)
			EndIf
			
			Package_Manager.send_objects(send_stream, world.id, world.object_map, universe.netw_man)
		EndIf
		
		If clientside_port And (Not player) Then
			player = TPLAYER.Create(100,100, world, id, name, False, Null)
		EndIf
	End Method
	
	Method teleport(new_world:VOXEL_SUPER_GRID)
		If player Then
			Print(" teleport me !")
			
			' destroy old player
			player.remove(new_world.universe.netw_man)
			
			' build new player
			world = new_world
			player = TPLAYER.Create(100,100, world, id, name, False, Null)
			
			' send client switch command.
			msg_send_array.write("/teleport_world " + world.id)
		EndIf
	End Method
	
	Method get_print:String()
		Return (ip_str + ":" + port)
	End Method
		
	Method set_client_join(p:Int, rcv_name:String)
		If Not clientside_port Then
			clientside_port = p
			
			send_stream = New TUDPStream
			
			If Not send_stream.Init() Then
				Print("Can't create socket (to client)! " + ip_str + ":" + clientside_port)
				
				clientside_port = 0
				Return
			EndIf
			
			send_stream.SetRemoteIP(ip)
			send_stream.SetLocalPort()
			send_stream.SetRemotePort(clientside_port)
			
			If name_map.Contains(rcv_name) Then
				' name exists already !
				
				must_kick = True
			Else
				name_map.Insert(rcv_name, Self)
				name = rcv_name
			EndIf
			
			' ----------------- say hi:
			Package_Manager.send_empty_package(send_stream)
		EndIf
	End Method
End Type

Type T_S_CLIENT_KEY
	Field ip:Int
	Field port:Int
	
	Function Create:T_S_CLIENT_KEY(ip:Int, port:Int)
		Local k:T_S_CLIENT_KEY = New T_S_CLIENT_KEY
		
		k.ip = ip
		k.port = port
		
		Return k
	End Function
	
	Method Compare:Int(other:Object)
		Local o2:T_S_CLIENT_KEY = T_S_CLIENT_KEY(other)
		
		If o2 = Null Then Return Super.Compare(other)
		
		If o2.ip < ip Then Return -1
		If o2.ip > ip Then Return 1
		
		If o2.port < port Then Return -1
		If o2.port > port Then Return 1
		
		Return 0
	End Method
End Type

Type T_S_Connect
	Field listen_port:Short
	Field listen_stream:TUDPStream
	
	Function Create:T_S_Connect(listen_port:Short)
		Local s:T_S_Connect = New T_S_Connect
		
		s.listen_port = listen_port
		s.listen_stream = New TUDPStream
		
		If Not s.listen_stream.Init() Then
			Throw("Can't create socket for server !")
		EndIf
		
		s.listen_stream.SetLocalPort(s.listen_port)
		
		Return s
	End Function
	
	Method update(universe:VOXEL_UNIVERSE)
		
		
		If listen_stream.RecvAvail() Then
			Local rcv_count:Int = 0
			
			While listen_stream.RecvMsg() And Not (rcv_count > 1000)
				If listen_stream.Size() > 0 Then
					Local ip:Int = listen_stream.GetMsgIP()
					Local port:Int = listen_stream.GetMsgPort()
					
					Local c:T_S_Client = T_S_Client.get(ip, port)
					
					If Not c Then
						c = T_S_Client.Create(ip, port, universe.get_spawn_world())
					EndIf
					
					While Not listen_stream.Eof()
							Package_Manager.execute(listen_stream, c, universe, universe.netw_man)
					Wend
				EndIf
			Wend
		EndIf
	End Method
End Type
'#######################################  CLIENT SIDE   #########################################
Type T_C_Connect
	Field world:VOXEL_SUPER_GRID
	Field name:String
	
	Field player:TPLAYER
	Field inventory:ITEMS_ARRAY
	
	'------------------------------ to server
	Field remote_port:Short
	Field remote_ip:Int
	Field remote_ip_str:String
	Field send_stream:TUDPStream
	Field msg_send_array:MESSAGE_UPDATE_ARRAY
	Field condact_array:CONDITIONAL_ACTION_ARRAY
	Field item_array_demand:ITEM_ARRAY_DEMAND
	Field last_send_ping:Int
	
	'------------------------------ receive
	Field listen_port:Short
	Field listen_stream:TUDPStream
	Field last_receive:Int
	Field server_highest_block_stamp:Int = 0
	Field msg_last_stamp_receive:Int = 0
	Field my_start_world_id:Int = 0
	Field my_world_id:Int = 0
	Field new_world_id:Int = 0 ' if different -> load that !
	
	'------------------------------ clientside_changed_blocks
	
	
	Function Create:T_C_Connect(ip_str:String, remote_port:Short, listen_port:Short, name:String)
		Local s:T_C_Connect = New T_C_Connect
		
		s.name = name
		
		s.msg_send_array =  MESSAGE_UPDATE_ARRAY.Create(20)
		s.msg_send_array.write("%green%joins the server")
		
		s.condact_array = CONDITIONAL_ACTION_ARRAY.Create(50)
		
		'------------------------------ receive
		s.listen_port = listen_port
		s.listen_stream = New TUDPStream
		
		If Not s.listen_stream.Init() Then
			Print("Can't create socket (listen)!")
			Return Null
		EndIf
		s.listen_stream.SetLocalPort(s.listen_port)
		
		'------------------------------ to server
		s.remote_port = remote_port
		s.remote_ip_str = ip_str
		s.remote_ip = TNetwork.IntIP(ip_str)
		s.send_stream = New TUDPStream
		
		If Not s.send_stream.Init() Then
			Print("Can't create socket (to server)!")
			Return Null
		EndIf
		
		s.send_stream.SetRemoteIP(s.remote_ip)
		s.send_stream.SetLocalPort()
		s.send_stream.SetRemotePort(s.remote_port)
		
		s.item_array_demand = ITEM_ARRAY_DEMAND.Create()
				
		Return s
	End Function
	
	Method receive_data(universe:VOXEL_UNIVERSE, netw_man:NETWORK_MANAGER)
		' from server
		
		If listen_stream.RecvAvail() Then
			Local rcv_count:Int = 0
			
			While listen_stream.RecvMsg(); Wend 'And Not (rcv_count > 1000)
				
				
				If listen_stream.Size() > 0 Then
					Local ip:Int = listen_stream.GetMsgIP()
					Local port:Int = listen_stream.GetMsgPort()
					
					' compare to server ?
					
					last_receive = MilliSecs()
					
					
					
					While Not listen_stream.Eof()
						Package_Manager.execute(listen_stream, Null, universe, netw_man)
					Wend
				EndIf
			'Wend
		EndIf
		
		If last_receive And (MilliSecs() - last_receive) > 5000 Then
			If (MilliSecs() - last_send_ping) > 200 Then
				last_send_ping = MilliSecs()
				Package_Manager.send_ping(send_stream)
			EndIf
		EndIf
		
		If last_receive And (MilliSecs() - last_receive) > 10000 Then
			RuntimeError("we probably timed out !")
		EndIf
		
	End Method
End Type	

Type ITEM_ARRAY_DEMAND
	
	Field item_arrays_demanded:Int[][] ' array of identifyers, player's inventory excluded (updated anyway)
	
	Function Create:ITEM_ARRAY_DEMAND()
		Local d:ITEM_ARRAY_DEMAND = New ITEM_ARRAY_DEMAND
		
		d.item_arrays_demanded = New Int[][0]
		
		Return d
	End Function
	
	Method add(ident:Int[])
		'print_me()
		
		' find empty if possible:
		Local written:Int = False
		For Local i:Int = 0 To item_arrays_demanded.length-1
			If item_arrays_demanded[i].length = 1 And item_arrays_demanded[i][0] = -1 Then
				item_arrays_demanded[i] = ident
				written = True
				Exit
			EndIf
		Next
		
		If Not written Then
			item_arrays_demanded:+[ident]
		EndIf
		
		'print_me()
	EndMethod
	
	Method remove(ident:Int[])
		'print_me()
		
		' find it:
		Local pos:Int = -1
		
		For Local i:Int = 0 To item_arrays_demanded.length-1
			Local rej:Int = False
			
			If item_arrays_demanded[i].length = ident.length Then
				For Local k:Int = 0 To item_arrays_demanded[i].length-1
					If item_arrays_demanded[i][k] <> ident[k] Then
						rej = True
						
						'Print "rej: " + i + " at " + k
						Exit
					EndIf
				Next
			Else
				rej = True
			EndIf
			
			If Not rej Then
				pos = i
				
				'Print "found: " + i
				
				Exit
			EndIf
		Next
		
		If pos > -1 Then
			item_arrays_demanded[pos] = [-1] ' invalid
		Else
			Print "item array ident not found !!"
		EndIf
		
		'print_me()
	EndMethod
	
	Rem
	Method print_me()
		Print "length: " + item_arrays_demanded.length
		For Local i:Int = 0 To item_arrays_demanded.length-1
			Local txt:String = i + ": "
			
			For Local k:Int = 0 To item_arrays_demanded[i].length-1
				txt:+ item_arrays_demanded[i][k] + ", "
			Next
			Print txt
		Next
	End Method
	End Rem
	
	Method write_to_stream(stream:TStream)
		Local data_found:Int = False ' just for me
		
		stream.WriteInt(item_arrays_demanded.length)
		
		For Local i:Int = 0 To item_arrays_demanded.length-1
			stream.WriteInt(item_arrays_demanded[i].length)
			For Local k:Int = 0 To item_arrays_demanded[i].length-1
				stream.WriteInt(item_arrays_demanded[i][k])
			Next
			
			If item_arrays_demanded[i].length <> 1 Or item_arrays_demanded[i][0] <> -1 Then
				data_found = True
			EndIf
		Next
		
		
		If Not data_found Then
			'print_me()
			item_arrays_demanded = New Int[][0]
			
			'Print "---------> no data found !"
			'print_me()
		EndIf
	End Method
	
	Method read_from_stream(stream:TStream)
		Local size:Int = stream.ReadInt()
		
		item_arrays_demanded = New Int[][size]
		
		For Local i:Int = 0 To item_arrays_demanded.length-1
			Local size_ident:Int = stream.ReadInt()
			
			item_arrays_demanded[i] = New Int[size_ident]
			
			For Local k:Int = 0 To item_arrays_demanded[i].length-1
				item_arrays_demanded[i][k] = stream.ReadInt()
			Next
		Next
		
		'Print "from client:"
		'print_me()
		
	End Method
	
	Method write_all_item_arrays(stream:TUDPStream, universe:VOXEL_UNIVERSE)
		For Local i:Int = 0 To item_arrays_demanded.length-1
			If item_arrays_demanded[i].length <> 1 Or item_arrays_demanded[i][0] <> -1 Then
				' find it.
				Local item_array:ITEMS_ARRAY = universe.find_item_array(item_arrays_demanded[i])
				
				If item_array Then
					Package_Manager.write_item_array(stream, item_array)
				EndIf
			EndIf
		Next
				
		
	End Method
	
	
	

End Type


Type ITEM ' no data, only functions !
	Const BLOCK_STONE:Int = 0
	Const BLOCK_GRASS_GREEN:Int = 1
	Const BLOCK_DIRT_BROWN:Int = 2
	Const BLOCK_GOLD:Int = 3
	
	Const BUCKET_WATER:Int = 4
	Const BUCKET_LAVA:Int = 5
	
	Const TOOL_PICKAXE:Int = 6
	Const TOOL_HAMMER:Int = 7
	
	Const BO_CHEST:Int = 8
	
	Const BLOCK_GLOWSTONE:Int = 9
	
	Const item_count:Int = 10
	
	Global img:TImage[]
	
	Global countable:Int[]
	Global typ:Int[]
	Global primary_info:Int[]
	Global secondary_info:Int[]
	Global third_info:Int[]
	
	Const TYPE_SIMPLE:Int = 1
	Const TYPE_BLOCK:Int = 2			' pr: block
	Const TYPE_TOOL_DIGGING:Int = 3		' pr: tool_nr				sec: dig value
	Const TYPE_BO:Int = 4				' pr: block object nr
	
	Function set_item_simple(item_:Int, countable_:Int, image_name:String)
		countable[item_] = countable_
		img[item_] = LoadImage("items\" + image_name + ".png",0)
		If Not img[item_] Then RuntimeError "item image not found ! " + image_name
		typ[item_] = TYPE_SIMPLE
	End Function
	
	Function set_item_block(item_:Int, countable_:Int, image_name:String, block:Int)
		set_item_simple(item_, countable_, image_name)
		typ[item_] = TYPE_BLOCK
		primary_info[item_] = block
	End Function
	Function get_block:Int(item_:Int)
		If typ[item_] <> TYPE_BLOCK Then RuntimeError "this is no block ITEM !"
		Return primary_info[item_]
	End Function
	
	Function set_item_tool_digging(item_:Int, countable_:Int, image_name:String, tool_nr:Int, dig_value:Int, dig_diameter:Int)
		set_item_simple(item_, countable_, image_name)
		typ[item_] = TYPE_TOOL_DIGGING
		primary_info[item_] = tool_nr
		secondary_info[item_] = dig_value
		third_info[item_] = dig_diameter
	End Function
	Function get_dig_tool_nr:Int(item_:Int)
		If typ[item_] <> TYPE_TOOL_DIGGING Then RuntimeError "this is no tool_digging ITEM !"
		Return primary_info[item_]
	End Function
	Function get_dig_value:Int(item_:Int)
		If typ[item_] <> TYPE_TOOL_DIGGING Then RuntimeError "this is no tool_digging ITEM !"
		Return secondary_info[item_]
	End Function
	Function get_dig_diameter:Int(item_:Int)
		If typ[item_] <> TYPE_TOOL_DIGGING Then RuntimeError "this is no tool_digging ITEM !"
		Return third_info[item_]
	End Function
	
	Function set_item_block_object(item_:Int, countable_:Int, image_name:String, bo_nr:Int)
		set_item_simple(item_, countable_, image_name)
		typ[item_] = TYPE_BO
		primary_info[item_] = bo_nr
	End Function
	Function get_bo_nr:Int(item_:Int)
		If typ[item_] <> TYPE_BO Then RuntimeError "this is no block_object ITEM !"
		Return primary_info[item_]
	End Function
	
	Function init()
		' dependency on VOXEL_BLOCK loading first !
		img = New TImage[item_count]
		countable = New Int[item_count]
		typ = New Int[item_count]
		primary_info = New Int[item_count]
		secondary_info = New Int[item_count]
		third_info = New Int[item_count]
		
		set_item_block(BLOCK_STONE, 			True, 		"block_stone", 				VOXEL_BLOCK.STONE)
		set_item_block(BLOCK_GRASS_GREEN, 	True, 		"block_grass_green",  		VOXEL_BLOCK.GRASS_GREEN)
		set_item_block(BLOCK_DIRT_BROWN, 	True, 		"block_dirt_brown", 			VOXEL_BLOCK.DIRT_BROWN)
		set_item_block(BLOCK_GOLD, 			True, 		"block_gold", 					VOXEL_BLOCK.GOLD)
		
		set_item_simple(BUCKET_WATER, 		False, 	 	"bucket_water") ' just for now
		set_item_simple(BUCKET_LAVA, 		False,  	"bucket_lava") ' just for now
		
		set_item_tool_digging(TOOL_PICKAXE, False,		"tool_pickaxe", 				HAND_OBJ.PICKAXE,			10,		2)
		set_item_tool_digging(TOOL_HAMMER, 	False,		"tool_hammer", 				HAND_OBJ.HAMMER,			40,		3)
		
		set_item_block_object(BO_CHEST, 		True, 		"bo_chest", 					BLOCK_OBJECT_MANAGER.TYPE_CHEST)
		
		set_item_block(BLOCK_GLOWSTONE, 		True, 		"block_glowstone", 			VOXEL_BLOCK.GLOWSTONE)
	End Function
	
	Function draw(kind:Int, amount:Int, info:Int[], x:Int,y:Int)
		If kind < 0 Then Return ' empty
		
		SetColor 255,255,255
		SetScale 2,2
		DrawImage img[kind], x,y
		
		If countable[kind] Then
			SetColor 0,0,0
			EFONT.draw(amount, x+36 - EFONT.get_width(amount,2), y+26+2, 2) ' shadow
			SetColor 255,255,255
			EFONT.draw(amount, x+36 - EFONT.get_width(amount,2), y+26, 2)
		EndIf
		
		SetScale 1,1
	End Function
	
	Function draw_drop(kind:Int, amount:Int, info:Int[], x:Int,y:Int)
		If kind < 0 Then Return ' empty
		
		SetScale 2,2
		SetColor 255,255,255
		DrawImage img[kind], x-18,y-18
		SetScale 1,1
		
	End Function
End Type
' this is really weird...
Function ITEM_draw(kind:Int, amount:Int, info:Int[], x:Int,y:Int)
	ITEM.draw(kind, amount, info, x,y)
End Function

Type ITEMS_ARRAY
	Const PLAYER_SIZE:Int = 40
	
	Field stamp_counter:Int = 0 ' networking
	Field last_rcv_stamp:Int = 0
	
	Field size:Int
	'Field name:String ' eg: chest_worldid_cx_cy_x_y, inventory_u123 -> try keep it short and unique !
	Field identifyer:Int[]
	' [1, id] -> player
	' [2, world_id, scx, scy, chest_id]
	
	Field array_kind:Int[]
	Field array_amount:Int[]
	Field array_info:Int[][]
	
	Field netw_man:NETWORK_MANAGER
		
	Function Create:ITEMS_ARRAY(size:Int, identifyer:Int[], netw_man:NETWORK_MANAGER) ' size, world, super_chunk
		Local a:ITEMS_ARRAY = New ITEMS_ARRAY
				
		a.size = size
		a.identifyer = identifyer
		
		a.array_kind = New Int[size]
		a.array_amount = New Int[size]
		a.array_info = New Int[][size]
		
		For Local i:Int = 0 To a.size-1
			a.array_kind[i] = -1 ' invalid
		Next
		
		a.netw_man = netw_man
		
		Return a
	End Function
	
	Method get_next_stamp:Int() ' can be used for sending item data
		stamp_counter:+1
		Return stamp_counter
	End Method
	
	Method add_item(kind:Int Var, amount:Int Var, info:Int[] Var)
		' kind will be -1 if all absorbed
		' otherwise amount reduced, if space
		
		If ITEM.countable[kind] Then
			' find alike
			For Local i:Int = 0 To size-1
				If array_kind[i] = kind Then
					array_amount[i]:+amount
					kind = -1
					amount = 0
					
					Exit
				EndIf
			Next
		EndIf
		
		If kind >= 0 Then ' still some left -> find new slot
			For Local i:Int = 0 To size-1
				If array_kind[i] = -1 Then
					array_kind[i] = kind
					array_amount[i] = amount
					array_info[i] = info
					
					kind = -1
					amount = 0
					
					Exit
				EndIf
			Next
		EndIf
	End Method
	
	Method take_item:Int(index:Int, amount:Int) ' returns amount really taken
		If array_kind[index] > -1 Then
			If array_amount[index] > 0 Then
				amount = Min(amount, array_amount[index])
				
				array_amount[index]:-amount
				
				If array_amount[index] = 0 Then
					array_kind[index] = -1
					array_info[index] = New Int[0]
				EndIf
				
				Return amount
			EndIf
		EndIf
		
		Return 0
	End Method
	
	' returns new amount to be transacted
	Function adjust_transaction:Int(from_array:ITEMS_ARRAY, from_index:Int, to_array:ITEMS_ARRAY, to_index:Int, amount:Int)
		
		If to_array.array_kind[to_index] = -1 Then
			' to is empty !
		Else
			If from_array.array_kind[from_index] <> to_array.array_kind[to_index] Then Return 0 ' abort
			
			If Not ITEM.countable[from_array.array_kind[from_index]] Then Return 0 ' abort -> not countable !
		EndIf
		
		If from_array.array_amount[from_index] < amount Then
			Return from_array.array_amount[from_index]
		EndIf
		
		Return amount
	End Function
	
	' assumes you have done the adjust_transaction !
	Function do_transaction:Int(from_array:ITEMS_ARRAY, from_index:Int, to_array:ITEMS_ARRAY, to_index:Int, amount:Int)
		
		If amount = 0 Then Return False
		
		If to_array.array_kind[to_index] = -1 Then
			' empty !
			
			' add new:
			to_array.array_kind[to_index] = from_array.array_kind[from_index]
			to_array.array_amount[to_index] = amount
			to_array.array_info[to_index] = from_array.array_info[from_index] ' should be copy ?
			
			' subtract old:
			from_array.array_amount[from_index]:-amount
			If from_array.array_amount[from_index] = 0 Then
				from_array.array_kind[from_index] = -1
				from_array.array_info[from_index] = New Int[0]
			EndIf
		Else
			' already something there !
			
			' add:
			to_array.array_amount[to_index]:+ amount
			
			' subtract old:
			from_array.array_amount[from_index]:-amount
			If from_array.array_amount[from_index] = 0 Then
				from_array.array_kind[from_index] = -1
				from_array.array_info[from_index] = New Int[0]
			EndIf
		EndIf
	End Function
	'------------------------------------- NETWORKING:
	
	Method write_to_stream(stream:TStream)
		stream.WriteInt(identifyer.length) ' name
		For Local i:Int = 0 To identifyer.length-1
			stream.WriteInt(identifyer[i])
		Next
		
		stamp_counter:+1
		stream.WriteInt(stamp_counter)
		
		stream.WriteInt(size)
		
		For Local i:Int = 0 To size-1
			stream.WriteInt(array_kind[i])
			stream.WriteInt(array_amount[i])
			
			stream.WriteInt(array_info[i].length)
			For Local k:Int = 0 To array_info[i].length-1
				stream.WriteInt(array_info[i][k])
			Next
		Next
	End Method
	
	' already read (to find and potentially create)
	'    -> name
	'    -> stamp
	'    -> size
	Method read_from_stream(stream:TStream, stamp:Int, size:Int)
		
		If size <> Self.size Then RuntimeError("size mismatch !")
		
		If stamp > last_rcv_stamp Then
			last_rcv_stamp = stamp
			
			For Local i:Int = 0 To size-1
				array_kind[i] = stream.ReadInt()
				array_amount[i] = stream.ReadInt()
				
				Local info_len:Int = stream.ReadInt()
				array_info[i] = New Int[info_len]
				For Local k:Int = 0 To info_len-1
					array_info[i][k] = stream.ReadInt()
				Next
			Next
		Else
			' ignore data:
			For Local i:Int = 0 To size-1
				stream.ReadInt()
				stream.ReadInt()
				
				Local info_len:Int = stream.ReadInt()
				For Local k:Int = 0 To info_len-1
					stream.ReadInt()
				Next
			Next
		EndIf
	End Method
	
	Function ignore_data(stream:TStream, stamp:Int, size:Int)
		For Local i:Int = 0 To size-1
			stream.ReadInt()
			stream.ReadInt()
			
			Local info_len:Int = stream.ReadInt()
			For Local k:Int = 0 To info_len-1
				stream.ReadInt()
			Next
		Next
	End Function
End Type




Type BLOCK_UPDATE_ARRAY
	Field stamp_counter:Int = 0
	
	Field size:Int
	Field write_pos:Int
	
	Field world_id:Int
	Field sc_x:Int
	Field sc_y:Int
	
	Field array_stamp:Int[]
	
	Field array_x:Int[]
	Field array_y:Int[]
	
	Field array_block_0:Short[]
	Field array_block_1:Short[]
	
	Field array_liquid:Int[]
	Field array_liquid_plus:Int[]
	Field array_liquid_type:Byte[]
	
	Function Create:BLOCK_UPDATE_ARRAY(size:Int, world_id:Int, sc_x:Int, sc_y:Int) ' size, world, super_chunk
		Local a:BLOCK_UPDATE_ARRAY = New BLOCK_UPDATE_ARRAY
				
		a.size = size
		a.write_pos = 0
		
		a.world_id = world_id
		a.sc_x = sc_x
		a.sc_y = sc_y
		
		a.array_stamp = New Int[size]
		
		a.array_x = New Int[size]
		a.array_y = New Int[size]
		
		a.array_block_0 = New Short[size]
		a.array_block_1 = New Short[size]
		
		a.array_liquid = New Int[size]
		a.array_liquid_plus = New Int[size]
		a.array_liquid_type = New Byte[size]
		
		For Local i:Int = 0 To size-1
			a.array_stamp[i] = -1 ' invalid
		Next
		
		Return a
	End Function
	
	Method get_next_stamp:Int() ' can be used for sending chunk data.
		stamp_counter:+1
		Return stamp_counter
	End Method
	
	Method write(x:Int, y:Int, block_0:Short, block_1:Short, liquid:Int, liquid_plus:Int, liquid_type:Byte)
		'Print("added: " + x + " " + y + " " + block_0 + " " + block_1 + " " + liquid + " " + liquid_plus + " " + liquid_type)
		
		stamp_counter:+1
		array_stamp[write_pos] = stamp_counter
		
		array_x[write_pos] = x
		array_y[write_pos] = y
		
		array_block_0[write_pos] = block_0
		array_block_1[write_pos] = block_1
		
		array_liquid[write_pos] = liquid
		array_liquid_plus[write_pos] = liquid_plus
		array_liquid_type[write_pos] = liquid_type
		
		' at the end
		write_pos = (write_pos+1) Mod size
	End Method
	
	Method write_to_stream(stream:TStream)
		stream.WriteInt(size)
		
		stream.WriteInt(world_id)
		stream.WriteInt(sc_x)
		stream.WriteInt(sc_y)
		
		Local i:Int = write_pos ' ------------> this ensures that old sent first !
		For Local count:Int = 0 To size-1
			
			stream.WriteInt(array_stamp[i])
			
			stream.WriteInt(array_x[i])
			stream.WriteInt(array_y[i])
			
			stream.WriteShort(array_block_0[i])
			stream.WriteShort(array_block_1[i])
			
			stream.WriteInt(array_liquid[i])
			stream.WriteInt(array_liquid_plus[i])
			stream.WriteByte(array_liquid_type[i])
			
			i = (i+1) Mod size
		Next
		
	End Method
	
	' first must read size, world_id, sc_x, scy
	'     -> then loop that many times over this:
	Function get_next_from_stream(stream:TStream,stamp:Int Var, x:Int Var, y:Int Var, block_0:Short Var, block_1:Short Var, liquid:Int Var, liquid_plus:Int Var, liquid_type:Byte Var)
		
		stamp = stream.ReadInt()
		
		x = stream.ReadInt()
		y = stream.ReadInt()
		
		block_0 = stream.ReadShort()
		block_1 = stream.ReadShort()
		
		liquid = stream.ReadInt()
		liquid_plus = stream.ReadInt()
		liquid_type = stream.ReadByte()
		
	End Function
End Type

Type CONDITIONAL_ACTION_ARRAY
	Const BREAK_BLOCK_BACK:Int = 1
	Const BREAK_BLOCK_FRONT:Int = 2
	Const PUT_BLOCK_BACK:Int = 3
	Const PUT_BLOCK_FRONT:Int = 4
	Const PUT_LIQUID:Int = 5
	Const MOVE_ITEMS:Int = 6
	Const PUT_BLK_OBJ:Int = 7
	Const BREAK_BLK_OBJ:Int = 8
	
	Field stamp_counter:Int = 0
	
	Field size:Int
	Field write_pos:Int
	
	Field array_stamp:Int[]
	
	Field array_world_id:Int[]
	
	Field array_action:Int[]
	
	Field array_x:Int[]
	Field array_y:Int[]
	
	Field array_valnum:Int[]
	Field array_values:Int[][]
		
	Function Create:CONDITIONAL_ACTION_ARRAY(size:Int)
		Local a:CONDITIONAL_ACTION_ARRAY = New CONDITIONAL_ACTION_ARRAY
		
		a.size = size
		a.write_pos = 0
		
		a.array_stamp = New Int[size]
		
		a.array_world_id = New Int[size]
		
		a.array_action = New Int[size]
		
		a.array_x = New Int[size]
		a.array_y = New Int[size]
		
		a.array_valnum = New Int[size]
		a.array_values = New Int[][size]
		
		For Local i:Int = 0 To size-1
			a.array_stamp[i] = -1 ' invalid
			a.array_action[i] = -1
			a.array_valnum[i] = 0
		Next
		
		Return a
	End Function
	
	' ---------------------------------------------------------------- ACTION-WRITE
	Method write_break_block_front(world_id:Int, x:Int, y:Int, block_0:Int, block_1:Int)
		' input blocks are the old ones at that place
		
		stamp_counter:+1
		array_stamp[write_pos] = stamp_counter
		
		array_action[write_pos] = BREAK_BLOCK_FRONT
		
		array_world_id[write_pos] = world_id
		
		array_x[write_pos] = x
		array_y[write_pos] = y
		
		array_valnum[write_pos] = 2
		array_values[write_pos] = [block_0, block_1]
		
		' at the end
		write_pos = (write_pos+1) Mod size
	End Method
	
	Method write_break_block_back(world_id:Int, x:Int, y:Int, block_0:Int, block_1:Int)
		' input blocks are the old ones at that place
		
		stamp_counter:+1
		array_stamp[write_pos] = stamp_counter
		
		array_action[write_pos] = BREAK_BLOCK_BACK
		
		array_world_id[write_pos] = world_id
		
		array_x[write_pos] = x
		array_y[write_pos] = y
		
		array_valnum[write_pos] = 2
		array_values[write_pos] = [block_0, block_1]
		
		' at the end
		write_pos = (write_pos+1) Mod size
	End Method
	
	Method write_put_block_back(world_id:Int, x:Int, y:Int, block_0:Int, block_1:Int, new_bock:Int, inventory_index:Int)
		' input blocks are the old ones at that place
		
		stamp_counter:+1
		array_stamp[write_pos] = stamp_counter
		
		array_action[write_pos] = PUT_BLOCK_BACK
		
		array_world_id[write_pos] = world_id
		
		array_x[write_pos] = x
		array_y[write_pos] = y
		
		array_valnum[write_pos] = 4
		array_values[write_pos] = [block_0, block_1,new_bock, inventory_index]
		
		' at the end
		write_pos = (write_pos+1) Mod size
	End Method
	
	Method write_put_block_front(world_id:Int, x:Int, y:Int, block_0:Int, block_1:Int, new_bock:Int, inventory_index:Int)
		' input blocks are the old ones at that place
		
		stamp_counter:+1
		array_stamp[write_pos] = stamp_counter
		
		array_action[write_pos] = PUT_BLOCK_FRONT
		
		array_world_id[write_pos] = world_id
		
		array_x[write_pos] = x
		array_y[write_pos] = y
		
		array_valnum[write_pos] = 4
		array_values[write_pos] = [block_0, block_1,new_bock, inventory_index]
		
		' at the end
		write_pos = (write_pos+1) Mod size
	End Method
	
	Method write_put_liquid(world_id:Int, x:Int, y:Int, block_0:Int, block_1:Int, amount:Int, typ:Byte, inventory_index:Int)
		' input blocks are the old ones at that place
		
		stamp_counter:+1
		array_stamp[write_pos] = stamp_counter
		
		array_action[write_pos] = PUT_LIQUID
		
		array_world_id[write_pos] = world_id
		
		array_x[write_pos] = x
		array_y[write_pos] = y
		
		array_valnum[write_pos] = 5
		array_values[write_pos] = [block_0, block_1, amount, Int(typ), inventory_index]
		
		' at the end
		write_pos = (write_pos+1) Mod size
	End Method
	
	
	Method write_move_items(from_identifyer:Int[], from_index:Int, from_kind:Int, to_identifyer:Int[], to_index:Int, to_kind:Int, move_amount:Int) ' don't care about info for now...
		' input blocks are the old ones at that place
		
		stamp_counter:+1
		array_stamp[write_pos] = stamp_counter
		
		array_action[write_pos] = MOVE_ITEMS
		
		array_world_id[write_pos] = -1 ' independent
		
		array_x[write_pos] = -1
		array_y[write_pos] = -1
		
		array_valnum[write_pos] = 7 + from_identifyer.length + to_identifyer.length
		array_values[write_pos] = [from_identifyer.length] + from_identifyer + [from_index, from_kind, to_identifyer.length] + to_identifyer + [to_index, to_kind, move_amount]
		
		' at the end
		write_pos = (write_pos+1) Mod size
	End Method
	
	Method write_put_blk_obj(world_id:Int, x:Int, y:Int, kind:Int, inventory_index:Int, item_kind:Int)
		' input blocks are the old ones at that place
		
		stamp_counter:+1
		array_stamp[write_pos] = stamp_counter
		
		array_action[write_pos] = PUT_BLK_OBJ
		
		array_world_id[write_pos] = world_id
		
		array_x[write_pos] = x
		array_y[write_pos] = y
		
		array_valnum[write_pos] = 3
		array_values[write_pos] = [kind, inventory_index, item_kind]
		
		' at the end
		write_pos = (write_pos+1) Mod size
	End Method
	
	Method write_break_blk_obj(world_id:Int, x:Int, y:Int, block_obj_type:Int)
		' input blocks are the old ones at that place
		
		stamp_counter:+1
		array_stamp[write_pos] = stamp_counter
		
		array_action[write_pos] = BREAK_BLK_OBJ
		
		array_world_id[write_pos] = world_id
		
		array_x[write_pos] = x
		array_y[write_pos] = y
		
		array_valnum[write_pos] = 1
		array_values[write_pos] = [block_obj_type]
		
		' at the end
		write_pos = (write_pos+1) Mod size
	End Method
		
	'------------------------------------------------------------------------ NETWORKING
	Method write_to_stream(stream:TStream)
		stream.WriteInt(size)
				
		Local i:Int = write_pos ' ------------> this ensures that old sent first !
		For Local count:Int = 0 To size-1
			
			stream.WriteInt(array_stamp[i])
			
			stream.WriteInt(array_world_id[i])
			stream.WriteInt(array_action[i])
			
			stream.WriteInt(array_x[i])
			stream.WriteInt(array_y[i])
			
			stream.WriteInt(array_valnum[i])
			
			For Local k:Int = 0 To array_valnum[i]-1
				stream.WriteInt(array_values[i][k])
			Next
						
			i = (i+1) Mod size
		Next
		
	End Method
	
	' first must read size
	'     -> then loop that many times over this:
	Function get_next_from_stream(stream:TStream,stamp:Int Var, world_id:Int Var, action:Int Var, x:Int Var, y:Int Var, valnum:Int Var, values:Int[] Var)
		
		stamp = stream.ReadInt()
		
		world_id = stream.ReadInt()
		action = stream.ReadInt()
		
		x = stream.ReadInt()
		y = stream.ReadInt()
		
		valnum = stream.ReadInt()
		
		values = New Int[valnum]
		For Local k:Int = 0 To valnum-1
			values[k] = stream.ReadInt() ' crash count 1
		Next
	End Function
End Type


Type MESSAGE_UPDATE_ARRAY
	Field stamp_counter:Int = 0
	
	Field size:Int
	Field write_pos:Int
	
	Field array_stamp:Int[]
	
	Field array_text:String[]
		
	Function Create:MESSAGE_UPDATE_ARRAY(size:Int)
		Local a:MESSAGE_UPDATE_ARRAY = New MESSAGE_UPDATE_ARRAY
		
		a.size = size
		a.write_pos = 0
		
		a.array_stamp = New Int[size]
		
		a.array_text = New String[size]
		
		For Local i:Int = 0 To size-1
			a.array_stamp[i] = -1 ' invalid
			a.array_text[i] = "" ' invalid
		Next
		
		Return a
	End Function
	
	Method write(txt:String)
		'Print("added: " + x + " " + y + " " + block_0 + " " + block_1 + " " + liquid + " " + liquid_plus + " " + liquid_type)
		
		stamp_counter:+1
		array_stamp[write_pos] = stamp_counter
		
		array_text[write_pos] = txt
		
		' at the end
		write_pos = (write_pos+1) Mod size
	End Method
	
	Method write_to_stream(stream:TStream)
		stream.WriteInt(size)
		
		Local i:Int = write_pos ' ------------> this ensures that old sent first !
		For Local count:Int = 0 To size-1
			stream.WriteInt(array_stamp[i])
			
			stream.WriteInt(array_text[i].length)
			stream.WriteString(array_text[i])
			
			i = (i+1) Mod size
		Next
	End Method
	
	' first must read size (int), then loop that many times over this:
	Function get_next_from_stream(stream:TStream, stamp:Int Var, txt:String Var)
		
		stamp = stream.ReadInt()
		
		Local length:Int = stream.ReadInt()
		
		txt = stream.ReadString(length)		
	End Function
End Type


'#######################################  PACKAGE MANAGER   #########################################
Type Package_Manager
	Function execute(Stream:TUDPStream, client:T_S_Client, universe:VOXEL_UNIVERSE, netw_man:NETWORK_MANAGER)
		If client Then client.last_update_from = MilliSecs()
		
		Local code:Short = Stream.ReadShort()
		
		Select code
			Case 112
				Package_Manager.read_safety(Stream)
				
				Print("got empty package!")
			Case 113
				' got ping (from client)
				Package_Manager.read_safety(Stream)
				
				Package_Manager.send_pong(client.send_stream)
				
				Print("got ping")
			Case 114
				' got pong (from server)
				Package_Manager.read_safety(Stream)
				
				Print("got pong")
			Case 1001
				' set client join package
				Local clientside_port:Int = Stream.ReadInt()
				Local name_size:Int = Stream.ReadInt()
				Local name_rcv:String = Stream.ReadString(name_size)
				
				Package_Manager.read_safety(Stream)
				
				client.set_client_join(clientside_port, name_rcv)
			Case 1002
				' request metadata
				If Not (netw_man.mode = NETWORK_MANAGER.SERVER) Then
					RuntimeError("should not be requested metadata as non-server !")
				EndIf
				
				Local rcv_world_id:Int = Stream.ReadInt()
				
				Package_Manager.read_safety(Stream)
				
				Print("request metadata " + client.get_print())
				
				Local super_grid:VOXEL_SUPER_GRID = universe.find_world_if_loaded:VOXEL_SUPER_GRID(rcv_world_id)
				
				Package_Manager.send_metadata(client.send_stream, rcv_world_id,..
					super_grid.super_chunk_size_chunks,..
					super_grid.chunk_size_blocks,..
					super_grid.size_x,..
					super_grid.size_y)
			Case 2002
				' receive metadata
				If Not (netw_man.mode = NETWORK_MANAGER.CLIENT) Then
					RuntimeError("should not be receiving metadata as non-client !")
				EndIf
				
				Local rcv_world_id:Int = Stream.ReadInt()
				
				Local super_grid:VOXEL_SUPER_GRID = universe.find_world_if_loaded(rcv_world_id)
				
				If Not super_grid Then
					RuntimeError("world not found, not wanted ? " + rcv_world_id)
				EndIf
				
				super_grid.super_chunk_size_chunks = Stream.ReadInt()
				super_grid.chunk_size_blocks = Stream.ReadInt()
								
				super_grid.super_chunk_size_blocks = super_grid.super_chunk_size_chunks * super_grid.chunk_size_blocks
				
				super_grid.size_x = Stream.ReadInt()
				super_grid.size_y = Stream.ReadInt()
				
				If Not super_grid.super_chunks Then
					super_grid.super_chunks = New VOXEL_SUPER_CHUNK[super_grid.size_x,super_grid.size_y]
					super_grid.empty_super_chunk = VOXEL_SUPER_CHUNK.make_empty(super_grid)
				EndIf
				
				Package_Manager.read_safety(Stream)
			Case 1004 ' request cliend id
				If Not (netw_man.mode = NETWORK_MANAGER.SERVER) Then
					RuntimeError("should not be requested client_id as non-server !")
				EndIf
				
				Package_Manager.read_safety(Stream)
				
				Package_Manager.send_client_id(client.send_stream, client.id)
			Case 2004 ' receive my (client) id
				If Not (netw_man.mode = NETWORK_MANAGER.CLIENT) Then
					RuntimeError("should not be sent client_id as non-client !")
				EndIf
				
				Local my_id:Int = Stream.ReadInt()
				Package_Manager.read_safety(Stream)
				
				netw_man.my_id = my_id
				
			Case 1005 ' request full data
				If Not (netw_man.mode = NETWORK_MANAGER.SERVER) Then
					RuntimeError("should not be requested full_data as non-server !")
				EndIf
				
				Local rcv_world_id:Int = Stream.ReadInt()
				Local super_grid:VOXEL_SUPER_GRID = universe.find_world_if_loaded:VOXEL_SUPER_GRID(rcv_world_id)
				
				Local data_x:Int = Stream.ReadInt()
				Local data_y:Int = Stream.ReadInt()
				
				Package_Manager.read_safety(Stream)
				
				Print("request full_data " + client.get_print() + " -> " + data_x + " " + data_y)
				
				Package_Manager.send_back_full_data(client.send_stream, rcv_world_id, data_x, data_y, super_grid)
			Case 2005 ' receive full data
				If Not (netw_man.mode = NETWORK_MANAGER.CLIENT) Then
					RuntimeError("should not be receiving full_data as non-client !")
				EndIf
				
				Local rcv_world_id:Int = Stream.ReadInt()
				Local super_grid:VOXEL_SUPER_GRID = universe.find_world_if_loaded:VOXEL_SUPER_GRID(rcv_world_id)
				' will crash here probably ?
				
				Local data_x:Int = Stream.ReadInt()
				Local data_y:Int = Stream.ReadInt()
				
				Local data_stamp:Int = Stream.ReadInt()
				
				Local sc:VOXEL_SUPER_CHUNK
				
				If super_grid.super_chunk_exists(data_x,data_y) Then
					sc = super_grid.get_super_chunk(data_x,data_y)
					sc.last_receive_full_data = MilliSecs()
					
					sc.rcv_last_data_stamp = data_stamp
					sc.rcv_last_block_update_stamp = data_stamp
				EndIf
				
				For Local typ:Int = 1 To 5
					Local data_size:Int = Stream.ReadInt()
					Local rcv_bank:TBank = CreateBank(data_size)
					Stream.ReadBytes(rcv_bank.Buf(), data_size)
					
					If sc Then
						sc.set_cpr_bank(rcv_bank, typ)
					EndIf
				Next
				
				Package_Manager.read_safety(Stream)
				
			Case 1006 ' send_request_metadata_universe
				If Not (netw_man.mode = NETWORK_MANAGER.SERVER) Then
					RuntimeError("should not be requested universe_metadata as non-server !")
				EndIf
				
				Package_Manager.read_safety(Stream)
				
				Print("send universe metadata: " + client.world.id)
				
				Package_Manager.send_metadata_universe(client.send_stream, client.world.id)
			Case 2006 ' send_metadata_universe
				If Not (netw_man.mode = NETWORK_MANAGER.CLIENT) Then
					RuntimeError("should not be receiving universe_metadata as non-client !")
				EndIf
				
				Local rcv_world_id:Int = Stream.ReadInt()
				Package_Manager.read_safety(Stream)
				
				Print("received universe metadata: " + rcv_world_id)
				
				netw_man.client_connector.my_start_world_id = rcv_world_id
			Case 1007 ' item_array request
				RuntimeError("implement item_array request")
				
			Case 2007 ' item_array data
				If Not (netw_man.mode = NETWORK_MANAGER.CLIENT) Then
					RuntimeError("should not be receiving item_array as non-client !")
				EndIf
								
				Local a_identifyer_len:Int = Stream.ReadInt()
				Local a_identifyer:Int[] = New Int[a_identifyer_len]
				
				For Local i:Int = 0 To a_identifyer_len-1
					a_identifyer[i] = Stream.ReadInt()
				Next
				
				Local a_stamp:Int = Stream.ReadInt()
				Local a_size:Int = Stream.ReadInt()
				
				If netw_man.client_connector.inventory Then ' else not ready anyway.
					' find it!
					Local inv:ITEMS_ARRAY = universe.find_item_array(a_identifyer)
					
					If inv Then
						inv.read_from_stream(Stream, a_stamp, a_size)
					Else
						ITEMS_ARRAY.ignore_data(Stream, a_stamp, a_size)
						Print "rcv: item_array not found !"
					EndIf
					Rem
					Local pl_inv:ITEMS_ARRAY = netw_man.client_connector.inventory
					
					If (a_identifyer[0] = pl_inv.identifyer[0]) And (a_identifyer[1] = pl_inv.identifyer[1]) Then
						netw_man.client_connector.inventory.read_from_stream(Stream, a_stamp, a_size)
					Else
						RuntimeError("implement find or create array !")
						
						'find_item_array:ITEMS_ARRAY(identifyer:Int[])
						asdfasdfasdf
					EndIf
					End Rem
				Else
					ITEMS_ARRAY.ignore_data(Stream, a_stamp, a_size)
				EndIf
				Package_Manager.read_safety(Stream)
			Case 3001 ' objects update
				
				If universe Then
					Local rcv_world_id:Int = Stream.ReadInt()
					Local super_grid:VOXEL_SUPER_GRID = universe.find_world_if_loaded(rcv_world_id)
					
					If super_grid Then
						TOBJECT.stream_to_map(super_grid.object_map, Stream, netw_man, super_grid)
						Package_Manager.read_safety(Stream)
					Else
						Select netw_man.mode
							Case NETWORK_MANAGER.CLIENT
								' all ok, can happen, should not?
								'RuntimeError("all ok, can happen, should not?")
							Case NETWORK_MANAGER.SERVER
								RuntimeError("world not found for objects update, despite being server !?")
							Default
								RuntimeError("mode not implemented")
						End Select
						
						Print("flush 1")
						Local m:TMap = CreateMap()
						TOBJECT.stream_to_map(m, Stream, netw_man, Null)
						Package_Manager.read_safety(Stream)
						'Package_Manager.flush_comm(Stream)
					EndIf
				Else
					' client not ready yet -> flush
					Print("flush 2")
					Local rcv_world_id:Int = Stream.ReadInt()
					
					Local m:TMap = CreateMap()
					TOBJECT.stream_to_map(m, Stream, netw_man, Null)
					Package_Manager.read_safety(Stream)
					'Package_Manager.flush_comm(Stream)
				EndIf
			Case 3002 ' block update
				
				Local size:Int = Stream.ReadInt()
				Local world_id:Int = Stream.ReadInt()
				Local sc_x:Int = Stream.ReadInt()
				Local sc_y:Int = Stream.ReadInt()
				
				If universe Then
				
					Local super_grid:VOXEL_SUPER_GRID = universe.find_world_if_loaded(world_id)
					Local super_c:VOXEL_SUPER_CHUNK
					If super_grid Then
						If super_grid.super_chunk_data_loaded(sc_x, sc_y) Then
							super_c = super_grid.get_super_chunk(sc_x, sc_y)
						EndIf
					EndIf
					
					Select netw_man.mode
						Case NETWORK_MANAGER.SERVER
							If super_grid Then
								If super_c Then
									super_c.read_block_update_from_stream(Stream, size)
								Else
									VOXEL_SUPER_CHUNK.ignore_block_update_from_stream(Stream, size)
								EndIf
							Else
								If world_id <> -1 Then
									RuntimeError("(block_update) could not find world: " + world_id)
								EndIf
							EndIf
						Case NETWORK_MANAGER.CLIENT
							If super_grid Then
								If super_c Then
									super_c.read_block_update_from_stream(Stream, size)
								Else
									VOXEL_SUPER_CHUNK.ignore_block_update_from_stream(Stream, size)
								EndIf
							Else
								VOXEL_SUPER_CHUNK.ignore_block_update_from_stream(Stream, size)
							EndIf
						Default
							RuntimeError("not implemented")
					End Select
				Else
					VOXEL_SUPER_CHUNK.ignore_block_update_from_stream(Stream, size)
				EndIf
				
				Rem				
				For Local i:Int = 1 To size
					Local stamp:Int
					
					Local x:Int
					Local y:Int
					
					Local block_0:Short
					Local block_1:Short
					
					Local liquid:Int
					Local liquid_plus:Int
					Local liquid_type:Byte
					
					netw_man.block_update.get_next_from_stream(Stream, stamp, world_id, x, y, block_0, block_1, liquid, liquid_plus, liquid_type)
					'Print(stamp + " " + x + " " + y + " " + block_0 + " " + block_1 + " " + liquid + " " + liquid_plus + " " + liquid_type)
					
					Select netw_man.mode
						Case NETWORK_MANAGER.SERVER
							'client.highest_block_stamp
							If stamp > client.highest_block_stamp Then ' new update, else ignore info
								client.highest_block_stamp = stamp
								
								
								If super_grid Then
									super_grid.grid.action_set_full_block(True , x, y, block_0, block_1, liquid, liquid_plus, liquid_type)
								Else
									If world_id <> -1 Then
										RuntimeError("(block_update) could not find world: " + world_id)
									EndIf
								EndIf
							EndIf
						Case NETWORK_MANAGER.CLIENT
							If stamp > netw_man.client_connector.server_highest_block_stamp Then ' new update, else ignore info
								netw_man.client_connector.server_highest_block_stamp = stamp
								If universe Then
									
									
									If super_grid Then
										super_grid.grid.action_set_full_block(True , x, y, block_0, block_1, liquid, liquid_plus, liquid_type)
									EndIf
								EndIf
							EndIf
						Default
							RuntimeError("not implemented")
					End Select
				Next
				End Rem
				
				Package_Manager.read_safety(Stream)
			Case 3003 ' msg update
				
				Local size:Int = Stream.ReadInt()
				
				For Local i:Int = 1 To size
					Local stamp:Int
					
					Local txt:String
					
					MESSAGE_UPDATE_ARRAY.get_next_from_stream(Stream, stamp, txt)
					
					Select netw_man.mode
						Case NETWORK_MANAGER.SERVER
							If stamp > client.msg_last_stamp_receive Then ' new update, else ignore info
								client.msg_last_stamp_receive = stamp
								
								Local cmd:String = COMMAND.is_cmd(txt)
								If cmd <> "" Then
									COMMAND.execute(cmd, universe.cons, netw_man, client)
								Else
									universe.cons.put("%o%<" + client.name + ">%std% " + txt)
									T_S_Client.msg_send_all("%o%<" + client.name + ">%std% " + txt)
								EndIf
							EndIf
						Case NETWORK_MANAGER.CLIENT
							If universe Then
								If stamp > netw_man.client_connector.msg_last_stamp_receive Then ' new update, else ignore info
									netw_man.client_connector.msg_last_stamp_receive = stamp
									
									Local cmd:String = COMMAND.is_cmd(txt)
									If cmd <> "" Then
										COMMAND.execute(cmd, universe.cons, netw_man, Null)
									Else
										universe.cons.put(txt)
									EndIf
								EndIf
							EndIf
						Default
							RuntimeError("not implemented mode")
					End Select
				Next
				Package_Manager.read_safety(Stream)
			Case 3004
				If Not (netw_man.mode = NETWORK_MANAGER.CLIENT) Then
					Print("should not be kicked as non-client !")
				Else
					EndGraphics()
					
					Print("")
					Print("you were KICKED.")
					Print("")
					Print("possible causes:")
					Print(" (1) bad behaviour")
					Print(" (2) duplicate name -> instant reject")
					Print(" (3) too quickly logged back in (wait 20 sec)")
					Print("")
					Input("hit ENTER to quit> ")
					End
				EndIf
			Case 3005
				If Not (netw_man.mode = NETWORK_MANAGER.SERVER) Then
					Print("should not get conditional_action as non-server !")
				EndIf
				
				If Not client Then
					Print("should only get conditional_action as server, and WITH CLIENT !")
				EndIf
				
				Local size:Int = Stream.ReadInt()
				
				
				For Local i:Int = 1 To size
					Local stamp:Int
					
					Local world_id:Int
					Local action:Int
					
					Local x:Int
					Local y:Int
					
					Local valnum:Int
					Local values:Int[]
					
					CONDITIONAL_ACTION_ARRAY.get_next_from_stream(Stream,stamp,world_id,action,x,y,valnum,values)
					
					If stamp > client.latest_action_stamp Then
						client.latest_action_stamp = stamp
						Local super_grid:VOXEL_SUPER_GRID = universe.find_world_if_loaded(world_id)
						
						Select action
							Case -1 ' nothing
							Case CONDITIONAL_ACTION_ARRAY.BREAK_BLOCK_BACK
								If super_grid Then
									Local is_b0:Short = super_grid.get_block_truncated(x,y, 0)
									Local is_b1:Short = super_grid.get_block_truncated(x,y, 1)
									
									If is_b0 = values[0] And is_b1 = values[1] Then
										super_grid.grid.action_set_full_block(True , x, y, 0, -1, -1,-1,-1)
										
										If VOXEL_BLOCK.item_when_breaking[is_b0] > -1 Then
											Local kind_:Int = VOXEL_BLOCK.item_when_breaking[is_b0]
											Local amount_:Int = 1
											Local info_:Int[] = New Int[0]
											'client.inventory.add_item(kind_,amount_,info_) ' what if does not take ?
											
											Local d_x:Int = x*super_grid.grid.block_size+super_grid.grid.block_size/2
											Local d_y:Int = y*super_grid.grid.block_size+super_grid.grid.block_size/2
											TITEM_DROP.Create(d_x,d_y, kind_,amount_,info_, super_grid, NETWORK_MANAGER.SERVER_ID, False, Null)
										EndIf
									Else
										Print("reject break back")
									EndIf
								EndIf
							Case CONDITIONAL_ACTION_ARRAY.BREAK_BLOCK_FRONT
								If super_grid Then
									Local is_b0:Short = super_grid.get_block_truncated(x,y, 0)
									Local is_b1:Short = super_grid.get_block_truncated(x,y, 1)
									
									If is_b0 = values[0] And is_b1 = values[1] Then
										super_grid.grid.action_set_full_block(True , x, y, -1, 0, -1,-1,-1)
										
										If VOXEL_BLOCK.item_when_breaking[is_b1] > -1 Then
											Local kind_:Int = VOXEL_BLOCK.item_when_breaking[is_b1]
											Local amount_:Int = 1
											Local info_:Int[] = New Int[0]
											'client.inventory.add_item(kind_,amount_,info_) ' what if does not take ?
											
											Local d_x:Int = x*super_grid.grid.block_size+super_grid.grid.block_size/2
											Local d_y:Int = y*super_grid.grid.block_size+super_grid.grid.block_size/2
											TITEM_DROP.Create(d_x,d_y, kind_,amount_,info_, super_grid, NETWORK_MANAGER.SERVER_ID, False, Null)
										EndIf
									Else
										Print("reject break front")
									EndIf
								EndIf
							Case CONDITIONAL_ACTION_ARRAY.PUT_BLOCK_FRONT
								If super_grid Then
									Local is_b0:Short = super_grid.get_block_truncated(x,y, 0)
									Local is_b1:Short = super_grid.get_block_truncated(x,y, 1)
									
									If is_b0 = values[0] And is_b1 = values[1] And client.inventory.array_kind[values[3]]>-1 And ITEM.typ[client.inventory.array_kind[values[3]]] = ITEM.TYPE_BLOCK And ITEM.get_block(client.inventory.array_kind[values[3]]) = values[2] Then
										'And ITEM.block_placable[client.inventory.array_kind[values[3]]] = values[2] Then
										super_grid.grid.action_set_full_block(True , x, y, -1, values[2], 0,0,0)
										
										'values[3] -> inventory index
										client.inventory.take_item(values[3], 1)
									Else
										Print("reject put front")
									EndIf
								EndIf
							Case CONDITIONAL_ACTION_ARRAY.PUT_BLOCK_BACK
								If super_grid Then
									Local is_b0:Short = super_grid.get_block_truncated(x,y, 0)
									Local is_b1:Short = super_grid.get_block_truncated(x,y, 1)
									
									If is_b0 = values[0] And is_b1 = values[1] And client.inventory.array_kind[values[3]]>-1 And ITEM.typ[client.inventory.array_kind[values[3]]] = ITEM.TYPE_BLOCK And ITEM.get_block(client.inventory.array_kind[values[3]]) = values[2] Then
										super_grid.grid.action_set_full_block(True , x, y, values[2],-1, -1,-1,-1)
										
										'values[3] -> inventory index
										client.inventory.take_item(values[3], 1)
									Else
										Print("reject put back")
									EndIf
								EndIf
							Case CONDITIONAL_ACTION_ARRAY.PUT_LIQUID
								If super_grid Then
									Local is_b0:Short = super_grid.get_block_truncated(x,y, 0)
									Local is_b1:Short = super_grid.get_block_truncated(x,y, 1)
									
									If is_b0 = values[0] And is_b1 = values[1] Then
										super_grid.grid.action_set_full_block(True , x, y, -1,-1, values[2],0,values[3])
										
										'values[4] -> inventory index
										client.inventory.take_item(values[4], 1)
									Else
										Print("reject put back")
									EndIf
								EndIf
							Case CONDITIONAL_ACTION_ARRAY.MOVE_ITEMS
								' let's disassemble the array:
								Local from_ident_len:Int = values[0]
								Local from_ident:Int[] = New Int[from_ident_len]
								
								For Local i:Int = 0 To from_ident_len-1
									from_ident[i] = values[1 + i]
								Next
								
								Local from_index:Int = values[1 + from_ident_len]
								Local from_kind:Int = values[1 + from_ident_len + 1]
								
								Local to_ident_len:Int = values[1 + from_ident_len + 2]
								Local to_ident:Int[] = New Int[to_ident_len]
								
								For Local i:Int = 0 To to_ident_len-1
									to_ident[i] = values[1 + from_ident_len + 3 + i]
								Next
								
								Local to_index:Int = values[1 + from_ident_len + 3 + to_ident_len]
								Local to_kind:Int = values[1 + from_ident_len + 3 + to_ident_len + 1]
								
								Local move_amount:Int = values[1 + from_ident_len + 3 + to_ident_len + 2]
																
								' find the arrays:
								
								Local from_array:ITEMS_ARRAY = universe.find_item_array(from_ident)
								Local to_array:ITEMS_ARRAY = universe.find_item_array(to_ident)
								
								If from_array And to_array Then
									' still possible ?
									
									Local new_amount:Int = ITEMS_ARRAY.adjust_transaction(from_array, from_index, to_array, to_index, move_amount)
									
									If new_amount = 0 Then
										Print("transaction cancled")
									ElseIf new_amount < move_amount Then
										Print("amount reduced")
									EndIf
									
									ITEMS_ARRAY.do_transaction(from_array, from_index, to_array, to_index, new_amount)
									
								Else
									Print("not both item_arrays found !")
								EndIf
							Case CONDITIONAL_ACTION_ARRAY.PUT_BLK_OBJ
								If super_grid Then
									' x,y,super_grid
									Local kind_:Int = values[0]
									Local index_:Int = values[1]
									Local item_kind_:Int = values[2]
									
									If client.inventory.array_kind[index_] = item_kind_ And client.inventory.take_item(index_, 1) Then
										BLOCK_OBJECT_MANAGER.place_server(kind_, super_grid, x,y)
										
										Print("server: put down that chest !")
									Else
										Print("server: reject chest placement ! " + client.inventory.array_kind[index_] + " " + item_kind_)
									EndIf
									
								EndIf
							Case CONDITIONAL_ACTION_ARRAY.BREAK_BLK_OBJ
								If super_grid Then
									' x,y,super_grid
									Local block_obj_kind_:Int = values[0]
									
									BLOCK_OBJECT_MANAGER.break_server(block_obj_kind_, super_grid, x,y)
								EndIf
							Default
								RuntimeError("invalid action !")
						End Select
					EndIf
				Next
				
				Package_Manager.read_safety(Stream)
			Case 3006 ' item_array_demand
				If Not (netw_man.mode = NETWORK_MANAGER.SERVER) Then
					Print("should not get item_array_demand as non-server !")
				EndIf
				
				If Not client Then
					Print("should only get item_array_demand as server, and WITH CLIENT !")
				EndIf
				
				client.item_array_demand.read_from_stream(Stream)
				
				Package_Manager.read_safety(Stream)
				'c.item_array_demand = ITEM_ARRAY_DEMAND.Create()
			Default
				Print("false code: " + code)
				
				Package_Manager.flush_comm(Stream)
			End Select
	End Function
	
	Function flush_comm(Stream:TUDPStream)
		While Not Stream.Eof()
			Stream.ReadByte() ' empty out data
		Wend
	EndFunction
	
	Function send_xy(Stream:TUDPStream, x:Int,y:Int)
		Stream.WriteShort(111)
		Stream.WriteInt(x)
		Stream.WriteInt(y)
		Package_Manager.write_safety(Stream)
		Stream.SendMsg()
	End Function
	
	Function send_empty_package(Stream:TUDPStream)
		Stream.WriteShort(112) ' code
		Package_Manager.write_safety(Stream)
		Stream.SendMsg()
	End Function
	
	Function send_ping(Stream:TUDPStream)
		Stream.WriteShort(113) ' code
		Package_Manager.write_safety(Stream)
		Stream.SendMsg()
	End Function
	
	Function send_pong(Stream:TUDPStream)
		Stream.WriteShort(114) ' code
		Package_Manager.write_safety(Stream)
		Stream.SendMsg()
	End Function
	
	Function send_client_join(Stream:TUDPStream, port:Int, name:String)
		Stream.WriteShort(1001) ' code for client join
		Stream.WriteInt(port)
		Stream.WriteInt(Len(name))
		stream.WriteString(name)
		Package_Manager.write_safety(Stream)
		Stream.SendMsg()
	End Function
		
	Function send_request_metadata(Stream:TUDPStream, world_id:Int)
		Stream.WriteShort(1002) ' code
		Stream.WriteInt(world_id)
		Package_Manager.write_safety(Stream)
		Stream.SendMsg()
	End Function
	
	Function send_metadata(Stream:TUDPStream, world_id:Int, super_chunk_size_chunks:Int, chunk_size_blocks:Int, size_x:Int, size_y:Int)
		Stream.WriteShort(2002) ' code
		
		Stream.WriteInt(world_id)
		
		Stream.WriteInt(super_chunk_size_chunks)
		Stream.WriteInt(chunk_size_blocks)
		Stream.WriteInt(size_x)
		Stream.WriteInt(size_y)
		
		Package_Manager.write_safety(Stream)
		Stream.SendMsg()
	End Function
		
	Function send_request_client_id(Stream:TUDPStream)
		Stream.WriteShort(1004)
		Package_Manager.write_safety(Stream)
		Stream.SendMsg()
	End Function
	
	Function send_client_id(Stream:TUDPStream, id:Int)
		Stream.WriteShort(2004)
		Stream.WriteInt(id)
		Package_Manager.write_safety(Stream)
		Stream.SendMsg()
	End Function
	
	Function send_request_full_data(Stream:TUDPStream, world_id:Int, x:Int, y:Int)
		Stream.WriteShort(1005) ' code
		
		Stream.WriteInt(world_id)
		
		Stream.WriteInt(x)
		Stream.WriteInt(y)
		Package_Manager.write_safety(Stream)
		Stream.SendMsg()
	End Function
	
	Function send_back_full_data(Stream:TUDPStream, world_id:Int, data_x:Int, data_y:Int,  super_grid:VOXEL_SUPER_GRID)
		If Not super_grid.super_chunk_exists(data_x,data_y) Then
			Print(" <!> tried to send chunk that was not in memory (" + data_x + " " + data_y + ") -> 2")
			Return
		EndIf
		
		Local sc:VOXEL_SUPER_CHUNK = super_grid.get_super_chunk(data_x,data_y)
		
		
		Stream.WriteShort(2005) ' code
		
		Stream.WriteInt(world_id)
		
		Stream.WriteInt(data_x)
		Stream.WriteInt(data_y)
		
		Stream.WriteInt(sc.block_update.get_next_stamp())
		
		For Local typ:Int = 1 To 5
			Local send_bank:TBank = sc.get_cpr_bank(typ)
			Local send_bank_size:Int = send_bank.Size()
			Stream.WriteInt(send_bank_size)
			Stream.WriteBytes(send_bank.Buf(), send_bank_size)
		Next
		
		Package_Manager.write_safety(Stream)
		Stream.SendMsg()
	End Function
	
	Function send_request_metadata_universe(Stream:TUDPStream)
		Stream.WriteShort(1006) ' code
		Package_Manager.write_safety(Stream)
		Stream.SendMsg()
	End Function
	
	Function send_metadata_universe(Stream:TUDPStream, client_world_id:Int)
		Stream.WriteShort(2006) ' code
		
		Stream.WriteInt(client_world_id)
		
		Package_Manager.write_safety(Stream)
		Stream.SendMsg()
	End Function
	
	Function write_request_item_array(Stream:TUDPStream, name:String)
		Stream.WriteShort(1007) ' code
		
		RuntimeError("implement write_request_item_array !")
		
		Package_Manager.write_safety(Stream)
	End Function
	
	Function write_item_array(Stream:TUDPStream, item_array:ITEMS_ARRAY)
		Stream.WriteShort(2007) ' code
		
		item_array.write_to_stream(Stream)
		
		Package_Manager.write_safety(Stream)
	End Function
	
	Function send_objects(Stream:TUDPStream, world_id:Int, map:TMap, netw_man:NETWORK_MANAGER)
		Stream.WriteShort(3001)
		Stream.WriteInt(world_id)
		
		TOBJECT.map_to_stream(map, Stream, netw_man)
		Package_Manager.write_safety(Stream)
		Stream.SendMsg()
	End Function
	
	Function write_block_update(Stream:TUDPStream, block_update:BLOCK_UPDATE_ARRAY)
		Stream.WriteShort(3002)
		block_update.write_to_stream(Stream)
		
		'Package_Manager.write_safety(Stream)
		'Stream.SendMsg() ' ----------> only write, pack with other package :)
		Package_Manager.write_safety(Stream)
	End Function
	
	Function write_msg_update(Stream:TUDPStream, msg_send_array:MESSAGE_UPDATE_ARRAY)
		Stream.WriteShort(3003)
		msg_send_array.write_to_stream(Stream)
		
		'Package_Manager.write_safety(Stream)
		'Stream.SendMsg() ' ----------> only write, pack with other package :)
		Package_Manager.write_safety(Stream)
	End Function
	
	Function write_kick(Stream:TUDPStream)
		Stream.WriteShort(3004)
	End Function
	
	Function write_conditional_action(Stream:TUDPStream, condact_array:CONDITIONAL_ACTION_ARRAY)
		Stream.WriteShort(3005)
		condact_array.write_to_stream(Stream)
		
		'Package_Manager.write_safety(Stream)
		'Stream.SendMsg() ' ----------> only write, pack with other package :)
		Package_Manager.write_safety(Stream)
	End Function
	
	Function write_item_array_demand(Stream:TUDPStream, demand:ITEM_ARRAY_DEMAND)
		Stream.WriteShort(3006)
		demand.write_to_stream(Stream)
		
		'Package_Manager.write_safety(Stream)
		'Stream.SendMsg() ' ----------> only write, pack with other package :)
		Package_Manager.write_safety(Stream)
	End Function
	
	
	Global SAFETY_SIZE:Int = 100
	
	Function write_safety(Stream:TUDPStream)
		For Local i:Int = 1 To SAFETY_SIZE
			Stream.WriteByte(50+i)
		Next
	End Function
	
	Function read_safety(Stream:TUDPStream)
		Try
			'Print("reading safety")
			For Local i:Int = 1 To SAFETY_SIZE
				'Print("-")
				If Stream.Eof() Then
					Print("safety read ABORTED !!!")
					Return
				EndIf
				
				'Print("--")
				Local rcv:Int = Stream.ReadByte()
				'Print(" rcv " + i + "> " + rcv)
				'Print("---")
				
				If Not rcv = i+50 Then RuntimeError("safety out of sync! (e: " + i+50 + ", r: " + rcv + ")")
			Next
			'Print("done.")
		Catch e:TStreamReadException
			Print("caught it!")
			End
		EndTry
	End Function
EndType
'#######################################  NETWORK_MANAGER   ##############################
Type NETWORK_MANAGER
	Const SERVER_LISTEN_PORT:Int = 1234
	Const SERVER:Int = 1
	Const CLIENT:Int = 2
	
	Field mode:Int ' server, client
	Field universe:VOXEL_UNIVERSE
	Field my_id:Int
	Const SERVER_ID:Int = -2
	
	Field render_liquid_per_frame:Int = 10 ' enough for a single player, server needs more
	
	' ---------------------------------------- Server
	Field server_connect:T_S_Connect
	
	Function Create_Server:NETWORK_MANAGER()
		Local s:NETWORK_MANAGER = New NETWORK_MANAGER
		
		T_S_Client.init()
		
		s.mode = NETWORK_MANAGER.SERVER
		s.server_connect = T_S_Connect.Create(NETWORK_MANAGER.SERVER_LISTEN_PORT)
		
		s.my_id = NETWORK_MANAGER.SERVER_ID
		
		s.render_liquid_per_frame = 50
		
		Print("Started up Server.")
		
		Return s
	End Function
	' ---------------------------------------- Client
	Field client_connector:T_C_Connect
	Field client_last_send:Int ' update of player position
	
	Function Create_Client:NETWORK_MANAGER(ip_str:String, name:String)
		Local s:NETWORK_MANAGER = New NETWORK_MANAGER
		
		s.mode = NETWORK_MANAGER.CLIENT
		s.client_connector = T_C_Connect.Create(ip_str, NETWORK_MANAGER.SERVER_LISTEN_PORT, Rand(1235, 10000), name)
				
		Print("Started up Client.")
		
		Return s
	End Function
	
	'------------------------------------------- CONSOLE / CHAT / COMMANDS
	Method console_input(txt:String)
		Select mode
			Case NETWORK_MANAGER.CLIENT
				' maybe extract local commands ?
				Local cmd:String = COMMAND.is_cmd(txt)
				If cmd <> "" Then
					Local resp:Int = COMMAND.execute(cmd, universe.cons, Self, Null)
					If resp Then Return
				EndIf
				
				' directly send to server
				client_connector.msg_send_array.write(txt)
			Case NETWORK_MANAGER.SERVER
				' maybe extract local commands ?
				Local cmd:String = COMMAND.is_cmd(txt)
				If cmd <> "" Then
					Local resp:Int = COMMAND.execute(cmd, universe.cons, Self, Null)
					If resp Then Return
				EndIf
				
				' directly send to all clients
				T_S_Client.msg_send_all("%y%<server> %std%" + txt)
				
				' draw to own console
				universe.cons.put("%y%> %std%" + txt)
			Default
				RuntimeError("console input: mode not implemented")
		End Select
	End Method
	
	'------------------------------------------- BLOCK UPDATES
	Rem
	Method write_block_update(only_if_host:Int, world_id:Int, x:Int, y:Int, block_0:Short, block_1:Short, liquid:Int, liquid_plus:Int, liquid_type:Byte)
		If only_if_host Then
			Select mode
				Case NETWORK_MANAGER.SERVER
					block_update.write(world_id, x,y,block_0,block_1,liquid,liquid_plus,liquid_type)
				Case NETWORK_MANAGER.CLIENT
					'nothing
				Default
					RuntimeError("not implemented")
			End Select
		Else
			block_update.write(world_id, x,y,block_0,block_1,liquid,liquid_plus,liquid_type)
		EndIf
	End Method
	End Rem
	
	Method update()
		Select mode
			Case NETWORK_MANAGER.SERVER
				server_connect.update(universe)
				T_S_Client.update_all(universe)
				
			Case NETWORK_MANAGER.CLIENT
				If client_last_send + 100 < MilliSecs() Then
					client_last_send = MilliSecs()
										
					Package_Manager.write_item_array_demand(client_connector.send_stream, client_connector.item_array_demand)
					
					Package_Manager.write_conditional_action(client_connector.send_stream, client_connector.condact_array)
					Package_Manager.write_msg_update(client_connector.send_stream, client_connector.msg_send_array)
					Package_Manager.send_objects(client_connector.send_stream, client_connector.world.id, client_connector.world.object_map, Self)
				EndIf
				
				client_connector.receive_data(universe, Self)
				
				If client_connector.new_world_id And client_connector.new_world_id <> client_connector.my_world_id Then
					universe.remove_all_worlds()
					client_connector.world = VOXEL_SUPER_GRID.Join(universe, client_connector.new_world_id)
				EndIf
		End Select
	End Method
		
	' ------------------------------------------------------------------ Client only
	Method join_establish_connection()
		If Not (mode = NETWORK_MANAGER.CLIENT) Then
			RuntimeError("You can only join_establish_connection in client_mode")
		EndIf
		
		Print("create full connection to server...")
		
		Repeat
			Package_Manager.send_client_join(client_connector.send_stream, client_connector.listen_port, client_connector.name)
			
			Delay 500
			
			client_connector.receive_data(universe, Self)
		Until client_connector.last_receive
		
		Print(" > CONNECTED !")
		Print("request my client id... (before: " + my_id + ")")
		
		Repeat
			Package_Manager.send_request_client_id(client_connector.send_stream)
			
			Delay 500
			
			client_connector.receive_data(universe, Self)
		Until my_id
		
		client_connector.inventory = ITEMS_ARRAY.Create(ITEMS_ARRAY.PLAYER_SIZE, [1, my_id], Self)
		
		Print(" > success (now: " + my_id + ")")
	End Method
	
	Method join_fetch_metadata(super_grid:VOXEL_SUPER_GRID)
		If Not (mode = NETWORK_MANAGER.CLIENT) Then
			RuntimeError("You can only join_fetch_metadata in client_mode")
		EndIf
		
		Print("fetching meta-data:")
		' lock down -> only meta-data
		
		Repeat
			Print(".  w")
			Package_Manager.send_request_metadata(client_connector.send_stream, super_grid.id)
			
			Delay 500
			Print(".. w")
			client_connector.receive_data(universe, Self)
		Until (super_grid.size_x > 0) ' indicator that metadata loaded !
		
		' lift lock down
		Print("meta-data received!")
	End Method
	
	Method join_fetch_metadata_universe(universe:VOXEL_UNIVERSE)
		If Not (mode = NETWORK_MANAGER.CLIENT) Then
			RuntimeError("You can only join_fetch_metadata in client_mode")
		EndIf
		
		Print("fetching universe meta-data:")
		' lock down -> only meta-data
		
		Repeat
			Print(".  u")
			Package_Manager.send_request_metadata_universe(client_connector.send_stream)
			
			Delay 500
			Print(".. u")
			client_connector.receive_data(universe, Self)
		Until (client_connector.my_start_world_id > 0) ' indicator that metadata loaded !
		
		' lift lock down
		Print("universe_meta-data received!")
	End Method
End Type

'#######################################  Code   #########################################
Rem
Local inp:String = Input("IP / server > ")

Local netw_man:NETWORK_MANAGER

If inp = "s" Or inp = "server" Then
	netw_man = NETWORK_MANAGER.Create_Server()
Else
	If inp = "" Then inp = "127.0.0.1" ' local
	If inp = " " Then inp = "192.168.1.41" ' lan
	
	netw_man = NETWORK_MANAGER.Create_Client(inp)
EndIf

Graphics 800,600

Repeat
	Cls
	
	netw_man.update()
	netw_man.draw()
	
	Flip
Until KeyHit(key_escape)
End Rem

'#################################################################################### CHARACTER ##############################################################################################

'############################# RESOURCES
Type HAND_OBJ
	Global NULL_OBJ:Int = 0
	Global HAMMER:Int = 1
	Global PICKAXE:Int = 2
	
	Const hand_obj_count:Int = 3
	Global hands:HAND_OBJ[] = New TOOL_IMG[hand_obj_count]
	
	Const TYPE_TOOL:Int = 1
	Field kind:Int
End Type

Type TOOL_IMG Extends HAND_OBJ
	Function init()
		hands[HAND_OBJ.NULL_OBJ] = Null
		hands[HAND_OBJ.HAMMER] = TOOL_IMG.Load("items\hammer\hand.png", 0, 18)
		hands[HAND_OBJ.PICKAXE] = TOOL_IMG.Load("items\pickaxe\hand.png", 0, 18)
	End Function
	
	Field img:TImage
	
	Function Load:TOOL_IMG(path:String, shoulder_x:Int, shoulder_y:Int)
		Local t:TOOL_IMG = New TOOL_IMG
		
		t.kind = HAND_OBJ.TYPE_TOOL
		t.img = LoadImage(path,0)
		
		If Not t.img Then RuntimeError "image not loaded: " + path
		
		SetImageHandle(t.img, shoulder_x, shoulder_y)
		
		Return t
	End Function
End Type


Type CHARACTER_IMG
	Global NORMAL:CHARACTER_IMG
	
	Function init()
		NORMAL = CHARACTER_IMG.Load("character\normal")
	End Function
	
	Field body:TImage
	Field head:TImage
	Field arm_front:TImage
	Field arm_back:TImage
	
	Field frames_per_row:Int
	Field number_rows:Int
	
	Field ticks:Int[][]
	Field arm_offset:Int[][] ' -> only affects swing-arms
	
	Field swing_arm_0_x:Int ' control point
	Field swing_arm_0_y:Int ' control point
	
	Field swing_arm_1_x:Int ' control point
	Field swing_arm_1_y:Int ' control point
	
	Field frame_size:Int
	
	Rem
		-------------   STATES
		0 = standing
		1 = running
		
	End Rem
	
	Function Load:CHARACTER_IMG(path:String)
		Local c:CHARACTER_IMG = New CHARACTER_IMG
		
		c.ticks = New Int[][4]
		c.arm_offset = New Int[][4]
		c.frames_per_row = 4
		c.number_rows = 4
		
		c.frame_size = 32
		
		c.body = LoadAnimImage(path + "\body.png",c.frame_size,c.frame_size,0,c.frames_per_row*c.number_rows, 0)
		c.head = LoadAnimImage(path + "\head.png",c.frame_size,c.frame_size,0,c.frames_per_row*c.number_rows, 0)
		c.arm_front = LoadAnimImage(path + "\arm_front.png",c.frame_size,c.frame_size,0,c.frames_per_row*c.number_rows, 0)
		c.arm_back = LoadAnimImage(path + "\arm_back.png",c.frame_size,c.frame_size,0,c.frames_per_row*c.number_rows, 0)
		
		SetImageHandle(c.body, 16,16)
		SetImageHandle(c.head, 16,16)
		SetImageHandle(c.arm_front, 16,16)
		SetImageHandle(c.arm_back, 16,16)
		
		c.ticks[0] = [1]
		c.ticks[1] = [8,8,8,8]
		c.ticks[2] = [1]
		c.ticks[3] = [1]
		
		c.arm_offset[0] = [0]
		c.arm_offset[1] = [0, -1, 0, -1]
		c.arm_offset[2] = [-2]
		c.arm_offset[3] = [-2]
		
		c.swing_arm_0_x = 20
		c.swing_arm_0_y = 13
		
		c.swing_arm_1_x = 14
		c.swing_arm_1_y = 13
		
		Return c
	End Function
	
	
	Function drawhandle( image:TImage,x#,y#,frame:Int, hanlde_x:Int, handle_y:Int)
		Local gc:TMax2DGraphics = TMax2DGraphics.Current()
		
		
		Local x0#=-hanlde_x,x1#=x0+image.width
		Local y0#=-handle_y,y1#=y0+image.height
		Local iframe:TImageFrame=image.Frame(frame)
		If iframe iframe.Draw x0,y0,x1,y1,x+gc.origin_x,y+gc.origin_y,0,0,image.width,image.height
	End Function
End Type

'############################# INSTANCE
Type CHARACTER
	Field char_img:CHARACTER_IMG
	
	Field state:Int
	Field frame:Int
	Field tick:Int
	
	Field last_arm_0_obj:HAND_OBJ, last_arm_0_mode:Int, last_arm_1_obj:HAND_OBJ, last_arm_1_mode:Int
	Field arm_0_count:Int, arm_1_count:Int
	
	Function Create:CHARACTER(char_img:CHARACTER_IMG)
		Local c:CHARACTER = New CHARACTER
		
		c.char_img = char_img
		
		Return c
	End Function
	
	Method draw(new_state:Int, direction:Int, arm_0_obj:HAND_OBJ, arm_0_mode:Int, arm_1_obj:HAND_OBJ, arm_1_mode:Int, x:Int,y:Int, scale:Int, aim_dx:Int,aim_dy:Int)
		' direction: 0 -> , 1 <-
		
		Local arm_0:Int = 0
		Local arm_1:Int = 0
		
		Local tool_0:TOOL_IMG ' if tool mode
		Local tool_1:TOOL_IMG ' if tool mode
		
		Local arm_0_w_off:Float = 0 ' for tool use
		Local arm_1_w_off:Float = 0
		
		If last_arm_0_obj = arm_0_obj And last_arm_0_mode = arm_0_mode Then
			arm_0_count:+1
		Else
			arm_0_count = 0
		EndIf
		
		If last_arm_1_obj = arm_1_obj And last_arm_1_mode = arm_1_mode Then
			arm_1_count:+1
		Else
			arm_1_count = 0
		EndIf
		
		If arm_0_obj Then
			Select arm_0_obj.kind
				Case HAND_OBJ.TYPE_TOOL
					arm_0 = 3 ' -> swingarm with tool image
					tool_0 = TOOL_IMG(arm_0_obj)
					
					If arm_0_mode Then
						
						arm_0_w_off = 2-(arm_0_count Mod 20)
						
						If arm_0_w_off < 0 Then
							arm_0_w_off = arm_0_w_off*3
						Else
							arm_0_w_off = -arm_0_w_off*10*3
						EndIf
						
						arm_0_w_off:+40
					EndIf
				Default
					RuntimeError "hand obj kind not known !"
			End Select
		EndIf
		
		If arm_1_obj Then
			Select arm_1_obj.kind
				Case HAND_OBJ.TYPE_TOOL
					arm_1 = 3 ' -> swingarm with tool image
					tool_1 = TOOL_IMG(arm_1_obj)
					
					If arm_1_mode Then
						arm_1_w_off = 2-(arm_1_count Mod 20)
						
						If arm_1_w_off < 0 Then
							arm_1_w_off = arm_1_w_off*3
						Else
							arm_1_w_off = -arm_1_w_off*10*3
						EndIf
						
						arm_1_w_off:+40
					EndIf
				Default
					RuntimeError "hand obj kind not known !"
			End Select
		EndIf
		
		' -------
		last_arm_0_obj = arm_0_obj
		last_arm_0_mode = arm_0_mode
		last_arm_1_obj = arm_1_obj
		last_arm_1_mode = arm_1_mode
		
		If state <> new_state Then
			' reset
			state = new_state
			frame = 0
			tick = 0
		Else
			tick:+1
			If tick>=char_img.ticks[state][frame] Then
				tick = 0
				frame:+1
				If frame >= char_img.ticks[state].length Then
					frame = 0
				EndIf
			EndIf
		EndIf
		
		If direction Then
			SetScale -scale, scale
		Else
			SetScale scale, scale
		EndIf
		SetColor 255,255,255
		
		Select direction
			Case 0
				Select arm_0
					Case 0
						DrawImage char_img.arm_back, x,y, frame + state*char_img.frames_per_row
					Case 1
						DrawImage char_img.arm_back, x,y + scale*char_img.arm_offset[state][frame], 0
					Case 2
						Local xx:Int = char_img.swing_arm_0_x*scale - char_img.frame_size*scale/2
						Local yy:Int = char_img.swing_arm_0_y*scale - char_img.frame_size*scale/2 + scale*char_img.arm_offset[state][frame]
						
						SetRotation ATan2(aim_dy - yy, aim_dx - xx)
						
						CHARACTER_IMG.drawhandle(char_img.arm_back,x+xx,y+yy, 1, char_img.swing_arm_0_x, char_img.swing_arm_0_y)
						
						SetRotation 0
					Case 3
						Local xx:Int = char_img.swing_arm_0_x*scale - char_img.frame_size*scale/2
						Local yy:Int = char_img.swing_arm_0_y*scale - char_img.frame_size*scale/2 + scale*char_img.arm_offset[state][frame]
						
						SetRotation ATan2(aim_dy - yy, aim_dx - xx)+arm_0_w_off
						
						CHARACTER_IMG.drawhandle(char_img.arm_back,x+xx,y+yy, 1, char_img.swing_arm_0_x, char_img.swing_arm_0_y)
						
						DrawImage tool_0.img, x+xx,y+yy
						
						SetRotation 0
					Default 
						RuntimeError "arm mode not known"
				End Select
				
				DrawImage char_img.body, x,y, frame + state*char_img.frames_per_row
				DrawImage char_img.head, x,y, frame + state*char_img.frames_per_row
				
				Select arm_1
					Case 0
						DrawImage char_img.arm_front, x,y, frame + state*char_img.frames_per_row
					Case 1
						DrawImage char_img.arm_front, x,y + scale*char_img.arm_offset[state][frame], 0
					Case 2
						Local xx:Int = char_img.swing_arm_1_x*scale - char_img.frame_size*scale/2
						Local yy:Int = char_img.swing_arm_1_y*scale - char_img.frame_size*scale/2 + scale*char_img.arm_offset[state][frame]
						
						SetRotation ATan2(aim_dy - yy, aim_dx - xx)
														
						CHARACTER_IMG.drawhandle(char_img.arm_front,x+xx,y+yy, 1, char_img.swing_arm_1_x, char_img.swing_arm_1_y)
						SetRotation 0
					Case 3
						Local xx:Int = char_img.swing_arm_1_x*scale - char_img.frame_size*scale/2
						Local yy:Int = char_img.swing_arm_1_y*scale - char_img.frame_size*scale/2 + scale*char_img.arm_offset[state][frame]
						
						SetRotation ATan2(aim_dy - yy, aim_dx - xx)+arm_1_w_off
						
						DrawImage tool_1.img, x+xx,y+yy
												
						CHARACTER_IMG.drawhandle(char_img.arm_front,x+xx,y+yy, 1, char_img.swing_arm_1_x, char_img.swing_arm_1_y)
						
						SetRotation 0
					Default 
						RuntimeError "arm mode not known"
				End Select
			Case 1
				Select arm_1
					Case 0
						DrawImage char_img.arm_back, x,y, frame + state*char_img.frames_per_row
					Case 1
						DrawImage char_img.arm_back, x,y + scale*char_img.arm_offset[state][frame], 0
					Case 2
						Local xx:Int =  - (char_img.swing_arm_0_x*scale - char_img.frame_size*scale/2)
						Local yy:Int =  + char_img.swing_arm_0_y*scale - char_img.frame_size*scale/2 + scale*char_img.arm_offset[state][frame]
						
						SetRotation ATan2(aim_dy - yy, aim_dx - xx) + 180
						
						CHARACTER_IMG.drawhandle(char_img.arm_back,x+xx,y+yy, 1, char_img.swing_arm_0_x, char_img.swing_arm_0_y)
						
						SetRotation 0
					Case 3
						Local xx:Int =  - (char_img.swing_arm_0_x*scale - char_img.frame_size*scale/2)
						Local yy:Int =  + char_img.swing_arm_0_y*scale - char_img.frame_size*scale/2 + scale*char_img.arm_offset[state][frame]
						
						SetRotation ATan2(aim_dy - yy, aim_dx - xx) + 180 - arm_1_w_off
						
						CHARACTER_IMG.drawhandle(char_img.arm_back,x+xx,y+yy, 1, char_img.swing_arm_0_x, char_img.swing_arm_0_y)
						
						DrawImage tool_1.img, x+xx,y+yy
						
						SetRotation 0
					Default 
						RuntimeError "arm mode not known"
				End Select
				
				DrawImage char_img.body, x,y, frame + state*char_img.frames_per_row
				DrawImage char_img.head, x,y, frame + state*char_img.frames_per_row
				
				Select arm_0
					Case 0
						DrawImage char_img.arm_front, x,y, frame + state*char_img.frames_per_row
					Case 1
						DrawImage char_img.arm_front, x,y + scale*char_img.arm_offset[state][frame], 0
					Case 2
						Local xx:Int = - (char_img.swing_arm_1_x*scale - char_img.frame_size*scale/2)
						Local yy:Int = + char_img.swing_arm_1_y*scale - char_img.frame_size*scale/2 + scale*char_img.arm_offset[state][frame]
						
						SetRotation ATan2(aim_dy - yy, aim_dx - xx) + 180
								
						CHARACTER_IMG.drawhandle(char_img.arm_front,x+xx,y+yy, 1, char_img.swing_arm_1_x, char_img.swing_arm_1_y)
						SetRotation 0
					Case 3
						Local xx:Int = - (char_img.swing_arm_1_x*scale - char_img.frame_size*scale/2)
						Local yy:Int = + char_img.swing_arm_1_y*scale - char_img.frame_size*scale/2 + scale*char_img.arm_offset[state][frame]
						
						SetRotation ATan2(aim_dy - yy, aim_dx - xx) + 180 - arm_0_w_off
						
						DrawImage tool_0.img, x+xx,y+yy
						
						CHARACTER_IMG.drawhandle(char_img.arm_front,x+xx,y+yy, 1, char_img.swing_arm_1_x, char_img.swing_arm_1_y)
						
						SetRotation 0
					Default 
						RuntimeError "arm mode not known"
				End Select
		End Select
		
		SetScale 1,1
	End Method
EndType


Rem
Graphics 800,600
CHARACTER_IMG.init()

Local char_1:CHARACTER = CHARACTER.Create(CHARACTER_IMG.NORMAL)
Local char_2:CHARACTER = CHARACTER.Create(CHARACTER_IMG.NORMAL)
Local char_3:CHARACTER = CHARACTER.Create(CHARACTER_IMG.NORMAL)

Repeat
	SetClsColor (MilliSecs()/100) Mod 255,(MilliSecs()/100) Mod 255,(MilliSecs()/100) Mod 255
	Cls
	
	If KeyDown(KEY_D) Then
		char_1.draw(1, 0, 0,0, 50,200, 3, MouseX()-50, MouseY()-200)
	Else
		char_1.draw(1, 1, 0,0, 50,200, 3, MouseX()-50, MouseY()-200)
	EndIf
	
	If KeyDown(KEY_D) Then
		char_2.draw(1, 0, 1,1, 200,200, 3, MouseX()-200, MouseY()-200)
	Else
		char_2.draw(1, 1, 1,1, 200,200, 3, MouseX()-200, MouseY()-200)
	EndIf
	
	If KeyDown(KEY_D) Then
		char_3.draw(1, 0, 2,2, 350,200, 3, MouseX()-350, MouseY()-200)
	Else
		char_3.draw(1, 1, 2,2, 350,200, 3, MouseX()-350, MouseY()-200)
	EndIf
	
	Flip
Until KeyHit(KEY_ESCAPE)
end rem