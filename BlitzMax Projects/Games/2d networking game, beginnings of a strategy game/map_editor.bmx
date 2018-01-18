SuperStrict

Type TMAPS
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
	
	Function create:TMAPS(x:Int,y:Int,tileset_name:String)
		Local m:TMAPS=New TMAPS
		
		m.x=x
		m.y=y
		
		m.tileset_name=tileset_name
		
		TFELD.load_tiles(m.tileset_name)
		
		m.felder=New TFELD[m.x,m.y]
		
		For Local xx:Int=0 To m.x-1
			For Local yy:Int=0 To m.y-1
				m.felder[xx,yy]=TFELD(TFELD.liste.first())
			Next
		Next
		
		Return m
	End Function
	
	Method save(path:String)
		Local stream:TStream=WriteFile(path)
		
		stream.WriteLine(Self.tileset_name)'TILESET
		stream.WriteInt(Self.x)'koordinaten
		stream.WriteInt(Self.y)
		
		For Local xx:Int=0 To Self.x-1
			For Local yy:Int=0 To Self.y-1
				stream.WriteInt(Self.felder[xx,yy].number)'nummern des tiles
			Next
		Next
		
		stream.close()
	End Method
	
	
	Function draw_mini_map(map:TMAPS, x:Int, y:Int, dx:Int, dy:Int)
		
		If map Then
			
			For Local xx:Int=0 To map.x-1
				For Local yy:Int=0 To map.y-1
					
					Select map.felder[xx,yy].typ
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

Local map:TMAPS

If Input("create? (y)> ")="y" Then
	Local dx:Int=Int(Input("x> "))
	Local dy:Int=Int(Input("y> "))
	Local tileset:String=Input("tileset> ")
	Graphics 800,600
	map=TMAPS.create(dx,dy,tileset)
Else
	Graphics 800,600
	map=TMAPS.load(RequestFile("Map öffnen","Map-File:map"))
End If

If map=Null Then End
If TFELD.liste=Null Then End


Local actual_tfeld:TFELD=TFELD(TFELD.liste.first())

Local yyyy:Int=10

Local ansicht_x:Int=TFELD.seite+50+10
Local ansicht_y:Int=10

Local show_typ:Int
Local show_raster:Int

Repeat
	Cls
	
	If KeyDown(key_w) Then ansicht_y:+10
	If KeyDown(key_s) Then ansicht_y:-10
	If KeyDown(key_a) Then ansicht_x:+10
	If KeyDown(key_d) Then ansicht_x:-10
	
	yyyy:+MouseZSpeed()*25
	If yyyy<-TFELD.anzahl*(TFELD.seite+10)+100 Then yyyy=-TFELD.anzahl*(TFELD.seite+10)+100
	If yyyy>10 Then yyyy=10
	
	Local md1:Int=MouseDown(1)
	Local md2:Int=MouseDown(2)
	show_typ=Abs(show_typ-KeyHit(key_t))
	show_raster=Abs(show_raster-KeyHit(key_r))
	
	Local mx:Int=MouseX()
	Local my:Int=MouseY()
	
	If md1 And mx>TFELD.seite+50 Then
		If mx>=ansicht_x And mx<ansicht_x+TFELD.seite*map.x And my>=ansicht_y And my<ansicht_y+TFELD.seite*map.y Then
			map.felder[(mx-ansicht_x)/TFELD.seite,(my-ansicht_y)/TFELD.seite]=actual_tfeld
		End If
	End If
	
	For Local xx:Int=0 To map.x-1
		For Local yy:Int=0 To map.y-1
			
			If show_typ Then
				
				'SetColor map.felder[xx,yy].typ*50,0,0
				
				Select map.felder[xx,yy].typ
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
				
				
				DrawRect xx*TFELD.seite+ansicht_x,yy*TFELD.seite+ansicht_y,TFELD.seite,TFELD.seite
				SetColor 255,255,255
			Else
				DrawImage map.felder[xx,yy].image,xx*TFELD.seite+ansicht_x,yy*TFELD.seite+ansicht_y
			End If
			
			If show_raster Then
				SetColor 0,0,0
				DrawRect xx*TFELD.seite+ansicht_x,yy*TFELD.seite+ansicht_y,TFELD.seite,1
				DrawRect xx*TFELD.seite+ansicht_x,yy*TFELD.seite+ansicht_y,1,TFELD.seite
				SetColor 255,255,255
			End If
			
		Next
	Next
	
	SetColor 100,100,100
	DrawRect 0,0,TFELD.seite+50,600
	
	SetColor 150,150,150
	DrawRect TFELD.seite+48,0,2,600
	
	SetColor 255,255,255
	
	
	Local yyy:Int=yyyy
	
	For Local f:TFELD=EachIn TFELD.liste
		If actual_tfeld=f Then
			SetColor 255,0,0
			DrawRect 2,yyy-2,4+TFELD.seite,4+TFELD.seite
			SetColor 255,255,255
			
		End If
		
		DrawImage f.image,4,yyy
		
		
		If md1 And mx>=4 And mx<4+TFELD.seite And my>=yyy And my<yyy+TFELD.seite Then
			actual_tfeld=f
		End If
		
		DrawText f.number,10+TFELD.seite,yyy+TFELD.seite/2-5
		
		yyy:+TFELD.seite+10
	Next
	
	DrawText "hit [t] to show the typ of the tiles",TFELD.seite+50+10,10
	DrawText "hit [r] to show the raster",TFELD.seite+50+10,30
	
	SetColor 255,255,255
	DrawRect 0,500,100,100
	SetColor 0,0,0
	DrawRect 2,502,96,96
	TMAPS.draw_mini_map(map, 4,504, 100,100)
	
	Flip
Until KeyHit(key_escape)

map.save(RequestFile("Map öffnen","Map-File:map"))