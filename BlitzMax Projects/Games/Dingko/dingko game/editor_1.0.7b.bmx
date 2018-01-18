SuperStrict

Framework BRL.GlMax2D

Import BRL.System
Import BRL.Map
Import BRL.StandardIO
Import BRL.Retro
Import BRL.PNGLoader

Import PUB.Win32
Import BRL.PolledInput

Include "modules/gui.bmx"

Const VERSION:String = "1.0.7a"
Const VERSION_COMPATIBILITY:Int = 5

'########################################################################################
'###########################       ######################################################
'########################### INFO  ######################################################
'###########################       ######################################################
'########################################################################################

Extern "win32"
	Function GetComputerNameA(lpbuffer:Byte Ptr,nSize:Int Ptr)
EndExtern

Type INFO
	Function get_computer_name:String()
		Local Size:Int = 32
		Local Buffer:Byte Ptr = MemAlloc(Size)
		GetComputerNameA(buffer,Varptr(size))
		Local name$ = String.FromCString(buffer)
		MemFree buffer
		
		Return name + " # " + getenv_("username")
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
		
		Local gfx_map:TMap = DATA_FILE_HANDLER.Load("Worlds\" + GAME.world.name + "\Levels\levels.ini")
		
		If Not gfx_map Then
			GAME_ERROR_HANDLER.error("GAME->load_world() ini -> map is not loaded! (Worlds\" + GAME.world.name + "\Levels\levels.ini)")
			GAME.world = Null
			Return
		End If
		
		Local i:Int = 0
		
		GAME.world.level_name_list = Null
		
		Repeat
			i:+1
			
			If gfx_map.contains("level_" + i) Then'START LEVEL
				
				GAME.world.level_name_list:+ [String(gfx_map.ValueForKey("level_" + i))]
				
				Print String(gfx_map.ValueForKey("level_" + i))
				
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
	
	Field level_name_list:String[]
	
	'actual_level """""""""""""""""""""""""""""""""""""
	Field act_level:TLevel
	
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
				Print "### NEW DIALOGUE: " + f + " ###"
				
				If ExtractExt(f) = "txt" Then
					Local d:TDialogue = New TDialogue
					
					d.name = StripAll(f)
					
					Local text_file:TStream = ReadFile("Worlds\" + level.world.name + "\Levels\" + level.name + "\dialogues\" + f)
					
					Local act_sub:TDialogue_Sub
					
					While Not Eof(text_file)
						
						Local rl:String = ReadLine(text_file)
						
						
						If Mid(rl, 1,1)="#" Then
							Print "new face:"
							If act_sub Then
								d.subs = d.subs + [act_sub]
							End If
							
							act_sub = New TDialogue_Sub
							act_sub.face = Mid(rl, 2,-1)
							Print act_sub.face
						Else
							If act_sub Then
								Print "line: " + rl
								act_sub.lines = act_sub.lines + [rl]
							Else
								Print "komentar: " + rl
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
'########################### BLOCK       Groups  ########################################
'###########################                     ########################################
'########################################################################################

Type TBlock_Group
	Global list:TList
	
	Function init()
		Print "---------------- Load Block Groups --------------------"
		TBlock_Group.list = New TList
		Local i:Int = 0
		Repeat
			i:+1
			If FileType("Worlds\" + GAME.world.name + "\Blocks\gfx\groups\"+i+".ini") Then
				Print i
				TBlock_Group.list.addlast(TBlock_Group.Load(i))
			Else
				Exit
			End If
		Forever
		Print "--------------------------------------------------------"
	End Function
	
	Function get_group:Int(number:Int)
		For Local g:TBlock_Group = EachIn TBlock_Group.list
			If g.is_member(number) Then Return g.g_number
		Next
		
		Return 0
	End Function
	
	Function get_number:Int(group_number:Int, code:String)
		For Local g:TBlock_Group = EachIn TBlock_Group.list
			If g.g_number = group_number Then
				
				Return g.get_member(code).number
				
			End If
		Next
	End Function
	
	Field member_list:TList
	Field g_number:Int
	
	Function Load:TBlock_Group(g_number:Int)
		Local g:TBlock_Group = New TBlock_Group
		g.member_list = New TList
		g.g_number = g_number:Int
		
		Local path:String = "Worlds\" + GAME.world.name + "\Blocks\gfx\groups\"+g.g_number+".ini"
		
		Local gfx_map:TMap = DATA_FILE_HANDLER.Load(path)
		
		If Not gfx_map Then
			GAME_ERROR_HANDLER.error("TBlock_Group: could not load: " +path)
			Return Null
		End If
		
		For Local n:String = EachIn gfx_map.keys()
			If Mid(n,1,1)<>"#" Then
				Local code:String = String(gfx_map.ValueForKey(n))
				
				'Print "... " + n + " _ " + code
				
				g.member_list.addlast(TBlock_Group_Member.Create(Int(n),code))
			End If
		Next
		
		Return g
	End Function
	
	Method is_member:Int(number:Int)
		For Local m:TBlock_Group_Member = EachIn Self.member_list
			If number = m.number Then Return 1
		Next
		Return 0
	End Method
	
	Method get_member:TBlock_Group_Member(code:String)
		For Local m:TBlock_Group_Member = EachIn Self.member_list
			If m.compare_code(code) Then Return m
		Next
		Return Null
	End Method
End Type

'########################################################################################
'###########################                     ########################################
'########################### BLOCK Groups Member ########################################
'###########################                     ########################################
'########################################################################################

Type TBlock_Group_Member
	Field number:Int
	Field code:String
	
	Function Create:TBlock_Group_Member(number:Int, code:String)
		Local m:TBlock_Group_Member = New TBlock_Group_Member
		
		m.number = number
		m.code = code
		
		Return m
	End Function
	
	Method compare_code:Int(code:String)'0=different,1=same
		For Local i:Int = 1 To 9
			Local cc1:String = Mid(code,i,1)
			Local cc2:String = Mid(Self.code,i,1)
			
			Select cc1
				Case "1"
					If cc2="0" Then Return 0
				Case "0"
					If cc2="1" Then Return 0
			End Select
		Next
		
		'Print Self.code + " " + code
		
		Return 1
	End Method
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
	
	Field collision_image:TImage=LoadImage("Worlds\" + GAME.world.name + "\Blocks\gfx\collision.png")
	
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
						Print "### LOAD IMAGE with " + manager.anz_frames[i] + " FRAMES"
						
						manager.images[i] = LoadAnimImage("Worlds\" + world_name + "\Blocks\gfx\"+i+".png", manager.image_side, manager.image_side, 0, manager.anz_frames[i])
						
					Else
						GAME_ERROR_HANDLER.error("BLOCK_IMAGE_MANAGER: image width to big! (Worlds\" + world_name + "\Blocks\gfx\"+i+".png)")
					End If
				End If
			Next
			
			manager.collision_image=LoadImage("Worlds\" + world_name + "\Blocks\gfx\collision.png")
			
			If Not manager.collision_image Then' WAS IMAGE LOADED?
				GAME_ERROR_HANDLER.error("BLOCK_IMAGE_MANAGER: collision_image not found! (Worlds\" + world_name + "\Blocks\gfx\collision.png)")
			End If
			
		Else
			GAME_ERROR_HANDLER.error("BLOCK_IMAGE_MANAGER: count not found! (Worlds\" + world_name + "\Blocks\gfx\gfx.ini)")
			Return Null
		End If
		
		Return manager
	End Function
	
	Method choose_image:Int(actual_image:Int)
		Local chosen:Int = actual_image
		If chosen > Self.anz_images-1 Then chosen = 0
		
		Local page:Int = (chosen / (7*12))
		
		SetViewport(0,0,1200,700)
		SetClsColor 0,0,0
		
		Repeat
			EMEGUI.render_events()
			
			chosen:+ EMEGUI.m_z_speed * (7*12)
			If chosen < 0 Then chosen = 0
			
			Cls
			
			If chosen > Self.anz_images-1 Then chosen = Self.anz_images-1
			page = (chosen / (7*12))
			For Local y:Int = 0 To 6
				For Local x:Int = 0 To 11
					If x+y*12 + page*(7*12) <= Self.anz_images-1 Then
						
						If x+y*12 + page*(7*12) = chosen Then
							SetColor 255,0,0
							DrawRect x*100, y*100,100,100
							SetColor 0,0,0
							DrawRect x*100 + 2, y*100 + 2,96,96
						Else
							SetColor 100,100,100
							DrawRect x*100, y*100,100,100
							SetColor 0,0,0
							DrawRect x*100 + 1, y*100 + 1,98,98
						End If
						
						SetColor 255,255,255
						DrawImage Self.images[x+y*12 + page*(7*12)], x*100 + 18, y*100 + 18, ((MilliSecs()/200) Mod Self.anz_frames[x+y*12 + page*(7*12)])
						
						If EMEGUI.m_hit_1 And EMEGUI.m_x > x*100 And EMEGUI.m_y > y*100 And EMEGUI.m_x < x*100 + 100 And EMEGUI.m_y < y*100 + 100 Then
							chosen = x+y*12 + page*(7*12)
						End If
					End If
				Next
			Next
			SetColor 150,150,150
			DrawRect 0,0,70,15
			SetColor 0,0,0
			DrawText "Page: " + (page+1),0,0
			
			MOUSE.draw()
			
			Flip
			
			If KeyHit(key_enter) Then Return chosen
			If KeyHit(key_escape) Then Return actual_image
		Forever
	End Method
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
	
	Field sign_text_map:TMap
	
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
	
	'OBJECTS -> CHUNKS
	Field anz_chunks_x:Int
	Field anz_chunks_y:Int
	Field chunks:TCHUNK[anz_chunks_x, anz_chunks_y,5]'x,y,layer   -> normal objects
	
	Field super_chunks:TCHUNK[5]'layer   -> important objects that need to be rendered everytime
	
	'so that the doors can be found by the keys!
	Field door_list:TList = New TList
	
	'dialogue map:
	
	Field dialogue_map:TMap
	
	Function Create:TLevel(world:TWorld, name:String, table_x:Int, table_y:Int, autor:String)
		Local l:TLevel = New TLevel
		
		l.name = name
		l.world = world
		
		l.vers = VERSION'specs
		l.vers_c = VERSION_COMPATIBILITY
		l.autor = autor
		l.date = CurrentDate$() + " " + CurrentTime$()
		
		l.table_x = table_x
		l.table_y = table_y
		
		l.table = New TBlock[l.table_x, l.table_y]
		
		l.image_side = l.world.block_image_manager.image_side
		
		'fill table witch blank-blocks:
		
		For Local x:Int = 0 To l.table_x-1
			For Local y:Int = 0 To l.table_y-1
				Local coll:Int
				
				If x = 0 Or y = 0 Or x = l.table_x-1 Or y = l.table_y-1 Then
					coll = 1
				Else
					coll = 0
				End If
				
				If y > l.table_y/2 Then
					l.table[x,y] = TBlock.Create(1, 1, -1, 0, -1)
				Else
					l.table[x,y] = TBlock.Create(coll, 0, -1, 0, -1)
				End If
				
			Next
		Next
		
		l.init_chunks(l.table_x*l.image_side/5, l.table_y*l.image_side/5)
		
		'------------- prepare SIGN TEXTS !
		
		l.sign_text_map = New TMap
		
		Return l
	End Function
	
	Method copy:TLevel(name:String, x1:Int, y1:Int, x2:Int, y2:Int)
		If x1 > x2 Then'check x
			Local x:Int = x1
			x1 = x2
			x2 = x
		End If
		
		If y1 > y2 Then'check y
			Local y:Int = y1
			y1 = y2
			y2 = y
		End If
		
		Local l:TLevel = New TLevel
		
		l.name = name
		l.world = Self.world
		l.table_x = x2-x1+1
		l.table_y = y2-y1+1
		
		l.table = New TBlock[l.table_x, l.table_y]
		
		l.image_side = l.world.block_image_manager.image_side
		
		'fill table witch blank-blocks:
		
		For Local x:Int = 0 To l.table_x-1
			For Local y:Int = 0 To l.table_y-1
				l.table[x,y] = Self.table[x + x1, y + y1].copy()
			Next
		Next
		
		l.init_chunks(l.table_x*l.image_side/5, l.table_y*l.image_side/5)
		
		Return l
	End Method
	
	Method paste(into:TLevel,x:Int,y:Int)
		'es gibt ärger wenn level aus into herauslappt
		For Local xx:Int = 0 To Self.table_x-1
			For Local yy:Int = 0 To Self.table_y-1
				If xx + x <= into.table_x-1 And yy + y <= into.table_y-1 Then
					into.table[xx + x, yy + y] = Self.table[xx, yy].copy()
				End If
			Next
		Next
	End Method
	
	Function Load:TLevel(world:TWorld, name:String, read_objects:Int = False, load_old_versions:Int = True)
		Local l:TLevel = New TLevel
		
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
		
		'-------------------- OBJECTS ----------------
		'prepare chunks
		l.init_chunks(l.table_x*l.image_side/5, l.table_y*l.image_side/5)
		
		If read_objects = True Then'SHOULD WE REALLY LOAD THE OBJECTS ?
			
			Print "//////////////  load objects \\\\\\\\\\\\\\\"
			
			'load objects
			Local object_file:TStream = ReadFile("Worlds\" + l.world.name + "\Levels\" + l.name + "\objects.data")
			
			Print "1"
			
			If Not object_file Then
				GAME_ERROR_HANDLER.error("load -> reading objects: could not open file! : Worlds\" + l.world.name + "\Levels\" + l.name + "\objects.data")
				Return Null
			End If
			
			
			If Not load_old_versions Then'load_old_versions
				' # VERSION
				Local l2:Int = object_file.ReadInt()
				l.vers = object_file.ReadString(l2)
				l.vers_c = object_file.ReadInt()
				
				' # AUTOR
				Local a2:Int = object_file.ReadInt()
				l.autor = object_file.ReadString(a2)
				
				' # DATE
				Local d2:Int = object_file.ReadInt()
				l.date = object_file.ReadString(d2)
			End If
			
			' # Objects
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
							Print "/// did not find this type \\\"
					End Select
					
					If o <> Null Then
						l.add_object(o)
					Else
						GAME_ERROR_HANDLER.error("load -> reading objects -> could not create Object!")
					End If
					
				Wend
			'Catch error:String
			'	GAME_ERROR_HANDLER.error("load -> reading objects: " + error)
			'	Return Null
			'End Try
			
			CloseFile(object_file)
			
			
			
			'------------- LOAD SIGN TEXTS !
			
			l.sign_text_map = Sign_Text.load_for_level(l)
			
		End If
		
		TDialogue.load_for_level(l)
		
		Return l
	End Function
	
	Method save(save_objects:Int = False, path:String = "")
		If path = "" Then path = "Worlds\" + Self.world.name + "\Levels\" + Self.name
		
		
		If Not FileType(path) Then'create directory for level
			If Not CreateDir(path) Then
				GAME_ERROR_HANDLER.error("could not create: " + path)
				Return
			End If
		End If
		
		Local file:TStream = WriteFile(path + "\table.data")
		
		' ---------- TABLE ---------------
		file.WriteInt(Self.table_x)'table x
		file.WriteInt(Self.table_y)'table y
		
		For Local x:Int = 0 To Self.table_x-1'table
			For Local y:Int = 0 To Self.table_y-1
				file.WriteInt(Self.table[x,y].collision)'collision
				
				file.WriteInt(Self.table[x,y].fg_image_number)'fg
				file.WriteInt(Self.table[x,y].fg_delta_t)
				
				file.WriteInt(Self.table[x,y].bg_image_number)'bg
				file.WriteInt(Self.table[x,y].bg_delta_t)
			Next
		Next
		
		CloseFile(file)
		
		' ----------- OBJECTS ------------
		If save_objects = True Then
			Local object_file:TStream = WriteFile(path + "\objects.data")
			
			' # VERSION
			object_file.WriteInt(Len(VERSION))
			object_file.WriteString(VERSION)
			
			object_file.WriteInt(VERSION_COMPATIBILITY)
			
			' # AUTOR
			object_file.WriteInt(Len(INFO.get_computer_name()))
			object_file.WriteString(INFO.get_computer_name())
			
			' # DATE
			Self.date = CurrentDate$() + " " + CurrentTime$()
			object_file.WriteInt(Len(Self.date))
			object_file.WriteString(Self.date)
			
			
			' # Objects
			For Local x:Int = 0 To Self.anz_chunks_x-1
				For Local y:Int = 0 To Self.anz_chunks_y-1
					For Local layer:Int = 0 To 4
						For Local o:TObject = EachIn Self.chunks[x,y,layer].list
							o.write_to_stream(object_file)
						Next
					Next
				Next
			Next
			
			For Local layer:Int = 0 To 4
				For Local o:TObject = EachIn Self.super_chunks[layer].list
					o.write_to_stream(object_file)
				Next
			Next
			
			CloseFile(object_file)
		End If
	End Method
	
	
	
	Method update_block_groups()
		For Local x:Int = 0 To Self.table_x-1
			For Local y:Int = 0 To Self.table_y-1
				
				'----------------------------------- fg
				Local code:String = ""
				Local g1:Int
				Local g2:Int
				
				For Local yy:Int = -1+y To 1+y
					For Local xx:Int = -1+x To 1+x
						
						If yy<0 Or xx<0 Or yy>Self.table_y-1 Or xx>Self.table_x-1 Then
							code:+"0"
						Else
							g1 = TBlock_Group.get_group(Self.table[x,y].fg_image_number)
							g2 = TBlock_Group.get_group(Self.table[xx,yy].fg_image_number)
							
							If g1 = g2 Then
								code:+"1"
							Else
								code:+"0"
							End If
						End If
						
					Next
				Next
				
				'Print code
				
				'If code = "111111111" Then Print "----------------------------------------"
				
				
				If g1>0 Then
					'Print TBlock_Group.get_number(g1, code)
					Self.table[x,y].fg_image_number = TBlock_Group.get_number(g1, code)
				End If
				
				'----------------------------------- bg
				code = ""
				
				For Local yy:Int = -1+y To 1+y
					For Local xx:Int = -1+x To 1+x
						
						If yy<0 Or xx<0 Or yy>Self.table_y-1 Or xx>Self.table_x-1 Then
							code:+"0"
						Else
							g1 = TBlock_Group.get_group(Self.table[x,y].bg_image_number)
							g2 = TBlock_Group.get_group(Self.table[xx,yy].bg_image_number)
							
							If g1 = g2 Then
								code:+"1"
							Else
								code:+"0"
							End If
						End If
						
					Next
				Next
				
				'Print code
				
				If g1>0 Then
					'Print TBlock_Group.get_number(g1, code)
					Self.table[x,y].bg_image_number = TBlock_Group.get_number(g1, code)
				End If
			Next
		Next
	End Method
	
	
	
	Method update_block_groups_reverse()
		For Local x:Int = 0 To Self.table_x-1
			For Local y:Int = 0 To Self.table_y-1
				
				'----------------------------------- fg
				Local code:String = ""
				Local g1:Int
				Local g2:Int
				
				For Local yy:Int = -1+y To 1+y
					For Local xx:Int = -1+x To 1+x
						
						If yy<0 Or xx<0 Or yy>Self.table_y-1 Or xx>Self.table_x-1 Then
							code:+"0"
						Else
							g1 = TBlock_Group.get_group(Self.table[x,y].fg_image_number)
							g2 = TBlock_Group.get_group(Self.table[xx,yy].fg_image_number)
							
							If g1 = g2 Then
								code:+"1"
							Else
								code:+"0"
							End If
						End If
						
					Next
				Next
				
				'Print code
				
				If g1>0 Then
					'Print TBlock_Group.get_number(g1, "")
					Self.table[x,y].fg_image_number = TBlock_Group.get_number(g1, "")
				End If
				
				'----------------------------------- bg
				code = ""
				
				For Local yy:Int = -1+y To 1+y
					For Local xx:Int = -1+x To 1+x
						
						If yy<0 Or xx<0 Or yy>Self.table_y-1 Or xx>Self.table_x-1 Then
							code:+"0"
						Else
							g1 = TBlock_Group.get_group(Self.table[x,y].bg_image_number)
							g2 = TBlock_Group.get_group(Self.table[xx,yy].bg_image_number)
							
							If g1 = g2 Then
								code:+"1"
							Else
								code:+"0"
							End If
						End If
						
					Next
				Next
				
				'Print code
				
				If g1>0 Then
					'Print TBlock_Group.get_number(g1, "")
					Self.table[x,y].bg_image_number = TBlock_Group.get_number(g1, "")
				End If
			Next
		Next
	End Method
	
	
	
		
	Method render()
		If Self.ansicht_ziel_x > 200 Then
			Self.ansicht_ziel_x = 200
		End If
		
		If Self.ansicht_ziel_y > 200 Then
			Self.ansicht_ziel_y = 200
		End If
		
		If Self.ansicht_ziel_x < - GAME.world.act_level.table_x*GAME.world.block_image_manager.image_side - 200 + 800 Then
			Self.ansicht_ziel_x = - GAME.world.act_level.table_x*GAME.world.block_image_manager.image_side - 200 + 800
		End If
		
		If Self.ansicht_ziel_y < - GAME.world.act_level.table_y*GAME.world.block_image_manager.image_side - 200 + 600 Then
			Self.ansicht_ziel_y = - GAME.world.act_level.table_y*GAME.world.block_image_manager.image_side - 200 + 600
		End If
		
		Self.ansicht_act_x = 0.8*Self.ansicht_act_x + 0.2*Self.ansicht_ziel_x
		Self.ansicht_act_y = 0.8*Self.ansicht_act_y + 0.2*Self.ansicht_ziel_y
	End Method
	
	Method render_key_movement()
		If KeyDown(key_right) Or KeyDown(key_d) Then Self.ansicht_ziel_x:-20 + 50*KeyDown(KEY_LSHIFT)
		If KeyDown(key_left) Or KeyDown(key_a) Then Self.ansicht_ziel_x:+20 + 50*KeyDown(KEY_LSHIFT)
		
		If KeyDown(key_up) Or KeyDown(key_w) Then Self.ansicht_ziel_y:+20 + 50*KeyDown(KEY_LSHIFT)
		If KeyDown(key_down) Or KeyDown(key_s) Then Self.ansicht_ziel_y:-20 + 50*KeyDown(KEY_LSHIFT)
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
	
	
	Method draw_collision()
		
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
				
				table[x,y].collision_draw(x*Self.image_side + Self.ansicht_act_x, y*Self.image_side + Self.ansicht_act_y)
				
			Next
		Next
		
	End Method
	
	Method copy_block_into_slot(x:Int, y:Int, slot:TBlock_Slot)
		
		If x > Self.table_x-1 Or x < 0 Or y > Self.table_y-1 Or y < 0 Then
			GAME_ERROR_HANDLER.error("copy_block_into_slot: x,y out of range of table!")
			Return
		End If
		
		Local t_block:TBlock = Self.table[x, y]
		
		slot.block.fg_image_number = t_block.fg_image_number
		slot.block.fg_act_frame = t_block.fg_act_frame
		slot.block.fg_delta_t = t_block.fg_delta_t
		slot.block.fg_last_t = t_block.fg_last_t
		
		slot.block.bg_image_number = t_block.bg_image_number
		slot.block.bg_act_frame = t_block.bg_act_frame
		slot.block.bg_delta_t = t_block.bg_delta_t
		slot.block.bg_last_t = t_block.bg_last_t
		
		slot.block.collision = t_block.collision
		
	End Method
	
	Method copy_slot_into_block(x:Int, y:Int, slot:TBlock_Slot)
		
		If x > Self.table_x-1 Or x < 0 Or y > Self.table_y-1 Or y < 0 Then
			GAME_ERROR_HANDLER.error("copy_block_into_slot: x,y out of range of table!")
			Return
		End If
		
		Local t_block:TBlock = Self.table[x, y]
		
		If slot.fg_use_check.wert = 1 Then'fg
			t_block.fg_image_number = slot.block.fg_image_number
			t_block.fg_act_frame = slot.block.fg_act_frame
			t_block.fg_delta_t = slot.block.fg_delta_t
			t_block.fg_last_t = slot.block.fg_last_t
		End If
		
		If slot.bg_use_check.wert = 1 Then'bg
			t_block.bg_image_number = slot.block.bg_image_number
			t_block.bg_act_frame = slot.block.bg_act_frame
			t_block.bg_delta_t = slot.block.bg_delta_t
			t_block.bg_last_t = slot.block.bg_last_t
		End If
		
		If slot.collision_use_check.wert = 1 Then'collision
			t_block.collision = slot.block.collision
		End If
	End Method
	
	Method fill_with_slot(x:Int, y:Int, slot:TBlock_Slot,slot_old:TBlock_Slot)
		
		'Print x + " : " + y
		
		If TBlock.are_the_same(slot.block,slot_old.block) Then
			
			Return
		End If
		
		If x > Self.table_x-1 Or x < 0 Or y > Self.table_y-1 Or y < 0 Then'check wether still in map
			Return
		End If
		
		Local t_block:TBlock = Self.table[x, y]'find block of coordinates
		
		'check block with old slot
		If TBlock.are_the_same(t_block,slot_old.block) Then
			'must replace
			
			Self.table[x, y] = slot.block.copy()
			
			Self.fill_with_slot(x+1, y, slot,slot_old)
			Self.fill_with_slot(x-1, y, slot,slot_old)
			Self.fill_with_slot(x, y+1, slot,slot_old)
			Self.fill_with_slot(x, y-1, slot,slot_old)
			
		Else
			Return'must change nothing
		End If
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
	
	Method render_chunks()'RENDERS chunks
		For Local x:Int = 0 To Self.anz_chunks_x-1
			For Local y:Int = 0 To Self.anz_chunks_y-1
				For Local layer:Int = 0 To 4
					Self.chunks[x,y,layer].render()'noch zu optimieren         !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
				Next
			Next
		Next
		
		For Local layer:Int = 0 To 4
			Self.super_chunks[layer].render()
		Next
	End Method
	
	Method draw_chunks(layer:Int)'DRAW Chunks of a certain layer
		For Local x:Int = 0 To Self.anz_chunks_x-1
			For Local y:Int = 0 To Self.anz_chunks_y-1
				Self.chunks[x,y,layer].draw()'noch zu optimieren         !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			Next
		Next
		
		Self.super_chunks[layer].draw()
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
	
	Method copy:TBlock()
		Local b:TBlock = New TBlock
		
		b.collision = Self.collision
		
		'foreground
		b.fg_image_number = Self.fg_image_number
		b.fg_delta_t = Self.fg_delta_t
		
		If b.fg_image_number > GAME.world.block_image_manager.anz_images-1 Then
			GAME_ERROR_HANDLER.error("create:TBLOCK fg_image_number out of range!")
		End If
		
		b.fg_act_frame = Self.fg_act_frame
		b.fg_last_t = Self.fg_last_t
		
		'background
		b.bg_image_number = Self.bg_image_number
		b.bg_delta_t = Self.bg_delta_t
		
		If b.bg_image_number > GAME.world.block_image_manager.anz_images-1 Then
			GAME_ERROR_HANDLER.error("create:TBLOCK bg_image_number out of range!")
		End If
		
		b.bg_act_frame = Self.bg_act_frame
		b.bg_last_t = Self.bg_last_t
		
		Return b
	End Method
	
	Function are_the_same:Int(b1:TBlock,b2:TBlock)
		If b1.collision <> b2.collision Then Return False
		
		If b1.fg_image_number <> b2.fg_image_number Then Return False
		If b1.fg_delta_t <> b2.fg_delta_t Then Return False
		If b1.bg_image_number <> b2.bg_image_number Then Return False
		If b1.bg_delta_t <> b2.bg_delta_t Then Return False
		Return True
		
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
		DrawImage GAME.world.block_image_manager.images[Self.fg_image_number], x, y, Self.fg_act_frame
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
		DrawImage GAME.world.block_image_manager.images[Self.bg_image_number], x, y, Self.bg_act_frame
		SetScale 1,1
	End Method
	
	'COLLISION
	Method collision_draw(x:Float, y:Float, scale:Float = 1.0)
		If Self.collision = 1 Then
			SetColor 255,255,255
			SetScale scale,scale
			DrawImage GAME.world.block_image_manager.collision_image, x, y
			SetScale 1,1
		End If
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
		
		EDITOR.object_list.addlast(Self)
	End Method
	
	Field id:Int
	
	'@@@ only in the editor:
	Field type_name:String = "Object"
	
	'@@@ -------------------
	
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
			
			EDITOR.remove_object(Self)'remove from editor list
			
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
			
			'Print "changed chunk !!!!!!!!!!!!!"
			
			GAME.world.act_level.add_object(Self)
		End If
	End Method
	
	Method draw_selected(typ:Int=0)
		
		Select typ
			Case 1
				SetColor 255,0,0
			Case 2
				SetColor 100,100,255
			Default
				SetColor 100,255,0
		End Select
		
		SetAlpha 0.2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x - 10, GAME.world.act_level.ansicht_act_y + Self.y - 10,20,20
		SetAlpha 1
		
	End Method
	
	Method render_mouse_over:Int(x1:Int = 0, x2:Int = 0, y1:Int = 0, y2:Int = 0)
		If x1 > x2 Then
			Local xx:Int=x1
			x1 = x2
			x2 = xx
		End If
		
		If y1 > y2 Then
			Local yy:Int=y1
			y1 = y2
			y2 = yy
		End If
		
		If x1 = 0 And x2 = 0 And y1 = 0 And y2 = 0 Then
		Else
		End If
		
		If EMEGUI.m_x > 800 Then Return 0
		If EMEGUI.m_y > 600 Then Return 0
		
		If EMEGUI.m_x < GAME.world.act_level.ansicht_act_x + Self.x - 10 Then Return 0
		If EMEGUI.m_y < GAME.world.act_level.ansicht_act_y + Self.y - 10 Then Return 0
		
		If EMEGUI.m_x > GAME.world.act_level.ansicht_act_x + Self.x + 10 Then Return 0
		If EMEGUI.m_y > GAME.world.act_level.ansicht_act_y + Self.y + 10 Then Return 0
		
		Return 1
	End Method
	
	Method draw_big_view()
		SetViewport(800,60,400,340)
		SetClsColor 40,0,40
		Cls
		
		SetColor 255,255,255
		DrawText "HELLO I AM AN OBJECT",900,100
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
	
	Method copy:TObject()
		Local o:TObject = New TObject
		
		o.x = Self.x
		o.y = Self.y
		o.layer = Self.layer
		o.important = Self.important
		
		Return o
	End Method
End Type

'########################################################################################
'###########################        #####################################################
'###########################  BOX   #####################################################
'###########################        #####################################################
'########################################################################################

Type TBox Extends TObject
	Global typs:TBox_Typ[,]
	
	Global renderers:TBox_Renderer[]
	
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
	
	Global radio_parent_layer:GUI_RADIO'layer
	
	Global radio_child_layer:GUI_RADIO_CHILD[5]
	
	
	Global radio_parent_rotation:GUI_RADIO'rotation
	
	Global radio_child_rotation:GUI_RADIO_CHILD[4]
	
	Field rotation:Int
	
	Function init_before_level()
		
		TBox.radio_parent_layer = GUI_RADIO.Create()
		
		For Local i:Int = 0 To 4
			TBox.radio_child_layer[i] = GUI_RADIO_CHILD.Create(810 + i*40, 120, String(i), TBox.radio_parent_layer)
		Next
		
		TBox.radio_parent_rotation = GUI_RADIO.Create()
		
		For Local i:Int = 0 To 3
			TBox.radio_child_rotation[i] = GUI_RADIO_CHILD.Create(810 + 230+i*40, 120, String(i), TBox.radio_parent_rotation)
		Next
		
		TBox.vdn_input = GUI_INPUT.Create(890,373,"",200)
		TBox.important_input = GUI_CHECK.Create(1180,373, 0)
		
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
	
	Field typ:Int
	Field renderer:TBox_Renderer
	Field renderer_number:Int
	
	Field vdn:String' variable dependence name
	Global vdn_input:GUI_INPUT
	
	Global important_input:GUI_CHECK
	
	Method New()
		Self.type_name = "Box"
		Self.layer = 3
		Self.important = 0
	End Method
	
	Method draw()
		SetColor 255,255,255
		
		SetRotation Self.rotation*90
		
		DrawImage TBox.typs[Self.typ,Self.rotation].image, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox.typs[Self.typ,Self.rotation].current_frame
		
		SetRotation 0
		
		If TBox_Renderer_Jumper(Self.renderer) Then
			Local a:Float = TBox_Renderer_Jumper(Self.renderer).angle
			
			SetRotation a
			
			DrawRect GAME.world.act_level.ansicht_act_x + Self.x + TBox.typs[Self.typ,Self.rotation].dx/2,GAME.world.act_level.ansicht_act_y + Self.y + TBox.typs[Self.typ,Self.rotation].dy/2,100,2
			
			SetRotation 0
		End If
	End Method
	
	Method render()
		Super.render()
		
		TBox.typs[Self.typ,Self.rotation].render_animation()
		
		Self.type_name = "Box:  " + TBox.typs[Self.typ,Self.rotation].name + " / " + Self.renderer.name
	End Method
	
	
	Method draw_selected(typ:Int=0)
		
		Select typ
			Case 1
				SetColor 255,0,0
			Case 2
				SetColor 100,100,255
			Case 3
				SetColor 0,255,0
			Default
				SetColor 100,255,0
		End Select
		
		SetAlpha 0.2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y,TBox.typs[Self.typ,Self.rotation].dx,TBox.typs[Self.typ,Self.rotation].dy
		SetAlpha 1
		
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox.typs[Self.typ,Self.rotation].dx, 2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, 2, TBox.typs[Self.typ,Self.rotation].dy
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y + TBox.typs[Self.typ,Self.rotation].dy, TBox.typs[Self.typ,Self.rotation].dx, 2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x + TBox.typs[Self.typ,Self.rotation].dx, GAME.world.act_level.ansicht_act_y + Self.y, 2, TBox.typs[Self.typ,Self.rotation].dy
		
	End Method
	
	
	Method render_mouse_over:Int(x1:Int = 0, x2:Int = 0, y1:Int = 0, y2:Int = 0)
		If x1 > x2 Then
			Local xx:Int=x1
			x1 = x2
			x2 = xx
		End If
		
		If y1 > y2 Then
			Local yy:Int=y1
			y1 = y2
			y2 = yy
		End If
		
		If x1 = 0 And x2 = 0 And y1 = 0 And y2 = 0 Then
			'normal part
			If EMEGUI.m_x > 800 Then Return 0
			If EMEGUI.m_y > 600 Then Return 0
			
			If EMEGUI.m_x < GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If EMEGUI.m_y < GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			
			If EMEGUI.m_x > GAME.world.act_level.ansicht_act_x + Self.x + TBox.typs[Self.typ,Self.rotation].dx Then Return 0
			If EMEGUI.m_y > GAME.world.act_level.ansicht_act_y + Self.y + TBox.typs[Self.typ,Self.rotation].dy Then Return 0
			'end normal part
		Else
			'additional part
			
			If x1 > GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If y1 > GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			
			If x2 < GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If y2 < GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			
			'select 3
			
			'end additional part
		End If
		
		
		Return 1
	End Method
	
	
	
	Method draw_big_view()
		SetViewport(800,60,400,340)
		SetClsColor 40,0,20
		Cls
		
		SetColor 255,255,255
		DrawText "BOX",980,65
		DrawRect 810,80, 380, 1
		
		SetColor 100,100,255'DRAW TYP AUSWAHL
		DrawRect 810,85,150,25
		
		SetColor 255,255,255
		
		If EMEGUI.m_x > 810 And EMEGUI.m_y > 85 And EMEGUI.m_x < (810 + 150) And EMEGUI.m_y < (85 + 25) Then
			
			Self.typ:+ EMEGUI.m_z_speed
			
			If Self.typ < 0 Then Self.typ = 0
			If Self.typ > TBox.typs.length/4 - 1 Then Self.typ = TBox.typs.length/4 - 1
			
			SetColor 0,0,0
		End If
		
		DrawText "Typ: " + Self.typ + " " + TBox.typs[Self.typ,Self.rotation].name,810 + 5,85 + 5
		
		SetColor 255,100,100'DRAW RENDERER AUSWAHL
		DrawRect 960,85,230,25
		
		SetColor 255,255,255
		
		If EMEGUI.m_x > 960 And EMEGUI.m_y > 85 And EMEGUI.m_x < (960 + 230) And EMEGUI.m_y < (85 + 25) Then
			
			Self.renderer_number:+ EMEGUI.m_z_speed
			
			If Self.renderer_number < 0 Then Self.renderer_number = 0
			If Self.renderer_number> TBox.renderers.length - 1 Then Self.renderer_number = TBox.renderers.length - 1
			
			If EMEGUI.m_z_speed <> 0 Then
				Self.renderer = TBox.renderers[Self.renderer_number].copy()
			End If
			
			SetColor 0,0,0
		End If
		
		DrawText "Renderer: " + Self.renderer_number + " " + Self.renderer.name,960 + 5,85 + 5
		
		
		Self.draw_big_view_l_r()'layer + rotation !
		
		
		SetColor 255,255,255'RENDERER:
		DrawRect 810,139, 380, 1
		
		'renderer y: 140 to 400
		
		Self.renderer.draw_editor_view()
		
	End Method
	
	Method draw_big_view_l_r()
		'layer:
		
		TBox.radio_parent_layer.actual_child = TBox.radio_child_layer[Self.layer]
		
		For Local i:Int = 0 To 4
			TBox.radio_child_layer[i].render()
		Next
		
		For Local i:Int = 0 To 4
			TBox.radio_child_layer[i].draw()
			SetColor 255,255,255
			DrawText i, 810 + 40*i + 15, 120
		Next
		
		If Self.layer <> Int(TBox.radio_parent_layer.actual_child.wert) Then
			Self.layer = Int(TBox.radio_parent_layer.actual_child.wert)
			Self.kill()
			
			GAME.world.act_level.add_object(Self)
		End If
		
		'rotation:
		
		SetColor 255,255,255
		DrawRect 810 + 200, 112,2,23
		
		TBox.radio_parent_rotation.actual_child = TBox.radio_child_rotation[Self.rotation]
		
		For Local i:Int = 0 To 3
			TBox.radio_child_rotation[i].render()
		Next
		
		Local r_txt:String[]=["^",">","v","<"]
		
		For Local i:Int = 0 To 3
			TBox.radio_child_rotation[i].draw()
			SetColor 255,255,255
			DrawText r_txt[i], 810 + 230+i*40+15, 120
		Next
		
		If Self.rotation <> Int(TBox.radio_parent_rotation.actual_child.wert) Then
			Self.rotation = Int(TBox.radio_parent_rotation.actual_child.wert)
			Self.kill()
			
			GAME.world.act_level.add_object(Self)
		End If
	End Method
	
	Method draw_big_view_vdn()
		TBox.vdn_input.content = Self.vdn
		
		TBox.vdn_input.render()
		TBox.vdn_input.draw()
		SetColor 255,255,255
		DrawRect 805,370,390,1
		DrawText "Variable: ",810,377
		
		Self.vdn = TBox.vdn_input.content
		
		TBox.important_input.wert = Self.important
		
		TBox.important_input.render()
		
		SetColor 255,255,255
		DrawText "Impotant:",1100,377
		
		TBox.important_input.draw()
		
		Self.important = TBox.important_input.wert
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
	
	Method copy:TBox()
		Local b:TBox = New TBox
		
		b.x = Self.x
		b.y = Self.y
		b.layer = Self.layer
		b.important = Self.important
		
		b.typ = Self.typ
		b.renderer_number = Self.renderer_number
		b.renderer = Self.renderer.copy()
		
		b.rotation = Self.rotation
		
		b.vdn = Self.vdn
		
		Return b
	End Method
	
	Function Create:TBox(x:Float, y:Float, typ:Int, layer:Int, renderer_number:Int)
		Local o:TBox = New TBox
		
		o.x = x
		o.y = y
		
		o.typ = typ
		
		o.renderer_number = renderer_number
		o.renderer = TBox.renderers[o.renderer_number].copy()
		
		o.layer = layer
		
		o.important = 0
		
		Return o
	End Function
End Type

'########################################################################################
'###########################              ###############################################
'########################### BOX Burnable ###############################################
'###########################              ###############################################
'########################################################################################

Type TBox_Burnable Extends TBox
	Global burnable_typs:TBox_Typ[,]
	
	Global burnable_renderer:TBox_Renderer
	
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
	
	Rem
	Field typ:Int
	Field renderer:TBox_Renderer
	Field renderer_number:Int
	End Rem
	
	Method New()
		Self.type_name = "burnable_Box"
		Self.layer = 3
		Self.important = 0
	End Method
	
	Method draw()
		SetColor 255,255,255
		SetRotation Self.rotation*90
		DrawImage TBox_Burnable.burnable_typs[Self.typ,Self.rotation].image, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Burnable.burnable_typs[Self.typ,Self.rotation].current_frame
		SetRotation 0
	End Method
	
	Method render()
		Super.render()
		
		TBox_Burnable.burnable_typs[Self.typ,Self.rotation].render_animation()
		
		Self.type_name = "burnable_Box:  " + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].name + " / " + Self.renderer.name
	End Method
	
	Method draw_selected(typ:Int=0)
		
		Select typ
			Case 1
				SetColor 255,0,0
			Case 2
				SetColor 100,100,255
			Case 3
				SetColor 0,255,0
			Default
				SetColor 100,255,0
		End Select
		
		SetAlpha 0.2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y,TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dx,TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dy
		SetAlpha 1
		
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dx, 2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, 2, TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dy
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dy, TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dx, 2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dx, GAME.world.act_level.ansicht_act_y + Self.y, 2, TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dy
		
	End Method
	
	
	Method render_mouse_over:Int(x1:Int = 0, x2:Int = 0, y1:Int = 0, y2:Int = 0)
		If x1 > x2 Then
			Local xx:Int=x1
			x1 = x2
			x2 = xx
		End If
		
		If y1 > y2 Then
			Local yy:Int=y1
			y1 = y2
			y2 = yy
		End If
		
		If x1 = 0 And x2 = 0 And y1 = 0 And y2 = 0 Then
			'normal part
			If EMEGUI.m_x > 800 Then Return 0
			If EMEGUI.m_y > 600 Then Return 0
			
			If EMEGUI.m_x < GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If EMEGUI.m_y < GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			
			If EMEGUI.m_x > GAME.world.act_level.ansicht_act_x + Self.x + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dx Then Return 0
			If EMEGUI.m_y > GAME.world.act_level.ansicht_act_y + Self.y + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].dy Then Return 0
			'end normal part
		Else
			'additional part
			
			If x1 > GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If y1 > GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			
			If x2 < GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If y2 < GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			'select 3
			
			'end additional part
		End If
		
		
		Return 1
	End Method
	
	
	
	Method draw_big_view()
		SetViewport(800,60,400,340)
		SetClsColor 40,0,20
		Cls
		
		SetColor 255,255,255
		DrawText "burnable_BOX",980,65
		DrawRect 810,80, 380, 1
		
		SetColor 100,100,255'DRAW TYP AUSWAHL
		DrawRect 810,85,150,25
		
		SetColor 255,255,255
		
		If EMEGUI.m_x > 810 And EMEGUI.m_y > 85 And EMEGUI.m_x < (810 + 150) And EMEGUI.m_y < (85 + 25) Then
			
			Self.typ:+ EMEGUI.m_z_speed
			
			If Self.typ < 0 Then Self.typ = 0
			If Self.typ > TBox_Burnable.burnable_typs.length/4 - 1 Then Self.typ = TBox_Burnable.burnable_typs.length/4 - 1
			
			SetColor 0,0,0
		End If
		
		DrawText "Typ: " + Self.typ + " " + TBox_Burnable.burnable_typs[Self.typ,Self.rotation].name,810 + 5,85 + 5
				
		Self.draw_big_view_l_r()'layer + rotation !
		
		Self.draw_big_view_vdn()'variable dependency name
		
		SetColor 255,255,255'RENDERER:
		DrawRect 810,139, 380, 1
		
		'renderer y: 140 to 400
		
		Self.renderer.draw_editor_view()
		
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
	
	Method copy:TBox()
		Local b:TBox_Burnable = New TBox_Burnable
		
		b.x = Self.x
		b.y = Self.y
		b.layer = Self.layer
		b.important = Self.important
		
		b.typ = Self.typ
		b.renderer_number = Self.renderer_number
		b.renderer = Self.renderer.copy()
		
		b.rotation = Self.rotation
		
		b.vdn = Self.vdn
		
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
	Global stone_typs:TBox_Typ[,]
	
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
	
	Rem
	Field typ:Int
	Field renderer:TBox_Renderer
	Field renderer_number:Int
	End Rem
	
	Method New()
		Self.type_name = "stone_Box"
		Self.layer = 3
		Self.important = 0
	End Method
	
	Method draw()
		SetColor 255,255,255
		SetRotation Self.rotation*90
		DrawImage TBox_Stone.stone_typs[Self.typ,Self.rotation].image, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Stone.stone_typs[Self.typ,Self.rotation].current_frame
		SetRotation 0
	End Method
	
	Method render()
		Super.render()
		
		TBox_Stone.stone_typs[Self.typ,Self.rotation].render_animation()
		
		Self.type_name = "stone_Box:  " + TBox_Stone.stone_typs[Self.typ,Self.rotation].name + " / " + Self.renderer.name
	End Method
	
	Method draw_selected(typ:Int=0)
		
		Select typ
			Case 1
				SetColor 255,0,0
			Case 2
				SetColor 100,100,255
			Case 3
				SetColor 0,255,0
			Default
				SetColor 100,255,0
		End Select
		
		SetAlpha 0.2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y,TBox_Stone.stone_typs[Self.typ,Self.rotation].dx,TBox_Stone.stone_typs[Self.typ,Self.rotation].dy
		SetAlpha 1
		
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Stone.stone_typs[Self.typ,Self.rotation].dx, 2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, 2, TBox_Stone.stone_typs[Self.typ,Self.rotation].dy
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y + TBox_Stone.stone_typs[Self.typ,Self.rotation].dy, TBox_Stone.stone_typs[Self.typ,Self.rotation].dx, 2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x + TBox_Stone.stone_typs[Self.typ,Self.rotation].dx, GAME.world.act_level.ansicht_act_y + Self.y, 2, TBox_Stone.stone_typs[Self.typ,Self.rotation].dy
		
	End Method
	
	
	Method render_mouse_over:Int(x1:Int = 0, x2:Int = 0, y1:Int = 0, y2:Int = 0)
		If x1 > x2 Then
			Local xx:Int=x1
			x1 = x2
			x2 = xx
		End If
		
		If y1 > y2 Then
			Local yy:Int=y1
			y1 = y2
			y2 = yy
		End If
		
		If x1 = 0 And x2 = 0 And y1 = 0 And y2 = 0 Then
			'normal part
			If EMEGUI.m_x > 800 Then Return 0
			If EMEGUI.m_y > 600 Then Return 0
			
			If EMEGUI.m_x < GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If EMEGUI.m_y < GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			
			If EMEGUI.m_x > GAME.world.act_level.ansicht_act_x + Self.x + TBox_Stone.stone_typs[Self.typ,Self.rotation].dx Then Return 0
			If EMEGUI.m_y > GAME.world.act_level.ansicht_act_y + Self.y + TBox_Stone.stone_typs[Self.typ,Self.rotation].dy Then Return 0
			'end normal part
		Else
			'additional part
			
			If x1 > GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If y1 > GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			
			If x2 < GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If y2 < GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			'select 3
			
			'end additional part
		End If
		
		
		Return 1
	End Method
	
	Method draw_big_view()
		SetViewport(800,60,400,340)
		SetClsColor 40,0,20
		Cls
		
		SetColor 255,255,255
		DrawText "Stone_BOX",980,65
		DrawRect 810,80, 380, 1
		
		SetColor 100,100,255'DRAW TYP AUSWAHL
		DrawRect 810,85,150,25
		
		SetColor 255,255,255
		
		If EMEGUI.m_x > 810 And EMEGUI.m_y > 85 And EMEGUI.m_x < (810 + 150) And EMEGUI.m_y < (85 + 25) Then
			
			Self.typ:+ EMEGUI.m_z_speed
			
			If Self.typ < 0 Then Self.typ = 0
			If Self.typ > TBox_Stone.stone_typs.length/4 - 1 Then Self.typ = TBox_Stone.stone_typs.length/4 - 1
			SetColor 0,0,0
		End If
		
		DrawText "Typ: " + Self.typ + " " + TBox_Stone.stone_typs[Self.typ,Self.rotation].name,810 + 5,85 + 5
		
		Self.draw_big_view_l_r()'layer + rotation !
		
		SetColor 255,255,255'RENDERER:
		DrawRect 810,139, 380, 1
		
		'renderer y: 140 to 400
		
		Self.renderer.draw_editor_view()
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
	
	Method copy:TBox()
		Local b:TBox_Stone = New TBox_Stone
		
		b.x = Self.x
		b.y = Self.y
		b.layer = Self.layer
		b.important = Self.important
		
		b.typ = Self.typ
		b.renderer_number = Self.renderer_number
		b.renderer = Self.renderer.copy()
		
		b.rotation = Self.rotation
		
		b.vdn = Self.vdn
		
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
	
	
	Method New()
		Self.type_name = "key_Box"
		Self.layer = 1
		Self.important = 1
	End Method
	
	Method draw()
		SetColor 255,255,255
		
		SetRotation Self.rotation*90
		
		For Local d:TBox_Door = EachIn GAME.world.act_level.door_list
			If TBox_Renderer_Door(d.renderer).door_name = TBox_Renderer_Key(Self.renderer).door_name Then
				
				Select TBox_Renderer_Door(d.renderer).status
					Case 0,3'opened (ing)
						DrawImage TBox_Key.key_typs[Self.typ,Self.rotation].image_opened, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Key.key_typs[Self.typ,Self.rotation].current_frame
					Case 1,2'closed (ing)
						DrawImage TBox_Key.key_typs[Self.typ,Self.rotation].image_closed, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Key.key_typs[Self.typ,Self.rotation].current_frame
				End Select
				SetRotation 0
				Return
			End If
		Next
		
		DrawImage TBox_Key.key_typs[Self.typ,Self.rotation].image_closed, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Key.key_typs[Self.typ,Self.rotation].current_frame
		
		SetRotation 0
	End Method
	
	Method render()
		Super.render()
		
		Self.type_name = "key_Box:  " + TBox_Key.key_typs[Self.typ,Self.rotation].name + " / " + Self.renderer.name
	End Method
	
	Method draw_selected(typ:Int=0)
		
		Select typ
			Case 1
				SetColor 255,0,0
			Case 2
				SetColor 100,100,255
			Case 3
				SetColor 0,255,0
			Default
				SetColor 100,255,0
		End Select
		
		SetAlpha 0.2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y,TBox_Key.key_typs[Self.typ,Self.rotation].dx,TBox_Key.key_typs[Self.typ,Self.rotation].dy
		SetAlpha 1
		
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Key.key_typs[Self.typ,Self.rotation].dx, 2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, 2, TBox_Key.key_typs[Self.typ,Self.rotation].dy
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y + TBox_Key.key_typs[Self.typ,Self.rotation].dy, TBox_Key.key_typs[Self.typ,Self.rotation].dx, 2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x + TBox_Key.key_typs[Self.typ,Self.rotation].dx, GAME.world.act_level.ansicht_act_y + Self.y, 2, TBox_Key.key_typs[Self.typ,Self.rotation].dy
		
	End Method
	
	
	Method render_mouse_over:Int(x1:Int = 0, x2:Int = 0, y1:Int = 0, y2:Int = 0)
		If x1 > x2 Then
			Local xx:Int=x1
			x1 = x2
			x2 = xx
		End If
		
		If y1 > y2 Then
			Local yy:Int=y1
			y1 = y2
			y2 = yy
		End If
		
		If x1 = 0 And x2 = 0 And y1 = 0 And y2 = 0 Then
			'normal part
			If EMEGUI.m_x > 800 Then Return 0
		If EMEGUI.m_y > 600 Then Return 0
			
			If EMEGUI.m_x < GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If EMEGUI.m_y < GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			
			If EMEGUI.m_x > GAME.world.act_level.ansicht_act_x + Self.x + TBox_Key.key_typs[Self.typ,Self.rotation].dx Then Return 0
			If EMEGUI.m_y > GAME.world.act_level.ansicht_act_y + Self.y + TBox_Key.key_typs[Self.typ,Self.rotation].dy Then Return 0
			'end normal part
		Else
			'additional part
			
			If x1 > GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If y1 > GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			
			If x2 < GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If y2 < GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			'select 3
			
			'end additional part
		End If
		
		
		Return 1
	End Method
	
	Method draw_big_view()
		SetViewport(800,60,400,340)
		SetClsColor 40,0,20
		Cls
		
		SetColor 255,255,255
		DrawText "key_BOX",980,65
		DrawRect 810,80, 380, 1
		
		SetColor 100,100,255'DRAW TYP AUSWAHL
		DrawRect 810,85,150,25
		
		SetColor 255,255,255
		
		If EMEGUI.m_x > 810 And EMEGUI.m_y > 85 And EMEGUI.m_x < (810 + 150) And EMEGUI.m_y < (85 + 25) Then
			
			Self.typ:+ EMEGUI.m_z_speed
			
			If Self.typ < 0 Then Self.typ = 0
			If Self.typ > TBox_Key.key_typs.length/4 - 1 Then Self.typ = TBox_Key.key_typs.length/4 - 1
			
			SetColor 0,0,0
		End If
		
		DrawText "Typ: " + Self.typ + " " + TBox_Key.key_typs[Self.typ,Self.rotation].name,810 + 5,85 + 5
				
		Self.draw_big_view_l_r()'layer + rotation !
		
		SetColor 255,255,255'RENDERER:
		DrawRect 810,139, 380, 1
		
		'renderer y: 140 to 400
		
		Self.renderer.draw_editor_view()
		
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
	
	Method copy:TBox()
		Local b:TBox_Key = New TBox_Key
		
		b.x = Self.x
		b.y = Self.y
		b.layer = Self.layer
		b.important = Self.important
		
		b.typ = Self.typ
		b.renderer_number = Self.renderer_number
		b.renderer = Self.renderer.copy()
		
		b.rotation = Self.rotation
		
		b.vdn = Self.vdn
		
		Return b
	End Method
	
	Function Create:TBox(x:Float, y:Float, typ:Int, layer:Int, renderer_number:Int)
		Local o:TBox_Key = New TBox_Key
		
		o.x = x
		o.y = y
		
		o.typ = typ
		
		o.renderer_number = renderer_number
		o.renderer = TBox_Key.key_renderer.copy()
		
		o.layer = layer
		
		o.important = 1
		
		Return o
	End Function
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
	
	
	Method New()
		Self.type_name = "door_Box"
		Self.layer = 3
		Self.important = 1
	End Method
	
	
	Method kill()'delete from memory
		Super.kill()
		
		GAME.world.act_level.door_list.addlast(Self)
	End Method
	
	
	Method draw()
		SetColor 255,255,255
		SetRotation Self.rotation*90
		
		Select TBox_Renderer_Door(Self.renderer).status
			Case 0'opened
				DrawImage TBox_Door.door_typs[Self.typ,Self.rotation].image_opened, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Door.door_typs[Self.typ,Self.rotation].current_frame
			Case 1'closed
				DrawImage TBox_Door.door_typs[Self.typ,Self.rotation].image_closed, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Door.door_typs[Self.typ,Self.rotation].current_frame
			Case 2'closing
				DrawImage TBox_Door.door_typs[Self.typ,Self.rotation].image_closing, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Door.door_typs[Self.typ,Self.rotation].current_frame
			Case 3'opening
				DrawImage TBox_Door.door_typs[Self.typ,Self.rotation].image_opening, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Door.door_typs[Self.typ,Self.rotation].current_frame
		End Select
		SetRotation 0
	End Method
	
	Method render()
		Super.render()
		
		Self.type_name = "door_Box:  " + TBox_Door.door_typs[Self.typ,Self.rotation].name + " / " + Self.renderer.name
	End Method
	
	Method draw_selected(typ:Int=0)
		
		Select typ
			Case 1
				SetColor 255,0,0
			Case 2
				SetColor 100,100,255
			Case 3
				SetColor 0,255,0
			Default
				SetColor 100,255,0
		End Select
		
		SetAlpha 0.2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y,TBox_Door.door_typs[Self.typ,Self.rotation].dx,TBox_Door.door_typs[Self.typ,Self.rotation].dy
		SetAlpha 1
		
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, TBox_Door.door_typs[Self.typ,Self.rotation].dx, 2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y, 2, TBox_Door.door_typs[Self.typ,Self.rotation].dy
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y + TBox_Door.door_typs[Self.typ,Self.rotation].dy, TBox_Door.door_typs[Self.typ,Self.rotation].dx, 2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x + TBox_Door.door_typs[Self.typ,Self.rotation].dx, GAME.world.act_level.ansicht_act_y + Self.y, 2, TBox_Door.door_typs[Self.typ,Self.rotation].dy
		
	End Method
	
	
	Method render_mouse_over:Int(x1:Int = 0, x2:Int = 0, y1:Int = 0, y2:Int = 0)
		If x1 > x2 Then
			Local xx:Int=x1
			x1 = x2
			x2 = xx
		End If
		
		If y1 > y2 Then
			Local yy:Int=y1
			y1 = y2
			y2 = yy
		End If
		
		If x1 = 0 And x2 = 0 And y1 = 0 And y2 = 0 Then
			'normal part
			
			If EMEGUI.m_x > 800 Then Return 0
			If EMEGUI.m_y > 600 Then Return 0
			
			If EMEGUI.m_x < GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If EMEGUI.m_y < GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			
			If EMEGUI.m_x > GAME.world.act_level.ansicht_act_x + Self.x + TBox_Door.door_typs[Self.typ,Self.rotation].dx Then Return 0
			If EMEGUI.m_y > GAME.world.act_level.ansicht_act_y + Self.y + TBox_Door.door_typs[Self.typ,Self.rotation].dy Then Return 0
			'end normal part
		Else
			'additional part
			
			If x1 > GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If y1 > GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			
			If x2 < GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If y2 < GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			'select 3
			
			'end additional part
		End If
		
		
		Return 1
	End Method
	
	Method draw_big_view()
		SetViewport(800,60,400,340)
		SetClsColor 40,0,20
		Cls
		
		SetColor 255,255,255
		DrawText "Door_BOX",980,65
		DrawRect 810,80, 380, 1
		
		SetColor 100,100,255'DRAW TYP AUSWAHL
		DrawRect 810,85,150,25
		
		SetColor 255,255,255
		
		If EMEGUI.m_x > 810 And EMEGUI.m_y > 85 And EMEGUI.m_x < (810 + 150) And EMEGUI.m_y < (85 + 25) Then
			
			Self.typ:+ EMEGUI.m_z_speed
			
			If Self.typ < 0 Then Self.typ = 0
			If Self.typ > TBox_Door.door_typs.length/4 - 1 Then Self.typ = TBox_Door.door_typs.length/4 - 1
			
			SetColor 0,0,0
		End If
		
		DrawText "Typ: " + Self.typ + " " + TBox_Door.door_typs[Self.typ,Self.rotation].name,810 + 5,85 + 5
				
		Self.draw_big_view_l_r()'layer + rotation !
		
		SetColor 255,255,255'RENDERER:
		DrawRect 810,139, 380, 1
		
		'renderer y: 140 to 400
		
		Self.renderer.draw_editor_view()
		
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
		
		stream.WriteInt(1)'Self.important)
		
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
		
		Local l:Int = stream.ReadInt()
		TBox_Renderer_Door(o.renderer).door_name = stream.ReadString(l)
		
		Local l2:Int = stream.ReadInt()
		TBox_Renderer_Door(o.renderer).teleport_name = stream.ReadString(l2)
		
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
		
		b.rotation = Self.rotation
		
		b.vdn = Self.vdn
		
		Return b
	End Method
	
	Function Create:TBox(x:Float, y:Float, typ:Int, layer:Int, renderer_number:Int)
		Local o:TBox_Door = New TBox_Door
		
		o.x = x
		o.y = y
		
		o.typ = typ
		
		o.renderer_number = renderer_number
		o.renderer = TBox_Door.door_renderer.copy()
		
		o.layer = layer
		
		o.important = 1
		
		GAME.world.act_level.door_list.addlast(o)
		
		Return o
	End Function
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
		
		bt.image = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\boxes\" + name + "\image.png", (bt.image_x1 + bt.dx + bt.image_x2), (bt.image_y1 + bt.dy + bt.image_y2))
		
		
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
	
	
	Field image_burnable:TImage
	
	
	
	Field speed_burning:Int
	
	
	
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
		bt.image = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\image.png", (bt.image_x1 + bt.dx + bt.image_x2), (bt.image_y1 + bt.dy + bt.image_y2))
		
		SetImageHandle(bt.image, bt.image_x1, bt.image_y1)
		
		
		'load burn image
		bt.image_burnable = ImageLoader.Load("Worlds\" + GAME.world.name + "\Objects\burnable_box\" + name + "\burning.png", (bt.image_x1 + bt.dx + bt.image_x2), (bt.image_y1 + bt.dy + bt.image_y2))
		
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
		
	End Method
	
End Type



'########################################################################################
'###########################              ###############################################
'########################### Box Renderer ###############################################
'###########################              ###############################################
'########################################################################################

Type TBox_Renderer
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
	
	Method draw_editor_view()
		'renderer : 140 - 400
		
		SetColor 0,255,0
		DrawText Self.name, 850, 150
		
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
	
	Global as_light_check:GUI_CHECK
	
	Function init()
		'900,200,200,140
		TBox_Renderer_Image.as_light_check = GUI_CHECK.Create(820,200,0)
	End Function
	
	Field as_light:Int = 0
	
	Method copy:TBox_Renderer_Image()
		Local r:TBox_Renderer_Image = New TBox_Renderer_Image
		
		r.name = Self.name
		
		r.as_light = Self.as_light
		
		Return r
	End Method
	
	Method draw_editor_view()
		'renderer : 140 - 400
		
		TBox_Renderer_Image.as_light_check.wert = Self.as_light
		
		TBox_Renderer_Image.as_light_check.render()
		
		SetColor 255,255,255
		DrawText "LIGHT",840,203
		
		TBox_Renderer_Image.as_light_check.draw()
		
		Self.as_light = TBox_Renderer_Image.as_light_check.wert
		
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
		r.name = "checkpoint"
		Return r
	End Function
	
	
	Function init()
		'900,200,200,140
		'TBox_Renderer_Image.as_light_check = GUI_CHECK.Create(820,200,0)
	End Function
	
	Method copy:TBox_Renderer_CheckPoint()
		Local r:TBox_Renderer_CheckPoint = New TBox_Renderer_CheckPoint
		
		r.name = Self.name
		
		Return r
	End Method
	
	Method draw_editor_view()
		'renderer : 140 - 400
		
		
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
	
	
	Function init()
		'900,200,200,140
		'TBox_Renderer_Image.as_light_check = GUI_CHECK.Create(820,200,0)
	End Function
	
	Method copy:TBox_Renderer_LevelCompleted()
		Local r:TBox_Renderer_LevelCompleted = New TBox_Renderer_LevelCompleted
		
		r.name = Self.name
		
		Return r
	End Method
	
	Method draw_editor_view()
		'renderer : 140 - 400
		
		
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
	
	
	Function init()
		'900,200,200,140
		'TBox_Renderer_Image.as_light_check = GUI_CHECK.Create(820,200,0)
	End Function
	
	Method copy:TBox_Renderer_FireSurprise()
		Local r:TBox_Renderer_FireSurprise = New TBox_Renderer_FireSurprise
		
		r.name = Self.name
		
		Return r
	End Method
	
	Method draw_editor_view()
		'renderer : 140 - 400
		
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
	
	
	Function init()
		'900,200,200,140
		'TBox_Renderer_Image.as_light_check = GUI_CHECK.Create(820,200,0)
	End Function
	
	Method copy:TBox_Renderer_ParticleFire()
		Local r:TBox_Renderer_ParticleFire = New TBox_Renderer_ParticleFire
		
		r.name = Self.name
		
		Return r
	End Method
	
	Method draw_editor_view()
		'renderer : 140 - 400
		
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
	
	
	Global coll_down_check:GUI_CHECK
	Global coll_up_check:GUI_CHECK
	Global coll_r_check:GUI_CHECK
	Global coll_l_check:GUI_CHECK
	
	Function init()
		'900,200,200,140
		TBox_Renderer_Collision.coll_down_check = GUI_CHECK.Create(835,150,0)
		TBox_Renderer_Collision.coll_up_check = GUI_CHECK.Create(835,200,0)
		TBox_Renderer_Collision.coll_r_check = GUI_CHECK.Create(810,175,0)
		TBox_Renderer_Collision.coll_l_check = GUI_CHECK.Create(860,175,0)
	End Function
	
	Field coll_down_on:Int = 1
	Field coll_up_on:Int = 1
	Field coll_r_on:Int = 1
	Field coll_l_on:Int = 1
	
	Method copy:TBox_Renderer_Collision()
		Local r:TBox_Renderer_Collision = New TBox_Renderer_Collision
		
		r.name = Self.name
		
		r.coll_down_on = Self.coll_down_on
		r.coll_up_on = Self.coll_up_on
		r.coll_r_on = Self.coll_r_on
		r.coll_l_on = Self.coll_l_on
		
		Return r
	End Method
	
	Method draw_editor_view()
		'renderer : 140 - 400
		
		TBox_Renderer_Collision.coll_down_check.wert = Self.coll_down_on
		TBox_Renderer_Collision.coll_up_check.wert = Self.coll_up_on
		TBox_Renderer_Collision.coll_r_check.wert = Self.coll_r_on
		TBox_Renderer_Collision.coll_l_check.wert = Self.coll_l_on
		
		TBox_Renderer_Collision.coll_down_check.render()
		TBox_Renderer_Collision.coll_up_check.render()
		TBox_Renderer_Collision.coll_r_check.render()
		TBox_Renderer_Collision.coll_l_check.render()
		
		SetColor 255,255,255
		DrawRect 815,155,55,55
		
		SetColor 0,0,0
		DrawRect 815+2,155+2,55-4,55-4
		
		TBox_Renderer_Collision.coll_down_check.draw()
		TBox_Renderer_Collision.coll_up_check.draw()
		TBox_Renderer_Collision.coll_r_check.draw()
		TBox_Renderer_Collision.coll_l_check.draw()
		
		Self.coll_down_on = TBox_Renderer_Collision.coll_down_check.wert
		Self.coll_up_on = TBox_Renderer_Collision.coll_up_check.wert
		Self.coll_r_on = TBox_Renderer_Collision.coll_r_check.wert
		Self.coll_l_on = TBox_Renderer_Collision.coll_l_check.wert
		
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
	
	
	Global coll_down_check:GUI_CHECK
	Global coll_up_check:GUI_CHECK
	Global coll_r_check:GUI_CHECK
	Global coll_l_check:GUI_CHECK
	
	Global invert_check:GUI_CHECK
	
	Function init()
		'900,200,200,140
		TBox_Renderer_Collision_Mode_Sensitive.coll_down_check = GUI_CHECK.Create(990,190,0)
		TBox_Renderer_Collision_Mode_Sensitive.coll_up_check = GUI_CHECK.Create(990,330,0)
		TBox_Renderer_Collision_Mode_Sensitive.coll_r_check = GUI_CHECK.Create(890,260,0)
		TBox_Renderer_Collision_Mode_Sensitive.coll_l_check = GUI_CHECK.Create(1090,260,0)
		
		TBox_Renderer_Collision_Mode_Sensitive.invert_check = GUI_CHECK.Create(810,230,0)
	End Function
	
	Field coll_down_on:Int = 1
	Field coll_up_on:Int = 1
	Field coll_r_on:Int = 1
	Field coll_l_on:Int = 1
	
	Field mode_number:Int = 0
	Global modes:String[] = ["normal", "fire", "water", "steam","transparent","stone","plant","ice"]
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
	
	Method draw_editor_view()
		'renderer : 140 - 400
		
		TBox_Renderer_Collision_Mode_Sensitive.coll_down_check.wert = Self.coll_down_on
		TBox_Renderer_Collision_Mode_Sensitive.coll_up_check.wert = Self.coll_up_on
		TBox_Renderer_Collision_Mode_Sensitive.coll_r_check.wert = Self.coll_r_on
		TBox_Renderer_Collision_Mode_Sensitive.coll_l_check.wert = Self.coll_l_on
		
		TBox_Renderer_Collision_Mode_Sensitive.invert_check.wert = Self.invert
		
		
		TBox_Renderer_Collision_Mode_Sensitive.coll_down_check.render()
		TBox_Renderer_Collision_Mode_Sensitive.coll_up_check.render()
		TBox_Renderer_Collision_Mode_Sensitive.coll_r_check.render()
		TBox_Renderer_Collision_Mode_Sensitive.coll_l_check.render()
		
		TBox_Renderer_Collision_Mode_Sensitive.invert_check.render()
		
		SetColor 255,255,255
		DrawRect 900,200,200,140
		
		SetColor 0,0,0
		DrawRect 900+2,200+2,200-4,140-4
		
		TBox_Renderer_Collision_Mode_Sensitive.coll_down_check.draw()
		TBox_Renderer_Collision_Mode_Sensitive.coll_up_check.draw()
		TBox_Renderer_Collision_Mode_Sensitive.coll_r_check.draw()
		TBox_Renderer_Collision_Mode_Sensitive.coll_l_check.draw()
		
		TBox_Renderer_Collision_Mode_Sensitive.invert_check.draw()
		
		SetColor 255,255,255
		DrawText "Invert",805,250
		
		Self.coll_down_on = TBox_Renderer_Collision_Mode_Sensitive.coll_down_check.wert
		Self.coll_up_on = TBox_Renderer_Collision_Mode_Sensitive.coll_up_check.wert
		Self.coll_r_on = TBox_Renderer_Collision_Mode_Sensitive.coll_r_check.wert
		Self.coll_l_on = TBox_Renderer_Collision_Mode_Sensitive.coll_l_check.wert
		
		Self.invert = TBox_Renderer_Collision_Mode_Sensitive.invert_check.wert
		
		SetColor 100,255,100'DRAW MODES AUSWAHL
		DrawRect 810,150,200,25
		
		SetColor 255,255,255
		
		If EMEGUI.m_x > 810 And EMEGUI.m_y > 150 And EMEGUI.m_x < (810 + 200) And EMEGUI.m_y < (150 + 25) Then
			
			Self.mode_number:+ EMEGUI.m_z_speed
			
			If Self.mode_number < 0 Then Self.mode_number = 0
			If Self.mode_number > Self.modes.length - 1 Then Self.mode_number = Self.modes.length - 1
			
			SetColor 0,0,0
		End If
		
		DrawText "Mode: " + Self.mode_number + " " + Self.modes[Self.mode_number],810 + 5,150 + 5
		
		
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
	
	Field controller_typ:Int
	
	'terminal, button (goes on when on it, and off when go released), activation area
	
	Global controller_typ_array:String[] = ["Player_inside_activate SWITCH", "Player_inside_activate OPEN", "Player_inside_activate CLOSE", "inside OPEN", "inside CLOSE", "Player_inside OPEN else CLOSE", "Player_inside CLOSE else OPEN", "enters SWITCH", "enters OPEN", "enters CLOSE", "Player_enters SWITCH", "Player_enters OPEN", "Player_enters CLOSE"]
	
	'asdfasd
	
	Field door_name:String = "key_" + Rand(10000)'sign_text_map
	
	Global door_name_imput:GUI_INPUT
	
	Function init()
		'900,200,200,140
		
		TBox_Renderer_Key.door_name_imput = GUI_INPUT.Create(820,170,"",200)
	End Function
	
	Method copy:TBox_Renderer_Key()
		Local r:TBox_Renderer_Key = New TBox_Renderer_Key
		
		r.name = Self.name
		r.door_name = Self.door_name
		r.controller_typ = Self.controller_typ
		
		Return r
	End Method
	
	Method draw_editor_view()
		SetColor 255,255,255
		DrawText "Key Text Name:", 820, 150
		
		TBox_Renderer_Key.door_name_imput.content = Self.door_name
		
		TBox_Renderer_Key.door_name_imput.render()
		TBox_Renderer_Key.door_name_imput.draw()
		
		Self.door_name = TBox_Renderer_Key.door_name_imput.content
		
		Local exists:Int = 0
		
		For Local d:TBox_Door = EachIn GAME.world.act_level.door_list
			If TBox_Renderer_Door(d.renderer).door_name = Self.door_name Then
				exists = 1
				Exit
			End If
		Next
		
		If exists = 1 Then
			SetColor 100,255,100
			DrawRect 1030, 160, 100, 30
			SetColor 0,0,0
			DrawText "Exists!", 1035,165
		Else
			SetColor 255,100,100
			DrawRect 1030, 160, 100, 30
			SetColor 0,0,0
			DrawText "not found!", 1035,165
		End If
		
		
		
		SetColor 100,255,100'DRAW CT AUSWAHL
		DrawRect 820,200,300,25
		
		SetColor 255,255,255
		
		If EMEGUI.m_x > 820 And EMEGUI.m_y > 200 And EMEGUI.m_x < (820 + 300) And EMEGUI.m_y < (200 + 25) Then
			
			Self.controller_typ:+ EMEGUI.m_z_speed
			
			If Self.controller_typ < 0 Then Self.controller_typ = 0
			If Self.controller_typ > Self.controller_typ_array.length - 1 Then Self.controller_typ = Self.controller_typ_array.length - 1
			
			SetColor 0,0,0
		End If
		
		DrawText Self.controller_typ + " " + Self.controller_typ_array[Self.controller_typ],820 + 5,200 + 5
		
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
	
	Global status_check:GUI_CHECK
	
	Field door_name:String
	Global door_name_imput:GUI_INPUT
	
	Field teleport_name:String
	Global teleport_name_imput:GUI_INPUT
	
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
	
	
	
	Function init()
		TBox_Renderer_Door.status_check = GUI_CHECK.Create(890, 170, 0)
		
		TBox_Renderer_Door.door_name_imput = GUI_INPUT.Create(1000,180,"",200)
		
		TBox_Renderer_Door.teleport_name_imput = GUI_INPUT.Create(1000,250,"",200)
	End Function
	
	Method draw_editor_view()
		
		Super.draw_editor_view()'collisions
		
		SetColor 255,255,255
		DrawText "closed", 915, 172
		
		TBox_Renderer_Door.status_check.wert = Self.status
		
		TBox_Renderer_Door.status_check.render()
		TBox_Renderer_Door.status_check.draw()
		
		Self.status = TBox_Renderer_Door.status_check.wert
		
		
		
		SetColor 255,255,255
		DrawText "Door Name:", 1000, 160
		
		TBox_Renderer_Door.door_name_imput.content = Self.door_name
		
		TBox_Renderer_Door.door_name_imput.render()
		TBox_Renderer_Door.door_name_imput.draw()
		
		Self.door_name = TBox_Renderer_Door.door_name_imput.content
		
		
		
		SetColor 255,255,255
		DrawText "Teleport Name:", 1000, 230
		
		TBox_Renderer_Door.teleport_name_imput.content = Self.teleport_name
		
		TBox_Renderer_Door.teleport_name_imput.render()
		TBox_Renderer_Door.teleport_name_imput.draw()
		
		Self.teleport_name = TBox_Renderer_Door.teleport_name_imput.content
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
	
	Field mode_number:Int = 1
	
	Global modes:String[] = ["normal", "fire", "water", "steam","transparent","stone","plant","ice"]
	
	Method copy:TBox_Renderer_Set_Player_Mode()
		Local r:TBox_Renderer_Set_Player_Mode = New TBox_Renderer_Set_Player_Mode
		
		r.name = Self.name
		r.mode_number = Self.mode_number
		
		Return r
	End Method
	
	Method draw_editor_view()
		SetColor 100,255,100'DRAW MODES AUSWAHL
		DrawRect 810,150,200,25
		
		SetColor 255,255,255
		
		If EMEGUI.m_x > 810 And EMEGUI.m_y > 150 And EMEGUI.m_x < (810 + 200) And EMEGUI.m_y < (150 + 25) Then
			
			Self.mode_number:+ EMEGUI.m_z_speed
			
			If Self.mode_number < 0 Then Self.mode_number = 0
			If Self.mode_number > Self.modes.length - 1 Then Self.mode_number = Self.modes.length - 1
			
			SetColor 0,0,0
		End If
		
		DrawText "Mode: " + Self.mode_number + " " + Self.modes[Self.mode_number],810 + 5,150 + 5
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
	
	Global deaths:String[] = ["mechanical", "poison", "burnt", "freeze","suck the water"]
	
	Method copy:TBox_Renderer_Death_Zone()
		Local r:TBox_Renderer_Death_Zone = New TBox_Renderer_Death_Zone
		
		r.name = Self.name
		r.death_number = Self.death_number
		
		Return r
	End Method
	
	Method draw_editor_view()
		SetColor 100,255,100'DRAW MODES AUSWAHL
		DrawRect 810,150,200,25
		
		SetColor 255,255,255
		
		If EMEGUI.m_x > 810 And EMEGUI.m_y > 150 And EMEGUI.m_x < (810 + 200) And EMEGUI.m_y < (150 + 25) Then
			
			Self.death_number:+ EMEGUI.m_z_speed
			
			If Self.death_number < 0 Then Self.death_number = 0
			If Self.death_number > Self.deaths.length - 1 Then Self.death_number = Self.deaths.length - 1
			
			SetColor 0,0,0
		End If
		
		DrawText "Mode: " + Self.death_number + " " + Self.deaths[Self.death_number],810 + 5,150 + 5
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
	
	Global liquids:String[] = ["water", "lava"]
	
	Method copy:TBox_Renderer_Liquid()
		Local r:TBox_Renderer_Liquid = New TBox_Renderer_Liquid
		
		r.name = Self.name
		r.liquid_number = Self.liquid_number
		
		Return r
	End Method
	
	Method draw_editor_view()
		SetColor 100,255,100'DRAW MODES AUSWAHL
		DrawRect 810,150,200,25
		
		SetColor 255,255,255
		
		If EMEGUI.m_x > 810 And EMEGUI.m_y > 150 And EMEGUI.m_x < (810 + 200) And EMEGUI.m_y < (150 + 25) Then
			
			Self.liquid_number:+ EMEGUI.m_z_speed
			
			If Self.liquid_number < 0 Then Self.liquid_number = 0
			If Self.liquid_number > Self.liquids.length - 1 Then Self.liquid_number = Self.liquids.length - 1
			
			SetColor 0,0,0
		End If
		
		DrawText "Liquid: " + Self.liquid_number + " " + Self.liquids[Self.liquid_number],810 + 5,150 + 5
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
	
	Field teleporter_name:String
	Global teleporter_name_input:GUI_INPUT
	
	Field location_name:String
	Global location_name_input:GUI_INPUT
	
	Field typ:Int
	
	Global typs:String[] = ["lokal", "change scene", "transportation", "end_location", "lokal turn"]
	
	Rem
	0 = lokal, keep speed, kamera normal
	1 = black out, reset kamera, must activate
	2 = rohr, linear camera, delay
	3 = end location
	
	Case 4' "lokal turn" lokal, turn speed, kamera normal
	
	End Rem
	
	'typ
	Rem
	Field keep_speed:Int
	Global keep_speed_check:GUI_CHECK
	
	Field reset_ansicht:Int
	Global reset_ansicht_check:GUI_CHECK
	
	Field blend_out:Int
	Global blend_out_check:GUI_CHECK
	
	Field must_activate:Int
	Global must_activate_check:GUI_CHECK
	End Rem
	'end typ
	
	
	Field player_only:Int
	Global player_only_check:GUI_CHECK
	
	Function init()
		TBox_Renderer_Teleporter.teleporter_name_input = GUI_INPUT.Create(850,200,"",300)
		
		TBox_Renderer_Teleporter.location_name_input = GUI_INPUT.Create(850,250,"",300)
		
		TBox_Renderer_Teleporter.player_only_check = GUI_CHECK.Create(850, 340, 0)
	End Function
	
	Method copy:TBox_Renderer_Teleporter()
		Local r:TBox_Renderer_Teleporter = New TBox_Renderer_Teleporter
		
		r.name = Self.name
		r.teleporter_name = Self.teleporter_name
		r.location_name = Self.location_name
		r.player_only = Self.player_only
		r.typ = Self.typ
		
		Return r
	End Method
	
	Method draw_editor_view()
		TBox_Renderer_Teleporter.teleporter_name_input.content = Self.teleporter_name
		TBox_Renderer_Teleporter.location_name_input.content = Self.location_name
		
		TBox_Renderer_Teleporter.teleporter_name_input.render()
		SetColor 255,255,255
		DrawText "Teleporter Name:", 850, 180
		TBox_Renderer_Teleporter.teleporter_name_input.draw()
		
		TBox_Renderer_Teleporter.location_name_input.render()
		SetColor 255,255,255
		DrawText "Location Name / End Modus:", 850, 230
		TBox_Renderer_Teleporter.location_name_input.draw()
		
		Self.teleporter_name = TBox_Renderer_Teleporter.teleporter_name_input.content
		Self.location_name = TBox_Renderer_Teleporter.location_name_input.content
		
		
		SetColor 50,150,50'DRAW TYPs AUSWAHL
		DrawRect 850,300,200,25
		
		SetColor 255,255,255
		
		If EMEGUI.m_x > 850 And EMEGUI.m_y > 300 And EMEGUI.m_x < (850 + 200) And EMEGUI.m_y < (300 + 25) Then
			
			Self.typ:+ EMEGUI.m_z_speed
			
			If Self.typ < 0 Then Self.typ = 0
			If Self.typ > Self.typs.length - 1 Then Self.typ = Self.typs.length - 1
			
			SetColor 0,0,0
		End If
		
		DrawText "Typ: " + Self.typ + " " + Self.typs[Self.typ],850 + 5,300 + 5
		
		'---
		TBox_Renderer_Teleporter.player_only_check.wert = Self.player_only
		
		TBox_Renderer_Teleporter.player_only_check.render()
		SetColor 255,255,255
		DrawText "Player Only", 870, 345
		TBox_Renderer_Teleporter.player_only_check.draw()
		
		Self.player_only = TBox_Renderer_Teleporter.player_only_check.wert
		
		'---
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
	
	Field light_typ_number:Int
	Global light_typ_list:String[] = ["normal","small","big"]
	
	Rem
	load thems images! but only in the game...
	End Rem
	
	Field brightness_r:Int
	Field brightness_g:Int
	Field brightness_b:Int
	
	Global brightness_r_input:GUI_INPUT
	Global brightness_g_input:GUI_INPUT
	Global brightness_b_input:GUI_INPUT
	
	Function init()
		TBox_Renderer_TLamp.brightness_r_input = GUI_INPUT.Create(850,170,"",300)
		TBox_Renderer_TLamp.brightness_g_input = GUI_INPUT.Create(850,220,"",300)
		TBox_Renderer_TLamp.brightness_b_input = GUI_INPUT.Create(850,270,"",300)
	End Function
	
	
	Method copy:TBox_Renderer_TLamp()
		Local r:TBox_Renderer_TLamp = New TBox_Renderer_TLamp
		
		r.name = Self.name
		r.brightness_r = Self.brightness_r
		r.brightness_g = Self.brightness_g
		r.brightness_b = Self.brightness_b
		
		r.light_typ_number = Self.light_typ_number
		
		Return r
	End Method
	
	Method draw_editor_view()
		TBox_Renderer_TLamp.brightness_r_input.content = Self.brightness_r
		TBox_Renderer_TLamp.brightness_g_input.content = Self.brightness_g
		TBox_Renderer_TLamp.brightness_b_input.content = Self.brightness_b
		
		TBox_Renderer_TLamp.brightness_r_input.render()
		TBox_Renderer_TLamp.brightness_g_input.render()
		TBox_Renderer_TLamp.brightness_b_input.render()
		
		SetColor 255,255,255
		DrawText "Red:", 850, 150
		DrawText "Green:", 850, 200
		DrawText "Blue:", 850, 250
		
		TBox_Renderer_TLamp.brightness_r_input.draw()
		TBox_Renderer_TLamp.brightness_g_input.draw()
		TBox_Renderer_TLamp.brightness_b_input.draw()
		
		Self.brightness_r = Int(TBox_Renderer_TLamp.brightness_r_input.content)
		Self.brightness_g = Int(TBox_Renderer_TLamp.brightness_g_input.content)
		Self.brightness_b = Int(TBox_Renderer_TLamp.brightness_b_input.content)
		
		
		'§§§§§§§§§§§§§§§§§§§§§§§§
		SetColor 30,150,30'DRAW MODES AUSWAHL
		DrawRect 810,300,200,25
		
		SetColor 255,255,255
		
		If EMEGUI.m_x > 810 And EMEGUI.m_y > 300 And EMEGUI.m_x < (810 + 200) And EMEGUI.m_y < (300 + 25) Then
			
			Self.light_typ_number:+ EMEGUI.m_z_speed
			
			If Self.light_typ_number < 0 Then Self.light_typ_number = 0
			If Self.light_typ_number > Self.light_typ_list.length - 1 Then Self.light_typ_number = Self.light_typ_list.length - 1
			
			SetColor 0,0,0
		End If
		
		DrawText "Typ: " + Self.light_typ_number + " " + Self.light_typ_list[Self.light_typ_number],810 + 5,300 + 5
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
	
	Global name_input:GUI_INPUT
	
	Function init()
		TBox_Renderer_Music.name_input = GUI_INPUT.Create(850,250,"",300)
	End Function
	
	Method copy:TBox_Renderer_Music()
		Local r:TBox_Renderer_Music = New TBox_Renderer_Music
		
		r.name = Self.name
		r.music_name = Self.music_name
		
		Return r
	End Method
	
	Method draw_editor_view()
		TBox_Renderer_Music.name_input.content = Self.music_name
		
		TBox_Renderer_Music.name_input.render()
		SetColor 255,255,255
		DrawText "Music Name:", 850, 230
		TBox_Renderer_Music.name_input.draw()
		
		Self.music_name = TBox_Renderer_Music.name_input.content
	End Method
End Type

'########################################################################################
'###########################                              ###############################
'###########################   Box Renderer MusicChanger  ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_MusicChanger Extends TBox_Renderer
	Function Create:TBox_Renderer_MusicChanger()
		Local r:TBox_Renderer_MusicChanger = New TBox_Renderer_MusicChanger
		r.name = "MusicChanger"
		Return r
	End Function
	
	Field music_name:String
	
	Global name_input:GUI_INPUT
	
	Function init()
		TBox_Renderer_MusicChanger.name_input = GUI_INPUT.Create(850,250,"",300)
	End Function
	
	Method copy:TBox_Renderer_MusicChanger()
		Local r:TBox_Renderer_MusicChanger = New TBox_Renderer_MusicChanger
		
		r.name = Self.name
		r.music_name = Self.music_name
		
		Return r
	End Method
	
	Method draw_editor_view()
		TBox_Renderer_MusicChanger.name_input.content = Self.music_name
		
		TBox_Renderer_MusicChanger.name_input.render()
		SetColor 255,255,255
		DrawText "Music Name:", 850, 230
		TBox_Renderer_MusicChanger.name_input.draw()
		
		Self.music_name = TBox_Renderer_MusicChanger.name_input.content
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
	
	Global name_input:GUI_INPUT
	
	Function init()
		TBox_Renderer_Sound.name_input = GUI_INPUT.Create(850,250,"",300)
	End Function
	
	Method copy:TBox_Renderer_Sound()
		Local r:TBox_Renderer_Sound= New TBox_Renderer_Sound
		
		r.name = Self.name
		r.music_name = Self.music_name
		
		Return r
	End Method
	
	Method draw_editor_view()
		TBox_Renderer_Sound.name_input.content = Self.music_name
		
		TBox_Renderer_Sound.name_input.render()
		SetColor 255,255,255
		DrawText "Music Name:", 850, 230
		TBox_Renderer_Sound.name_input.draw()
		
		Self.music_name = TBox_Renderer_Sound.name_input.content
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
	
	Global name_input:GUI_INPUT
	Global delta_t_input:GUI_INPUT
	Global delta_rand_input:GUI_INPUT
	Global radius_input:GUI_INPUT
	
	Function init()
		TBox_Renderer_SoundRepeater.name_input = GUI_INPUT.Create(850,170,"",300)
		TBox_Renderer_SoundRepeater.delta_t_input = GUI_INPUT.Create(850,220,"",300)
		TBox_Renderer_SoundRepeater.delta_rand_input = GUI_INPUT.Create(850,270,"",300)
		TBox_Renderer_SoundRepeater.radius_input = GUI_INPUT.Create(850,330,"",300)
	End Function
	
	Method copy:TBox_Renderer_SoundRepeater()
		Local r:TBox_Renderer_SoundRepeater = New TBox_Renderer_SoundRepeater
		
		r.name = Self.name
		r.music_name = Self.music_name
		r.delta_t= Self.delta_t
		r.delta_rand = Self.delta_rand
		r.radius = Self.radius
		
		Return r
	End Method
	
	Method draw_editor_view()
		TBox_Renderer_SoundRepeater.name_input.content = Self.music_name
		TBox_Renderer_SoundRepeater.delta_t_input.content = Self.delta_t
		TBox_Renderer_SoundRepeater.delta_rand_input.content = Self.delta_rand
		TBox_Renderer_SoundRepeater.radius_input.content = Self.radius
		
		TBox_Renderer_SoundRepeater.name_input.render()
		TBox_Renderer_SoundRepeater.delta_t_input.render()
		TBox_Renderer_SoundRepeater.delta_rand_input.render()
		TBox_Renderer_SoundRepeater.radius_input.render()
		
		SetColor 255,255,255
		DrawText "Music Name:", 850, 150
		DrawText "delta_t:", 850, 200
		DrawText "delta_rand:", 850, 250
		DrawText "radius:", 850, 300
		
		TBox_Renderer_SoundRepeater.name_input.draw()
		TBox_Renderer_SoundRepeater.delta_t_input.draw()
		TBox_Renderer_SoundRepeater.delta_rand_input.draw()
		TBox_Renderer_SoundRepeater.radius_input.draw()
		
		Self.music_name = TBox_Renderer_SoundRepeater.name_input.content
		Self.delta_t = Int(TBox_Renderer_SoundRepeater.delta_t_input.content)
		Self.delta_rand = Int(TBox_Renderer_SoundRepeater.delta_rand_input.content)
		Self.radius = Int(TBox_Renderer_SoundRepeater.radius_input.content)
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
	
	Global brightness_r_input:GUI_INPUT
	Global brightness_g_input:GUI_INPUT
	Global brightness_b_input:GUI_INPUT
	Global init_run_check:GUI_CHECK
	
	
	Function init()
		TBox_Renderer_LightHandler.brightness_r_input = GUI_INPUT.Create(850,170,"",300)
		TBox_Renderer_LightHandler.brightness_g_input = GUI_INPUT.Create(850,220,"",300)
		TBox_Renderer_LightHandler.brightness_b_input = GUI_INPUT.Create(850,270,"",300)
		TBox_Renderer_LightHandler.init_run_check = GUI_CHECK.Create(820,320,0)
	End Function
	
	Method copy:TBox_Renderer_LightHandler()
		Local r:TBox_Renderer_LightHandler = New TBox_Renderer_LightHandler
		
		r.name = Self.name
		
		r.brightness_r = Self.brightness_r
		r.brightness_g = Self.brightness_g
		r.brightness_b = Self.brightness_b
		r.init_run = Self.init_run
		
		Return r
	End Method
	
	Method draw_editor_view()
		TBox_Renderer_LightHandler.brightness_r_input.content = Self.brightness_r
		TBox_Renderer_LightHandler.brightness_g_input.content = Self.brightness_g
		TBox_Renderer_LightHandler.brightness_b_input.content = Self.brightness_b
		TBox_Renderer_LightHandler.init_run_check.wert = Self.init_run
		
		If Self.brightness_r < 0 Then Self.brightness_r = 0
		If Self.brightness_r > 255 Then Self.brightness_r = 255
		
		If Self.brightness_g < 0 Then Self.brightness_g = 0
		If Self.brightness_g > 255 Then Self.brightness_g = 255
		
		If Self.brightness_b < 0 Then Self.brightness_b = 0
		If Self.brightness_b > 255 Then Self.brightness_b = 255
		
		TBox_Renderer_LightHandler.brightness_r_input.render()
		TBox_Renderer_LightHandler.brightness_g_input.render()
		TBox_Renderer_LightHandler.brightness_b_input.render()
		TBox_Renderer_LightHandler.init_run_check.render()
		
		
		SetColor 255,255,255
		DrawText "Red:", 850, 150
		DrawText "Green:", 850, 200
		DrawText "Blue:", 850, 250
		DrawText "Init Run:", 850, 323
		
		TBox_Renderer_LightHandler.brightness_r_input.draw()
		TBox_Renderer_LightHandler.brightness_g_input.draw()
		TBox_Renderer_LightHandler.brightness_b_input.draw()
		TBox_Renderer_LightHandler.init_run_check.draw()
		
		Self.brightness_r = Int(TBox_Renderer_LightHandler.brightness_r_input.content)
		Self.brightness_g = Int(TBox_Renderer_LightHandler.brightness_g_input.content)
		Self.brightness_b = Int(TBox_Renderer_LightHandler.brightness_b_input.content)
		Self.init_run = TBox_Renderer_LightHandler.init_run_check.wert
		
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
	
	Field dialogue_name:String
	Field dialogue_id:String
	
	Global dialogue_name_imput:GUI_INPUT
	Global dialogue_id_imput:GUI_INPUT
	
	Function init()
		'900,200,200,140
		
		TBox_Renderer_Dialogue.dialogue_name_imput = GUI_INPUT.Create(850,210,"",300)
		TBox_Renderer_Dialogue.dialogue_id_imput = GUI_INPUT.Create(850,310,"",300)
	End Function
	
	Method copy:TBox_Renderer_Dialogue()
		Local r:TBox_Renderer_Dialogue = New TBox_Renderer_Dialogue
		
		r.name = Self.name
		r.dialogue_name = Self.dialogue_name
		r.dialogue_id = Self.dialogue_id
		
		Return r
	End Method
	
	Method draw_editor_view()
		
		SetColor 255,255,255
		DrawText "Dialogue Name:", 850, 180
		
		TBox_Renderer_Dialogue.dialogue_name_imput.content = Self.dialogue_name
		
		TBox_Renderer_Dialogue.dialogue_name_imput.render()
		TBox_Renderer_Dialogue.dialogue_name_imput.draw()
		
		Self.dialogue_name = TBox_Renderer_Dialogue.dialogue_name_imput.content
		
		Rem
		If GAME.world.act_level.dialogue_map.contains(Self.dialogue_name) Then
			SetColor 100,255,100
			DrawRect 850, 280, 100, 30
			SetColor 0,0,0
			DrawText "Exists!", 855,285
		Else
			SetColor 255,100,100
			DrawRect 850, 280, 100, 30
			SetColor 0,0,0
			DrawText "not found!", 855,285
		End If
		End Rem
		
		SetColor 255,255,255
		DrawText "Dialogue ID:", 850, 280
		
		TBox_Renderer_Dialogue.dialogue_id_imput.content = Self.dialogue_id
		
		TBox_Renderer_Dialogue.dialogue_id_imput.render()
		TBox_Renderer_Dialogue.dialogue_id_imput.draw()
		
		Self.dialogue_id = TBox_Renderer_Dialogue.dialogue_id_imput.content
		
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
	
	Global dialogue_name_imput:GUI_INPUT
	Global dialogue_id_imput:GUI_INPUT
	
	Function init()
		'900,200,200,140
		
		TBox_Renderer_Dialogue_Changer.dialogue_name_imput = GUI_INPUT.Create(850,210,"",300)
		TBox_Renderer_Dialogue_Changer.dialogue_id_imput = GUI_INPUT.Create(850,310,"",300)
	End Function
	
	Method copy:TBox_Renderer_Dialogue_Changer()
		Local r:TBox_Renderer_Dialogue_Changer = New TBox_Renderer_Dialogue_Changer
		
		r.name = Self.name
		r.dialogue_name = Self.dialogue_name
		r.dialogue_id = Self.dialogue_id
		
		Return r
	End Method
	
	Method draw_editor_view()
		
		SetColor 255,255,255
		DrawText "Dialogue Name:", 850, 180
		
		TBox_Renderer_Dialogue_Changer.dialogue_name_imput.content = Self.dialogue_name
		
		TBox_Renderer_Dialogue_Changer.dialogue_name_imput.render()
		TBox_Renderer_Dialogue_Changer.dialogue_name_imput.draw()
		
		Self.dialogue_name = TBox_Renderer_Dialogue_Changer.dialogue_name_imput.content
		
		Rem
		If GAME.world.act_level.dialogue_map.contains(Self.dialogue_name) Then
			SetColor 100,255,100
			DrawRect 850, 280, 100, 30
			SetColor 0,0,0
			DrawText "Exists!", 855,285
		Else
			SetColor 255,100,100
			DrawRect 850, 280, 100, 30
			SetColor 0,0,0
			DrawText "not found!", 855,285
		End If
		End Rem
		
		SetColor 255,255,255
		DrawText "Dialogue ID:", 850, 280
		
		TBox_Renderer_Dialogue_Changer.dialogue_id_imput.content = Self.dialogue_id
		
		TBox_Renderer_Dialogue_Changer.dialogue_id_imput.render()
		TBox_Renderer_Dialogue_Changer.dialogue_id_imput.draw()
		
		Self.dialogue_id = TBox_Renderer_Dialogue_Changer.dialogue_id_imput.content
		
	End Method
End Type



'########################################################################################
'###########################                              ###############################
'###########################        Box Renderer Sign     ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_Sign Extends TBox_Renderer
	Function Create:TBox_Renderer_Sign()
		Local r:TBox_Renderer_Sign = New TBox_Renderer_Sign
		r.name = "Sign"
		Return r
	End Function
	
	Field sign_text_name:String = "blub" + Rand(1000)'sign_text_map
	
	Global sign_text_name_imput:GUI_INPUT
	
	Function init()
		'900,200,200,140
		
		TBox_Renderer_Sign.sign_text_name_imput = GUI_INPUT.Create(850,250,"",300)
	End Function
	
	Method copy:TBox_Renderer_Sign()
		Local r:TBox_Renderer_Sign = New TBox_Renderer_Sign
		
		r.name = Self.name
		r.sign_text_name = Self.sign_text_name
		
		Return r
	End Method
	
	Method draw_editor_view()
		SetColor 255,255,255
		DrawText "Sign Text Name:", 850, 220
		
		TBox_Renderer_Sign.sign_text_name_imput.content = Self.sign_text_name
		
		TBox_Renderer_Sign.sign_text_name_imput.render()
		TBox_Renderer_Sign.sign_text_name_imput.draw()
		
		Self.sign_text_name = TBox_Renderer_Sign.sign_text_name_imput.content
		
		If GAME.world.act_level.sign_text_map.contains(Self.sign_text_name) Then
			SetColor 100,255,100
			DrawRect 850, 300, 100, 30
			SetColor 0,0,0
			DrawText "Exists!", 855,305
		Else
			SetColor 255,100,100
			DrawRect 850, 300, 100, 30
			SetColor 0,0,0
			DrawText "not found!", 855,305
		End If
	End Method
End Type

'########################################################################################
'###########################                              ###############################
'###########################   Box Renderer MusicChanger  ###############################
'###########################                              ###############################
'########################################################################################

Type TBox_Renderer_Jumper Extends TBox_Renderer
	Function Create:TBox_Renderer_Jumper()
		Local r:TBox_Renderer_Jumper = New TBox_Renderer_Jumper
		r.name = "Jumper"
		r.power = 1
		Return r
	End Function
	
	Field angle:Float
	
	Global angle_input:GUI_INPUT
	
	Field power:Float=1
	
	Global power_input:GUI_INPUT
	
	Function init()
		TBox_Renderer_Jumper.angle_input = GUI_INPUT.Create(850,250,"",300)
		TBox_Renderer_Jumper.power_input = GUI_INPUT.Create(850,300,"",300)
	End Function
	
	Method copy:TBox_Renderer_Jumper()
		Local r:TBox_Renderer_Jumper = New TBox_Renderer_Jumper
		
		r.name = Self.name
		r.angle = Self.angle
		r.power = Self.power
		
		Return r
	End Method
	
	Method draw_editor_view()
		TBox_Renderer_Jumper.angle_input.content = Self.angle
		
		TBox_Renderer_Jumper.angle_input.render()
		SetColor 255,255,255
		DrawText "Angle:", 850, 230
		TBox_Renderer_Jumper.angle_input.draw()
		
		Self.angle = Float(TBox_Renderer_Jumper.angle_input.content)
		
		'------
		
		TBox_Renderer_Jumper.power_input.content = Self.power
		
		TBox_Renderer_Jumper.power_input.render()
		SetColor 255,255,255
		DrawText "power:", 850, 280
		TBox_Renderer_Jumper.power_input.draw()
		
		Self.power = Float(TBox_Renderer_Jumper.power_input.content)
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
	Global script_name_imput:GUI_INPUT
	
	Field run_init:Int
	Global run_init_check:GUI_CHECK
	
	Function init()
		'900,200,200,140
		
		TBox_Renderer_Sequence.script_name_imput = GUI_INPUT.Create(850,250,"",300)
		TBox_Renderer_Sequence.run_init_check = GUI_CHECK.Create(820,320,0)
	End Function
	
	Method copy:TBox_Renderer_Sequence()
		Local r:TBox_Renderer_Sequence = New TBox_Renderer_Sequence
		
		r.name = Self.name
		r.script_name = Self.script_name
		r.run_init = Self.run_init
		
		Return r
	End Method
	
	Method draw_editor_view()
		SetColor 255,255,255
		DrawText "Script Name:", 850, 220
		
		TBox_Renderer_Sequence.script_name_imput.content = Self.script_name'script name
		
		TBox_Renderer_Sequence.script_name_imput.render()
		TBox_Renderer_Sequence.script_name_imput.draw()
		
		Self.script_name = TBox_Renderer_Sequence.script_name_imput.content
		
		TBox_Renderer_Sequence.run_init_check.wert = Self.run_init'run init
		
		TBox_Renderer_Sequence.run_init_check.render()
		TBox_Renderer_Sequence.run_init_check.draw()
		
		Self.run_init = TBox_Renderer_Sequence.run_init_check.wert
		
		SetColor 255,255,255
		DrawText "run init",850,325
	End Method
End Type

Rem
Sequences:
 - init
 - script-name

 - image
 - music
 - waitmusic
 - Delay
End Rem

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
	
	
	Rem
	
	Field x:Float
	Field y:Float
	Field layer:Int'0 = behind bg, 1 = just in front of bg, 2 = middle, 3 = just behind fg, 4 = in front of fg
	
	Field important:Int
	
	End Rem
End Type

'########################################################################################
'###########################          ###################################################
'########################### FireBird ###################################################
'###########################          ###################################################
'########################################################################################

Type TFireBird Extends TMob
	
	Global image:TImage
	
	Function init()
		TFireBird.image = LoadImage("Worlds\" + GAME.world.name + "\Objects\fire_bird\image.png")
		MidHandleImage TFireBird.image
	End Function
	
	Method New()
		Self.type_name = "FireBird"
		Self.layer = 1
		Self.important = 1
		
		Self.rx = ImageWidth(TFireBird.image)/2
		Self.ry = ImageHeight(TFireBird.image)/2
	End Method
	
	Function Create:TFireBird(x:Float,y:Float)
		Local p:TFireBird = New TFireBird
		
		p.x = x
		p.y = y
		
		Return p
	End Function
	
	Method render()
		Super.render()
		
	End Method
	
	Method draw()
		SetColor 255,255,255
		DrawImage TFireBird.image, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y
	End Method
	
	Method draw_selected(typ:Int=0)
		
		Select typ
			Case 1
				SetColor 255,0,0
			Case 2
				SetColor 100,100,255
			Case 3
				SetColor 0,255,0
			Default
				SetColor 100,255,0
		End Select
		
		SetAlpha 0.2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x - Self.rx, GAME.world.act_level.ansicht_act_y + Self.y - Self.ry,2*Self.rx,2*Self.ry
		SetAlpha 1
		
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x - Self.rx, GAME.world.act_level.ansicht_act_y + Self.y - Self.ry, 2*Self.rx, 2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x - Self.rx, GAME.world.act_level.ansicht_act_y + Self.y - Self.ry, 2, 2*Self.ry
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x - Self.rx, GAME.world.act_level.ansicht_act_y + Self.y + Self.ry, 2*Self.rx, 2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x + Self.rx, GAME.world.act_level.ansicht_act_y + Self.y - Self.ry, 2, 2*Self.ry
		
	End Method
	
	
	Method render_mouse_over:Int(x1:Int = 0, x2:Int = 0, y1:Int = 0, y2:Int = 0)
		If x1 > x2 Then
			Local xx:Int=x1
			x1 = x2
			x2 = xx
		End If
		
		If y1 > y2 Then
			Local yy:Int=y1
			y1 = y2
			y2 = yy
		End If
		
		If x1 = 0 And x2 = 0 And y1 = 0 And y2 = 0 Then
			'normal part
			
			If EMEGUI.m_x > 800 Then Return 0
			If EMEGUI.m_y > 600 Then Return 0
			
			If EMEGUI.m_x < GAME.world.act_level.ansicht_act_x + Self.x - Self.rx Then Return 0
			If EMEGUI.m_y < GAME.world.act_level.ansicht_act_y + Self.y - Self.ry Then Return 0
			
			If EMEGUI.m_x > GAME.world.act_level.ansicht_act_x + Self.x + Self.rx Then Return 0
			If EMEGUI.m_y > GAME.world.act_level.ansicht_act_y + Self.y + Self.ry Then Return 0
			
			'end normal part
		Else
			'additional part
			
			If x1 > GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If y1 > GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			
			If x2 < GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If y2 < GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			'select 3
			
			'end additional part
		End If
		
		
		Return 1
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
		o.layer = stream.ReadInt()
		o.important = stream.ReadInt()
		
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
'########################### PLAYER #####################################################
'###########################        #####################################################
'########################################################################################

Type TPLAYER Extends TMob
	'Field type_name:String = "Player"
	
	Global image:TImage
	
	Function init()
		TPLAYER.image = LoadImage("Worlds\" + GAME.world.name + "\Objects\player\player.png")
		MidHandleImage TPLAYER.image
	End Function
	
	Method New()
		Self.type_name = "Player"
		Self.layer = 2
		Self.important = 1
		
		Self.rx = ImageWidth(TPLAYER.image)/2
		Self.ry = ImageHeight(TPLAYER.image)/2
	End Method
	
	Function Create:TPLAYER(x:Float,y:Float)
		Local p:TPLAYER = New TPLAYER
		
		p.x = x
		p.y = y
		
		
		
		Return p
	End Function
	
	Method render()
		Super.render()
	End Method
	
	Method draw()
		SetColor 255,255,255
		DrawImage TPLAYER.image, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y
	End Method
	
	Method draw_selected(typ:Int=0)
		Select typ
			Case 1
				SetColor 255,0,0
			Case 2
				SetColor 100,100,255
			Case 3
				SetColor 0,255,0
			Default
				SetColor 100,255,0
		End Select
		
		SetAlpha 0.2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x - Self.rx, GAME.world.act_level.ansicht_act_y + Self.y - Self.ry,2*Self.rx,2*Self.ry
		SetAlpha 1
		
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x - Self.rx, GAME.world.act_level.ansicht_act_y + Self.y - Self.ry, 2*Self.rx, 2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x - Self.rx, GAME.world.act_level.ansicht_act_y + Self.y - Self.ry, 2, 2*Self.ry
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x - Self.rx, GAME.world.act_level.ansicht_act_y + Self.y + Self.ry, 2*Self.rx, 2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x + Self.rx, GAME.world.act_level.ansicht_act_y + Self.y - Self.ry, 2, 2*Self.ry
		
	End Method
	
	
	Method render_mouse_over:Int(x1:Int = 0, x2:Int = 0, y1:Int = 0, y2:Int = 0)
		If x1 > x2 Then
			Local xx:Int=x1
			x1 = x2
			x2 = xx
		End If
		
		If y1 > y2 Then
			Local yy:Int=y1
			y1 = y2
			y2 = yy
		End If
		
		If x1 = 0 And x2 = 0 And y1 = 0 And y2 = 0 Then
			'normal part
			
			If EMEGUI.m_x > 800 Then Return 0
			If EMEGUI.m_y > 600 Then Return 0
			
			If EMEGUI.m_x < GAME.world.act_level.ansicht_act_x + Self.x - Self.rx Then Return 0
			If EMEGUI.m_y < GAME.world.act_level.ansicht_act_y + Self.y - Self.ry Then Return 0
			
			If EMEGUI.m_x > GAME.world.act_level.ansicht_act_x + Self.x + Self.rx Then Return 0
			If EMEGUI.m_y > GAME.world.act_level.ansicht_act_y + Self.y + Self.ry Then Return 0
			
				
			'end normal part
		Else
			'additional part
			
			If x1 > GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If y1 > GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			
			If x2 < GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If y2 < GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			'select 3
			
			'end additional part
		End If
		
		
		Return 1
	End Method

	
	Method write_to_stream(stream:TStream)
		stream.WriteInt(1)'OBJECT = 0        -> ONLY in write, is to find the right read function!
		
		stream.WriteInt(Self.id)'id
		stream.WriteFloat(Self.x)
		stream.WriteFloat(Self.y)
		stream.WriteInt(Self.layer)
		stream.WriteInt(Self.important)
	End Method
	
	Function read_from_stream:TPLAYER(stream:TStream)
		Local o:TPLAYER = New TPLAYER
		
		Try
			o.id = stream.ReadInt()
			o.x = stream.ReadFloat()
			o.y = stream.ReadFloat()
			o.layer = stream.ReadInt()
			o.important = stream.ReadInt()
			
		Catch error_txt:String
			GAME_ERROR_HANDLER.error("TPLAYER -> read_from_stream: " + error_txt)
			Return Null
		End Try
		
		Return o
	End Function
	
	Method copy:TPLAYER()
		Local p:TPLAYER = New TPLAYER
		
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
		Self.type_name = "Badie"
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
	
	Method render()
		Super.render()
		
		Rem
		If KeyDown(key_i) Then Self.y:-10
		If KeyDown(key_k) Then Self.y:+10
		If KeyDown(key_j) Then Self.x:-10
		If KeyDown(key_l) Then Self.x:+10
		End Rem
	End Method
	
	Method draw()
		SetColor 255,255,255
		DrawImage TBADIE.image, GAME.world.act_level.ansicht_act_x + Self.x, GAME.world.act_level.ansicht_act_y + Self.y
	End Method
	
	Method draw_selected(typ:Int=0)
		
		Select typ
			Case 1
				SetColor 255,0,0
			Case 2
				SetColor 100,100,255
			Case 3
				SetColor 0,255,0
			Default
				SetColor 100,255,0
		End Select
		
		SetAlpha 0.2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x - Self.rx, GAME.world.act_level.ansicht_act_y + Self.y - Self.ry,2*Self.rx,2*Self.ry
		SetAlpha 1
		
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x - Self.rx, GAME.world.act_level.ansicht_act_y + Self.y - Self.ry, 2*Self.rx, 2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x - Self.rx, GAME.world.act_level.ansicht_act_y + Self.y - Self.ry, 2, 2*Self.ry
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x - Self.rx, GAME.world.act_level.ansicht_act_y + Self.y + Self.ry, 2*Self.rx, 2
		DrawRect GAME.world.act_level.ansicht_act_x + Self.x + Self.rx, GAME.world.act_level.ansicht_act_y + Self.y - Self.ry, 2, 2*Self.ry
		
	End Method
	
	
	Method render_mouse_over:Int(x1:Int = 0, x2:Int = 0, y1:Int = 0, y2:Int = 0)
		If x1 > x2 Then
			Local xx:Int=x1
			x1 = x2
			x2 = xx
		End If
		
		If y1 > y2 Then
			Local yy:Int=y1
			y1 = y2
			y2 = yy
		End If
		
		If x1 = 0 And x2 = 0 And y1 = 0 And y2 = 0 Then
			'normal part
			
			If EMEGUI.m_x > 800 Then Return 0
			If EMEGUI.m_y > 600 Then Return 0
			
			If EMEGUI.m_x < GAME.world.act_level.ansicht_act_x + Self.x - Self.rx Then Return 0
			If EMEGUI.m_y < GAME.world.act_level.ansicht_act_y + Self.y - Self.ry Then Return 0
			
			If EMEGUI.m_x > GAME.world.act_level.ansicht_act_x + Self.x + Self.rx Then Return 0
			If EMEGUI.m_y > GAME.world.act_level.ansicht_act_y + Self.y + Self.ry Then Return 0
			
			
			'end normal part
		Else
			'additional part
			
			If x1 > GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If y1 > GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			
			If x2 < GAME.world.act_level.ansicht_act_x + Self.x Then Return 0
			If y2 < GAME.world.act_level.ansicht_act_y + Self.y Then Return 0
			'select 3
			
			'end additional part
		End If
		
		
		Return 1
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
			'mouseover setzen
			If EDITOR.radio_parent_block_object.actual_child = EDITOR.radio_child_object And o.render_mouse_over() Then EDITOR.object_mouse_over = o
			'selecten
			If EDITOR.radio_parent_block_object.actual_child = EDITOR.radio_child_object And o.render_mouse_over() And EMEGUI.m_hit_1 Then
				EDITOR.object_selected = o
				EDITOR.object_select_list = New TList
				FlushKeys()
			End If
			
			
			If EDITOR.radio_parent_block_object.actual_child = EDITOR.radio_child_object Then
				'select3
				
				If EDITOR.object_select_status > 1 Then
					If o.render_mouse_over(EDITOR.object_select_x1+GAME.world.act_level.ansicht_act_x, EDITOR.object_select_x2+GAME.world.act_level.ansicht_act_x, EDITOR.object_select_y1+GAME.world.act_level.ansicht_act_y, EDITOR.object_select_y2+GAME.world.act_level.ansicht_act_y) Then
						EDITOR.object_select_list.addlast(o)
					End If
				End If
				
			End If
			
		Next
	End Method
	
	Method draw()'DRAW list
		
		Rem
		SetAlpha 0.1
		SetColor Rand(0,255),Rand(0,255),Rand(0,255)
		DrawOval GAME.world.act_level.ansicht_act_x + Self.x*Self.dx, GAME.world.act_level.ansicht_act_y + Self.y*Self.dy,Self.dx, Self.dy
		SetAlpha 1
		End Rem
		
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
				'Print "read..."
				
				Local name:String = Trim(Mid(txt,1,pos-1))
				Local data:String = Trim(Mid(txt,pos+1,-1))
				
				'Print name
				'Print data
				
				map.insert(name, data)
			Else
				'Print "white line!"
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
End Type

'########################################################################################
'###########################                   ##########################################
'###########################   MOUSE HANDLER   ##########################################
'###########################                   ##########################################
'########################################################################################

Type MOUSE
	Global image_strip:TImage
	Global typ:Int=0
	
	Function draw()
		SetColor 255,255,255
		DrawImage MOUSE.image_strip, EMEGUI.m_x, EMEGUI.m_y, MOUSE.typ
	End Function
	
	Function init()
		MOUSE.image_strip = LoadAnimImage("gfx\mouse.png",50,50,0,8)
		MidHandleImage MOUSE.image_strip
		
		HideMouse()
	End Function
End Type

'########################################################################################
'###########################                   ##########################################
'###########################    BLOCK SLOT     ##########################################
'###########################                   ##########################################
'########################################################################################

Type TBlock_Slot
	Field block:TBlock
	
	Field world:TWorld
	
	Field x:Int
	Field y:Int
	
	Field number:Int
	
	Field fg_delta_t_i:GUI_INPUT'=GUI_INPUT.Create(10,200,"testiania",300)
	Field bg_delta_t_i:GUI_INPUT
	
	Field fg_use_check:GUI_CHECK' = GUI_CHECK.Create(910,5,1)
	Field bg_use_check:GUI_CHECK
	
	Field collision_on_check:GUI_CHECK
	Field collision_use_check:GUI_CHECK
	
	Field radio_parent:GUI_RADIO
	Field radio_child_choose:GUI_RADIO_CHILD
	
	
	Function Create:TBlock_Slot(world:TWorld, x:Int, y:Int, number:Int, block:TBlock,radio_parent:GUI_RADIO, fg_use:Int=1, bg_use:Int=1, collsion_use:Int=1)
		Local bs:TBlock_Slot = New TBlock_Slot
		
		bs.world = world
		
		bs.x = x
		bs.y = y
		bs.number = number
		
		bs.block = block
		
		
		bs.fg_use_check = GUI_CHECK.Create(bs.x + 2, bs.y + 70, fg_use)
		bs.fg_delta_t_i = GUI_INPUT.Create(bs.x + 20, bs.y + 70,String(bs.block.fg_delta_t),70)
		
		bs.bg_use_check = GUI_CHECK.Create(bs.x + 2, bs.y + 70 + 100, bg_use)
		bs.bg_delta_t_i = GUI_INPUT.Create(bs.x + 20, bs.y + 70 + 100,String(bs.block.bg_delta_t),70)
		
		bs.collision_use_check = GUI_CHECK.Create(bs.x + 2, bs.y + 2 + 220, collsion_use)
		bs.collision_on_check = GUI_CHECK.Create(bs.x + 2 + 70, bs.y + 2 + 220, bs.block.collision)
		
		bs.radio_child_choose:GUI_RADIO_CHILD = GUI_RADIO_CHILD.Create(bs.x + 2, bs.y + 2, number, radio_parent)
		bs.radio_parent = radio_parent
		bs.radio_parent.actual_child = bs.radio_child_choose
		
		Return bs
	End Function
	
	Method render()
		Self.fg_delta_t_i.content = Self.block.fg_delta_t
		Self.bg_delta_t_i.content = Self.block.bg_delta_t
		Self.collision_on_check.wert = Self.block.collision
		
		Self.fg_delta_t_i.render()
		Self.bg_delta_t_i.render()
		
		Self.fg_use_check.render()
		Self.bg_use_check.render()
		
		Self.collision_on_check.render()
		Self.collision_use_check.render()
		
		Self.radio_child_choose.render()
		
		Self.block.fg_delta_t = Int(Self.fg_delta_t_i.content)
		Self.block.bg_delta_t = Int(Self.bg_delta_t_i.content)
		Self.block.collision = Self.collision_on_check.wert
		'on klick image!!!!!!!!!!!!!
		
		
		If EMEGUI.m_hit_1 And EMEGUI.m_x > Self.x + 20 And EMEGUI.m_x < Self.x + 20 + Self.world.block_image_manager.image_side And EMEGUI.m_y > Self.y + 5 And EMEGUI.m_y < Self.y + 5 + Self.world.block_image_manager.image_side Then
			Self.block.fg_image_number = Self.world.block_image_manager.choose_image(Self.block.fg_image_number)
		End If
		
		If EMEGUI.m_hit_1 And EMEGUI.m_x > Self.x + 20 And EMEGUI.m_x < Self.x + 20 + Self.world.block_image_manager.image_side And EMEGUI.m_y > Self.y + 5 + 100 And EMEGUI.m_y < Self.y + 5 + 100 + Self.world.block_image_manager.image_side Then
			Self.block.bg_image_number = Self.world.block_image_manager.choose_image(Self.block.bg_image_number)
		End If
		
	End Method
	
	Method draw()
		If Self.radio_parent.actual_child = Self.radio_child_choose Then
			SetColor 255,100,100
			DrawRect Self.x, Self.y, 100, 250
		End If
		
		Self.fg_delta_t_i.draw()
		Self.bg_delta_t_i.draw()
		
		Self.fg_use_check.draw()
		Self.bg_use_check.draw()
		
		Self.collision_on_check.draw()
		Self.collision_use_check.draw()
		
		SetColor 0,0,0
		DrawText "collision:",Self.x + 2, Self.y + 2 + 200
		
		SetColor 100,255,100
		DrawRect Self.x +30, Self.y  + 220,20,20
		SetColor 0,0,0
		DrawText Self.number,Self.x + 2 +30, Self.y + 2 + 220
		
		Self.radio_child_choose.draw()
		
		SetColor 0,0,0
		DrawRect Self.x + 20 - 1, Self.y + 5 - 1, GAME.world.block_image_manager.image_side + 2, GAME.world.block_image_manager.image_side + 2
		SetColor 255,255,255
		DrawRect Self.x + 20, Self.y + 5, GAME.world.block_image_manager.image_side, GAME.world.block_image_manager.image_side
		Self.block.fg_draw(Self.x + 20, Self.y + 5)
		
		SetColor 0,0,0
		DrawRect Self.x + 20 - 1, Self.y + 5 + 100 - 1, GAME.world.block_image_manager.image_side + 2, GAME.world.block_image_manager.image_side + 2
		SetColor 255,255,255
		DrawRect Self.x + 20, Self.y + 5 + 100, GAME.world.block_image_manager.image_side, GAME.world.block_image_manager.image_side
		Self.block.bg_draw(Self.x + 20, Self.y + 5 + 100)
	End Method
End Type

'########################################################################################
'###########################                   ##########################################
'###########################    LEVEL SLOT     ##########################################
'###########################                   ##########################################
'########################################################################################

Type TLevel_Slot
	Field level:TLevel
	
	Field number:Int
	
	Field x:Int
	Field y:Int
	
	Field radio_parent:GUI_RADIO
	Field radio_child_choose:GUI_RADIO_CHILD
	
	Function Create:TLevel_Slot(x:Int, y:Int, level:TLevel, number:Int, radio_parent:GUI_RADIO)
		Local ls:TLevel_Slot = New TLevel_Slot
		
		ls.level = level
		ls.number = number
		ls.radio_parent = radio_parent
		ls.x = x
		ls.y = y
		
		ls.radio_child_choose = GUI_RADIO_CHILD.Create(ls.x + 2, ls.y + 2, ls.number, ls.radio_parent)
		
		ls.radio_parent.actual_child = ls.radio_child_choose
		
		Return ls
	End Function
	
	Method render()
		Self.radio_child_choose.render()
	End Method
	
	Method draw()
		If Self.radio_parent.actual_child = Self.radio_child_choose Then
			SetColor 0,0,0
			DrawRect Self.x, Self.y, 100, 50
			
			SetColor 200,255,200
			DrawRect Self.x+2, Self.y+2, 100-4, 50-4
		Else
			SetColor 0,0,0
			DrawRect Self.x, Self.y, 100, 50
			
			SetColor 255,200,200
			DrawRect Self.x+2, Self.y+2, 100-4, 50-4
		End If
		
		Self.radio_child_choose.draw()
		
		If Self.level = Null
			SetColor 100,0,0
			DrawText "# EMPTY #", Self.x + 20, Self.y + 2
		Else
			SetColor 0,0,0
			DrawText Self.level.name, Self.x + 20, Self.y + 2
			DrawText Self.level.table_x + "/" + Self.level.table_y, Self.x + 2, Self.y + 25
		End If
		
	End Method
	
	Method draw_paste_field()
		If Self.level <> Null Then
			
			If EDITOR.block_over_x + Self.level.table_x =< GAME.world.act_level.table_x And EDITOR.block_over_y + Self.level.table_y =< GAME.world.act_level.table_y Then
				SetColor 0,255,0
			Else
				SetColor 255,0,0
			End If
			
			SetAlpha Float(MilliSecs() Mod 800)/800.0*0.15+0.1
			DrawRect EDITOR.block_over_x*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, EDITOR.block_over_y*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y, GAME.world.block_image_manager.image_side * Self.level.table_x, GAME.world.block_image_manager.image_side * Self.level.table_y 
			
			SetAlpha 0.5
			'box around it
			DrawRect EDITOR.block_over_x*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, EDITOR.block_over_y*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y, GAME.world.block_image_manager.image_side * Self.level.table_x, 2
			DrawRect EDITOR.block_over_x*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, EDITOR.block_over_y*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y, 2, GAME.world.block_image_manager.image_side * Self.level.table_y
			DrawRect EDITOR.block_over_x*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, -2 + (EDITOR.block_over_y + Self.level.table_y)*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y, GAME.world.block_image_manager.image_side * Self.level.table_x, 2
			DrawRect -2 + (EDITOR.block_over_x + Self.level.table_x)*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, EDITOR.block_over_y*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y, 2, GAME.world.block_image_manager.image_side * Self.level.table_y
			
			SetAlpha 1
			
		End If
	End Method
	
End Type

'########################################################################################
'###########################                   ##########################################
'###########################      EDITOR       ##########################################
'###########################                   ##########################################
'########################################################################################


Type EDITOR
	'----------------- MOUSE OVER/SELECT -----------------------------
	Global block_over_x:Int
	Global block_over_y:Int
	Global block_over_image:TImage
	
	Global block_selected_x1:Int
	Global block_selected_y1:Int
	Global block_selected_image_1:TImage
	
	Global block_selected_x2:Int
	Global block_selected_y2:Int
	Global block_selected_image_2:TImage
	
	Function init_over_select()
		EDITOR.block_over_image = LoadImage("Worlds\" + GAME.world.name + "\Blocks\gfx\mouse_over.png")
		EDITOR.block_selected_image_1 = LoadImage("Worlds\" + GAME.world.name + "\Blocks\gfx\select_1.png")
		EDITOR.block_selected_image_2 = LoadImage("Worlds\" + GAME.world.name + "\Blocks\gfx\select_2.png")
	End Function
	
	'--------------------- GUI ----------------------------------------
	Global radio_parent_block_object:GUI_RADIO'block or object?
	Global radio_child_block:GUI_RADIO_CHILD
	Global radio_child_object:GUI_RADIO_CHILD
	
	
	Global radio_block_parent:GUI_RADIO'block
	Global radio_block_select:GUI_RADIO_CHILD
	Global radio_block_set:GUI_RADIO_CHILD
	Global radio_block_copy:GUI_RADIO_CHILD
	Global radio_block_paste:GUI_RADIO_CHILD
	
	Global check_draw_fg:GUI_CHECK'what shall we draw?
	Global check_draw_bg:GUI_CHECK
	Global check_draw_collision:GUI_CHECK
	Global check_draw_objects:GUI_CHECK
	
	Function init_gui()
		EDITOR.radio_parent_block_object = GUI_RADIO.Create()'block or object?
		
		EDITOR.radio_child_block = GUI_RADIO_CHILD.Create(805,5, "block", EDITOR.radio_parent_block_object)
		EDITOR.radio_child_object = GUI_RADIO_CHILD.Create(805,35, "object", EDITOR.radio_parent_block_object)
		
		EDITOR.radio_parent_block_object.actual_child = EDITOR.radio_child_block
		
		
		EDITOR.radio_block_parent = GUI_RADIO.Create()'block
		EDITOR.radio_block_select = GUI_RADIO_CHILD.Create(805,70,"select",EDITOR.radio_block_parent)
		EDITOR.radio_block_set = GUI_RADIO_CHILD.Create(905,70,"set",EDITOR.radio_block_parent)
		EDITOR.radio_block_copy = GUI_RADIO_CHILD.Create(1005,70,"copy",EDITOR.radio_block_parent)
		EDITOR.radio_block_paste = GUI_RADIO_CHILD.Create(1105,70,"paste",EDITOR.radio_block_parent)
		EDITOR.radio_block_parent.actual_child = EDITOR.radio_block_set
		
		EDITOR.check_draw_fg = GUI_CHECK.Create(910,5,1)'what shall we draw?
		EDITOR.check_draw_bg = GUI_CHECK.Create(1060,5,1)
		EDITOR.check_draw_collision = GUI_CHECK.Create(910,35,1)
		EDITOR.check_draw_objects = GUI_CHECK.Create(1060,35,1)
	End Function
	
	'--------------------- BLOCK SLOTS ----------------------
	Global slots_for_blocks:TBlock_Slot[8]
	Global radio_parent_slots_blocks:GUI_RADIO
	
	Function init_block_slots()
		EDITOR.radio_parent_slots_blocks = GUI_RADIO.Create()
		
		If FileType("Worlds\" + GAME.world.name + "\Blocks\colors.data") Then
			Print "load color slots"
			Local color_map:TMap = DATA_FILE_HANDLER.Load("Worlds\" + GAME.world.name + "\Blocks\colors.data")
			
			For Local i:Int = 0 To 7
				Local coll_on:Int = Int(String(color_map.ValueForKey("coll_on_" + i)))
				Local coll_use:Int = Int(String(color_map.ValueForKey("coll_use_" + i)))
				Local fg:Int = Int(String(color_map.ValueForKey("fg_" + i)))
				Local fg_t:Int = Int(String(color_map.ValueForKey("fg_t_" + i)))
				Local fg_use:Int = Int(String(color_map.ValueForKey("fg_use_" + i)))
				Local bg:Int = Int(String(color_map.ValueForKey("bg_" + i)))
				Local bg_t:Int = Int(String(color_map.ValueForKey("bg_t_" + i)))
				Local bg_use:Int = Int(String(color_map.ValueForKey("bg_use_" + i)))
				
				EDITOR.slots_for_blocks[i] = TBlock_Slot.Create(GAME.world, 800 + 100*(i-4*(i/4)), 100 + 250*(i/4), i, TBlock.Create(coll_on, fg, fg_t, bg, bg_t), EDITOR.radio_parent_slots_blocks)
				
				EDITOR.slots_for_blocks[i].fg_use_check.wert = fg_use
				EDITOR.slots_for_blocks[i].bg_use_check.wert = bg_use
				EDITOR.slots_for_blocks[i].collision_use_check.wert = coll_use
				
			Next
			
		Else
			For Local i:Int = 0 To 7
				EDITOR.slots_for_blocks[i] = TBlock_Slot.Create(GAME.world, 800 + 100*(i-4*(i/4)), 100 + 250*(i/4), i, TBlock.Create(0, 0, -1, 0, -1), EDITOR.radio_parent_slots_blocks)
			Next
		End If
	End Function
	
	Function save_level_slots()
		For Local i:Int = 0 To 4*5-1
			If EDITOR.slots_for_levels[i].level <> Null Then EDITOR.slots_for_levels[i].level.save()
		Next
	End Function
	
	
	'-------------------------- LEVEL SLOTS ---------------------
	Global slots_for_levels:TLevel_Slot[4*5]
	Global radio_parent_slots_levels:GUI_RADIO
	
	Function init_level_slots()
		EDITOR.radio_parent_slots_levels = GUI_RADIO.Create()
		
		
		For Local y:Int = 0 To 4
			For Local x:Int = 0 To 3
				If FileType("Worlds\" + GAME.world.name + "\Levels\SLOT_" + String(y*4 + x)) Then
					EDITOR.slots_for_levels[y*4 + x] = TLevel_Slot.Create(800 + 100*x, 100 + 50*y, TLevel.Load(GAME.world, "SLOT_" + (y*4 + x)), y*4 + x, EDITOR.radio_parent_slots_levels)
				Else
					EDITOR.slots_for_levels[y*4 + x] = TLevel_Slot.Create(800 + 100*x, 100 + 50*y, Null, y*4 + x, EDITOR.radio_parent_slots_levels)
				End If
			Next
		Next
	End Function
	
	Function save_block_slots()
		Local map:TMap = New TMap
		
		For Local i:Int = 0 To 7
			map.Insert("coll_on_" + i, String(EDITOR.slots_for_blocks[i].block.collision))'collision
			map.Insert("coll_use_" + i, String(EDITOR.slots_for_blocks[i].collision_use_check.wert))
			
			map.Insert("fg_" + i, String(EDITOR.slots_for_blocks[i].block.fg_image_number))'fg
			map.Insert("fg_t_" + i, String(EDITOR.slots_for_blocks[i].block.fg_delta_t))
			map.Insert("fg_use_" + i, String(EDITOR.slots_for_blocks[i].fg_use_check.wert))
			
			map.Insert("bg_" + i, String(EDITOR.slots_for_blocks[i].block.bg_image_number))'fg
			map.Insert("bg_t_" + i, String(EDITOR.slots_for_blocks[i].block.bg_delta_t))
			map.Insert("bg_use_" + i, String(EDITOR.slots_for_blocks[i].bg_use_check.wert))
		Next
		
		DATA_FILE_HANDLER.save(map, "Worlds\" + GAME.world.name + "\Blocks\colors.data")
	End Function
	
	
	Function init()'init everything for the editor
		EDITOR.init_over_select()
		
		EDITOR.init_gui()
		
		EDITOR.init_block_slots()
		
		EDITOR.init_level_slots()
		
		'EDITOR.init_objects()'must be loaded before level
	End Function
	
	
	Function mouse_over_block()
		
		EDITOR.block_over_x = (EMEGUI.m_x - GAME.world.act_level.ansicht_act_x)/GAME.world.block_image_manager.image_side
		EDITOR.block_over_y = (EMEGUI.m_y - GAME.world.act_level.ansicht_act_y)/GAME.world.block_image_manager.image_side
		
		If EDITOR.block_over_x < 0 Then EDITOR.block_over_x = 0
		If EDITOR.block_over_y < 0 Then EDITOR.block_over_y = 0
		
		If EDITOR.block_over_x > GAME.world.act_level.table_x-1 Then EDITOR.block_over_x = GAME.world.act_level.table_x-1
		If EDITOR.block_over_y > GAME.world.act_level.table_y-1 Then EDITOR.block_over_y = GAME.world.act_level.table_y-1
		
	End Function
	
	Function draw_selected_field()
		'the two selected blocks:
		SetColor 255,255,255
		DrawImage EDITOR.block_selected_image_1, EDITOR.block_selected_x1*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, EDITOR.block_selected_y1*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y
		DrawText "x= " + EDITOR.block_selected_x1, 2 + EDITOR.block_selected_x1*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, 2 + EDITOR.block_selected_y1*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y
		DrawText "y= " + EDITOR.block_selected_y1, 2 + EDITOR.block_selected_x1*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, 25 + EDITOR.block_selected_y1*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y
		
		SetColor 255,255,255
		DrawImage EDITOR.block_selected_image_2, EDITOR.block_selected_x2*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, EDITOR.block_selected_y2*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y
		DrawText "x= " + EDITOR.block_selected_x2, 2 + EDITOR.block_selected_x2*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, 2 + EDITOR.block_selected_y2*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y
		DrawText "y= " + EDITOR.block_selected_y2, 2 + EDITOR.block_selected_x2*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, 25 + EDITOR.block_selected_y2*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y
		
		'DRAW BOX
		Local x1:Int
		Local x2:Int
		'check x
		If EDITOR.block_selected_x1 <= EDITOR.block_selected_x2 Then
			x1 = EDITOR.block_selected_x1
			x2 = EDITOR.block_selected_x2
		Else
			x1 = EDITOR.block_selected_x2
			x2 = EDITOR.block_selected_x1
		End If
		
		Local y1:Int
		Local y2:Int
		'check y
		If EDITOR.block_selected_y1 <= EDITOR.block_selected_y2 Then
			y1 = EDITOR.block_selected_y1
			y2 = EDITOR.block_selected_y2
		Else
			y1 = EDITOR.block_selected_y2
			y2 = EDITOR.block_selected_y1
		End If
		
		SetColor 0,255,0'draw rect with box
		SetAlpha Float(MilliSecs() Mod 700)/700.0*0.1+0.05
		
		DrawRect x1*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, y1*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y, GAME.world.block_image_manager.image_side * (x2-x1+1), GAME.world.block_image_manager.image_side * (y2-y1+1)
		
		SetAlpha 0.5
		
		DrawRect x1*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, y1*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y, GAME.world.block_image_manager.image_side * (x2-x1+1), 2
		DrawRect x1*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, y1*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y, 2, GAME.world.block_image_manager.image_side * (y2-y1+1)
		DrawRect x1*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, -2 + (y2+1)*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y, GAME.world.block_image_manager.image_side * (x2-x1+1), 2
		DrawRect -2 + (x2+1)*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, y1*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y, 2, GAME.world.block_image_manager.image_side * (y2-y1+1)
		
		SetAlpha 1
	End Function
	
	Function render()
		EDITOR.object_mouse_over = Null'object_mouse_over zurücksetzen
		
		
		EDITOR.radio_child_block.render()'block vs. object schalter
		EDITOR.radio_child_object.render()
		
		
		EDITOR.check_draw_fg.render()'what shall we draw?
		EDITOR.check_draw_bg.render()
		EDITOR.check_draw_collision.render()
		EDITOR.check_draw_objects.render()
		
		EDITOR.render_actions_over_map()
		
		If EDITOR.radio_parent_block_object.actual_child = EDITOR.radio_child_object Then
			
			If KeyHit(KEY_DELETE) Then
				If EDITOR.object_selected <> Null Then EDITOR.object_selected.kill_me = 1
			
				If EDITOR.object_select_list.count()>0 Then
					For Local o:TObject = EachIn EDITOR.object_select_list
						o.kill_me = 1
					Next
					EDITOR.object_select_list = New TList
				End If
			End If
			
			If KeyHit(key_space) And EDITOR.object_selected <> Null Then
				'ansicht zu objekt
				GAME.world.act_level.ansicht_ziel_x = -EDITOR.object_selected.x+400	
				GAME.world.act_level.ansicht_ziel_y = -EDITOR.object_selected.y+300
			End If
			
			If EMEGUI.m_down_2 And EDITOR.object_selected <> Null Then
				EDITOR.object_selected.x = EMEGUI.m_x - GAME.world.act_level.ansicht_act_x
				EDITOR.object_selected.y = EMEGUI.m_y - GAME.world.act_level.ansicht_act_y
				
				If KeyDown(Key_f3) Then
					EDITOR.object_selected.x = EDITOR.object_selected.x-(EDITOR.object_selected.x Mod GAME.world.block_image_manager.image_side)
					EDITOR.object_selected.y = EDITOR.object_selected.y-(EDITOR.object_selected.y Mod GAME.world.block_image_manager.image_side)
				End If
				
				MOUSE.typ = 1
			End If
			
			
			If EMEGUI.m_x > 820 And EMEGUI.m_y > 400 Then
				Local i:Int = (EMEGUI.m_y - 400)/20 + EDITOR.object_list_start_drawing
				
				If i < EDITOR.object_list.count() Then
					
					Local o:TObject = TObject(EDITOR.object_list.ValueAtIndex(i))
					
					If o <> Null Then
						EDITOR.object_mouse_over = o
						FlushKeys()
					End If
				End If
			End If
		End If
	End Function
	
	Function draw_side()
		'DRAW MAIN CONTROLLERS
		
		SetColor 0,255,0
		DrawRect 802, (EDITOR.radio_parent_block_object.actual_child = EDITOR.radio_child_object)*30 + 2,96,26
		EDITOR.radio_child_block.draw()'block vs. object schalter
		EDITOR.radio_child_object.draw()
		SetColor 0,0,0
		DrawText "BLOCK [F1]", 822, 5
		DrawText "OBJECT[F2]", 822, 35
		DrawRect 800,60,400,2
		DrawRect 900,0,2,60
		
		If KeyHit(key_f1) Then EDITOR.radio_parent_block_object.actual_child = EDITOR.radio_child_block
		If KeyHit(key_f2) Then EDITOR.radio_parent_block_object.actual_child = EDITOR.radio_child_object
		
		
		EDITOR.check_draw_fg.draw()'what shall we draw?
		EDITOR.check_draw_bg.draw()
		EDITOR.check_draw_collision.draw()
		EDITOR.check_draw_objects.draw()
		
		If KeyHit(KEY_NUMADD) Then EDITOR.check_draw_collision.wert = 1-EDITOR.check_draw_collision.wert
		
		SetColor 0,0,0
		DrawText "FG", 925,5
		DrawText "BG", 1085,5
		DrawText "collision [+]", 925,35
		DrawText "OBJECT's", 1085,35
		
		'DRAW STUFF BELOW (blocks or objects)
		
		If EDITOR.radio_parent_block_object.actual_child = EDITOR.radio_child_block Then
			
			'------------------------- BLOCKS -------------------------@@@@@
			
			EDITOR.radio_block_set.render()'SET OR SELECT? or copy or paste?
			EDITOR.radio_block_select.render()
			EDITOR.radio_block_copy.render()
			EDITOR.radio_block_paste.render()
			
			SetColor 50,200,50
			Select EDITOR.radio_block_parent.actual_child
				Case EDITOR.radio_block_select
					DrawRect 800,65,80,25
				Case EDITOR.radio_block_set
					DrawRect 900,65,80,25
				Case EDITOR.radio_block_copy
					DrawRect 1000,65,80,25
				Case EDITOR.radio_block_paste
					DrawRect 1100,65,80,25
			End Select
			
			EDITOR.radio_block_set.draw()
			EDITOR.radio_block_select.draw()
			EDITOR.radio_block_copy.draw()
			EDITOR.radio_block_paste.draw()
			
			If KeyHit(key_f) Then EDITOR.radio_block_parent.actual_child = EDITOR.radio_block_select
			If KeyHit(key_p) Then EDITOR.radio_block_parent.actual_child = EDITOR.radio_block_set
			If KeyHit(key_c) Then EDITOR.radio_block_parent.actual_child = EDITOR.radio_block_copy
			If KeyHit(key_i) Then EDITOR.radio_block_parent.actual_child = EDITOR.radio_block_paste
			
			SetColor 0,0,0
			DrawText "[F] FILL", 820, 70'select
			DrawText "[P] PAINT", 920, 70'set
			DrawText "[C] COPY", 1020, 70'copy
			DrawText "[I] INSERT", 1120, 70'paste
			
			DrawRect 1000,65,2,30
			
			Select EDITOR.radio_block_parent.actual_child
				Case EDITOR.radio_block_select, EDITOR.radio_block_set
					
					'DRAW BLOCK-SLOTS
					
					For Local i:Int = 0 To 7'SLOTS
						EDITOR.slots_for_blocks[i].render()
						EDITOR.slots_for_blocks[i].draw()
					Next
					
					If KeyHit(key_1) Then EDITOR.slots_for_blocks[0].radio_parent.actual_child = EDITOR.slots_for_blocks[0].radio_child_choose
					If KeyHit(key_2) Then EDITOR.slots_for_blocks[1].radio_parent.actual_child = EDITOR.slots_for_blocks[1].radio_child_choose
					If KeyHit(key_3) Then EDITOR.slots_for_blocks[2].radio_parent.actual_child = EDITOR.slots_for_blocks[2].radio_child_choose
					If KeyHit(key_4) Then EDITOR.slots_for_blocks[3].radio_parent.actual_child = EDITOR.slots_for_blocks[3].radio_child_choose
					If KeyHit(key_5) Then EDITOR.slots_for_blocks[4].radio_parent.actual_child = EDITOR.slots_for_blocks[4].radio_child_choose
					If KeyHit(key_6) Then EDITOR.slots_for_blocks[5].radio_parent.actual_child = EDITOR.slots_for_blocks[5].radio_child_choose
					If KeyHit(key_7) Then EDITOR.slots_for_blocks[6].radio_parent.actual_child = EDITOR.slots_for_blocks[6].radio_child_choose
					If KeyHit(key_8) Then EDITOR.slots_for_blocks[7].radio_parent.actual_child = EDITOR.slots_for_blocks[7].radio_child_choose
					
					SetColor 0,0,0'SLOTS - raster
					DrawRect 800,100,400,2
					DrawRect 800,350,400,2
					DrawRect 800,600,400,2
					
					DrawRect 900,100,2,500
					DrawRect 1000,100,2,500
					DrawRect 1100,100,2,500
					
				Case EDITOR.radio_block_copy, EDITOR.radio_block_paste
					
					SetColor 0,0,0
					DrawRect 800,100,400,2
					
					For Local i:Int = 0 To 4*5-1'SLOTS
						EDITOR.slots_for_levels[i].render()
						EDITOR.slots_for_levels[i].draw()
					Next
			End Select
			
			
			SetColor 0,0,0
			DrawText "[F12] render group, [F11] reverse process",820,620
			
		Else
			'------------------------- OBJECTS -------------------------@@@@@
			
			'-------------- SELECTED OBJECT ---------##
			If EDITOR.object_selected <> Null Then
				EDITOR.object_selected.draw_big_view()
				If TBox(EDITOR.object_selected) Then TBox(EDITOR.object_selected).draw_big_view_vdn()
			Else
				SetViewport(800,60,400,340)
				SetClsColor 0,0,40
				Cls
				
				SetColor 255,255,255
				DrawText "PLEASE SELECT AN OBJECT",900,100
			End If
			
			
			
			'---------------- OBJECT LIST -----------##
			SetViewport(800,400,400,300)
			SetClsColor 0,20,0
			Cls
			
			Local counter:Int = 0
			Local anz_objects:Int = EDITOR.object_list.Count()
			
			'draw balken
			SetColor 150,150,150
			DrawRect 800,400,20,300
			
			If anz_objects > 15 Then
				
				'draw schieber von balken
				SetColor 50,50,50
				DrawRect 800,400 + Float(Float(EDITOR.object_list_start_drawing)/Float(anz_objects-15)*300.0)-10,20,20
				SetColor 150,150,150
				DrawRect 800+2,400 + Float(Float(EDITOR.object_list_start_drawing)/Float(anz_objects-15)*300.0)-1,16,2
				
				If EMEGUI.m_x > 800 And EMEGUI.m_x < 820 And EMEGUI.m_y > 400 Then
					If EMEGUI.m_down_1 Then
						EDITOR.object_list_start_drawing = (Float(EMEGUI.m_y - 400)/300.0*Float(anz_objects-15) + 0.5)
					End If
				End If
				
				If EMEGUI.m_x > 800 And EMEGUI.m_y > 400 Then
					EDITOR.object_list_start_drawing:-EMEGUI.m_z_speed
					
					If EDITOR.object_list_start_drawing < 0 Then EDITOR.object_list_start_drawing = 0
					If EDITOR.object_list_start_drawing > anz_objects-15 Then EDITOR.object_list_start_drawing = anz_objects-15
				End If
			Else
				EDITOR.object_list_start_drawing = 0
			End If
			
			'DRAW LIST
			For Local o:TObject = EachIn EDITOR.object_list
				If EDITOR.object_list_start_drawing <= counter Or counter <= EDITOR.object_list_start_drawing + 15 Then
					
					If EDITOR.object_selected = o Then'box rundherum
						SetColor 255,0,0
					ElseIf EDITOR.object_select_list.contains(o)
						SetColor 0,255,0
					ElseIf EDITOR.object_mouse_over = o
						SetColor 100,100,255
					Else
						SetColor 100,100,100
					End If
					DrawRect 820, 400 + (counter - EDITOR.object_list_start_drawing)*20,380,20
					
					If EDITOR.object_selected = o Then'box innen
						SetColor 100,0,0
					ElseIf EDITOR.object_select_list.contains(o)
						SetColor 0,255,0
					ElseIf EDITOR.object_mouse_over = o
						SetColor 20,20,100
					Else
						SetColor 0,0,0
					End If
					DrawRect 820+1, 400 + (counter - EDITOR.object_list_start_drawing)*20+1,380-2,20-2
					
					SetColor 255,255,255
					'DrawText o.id, 820+3, 400 + (counter - EDITOR.object_list_start_drawing)*20+3
					DrawText o.type_name, 830, 400 + (counter - EDITOR.object_list_start_drawing)*20+3
					
					SetColor 255,255,255
					DrawImage EDITOR.kill_object_image,1200-20, 400 + (counter - EDITOR.object_list_start_drawing)*20
					
					
					If EMEGUI.m_x > 820 And EMEGUI.m_y > 400 And EMEGUI.m_y > 400 + (counter - EDITOR.object_list_start_drawing)*20 And EMEGUI.m_y < 400 + (counter - EDITOR.object_list_start_drawing)*20 + 20 Then
						If EMEGUI.m_hit_1 Then
							EDITOR.object_selected = o
						End If
					End If
					
					If EMEGUI.m_x > 1200-20 And EMEGUI.m_y > 400 + (counter - EDITOR.object_list_start_drawing)*20 And EMEGUI.m_y < 400 + (counter - EDITOR.object_list_start_drawing)*20 + 20 Then
						If EMEGUI.m_hit_1 Then
							o.kill_me = 1
						End If
					End If
				End If
				counter:+1
			Next
		End If
		
	End Function
	
	
	Function render_actions_over_map()
		If EMEGUI.m_x < 800 And EMEGUI.m_y < 600 Then
			
			EDITOR.mouse_over_block()
			
			MOUSE.typ = 0
			
			If EDITOR.radio_parent_block_object.actual_child = EDITOR.radio_child_block Then
				Select EDITOR.radio_block_parent.actual_child
					Case EDITOR.radio_block_select' ************ SELECT now Fill
						
						MOUSE.typ = 7
						
						If EMEGUI.m_hit_1 Then
							'Create:TBlock_Slot(world:TWorld, x:Int, y:Int, number:Int, block:TBlock,radio_parent:GUI_RADIO, fg_use:Int=1, bg_use:Int=1, collsion_use:Int=1)
							Local slot_old:TBlock_Slot = TBlock_Slot.Create(GAME.world, -1,-1,-1, New TBlock, GUI_RADIO.Create(),1,1,1)
							GAME.world.act_level.copy_block_into_slot(EDITOR.block_over_x, EDITOR.block_over_y, slot_old)
							GAME.world.act_level.fill_with_slot(EDITOR.block_over_x, EDITOR.block_over_y, EDITOR.slots_for_blocks[Int(EDITOR.radio_parent_slots_blocks.actual_child.wert)],slot_old)
						End If
						
						If EMEGUI.m_down_2 Then
							MOUSE.typ = 3
							
							GAME.world.act_level.copy_block_into_slot(EDITOR.block_over_x, EDITOR.block_over_y, EDITOR.slots_for_blocks[Int(EDITOR.radio_parent_slots_blocks.actual_child.wert)])
						End If
						
						
					Case EDITOR.radio_block_set' ************** SET now PAINT
						MOUSE.typ = 2
						
						If EMEGUI.m_down_1 Then
							
							GAME.world.act_level.copy_slot_into_block(EDITOR.block_over_x, EDITOR.block_over_y, EDITOR.slots_for_blocks[Int(EDITOR.radio_parent_slots_blocks.actual_child.wert)])
							
						End If
						
						If EMEGUI.m_down_2 Then
							MOUSE.typ = 3
							
							GAME.world.act_level.copy_block_into_slot(EDITOR.block_over_x, EDITOR.block_over_y, EDITOR.slots_for_blocks[Int(EDITOR.radio_parent_slots_blocks.actual_child.wert)])
						End If
						
					Case EDITOR.radio_block_copy' **************** COPY
						MOUSE.typ = 4
						
						If EMEGUI.m_hit_1 Then'select 1
							
							EDITOR.block_selected_x1 = EDITOR.block_over_x
							EDITOR.block_selected_y1 = EDITOR.block_over_y
							
						End If
						
						If EMEGUI.m_hit_2 Then'select 2
							
							EDITOR.block_selected_x2 = EDITOR.block_over_x
							EDITOR.block_selected_y2 = EDITOR.block_over_y
							
						End If
						
						If KeyHit(key_c) Then'copy !
							Local slot:TLevel_Slot = EDITOR.slots_for_levels[Int(EDITOR.radio_parent_slots_levels.actual_child.wert)]
							
							slot.level = GAME.world.act_level.copy("SLOT_" + slot.number, EDITOR.block_selected_x1, EDITOR.block_selected_y1, EDITOR.block_selected_x2, EDITOR.block_selected_y2)
						End If
						
					Case EDITOR.radio_block_paste' ****************** paste
						Local slot:TLevel_Slot = EDITOR.slots_for_levels[Int(EDITOR.radio_parent_slots_levels.actual_child.wert)]
						
						
						If slot.level <> Null Then
							MOUSE.typ = 7
							
							If EMEGUI.m_hit_1 Then
								slot.level.paste(GAME.world.act_level, EDITOR.block_over_x, EDITOR.block_over_y)
							End If
							
						Else
							MOUSE.typ = 6
						End If
						
				End Select
			End If
			
			If EMEGUI.m_down_3 Then' grab map and move it
					GAME.world.act_level.ansicht_ziel_x:+ EMEGUI.m_x_speed
					GAME.world.act_level.ansicht_ziel_y:+ EMEGUI.m_y_speed
					MOUSE.typ = 1
			End If
			
			GAME.world.act_level.render_key_movement()'move map with keys
		Else
			MOUSE.typ = 0
		End If
	End Function
	
	Function draw_selected_fields_and_co()
		
		'DRAW LEVEL SLOT PASTE FIELD
		If EDITOR.radio_parent_block_object.actual_child = EDITOR.radio_child_block Then
			If EDITOR.radio_block_parent.actual_child = EDITOR.radio_block_paste Then
				
				EDITOR.slots_for_levels[Int(EDITOR.radio_parent_slots_levels.actual_child.wert)].draw_paste_field()
				
			End If
		End If
		
		'DRAW SELECTED FIELD
		If EDITOR.radio_parent_block_object.actual_child = EDITOR.radio_child_block Then
			If EDITOR.radio_block_parent.actual_child = EDITOR.radio_block_copy Then
				
				EDITOR.draw_selected_field()
				
			End If
		End If
		
		If EDITOR.radio_parent_block_object.actual_child = EDITOR.radio_child_block Then
			'DRAW EDITOR mouse over block
			SetColor 255,255,255
			DrawImage EDITOR.block_over_image, EDITOR.block_over_x*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, EDITOR.block_over_y*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y
			DrawText "x= " + EDITOR.block_over_x, 2 + EDITOR.block_over_x*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, 2 + EDITOR.block_over_y*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y
			DrawText "y= " + EDITOR.block_over_y, 2 + EDITOR.block_over_x*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_x, 25 + EDITOR.block_over_y*GAME.world.block_image_manager.image_side + GAME.world.act_level.ansicht_act_y
		End If
	End Function
	
	Global object_list:TList
	
	Global object_select_list:TList
	
	Global object_select_x1:Int
	Global object_select_x2:Int
	Global object_select_y1:Int
	Global object_select_y2:Int
	
	Global object_select_status:Int'0= off,1=start, 2=on,3=end
	'0-> no change
	'1-> empty
	'2-> empty + fill constantly
	'3-> fill
	
	Global object_selected:TObject
	
	Global object_mouse_over:TObject
	
	Global object_list_start_drawing:Int = 0
	
	Global kill_object_image:TImage
	
	Function init_objects()
		EDITOR.object_list = New TList
		EDITOR.object_select_list = New TList
		EDITOR.kill_object_image = LoadImage("gfx\kill_object.png")
	End Function
	
	Function draw_selected()
		If EDITOR.object_mouse_over <> Null And EDITOR.object_mouse_over <> EDITOR.object_selected And Not EDITOR.object_select_list.contains(EDITOR.object_mouse_over) Then
			EDITOR.object_mouse_over.draw_selected(2)
		End If
		'EDITOR.object_mouse_over = Null'mouse_over zurücksetzen
		
		If EDITOR.object_selected <> Null Then
			EDITOR.object_selected.draw_selected(1)
		End If
		
		For Local o:TObject = EachIn EDITOR.object_select_list
			If o <> EDITOR.object_selected Then o.draw_selected(3)
			'select3
		Next
		
		If EDITOR.radio_parent_block_object.actual_child = EDITOR.radio_child_object Then
			
			If KeyDown(key_lcontrol) Then
				EDITOR.object_select_x2 = EMEGUI.m_x-GAME.world.act_level.ansicht_act_x
				EDITOR.object_select_y2 = EMEGUI.m_y-GAME.world.act_level.ansicht_act_y
			End If
			
			If EDITOR.object_select_status=0 And EDITOR.object_select_list.count()>0 Then
				If EMEGUI.m_down_2 Then
					'move list!
					Local x1:Int = EDITOR.object_select_x1
					Local y1:Int = EDITOR.object_select_y1
					Local x2:Int = EDITOR.object_select_x2
					Local y2:Int = EDITOR.object_select_y2
					
					If x1 > x2 Then
						Local xx:Int=x1
						x1 = x2
						x2 = xx
					End If
					
					If y1 > y2 Then
						Local yy:Int=y1
						y1 = y2
						y2 = yy
					End If
					
					Local dx:Int = EMEGUI.m_x-GAME.world.act_level.ansicht_act_x-x1
					Local dy:Int = EMEGUI.m_y-GAME.world.act_level.ansicht_act_y-y1
					
					EDITOR.object_select_x1:+dx
					EDITOR.object_select_x2:+dx
					EDITOR.object_select_y1:+dy
					EDITOR.object_select_y2:+dy
					
					For Local o:TObject = EachIn EDITOR.object_select_list
						o.x:+dx
						o.y:+dy
					Next
				End If
			End If
			
			
			
			Select EDITOR.object_select_status
				Case 0
					If KeyDown(key_lcontrol) Then
						Print "start"
						EDITOR.object_select_status = 1
						
						EDITOR.object_select_list = New TList
						
						EDITOR.object_select_x1 = EMEGUI.m_x-GAME.world.act_level.ansicht_act_x
						EDITOR.object_select_y1 = EMEGUI.m_y-GAME.world.act_level.ansicht_act_y
					End If
				Case 1
					EDITOR.object_select_status = 2
					
					EDITOR.object_select_list = New TList
					
					EDITOR.object_selected = Null
					
				Case 2
					EDITOR.object_select_list = New TList
					
					If Not KeyDown(key_lcontrol) Then
						EDITOR.object_select_status = 3
						Print "end"
					End If
					
					EDITOR.object_selected = Null
				Case 3
					EDITOR.object_select_status = 0
					
					If EDITOR.object_select_list.count() = 1 Then
						For Local o:TObject = EachIn EDITOR.object_select_list
							EDITOR.object_selected = o
						Next
						EDITOR.object_select_list = New TList
					Else
						EDITOR.object_selected = Null
					End If
			End Select
			
			If EDITOR.object_select_status > 0 Or EDITOR.object_select_list.count()>0 Then
				Local x1:Int = EDITOR.object_select_x1
				Local y1:Int = EDITOR.object_select_y1
				Local x2:Int = EDITOR.object_select_x2
				Local y2:Int = EDITOR.object_select_y2
				
				If x1 > x2 Then
					Local xx:Int=x1
					x1 = x2
					x2 = xx
				End If
				
				If y1 > y2 Then
					Local yy:Int=y1
					y1 = y2
					y2 = yy
				End If
				
				SetColor 0,100,0
				SetAlpha 0.3
				
				DrawRect x1+GAME.world.act_level.ansicht_act_x,y1+GAME.world.act_level.ansicht_act_y,x2-x1,y2-y1
				
				SetAlpha 0.9
				
				DrawRect x1+GAME.world.act_level.ansicht_act_x,y1+GAME.world.act_level.ansicht_act_y,2,y2-y1
				DrawRect x1+GAME.world.act_level.ansicht_act_x,y1+GAME.world.act_level.ansicht_act_y,x2-x1,2
				
				DrawRect x2+GAME.world.act_level.ansicht_act_x,y1+GAME.world.act_level.ansicht_act_y,2,y2-y1
				DrawRect x1+GAME.world.act_level.ansicht_act_x,y2+GAME.world.act_level.ansicht_act_y,x2-x1,2
				
				
				
				SetAlpha 1
			End If
		Else
			EDITOR.object_select_status = 0
		End If
		
		
	End Function
	
	Function remove_object(o:TObject)
		If EDITOR.object_list.contains(o) Then
			EDITOR.object_list.remove(o)
		End If
		
		If EDITOR.object_select_list.contains(o) Then
			EDITOR.object_select_list.remove(o)
		End If
		
		If EDITOR.object_selected = o Then
			EDITOR.object_selected = Null
		End If
		
		If EDITOR.object_mouse_over = o Then
			EDITOR.object_mouse_over = Null
		End If
	End Function
	
	
	Function render_draw_bottom()
		
		If EDITOR.radio_parent_block_object.actual_child = EDITOR.radio_child_block Then
		Else
			'---------------- player §§§
			SetColor 100,255,100
			DrawRect 10, 610, 90, 25
			
			SetColor 0,0,0
			If EMEGUI.m_x > 10 And EMEGUI.m_y > 610 And EMEGUI.m_x < (10 + 90) And EMEGUI.m_y < (610 + 25) Then
				SetColor 255,0,0
				
				If EMEGUI.m_hit_1 Then
					Local o:TObject = TPLAYER.Create(400 - GAME.world.act_level.ansicht_act_x, 300 - GAME.world.act_level.ansicht_act_y)
					GAME.world.act_level.add_object(o)
					EDITOR.object_selected = o
				End If
			End If
			
			DrawText "[1] PLAYER", 10 + 5, 610 + 5
			
			If KeyHit(key_1) And EMEGUI.m_x<800 Then'create player
				Local o:TObject = TPLAYER.Create(400 - GAME.world.act_level.ansicht_act_x, 300 - GAME.world.act_level.ansicht_act_y)
				GAME.world.act_level.add_object(o)
				EDITOR.object_selected = o
			End If
			
			'---------------- box §§§
			SetColor 100,255,100
			DrawRect 10, 645, 90, 25
			
			SetColor 0,0,0
			If EMEGUI.m_x > 10 And EMEGUI.m_y > 645 And EMEGUI.m_x < (10 + 90) And EMEGUI.m_y < (645 + 25) Then
				SetColor 255,0,0
				
				If EMEGUI.m_hit_1 Then
					Local o:TObject = TBox.Create(400 - GAME.world.act_level.ansicht_act_x, 300 - GAME.world.act_level.ansicht_act_y, 0, 3, 0)
					GAME.world.act_level.add_object(o)
					EDITOR.object_selected = o
				End If
			End If
			
			DrawText "[2] Box", 10 + 5, 645 + 5
			
			If KeyHit(key_2) And EMEGUI.m_x<800 Then'create box
				Local o:TObject = TBox.Create(400 - GAME.world.act_level.ansicht_act_x, 300 - GAME.world.act_level.ansicht_act_y, 0, 3, 0)
				GAME.world.act_level.add_object(o)
				EDITOR.object_selected = o
			End If
			
			'---------------- burnable box §§§
			SetColor 100,255,100
			DrawRect 110, 645, 190, 25
			
			SetColor 0,0,0
			If EMEGUI.m_x > 110 And EMEGUI.m_y > 645 And EMEGUI.m_x < (110 + 190) And EMEGUI.m_y < (645 + 25) Then
				SetColor 255,0,0
				
				If EMEGUI.m_hit_1 Then
					Local o:TObject = TBox_Burnable.Create(400 - GAME.world.act_level.ansicht_act_x, 300 - GAME.world.act_level.ansicht_act_y, 0, 3, 0)
					GAME.world.act_level.add_object(o)
					EDITOR.object_selected = o
				End If
			End If
			
			DrawText "[3] burnable Box", 110 + 5, 645 + 5
			
			If KeyHit(key_3) And EMEGUI.m_x<800 Then'create burnable box
				Local o:TObject = TBox_Burnable.Create(400 - GAME.world.act_level.ansicht_act_x, 300 - GAME.world.act_level.ansicht_act_y, 0, 3, 0)
				GAME.world.act_level.add_object(o)
				EDITOR.object_selected = o
			End If
			
			
			'---------------- stone box §§§
			SetColor 100,255,100
			DrawRect 310, 610, 190, 25
			
			SetColor 0,0,0
			If EMEGUI.m_x > 310 And EMEGUI.m_y > 610 And EMEGUI.m_x < (310 + 190) And EMEGUI.m_y < (610 + 25) Then
				SetColor 255,0,0
				
				If EMEGUI.m_hit_1 Then
					Local o:TObject = TBox_Stone.Create(400 - GAME.world.act_level.ansicht_act_x, 300 - GAME.world.act_level.ansicht_act_y, 0, 3, 0)
					GAME.world.act_level.add_object(o)
					EDITOR.object_selected = o
				End If
			End If
			
			DrawText "[4] stone Box", 310 + 5, 610 + 5
			
			If KeyHit(key_4) And EMEGUI.m_x<800 Then'create burnable box
				Local o:TObject = TBox_Stone.Create(400 - GAME.world.act_level.ansicht_act_x, 300 - GAME.world.act_level.ansicht_act_y, 0, 3, 0)
				GAME.world.act_level.add_object(o)
				EDITOR.object_selected = o
			End If
			
			'---------------- Fire Bird  §§§
			SetColor 100,255,100
			DrawRect 510, 610, 190, 25
			
			SetColor 0,0,0
			If EMEGUI.m_x > 510 And EMEGUI.m_y > 610 And EMEGUI.m_x < (510 + 190) And EMEGUI.m_y < (610 + 25) Then
				SetColor 255,0,0
				
				If EMEGUI.m_hit_1 Then
					Local o:TObject = TFireBird.Create(400 - GAME.world.act_level.ansicht_act_x, 300 - GAME.world.act_level.ansicht_act_y)
					GAME.world.act_level.add_object(o)
					EDITOR.object_selected = o
				End If
			End If
			
			DrawText "[5] Fire Bird", 510 + 5, 610 + 5
			
			If KeyHit(key_5) And EMEGUI.m_x<800 Then'create burnable box
				Local o:TObject = TFireBird.Create(400 - GAME.world.act_level.ansicht_act_x, 300 - GAME.world.act_level.ansicht_act_y)
				GAME.world.act_level.add_object(o)
				EDITOR.object_selected = o
			End If
			
			'---------------- door box §§§
			SetColor 100,255,100
			DrawRect 310, 645, 190, 25
			
			SetColor 0,0,0
			If EMEGUI.m_x > 310 And EMEGUI.m_y > 645 And EMEGUI.m_x < (310 + 190) And EMEGUI.m_y < (645 + 25) Then
				SetColor 255,0,0
				
				If EMEGUI.m_hit_1 Then
					Local o:TObject = TBox_Door.Create(400 - GAME.world.act_level.ansicht_act_x, 300 - GAME.world.act_level.ansicht_act_y, 0, 3, 0)
					GAME.world.act_level.add_object(o)
					EDITOR.object_selected = o
				End If
			End If
			
			DrawText "[6] Door Box", 310 + 5, 645 + 5
			
			If KeyHit(key_6) And EMEGUI.m_x<800 Then'create burnable box
				Local o:TObject = TBox_Door.Create(400 - GAME.world.act_level.ansicht_act_x, 300 - GAME.world.act_level.ansicht_act_y, 0, 3, 0)
				GAME.world.act_level.add_object(o)
				EDITOR.object_selected = o
			End If
			
			
			
			'---------------- key box §§§
			SetColor 100,255,100
			DrawRect 510, 645, 190, 25
			
			SetColor 0,0,0
			If EMEGUI.m_x > 510 And EMEGUI.m_y > 645 And EMEGUI.m_x < (510 + 190) And EMEGUI.m_y < (645 + 25) Then
				SetColor 255,0,0
				
				If EMEGUI.m_hit_1 Then
					Local o:TObject = TBox_Key.Create(400 - GAME.world.act_level.ansicht_act_x, 300 - GAME.world.act_level.ansicht_act_y, 0, 1, 0)
					GAME.world.act_level.add_object(o)
					EDITOR.object_selected = o
				End If
			End If
			
			DrawText "[7] Key Box", 510 + 5, 645 + 5
			
			If KeyHit(key_7) And EMEGUI.m_x<800 Then'create burnable box
				Local o:TObject = TBox_Key.Create(400 - GAME.world.act_level.ansicht_act_x, 300 - GAME.world.act_level.ansicht_act_y, 0, 1, 0)
				GAME.world.act_level.add_object(o)
				EDITOR.object_selected = o
			End If
			
			
			'---------------- badie §§§
			SetColor 100,255,100
			DrawRect 110, 610, 90, 25
			
			SetColor 0,0,0
			If EMEGUI.m_x > 110 And EMEGUI.m_y > 610 And EMEGUI.m_x < (110 + 90) And EMEGUI.m_y < (610 + 25) Then
				SetColor 255,0,0
				
				If EMEGUI.m_hit_1 Then
					Local o:TObject = TBADIE.Create(400 - GAME.world.act_level.ansicht_act_x, 300 - GAME.world.act_level.ansicht_act_y)
					GAME.world.act_level.add_object(o)
					EDITOR.object_selected = o
				End If
			End If
			
			DrawText "[8] BADIE", 110 + 5, 610 + 5
			
			If KeyHit(key_8) And EMEGUI.m_x<800 Then'create player
				Local o:TObject = TBADIE.Create(400 - GAME.world.act_level.ansicht_act_x, 300 - GAME.world.act_level.ansicht_act_y)
				GAME.world.act_level.add_object(o)
				EDITOR.object_selected = o
			End If
			
			
			SetColor 255,255,255
			DrawText "[C] copy selected | [delete] delete selected",10, 675
			
			
			If KeyHit(key_c) Then'create box
				If EDITOR.object_selected <> Null And EMEGUI.m_x<800 Then
					Local o:TObject = EDITOR.object_selected.copy()
					GAME.world.act_level.add_object(o)
					EDITOR.object_selected = o
				End If
				
				If EDITOR.object_select_list.count()>0 Then
					For Local o:TObject = EachIn EDITOR.object_select_list
						Local o2:TObject = o.copy()
						GAME.world.act_level.add_object(o2)
					Next
				End If
			End If
			
		End If
	End Function
End Type


'########################################################################################
'###########################                   ##########################################
'###########################     MINIMAP       ##########################################
'###########################                   ##########################################
'########################################################################################

Type MINIMAP
	
	Global scale:Float = -1.0
	
	Function show()
		
		If KeyDown(key_m) Then
			
			If MINIMAP.scale <= 0 Then
				MINIMAP.scale = 1200.0 / Float(GAME.world.act_level.table_x * GAME.world.block_image_manager.image_side)
				
				If 700.0 / Float(GAME.world.act_level.table_y * GAME.world.block_image_manager.image_side) < MINIMAP.scale Then
					MINIMAP.scale = 700.0 / Float(GAME.world.act_level.table_y * GAME.world.block_image_manager.image_side)
				End If
			End If
			
			SetViewport(0,0,1200,700)
			
			While KeyDown(key_m)
				EMEGUI.render_events()'mouse and co.
				
				GAME.world.act_level.render()'RENDER LEVEL
				
				MINIMAP.scale:*(1.01^Float(EMEGUI.m_z_speed))'render scale
				
				SetClsColor 100,0,0
				Cls
				SetColor 0,0,0
				DrawRect 0,0,2+MINIMAP.scale *Float(GAME.world.act_level.table_x*GAME.world.block_image_manager.image_side),2+ MINIMAP.scale *Float(GAME.world.act_level.table_y*GAME.world.block_image_manager.image_side)
				
				
				If EMEGUI.m_down_1 Then'jump to new location
					GAME.world.act_level.ansicht_ziel_x = -Float(EMEGUI.m_x)/MINIMAP.scale + 400.0
					GAME.world.act_level.ansicht_ziel_y = -Float(EMEGUI.m_y)/MINIMAP.scale + 300.0
				End If
				
				
				SetColor 255,255,255
				
				For Local x:Int = 0 To GAME.world.act_level.table_x-1'draw minimap
					For Local y:Int = 0 To GAME.world.act_level.table_y-1
						If EDITOR.check_draw_bg.wert = 1 Then GAME.world.act_level.table[x, y].bg_draw(MINIMAP.scale *Float(x*GAME.world.block_image_manager.image_side), MINIMAP.scale *Float(y*GAME.world.block_image_manager.image_side), MINIMAP.scale)
						If EDITOR.check_draw_fg.wert = 1 Then GAME.world.act_level.table[x, y].fg_draw(MINIMAP.scale *Float(x*GAME.world.block_image_manager.image_side), MINIMAP.scale *Float(y*GAME.world.block_image_manager.image_side), MINIMAP.scale)
						If EDITOR.check_draw_collision.wert = 1 Then GAME.world.act_level.table[x, y].collision_draw(MINIMAP.scale *Float(x*GAME.world.block_image_manager.image_side), MINIMAP.scale *Float(y*GAME.world.block_image_manager.image_side), MINIMAP.scale)
					Next
				Next
				
				SetColor 255,255,255'draw rect of act view
				
				DrawRect MINIMAP.scale *Float(-GAME.world.act_level.ansicht_act_x), MINIMAP.scale *Float(-GAME.world.act_level.ansicht_act_y), MINIMAP.scale *Float(800.0), 1
				DrawRect MINIMAP.scale *Float(-GAME.world.act_level.ansicht_act_x), MINIMAP.scale *Float(-GAME.world.act_level.ansicht_act_y), 1, MINIMAP.scale *Float(600.0)
				DrawRect MINIMAP.scale *Float(-GAME.world.act_level.ansicht_act_x), MINIMAP.scale *Float(-GAME.world.act_level.ansicht_act_y) + MINIMAP.scale *Float(600.0)-1, MINIMAP.scale *Float(800.0), 1
				DrawRect MINIMAP.scale *Float(-GAME.world.act_level.ansicht_act_x) + MINIMAP.scale *Float(800.0)-1, MINIMAP.scale *Float(-GAME.world.act_level.ansicht_act_y), 1, MINIMAP.scale *Float(600.0)
				
				MOUSE.typ = 0
				
				MOUSE.draw()
				
				Flip
			Wend
		End If
		
	End Function
End Type

'########################################################################################
'###########################                   ##########################################
'###########################     INIT PAGE     ##########################################
'###########################                   ##########################################
'########################################################################################

Type INIT_PAGE
	'NEW
	Global new_world_i:GUI_OBJEKT
	Global new_level_i:GUI_OBJEKT
	
	Global new_x_i:GUI_OBJEKT
	Global new_y_i:GUI_OBJEKT
	
	Global new_b:GUI_OBJEKT
	
	'LOAD
	Global load_world_i:GUI_OBJEKT
	Global load_level_i:GUI_OBJEKT
	
	Global load_b:GUI_OBJEKT
	
	Global load_objects:GUI_CHECK
	Global load_old:GUI_CHECK
	
	Function init()
		'NEW
		INIT_PAGE.new_world_i=GUI_INPUT.Create(10,200,"testiania",300)
		INIT_PAGE.new_level_i=GUI_INPUT.Create(400,200,"l1",300)
		
		INIT_PAGE.new_x_i=GUI_INPUT.Create(10,300,"100",300)
		INIT_PAGE.new_y_i=GUI_INPUT.Create(400,300,"100",300)
		
		INIT_PAGE.new_b=GUI_BUTTON.Create(10,400,"CREATE",100)
		
		'LOAD
		INIT_PAGE.load_world_i=GUI_INPUT.Create(10,500,"testiania",300)
		INIT_PAGE.load_level_i=GUI_INPUT.Create(400,500,"l1",300)
		
		INIT_PAGE.load_b=GUI_BUTTON.Create(100,550,"LOAD",100)
		
		INIT_PAGE.load_objects = GUI_CHECK.Create(100, 600, 1)
		INIT_PAGE.load_old = GUI_CHECK.Create(100, 620, 0)
	End Function
	
	Function render()
		INIT_PAGE.new_world_i.render()
		INIT_PAGE.new_level_i.render()
		INIT_PAGE.new_x_i.render()
		INIT_PAGE.new_y_i.render()
		INIT_PAGE.new_b.render()
		
		INIT_PAGE.load_world_i.render()
		INIT_PAGE.load_level_i.render()
		INIT_PAGE.load_b.render()
		INIT_PAGE.load_objects.render()
		INIT_PAGE.load_old.render()
	End Function
	
	
	Function draw()
		'-------- NEW
		SetColor 0,0,0
		DrawText "WORLD",10,170
		DrawText "LEVEL",400,170
		INIT_PAGE.new_world_i.draw()
		INIT_PAGE.new_level_i.draw()
		
		If FileType("Worlds\" + GUI_INPUT(INIT_PAGE.new_world_i).content + "\Levels\" + GUI_INPUT(INIT_PAGE.new_level_i).content) Then
			SetColor 50,50,0
			DrawRect 750,200,200,50
			SetColor 255,255,0
			DrawText "OVERWRITE?",755,205
		Else
			SetColor 0,50,0
			DrawRect 750,200,200,50
			SetColor 0,255,0
			DrawText "CREATE",755,205
		End If
		
		SetColor 0,0,0
		DrawText "X",10,270
		DrawText "Y",400,270
		INIT_PAGE.new_x_i.draw()
		INIT_PAGE.new_y_i.draw()
		
		Local txt:String
		Local ok:Int
		If Int(GUI_INPUT(INIT_PAGE.new_x_i).content) > 10 Then
			If Int(GUI_INPUT(INIT_PAGE.new_x_i).content) < 200 Then
				'ok
				txt = "OK"
				ok = 1
			Else
				'too big
				txt = "TOO BIG"
				ok = 0
			End If
		Else
			'too small
			txt = "TOO SMALL"
			ok = 0
		End If
		
		If ok = 0 Then
			SetColor 50,0,0
			DrawRect 10,350,100,30
			SetColor 255,0,0
			DrawText txt, 12,352
		Else
			SetColor 0,50,0
			DrawRect 10,350,100,30
			SetColor 0,255,0
			DrawText txt, 12,352
		End If
		
		If Int(GUI_INPUT(INIT_PAGE.new_y_i).content) > 10 Then
			If Int(GUI_INPUT(INIT_PAGE.new_y_i).content) < 200 Then
				'ok
				txt = "OK"
				ok = 1
			Else
				'too big
				txt = "TOO BIG"
				ok = 0
			End If
		Else
			'too small
			txt = "TOO SMALL"
			ok = 0
		End If
		
		If ok = 0 Then
			SetColor 50,0,0
			DrawRect 400,350,100,30
			SetColor 255,0,0
			DrawText txt, 402,352
		Else
			SetColor 0,50,0
			DrawRect 400,350,100,30
			SetColor 0,255,0
			DrawText txt, 402,352
		End If
		
		INIT_PAGE.new_b.draw()
		
		'------------ TRENN - STRICH
		SetColor 0,0,0
		DrawRect 0,450,1000,2
		
		'------------ LOAD
		SetColor 0,0,0
		DrawText "WORLD",10,470
		DrawText "LEVEL",400,470
		INIT_PAGE.load_world_i.draw()
		INIT_PAGE.load_level_i.draw()
		
		If FileType("Worlds\" + GUI_INPUT(INIT_PAGE.load_world_i).content + "\Levels\" + GUI_INPUT(INIT_PAGE.load_level_i).content) Then
			SetColor 0,50,0
			DrawRect 750,500,200,50
			SetColor 0,255,0
			DrawText "EXISTS",755,505
		Else
			SetColor 50,0,0
			DrawRect 750,500,200,50
			SetColor 255,0,0
			DrawText "NOT FOUND",755,505
		End If
		
		INIT_PAGE.load_b.draw()
		
		INIT_PAGE.load_objects.draw()
		SetColor 0,0,0
		DrawText "Load Objects", 120,600
		INIT_PAGE.load_old.draw()
		SetColor 0,0,0
		DrawText "Load old versions", 120,620
	End Function
	
	Function get_world_and_level()
		
		SetClsColor 150,150,150
		
		Repeat
			'-------------------- RENDER ----------------
			EMEGUI.render_events()
			
			INIT_PAGE.render()
			
			'--------------------- DRAW -----------------
			
			INIT_PAGE.draw()
			
			MOUSE.draw()
			Flip
			Cls
		Until KeyHit(key_escape) Or AppTerminate() Or GUI_BUTTON(INIT_PAGE.new_b).pressed = 3 Or GUI_BUTTON(INIT_PAGE.load_b).pressed = 3
		
		
		
		If Not (GUI_BUTTON(INIT_PAGE.new_b).pressed = 3 Or GUI_BUTTON(INIT_PAGE.load_b).pressed = 3) Then
			End
		End If
		
		
		If GUI_BUTTON(INIT_PAGE.new_b).pressed = 3 Then
			GUI_BUTTON(INIT_PAGE.new_b).pressed = 0
			'NEW
			GAME.load_world(GUI_INPUT(INIT_PAGE.new_world_i).content)
			
			If GAME.world = Null Then
				GAME_ERROR_HANDLER.error("INIT_PAGE->get_world_and_level() world is not loaded!")
				Return'laden abbrechen
			End If
			
			init_before_level()
			
			GAME.world.act_level = TLevel.Create(GAME.world, GUI_INPUT(INIT_PAGE.new_level_i).content, Int(GUI_INPUT(INIT_PAGE.new_x_i).content), Int(GUI_INPUT(INIT_PAGE.new_y_i).content), INFO.get_computer_name())
			
			GAME.world.act_level.save(True)
			
			GAME.world.act_level = TLevel.Load(GAME.world, GUI_INPUT(INIT_PAGE.new_level_i).content, False, True)
		Else
			GUI_BUTTON(INIT_PAGE.load_b).pressed = 0
			'LOAD
			GAME.load_world(GUI_INPUT(INIT_PAGE.load_world_i).content)
			
			If GAME.world = Null Then
				GAME_ERROR_HANDLER.error("INIT_PAGE->get_world_and_level() world is not loaded!")
				Return'laden abbrechen
			End If
			
			init_before_level()
			
			GAME.world.act_level = TLevel.Load(GAME.world, GUI_INPUT(INIT_PAGE.load_level_i).content, GUI_CHECK(INIT_PAGE.load_objects).wert, GUI_CHECK(INIT_PAGE.load_old).wert)'True)
		End If
		
	End Function
End Type

'###################################################################################

'###################################################################################

'--------------------------- END OF TYPES ------------------------------------------

'###################################################################################

'###################################################################################

Function init_before_world()
	'-------------------------- GRAPHICS -----------------------------------
	AppTitle = "LEVEL-EDITOR  #  Version: " + VERSION + ", C: " + VERSION_COMPATIBILITY
	Graphics 1200,700
	SetBlend ALPHABLEND
	
	MOUSE.init()
	
	EDITOR.init_objects()
	
	TBox.init_before_level()
	TBox_Burnable.init_before_level()
	TBox_Stone.init_before_level()
	TBox_Door.init_before_level()
	TBox_Key.init_before_level()
	
	
	INIT_PAGE.init()
End Function

Function init_before_level()
	
	EDITOR.init()
	
	TPLAYER.init()
	TBADIE.init()
	TFireBird.init()
	
	TBox.init_after_level()
	TBox_Burnable.init_after_level()
	TBox_Stone.init_after_level()
	TBox_Door.init_after_level()
	TBox_Key.init_after_level()
	
	TBox_Renderer_Collision.init()
	TBox_Renderer_Sign.init()
	TBox_Renderer_Door.init()
	TBox_Renderer_Key.init()
	TBox_Renderer_Teleporter.init()
	TBox_Renderer_TLamp.init()
	TBox_Renderer_Dialogue.init()
	TBox_Renderer_Dialogue_Changer.init()
	TBox_Renderer_Image.init()
	TBox_Renderer_Collision_Mode_Sensitive.init()
	TBox_Renderer_Music.init()
	TBox_Renderer_MusicChanger.init()
	TBox_Renderer_Sound.init()
	TBox_Renderer_SoundRepeater.init()
	TBox_Renderer_LightHandler.init()
	TBox_Renderer_Sequence.init()
	TBox_Renderer_Jumper.init()
	
	
	TBlock_Group.init()
End Function


Function init_after_level()
	
End Function




init_before_world()

While (GAME.world = Null Or GAME.world.act_level = Null)
	INIT_PAGE.get_world_and_level()
	
	If (GAME.world = Null Or GAME.world.act_level = Null) Then
		GAME_ERROR_HANDLER.error("INIT_PAGE->get_world_and_level() level is not loaded!")
	End If
Wend

init_after_level()

'##########################################################################################
'################################       MAIN LOOP          ################################
'##########################################################################################

Repeat
	MINIMAP.show()'SHOW MINIMAP ?
	
	'############## RENDER ###############
	
	If EMEGUI.m_x<800 Then
		EMEGUI.focus = Null
	End If
	
	EMEGUI.render_events()'RENDER mouse and co.
	
	GAME.world.act_level.render()'RENDER LEVEL
	
	EDITOR.render()'RENDER EDITOR
	
	GAME.world.act_level.render_chunks()
	
	If KeyHit(key_f12) Then
		Print "start updating block groups"
		GAME.world.act_level.update_block_groups()
		Print "end updating block groups"
	End If
	
	If KeyHit(key_f11) Then
		Print "start updating block groups REVERSE"
		GAME.world.act_level.update_block_groups_reverse()
		Print "end updating block groups REVERSE"
	End If
	
	
	'################ DRAW ###############
	
	'------------------------------------- MAP -------------------------------------
	SetViewport(0,0,800,600)
	SetClsColor 0,0,0
	Cls
	SetColor 255,255,255
	
	If EDITOR.check_draw_objects.wert = 1 Then GAME.world.act_level.draw_chunks(0)
	If EDITOR.check_draw_bg.wert = 1 Then GAME.world.act_level.draw_bg()' DRAW LEVEL BG
	If EDITOR.check_draw_objects.wert = 1 Then GAME.world.act_level.draw_chunks(1)
	If EDITOR.check_draw_objects.wert = 1 Then GAME.world.act_level.draw_chunks(2)
	If EDITOR.check_draw_objects.wert = 1 Then GAME.world.act_level.draw_chunks(3)
	If EDITOR.check_draw_fg.wert = 1 Then GAME.world.act_level.draw_fg()' DRAW LEVEL FG
	If EDITOR.check_draw_objects.wert = 1 Then GAME.world.act_level.draw_chunks(4)
	
	If EDITOR.check_draw_objects.