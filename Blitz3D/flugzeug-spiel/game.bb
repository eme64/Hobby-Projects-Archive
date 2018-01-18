Graphics3D 1280, 1024,0,1
SetBuffer BackBuffer ()

mann=LoadMesh ("mann_1\mann.x")
ScaleEntity mann,0.5,0.5,0.5

Global leben=255

Global fire=LoadSprite ("fire.bmp")
HandleSprite fire, 0, 0;-1
ScaleSprite fire, 7, 7
EntityAlpha fire, 0.25
EntityFX fire, 8
HideEntity fire


Global boom=LoadSprite ("boom.bmp")
HandleSprite boom, 0, 0;-1
ScaleSprite boom, 200,200
EntityAlpha boom, 1
EntityFX boom, 8
HideEntity boom

pfeil=LoadImage("pfeil.bmp")

HandleImage pfeil,125,125

Type rocket
	Field ID
	Field ziel
	Field pivot
	Field richtung
End Type



Type rocket_start_ramps
	Field ID
End Type

Type flame
	Field ID
	Field alpha#
End Type

AmbientLight 200, 200, 200

sun = CreateLight ()
LightColor sun, 255, 220, 180
RotateEntity sun, 0, 45, 0

terrain = LoadTerrain ("t.bmp")

z=10
ScaleEntity terrain, 5*z, 300*z, 5*z
TerrainShading terrain, True

TerrainDetail terrain, 2500, True
EntityPickMode terrain, 2, True
gras = LoadTexture ("boden.bmp")
ScaleTexture gras, 50, 50
EntityTexture terrain, gras, 0, 1

rocket_brush=CreateBrush(150,50,50)
rocket_brush_2=CreateBrush(75,75,0)
start_brush=CreateBrush(100,150,100)


rocket_old=CreateCylinder()
rocket_spitz=CreateCone(8,1,rocket_old)

MoveEntity rocket_spitz,0,1.5,0
ScaleEntity rocket_old,0.5,2,0.5
ScaleEntity rocket_spitz,1,0.5,1
ScaleEntity rocket_old,5,5,5
PaintEntity rocket_old,rocket_brush
PaintEntity rocket_spitz,rocket_brush_2

;PositionEntity rocket_old,1000,1000,1000




RotateEntity rocket_old,90,0,0
AddMesh rocket_spitz,rocket_old
HideEntity rocket_old

EntityPickMode rocket_old,2

anz_rocket_starts=200


	For a=0 To anz_rocket_starts-1
		rocket_start_r.rocket_start_ramps =New rocket_start_ramps
		bx = Rnd (TerrainSize (terrain) * 50)
		bz = Rnd (TerrainSize (terrain) * 50)
		rocket_start_r\ID=LoadMesh ("station.x");CreateCube()
		ScaleEntity rocket_start_r\ID,0.5,0.5,0.5
		;PaintEntity rocket_start_r\ID,start_brush
		PositionEntity rocket_start_r\ID, bx, TerrainY (terrain, bx, 0, bz) -10, bz
		EntityPickMode rocket_start_r\ID,2
		EntityType rocket_start_r\ID,3,1
		RotateEntity rocket_start_r\ID, 0,Rand(0,360),0
	Next


fighter= CreatePivot ()

PositionEntity fighter,2000,2000,2000

;f=LoadMesh ("stealth.3ds",fighter)
f=LoadMesh ("plane.x",fighter)
ScaleEntity f, 0.7, 0.7,0.7
TurnEntity f,0,90,0

fire_fighter_point=CreatePivot (f)
MoveEntity fire_fighter_point,0,0,0

camera = CreateCamera (fighter)
CameraViewport camera,200,0,1080,1024
r=40
g=20
b=20
CameraFogMode camera, 1
CameraFogColor camera, r,g, b
range = 10000
CameraRange camera, 1, range
CameraFogRange camera, 1, range - 10
CameraClsColor camera, r, g, b

MoveEntity camera,0,4,-20


;CameraFogMode camera, 1
;CameraFogColor camera, 200, 220, 255
;range = 2500
;CameraRange camera, 1, range
;CameraFogRange camera, 1, range - 10
;CameraClsColor camera, 200, 220, 255

cam_2=CreateCamera()
CameraViewport cam_2,1,51,198,198
TurnEntity cam_2,90,0,0

MoveEntity cam_2,0,0,-2000

r=40
g=20
b=20
CameraFogMode cam_2, 1
CameraFogColor cam_2, r,g, b
range = 20000
CameraRange cam_2, 1, range
CameraFogRange cam_2, 1, range - 10
CameraClsColor cam_2, r, g, b



speed#=0

EntityType terrain, 1
EntityType fighter, 2

Collisions 2, 1, 2, 2
Collisions 4, 1, 2, 2
Collisions 4, 2, 2, 2
Collisions 2, 3, 2, 1
Collisions 4, 3, 2, 1

ud_grad#=0
uudd#=0


set_speed#=1
navystop=1

rl_grad#=0
rrll#=0
rrll_last#=0

Function delete_rocket(id)
		For rocket_new.rocket=Each rocket
			If rocket_new\ziel=id Then
				delete_rocket(rocket_new\ID)
			End If
		Next
		For rocket_new.rocket=Each rocket
			If rocket_new\ID=id Then
				If rocket_new\ziel=-1 Then FreeEntity rocket_new\pivot
				fl.flame =New flame
				fl\ID=CopyEntity(boom)
				fl\alpha#=1
				PositionEntity fl\ID,EntityX(rocket_new\ID)+Rand(0,50)-25,EntityY(rocket_new\ID)+Rand(0,50)-25,EntityZ(rocket_new\ID)+Rand(0,50)-25
				RotateSprite fl\ID,Rand(0,360)
				FreeEntity rocket_new\ID
				Delete rocket_new.rocket
				tot=tot+1
				Exit
			End If
		Next
End Function
Global tot=0

Repeat
	;;;;;;;;;;;;;;;;;;;rockets;;;;;;;;;;;;;;;
	If Not KeyDown(25) Then
	For rocket_start_r.rocket_start_ramps =Each rocket_start_ramps
		If Rnd (1000) >995 And EntityDistance (rocket_start_r\ID, fighter) < 2000;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
			rocket_new.rocket =New rocket
			rocket_new\ID=CopyEntity (rocket_old)
			PositionEntity rocket_new\ID,EntityX(rocket_start_r\ID),EntityY(rocket_start_r\ID)+150,EntityZ(rocket_start_r\ID)
			EntityType rocket_new\ID,4,1
			rocket_new\ziel=fighter
		EndIf
		;;;
		
		obj=EntityCollided (rocket_start_r\ID,4)
		If obj Then
			For rocket_new.rocket=Each rocket
				If MeshesIntersect(rocket_start_r\ID,rocket_new\ID) Then;rocket_new\ziel=rocket_start_r\ID
					delete_rocket(rocket_new\ID)
					h#=TerrainHeight(terrain,EntityX(rocket_start_r\ID),EntityZ(rocket_start_r\ID))
					ModifyTerrain terrain,EntityX(rocket_start_r\ID),EntityZ(rocket_start_r\ID),1,1;h#-0.05
					
				End If
			Next
			delete_rocket(obj)
			tot_station=tot_station+1
			FreeEntity rocket_start_r\ID
			Delete rocket_start_r.rocket_start_ramps
		End If
		;;;
		
	Next
	anz_rockets=0
	For rocket_new.rocket=Each rocket
		entf_min=-1000
		entf_max=53000
		If EntityX(rocket_new\ID)<entf_min Or EntityX(rocket_new\ID)>entf_max Or EntityY(rocket_new\ID)<entf_min Or EntityY(rocket_new\ID)>entf_max Or EntityZ(rocket_new\ID)<entf_min Or EntityZ(rocket_new\ID)>entf_max Then delete_rocket(rocket_new\ID)
	Next
	For rocket_new.rocket=Each rocket
		fl.flame =New flame
		fl\ID=CopyEntity(fire)
		fl\alpha#=0.5
		;;;aaaa= EntityVisible (rocket_new\ID,rocket_new\ziel)
		PositionEntity fl\ID,EntityX(rocket_new\ID),EntityY(rocket_new\ID),EntityZ(rocket_new\ID)
		
		Select rocket_new\ziel
			Case -1
				If rocket_new\richtung=0 Then
					rocket_new\richtung=1
					PointEntity rocket_new\ID,rocket_new\pivot,1
					TurnEntity rocket_new\ID,90,0,0
				End If
				anz_rockets=anz_rockets+1
				
				enttfernung#=EntityDistance#(rocket_new\ID,rocket_new\pivot)
				rocket_speed#=enttfernung#/10+10
				If rocket_speed#>20 Then rocket_speed#=10
			Case 0
				Stop
			Default
				PointEntity rocket_new\ID,rocket_new\ziel,1
				anz_rockets=anz_rockets+1
				TurnEntity rocket_new\ID,90,0,0
				enttfernung#=EntityDistance#(rocket_new\ID,rocket_new\ziel)
				rocket_speed#=enttfernung#/10+10
				If rocket_speed#>20 Then rocket_speed#=10
		End Select
		
		
		
		;MoveEntity rocket_new\ID,0,5,0
		MoveEntity rocket_new\ID,0,rocket_speed#,0
		
		If EntityCollided (rocket_new\ID,1) Then
			;h#=TerrainHeight(terrain,EntityX(rocket_new\ID),EntityZ(rocket_new\ID))
			;ModifyTerrain terrain,EntityX(rocket_new\ID),EntityZ(rocket_new\ID),1,1;h#-0.05
			
			;;;;;;;;;;;;;;;;;;;;;;;;;;;
			
			TFormPoint( EntityX(rocket_new\ID),EntityY(rocket_new\ID),EntityZ(rocket_new\ID),0,terrain )
			hi#=TerrainHeight( terrain,TFormedX(),TFormedZ() )
			If hi>0
				hi=hi-.05:If hi<0 Then hi=0
				ModifyTerrain terrain,TFormedX()-1,TFormedZ()-1,hi,1
				ModifyTerrain terrain,TFormedX()-1,TFormedZ(),hi,1
				ModifyTerrain terrain,TFormedX()-1,TFormedZ()+1,hi,1
				ModifyTerrain terrain,TFormedX(),TFormedZ()-1,hi,1
				ModifyTerrain terrain,TFormedX(),TFormedZ(),hi,1
				ModifyTerrain terrain,TFormedX(),TFormedZ()+1,hi,1
				ModifyTerrain terrain,TFormedX()+1,TFormedZ()-1,hi,1
				ModifyTerrain terrain,TFormedX()+1,TFormedZ(),hi,1
				ModifyTerrain terrain,TFormedX()+1,TFormedZ()+1,hi,1
			EndIf
			;;;;;;;;;;;;;;;;;;;;;;;;;;;
			;1
			delete_rocket(rocket_new\ID)
			
		Else
			If MeshesIntersect (rocket_new\ID,f) Then
			;2
				delete_rocket(rocket_new\ID)
				ich_tot=ich_tot+1
			End If
		End If
		
		
	Next
	End If
	Repeat
	e=0
	For rocket_new.rocket=Each rocket
		For rocket_new_2.rocket=Each rocket
			If MeshesIntersect (rocket_new\ID,rocket_new_2\ID) And rocket_new\ID <> rocket_new_2\ID Then
				delete_rocket(rocket_new\ID)
				delete_rocket(rocket_new_2\ID)
				e=1
				Exit
			End If
		Next
	Next
	Until e=0
	
	
	
	
	;;;;;;;;;;;;;;;;;;fire;;;;;;;;;;;;
	
	For fl.flame =Each flame
		fl\alpha#=fl\alpha#-0.005
		EntityAlpha fl\ID, fl\alpha#
		
		If fl\alpha#<=0 Then
			FreeEntity fl\ID
			Delete fl.flame
			
		EndIf
	Next
	
	;;;;;;;;;;;;;;;;;up/down;;;;;;;;;;;;;;;;;;
	If KeyDown(200) And navystop=0 Then;+
		uudd#=uudd#+0.05
	End If
	If KeyDown(208) And navystop=0 Then;-
		uudd#=uudd#-0.05
	End If
	uudd#=uudd#*0.6
	ud_grad#=ud_grad#+uudd#-(ud_grad#/20)
	TurnEntity fighter,ud_grad#,0,0
	;;;;;;;;;;;;;;;;;;roll;;;;;;;;;;;;;;;;;;;;;
	If KeyDown(205) Then
		rrll#=rrll#-0.05
	End If
	If KeyDown(203) Then
		rrll#=rrll#+0.05
	End If
	rrll#=rrll#*0.6
	rl_grad#=rl_grad#+rrll-(rl_grad#/30)
	TurnEntity fighter,0,rl_grad#,0
	TurnEntity f,(rl_grad#-rrll_last#)*30,0,0
	rrll_last#=rl_grad#
	;;;;;;;;;;;;;;;;;;speed;;;;;;;;;;;;;;;;;;;;;

	sss#=(sss#/2)+(set_speed/100000)
		
	speed=speed-(speed/2000)+sss
	If speed>40 Then
		speed=40
		set_speed=1
	End If
	;If speed<5 Then speed=5
	MoveEntity fighter,0,0,speed

	If KeyDown(57) And speed<39 Then
		set_speed=set_speed+40
		
		;set_speed=set_speed+(10/(set_speed+0.1))
	Else
		set_speed=set_speed*0.2
	End If
	If set_speed<0 Then set_speed=0
	If KeyHit(83) Then
		speed=5
		sss=0
		set_speed=1
	End If
	If speed<5 And navystop=0 Then speed=5
	If navystop=1 And speed=>5 Then navystop=0
	;;;;;;;;;;;;;;;;;;;;;;;;;;updaten;;;;;;;;;;

	
	
	If EntityRoll(fighter)<-80 Or EntityRoll(fighter)>80 Then
		;TurnEntity fighter,0,0,-EntityRoll(fighter)/50,0
	Else
		TurnEntity fighter,0,0,-EntityRoll(fighter)/100,0
	End If
	;TurnEntity fighter,0,0,-EntityRoll(fighter),0
	RotateEntity cam_2,90,EntityYaw(fighter),0,1
	PositionEntity cam_2,EntityX(fighter),EntityY(fighter)+300,EntityZ(fighter)
	;PointEntity camera, fighter
	
	
	
	
	
	
	
	ent_ity = CameraPick (camera, MouseX ()-200, MouseY ())
	
	If MouseHit(1) And ent_ity><0 Then;zu del
		rocket_new.rocket =New rocket
		rocket_new\ID=CopyEntity (rocket_old)
		
		rocket_new\ziel=-1
		
		rocket_new\pivot=CreatePivot()
		PositionEntity rocket_new\pivot,PickedX(),PickedY(),PickedZ()
		
		PositionEntity rocket_new\ID,EntityX(fighter),EntityY(fighter)-10,EntityZ(fighter)
		EntityType rocket_new\ID,4,1
	EndIf
	
	UpdateWorld
	RenderWorld
	
	;Color 255,0,0
	;Text 10,10,-(speed/2000)+sss
	;Text 10,20,speed
	;Text 10,40,anz_rockets
	;Text 10,50,tot
	;Text 10,30,EntityPitch(fighter)
	;Text 10,60,ent_ity
	;Text 10,70,terrain
	;Text 10,80,aaaa
	;Color 0,255,0
	;Text 10,90,ich_tot
	Color 100,100,250
	Text 10,22,"Überblick"
	Rect 0,50,200,200,0

	;;;stations
	Color 0,200,0
	Text 10,400,"Zerstörte"
	Text 10,412,"Racketenstationen:"
	Text 10,430,+tot_station+"/"+anz_rocket_starts
	;;;racketen
	Color 150,150,150
	Text 10,510,"Anzahl fliegender" 
	Text 10,525,"Racketen:"+anz_rockets
	;;;speed
	Color 200,0,0
	Text 10,278,"Speed"
	Rect 10,300,3*speed,10
	Color 150,150,0
	Rect 9,299,120,12,0
	
	Text 10,700, ich_tot
	Text 10,710,EntityX(fighter)
	Text 10,720,EntityY(fighter)
	Text 10,730,EntityZ(fighter)
	
	If ich_tot>0 Then
		ich_tot=0
		leben=leben-5
	End If
	
	Color 0,255,0
	Text 10,900,"Leben"
	Color 255-leben,leben,0
	Rect 10,920,leben,20
	
	;;;
	If KeyHit (17)
		w = 1 - w
		WireFrame w
	EndIf
	DrawImage pfeil,MouseX (), MouseY()
	Flip
	Cls
Until KeyHit(1)
End
	PointEntity rocket,f,1
	
	TurnEntity rocket,90,0,0
	enttfernung#=EntityDistance#(rocket,fighter)
	rocket_speed#=enttfernung#/10+6
	If rocket_speed#>10 Then rocket_speed#=10
	
	MoveEntity rocket,0,rocket_speed#,0