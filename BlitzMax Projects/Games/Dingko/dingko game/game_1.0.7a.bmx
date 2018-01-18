SuperStrict

Framework BRL.GlMax2D

'Import "-ldl"

Import BRL.System
Import BRL.Map
Import BRL.StandardIO
Import BRL.Retro
Import BRL.PNGLoader

Import BRL.FreeTypeFont

Import BRL.Audio
Import BRL.WAVLoader
Import BRL.DirectSoundAudio
Import BRL.OGGLoader

Import BRL.Threads

Import Pub.Glew

'.......................

Import "modules/lights.bmx"
Incbin "font2.ttf"'"font.ttf"

Const VERSION:String = "1.0.7a"
Const VERSION_COMPATIBILITY:Int = 5

Global FRONT_MESSAGE:String = ""'"Fuer Kritik eifach uf Skype cho..."
Global CHEAT_MODE:Int = 0

Global NET_IMAGE:TImage

Rem
# patch 1.0.1
 - levelstart-view
 - minimal charge value
# patch 1.0.2
 - water mode -> climb walls without charging before
# patch 1.0.3
 - menu: appterminate (X) now works
 - keys: you can change them now and settings are saved
 - suicide: reload from last checkpoint
 - continue to next level after completing this level
 - blending before and after level improved
# patch 1.0.4
 - Screen resolution for fullscreen
 - Editor multiple select
 - key / door bug fixed, just run every level with bug with editor and save it!
# patch 1.0.5
 - fix fps
 - screen resolution selection improved
 - Version, Autor, Date
 - TELEPORTER
 - Door-teleporter
 - 2d-sound improved, direction is now being updated
 - partikel und lightengine switch (on / off)
 - lightengine problem after screen-change fixed
 - Stone fall on stone - destroy stone, keep mode
 - Language-switcher
 - sequences: intro, outro ...
 - fps-independent
 - Steindinko keine Elemente aufnehmen
# patch 1.0.6
 - sequence now to language :> (script system)
 - objects can now be rotated
 - firesurprise + particlefire accoarding to rotation
 - teleporter "local" as well, rotation of "end" counts
 - lamp + image-light_on as well, but NOT tested
 - fps-bar romoved in options
 - light source for every mode
 - fixed image light
 - much much more, too much actually...
# patch 1.0.7
 - variable dependency of boxes
 - script inproved, sys-variables


TODO:
 - audio botschaft
 - Editor: stick to grid
 - Level Management system
 - standard-fill of new level
End Rem





'########################################################################################
'###########################       ######################################################
'########################### INFO  ######################################################
'###########################       ######################################################
'########################################################################################
Rem
Extern "win32"
	Function GetComputerNameA(lpbuffer:Byte Ptr,nSize:Int Ptr)
EndExtern
End Rem
Type INFO
	Function get_computer_name:String()
		Return "asdf"
		Rem
		Local Size:Int = 32
		Local Buffer:Byte Ptr = MemAlloc(Size)
		GetComputerNameA(buffer,Varptr(size))
		Local name$ = String.FromCString(buffer)
		MemFree buffer
		
		Return name + " # " + getenv_("username")
		EndRem
	End Function
End Type

'########################################################################################
'###########################       ######################################################
'########################### GAME  ######################################################
'###########################       ######################################################
'########################################################################################

Type GAME
	Global world:TWorld
	
	Function load_world(name:String)
		GAME.world = New TWorld
		
		GAME.world.name = name
		
		'GAME.world.highest_level_completed
		Local gfx_map:TMap = DATA_FILE_HANDLER.Load("Worlds\" + GAME.world.name + "\world.ini")'world.ini
		
		If Not gfx_map Then
			GAME_ERROR_HANDLER.error("GAME->load_world() world.ini -> map is not loaded! (Worlds\" + GAME.world.name + "\world.ini")
			GAME.world = Null
			Return
		End If
		
		If gfx_map.contains("highest_level_completed") Then
			
			GAME.world.highest_level_completed = Int(String(gfx_map.ValueForKey("highest_level_completed")))
		Else
			GAME_ERROR_HANDLER.error("GAME->load_world() world.ini -> variable highest_level_completed not found! (Worlds\" + GAME.world.name + "\world.ini")
			GAME.world = Null
			Return
		End If
		
		
		gfx_map= DATA_FILE_HANDLER.Load("Worlds\" + GAME.world.name + "\Levels\levels.ini")
		
		If Not gfx_map Then
			GAME_ERROR_HANDLER.error("GAME->load_world() level.ini -> map is not loaded! (Worlds\" + GAME.world.name + "\Levels\levels.ini)")
			GAME.world = Null
			Return
		End If
		
		Local i:Int = 0
		
		GAME.world.level_name_list = Null
		
		Repeat
			i:+1
			
			If gfx_map.contains("level_" + i) Then'START LEVEL
				
				If Not gfx_map.ValueForKey("level_" + i) Then
					GAME_ERROR_HANDLER.error("level name not available! " + i)
					Return'laden abbrechen
				End If
				
				GAME.world.level_name_list:+ [String(gfx_map.ValueForKey("level_" + i))]
				
				Print String(gfx_map.ValueForKey("level_" + i))
				
				GAME.world.level_menu_image_list:+ [LoadImage("Worlds\" + GAME.world.name + "\Levels\" + String(gfx_map.ValueForKey("level_" + i)) + "\menu_image.png")]
				
				If Not GAME.world.level_menu_image_list[i-1] Then
					GAME_ERROR_HANDLER.error("menu_image.png not loaded! " + String(gfx_map.ValueForKey("level_" + i)))
					Return'laden abbrechen
				End If
			Else
				i = -1
			End If
			
		Until i = -1
		
		GAME.world.block_image_manager = TBlock_Image_Manager.Load(GAME.world.name)
		
		If Not GAME.world.block_image_manager Then
			GAME_ERROR_HANDLER.error("GAME->load_world() TBlock_Image_Manager is not loaded!")
			GAME.world = Null
			Return
		End If
		
		TFace.load_for_world(GAME.world)
		
	End Function
End Type

'########################################################################################
'###########################       ######################################################
'########################### World ######################################################
'###########################       ######################################################
'########################################################################################

Type TWorld
	Field name:String
	
	Field highest_level_completed:Int
	
	Global lightengine_on:Int = 1
	Global particles_on:Int = 1
	
	'level list """""""""""""""""""""""""""""""""""""""
	Field level_name_list:String[]
	Field level_menu_image_list:TImage[]
	
	'actual_level """""""""""""""""""""""""""""""""""""
	Field act_level:TLevel
	Field act_level_number:Int
	
	'Block set """"""""""""""""""""""""""""""""""""""""
	Field block_image_manager:TBlock_Image_Manager
	
	'Faces set """"""""""""""""""""""""""""""""""""""""
	Field faces_map:TMap
End Type

'########################################################################################
'###########################           ##################################################
'########################### TDialogue ##################################################
'###########################           ##################################################
'########################################################################################

Type TDialogue
	Field name:String
	Field subs:TDialogue_Sub[]
	
	Function load_for_level(level:TLevel)
		level.dialogue_map = New TMap
		
		
		If FileType("Worlds\" + level.world.name + "\Levels\" + level.name + "\dialogues") = 2 Then
			
			Local files:String[] = LoadDir("Worlds\" + level.world.name + "\Levels\" + level.name + "\dialogues")
			
			Print "////////// load dialogues \\\\\\\\\\\\\"
			
			For Local f:String = EachIn files
				
				If ExtractExt(f) = "txt" Then
					Print "NEW DIALOGUE: " + f
					
					Local d:TDialogue = New TDialogue
					
					d.name = StripAll(f)
					
					Local text_file:TStream = ReadFile("Worlds\" + level.world.name + "\Levels\" + level.name + "\dialogues\" + f)
					
					Local act_sub:TDialogue_Sub
					
					While Not Eof(text_file)
						
						Local rl:String = ReadLine(text_file)
						
						
						If Mid(rl, 1,1)="#" Then
							
							If act_sub Then
								d.subs = d.subs + [act_sub]
							End If
							
							act_sub = New TDialogue_Sub
							act_sub.face = Mid(rl, 2,-1)
							
						Else
							If act_sub Then
								
								act_sub.lines = act_sub.lines + [rl]
							Else
								
							End If
						End If
						
					Wend
					
					If act_sub Then
						d.subs = d.subs + [act_sub]
					End If
					
					level.dialogue_map.Insert(d.name, d)
					
				End If
			Next
			
			Print "\\\\\\\\\\\\ dialogues loaded /////////////"
			
			
		Else
			
			Print "could not load dialogues: Worlds\" + level.world.name + "\Levels\" + level.name + "\dialogues"
		End If
		
	End Function
End Type

'########################################################################################
'###########################               ##############################################
'########################### TDialogue Sub ##############################################
'###########################               ##############################################
'########################################################################################

Type TDialogue_Sub
	Field face:String
	Field lines:String[]
End Type
'########################################################################################
'###########################        #####################################################
'########################### TFaces #####################################################
'###########################        #####################################################
'########################################################################################

Type TFace
	Field name:String
	Field image:TImage
	Field image_speed:Int = 100
	
	Function Load:TFace(name:String)
		Local f:TFace = New TFace
		
		f.name = name
		
		f.image = ImageLoader.Load("Worlds\" + GAME.world.name + "\faces\" + f.name +  ".png", 80, 120)
		
		Return f
	End Function
	
	Function load_for_world(world:TWorld)
		If FileType("Worlds\" + world.name + "\Faces") = 2 Then
			
			Local files:String[] = LoadDir("Worlds\" + world.name + "\Faces")
			world.faces_map = New TMap
			Print "////////// load faces \\\\\\\\\\\\\"
			
			For Local f:String = EachIn files
				
				If ExtractExt(f) = "png" Then
					Print "loading " + StripAll(f)
					Local f:TFace = TFace.Load(StripAll(f))
					
					world.faces_map.Insert(f.name, f)
				Else
					Print "no good extention: " + f
				End If
			Next
			
			Print "\\\\\\\\\\ load faces ///////////"
		Else
			GAME_ERROR_HANDLER.error("TFace -> directory does not exist! Worlds\" + world.name + "\Faces")
			world.faces_map = New TMap
		End If
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
'###########################                     ########################################
'########################### BLOCK IMAGE MANAGER ########################################
'###########################                     ########################################
'########################################################################################

Type TBlock_Image_Manager
	Field image_side:Int
	Field anz_images:Int' starts witch 0 -> n-1
	Field images:TImage[]
	Field anz_frames:Int[]
	
	Function Load:TBlock_Image_Manager(world_name:String)
		Local manager:TBlock_Image_Manager = New TBlock_Image_Manager
		
		Local gfx_map:TMap = DATA_FILE_HANDLER.Load("Worlds\" + world_name + "\Blocks\gfx\gfx.ini")
		
		If Not gfx_map Then
			GAME_ERROR_HANDLER.error("BLOCK_IMAGE_MANAGER: ini -> map is not loaded! (Worlds\" + world_name + "\Blocks\gfx\gfx.ini)")
			Return Null
		End If
		
		If gfx_map.contains("side") Then'############## SIDE #################
			manager.image_side = Int(String(gfx_map.ValueForKey("side")))
		Else
			GAME_ERROR_HANDLER.error("BLOCK_IMAGE_MANAGER: side length not found! (Worlds\" + world_name + "\Blocks\gfx\gfx.ini)")
			Return Null
		End If
		
		Print "block side length is: " + manager.image_side
		
		If gfx_map.contains("count") Then'############## COUNT - LOAD IMAGES #################
			
			manager.anz_images = Int(String(gfx_map.ValueForKey("count")))
			manager.images = New TImage[manager.anz_images]
			manager.anz_frames = New Int[manager.anz_images]
			
			For Local i:Int = 0 To manager.anz_images-1' LOAD IMAGES
				Print "loading: Worlds\" + world_name + "\Blocks\gfx\"+i+".png"
				manager.images[i] = LoadImage("Worlds\" + world_name + "\Blocks\gfx\" + i + ".png")
				manager.anz_frames[i]=1
				
				If Not manager.images[i] Then' WAS IMAGE LOADED?
					GAME_ERROR_HANDLER.error("BLOCK_IMAGE_MANAGER: image not found! (Worlds\" + world_name + "\Blocks\gfx\"+i+".png)")
				End If
				
				If manager.images[i].height <> manager.image_side Then'HIGHT OK?
					GAME_ERROR_HANDLER.error("BLOCK_IMAGE_MANAGER: image has wrong hight! (Worlds\" + world_name + "\Blocks\gfx\"+i+".png)")
				End If
				
				If manager.images[i].width < manager.image_side Then'WIDTH TO SMALL?
					GAME_ERROR_HANDLER.error("BLOCK_IMAGE_MANAGER: image width to small! (Worlds\" + world_name + "\Blocks\gfx\"+i+".png)")
				End If
				
				If manager.images[i].width > manager.image_side Then'WIDTH BIGGER?
					If manager.images[i].width >= 2*manager.image_side Then'WIDTH at least 2* BIGGER? - IMAGE HAS FRAMES
						
						manager.anz_frames[i] = manager.images[i].width / manager.image_side
						
						manager.images[i] = LoadAnimImage("Worlds\" + world_name + "\Blocks\gfx\"+i+".png", manager.image_side, manager.image_side, 0, manager.anz_frames[i])
						
					Else
						GAME_ERROR_HANDLER.error("BLOCK_IMAGE_MANAGER: image width to big! (Worlds\" + world_name + "\Blocks\gfx\"+i+".png)")
					End If
				End If
			Next
			
			
			
		Else
			GAME_ERROR_HANDLER.error("BLOCK_IMAGE_MANAGER: count not found! (Worlds\" + world_name + "\Blocks\gfx\gfx.ini)")
			Return Null
		End If
		
		Return manager
	End Function
End Type

'########################################################################################
'###########################       ######################################################
'########################### LEVEL ######################################################
'###########################       ######################################################
'########################################################################################

Type TLevel
	Field name:String
	
	Field vers:String'specs
	Field vers_c:Int
	Field autor:String'CurrentDate$() + " " + CurrentTime$()
	Field date:String
	
	Field world:TWorld
	
	Field player:TPlayer
	
	'load_for_level:Sign_Text[](l:TLevel)
	
	Field sign_text_map:TMap
	
	Field current_sign_text:Sign_Text
	
	Field last_time_sign_text_activated:Int
	
	'blocks
	Field table_x:Int
	Field table_y:Int
	
	Field table:TBlock[table_x, table_y]
	
	Field image_side:Int
	
	'ansicht
	Field ansicht_act_x:Int
	Field ansicht_act_y:Int
	
	Field ansicht_ziel_x:Int
	Field ansicht_ziel_y:Int
	
	Field ansicht_mode:Int'0 = fast,1=fix-15
	
	Method get_ansicht_d:Float()
		Return ((Self.ansicht_act_x-Self.ansicht_ziel_x)^2+(Self.ansicht_act_y-Self.ansicht_ziel_y)^2)^0.5
	End Method
	
	'OBJECTS -> CHUNKS
	Field anz_chunks_x:Int
	Field anz_chunks_y:Int
	Field chunks:TCHUNK[anz_chunks_x, anz_chunks_y,5]'x,y,layer   -> normal objects
	
	Field super_chunks:TCHUNK[5]'layer   -> important objects that need to be rendered everytime
	
	
	'so that the doors can be found by the keys!
	Field door_list:TList = New TList
	Field location_map:TMap = New TMap
	
	Field black_in:Float = 1.0
	
	Field level_completed:Int = 0
		
	'Textbox
	Field textbox_image:TImage
	Field signbox_image:TImage
	
	'music
	Field current_music_name:String
	
	'heatbar:
	Field heatbar_image:TImage
	Field heatbar_abschluss_oben_image:TImage
	Field heatbar_verlauf_oben_image:TImage
	Field heatbar_unten_image:TImage
	Field heatbar_bg_image:TImage
	
	Field chargebar_abschluss_oben_image:TImage
	Field chargebar_verlauf_oben_image:TImage
	
	Field waterbar_abschluss_oben_image:TImage
	Field waterbar_verlauf_oben_image:TImage
	
	Field firebar_l_image:TImage
	Field firebar_m_image:TImage
	Field firebar_r_image:TImage
	
	'BACKGROUND IMAGES
	Field bg_images:TImage[]
	
	'dialogue map:
	Field dialogue_map:TMap
	
	Field current_dialogue:TDialogue
	Field current_sub:Int
	
	'dialogue id map:
	Field dialogue_id_map:TMap
	
	'FPS - controll
	Field last_updated:Int=0'millisecs()
	
	'light
	Field lights_on:Int = 0
	Field brightness_r:Int = 255
	Field brightness_g:Int = 255
	Field brightness_b:Int = 255
	
	Method set_brightness(r:Int,g:Int,b:Int)
		Self.brightness_r = r
		Self.brightness_g = g
		Self.brightness_b = b
		
		Self.render_brightness()
		
	End Method
	
	Method render_brightness()
		If Self.brightness_r = 255 And Self.brightness_g = 255 And Self.brightness_b = 255 Then
			Self.lights_on = 0
		Else
			Self.lights_on = 1
		End If
		
		If TWorld.lightengine_on = 0 Then Self.lights_on = 0
	End Method
	
	Function Load:TLevel(world:TWorld, name:String, read_objects:Int = False)
		Local l:TLevel = New TLevel
		
		LEVEL_VARIABLES.init()
		
		l.textbox_image = LoadImage("gfx\textbox.png")
		
		l.signbox_image = LoadImage("gfx\signbox.png")
		
		l.heatbar_image = LoadImage("gfx\heatbar.png")
		
		l.heatbar_abschluss_oben_image = LoadImage("gfx\heatbar_oben.png")
		l.heatbar_verlauf_oben_image = LoadImage("gfx\heatbar_mitte.png")
		l.heatbar_unten_image = LoadImage("gfx\heatbar_unten.png")
		l.heatbar_bg_image = LoadImage("gfx\heatbar_bg.png")
		
		l.chargebar_abschluss_oben_image = LoadImage("gfx\chargebar_oben.png")
		l.chargebar_verlauf_oben_image = LoadImage("gfx\chargebar_mitte.png")
		
		l.waterbar_abschluss_oben_image = LoadImage("gfx\waterbar_oben.png")
		l.waterbar_verlauf_oben_image = LoadImage("gfx\waterbar_mitte.png")
		
		l.firebar_l_image = LoadImage("gfx\firebar_l.png")
		l.firebar_m_image = LoadImage("gfx\firebar_m.png")
		l.firebar_r_image = LoadImage("gfx\firebar_r.png")
		
		If Not l.textbox_image Then
			GAME_ERROR_HANDLER.error("textbox image could not be loaded!: gfx\textbox.png")
			Return Null
		End If
		
		
		l.name = name
		l.world = world
		
		l.image_side = l.world.block_image_manager.image_side
		
		If Not FileType("Worlds\" + l.world.name + "\Levels\" + l.name + "\table.data") Then
			GAME_ERROR_HANDLER.error("level-table-file not found: " + "Worlds\" + l.world.name + "\Levels\" + l.name + "\table.data")
			Return Null
		End If
		
		'-------------------- TABLE ----------------
		Local file:TStream = ReadFile("Worlds\" + l.world.name + "\Levels\" + l.name + "\table.data")
		
		If Not file Then
			GAME_ERROR_HANDLER.error("level-table-file could not be loaded: " + "Worlds\" + l.world.name + "\Levels\" + l.name + "\table.data")
			Return Null
		End If
		
		If Eof(file) Then'table x
			GAME_ERROR_HANDLER.error("level-table file damaged: table_x")
			Return Null
		Else
			l.table_x = file.ReadInt()
		End If
		
		If Eof(file) Then'table y
			GAME_ERROR_HANDLER.error("level-table file damaged: table_y")
			Return Null
		Else
			l.table_y = file.ReadInt()
		End If
		
		l.table = New TBlock[l.table_x, l.table_y]
		
		For Local x:Int = 0 To l.table_x-1'table
			For Local y:Int = 0 To l.table_y-1
				
				Local coll:Int
				Local fg:Int
				Local ft:Int
				Local bg:Int
				Local bt:Int
				
				If Eof(file) Then'coll
					GAME_ERROR_HANDLER.error("level-table file damaged: coll, x=" + x + ", y=" + y)
					Return Null
				Else
					coll = file.ReadInt()
				End If
				
				If Eof(file) Then'fg
					GAME_ERROR_HANDLER.error("level-table file damaged: fg, x=" + x + ", y=" + y)
					Return Null
				Else
					fg = file.ReadInt()
				End If
				
				If Eof(file) Then'ft
					GAME_ERROR_HANDLER.error("level-table file damaged: ft, x=" + x + ", y=" + y)
					Return Null
				Else
					ft = file.ReadInt()
				End If
				
				If Eof(file) Then'bg
					GAME_ERROR_HANDLER.error("level-table file damaged: bg, x=" + x + ", y=" + y)
					Return Null
				Else
					bg = file.ReadInt()
				End If
				
				If Eof(file) Then'bt
					GAME_ERROR_HANDLER.error("level-table file damaged: bt, x=" + x + ", y=" + y)
					Return Null
				Else
					bt = file.ReadInt()
				End If
				
				l.table[x,y] = TBlock.Create(coll, fg, ft, bg, bt)
				
			Next
		Next
		
		'CloseFile(file)
		
		l.dialogue_id_map = New TMap
		
		'-------------------- OBJECTS ----------------
		'prepare chunks
		l.init_chunks(400,400)'l.init_chunks(l.table_x*l.image_side/5, l.table_y*l.image_side/5)
		
		If read_objects = True Then'SHOULD WE REALLY LOAD THE OBJECTS ?
			
			Print "//////////////  load objects \\\\\\\\\\\\\\\"
			
			'load objects
			Local object_file:TStream = ReadFile("Worlds\" + l.world.name + "\Levels\" + l.name + "\objects.data")
			
			If Not object_file Then
				GAME_ERROR_HANDLER.error("load -> reading objects: could not open file! : Worlds\" + l.world.name + "\Levels\" + l.name + "\objects.data")
				Return Null
			End If
			
			
			'If Not load_old_versions Then'load_old_versions
				' # VERSION
				Local l2:Int = object_file.ReadInt()
				
				l.vers = object_file.ReadString(l2)
				l.vers_c = object_file.ReadInt()
				
				If l.vers_c <> VERSION_COMPATIBILITY Then
					GAME_ERROR_HANDLER.error("Versions are not compatible! " + l.vers + ", " + l.vers_c)
				End If
				
				' # AUTOR
				Local a2:Int = object_file.ReadInt()
				l.autor = object_file.ReadString(a2)
				
				' # DATE
				Local d2:Int = object_file.ReadInt()
				l.date = object_file.ReadString(d2)
			'End If
			
			
			'Try
				While Not Eof(object_file)
					Local type_number:Int = ReadInt(object_file)
					
					Local o:TObject
					
					Select type_number
						Case 0
							o = TObject.read_from_stream(object_file)
						Case 1
							o = TPLAYER.read_from_stream(object_file)
						Case 2
							o = TBox.read_from_stream(object_file)
							
							Rem
							If TBox_Renderer_TLamp(TBox(o).renderer) Then
								l.location_map.insert(TBox_Renderer_TLamp(TBox(o).renderer).l_name,TBox(o))
							End If
							End Rem
							
							If TBox_Renderer_Teleporter(TBox(o).renderer) Then
								l.location_map.insert(TBox_Renderer_Teleporter(TBox(o).renderer).teleporter_name,TBox(o))
							End If
						Case 3
							o = TBox_Burnable.read_from_stream(object_file)
						Case 4
							o = TBADIE.read_from_stream(object_file)
						Case 5
							o = TBox_Door.read_from_stream(object_file)
							
							l.door_list.addlast(o)
						Case 6
							o = TBox_Key.read_from_stream(object_file)
						Case 7
							o = TBox_Stone.read_from_stream(object_file)
						Case 8
							o = TFireBird.read_from_stream(object_file)
						Default
							GAME_ERROR_HANDLER.error("load -> reading objects -> could not find this type of Objects! " + type_number)
							Return Null
					End Select
					
					If o <> Null Then
						l.add_object(o)
					Else
						GAME_ERROR_HANDLER.error("load -> reading objects -> could not create Object!")
						Return Null
					End If
					
				Wend
			'Catch error:String
			'	GAME_ERROR_HANDLER.error("load -> reading objects: " + error)
			'	Return Null
			'End Try
			
			CloseFile(object_file)
			
		End If
		
		'------------- LOAD SIGN TEXTS !
		
		l.sign_text_map = Sign_Text.load_for_level(l)
		
		'-------------------- BACKGROUND IMAGES ----------------
		
		Print "//////////////  load bg images \\\\\\\\\\\\\\\"
		
		Local number_of_bg_images:Int = 0
		
		If FileType("Worlds\" + l.world.name + "\Levels\" + l.name + "\background") Then
			While FileType("Worlds\" + l.world.name + "\Levels\" + l.name + "\background\" + number_of_bg_images + ".png")
				number_of_bg_images:+1
			Wend
		Else
			CreateDir("Worlds\" + l.world.name + "\Levels\" + l.name + "\background", True)
		End If
		
		l.bg_images = New TImage[number_of_bg_images]
		
		For Local i:Int = 0 To number_of_bg_images-1
			Print "Worlds\" + l.world.name + "\Levels\" + l.name + "\background\" + i + ".png"
			l.bg_images[i] = LoadImage("Worlds\" + l.world.name + "\Levels\" + l.name + "\background\" + i + ".png")
			
			If Not l.bg_images[i] Then
				GAME_ERROR_HANDLER.error("load -> loading background images -> could not load image! Worlds\" + l.world.name + "\Levels\" + l.name + "\background\" + i + ".png")
				Return Null
			End If
		Next
		
		TDialogue.load_for_level(l)
		
		Return l
	End Function
	
	
	Method save_running_level(name:String)
		
		Local directory:String = "Worlds\" + Game.world.name + "\Running_Levels\" + name
		
		CreateDir(directory)
		Local file:TStream = WriteFile(directory + "\running.data")
		
		If Not file Then
			GAME_ERROR_HANDLER.error("save_running_level -> could not create file! " + directory + "\running.data")
		End If
		
		
		'Write info about level
		
		DATA_FILE_HANDLER.WriteString(file, Self.world.name)'world
		DATA_FILE_HANDLER.WriteString(file, Self.name)'name
		
		file.WriteInt(MilliSecs())'millisecs
		
		file.WriteInt(Self.ansicht_act_x)'ansicht
		file.WriteInt(Self.ansicht_act_y)
		file.WriteInt(Self.ansicht_ziel_x)
		file.WriteInt(Self.ansicht_ziel_y)
		
		file.WriteInt(Self.ansicht_mode)'new
		
		
		file.WriteInt(Self.lights_on)'lights
		file.WriteInt(Self.brightness_r)
		file.WriteInt(Self.brightness_g)
		file.WriteInt(Self.brightness_b)
		
		file.WriteFloat(Self.black_in)'black in
		
		DATA_FILE_HANDLER.WriteString(file, Self.current_music_name)'music
		
		If Self.current_sign_text Then
			DATA_FILE_HANDLER.WriteString(file, Self.current_sign_text.name)'Current sign test
			file.WriteInt(Self.last_time_sign_text_activated)
		Else
			DATA_FILE_HANDLER.WriteString(file, "#")
			file.WriteInt(Self.last_time_sign_text_activated)
		End If
		
		If Self.current_dialogue Then
			DATA_FILE_HANDLER.WriteString(file, Self.current_dialogue.name)'current dialogue
			file.WriteInt(Self.current_sub)
		Else
			DATA_FILE_HANDLER.WriteString(file, "#")'current dialogue
			file.WriteInt(Self.current_sub)
		End If
		
		'save objects
		
		For Local x:Int = 0 To Self.anz_chunks_x-1
			For Local y:Int = 0 To Self.anz_chunks_y-1
				For Local layer:Int = 0 To 4
					For Local o:TObject = EachIn Self.chunks[x,y,layer].list
						o.write_to_stream_running(file)
					Next
				Next
			Next
		Next
		
		For Local layer:Int = 0 To 4
			For Local o:TObject = EachIn Self.super_chunks[layer].list
				o.write_to_stream_running(file)
			Next
		Next
		
		
		CloseFile(file)
		
		LEVEL_VARIABLES.save_to_file(directory + "\variables.txt")'save VARIABLES
		
	End Method
	
	Function load_saved_running_level:TLevel(name:String)
		
		Local directory:String = "Worlds\" + Game.world.name + "\Running_Levels\" + name
		
		Local file:TStream = ReadFile(directory + "\running.data")
		
		If Not file Then
			GAME_ERROR_HANDLER.error("save_running_level -> could not open file! " + directory + "\running.data")
			Return Null
		End If
		
		'read info about level
		Local l_world_name:String = DATA_FILE_HANDLER.ReadString(file)
		Local l_name:String = DATA_FILE_HANDLER.ReadString(file)
		
		If l_world_name <> GAME.world.name Then
			GAME_ERROR_HANDLER.error("save_running_level -> level is from wrong world! " + l_world_name + "<>" + GAME.world.name)
			Return Null
		End If
		
		Local level:TLevel = TLevel.Load(GAME.world, l_name, False)
		
		If Not level Then
			GAME_ERROR_HANDLER.error("save_running_level -> could not load original level!")
			Return Null
		End If
		
		Local delta_t:Int = MilliSecs() - file.ReadInt()'millisecs
		
		level.ansicht_act_x = file.ReadInt()'ansicht
		level.ansicht_act_y = file.ReadInt()
		level.ansicht_ziel_x = file.ReadInt()
		level.ansicht_ziel_y = file.ReadInt()
		
		level.ansicht_mode = file.ReadInt()'new
		
		
		level.lights_on = file.ReadInt()'lights
		level.brightness_r = file.ReadInt()
		level.brightness_g = file.ReadInt()
		level.brightness_b = file.ReadInt()
		
		
		level.black_in = file.ReadFloat()'black in
		
		level.current_music_name = DATA_FILE_HANDLER.ReadString(file)'music
		
		Local cstn:String = DATA_FILE_HANDLER.ReadString(file)'Current sign test
		If level.sign_text_map.contains(cstn) Then
			level.current_sign_text = Sign_Text(level.sign_text_map.ValueForKey(cstn))
		End If
		level.last_time_sign_text_activated = file.ReadInt() + delta_t
		
		Local cdn:String = DATA_FILE_HANDLER.ReadString(file)'current dialogue
		If level.dialogue_map.contains(cdn) Then
			level.current_dialogue = TDialogue(level.dialogue_map.ValueForKey(cdn))
		End If
		level.current_sub = file.ReadInt()
		
		'load objects:
		
		level.dialogue_id_map = New TMap
		
		While Not Eof(file)
			Local type_number:Int = ReadInt(file)
			
			Local o:TObject
			
			Print type_number
			
			Select type_number
				Case 0
					o = TObject.read_from_stream_running(file, delta_t)
				Case 1
					o = TPLAYER.read_from_stream_running(file, delta_t)
				Case 2
					o = TBox.read_from_stream_running(file, delta_t)
					
					If TBox_Renderer_Teleporter(TBox(o).renderer) Then
						level.location_map.insert(TBox_Renderer_Teleporter(TBox(o).renderer).teleporter_name,TBox(o))
					End If
				Case 3
					o = TBox_Burnable.read_from_stream_running(file, delta_t)
				Case 4
					o = TBADIE.read_from_stream_running(file, delta_t)
				Case 5
					o = TBox_Door.read_from_stream_running(file, delta_t)
					
					level.door_list.addlast(o)
				Case 6
					o = TBox_Key.read_from_stream_running(file, delta_t)
				Case 7
					o = TBox_Stone.read_from_stream_running(file, delta_t)
				Case 8
					o = TFireBird.read_from_stream_running(file, delta_t)
				Default
					GAME_ERROR_HANDLER.error("save_running_level -> reading objects -> could not find this type of Objects! " + type_number)
					Return Null
			End Select
			
			If o <> Null Then
				level.add_object(o)
			Else
				GAME_ERROR_HANDLER.error("save_running_level -> reading objects -> could not create Object!")
				Return Null
			End If
			
		Wend
		
		LEVEL_VARIABLES.load_from_file(directory + "\variables.txt")'load VARIABLES
		
		Return level
	End Function
	
	Function black_out()
		Flip
		
		Local image:TImage=CreateImage(800,600,1,DYNAMICIMAGE)
		
		GrabImage image, Graphics_Handler.origin_x, Graphics_Handler.origin_y
		
		For Local i:Float = 0.0 To 1.0 Step 0.04
			Cls
			SetColor 255,255,255
			Draw_Image image,0,0
			
			SetColor 0,0,0
			SetAlpha i
			Draw_Rect 0,0,800,600
			SetAlpha 1
			
			Graphics_Handler.draw_brille()
			
			Flip
		Next
		Cls
		
		GAME.world.act_level.black_in = 1.0
	End Function
	
	Method run:Int()
		'##########################################################################################
		'################################       MAIN LOOP          ################################
		'##########################################################################################
		
		Self.black_in = 1.0
		
		Repeat
			If TControls.reload.key.hit Then
				TControls.reload.key.hit = 0
				GAME.world.act_level = TLevel.Load(GAME.world, GAME.world.act_level.name, True)
				GAME.world.act_level.run()
				Return 0
			End If
			
			'############## RENDER ###############
			
			'EMEGUI.render_events()'RENDER mouse and co.
			
			Self.render_brightness()
			
			LEVEL_VARIABLES.render_sys()
			
			TControls.render_controls()
			
			GAME.world.act_level.render()'RENDER LEVEL
			
			GAME.world.act_level.render_chunks(-GAME.world.act_level.ansicht_act_x+400.0, -GAME.world.act_level.ansicht_act_y+300.0)
			
			'################ DRAW Level #########
			
			'------------------------------------- MAP -------------------------------------
			'SetViewport(0,0,800,600)
			SetClsColor 0,0,0
			Cls
			SetColor 255,255,255
			
			GAME.world.act_level.draw_bg_images()
			
			GAME.world.act_level.draw_chunks(0, -GAME.world.act_level.ansicht_act_x+400.0, -GAME.world.act_level.ansicht_act_y+300.0)
			GAME.world.act_level.draw_bg()' DRAW LEVEL BG
			GAME.world.act_level.draw_chunks(1, -GAME.world.act_level.ansicht_act_x+400.0, -GAME.world.act_level.ansicht_act_y+300.0)
			GAME.world.act_level.draw_chunks(2, -GAME.world.act_level.ansicht_act_x+400.0, -GAME.world.act_level.ansicht_act_y+300.0)
			GAME.world.act_level.draw_chunks(3, -GAME.world.act_level.ansicht_act_x+400.0, -GAME.world.act_level.ansicht_act_y+300.0)
			GAME.world.act_level.draw_fg()' DRAW LEVEL FG
			GAME.world.act_level.draw_chunks(4, -GAME.world.act_level.ansicht_act_x+400.0, -GAME.world.act_level.ansicht_act_y+300.0)
			'----------------------------- DRAW LIGHTS ------------------------------------
			'If KeyHit(key_l) Then GAME.world.act_level.lights_on = 1-GAME.world.act_level.lights_on
			'If KeyHit(key_p) Then TWorld.particles_on = 1-TWorld.particles_on
			
			SetBlend shadeblend
			SetColor 255,255,255
			If GAME.world.act_level.lights_on Then TBuffer.light_mix.draw(Graphics_Handler.origin_x,Graphics_Handler.origin_y)
			SetBlend alphablend
			TBuffer.light_mix.cls_me(Self.brightness_r/255.0,Self.brightness_g/255.0,Self.brightness_b/255.0)
			
			'################ DRAW rest ##########
			
			'----------------------------- LEVEL INTERFACE ------------------------------------
			GAME.world.act_level.draw_interface()
			
			
			If CHEAT_MODE Then
				If KeyHit(KEY_F8) Then'cheat set stone
					GAME.world.act_level.player.set_mode(TPLAYER_MODE.modes[5],1)
				End If
				
				If KeyHit(KEY_F9) Then'cheat set normal
					GAME.world.act_level.player.set_mode(TPLAYER_MODE.modes[0],1)
				End If
				
				If KeyHit(KEY_F10) Then'cheat set fire
					GAME.world.act_level.player.set_mode(TPLAYER_MODE.modes[1],1)
				End If
				
				If KeyHit(KEY_F11) Then'cheat set water
					GAME.world.act_level.player.set_mode(TPLAYER_MODE.modes[2],1)
				End If
				
				If KeyHit(KEY_F12) Then'cheat set plant
					GAME.world.act_level.player.set_mode(TPLAYER_MODE.modes[6],1)
				End If
				
				If KeyHit(KEY_F1) Then' DEBUG MODE !
					Graphics_Handler.show_debug = 1-Graphics_Handler.show_debug
				End If
				
				If KeyHit(KEY_F6) Then' PARTICLES
					TWorld.particles_on = 1-TWorld.particles_on
				End If
				
				If KeyHit(KEY_F7) Then' LIGHTS
					TWorld.lightengine_on = 1-TWorld.lightengine_on
				End If
				
				
				If Graphics_Handler.show_debug Then
					'SHOW LEVEL NAME
					SetColor 0,0,0
					SetAlpha 0.7
					Draw_Rect 395,5,400,100
					SetAlpha 1.0
					
					SetColor 255,255,255
					Draw_Text "World: " + GAME.world.name + ", Level: " + GAME.world.act_level.name, 400, 10
					Draw_Text "Autor: " + GAME.world.act_level.autor + ", Date: " + GAME.world.act_level.date , 400, 40
					Draw_Text "Version: " + GAME.world.act_level.vers + ", C: " + GAME.world.act_level.vers_c, 400, 70
					
					
					LEVEL_VARIABLES.draw_to_screen(150,80)' SHOW VARIABLES
					
					' --- SHOW F's ---
					
					SetAlpha 0.7
					SetColor 0,0,0
					Draw_Rect 550,120,240,260
					SetAlpha 1
					
					SetColor 200,200,200
					Draw_Text "F1 -> Toggle Help Mode",560,130
					
					Draw_Text "F2 -> Screenshot",560,170
					Draw_Text "F3 -> Levelshot",560,190
					
					Draw_Text "F5 -> fly",560,230
					
					Draw_Text "F8 -> stone",560,270
					Draw_Text "F9 -> normal",560,290
					Draw_Text "F10 -> fire",560,310
					Draw_Text "F11 -> water",560,330
					Draw_Text "F12 -> plant",560,350
					
					
					' --- Settings ---
					SetAlpha 0.7
					SetColor 0,0,0
					Draw_Rect 550,400,240,90
					SetAlpha 1
					
					SetColor 100+TWorld.particles_on*100,100+TWorld.particles_on*100,150
					Draw_Text "F6 -> Particles: " + TWorld.particles_on,560,410
					
					SetColor 100+TWorld.lightengine_on*100,100+TWorld.lightengine_on*100,150
					Draw_Text "F7 -> Light: " + TWorld.lightengine_on,560,430
					
					SetColor 200,200,200
					Draw_Text "Language: " + Language_Handler.cl.name + " (" + Language_Handler.cl.small + ")",560,450
					
					' ### FPS ###
					SetAlpha 0.5
					SetColor 0,0,0
					Draw_Rect 0,0,130,70
					SetAlpha 1
					SetColor 255,255,0
					Draw_Text "FIX: " + Mid(Graphics_Handler.FPS_MAX,1,5),0,0
					Draw_Text "FPS: " + Graphics_Handler.last_sec_FPS,0,20
					Draw_Text "LEFT: " + Graphics_Handler.last_sec_delay + " ms/s",0,40
				End If
				
			End If
			
			'----------------------------- BLACK IN ------------------------------------
			If GAME.world.act_level.black_in > 0.0 Then
				SetColor 0,0,0
				SetAlpha GAME.world.act_level.black_in
				Draw_Rect 0,0,800,600
				SetAlpha 1
			End If
			
			'----------------------------- LEVEL COMPLETED --------------------------------
			
			If GAME.world.act_level.level_completed = 1 Then
				SetColor 255,255,255
				Draw_Image MENU.level_complete_image,0,0
				
				MENU.mouse_x = MouseX()-(Graphics_Handler.mode = 2)*Graphics_Handler.origin_x'mouse
				MENU.mouse_y = MouseY()-(Graphics_Handler.mode = 2)*Graphics_Handler.origin_y
				
				If MENU.mouse_x>800 Then MENU.mouse_x = 800
				If MENU.mouse_y>600 Then MENU.mouse_y = 600
				If MENU.mouse_x<0 Then MENU.mouse_x = 0
				If MENU.mouse_y<0 Then MENU.mouse_y = 0
				
				MENU.mouse_down_1 = MouseDown(1)
				MENU.mouse_hit_1 = MouseHit(1)
				
				If MENU.mouse_x > 650 And MENU.mouse_y > 550 And MENU.mouse_hit_1 Then'continue
					GAME.world.act_level = Null
					Return 1
				End If
				
				MENU.draw_mouse()
				
			End If
			
			
			' -------------------------- Screenshot -------------------------------
			If KeyHit(KEY_F2) Then
				Local image:TImage=CreateImage(800,600,1,DYNAMICIMAGE)'|MASKEDIMAGE)
				GrabImage image,0,0
				Local i:Int = 0
				Repeat
					i:+1
				Until FileType("screenshots\"+i+".png")=0
				SavePixmapPNG(LockImage(image), "screenshots\"+i+".png")
			End If
			
			' -------------------------- RAMEN -------------------------------
			Graphics_Handler.draw_brille()
			
			
			' ----------------------------- FIX FPS ---------------------------
			If Graphics_Handler.last_sec_end=0 Or MilliSecs()-Graphics_Handler.last_sec_end>2000 Then
				Graphics_Handler.last_sec_end = MilliSecs()
				Graphics_Handler.last_sec_delay = Graphics_Handler.delay_counter
				Graphics_Handler.delay_counter = 0
				Graphics_Handler.last_sec_FPS = Graphics_Handler.FPS_counter
				Graphics_Handler.FPS_counter = 0
			End If
			
			If MilliSecs()-Graphics_Handler.last_sec_end>=1000 Then
				Graphics_Handler.last_sec_end:+1000
				Graphics_Handler.last_sec_delay = Graphics_Handler.delay_counter
				Graphics_Handler.delay_counter = 0
				Graphics_Handler.last_sec_FPS = Graphics_Handler.FPS_counter
				Graphics_Handler.FPS_counter = 0
				
				
				If Graphics_Handler.last_sec_delay>900 Then
					Graphics_Handler.FPS_MAX:+10
				ElseIf Graphics_Handler.last_sec_delay>600 Then
					Graphics_Handler.FPS_MAX:+3
				ElseIf Graphics_Handler.last_sec_delay>300 Then
					Graphics_Handler.FPS_MAX:+1
				ElseIf Graphics_Handler.last_sec_delay=0
					Graphics_Handler.FPS_MAX:-5
				ElseIf Graphics_Handler.last_sec_delay<50
					Graphics_Handler.FPS_MAX:-2
				ElseIf Graphics_Handler.last_sec_delay<100
					Graphics_Handler.FPS_MAX:-1
				End If
			End If
			
			
			If Self.last_updated >= MilliSecs()-1000/Graphics_Handler.FPS_MAX Then
				Graphics_Handler.delay_counter:+ Self.last_updated - (MilliSecs()-1000.0/Graphics_Handler.FPS_MAX)
				Delay Self.last_updated - (MilliSecs()-1000.0/Graphics_Handler.FPS_MAX)
			End If
			
			Graphics_Handler.FPS_counter:+1
			Self.last_updated = MilliSecs()
			
			
			If Graphics_Handler.FPS_MAX<10 Then Graphics_Handler.FPS_MAX=10
			If Graphics_Handler.FPS_MAX>60 Then Graphics_Handler.FPS_MAX=60
			
			' ------------------------- FLIP ----------------------------------------------
			Flip
			
			' -------------------------- Level Screenshot -------------------------------
			If KeyHit(KEY_F3) And CHEAT_MODE Then
				'#################################################################
				
				Local image:TImage=CreateImage(800,600,1,DYNAMICIMAGE|MASKEDIMAGE)
				Local ans_before_x:Float = GAME.world.act_level.ansicht_act_x
				Local ans_before_y:Float = GAME.world.act_level.ansicht_act_y
				
				
				For Local pos_x:Int = 0 To (GAME.world.act_level.table_x*GAME.world.block_image_manager.image_side)/800
					For Local pos_y:Int = 0 To (GAME.world.act_level.table_y*GAME.world.block_image_manager.image_side)/600
						
						GAME.world.act_level.ansicht_act_x = -pos_x*800.0
						GAME.world.act_level.ansicht_act_y = -pos_y*600.0
						
						GAME.world.act_level.render()'RENDER LEVEL
						
						GAME.world.act_level.ansicht_act_x = -pos_x*800.0
						GAME.world.act_level.ansicht_act_y = -pos_y*600.0
						
						GAME.world.act_level.render_chunks(-GAME.world.act_level.ansicht_act_x+400.0, -GAME.world.act_level.ansicht_act_y+300.0)
						
						GAME.world.act_level.ansicht_act_x = -pos_x*800.0
						GAME.world.act_level.ansicht_act_y = -pos_y*600.0
						
						SetClsColor 0,0,0
						Cls
						SetColor 255,255,255
						
						'GAME.world.act_level.draw_bg_images()
						
						GAME.world.act_level.draw_chunks(0, -GAME.world.act_level.ansicht_act_x+400.0, -GAME.world.act_level.ansicht_act_y+300.0)
						GAME.world.act_level.draw_bg()' DRAW LEVEL BG
						GAME.world.act_level.draw_chunks(1, -GAME.world.act_level.ansicht_act_x+400.0, -GAME.world.act_level.ansicht_act_y+300.0)
						GAME.world.act_level.draw_chunks(2, -GAME.world.act_level.ansicht_act_x+400.0, -GAME.world.act_level.ansicht_act_y+300.0)
						GAME.world.act_level.draw_chunks(3, -GAME.world.act_level.ansicht_act_x+400.0, -GAME.world.act_level.ansicht_act_y+300.0)
						GAME.world.act_level.draw_fg()' DRAW LEVEL FG
						GAME.world.act_level.draw_chunks(4, -GAME.world.act_level.ansicht_act_x+400.0, -GAME.world.act_level.ansicht_act_y+300.0)
						'----------------------------- DRAW LIGHTS ------------------------------------
						
						SetBlend shadeblend
						SetColor 255,255,255
						If GAME.world.act_level.lights_on Then TBuffer.light_mix.draw(0,0)
						SetBlend alphablend
						TBuffer.light_mix.cls_me(Self.brightness_r/255.0,Self.brightness_g/255.0,Self.brightness_b/255.0)
						
						'save it
						
						GrabImage image,0,0
						SavePixmapPNG(LockImage(image), "level_shot\"+pos_x+"_"+pos_y+".png")
					Next
				Next
				
				GAME.world.act_level.ansicht_act_x = ans_before_x
				GAME.world.act_level.ansicht_act_y = ans_before_y
				'##################################################################
				
			End If
			' -------------------------- end Level Screenshot -------------------------------
			
		Until TControls.escape.key.hit Or AppTerminate()
		'##########################################################################################
		'################################    END OF MAIN LOOP      ################################
		'##########################################################################################
		TSoundPlayer.pause_all()
	End Method
	
	
	
	Method draw_bg_images()
		SetColor 255,255,255
		
		For Local i:Int = 0 To Self.bg_images.length-1
			Draw_Image Self.bg_images[i], Int((GAME.world.act_level.ansicht_act_x)/Float(Self.table_x*Self.image_side-800)*Float(Self.bg_images[i].width-800)), Int((GAME.world.act_level.ansicht_act_y)/Float(Self.table_y*Self.image_side-600)*Float(Self.bg_images[i].height - 600))
		Next
	End Method
	
	
	Method goto_ansicht_ziel()
		Self.ansicht_act_x = Self.ansicht_ziel_x
		Self.ansicht_act_y = Self.ansicht_ziel_y
	End Method
	
	Field player_dead_countdown:Int = -1
	
	Method render_music()
		
		Music_Handler.set_music(Self.current_music_name)
		
		TSoundPlayer.render_all()
		
	End Method
	
	Method render()
		Self.render_music()
		
		If Self.player = Null Then
			If Self.player_dead_countdown = -1 Then
				Self.player_dead_countdown = 100
			Else
				Self.player_dead_countdown:-1
				If Self.player_dead_countdown = 0 Then
					
					Flip
					
					Local image:TImage=CreateImage(800,600,1,DYNAMICIMAGE)
					
					GrabImage image, Graphics_Handler.origin_x, Graphics_Handler.origin_y
					
					For Local i:Float = 0.0 To 1.0 Step 0.04
						Cls
						SetColor 255,255,255
						Draw_Image image,0,0
						
						SetColor 0,0,0
						SetAlpha i
						Draw_Rect 0,0,800,600
						SetAlpha 1
						
						Graphics_Handler.draw_brille()
						
						Flip
					Next
					Cls
					
					'reload
					
					GAME.world.act_level = TLevel.load_saved_running_level("check_point_save_"+INFO.get_computer_name())
					Return
				End If
			End If
		End If
		
		Self.black_in:-0.04
		If Self.black_in < 0.0 Then
			Self.black_in = 0.0
		End If
		
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
		
		If Self.ansicht_ziel_x < - GAME.world.act_level.table_x*GAME.world.block_image_manager.image_side + 800 Then'x
			Self.ansicht_ziel_x = - GAME.world.act_level.table_x*GAME.world.block_image_manager.image_side + 800
		End If
		
		If Self.ansicht_act_x < - GAME.world.act_level.table_x*GAME.world.block_image_manager.image_side + 800 Then
			Self.ansicht_act_x = - GAME.world.act_level.table_x*GAME.world.block_image_manager.image_side + 800
		End If
		
		If Self.ansicht_ziel_y < - GAME.world.act_level.table_y*GAME.world.block_image_manager.image_side + 600 Then'y
			Self.ansicht_ziel_y = - GAME.world.act_level.table_y*GAME.world.block_image_manager.image_side + 600
		End If
		
		If Self.ansicht_act_y < - GAME.world.act_level.table_y*GAME.world.block_image_manager.image_side + 600 Then
			Self.ansicht_act_y = - GAME.world.act_level.table_y*GAME.world.block_image_manager.image_side + 600
		End If
		
		If Self.player Then
			
			Local ver_x:Float = (Float(Self.ansicht_act_x) - Float(Self.ansicht_ziel_x))*0.1
			Local ver_y:Float = (Float(Self.ansicht_act_y) - Float(Self.ansicht_ziel_y))*0.1
			
			If ((ver_x)^2 + (ver_y)^2)^0.5 > 15.0 And Self.ansicht_mode = 1 Then
				Local ww:Float = ATan2(ver_y, ver_x)
				ver_x = Cos(ww)*15.0
				ver_y = Sin(ww)*15.0
				Print "slow!"
			End If
			
			Self.ansicht_act_x:- ver_x*(60.0/Graphics_Handler.FPS_MAX)
			Self.ansicht_act_y:- ver_y*(60.0/Graphics_Handler.FPS_MAX)
		End If
	End Method
	
	
	Method draw_bg()
		
		Local x1:Int = 0
		Local x2:Int = Self.table_x - 1
		
		If x1 < (0 - GAME.world.act_level.ansicht_act_x)/GAME.world.block_image_manager.image_side Then
			x1 = (0 - GAME.world.act_level.ansicht_act_x)/GAME.world.block_image_manager.image_side
		End If
		
		If x2 > (800 - GAME.world.act_level.ansicht_act_x)/GAME.world.block_image_manager.image_side Then
			x2 = (800 - GAME.world.act_level.ansicht_act_x)/GAME.world.block_image_manager.image_side
		End If
		
		Local y1:Int = 0
		Local y2:Int = Self.table_y - 1
		
		If y1 < (0 - GAME.world.act_level.ansicht_act_y)/GAME.world.block_image_manager.image_side Then
			y1 = (0 - GAME.world.act_level.ansicht_act_y)/GAME.world.block_image_manager.image_side
		End If
		
		If y2 > (600 - GAME.world.act_level.ansicht_act_y)/GAME.world.block_image_manager.image_side Then
			y2 = (600 - GAME.world.act_level.ansicht_act_y)/GAME.world.block_image_manager.image_side
		End If
		
		For Local x:Int = x1 To x2
			For Local y:Int = y1 To y2
				
				table[x,y].bg_draw(x*Self.image_side + Self.ansicht_act_x, y*Self.image_side + Self.ansicht_act_y)
				
			Next
		Next
		
	End Method
	
	Method draw_fg()
		
		Local x1:Int = 0
		Local x2:Int = Self.table_x - 1
		
		If x1 < (0 - GAME.world.act_level.ansicht_act_x)/GAME.world.block_image_manager.image_side Then
			x1 = (0 - GAME.world.act_level.ansicht_act_x)/GAME.world.block_image_manager.image_side
		End If
		
		If x2 > (800 - GAME.world.act_level.ansicht_act_x)/GAME.world.block_image_manager.image_side Then
			x2 = (800 - GAME.world.act_level.ansicht_act_x)/GAME.world.block_image_manager.image_side
		End If
		
		Local y1:Int = 0
		Local y2:Int = Self.table_y - 1
		
		If y1 < (0 - GAME.world.act_level.ansicht_act_y)/GAME.world.block_image_manager.image_side Then
			y1 = (0 - GAME.world.act_level.ansicht_act_y)/GAME.world.block_image_manager.image_side
		End If
		
		If y2 > (600 - GAME.world.act_level.ansicht_act_y)/GAME.world.block_image_manager.image_side Then
			y2 = (600 - GAME.world.act_level.ansicht_act_y)/GAME.world.block_image_manager.image_side
		End If
		
		For Local x:Int = x1 To x2
			For Local y:Int = y1 To y2
				
				table[x,y].fg_draw(x*Self.image_side + Self.ansicht_act_x, y*Self.image_side + Self.ansicht_act_y)
				
			Next
		Next
		
	End Method
	
		
	Method init_chunks(max_dx:Float, max_dy:Float)'INIT CHUNKS
		Self.anz_chunks_x = Ceil(Float(Self.table_x * Self.image_side) / max_dx)'calculate the number of chunks needed
		Self.anz_chunks_y = Ceil(Float(Self.table_y * Self.image_side) / max_dy)
		Self.chunks = New TCHUNK[Self.anz_chunks_x, Self.anz_chunks_y,5]
		
		Local dx:Float = Float(Self.table_x * Self.image_side) / Float(Self.anz_chunks_x)
		Local dy:Float = Float(Self.table_y * Self.image_side) / Float(Self.anz_chunks_y)
		
		'create all the necessary chunks
		For Local x:Int = 0 To Self.anz_chunks_x-1
			For Local y:Int = 0 To Self.anz_chunks_y-1
				For Local layer:Int = 0 To 4
					Self.chunks[x,y,layer] = TCHUNK.Create(x,y, layer, dx, dy)
				Next
			Next
		Next
		
		For Local layer:Int = 0 To 4
			Self.super_chunks[layer] = TCHUNK.Create(0,0, layer, Self.table_x * Self.image_side, Self.table_y * Self.image_side)
		Next
	End Method
	
	Method render_chunks(centre_x:Int, centre_y:Int)'RENDERS chunks
		
		Local c_x:Int = Int(centre_x/(Float(Self.table_x * Self.image_side) / Float(Self.anz_chunks_x)))
		Local c_y:Int = Int(centre_y/(Float(Self.table_y * Self.image_side) / Float(Self.anz_chunks_y)))
		
		Local x1:Int = c_x - 2
		If x1 < 0 Then x1 = 0
		Local x2:Int = c_x + 2
		If x2 > Self.anz_chunks_x-1 Then x2 = Self.anz_chunks_x-1
		Local y1:Int = c_y - 3
		If y1 < 0 Then y1 = 0
		Local y2:Int = c_y + 3
		If y2 > Self.anz_chunks_y-1 Then y2 = Self.anz_chunks_y-1
		
		For Local x:Int = x1 To x2
			For Local y:Int = y1 To y2
				For Local layer:Int = 0 To 4
					Self.chunks[x,y,layer].render()
				Next
			Next
		Next
		
		For Local layer:Int = 0 To 4
			Self.super_chunks[layer].render()
		Next
	End Method
	
	Method set_fire_to_burnable_boxes(box:TBox_Burnable, radius:Float)'centre_x:Int, centre_y:Int)'RENDERS chunks
		
		Local c_x:Int = Int(box.x/(Float(Self.table_x * Self.image_side) / Float(Self.anz_chunks_x)))
		Local c_y:Int = Int(box.y/(Float(Self.table_y * Self.image_side) / Float(Self.anz_chunks_y)))
		
		Local x1:Int = c_x - 2
		If x1 < 0 Then x1 = 0
		Local x2:Int = c_x + 2
		If x2 > Self.anz_chunks_x-1 Then x2 = Self.anz_chunks_x-1
		Local y1:Int = c_y - 3
		If y1 < 0 Then y1 = 0
		Local y2:Int = c_y + 3
		If y2 > Self.anz_chunks_y-1 Then y2 = Self.anz_chunks_y-1
		
		For Local x:Int = x1 To x2
			For Local y:Int = y1 To y2
				For Local layer:Int = 0 To 4
					Self.set_fire_to_burnable_boxes_chunk(Self.chunks[x,y,layer], box, radius)'Self.chunks[x,y,layer].render()
				Next
			Next
		Next
		
		For Local layer:Int = 0 To 4
			Self.set_fire_to_burnable_boxes_chunk(Self.super_chunks[layer], box, radius)'Self.super_chunks[layer].render()
		Next
		
	End Method
	
	Method set_fire_to_burnable_boxes_chunk(chunk:TCHUNK, box:TBox_Burnable, radius:Float)
		
		
		For Local b:TBox_Burnable = EachIn chunk.list
			If ((b.x - (box.x+TBox_Burnable.burnable_typs[box.typ,box.rotation].dx))^2 + (b.y - (box.y+TBox_Burnable.burnable_typs[box.typ,box.rotation].dy))^2)^0.5 < radius Then
				b.set_fire()
			Else If (((b.x+TBox_Burnable.burnable_typs[b.typ,box.rotation].dx) - box.x)^2 + ((b.y+TBox_Burnable.burnable_typs[b.typ,box.rotation].dy) - box.y)^2)^0.5 < radius Then
				b.set_fire()
			Else If ((b.x - (box.x+TBox_Burnable.burnable_typs[box.typ,box.rotation].dx))^2 + ((b.y+TBox_Burnable.burnable_typs[b.typ,box.rotation].dy) - box.y)^2)^0.5 < radius Then
				b.set_fire()
			Else If (((b.x+TBox_Burnable.burnable_typs[b.typ,box.rotation].dx) - box.x)^2 + (b.y - (box.y+TBox_Burnable.burnable_typs[box.typ,box.rotation].dy))^2)^0.5 < radius Then
				b.set_fire()
			Else If ((b.x - box.x)^2+(b.y - box.y)^2)^0.5 < radius Then
				b.set_fire()
			End If
		Next
		
	End Method
	
	Method break_stone_boxes(player:TPLAYER)'centre_x:Int, centre_y:Int)'RENDERS chunks
		
		Local c_x:Int = Int(player.x/(Float(Self.table_x * Self.image_side) / Float(Self.anz_chunks_x)))
		Local c_y:Int = Int(player.y/(Float(Self.table_y * Self.image_side) / Float(Self.anz_chunks_y)))
		
		Local x1:Int = c_x - 1
		If x1 < 0 Then x1 = 0
		Local x2:Int = c_x + 1
		If x2 > Self.anz_chunks_x-1 Then x2 = Self.anz_chunks_x-1
		Local y1:Int = c_y - 1
		If y1 < 0 Then y1 = 0
		Local y2:Int = c_y + 1
		If y2 > Self.anz_chunks_y-1 Then y2 = Self.anz_chunks_y-1
		
		For Local x:Int = x1 To x2
			For Local y:Int = y1 To y2
				For Local layer:Int = 0 To 4
					Self.break_stone_boxes_chunk(Self.chunks[x,y,layer], player)'Self.chunks[x,y,layer].render()
				Next
			Next
		Next
		
		For Local layer:Int = 0 To 4
			Self.break_stone_boxes_chunk(Self.super_chunks[layer], player)'Self.super_chunks[layer].render()
		Next
		
	End Method
	
	Method break_stone_boxes_chunk(chunk:TCHUNK, player:TPLAYER)
		
		
		For Local b:TBox_Stone = EachIn chunk.list
			If Abs(player.y + player.mode.ry - b.y) < 1.0 Then
				
				If player.x > b.x - player.mode.rx And player.x < b.x + TBox_Stone.stone_typs[b.typ,b.rotation].dx + player.mode.rx Then
					b.set_breaking()
				End If
				
			End If
			
		Next
		
	End Method
	
	Method draw_chunks(layer:Int, centre_x:Int, centre_y:Int)'DRAW Chunks of a certain layer
		
		Local c_x:Int = Int(centre_x/(Float(Self.table_x * Self.image_side) / Float(Self.anz_chunks_x)))
		Local c_y:Int = Int(centre_y/(Float(Self.table_y * Self.image_side) / Float(Self.anz_chunks_y)))
		
		Local x1:Int = c_x - 2
		If x1 < 0 Then x1 = 0
		Local x2:Int = c_x + 2
		If x2 > Self.anz_chunks_x-1 Then x2 = Self.anz_chunks_x-1
		Local y1:Int = c_y - 3
		If y1 < 0 Then y1 = 0
		Local y2:Int = c_y + 3
		If y2 > Self.anz_chunks_y-1 Then y2 = Self.anz_chunks_y-1
		
		For Local x:Int = x1 To x2
			For Local y:Int = y1 To y2
				Self.chunks[x,y,layer].draw()
			Next
		Next
		
		Self.super_chunks[layer].draw()
	End Method
	
	Field last_frame:Int = MilliSecs()
	
	Method draw_interface()
		
		If Self.player Then'temperature
			
			SetColor 255,255,255
			Draw_Image Self.heatbar_bg_image,10,10' BG
			
			'heatbar
			SetColor Float(0.5*2.55*Self.player.temperature),101-Float(0.5*1.01*Self.player.temperature),255-Float(0.5*2.55*Self.player.temperature)
			'Draw_Rect 15,25 + 200 - Self.player.temperature,25,Self.player.temperature+15
			
			Draw_Image Self.heatbar_abschluss_oben_image,23,25+200-Self.player.temperature
			
			SetScale 1,(Self.player.temperature-5)
			Draw_Image Self.heatbar_verlauf_oben_image,23,25+200-Self.player.temperature+5
			SetScale 1,1
			
			Draw_Image Self.heatbar_unten_image,17,25+200
			
			
			'waterbar
			SetColor 255,255,255
			Draw_Image Self.waterbar_abschluss_oben_image,41,35+84-Self.player.water_amount-12
			
			SetScale 1,(Self.player.water_amount)
			Draw_Image Self.waterbar_verlauf_oben_image,41,35+84-Self.player.water_amount
			SetScale 1,1
			
			
			'chargebar
			SetColor 50,150+100*Self.player.water_charge/84,250-150*Self.player.water_charge/84
			Draw_Image Self.chargebar_abschluss_oben_image,86,35+84-Self.player.water_charge
			
			SetScale 1,(Self.player.water_charge-3)
			Draw_Image Self.chargebar_verlauf_oben_image,86,35+84-Self.player.water_charge+3
			SetScale 1,1
			
			
			SetColor 255,255,255'FG
			Draw_Image Self.heatbar_image,10,10
		End If
		
		If Self.player And Self.player.mode = TPLAYER_MODE.modes[1] Then'fire
			
			SetColor 255,200-Float(222.0*Float(Self.player.burning_for)/600.0)+(MilliSecs()/10 Mod 50),0
			
			Draw_Image Self.firebar_l_image,400-(200*(600-Self.player.burning_for)/600.0)-4,570
			For Local i:Int = 400-(200*(600-Self.player.burning_for)/600.0) To 400+(200*(600-Self.player.burning_for)/600.0) Step 2
				Draw_Image Self.firebar_m_image,i,570
			Next
			Draw_Image Self.firebar_r_image,400+(200*(600-Self.player.burning_for)/600.0),570
			
		End If
		
		If Self.current_dialogue <> Null  Then
			
			SetColor 255,255,255
			Draw_Image Self.textbox_image,50,450
			
			SetColor 255,255,255
			
			
			Local f:TFace = TFace(Self.world.faces_map.ValueForKey(Self.current_dialogue.subs[Self.current_sub].face))
			
			If f Then
				Draw_Image f.image,65,465,((MilliSecs()/f.image_speed) Mod f.image.frames.length)
			Else
				Print "bad face!"
				Print Self.current_dialogue.subs[Self.current_sub].face
			End If
			
			For Local i:Int = 0 To Self.current_dialogue.subs[Self.current_sub].lines.length - 1
				
				'Draw_Text LEVEL_VARIABLES.get_txt(Self.current_dialogue.subs[Self.current_sub].lines[i]), 170,470 + 25*i
				
				Local txt_ln:String = LEVEL_VARIABLES.get_txt(Self.current_dialogue.subs[Self.current_sub].lines[i])
				
				
				Local draw_mode:Int=0
				Local current_txt:String=""
				Local dx:Int = 0
				
				For Local ii:Int = 1 To Len(txt_ln)
					If draw_mode=0 Then
						Select Mid(txt_ln,ii,1)
							Case "@"
								draw_mode=1
								
								Draw_Text current_txt, 170+dx,470 + 25*i
								
								
								dx:+TextWidth(current_txt)
								current_txt=""
							Default
								current_txt:+Mid(txt_ln,ii,1)
						End Select
					Else
						Select Mid(txt_ln,ii,1)
							Case "@"
								draw_mode=0
								
								Select Lower(current_txt)
									Case "red","r"
										SetColor 255,50,50
									Case "blue","b"
										SetColor 50,100,255
									Case "green","g"
										SetColor 50,255,50
									Case "white","w"
										SetColor 255,255,255
									Case "black"
										SetColor 0,0,0
									Case "orange","o"
										SetColor 255,100,0
									Case "yellow","y"
										SetColor 255,255,0
									Case "pink","p"
										SetColor 255,50,255
								End Select
								
								current_txt=""
							Default
								current_txt:+Mid(txt_ln,ii,1)
						End Select
					End If
				Next
				
				If draw_mode=0 Then
					Draw_Text current_txt, 170+dx,470 + 25*i
				End If
			Next
			
			If TControls.cont.key.hit Then
				Self.current_sub:+1
				
				If Self.current_sub > Self.current_dialogue.subs.length-1 Then
					Self.current_dialogue = Null
				End If
			End If
			
			
						
		ElseIf Self.current_sign_text <> Null And (MilliSecs() - Self.last_time_sign_text_activated) < 500 Then
			
			SetColor 255,255,255
			Draw_Image Self.signbox_image,50,450
			
			SetColor 255,255,255
			
			For Local i:Int = 0 To Self.current_sign_text.lines.length -1
				
				'Draw_Text LEVEL_VARIABLES.get_txt(Self.current_sign_text.lines[i]), 80,470 + 25*i
				
				Local txt_ln:String = LEVEL_VARIABLES.get_txt(Self.current_sign_text.lines[i])
				
				
				Local draw_mode:Int=0
				Local current_txt:String=""
				Local dx:Int = 0
				
				For Local ii:Int = 1 To Len(txt_ln)
					If draw_mode=0 Then
						Select Mid(txt_ln,ii,1)
							Case "@"
								draw_mode=1
								
								Draw_Text current_txt, 70+dx,460 + 25*i
								
								
								dx:+TextWidth(current_txt)
								current_txt=""
							Default
								current_txt:+Mid(txt_ln,ii,1)
						End Select
					Else
						Select Mid(txt_ln,ii,1)
							Case "@"
								draw_mode=0
								
								Select Lower(current_txt)
									Case "red","r"
										SetColor 255,50,50
									Case "blue","b"
										SetColor 50,100,255
									Case "green","g"
										SetColor 50,255,50
									Case "white","w"
										SetColor 255,255,255
									Case "black"
										SetColor 0,0,0
									Case "orange","o"
										SetColor 255,100,0
									Case "yellow","y"
										SetColor 255,255,0
									Case "pink","p"
										SetColor 255,50,255
								End Select
								
								current_txt=""
							Default
								current_txt:+Mid(txt_ln,ii,1)
						End Select
					End If
				Next
				
				If draw_mode=0 Then
					Draw_Text current_txt, 70+dx,460 + 25*i
				End If
			Next
			
		End If
		
	End Method
	
	
	Method add_object(o:TObject)'FINDS THE RIGHT CHUNK FOR AN OBJECT and stores it there
		If o.important = 1 Then
			Self.super_chunks[o.layer].add(o)
		Else
			
			Local x:Int = Float(o.x * Self.anz_chunks_x) / Float(Self.table_x * Self.image_side)
			Local y:Int = Float(o.y * Self.anz_chunks_y) / Float(Self.table_y * Self.image_side)
			
			If x < 0 Then x = 0
			If y < 0 Then y = 0
			
			If x > Self.anz_chunks_x-1 Then x = Self.anz_chunks_x-1
			If y > Self.anz_chunks_y-1 Then y = Self.anz_chunks_y-1
			
			Self.chunks[x,y,o.layer].add(o)
		End If
	End Method
	
	Method has_collision:Int(x:Int,y:Int)
		If x < 0 Then Return 0
		If y < 0 Then Return 0
		
		If x > Self.table_x-1 Then Return 0
		If y > Self.table_y-1 Then Return 0
		
		Return Self.table[x,y].collision
	End Method
	
	Function set_completed()
		GAME.world.act_level.level_completed = 1
		
		If GAME.world.act_level_number >= GAME.world.highest_level_completed Then GAME.world.highest_level_completed:+1
		
		Local world_map:TMap = New TMap
		
		world_map.Insert("highest_level_completed", String(GAME.world.highest_level_completed))
		DATA_FILE_HANDLER.save(world_map, "Worlds\" + GAME.world.name + "\world.ini")
		
	End Function
End Type

'########################################################################################
'###########################       ######################################################
'########################### BLOCK ######################################################
'###########################       ######################################################
'########################################################################################

Type TBlock
	Field collision:Int'0 = off, 1 = on
	
	Function Create:TBlock(collision:Int=0, fg:Int=0, ft:Int=-1, bg:Int=0, bt:Int=-1)
		Local b:TBlock = New TBlock
		
		b.collision = collision
		
		'foreground
		b.fg_image_number = fg
		b.fg_delta_t = ft
		
		If b.fg_image_number > GAME.world.block_image_manager.anz_images-1 Then
			GAME_ERROR_HANDLER.error("create:TBLOCK fg_image_number out of range!")
			Return Null
		End If
		
		b.fg_act_frame = 0
		b.fg_last_t = MilliSecs()
		
		'background
		b.bg_image_number = bg
		b.bg_delta_t = bt
		
		If b.bg_image_number > GAME.world.block_image_manager.anz_images-1 Then
			GAME_ERROR_HANDLER.error("create:TBLOCK bg_image_number out of range!")
			Return Null
		End If
		
		b.bg_act_frame = 0
		b.bg_last_t = MilliSecs()
		
		Return b
	End Function
	
	
	'FOREGROUND
	Field fg_image_number:Int
	Field fg_act_frame:Int
	Field fg_delta_t:Int
	Field fg_last_t:Int
	
	Method fg_draw(x:Float, y:Float, scale:Float = 1.0)
		
		If Self.fg_delta_t + Self.fg_last_t < MilliSecs() And Self.fg_delta_t > 0 Then
			Self.fg_last_t = MilliSecs()
			
			Self.fg_act_frame:+1
			If Self.fg_act_frame > GAME.world.block_image_manager.anz_frames[Self.fg_image_number]-1 Then
				Self.fg_act_frame = 0
			End If
		End If
		
		SetColor 255,255,255
		SetScale scale,scale
		Draw_Image GAME.world.block_image_manager.images[Self.fg_image_number], x, y, Self.fg_act_frame
		SetScale 1,1
	End Method
	
	'BACKGROUND
	Field bg_image_number:Int
	Field bg_act_frame:Int
	Field bg_delta_t:Int
	Field bg_last_t:Int
	
	Method bg_draw(x:Float, y:Float, scale:Float = 1.0)
		
		If Self.bg_delta_t + Self.bg_last_t < MilliSecs() And Self.bg_delta_t > 0 Then
			Self.bg_last_t = MilliSecs()
			
			Self.bg_act_frame:+1
			If Self.bg_act_frame > GAME.world.block_image_manager.anz_frames[Self.bg_image_number]-1 Then
				Self.bg_act_frame = 0
			End If
		End If
		
		SetColor 255,255,255
		SetScale scale,scale
		Draw_Image GAME.world.block_image_manager.images[Self.bg_image_number], x, y, Self.bg_act_frame
		SetScale 1,1
	End Method
End Type

'########################################################################################
'###########################        #####################################################
'########################### OBJECT #####################################################
'###########################        #####################################################
'########################################################################################

Rem

Collision boxes (destroyable? moving? movable? one sided?) also water, killzone, change song, movable block ...
ki (moving? attacking? collision?) [player, ennemies, bombs, ...]
action (portal, change mode, open dor, bomb, save point)
game controller (counter, timer) has no x,y

End Rem

Type TObject
	Global counter:Int = 0
	
	Method New()
		TObject.counter:+1
		Self.id = TObject.counter
	End Method
	
	Field id:Int
	
	Field x:Float
	Field y:Float
	Field layer:Int'0 = behind bg, 1 = just in front of bg, 2 = middle, 3 = just behind fg, 4 = in front of fg
	
	Field important:Int'0 = off, 1 = allways rendered and drawed -> super-chunk
	Field chunk_x:Int
	Field chunk_y:Int
	
	Field chunk:TCHUNK'current chunk in which the object is stored
	
	Field kill_me:Int = 0 '1 = kill it definately
	
	Method render()
		If Self.kill_me = 1 Then
			Self.kill()'kill definately !
			
			Return
		End If
		
		Self.update_chunk_location()
	End Method
	
	Method draw()
	End Method
	
	Method kill()'delete from memory
		Self.chunk.remove(Self)
	End Method
	
	Method update_chunk_location()'update to the right chunk
		If Not Self.chunk.is_inside(Self.x, Self.y) Then
			Self.kill()
			
			GAME.world.act_level.add_object(Self)
		End If
	End Method
	
	
	Method write_to_stream(stream:TStream)
		stream.WriteInt(0)'OBJECT = 0        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		stream.WriteInt(Self.important)
		
	End Method
	
	Function read_from_stream:TObject(stream:TStream)
		Local o:TObject = New TObject
		
		Try
			o.id = stream.ReadInt()
			o.x = stream.ReadFloat()
			o.y = stream.ReadFloat()
			o.layer = stream.ReadInt()
			o.important = stream.ReadInt()
			
		Catch error_txt:String
			GAME_ERROR_HANDLER.error("TObject -> read_from_stream: " + error_txt)
			Return Null
		End Try
		
		Return o
	End Function
	
	Method write_to_stream_running(stream:TStream)
		stream.WriteInt(0)'OBJECT = 0        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		stream.WriteInt(Self.important)
		
		stream.WriteInt(Self.kill_me)'NEW !
	End Method
	
	Function read_from_stream_running:TObject(stream:TStream, delta_t:Int)
		Local o:TObject = New TObject
		
		Try
			o.id = stream.ReadInt()
			o.x = stream.ReadFloat()
			o.y = stream.ReadFloat()
			o.layer = stream.ReadInt()
			o.important = stream.ReadInt()
			
			o.kill_me = stream.ReadInt()'NEW ! stream.WriteInt(Self.kill_me)'NEW !
			
		Catch error_txt:String
			GAME_ERROR_HANDLER.error("TObject -> read_from_stream: " + error_txt)
			Return Null
		End Try
		
		Return o
	End Function
	
End Type

'########################################################################################
'###########################        #####################################################
'###########################  BOX   #####################################################
'###########################        #####################################################
'########################################################################################

Type TBox Extends TObject
	Global typs:TBox_Typ[,]
	
	Global renderers:TBox_Renderer[]
	
	Field rotation:Int
	
	Function init_after_level()
		Local gfx_map:TMap = DATA_FILE_HANDLER.Load("Worlds\" + GAME.world.name + "\Objects\boxes\boxes.ini")
		
		If Not gfx_map Then
			GAME_ERROR_HANDLER.error("Box -> load -> ini -> map is not loaded! Worlds\" + GAME.world.name + "\Objects\boxes\boxes.ini")
			Return
		End If
		
		Local number_of_boxes:Int
		
		If gfx_map.contains("number_of_boxes") Then'number_of_boxes
			number_of_boxes = Int(String(gfx_map.ValueForKey("number_of_boxes")))
		Else
			GAME_ERROR_HANDLER.error("Box -> load -> ini -> number_of_boxes not found! Worlds\" + GAME.world.name + "\Objects\boxes\boxes.ini")
			Return
		End If
		
		TBox.typs = New TBox_Typ[number_of_boxes,4]
		
		For Local i:Int = 0 To number_of_boxes-1
			
			Local i_name:String
			
			If gfx_map.contains("box_" + i) Then'name of box
				i_name = String(gfx_map.ValueForKey("box_" + i))
			Else
				GAME_ERROR_HANDLER.error("Box -> load -> ini -> box_" + i + " Not found! Worlds\" + GAME.world.name + "\Objects\boxes\boxes.ini")
				Return
			End If
			
			TBox.typs[i,0] = TBox_Typ.Load(i_name)
			
			'load rest !
			
			For Local ii:Int = 1 To 3
				TBox.typs[i,ii] = TBox.typs[i,0].turn(ii)
			Next
		Next
	End Function
	
	Function init_before_level()
		TBox.renderers = New TBox_Renderer[22]
		
		TBox.renderers[0] = TBox_Renderer_Collision.Create()
		TBox.renderers[1] = TBox_Renderer_Set_Player_Mode.Create()
		TBox.renderers[2] = TBox_Renderer_Sign.Create()
		TBox.renderers[3] = TBox_Renderer_Liquid.Create()
		TBox.renderers[4] = TBox_Renderer_Teleporter.Create()
		TBox.renderers[5] = TBox_Renderer_TLamp.Create()
		TBox.renderers[6] = TBox_Renderer_Dialogue.Create()
		TBox.renderers[7] = TBox_Renderer_Image.Create()
		TBox.renderers[8] = TBox_Renderer_CheckPoint.Create()
		TBox.renderers[9] = TBox_Renderer_Collision_Mode_Sensitive.Create()
		TBox.renderers[10] = TBox_Renderer_Dialogue_Changer.Create()
		TBox.renderers[11] = TBox_Renderer_Death_Zone.Create()
		TBox.renderers[12] = TBox_Renderer_LevelCompleted.Create()
		TBox.renderers[13] = TBox_Renderer_FireSurprise.Create()
		TBox.renderers[14] = TBox_Renderer_Music.Create()
		TBox.renderers[15] = TBox_Renderer_MusicChanger.Create()
		TBox.renderers[16] = TBox_Renderer_Sound.Create()
		TBox.renderers[17] = TBox_Renderer_SoundRepeater.Create()
		TBox.renderers[18] = TBox_Renderer_LightHandler.Create()
		TBox.renderers[19] = TBox_Renderer_ParticleFire.Create()
		TBox.renderers[20] = TBox_Renderer_Sequence.Create()
		TBox.renderers[21] = TBox_Renderer_Jumper.Create()
	End Function
	
	Field typ:Int'TBox_Typ
	Field renderer:TBox_Renderer
	Field renderer_number:Int
	
	Field vdn:String' variable dependence name
	
	Method var_on:Int()
		
		If Self.vdn<>"" Or LEVEL_VARIABLES.map.ValueForKey(Lower(Self.vdn)) Then
			Return Int(String(LEVEL_VARIABLES.map.ValueForKey(Lower(Self.vdn))))
		Else
			Return 1
		End If
		
	End Method
	
	Method New()
		Self.layer = 3
		Self.important = 0
	End Method
	
	Method draw()
		If TBox_Renderer_CheckPoint(Self.renderer) Then Return
		If TBox_Renderer_LevelCompleted(Self.renderer) Then Return
		If TBox_Renderer_Liquid(Self.renderer) Then Return
		If TBox_Renderer_LightHandler(Self.renderer) Then Return
		If TBox_Renderer_TLamp(Self.renderer) Then Return
		If TBox_Renderer_Teleporter(Self.renderer) Then Return
		If TBox_Renderer_Music(Self.renderer) Then Return
		If TBox_Renderer_MusicChanger(Self.renderer) Then Return
		If TBox_Renderer_SoundRepeater(Self.renderer) Then Return
		If TBox_Renderer_Sequence(Self.renderer) Then Return
		
		If TBox_Renderer_Image(Self.renderer) And TBox_Renderer_Image(Self.renderer).as_light = 1 Then Return
		
		If Not Self.var_on() Then Return
		
		SetColor 255,255,255
		
		SetRotation Self.rotation*90
		
		If TBox_Renderer_Jumper(Self.renderer) Then
			
			Local dtime:Float = MilliSecs()-TBox_Renderer_Jumper(Self.renderer).last_jump
			Local frame:Int = dtime/TBox.typs[Self.typ,Self.rotation].speed+1
			
			If frame  > TBox.typs[Self.typ,Self.rotation].image.frames.length-1 Then
				frame = 0
				'TBox_Renderer_Jumper(Self.renderer).last_jump=0
			End If
			
			Draw_Image TBox.typs[Self.typ,Self.rotation].image, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, frame
		Else
			Draw_Image TBox.typs[Self.typ,Self.rotation].image, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox.typs[Self.typ,Self.rotation].current_frame
		End If
		
		SetRotation 0
	End Method
	
	Method render()
		Super.render()
		
		Self.render_mobs()
		
		'TBox_Renderer_TLamp.light_typ_image_list[0]
		
		If TBox_Renderer_TLamp(Self.renderer) And Self.var_on() Then
			
			If Not TBox_Renderer_TLamp(Self.renderer).light Then
				TBox_Renderer_TLamp(Self.renderer).light = TLight.Create(TBox_Renderer_TLamp.light_typ_image_list[TBox_Renderer_TLamp(Self.renderer).light_typ_number],0,0)
				
				If TBox_Renderer_TLamp(Self.renderer).light_typ_number = 3 Then
					TBox_Renderer_TLamp(Self.renderer).light.set_color(TBox_Renderer_TLamp(Self.renderer).brightness_r, TBox_Renderer_TLamp(Self.renderer).brightness_g, TBox_Renderer_TLamp(Self.renderer).brightness_b)
					
					TBox_Renderer_TLamp(Self.renderer).light.rot:* Rnd()
					TBox_Renderer_TLamp(Self.renderer).light.gruen:* Rnd()
					TBox_Renderer_TLamp(Self.renderer).light.blau:* Rnd()
				Else
					TBox_Renderer_TLamp(Self.renderer).light.set_color(TBox_Renderer_TLamp(Self.renderer).brightness_r, TBox_Renderer_TLamp(Self.renderer).brightness_g, TBox_Renderer_TLamp(Self.renderer).brightness_b)
				End If
			End If
			
			TBox_Renderer_TLamp(Self.renderer).light.w = Self.rotation*90
			
			TBox_Renderer_TLamp(Self.renderer).light.x = Self.x+TBox.typs[Self.typ,Self.rotation].image.width/2
			TBox_Renderer_TLamp(Self.renderer).light.y = Self.y+TBox.typs[Self.typ,Self.rotation].image.height/2
			TBox_Renderer_TLamp(Self.renderer).light.render()
			TBox_Renderer_TLamp(Self.renderer).light.draw_to_buffer()
		End If
		
		If TBox_Renderer_Image(Self.renderer) And TBox_Renderer_Image(Self.renderer).as_light = 1 And Self.var_on() Then
			If Not TBox_Renderer_Image(Self.renderer).light Then
				TBox_Renderer_Image(Self.renderer).light = TLight.Create(TBox.typs[Self.typ,Self.rotation].image,0,0)
				TBox_Renderer_Image(Self.renderer).light.set_color(255,255,255)
			End If
			
			TBox_Renderer_Image(Self.renderer).light.w = Self.rotation*90
			
			'TBox_Renderer_Image(Self.renderer).light.x = Self.x+TBox.typs[Self.typ,Self.rotation].image.width/2
			TBox_Renderer_Image(Self.renderer).light.x = Self.x+TBox.typs[Self.typ,Self.rotation].image_x1+TBox.typs[Self.typ,Self.rotation].dx/2
			TBox_Renderer_Image(Self.renderer).light.y = Self.y+TBox.typs[Self.typ,Self.rotation].image_y1+TBox.typs[Self.typ,Self.rotation].dy/2
			TBox_Renderer_Image(Self.renderer).light.render()
			TBox_Renderer_Image(Self.renderer).light.draw_to_buffer()
		End If
		
		TBox.typs[Self.typ,Self.rotation].render_animation()
	End Method
	
	Method render_mobs()
		If Not Self.var_on() Then Return
		
		
		Local c_x:Int = Int(Self.x/(Float(GAME.world.act_level.table_x * GAME.world.act_level.image_side) / Float(GAME.world.act_level.anz_chunks_x)))
		Local c_y:Int = Int(Self.y/(Float(GAME.world.act_level.table_y * GAME.world.act_level.image_side) / Float(GAME.world.act_level.anz_chunks_y)))
		
		Local x1:Int = c_x - 1
		If x1 < 0 Then x1 = 0
		Local x2:Int = c_x + 1
		If x2 > GAME.world.act_level.anz_chunks_x-1 Then x2 = GAME.world.act_level.anz_chunks_x-1
		Local y1:Int = c_y - 1
		If y1 < 0 Then y1 = 0
		Local y2:Int = c_y + 1
		If y2 > GAME.world.act_level.anz_chunks_y-1 Then y2 = GAME.world.act_level.anz_chunks_y-1
		
		For Local x:Int = x1 To x2
			For Local y:Int = y1 To y2
				For Local layer:Int = 0 To 4
					For Local m:TMob = EachIn GAME.world.act_level.chunks[x,y,layer].list
						Self.renderer.render(Self, m)
					Next
				Next
			Next
		Next
		
		For Local layer:Int = 0 To 4
			For Local m:TMob = EachIn GAME.world.act_level.super_chunks[layer].list
				Self.renderer.render(Self, m)
			Next
		Next
	End Method
	
	
	Method mob_middle_is_inside:Int(m:TMob)
		
		If (Self.x) =< (m.x + m.vx) And (Self.y) =< (m.y + m.vy) And (Self.x + TBox.typs[Self.typ,Self.rotation].dx) > (m.x + m.vx) And (Self.y + TBox.typs[Self.typ,Self.rotation].dy) > (m.y + m.vy) Then
			Return 1
		Else
			Return 0
		End If
		
	End Method
	
	
	Method mob_is_inside:Int(m:TMob)
		
		If (Self.x - m.rx) =< (m.x + m.vx) And (Self.y - m.ry) =< (m.y + m.vy) And (Self.x + TBox.typs[Self.typ,Self.rotation].dx + m.rx) > (m.x + m.vx) And (Self.y + TBox.typs[Self.typ,Self.rotation].dy + m.ry) > (m.y + m.vy) Then
			Return 1
		Else
			Return 0
		End If
		
	End Method
	
	Method mob_enters:Int(m:TMob)'return which side, if not return 0
		
		'------------- R 1
		If Self.x >= (m.x + m.rx) And Self.x < (m.x + m.rx + m.vx) Then
			If Self.y < (m.y + m.ry + m.vy) And (Self.y + TBox.typs[Self.typ,Self.rotation].dy) > (m.y - m.ry + m.vy) Then
				Return 1
			End If
		End If
		
		'------------- L 2
		If (Self.x + TBox.typs[Self.typ,Self.rotation].dx) <= (m.x - m.rx) And (Self.x + TBox.typs[Self.typ,Self.rotation].dx) > (m.x - m.rx + m.vx) Then
			If Self.y < (m.y + m.ry + m.vy) And (Self.y + TBox.typs[Self.typ,Self.rotation].dy) > (m.y - m.ry + m.vy) Then
				Return 2
			End If
		End If
		
		'------------- TOP 3
		If Self.y >= (m.y + m.ry) And Self.y < (m.y + m.ry + m.vy) Then
			If Self.x < (m.x + m.rx + m.vx) And (Self.x + TBox.typs[Self.typ,Self.rotation].dx) > (m.x - m.rx + m.vx) Then
				Return 3
			End If
		End If
		
		'------------- BOTTOM 4
		If (Self.y + TBox.typs[Self.typ,Self.rotation].dy) <= (m.y - m.ry) And (Self.y + TBox.typs[Self.typ,Self.rotation].dy) > (m.y - m.ry + m.vy) Then
			If Self.x < (m.x + m.rx + m.vx) And (Self.x + TBox.typs[Self.typ,Self.rotation].dx) > (m.x - m.rx + m.vx) Then
				Return 4
			End If
		End If
		
		Return 0
	End Method
	
	Method write_to_stream(stream:TStream)
		stream.WriteInt(2)'TBox = 2        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		
		stream.WriteInt(2222)'just to save my ass...
		stream.WriteInt(Self.rotation)
		stream.WriteInt(Len(Self.vdn))
		stream.WriteString(Self.vdn)
		
		stream.WriteInt(Self.important)
		
		stream.WriteInt(Self.typ)
		
		stream.WriteInt(Self.renderer_number)
		
		Select Self.renderer_number
			Case 0'collision
				stream.WriteInt(TBox_Renderer_Collision(Self.renderer).coll_down_on)
				stream.WriteInt(TBox_Renderer_Collision(Self.renderer).coll_up_on)
				stream.WriteInt(TBox_Renderer_Collision(Self.renderer).coll_r_on)
				stream.WriteInt(TBox_Renderer_Collision(Self.renderer).coll_l_on)
			Case 1'set_player_mode
				stream.WriteInt(TBox_Renderer_Set_Player_Mode(Self.renderer).mode_number)
			Case 2'sign
				stream.WriteInt(Len(TBox_Renderer_Sign(Self.renderer).sign_text_name))
				stream.WriteString(TBox_Renderer_Sign(Self.renderer).sign_text_name)
			Case 3'liquid
				stream.WriteInt(TBox_Renderer_Liquid(Self.renderer).liquid_number)
			Case 4'teleporter
				stream.WriteInt(Len(TBox_Renderer_Teleporter(Self.renderer).teleporter_name))
				stream.WriteString(TBox_Renderer_Teleporter(Self.renderer).teleporter_name)
				
				stream.WriteInt(Len(TBox_Renderer_Teleporter(Self.renderer).location_name))
				stream.WriteString(TBox_Renderer_Teleporter(Self.renderer).location_name)
				
				stream.WriteInt(TBox_Renderer_Teleporter(Self.renderer).player_only)
				
				stream.WriteInt(TBox_Renderer_Teleporter(Self.renderer).typ)
				
			Case 5'lamp
				stream.WriteInt(TBox_Renderer_TLamp(Self.renderer).light_typ_number)
				stream.WriteInt(TBox_Renderer_TLamp(Self.renderer).brightness_r)
				stream.WriteInt(TBox_Renderer_TLamp(Self.renderer).brightness_g)
				stream.WriteInt(TBox_Renderer_TLamp(Self.renderer).brightness_b)
				
			Case 6'dialogue
				stream.WriteInt(Len(TBox_Renderer_Dialogue(Self.renderer).dialogue_name))
				stream.WriteString(TBox_Renderer_Dialogue(Self.renderer).dialogue_name)
				
				stream.WriteInt(Len(TBox_Renderer_Dialogue(Self.renderer).dialogue_id))
				stream.WriteString(TBox_Renderer_Dialogue(Self.renderer).dialogue_id)
			Case 7'image
				stream.WriteInt(TBox_Renderer_Image(Self.renderer).as_light)
			Case 8'checkpoint
				
			Case 9'collision_mode_sensitive
				stream.WriteInt(TBox_Renderer_Collision_Mode_Sensitive(Self.renderer).coll_down_on)
				stream.WriteInt(TBox_Renderer_Collision_Mode_Sensitive(Self.renderer).coll_up_on)
				stream.WriteInt(TBox_Renderer_Collision_Mode_Sensitive(Self.renderer).coll_r_on)
				stream.WriteInt(TBox_Renderer_Collision_Mode_Sensitive(Self.renderer).coll_l_on)
				
				stream.WriteInt(TBox_Renderer_Collision_Mode_Sensitive(Self.renderer).mode_number)
				stream.WriteInt(TBox_Renderer_Collision_Mode_Sensitive(Self.renderer).invert)
			Case 10'dialogue_changer
				stream.WriteInt(Len(TBox_Renderer_Dialogue_Changer(Self.renderer).dialogue_name))
				stream.WriteString(TBox_Renderer_Dialogue_Changer(Self.renderer).dialogue_name)
				
				stream.WriteInt(Len(TBox_Renderer_Dialogue_Changer(Self.renderer).dialogue_id))
				stream.WriteString(TBox_Renderer_Dialogue_Changer(Self.renderer).dialogue_id)
			Case 11'death_zone
				stream.WriteInt(TBox_Renderer_Death_Zone(Self.renderer).death_number)
			Case 12'LevelCompleted
				
			Case 13'FireSurprise
				
			Case 14'TBox_Renderer_Music
				stream.WriteInt(Len(TBox_Renderer_Music(Self.renderer).music_name))
				stream.WriteString(TBox_Renderer_Music(Self.renderer).music_name)
			Case 15'MusicChanger
				stream.WriteInt(Len(TBox_Renderer_MusicChanger(Self.renderer).music_name))
				stream.WriteString(TBox_Renderer_MusicChanger(Self.renderer).music_name)
			Case 16'Sound
				stream.WriteInt(Len(TBox_Renderer_Sound(Self.renderer).music_name))
				stream.WriteString(TBox_Renderer_Sound(Self.renderer).music_name)
			Case 17'SoundRepeater
				stream.WriteInt(Len(TBox_Renderer_SoundRepeater(Self.renderer).music_name))
				stream.WriteString(TBox_Renderer_SoundRepeater(Self.renderer).music_name)
				
				stream.WriteInt(TBox_Renderer_SoundRepeater(Self.renderer).delta_t)
				stream.WriteInt(TBox_Renderer_SoundRepeater(Self.renderer).delta_rand)
				stream.WriteInt(TBox_Renderer_SoundRepeater(Self.renderer).radius)
			Case 18'LightHandler
				
				stream.WriteInt(TBox_Renderer_LightHandler(Self.renderer).brightness_r)
				stream.WriteInt(TBox_Renderer_LightHandler(Self.renderer).brightness_g)
				stream.WriteInt(TBox_Renderer_LightHandler(Self.renderer).brightness_b)
				stream.WriteInt(TBox_Renderer_LightHandler(Self.renderer).init_run)
			Case 19'particle fire
			Case 20'TBox_Renderer_Sequence
				stream.WriteInt(Len(TBox_Renderer_Sequence(Self.renderer).script_name))
				stream.WriteString(TBox_Renderer_Sequence(Self.renderer).script_name)
				
				stream.WriteInt(TBox_Renderer_Sequence(Self.renderer).run_init)
			Case 21'TBox_Renderer_Jumper
				stream.WriteFloat(TBox_Renderer_Jumper(Self.renderer).angle)
				
				stream.WriteFloat(TBox_Renderer_Jumper(Self.renderer).power)
		End Select
	End Method
	
	Function read_from_stream:TBox(stream:TStream)
		Local o:TBox = New TBox
		
		o.id = stream.ReadInt()
		o.x = stream.ReadFloat()
		o.y = stream.ReadFloat()
		o.layer = stream.ReadInt()
		
		'stream.WriteInt(1111)
		'If VERSION_COMPATIBILITY > 3 Then stream.WriteInt(Self.rotation)
		Local value:Int = stream.ReadInt()
		
		If value = 1111 Then
			o.rotation = stream.ReadInt()
			o.important = stream.ReadInt()
		Else If value = 2222
			o.rotation = stream.ReadInt()
			
			Local ll:Int = stream.ReadInt()
			o.vdn = stream.ReadString(ll)
			
			o.important = stream.ReadInt()
		Else
			o.important = value
		End If
		
		o.typ = stream.ReadInt()
		o.renderer_number = stream.ReadInt()
		
		o.renderer = TBox.renderers[o.renderer_number].copy()
		
		Select o.renderer_number
			Case 0'collision
				TBox_Renderer_Collision(o.renderer).coll_down_on = stream.ReadInt()
				TBox_Renderer_Collision(o.renderer).coll_up_on = stream.ReadInt()
				TBox_Renderer_Collision(o.renderer).coll_r_on = stream.ReadInt()
				TBox_Renderer_Collision(o.renderer).coll_l_on = stream.ReadInt()
			Case 1'set_player_mode
				TBox_Renderer_Set_Player_Mode(o.renderer).mode_number = stream.ReadInt()
			Case 2'sign
				Local l:Int = stream.ReadInt()
				TBox_Renderer_Sign(o.renderer).sign_text_name = stream.ReadString(l)
			Case 3'liquid
				TBox_Renderer_Liquid(o.renderer).liquid_number = stream.ReadInt()
			Case 4'teleporter
				
				Local l2:Int = stream.ReadInt()
				TBox_Renderer_Teleporter(o.renderer).teleporter_name = stream.ReadString(l2)
				
				Local l:Int = stream.ReadInt()
				TBox_Renderer_Teleporter(o.renderer).location_name = stream.ReadString(l)
				
				
				TBox_Renderer_Teleporter(o.renderer).player_only = stream.ReadInt()
				
				TBox_Renderer_Teleporter(o.renderer).typ = stream.ReadInt()
				
			Case 5'lamp
				TBox_Renderer_TLamp(o.renderer).light_typ_number = stream.ReadInt()
				TBox_Renderer_TLamp(o.renderer).brightness_r = stream.ReadInt()
				TBox_Renderer_TLamp(o.renderer).brightness_g = stream.ReadInt()
				TBox_Renderer_TLamp(o.renderer).brightness_b = stream.ReadInt()
				
			Case 6'dialogue
				Local l:Int = stream.ReadInt()
				TBox_Renderer_Dialogue(o.renderer).dialogue_name = stream.ReadString(l)
				
				Local l2:Int = stream.ReadInt()
				TBox_Renderer_Dialogue(o.renderer).dialogue_id = stream.ReadString(l2)
			Case 7'image
				TBox_Renderer_Image(o.renderer).as_light = stream.ReadInt()
			Case 8'checkpoint
				
			Case 9'collision_mode_sensitive
				TBox_Renderer_Collision_Mode_Sensitive(o.renderer).coll_down_on = stream.ReadInt()
				TBox_Renderer_Collision_Mode_Sensitive(o.renderer).coll_up_on = stream.ReadInt()
				TBox_Renderer_Collision_Mode_Sensitive(o.renderer).coll_r_on = stream.ReadInt()
				TBox_Renderer_Collision_Mode_Sensitive(o.renderer).coll_l_on = stream.ReadInt()
				
				TBox_Renderer_Collision_Mode_Sensitive(o.renderer).mode_number = stream.ReadInt()
				TBox_Renderer_Collision_Mode_Sensitive(o.renderer).invert = stream.ReadInt()
			Case 10'dialogue_changer
				Local l:Int = stream.ReadInt()
				TBox_Renderer_Dialogue_Changer(o.renderer).dialogue_name = stream.ReadString(l)
				
				Local l2:Int = stream.ReadInt()
				TBox_Renderer_Dialogue_Changer(o.renderer).dialogue_id = stream.ReadString(l2)
			Case 11'death_zone
				TBox_Renderer_Death_Zone(o.renderer).death_number = stream.ReadInt()
			Case 12'LevelCompleted
				
			Case 13'FireSurprise
				
			Case 14'TBox_Renderer_Music
				
				Local l:Int = stream.ReadInt()
				TBox_Renderer_Music(o.renderer).music_name = stream.ReadString(l)
			Case 15'MusicChanger
				Local l:Int = stream.ReadInt()
				TBox_Renderer_MusicChanger(o.renderer).music_name = stream.ReadString(l)
			Case 16'Sound
				Local l:Int = stream.ReadInt()
				TBox_Renderer_Sound(o.renderer).music_name = stream.ReadString(l)
			Case 17'SoundRepeater
				Local l:Int = stream.ReadInt()
				TBox_Renderer_SoundRepeater(o.renderer).music_name = stream.ReadString(l)
				
				TBox_Renderer_SoundRepeater(o.renderer).delta_t = stream.ReadInt()
				TBox_Renderer_SoundRepeater(o.renderer).delta_rand = stream.ReadInt()
				TBox_Renderer_SoundRepeater(o.renderer).radius = stream.ReadInt()
			Case 18'LightHandler
				
				TBox_Renderer_LightHandler(o.renderer).brightness_r = stream.ReadInt()
				TBox_Renderer_LightHandler(o.renderer).brightness_g = stream.ReadInt()
				TBox_Renderer_LightHandler(o.renderer).brightness_b = stream.ReadInt()
				TBox_Renderer_LightHandler(o.renderer).init_run = stream.ReadInt()
			Case 19'particle fire
			Case 20'TBox_Renderer_Sequence
				Local l:Int = stream.ReadInt()
				TBox_Renderer_Sequence(o.renderer).script_name = stream.ReadString(l)
				
				TBox_Renderer_Sequence(o.renderer).run_init = stream.ReadInt()
			Case 21'TBox_Renderer_Jumper
				TBox_Renderer_Jumper(o.renderer).angle = stream.ReadFloat()
				TBox_Renderer_Jumper(o.renderer).power= stream.ReadFloat()
		End Select
		
		Return o
	End Function
	
	
	Method write_to_stream_running(stream:TStream)
		stream.WriteInt(2)'TBox = 2        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		
		stream.WriteInt(Self.rotation)
		stream.WriteInt(Len(Self.vdn))
		stream.WriteString(Self.vdn)
		
		stream.WriteInt(Self.important)
		
		stream.WriteInt(Self.kill_me)'NEW !
		
		stream.WriteInt(Self.typ)
		
		stream.WriteInt(Self.renderer_number)
		
		Select Self.renderer_number
			Case 0'collision
				stream.WriteInt(TBox_Renderer_Collision(Self.renderer).coll_down_on)'ok
				stream.WriteInt(TBox_Renderer_Collision(Self.renderer).coll_up_on)
				stream.WriteInt(TBox_Renderer_Collision(Self.renderer).coll_r_on)
				stream.WriteInt(TBox_Renderer_Collision(Self.renderer).coll_l_on)
			Case 1'set_player_mode
				stream.WriteInt(TBox_Renderer_Set_Player_Mode(Self.renderer).mode_number)'ok
			Case 2'sign
				stream.WriteInt(Len(TBox_Renderer_Sign(Self.renderer).sign_text_name))'ok
				stream.WriteString(TBox_Renderer_Sign(Self.renderer).sign_text_name)
			Case 3'liquid
				stream.WriteInt(TBox_Renderer_Liquid(Self.renderer).liquid_number)'ok
			Case 4'teleporter
				stream.WriteInt(Len(TBox_Renderer_Teleporter(Self.renderer).teleporter_name))'ok
				stream.WriteString(TBox_Renderer_Teleporter(Self.renderer).teleporter_name)
				
				stream.WriteInt(Len(TBox_Renderer_Teleporter(Self.renderer).location_name))
				stream.WriteString(TBox_Renderer_Teleporter(Self.renderer).location_name)
				
				stream.WriteInt(TBox_Renderer_Teleporter(Self.renderer).player_only)
				
				stream.WriteInt(TBox_Renderer_Teleporter(Self.renderer).typ)
			Case 5'lamp
				stream.WriteInt(TBox_Renderer_TLamp(Self.renderer).light_typ_number)'ok
				stream.WriteInt(TBox_Renderer_TLamp(Self.renderer).brightness_r)
				stream.WriteInt(TBox_Renderer_TLamp(Self.renderer).brightness_g)
				stream.WriteInt(TBox_Renderer_TLamp(Self.renderer).brightness_b)
			Case 6'dialogue
				stream.WriteInt(Len(TBox_Renderer_Dialogue(Self.renderer).dialogue_name))
				stream.WriteString(TBox_Renderer_Dialogue(Self.renderer).dialogue_name)
				
				stream.WriteInt(Len(TBox_Renderer_Dialogue(Self.renderer).dialogue_id))
				stream.WriteString(TBox_Renderer_Dialogue(Self.renderer).dialogue_id)
				
				stream.WriteInt(TBox_Renderer_Dialogue(Self.renderer).last_time_inside)'new !!!
			Case 7'image
				stream.WriteInt(TBox_Renderer_Image(Self.renderer).as_light)
			Case 8'checkpoint
				
			Case 9'collision_mode_sensitive
				stream.WriteInt(TBox_Renderer_Collision_Mode_Sensitive(Self.renderer).coll_down_on)
				stream.WriteInt(TBox_Renderer_Collision_Mode_Sensitive(Self.renderer).coll_up_on)
				stream.WriteInt(TBox_Renderer_Collision_Mode_Sensitive(Self.renderer).coll_r_on)
				stream.WriteInt(TBox_Renderer_Collision_Mode_Sensitive(Self.renderer).coll_l_on)
				
				stream.WriteInt(TBox_Renderer_Collision_Mode_Sensitive(Self.renderer).mode_number)
				stream.WriteInt(TBox_Renderer_Collision_Mode_Sensitive(Self.renderer).invert)
			Case 10'Dialogue_Changer
				stream.WriteInt(Len(TBox_Renderer_Dialogue_Changer(Self.renderer).dialogue_name))
				stream.WriteString(TBox_Renderer_Dialogue_Changer(Self.renderer).dialogue_name)
				
				stream.WriteInt(Len(TBox_Renderer_Dialogue_Changer(Self.renderer).dialogue_id))
				stream.WriteString(TBox_Renderer_Dialogue_Changer(Self.renderer).dialogue_id)
			Case 11'death_zone
				stream.WriteInt(TBox_Renderer_Death_Zone(Self.renderer).death_number)
			Case 12'LevelCompleted
				
			Case 13'FireSurprise
				
			Case 14'TBox_Renderer_Music
				stream.WriteInt(Len(TBox_Renderer_Music(Self.renderer).music_name))
				stream.WriteString(TBox_Renderer_Music(Self.renderer).music_name)
			Case 15'MusicChanger
				stream.WriteInt(Len(TBox_Renderer_MusicChanger(Self.renderer).music_name))
				stream.WriteString(TBox_Renderer_MusicChanger(Self.renderer).music_name)
			Case 16'Sound
				stream.WriteInt(Len(TBox_Renderer_Sound(Self.renderer).music_name))
				stream.WriteString(TBox_Renderer_Sound(Self.renderer).music_name)
			Case 17'SoundRepeater
				stream.WriteInt(Len(TBox_Renderer_SoundRepeater(Self.renderer).music_name))
				stream.WriteString(TBox_Renderer_SoundRepeater(Self.renderer).music_name)
				
				stream.WriteInt(TBox_Renderer_SoundRepeater(Self.renderer).delta_t)
				stream.WriteInt(TBox_Renderer_SoundRepeater(Self.renderer).delta_rand)
				stream.WriteInt(TBox_Renderer_SoundRepeater(Self.renderer).radius)
			Case 18'LightHandler
				
				stream.WriteInt(TBox_Renderer_LightHandler(Self.renderer).brightness_r)
				stream.WriteInt(TBox_Renderer_LightHandler(Self.renderer).brightness_g)
				stream.WriteInt(TBox_Renderer_LightHandler(Self.renderer).brightness_b)
				stream.WriteInt(TBox_Renderer_LightHandler(Self.renderer).init_run)
			Case 19'particle fire
			Case 20'TBox_Renderer_Sequence
				stream.WriteInt(Len(TBox_Renderer_Sequence(Self.renderer).script_name))
				stream.WriteString(TBox_Renderer_Sequence(Self.renderer).script_name)
				
				stream.WriteInt(TBox_Renderer_Sequence(Self.renderer).run_init)
				
				'seq
				
				Local seq:Sequence = TBox_Renderer_Sequence(Self.renderer).seq
				
				If seq Then
					stream.WriteInt(1)
					
					stream.WriteInt(Len(seq.name))
					stream.WriteString(seq.name)
					stream.WriteInt(seq.cl)
				Else
					stream.WriteInt(0)
				End If
			Case 21'TBox_Renderer_Jumper
				stream.WriteFloat(TBox_Renderer_Jumper(Self.renderer).angle)
				
				stream.WriteFloat(TBox_Renderer_Jumper(Self.renderer).power)
		End Select
	End Method
	
	Function read_from_stream_running:TBox(stream:TStream, delta_t:Int)
		Local o:TBox = New TBox
		
		o.id = stream.ReadInt()
		o.x = stream.ReadFloat()
		o.y = stream.ReadFloat()
		o.layer = stream.ReadInt()
		
		o.rotation = stream.ReadInt()
		
		Local ll:Int = stream.ReadInt()
		o.vdn = stream.ReadString(ll)
		
		o.important = stream.ReadInt()
		
		o.kill_me = stream.ReadInt()'NEW !
		
		o.typ = stream.ReadInt()
		o.renderer_number = stream.ReadInt()
		
		o.renderer = TBox.renderers[o.renderer_number].copy()
		
		Select o.renderer_number
			Case 0'collision
				TBox_Renderer_Collision(o.renderer).coll_down_on = stream.ReadInt()'ok
				TBox_Renderer_Collision(o.renderer).coll_up_on = stream.ReadInt()
				TBox_Renderer_Collision(o.renderer).coll_r_on = stream.ReadInt()
				TBox_Renderer_Collision(o.renderer).coll_l_on = stream.ReadInt()
			Case 1'set_player_mode
				TBox_Renderer_Set_Player_Mode(o.renderer).mode_number = stream.ReadInt()'ok
			Case 2'sign
				Local l:Int = stream.ReadInt()
				TBox_Renderer_Sign(o.renderer).sign_text_name = stream.ReadString(l)'ok
			Case 3'liquid
				TBox_Renderer_Liquid(o.renderer).liquid_number = stream.ReadInt()'ok
			Case 4'teleporter
				Local l2:Int = stream.ReadInt()
				TBox_Renderer_Teleporter(o.renderer).teleporter_name = stream.ReadString(l2)
				
				Local l:Int = stream.ReadInt()
				TBox_Renderer_Teleporter(o.renderer).location_name = stream.ReadString(l)
				
				TBox_Renderer_Teleporter(o.renderer).player_only = stream.ReadInt()
				
				TBox_Renderer_Teleporter(o.renderer).typ = stream.ReadInt()
			Case 5'lamp
				TBox_Renderer_TLamp(o.renderer).light_typ_number = stream.ReadInt()
				TBox_Renderer_TLamp(o.renderer).brightness_r = stream.ReadInt()
				TBox_Renderer_TLamp(o.renderer).brightness_g = stream.ReadInt()
				TBox_Renderer_TLamp(o.renderer).brightness_b = stream.ReadInt()
			Case 6'dialogue
				Local l:Int = stream.ReadInt()
				TBox_Renderer_Dialogue(o.renderer).dialogue_name = stream.ReadString(l)
				
				Local l2:Int = stream.ReadInt()
				TBox_Renderer_Dialogue(o.renderer).dialogue_id = stream.ReadString(l2)
				
				TBox_Renderer_Dialogue(o.renderer).last_time_inside = stream.ReadInt() + delta_t'new !!!
			Case 7'image
				TBox_Renderer_Image(o.renderer).as_light = stream.ReadInt()
			Case 8'checkpoint
				
			Case 9'collision_mode_sensitive
				TBox_Renderer_Collision_Mode_Sensitive(o.renderer).coll_down_on = stream.ReadInt()
				TBox_Renderer_Collision_Mode_Sensitive(o.renderer).coll_up_on = stream.ReadInt()
				TBox_Renderer_Collision_Mode_Sensitive(o.renderer).coll_r_on = stream.ReadInt()
				TBox_Renderer_Collision_Mode_Sensitive(o.renderer).coll_l_on = stream.ReadInt()
				
				TBox_Renderer_Collision_Mode_Sensitive(o.renderer).mode_number = stream.ReadInt()
				TBox_Renderer_Collision_Mode_Sensitive(o.renderer).invert = stream.ReadInt()
			Case 10'Dialogue_Changer
				Local l:Int = stream.ReadInt()
				TBox_Renderer_Dialogue_Changer(o.renderer).dialogue_name = stream.ReadString(l)
				
				Local l2:Int = stream.ReadInt()
				TBox_Renderer_Dialogue_Changer(o.renderer).dialogue_id = stream.ReadString(l2)
			Case 11'death_zone
				TBox_Renderer_Death_Zone(o.renderer).death_number = stream.ReadInt()
			Case 12'LevelCompleted
				
			Case 13'FireSurprise
				
			Case 14'TBox_Renderer_Music
				
				Local l:Int = stream.ReadInt()
				TBox_Renderer_Music(o.renderer).music_name = stream.ReadString(l)
			Case 15'MusicChanger
				Local l:Int = stream.ReadInt()
				TBox_Renderer_MusicChanger(o.renderer).music_name = stream.ReadString(l)
			Case 16'Sound
				Local l:Int = stream.ReadInt()
				TBox_Renderer_Sound(o.renderer).music_name = stream.ReadString(l)
			Case 17'SoundRepeater
				Local l:Int = stream.ReadInt()
				TBox_Renderer_SoundRepeater(o.renderer).music_name = stream.ReadString(l)
				
				TBox_Renderer_SoundRepeater(o.renderer).delta_t = stream.ReadInt()
				TBox_Renderer_SoundRepeater(o.renderer).delta_rand = stream.ReadInt()
				TBox_Renderer_SoundRepeater(o.renderer).radius = stream.ReadInt()
			Case 18'LightHandler
				
				TBox_Renderer_LightHandler(o.renderer).brightness_r = stream.ReadInt()
				TBox_Renderer_LightHandler(o.renderer).brightness_g = stream.ReadInt()
				TBox_Renderer_LightHandler(o.renderer).brightness_b = stream.ReadInt()
				TBox_Renderer_LightHandler(o.renderer).init_run = stream.ReadInt()
			Case 19'particle fire
			Case 20'TBox_Renderer_Sequence
				Local l:Int = stream.ReadInt()
				TBox_Renderer_Sequence(o.renderer).script_name = stream.ReadString(l)
				
				TBox_Renderer_Sequence(o.renderer).run_init = stream.ReadInt()
				
				'seq
				
				If stream.ReadInt()=1 Then
					Local l2:Int = stream.ReadInt()
					Local seq_name:String = stream.ReadString(l2)
					Local se1_cl:Int = stream.ReadInt()
					
					TBox_Renderer_Sequence(o.renderer).seq = Sequence.Create(seq_name)
					TBox_Renderer_Sequence(o.renderer).seq.cl = se1_cl
				End If
			Case 21'TBox_Renderer_Jumper
				TBox_Renderer_Jumper(o.renderer).angle = stream.ReadFloat()
				TBox_Renderer_Jumper(o.renderer).power= stream.ReadFloat()
		End Select
		
		Return o
	End Function
End Type


'########################################################################################
'###########################              ###############################################
'########################### BOX Burnable ###############################################
'###########################              ###############################################
'########################################################################################

Type TBox_Burnable Extends TBox
	Global burnable_typs:TBox_Burnable_Typ[,]
	
	Global burnable_renderer:TBox_Renderer
	
	Global burning_hot_time:Int = 400
	Field burning_hot:Int = 0
	
	Function init_after_level()
		Local gfx_map:TMap = DATA_FILE_HANDLER.Load("Worlds\" + GAME.world.name + "\Objects\burnable_box\boxes.ini")
		
		If Not gfx_map Then
			GAME_ERROR_HANDLER.error("burnable_box -> load -> ini -> map is not loaded! Worlds\" + GAME.world.name + "\Objects\burnable_box\boxes.ini")
			Return
		End If
		
		Local number_of_boxes:Int
		
		If gfx_map.contains("number_of_boxes") Then'number_of_boxes
			number_of_boxes = Int(String(gfx_map.ValueForKey("number_of_boxes")))
		Else
			GAME_ERROR_HANDLER.error("burnable_box -> load -> ini -> number_of_boxes not found! Worlds\" + GAME.world.name + "\Objects\burnable_box\boxes.ini")
			Return
		End If
		
		TBox_Burnable.burnable_typs = New TBox_Burnable_Typ[number_of_boxes,4]
		
		For Local i:Int = 0 To number_of_boxes-1
			
			Local i_name:String
			
			If gfx_map.contains("box_" + i) Then'name of box
				i_name = String(gfx_map.ValueForKey("box_" + i))
			Else
				GAME_ERROR_HANDLER.error("burnable_box -> load -> ini -> box_" + i + " Not found! Worlds\" + GAME.world.name + "\Objects\burnable_box\boxes.ini")
				Return
			End If
			
			TBox_Burnable.burnable_typs[i,0] = TBox_Burnable_Typ.Load(i_name)
			
			'load rest !
			
			For Local ii:Int = 1 To 3
				TBox_Burnable.burnable_typs[i,ii] = TBox_Burnable.burnable_typs[i,0].turn(ii)
			Next
			
		Next
	End Function
	
	Function init_before_level()
		TBox_Burnable.burnable_renderer = TBox_Renderer_Burnable.Create()
	End Function
	
	Field burning:Int = -1'if bigger then burning
	Field last_burning_frame_time:Int
	
	Method set_fire()
		If Self.burning = -1 Then
			Self.burning = 0
			Self.last_burning_frame_time = MilliSecs()
		End If
	End Method
	
	Method New()
		Self.layer = 3
		Self.important = 0
	End Method
	
	Method draw()
		SetColor 255,255,255
		
		SetRotation Self.rotation*90
		
		If Self.burning > -1 Then
			Draw_Image TBox_Burnable.burnable_typs[Self.typ,Self.rotation].image_burnable, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, Self.burning
		Else
			Draw_Image TBox_Burnable.burnable_typs[Self.typ,Self.rotation].image, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Burnable.burnable_typs[Self.typ,Self.rotation].current_frame
		End If
		
		SetRotation 0
	End Method
	
	Method render()
		Super.render()
		
		'Self.render_mobs()
		
		TBox_Burnable.burnable_typs[Self.typ,Self.rotation].render_animation()
		
		If Self.burning > -1 Then
			
			If Rand(1,60)=1 Then
				Select Rand(0,10)
					Case 0
						'Sound_Handler.play_2d("fr",Self.x,Self.y,1000)
						TSoundPlayer.run("fr",Self.x,Self.y,Self,1000)
					Default
						'Sound_Handler.play_2d("knack"+Rand(1,5),Self.x,Self.y,1000)
						TSoundPlayer.run("knack"+Rand(1,5),Self.x,Self.y,Self,1000)
				End Select
			End If
			
			
			If (MilliSecs()-Self.last_burning_frame_time+Self.burning*TBox_Burnable.burnable_typs[Self.typ,Self.rotation].speed_burning) > TBox_Burnable.burning_hot_time Then
				
				If Self.burning_hot = 0 Then
					GAME.world.act_level.set_fire_to_burnable_boxes(Self, 100)
				End If
				
				Self.burning_hot = 1
			End If
			
			If Self.last_burning_frame_time + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].speed_burning < MilliSecs() Then
				Self.last_burning_frame_time:+ TBox_Burnable.burnable_typs[Self.typ,Self.rotation].speed_burning
				Self.burning:+1
				If TBox_Burnable.burnable_typs[Self.typ,Self.rotation].image_burnable.frames.length-1 < Self.burning Then
					Self.burning = TBox_Burnable.burnable_typs[Self.typ,Self.rotation].image_burnable.frames.length-1
					
					Self.kill()
				End If
			End If
			
		End If
	End Method
	
	
	Method mob_is_inside:Int(m:TMob)
		
		If (Self.x - m.rx) =< m.x And (Self.y - m.ry) =< m.y And (Self.x + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dx + m.rx) > m.x And (Self.y + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dy + m.ry) > m.y Then
			Return 1
		Else
			Return 0
		End If
		
	End Method
	
	Method mob_enters:Int(m:TMob)'return which side, if not return 0
		
		'------------- R 1
		If Self.x >= (m.x + m.rx) And Self.x < (m.x + m.rx + m.vx) Then
			If Self.y < (m.y + m.ry + m.vy) And (Self.y + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dy) > (m.y - m.ry + m.vy) Then
				Return 1
			End If
		End If
		
		'------------- L 2
		If (Self.x + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dx) <= (m.x - m.rx) And (Self.x + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dx) > (m.x - m.rx + m.vx) Then
			If Self.y < (m.y + m.ry + m.vy) And (Self.y + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dy) > (m.y - m.ry + m.vy) Then
				Return 2
			End If
		End If
		
		'------------- TOP 3
		If Self.y >= (m.y + m.ry) And Self.y < (m.y + m.ry + m.vy) Then
			If Self.x < (m.x + m.rx + m.vx) And (Self.x + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dx) > (m.x - m.rx + m.vx) Then
				Return 3
			End If
		End If
		
		'------------- BOTTOM 4
		If (Self.y + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dy) <= (m.y - m.ry) And (Self.y + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dy) > (m.y - m.ry + m.vy) Then
			If Self.x < (m.x + m.rx + m.vx) And (Self.x + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dx) > (m.x - m.rx + m.vx) Then
				Return 4
			End If
		End If
		
		Return 0
	End Method
	
	
	
	Method write_to_stream(stream:TStream)
		stream.WriteInt(3)'TBox = 2        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		
		stream.WriteInt(2222)'just to save my ass...
		stream.WriteInt(Self.rotation)
		stream.WriteInt(Len(Self.vdn))
		stream.WriteString(Self.vdn)
		
		stream.WriteInt(Self.important)
		
		stream.WriteInt(Self.typ)
		
		'stream.WriteInt(Self.renderer_number)
		
		
		stream.WriteInt(TBox_Renderer_Burnable(Self.renderer).coll_down_on)
		stream.WriteInt(TBox_Renderer_Burnable(Self.renderer).coll_up_on)
		stream.WriteInt(TBox_Renderer_Burnable(Self.renderer).coll_r_on)
		stream.WriteInt(TBox_Renderer_Burnable(Self.renderer).coll_l_on)
		
	End Method
	
	Function read_from_stream:TBox(stream:TStream)
		Local o:TBox_Burnable = New TBox_Burnable
		
		o.id = stream.ReadInt()
		o.x = stream.ReadFloat()
		o.y = stream.ReadFloat()
		o.layer = stream.ReadInt()
		
		'stream.WriteInt(1111)
		'If VERSION_COMPATIBILITY > 3 Then stream.WriteInt(Self.rotation)
		Local value:Int = stream.ReadInt()
		
		If value = 1111 Then
			o.rotation = stream.ReadInt()
			o.important = stream.ReadInt()
		Else If value = 2222
			o.rotation = stream.ReadInt()
			
			Local ll:Int = stream.ReadInt()
			o.vdn = stream.ReadString(ll)
			
			o.important = stream.ReadInt()
		Else
			o.important = value
		End If
		
		o.typ = stream.ReadInt()
		
		'o.renderer_number = stream.ReadInt()
		
		o.renderer = TBox_Burnable.burnable_renderer.copy()
		
		TBox_Renderer_Burnable(o.renderer).coll_down_on = stream.ReadInt()
		TBox_Renderer_Burnable(o.renderer).coll_up_on = stream.ReadInt()
		TBox_Renderer_Burnable(o.renderer).coll_r_on = stream.ReadInt()
		TBox_Renderer_Burnable(o.renderer).coll_l_on = stream.ReadInt()
		
		Return o
	End Function
	
	Method write_to_stream_running(stream:TStream)
		stream.WriteInt(3)'TBox = 2        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		
		
		stream.WriteInt(Self.rotation)
		stream.WriteInt(Len(Self.vdn))
		stream.WriteString(Self.vdn)
		
		stream.WriteInt(Self.important)
		
		stream.WriteInt(Self.kill_me)'NEW !
		
		stream.WriteInt(Self.typ)
		
		
		stream.WriteInt(TBox_Renderer_Burnable(Self.renderer).coll_down_on)
		stream.WriteInt(TBox_Renderer_Burnable(Self.renderer).coll_up_on)
		stream.WriteInt(TBox_Renderer_Burnable(Self.renderer).coll_r_on)
		stream.WriteInt(TBox_Renderer_Burnable(Self.renderer).coll_l_on)
		
		'NEW !
		stream.WriteInt(Self.burning)
		stream.WriteInt(Self.last_burning_frame_time)
	End Method
	
	Function read_from_stream_running:TBox(stream:TStream, delta_t:Int)
		Local o:TBox_Burnable = New TBox_Burnable
		
		o.id = stream.ReadInt()
		o.x = stream.ReadFloat()
		o.y = stream.ReadFloat()
		o.layer = stream.ReadInt()
		
		o.rotation = stream.ReadInt()
		
		Local ll:Int = stream.ReadInt()
		o.vdn = stream.ReadString(ll)
		
		o.important = stream.ReadInt()
		
		o.kill_me = stream.ReadInt()'NEW !
		
		o.typ = stream.ReadInt()
		
		o.renderer = TBox_Burnable.burnable_renderer.copy()
		
		TBox_Renderer_Burnable(o.renderer).coll_down_on = stream.ReadInt()
		TBox_Renderer_Burnable(o.renderer).coll_up_on = stream.ReadInt()
		TBox_Renderer_Burnable(o.renderer).coll_r_on = stream.ReadInt()
		TBox_Renderer_Burnable(o.renderer).coll_l_on = stream.ReadInt()
		
		'NEW !
		o.burning = stream.ReadInt()
		o.last_burning_frame_time = stream.ReadInt() + delta_t
		
		Return o
	End Function
	
	Method copy:TBox()
		Local b:TBox_Burnable = New TBox_Burnable
		
		b.x = Self.x
		b.y = Self.y
		b.layer = Self.layer
		b.important = Self.important
		
		b.typ = Self.typ
		b.renderer_number = Self.renderer_number
		b.renderer = Self.renderer.copy()
		
		Return b
	End Method
	
	Function Create:TBox(x:Float, y:Float, typ:Int, layer:Int, renderer_number:Int)
		Local o:TBox_Burnable = New TBox_Burnable
		
		o.x = x
		o.y = y
		
		o.typ = typ
		
		o.renderer_number = renderer_number
		o.renderer = TBox_Burnable.burnable_renderer.copy()
		
		o.layer = layer
		
		o.important = 0
		
		Return o
	End Function
End Type


'########################################################################################
'###########################              ###############################################
'###########################  BOX Stone   ###############################################
'###########################              ###############################################
'########################################################################################

Type TBox_Stone Extends TBox
	Global stone_typs:TBox_Stone_Typ[,]
	
	Global stone_renderer:TBox_Renderer
	
	
	Function init_after_level()
		Local gfx_map:TMap = DATA_FILE_HANDLER.Load("Worlds\" + GAME.world.name + "\Objects\stone_box\boxes.ini")
		
		If Not gfx_map Then
			GAME_ERROR_HANDLER.error("stone_box -> load -> ini -> map is not loaded! Worlds\" + GAME.world.name + "\Objects\stone_box\boxes.ini")
			Return
		End If
		
		Local number_of_boxes:Int
		
		If gfx_map.contains("number_of_boxes") Then'number_of_boxes
			number_of_boxes = Int(String(gfx_map.ValueForKey("number_of_boxes")))
		Else
			GAME_ERROR_HANDLER.error("stone_box -> load -> ini -> number_of_boxes not found! Worlds\" + GAME.world.name + "\Objects\stone_box\boxes.ini")
			Return
		End If
		
		TBox_Stone.stone_typs = New TBox_Stone_Typ[number_of_boxes,4]
		
		For Local i:Int = 0 To number_of_boxes-1
			
			Local i_name:String
			
			If gfx_map.contains("box_" + i) Then'name of box
				i_name = String(gfx_map.ValueForKey("box_" + i))
			Else
				GAME_ERROR_HANDLER.error("stone_box -> load -> ini -> box_" + i + " Not found! Worlds\" + GAME.world.name + "\Objects\stone_box\boxes.ini")
				Return
			End If
			
			TBox_Stone.stone_typs[i,0] = TBox_Stone_Typ.Load(i_name)
			
			'load rest !
			
			For Local ii:Int = 1 To 3
				TBox_Stone.stone_typs[i,ii] = TBox_Stone.stone_typs[i,0].turn(ii)
			Next
		Next
	End Function
	
	Function init_before_level()
		TBox_Stone.stone_renderer = TBox_Renderer_Stone.Create()
	End Function
	
	Field breaking:Int = -1'if bigger then burning
	Field last_breaking_frame_time:Int
	
	Method set_breaking()
		If Self.breaking = -1 Then
			Self.breaking = 0
			Self.last_breaking_frame_time = MilliSecs()
		End If
	End Method
	
	Method New()
		Self.layer = 3
		Self.important = 0
	End Method
	
	Method draw()
		SetColor 255,255,255
		
		SetRotation Self.rotation*90
		
		If Self.breaking > -1 Then
			Draw_Image TBox_Stone.stone_typs[Self.typ,Self.rotation].image_breaking, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, Self.breaking
		Else
			Draw_Image TBox_Stone.stone_typs[Self.typ,Self.rotation].image, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Stone.stone_typs[Self.typ,Self.rotation].current_frame
		End If
		
		SetRotation 0
	End Method
	
	Method render()
		Super.render()
		
		Self.render_mobs()
		
		
		
		If Self.breaking > -1 Then
			
			If Self.last_breaking_frame_time + TBox_Stone.stone_typs[Self.typ,Self.rotation].speed_breaking< MilliSecs() Then
				Self.last_breaking_frame_time:+ TBox_Stone.stone_typs[Self.typ,Self.rotation].speed_breaking
				Self.breaking:+1
				If TBox_Stone.stone_typs[Self.typ,Self.rotation].image_breaking.frames.length-1 < Self.breaking Then
					Self.breaking = TBox_Stone.stone_typs[Self.typ,Self.rotation].image_breaking.frames.length-1
					
					Self.kill()
				End If
			End If
		Else
			TBox_Stone.stone_typs[Self.typ,Self.rotation].render_animation()
		End If
		
	End Method
	
		
	Method mob_is_inside:Int(m:TMob)
		
		If (Self.x - m.rx) =< m.x And (Self.y - m.ry) =< m.y And (Self.x + TBox_Stone.stone_typs[Self.typ,Self.rotation].dx + m.rx) > m.x And (Self.y + TBox_Stone.stone_typs[Self.typ,Self.rotation].dy + m.ry) > m.y Then
			Return 1
		Else
			Return 0
		End If
		
	End Method
	
	Method mob_enters:Int(m:TMob)'return which side, if not return 0
		
		'------------- R 1
		If Self.x >= (m.x + m.rx) And Self.x < (m.x + m.rx + m.vx) Then
			If Self.y < (m.y + m.ry + m.vy) And (Self.y + TBox_Stone.stone_typs[Self.typ,Self.rotation].dy) > (m.y - m.ry + m.vy) Then
				Return 1
			End If
		End If
		
		'------------- L 2
		If (Self.x + TBox_Stone.stone_typs[Self.typ,Self.rotation].dx) <= (m.x - m.rx) And (Self.x + TBox_Stone.stone_typs[Self.typ,Self.rotation].dx) > (m.x - m.rx + m.vx) Then
			If Self.y < (m.y + m.ry + m.vy) And (Self.y + TBox_Stone.stone_typs[Self.typ,Self.rotation].dy) > (m.y - m.ry + m.vy) Then
				Return 2
			End If
		End If
		
		'------------- TOP 3
		If Self.y >= (m.y + m.ry) And Self.y < (m.y + m.ry + m.vy) Then
			If Self.x < (m.x + m.rx + m.vx) And (Self.x + TBox_Stone.stone_typs[Self.typ,Self.rotation].dx) > (m.x - m.rx + m.vx) Then
				Return 3
			End If
		End If
		
		'------------- BOTTOM 4
		If (Self.y + TBox_Stone.stone_typs[Self.typ,Self.rotation].dy) <= (m.y - m.ry) And (Self.y + TBox_Stone.stone_typs[Self.typ,Self.rotation].dy) > (m.y - m.ry + m.vy) Then
			If Self.x < (m.x + m.rx + m.vx) And (Self.x + TBox_Stone.stone_typs[Self.typ,Self.rotation].dx) > (m.x - m.rx + m.vx) Then
				Return 4
			End If
		End If
		
		Return 0
	End Method
	
	
	
	Method write_to_stream(stream:TStream)
		stream.WriteInt(7)'TBox = 2        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		
		stream.WriteInt(2222)'just to save my ass...
		stream.WriteInt(Self.rotation)
		stream.WriteInt(Len(Self.vdn))
		stream.WriteString(Self.vdn)
		
		stream.WriteInt(Self.important)
		
		stream.WriteInt(Self.typ)
		
		'stream.WriteInt(Self.renderer_number)
		
		
		stream.WriteInt(TBox_Renderer_Stone(Self.renderer).coll_down_on)
		stream.WriteInt(TBox_Renderer_Stone(Self.renderer).coll_up_on)
		stream.WriteInt(TBox_Renderer_Stone(Self.renderer).coll_r_on)
		stream.WriteInt(TBox_Renderer_Stone(Self.renderer).coll_l_on)
		
	End Method
	
	Function read_from_stream:TBox(stream:TStream)
		Local o:TBox_Stone = New TBox_Stone
		
		o.id = stream.ReadInt()
		o.x = stream.ReadFloat()
		o.y = stream.ReadFloat()
		o.layer = stream.ReadInt()
		
		'stream.WriteInt(1111)
		'If VERSION_COMPATIBILITY > 3 Then stream.WriteInt(Self.rotation)
		Local value:Int = stream.ReadInt()
		
		If value = 1111 Then
			o.rotation = stream.ReadInt()
			o.important = stream.ReadInt()
		Else If value = 2222
			o.rotation = stream.ReadInt()
			
			Local ll:Int = stream.ReadInt()
			o.vdn = stream.ReadString(ll)
			
			o.important = stream.ReadInt()
		Else
			o.important = value
		End If
		
		o.typ = stream.ReadInt()
		
		'o.renderer_number = stream.ReadInt()
		
		o.renderer = TBox_Stone.stone_renderer.copy()
		
		TBox_Renderer_Stone(o.renderer).coll_down_on = stream.ReadInt()
		TBox_Renderer_Stone(o.renderer).coll_up_on = stream.ReadInt()
		TBox_Renderer_Stone(o.renderer).coll_r_on = stream.ReadInt()
		TBox_Renderer_Stone(o.renderer).coll_l_on = stream.ReadInt()
		
		Return o
	End Function
	
	Method write_to_stream_running(stream:TStream)
		stream.WriteInt(7)'TBox = 2        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		
		stream.WriteInt(Self.rotation)
		stream.WriteInt(Len(Self.vdn))
		stream.WriteString(Self.vdn)
		
		stream.WriteInt(Self.important)
		
		stream.WriteInt(Self.kill_me)'NEW !
		
		stream.WriteInt(Self.typ)
		
		
		stream.WriteInt(TBox_Renderer_Stone(Self.renderer).coll_down_on)
		stream.WriteInt(TBox_Renderer_Stone(Self.renderer).coll_up_on)
		stream.WriteInt(TBox_Renderer_Stone(Self.renderer).coll_r_on)
		stream.WriteInt(TBox_Renderer_Stone(Self.renderer).coll_l_on)
		
		'NEW !
		stream.WriteInt(Self.breaking)
		stream.WriteInt(Self.last_breaking_frame_time)
	End Method
	
	Function read_from_stream_running:TBox(stream:TStream, delta_t:Int)
		Local o:TBox_Stone = New TBox_Stone
		
		o.id = stream.ReadInt()
		o.x = stream.ReadFloat()
		o.y = stream.ReadFloat()
		o.layer = stream.ReadInt()
		
		o.rotation = stream.ReadInt()
		
		Local ll:Int = stream.ReadInt()
		o.vdn = stream.ReadString(ll)
		
		o.important = stream.ReadInt()
		
		o.kill_me = stream.ReadInt()'NEW !
		
		o.typ = stream.ReadInt()
		
		o.renderer = TBox_Stone.stone_renderer.copy()
		
		TBox_Renderer_Stone(o.renderer).coll_down_on = stream.ReadInt()
		TBox_Renderer_Stone(o.renderer).coll_up_on = stream.ReadInt()
		TBox_Renderer_Stone(o.renderer).coll_r_on = stream.ReadInt()
		TBox_Renderer_Stone(o.renderer).coll_l_on = stream.ReadInt()
		
		'NEW !
		o.breaking = stream.ReadInt()
		o.last_breaking_frame_time = stream.ReadInt() + delta_t
		
		Return o
	End Function
	
	Method copy:TBox()
		Local b:TBox_Stone = New TBox_Stone
		
		b.x = Self.x
		b.y = Self.y
		b.layer = Self.layer
		b.important = Self.important
		
		b.typ = Self.typ
		b.renderer_number = Self.renderer_number
		b.renderer = Self.renderer.copy()
		
		Return b
	End Method
	
	Function Create:TBox(x:Float, y:Float, typ:Int, layer:Int, renderer_number:Int)
		Local o:TBox_Stone = New TBox_Stone
		
		o.x = x
		o.y = y
		
		o.typ = typ
		
		o.renderer_number = renderer_number
		o.renderer = TBox_Stone.stone_renderer.copy()
		
		o.layer = layer
		
		o.important = 0
		
		Return o
	End Function
End Type



'########################################################################################
'###########################              ###############################################
'###########################   BOX Key    ###############################################
'###########################              ###############################################
'########################################################################################

Type TBox_Key Extends TBox
	Global key_typs:TBox_Key_Typ[,]
	
	Global key_renderer:TBox_Renderer
	
	Function init_after_level()
		Local gfx_map:TMap = DATA_FILE_HANDLER.Load("Worlds\" + GAME.world.name + "\Objects\key_box\boxes.ini")
		
		If Not gfx_map Then
			GAME_ERROR_HANDLER.error("key_box -> load -> ini -> map is not loaded! Worlds\" + GAME.world.name + "\Objects\key_box\boxes.ini")
			Return
		End If
		
		Local number_of_boxes:Int
		
		If gfx_map.contains("number_of_boxes") Then'number_of_boxes
			number_of_boxes = Int(String(gfx_map.ValueForKey("number_of_boxes")))
		Else
			GAME_ERROR_HANDLER.error("key_box -> load -> ini -> number_of_boxes not found! Worlds\" + GAME.world.name + "\Objects\key_box\boxes.ini")
			Return
		End If
		
		TBox_Key.key_typs = New TBox_Key_Typ[number_of_boxes,4]
		
		For Local i:Int = 0 To number_of_boxes-1
			
			Local i_name:String
			
			If gfx_map.contains("box_" + i) Then'name of box
				i_name = String(gfx_map.ValueForKey("box_" + i))
			Else
				GAME_ERROR_HANDLER.error("key_box -> load -> ini -> box_" + i + " Not found! Worlds\" + GAME.world.name + "\Objects\key_box\boxes.ini")
				Return
			End If
			
			TBox_Key.key_typs[i,0] = TBox_Key_Typ.Load(i_name)
			
			'load rest !
			
			For Local ii:Int = 1 To 3
				TBox_Key.key_typs[i,ii] = TBox_Key.key_typs[i,0].turn(ii)
			Next
		Next
	End Function
	
	Function init_before_level()
		TBox_Key.key_renderer = TBox_Renderer_Key.Create()
	End Function
	
	Method draw()
		SetColor 255,255,255
		
		SetRotation Self.rotation*90
		
		
		Select Int(String(LEVEL_VARIABLES.get(TBox_Renderer_Key(Self.renderer).door_name)))
			Case 0'opened (ing)
				Draw_Image TBox_Key.key_typs[Self.typ,Self.rotation].image_opened, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Key.key_typs[Self.typ,Self.rotation].current_frame
			Default
				Draw_Image TBox_Key.key_typs[Self.typ,Self.rotation].image_closed, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Key.key_typs[Self.typ,Self.rotation].current_frame
		End Select
		
		SetRotation 0
		Return
		
	End Method
	
	Method render()
		
		Select TBox_Renderer_Key(Self.renderer).controller_typ
			Case 3'Button_On
				
				If TBox_Renderer_Key(Self.renderer).count_objects_inside = 0 And TBox_Renderer_Key(Self.renderer).last_count_objects_inside > 0 Then
					'TBox_Door.close(TBox_Renderer_Key(Self.renderer).door_name)
					
					LEVEL_VARIABLES.set(TBox_Renderer_Key(Self.renderer).door_name,"1")
				End If
				
			Case 4'Button_Off
				
				If TBox_Renderer_Key(Self.renderer).count_objects_inside = 0 And TBox_Renderer_Key(Self.renderer).last_count_objects_inside > 0 Then
					'TBox_Door.open(TBox_Renderer_Key(Self.renderer).door_name)
					
					LEVEL_VARIABLES.set(TBox_Renderer_Key(Self.renderer).door_name,"0")
				End If
				
		End Select
		
		TBox_Renderer_Key(Self.renderer).last_count_objects_inside = TBox_Renderer_Key(Self.renderer).count_objects_inside
		
		TBox_Renderer_Key(Self.renderer).count_objects_inside = 0
		
		
		Super.render()
		
		'Self.render_mobs()
		
		TBox_Key.key_typs[Self.typ,Self.rotation].render_animation()
		
		
	End Method
	
	Method mob_is_inside:Int(m:TMob)
		
		If (Self.x - m.rx) =< m.x And (Self.y - m.ry) =< m.y And (Self.x + TBox_Key.key_typs[Self.typ,Self.rotation].dx + m.rx) > m.x And (Self.y + TBox_Key.key_typs[Self.typ,Self.rotation].dy + m.ry) > m.y Then
			Return 1
		Else
			Return 0
		End If
		
	End Method
	
	Method mob_enters:Int(m:TMob)'return which side, if not return 0
		
		'------------- R 1
		If Self.x >= (m.x + m.rx) And Self.x < (m.x + m.rx + m.vx) Then
			If Self.y < (m.y + m.ry + m.vy) And (Self.y + TBox_Key.key_typs[Self.typ,Self.rotation].dy) > (m.y - m.ry + m.vy) Then
				Return 1
			End If
		End If
		
		'------------- L 2
		If (Self.x + TBox_Key.key_typs[Self.typ,Self.rotation].dx) <= (m.x - m.rx) And (Self.x + TBox_Key.key_typs[Self.typ,Self.rotation].dx) > (m.x - m.rx + m.vx) Then
			If Self.y < (m.y + m.ry + m.vy) And (Self.y + TBox_Key.key_typs[Self.typ,Self.rotation].dy) > (m.y - m.ry + m.vy) Then
				Return 2
			End If
		End If
		
		'------------- TOP 3
		If Self.y >= (m.y + m.ry) And Self.y < (m.y + m.ry + m.vy) Then
			If Self.x < (m.x + m.rx + m.vx) And (Self.x + TBox_Key.key_typs[Self.typ,Self.rotation].dx) > (m.x - m.rx + m.vx) Then
				Return 3
			End If
		End If
		
		'------------- BOTTOM 4
		If (Self.y + TBox_Key.key_typs[Self.typ,Self.rotation].dy) <= (m.y - m.ry) And (Self.y + TBox_Key.key_typs[Self.typ,Self.rotation].dy) > (m.y - m.ry + m.vy) Then
			If Self.x < (m.x + m.rx + m.vx) And (Self.x + TBox_Key.key_typs[Self.typ,Self.rotation].dx) > (m.x - m.rx + m.vx) Then
				Return 4
			End If
		End If
		
		Return 0
	End Method
	
	Method write_to_stream(stream:TStream)
		stream.WriteInt(6)'TBox = 2        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		
		stream.WriteInt(2222)'just to save my ass...
		stream.WriteInt(Self.rotation)
		stream.WriteInt(Len(Self.vdn))
		stream.WriteString(Self.vdn)
		
		stream.WriteInt(1)'Self.important)
		
		stream.WriteInt(Self.typ)
		
		stream.WriteInt(Len(TBox_Renderer_Key(Self.renderer).door_name))
		
		stream.WriteString(TBox_Renderer_Key(Self.renderer).door_name)
		
		stream.WriteInt(TBox_Renderer_Key(Self.renderer).controller_typ)
		
	End Method
	
	Function read_from_stream:TBox(stream:TStream)
		Local o:TBox_Key = New TBox_Key
		
		o.id = stream.ReadInt()
		o.x = stream.ReadFloat()
		o.y = stream.ReadFloat()
		o.layer = stream.ReadInt()
		
		'stream.WriteInt(1111)
		'If VERSION_COMPATIBILITY > 3 Then stream.WriteInt(Self.rotation)
		Local value:Int = stream.ReadInt()
		
		If value = 1111 Then
			o.rotation = stream.ReadInt()
			o.important = stream.ReadInt()
		Else If value = 2222
			o.rotation = stream.ReadInt()
			
			Local ll:Int = stream.ReadInt()
			o.vdn = stream.ReadString(ll)
			
			o.important = stream.ReadInt()
		Else
			o.important = value
		End If
		
		o.typ = stream.ReadInt()
		
		o.renderer = TBox_Key.key_renderer.copy()
		
		Local l:Int = stream.ReadInt()
		
		TBox_Renderer_Key(o.renderer).door_name = stream.ReadString(l)
		
		TBox_Renderer_Key(o.renderer).controller_typ = stream.ReadInt()
		
		Return o
	End Function

	Method write_to_stream_running(stream:TStream)
		stream.WriteInt(6)'TBox = 2        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		
		
		stream.WriteInt(Self.rotation)
		stream.WriteInt(Len(Self.vdn))
		stream.WriteString(Self.vdn)
		
		stream.WriteInt(Self.important)
		
		stream.WriteInt(Self.kill_me)'NEW !
		
		stream.WriteInt(Self.typ)
		
		stream.WriteInt(Len(TBox_Renderer_Key(Self.renderer).door_name))
		
		stream.WriteString(TBox_Renderer_Key(Self.renderer).door_name)
		
		stream.WriteInt(TBox_Renderer_Key(Self.renderer).controller_typ)
		
	End Method
	
	Function read_from_stream_running:TBox(stream:TStream, delta_t:Int)
		Local o:TBox_Key = New TBox_Key
		
		o.id = stream.ReadInt()
		o.x = stream.ReadFloat()
		o.y = stream.ReadFloat()
		o.layer = stream.ReadInt()
		
		o.rotation = stream.ReadInt()
		
		Local ll:Int = stream.ReadInt()
		o.vdn = stream.ReadString(ll)
		
		o.important = stream.ReadInt()
		
		o.kill_me = stream.ReadInt()'NEW !
		
		o.typ = stream.ReadInt()
		
		o.renderer = TBox_Key.key_renderer.copy()
		
		Local l:Int = stream.ReadInt()
		
		TBox_Renderer_Key(o.renderer).door_name = stream.ReadString(l)
		
		TBox_Renderer_Key(o.renderer).controller_typ = stream.ReadInt()
		
		Return o
	End Function
	
	Method copy:TBox()
		Local b:TBox_Key = New TBox_Key
		
		b.x = Self.x
		b.y = Self.y
		b.layer = Self.layer
		b.important = Self.important
		
		b.typ = Self.typ
		b.renderer_number = Self.renderer_number
		b.renderer = Self.renderer.copy()
		
		Return b
	End Method
End Type


'########################################################################################
'###########################              ###############################################
'###########################   BOX Door   ###############################################
'###########################              ###############################################
'########################################################################################

Type TBox_Door Extends TBox
	Global door_typs:TBox_Door_Typ[,]
	
	Global door_renderer:TBox_Renderer
	
	Function init_after_level()
		Local gfx_map:TMap = DATA_FILE_HANDLER.Load("Worlds\" + GAME.world.name + "\Objects\door_box\boxes.ini")
		
		If Not gfx_map Then
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> map is not loaded! Worlds\" + GAME.world.name + "\Objects\door_box\boxes.ini")
			Return
		End If
		
		Local number_of_boxes:Int
		
		If gfx_map.contains("number_of_boxes") Then'number_of_boxes
			number_of_boxes = Int(String(gfx_map.ValueForKey("number_of_boxes")))
		Else
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> number_of_boxes not found! Worlds\" + GAME.world.name + "\Objects\door_box\boxes.ini")
			Return
		End If
		
		TBox_Door.door_typs = New TBox_Door_Typ[number_of_boxes,4]
		
		For Local i:Int = 0 To number_of_boxes-1
			
			Local i_name:String
			
			If gfx_map.contains("box_" + i) Then'name of box
				i_name = String(gfx_map.ValueForKey("box_" + i))
			Else
				GAME_ERROR_HANDLER.error("door_box -> load -> ini -> box_" + i + " Not found! Worlds\" + GAME.world.name + "\Objects\door_box\boxes.ini")
				Return
			End If
			
			TBox_Door.door_typs[i,0] = TBox_Door_Typ.Load(i_name)
			
			'load rest !
			
			For Local ii:Int = 1 To 3
				TBox_Door.door_typs[i,ii] = TBox_Door.door_typs[i,0].turn(ii)
			Next
		Next
	End Function
	
	Function init_before_level()
		TBox_Door.door_renderer = TBox_Renderer_Door.Create()
	End Function
	
	
	Field want:Int '0 = open, 1 = closed
	Field last_frame_change:Int
	Field current_frame:Int
	
	Rem
	Function switch(name:String)
		For Local d:TBox_Door = EachIn GAME.world.act_level.door_list
			If TBox_Renderer_Door(d.renderer).door_name = name Then
				
				d.want = 1-d.want
				
				'TBox_Renderer_Door(d.renderer).status = 1 - TBox_Renderer_Door(d.renderer).status
			End If
		Next
	End Function
	
	Function open(name:String)
		For Local d:TBox_Door = EachIn GAME.world.act_level.door_list
			If TBox_Renderer_Door(d.renderer).door_name = name Then
				d.want = 0
				'TBox_Renderer_Door(d.renderer).status = 0
			End If
		Next
	End Function
	
	Function close(name:String)
		For Local d:TBox_Door = EachIn GAME.world.act_level.door_list
			If TBox_Renderer_Door(d.renderer).door_name = name Then
				d.want = 1
				'TBox_Renderer_Door(d.renderer).status = 1
			End If
		Next
	End Function
	End Rem
	
	Method kill()'delete from memory
		Super.kill()
		
		GAME.world.act_level.door_list.addlast(Self)
	End Method
	
	Method draw()
		SetColor 255,255,255
		
		SetRotation Self.rotation*90
		
		Select TBox_Renderer_Door(Self.renderer).status
			Case 0'opened
				If Self.current_frame > TBox_Door.door_typs[Self.typ,Self.rotation].image_opened.frames.length-1 Then Self.current_frame = TBox_Door.door_typs[Self.typ,Self.rotation].image_opened.frames.length-1
				Draw_Image TBox_Door.door_typs[Self.typ,Self.rotation].image_opened, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, Self.current_frame
			Case 1'closed
				If Self.current_frame > TBox_Door.door_typs[Self.typ,Self.rotation].image_closed.frames.length-1 Then Self.current_frame = TBox_Door.door_typs[Self.typ,Self.rotation].image_closed.frames.length-1
				Draw_Image TBox_Door.door_typs[Self.typ,Self.rotation].image_closed, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, Self.current_frame
			Case 2'closing
				If Self.current_frame > TBox_Door.door_typs[Self.typ,Self.rotation].image_closing.frames.length-1 Then Self.current_frame = TBox_Door.door_typs[Self.typ,Self.rotation].image_closing.frames.length-1
				Draw_Image TBox_Door.door_typs[Self.typ,Self.rotation].image_closing, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, Self.current_frame
			Case 3'opening
				If Self.current_frame > TBox_Door.door_typs[Self.typ,Self.rotation].image_opening.frames.length-1 Then Self.current_frame = TBox_Door.door_typs[Self.typ,Self.rotation].image_opening.frames.length-1
				Draw_Image TBox_Door.door_typs[Self.typ,Self.rotation].image_opening, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, Self.current_frame
		End Select
		SetRotation 0
	End Method
	
	Method render()
		
		Super.render()
		
		
		Self.want = Int(LEVEL_VARIABLES.get(TBox_Renderer_Door(Self.renderer).door_name))' get variable !
		
		Select TBox_Renderer_Door(Self.renderer).status
			Case 0'opened
				If Self.want = 1 Then
					TBox_Renderer_Door(Self.renderer).status = 2
					Self.current_frame = 0
					Self.last_frame_change = MilliSecs()
				Else
					
					
					If Self.last_frame_change + TBox_Door.door_typs[Self.typ,Self.rotation].image_opened_speed < MilliSecs() Then
						Self.current_frame:+1
						Self.last_frame_change:+TBox_Door.door_typs[Self.typ,Self.rotation].image_opened_speed
						
						If Self.current_frame >= TBox_Door.door_typs[Self.typ,Self.rotation].image_opened.frames.length Then
							Self.current_frame = 0
						End If
					End If
					
					
				End If
			Case 1'closed
				If Self.want = 0 Then
					TBox_Renderer_Door(Self.renderer).status = 3
					Self.current_frame = 0
					Self.last_frame_change = MilliSecs()
				Else
					
					
					If Self.last_frame_change + TBox_Door.door_typs[Self.typ,Self.rotation].image_closed_speed < MilliSecs() Then
						Self.current_frame:+1
						Self.last_frame_change:+TBox_Door.door_typs[Self.typ,Self.rotation].image_closed_speed
						
						If Self.current_frame >= TBox_Door.door_typs[Self.typ,Self.rotation].image_closed.frames.length Then
							Self.current_frame = 0
						End If
					End If
					
					
				End If
			Case 2'closing
				If Self.last_frame_change + TBox_Door.door_typs[Self.typ,Self.rotation].image_closing_speed < MilliSecs() Then
					Self.current_frame:+1
					Self.last_frame_change:+TBox_Door.door_typs[Self.typ,Self.rotation].image_closing_speed
					
					If Self.current_frame >= TBox_Door.door_typs[Self.typ,Self.rotation].image_closing.frames.length Then
						Self.current_frame = 0
						TBox_Renderer_Door(Self.renderer).status = 1
					End If
				End If
			Case 3'opening
				If Self.last_frame_change + TBox_Door.door_typs[Self.typ,Self.rotation].image_opening_speed < MilliSecs() Then
					Self.current_frame:+1
					Self.last_frame_change:+TBox_Door.door_typs[Self.typ,Self.rotation].image_opening_speed
					
					If Self.current_frame >= TBox_Door.door_typs[Self.typ,Self.rotation].image_opening.frames.length Then
						Self.current_frame = 0
						TBox_Renderer_Door(Self.renderer).status = 0
					End If
				End If
		End Select
		
		
	End Method
	
	
	Method mob_is_inside:Int(m:TMob)
		
		If (Self.x - m.rx) =< m.x And (Self.y - m.ry) =< m.y And (Self.x + TBox_Door.door_typs[Self.typ,Self.rotation].dx + m.rx) > m.x And (Self.y + TBox_Door.door_typs[Self.typ,Self.rotation].dy + m.ry) > m.y Then
			Return 1
		Else
			Return 0
		End If
		
	End Method
	
	Method mob_enters:Int(m:TMob)'return which side, if not return 0
		
		'------------- R 1
		If Self.x >= (m.x + m.rx) And Self.x < (m.x + m.rx + m.vx) Then
			If Self.y < (m.y + m.ry + m.vy) And (Self.y + TBox_Door.door_typs[Self.typ,Self.rotation].dy) > (m.y - m.ry + m.vy) Then
				Return 1
			End If
		End If
		
		'------------- L 2
		If (Self.x + TBox_Door.door_typs[Self.typ,Self.rotation].dx) <= (m.x - m.rx) And (Self.x + TBox_Door.door_typs[Self.typ,Self.rotation].dx) > (m.x - m.rx + m.vx) Then
			If Self.y < (m.y + m.ry + m.vy) And (Self.y + TBox_Door.door_typs[Self.typ,Self.rotation].dy) > (m.y - m.ry + m.vy) Then
				Return 2
			End If
		End If
		
		'------------- TOP 3
		If Self.y >= (m.y + m.ry) And Self.y < (m.y + m.ry + m.vy) Then
			If Self.x < (m.x + m.rx + m.vx) And (Self.x + TBox_Door.door_typs[Self.typ,Self.rotation].dx) > (m.x - m.rx + m.vx) Then
				Return 3
			End If
		End If
		
		'------------- BOTTOM 4
		If (Self.y + TBox_Door.door_typs[Self.typ,Self.rotation].dy) <= (m.y - m.ry) And (Self.y + TBox_Door.door_typs[Self.typ,Self.rotation].dy) > (m.y - m.ry + m.vy) Then
			If Self.x < (m.x + m.rx + m.vx) And (Self.x + TBox_Door.door_typs[Self.typ,Self.rotation].dx) > (m.x - m.rx + m.vx) Then
				Return 4
			End If
		End If
		
		Return 0
	End Method
	
	
	
	Method write_to_stream(stream:TStream)
		stream.WriteInt(5)'TBox = 2        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		
		stream.WriteInt(2222)'just to save my ass...
		stream.WriteInt(Self.rotation)
		stream.WriteInt(Len(Self.vdn))
		stream.WriteString(Self.vdn)
		
		stream.WriteInt(Self.important)
		
		stream.WriteInt(Self.typ)
		
		
		stream.WriteInt(TBox_Renderer_Door(Self.renderer).coll_down_on)
		stream.WriteInt(TBox_Renderer_Door(Self.renderer).coll_up_on)
		stream.WriteInt(TBox_Renderer_Door(Self.renderer).coll_r_on)
		stream.WriteInt(TBox_Renderer_Door(Self.renderer).coll_l_on)
		
		stream.WriteInt(TBox_Renderer_Door(Self.renderer).status)
		
		stream.WriteInt(Len(TBox_Renderer_Door(Self.renderer).door_name))
		stream.WriteString(TBox_Renderer_Door(Self.renderer).door_name)
		
		stream.WriteInt(Len(TBox_Renderer_Door(Self.renderer).teleport_name))
		stream.WriteString(TBox_Renderer_Door(Self.renderer).teleport_name)
	End Method
	
	Function read_from_stream:TBox(stream:TStream)
		Local o:TBox_Door = New TBox_Door
		
		o.id = stream.ReadInt()
		o.x = stream.ReadFloat()
		o.y = stream.ReadFloat()
		o.layer = stream.ReadInt()
		
		'stream.WriteInt(1111)
		'If VERSION_COMPATIBILITY > 3 Then stream.WriteInt(Self.rotation)
		Local value:Int = stream.ReadInt()
		
		If value = 1111 Then
			o.rotation = stream.ReadInt()
			o.important = stream.ReadInt()
		Else If value = 2222
			o.rotation = stream.ReadInt()
			
			Local ll:Int = stream.ReadInt()
			o.vdn = stream.ReadString(ll)
			
			o.important = stream.ReadInt()
		Else
			o.important = value
		End If
		
		o.typ = stream.ReadInt()
		
		
		o.renderer = TBox_Door.door_renderer.copy()
		
		
		TBox_Renderer_Door(o.renderer).coll_down_on = stream.ReadInt()
		TBox_Renderer_Door(o.renderer).coll_up_on = stream.ReadInt()
		TBox_Renderer_Door(o.renderer).coll_r_on = stream.ReadInt()
		TBox_Renderer_Door(o.renderer).coll_l_on = stream.ReadInt()
		
		TBox_Renderer_Door(o.renderer).status = stream.ReadInt()
		
		Select TBox_Renderer_Door(o.renderer).status
			Case 0'opened
				o.want = 0
			Case 1'closed
				o.want = 1
			Case 2'closing
				o.want = 1
			Case 3'opening
				o.want = 0
		End Select
		
		
		
		o.current_frame = 0
		o.last_frame_change = MilliSecs()
		
		Local l:Int = stream.ReadInt()
		TBox_Renderer_Door(o.renderer).door_name = stream.ReadString(l)
		
		LEVEL_VARIABLES.set(TBox_Renderer_Door(o.renderer).door_name, o.want)'set want
		
		Local l2:Int = stream.ReadInt()
		TBox_Renderer_Door(o.renderer).teleport_name = stream.ReadString(l2)
		
		Return o
	End Function

	
	
	
	Method write_to_stream_running(stream:TStream)
		stream.WriteInt(5)'TBox = 2        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		
		
		stream.WriteInt(Self.rotation)
		stream.WriteInt(Len(Self.vdn))
		stream.WriteString(Self.vdn)
		
		stream.WriteInt(Self.important)
		
		stream.WriteInt(Self.kill_me)'NEW !
		
		stream.WriteInt(Self.typ)
		
		
		stream.WriteInt(TBox_Renderer_Door(Self.renderer).coll_down_on)
		stream.WriteInt(TBox_Renderer_Door(Self.renderer).coll_up_on)
		stream.WriteInt(TBox_Renderer_Door(Self.renderer).coll_r_on)
		stream.WriteInt(TBox_Renderer_Door(Self.renderer).coll_l_on)
		
		stream.WriteInt(TBox_Renderer_Door(Self.renderer).status)
		
		stream.WriteInt(Len(TBox_Renderer_Door(Self.renderer).door_name))
		stream.WriteString(TBox_Renderer_Door(Self.renderer).door_name)
		
		stream.WriteInt(Len(TBox_Renderer_Door(Self.renderer).teleport_name))
		stream.WriteString(TBox_Renderer_Door(Self.renderer).teleport_name)
		
		
		stream.WriteInt(Self.last_frame_change)'NEW !!!
		stream.WriteInt(Self.current_frame)'NEW !!!
	End Method
	
	
	Function read_from_stream_running:TBox(stream:TStream, delta_t:Int)
		Local o:TBox_Door = New TBox_Door
		
		o.id = stream.ReadInt()
		o.x = stream.ReadFloat()
		o.y = stream.ReadFloat()
		o.layer = stream.ReadInt()
		
		o.rotation = stream.ReadInt()
		
		Local ll:Int = stream.ReadInt()
		o.vdn = stream.ReadString(ll)
		
		o.important = stream.ReadInt()
		
		o.kill_me = stream.ReadInt()'NEW !
		
		o.typ = stream.ReadInt()
		
		
		o.renderer = TBox_Door.door_renderer.copy()
		
		
		TBox_Renderer_Door(o.renderer).coll_down_on = stream.ReadInt()
		TBox_Renderer_Door(o.renderer).coll_up_on = stream.ReadInt()
		TBox_Renderer_Door(o.renderer).coll_r_on = stream.ReadInt()
		TBox_Renderer_Door(o.renderer).coll_l_on = stream.ReadInt()
		
		TBox_Renderer_Door(o.renderer).status = stream.ReadInt()
		
		Select TBox_Renderer_Door(o.renderer).status
			Case 0'opened
				o.want = 0
			Case 1'closed
				o.want = 1
			Case 2'closing
				o.want = 1
			Case 3'opening
				o.want = 0
		End Select
		
		'o.current_frame = 0 sind ersetzt
		'o.last_frame_change = MilliSecs()
		
		Local l:Int = stream.ReadInt()
		TBox_Renderer_Door(o.renderer).door_name = stream.ReadString(l)
		
		LEVEL_VARIABLES.set(TBox_Renderer_Door(o.renderer).door_name, o.want)'set want
		
		Local l2:Int = stream.ReadInt()
		TBox_Renderer_Door(o.renderer).teleport_name = stream.ReadString(l2)
		
		o.current_frame = stream.ReadInt()'NEW !!!
		o.last_frame_change = stream.ReadInt() + delta_t'NEW !!!
		
		Return o
	End Function
	
	Method copy:TBox()
		Local b:TBox_Door = New TBox_Door
		
		b.x = Self.x
		b.y = Self.y
		b.layer = Self.layer
		b.important = Self.important
		
		b.typ = Self.typ
		b.renderer_number = Self.renderer_number
		b.renderer = Self.renderer.copy()
		
		Return b
	End Method
End Type




'########################################################################################
'###########################          ###################################################
'########################### BOX Typ  ###################################################
'###########################          ###################################################
'########################################################################################

Type TBox_Typ
	Field image:TImage
	
	Field name:String
	
	Field image_x1:Int
	Field image_x2:Int
	Field dx:Int
	
	Field image_y1:Int
	Field image_y2:Int
	Field dy:Int
	
	Field speed:Int
	
	Field last_frame_change:Int
	Field current_frame:Int
	
	Function Load:TBox_Typ(name:String)
		Local bt:TBox_Typ = New TBox_Typ
		
		Print "loading box: " + name
		
		bt.name = name
		
		Local gfx_map:TMap = DATA_FILE_HANDLER.Load("Worlds\" + GAME.world.name + "\Objects\boxes\" + name + "\image.ini")
		
		If Not gfx_map Then
			GAME_ERROR_HANDLER.error("Box -> load -> ini -> map is not loaded! Worlds\" + GAME.world.name + "\Objects\boxes\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_x1") Then'image_x1
			bt.image_x1 = Int(String(gfx_map.ValueForKey("image_x1")))
		Else
			GAME_ERROR_HANDLER.error("Box -> load -> ini -> image_x1 not found! Worlds\" + GAME.world.name + "\Objects\boxes\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_x2") Then'image_x2
			bt.image_x2 = Int(String(gfx_map.ValueForKey("image_x2")))
		Else
			GAME_ERROR_HANDLER.error("Box -> load -> ini -> image_x2 not found! Worlds\" + GAME.world.name + "\Objects\boxes\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_y1") Then'image_y1
			bt.image_y1 = Int(String(gfx_map.ValueForKey("image_y1")))
		Else
			GAME_ERROR_HANDLER.error("Box -> load -> ini -> image_y1 not found! Worlds\" + GAME.world.name + "\Objects\boxes\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_y2") Then'image_y2
			bt.image_y2 = Int(String(gfx_map.ValueForKey("image_y2")))
		Else
			GAME_ERROR_HANDLER.error("Box -> load -> ini -> image_y2 not found! Worlds\" + GAME.world.name + "\Objects\boxes\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_dx") Then'image_dx
			bt.dx = Int(String(gfx_map.ValueForKey("image_dx")))
		Else
			GAME_ERROR_HANDLER.error("Box -> load -> ini -> image_dx not found! Worlds\" + GAME.world.name + "\Objects\boxes\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_dy") Then'image_dy
			bt.dy = Int(String(gfx_map.ValueForKey("image_dy")))
		Else
			GAME_ERROR_HANDLER.error("Box -> load -> ini -> image_dy not found! Worlds\" + GAME.world.name + "\Objects\boxes\" + name + "\image.ini")
			Return Null
		End If
		
		
		If gfx_map.contains("image_speed") Then'image_speed
			bt.speed = Int(String(gfx_map.ValueForKey("image_speed")))
		Else
			GAME_ERROR_HANDLER.error("Box -> load -> ini -> image_speed not found! Worlds\" + GAME.world.name + "\Objects\boxes\" + name + "\image.ini")
			Return Null
		End If
		
		bt.image = LoadImage("Worlds\" + GAME.world.name + "\Objects\boxes\" + name + "\image.png")'loading image
		
		If Not bt.image Then
			GAME_ERROR_HANDLER.error("Box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\boxes\" + name + "\image.png")
			Return Null
		End If
		
		If bt.image.width >= 2*(bt.image_x1 + bt.dx + bt.image_x2) Then'loading if anim image
			bt.image = LoadAnimImage("Worlds\" + GAME.world.name + "\Objects\boxes\" + name + "\image.png", (bt.image_x1 + bt.dx + bt.image_x2), (bt.image_y1 + bt.dy + bt.image_y2), 0, bt.image.width/(bt.image_x1 + bt.dx + bt.image_x2))
		End If
		
		If Not bt.image Then'check again
			GAME_ERROR_HANDLER.error("Box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\boxes\" + name + "\image.png")
			Return Null
		End If
		
		SetImageHandle(bt.image, bt.image_x1, bt.image_y1)
		
		bt.last_frame_change = MilliSecs()
		
		Return bt
	End Function
	
	Method turn:TBox_Typ(rotation:Int)
		Local bt:TBox_Typ = New TBox_Typ
		
		bt.name = Self.name
		
		bt.speed = Self.speed
		
		bt.image = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\boxes\" + Self.name + "\image.png", (Self.image_x1 + Self.dx + Self.image_x2), (Self.image_y1 + Self.dy + Self.image_y2))
		
		Select rotation
			Case 0'-----------------------------------------------
				bt.image_x1 = Self.image_x1
				
				bt.image_x2 = Self.image_x2
				
				bt.image_y1 = Self.image_y1
				
				bt.image_y2 = Self.image_y2
				
				bt.dx = Self.dx
				
				bt.dy = Self.dy
				
				SetImageHandle(bt.image, bt.image_x1, bt.image_y1)
			Case 1'-----------------------------------------------
				bt.image_x1 = Self.image_y1
				
				bt.image_x2 = Self.image_y2
				
				bt.image_y1 = Self.image_x2
				
				bt.image_y2 = Self.image_x1
				
				bt.dx = Self.dy
				
				bt.dy = Self.dx
				
				SetImageHandle(bt.image, Self.image_x1, Self.image_y1+Self.dy)
			Case 2'-----------------------------------------------
				bt.image_x1 = Self.image_x2
				
				bt.image_x2 = Self.image_x1
				
				bt.image_y1 = Self.image_y2
				
				bt.image_y2 = Self.image_y1
				
				bt.dx = Self.dx
				
				bt.dy = Self.dy
				
				SetImageHandle(bt.image, Self.image_x1+Self.dx, Self.image_y1+Self.dy)
			Case 3'-----------------------------------------------
				bt.image_x1 = Self.image_y2
				
				bt.image_x2 = Self.image_y1
				
				bt.image_y1 = Self.image_x1
				
				bt.image_y2 = Self.image_x2
				
				bt.dx = Self.dy
				
				bt.dy = Self.dx
				
				SetImageHandle(bt.image, Self.image_x1+Self.dx, Self.image_y1)
		End Select
		
		
		bt.last_frame_change = MilliSecs()
		
		Return bt
	End Method

	
	Method render_animation()
		If Self.last_frame_change + Self.speed < MilliSecs() Then
			Self.current_frame:+1
			Self.last_frame_change:+Self.speed
			
			If Self.current_frame >= Self.image.frames.length Then
				Self.current_frame = 0
			End If
		End If
	End Method
End Type

'########################################################################################
'###########################                  ###########################################
'########################### BOX Burnable Typ ###########################################
'###########################                  ###########################################
'########################################################################################

Type TBox_Burnable_Typ Extends TBox_Typ
	'Field image:TImage
	
	Field image_burnable:TImage
	
	Rem
	Field name:String
	
	Field image_x1:Int
	Field image_x2:Int
	Field dx:Int
	
	Field image_y1:Int
	Field image_y2:Int
	Field dy:Int
	End Rem
	
	'Field speed:Int
	
	Field speed_burning:Int
	
	Rem
	Field last_frame_change:Int
	Field current_frame:Int
	End Rem
	
	Function Load:TBox_Burnable_Typ(name:String)
		Local bt:TBox_Burnable_Typ = New TBox_Burnable_Typ
		
		Print "loading burnable_box: " + name
		
		bt.name = name
		
		Local gfx_map:TMap = DATA_FILE_HANDLER.Load("Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\image.ini")
		
		If Not gfx_map Then
			GAME_ERROR_HANDLER.error("burnable_box -> load -> ini -> map is not loaded! Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_x1") Then'image_x1
			bt.image_x1 = Int(String(gfx_map.ValueForKey("image_x1")))
		Else
			GAME_ERROR_HANDLER.error("burnable_box -> load -> ini -> image_x1 not found! Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_x2") Then'image_x2
			bt.image_x2 = Int(String(gfx_map.ValueForKey("image_x2")))
		Else
			GAME_ERROR_HANDLER.error("burnable_box -> load -> ini -> image_x2 not found! Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_y1") Then'image_y1
			bt.image_y1 = Int(String(gfx_map.ValueForKey("image_y1")))
		Else
			GAME_ERROR_HANDLER.error("burnable_box -> load -> ini -> image_y1 not found! Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_y2") Then'image_y2
			bt.image_y2 = Int(String(gfx_map.ValueForKey("image_y2")))
		Else
			GAME_ERROR_HANDLER.error("burnable_box -> load -> ini -> image_y2 not found! Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_dx") Then'image_dx
			bt.dx = Int(String(gfx_map.ValueForKey("image_dx")))
		Else
			GAME_ERROR_HANDLER.error("burnable_box -> load -> ini -> image_dx not found! Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_dy") Then'image_dy
			bt.dy = Int(String(gfx_map.ValueForKey("image_dy")))
		Else
			GAME_ERROR_HANDLER.error("burnable_box -> load -> ini -> image_dy not found! Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\image.ini")
			Return Null
		End If
		
		
		If gfx_map.contains("image_speed") Then'image_speed
			bt.speed = Int(String(gfx_map.ValueForKey("image_speed")))
		Else
			GAME_ERROR_HANDLER.error("burnable_box -> load -> ini -> image_speed not found! Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("burning_speed") Then'burning_speed
			bt.speed_burning = Int(String(gfx_map.ValueForKey("burning_speed")))
		Else
			GAME_ERROR_HANDLER.error("burnable_box -> load -> ini -> burning_speed not found! Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\image.ini")
			Return Null
		End If
		
		
		'load normal image
		bt.image = LoadImage("Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\image.png")'loading image
		
		If Not bt.image Then
			GAME_ERROR_HANDLER.error("burnable_box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\image.png")
			Return Null
		End If
		
		If bt.image.width >= 2*(bt.image_x1 + bt.dx + bt.image_x2) Then'loading if anim image
			bt.image = LoadAnimImage("Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\image.png", (bt.image_x1 + bt.dx + bt.image_x2), (bt.image_y1 + bt.dy + bt.image_y2), 0, bt.image.width/(bt.image_x1 + bt.dx + bt.image_x2))
		End If
		
		If Not bt.image Then'check again
			GAME_ERROR_HANDLER.error("burnable_box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\image.png")
			Return Null
		End If
		
		SetImageHandle(bt.image, bt.image_x1, bt.image_y1)
		
		
		'load burn image
		bt.image_burnable = LoadImage("Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\burning.png")'loading image
		
		If Not bt.image_burnable Then
			GAME_ERROR_HANDLER.error("burnable_box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\burning.png")
			Return Null
		End If
		
		If bt.image_burnable.width >= 2*(bt.image_x1 + bt.dx + bt.image_x2) Then'loading if anim image
			bt.image_burnable = LoadAnimImage("Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\burning.png", (bt.image_x1 + bt.dx + bt.image_x2), (bt.image_y1 + bt.dy + bt.image_y2), 0, bt.image_burnable.width/(bt.image_x1 + bt.dx + bt.image_x2))
		End If
		
		If Not bt.image_burnable Then'check again
			GAME_ERROR_HANDLER.error("burnable_box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\burning.png")
			Return Null
		End If
		
		SetImageHandle(bt.image_burnable, bt.image_x1, bt.image_y1)
		
		bt.last_frame_change = MilliSecs()
		
		Return bt
	End Function
	
	Method turn:TBox_Burnable_Typ(rotation:Int)
		Local bt:TBox_Burnable_Typ = New TBox_Burnable_Typ
		
		bt.name = Self.name
		
		bt.speed = Self.speed
		
		bt.speed_burning = Self.speed_burning
		
		bt.image = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\burnable_box\" + Self.name + "\image.png", (Self.image_x1 + Self.dx + Self.image_x2), (Self.image_y1 + Self.dy + Self.image_y2))
		
		bt.image_burnable = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\burnable_box\" + Self.name + "\burning.png", (Self.image_x1 + Self.dx + Self.image_x2), (Self.image_y1 + Self.dy + Self.image_y2))
		
		Select rotation
			Case 0'-----------------------------------------------
				bt.image_x1 = Self.image_x1
				
				bt.image_x2 = Self.image_x2
				
				bt.image_y1 = Self.image_y1
				
				bt.image_y2 = Self.image_y2
				
				bt.dx = Self.dx
				
				bt.dy = Self.dy
				
				SetImageHandle(bt.image, bt.image_x1, bt.image_y1)
				SetImageHandle(bt.image_burnable, bt.image_x1, bt.image_y1)
			Case 1'-----------------------------------------------
				bt.image_x1 = Self.image_y1
				
				bt.image_x2 = Self.image_y2
				
				bt.image_y1 = Self.image_x2
				
				bt.image_y2 = Self.image_x1
				
				bt.dx = Self.dy
				
				bt.dy = Self.dx
				
				SetImageHandle(bt.image, Self.image_x1, Self.image_y1+Self.dy)
				SetImageHandle(bt.image_burnable, Self.image_x1, Self.image_y1+Self.dy)
			Case 2'-----------------------------------------------
				bt.image_x1 = Self.image_x2
				
				bt.image_x2 = Self.image_x1
				
				bt.image_y1 = Self.image_y2
				
				bt.image_y2 = Self.image_y1
				
				bt.dx = Self.dx
				
				bt.dy = Self.dy
				
				SetImageHandle(bt.image, Self.image_x1+Self.dx, Self.image_y1+Self.dy)
				SetImageHandle(bt.image_burnable, Self.image_x1+Self.dx, Self.image_y1+Self.dy)
			Case 3'-----------------------------------------------
				bt.image_x1 = Self.image_y2
				
				bt.image_x2 = Self.image_y1
				
				bt.image_y1 = Self.image_x1
				
				bt.image_y2 = Self.image_x2
				
				bt.dx = Self.dy
				
				bt.dy = Self.dx
				
				SetImageHandle(bt.image, Self.image_x1+Self.dx, Self.image_y1)
				SetImageHandle(bt.image_burnable, Self.image_x1+Self.dx, Self.image_y1)
		End Select
		
		
		bt.last_frame_change = MilliSecs()
		
		Return bt
	End Method
	
	Method render_animation()
		If Self.last_frame_change + Self.speed < MilliSecs() Then
			Self.current_frame:+1
			Self.last_frame_change:+Self.speed
			
			If Self.current_frame >= Self.image.frames.length Then
				Self.current_frame = 0
			End If
		End If
	End Method
End Type

'########################################################################################
'###########################                  ###########################################
'###########################  BOX Stone Typ   ###########################################
'###########################                  ###########################################
'########################################################################################

Type TBox_Stone_Typ Extends TBox_Typ
	
	Field image_breaking:TImage
	
	Field speed_breaking:Int
	
	Function Load:TBox_Stone_Typ(name:String)
		Local bt:TBox_Stone_Typ = New TBox_Stone_Typ
		
		Print "loading stone_box: " + name
		
		bt.name = name
		
		Local gfx_map:TMap = DATA_FILE_HANDLER.Load("Worlds\" + GAME.world.name + "\Objects\stone_box\" + name + "\image.ini")
		
		If Not gfx_map Then
			GAME_ERROR_HANDLER.error("stone_box -> load -> ini -> map is not loaded! Worlds\" + GAME.world.name + "\Objects\stone_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_x1") Then'image_x1
			bt.image_x1 = Int(String(gfx_map.ValueForKey("image_x1")))
		Else
			GAME_ERROR_HANDLER.error("stone_box -> load -> ini -> image_x1 not found! Worlds\" + GAME.world.name + "\Objects\stone_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_x2") Then'image_x2
			bt.image_x2 = Int(String(gfx_map.ValueForKey("image_x2")))
		Else
			GAME_ERROR_HANDLER.error("stone_box -> load -> ini -> image_x2 not found! Worlds\" + GAME.world.name + "\Objects\stone_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_y1") Then'image_y1
			bt.image_y1 = Int(String(gfx_map.ValueForKey("image_y1")))
		Else
			GAME_ERROR_HANDLER.error("stone_box -> load -> ini -> image_y1 not found! Worlds\" + GAME.world.name + "\Objects\stone_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_y2") Then'image_y2
			bt.image_y2 = Int(String(gfx_map.ValueForKey("image_y2")))
		Else
			GAME_ERROR_HANDLER.error("stone_box -> load -> ini -> image_y2 not found! Worlds\" + GAME.world.name + "\Objects\stone_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_dx") Then'image_dx
			bt.dx = Int(String(gfx_map.ValueForKey("image_dx")))
		Else
			GAME_ERROR_HANDLER.error("stone_box -> load -> ini -> image_dx not found! Worlds\" + GAME.world.name + "\Objects\stone_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_dy") Then'image_dy
			bt.dy = Int(String(gfx_map.ValueForKey("image_dy")))
		Else
			GAME_ERROR_HANDLER.error("stone_box -> load -> ini -> image_dy not found! Worlds\" + GAME.world.name + "\Objects\stone_box\" + name + "\image.ini")
			Return Null
		End If
		
		
		If gfx_map.contains("image_speed") Then'image_speed
			bt.speed = Int(String(gfx_map.ValueForKey("image_speed")))
		Else
			GAME_ERROR_HANDLER.error("stone_box -> load -> ini -> image_speed not found! Worlds\" + GAME.world.name + "\Objects\stone_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("breaking_speed") Then'burning_speed
			bt.speed_breaking = Int(String(gfx_map.ValueForKey("breaking_speed")))
		Else
			GAME_ERROR_HANDLER.error("stone_box -> load -> ini -> breaking_speed not found! Worlds\" + GAME.world.name + "\Objects\stone_box\" + name + "\image.ini")
			Return Null
		End If
		
		
		'load normal image
		bt.image = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\stone_box\" + name + "\image.png", (bt.image_x1 + bt.dx + bt.image_x2), (bt.image_y1 + bt.dy + bt.image_y2))
		
		SetImageHandle(bt.image, bt.image_x1, bt.image_y1)
		
		
		'load break image
		bt.image_breaking = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\stone_box\" + name + "\breaking.png", (bt.image_x1 + bt.dx + bt.image_x2), (bt.image_y1 + bt.dy + bt.image_y2))
		
		SetImageHandle(bt.image_breaking, bt.image_x1, bt.image_y1)
		
		bt.last_frame_change = MilliSecs()
		
		Return bt
	End Function
	
	Method turn:TBox_Stone_Typ(rotation:Int)
		Local bt:TBox_Stone_Typ = New TBox_Stone_Typ
		
		bt.name = Self.name
		
		bt.speed = Self.speed
		
		bt.speed_breaking = Self.speed_breaking
		
		bt.image = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\stone_box\" + name + "\image.png", (Self.image_x1 + Self.dx + Self.image_x2), (Self.image_y1 + Self.dy + Self.image_y2))
		
		bt.image_breaking = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\stone_box\" + name + "\breaking.png", (Self.image_x1 + Self.dx + Self.image_x2), (Self.image_y1 + Self.dy + Self.image_y2))
		
		Select rotation
			Case 0'-----------------------------------------------
				bt.image_x1 = Self.image_x1
				
				bt.image_x2 = Self.image_x2
				
				bt.image_y1 = Self.image_y1
				
				bt.image_y2 = Self.image_y2
				
				bt.dx = Self.dx
				
				bt.dy = Self.dy
				
				SetImageHandle(bt.image, bt.image_x1, bt.image_y1)
				SetImageHandle(bt.image_breaking, bt.image_x1, bt.image_y1)
			Case 1'-----------------------------------------------
				bt.image_x1 = Self.image_y1
				
				bt.image_x2 = Self.image_y2
				
				bt.image_y1 = Self.image_x2
				
				bt.image_y2 = Self.image_x1
				
				bt.dx = Self.dy
				
				bt.dy = Self.dx
				
				SetImageHandle(bt.image, Self.image_x1, Self.image_y1+Self.dy)
				SetImageHandle(bt.image_breaking, Self.image_x1, Self.image_y1+Self.dy)
			Case 2'-----------------------------------------------
				bt.image_x1 = Self.image_x2
				
				bt.image_x2 = Self.image_x1
				
				bt.image_y1 = Self.image_y2
				
				bt.image_y2 = Self.image_y1
				
				bt.dx = Self.dx
				
				bt.dy = Self.dy
				
				SetImageHandle(bt.image, Self.image_x1+Self.dx, Self.image_y1+Self.dy)
				SetImageHandle(bt.image_breaking, Self.image_x1+Self.dx, Self.image_y1+Self.dy)
			Case 3'-----------------------------------------------
				bt.image_x1 = Self.image_y2
				
				bt.image_x2 = Self.image_y1
				
				bt.image_y1 = Self.image_x1
				
				bt.image_y2 = Self.image_x2
				
				bt.dx = Self.dy
				
				bt.dy = Self.dx
				
				SetImageHandle(bt.image, Self.image_x1+Self.dx, Self.image_y1)
				SetImageHandle(bt.image_breaking, Self.image_x1+Self.dx, Self.image_y1)
		End Select
		
		
		bt.last_frame_change = MilliSecs()
		
		Return bt
	End Method
	
	Method render_animation()
		If Self.last_frame_change + Self.speed < MilliSecs() Then
			Self.current_frame:+1
			Self.last_frame_change:+Self.speed
			
			If Self.current_frame >= Self.image.frames.length Then
				Self.current_frame = 0
			End If
		End If
	End Method
End Type


'########################################################################################
'###########################                  ###########################################
'###########################   BOX Key Typ    ###########################################
'###########################                  ###########################################
'########################################################################################

Type TBox_Key_Typ Extends TBox_Typ
	'Field image:TImage
	
	Field image_opened:TImage
	Field image_opened_speed:Int
	
	Field image_closed:TImage
	Field image_closed_speed:Int
	
	Function Load:TBox_Key_Typ(name:String)
		Local bt:TBox_Key_Typ = New TBox_Key_Typ
		
		Print "loading key_box: " + name
		
		bt.name = name
		
		
		Local gfx_map:TMap = DATA_FILE_HANDLER.Load("Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\image.ini")
		
		If Not gfx_map Then
			GAME_ERROR_HANDLER.error("key_box -> load -> ini -> map is not loaded! Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\image.ini")
			Return Null
		End If
		
		
		If gfx_map.contains("image_x1") Then'image_x1
			bt.image_x1 = Int(String(gfx_map.ValueForKey("image_x1")))
		Else
			GAME_ERROR_HANDLER.error("key_box -> load -> ini -> image_x1 not found! Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_x2") Then'image_x2
			bt.image_x2 = Int(String(gfx_map.ValueForKey("image_x2")))
		Else
			GAME_ERROR_HANDLER.error("key_box -> load -> ini -> image_x2 not found! Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_y1") Then'image_y1
			bt.image_y1 = Int(String(gfx_map.ValueForKey("image_y1")))
		Else
			GAME_ERROR_HANDLER.error("key_box -> load -> ini -> image_y1 not found! Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_y2") Then'image_y2
			bt.image_y2 = Int(String(gfx_map.ValueForKey("image_y2")))
		Else
			GAME_ERROR_HANDLER.error("key_box -> load -> ini -> image_y2 not found! Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_dx") Then'image_dx
			bt.dx = Int(String(gfx_map.ValueForKey("image_dx")))
		Else
			GAME_ERROR_HANDLER.error("key_box -> load -> ini -> image_dx not found! Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_dy") Then'image_dy
			bt.dy = Int(String(gfx_map.ValueForKey("image_dy")))
		Else
			GAME_ERROR_HANDLER.error("key_box -> load -> ini -> image_dy not found! Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\image.ini")
			Return Null
		End If
		
		
		
		
		If gfx_map.contains("image_opened_speed") Then'image_opened_speed
			bt.image_opened_speed = Int(String(gfx_map.ValueForKey("image_opened_speed")))
		Else
			GAME_ERROR_HANDLER.error("key_box -> load -> ini -> image_opened_speed not found! Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\image.ini")
			Return Null
		End If
		
		
		If gfx_map.contains("image_closed_speed") Then'image_closed_speed
			bt.image_closed_speed = Int(String(gfx_map.ValueForKey("image_closed_speed")))
		Else
			GAME_ERROR_HANDLER.error("key_box -> load -> ini -> image_closed_speed not found! Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\image.ini")
			Return Null
		End If
		
		
		
		' --------------   load image_opened
		bt.image_opened = LoadImage("Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\opened.png")'loading image
		
		If Not bt.image_opened Then
			GAME_ERROR_HANDLER.error("key_box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\opened.png")
			Return Null
		End If
		
		If bt.image_opened.width >= 2*(bt.image_x1 + bt.dx + bt.image_x2) Then'loading if anim image
			bt.image_opened = LoadAnimImage("Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\opened.png", (bt.image_x1 + bt.dx + bt.image_x2), (bt.image_y1 + bt.dy + bt.image_y2), 0, bt.image_opened.width/(bt.image_x1 + bt.dx + bt.image_x2))
		End If
		
		If Not bt.image_opened Then'check again
			GAME_ERROR_HANDLER.error("key_box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\opened.png")
			Return Null
		End If
		
		SetImageHandle(bt.image_opened, bt.image_x1, bt.image_y1)
				
		
		' --------------   load image_closed
		bt.image_closed = LoadImage("Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\closed.png")'loading image
		
		If Not bt.image_closed Then
			GAME_ERROR_HANDLER.error("key_box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\closed.png")
			Return Null
		End If
		
		If bt.image_closed.width >= 2*(bt.image_x1 + bt.dx + bt.image_x2) Then'loading if anim image
			bt.image_closed = LoadAnimImage("Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\closed.png", (bt.image_x1 + bt.dx + bt.image_x2), (bt.image_y1 + bt.dy + bt.image_y2), 0, bt.image_closed.width/(bt.image_x1 + bt.dx + bt.image_x2))
		End If
		
		If Not bt.image_closed Then'check again
			GAME_ERROR_HANDLER.error("key_box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\closed.png")
			Return Null
		End If
		
		SetImageHandle(bt.image_closed, bt.image_x1, bt.image_y1)
		
		
		bt.last_frame_change = MilliSecs()
		
		Return bt
	End Function
	
	Method turn:TBox_Key_Typ(rotation:Int)
		Local bt:TBox_Key_Typ = New TBox_Key_Typ
		
		bt.name = Self.name
		
		bt.speed = Self.speed
		
		bt.image_opened_speed = Self.image_opened_speed
		
		bt.image_closed_speed = Self.image_closed_speed
		
		bt.image_opened = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\opened.png", (Self.image_x1 + Self.dx + Self.image_x2), (Self.image_y1 + Self.dy + Self.image_y2))
		
		bt.image_closed = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\key_box\" + name + "\closed.png", (Self.image_x1 + Self.dx + Self.image_x2), (Self.image_y1 + Self.dy + Self.image_y2))
		
		Select rotation
			Case 0'-----------------------------------------------
				bt.image_x1 = Self.image_x1
				
				bt.image_x2 = Self.image_x2
				
				bt.image_y1 = Self.image_y1
				
				bt.image_y2 = Self.image_y2
				
				bt.dx = Self.dx
				
				bt.dy = Self.dy
				
				SetImageHandle(bt.image_opened, bt.image_x1, bt.image_y1)
				SetImageHandle(bt.image_closed, bt.image_x1, bt.image_y1)
			Case 1'-----------------------------------------------
				bt.image_x1 = Self.image_y1
				
				bt.image_x2 = Self.image_y2
				
				bt.image_y1 = Self.image_x2
				
				bt.image_y2 = Self.image_x1
				
				bt.dx = Self.dy
				
				bt.dy = Self.dx
				
				SetImageHandle(bt.image_opened, Self.image_x1, Self.image_y1+Self.dy)
				SetImageHandle(bt.image_closed, Self.image_x1, Self.image_y1+Self.dy)
			Case 2'-----------------------------------------------
				bt.image_x1 = Self.image_x2
				
				bt.image_x2 = Self.image_x1
				
				bt.image_y1 = Self.image_y2
				
				bt.image_y2 = Self.image_y1
				
				bt.dx = Self.dx
				
				bt.dy = Self.dy
				
				SetImageHandle(bt.image_opened, Self.image_x1+Self.dx, Self.image_y1+Self.dy)
				SetImageHandle(bt.image_closed, Self.image_x1+Self.dx, Self.image_y1+Self.dy)
			Case 3'-----------------------------------------------
				bt.image_x1 = Self.image_y2
				
				bt.image_x2 = Self.image_y1
				
				bt.image_y1 = Self.image_x1
				
				bt.image_y2 = Self.image_x2
				
				bt.dx = Self.dy
				
				bt.dy = Self.dx
				
				SetImageHandle(bt.image_opened, Self.image_x1+Self.dx, Self.image_y1)
				SetImageHandle(bt.image_closed, Self.image_x1+Self.dx, Self.image_y1)
		End Select
		
		
		bt.last_frame_change = MilliSecs()
		
		Return bt
	End Method
	
	Method render_animation()
		
	End Method
	
End Type



'########################################################################################
'###########################                  ###########################################
'###########################   BOX Door Typ   ###########################################
'###########################                  ###########################################
'########################################################################################

Type TBox_Door_Typ Extends TBox_Typ
	'Field image:TImage
	
	Field image_opened:TImage
	Field image_opened_speed:Int
	
	Field image_opening:TImage
	Field image_opening_speed:Int
	
	Field image_closed:TImage
	Field image_closed_speed:Int
	
	Field image_closing:TImage
	Field image_closing_speed:Int
	
	Function Load:TBox_Door_Typ(name:String)
		Local bt:TBox_Door_Typ = New TBox_Door_Typ
		
		Print "loading door_box: " + name
		
		bt.name = name
		
		
		Local gfx_map:TMap = DATA_FILE_HANDLER.Load("Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\image.ini")
		
		If Not gfx_map Then
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> map is not loaded! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\image.ini")
			Return Null
		End If
		
		
		If gfx_map.contains("image_x1") Then'image_x1
			bt.image_x1 = Int(String(gfx_map.ValueForKey("image_x1")))
		Else
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image_x1 not found! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_x2") Then'image_x2
			bt.image_x2 = Int(String(gfx_map.ValueForKey("image_x2")))
		Else
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image_x2 not found! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_y1") Then'image_y1
			bt.image_y1 = Int(String(gfx_map.ValueForKey("image_y1")))
		Else
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image_y1 not found! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_y2") Then'image_y2
			bt.image_y2 = Int(String(gfx_map.ValueForKey("image_y2")))
		Else
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image_y2 not found! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_dx") Then'image_dx
			bt.dx = Int(String(gfx_map.ValueForKey("image_dx")))
		Else
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image_dx not found! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\image.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_dy") Then'image_dy
			bt.dy = Int(String(gfx_map.ValueForKey("image_dy")))
		Else
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image_dy not found! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\image.ini")
			Return Null
		End If
		
		
		
		
		If gfx_map.contains("image_opened_speed") Then'image_opened_speed
			bt.image_opened_speed = Int(String(gfx_map.ValueForKey("image_opened_speed")))
		Else
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image_opened_speed not found! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\image.ini")
			Return Null
		End If
		
		
		If gfx_map.contains("image_opening_speed") Then'image_opening_speed
			bt.image_opening_speed = Int(String(gfx_map.ValueForKey("image_opening_speed")))
		Else
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image_opening_speed not found! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\image.ini")
			Return Null
		End If
		
		
		If gfx_map.contains("image_closed_speed") Then'image_closed_speed
			bt.image_closed_speed = Int(String(gfx_map.ValueForKey("image_closed_speed")))
		Else
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image_closed_speed not found! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\image.ini")
			Return Null
		End If
		
		
		If gfx_map.contains("image_closing_speed") Then'image_closing_speed
			bt.image_closing_speed = Int(String(gfx_map.ValueForKey("image_closing_speed")))
		Else
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image_closing_speed not found! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\image.ini")
			Return Null
		End If
		
		
		' --------------   load image_opened
		bt.image_opened = LoadImage("Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\opened.png")'loading image
		
		If Not bt.image_opened Then
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\opened.png")
			Return Null
		End If
		
		If bt.image_opened.width >= 2*(bt.image_x1 + bt.dx + bt.image_x2) Then'loading if anim image
			bt.image_opened = LoadAnimImage("Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\opened.png", (bt.image_x1 + bt.dx + bt.image_x2), (bt.image_y1 + bt.dy + bt.image_y2), 0, bt.image_opened.width/(bt.image_x1 + bt.dx + bt.image_x2))
		End If
		
		If Not bt.image_opened Then'check again
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\opened.png")
			Return Null
		End If
		
		SetImageHandle(bt.image_opened, bt.image_x1, bt.image_y1)
		
		
		' --------------   load image_opening
		bt.image_opening = LoadImage("Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\opening.png")'loading image
		
		If Not bt.image_opening Then
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\opening.png")
			Return Null
		End If
		
		If bt.image_opening.width >= 2*(bt.image_x1 + bt.dx + bt.image_x2) Then'loading if anim image
			bt.image_opening = LoadAnimImage("Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\opening.png", (bt.image_x1 + bt.dx + bt.image_x2), (bt.image_y1 + bt.dy + bt.image_y2), 0, bt.image_opening.width/(bt.image_x1 + bt.dx + bt.image_x2))
		End If
		
		If Not bt.image_opening Then'check again
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\opening.png")
			Return Null
		End If
		
		SetImageHandle(bt.image_opening , bt.image_x1, bt.image_y1)
		
		
		' --------------   load image_closed
		bt.image_closed = LoadImage("Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\closed.png")'loading image
		
		If Not bt.image_closed Then
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\closed.png")
			Return Null
		End If
		
		If bt.image_closed.width >= 2*(bt.image_x1 + bt.dx + bt.image_x2) Then'loading if anim image
			bt.image_closed = LoadAnimImage("Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\closed.png", (bt.image_x1 + bt.dx + bt.image_x2), (bt.image_y1 + bt.dy + bt.image_y2), 0, bt.image_closed.width/(bt.image_x1 + bt.dx + bt.image_x2))
		End If
		
		If Not bt.image_closed Then'check again
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\closed.png")
			Return Null
		End If
		
		SetImageHandle(bt.image_closed, bt.image_x1, bt.image_y1)
		
		
		
		
		' --------------   load image_closing
		bt.image_closing = LoadImage("Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\closing.png")'loading image
		
		If Not bt.image_closing Then
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\closing.png")
			Return Null
		End If
		
		If bt.image_closing.width >= 2*(bt.image_x1 + bt.dx + bt.image_x2) Then'loading if anim image
			bt.image_closing = LoadAnimImage("Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\closing.png", (bt.image_x1 + bt.dx + bt.image_x2), (bt.image_y1 + bt.dy + bt.image_y2), 0, bt.image_closing.width/(bt.image_x1 + bt.dx + bt.image_x2))
		End If
		
		If Not bt.image_closing Then'check again
			GAME_ERROR_HANDLER.error("door_box -> load -> ini -> image could not be loaded! Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\closing.png")
			Return Null
		End If
		
		SetImageHandle(bt.image_closing, bt.image_x1, bt.image_y1)
		
		
		bt.last_frame_change = MilliSecs()
		
		Return bt
	End Function
	
	Method turn:TBox_Door_Typ(rotation:Int)
		Local bt:TBox_Door_Typ = New TBox_Door_Typ
		
		bt.name = Self.name
		
		bt.speed = Self.speed
		
		bt.image_opened_speed = Self.image_opened_speed
		
		bt.image_opening_speed = Self.image_opening_speed
		
		bt.image_closed_speed = Self.image_closed_speed
		
		bt.image_closing_speed = Self.image_closing_speed
		
		bt.image_opened = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\opened.png", (Self.image_x1 + Self.dx + Self.image_x2), (Self.image_y1 + Self.dy + Self.image_y2))
		bt.image_opening = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\opening.png", (Self.image_x1 + Self.dx + Self.image_x2), (Self.image_y1 + Self.dy + Self.image_y2))
		
		bt.image_closed = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\closed.png", (Self.image_x1 + Self.dx + Self.image_x2), (Self.image_y1 + Self.dy + Self.image_y2))
		bt.image_closing = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\door_box\" + name + "\closing.png", (Self.image_x1 + Self.dx + Self.image_x2), (Self.image_y1 + Self.dy + Self.image_y2))
		
		Select rotation
			Case 0'-----------------------------------------------
				bt.image_x1 = Self.image_x1
				
				bt.image_x2 = Self.image_x2
				
				bt.image_y1 = Self.image_y1
				
				bt.image_y2 = Self.image_y2
				
				bt.dx = Self.dx
				
				bt.dy = Self.dy
				
				SetImageHandle(bt.image_opened, bt.image_x1, bt.image_y1)
				SetImageHandle(bt.image_opening, bt.image_x1, bt.image_y1)
				SetImageHandle(bt.image_closed, bt.image_x1, bt.image_y1)
				SetImageHandle(bt.image_closing, bt.image_x1, bt.image_y1)
			Case 1'-----------------------------------------------
				bt.image_x1 = Self.image_y1
				
				bt.image_x2 = Self.image_y2
				
				bt.image_y1 = Self.image_x2
				
				bt.image_y2 = Self.image_x1
				
				bt.dx = Self.dy
				
				bt.dy = Self.dx
				
				SetImageHandle(bt.image_opened, Self.image_x1, Self.image_y1+Self.dy)
				SetImageHandle(bt.image_opening, Self.image_x1, Self.image_y1+Self.dy)
				SetImageHandle(bt.image_closed, Self.image_x1, Self.image_y1+Self.dy)
				SetImageHandle(bt.image_closing, Self.image_x1, Self.image_y1+Self.dy)
			Case 2'-----------------------------------------------
				bt.image_x1 = Self.image_x2
				
				bt.image_x2 = Self.image_x1
				
				bt.image_y1 = Self.image_y2
				
				bt.image_y2 = Self.image_y1
				
				bt.dx = Self.dx
				
				bt.dy = Self.dy
				
				SetImageHandle(bt.image_opened, Self.image_x1+Self.dx, Self.image_y1+Self.dy)
				SetImageHandle(bt.image_opening, Self.image_x1+Self.dx, Self.image_y1+Self.dy)
				SetImageHandle(bt.image_closed, Self.image_x1+Self.dx, Self.image_y1+Self.dy)
				SetImageHandle(bt.image_closing, Self.image_x1+Self.dx, Self.image_y1+Self.dy)
			Case 3'-----------------------------------------------
				bt.image_x1 = Self.image_y2
				
				bt.image_x2 = Self.image_y1
				
				bt.image_y1 = Self.image_x1
				
				bt.image_y2 = Self.image_x2
				
				bt.dx = Self.dy
				
				bt.dy = Self.dx
				
				SetImageHandle(bt.image_opened, Self.image_x1+Self.dx, Self.image_y1)
				SetImageHandle(bt.image_opening, Self.image_x1+Self.dx, Self.image_y1)
				SetImageHandle(bt.image_closed, Self.image_x1+Self.dx, Self.image_y1)
				SetImageHandle(bt.image_closing, Self.image_x1+Self.dx, Self.image_y1)
		End Select
		
		
		bt.last_frame_change = MilliSecs()
		
		Return bt
	End Method
	
	
	Method render_animation()
		Rem
		If Self.last_frame_change + Self.speed < MilliSecs() Then
			Self.current_frame:+1
			Self.last_frame_change:+Self.speed
			
			If Self.current_frame >= Self.image.frames.length Then
				Self.current_frame = 0
			End If
		End If
		End Rem
	End Method
	
End Type



'########################################################################################
'###########################              ###############################################
'########################### Box Renderer ###############################################
'###########################              ###############################################
'########################################################################################

Type TBox_Renderer'the normal is just collision box
	Field name:String
	
	Function Create:TBox_Renderer()
		Local r:TBox_Renderer = New TBox_Renderer
		r.name = "renderer"
		Return r
	End Function
	
	Method copy:TBox_Renderer()
		Local r:TBox_Renderer = New TBox_Renderer
		
		r.name = Self.name
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
	End Method
End Type

'########################################################################################
'###########################                        #####################################
'###########################   Box Renderer Image   #####################################
'###########################                        #####################################
'########################################################################################

Type TBox_Renderer_Image Extends TBox_Renderer
	Function Create:TBox_Renderer()
		Local r:TBox_Renderer_Image = New TBox_Renderer_Image
		r.name = "Image"
		Return r
	End Function
	
	Field as_light:Int = 0
	
	Field light:TLight
	
	Method copy:TBox_Renderer_Image()
		Local r:TBox_Renderer_Image = New TBox_Renderer_Image
		
		r.name = Self.name
		
		r.as_light = Self.as_light
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
	End Method
End Type


'########################################################################################
'###########################                         ####################################
'########################### Box Renderer CheckPoint ####################################
'###########################                         ####################################
'########################################################################################

Type TBox_Renderer_CheckPoint Extends TBox_Renderer
	Function Create:TBox_Renderer()
		Local r:TBox_Renderer_CheckPoint = New TBox_Renderer_CheckPoint
		r.name = "CheckPoint"
		Return r
	End Function
	
	
	Method copy:TBox_Renderer_CheckPoint()
		Local r:TBox_Renderer_CheckPoint = New TBox_Renderer_CheckPoint
		
		r.name = Self.name
		
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		
		If b.mob_enters(m) And TPLAYER(m) Then
			
			GAME.world.act_level.save_running_level("check_point_save_"+INFO.get_computer_name())'INFO.get_computer_name
			'GAME.world.act_level = TLevel.load_saved_running_level("save_007")
			
		End If
		
	End Method
End Type

'########################################################################################
'###########################                         ####################################
'########################### Box Renderer CheckPoint ####################################
'###########################                         ####################################
'########################################################################################

Type TBox_Renderer_LevelCompleted Extends TBox_Renderer
	Function Create:TBox_Renderer()
		Local r:TBox_Renderer_LevelCompleted  = New TBox_Renderer_LevelCompleted 
		r.name = "LevelCompleted"
		Return r
	End Function
	
	
	Method copy:TBox_Renderer_LevelCompleted()
		Local r:TBox_Renderer_LevelCompleted = New TBox_Renderer_LevelCompleted
		
		r.name = Self.name
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		
		If b.mob_enters(m) And TPLAYER(m) Then
			
			TLevel.set_completed()
			
			Rem
			GAME.world.act_level.level_completed = 1
			
			If GAME.world.act_level_number >= GAME.world.highest_level_completed Then GAME.world.highest_level_completed:+1
			
			Local world_map:TMap = New TMap
			
			world_map.Insert("highest_level_completed", String(GAME.world.highest_level_completed))
			DATA_FILE_HANDLER.save(world_map, "Worlds\" + GAME.world.name + "\world.ini")
			End Rem
		End If
		
	End Method
End Type

'########################################################################################
'###########################                           ##################################
'########################### Box Renderer FireSurprise ##################################
'###########################                           ##################################
'########################################################################################

Type TBox_Renderer_FireSurprise Extends TBox_Renderer
	Function Create:TBox_Renderer()
		Local r:TBox_Renderer_FireSurprise = New TBox_Renderer_FireSurprise
		r.name = "FireSurprise"
		Return r
	End Function
	
	
	Method copy:TBox_Renderer_FireSurprise()
		Local r:TBox_Renderer_FireSurprise = New TBox_Renderer_FireSurprise
		
		r.name = Self.name
		
		Return r
	End Method
	
	
	Method render(b:TBox, m:TMob)
		If (b.mob_enters(m) Or b.mob_is_inside(m)) And TPLAYER(m) And b.var_on() Then
			
			Select b.rotation
				Case 0'^  Rnd()*2.0-1.0,-Rnd()*0.2-1.0
					For Local i:Int = 1 To 5*60.0/Graphics_Handler.FPS_MAX
						TPARTIKEL.Create(Rand(0,3), 1,  b.x + TBox.typs[b.typ,b.rotation].dx*0.5,b.y + TBox.typs[b.typ,b.rotation].dy,   Rnd()*2.0-1.0,-Rnd()*0.2-1.0,-0.1, Rnd()*360.0,Rnd()*4.0-2.0, Rnd()*1.0+2.0,Rnd()*0.5+0.5, 60)
					Next
				Case 1'>
					For Local i:Int = 1 To 5*60.0/Graphics_Handler.FPS_MAX
						TPARTIKEL.Create(Rand(0,3), 1,  b.x,b.y + TBox.typs[b.typ,b.rotation].dy*0.5,   Rnd()*2.0+2.0,Rnd()*2.0-1.0,-0.1, Rnd()*360.0,Rnd()*4.0-2.0, Rnd()*1.0+2.0,Rnd()*0.5+0.5, 60)
					Next
				Case 2'v
					For Local i:Int = 1 To 5*60.0/Graphics_Handler.FPS_MAX
						TPARTIKEL.Create(Rand(0,3), 1,  b.x + TBox.typs[b.typ,b.rotation].dx*0.5,b.y,   Rnd()*2.0-1.0,Rnd()*0.2+4.0,-0.1, Rnd()*360.0,Rnd()*4.0-2.0, Rnd()*1.0+2.0,Rnd()*0.5+0.5, 60)
					Next
				Case 3'<
					For Local i:Int = 1 To 5*60.0/Graphics_Handler.FPS_MAX
						TPARTIKEL.Create(Rand(0,3), 1,  b.x + TBox.typs[b.typ,b.rotation].dx,b.y + TBox.typs[b.typ,b.rotation].dy*0.5,   -Rnd()*2.0-2.0,Rnd()*2.0-1.0,-0.1, Rnd()*360.0,Rnd()*4.0-2.0, Rnd()*1.0+2.0,Rnd()*0.5+0.5, 60)
					Next
			End Select
			
			
			
			TPLAYER(m).set_mode(TPLAYER_MODE.modes[1])
			
		End If
	End Method
End Type

'########################################################################################
'###########################                           ##################################
'########################### Box Renderer ParticleFire ##################################
'###########################                           ##################################
'########################################################################################

Type TBox_Renderer_ParticleFire Extends TBox_Renderer
	Function Create:TBox_Renderer()
		Local r:TBox_Renderer_ParticleFire = New TBox_Renderer_ParticleFire
		r.name = "ParticleFire"
		Return r
	End Function
	
	Method copy:TBox_Renderer_ParticleFire()
		Local r:TBox_Renderer_ParticleFire = New TBox_Renderer_ParticleFire
		
		r.name = Self.name
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		
			
		
		Select b.rotation
			Case 0'^  Rnd()*2.0-1.0,-Rnd()*0.2-1.0
				For Local i:Int = 1 To 5*60.0/Graphics_Handler.FPS_MAX
					TPARTIKEL.Create(Rand(0,3), 1,  b.x + TBox.typs[b.typ,b.rotation].dx*0.5,b.y + TBox.typs[b.typ,b.rotation].dy,   Rnd()*2.0-1.0,-Rnd()*0.2-1.0,-0.1, Rnd()*360.0,Rnd()*4.0-2.0, Rnd()*1.0+2.0,Rnd()*0.5+0.5, 60)
				Next
			Case 1'>
				For Local i:Int = 1 To 5*60.0/Graphics_Handler.FPS_MAX
					TPARTIKEL.Create(Rand(0,3), 1,  b.x,b.y + TBox.typs[b.typ,b.rotation].dy*0.5,   Rnd()*2.0+2.0,Rnd()*2.0-1.0,-0.1, Rnd()*360.0,Rnd()*4.0-2.0, Rnd()*1.0+2.0,Rnd()*0.5+0.5, 60)
				Next
			Case 2'v
				For Local i:Int = 1 To 5*60.0/Graphics_Handler.FPS_MAX
					TPARTIKEL.Create(Rand(0,3), 1,  b.x + TBox.typs[b.typ,b.rotation].dx*0.5,b.y,   Rnd()*2.0-1.0,Rnd()*0.2+4.0,-0.1, Rnd()*360.0,Rnd()*4.0-2.0, Rnd()*1.0+2.0,Rnd()*0.5+0.5, 60)
				Next
			Case 3'<
				For Local i:Int = 1 To 5*60.0/Graphics_Handler.FPS_MAX
					TPARTIKEL.Create(Rand(0,3), 1,  b.x + TBox.typs[b.typ,b.rotation].dx,b.y + TBox.typs[b.typ,b.rotation].dy*0.5,   -Rnd()*2.0-2.0,Rnd()*2.0-1.0,-0.1, Rnd()*360.0,Rnd()*4.0-2.0, Rnd()*1.0+2.0,Rnd()*0.5+0.5, 60)
				Next
		End Select
		
		If (b.mob_enters(m) Or b.mob_is_inside(m)) Then
			TPLAYER(m).set_mode(TPLAYER_MODE.modes[1])
		End If
		
	End Method
End Type



'########################################################################################
'###########################                        #####################################
'########################### Box Renderer Collision #####################################
'###########################                        #####################################
'########################################################################################

Type TBox_Renderer_Collision Extends TBox_Renderer
	Function Create:TBox_Renderer()
		Local r:TBox_Renderer_Collision = New TBox_Renderer_Collision
		r.name = "collision"
		Return r
	End Function
	
	Method copy:TBox_Renderer_Collision()
		Local r:TBox_Renderer_Collision = New TBox_Renderer_Collision
		
		r.name = Self.name
		
		r.coll_down_on = Self.coll_down_on
		r.coll_up_on = Self.coll_up_on
		r.coll_r_on = Self.coll_r_on
		r.coll_l_on = Self.coll_l_on
		
		Return r
	End Method
	
	Field coll_down_on:Int = 1
	Field coll_up_on:Int = 1
	Field coll_r_on:Int = 1
	Field coll_l_on:Int = 1
	
	Method render(b:TBox, m:TMob)
		
		Select b.mob_enters(m)
			Case 1'r
				If Self.coll_r_on = 1 Then
					m.vx = b.x - (m.x + m.rx)
					m.coll_r = 1
				End If
			Case 2'l
				If Self.coll_l_on = 1 Then
					m.vx = (b.x + TBox.typs[b.typ,b.rotation].dx) - (m.x - m.rx)
					m.coll_l = 1
				End If
			Case 3'top
				If Self.coll_down_on = 1 Then
					m.vy = b.y - (m.y + m.ry)
					m.coll_ground = 1
				End If
			Case 4'bottom
				If Self.coll_up_on = 1 Then
					m.vy = (b.y + TBox.typs[b.typ,b.rotation].dy) - (m.y - m.ry)
					m.coll_up = 1
				End If
		End Select
		
	End Method
End Type

'########################################################################################
'###################                                       ##############################
'################### Box Renderer Collision_Mode_Sensitive ##############################
'###################                                       ##############################
'########################################################################################

Type TBox_Renderer_Collision_Mode_Sensitive Extends TBox_Renderer
	Function Create:TBox_Renderer()
		Local r:TBox_Renderer_Collision_Mode_Sensitive = New TBox_Renderer_Collision_Mode_Sensitive
		r.name = "Collision_Mode_Sensitive"
		Return r
	End Function
	
	
	Field coll_down_on:Int = 1
	Field coll_up_on:Int = 1
	Field coll_r_on:Int = 1
	Field coll_l_on:Int = 1
	
	Field mode_number:Int = 0
	Field invert:Int = 0
	
	Method copy:TBox_Renderer_Collision_Mode_Sensitive()
		Local r:TBox_Renderer_Collision_Mode_Sensitive = New TBox_Renderer_Collision_Mode_Sensitive
		
		r.name = Self.name
		
		r.coll_down_on = Self.coll_down_on
		r.coll_up_on = Self.coll_up_on
		r.coll_r_on = Self.coll_r_on
		r.coll_l_on = Self.coll_l_on
		
		r.mode_number = Self.mode_number
		r.invert = Self.invert
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		
		
		
		Local coll:Int = 0
		
		If TPLAYER(m) Then
			If TPLAYER(m).mode = TPLAYER_MODE.modes[Self.mode_number] Then
				If Self.invert = 0 Then coll = 1
			Else
				If Self.invert = 1 Then coll = 1
			End If
		End If
		
		If coll = 1 Then
			Select b.mob_enters(m)
				Case 1'r
					If Self.coll_r_on = 1 Then
						m.vx = b.x - (m.x + m.rx)
						m.coll_r = 1
					End If
				Case 2'l
					If Self.coll_l_on = 1 Then
						m.vx = (b.x + TBox.typs[b.typ,b.rotation].dx) - (m.x - m.rx)
						m.coll_l = 1
					End If
				Case 3'top
					If Self.coll_down_on = 1 Then
						m.vy = b.y - (m.y + m.ry)
						m.coll_ground = 1
					End If
				Case 4'bottom
					If Self.coll_up_on = 1 Then
						m.vy = (b.y + TBox.typs[b.typ,b.rotation].dy) - (m.y - m.ry)
						m.coll_up = 1
					End If
			End Select
		End If
	End Method
End Type


'########################################################################################
'###########################                        #####################################
'########################### Box Renderer Burnable  #####################################
'###########################                        #####################################
'########################################################################################

Type TBox_Renderer_Burnable Extends TBox_Renderer_Collision
	Function Create:TBox_Renderer()
		Local r:TBox_Renderer_Burnable = New TBox_Renderer_Burnable
		r.name = "burnable"
		Return r
	End Function
	
	Method copy:TBox_Renderer_Burnable()
		Local r:TBox_Renderer_Burnable = New TBox_Renderer_Burnable
		
		r.name = Self.name
		
		r.coll_down_on = Self.coll_down_on
		r.coll_up_on = Self.coll_up_on
		r.coll_r_on = Self.coll_r_on
		r.coll_l_on = Self.coll_l_on
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		
		
		
		If b.mob_enters(m) And TPLAYER(m) And TPLAYER(m).mode = TPLAYER_MODE.modes[1] Then
			TBox_Burnable(b).set_fire()
		End If
		
		
		
		Select b.mob_enters(m)
			Case 1'r
				If Self.coll_r_on = 1 Then
					m.vx = b.x - (m.x + m.rx)
					m.coll_r = 1
				End If
			Case 2'l
				If Self.coll_l_on = 1 Then
					m.vx = (b.x + TBox_Burnable.burnable_typs[b.typ,b.rotation].dx) - (m.x - m.rx)
					m.coll_l = 1
				End If
			Case 3'top
				If Self.coll_down_on = 1 Then
					m.vy = b.y - (m.y + m.ry)
					m.coll_ground = 1
				End If
			Case 4'bottom
				If Self.coll_up_on = 1 Then
					m.vy = (b.y + TBox_Burnable.burnable_typs[b.typ,b.rotation].dy) - (m.y - m.ry)
					m.coll_up = 1
				End If
		End Select
	End Method
End Type



'########################################################################################
'###########################                        #####################################
'###########################   Box Renderer Stone   #####################################
'###########################                        #####################################
'########################################################################################

Type TBox_Renderer_Stone Extends TBox_Renderer_Collision
	Function Create:TBox_Renderer()
		Local r:TBox_Renderer_Stone = New TBox_Renderer_Stone
		r.name = "stone"
		Return r
	End Function
	
	Method copy:TBox_Renderer_Stone()
		Local r:TBox_Renderer_Stone = New TBox_Renderer_Stone
		
		r.name = Self.name
		
		r.coll_down_on = Self.coll_down_on
		r.coll_up_on = Self.coll_up_on
		r.coll_r_on = Self.coll_r_on
		r.coll_l_on = Self.coll_l_on
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		Rem
		If b.mob_enters(m) And TPLAYER(m) And TPLAYER(m).mode = TPLAYER_MODE.modes[1] Then
			TBox_Burnable(b).set_fire()
		End If
		End Rem
		
		
		
		Select b.mob_enters(m)
			Case 1'r
				If Self.coll_r_on = 1 Then
					m.vx = b.x - (m.x + m.rx)
					m.coll_r = 1
				End If
			Case 2'l
				If Self.coll_l_on = 1 Then
					m.vx = (b.x + TBox_Stone.stone_typs[b.typ,b.rotation].dx) - (m.x - m.rx)
					m.coll_l = 1
				End If
			Case 3'top
				If Self.coll_down_on = 1 Then
					m.vy = b.y - (m.y + m.ry)
					m.coll_ground = 1
				End If
			Case 4'bottom
				If Self.coll_up_on = 1 Then
					m.vy = (b.y + TBox_Stone.stone_typs[b.typ,b.rotation].dy) - (m.y - m.ry)
					m.coll_up = 1
				End If
		End Select
	End Method
	
End Type




'########################################################################################
'###########################                              ###############################
'###########################        Box Renderer Key      ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_Key Extends TBox_Renderer
	Function Create:TBox_Renderer_Key()
		Local r:TBox_Renderer_Key = New TBox_Renderer_Key
		r.name = "Key"
		Return r
	End Function
	
	Field door_name:String = "key_" + Rand(10000)'sign_text_map
	
	Field controller_typ:Int
	
	Method copy:TBox_Renderer_Key()
		Local r:TBox_Renderer_Key = New TBox_Renderer_Key
		
		r.name = Self.name
		r.door_name = Self.door_name
		
		Return r
	End Method
	
	Field count_objects_inside:Int
	Field last_count_objects_inside:Int
	
	Method render(b:TBox, m:TMob)
		
		
		
		
		Select Self.controller_typ
			Case 0'Key
				
				If TPLAYER(m) Then
					If b.mob_is_inside(m) Then
						If TControls.activate.key.hit Then
							'TBox_Door.switch(Self.door_name)
							
							LEVEL_VARIABLES.set(Self.door_name, 1-Int(LEVEL_VARIABLES.get(Self.door_name)))
							
							'Sound_Handler.play("sch" + Rand(1,4),b.x)'open sound
							
							TSoundPlayer.run("sch" + Rand(1,4),m.x,m.y,m,100000)
						End If
					End If
				End If
				
				
			Case 1'Key_On
				If TPLAYER(m) Then
					If b.mob_is_inside(m) Then
						If TControls.activate.key.hit Then
							'TBox_Door.open(Self.door_name)
							
							LEVEL_VARIABLES.set(Self.door_name, "0")
							
							'Sound_Handler.play("sch" + Rand(1,4),b.x)'open sound
							
							TSoundPlayer.run("sch" + Rand(1,4),m.x,m.y,m,100000)
						End If
					End If
				End If
				
			Case 2'Key_Off
				If TPLAYER(m) Then
					If b.mob_is_inside(m) Then
						If TControls.activate.key.hit Then
							'TBox_Door.close(Self.door_name)
							
							LEVEL_VARIABLES.set(Self.door_name, "1")
							
							'Sound_Handler.play("sch" + Rand(1,4),b.x)'open sound
							
							TSoundPlayer.run("sch" + Rand(1,4),m.x,m.y,m,100000)
						End If
					End If
				End If
				
			Case 3'Button_On
				If b.mob_is_inside(m) Then
					'TBox_Door.open(Self.door_name)
					LEVEL_VARIABLES.set(Self.door_name, "0")
					
					Self.count_objects_inside:+1
				End If
			Case 4'Button_Off
				If b.mob_is_inside(m) Then
					'TBox_Door.close(Self.door_name)
					LEVEL_VARIABLES.set(Self.door_name, "1")
					
					Self.count_objects_inside:+1
				End If
			Case 5'Button_On_Player
				If TPLAYER(m) Then
					If b.mob_is_inside(m) Then
						'TBox_Door.open(Self.door_name)
						LEVEL_VARIABLES.set(Self.door_name, "0")
						
					Else
						'TBox_Door.close(Self.door_name)
						LEVEL_VARIABLES.set(Self.door_name, "1")
					End If
				End If
			Case 6'Button_Off_Player
				If TPLAYER(m) Then
					If b.mob_is_inside(m) Then
						'TBox_Door.close(Self.door_name)
						LEVEL_VARIABLES.set(Self.door_name, "1")
					Else
						'TBox_Door.open(Self.door_name)
						LEVEL_VARIABLES.set(Self.door_name, "0")
					End If
				End If
			Case 7'Area
				
				If b.mob_enters(m) Then
					'TBox_Door.switch(Self.door_name)
					LEVEL_VARIABLES.set(Self.door_name, 1-Int(LEVEL_VARIABLES.get(Self.door_name)))
				End If
				
			Case 8'Area_On
				
				If b.mob_enters(m) Then
					'TBox_Door.open(Self.door_name)
					LEVEL_VARIABLES.set(Self.door_name, "0")
				End If
				
			Case 9'Area_Off
				
				If b.mob_enters(m) Then
					'TBox_Door.close(Self.door_name)
					LEVEL_VARIABLES.set(Self.door_name, "1")
				End If
				
			Case 10'Area_Player
				If TPLAYER(m) Then
					If b.mob_enters(m) Then
						'TBox_Door.switch(Self.door_name)
						LEVEL_VARIABLES.set(Self.door_name, 1-Int(LEVEL_VARIABLES.get(Self.door_name)))
					End If
				End If
			Case 11'Area_On_Player
				If TPLAYER(m) Then
					If b.mob_enters(m) Then
						'TBox_Door.open(Self.door_name)
						LEVEL_VARIABLES.set(Self.door_name, "0")
					End If
				End If
			Case 12'Area_Off_Player
				If TPLAYER(m) Then
					If b.mob_enters(m) Then
						'TBox_Door.close(Self.door_name)
						LEVEL_VARIABLES.set(Self.door_name, "1")
					End If
				End If
		End Select
		
	End Method
	
End Type



'########################################################################################
'###########################                        #####################################
'###########################  Box Renderer Door     #####################################
'###########################                        #####################################
'########################################################################################

Type TBox_Renderer_Door Extends TBox_Renderer_Collision
	Function Create:TBox_Renderer()
		Local r:TBox_Renderer_Door = New TBox_Renderer_Door
		r.name = "door"
		Return r
	End Function
	
	Field status:Int=1' 1=closed, 0=opened,        ( 2=closing, 3=openin )
	
	Field door_name:String
	
	Field teleport_name:String
	
	Method copy:TBox_Renderer_Door()
		Local r:TBox_Renderer_Door = New TBox_Renderer_Door
		
		r.name = Self.name
		
		r.coll_down_on = Self.coll_down_on
		r.coll_up_on = Self.coll_up_on
		r.coll_r_on = Self.coll_r_on
		r.coll_l_on = Self.coll_l_on
		
		r.status = Self.status
		r.door_name = Self.door_name
		r.teleport_name = Self.teleport_name
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		
		
		
		If Self.status <> 0 Then
			
			Select b.mob_enters(m)
				Case 1'r
					If Self.coll_r_on = 1 Then
						m.vx = b.x - (m.x + m.rx)
						m.coll_r = 1
					End If
				Case 2'l
					If Self.coll_l_on = 1 Then
						m.vx = (b.x + TBox_Door.door_typs[b.typ,b.rotation].dx) - (m.x - m.rx)
						m.coll_l = 1
					End If
				Case 3'top
					If Self.coll_down_on = 1 Then
						m.vy = b.y - (m.y + m.ry)
						m.coll_ground = 1
					End If
				Case 4'bottom
					If Self.coll_up_on = 1 Then
						m.vy = (b.y + TBox_Door.door_typs[b.typ,b.rotation].dy) - (m.y - m.ry)
						m.coll_up = 1
					End If
			End Select
			
		Else
			
			If TPLAYER(m) And TControls.activate.key.hit Then
				
				
				If b.mob_is_inside(m) And Self.teleport_name<>"" Then
					
					TControls.activate.key.hit = 0
					
					Local l:TBox = TBox(GAME.world.act_level.location_map.ValueForKey(Self.teleport_name))
					
					If l Then
						
						TLevel.black_out()
						
						m.x = l.x
						m.y = l.y
						
						m.vx = 0
						m.vy = 0
						
						TPLAYER(m).set_mode_teleport()
						
						GAME.world.act_level.ansicht_ziel_x = - m.x + 400
						GAME.world.act_level.ansicht_ziel_y = - m.y + 300
						
						GAME.world.act_level.ansicht_act_x = GAME.world.act_level.ansicht_ziel_x
						GAME.world.act_level.ansicht_act_y = GAME.world.act_level.ansicht_ziel_y
						
						
						Print "teleport 1 with door!"
					Else
						Print "location not found: " + Self.teleport_name
					End If
				End If
				
			End If
			
		End If
		
	End Method
	
End Type


'########################################################################################
'###########################                              ###############################
'########################### Box Renderer Set Player Mode ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_Set_Player_Mode Extends TBox_Renderer
	Function Create:TBox_Renderer_Set_Player_Mode()
		Local r:TBox_Renderer_Set_Player_Mode = New TBox_Renderer_Set_Player_Mode
		r.name = "set_player_mode"
		Return r
	End Function
	
	Field mode_number:Int
	
	Method copy:TBox_Renderer_Set_Player_Mode()
		Local r:TBox_Renderer_Set_Player_Mode = New TBox_Renderer_Set_Player_Mode
		
		r.name = Self.name
		r.mode_number = Self.mode_number
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		
		
		If TPLAYER(m) Then
			If b.mob_enters(m) Or b.mob_is_inside(m) Then
				TPLAYER(m).set_mode(TPLAYER_MODE.modes[Self.mode_number])
			End If
		End If
	End Method
End Type

'########################################################################################
'###########################                              ###############################
'###########################    Box Renderer Death_Zone   ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_Death_Zone Extends TBox_Renderer
	Function Create:TBox_Renderer_Death_Zone()
		Local r:TBox_Renderer_Death_Zone = New TBox_Renderer_Death_Zone
		r.name = "Death_Zone"
		Return r
	End Function
	
	
	Field death_number:Int = 1
	
	Method copy:TBox_Renderer_Death_Zone()
		Local r:TBox_Renderer_Death_Zone = New TBox_Renderer_Death_Zone
		
		r.name = Self.name
		r.death_number = Self.death_number
		
		Return r
	End Method
	
	'Global deaths:String[] = ["mechanical", "poison", "burnt", "freeze", "suck the water"]
	
	' ["normal", "fire", "water", "steam","transparent","stone","plant","ice"]
	
	Method render(b:TBox, m:TMob)
		
		
		
		If b.mob_enters(m) Or b.mob_is_inside(m) Then
			If TPLAYER(m) Then
				
				Select Self.death_number
					Case 0'mechanical
						If TPLAYER(m).mode  = TPLAYER_MODE.modes[1] Then Return
						If TPLAYER(m).mode  = TPLAYER_MODE.modes[2] Then Return
						If TPLAYER(m).mode  = TPLAYER_MODE.modes[3] Then Return
						If TPLAYER(m).mode  = TPLAYER_MODE.modes[4] Then Return
						If TPLAYER(m).mode  = TPLAYER_MODE.modes[5] Then Return
						
						m.kill_me = 1
						
						For Local i:Int = 0 To 100
							Local w:Float = Rnd()*360.0
							Local s:Float = Rnd()*0.5+0.2
							TPARTIKEL.Create(Rand(22,24), 1,  m.x-m.rx + Rnd()*2.0*m.rx, m.y-m.ry + Rnd()*2.0*m.ry,   Cos(w)*s,Sin(w)*s,0.1, Rnd()*360.0,Rnd()*4.0-2.0, Rnd()+1.0,1.0, 100)
						Next
					Case 1'poison
						m.kill_me = 1
					Case 2'burnt
						m.kill_me = 1
					Case 3'freeze
						m.kill_me = 1
					Case 4'suck the water
						
						If Not (TPLAYER(m).mode = TPLAYER_MODE.modes[2]) Then Return
						
						
						For Local i:Int = 0 To 2
							Local w:Float = 180+ATan2(m.y - (b.y + 0.5*TBox.typs[b.typ,b.rotation].dy), m.x - (b.x + 0.5*TBox.typs[b.typ,b.rotation].dx)) + Rnd()*20.0-10.0
							Local s:Float = Rnd()*1.0+0.5
							TPARTIKEL.Create(Rand(8,10), 2,  m.x + Rnd()*m.rx*2.0-m.rx, m.y + Rnd()*m.ry*1.3-0.3*m.ry,   Cos(w)*s,Sin(w)*s,0.0, Rnd()*360.0,Rnd()*4.0-2.0, 1.0,1.0, 100)
						Next
						
						TPLAYER(m).water_amount:-1.7
						
						If b.mob_enters(m) Then TSoundPlayer.run("schlurf",m.x,m.y,m,1000)'Sound_Handler.play("schlurf",m.x)
						
						
						If TPLAYER(m).water_amount <= 0 Then
							m.kill_me = 1
							
							For Local i:Int = 0 To 200
								Local w:Float = 180+ATan2(m.y - (b.y + 0.5*TBox.typs[b.typ,b.rotation].dy), m.x - (b.x + 0.5*TBox.typs[b.typ,b.rotation].dx)) + Rnd()*20.0-10.0
								Local s:Float = Rnd()*1.0+0.5
								TPARTIKEL.Create(Rand(8,10), 2,  m.x + Rnd()*m.rx*2.0-m.rx, m.y + Rnd()*m.ry*1.3-0.3*m.ry,   Cos(w)*s,Sin(w)*s,0.0, Rnd()*360.0,Rnd()*4.0-2.0, 1.0,1.0, 100)
							Next
							
						End If
				End Select
			End If
		End If
	End Method
End Type


'########################################################################################
'###########################                              ###############################
'###########################     Box Renderer Liquid      ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_Liquid Extends TBox_Renderer
	Function Create:TBox_Renderer_Liquid()
		Local r:TBox_Renderer_Liquid = New TBox_Renderer_Liquid
		r.name = "liquid"
		Return r
	End Function
	
	Field liquid_number:Int = 1
	
	'Global liquids:String[] = ["water", "lava"]
	
	Method copy:TBox_Renderer_Liquid()
		Local r:TBox_Renderer_Liquid = New TBox_Renderer_Liquid
		
		r.name = Self.name
		r.liquid_number = Self.liquid_number
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		
		
		If b.mob_middle_is_inside(m) Then
			m.in_water = 2
		End If
		
		If b.mob_is_inside(m) Then
			Select Self.liquid_number
				Case 0'Water
					If m.in_water < 2 Then
						m.in_water = 1
					End If
				Case 1'Lava
					m.in_lava = 1
			End Select
		End If
		
		If Self.liquid_number = 0 Then'water
			If b.mob_enters(m) Then'pflatsch
				TSoundPlayer.run("platsch" + Rand(1,3),m.x,m.y,m,100000)'Sound_Handler.play("platsch" + Rand(1,3),b.x)'platsch sound
			End If
		End If
		
	End Method
End Type


'########################################################################################
'###########################                              ###############################
'###########################   Box Renderer Teleporter    ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_Teleporter Extends TBox_Renderer
	Function Create:TBox_Renderer_Teleporter()
		Local r:TBox_Renderer_Teleporter = New TBox_Renderer_Teleporter
		r.name = "Teleporter"
		Return r
	End Function
	
	Field typ:Int
	
	'Global typs:String[] = ["lokal", "change scene", "transportation", "end_location"]
	Rem
	0 = lokal, keep speed, kamera normal
	1 = black out, reset kamera, must activate
	2 = rohr, linear camera, delay
	End Rem
	
	Field teleporter_name:String'name
	
	Field location_name:String
	
	Field player_only:Int
	
	'Global teleportation_delay:Int = 2000
	
	Method copy:TBox_Renderer_Teleporter()
		Local r:TBox_Renderer_Teleporter = New TBox_Renderer_Teleporter
		
		r.name = Self.name
		r.teleporter_name = Self.teleporter_name
		r.location_name = Self.location_name
		
		r.player_only = Self.player_only
		
		r.typ = Self.typ
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		
		
		If Self.player_only = 1 And TPLAYER(m)=Null Then Return
		
		If TPLAYER(m) And TPLAYER(m).last_teleport > MilliSecs() Then
			Print "blocked !"
			Return
		End If
		
		
		Select Self.typ
			Case 0' "lokal" lokal, keep speed, kamera normal
				
				If b.mob_is_inside(m) Then
					Local l:TBox = TBox(GAME.world.act_level.location_map.ValueForKey(Self.location_name))
					
					If l Then
						
						m.x = l.x
						m.y = l.y
						
						
						Local vvx:Float=m.vx
						Local vvy:Float=m.vy
						
						Select l.rotation
							Case 0
								m.vx = vvx
								m.vy = vvy
							Case 1
								m.vx = -vvy
								m.vy = vvx
							Case 2
								m.vx = -vvx
								m.vy = -vvy
							Case 3
								m.vx = vvy
								m.vy = -vvx
						End Select
						
						Print "my rotation is: " + l.rotation
						
						
						If TPLAYER(m) Then TPLAYER(m).set_mode_teleport()
						
						Print "teleport 0"
					Else
						Print "location not found: " + Self.location_name
					End If
				End If
				
			Case 1' "change scene" black out, reset kamera, must activate
				
				If TControls.activate.key.hit = 0 Then Return
				
				TControls.activate.key.hit = 0
				
				If b.mob_is_inside(m) And TPLAYER(m) Then
					Local l:TBox = TBox(GAME.world.act_level.location_map.ValueForKey(Self.location_name))
					
					If l Then
						
						TLevel.black_out()
						
						m.x = l.x
						m.y = l.y
						
						m.vx = 0
						m.vy = 0
						
						TPLAYER(m).set_mode_teleport()
						
						GAME.world.act_level.ansicht_ziel_x = - m.x + 400
						GAME.world.act_level.ansicht_ziel_y = - m.y + 300
						
						GAME.world.act_level.ansicht_act_x = GAME.world.act_level.ansicht_ziel_x
						GAME.world.act_level.ansicht_act_y = GAME.world.act_level.ansicht_ziel_y
						
						Print "teleport 1"
					Else
						Print "location not found: " + Self.location_name
					End If
				End If
				
			Case 2' "transportation" rohr, linear camera, delay
				
				If b.mob_is_inside(m) And TPLAYER(m) Then
					Local l:TBox = TBox(GAME.world.act_level.location_map.ValueForKey(Self.location_name))
					
					If l Then
						
						TPLAYER(m).last_teleport = MilliSecs() + 1000.0/60.0*((m.x - l.x)^2.0 + (m.y - l.y)^2.0)^0.5/15.0
						
						m.x = l.x
						m.y = l.y
						
						m.vx = 0
						m.vy = 0
						
						TPLAYER(m).set_mode_teleport()
						
						GAME.world.act_level.ansicht_mode=1'set cammera follow motion to slow
						
						Print "teleport 2"
					Else
						Print "location not found: " + Self.location_name
					End If
				End If
				
			Case 3' "end_location"
				If b.mob_is_inside(m) And TPLAYER(m) Then
					TPLAYER(m).set_mode_after_teleport(Self.location_name)
					GAME.world.act_level.ansicht_mode=0'set camera motion normal
				End If
				
			Case 4' "lokal turn" lokal, turn speed, kamera normal
				
				If b.mob_is_inside(m) Then
					Local l:TBox = TBox(GAME.world.act_level.location_map.ValueForKey(Self.location_name))
					
					If l Then
						
						m.x = l.x
						m.y = l.y
						
						m.vy = - m.vy
						
						'If TPLAYER(m) Then TPLAYER(m).set_mode_teleport()
						
						Print "teleport 0"
					Else
						Print "location not found: " + Self.location_name
					End If
				End If
		End Select
		
	End Method
End Type
'########################################################################################
'###########################                              ###############################
'###########################    Box Renderer TLamp    ###################################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_TLamp Extends TBox_Renderer
	Function Create:TBox_Renderer_TLamp()
		Local r:TBox_Renderer_TLamp = New TBox_Renderer_TLamp
		r.name = "LAMP"
		Return r
	End Function
	
	Field light:TLight
	
	Field light_typ_number:Int
	
	Global light_typ_image_list:TImage[2]
	
	Function init()
		TBox_Renderer_TLamp.light_typ_image_list = New TImage[3]
		TBox_Renderer_TLamp.light_typ_image_list[0] = LoadImage("Worlds\" + GAME.world.name + "\Lights\normal.png")
		TBox_Renderer_TLamp.light_typ_image_list[1] = LoadImage("Worlds\" + GAME.world.name + "\Lights\small.png")
		TBox_Renderer_TLamp.light_typ_image_list[2] = LoadImage("Worlds\" + GAME.world.name + "\Lights\big.png")
		'TBox_Renderer_TLamp.light_typ_image_list[3] = LoadImage("Worlds\" + GAME.world.name + "\Lights\big.png")
	End Function
	
	Field brightness_r:Int
	Field brightness_g:Int
	Field brightness_b:Int
	
	Method copy:TBox_Renderer_TLamp()
		Local r:TBox_Renderer_TLamp = New TBox_Renderer_TLamp
		
		r.name = Self.name
		r.brightness_r = Self.brightness_r
		r.brightness_g = Self.brightness_g
		r.brightness_b = Self.brightness_b
		
		r.light_typ_number = Self.light_typ_number
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		
	End Method
End Type


'########################################################################################
'###########################                              ###############################
'###########################      Box Renderer Music      ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_Music Extends TBox_Renderer
	Function Create:TBox_Renderer_Music()
		Local r:TBox_Renderer_Music = New TBox_Renderer_Music
		r.name = "Music"
		Return r
	End Function
	
	Field music_name:String
	
	Method copy:TBox_Renderer_Music()
		Local r:TBox_Renderer_Music = New TBox_Renderer_Music
		
		r.name = Self.name
		r.music_name = Self.music_name
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		
		
		If GAME.world.act_level.current_music_name = ""  Then
			GAME.world.act_level.current_music_name = Self.music_name
		End If
	End Method
End Type

'########################################################################################
'###########################                              ###############################
'###########################  Box Renderer MusicChanger   ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_MusicChanger Extends TBox_Renderer
	Function Create:TBox_Renderer_MusicChanger()
		Local r:TBox_Renderer_MusicChanger = New TBox_Renderer_MusicChanger
		r.name = "MusicChanger"
		Return r
	End Function
	
	Field music_name:String
	
	
	
	Method copy:TBox_Renderer_MusicChanger()
		Local r:TBox_Renderer_MusicChanger = New TBox_Renderer_MusicChanger
		
		r.name = Self.name
		r.music_name = Self.music_name
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		
		
		If TPLAYER(m) Then
			If b.mob_is_inside(m) Then
				GAME.world.act_level.current_music_name = Self.music_name
			End If
		End If
	End Method
End Type

'########################################################################################
'###########################                              ###############################
'###########################      Box Renderer Sound      ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_Sound Extends TBox_Renderer
	Function Create:TBox_Renderer_Sound()
		Local r:TBox_Renderer_Sound = New TBox_Renderer_Sound
		r.name = "Sound"
		Return r
	End Function
	
	Field music_name:String
	
	Method copy:TBox_Renderer_Sound()
		Local r:TBox_Renderer_Sound= New TBox_Renderer_Sound
		
		r.name = Self.name
		r.music_name = Self.music_name
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		
		
		If TPLAYER(m) Then
			If b.mob_enters(m) Then
				TSoundPlayer.run(Self.music_name,m.x,m.y,m,10000000)'Sound_Handler.play(Self.music_name,b.x)
			End If
		End If
	End Method
End Type

'########################################################################################
'###########################                              ###############################
'###########################  Box Renderer SoundRepeater  ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_SoundRepeater Extends TBox_Renderer
	Function Create:TBox_Renderer_SoundRepeater()
		Local r:TBox_Renderer_SoundRepeater = New TBox_Renderer_SoundRepeater
		r.name = "SoundRepeater"
		
		Return r
	End Function
	
	Field music_name:String
	Field delta_t:Int
	Field delta_rand:Int
	Field radius:Int
	
	Field next_sound:Int
	
	Method copy:TBox_Renderer_SoundRepeater()
		Local r:TBox_Renderer_SoundRepeater = New TBox_Renderer_SoundRepeater
		
		r.name = Self.name
		r.music_name = Self.music_name
		r.delta_t= Self.delta_t
		r.delta_rand = Self.delta_rand
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		If Self.next_sound < MilliSecs() Then
			Self.next_sound = MilliSecs()+  Self.delta_t+Rand(0,Self.delta_rand)
			
			'Sound_Handler.play_2d(Self.music_name,b.x,b.y,Self.radius)
			TSoundPlayer.run(Self.music_name,b.x,b.y,b,Self.radius)
		End If
	End Method
End Type

'########################################################################################
'###########################                              ###############################
'###########################  Box Renderer LightHandler   ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_LightHandler Extends TBox_Renderer
	Function Create:TBox_Renderer_LightHandler()
		Local r:TBox_Renderer_LightHandler = New TBox_Renderer_LightHandler
		r.name = "LightHandler"
		Return r
	End Function
	
	Field brightness_r:Int
	Field brightness_g:Int
	Field brightness_b:Int
	Field init_run:Int
	
	Method copy:TBox_Renderer_LightHandler()
		Local r:TBox_Renderer_LightHandler = New TBox_Renderer_LightHandler
		
		r.name = Self.name
		
		r.brightness_r = Self.brightness_r
		r.brightness_g = Self.brightness_g
		r.brightness_b = Self.brightness_b
		r.init_run = Self.init_run
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		If Self.init_run = 1 Then
			Self.init_run = 2
			
			GAME.world.act_level.set_brightness(Self.brightness_r,Self.brightness_g,Self.brightness_b)
			
			
		ElseIf Self.init_run = 2 Then
			
			'do nothing
			
		Else
			If TPLAYER(m) Then
				If b.mob_enters(m) Then
					
					GAME.world.act_level.set_brightness(Self.brightness_r,Self.brightness_g,Self.brightness_b)
					
				End If
			End If
		End If
	End Method
End Type

'########################################################################################
'###########################                              ###############################
'###########################     Box Renderer Dialogue    ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_Dialogue Extends TBox_Renderer
	Function Create:TBox_Renderer_Dialogue()
		Local r:TBox_Renderer_Dialogue= New TBox_Renderer_Dialogue
		r.name = "Dialogue"
		Return r
	End Function
	
	Field dialogue_id:String
	Field dialogue_name:String
	Field last_time_inside:Int = 0
	
	Method copy:TBox_Renderer_Dialogue()
		Local r:TBox_Renderer_Dialogue = New TBox_Renderer_Dialogue
		
		r.name = Self.name
		r.dialogue_name = Self.dialogue_name
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		If Not MapContains(GAME.world.act_level.dialogue_id_map, Self.dialogue_id) Then
			
			GAME.world.act_level.dialogue_id_map.insert(Self.dialogue_id, Self)
			
		Else
			If TPLAYER(m) Then
				If b.mob_is_inside(m) Then
					
					If GAME.world.act_level.dialogue_map.contains(Self.dialogue_name + Language_Handler.cl.small) Then
						
						If GAME.world.act_level.current_dialogue = Null And Self.last_time_inside = 0 Then
							
							GAME.world.act_level.current_dialogue = TDialogue(GAME.world.act_level.dialogue_map.ValueForKey(Self.dialogue_name + Language_Handler.cl.small))
							
							GAME.world.act_level.current_sub = 0
							
							
						End If
						
					Else
						Print "dialogue missing: " + Self.dialogue_name + Language_Handler.cl.small
					End If
					Self.last_time_inside = 1
				Else
					If Self.last_time_inside = 1 Then
						GAME.world.act_level.current_dialogue = Null
						
					End If
					
					Self.last_time_inside = 0
				End If
				
			End If
		End If
	End Method
End Type

'########################################################################################
'#########################                                ###############################
'######################### Box Renderer Dialogue_Changer  ###############################
'#########################                                ###############################
'########################################################################################

Type TBox_Renderer_Dialogue_Changer Extends TBox_Renderer
	Function Create:TBox_Renderer_Dialogue_Changer()
		Local r:TBox_Renderer_Dialogue_Changer= New TBox_Renderer_Dialogue_Changer
		r.name = "Dialogue_Changer"
		Return r
	End Function
	
	Field dialogue_name:String
	Field dialogue_id:String
	
	
	Method copy:TBox_Renderer_Dialogue_Changer()
		Local r:TBox_Renderer_Dialogue_Changer = New TBox_Renderer_Dialogue_Changer
		
		r.name = Self.name
		r.dialogue_name = Self.dialogue_name
		r.dialogue_id = Self.dialogue_id
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		If TPLAYER(m) Then
			If b.mob_enters(m) Then
				
				'find me the talker!!!
				If GAME.world.act_level.dialogue_id_map.Contains(Self.dialogue_id) Then
					TBox_Renderer_Dialogue(GAME.world.act_level.dialogue_id_map.ValueForKey(Self.dialogue_id)).dialogue_name = Self.dialogue_name
				Else
					Print "(dialogue) talker not found!"
				End If
				
			End If
		End If
	End Method
End Type



'########################################################################################
'###########################                              ###############################
'###########################       Box Renderer Sign      ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_Sign Extends TBox_Renderer
	Function Create:TBox_Renderer_Sign()
		Local r:TBox_Renderer_Sign = New TBox_Renderer_Sign
		r.name = "Sign"
		Return r
	End Function
	
	Field sign_text_name:String
	
	Method copy:TBox_Renderer_Sign()
		Local r:TBox_Renderer_Sign = New TBox_Renderer_Sign
		
		r.name = Self.name
		r.sign_text_name = Self.sign_text_name
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		
		If TPLAYER(m) Then
			If b.mob_is_inside(m) Then
				
				If GAME.world.act_level.sign_text_map.contains(Self.sign_text_name + Language_Handler.cl.small) Then
					
					GAME.world.act_level.current_sign_text = Sign_Text(GAME.world.act_level.sign_text_map.ValueForKey(Self.sign_text_name + Language_Handler.cl.small))
					
					GAME.world.act_level.last_time_sign_text_activated = MilliSecs()
				Else
					Print "sing missing: " + Self.sign_text_name + Language_Handler.cl.small
				End If
				
			End If
		End If
	End Method
End Type

'########################################################################################
'###########################                              ###############################
'###########################       Box Renderer Jumper    ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_Jumper Extends TBox_Renderer
	Function Create:TBox_Renderer_Jumper()
		Local r:TBox_Renderer_Jumper = New TBox_Renderer_Jumper
		r.name = "Jumper"
		Return r
	End Function
	
	Field angle:Float
	Field power:Float
	Field last_jump:Int
	
	Method copy:TBox_Renderer_Jumper()
		Local r:TBox_Renderer_Jumper = New TBox_Renderer_Jumper
		
		r.name = Self.name
		r.angle = Self.angle
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		
		If TPLAYER(m) And b.mob_enters(m)=3 Then
			m.vy = -Self.power*m.vy
			
			Self.last_jump = MilliSecs()
		End If
		
	End Method
End Type

'########################################################################################
'###########################                              ###############################
'###########################     Box Renderer Sequence    ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_Sequence Extends TBox_Renderer
	Function Create:TBox_Renderer_Sequence()
		Local r:TBox_Renderer_Sequence = New TBox_Renderer_Sequence
		r.name = "Sequence"
		Return r
	End Function
	
	Field script_name:String
	
	Field run_init:Int
	
	Field seq:Sequence
	
	Method copy:TBox_Renderer_Sequence()
		Local r:TBox_Renderer_Sequence = New TBox_Renderer_Sequence
		
		r.name = Self.name
		r.script_name = Self.script_name
		r.run_init = Self.run_init
		
		Return r
	End Method
	
	Method render(b:TBox, m:TMob)
		If Self.run_init = 1 Then
			Self.seq = Sequence.Create(Self.script_name)
			Self.run_seq(b)
			'b.kill_me = 1
			Self.run_init = 0
		End If
		
		
		If TPLAYER(m) Then
			If b.mob_enters(m) Then
				If Self.run_init = 0 Then Self.seq = Sequence.Create(Self.script_name)'Sequence.play(Self.script_name)
			End If
			
			Self.run_seq(b)
			
		End If
	End Method
	
	Method run_seq(b:TBox)
		If Self.seq Then
			Local cont:Int = 0
			Repeat
				Select Self.seq.render_line()
					Case 0'normal
					Case 1'continue
						cont = 1
					Case 2'kill_box
						cont = 1
						b.kill_me = 1
					Case 3'end script running
						cont = 1
						Self.seq = Null
				End Select
				
				If Self.seq.done = 1 Then Self.seq = Null
			Until cont = 1 Or Self.seq = Null
		End If
	End Method
End Type

Rem
Sequences:
 - image <filename> <x> <y>
 - image_lang <filename> <x> <y> (dependent on language)
 - cls
 - flip
 - music <musicname>
 - sound <soundname>
 - delay <milliseconds>
 - wait <ms>
 - kill_box
 - print <txt>
 - goto <markername> (:<markername>)
 - # (comment)
 - set <variablename without %> txt
 - goto_if txt1 txt2 marker (if txt1=txt2)
 - pause (give the power back to the game)
 - end (end script running)
 - levelcomplete
 - lc
 - lighthandler
 - lh
End Rem

'########################################################################################
'###########################            #################################################
'###########################  Sequence  #################################################
'###########################            #################################################
'########################################################################################

Type Sequence
	
	Field name:String
	
	Field lines:String[]
	Field cl:Int'current line
	
	Field done:Int = 0
	
	Function Create:Sequence(name:String)
		Local s:Sequence = New Sequence
		
		s.name = name
		
		Local text_file:TStream = ReadFile("Worlds\" + GAME.world.act_level.world.name + "\Levels\" + GAME.world.act_level.name + "\sequences\" + name + ".txt")
		If Not text_file Then
			Print "sequence not found! " + name
			Return Null
		End If
		
		s.lines = [""]
		
		While Not Eof(text_file)
			s.lines:+ [ReadLine(text_file)]
		Wend
		CloseFile(text_file)
		
		s.cl = -1
		
		Return s
	End Function
	
	Method render_line:Int()
		
		If Self.cl >= Self.lines.length-1 Then Self.done = 1
		
		If Self.done = 1 Then Return 1
		
		Self.cl:+1
		Local txt:String = LEVEL_VARIABLES.get_txt(Self.lines[Self.cl])
		Local txt_old:String = txt
		
		Local t:String[]
		
		While txt<>""
			Local pos:Int = Instr(txt," ")
			
			If pos = 0 Then
				t:+[txt]
				txt = ""
			Else
				t:+[Mid(txt,1,pos-1)]
				
				txt = Mid(txt,pos+1,-1)
			End If
		Wend
		
		
		If t.length > 0 Then
			
			Select Lower(t[0])
				Case ""
					Return 0
				Case "image"
					If Not t.length > 1 Then
						Print "image <filename> <x> <y>"
					Else
						Local filename:String = t[1]
						
						Local xx:Int = 0
						Local yy:Int = 0
						
						If t.length > 2 Then xx= Int(t[2])
						If t.length > 3 Then yy= Int(t[3])
						
						Local image:TImage = LoadImage("Worlds\" + GAME.world.act_level.world.name + "\Levels\" + GAME.world.act_level.name + "\sequences\" + filename + ".png")
						If image Then
							SetColor 255,255,255
							Draw_Image image,xx,yy
						Else
							Print "could not show image: " + filename + ".png"
						End If
						
					End If
					Return 0
				Case "image_lang"
					If Not t.length > 1 Then
						Print "image_lang <filename> <x> <y>"
					Else
						Local filename:String = t[1]
						
						Local xx:Int = 0
						Local yy:Int = 0
						
						If t.length > 2 Then xx= Int(t[2])
						If t.length > 3 Then yy= Int(t[3])
						
						Local image:TImage = LoadImage("Worlds\" + GAME.world.act_level.world.name + "\Levels\" + GAME.world.act_level.name + "\sequences\" + filename + Language_Handler.cl.small + ".png")
						If image Then
							SetColor 255,255,255
							Draw_Image image,xx,yy
						Else
							Print "could not show image: " + filename + Language_Handler.cl.small + ".png"
						End If
						
					End If
					Return 0
				Case "cls"
					Cls
					Return 0
				Case "flip"
					Flip
					Return 0
				Case "levelcomplete", "lc"
					
					TLevel.set_completed()
					
					Return 0
				Case "delay"
					If Not t.length > 1 Then
						Print "parameter missing: delay-time"
					Else
						
						Local time:Int = MilliSecs()+Int(t[1])
						
						Repeat
							'rendering of the necessary:
							TControls.render_controls()
							GAME.world.act_level.render_music()
							
						Until MilliSecs() >= time Or TControls.escape.key.hit
						TControls.escape.key.hit = 0
					End If
					
					Return 0
				Case "wait"
					If Not t.length > 1 Then
						Print "parameter missing: delay-time"
					Else
						
						Local c:Int = Int(LEVEL_VARIABLES.get("_sys_wait_time"))
						
						If c = 0 Then
							'start it
							LEVEL_VARIABLES.set("_sys_wait_time",Int(MilliSecs()+Int(t[1])))
							Self.cl:-1
							Return 1
						Else If c < MilliSecs()
							'end if
							LEVEL_VARIABLES.set("_sys_wait_time","0")
							Return 0
						Else
							'continue waiting
							
							Self.cl:-1
							Return 1
						End If
					End If
					
					Return 0
				Case "music"
					If Not t.length > 1 Then
						Print "parameter missing: music-name"
					Else
						GAME.world.act_level.current_music_name = t[1]
						
					End If
					Return 0
				Case "sound"
					If Not t.length > 1 Then
						Print "parameter missing: sound-name"
					Else
						
						Sound_Handler.play_simple(t[1])
						
					End If
					Return 0
				Case "print"
					If Not t.length > 1 Then
						Print "parameter missing: txt"
					Else
						Print "SCRIPT PRINT> " + Mid(txt_old,7,-1)
					End If
					
					Return 0
				Case "set"
					If Not t.length > 2 Then
						Print "it should be: set variable txt"
					Else
						LEVEL_VARIABLES.set(t[1], Mid(txt_old,Len(t[0]+t[1])+3,-1))
					End If
					
					Return 0
				Case "add"
					If Not t.length > 2 Then
						Print "it should be: add variable number"
					Else
						LEVEL_VARIABLES.set(t[1], Int(Int(LEVEL_VARIABLES.get(t[1])) + Int(Mid(txt_old,Len(t[0]+t[1])+3,-1))))
					End If
					
					Return 0
				Case "kill_box"
					Return 2
				Case "end"
					Return 3
				Case "goto"
					If Not t.length > 1 Then
						Print "parameter missing: location marker name"
					Else
						
						For Local i:Int = 0 To Self.lines.length-1
							If Lower(Self.lines[i])=":" + t[1] Then
								
								Self.cl = i
								
								Return 0
							End If
						Next
					End If
					
					Return 0
				Case "goto_if"'txt1 txt2 marker (if txt1=txt2)
					If Not t.length > 3 Then
						Print "it should be: goto_if txt1 txt2 marker"
					Else
						
						If t[1]<>t[2] Then Return 0
						
						For Local i:Int = 0 To Self.lines.length-1
							If Lower(Self.lines[i])=":" + t[3] Then
								
								Self.cl = i
								
								Return 0
							End If
						Next
					End If
					
					Return 0
				Case "lighthandler", "lh"
					If Not t.length > 3 Then
						Print "it should be: lighthandler r g b"
					Else
						
						GAME.world.act_level.set_brightness(Int(t[1]), Int(t[2]), Int(t[3]))
						
					End If
					
					Return 0
				Case "#"
					Return 0
				Case "pause"
					Return 1
				Default
					If Mid(txt_old,1,1)=":" Then Return 0
					Print "I do not know: " + txt_old
					Return 0
			End Select
		End If
	End Method
	
End Type

'########################################################################################
'###########################                 ############################################
'########################### Level Variables ############################################
'###########################                 ############################################
'########################################################################################

Type LEVEL_VARIABLES
	Global map:TMap
	
	'%variablename%
	
	Function init()
		LEVEL_VARIABLES.map = New TMap
	End Function
	
	Function render_sys()
		LEVEL_VARIABLES.set("_sys_"+TControls.up.name,TControls.up.key.name)
		LEVEL_VARIABLES.set("_sys_"+TControls.down.name,TControls.down.key.name)
		LEVEL_VARIABLES.set("_sys_"+TControls.r.name,TControls.r.key.name)
		LEVEL_VARIABLES.set("_sys_"+TControls.l.name,TControls.l.key.name)
		
		LEVEL_VARIABLES.set("_sys_"+TControls.activate.name,TControls.activate.key.name)
		LEVEL_VARIABLES.set("_sys_"+TControls.ability.name,TControls.ability.key.name)
		LEVEL_VARIABLES.set("_sys_"+TControls.cont.name,TControls.cont.key.name)
		
		LEVEL_VARIABLES.set("_sys_"+TControls.reload.name,TControls.reload.key.name)
		LEVEL_VARIABLES.set("_sys_"+TControls.suicide.name,TControls.suicide.key.name)
		
		LEVEL_VARIABLES.set("_sys_"+TControls.escape.name,TControls.escape.key.name)
		
		LEVEL_VARIABLES.set("_sys_language",Language_Handler.cl.name)
		LEVEL_VARIABLES.set("_sys_language_small",Language_Handler.cl.small)
		
		If GAME.world.act_level.player Then
			LEVEL_VARIABLES.set("_sys_player_mode",GAME.world.act_level.player.mode.name)
		End If
	End Function
	
	Function draw_to_screen(x:Int,y:Int)
		
		SetAlpha 0.7
		SetColor 0,0,0
		Draw_Rect x-54,y,240,30
		
		SetAlpha 1
		SetColor 200,200,200
		Draw_Text "VARIABLES [TAB] -> _sys_",x-50,y+2
		
		
		Local i:Int = 0
		For Local v:String = EachIn LEVEL_VARIABLES.map.Keys()
			If Mid(v,1,5)="_sys_" And Not KeyDown(key_tab) Then
			Else
				
				Local ix:Int = i/13
				Local iy:Int = (i Mod 13) + 1
				i:+1
				
				
				Local content:String = String(LEVEL_VARIABLES.map.ValueForKey(v))
				
				SetAlpha 0.7
				SetColor 0,0,0
				Draw_Rect x-TextWidth(v)-4+ix*200,y+iy*35,TextWidth(v)+TextWidth(content)+20,30
				
				SetAlpha 1
				SetColor 200,0,0
				Draw_Text v,x-TextWidth(v)-2+ix*200,y+iy*35+2
				
				SetColor 0,200,200
				Draw_Text content,x+6+ix*200,y+iy*35+2
			End If
		Next
		
	End Function
	
	
	Function save_to_file(path:String)
		
		Local file:TStream = WriteFile(path)
		
		For Local v:String = EachIn LEVEL_VARIABLES.map.Keys()
			Local content:String = String(LEVEL_VARIABLES.map.ValueForKey(v))
			
			file.WriteLine(v)
			file.WriteLine(content)
		Next
		
		CloseFile(file)
		
	End Function
	
	Function load_from_file(path:String)
		LEVEL_VARIABLES.map = New TMap
		
		Local file:TStream = ReadFile(path)
		
		While Not Eof(file)
			Local v:String = ReadLine(file)
			Local content:String = ReadLine(file)
			
			LEVEL_VARIABLES.map.Insert(v, content)
		Wend
		
		CloseFile(file)
		
	End Function
	
	Function set(v:String, txt:String)
		LEVEL_VARIABLES.map.Insert(Lower(v),txt)
	End Function
	
	Function get:String(v:String)
		Return String(LEVEL_VARIABLES.map.ValueForKey(Lower(v)))
	End Function
	
	Function get_txt:String(txt:String)'string from string with variables
		Local txt2:String = txt
		Local resultat:String = ""
		Local v_name:String = ""
		Local v_on:Int = 0
		
		While Len(txt)>0
			If Mid(txt,1,1) = "%" Then
				If v_on=0 Then
					v_on=1
					v_name = ""
				Else
					v_on=0
					'get it in!
					
					resultat:+LEVEL_VARIABLES.get(v_name)
				End If
			Else
				If v_on=0 Then
					resultat:+Mid(txt,1,1)
				Else
					v_name:+Mid(txt,1,1)
				End If
			End If
			txt = Mid(txt,2,-1)
		Wend
		
		Return resultat
	End Function
End Type

'########################################################################################
'###########################            #################################################
'########################### Sign Texts #################################################
'###########################            #################################################
'########################################################################################

Rem

'------------- LOAD SIGN TEXTS !
			
			l.sign_text_map = Sign_Text.load_for_level(l)

End Rem

Type Sign_Text
	Field lines:String[]
	Field name:String
	
	Function load_for_level:TMap(l:TLevel)
		
		If FileType("Worlds\" + l.world.name + "\Levels\" + l.name + "\sign_texts") = 2 Then
			
			Local files:String[] = LoadDir("Worlds\" + l.world.name + "\Levels\" + l.name + "\sign_texts")
			
			Local map:TMap = New TMap
			
			Print "////////// load sign texts \\\\\\\\\\\\\"
			
			For Local f:String = EachIn files
				Print f
				
				If ExtractExt(f) = "txt" Then
					Local st:Sign_Text = New Sign_Text
					
					st.name = StripAll(f)
					
					Local text_file:TStream = ReadFile("Worlds\" + l.world.name + "\Levels\" + l.name + "\sign_texts\" + f)
					
					While Not Eof(text_file)
						st.lines = st.lines + [ReadLine(text_file)]
					Wend
					
					map.Insert(st.name, st)
					
				End If
			Next
			
			Return map
			
		Else
			
			Return New TMap
		End If
		
	End Function
End Type


'########################################################################################
'###########################        #####################################################
'###########################  MOB   #####################################################
'###########################        #####################################################
'########################################################################################

Type TMob Extends TObject
	Field rx:Float'1/2 of side of image
	Field ry:Float
	
	Field vx:Float
	Field vy:Float
	
	Field coll_ground:Int = 0
	Field coll_l:Int = 0
	Field coll_r:Int = 0
	Field coll_up:Int = 0
	
	Field in_fire:Int = 0
	Field in_water:Int = 0'1=in it'2=full in it
	Field in_lava:Int = 0
	
	Method render()
		Super.render()
		
		Self.in_fire = 0
		Self.in_water = 0
		Self.in_lava = 0
		
	End Method
	
	Method New()
		Self.layer = 1
		Self.important = 0
	End Method
End Type



'########################################################################################
'###########################          ###################################################
'########################### FireBird ###################################################
'###########################          ###################################################
'########################################################################################

Type TFireBird Extends TMob
	
	Global image:TImage
	Global image_falling:TImage
	
	Field nest_x:Float
	Field nest_y:Float
	Field modus:Int = 0'0 = sitting, 1 = flying
	Field reset_delay:Int
	
	Function init()
		TFireBird.image = LoadImage("Worlds\" + GAME.world.name + "\Objects\fire_bird\image.png")
		MidHandleImage TFireBird.image
		TFireBird.image_falling = LoadImage("Worlds\" + GAME.world.name + "\Objects\fire_bird\falling.png")
		MidHandleImage TFireBird.image_falling
	End Function
	
	Method New()
		Self.layer = 2
		Self.important = 1
		
		Self.rx = ImageWidth(TFireBird.image_falling)/2
		Self.ry = ImageHeight(TFireBird.image_falling)/2
	End Method
	
	Function Create:TFireBird(x:Float,y:Float)
		Local p:TFireBird = New TFireBird
		
		p.x = x
		p.y = y
		
		p.nest_x = x
		p.nest_y = y
		
		Return p
	End Function
	
	Method should_attack:Int(mode:TPLAYER_MODE)
		'' ["normal", "fire", "water", "steam","transparent","stone","plant","ice"]
		'0, 2, 3
		If mode = TPLAYER_MODE.modes[0] Then Return 1
		If mode = TPLAYER_MODE.modes[2] Then Return 1
		If mode = TPLAYER_MODE.modes[3] Then Return 1
		Return 0
	End Method
	
	Method render()
		Super.render()
		
		Select Self.modus
			Case 0'sitting
				
				If Self.reset_delay > 0 Then
					Self.reset_delay:-1
				Else
					
					If GAME.world.act_level.player Then
						
						If Self.should_attack(GAME.world.act_level.player.mode) Then
							If ((GAME.world.act_level.player.x-Self.x)^2+(GAME.world.act_level.player.y-Self.y)^2)^0.5 < 400 Then
								Self.modus = 1
								
								Self.vx = 0
								Self.vy = 0
								
								'Sound_Handler.play_2d("ziu",Self.x,Self.y,500.0)
								TSoundPlayer.run("ziu",Self.x,Self.y,Self,500.0)
								
							End If
						End If
					End If
				End If
				
			Case 1'flying
				
				
				If GAME.world.act_level.has_collision(Floor(Self.x/GAME.world.act_level.image_side),Floor(Self.y/GAME.world.act_level.image_side)) Then
					
					
					'Sound_Handler.play_2d("pfu",Self.x,Self.y,500.0)
					TSoundPlayer.run("pfu",Self.x,Self.y,Self,500.0)
					
					For Local i:Int = 1 To 100
						Local w:Float = Rnd()*360.0
						Local s:Float = Rnd()*2.0-1.0
						TPARTIKEL.Create(Rand(0,3), 1,  Self.x,Self.y,   Cos(w)*s,Sin(w)*s,-0.01, Rnd()*360.0,Rnd()*4.0-2.0, Rnd()*1.0+1.0,1.0, 100)
					Next
					
					Self.reset()'Self.kill_me = 1
				End If
				
				If GAME.world.act_level.player Then
					If Self.should_attack(GAME.world.act_level.player.mode) Then
						If Self.x-GAME.world.act_level.player.rx < GAME.world.act_level.player.x Then
							If Self.x+GAME.world.act_level.player.rx > GAME.world.act_level.player.x Then
								If Self.y-GAME.world.act_level.player.ry < GAME.world.act_level.player.y Then
									If Self.y+GAME.world.act_level.player.ry > GAME.world.act_level.player.y Then
										
										
										'Sound_Handler.play_2d("pfu",Self.x,Self.y,500.0)
										TSoundPlayer.run("pfu",Self.x,Self.y,Self,500.0)
										
										GAME.world.act_level.player.set_mode(TPLAYER_MODE.modes[1],1)
										
										For Local i:Int = 1 To 100
											Local w:Float = Rnd()*360.0
											Local s:Float = Rnd()*2.0-1.0
											TPARTIKEL.Create(Rand(0,3), 1,  Self.x,Self.y,   Cos(w)*s,Sin(w)*s,-0.01, Rnd()*360.0,Rnd()*4.0-2.0, Rnd()*1.0+1.0,1.0, 100)
										Next
										
										Self.reset()'Self.kill_me = 1
									EndIf
								End If
							End If
						EndIf
					EndIf
				End If
				
				If GAME.world.act_level.player Then
					If Self.should_attack(GAME.world.act_level.player.mode) Then
						Local w:Float = 180+ATan2(Self.y-(GAME.world.act_level.player.y-GAME.world.act_level.player.ry), Self.x-GAME.world.act_level.player.x)
						
						Self.vx:+Cos(w)*0.3
						Self.vy:+Sin(w)*0.3
					Else
						Local w:Float = ATan2(Self.y-(GAME.world.act_level.player.y-GAME.world.act_level.player.ry), Self.x-GAME.world.act_level.player.x)
						
						Self.vx:+Cos(w)*0.2
						Self.vy:-Abs(Sin(w)*0.5)
					End If
				End If
				
				Self.vy:+0.1
				
				Self.x:+Self.vx
				Self.y:+Self.vy
				
				
				
				
				For Local i:Int = 1 To 2
					TPARTIKEL.Create(Rand(0,3), 1,  Self.x,Self.y,   -Self.vx*0.1 + Rnd()*2.0-1.0,-Self.vy*0.1 + Rnd()*2.0-1.0,-0.001, Rnd()*360.0,Rnd()*4.0-2.0, Rnd()*1.0+1.0,1.0, 100)
				Next
		End Select
		
	End Method
	
	Method reset()
		Self.modus = 0
		
		Self.vx = 0
		Self.vy = 0
		Self.x = Self.nest_x
		Self.y = Self.nest_y
		
		Self.reset_delay = 60*5
	End Method
	
	Method draw()
		Select Self.modus
			Case 0'sitting
				SetColor 255,255,255
				Draw_Image TFireBird.image, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y
				
			Case 1'flying
				If Self.vx > 0 Then
					SetColor 255,255,255
					Draw_Image TFireBird.image_falling, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y
				Else
					SetScale -1,1
					
					SetColor 255,255,255
					Draw_Image TFireBird.image_falling, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y
					
					SetScale 1,1
				End If
				
		End Select
		
	End Method
	
		
	Method write_to_stream(stream:TStream)
		stream.WriteInt(8)'OBJECT = 0        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		stream.WriteInt(Self.important)
	End Method
	
	Function read_from_stream:TFireBird(stream:TStream)
		Local o:TFireBird = New TFireBird
		
		
		o.id = stream.ReadInt()
		o.x = stream.ReadFloat()
		o.y = stream.ReadFloat()
		o.nest_x = o.x
		o.nest_y = o.y
		o.layer = stream.ReadInt()
		o.important = stream.ReadInt()
		
		
		Return o
	End Function
	
	Method write_to_stream_running(stream:TStream)
		stream.WriteInt(8)'OBJECT = 0        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		stream.WriteInt(Self.important)
		
		stream.WriteInt(Self.kill_me)'NEW !
		
		'NEW !!!
		stream.WriteFloat(Self.rx)
		stream.WriteFloat(Self.ry)
		
		stream.WriteFloat(Self.vx)
		stream.WriteFloat(Self.vy)
		
		stream.WriteInt(Self.coll_ground)
		stream.WriteInt(Self.coll_l)
		stream.WriteInt(Self.coll_r)
		stream.WriteInt(Self.coll_up)
		
		stream.WriteInt(Self.in_fire)
		stream.WriteInt(Self.in_water)
		stream.WriteInt(Self.in_lava)
		
		stream.WriteFloat(Self.nest_x)
		stream.WriteFloat(Self.nest_y)
		stream.WriteInt(Self.modus)
		stream.WriteInt(Self.reset_delay)
		
		
	End Method
	
	
	Function read_from_stream_running:TFireBird(stream:TStream, delta_t:Int)
		Local o:TFireBird = New TFireBird
		
		
		o.id = stream.ReadInt()
		o.x = stream.ReadFloat()
		o.y = stream.ReadFloat()
		o.layer = stream.ReadInt()
		o.important = stream.ReadInt()
		
		o.kill_me = stream.ReadInt()'NEW !
				
		'NEW !!!
		o.rx = stream.ReadFloat()
		o.ry = stream.ReadFloat()
		
		o.vx = stream.ReadFloat()
		o.vy = stream.ReadFloat()
		
		o.coll_ground = stream.ReadInt()
		o.coll_l = stream.ReadInt()
		o.coll_r = stream.ReadInt()
		o.coll_up = stream.ReadInt()
		
		o.in_fire = stream.ReadInt()
		o.in_water = stream.ReadInt()
		o.in_lava = stream.ReadInt()
		
		o.nest_x = stream.ReadFloat()
		o.nest_y = stream.ReadFloat()
		o.modus = stream.ReadInt()
		o.reset_delay = stream.ReadInt()
		
		Return o
	End Function
	
	Method copy:TFireBird()
		Local p:TFireBird = New TFireBird
		
		p.x = Self.x
		p.y = Self.y
		p.layer = Self.layer
		p.important = Self.important
		
		Return p
	End Method
End Type


'########################################################################################
'###########################        #####################################################
'########################### BADIE  #####################################################
'###########################        #####################################################
'########################################################################################

Type TBADIE Extends TMob
	
	Global image:TImage
	
	Function init()
		TBADIE.image = LoadImage("Worlds\" + GAME.world.name + "\Objects\badie\image.png")
		MidHandleImage TBADIE.image
	End Function
	
	Method New()
		Self.layer = 1
		Self.important = 0
		
		Self.rx = ImageWidth(TBADIE.image)/2
		Self.ry = ImageHeight(TBADIE.image)/2
	End Method
	
	Function Create:TBADIE(x:Float,y:Float)
		Local p:TBADIE = New TBADIE
		
		p.x = x
		p.y = y
		
		Return p
	End Function
	
	Field coll_ground_since:Int
	
	Field side_walking:Int = -1
	
	Field coll_l_since:Int
	Field coll_r_since:Int
	
	Field next_jump_in:Int = 300
	
	Method render()
		Super.render()
		
		Self.x:+Self.vx
		Self.y:+Self.vy
		
		'Self.mode.render(Self.vx, Self.vy, Self.coll_ground, Self)
		
		Self.vy:+0.35
		
		If Self.vx = 0 Then
			Self.vx = 3.0*Self.side_walking
		End If
		
		If Self.coll_ground = 1 Then
			If Self.coll_ground_since = 0 Then
				Self.coll_ground_since = MilliSecs()
			End If
			
			If (MilliSecs() - Self.coll_ground_since) > Self.next_jump_in Then
				Self.vy = -1.0
				Self.next_jump_in = Rand(0,500)
			End If
			
		Else
			Self.coll_ground_since = 0
		End If
		
		
		If Self.coll_r = 1 Then
			If Self.coll_r_since = 0 Then
				Self.coll_r_since = MilliSecs()
			End If
			
			If (MilliSecs() - Self.coll_r_since) > Rand(900,1100) Then
				Self.side_walking = -1
			End If
			
		Else
			Self.coll_r_since = 0
		End If
		
		If Self.coll_l = 1 Then
			If Self.coll_l_since = 0 Then
				Self.coll_l_since = MilliSecs()
			End If
			
			If (MilliSecs() - Self.coll_l_since) > Rand(900,1100) Then
				Self.side_walking = 1
			End If
			
		Else
			Self.coll_l_since = 0
		End If
		
		
		'--------------- collision --------------
		Self.coll_ground = 0
		Self.coll_l = 0
		Self.coll_r = 0
		Self.coll_up = 0
		
		'---------------- andti wall climber
		If Ceil((Self.y + Self.ry)/GAME.world.act_level.image_side) < Ceil((Self.y+Self.ry + Self.vy)/GAME.world.act_level.image_side) Then
			'going one down
			
			If Ceil((Self.x + Self.rx)/GAME.world.act_level.image_side) < Ceil((Self.x+Self.rx + Self.vx)/GAME.world.act_level.image_side) Then
				'going one to the right
				
				Local iy:Int = Ceil((Self.y+Self.ry  + Self.vy)/GAME.world.act_level.image_side)-1
				Local ix:Int = Ceil((Self.x+Self.rx)/GAME.world.act_level.image_side)
				If GAME.world.act_level.has_collision(ix, iy) And GAME.world.act_level.has_collision(ix, iy - 1) Then
					Self.vx = (Ceil((Self.x+Self.rx)/GAME.world.act_level.image_side)*GAME.world.act_level.image_side) - (Self.x + Self.rx)
					
					If Self.vx = 0 Then Self.coll_r = 1
				End If
				
			End If
			
			If Floor((Self.x - Self.rx)/GAME.world.act_level.image_side) > Floor((Self.x - Self.rx + Self.vx)/GAME.world.act_level.image_side) Then
				'going one to the left
				
				
				Local iy:Int = Ceil((Self.y+Self.ry + Self.vy)/GAME.world.act_level.image_side)-1
				Local ix:Int = Floor((Self.x-Self.rx)/GAME.world.act_level.image_side) - 1
				If GAME.world.act_level.has_collision(ix, iy) And GAME.world.act_level.has_collision(ix, iy - 1) Then
					Self.vx = (Floor((Self.x-Self.rx)/GAME.world.act_level.image_side)*GAME.world.act_level.image_side) - (Self.x-Self.rx)
					If Self.vx = 0 Then Self.coll_l = 1
				End If
				
			End If
		End If
		
		
		'---------------- ground:
		If Ceil((Self.y + Self.ry)/GAME.world.act_level.image_side) < Ceil((Self.y+Self.ry + Self.vy)/GAME.world.act_level.image_side) Then
			'you have just entered a new row of blocks!
			
			'muss +vx haben, damit keine stÃÂÃÂ¶runen wenn genau auf ecke des blockes fÃÂÃÂ¤llt
			For Local ix:Int = Floor((Self.x - Self.rx + Self.vx)/GAME.world.act_level.image_side) To Ceil((Self.x+Self.rx + Self.vx)/GAME.world.act_level.image_side)-1
				If GAME.world.act_level.has_collision(ix,Ceil((Self.y+Self.ry)/GAME.world.act_level.image_side)) Then
					Self.vy = (Ceil((Self.y+Self.ry)/GAME.world.act_level.image_side)*GAME.world.act_level.image_side) - (Self.y+Self.ry)
					
					If Self.vy = 0 Then Self.coll_ground = 1
				End If
			Next
		End If
		
		'---------------- r:
		If Ceil((Self.x + Self.rx)/GAME.world.act_level.image_side) < Ceil((Self.x+Self.rx + Self.vx)/GAME.world.act_level.image_side) Then
			'you have just entered a new row of blocks!
			
			For Local iy:Int = Floor((Self.y - Self.ry  + Self.vy)/GAME.world.act_level.image_side) To Ceil((Self.y+Self.ry  + Self.vy)/GAME.world.act_level.image_side)-1
				If GAME.world.act_level.has_collision(Ceil((Self.x+Self.rx)/GAME.world.act_level.image_side), iy) Then
					Self.vx = (Ceil((Self.x+Self.rx)/GAME.world.act_level.image_side)*GAME.world.act_level.image_side) - (Self.x+Self.rx)
					
					If Self.vx = 0 Then Self.coll_r = 1
				End If
			Next
		End If
		
		'---------------- l:
		If Floor((Self.x - Self.rx)/GAME.world.act_level.image_side) > Floor((Self.x - Self.rx + Self.vx)/GAME.world.act_level.image_side) Then
			'you have just entered a new row of blocks!
			
			For Local iy:Int = Floor((Self.y - Self.ry + Self.vy)/GAME.world.act_level.image_side) To Ceil((Self.y+Self.ry + Self.vy)/GAME.world.act_level.image_side)-1
				If GAME.world.act_level.has_collision(Floor((Self.x-Self.rx)/GAME.world.act_level.image_side) - 1, iy) Then
					Self.vx = (Floor((Self.x-Self.rx)/GAME.world.act_level.image_side)*GAME.world.act_level.image_side) - (Self.x-Self.rx)
					If Self.vx = 0 Then Self.coll_l = 1
				End If
			Next
		End If
		
		
		'---------------- up:
		If Floor((Self.y - Self.ry)/GAME.world.act_level.image_side) > Floor((Self.y - Self.ry + Self.vy)/GAME.world.act_level.image_side) Then
			'you have just entered a new row of blocks!
			
			For Local ix:Int = Floor((Self.x - Self.rx + Self.vx)/GAME.world.act_level.image_side) To Ceil((Self.x+Self.rx + Self.vx)/GAME.world.act_level.image_side)-1
				If GAME.world.act_level.has_collision(ix, Floor((Self.y-Self.ry)/GAME.world.act_level.image_side) - 1) Then
					Self.vy = (Floor((Self.y-Self.ry)/GAME.world.act_level.image_side)*GAME.world.act_level.image_side) - (Self.y-Self.ry)
					If Self.vy = 0 Then Self.coll_up = 1
				End If
			Next
		End If
		
	End Method
	
	Method draw()
		SetColor 255,255,255
		Draw_Image TBADIE.image, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y
		
	End Method
	
	Method write_to_stream(stream:TStream)
		stream.WriteInt(4)'OBJECT = 0        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		stream.WriteInt(Self.important)
	End Method
	
	Function read_from_stream:TBADIE(stream:TStream)
		Local o:TBADIE = New TBADIE
		
		
		o.id = stream.ReadInt()
		o.x = stream.ReadFloat()
		o.y = stream.ReadFloat()
		o.layer = stream.ReadInt()
		o.important = stream.ReadInt()
		
		
		Return o
	End Function
	
	Method write_to_stream_running(stream:TStream)
		stream.WriteInt(4)'OBJECT = 0        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		stream.WriteInt(Self.important)
		
		stream.WriteInt(Self.kill_me)'NEW !
		
		'NEW !!!
		stream.WriteFloat(Self.rx)
		stream.WriteFloat(Self.ry)
		
		stream.WriteFloat(Self.vx)
		stream.WriteFloat(Self.vy)
		
		stream.WriteInt(Self.coll_ground)
		stream.WriteInt(Self.coll_l)
		stream.WriteInt(Self.coll_r)
		stream.WriteInt(Self.coll_up)
		
		stream.WriteInt(Self.in_fire)
		stream.WriteInt(Self.in_water)
		stream.WriteInt(Self.in_lava)
		
		stream.WriteInt(Self.coll_ground_since)
		
		stream.WriteInt(Self.side_walking)
		
		stream.WriteInt(Self.coll_l_since)
		stream.WriteInt(Self.coll_r_since)
		
		stream.WriteInt(Self.next_jump_in)
	End Method
	
	
	Function read_from_stream_running:TBADIE(stream:TStream, delta_t:Int)
		Local o:TBADIE = New TBADIE
		
		
		o.id = stream.ReadInt()
		o.x = stream.ReadFloat()
		o.y = stream.ReadFloat()
		o.layer = stream.ReadInt()
		o.important = stream.ReadInt()
		
		o.kill_me = stream.ReadInt()'NEW !
				
		'NEW !!!
		o.rx = stream.ReadFloat()
		o.ry = stream.ReadFloat()
		
		o.vx = stream.ReadFloat()
		o.vy = stream.ReadFloat()
		
		o.coll_ground = stream.ReadInt()
		o.coll_l = stream.ReadInt()
		o.coll_r = stream.ReadInt()
		o.coll_up = stream.ReadInt()
		
		o.in_fire = stream.ReadInt()
		o.in_water = stream.ReadInt()
		o.in_lava = stream.ReadInt()
		
		o.coll_ground_since = stream.ReadInt() + delta_t
		
		o.side_walking = stream.ReadInt()
		
		o.coll_l_since = stream.ReadInt() + delta_t
		o.coll_r_since = stream.ReadInt() + delta_t
		
		o.next_jump_in = stream.ReadInt()
		
		Return o
	End Function
	
	Method copy:TBADIE()
		Local p:TBADIE = New TBADIE
		
		p.x = Self.x
		p.y = Self.y
		p.layer = Self.layer
		p.important = Self.important
		
		Return p
	End Method
End Type

'########################################################################################
'###########################        #####################################################
'########################### PLAYER #####################################################
'###########################        #####################################################
'########################################################################################

Type TPLAYER Extends TMob
	
	Field mode:TPLAYER_MODE
	Field old_mode:TPLAYER_MODE
	
	Field temperature:Float = 0
	
	Field water_amount:Float = 0
	Field water_charge:Float = 0
	Field burning_for:Float = 0
	
	Field last_teleport:Int
	Field last_in_teleportation:Int = 0
	
	Field next_jump_in:Int
	Global jump_delay:Int = 100
	
	Field light:TLight
	
	Field last_vy:Float
	
	Function init()
		'hmmm ..... nothing here any more...
	End Function
	
	Method New()
		Self.layer = 2
		Self.important = 1
		
		Self.light = TLight.Create(TLight.source_normal,0,0)
		Self.light.set_color(255,255,255)
		
		
		Self.set_mode(TPLAYER_MODE.modes[0])
	End Method
	
	
	Function Create:TPLAYER(x:Float,y:Float)
		Local p:TPLAYER = New TPLAYER
		
		p.x = x
		p.y = y
		
		Return p
	End Function
	
	Method render()
		
		GAME.world.act_level.ansicht_ziel_x = - Self.x + 400
		GAME.world.act_level.ansicht_ziel_y = - Self.y + 300
		
		
		If Not GAME.world.act_level.player Then
			GAME.world.act_level.player = Self
			GAME.world.act_level.goto_ansicht_ziel()
		End If
		
		
		If Self.mode = TPLAYER_MODE.modes[5] And Self.last_vy > 2.0 And  Self.vy < 1.0 Then'stone collision stone
			GAME.world.act_level.break_stone_boxes(Self)
		End If
		
		
		
		Self.x:+Self.vx
		Self.y:+Self.vy
		
		Self.last_vy = Self.vy
		
		If KeyDown(key_f5) And CHEAT_MODE Then
			Self.vy:-(Self.mode.gravity+0.2)
		End If
		
		If Not (Self.mode = TPLAYER_MODE.modes[4]) Then'transparent
			'#########################
			
			Self.light.image = Self.mode.light_image
			Self.light.x = Self.x
			Self.light.y = Self.y
			Self.light.render()
			Self.light.draw_to_buffer()
			
			'######################
		End If
		
		Self.mode.render(Self.vx, Self.vy, Self.coll_ground, Self)
		
		If Self.mode = TPLAYER_MODE.modes[3] Then' RENDER TEMPERATURE
			If Self.temperature < 100.0 Then
				Self.set_mode(TPLAYER_MODE.modes[2])
			Else If Self.temperature > 200.0 Then
				Self.set_mode(TPLAYER_MODE.modes[1])
			End If
			
			Self.temperature:-0.2'cool it
		Else If Self.mode = TPLAYER_MODE.modes[2] Then
			Self.temperature:-0.2'cool it
			If Self.temperature<10.0 Then
				Self.temperature = 10.0
			End If
		End If
		
		
		If Self.in_water > 0 Then
			Self.vy:+ Self.mode.gravity_water 'Gravity
			
			Self.water_amount = 84.0
		Else
			If Self.mode = TPLAYER_MODE.modes[2] Then
				If Self.coll_ground = 1 Then
					Self.vy=0.1
				Else If Self.coll_l = 1 Then
					Self.vy:*0.9
					Self.vx = -0.1
				ElseIf Self.coll_r = 1 Then
					Self.vy:*0.9
					Self.vx = 0.1
				Else If Self.coll_up = 1 Then
					Self.vy = -0.1
				Else
					Self.vy:+ Self.mode.gravity 'Gravity
				End If
			Else
				If Self.mode = TPLAYER_MODE.modes[1] Then
					If Rand(0,6)>4 Then
						Self.vy:-Self.mode.gravity
					Else
						Self.vy:+Self.mode.gravity
					End If
				Else
					Self.vy:+ Self.mode.gravity 'Gravity
				End If
			End If
		End If
		
		If TControls.up.key.hold Then
			If Self.mode = TPLAYER_MODE.modes[2] Then'water
				
				If Not Self.coll_ground = 1 Then Self.water_charge = 0
				
				If Self.coll_l = 1 Or Self.coll_r = 1 Then
					Self.vy = - Self.mode.speed
				End If
			End If
			
			If Self.coll_ground = 1 Then
				If Self.vy > Self.mode.jump And MilliSecs() > Self.next_jump_in Then
					
					If Self.mode = TPLAYER_MODE.modes[2] Then'water charge
						
						Self.water_charge:+0.8*60.0/Graphics_Handler.FPS_MAX
						
						If Self.water_charge < 20 Then Self.water_charge = 20'water minimum charge
						
						If Self.water_charge >= Self.water_amount*4.0 Then
							Self.water_charge = Self.water_amount*4.0
							TControls.up.key.hold = 0
						End If
						
						If Self.water_charge >= 84.0 Then
							Self.water_charge = 84.0
							TControls.up.key.hold = 0
						End If
						
					Else'normal jump
						Self.next_jump_in = MilliSecs() + TPLAYER.jump_delay
						
						Self.vy = Self.mode.jump
					End If
				End If
			Else If Self.in_water = 2 Then' in water
				If Self.vy > Self.mode.jump_swim Then
					Self.vy = Self.mode.jump_swim
				End If
			Else If Self.mode = TPLAYER_MODE.modes[3] Then'steam
				Self.vy = Self.mode.jump
			End If
		End If
		
		
		If TPLAYER_MODE.modes[2]=Self.mode Then
			If Not TControls.up.key.hold And Self.water_charge > 0 Then
				Self.water_amount:-(Self.water_charge/4.0)
				
				Self.next_jump_in = MilliSecs() + TPLAYER.jump_delay
				
				'Sound_Handler.play("tschiu",Self.x)
				TSoundPlayer.run("tschiu",Self.x,Self.y,Self,10000000)
				
				Self.vy = Self.mode.jump*Self.water_charge/84.0
				Self.vx = 0
				
				Self.water_charge = 0
				
			End If
			
			If Self.water_amount = 0 And Self.vy >= 0 Then
				Self.set_mode(TPLAYER_MODE.modes[0],1)
			End If
		Else
			If TPLAYER_MODE.modes[7] <> Self.mode And TPLAYER_MODE.modes[3] <> Self.mode Then Self.water_amount = 0
			Self.water_charge = 0
		End If
		
		
		
		If TControls.down.key.hold Then
			If Self.mode = TPLAYER_MODE.modes[2] Then'water
				If Self.coll_l = 1 Or Self.coll_r = 1 Then
					Self.vy = Self.mode.speed
				End If
				
				If Self.coll_up Then
					Self.vy=0
				End If
			End If
		End If
		
		If TControls.ability.key.hit And Self.mode = TPLAYER_MODE.modes[5] Then'stone smash down
			If Self.coll_ground = 1 Then
				
				Self.mode.act_image = 2
				Self.mode.act_frame = 0
				
			End If
		End If
		
		If Self.mode.act_image = 2 And Self.mode = TPLAYER_MODE.modes[5] Then'stone smash down part 2
			
			If Self.mode.act_frame = Self.mode.images[Self.mode.act_image, Self.mode.act_side].frames.length-1
				
				'break it !!!
				
				Self.mode.act_image = 0
				Self.mode.act_frame = 0
				
				Self.set_mode(TPLAYER_MODE.modes[0],1)
				
				GAME.world.act_level.break_stone_boxes(Self)
				
			End If
		End If
		
		If TPLAYER_MODE.modes[1]=Self.mode Then'fire
			Self.burning_for:+0.2
			
			If Self.burning_for > 600 Then
				Self.kill_me = 1
				
				For Local i:Int = 1 To 400
					Local w:Float = Rnd()*360.0
					Local s:Float = Rnd()*1.5+0.5
					TPARTIKEL.Create(Rand(0,3), 1,  Self.x,Self.y,   Cos(w)*s,Sin(w)*s,-0.1-Rnd()*0.1, Rnd()*360.0,Rnd()*4.0-2.0, Rnd()*1.0+2.0,Rnd()*0.5+0.5, 60)
				Next
			EndIf
		Else
			Self.burning_for=0
		End If
		
		If TControls.ability.key.hit And TPLAYER_MODE.modes[6]=Self.mode Then'plant
			Self.set_mode(TPLAYER_MODE.modes[0],1)
			
			'Sound_Handler.play("raschel"+Rand(1,2),Self.x)
			TSoundPlayer.run("raschel"+Rand(1,2),Self.x,Self.y,Self,10000000)
			
			For Local i:Int = 0 To 50
				Local w:Float = Rnd()*360.0
				Local s:Float = Rnd()*1.0+0.5
				TPARTIKEL.Create(Rand(5,7), 3,  Self.x-Self.rx + Rnd()*2.0*Self.rx, Self.y-Self.ry + Rnd()*2.0*Self.ry,   Cos(w)*s,Sin(w)*s,0.1, Rnd()*360.0,Rnd()*4.0-2.0, Rnd()+1.0,1.0, 100)
			Next
		End If
		
		
		If TPLAYER_MODE.modes[2]=Self.mode And Self.vy < -0.2 And Self.coll_r = 0 And Self.coll_l = 0 Then 'water
			For Local i:Int = 1 To Float(2+(Self.in_water = 0)*4)*60.0/Graphics_Handler.FPS_MAX
				TPARTIKEL_WATER.Create(Rand(12,15), 1,  Self.x - 0.5*Self.rx + Float(Rand(0,10))/10.0*Self.rx, Self.y + Self.ry-Rnd()*5.0, 0,0.5+0.4*Rnd(), 0.01, 0,0, 1.0,1.0, 100)
			Next
		End If
		
		
		If Self.mode = TPLAYER_MODE.modes[3] Then'steam
			For Local i:Int = 0 To 2*60.0/Graphics_Handler.FPS_MAX
				TPARTIKEL.Create(19, 1,  Self.x + Rnd()*Self.rx, Self.y - Self.ry + Self.ry*Rnd()*2.0, Rnd()*2.0,Self.vy + Rnd()*3.0 - 1.5, -0.005, Rnd()*360,Rnd()*10.0, 1.0,0.8, 100)
			Next
			
			For Local i:Int = 0 To 2*60.0/Graphics_Handler.FPS_MAX
				TPARTIKEL.Create(20, 1,  Self.x - Rnd()*Self.rx, Self.y - Self.ry + Self.ry*Rnd()*2.0, - Rnd()*2.0,Self.vy + Rnd()*3.0 - 1.5, -0.005, Rnd()*360,-Rnd()*10.0, 1.0,0.8, 100)
			Next
		End If
		
		
		If TPLAYER_MODE.modes[7]=Self.mode Then'ice
			If TControls.down.key.hit Or TControls.up.key.hit Or TControls.r.key.hit Or TControls.l.key.hit Or TControls.ability.key.hit Then
				
				Local xx:Float = Self.x
				Self.set_mode(TPLAYER_MODE.modes[0],1)
				Self.x = xx
				Self.vx = 0
				Self.vy = 0
				
				'ICE PLATFORM
				Local s:TBox_Stone = TBox_Stone(TBox_Stone.Create(Self.x - TBox_Stone.stone_typs[2,0].dx*0.5, Self.y+Self.ry+0.1, 2, 3, 0))
				s.set_breaking()
				TBox_Renderer_Stone(s.renderer).coll_down_on = 1
				TBox_Renderer_Stone(s.renderer).coll_up_on = 0
				TBox_Renderer_Stone(s.renderer).coll_r_on = 0
				TBox_Renderer_Stone(s.renderer).coll_l_on = 0
				
				GAME.world.act_level.add_object(s)
				
				For Local i:Int = 0 To 100
					Local w:Float = Rnd()*360.0
					Local s:Float = Rnd()*1.0+0.5
					TPARTIKEL.Create(11, 3,  Self.x-Self.rx + Rnd()*2.0*Self.rx, Self.y-Self.ry + Rnd()*2.0*Self.ry,   Cos(w)*s,Sin(w)*s, -0.001, Rnd()*360.0,Rnd()*4.0-2.0, 0.7+Rnd()*0.5,1.0, 200)
				Next
			End If
		End If
		
		If TControls.suicide.key.hit Then'SUICIDE
			TControls.suicide.key.hit = 0
			FlushKeys()
			Self.kill_me = 1
			Print "SUICIDE !!!!!!!!!!"
		End If
		
		If TControls.ability.key.hit And TPLAYER_MODE.modes[2]=Self.mode Then 'water
			
			Local xx:Float = Self.x
			Self.set_mode(TPLAYER_MODE.modes[7],1)
			Self.x = xx
			Self.vx = 0
			Self.vy = 0
		End If
		
		
		If Self.in_water > 0 Then
			If TControls.l.key.hold Then Self.vx = - Self.mode.speed_swim
			If TControls.r.key.hold Then Self.vx = Self.mode.speed_swim
		Else
			If TControls.l.key.hold Then Self.vx = - Self.mode.speed
			If TControls.r.key.hold Then Self.vx = Self.mode.speed
		End If
		
		
		'-------- 60.0/Graphics_Handler.FPS_MAX
		If Self.mode = TPLAYER_MODE.modes[3] Then'steam
			Self.vy:*(0.95^(60.0/Graphics_Handler.FPS_MAX))
			Self.vx:*(0.9^(60.0/Graphics_Handler.FPS_MAX))
		ElseIf Self.coll_ground = 1 Then
			Self.vx:*(0.75^(60.0/Graphics_Handler.FPS_MAX))
		Else If Self.in_water > 0 Then
			Self.vx:*(0.75^(60.0/Graphics_Handler.FPS_MAX))
			'If Self.coll_r = 0 And Self.coll_l = 0 Then
				Self.vy:*(0.97^(60.0/Graphics_Handler.FPS_MAX))
			'End If
		Else
			Self.vx:*(0.9^(60.0/Graphics_Handler.FPS_MAX))
		End If
		'--------
		
		
		If Self.in_fire = 1 Then
			Self.set_mode(TPLAYER_MODE.modes[1])
		End If
		
		If Self.in_water > 0 Then
			Self.set_mode(TPLAYER_MODE.modes[2])
		End If
		
		If Self.in_lava = 1 Then
			Self.set_mode(TPLAYER_MODE.modes[1])
		End If
		
		Super.render()
		
		
		'--------------- collision --------------
		Self.coll_ground = 0
		Self.coll_l = 0
		Self.coll_r = 0
		Self.coll_up = 0
		
		'---------------- ground + andti wall climber
		If Ceil((Self.y + Self.mode.ry)/GAME.world.act_level.image_side) < Ceil((Self.y+Self.mode.ry + Self.vy)/GAME.world.act_level.image_side) Then
			'going one down
			
			If Ceil((Self.x + Self.mode.rx)/GAME.world.act_level.image_side) < Ceil((Self.x+Self.mode.rx + Self.vx)/GAME.world.act_level.image_side) Then
				'going one to the right
				
				Local iy:Int = Ceil((Self.y+Self.mode.ry  + Self.vy)/GAME.world.act_level.image_side)-1
				Local ix:Int = Ceil((Self.x+Self.mode.rx)/GAME.world.act_level.image_side)
				If GAME.world.act_level.has_collision(ix, iy) And GAME.world.act_level.has_collision(ix, iy - 1) Then
					Self.vx = (Ceil((Self.x+Self.mode.rx)/GAME.world.act_level.image_side)*GAME.world.act_level.image_side) - (Self.x+Self.mode.rx)
					
					If Self.vx = 0 Then Self.coll_r = 1
				End If
				
			End If
			
			If Floor((Self.x - Self.mode.rx)/GAME.world.act_level.image_side) > Floor((Self.x - Self.mode.rx + Self.vx)/GAME.world.act_level.image_side) Then
				'going one to the left
				
				
				Local iy:Int = Ceil((Self.y+Self.mode.ry + Self.vy)/GAME.world.act_level.image_side)-1
				Local ix:Int = Floor((Self.x-Self.mode.rx)/GAME.world.act_level.image_side) - 1
				If GAME.world.act_level.has_collision(ix, iy) And GAME.world.act_level.has_collision(ix, iy - 1) Then
					Self.vx = (Floor((Self.x-Self.mode.rx)/GAME.world.act_level.image_side)*GAME.world.act_level.image_side) - (Self.x-Self.mode.rx)
					If Self.vx = 0 Then Self.coll_l = 1
				End If
				
			End If
			
			
			'---------------- ground:
			'you have just entered a new row of blocks!
			
			'muss +vx haben, damit keine stÃÂÃÂ¶runen wenn genau auf ecke des blockes fÃÂÃÂ¤llt
			For Local ix:Int = Floor((Self.x - Self.mode.rx + Self.vx)/GAME.world.act_level.image_side) To Ceil((Self.x+Self.mode.rx + Self.vx)/GAME.world.act_level.image_side)-1
				If GAME.world.act_level.has_collision(ix,Ceil((Self.y+Self.mode.ry)/GAME.world.act_level.image_side)) Then
					Self.vy = (Ceil((Self.y+Self.mode.ry)/GAME.world.act_level.image_side)*GAME.world.act_level.image_side) - (Self.y+Self.mode.ry)
					
					If Self.vy = 0 Then Self.coll_ground = 1
				End If
			Next
			
		End If
		
		
		
		'---------------- top + andti wall stop jumping
		If Floor((Self.y - Self.mode.ry)/GAME.world.act_level.image_side) > Floor((Self.y - Self.mode.ry + Self.vy)/GAME.world.act_level.image_side) Then
			'going one up
			
			
			If Ceil((Self.x + Self.mode.rx)/GAME.world.act_level.image_side) < Ceil((Self.x+Self.mode.rx + Self.vx)/GAME.world.act_level.image_side) Then
				'going one to the right
				
				Local iy:Int = Floor((Self.y - Self.mode.ry)/GAME.world.act_level.image_side)
				Local ix:Int = Ceil((Self.x+Self.mode.rx)/GAME.world.act_level.image_side)
				If GAME.world.act_level.has_collision(ix, iy) And GAME.world.act_level.has_collision(ix, iy - 1) Then
					Self.vx = (Ceil((Self.x+Self.mode.rx)/GAME.world.act_level.image_side)*GAME.world.act_level.image_side) - (Self.x+Self.mode.rx)
					
					If Self.vx = 0 Then Self.coll_r = 1
				End If
				
			End If
			
			If Floor((Self.x - Self.mode.rx)/GAME.world.act_level.image_side) > Floor((Self.x - Self.mode.rx + Self.vx)/GAME.world.act_level.image_side) Then
				'going one to the left
				
				
				Local iy:Int = Floor((Self.y - Self.mode.ry)/GAME.world.act_level.image_side)
				Local ix:Int = Floor((Self.x-Self.mode.rx)/GAME.world.act_level.image_side) - 1
				If GAME.world.act_level.has_collision(ix, iy) And GAME.world.act_level.has_collision(ix, iy - 1) Then
					Self.vx = (Floor((Self.x-Self.mode.rx)/GAME.world.act_level.image_side)*GAME.world.act_level.image_side) - (Self.x-Self.mode.rx)
					If Self.vx = 0 Then Self.coll_l = 1
				End If
				
			End If
			
			
			'---------------- top:
			'you have just entered a new row of blocks!
			
			For Local ix:Int = Floor((Self.x - Self.mode.rx + Self.vx)/GAME.world.act_level.image_side) To Ceil((Self.x+Self.mode.rx + Self.vx)/GAME.world.act_level.image_side)-1
				If GAME.world.act_level.has_collision(ix, Floor((Self.y-Self.mode.ry)/GAME.world.act_level.image_side) - 1) Then
					Self.vy = (Floor((Self.y-Self.mode.ry)/GAME.world.act_level.image_side)*GAME.world.act_level.image_side) - (Self.y-Self.mode.ry)
					If Self.vy = 0 Then Self.coll_up = 1
				End If
			Next
		End If
		
		
		'---------------- r:
		If Ceil((Self.x + Self.mode.rx)/GAME.world.act_level.image_side) < Ceil((Self.x+Self.mode.rx + Self.vx)/GAME.world.act_level.image_side) Then
			'you have just entered a new row of blocks!
			
			For Local iy:Int = Floor((Self.y - Self.mode.ry  + Self.vy)/GAME.world.act_level.image_side) To Ceil((Self.y+Self.mode.ry  + Self.vy)/GAME.world.act_level.image_side)-1
				If GAME.world.act_level.has_collision(Ceil((Self.x+Self.mode.rx)/GAME.world.act_level.image_side), iy) Then
					Self.vx = (Ceil((Self.x+Self.mode.rx)/GAME.world.act_level.image_side)*GAME.world.act_level.image_side) - (Self.x+Self.mode.rx)
					
					If Self.vx = 0 Then Self.coll_r = 1
				End If
			Next
		End If
		
		'---------------- l:
		If Floor((Self.x - Self.mode.rx)/GAME.world.act_level.image_side) > Floor((Self.x - Self.mode.rx + Self.vx)/GAME.world.act_level.image_side) Then
			'you have just entered a new row of blocks!
			
			For Local iy:Int = Floor((Self.y - Self.mode.ry + Self.vy)/GAME.world.act_level.image_side) To Ceil((Self.y+Self.mode.ry + Self.vy)/GAME.world.act_level.image_side)-1
				If GAME.world.act_level.has_collision(Floor((Self.x-Self.mode.rx)/GAME.world.act_level.image_side) - 1, iy) Then
					Self.vx = (Floor((Self.x-Self.mode.rx)/GAME.world.act_level.image_side)*GAME.world.act_level.image_side) - (Self.x-Self.mode.rx)
					If Self.vx = 0 Then Self.coll_l = 1
				End If
			Next
		End If
		
		Self.rx = Self.mode.rx
		Self.ry = Self.mode.ry
	End Method
	
	Method draw()
		Rem
		SetColor 255,255,255
		Draw_Image TPLAYER.image, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y
		End Rem
		
		If Self.mode = TPLAYER_MODE.modes[2] Then
			If Self.coll_r = 1 Then
				SetRotation 270
			ElseIf Self.coll_l = 1 Then
				SetRotation 90
			ElseIf Self.coll_up = 1 Then
				SetRotation 180
			End If
		End If
		
		If Self.coll_up = 1 And Self.mode = TPLAYER_MODE.modes[2] Then SetScale -1,1
		
		Self.mode.draw(Self.x, Self.y)
		SetScale 1,1
		SetRotation 0
		
		
	End Method
	
	Method kill()'delete from memory
		Super.kill()
		
		GAME.world.act_level.player = Null
	End Method
	
	Method write_to_stream(stream:TStream)
		stream.WriteInt(1)'OBJECT = 0        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		stream.WriteInt(Self.important)
	End Method
	
	Function read_from_stream:TObject(stream:TStream)
		Local o:TPLAYER = New TPLAYER
		
		o.id = stream.ReadInt()
		o.x = stream.ReadFloat()
		o.y = stream.ReadFloat()
		o.layer = stream.ReadInt()
		o.important = stream.ReadInt()
		
		Return o
	End Function
	
	Method write_to_stream_running(stream:TStream)
		stream.WriteInt(1)'OBJECT = 0        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		stream.WriteInt(Self.important)
		
		stream.WriteInt(Self.kill_me)'NEW !
		
		'NEW !!!
		stream.WriteFloat(Self.rx)
		stream.WriteFloat(Self.ry)
		
		stream.WriteFloat(Self.vx)
		stream.WriteFloat(Self.vy)
		
		stream.WriteInt(Self.coll_ground)
		stream.WriteInt(Self.coll_l)
		stream.WriteInt(Self.coll_r)
		stream.WriteInt(Self.coll_up)
		
		stream.WriteInt(Self.in_fire)
		stream.WriteInt(Self.in_water)
		stream.WriteInt(Self.in_lava)
		
		DATA_FILE_HANDLER.WriteString(stream, Self.mode.name)
		
		stream.WriteFloat(Self.temperature)
		
		stream.WriteFloat(Self.water_amount)
		stream.WriteFloat(Self.water_charge)
		stream.WriteFloat(Self.burning_for)
	End Method
	
	
	
	Function read_from_stream_running:TObject(stream:TStream, delta_t:Int)
		Local o:TPLAYER = New TPLAYER
		
		o.id = stream.ReadInt()
		o.x = stream.ReadFloat()
		o.y = stream.ReadFloat()
		o.layer = stream.ReadInt()
		o.important = stream.ReadInt()
		
		o.kill_me = stream.ReadInt()'NEW !
				
		'NEW !!!
		o.rx = stream.ReadFloat()
		o.ry = stream.ReadFloat()
		
		o.vx = stream.ReadFloat()
		o.vy = stream.ReadFloat()
		
		o.coll_ground = stream.ReadInt()
		o.coll_l = stream.ReadInt()
		o.coll_r = stream.ReadInt()
		o.coll_up = stream.ReadInt()
		
		o.in_fire = stream.ReadInt()
		o.in_water = stream.ReadInt()
		o.in_lava = stream.ReadInt()
		
		Local mn:String = DATA_FILE_HANDLER.ReadString(stream)
		'Self.mode.name
		
		For Local m:TPLAYER_MODE = EachIn TPLAYER_MODE.modes
			If mn = m.name Then
				o.mode = m
				Exit
			End If
		Next
		
		If Not o.mode Then Print "this is a desaster! mode does not exist!"
		
		
		o.temperature = stream.ReadFloat()
		
		o.water_amount = stream.ReadFloat()
		o.water_charge = stream.ReadFloat()
		o.burning_for = stream.ReadFloat()
		
		Return o
	End Function
	
	Method set_mode_teleport()
		If Self.mode <> TPLAYER_MODE.modes[4] Then
			Self.old_mode = Self.mode
		End If
		Self.set_mode(TPLAYER_MODE.modes[4])
		Print "set me teleport!"
	End Method
	
	Method set_mode_after_teleport(name:String)
		If Self.mode = TPLAYER_MODE.modes[4] Then'transparent
			Print "hullo! " + name
			Select name
				Case "normal"'["normal", "fire", "water", "steam","transparent","stone","plant","ice"]
					Self.set_mode(TPLAYER_MODE.modes[0],1)
				Case "fire"
					Self.set_mode(TPLAYER_MODE.modes[1],1)
				Case "water"
					Self.set_mode(TPLAYER_MODE.modes[2],1)
				Case "steam"
					Self.set_mode(TPLAYER_MODE.modes[3],1)
				Case "transparent"
					Self.set_mode(TPLAYER_MODE.modes[4],1)
				Case "stone"
					Self.set_mode(TPLAYER_MODE.modes[5],1)
				Case "plant"
					Self.set_mode(TPLAYER_MODE.modes[6],1)
				Case "ice"
					Self.set_mode(TPLAYER_MODE.modes[7],1)
				Case "old"
					Self.set_mode(Self.old_mode)
				Default
					Print "mode not found: " + name
			End Select
		End If
	End Method
	
	
	Method set_mode(mode:TPLAYER_MODE,enforce:Int = 0)
		
		If Self.mode = mode Then Return
		
		If enforce = 0 Then
			
			Select Self.mode
				Case TPLAYER_MODE.modes[0]'normal
					
					
					
				Case TPLAYER_MODE.modes[1]'fire
					
					Self.temperature = 200.0
					
					Rem
					If mode = TPLAYER_MODE.modes[2] Then 'water
						Self.set_mode(TPLAYER_MODE.modes[3])'steam
						Return
					End If
					
					If mode = TPLAYER_MODE.modes[3] Then
					End If
					End Rem
					
				Case TPLAYER_MODE.modes[2]'water
					
					If mode = TPLAYER_MODE.modes[1] Then 'fire
						Self.set_mode(TPLAYER_MODE.modes[3])'steam
						Return
					End If
					
				Case TPLAYER_MODE.modes[3]'steam
					
					If mode = TPLAYER_MODE.modes[1] Then 'fire
						If Self.temperature < 200.0 Then
							Self.temperature:+1.5
							Self.set_mode(TPLAYER_MODE.modes[3])'steam
							Return
						End If
						
					Else If mode = TPLAYER_MODE.modes[2] Then 'water
						If Self.temperature > 100.0 Then
							Self.temperature:-1.0
							Self.set_mode(TPLAYER_MODE.modes[3])'steam
							Return
						End If
					End If
				Case TPLAYER_MODE.modes[5]'stone
					Return
			End Select
		End If
		
		If Self.mode = mode Then Return
		
		Select mode
			Case TPLAYER_MODE.modes[0]'normal
				
				Self.temperature = 37.0
				
			Case TPLAYER_MODE.modes[1]'fire
				
				Self.temperature = 200.0
				
			Case TPLAYER_MODE.modes[2]'water
				
				'Self.temperature = 100.0
				Self.water_amount = 84.0
				
			Case TPLAYER_MODE.modes[3]'steam
				If Self.mode = TPLAYER_MODE.modes[1] Then
					Self.temperature=199.0
				Else If Self.mode = TPLAYER_MODE.modes[2] Then
					Self.temperature:+5.0
				End If
			Case TPLAYER_MODE.modes[7]'ice
				Self.temperature = 2.0
		End Select
		
		If Self.mode <> Null Then
			If Self.vx => 0 Then
				Self.x:+ (Self.mode.rx - mode.rx)
			Else
				Self.x:- (Self.mode.rx - mode.rx)
			End If
			
			If Self.vy => 0 Then
				Self.y:+ (Self.mode.ry - mode.ry)
			Else
				Self.y:- (Self.mode.ry - mode.ry)
			End If
			
			mode.act_side = Self.mode.act_side
		End If
		
		Self.mode = mode
		
		Self.rx = Self.mode.rx
		Self.ry = Self.mode.ry
		
		Self.mode.act_frame = 0
		Self.mode.last_frame_change = MilliSecs()
		
		
	End Method
End Type

'########################################################################################
'###########################              ###############################################
'########################### PLAYER MODE  ###############################################
'###########################              ###############################################
'########################################################################################

Type TPLAYER_MODE
	
	Global modes:TPLAYER_MODE[8]
	
	Function init()
		TPLAYER_MODE.modes[0] = TPLAYER_MODE.Create("normal")
		
		TPLAYER_MODE.modes[0].nfs_gravity = 0.4
		TPLAYER_MODE.modes[0].nfs_gravity_water = 0.6
		TPLAYER_MODE.modes[0].nfs_jump = -9.0
		TPLAYER_MODE.modes[0].nfs_speed = 6.0
		TPLAYER_MODE.modes[0].nfs_jump_swim = -0.3
		TPLAYER_MODE.modes[0].nfs_speed_swim = 2.0
		TPLAYER_MODE.modes[0].render_fps_sync()
		
		
		TPLAYER_MODE.modes[1] = TPLAYER_MODE.Create("fire")
		
		TPLAYER_MODE.modes[1].nfs_gravity = 0.15
		TPLAYER_MODE.modes[1].nfs_gravity_water = -0.4
		TPLAYER_MODE.modes[1].nfs_jump = -5.0
		TPLAYER_MODE.modes[1].nfs_speed = 4.5
		TPLAYER_MODE.modes[1].nfs_jump_swim = -5.0
		TPLAYER_MODE.modes[1].nfs_speed_swim = 3.0
		TPLAYER_MODE.modes[1].render_fps_sync()
		
		
		TPLAYER_MODE.modes[2] = TPLAYER_MODE.Create("water")
		
		TPLAYER_MODE.modes[2].nfs_gravity = 0.25
		TPLAYER_MODE.modes[2].nfs_gravity_water = 0.3
		TPLAYER_MODE.modes[2].nfs_jump = -15.0
		TPLAYER_MODE.modes[2].nfs_speed = 3.5
		TPLAYER_MODE.modes[2].nfs_jump_swim = -8.0
		TPLAYER_MODE.modes[2].nfs_speed_swim = 6.0
		TPLAYER_MODE.modes[2].render_fps_sync()
		
		
		TPLAYER_MODE.modes[3] = TPLAYER_MODE.Create("steam")
		
		TPLAYER_MODE.modes[3].nfs_gravity = -0.15
		TPLAYER_MODE.modes[3].nfs_gravity_water = -0.8
		TPLAYER_MODE.modes[3].nfs_jump = -1.5
		TPLAYER_MODE.modes[3].nfs_speed = 2.5
		TPLAYER_MODE.modes[3].nfs_jump_swim = -1.0
		TPLAYER_MODE.modes[3].nfs_speed_swim = 2.0
		TPLAYER_MODE.modes[3].render_fps_sync()
		
		
		TPLAYER_MODE.modes[4] = TPLAYER_MODE.Create("transparent")
		
		TPLAYER_MODE.modes[4].nfs_gravity = 0
		TPLAYER_MODE.modes[4].nfs_gravity_water = 0
		TPLAYER_MODE.modes[4].nfs_jump = 0
		TPLAYER_MODE.modes[4].nfs_speed = 0
		TPLAYER_MODE.modes[4].nfs_jump_swim = 0
		TPLAYER_MODE.modes[4].nfs_speed_swim = 0
		TPLAYER_MODE.modes[4].render_fps_sync()
		
		
		TPLAYER_MODE.modes[5] = TPLAYER_MODE.Create("stone")
		
		TPLAYER_MODE.modes[5].nfs_gravity = 0.4
		TPLAYER_MODE.modes[5].nfs_gravity_water = 0.4
		TPLAYER_MODE.modes[5].nfs_jump = -4.0
		TPLAYER_MODE.modes[5].nfs_speed = 2.0
		TPLAYER_MODE.modes[5].nfs_jump_swim = 0
		TPLAYER_MODE.modes[5].nfs_speed_swim = 1.5
		TPLAYER_MODE.modes[5].render_fps_sync()
		
		
		TPLAYER_MODE.modes[6] = TPLAYER_MODE.Create("plant")
		
		TPLAYER_MODE.modes[6].nfs_gravity = 0.4
		TPLAYER_MODE.modes[6].nfs_gravity_water = 0.6
		TPLAYER_MODE.modes[6].nfs_jump = 0
		TPLAYER_MODE.modes[6].nfs_speed = 3.0
		TPLAYER_MODE.modes[6].nfs_jump_swim = 0
		TPLAYER_MODE.modes[6].nfs_speed_swim = 2.0
		TPLAYER_MODE.modes[6].render_fps_sync()
		
		
		TPLAYER_MODE.modes[7] = TPLAYER_MODE.Create("ice")
		
		TPLAYER_MODE.modes[7].nfs_gravity = 0
		TPLAYER_MODE.modes[7].nfs_gravity_water = 0
		TPLAYER_MODE.modes[7].nfs_jump = 0
		TPLAYER_MODE.modes[7].nfs_speed = 0
		TPLAYER_MODE.modes[7].nfs_jump_swim = 0
		TPLAYER_MODE.modes[7].nfs_speed_swim = 0
		TPLAYER_MODE.modes[7].render_fps_sync()
		
	End Function
	
	Method render_fps_sync()
		
		Self.gravity = Self.nfs_gravity*(60.0/Graphics_Handler.FPS_MAX)^2.0'm/s^2
		Self.gravity_water = Self.nfs_gravity_water*(60.0/Graphics_Handler.FPS_MAX)^2'm/s^2
		Self.jump = Self.nfs_jump*60.0/Graphics_Handler.FPS_MAX'm/s
		
		Self.speed = Self.nfs_speed*60.0/Graphics_Handler.FPS_MAX'm/s
		Self.jump_swim = Self.nfs_jump_swim*60.0/Graphics_Handler.FPS_MAX'm/s
		Self.speed_swim = Self.nfs_speed_swim*60.0/Graphics_Handler.FPS_MAX'm/s
		
	End Method
	
	Field name:String
	
	Field images:TImage[4,2]' 0 = standing, 1 = walking, 2 = jumping, 3 = falling ; 0 = r , 1 = l
	Field act_image:Int = 0
	Field act_side:Int = 0
	Field images_speed:Int[4,2]
	Field act_frame:Int = 0
	Field last_frame_change:Int
	
	Field image_x:Int
	Field image_y:Int
	
	Field rx:Float
	Field ry:Float
	
	Field image_x1:Float
	Field image_x2:Float
	
	Field image_y1:Float
	Field image_y2:Float
	
	Field nfs_gravity:Float'NOT fps synced
	Field nfs_gravity_water:Float
	Field nfs_jump:Float
	Field nfs_jump_swim:Float
	Field nfs_speed:Float
	Field nfs_speed_swim:Float
	
	Field gravity:Float'fps synced
	Field gravity_water:Float
	Field jump:Float
	Field jump_swim:Float
	Field speed:Float
	Field speed_swim:Float
	
	Field light_image:TImage
	
	Method render(vx:Float, vy:Float, coll_ground:Int, player:TPLAYER)
		
		Self.render_fps_sync()
		
		Local new_image:Int
		
		If vx > 0 Then
			Self.act_side = 0
		Else If vx < 0 Then
			Self.act_side = 1
		Else
			'wenn genau still steht nix machen
		End If
		
		
		
		Select player.mode
			Case TPLAYER_MODE.modes[0]'normal
				
				If vy > 4.5 Then
					'falling
					new_image = 3
				ElseIf vy < -0.2 Then
					'jumping
					new_image = 2
				Else
					If Abs(vx) > 0.05 Then
						'walking
						new_image = 1
					Else
						'standing
						new_image = 0
					End If
				End If
			Case TPLAYER_MODE.modes[1]
				new_image = 0
			Case TPLAYER_MODE.modes[2]
				
				If player.coll_r = 1 Then
					If Abs(vy) > 0.05 Then
						'walking
						new_image = 1
						
						If vy > 0 Then
							Self.act_side = 1
						Else If vy < 0 Then
							Self.act_side = 0
						Else
							'wenn genau still steht nix machen
						End If
					Else
						'standing
						new_image = 0
					End If
				ElseIf player.coll_l = 1 Then
					If Abs(vy) > 0.05 Then
						'walking
						new_image = 1
						
						If vy > 0 Then
							Self.act_side = 0
						Else If vy < 0 Then
							Self.act_side = 1
						Else
							'wenn genau still steht nix machen
						End If
					Else
						'standing
						new_image = 0
					End If
				ElseIf player.coll_up = 1 Then
					
					If Abs(vx) > 0.05 Then
						'walking
						new_image = 1
					Else
						'standing
						new_image = 0
					End If
					
					
				Else
					If coll_ground = 1 Then
						'standing or walking
						
						If Abs(vx) > 0.05 Then
							'walking
							new_image = 1
						Else
							'standing
							new_image = 0
						End If
					Else
						'jumping or falling
						
						If vy < 0 Then
							'jumping
							new_image = 2
						Else
							'falling
							new_image = 3
						End If
					End If
				End If
				
			Case TPLAYER_MODE.modes[5]'stone
				
				If Self.act_image = 2 Then
					new_image = 2
				Else
					If vy > 4.5 Then
						'falling
						new_image = 3
					'ElseIf vy < -0.2 Then
					'	'jumping
					'	new_image = 2
					Else
						If Abs(vx) > 0.05 Then
							'walking
							new_image = 1
						Else
							'standing
							new_image = 0
						End If
					End If
				End If
				
			Default
				
				If coll_ground = 1 Then
					'standing or walking
					
					If Abs(vx) > 0.05 Then
						'walking
						new_image = 1
					Else
						'standing
						new_image = 0
					End If
				Else
					'jumping or falling
					
					If vy < 0 Then
						'jumping
						new_image = 2
					Else
						'falling
						new_image = 3
					End If
				End If
				
		End Select
		
		If new_image = Self.act_image Then
			
			If Self.last_frame_change + Self.images_speed[Self.act_image, Self.act_side] < MilliSecs() Then
				Self.last_frame_change:+ Self.images_speed[Self.act_image, Self.act_side]
				Self.act_frame:+1
				
				If Self.act_frame >= Self.images[Self.act_image, Self.act_side].frames.length Then
					
					If player.mode = TPLAYER_MODE.modes[5] And Self.act_image = 2 Then
						Self.act_frame:-1
					Else
						Self.act_frame = 0
					End If
					
				End If
			End If
		Else
			Self.act_image = new_image
			Self.last_frame_change = MilliSecs()
			Self.act_frame = 0
		End If
		
	End Method
	
	Method draw(x:Float,y:Float)
		SetColor 255,255,255
		
		Draw_Image Self.images[Self.act_image, Self.act_side], GAME.world.act_level.ansicht_act_x + x, GAME.world.act_level.ansicht_act_y + y, Self.act_frame
		
	End Method
	
	Function Create:TPLAYER_MODE(mode_name:String)
		Local m:TPLAYER_MODE = New TPLAYER_MODE
		
		m.name = mode_name
		
		Local gfx_map:TMap = DATA_FILE_HANDLER.Load("Worlds\" + GAME.world.name + "\Objects\player\mode_" + mode_name + "\gfx.ini")
		
		If Not gfx_map Then
			GAME_ERROR_HANDLER.error("TPLAYER_MODE.create() -> map is Not loaded! (Worlds\" + GAME.world.name + "\Objects\player\mode_" + mode_name + "\gfx.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_x1") Then'image_x1
			m.image_x1 = Int(String(gfx_map.ValueForKey("image_x1")))
		Else
			GAME_ERROR_HANDLER.error("TPLAYER_MODE.create() -> image_x1 not found! (Worlds\" + GAME.world.name + "\Objects\player\mode_" + mode_name + "\gfx.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_x2") Then'image_x2
			m.image_x2 = Int(String(gfx_map.ValueForKey("image_x2")))
		Else
			GAME_ERROR_HANDLER.error("TPLAYER_MODE.create() -> image_x2 not found! (Worlds\" + GAME.world.name + "\Objects\player\mode_" + mode_name + "\gfx.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_y1") Then'image_y1
			m.image_y1 = Int(String(gfx_map.ValueForKey("image_y1")))
		Else
			GAME_ERROR_HANDLER.error("TPLAYER_MODE.create() -> image_y1 not found! (Worlds\" + GAME.world.name + "\Objects\player\mode_" + mode_name + "\gfx.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_y2") Then'image_y2
			m.image_y2 = Int(String(gfx_map.ValueForKey("image_y2")))
		Else
			GAME_ERROR_HANDLER.error("TPLAYER_MODE.create() -> image_y2 not found! (Worlds\" + GAME.world.name + "\Objects\player\mode_" + mode_name + "\gfx.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_rx") Then'image_rx
			m.rx = Int(String(gfx_map.ValueForKey("image_rx")))
		Else
			GAME_ERROR_HANDLER.error("TPLAYER_MODE.create() -> image_rx not found! (Worlds\" + GAME.world.name + "\Objects\player\mode_" + mode_name + "\gfx.ini")
			Return Null
		End If
		
		If gfx_map.contains("image_ry") Then'image_ry
			m.ry = Int(String(gfx_map.ValueForKey("image_ry")))
		Else
			GAME_ERROR_HANDLER.error("TPLAYER_MODE.create() -> image_ry not found! (Worlds\" + GAME.world.name + "\Objects\player\mode_" + mode_name + "\gfx.ini")
			Return Null
		End If
		
		m.image_x = m.image_x1 + 2*m.rx + m.image_x2
		m.image_y = m.image_y1 + 2*m.ry + m.image_y2
		
		m.images = New TImage[4,2]' 4 images !
		m.images_speed = New Int[4,2]
		
		For Local i:Int = 0 To 3' 4 images !
			
			For Local ii:Int = 0 To 1' r und l
				If gfx_map.contains("image_" + i + "_" + ii + "_speed") Then'images speed
					m.images_speed[i, ii] = Int(String(gfx_map.ValueForKey("image_" + i + "_" + ii + "_speed")))
				Else
					GAME_ERROR_HANDLER.error("TPLAYER_MODE.create() -> image_" + i + "_" + ii + "_speed not found! (Worlds\" + GAME.world.name + "\Objects\player\mode_" + mode_name + "\gfx.ini")
					Return Null
				End If
				
				m.images[i, ii] = LoadImage("Worlds\" + GAME.world.name + "\Objects\player\mode_" + mode_name + "\" + i + "_" + ii + ".png")
				
				If Not m.images[i, ii] Then
					GAME_ERROR_HANDLER.error("TPLAYER_MODE.create() -> image not found! (Worlds\" + GAME.world.name + "\Objects\player\mode_" + mode_name + "\" + i + "_" + ii + ".png")
					Return Null
				End If
				
				If m.images[i, ii].width >= 2*m.image_x Then
					
					m.images[i, ii] = LoadAnimImage("Worlds\" + GAME.world.name + "\Objects\player\mode_" + mode_name + "\" + i + "_" + ii + ".png", m.image_x, m.image_y, 0, m.images[i, ii].width/m.image_x)
					
				End If
				
				SetImageHandle(m.images[i, ii], m.image_x1 + m.rx, m.image_y1 + m.ry)
			Next
		Next
		
		m.light_image = LoadImage("Worlds\" + GAME.world.name + "\Objects\player\mode_" + mode_name + "\light.png")
		
		Return m
	End Function
	
End Type

'########################################################################################
'###########################          ###################################################
'########################### PARTIKEL ###################################################
'###########################          ###################################################
'########################################################################################

Type TPARTIKEL Extends TObject
	Global images:TImage[]
	
	Function init()
		Local anz_images:Int = 25
		TPARTIKEL.images = New TImage[anz_images]
		
		For Local i:Int = 0 To anz_images-1
			TPARTIKEL.images[i] = LoadImage("Worlds\" + GAME.world.name + "\Partikel\" + i + ".png")
			MidHandleImage TPARTIKEL.images[i]
		Next
	End Function
	
	Field image_number:Int
	
	Field vx:Float
	Field vy:Float
	Field gravity:Float
	
	
	Field w:Float
	Field vw:Float
	
	Field scale:Float
	Field alpha:Float
	
	Field count_max:Float
	Field count_act:Float
	
	Function Create:TPARTIKEL(image_number:Int, layer:Int, x:Float,y:Float,vx:Float,vy:Float,gravity:Float, w:Float,vw:Float, scale:Float,alpha:Float, count_max:Int)
		If TWorld.particles_on = 0 Then Return Null'particles off
		
		Local p:TPARTIKEL = New TPARTIKEL
		
		p.image_number = image_number
		p.layer = layer
		p.important = 1
		
		p.x = x
		p.y = y
		p.vx = vx
		p.vy = vy
		p.gravity = gravity
		
		p.w = w
		p.vw = vw
		
		p.scale = scale
		p.alpha = alpha
		
		p.count_max = count_max
		p.count_act = count_max
		
		GAME.world.act_level.add_object(p)
		
		Return p
	End Function
	
	Method render()
		Super.render()
		
		Self.x:+Self.vx*60.0/Graphics_Handler.FPS_MAX
		Self.vy:+Self.gravity*60.0/Graphics_Handler.FPS_MAX
		Self.y:+Self.vy*60.0/Graphics_Handler.FPS_MAX
		Self.w:+Self.vw*60.0/Graphics_Handler.FPS_MAX
		
		Self.count_act:-1*60.0/Graphics_Handler.FPS_MAX
		If Self.count_act <= 0 Then Self.kill_me = 1
	End Method
	
	Method draw()
		SetColor 255,255,255
		SetScale Self.scale,Self.scale
		SetRotation Self.w
		
		SetAlpha Self.alpha * Float(Self.count_act)/Float(Self.count_max)
		
		Draw_Image TPARTIKEL.images[Self.image_number], GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y
		
		SetAlpha 1
		
		SetRotation 0
		SetScale 1,1
	End Method
	
	Method write_to_stream(stream:TStream)
	End Method
	
	Function read_from_stream:TObject(stream:TStream)
	End Function
	
	Method write_to_stream_running(stream:TStream)
	End Method
	
	Function read_from_stream_running:TObject(stream:TStream, delta_t:Int)
	End Function
End Type

'########################################################################################
'###########################                  ###########################################
'###########################  PARTIKEL WATER  ###########################################
'###########################                  ###########################################
'########################################################################################


Type TPARTIKEL_WATER Extends TPARTIKEL
	
	Function Create:TPARTIKEL_WATER(image_number:Int, layer:Int, x:Float,y:Float,vx:Float,vy:Float,gravity:Float, w:Float,vw:Float, scale:Float,alpha:Float, count_max:Int)
		If TWorld.particles_on = 0 Then Return Null'particles off
		
		Local p:TPARTIKEL_WATER = New TPARTIKEL_WATER
		
		p.image_number = image_number
		p.layer = layer
		p.important = 1
		
		p.x = x
		p.y = y
		p.vx = vx
		p.vy = vy
		p.gravity = gravity
		
		p.w = w
		p.vw = vw
		
		p.scale = scale
		p.alpha = alpha
		
		p.count_max = count_max
		p.count_act = count_max
		
		GAME.world.act_level.add_object(p)
		
		Return p
	End Function
	
	Method render()
		Super.render()
		
		Self.x:+Self.vx*60.0/Graphics_Handler.FPS_MAX
		Self.vy:+Self.gravity*60.0/Graphics_Handler.FPS_MAX
		
		'collision
		
		If Ceil((Self.y)/GAME.world.act_level.image_side) < Ceil((Self.y + Self.vy)/GAME.world.act_level.image_side) Then
			'you have just entered a new row of blocks!
			
			'muss +vx haben, damit keine stÃÂÃÂ¶runen wenn genau auf ecke des blockes fÃÂÃÂ¤llt
			For Local ix:Int = Floor((Self.x + Self.vx)/GAME.world.act_level.image_side) To Ceil((Self.x + Self.vx)/GAME.world.act_level.image_side)-1
				If GAME.world.act_level.has_collision(ix,Ceil((Self.y)/GAME.world.act_level.image_side)) Then
					
					'water splash !
					Self.kill_me = 1
					
					If Rand(1,20) = 1 Then TSoundPlayer.run("platsch"+Rand(1,3),Self.x,Self.y,Self,300)'Sound_Handler.play_2d("platsch"+Rand(1,3),Self.x,Self.y,300)
					
					For Local i:Int = 0 To 3
						TPARTIKEL.Create(Rand(8,10), Self.layer, Self.x,Self.y,Rnd()*4.0-2.0,-Rnd()*1.0-3.5,0.2, Rnd()*360,Rnd()*10.0-5.0, 1.0,1.0, 50)
					Next
					
				End If
			Next
			
		End If
		'end collision
		
		
		If GAME.world.act_level.player And GAME.world.act_level.player.mode = TPLAYER_MODE.modes[7] Then
			Self.kill_me = 1
			
			If Rand(1,6) = 1 Then
				TPARTIKEL.Create(21, Self.layer, Self.x,Self.y,0,0,0, 0,0, 1.0,1.0, Self.count_act*10.0)
			End If
			
		End If
		
		
		Self.y:+Self.vy*60.0/Graphics_Handler.FPS_MAX
		Self.w:+Self.vw*60.0/Graphics_Handler.FPS_MAX
		
		Self.count_act:-1*60.0/Graphics_Handler.FPS_MAX
		If Self.count_act <= 0 Then Self.kill_me = 1
	End Method
End Type


'########################################################################################
'###########################        #####################################################
'########################### CHUNK  #####################################################
'###########################        #####################################################
'########################################################################################

Type TCHUNK
	Field list:TList'contains objects
	
	Field x:Int
	Field y:Int
	
	Field dx:Float'width and hight of chunk
	Field dy:Float
	
	Field layer:Int
	
	Function Create:TCHUNK(x:Int, y:Int, layer:Int, dx:Float, dy:Float)'CREATE a CHUNK
		Local c:TCHUNK = New TCHUNK
		
		c.list = New TList
		c.x = x
		c.y = y
		
		c.dx = dx
		c.dy = dy
		
		Return c
	End Function
	
	Method add(o:TObject)'ADD an OBJECT to the list
		Self.list.addlast(o)
		
		If o.chunk <> Null Then'delete from all other chunks
			o.chunk.remove(o)
		End If
		
		o.chunk_x = Self.x
		o.chunk_y = Self.y
		
		o.chunk = Self
	End Method
	
	Method remove(o:TObject)'DELETE an Object from list if there
		If Self.list.contains(o) Then
			Self.list.remove(o)
			o.chunk = Null
		End If
	End Method
	
	Method is_inside:Int(x:Float,y:Float)
		If x < Self.x*Self.dx Then Return 0
		If y < Self.y*Self.dy Then Return 0
		
		If x > (Self.x+1.0)*Self.dx Then Return 0
		If y > (Self.y+1.0)*Self.dy Then Return 0
		
		Return 1
	End Method
	
	Method render()'RENDER list
		For Local o:TObject = EachIn Self.list
			o.render()
		Next
	End Method
	
	Method draw()'DRAW list
		For Local o:TObject = EachIn Self.list
			o.draw()
		Next
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
'###########################                   ##########################################
'########################### DATA FILE HANDLER ##########################################
'###########################                   ##########################################
'########################################################################################

Type DATA_FILE_HANDLER
	Function Load:TMap(path:String)
		Local map:TMap = New TMap
		
		Local file:TStream = ReadFile(path)
		
		If Not file Then
			GAME_ERROR_HANDLER.error("file could not be opened: "+path)
			Return Null
		End If
		
		While Not Eof(file)
			Local txt:String = ReadLine(file)
			
			Local pos:Int = Instr(txt,"=")
			
			If pos<>0 Then
				
				
				Local name:String = Trim(Mid(txt,1,pos-1))
				Local data:String = Trim(Mid(txt,pos+1,-1))
				
				
				map.insert(name, data)
				
			End If
		Wend
		
		CloseFile(file)
		
		Return map
	End Function
	
	Function save(map:TMap, path:String)
		Local file:TStream = WriteFile(path)
		
		For Local name:String = EachIn map.keys()
			Print name
			Print String(map.ValueForKey(name))
			
			file.WriteLine(name + "=" + String(map.ValueForKey(name)))
		Next
		
		CloseFile(file)
		
	End Function
	
	Function WriteString(stream:TStream, txt:String)'DATA_FILE_HANDLER.WriteString(s, t)
		stream.WriteInt(Len(txt))
		stream.WriteString(txt)
	End Function
	
	Function ReadString:String(stream:TStream)'DATA_FILE_HANDLER.ReadString(s)
		Local l:Int = stream.ReadInt()
		Return stream.ReadString(l)
	End Function
End Type


'########################################################################################
'###########################                   ##########################################
'###########################     Controls      ##########################################
'###########################                   ##########################################
'########################################################################################

Type TControls
	'SUPER
	Function init()
		TControls.init_keys()
		TControls.init_controls()
	End Function
	
	Global key_list:TList
	
	Function init_keys()
		TControls.key_list = New TList
		
		'TControls.key_list.addlast(TKey.Create(name:String, code:Int))
		
		For Local i:Int = 48 To 90'NUMBERS + LETTERS
			TControls.key_list.addlast(TKey.Create(Chr(i), i))
		Next
		
		TControls.key_list.addlast(TKey.Create("BACKSPACE", KEY_BACKSPACE))
		TControls.key_list.addlast(TKey.Create("TAB", KEY_TAB))
		TControls.key_list.addlast(TKey.Create("ENTER", KEY_ENTER))
		TControls.key_list.addlast(TKey.Create("ESCAPE", KEY_ESCAPE))
		TControls.key_list.addlast(TKey.Create("SPACE", KEY_SPACE))
		TControls.key_list.addlast(TKey.Create("PAGEUP", KEY_PAGEUP))
		TControls.key_list.addlast(TKey.Create("PAGEDOWN", KEY_PAGEDOWN))
		TControls.key_list.addlast(TKey.Create("END", KEY_END))
		TControls.key_list.addlast(TKey.Create("HOME", KEY_HOME))
		TControls.key_list.addlast(TKey.Create("LEFT", KEY_LEFT))
		TControls.key_list.addlast(TKey.Create("UP", KEY_UP))
		TControls.key_list.addlast(TKey.Create("RIGHT", KEY_RIGHT))
		TControls.key_list.addlast(TKey.Create("DOWN", KEY_DOWN))
		TControls.key_list.addlast(TKey.Create("SELECT", KEY_SELECT))
		TControls.key_list.addlast(TKey.Create("PRINT", KEY_PRINT))
		TControls.key_list.addlast(TKey.Create("EXECUTE", KEY_EXECUTE))
		TControls.key_list.addlast(TKey.Create("SCREEN", KEY_SCREEN))
		TControls.key_list.addlast(TKey.Create("INSERT", KEY_INSERT))
		TControls.key_list.addlast(TKey.Create("DELETE", KEY_DELETE))
		'TControls.key_list.addlast(TKey.Create("HELP", KEY_HELP))
		
		TControls.key_list.addlast(TKey.Create("LSYS", KEY_LSYS))
		TControls.key_list.addlast(TKey.Create("RSYS", KEY_RSYS))
		
		TControls.key_list.addlast(TKey.Create("NUM0", KEY_NUM0))
		TControls.key_list.addlast(TKey.Create("NUM1", KEY_NUM1))
		TControls.key_list.addlast(TKey.Create("NUM2", KEY_NUM2))
		TControls.key_list.addlast(TKey.Create("NUM3", KEY_NUM3))
		TControls.key_list.addlast(TKey.Create("NUM4", KEY_NUM4))
		TControls.key_list.addlast(TKey.Create("NUM5", KEY_NUM5))
		TControls.key_list.addlast(TKey.Create("NUM6", KEY_NUM6))
		TControls.key_list.addlast(TKey.Create("NUM7", KEY_NUM7))
		TControls.key_list.addlast(TKey.Create("NUM8", KEY_NUM8))
		TControls.key_list.addlast(TKey.Create("NUM9", KEY_NUM9))
		
		TControls.key_list.addlast(TKey.Create("NUMMULTIPLY", KEY_NUMMULTIPLY))
		TControls.key_list.addlast(TKey.Create("NUMADD", KEY_NUMADD))
		TControls.key_list.addlast(TKey.Create("NUMSUBTRACT", KEY_NUMSUBTRACT))
		TControls.key_list.addlast(TKey.Create("NUMDECIMAL", KEY_NUMDECIMAL))
		TControls.key_list.addlast(TKey.Create("NUMDIVIDE", KEY_NUMDIVIDE))
		
		
		
		'TControls.key_list.addlast(TKey.Create("NUMLOCK", KEY_NUMLOCK))
		'TControls.key_list.addlast(TKey.Create("SCROLL", KEY_SCROLL))
		TControls.key_list.addlast(TKey.Create("LSHIFT", KEY_LSHIFT))
		TControls.key_list.addlast(TKey.Create("RSHIFT", KEY_RSHIFT))
		TControls.key_list.addlast(TKey.Create("LCONTROL", KEY_LCONTROL))
		TControls.key_list.addlast(TKey.Create("RCONTROL", KEY_RCONTROL))
	End Function
	
	Global controls_list:TList
	Rem
		0 up, 1 down, 2 r, 3 l
		4 activite, 5 ability-power, 6 continue
		7 reload, 8 suicide
		9 escape
	End Rem
	
	Global up:TControls
	Global down:TControls
	Global r:TControls
	Global l:TControls
	
	Global activate:TControls
	Global ability:TControls
	Global cont:TControls
	
	Global reload:TControls
	Global suicide:TControls
	
	Global escape:TControls
	
	
	Function init_controls()
		
		'end default setting
		TControls.up = TControls.Create(TKey.Create("UP", KEY_UP),"UP")
		TControls.down= TControls.Create(TKey.Create("DOWN", KEY_DOWN),"DOWN")
		TControls.r = TControls.Create(TKey.Create("RIGHT", KEY_RIGHT),"RIGHT")
		TControls.l = TControls.Create(TKey.Create("LEFT", KEY_LEFT),"LEFT")
		
		TControls.activate = TControls.Create(TKey.Create("TAB", KEY_TAB),"ACTIVATE")
		TControls.ability = TControls.Create(TKey.Create("SPACE", KEY_SPACE),"ABILITY")
		TControls.cont = TControls.Create(TKey.Create("ENTER", KEY_ENTER),"CONTINUE")
		
		TControls.reload = TControls.Create(TKey.Create("R", KEY_R),"RELOAD")
		TControls.suicide = TControls.Create(TKey.Create("BACKSPACE", KEY_BACKSPACE),"SUICIDE")
		
		TControls.escape = TControls.Create(TKey.Create("ESCAPE", KEY_ESCAPE),"MENU")
		
		'load ini:
		
		Local path:String = "Worlds\" + GAME.world.name + "\controls.ini"
		
		If FileType(path) Then
			Local gfx_map:TMap = DATA_FILE_HANDLER.Load(path)'controls.ini
			
			If gfx_map Then
				'read the keys:
				
				If gfx_map.contains("UP") Then'here
					Local find:String = String(gfx_map.ValueForKey("UP"))'here
					
					For Local k:TKey = EachIn TControls.key_list
						If k.name = find Then
							TControls.up.key = k'here
							
							Exit
						End If
					Next
				End If
				
				If gfx_map.contains("DOWN") Then'here
					Local find:String = String(gfx_map.ValueForKey("DOWN"))'here
					
					For Local k:TKey = EachIn TControls.key_list
						If k.name = find Then
							TControls.down.key = k'here
							Exit
						End If
					Next
				End If
				
				If gfx_map.contains("RIGHT") Then'here
					Local find:String = String(gfx_map.ValueForKey("RIGHT"))'here
					
					For Local k:TKey = EachIn TControls.key_list
						If k.name = find Then
							TControls.r.key = k'here
							Exit
						End If
					Next
				End If
				
				If gfx_map.contains("LEFT") Then'here
					Local find:String = String(gfx_map.ValueForKey("LEFT"))'here
					
					For Local k:TKey = EachIn TControls.key_list
						If k.name = find Then
							TControls.l.key = k'here
							Exit
						End If
					Next
				End If
				
				If gfx_map.contains("ACTIVATE") Then'here
					Local find:String = String(gfx_map.ValueForKey("ACTIVATE"))'here
					
					For Local k:TKey = EachIn TControls.key_list
						If k.name = find Then
							TControls.activate.key = k'here
							Exit
						End If
					Next
				End If
				
				If gfx_map.contains("ABILITY") Then'here
					Local find:String = String(gfx_map.ValueForKey("ABILITY"))'here
					
					For Local k:TKey = EachIn TControls.key_list
						If k.name = find Then
							TControls.ability.key = k'here
							Exit
						End If
					Next
				End If
				
				If gfx_map.contains("CONTINUE") Then'here
					Local find:String = String(gfx_map.ValueForKey("CONTINUE"))'here
					
					For Local k:TKey = EachIn TControls.key_list
						If k.name = find Then
							TControls.cont.key = k'here
							Exit
						End If
					Next
				End If
				
				If gfx_map.contains("RELOAD") Then'here
					Local find:String = String(gfx_map.ValueForKey("RELOAD"))'here
					
					For Local k:TKey = EachIn TControls.key_list
						If k.name = find Then
							TControls.reload.key = k'here
							Exit
						End If
					Next
				End If
				
				If gfx_map.contains("SUICIDE") Then'here
					Local find:String = String(gfx_map.ValueForKey("SUICIDE"))'here
					
					For Local k:TKey = EachIn TControls.key_list
						If k.name = find Then
							TControls.suicide.key = k'here
							Exit
						End If
					Next
				End If
				
				If gfx_map.contains("MENU") Then'here
					Local find:String = String(gfx_map.ValueForKey("MENU"))'here
					
					For Local k:TKey = EachIn TControls.key_list
						If k.name = find Then
							TControls.escape.key = k'here
							Exit
						End If
					Next
				End If
				
			Else
				Print path + " map could Not be loaded!"
			End If
			
			
		Else
			Print path + " Not found"
		End If
		
		'give it to list:
		
		TControls.controls_list = New TList
		
		TControls.controls_list.addlast(TControls.up)
		TControls.controls_list.addlast(TControls.down)
		TControls.controls_list.addlast(TControls.r)
		TControls.controls_list.addlast(TControls.l)
		
		TControls.controls_list.addlast(TControls.activate)
		TControls.controls_list.addlast(TControls.ability)
		TControls.controls_list.addlast(TControls.cont)
		
		TControls.controls_list.addlast(TControls.reload)
		TControls.controls_list.addlast(TControls.suicide)
		
		TControls.controls_list.addlast(TControls.escape)
	End Function
	
	Function save_controls()
		Local controls_map:TMap = New TMap
		
		For Local c:TControls = EachIn TControls.controls_list
			controls_map.Insert(c.name, c.key.name)
		Next
		
		DATA_FILE_HANDLER.save(controls_map, "Worlds\" + GAME.world.name + "\controls.ini")
	End Function
	
	'SELF
	Field key:TKey
	Field name:String
	'Field hit:Int
	'Field hold:Int
	
	Function Create:TControls(key:TKey,name:String)
		Local c:TControls = New TControls
		c.key = key
		c.name = name
		Return c
	End Function
	
	
	Function render_controls()
		For Local c:TControls = EachIn TControls.controls_list
			c.key.hit = KeyHit(c.key.code)
			c.key.hold = KeyDown(c.key.code)
			
			'Print c.key.name
		Next
	End Function
End Type

'########################################################################################
'###########################                   ##########################################
'###########################       Keys        ##########################################
'###########################                   ##########################################
'########################################################################################

Type TKey
	Field name:String
	Field code:Int
	Field hit:Int
	Field hold:Int
	
	Function Create:TKey(name:String, code:Int)
		Local k:TKey = New TKey
		
		k.name = name
		k.code = code
		
		Return k
	End Function
End Type

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
	
	Global big_x:Int
	Global big_y:Int
	
	Global mode:Int
	
	Global show_debug:Int = 0
	
	Global FPS_MAX:Float = 60.0
	
	Global last_sec_FPS:Int
	Global last_sec_end:Int
	
	Global FPS_counter:Int
	Global delay_counter:Int
	Global last_sec_delay:Int
	
	Global font_small:TImageFont
	Global font_middle:TImageFont
	Global font_big:TImageFont
		
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
	
	Function set_graphics(x:Int,y:Int,mode:Int=0,big_x:Int=0, big_y:Int=0)
		
		SetGraphicsDriver(GLMax2DDriver())
		
		Graphics_Handler.mode = mode
		Graphics_Handler.x = x
		Graphics_Handler.y = y
		
		
		Select mode
			Case 0
				Graphics(x,y,0,60)
				Graphics_Handler.origin_x = 0
				Graphics_Handler.origin_y = 0
				
				
				Graphics_Handler.big_x = x
				Graphics_Handler.big_y = y
			Case 1
				Print "dead end"
				End
				Rem
				Graphics_Handler.origin_x = (big_x-x)/2
				Graphics_Handler.origin_y = (big_y-y)/2
				
				Graphics(big_x, big_y,32,60)
				End Rem
			Case 2
				If big_x=0 Then
					big_x=Graphics_Handler.get_max_x()
				End If
				
				If big_y=0 Then
					big_y=Graphics_Handler.get_max_y()
				End If
				
				Graphics_Handler.big_x = big_x
				Graphics_Handler.big_y = big_y
				
				Graphics_Handler.origin_x = (Graphics_Handler.big_x-x)/2
				Graphics_Handler.origin_y = (Graphics_Handler.big_y-y)/2
				
				Graphics(Graphics_Handler.big_x, Graphics_Handler.big_y,32,60)
				
				'SetOrigin(Graphics_Handler.origin_x,Graphics_Handler.origin_y)
				'SetViewport(Graphics_Handler.origin_x,Graphics_Handler.origin_y,x,y)
		End Select
		
		Graphics_Handler.set_normal()
		
		glewInit()
		
		SetBlend ALPHABLEND
		SetClsColor 255,255,255
		
		TLight.restart_engine()'TBuffer.light_mix = TBuffer.Create(1024)  'lightengine restart!
		
		Graphics_Handler.font_small = LoadImageFont("incbin::font2.ttf", 24,SMOOTHFONT)' # LOAD FONT #
		SetImageFont Graphics_Handler.font_small
		
		Graphics_Handler.font_middle = LoadImageFont("incbin::font2.ttf", 35,SMOOTHFONT)
		Graphics_Handler.font_big = LoadImageFont("incbin::font2.ttf", 50,SMOOTHFONT)
		
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
				SetOrigin(0,0)
				SetViewport(0,0,Graphics_Handler.big_x, Graphics_Handler.big_y)
				
				'SetOrigin(Graphics_Handler.origin_x,Graphics_Handler.origin_y)
				'SetViewport(Graphics_Handler.origin_x,Graphics_Handler.origin_y,Graphics_Handler.x,Graphics_Handler.y)
		End Select
		
		SetBlend ALPHABLEND
		SetClsColor 255,255,255
	End Function
	
	Function draw_brille()
		If Graphics_Handler.mode = 2 Then
				'top
				SetColor 10,10,10
				DrawRect 0,0,Graphics_Handler.origin_x,Graphics_Handler.origin_y
				
				SetColor 0,0,0
				DrawRect Graphics_Handler.origin_x,0,Graphics_Handler.x,Graphics_Handler.origin_y
				
				SetColor 10,10,10
				DrawRect Graphics_Handler.origin_x+Graphics_Handler.x,0,Graphics_Handler.origin_x,Graphics_Handler.origin_y
				
				'middle
				
				SetColor 0,0,0
				DrawRect 0,Graphics_Handler.origin_y,Graphics_Handler.origin_x,Graphics_Handler.y
				
				SetColor 0,0,0
				DrawRect Graphics_Handler.origin_x+Graphics_Handler.x,Graphics_Handler.origin_y,Graphics_Handler.origin_x,Graphics_Handler.y
				
				'bottom
				SetColor 10,10,10
				DrawRect 0,Graphics_Handler.origin_y+Graphics_Handler.y,Graphics_Handler.origin_x,Graphics_Handler.origin_y
				
				SetColor 0,0,0
				DrawRect Graphics_Handler.origin_x,Graphics_Handler.origin_y+Graphics_Handler.y,Graphics_Handler.x,Graphics_Handler.origin_y
				
				SetColor 10,10,10
				DrawRect Graphics_Handler.origin_x+Graphics_Handler.x,Graphics_Handler.origin_y+Graphics_Handler.y,Graphics_Handler.origin_x,Graphics_Handler.origin_y
				
				
				SetColor 255,255,255
			End If
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

Function Draw_Text( t$,x#,y# )
	DrawText(t,x+Graphics_Handler.origin_x,y+Graphics_Handler.origin_y)
End Function

Function Draw_Rect( x#,y#,width#,height# )
	DrawRect(x+Graphics_Handler.origin_x,y+Graphics_Handler.origin_y,width#,height# )
End Function

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
	Field x:Float
	Field y:Float
	
	Field w:Float = 0.0
	
	Field image:TImage
	Field r:Float
	
	Field buffer:TBuffer
	
	Global source_normal:TImage
	Global source_spot:TImage
	Global source_treasure:TImage
	
	Field rot:Float = 255
	Field gruen:Float = 255
	Field blau:Float = 255
	
	Method set_color(r:Int,g:Int,b:Int)
		Self.rot = r
		Self.gruen = g
		Self.blau = b
	End Method
	
	Function init()
		TLight.source_normal = LoadImage("gfx\lights\normal.png")
		'MidHandleImage TLight.source_normal
		TLight.source_spot = LoadImage("gfx\lights\spot.png")
		'MidHandleImage TLight.source_spot
		TLight.source_treasure = LoadImage("gfx\lights\treasure.png")
		'MidHandleImage TLight.source_treasure
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
	
	Function restart_engine()
		TBuffer.light_mix = TBuffer.Create(1024)'lightengine restart!
		
		'restart every buffer
		
		'l.buffer = TBuffer.Create(image.width)
		
		If Not GAME.world.act_level Return
		
		For Local x:Int = 0 To GAME.world.act_level.anz_chunks_x-1
			For Local y:Int = 0 To GAME.world.act_level.anz_chunks_y-1
				For Local layer:Int = 0 To 4
					For Local o:TObject = EachIn GAME.world.act_level.chunks[x,y,layer].list
						TLight.restart_object(o)
					Next
				Next
			Next
		Next
		
		For Local layer:Int = 0 To 4
			For Local o:TObject = EachIn GAME.world.act_level.super_chunks[layer].list
				TLight.restart_object(o)
			Next
		Next
		
	End Function
	
	Function restart_object(o:TObject)
		If TBox(o) And TBox_Renderer_TLamp(TBox(o).renderer) Then
			Print "restart me! TLamp"
			
			TBox_Renderer_TLamp(TBox(o).renderer).light.buffer = TBuffer.Create(TBox_Renderer_TLamp(TBox(o).renderer).light.image.width)
		End If
		
		If TBox(o) And TBox_Renderer_Image(TBox(o).renderer) And TBox_Renderer_Image(TBox(o).renderer).light Then
			Print "restart me! Image"
			
			TBox_Renderer_Image(TBox(o).renderer).light.buffer = TBuffer.Create(TBox_Renderer_Image(TBox(o).renderer).light.image.width)
		End If
		
		If TPlayer(o) Then
			TPlayer(o).light.buffer = TBuffer.Create(TPlayer(o).light.image.width)
			
			Print "restart me! Player"
		End If
	End Function
	
	Method render()
		If Not GAME.world.act_level.lights_on Then Return
		Self.buffer.set_me()
		
		SetColor Self.rot, Self.gruen, Self.blau
		SetBlend alphablend
		SetRotation Self.w
		DrawImage Self.image,0,0'Self.r,Self.r
		SetRotation 0
		SetBlend solidblend
		SetColor 255,255,255
		'TRIANGLES.set_tex(LockImage(Self.image))
		'UnlockImage(Self.image)
		
		Local x1:Int = (Self.x - Self.r)/GAME.world.act_level.image_side
		Local x2:Int = (Self.x + Self.r)/GAME.world.act_level.image_side
		
		Local y1:Int = (Self.y - Self.r)/GAME.world.act_level.image_side
		Local y2:Int = (Self.y + Self.r)/GAME.world.act_level.image_side
		
		If x1 < 0 Then x1 = 0
		If y1 < 0 Then y1 = 0
		
		If x2 > GAME.world.act_level.table_x-1 Then x2 = GAME.world.act_level.table_x-1
		If y2 > GAME.world.act_level.table_y-1 Then y2 = GAME.world.act_level.table_y-1
		
		For Local x:Int = x1 To x2
			For Local y:Int = y1 To y2
				
				If GAME.world.act_level.table[x,y].collision = 1 Then
					Local b_x:Float = Self.r-Self.x + x*GAME.world.act_level.image_side
					Local b_y:Float = Self.r-Self.y + y*GAME.world.act_level.image_side
					
					If b_x < Self.r And b_x + GAME.world.act_level.image_side > Self.r Then
						
						If b_y > Self.r Then
							
							Local w1:Float = ATan2(b_y - Self.r, b_x - Self.r)
							Local w2:Float = ATan2(b_y - Self.r, b_x + GAME.world.act_level.image_side - Self.r)
							
							SetColor 0,0,0
							
							Local a:Float [] = [b_x + GAME.world.act_level.image_side, b_y, b_x, b_y, Float(Self.r + Cos(w1)*Self.r*2.0), Float(Self.r + Sin(w1)*Self.r*2.0), Float(Self.r + Cos(w2)*Self.r*2.0), Float(Self.r + Sin(w2)*Self.r*2.0)]
							
							DrawPoly a
						Else
							
							
							Local w2:Float = ATan2(b_y  + GAME.world.act_level.image_side - Self.r, b_x - Self.r)
							Local w1:Float = ATan2(b_y  + GAME.world.act_level.image_side  - Self.r, b_x  + GAME.world.act_level.image_side - Self.r)
							
							SetColor 0,0,0
							
							Local a:Float [] = [b_x, b_y  + GAME.world.act_level.image_side, b_x  + GAME.world.act_level.image_side, b_y  + GAME.world.act_level.image_side, Float(Self.r + Cos(w1)*Self.r*2.0), Float(Self.r + Sin(w1)*Self.r*2.0), Float(Self.r + Cos(w2)*Self.r*2.0), Float(Self.r + Sin(w2)*Self.r*2.0)]
							
							DrawPoly a
						End If
						
					ElseIf b_y < Self.r And b_y + GAME.world.act_level.image_side > Self.r Then
						
						If b_x > Self.r Then
							
							Local w2:Float = ATan2(b_y - Self.r, b_x - Self.r)
							Local w1:Float = ATan2(b_y + GAME.world.act_level.image_side - Self.r, b_x - Self.r)
							
							SetColor 0,0,0
							
							Local a:Float [] = [b_x, b_y, b_x, b_y + GAME.world.act_level.image_side, Float(Self.r + Cos(w1)*Self.r*2.0), Float(Self.r + Sin(w1)*Self.r*2.0), Float(Self.r + Cos(w2)*Self.r*2.0), Float(Self.r + Sin(w2)*Self.r*2.0)]
							
							DrawPoly a
						Else
							
							Local w1:Float = ATan2(b_y - Self.r, b_x + GAME.world.act_level.image_side - Self.r)
							Local w2:Float = ATan2(b_y + GAME.world.act_level.image_side - Self.r, b_x + GAME.world.act_level.image_side - Self.r)
							
							SetColor 0,0,0
							
							Local a:Float [] = [b_x + GAME.world.act_level.image_side, b_y + GAME.world.act_level.image_side, b_x + GAME.world.act_level.image_side, b_y, Float(Self.r + Cos(w1)*Self.r*2.0), Float(Self.r + Sin(w1)*Self.r*2.0), Float(Self.r + Cos(w2)*Self.r*2.0), Float(Self.r + Sin(w2)*Self.r*2.0)]
							
							DrawPoly a
						End If
						
					ElseIf b_x > Self.r Then
						
						If b_y > Self.r Then
							
							Local w1:Float = ATan2(b_y + GAME.world.act_level.image_side - Self.r, b_x - Self.r)
							Local w2:Float = ATan2(b_y - Self.r, b_x + GAME.world.act_level.image_side - Self.r)
							
							SetColor 0,0,0
							
							Local a:Float [] = [b_x + GAME.world.act_level.image_side, b_y, b_x, b_y, b_x, b_y + GAME.world.act_level.image_side, Float(Self.r + Cos(w1)*Self.r*2.0), Float(Self.r + Sin(w1)*Self.r*2.0), Float(Self.r + Cos(w2)*Self.r*2.0), Float(Self.r + Sin(w2)*Self.r*2.0)]
							
							DrawPoly a
						Else
							Local w2:Float = ATan2(b_y - Self.r, b_x - Self.r)
							Local w1:Float = ATan2(b_y + GAME.world.act_level.image_side - Self.r, b_x + GAME.world.act_level.image_side - Self.r)
							
							SetColor 0,0,0
							
							Local a:Float [] = [b_x, b_y, b_x, b_y + GAME.world.act_level.image_side, b_x + GAME.world.act_level.image_side, b_y + GAME.world.act_level.image_side, Float(Self.r + Cos(w1)*Self.r*2.0), Float(Self.r + Sin(w1)*Self.r*2.0), Float(Self.r + Cos(w2)*Self.r*2.0), Float(Self.r + Sin(w2)*Self.r*2.0)]
							
							DrawPoly a
						End If
						
					Else
						
						If b_y > Self.r Then
							
							Local w2:Float = ATan2(b_y + GAME.world.act_level.image_side - Self.r, b_x +  + GAME.world.act_level.image_side - Self.r)
							Local w1:Float = ATan2(b_y - Self.r, b_x - Self.r)
							
							SetColor 0,0,0
							
							Local a:Float [] = [b_x +  + GAME.world.act_level.image_side, b_y +  + GAME.world.act_level.image_side, b_x +  + GAME.world.act_level.image_side, b_y, b_x, b_y, Float(Self.r + Cos(w1)*Self.r*2.0), Float(Self.r + Sin(w1)*Self.r*2.0), Float(Self.r + Cos(w2)*Self.r*2.0), Float(Self.r + Sin(w2)*Self.r*2.0)]
							
							DrawPoly a
						Else
							Local w1:Float = ATan2(b_y - Self.r, b_x + GAME.world.act_level.image_side - Self.r)
							Local w2:Float = ATan2(b_y + GAME.world.act_level.image_side - Self.r, b_x - Self.r)
							
							SetColor 0,0,0
							
							Local a:Float [] = [b_x, b_y + GAME.world.act_level.image_side, b_x + GAME.world.act_level.image_side, b_y + GAME.world.act_level.image_side, b_x + GAME.world.act_level.image_side, b_y, Float(Self.r + Cos(w1)*Self.r*2.0), Float(Self.r + Sin(w1)*Self.r*2.0), Float(Self.r + Cos(w2)*Self.r*2.0), Float(Self.r + Sin(w2)*Self.r*2.0)]
							
							DrawPoly a
						End If
						
					End If
					
					
					'Draw_Rect b_x, b_y, GAME.world.act_level.image_side, GAME.world.act_level.image_side
					
				End If
				
			Next
		Next
		
		
		Self.buffer.set_normal()
	End Method
	
	Method draw_to_buffer()
		If Not GAME.world.act_level.lights_on Then Return
		
		TBuffer.light_mix.set_me()
		
		SetBlend lightblend
		SetColor 255,255,255
		Self.buffer.draw( GAME.world.act_level.ansicht_act_x + Self.x - Self.r, GAME.world.act_level.ansicht_act_y + Self.y - Self.r)
		
		SetBlend alphablend
		
		TBuffer.light_mix.set_normal()
	End Method
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
'###########################   MENU HANDLER    ##########################################
'###########################                   ##########################################
'########################################################################################

Type MENU
	Global menu_bg_image:TImage
	Global options_bg_image:TImage
	Global credits_bg_image:TImage
	Global controls_bg_image:TImage
	Global menu_level_bg_image:TImage
	
	Global menu_internet_image:TImage
	
	Global level_complete_image:TImage
	Global level_locked_image:TImage
	
	Global cursor_up_image:TImage
	Global cursor_down_image:TImage
	
	Global fps_bar_image:TImage
	
	Global volume_bar_image:TImage
	Global volume_glider_image:TImage
	
	Global mouse_x:Int
	Global mouse_y:Int
	
	Global mouse_down_1:Int
	Global mouse_hit_1:Int
	
	
	Global menu_button_options:TMENU_BUTTON'menu
	Global menu_button_credits:TMENU_BUTTON
	Global menu_button_quit:TMENU_BUTTON
	Global menu_button_resume:TMENU_BUTTON
	
	
	Global options_button_back:TMENU_BUTTON'options
	Global options_button_controls:TMENU_BUTTON
	Global options_button_fullscreen:TMENU_BUTTON
	Global options_button_window:TMENU_BUTTON
	Global options_button_apply:TMENU_BUTTON
	
	Global options_button_rechts:TMENU_BUTTON
	Global options_button_links:TMENU_BUTTON
	
	Global options_button_lights:TMENU_BUTTON
	Global options_button_particles:TMENU_BUTTON
	
	
	Global credits_button_back:TMENU_BUTTON'credits
	
	Global controls_button_back:TMENU_BUTTON'controls
	
	Global menu_level_x_ziel:Float
	Global menu_level_x_act:Float
	
	
	Function init()
		SetMaskColor(255,0,255)
		MENU.menu_bg_image = LoadImage("gfx\menu\menu.png")
		MENU.options_bg_image = LoadImage("gfx\menu\options.png")
		MENU.credits_bg_image = LoadImage("gfx\menu\credits.png")
		MENU.controls_bg_image = LoadImage("gfx\menu\controls.png")
		MENU.menu_level_bg_image = LoadImage("gfx\menu\level_bg.png")
		MENU.level_complete_image = LoadImage("gfx\menu\level_completed.png")
		
		MENU.menu_internet_image = LoadImage("gfx\menu\internet.png")
		
		MENU.level_locked_image = LoadImage("gfx\menu\level_locked.png")
		
		MENU.cursor_up_image = LoadImage("gfx\menu\cursor_up.png")
		SetImageHandle(MENU.cursor_up_image, 2, 2)
		MENU.cursor_down_image = LoadImage("gfx\menu\cursor_down.png")
		SetImageHandle(MENU.cursor_down_image, 2, 2)
		
		'MENU.fps_bar_image = LoadImage("gfx\menu\fps_bar.png")
		
		MENU.volume_bar_image = LoadImage("gfx\menu\volume_bar.png")
		MENU.volume_glider_image = LoadImage("gfx\menu\volume_glider.png")
		
		MENU.menu_button_options = TMENU_BUTTON.Create("options", 100, 400)'menu
		MENU.menu_button_resume = TMENU_BUTTON.Create("resume", 500, 400)
		MENU.menu_button_credits = TMENU_BUTTON.Create("credits", 100, 500)
		MENU.menu_button_quit = TMENU_BUTTON.Create("quit", 500, 500)
		
		
		MENU.menu_level_x_ziel = (800-150)/2
		MENU.menu_level_x_act = (800-150)/2
		
		
		MENU.options_button_back = TMENU_BUTTON.Create("back", 580, 530)'options
		MENU.options_button_controls = TMENU_BUTTON.Create("controls", 20, 530)
		
		MENU.options_button_fullscreen = TMENU_BUTTON.Create("fullscreen", 50, 130)
		MENU.options_button_window = TMENU_BUTTON.Create("window", 50, 130)
		MENU.options_button_apply = TMENU_BUTTON.Create("apply", 50, 230)
		MENU.options_button_rechts = TMENU_BUTTON.Create("rechts", 700, 130)
		MENU.options_button_links = TMENU_BUTTON.Create("links", 300, 130)
		
		MENU.options_button_lights = TMENU_BUTTON.Create("light", 60, 440)
		MENU.options_button_particles = TMENU_BUTTON.Create("particles", 160, 440)
		
		MENU.credits_button_back = TMENU_BUTTON.Create("back", 590, 540)'options
		
		MENU.controls_button_back = TMENU_BUTTON.Create("back", 580, 530)'controls
	End Function
	
	
	Function draw_mouse()
		SetColor 255,255,255
		
		If MENU.mouse_down_1 Or MENU.mouse_hit_1 Then
			Draw_Image MENU.cursor_down_image, MENU.mouse_x, MENU.mouse_y
		Else
			Draw_Image MENU.cursor_up_image, MENU.mouse_x, MENU.mouse_y
		End If
	End Function
	
	Function play_level()
		
		Repeat
			
			Print "###### start"
			Local ret:Int = GAME.world.act_level.run()
			Print "###### end"
			
			If ret <> 1 Then
				Print "######## end it"
				Return
			End If
			
			If GAME.world.act_level_number < GAME.world.level_name_list.length-1 Then
				GAME.world.act_level_number:+1
				GAME.world.act_level = TLevel.Load(GAME.world, GAME.world.level_name_list[GAME.world.act_level_number],True)
				Print "###### next level"
			Else
				Print "###### top achieved"
				Return
			End If
			
		Forever
		
	End Function
	
	
	Function run_menu()
		
		Print "menu"
		
		'Music_Handler.stop()
		Repeat
			
			
			If KeyDown(KEY_LCONTROL) And KeyDown(KEY_LALT) And KeyDown(KEY_c) Then CHEAT_MODE=1
			
			
			Music_Handler.set_music("menu")
			
			If MENU.menu_button_options.mouse_over = 2 Then 'options
				MENU.menu_button_options.mouse_over = 0
				
				Sound_Handler.play_absolute("menu")
				
				MENU.run_options()
			End If
			
			If MENU.menu_button_quit.mouse_over = 2 Then 'quit
				Sound_Handler.play_absolute("menu")
				End
			End If
			
			If MENU.menu_button_credits.mouse_over = 2 Then 'credits
				MENU.menu_button_credits.mouse_over = 0
				
				Sound_Handler.play_absolute("menu")
				
				MENU.run_credits()
			End If
			
			
			If MENU.menu_button_resume.mouse_over = 2 Then 'resume
				MENU.menu_button_resume.mouse_over = 0
				
				If GAME.world.act_level Then
					Sound_Handler.play_absolute("menu")
					MENU.play_level()'GAME.world.act_level.run()
				End If
			End If
			
			MENU.mouse_x = MouseX()-(Graphics_Handler.mode = 2)*Graphics_Handler.origin_x'mouse
			MENU.mouse_y = MouseY()-(Graphics_Handler.mode = 2)*Graphics_Handler.origin_y
			
			If MENU.mouse_x>800 Then MENU.mouse_x = 800
			If MENU.mouse_y>600 Then MENU.mouse_y = 600
			If MENU.mouse_x<0 Then MENU.mouse_x = 0
			If MENU.mouse_y<0 Then MENU.mouse_y = 0
			
			MENU.mouse_down_1 = MouseDown(1)
			MENU.mouse_hit_1 = MouseHit(1)
			
			MENU.menu_button_options.render()'render
			MENU.menu_button_credits.render()
			MENU.menu_button_quit.render()
			MENU.menu_button_resume.render()
			
			'level auswahl
			MENU.menu_level_x_ziel:+MouseZSpeed()*100 + KeyHit(key_a)*200 - KeyHit(key_d)*200 + KeyHit(key_left)*200 - KeyHit(key_right)*200
			
			If MENU.mouse_y > 180 And MENU.mouse_y < 180+150 Then
				
				If MENU.mouse_x < 100 Then MENU.menu_level_x_ziel:+10.0*60.0/Graphics_Handler.FPS_MAX
				If MENU.mouse_x > 700 Then MENU.menu_level_x_ziel:-10.0*60.0/Graphics_Handler.FPS_MAX
				
			End If
			
			If MENU.menu_level_x_ziel > (800-150)/2 Then MENU.menu_level_x_ziel = (800-150)/2
			If MENU.menu_level_x_ziel < (800-150)/2 - (GAME.world.level_name_list.length-1)*200 Then MENU.menu_level_x_ziel = (800-150)/2 - (GAME.world.level_name_list.length-1)*200
			
			MENU.menu_level_x_act = 0.9*MENU.menu_level_x_act + 0.1*MENU.menu_level_x_ziel
			
			'MENU.menu_level_x_act:+Float(-MENU.menu_level_x_act+MENU.menu_level_x_ziel)*0.1'^(Graphics_Handler.FPS_MAX/60.0)
			
			
			Cls' DRAW
			SetColor 255,255,255
			Draw_Image MENU.menu_bg_image,0,0
			
			If NET_IMAGE Then Draw_Image NET_IMAGE,0,0
			
			If CHEAT_MODE=1 Then
				SetColor 255,0,0
				Draw_Rect 0,0,400,70
				SetColor 255,255,255
				
				SetImageFont Graphics_Handler.font_big
				
				Draw_Text "CHEAT-MODE IS ON !",5,5
				
				SetImageFont Graphics_Handler.font_small
			End If
			
			For Local i:Int = 0 To GAME.world.level_name_list.length-1
				
				If MENU.mouse_hit_1 Then
					If MENU.mouse_y > 180 And MENU.mouse_y < 180+150 Then
						If MENU.mouse_x > MENU.menu_level_x_act + i*200 And MENU.mouse_x < MENU.menu_level_x_act + i*200 + 150 Then
							
							'start level !!
							'GAME.world.level_name_list[i]
							
							Sound_Handler.play_absolute("menu")
							
							GAME.world.act_level_number = i
							
							GAME.world.act_level = TLevel.Load(GAME.world, GAME.world.level_name_list[i],True)
							
							'save check point at starting of level
							GAME.world.act_level.save_running_level("check_point_save_"+INFO.get_computer_name())
							
							MENU.play_level()'GAME.world.act_level.run()
							
							'ShowMouse()
							
						End If
					EndIf
				End If
				
				Draw_Image MENU.menu_level_bg_image,MENU.menu_level_x_act + i*200,180
				
				If i <= GAME.world.highest_level_completed Then
					
					Local txt:String = GAME.world.level_name_list[i]
					Draw_Text txt,MENU.menu_level_x_act + i*200+75-TextWidth(txt)/2,180+105
					
					If GAME.world.level_menu_image_list[i] Then
						Draw_Image GAME.world.level_menu_image_list[i], MENU.menu_level_x_act + i*200+15,180+15
					Else
						GAME_ERROR_HANDLER.error("level menu image not available!")
						Return'laden abbrechen
					End If
				Else
					Draw_Image MENU.level_locked_image, MENU.menu_level_x_act + i*200+15,180+15
				End If
			Next
			
			
			'internet
			Draw_Image MENU.menu_internet_image,350,400
			If MENU.mouse_x > 350 And MENU.mouse_y > 400 And MENU.mouse_x < 450 And MENU.mouse_y < 500 And MENU.mouse_hit_1 Then
				OpenURL("http://dingko.1x.de/")
			End If
			
			MENU.menu_button_options.draw()'draw
			MENU.menu_button_credits.draw()
			MENU.menu_button_quit.draw()
			If GAME.world.act_level Then MENU.menu_button_resume.draw()
			
			
			SetImageFont Graphics_Handler.font_big
			SetColor Rand(50,100),Rand(200,255),Rand(200,255)
			Draw_Text FRONT_MESSAGE,10,330
			SetImageFont Graphics_Handler.font_small
			
			MENU.draw_mouse()
			
			Graphics_Handler.draw_brille()
			
			
			Flip
		Until KeyHit(key_escape)
		
	End Function
	
	Function run_options()
		
		Local g_mode_list:TList = New TList
		
		For Local mode:TGraphicsMode = EachIn GraphicsModes()
			If mode.width >= 800 And mode.height >= 600 And mode.depth = 32 And mode.hertz = 60 Then
				Print mode.width+","+mode.height+","+mode.depth+","+mode.hertz
				
				g_mode_list.addlast(mode)
			End If
		Next
		
		Local x:Int = 0
		Local y:Int = 0
		
		For Local mode:TGraphicsMode = EachIn g_mode_list
			If mode.width = x And mode.height = y Then
				g_mode_list.remove(mode)
			Else
				x = mode.width
				y = mode.height
			End If
		Next
		
		Local g_mode_array:TGraphicsMode[] = New TGraphicsMode[g_mode_list.count()]
		
		Local i:Int = 0
		For Local mode:TGraphicsMode = EachIn g_mode_list
			g_mode_array[i] = mode
			i:+1
		Next
		
		Local current_g_mode:Int = g_mode_array.length-1
		
		Repeat
			
			Music_Handler.set_music("menu")
			
			If MENU.options_button_back.mouse_over = 2 Then 'back
				MENU.options_button_back.mouse_over = 0
				
				Sound_Handler.play_absolute("menu")
				Return
			End If
			
			If MENU.options_button_controls.mouse_over = 2 Then 'controlls
				MENU.options_button_controls.mouse_over = 0
				
				Sound_Handler.play_absolute("menu")
				MENU.run_controls()
			End If
			
			If MENU.options_button_fullscreen.mouse_over = 2 Then 'fullscreen
				MENU.options_button_fullscreen.mouse_over = 0
				
				Sound_Handler.play_absolute("menu")
				
				Graphics_Handler.set_graphics(800,600,2)
				
			End If
			
			If MENU.options_button_window.mouse_over = 2 Then 'window
				MENU.options_button_window.mouse_over = 0
				
				Sound_Handler.play_absolute("menu")
				
				Graphics_Handler.set_graphics(800,600,0)
				
			End If
			
			If MENU.options_button_apply.mouse_over = 2 Then 'apply
				MENU.options_button_apply.mouse_over = 0
				
				Sound_Handler.play_absolute("menu")
				
				Graphics_Handler.set_graphics(800,600,2, g_mode_array[current_g_mode].width, g_mode_array[current_g_mode].height)
				
				Print "apply"
			End If
			
			If MENU.options_button_rechts.mouse_over = 2 Then 'rechts
				MENU.options_button_rechts.mouse_over = 0
				
				Sound_Handler.play_absolute("menu")
				
				current_g_mode = (current_g_mode + 1) Mod g_mode_array.length
				
				Print "rechts"
			End If
			
			If MENU.options_button_links.mouse_over = 2 Then 'links
				MENU.options_button_links.mouse_over = 0
				
				Sound_Handler.play_absolute("menu")
				
				current_g_mode = (current_g_mode + g_mode_array.length-1) Mod g_mode_array.length
				
				Print "links"
			End If
			
			If MENU.options_button_lights.mouse_over = 2 Then 'lights
				MENU.options_button_lights.mouse_over = 0
				
				Sound_Handler.play_absolute("menu")
				
				TWorld.lightengine_on = 1-TWorld.lightengine_on
				
				Print "lights " + TWorld.lightengine_on
			End If
			
			If MENU.options_button_particles.mouse_over = 2 Then 'particles
				MENU.options_button_particles.mouse_over = 0
				
				Sound_Handler.play_absolute("menu")
				
				TWorld.particles_on = 1-TWorld.particles_on
				
				Print "particles " + TWorld.particles_on
			End If
			
			
			MENU.mouse_x = MouseX()-(Graphics_Handler.mode = 2)*Graphics_Handler.origin_x'mouse
			MENU.mouse_y = MouseY()-(Graphics_Handler.mode = 2)*Graphics_Handler.origin_y
			
			If MENU.mouse_x>800 Then MENU.mouse_x = 800
			If MENU.mouse_y>600 Then MENU.mouse_y = 600
			If MENU.mouse_x<0 Then MENU.mouse_x = 0
			If MENU.mouse_y<0 Then MENU.mouse_y = 0
			
			MENU.mouse_down_1 = MouseDown(1)
			MENU.mouse_hit_1 = MouseHit(1)
			
			MENU.options_button_back.render()'render
			MENU.options_button_controls.render()
			If Graphics_Handler.mode = 0 Then
				MENU.options_button_fullscreen.render()
			Else
				MENU.options_button_window.render()
				MENU.options_button_apply.render()
				
				MENU.options_button_rechts.render()
				MENU.options_button_links.render()
			End If
			
			
			
			'volume
			If MENU.mouse_x>50 And MENU.mouse_x<350 And MENU.mouse_y>350 And MENU.mouse_y<400 And MENU.mouse_down_1 Then
				Music_Handler.set_volume(Float(MENU.mouse_x-100)/200.0)
			End If
			
			If MENU.mouse_x>450 And MENU.mouse_x<750 And MENU.mouse_y>350 And MENU.mouse_y<400 And MENU.mouse_down_1 Then
				Sound_Handler.volume = Float(MENU.mouse_x-500)/200.0
				If Sound_Handler.volume > 1.0 Then Sound_Handler.volume = 1.0
				If Sound_Handler.volume < 0.0 Then Sound_Handler.volume = 0.0
				If MENU.mouse_hit_1 Then Sound_Handler.play_absolute("menu")
			End If
			'end volume
			
			Rem
			'fps
			If MENU.mouse_x>50+200 And MENU.mouse_x<350+200 And MENU.mouse_y>350+130 And MENU.mouse_y<400+130 And MENU.mouse_down_1 Then
				Graphics_Handler.FPS_MAX=Float(MENU.mouse_x-100-200)/2
				
				If Graphics_Handler.FPS_MAX<10 Then Graphics_Handler.FPS_MAX=10
				If Graphics_Handler.FPS_MAX>100 Then Graphics_Handler.FPS_MAX=100
			End If
			'end fps
			End Rem
			
			MENU.options_button_lights.render()
			MENU.options_button_particles.render()
			
			'render laguage
			If MENU.mouse_x>620 And MENU.mouse_x<620+100 And MENU.mouse_y>420 And MENU.mouse_y<420+100 And MENU.mouse_hit_1 Then
				'next language
				
				Print "next"
				
				Local c:Int=0
				
				For Local l:Language_Handler = EachIn Language_Handler.list
					If l = Language_Handler.cl Then Exit
					c:+1
				Next
				
				c = ((c+1) Mod Language_Handler.list.count())
				
				Local i:Int = 0
				
				For Local l:Language_Handler = EachIn Language_Handler.list
					If i = c Then Language_Handler.cl = l
					i:+1
				Next
			End If
			
			If MENU.options_button_lights.mouse_over <> 2 Then MENU.options_button_lights.mouse_over = TWorld.lightengine_on
			If MENU.options_button_particles.mouse_over <> 2 Then MENU.options_button_particles.mouse_over = TWorld.particles_on
			
			Cls
			
			draw_image MENU.options_bg_image,0,0
			
			MENU.options_button_lights.draw()
			MENU.options_button_particles.draw()
			
			
			Draw_Image Language_Handler.cl.image, 620, 420'language
			
			
			MENU.options_button_back.draw()'draw
			MENU.options_button_controls.draw()
			If Graphics_Handler.mode = 0 Then
				MENU.options_button_fullscreen.draw()
			Else
				MENU.options_button_window.draw()
				MENU.options_button_apply.draw()
				
				MENU.options_button_rechts.draw()
				MENU.options_button_links.draw()
				
				SetColor 200,200,200
				Draw_Rect 370,130,310,20
				
				SetColor 100,100,100
				Draw_Rect 375,135,300*current_g_mode/(g_mode_array.length-1),10
				
				Local by:Int=120
				Local bx:Int=g_mode_array[current_g_mode].width*by/g_mode_array[current_g_mode].height
				
				Local sy:Int = 600*by/g_mode_array[current_g_mode].height
				Local sx:Int = 800*by/g_mode_array[current_g_mode].height
				
				SetColor 200,200,200
				Draw_Rect 370,160,bx,by
				
				SetColor 50,50,50
				Draw_Rect 370+(bx-sx)/2,160+(by-sy)/2,sx,sy
				
				
				SetColor 200,200,200
				Draw_Text g_mode_array[current_g_mode].width,370+(bx-sx)/2+5,160+(by-sy)/2+5
				Draw_Text g_mode_array[current_g_mode].height,370+(bx-sx)/2+5,160+(by-sy)/2+25
			End If
			
			
			'volume
			SetColor 255,255,255
			Draw_Image MENU.volume_bar_image,50,350
			Draw_Image MENU.volume_glider_image,100.0+Float(Music_Handler.volume*190.0),350
			
			SetColor 255,255,255
			Draw_Image MENU.volume_bar_image,450,350
			Draw_Image MENU.volume_glider_image,500.0+Float(Sound_Handler.volume*190.0),350
			'end volume
			
			Rem
			'fps
			SetColor 255,255,255
			Draw_Image MENU.fps_bar_image,50+200,350+130
			Draw_Image MENU.volume_glider_image,100.0+Float(Graphics_Handler.FPS_MAX*2-10)+200,350+130
			'end fps
			End Rem
			
			MENU.draw_mouse()
			
			Graphics_Handler.draw_brille()
			
			Flip
		Until KeyHit(key_escape) Or AppTerminate()
		
	End Function
	
	
	
	Function run_credits()
		
		Repeat
			
			Music_Handler.set_music("menu")
			
			If MENU.credits_button_back.mouse_over = 2 Then 'quit
				MENU.credits_button_back.mouse_over = 0
				
				Sound_Handler.play_absolute("menu")
				
				Return
			End If
			
			MENU.mouse_x = MouseX()-(Graphics_Handler.mode = 2)*Graphics_Handler.origin_x'mouse
			MENU.mouse_y = MouseY()-(Graphics_Handler.mode = 2)*Graphics_Handler.origin_y
			
			If MENU.mouse_x>800 Then MENU.mouse_x = 800
			If MENU.mouse_y>600 Then MENU.mouse_y = 600
			If MENU.mouse_x<0 Then MENU.mouse_x = 0
			If MENU.mouse_y<0 Then MENU.mouse_y = 0
			
			MENU.mouse_down_1 = MouseDown(1)
			MENU.mouse_hit_1 = MouseHit(1)
			
			MENU.credits_button_back.render()'render
			
			Cls
			
			Draw_Image MENU.credits_bg_image,0,0
			
			MENU.credits_button_back.draw()'draw
			
			MENU.draw_mouse()
			
			Graphics_Handler.draw_brille()
			
			Flip
		Until KeyHit(key_escape) Or AppTerminate()
		
	End Function
	
	Function run_controls()
		
		Local control_selected:Int = -1
		
		Repeat
			
			Music_Handler.set_music("menu")
			
			If MENU.controls_button_back.mouse_over = 2 Then 'quit
				MENU.controls_button_back.mouse_over = 0
				
				Sound_Handler.play_absolute("menu")
				
				Return
			End If
			
			MENU.mouse_x = MouseX()-(Graphics_Handler.mode = 2)*Graphics_Handler.origin_x'mouse
			MENU.mouse_y = MouseY()-(Graphics_Handler.mode = 2)*Graphics_Handler.origin_y
			
			If MENU.mouse_x>800 Then MENU.mouse_x = 800
			If MENU.mouse_y>600 Then MENU.mouse_y = 600
			If MENU.mouse_x<0 Then MENU.mouse_x = 0
			If MENU.mouse_y<0 Then MENU.mouse_y = 0
			
			MENU.mouse_down_1 = MouseDown(1)
			MENU.mouse_hit_1 = MouseHit(1)
			
			MENU.controls_button_back.render()'render
			
			Cls
			
			Draw_Image MENU.controls_bg_image,0,0
			
			MENU.controls_button_back.draw()'draw
			
			'new part
			
			Local i:Int = 0
			
			For Local c:TControls = EachIn TControls.controls_list
				
				SetColor 0,0,0
				
				If MENU.mouse_x>50+(i>4)*400 And MENU.mouse_x<50+(i>4)*400+300 And MENU.mouse_y>200+(i Mod 5)*60 And MENU.mouse_y<200+(i Mod 5)*60+50 Then
					SetColor 30,30,30
					
					If MENU.mouse_hit_1 Then
						control_selected = i
					End If
				End If
				
				If control_selected = i Then
					For Local k:TKey = EachIn TControls.key_list
						If KeyHit(k.code) Then
							c.key = k
							
							TControls.save_controls()
							
							control_selected = -1
						End If
					Next
				End If
				
				Draw_Rect 50+(i>4)*400, 200+(i Mod 5)*60,300,50
				
				
				
				SetColor 255,255,255
				Draw_Text c.name,50+(i>4)*400+5, 200+(i Mod 5)*60+5
				
				If control_selected = i Then SetColor 255*(MilliSecs() Mod 600)/600,100*(MilliSecs() Mod 600)/600,100*(MilliSecs() Mod 600)/600
				
				Draw_Text c.key.name,50+(i>4)*400+5, 200+(i Mod 5)*60+5+20
				
				i:+1
			Next
			
			'end new part
			
			MENU.draw_mouse()
			
			Graphics_Handler.draw_brille()
			
			Flip
		Until AppTerminate()
	End Function
End Type

'########################################################################################
'###########################                   ##########################################
'###########################   MENU Buttons    ##########################################
'###########################                   ##########################################
'########################################################################################

Type TMENU_BUTTON
	Field image_up:TImage
	Field image_down:TImage
	
	Field mouse_over:Int = 0'1 = over, 2 = hit
	
	Field x:Int, y:Int
	
	Function Create:TMENU_BUTTON(name:String, x:Int,y:Int)
		Local b:TMENU_BUTTON = New TMENU_BUTTON
		
		If Not FileType("gfx\menu\buttons\" + name) Then
			GAME_ERROR_HANDLER.error("menu_button folder missing: gfx\menu\buttons\" + name)
			Return Null
		End If
		
		b.x = x
		b.y = y
		
		b.image_up = LoadImage("gfx\menu\buttons\" + name + "\up.png")
		b.image_down = LoadImage("gfx\menu\buttons\" + name + "\down.png")
		
		Return b
	End Function
	
	Method render()
		
		Self.mouse_over = 0
		If MENU.mouse_x > Self.x And MENU.mouse_y > Self.y And MENU.mouse_x < Self.x+Self.image_up.width And MENU.mouse_y < Self.y+Self.image_up.height Then
			Self.mouse_over = 1
			If MENU.mouse_hit_1 Then
				Self.mouse_over = 2
			End If
		End If
		
	End Method
	
	Method draw()
		SetColor 255,255,255
		
		If Self.mouse_over = 0 Then
			Draw_Image Self.image_up, Self.x, Self.y
		Else
			Draw_Image Self.image_down, Self.x, Self.y
		End If
		
	End Method
End Type

'########################################################################################
'###########################                   ##########################################
'########################### Language Handler  ##########################################
'###########################                   ##########################################
'########################################################################################

Rem
LANGUAGE:
 - Dialogue - all
 - Signs - all
 - audio botschaft - selective
End Rem

Type Language_Handler
	Global list:TList
	
	Global dl:Language_Handler'default language
	Global cl:Language_Handler'current language
	
	Field name:String
	Field small:String
	Field image:TImage
	
	Function init()
		Local path:String = "Worlds\" + GAME.world.name + "\Language\language.ini"
		Local l_map:TMap = DATA_FILE_HANDLER.Load(path)'world.ini
		
		If Not l_map Then
			GAME_ERROR_HANDLER.error("Language Handler -> map is not loaded! (" + path + ")")
			Return
		End If
		
		Language_Handler.list = New TList
		
		For Local n:String = EachIn l_map.keys()
			Print n + " / " + String(l_map.ValueForKey(n))
			
			Local l:Language_Handler = New Language_Handler
			
			l.name = n
			l.small = String(l_map.ValueForKey(n))
			
			l.image = LoadImage("Worlds\" + GAME.world.name + "\Language\" + l.name + ".png")
			
			Language_Handler.list.addlast(l)
			
			If Not Language_Handler.dl Then Language_Handler.dl = l
		Next
		
		Language_Handler.cl = Language_Handler.dl
	End Function
End Type

'########################################################################################
'###########################                   ##########################################
'###########################   SOUND Handler   ##########################################
'###########################                   ##########################################
'########################################################################################

Type Sound_Handler
	Global sound_map:TMap
	Global volume:Float = 1.0
	
	Function init()
		'load Sound_Handler.sound_map
		Sound_Handler.sound_map = New TMap
		
		'Sound_Handler.sound_map.insert(name,sound)
		Local files:String[] = LoadDir("Worlds\" + GAME.world.name + "\Sound", True)
		
		For Local t:String = EachIn files
			t = "Worlds\" + GAME.world.name + "\Sound\"+t
			
			If FileType(t) = 1 Then
				If ExtractExt(t) = "ogg" Then
					Print t
					
					Local sound:TSound = LoadSound(t)
					
					If Not sound Then
						Print "sound not loaded ! ! ! ! ! ! ! !"
					End If
					
					Sound_Handler.sound_map.insert(StripAll(t),sound)
				End If
			End If
		Next
	End Function
	
	
	Rem
	Function play(name:String,x:Float)
		Sound_Handler.play_absolute(name, x + GAME.world.act_level.ansicht_act_x)
	End Function
	End Rem
	
	
	Function play_absolute(name:String,x:Float = 400.0)
		Local sound:TSound = TSound(Sound_Handler.sound_map.ValueForKey(name))
		If Not sound Then Return
		Local pan:Float = 0
		
		If x < 0 Then
			pan = -1.0
		ElseIf x > 800 Then
			pan = 1.0
		Else
			pan = x/400.0 - 1.0
		End If
		
		Local channel:TChannel = sound.play()
		channel.SetPan(pan)
		channel.SetVolume(Sound_Handler.volume)
	End Function
	
	Function play_simple(name:String)
		Local sound:TSound = TSound(Sound_Handler.sound_map.ValueForKey(name))
		If Not sound Then Return
		
		sound.play()
		
	End Function
	
	Rem
	Function play_2d(name:String,x:Float,y:Float,radius:Float)
		Sound_Handler.play_absolute_2d(name, x + GAME.world.act_level.ansicht_act_x,y + GAME.world.act_level.ansicht_act_y,radius)
	End Function
	
	Function play_absolute_2d(name:String,x:Float = 400.0,y:Float=300,radius:Float)
		Local d:Float = ((x-400.0)^2.0 + (y-300.0)^2.0)^0.5
		If d > radius Then Return
		Local sound:TSound = TSound(Sound_Handler.sound_map.ValueForKey(name))
		
		If Not sound Then Return
		
		Local pan:Float = 0
		
		If x < 0 Then
			pan = -1.0
		ElseIf x > 800 Then
			pan = 1.0
		Else
			pan = x/400.0 - 1.0
		End If
		
		Local channel:TChannel = sound.play()
		channel.SetPan(pan)
		channel.SetVolume(Sound_Handler.volume*Float(1.0 - d/radius)^2)
	End Function
	End Rem
End Type

'########################################################################################
'###########################                   ##########################################
'###########################    Sound Player   ##########################################
'###########################                   ##########################################
'########################################################################################

Type TSoundPlayer
	Global list:TList
	
	Field name:String
	
	Field x:Float
	Field y:Float
	Field o:TObject
	
	Field radius:Float
	
	Field channel:TChannel
	
	Function run(name:String,x:Float,y:Float,o:TObject,radius:Float)
		Local s:TSoundPlayer = New TSoundPlayer
		
		s.name = name
		s.x = x
		s.y = y
		s.o = o
		s.radius = radius
		
		If s.o Then
			s.x = o.x
			s.y = o.y
		End If
		
		Local sound:TSound = TSound(Sound_Handler.sound_map.ValueForKey(name))
		
		If Not sound Then Return
		
		s.channel = sound.play()
		
		TSoundPlayer.list.addlast(s)
		
		s.render()
	End Function
	
	Function pause_all()
		If Not TSoundPlayer.list Then TSoundPlayer.list = New TList
		For Local s:TSoundPlayer = EachIn TSoundPlayer.list
			s.channel.SetPaused(True)
		Next
	End Function
	
	Function render_all()
		If Not TSoundPlayer.list Then TSoundPlayer.list = New TList
		For Local s:TSoundPlayer = EachIn TSoundPlayer.list
			s.channel.SetPaused(False)
			s.render()
		Next
	End Function
	
	Method render()
		
		If Not Self.channel.Playing() Then TSoundPlayer.list.remove(Self)
		
		If Self.o Then
			Self.x = Self.o.x + GAME.world.act_level.ansicht_act_x
			Self.y = Self.o.y + GAME.world.act_level.ansicht_act_y
		End If
		
		Local d:Float = ((Self.x-400.0)^2.0 + (Self.y-300.0)^2.0)^0.5
		
		If d > Self.radius Then d = Self.radius
		
		Local pan:Float = 0
		
		If Self.x < 0 Then
			pan = -1.0
		ElseIf Self.x > 800 Then
			pan = 1.0
		Else
			pan = Self.x/400.0 - 1.0
		End If
		
		Self.channel.SetPan(pan)
		Self.channel.SetVolume(Sound_Handler.volume*Float(1.0 - d/radius)^2)
	End Method
End Type

'########################################################################################
'###########################                   ##########################################
'###########################   MUSIC Handler   ##########################################
'###########################                   ##########################################
'########################################################################################


Type Music_Handler
	Global current_music_name:String
	Global current_music:TChannel
	Global sound:TSound 
	
	Global music_map:TMap
	Global volume:Float = 1.0
	
	Function init()
		'load Sound_Handler.sound_map
		Music_Handler.music_map = New TMap
		
		'Sound_Handler.sound_map.insert(name,sound)
		Local files:String[] = LoadDir("Worlds\" + GAME.world.name + "\Music", True)
		
		For Local t:String = EachIn files
			t = "Worlds\" + GAME.world.name + "\Music\"+t
			
			If FileType(t) = 1 Then
				If ExtractExt(t) = "ogg" Then
					Print t
					
					Local sound:TSound = LoadSound(t)
					
					If Not sound Then
						Print "sound not loaded ! ! ! ! ! ! ! !"
					End If
					
					Music_Handler.music_map.insert(StripAll(t),sound)
				End If
			End If
		Next
	End Function
	
	Function set_music(name:String)
		If Music_Handler.current_music_name <> name Then
			
			Local sound:TSound = TSound(Music_Handler.music_map.ValueForKey(name))
			
			If sound Then
				Music_Handler.current_music_name = name
				If Music_Handler.current_music Then Music_Handler.current_music.stop()
				
				Music_Handler.sound = sound
				Music_Handler.current_music = Music_Handler.sound.play()
				Music_Handler.current_music.SetVolume(Music_Handler.volume)
			End If
		End If
		
		Self.render_me()
	End Function
	
	Function render_me()
		If Not Music_Handler.current_music.Playing() Then
			Music_Handler.current_music = Music_Handler.sound.play()
			Music_Handler.current_music.SetVolume(Music_Handler.volume)
		End If
	End Function
	
	Function stop()
		Music_Handler.current_music.stop()
		Music_Handler.current_music = Null
	End Function
	
	Function set_volume(volume:Float)
		Music_Handler.volume = volume
		If Music_Handler.volume > 1.0 Then Music_Handler.volume = 1.0
		If Music_Handler.volume < 0.0 Then Music_Handler.volume = 0.0
		If Music_Handler.current_music Then Music_Handler.current_music.SetVolume(Music_Handler.volume)
	End Function
End Type

'########################################################################################
'###########################                   ##########################################
'###########################  Loading Screen   ##########################################
'###########################                   ##########################################
'########################################################################################

Type LoadingScreen
	Global loading_animation:TImage
	Global last_frame:Int
	Global act_frame:Int
	
	Function init()
		AppTitle = "GAME Loading ..."
		Graphics 300,300
		
		LoadingScreen.loading_animation = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\player\mode_plant\1_0.png",104,108)
		LoadingScreen.last_frame = MilliSecs()
		LoadingScreen.act_frame = 0
		
		'SetClsColor 100,50,20
	End Function
	
	Function render_image()
		Cls
		
		If LoadingScreen.last_frame+150 < MilliSecs() Then
			LoadingScreen.last_frame:+150
			
			LoadingScreen.act_frame:+1
			
			If LoadingScreen.act_frame >= LoadingScreen.loading_animation.frames.length-1 Then
				LoadingScreen.act_frame = 0
			End If
		End If
		
		Draw_Image LoadingScreen.loading_animation,95,95,LoadingScreen.act_frame
		
		If KeyHit(key_escape) Then End
		If AppTerminate() Then End
		
		DrawText "Version " + VERSION,2,286
		
		Flip
	End Function
	
	Function run_loader:Object( data:Object )
		
		TPLAYER_MODE.init()' ### INIT PRELEVEL ###
		
		TBox.init_before_level()
		TBox_Burnable.init_before_level()
		TBox_Stone.init_before_level()
		TBox_Door.init_before_level()
		TBox_Key.init_before_level()
		
		TBADIE.init()
		TFireBird.init()
		TBox_Renderer_TLamp.init()
		
		SetMaskColor(255,0,255)
		Sound_Handler.init()
		'------------------------ INIT ALL OBJECTs -----------------------------
		
		TPLAYER.init()
		
		TLight.init()
		
		TBox.init_after_level()
		TBox_Burnable.init_after_level()
		TBox_Stone.init_after_level()
		TBox_Door.init_after_level()
		TBox_Key.init_after_level()
		
		TPARTIKEL.init()
		
		Music_Handler.init()
		
		TControls.init()
		
		Language_Handler.init()
		
		MENU.init()' ### LOAD MENU ###
		
		NET_IMAGE = LoadImage(LoadBank("http::dingko.1x.de/"+ VERSION +".png"))
		
		HideMouse()
	End Function
End Type

'##########################################################################################
'###############################      END OF TYPES         ################################
'##########################################################################################
'###############################          MAIN             ################################
'##########################################################################################

SetMaskColor(255,0,255)
GAME.load_world("Testiania")' ### LOAD WORLD ###

LoadingScreen.init()

Local thread:TThread=CreateThread(LoadingScreen.run_loader,"run it biach !!")

Repeat
	LoadingScreen.render_image()
Until Not ThreadRunning(Thread)
WaitThread(Thread)


AppTitle = "GAME #  Version: " + VERSION + ", C: " + VERSION_COMPATIBILITY
Graphics_Handler.set_graphics(800,600,0)' ## INIT GRAPHICS ##

MENU.run_menu()

End