Graphics3D 1280,1024,0,1  ;Grafikmodus setzen
;--------------------------------
Const Terrain_T = 1         ;Werte f�r die Kollisionsabfrage definieren
Const Unsichtbar_T = 1
Const Figur_T = 2
Global Jump#                   ;Variable f�r's Springen 

;-----------------------------------------
Light = CreateLight()                  ;ein Licht erstellen, das die Welt 3Dimensionaler aussieht
;------------------------------------------
tex1 = LoadTexture("Gras.png")       ;Texturen Laden und gr�sser und kleiner machen
ScaleTexture tex1, 128, 128

;------------------------------------------
Figur = LoadMesh("mario.x")           ;Figur laden;"mario.x"
ScaleMesh Figur,0.25,0.25,0.25     ;Figur kleiner machen, weil sie sonst ein bisschen zu gross ist ...
EntityType Figur,Figur_T                ;Ein Kollisionstyp erstellen

;-------------------------------------------- 
Camera = CreateCamera(Figur)     ;Eine Kamera erstellen, die die Figur verfolgt
PositionEntity Camera,0,5,-8          ;Kamera hinter der Figur plazieren
;--------------------------------------------
t_bild=LoadImage("Terrain.png")
ScaleImage t_bild,1,1
Terrain = LoadTerrain("Terrain.png") ;Terrain laden
TerrainDetail Terrain,60000,True;20000        ;Details auf 2000 stellen und Morph  einschalten 
TerrainShading Terrain,True             ;Schatten ein
EntityTexture Terrain,Tex1                ;Terrain texturrieren
ScaleEntity Terrain,3,40,3 ;3,199,3               ;Terrain wird skaliert
EntityType Terrain,Terrain_T,1 
EntityAlpha Terrain,1          ;Kollisionstyp wird erstellt
;-------------------------------------------
Baum = LoadSprite("Baum.png",7)     ;Ein Sprite wird erstellt mit besonderen eigenschaften => Onlinehilfe 
ScaleSprite Baum,3,100 
EntityAlpha Baum,0.7                        ;Gr�sse ver�ndern
;------------------------------------------------
SetBuffer BackBuffer()                        ;BackBuffer 
;----------------------------------------------
PositionEntity Figur,20,50,100      ;Objekte plazieren
PositionEntity Baum,190,80,170

;------------------------------------------------
Collisions 2,1,2,3                                ;Kollision einschalten mit den Kollisionstypen mit der Zahl 1 und 2
;===================================
radius=2
bed=0
While Not(KeyHit(1)) Or bed;Schlaife starten
;-----------------------------------------
If KeyHit(17) Then w = Not(W):WireFrame w   ;Wireframe
;----------------------------------------------------
If KeyDown(3) Then MoveEntity Figur,0,0,10
If KeyDown(200) Then MoveEntity Figur,0,0,4   ;Steuerung
If KeyDown(208) Then MoveEntity Figur,0,0,-4
If KeyDown(203) Then TurnEntity Figur,0,5,0
If KeyDown(205) Then TurnEntity Figur,0,-5,0

;-----------------------------------------------------
If 1=1 Then
If KeyHit(57) Then  ;Wenn die Leertaste gedr�ckt wird ...
Jump = 5               ;wird die Variable Jump auf 5 gesetzt
ElseIf Jump > 0 Then ;Wenn das nicht der Fall ist und Jump gr�sser als 0 ist, ...
Jump = Jump- 0.1      ;wird immaer 0.1 von Jump abgezogen
TranslateEntity Figur,0,Jump,0 ;Die Figur wird um die Variable Jump nach oben verschoben
EndIf
End If
;------------------------------------------------------- 
counter = counter + 1                    ;Frames z�hler
If time = 0 Then time = MilliSecs()
If time + 1001 < MilliSecs() Then 
framerate = counter
counter = 0
time = MilliSecs()
EndIf 
;---------------------------------------------------
TranslateEntity Figur,0,-3,0        ;Anziehungskraft
;-----------------------------------------
UpdateWorld()                  ;Kollisionen
RenderWorld()                  ;Zeichnen
;------------------------------------
DrawBlock t_bild,0,0
Color 255,0,0
Rect (EntityX(Figur)/3)-1,(128)-(EntityZ(Figur)/3)-1,3,3,1
Color 0,255,255
Rect (EntityX(Baum)/3)-1,(128)-(EntityZ(Baum)/3)-1,3,3,1
;Text 10,20,EntityX(Figur)
;Text 10,30,EntityY(Figur)
;Text 10,40,EntityZ(Figur)
;Text 10,10,framerate        ;Frames anzeigen
Flip                                   ; ???
;---------------------------------------
bed=(EntityX(Figur)+radius>EntityX(Baum) And EntityX(Figur)-radius<EntityX(Baum) And EntityZ(Figur)+radius>EntityZ(Baum) And EntityZ(Figur)-radius<EntityZ(Baum))
Wend
;===============================
If bed Then
	Color 255,0,0
	Print"YOU WIN"
	While Not KeyHit(1)
	Wend
End If
End  