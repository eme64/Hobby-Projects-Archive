SuperStrict

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
	Global tile_number:Int = 8
	Global tile_side:Int = 64
	
	Function ini()
		GAME.tiles = New TImage[GAME.tile_number]
		
		For Local i:Int = 0 To GAME.tile_number-1
			GAME.tiles[i] = ImageLoader.Load("tiles\" + i + ".png", GAME.tile_side, GAME.tile_side)
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
	
	'objects
	Field objects:TList
	
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
	
	Function Create:TLevel()
		Local l:TLevel = New TLevel
		
		l.table_x = 31
		l.table_y = 31
		
		l.table = New TBlock[l.table_x, l.table_y]
		
		l.objects = New TList
		
		'fill table
		
		Local data_root:DATA = TLevel.generate_data(l.table_x, l.table_y, l)'New Int[l.table_x, l.table_y]
		Local data:Int[,] = data_root.data
		
		Local blocks:TBlock[] = New TBlock[4]
		
		blocks[0] = TBlock.Create(1, 1, 1, 0)'wall
		blocks[1] = TBlock.Create(0, 0, 2, 0)'room
		blocks[2] = TBlock.Create(0, 0, 3, 0)'corridor
		blocks[3] = TBlock.Create(1, 0, 7, 6)'door
		
		For Local x:Int = 0 To l.table_x-1
			For Local y:Int = 0 To l.table_y-1
				If x = 0 Or x = l.table_x-1 Or y = 0 Or y = l.table_y-1 Then
					l.table[x,y] = blocks[0].copy()'wall
				Else
					l.table[x,y] = blocks[data[x,y]].copy()
					
					Select data[x,y]
						Case 1'room
							l.table[x,y].obj_type = 1
						Case 3'door
							l.table[x,y].obj_type = 2
						Case 4'airlock
							l.table[x,y].obj_type = 3
					End Select
					
					
					If data[x,y]>0 And Rand(0,30) < 1 Then
						TLamp.Create(x*GAME.tile_side + GAME.tile_side/2, y*GAME.tile_side + GAME.tile_side/2,[Rand(200,255),Rand(100,200),Rand(0,100)],TLight.source_normal,l)
					EndIf
				EndIf
				
				
				l.table[x,y].obj_id = data_root.data_n[x,y]
			Next
		Next
		
		'add objects
		
		
		TPlayer.Create(l.table_x*GAME.tile_side/2,l.table_y*GAME.tile_side/2,l)
		
		Rem
		For Local i:Int = 1 To 10
			TLamp.Create(Rand(100, l.table_x*GAME.tile_side-100),Rand(100, l.table_y*GAME.tile_side-100),[Rand(255),Rand(255),Rand(255)],TLight.source_treasure,l)
		Next
		End Rem
		
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
			SetColor 255,255,255
			DrawText KeyboardInput.text, 10,100
			DrawText KeyboardInput.numb, 10,150
			DrawText KeyboardInput.command_to_execute, 10,200
			
			
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
	End Method
	
	Method draw()
		SetClsColor 0,0,0
		Cls
		SetColor 255,255,255
		
		Self.draw_bg()
		
		For Local o:TObject = EachIn Self.objects
			o.draw()
		Next
		
		Self.draw_fg()
		
		' DRAW LIGHTS
		If KeyHit(key_l) Then GAME.level.lights_on = 1-GAME.level.lights_on
		
		SetBlend shadeblend
		SetColor 255,255,255
		If GAME.level.lights_on Then TBuffer.light_mix.draw(0,0)
		SetBlend alphablend
		TBuffer.light_mix.cls_me(Self.brightness_r/255.0,Self.brightness_g/255.0,Self.brightness_b/255.0)
		
		' Tactical overlay - taco
		Self.draw_taco()
	End Method
	
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
				
				table[x,y].block_draw(x*GAME.tile_side + Self.ansicht_act_x, y*GAME.tile_side + Self.ansicht_act_y, table[x,y].bg_image_number)
				
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
				
				table[x,y].block_draw(x*GAME.tile_side + Self.ansicht_act_x, y*GAME.tile_side + Self.ansicht_act_y, table[x,y].fg_image_number)
				
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
				
				table[x,y].block_draw_taco(x*GAME.tile_side + Self.ansicht_act_x, y*GAME.tile_side + Self.ansicht_act_y)
				
			Next
		Next
		
	End Method
	
	Method render_tiles_commands()
		Local cmd:String = KeyboardInput.command_to_execute
		
		If cmd <> "" Then
			Local d:Int = Int(Mid(cmd, 2,-1))
			
			For Local x:Int = 0 To Self.table_x - 1
				For Local y:Int = 0 To Self.table_y - 1
					If table[x,y].obj_type = 2 And table[x,y].obj_id = d Then
						If table[x,y].collision = 1 Then
							table[x,y].collision = 0
							table[x,y].taco_image_number = 5
						Else
							table[x,y].collision = 1
							table[x,y].taco_image_number = 6
						EndIf
					EndIf
				Next
			Next
			
		EndIf
		
		KeyboardInput.command_to_execute = ""
	End Method
	
	Method render_tiles()
		Self.render_tiles_commands()
		
		For Local x:Int = 1 To Self.table_x - 2
			For Local y:Int = 1 To Self.table_y - 2
				'check visibility
				
				If table[x,y].collision = 0 And table[x,y].visible > 0 Then
					If table[x,y].visible = 2 Then
						If table[x+1,y].visible = 0 Then table[x+1,y].visible = 1
						If table[x-1,y].visible = 0 Then table[x-1,y].visible = 1
						If table[x,y+1].visible = 0 Then table[x,y+1].visible = 1
						If table[x,y-1].visible = 0 Then table[x,y-1].visible = 1
					EndIf
					
					table[x,y].visible = 2
				Else
					
				EndIf
				
				
				Rem
				If table[x,y].collision = 0 Then
					If table[x,y].visible = 1 Then
						table[x,y].visible = 2
					ElseIf table[x,y].visible = 0
						If table[x+1,y].visible=2 Or table[x-1,y].visible=2 Or table[x,y+1].visible=2 Or table[x,y-1].visible=2 Then
							table[x,y].visible=1
						EndIf
					EndIf
				EndIf
				End Rem
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
	
	Function generate_data:DATA(dx:Int,dy:Int, l:TLevel, docks:Int = 2)
		Local data:DATA = DATA.Create(dx, dy)
		
		data.add_rooms(l)
		
		Repeat
			For Local d:DATAGEN = EachIn data.list	
				d.run(data)
			Next
		Until data.list.Count() = 0	
		
		'put doors and docks
		data.put_doors()
		data.put_docks(docks)
		
		Return data
	End Function
End Type

Type DATA
	Field data:Int[,]
	Field data_n:Int[,]
	Field x:Int
	Field y:Int
	
	Field list:TList
	
	Function Create:DATA(x:Int, y:Int)
		Local d:DATA = New DATA
		
		d.x = x
		d.y = y	
		
		d.data = New Int[x,y]
		d.data_n = New Int[x,y]
		
		For Local xx:Int = 0 To x-1
			For Local yy:Int = 0 To y-1
				d.data[xx,yy] = 0
			Next	
		Next	
		
		
		d.list = New TList
		
		Return d
	End Function
	
	Method add_rooms(l:TLevel)
		Local amount:Int = x*y/4'/16
		
		Local count:Int = 0
		
		Local count_fail:Int = 0
		
		Local room_counter:Int = 0
		
		Repeat
			' Set data for room
			Local dx:Int = Rand(2,4)*2-1
			Local dy:Int = Rand(2,4)*2-1
			
			Local xx:Int = Rand(0,Self.x/2-4)*2+1
			Local yy:Int = Rand(0,Self.y/2-4)*2+1
			
			' Test room
			
			Local fail:Int = 0
			
			For Local ix:Int = xx To xx + dx-1
				For Local iy:Int = yy To yy + dy-1
					If Not Self.get_free(ix,iy) Then
						fail = 1
						count_fail:+1
						
						If count_fail > 300 Then Return
						
						Exit
					EndIf
				Next
				If fail = 1 Then Exit
			Next
			
			If fail = 1 Then Continue
			
			' Draw Room
			
			count:+1
			
			For Local ix:Int = xx To xx + dx-1
				For Local iy:Int = yy To yy + dy-1
					Self.data[ix,iy] = 1
				Next
			Next
			
			room_counter:+1
			Self.data_n[xx+dx/2,yy+dy/2] = room_counter
			
			
			TBot.Create(GAME.tile_side*(xx+dx/2),GAME.tile_side*(yy+dy/2),l)
			
			' Draw Doors
			
			Local doors:Int = (dx+dy)/2-1
			
			For Local i:Int = 1 To doors
				Local doorx:Int
				Local doory:Int
				
				
				If Rand(0,1) = 0 Then
					' XXX
				
					If Rand(0,1) = 0 Then
						doorx = xx
						doory = yy + Rand(0,dy/2)*2
						
						DATAGEN.Create(Self, doorx, doory, 0)
					Else
						doorx = xx + (dx-1)
						doory = yy + Rand(0,dy/2)*2
						DATAGEN.Create(Self, doorx, doory, 1)
					EndIf
					
				Else
					' YYY
					
					If Rand(0,1) = 0 Then
						doory = yy
						doorx = xx + Rand(0,dx/2)*2
						DATAGEN.Create(Self, doorx, doory, 2)
					Else
						doory = yy + (dy-1)
						doorx = xx + Rand(0,dx/2)*2
						DATAGEN.Create(Self, doorx, doory, 3)
					EndIf
					
				EndIf
				
				'Self.data[doorx,doory] = 2
			Next
			
		Until count = amount
	End Method
	
	Method get_free:Int(x:Int, y:Int)
		
		If x < 0 Then Return 0
		If y < 0 Then Return 0
		If x >= Self.x Then Return 0
		If y >= Self.y Then Return 0
		
		If Self.data[x,y] = 0 Then Return 1 Else Return 0
	End Method
	
	Method put_doors()
		Local counter:Int = 0
		For Local xx:Int = 0 To Self.x-1
			For Local yy: Int = 0 To Self.y-1
				Local i:Int = 0
				If Self.data[xx,yy] = 2 Then' if corridor then
					For Local ix:Int = -1 To 1'scan for room around
						For Local iy:Int = -1 To 1
							If Self.data[xx+ix,yy+iy] = 1 Then i = 1'set flag for door
						Next
					Next
				EndIf
				
				If i=1 Then
					Self.data[xx,yy] = 3'set as door
					counter:+1
					Self.data_n[xx,yy] = counter
				End If
			Next
		Next
	End Method
	
	Method put_docks(n:Int)
		
	End Method
End Type

Type DATAGEN
	Field direction:Int
	
	Field x:Int, y:Int
	
	Function Create:DATAGEN(d:DATA, x:Int,y:Int, direction:Int)
		Local dd:DATAGEN = New DATAGEN
		
		dd.x = x
		dd.y = y
		dd.direction = direction
		
		d.list.addlast(dd)
		
		'd.data[x,y] = 2
		
		Return dd
	End Function
	
	Method run(d:DATA)
		'Print name
		
		d.list.remove(Self)
		
		If d.data[x,y] > 1 Then Return
		
		If d.data[x,y] = 0 Then d.data[x,y] = 2
		
		Select Self.direction
			Case 0'x-
				Select DATAGEN.get(d, x-2, y)
					Case 0
						d.data[x-1,y] = 2
						DATAGEN.Create(d, x-2, y, [0,0,0,2,3][Rand(0,4)])
						If Rand(0,2) = 0 Then DATAGEN.Create(d, x-2, y, [0,2,3][Rand(0,2)])
					Case 2,1
						d.data[x-1,y] = 2
				End Select
				
			Case 1'x+
				Select DATAGEN.get(d, x+2, y)
					Case 0
						d.data[x+1,y] = 2
						DATAGEN.Create(d, x+2, y, [1,1,1,2,3][Rand(0,4)])
						If Rand(0,2) = 0 Then DATAGEN.Create(d, x+2, y, [1,2,3][Rand(0,2)])
					Case 2,1
						d.data[x+1,y] = 2
				End Select
			Case 2'y-
				Select DATAGEN.get(d, x, y-2)
					Case 0
						d.data[x,y-1] = 2
						DATAGEN.Create(d, x, y-2, [2,2,2,0,1][Rand(0,4)])
						If Rand(0,2) = 0 Then DATAGEN.Create(d, x, y-2, [2,0,1][Rand(0,2)])
					Case 2,1
						d.data[x,y-1] = 2
				End Select
			Case 3'y+
				Select DATAGEN.get(d, x, y+2)
					Case 0
						d.data[x,y+1] = 2
						DATAGEN.Create(d, x, y+2, [3,3,3,0,1][Rand(0,4)])
						If Rand(0,2) = 0 Then DATAGEN.Create(d, x, y+2, [3,0,1][Rand(0,2)])
					Case 2,1
						d.data[x,y+1] = 2
				End Select
		End Select
		
	End Method
	
	Function get:Int(d:DATA, x:Int, y:Int)
		
		If x < 0 Then Return -1
		If y < 0 Then Return -1
		If x >= d.x Then Return -1
		If y >= d.y Then Return -1
		
		Return d.data[x,y]
	End Function
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
		
		'background
		b.bg_image_number = Self.bg_image_number
		
		'tactical overview - taco
		b.taco_image_number = Self.taco_image_number
		
		b.obj_type = Self.obj_type
		b.obj_id= Self.obj_id
		Return b
	End Method
	
	'FOREGROUND
	Field fg_image_number:Int
	
	'BACKGROUND
	Field bg_image_number:Int
	
	Method block_draw(x:Float, y:Float, img_n:Int)
		
		SetColor 255,255,255
		Draw_Image GAME.tiles[img_n], x, y, 0
		SetScale 1,1
	End Method
	
	Method block_draw_taco(x:Float, y:Float)
		If visible = 0 Then Return
		
		SetColor 255,255,255
		'DrawRect x+10,y+10,visible*5 ,visible*5
		
		Draw_Image GAME.tiles[Self.taco_image_number], x, y, 0
		SetScale 1,1
		
		If Self.obj_id > 0 Then
			Select Self.obj_type
				Case 1'room
					SetColor 200,200,200
					Local txt:String = "r" + Self.obj_id
					
					Draw_Text txt, x + GAME.tile_side/2 - TextWidth(txt)/2,y + GAME.tile_side/2 - TextHeight(txt)/2
				Case 2'door
					SetColor 0,255,255
					Local txt:String = "d" + Self.obj_id
					
					Draw_Text txt, x + GAME.tile_side/2 - TextWidth(txt)/2,y + GAME.tile_side/2 - TextHeight(txt)/2
				Case 3'airlock
					SetColor 255,0,255
					Local txt:String = "a" + Self.obj_id
					
					Draw_Text txt, x + GAME.tile_side/2 - TextWidth(txt)/2,y + GAME.tile_side/2 - TextHeight(txt)/2
			End Select
		EndIf
	End Method
	
	'Tactical Overlay - taco
	Field taco_image_number:Int
	
	' Objec ID - door, room, airlock, ...
	Field obj_id:Int
	Field obj_type:Int
	
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
			
			'muss +vx haben, damit keine stÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¶runen wenn genau auf ecke des blockes fÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂÃÂ¤llt
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
	
	Field hit:Int
	Field hit_max:Int = 10
	
	Field hit_angle:Float = 60
	Field hit_distance:Float = 80'from centre of obj
	
	Method draw_hit()
		If Self.hit > 0 Then
			Self.hit:-1
			
			Local a:Float[] = [0.0,0.0]
			
			For Local i:Int = Self.hit To Self.hit_max
				Local ww:Float = -hit_angle + Self.w + i*2*hit_angle/hit_max
				a:+[Float(Cos(ww)*hit_distance),Float(Sin(ww)*hit_distance)]
			Next
			
			SetAlpha 0.5
			SetColor 255,255,255
			Draw_Poly(a,Self.x,Self.y)
			SetAlpha 1
			
			
		EndIf
	End Method
	
	Method do_hit()
		If Not Self.hit > 0 Then
			Self.hit = Self.hit_max
			
			For Local b:TBot = EachIn GAME.level.objects
				If ((b.x - Self.x)^2 + (b.y - Self.y)^2) < (b.r + Self.hit_distance)^2 Then
					b.kill()
				EndIf
			Next
			
		EndIf
	End Method
End Type

'########################################################################################
'###########################        #####################################################
'########################### PLAYER #####################################################
'###########################        #####################################################
'########################################################################################

Type TPlayer Extends TMob
	
	Global image:TImage
	
	Field light:TLight
	
	Field level:TLevel
	
	Function Create:TPlayer(x:Float,y:Float,l:TLevel)
		Local p:TPlayer = New TPlayer
		
		p.r = 20
		
		p.x = x
		p.y = y
		
		l.objects.addlast(p)
		
		p.light = TLight.Create(TLight.source_big,0,0)
		p.light.set_color(255,150,100)
		
		p.level = l
		
		Return p
	End Function
	
	Function ini()
		TPlayer.image = ImageLoader.Load("gfx\player.png",50,50)
		MidHandleImage TPlayer.image
	End Function
	
	Method render()
		Super.render()
		
		GAME.level.ansicht_ziel_x = - Self.x + Graphics_Handler.x/2
		GAME.level.ansicht_ziel_y = - Self.y + Graphics_Handler.y/2
		
		
		Self.w = ATan2(MouseY() - Self.y - GAME.level.ansicht_act_y, MouseX() - Self.x - GAME.level.ansicht_act_x)	
		
		Self.vx:+ KeyDown(key_right) - KeyDown(key_left)
		Self.vy:+ KeyDown(key_down) - KeyDown(key_up)
		
		Rem
		Self.vx:+ KeyDown(key_d)*Cos(Self.w+90) - KeyDown(key_a)*Cos(Self.w+90) - KeyDown(key_s)*Cos(Self.w) + KeyDown(key_w)*Cos(Self.w)
		Self.vy:+ KeyDown(key_d)*Sin(Self.w+90) - KeyDown(key_a)*Sin(Self.w+90) - KeyDown(key_s)*Sin(Self.w) + KeyDown(key_w)*Sin(Self.w)
		EndRem
		
		If MouseHit(1) Then
			Self.do_hit()'If Rand(1,3) = 1 Then TShot.Create(Self.x,Self.y,w,GAME.level)
		EndIf
		
		If KeyHit(key_space) Then
			TLamp.Create(Self.x,Self.y,[Rand(200,255),Rand(100,200),Rand(0,100)],TLight.source_normal,GAME.level)
		EndIf
		
		
		Self.calc_collision()
		
		Self.x:+ Self.vx
		Self.y:+ Self.vy
		
		'Self.light.image = Self.light_image
		Self.light.x = Self.x+Rnd()
		Self.light.y = Self.y+Rnd()
		Self.light.w = Self.w
		Self.light.render()
		'Self.light.draw_to_buffer()
		
		'If Rand(100) = 1 Then Self.light.set_color(Rand(150,255),Rand(100,200),Rand(50,100))
		
		Self.vx:*0.8
		Self.vy:*0.8
		
		
		Self.level.table[Self.x/GAME.tile_side,Self.y/GAME.tile_side].visible = 2
	End Method
	
	Method draw()
		
		Self.draw_hit()
		
		SetColor 255,255,255
		SetRotation Self.w
		Draw_Image TPlayer.image, GAME.level.ansicht_act_x + Self.x, GAME.level.ansicht_act_y + Self.y
		SetRotation 0
		
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
	DrawRect(x+Graphics_Handler.origin_x + GAME.level.ansicht_act_x,y+Graphics_Handler.origin_y + GAME.level.ansicht_act_y,width#,height# )
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
		
		SetImageFont LoadImageFont("incbin::font2.ttf", 30,SMOOTHFONT)' # LOAD FONT #
		
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
	Global source_small:TImage
	Global source_shot:TImage
	Global source_bot1:TImage
	
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
		TLight.source_small = LoadImage("lights\small.png")
		MidHandleImage TLight.source_small
		
		TLight.source_shot = LoadImage("lights\shot.png")
		MidHandleImage TLight.source_shot
		
		TLight.source_bot1 = LoadImage("lights\bot1.png")
		MidHandleImage TLight.source_bot1
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
		
		If Self.x = Self.last_x And Self.y = Self.last_y And Self.w = Self.last_w And Self.rot = Self.last_r And Self.gruen = Self.last_g And Self.blau = Self.last_b Then
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
Graphics_Handler.set_graphics(DesktopWidth()-60,DesktopHeight()-50,0)'DesktopWidth(),DesktopHeight(),1)' ## INIT GRAPHICS ##'800,600,0)'

GAME.run()

End