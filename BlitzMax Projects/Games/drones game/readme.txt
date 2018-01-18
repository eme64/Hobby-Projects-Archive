this game was basically a clone of "duskers", just wanted to see how far I could make it.
Mayve first play duskers first, because this game only makes sense as a clone.
What I tested was the commandline and the bots that automatically run around the open rooms.

The commands are:
dock
remote
navigate
reroute
open
close


corresponding Code:

------------------------
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
