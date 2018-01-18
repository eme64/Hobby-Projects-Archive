



;Draw3D.V.3.2
;15.04.2008
;Autor.hectic
;www.hectic.de




;====-===-==-=-O-P-T-I-O-N-S-=---- --- -- - -  -   -    -
Const DRAWOFFSET#=0.25 ;Grabing-UV-Offset-Constant (Standard 0.25)
Const DRAWBANKSIZE=1024 ;Drawbank-Size-Declaration (Maximal Images)
Const DRAWFONTBANKSIZE=16 ;Fontbank-Size-Declaration (Maximal Fonts)
Const DRAWRECTOFFSET#=0.0 ;Rect-Drawing-Art-Constant (Less Than 0.25)
;====-===-==-=-O-P-T-I-O-N-S-=---- --- -- - -  -   -    -




;Used-Variables
Global MouseX3D%=0
Global MouseY3D%=0
Global MouseX3DOld%=0
Global MouseY3DOld%=0
Global MouseHit3D%=0
Global MousePit3D%=0
Global MouseDown3D%=0
Global MouseOver3D%=0
Global MouseText3D$=""
;Internal-Global-Variables
Dim ADrawPivot%(1) ;Camera-Pivot-Handle
Global GDrawNFR%=255 ;Native-Farbe-Rot
Global GDrawNFG%=255 ;Native-Farbe-Grün
Global GDrawNFB%=255 ;Native-Farbe-Blau
Global GDrawNFA#=1 ;Native-Alpha-Angabe
Global GDrawTFR%=255 ;Text3D-Farbe-Rot
Global GDrawTFG%=255 ;Text3D-Farbe-Grün
Global GDrawTFB%=255 ;Text3D-Farbe-Blau
Global GDrawTFA#=1 ;Text3D-Alpha-Angabe
Global GDrawGFR%=255 ;Grafik-Farbe-Rot
Global GDrawGFG%=255 ;Grafik-Farbe-Grün
Global GDrawGFB%=255 ;Grafik-Farbe-Blau
Global GDrawGFA#=1 ;Grafik-Alpha-Angabe
Global GDrawSFont#=1 ;Font-Größen-Skallierung
Global GDrawHFont#=1 ;Font-Nur-Höhenskallierung
Global GDrawPFont#=0 ;Font-Zeichenabstand-In-Pixel
Global GDrawIFont#=0 ;Font-Kursiv-(Negativ/Positiv)-Grad
Global GDrawXScale#=1 ;X-Skallierungsfaktor-Für-IDrawPivot
Global GDrawYScale#=1 ;Y-Skallierungsfaktor-Für-IDrawPivot
Global GDrawXSize%=0 ;X-Skallierungsfaktor-Für-MouseX3D
Global GDrawYSize%=0 ;Y-Skallierungsfaktor-Für-MouseY3D
Global GDrawMouseHit%=0 ;Für-Eigene-MouseHit-Berechnung
Global GDrawMousePit$="" ;Für-Eigene-MousePit-Berechnung
Global GDrawBankUsed%=0 ;Maximale-Bankbesetzung
;Bank-Offset-Constants
Const DRAWBANKKING=0
Const DRAWBANKMESH=4
Const DRAWBANKFACE=8
Const DRAWBANKTEXTURE=12
Const DRAWBANKXMAIN=16
Const DRAWBANKYMAIN=20
Const DRAWBANKXSIZE=24
Const DRAWBANKYSIZE=28
Const DRAWBANKU1MAP=32
Const DRAWBANKV1MAP=36
Const DRAWBANKU2MAP=40
Const DRAWBANKV2MAP=44
Const DRAWBANKSTEP=48
;Font-Offset-Constants
Const DRAWFONTBANK=DRAWBANKXMAIN
Const DRAWFONTSIZE=DRAWBANKYMAIN
Const DRAWFONTUVSTEP#=1.0/16.0
Const DRAWFONTBANKSTEP=256
;Bank-Creating-And-Setting-The-Size
Global GDrawBank;=CreateBank(DRAWBANKSTEP+DRAWBANKSIZE*DRAWBANKSTEP)
Global GDrawFontBank;=CreateBank(DRAWFONTBANKSIZE*DRAWFONTBANKSTEP)




;DrawInit3D( Camera )
Function DrawInit3D(FDrawCamera%)
	GDrawBank=CreateBank(DRAWBANKSTEP+DRAWBANKSIZE*DRAWBANKSTEP)
	GDrawFontBank=CreateBank(DRAWFONTBANKSIZE*DRAWFONTBANKSTEP)
	If FDrawCamera=0 Then RuntimeError "Camera not found"
	ADrawPivot(0)=CreatePivot(FDrawCamera)
	ADrawPivot(1)=CreatePivot()
	PositionEntity ADrawPivot(0),0,0,GraphicsWidth()/2.0
	PositionEntity ADrawPivot(1),0,0,GraphicsWidth()/2.0
	MoveMouse GraphicsWidth()/2,GraphicsHeight()/2
	Origin3D(GraphicsWidth(),GraphicsHeight())
End Function




;DrawFree3D( )
Function DrawFree3D()
	Local IDrawLoop%
	;Alle-Bankpositionen-Durchgehen
	For IDrawLoop=DRAWBANKSTEP To GDrawBankUsed Step DRAWBANKSTEP
		If PeekInt(GDrawBank,IDrawLoop+DRAWBANKKING)>0
			ClearSurface PeekInt(GDrawBank,IDrawLoop+DRAWBANKFACE)
			FreeEntity PeekInt(GDrawBank,IDrawLoop*DRAWBANKSTEP+DRAWBANKMESH)
			FreeTexture PeekInt(GDrawBank,IDrawLoop*DRAWBANKSTEP+DRAWBANKTEXTURE)
			PokeInt GDrawBank,IDrawLoop,0
		End If
	Next
	;Sonstiges-Freigeben
	FreeEntity ADrawPivot(0)
	FreeEntity ADrawPivot(1)
	FreeBank GDrawFontBank
	FreeBank GDrawBank
	;Variablen-Auf-Standard-Zurück-Setzen
	GDrawNFR=255:GDrawNFG=255:GDrawNFB=255:GDrawNFA=1
	GDrawTFR=255:GDrawTFG=255:GDrawTFB=255:GDrawTFA=1
	GDrawGFR=255:GDrawGFG=255:GDrawGFB=255:GDrawGFA=1
	GDrawSFont=1:GDrawHFont=1:GDrawPFont=0:GDrawIFont=0
	GDrawXScale=1:GDrawYScale=1
	GDrawXSize=0:GDrawYSize=0
	GDrawBankUsed=0
End Function




;Origin3D( X-Size, Y-Size, Pivot )
Function Origin3D(FDrawX#=0,FDrawY#=0,FDrawPivot%=2)
	;Variablen-Vorberechnung
	Local IDrawXScale#=GraphicsWidth()/FDrawX
	Local IDrawYScale#=GraphicsHeight()/FDrawY
	If FDrawPivot<0 Then FDrawPivot=0
	If FDrawPivot>2 Then FDrawPivot=2
	FDrawPivot=FDrawPivot+1
	;Automatische-1:1-Stellung
	If FDrawX=0 And FDrawY=0 Then
		FDrawX=GraphicsWidth()
		FDrawY=GraphicsHeight()
	End If
	;Bestimmung-des-HUD-Pivots
	If FDrawPivot And %00000001 Then
		
		;Relationsberechnungen
		GDrawXScale=IDrawXScale
		GDrawYScale=IDrawYScale
		
		PositionEntity ADrawPivot(0),0,0,(GraphicsWidth()/2.0)/IDrawXScale
		ScaleEntity ADrawPivot(0),1,IDrawYScale/IDrawXScale,1
		GDrawXSize=FDrawX
		GDrawYSize=FDrawY
	End If
	;Bestimmung-des-World-Pivots
	If FDrawPivot And %00000010 Then
		PositionEntity ADrawPivot(1),0,0,(GraphicsWidth()/2.0)/IDrawXScale
		ScaleEntity ADrawPivot(1),1,IDrawYScale/IDrawXScale,1
	End If
End Function




;Clear3D( Handle )
Function Clear3D(FDrawFace%=0)
	Local IDrawLoop%
	If FDrawFace=0
		MouseX3DOld=MouseX3D
		MouseY3DOld=MouseY3D
		If MouseText3D="" Then GDrawMousePit="" Else MouseText3D=""
		MouseX3D=MouseX()/GDrawXScale-(GDrawXSize/2)
		MouseY3D=(GDrawYSize/2)-MouseY()/GDrawYScale
		For IDrawLoop=DRAWBANKSTEP To GDrawBankUsed Step DRAWBANKSTEP
			If PeekInt(GDrawBank,IDrawLoop+DRAWBANKKING)>0
				ClearSurface PeekInt(GDrawBank,IDrawLoop+DRAWBANKFACE)
			End If
		Next
	Else
		ClearSurface PeekInt(GDrawBank,FDrawFace+DRAWBANKFACE)
	End If
End Function




;ClearOn3D( Handle )
Function ClearOn3D(FDrawHandle%)
	Local LDrawKing%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKKING)
	Local IDrawMaster%=DRAWBANKSTEP+DRAWBANKSIZE*DRAWBANKSTEP
	If LDrawKing=-IDrawMaster-FDrawHandle Then PokeInt(GDrawBank,FDrawHandle,FDrawHandle)
End Function




;ClearOff3D( Handle )
Function ClearOff3D(FDrawHandle%)
	Local LDrawKing%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKKING)
	Local IDrawMaster%=DRAWBANKSTEP+DRAWBANKSIZE*DRAWBANKSTEP
	If LDrawKing>0 Then PokeInt(GDrawBank,LDrawKing,-LDrawKing-IDrawMaster)
End Function




;ColorN3D( Red, Green, Blue, Alpha )
Function ColorN3D(FDrawFR%=255,FDrawFG%=255,FDrawFB%=255,FDrawFA#=1)
	GDrawNFR=FDrawFR
	GDrawNFG=FDrawFG
	GDrawNFB=FDrawFB
	GDrawNFA=FDrawFA
End Function




;ColorT3D( Red, Green, Blue, Alpha )
Function ColorT3D(FDrawFR%=255,FDrawFG%=255,FDrawFB%=255,FDrawFA#=1)
	GDrawTFR=FDrawFR
	GDrawTFG=FDrawFG
	GDrawTFB=FDrawFB
	GDrawTFA=FDrawFA
End Function




;ColorG3D( Red, Green, Blue, Alpha )
Function ColorG3D(FDrawFR%=255,FDrawFG%=255,FDrawFB%=255,FDrawFA#=1)
	GDrawGFR=FDrawFR
	GDrawGFG=FDrawFG
	GDrawGFB=FDrawFB
	GDrawGFA=FDrawFA
End Function




;SetFont3D( Font-Size, Font-Height, Font-Padding, Italic-Font)
Function SetFont3D(FDrawSFont#=1,FDrawHFont#=1,FDrawPFont#=0,FDrawIFont#=0)
	GDrawSFont=FDrawSFont
	GDrawHFont=FDrawHFont
	GDrawPFont=FDrawPFont
	GDrawIFont=FDrawIFont
End Function




;LoadFont3D( Texture-Name, Texture-Mode, Texture-Blend, Texture-Pivot )
Function LoadFont3D(FDrawFile$,FDrawMode%=2,FDrawBlend%=2,FDrawPivot%=0)
	If FileType(FDrawFile)<>1 Then RuntimeError FDrawFile+" not found"
	;Variablen-Vorberechnung
	If FDrawMode<0 Then FDrawMode=0
	If FDrawMode>4 Then FDrawMode=4
	If FDrawBlend<0 Then FDrawBlend=0
	If FDrawBlend>5 Then FDrawBlend=5
	If FDrawPivot<0 Then FDrawPivot=0
	If FDrawPivot>1 Then FDrawPivot=1
	;Neue-Bank-Positionen-Festlegen
	Local IDrawBankPosition%=XDrawBP3D()
	Local IDrawFontBankPosition%=XDrawFP3D()
	;Variablen-Vorberechnung
	Local IDrawXLoop%=0
	Local IDrawYLoop%=0
	Local IDrawValue%=0
	Local IDrawKing%=IDrawBankPosition
	Local IDrawMesh%=CreateMesh(ADrawPivot(FDrawPivot))
	Local IDrawFace%=CreateSurface(IDrawMesh)
	Local IDrawTexture%=LoadTexture(FDrawFile,FDrawMode)
	Local IDrawXMain%=TextureWidth(IDrawTexture)
	Local IDrawYMain%=TextureHeight(IDrawTexture)
	Local IDrawXSize%=IDrawXMain/16
	;DrawBank-Variablen-EINweisung
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKKING,IDrawKing
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKMESH,IDrawMesh
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKFACE,IDrawFace
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKTEXTURE,IDrawTexture
	PokeInt GDrawBank,IDrawBankPosition+DRAWFONTBANK,IDrawFontBankPosition
	PokeInt GDrawBank,IDrawBankPosition+DRAWFONTSIZE,IDrawXSize
	;Sonstige-Zuweisung/Berechnungen
	EntityTexture IDrawMesh,IDrawTexture
	TextureBlend IDrawTexture,FDrawBlend
	EntityOrder IDrawMesh,-1000-IDrawKing/DRAWBANKSTEP
	EntityFX IDrawMesh,1+2+8+16
	XDrawMP3D(IDrawKing,FDrawMode)
	;Zeichenspezifische-Festlegung
	For IDrawYLoop=0 To 15
		For IDrawXLoop=0 To 15
			IDrawValue=XDrawTT3D(IDrawTexture,IDrawXMain,IDrawYMain,IDrawXLoop,IDrawYLoop)
			PokeByte GDrawFontBank,IDrawFontBankPosition+IDrawXLoop+IDrawYLoop*16,IDrawValue
		Next
	Next
	IDrawValue=PeekByte(GDrawFontBank,IDrawFontBankPosition+33)
	PokeByte GDrawFontBank,IDrawFontBankPosition+DRAWBANKKING,1
	PokeByte GDrawFontBank,IDrawFontBankPosition+32,IDrawValue
	;Variablen-Ausstiegsvorbereitung
	Return IDrawKing
End Function




;LoadImage3D( Texture-Name, Texture-Mode, Texture-Blend, Texture-Pivot )
Function LoadImage3D(FDrawFile$,FDrawMode%=2,FDrawBlend%=2,FDrawPivot%=0)
	If FileType(FDrawFile)<>1 Then RuntimeError FDrawFile+" not found"
	;Variablen-Vorberechnung
	If FDrawMode<0 Then FDrawMode=0
	If FDrawMode>4 Then FDrawMode=4
	If FDrawBlend<0 Then FDrawBlend=0
	If FDrawBlend>5 Then FDrawBlend=5
	If FDrawPivot<0 Then FDrawPivot=0
	If FDrawPivot>1 Then FDrawPivot=1
	;Neue-Bank-Position-Festlegen
	Local IDrawBankPosition%=XDrawBP3D()
	;Variablen-Vorberechnung
	Local IDrawKing%=IDrawBankPosition
	Local IDrawMesh%=CreateMesh(ADrawPivot(FDrawPivot))
	Local IDrawFace%=CreateSurface(IDrawMesh)
	Local IDrawTexture%=LoadTexture(FDrawFile,FDrawMode)
	Local IDrawXMain%=TextureWidth(IDrawTexture)/2
	Local IDrawYMain%=TextureHeight(IDrawTexture)/2
	Local IDrawXSize#=IDrawXMain
	Local IDrawYSize#=IDrawYMain
	Local IDrawU1Map#=0+(DRAWOFFSET/IDrawXMain)
	Local IDrawV1Map#=0+(DRAWOFFSET/IDrawYMain)
	Local IDrawU2Map#=1-(DRAWOFFSET/IDrawXMain)
	Local IDrawV2Map#=1-(DRAWOFFSET/IDrawYMain)
	;DrawBank-Variablen-EINweisung
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKKING,IDrawKing
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKMESH,IDrawMesh
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKFACE,IDrawFace
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKTEXTURE,IDrawTexture
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKXMAIN,IDrawXMain
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKYMAIN,IDrawYMain
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKXSIZE,IDrawXSize
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKYSIZE,IDrawYSize
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKU1MAP,IDrawU1Map
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKV1MAP,IDrawV1Map
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKU2MAP,IDrawU2Map
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKV2MAP,IDrawV2Map
	;Sonstige-Zuweisung/Berechnungen
	EntityTexture IDrawMesh,IDrawTexture
	TextureBlend IDrawTexture,FDrawBlend
	EntityOrder IDrawMesh,-1000-IDrawKing/DRAWBANKSTEP
	EntityFX IDrawMesh,1+2+8+16
	XDrawMP3D(IDrawKing,FDrawMode)
	;Variablen-Ausstiegsvorbereitung
	Return IDrawKing
End Function




;CreateImage3D( Texture-Size, Texture-Mode, Texture-Blend, X-Scale, Y-Scale, Texture-Pivot )
Function CreateImage3D(FDrawSize%,FDrawMode%=2,FDrawBlend%=2,FDrawXScale#=1,FDrawYScale#=1,FDrawPivot%=0)
	;Variablen-Vorberechnung
	FDrawSize=2^Abs(FDrawSize)
	If FDrawMode<0 Then FDrawMode=0
	If FDrawMode>2 Then FDrawMode=4
	If FDrawBlend<0 Then FDrawBlend=0
	If FDrawBlend>5 Then FDrawBlend=5
	;Neue-Bank-Position-Festlegen
	Local IDrawBankPosition%=XDrawBP3D()
	;Variablen-Vorberechnung
	Local IDrawKing%=IDrawBankPosition
	Local IDrawMesh%=CreateMesh(ADrawPivot(FDrawPivot))
	Local IDrawFace%=CreateSurface(IDrawMesh)
	Local IDrawTexture%=CreateTexture(FDrawSize,FDrawSize,FDrawMode)
	Local IDrawXMain%=TextureWidth(IDrawTexture)/2.0
	Local IDrawYMain%=TextureHeight(IDrawTexture)/2.0
	Local IDrawXSize#=IDrawXMain*FDrawXScale
	Local IDrawYSize#=IDrawYMain*FDrawYScale
	Local IDrawU1Map#=0+(DRAWOFFSET/IDrawXMain)
	Local IDrawV1Map#=0+(DRAWOFFSET/IDrawYMain)
	Local IDrawU2Map#=1-(DRAWOFFSET/IDrawXMain)
	Local IDrawV2Map#=1-(DRAWOFFSET/IDrawYMain)
	;DrawBank-Variablen-EINweisung
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKKING,IDrawKing
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKMESH,IDrawMesh
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKFACE,IDrawFace
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKTEXTURE,IDrawTexture
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKXMAIN,IDrawXMain
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKYMAIN,IDrawYMain
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKXSIZE,IDrawXSize
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKYSIZE,IDrawYSize
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKU1MAP,IDrawU1Map
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKV1MAP,IDrawV1Map
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKU2MAP,IDrawU2Map
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKV2MAP,IDrawV2Map
	;Sonstige-Zuweisung/Berechnungen
	EntityTexture IDrawMesh,IDrawTexture
	TextureBlend IDrawTexture,FDrawBlend
	EntityOrder IDrawMesh,-1000-IDrawKing/DRAWBANKSTEP
	EntityFX IDrawMesh,1+2+8+16
	XDrawMP3D(IDrawKing,FDrawMode)
	;Variablen-Ausstiegsvorbereitung
	Return IDrawKing
End Function




;GrabImage3D( Handle, U-Start-Position, V-Start-Position, U-Size, V-Size, X-Scale, Y-Scale )
Function GrabImage3D(FDrawHandle%,FDrawUP#,FDrawVP#,FDrawUSize#,FDrawVSize#,FDrawXScale#=1,FDrawYScale#=1)
	If FDrawHandle<0 Then RuntimeError "Grabbing only main-images!"
	;Variablen-Vorberechnung
	FDrawUP=FDrawUP/2.0
	FDrawVP=FDrawVP/2.0
	FDrawUSize=FDrawUSize/2.0
	FDrawVSize=FDrawVSize/2.0
	;Neue-Bank-Position-Festlegen
	Local IDrawBankPosition%=XDrawBP3D()
	;DrawBank-Variablen-AUSweisung
	Local LDrawMesh%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKMESH)
	Local LDrawFace%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKFACE)
	Local LDrawTexture%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKTEXTURE)
	Local LDrawXMain%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKXMAIN)
	Local LDrawYMain%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKYMAIN)
	;DrawBank-Variablen-EINweisung
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKKING,-FDrawHandle
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKMESH,LDrawMesh
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKFACE,LDrawFace
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKTEXTURE,LDrawTexture
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKXMAIN,LDrawXMain
	PokeInt GDrawBank,IDrawBankPosition+DRAWBANKYMAIN,LDrawYMain
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKXSIZE,Abs(FDrawUSize)*FDrawXScale
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKYSIZE,Abs(FDrawVSize)*FDrawYScale
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKU1MAP,(FDrawUP/LDrawXMain)+(DRAWOFFSET/LDrawXMain*Sgn(FDrawUSize))
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKV1MAP,(FDrawVP/LDrawYMain)+(DRAWOFFSET/LDrawYMain*Sgn(FDrawVSize))
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKU2MAP,(FDrawUP+FDrawUSize)/LDrawXMain-(DRAWOFFSET/LDrawXMain*Sgn(FDrawUSize))
	PokeFloat GDrawBank,IDrawBankPosition+DRAWBANKV2MAP,(FDrawVP+FDrawVSize)/LDrawYMain-(DRAWOFFSET/LDrawYMain*Sgn(FDrawVSize))
	;Variablen-Ausstiegsvorbereitung
	Return IDrawBankPosition
End Function




;DrawImage3D( Handle, X-Center-Position, Y-Center-Position, Button, Angle, Scale, Image-Frame )
Function DrawImage3D(FDrawHandle%,FDrawX#,FDrawY#,FDrawButton%=0,FDrawAngle#=0,FDrawScale#=1,FDrawFrame%=0)
	FDrawFrame=FDrawFrame*DRAWBANKSTEP
	;DrawBank-Variablen-AUSweisung
	Local LDrawFace%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKFACE+FDrawFrame)
	Local LDrawXSize#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKXSIZE+FDrawFrame)*FDrawScale
	Local LDrawYSize#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKYSIZE+FDrawFrame)*FDrawScale
	Local LDrawU1Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKU1MAP+FDrawFrame)
	Local LDrawV1Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKV1MAP+FDrawFrame)
	Local LDrawU2Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKU2MAP+FDrawFrame)
	Local LDrawV2Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKV2MAP+FDrawFrame)
	;Variablen-Vorberechnung
	FDrawX=FDrawX-0.5
	FDrawY=FDrawY+0.5
	If FDrawAngle<>0 Then
		Local IDrawAngle#=ATan2(LDrawYSize,LDrawXSize)
		Local IDrawRadius#=Sqr((LDrawXSize*LDrawXSize)+(LDrawYSize*LDrawYSize))
		Local IDrawXPos1#=Cos(IDrawAngle+FDrawAngle)*IDrawRadius
		Local IDrawYPos1#=Sin(IDrawAngle+FDrawAngle)*IDrawRadius
		Local IDrawXPos2#=Cos(IDrawAngle-FDrawAngle)*IDrawRadius
		Local IDrawYPos2#=Sin(IDrawAngle-FDrawAngle)*IDrawRadius
	Else
		IDrawXPos1=LDrawXSize
		IDrawYPos1=LDrawYSize
		IDrawXPos2=LDrawXSize
		IDrawYPos2=LDrawYSize
	End If
	;Vertex/Ploygon-Zuweisung/Berechnungen
	Local IDrawV0=AddVertex(LDrawFace,FDrawX-IDrawXPos1,FDrawY+IDrawYPos1,0 ,LDrawU1Map,LDrawV1Map)
	Local IDrawV1=AddVertex(LDrawFace,FDrawX+IDrawXPos2,FDrawY+IDrawYPos2,0 ,LDrawU2Map,LDrawV1Map)
	Local IDrawV2=AddVertex(LDrawFace,FDrawX+IDrawXPos1,FDrawY-IDrawYPos1,0 ,LDrawU2Map,LDrawV2Map)
	Local IDrawV3=AddVertex(LDrawFace,FDrawX-IDrawXPos2,FDrawY-IDrawYPos2,0 ,LDrawU1Map,LDrawV2Map)
	VertexColor LDrawFace,IDrawV0,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
	VertexColor LDrawFace,IDrawV1,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
	VertexColor LDrawFace,IDrawV2,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
	VertexColor LDrawFace,IDrawV3,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
	AddTriangle LDrawFace,IDrawV0,IDrawV1,IDrawV2
	AddTriangle LDrawFace,IDrawV2,IDrawV3,IDrawV0
	If FDrawButton<>0 Then CheckQuad3D(FDrawX-IDrawXPos1,FDrawY+IDrawYPos1,FDrawX+IDrawXPos2,FDrawY+IDrawYPos2,FDrawX+IDrawXPos1,FDrawY-IDrawYPos1,FDrawX-IDrawXPos2,FDrawY-IDrawYPos2,FDrawButton,"image:"+Str(FDrawHandle/DRAWBANKSTEP))
End Function




;DrawLine3D( Handle, X-Start, Y-Start, X-End, Y-End, IDrawing-Size, IDrawing-Mode, Image-Frame )
Function DrawLine3D(FDrawHandle%,FDrawX1#,FDrawY1#,FDrawX2#,FDrawY2#,FDrawSize#,FDrawMode%=0,FDrawFrame%=0)
	If FDrawX1<>FDrawX2 Or FDrawY1<>FDrawY2 Then
		FDrawFrame=FDrawFrame*DRAWBANKSTEP
		;DrawBank-Variablen-AUSweisung
		Local LDrawFace%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKFACE+FDrawFrame)
		Local LDrawXSize#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKXSIZE+FDrawFrame)
		Local LDrawU1Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKU1MAP+FDrawFrame)
		Local LDrawV1Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKV1MAP+FDrawFrame)
		Local LDrawU2Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKU2MAP+FDrawFrame)
		Local LDrawV2Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKV2MAP+FDrawFrame)
		;Variablen-Vorberechnung
		TFormNormal FDrawX2-FDrawX1,FDrawY2-FDrawY1,0,0,0
		Local IDrawXTForm#=TFormedX()*FDrawSize
		Local IDrawYTForm#=TFormedY()*FDrawSize
		;Modus-Rollen
		If FDrawMode=1 Then
			Local IDrawLineSize#=Sqr((FDrawX1-FDrawX2)*(FDrawX1-FDrawX2)+(FDrawY1-FDrawY2)*(FDrawY1-FDrawY2))
			LDrawU2Map#=LDrawU1Map+(IDrawLineSize/PeekInt(GDrawBank,FDrawHandle+DRAWBANKXMAIN))/2
		End If
		;Modus-Absolut
		If FDrawMode=2 Then
			FDrawX2=FDrawX1+TFormedX()*LDrawXSize*2
			FDrawY2=FDrawY1+TFormedY()*LDrawXSize*2
		End If
		;Vertex/Ploygon-Zuweisung/Berechnungen
		Local IDrawV0=AddVertex(LDrawFace,FDrawX1-IDrawYTForm-0.5,FDrawY1+IDrawXTForm+0.5,0, LDrawU1Map,LDrawV1Map)
		Local IDrawV1=AddVertex(LDrawFace,FDrawX2-IDrawYTForm-0.5,FDrawY2+IDrawXTForm+0.5,0, LDrawU2Map,LDrawV1Map)
		Local IDrawV2=AddVertex(LDrawFace,FDrawX2+IDrawYTForm-0.5,FDrawY2-IDrawXTForm+0.5,0, LDrawU2Map,LDrawV2Map)
		Local IDrawV3=AddVertex(LDrawFace,FDrawX1+IDrawYTForm-0.5,FDrawY1-IDrawXTForm+0.5,0, LDrawU1Map,LDrawV2Map)
		VertexColor LDrawFace,IDrawV0,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
		VertexColor LDrawFace,IDrawV1,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
		VertexColor LDrawFace,IDrawV2,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
		VertexColor LDrawFace,IDrawV3,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
		AddTriangle(LDrawFace,IDrawV0,IDrawV1,IDrawV2)
		AddTriangle(LDrawFace,IDrawV2,IDrawV3,IDrawV0)
	End If
End Function




;DrawQuad3D( Handle, X1-Pos, Y1-Pos, X2-Pos, Y2-Pos, X3-Pos, Y3-Pos, X4-Pos, Y4-Pos, Button, Image-Frame )
Function DrawQuad3D(FDrawHandle%,FDrawX1#,FDrawY1#,FDrawX2#,FDrawY2#,FDrawX3#,FDrawY3#,FDrawX4#,FDrawY4#,FDrawButton%=0,FDrawFrame%=0)
	FDrawFrame=FDrawFrame*DRAWBANKSTEP
	;DrawBank-Variablen-AUSweisung
	Local LDrawFace%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKFACE+FDrawFrame)
	Local LDrawU1Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKU1MAP+FDrawFrame)
	Local LDrawV1Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKV1MAP+FDrawFrame)
	Local LDrawU2Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKU2MAP+FDrawFrame)
	Local LDrawV2Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKV2MAP+FDrawFrame)
	;Vertex/Ploygon-Zuweisung/Berechnungen
	Local IDrawV0=AddVertex(LDrawFace,FDrawX1-0.5,FDrawY1+0.5,0 ,LDrawU1Map,LDrawV1Map)
	Local IDrawV1=AddVertex(LDrawFace,FDrawX2-0.5,FDrawY2+0.5,0 ,LDrawU2Map,LDrawV1Map)
	Local IDrawV2=AddVertex(LDrawFace,FDrawX3-0.5,FDrawY3+0.5,0 ,LDrawU2Map,LDrawV2Map)
	Local IDrawV3=AddVertex(LDrawFace,FDrawX4-0.5,FDrawY4+0.5,0 ,LDrawU1Map,LDrawV2Map)
	VertexColor LDrawFace,IDrawV0,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
	VertexColor LDrawFace,IDrawV1,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
	VertexColor LDrawFace,IDrawV2,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
	VertexColor LDrawFace,IDrawV3,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
	AddTriangle LDrawFace,IDrawV0,IDrawV1,IDrawV2
	AddTriangle LDrawFace,IDrawV2,IDrawV3,IDrawV0
	If FDrawButton<>0 Then CheckQuad3D(FDrawX1,FDrawY1,FDrawX2,FDrawY2,FDrawX3,FDrawY3,FDrawX4,FDrawY4,FDrawButton,"image:"+Str(FDrawHandle/DRAWBANKSTEP))
End Function




;DrawRect3D( Handle, X-Center-Position, Y-Center-Position, U-Start-Position, V-Start-Position, U-Size, V-Size, Button, Angle, Scale )
Function DrawRect3D(FDrawHandle%,FDrawX#,FDrawY#,FDrawUPos#,FDrawVPos#,FDrawUSize#,FDrawVSize#,FDrawButton%=0,FDrawAngle#=0,FDrawScale#=1)
	;DrawBank-Variablen-AUSweisung
	Local LDrawFace%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKFACE)
	Local LDrawXMain%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKXMAIN)
	Local LDrawYMain%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKYMAIN)
	;Variablen-Vorberechnung
	FDrawX=FDrawX-0.5
	FDrawY=FDrawY+0.5
	Local IDrawUPos#=FDrawUPos/LDrawXMain*0.5
	Local IDrawVPos#=FDrawVPos/LDrawYMain*0.5
	Local IDrawUSize#=FDrawUSize/LDrawXMain*0.5
	Local IDrawVSize#=FDrawVSize/LDrawYMain*0.5
	If FDrawAngle<>0 Then
		Local IDrawAngle#=ATan2(FDrawVSize,FDrawUSize)
		Local IDrawRadius#=Sqr((FDrawUSize*FDrawUSize)+(FDrawVSize*FDrawVSize))*FDrawScale*0.5
		Local IDrawXPos1#=Cos(IDrawAngle+FDrawAngle)*IDrawRadius
		Local IDrawYPos1#=Sin(IDrawAngle+FDrawAngle)*IDrawRadius
		Local IDrawXPos2#=Cos(IDrawAngle-FDrawAngle)*IDrawRadius
		Local IDrawYPos2#=Sin(IDrawAngle-FDrawAngle)*IDrawRadius
	Else
		IDrawXPos1=FDrawUSize*FDrawScale*0.5
		IDrawYPos1=FDrawVSize*FDrawScale*0.5
		IDrawXPos2=FDrawUSize*FDrawScale*0.5
		IDrawYPos2=FDrawVSize*FDrawScale*0.5
	End If
	;Vertex/Ploygon-Zuweisung/Berechnungen
	Local IDrawV0=AddVertex(LDrawFace,FDrawX-IDrawXPos1,FDrawY+IDrawYPos1,0 ,IDrawUPos,IDrawVPos)
	Local IDrawV1=AddVertex(LDrawFace,FDrawX+IDrawXPos2,FDrawY+IDrawYPos2,0 ,IDrawUPos+IDrawUSize,IDrawVPos)
	Local IDrawV2=AddVertex(LDrawFace,FDrawX+IDrawXPos1,FDrawY-IDrawYPos1,0 ,IDrawUPos+IDrawUSize,IDrawVPos+IDrawVSize)
	Local IDrawV3=AddVertex(LDrawFace,FDrawX-IDrawXPos2,FDrawY-IDrawYPos2,0 ,IDrawUPos,IDrawVPos+IDrawVSize)
	VertexColor LDrawFace,IDrawV0,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
	VertexColor LDrawFace,IDrawV1,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
	VertexColor LDrawFace,IDrawV2,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
	VertexColor LDrawFace,IDrawV3,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
	AddTriangle LDrawFace,IDrawV0,IDrawV1,IDrawV2
	AddTriangle LDrawFace,IDrawV2,IDrawV3,IDrawV0
	If FDrawButton<>0 Then CheckQuad3D(FDrawX-IDrawXPos1,FDrawY+IDrawYPos1,FDrawX+IDrawXPos2,FDrawY+IDrawYPos2,FDrawX+IDrawXPos1,FDrawY-IDrawYPos1,FDrawX-IDrawXPos2,FDrawY-IDrawYPos2,FDrawButton,"image:"+Str(FDrawHandle/DRAWBANKSTEP))
End Function




;DrawMouse3D( Handle, Angle, Scale )
Function DrawMouse3D(FDrawHandle%,FDrawAngle#=0,FDrawScale#=1)
	;DrawBank-Variablen-AUSweisung
	Local LDrawFace%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKFACE)
	;Variablen-Vorberechnung
	Local IDrawXPos1#=Cos(25.5+FDrawAngle+90)*64*FDrawScale
	Local IDrawYPos1#=Sin(25.5+FDrawAngle+90)*64*FDrawScale
	Local IDrawXPos2#=Cos(25.5-FDrawAngle-90)*64*FDrawScale
	Local IDrawYPos2#=Sin(25.5-FDrawAngle-90)*64*FDrawScale
	;Vertex/Ploygon-Zuweisung/Berechnungen
	Local IDrawV0=AddVertex(LDrawFace,MouseX3D-IDrawXPos1-0.5,MouseY3D+IDrawYPos1+0.5,0 ,0.002,0.002)
	Local IDrawV1=AddVertex(LDrawFace,MouseX3D+IDrawXPos2-0.5,MouseY3D+IDrawYPos2+0.5,0 ,0.248,0.002)
	Local IDrawV2=AddVertex(LDrawFace,MouseX3D+IDrawXPos1-0.5,MouseY3D-IDrawYPos1+0.5,0 ,0.248,0.123)
	Local IDrawV3=AddVertex(LDrawFace,MouseX3D-IDrawXPos2-0.5,MouseY3D-IDrawYPos2+0.5,0 ,0.002,0.123)
	VertexColor LDrawFace,IDrawV0,GDrawTFR,GDrawTFG,GDrawTFB,GDrawTFA
	VertexColor LDrawFace,IDrawV1,GDrawTFR,GDrawTFG,GDrawTFB,GDrawTFA
	VertexColor LDrawFace,IDrawV2,GDrawTFR,GDrawTFG,GDrawTFB,GDrawTFA
	VertexColor LDrawFace,IDrawV3,GDrawTFR,GDrawTFG,GDrawTFB,GDrawTFA
	AddTriangle LDrawFace,IDrawV0,IDrawV1,IDrawV2
	AddTriangle LDrawFace,IDrawV2,IDrawV3,IDrawV0
End Function




;OnLockBuffer3D( Handle )
Function OnLockBuffer3D(FDrawHandle%)
	Local LDrawTexture%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKTEXTURE)
	LockBuffer TextureBuffer(LDrawTexture)
End Function




;UnLockBuffer3D( Handle )
Function UnLockBuffer3D(FDrawHandle%)
	Local LDrawTexture%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKTEXTURE)
	UnlockBuffer TextureBuffer(LDrawTexture)
End Function




;SetPixel3D( Handle, X-Position, Y-Position, ARGB-Color )
Function SetPixel3D(FDrawHandle%,FDrawX%,FDrawY%,FDrawARGB%=0)
	Local LDrawTexture%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKTEXTURE)
	WritePixelFast FDrawX,FDrawY,FDrawARGB,TextureBuffer(LDrawTexture)
End Function




;GetPixel3D( Handle, X-Position, Y-Position, ARGB-Mask )
Function GetPixel3D(FDrawHandle%,FDrawX%,FDrawY%,FDrawMask%=$FFFFFFFF)
	Local LDrawTexture%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKTEXTURE)
	Local IDrawARGB%=ReadPixelFast(FDrawX,FDrawY,TextureBuffer(LDrawTexture))
	If FDrawMask<>$FFFFFFFF Then
		Local IDrawRPMXPos%=0
		Local IDrawRPMWert%=0
		Local IDrawRPMPlus%=1
		;Maske-Zusammenfassen
		For IDrawRPMXPos=0 To 31
			If FDrawMask And 2^IDrawRPMXPos Then
				If IDrawARGB And 2^IDrawRPMXPos Then
					IDrawRPMWert=IDrawRPMWert+IDrawRPMPlus
				End If
				IDrawRPMPlus=IDrawRPMPlus*2
			End If
		Next
		;Ausgabe-Mit-Maske
		Return IDrawRPMWert
	Else
		;Reine-Ausgabe
		Return IDrawARGB
	End If
End Function




;SetTexel3D( Handle, X-Bullet, Y-Bullet, X-Image, Y-Image, Image-Angle, Image-Scale, ARGB-Color )
Function SetTexel3D(FDrawHandle%,FDrawX1#,FDrawY1#,FDrawX2#,FDrawY2#,FDrawAngle#=0,FDrawScale#=1,FDrawARGB%=0)
	;DrawBank-Variablen-AUSweisung
	Local LDrawTexture%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKTEXTURE)
	Local LDrawXMain%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKXMAIN)
	Local LDrawYMain%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKYMAIN)
	Local LDrawXSize#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKXSIZE)*FDrawScale
	Local LDrawYSize#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKYSIZE)*FDrawScale
	Local LDrawU1Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKU1MAP)
	Local LDrawV1Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKV1MAP)
	Local LDrawU2Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKU2MAP)
	Local LDrawV2Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKV2MAP)
	;Variablen-Vorberechnung
	FDrawX2=FDrawX2-0.5
	FDrawY2=FDrawY2+0.5
	Local IDrawXOffset#=LDrawXMain*2*LDrawU1Map-1
	Local IDrawYOffset#=LDrawYMain*2*LDrawV1Map-1
	Local IDrawXScale#=(LDrawXMain*2*LDrawU2Map)-IDrawXOffset
	Local IDrawYScale#=(LDrawYMain*2*LDrawV2Map)-IDrawYOffset
	Local IDrawXRelative#=FDrawX1-FDrawX2
	Local IDrawYRelative#=FDrawY1-FDrawY2
	Local IDrawURelative#=0
	Local IDrawVRelative#=0
	;Texel/Textur-Setzen
	If FDrawAngle=0 Then
		If IDrawXRelative>-LDrawXSize Then
			If IDrawXRelative<+LDrawXSize Then
				If IDrawYRelative>-LDrawYSize Then
					If IDrawYRelative<+LDrawYSize Then
						IDrawURelative#=0.5+(IDrawXRelative/LDrawXSize*0.5)
						IDrawVRelative#=0.5-(IDrawYRelative/LDrawYSize*0.5)
						WritePixelFast IDrawXOffset+IDrawXScale*IDrawURelative,IDrawYOffset+IDrawYScale*IDrawVRelative,FDrawARGB,TextureBuffer(LDrawTexture)
					End If
				End If
			End If
		End If
	Else
		Local IDrawAngle#=ATan2(IDrawYRelative,IDrawXRelative)
		Local IDrawRadius#=Sqr((Abs(IDrawXRelative*IDrawXRelative))+(Abs(IDrawYRelative*IDrawYRelative)))
		IDrawXRelative=Cos(-FDrawAngle-IDrawAngle)*IDrawRadius
		IDrawYRelative=Sin(-FDrawAngle-IDrawAngle)*IDrawRadius
		If IDrawXRelative>-LDrawXSize Then
			If IDrawXRelative<+LDrawXSize Then
				If IDrawYRelative>-LDrawYSize Then
					If IDrawYRelative<+LDrawYSize Then
						IDrawURelative#=0.5+(IDrawXRelative/LDrawXSize*0.5)
						IDrawVRelative#=0.5+(IDrawYRelative/LDrawYSize*0.5)
						WritePixelFast IDrawXOffset+IDrawXScale*IDrawURelative,IDrawYOffset+IDrawYScale*IDrawVRelative,FDrawARGB,TextureBuffer(LDrawTexture)
					End If
				End If
			End If
		End If
	End If
End Function




;GetTexel3D( Handle, X-Bullet, Y-Bullet, X-Image, Y-Image, Image-Angle, Image-Scale, ARGB-Mask )
Function GetTexel3D(FDrawHandle%,FDrawX1#,FDrawY1#,FDrawX2#,FDrawY2#,FDrawAngle#=0,FDrawScale#=1,FDrawMask%=$FFFFFFFF)
	;DrawBank-Variablen-AUSweisung
	Local LDrawTexture%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKTEXTURE)
	Local LDrawXMain%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKXMAIN)
	Local LDrawYMain%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKYMAIN)
	Local LDrawXSize#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKXSIZE)*FDrawScale
	Local LDrawYSize#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKYSIZE)*FDrawScale
	Local LDrawU1Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKU1MAP)
	Local LDrawV1Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKV1MAP)
	Local LDrawU2Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKU2MAP)
	Local LDrawV2Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKV2MAP)
	;Variablen-Vorberechnung
	FDrawX2=FDrawX2-0.5
	FDrawY2=FDrawY2+0.5
	Local IDrawXOffset#=LDrawXMain*2*LDrawU1Map-1
	Local IDrawYOffset#=LDrawYMain*2*LDrawV1Map-1
	Local IDrawXScale#=(LDrawXMain*2*LDrawU2Map)-IDrawXOffset
	Local IDrawYScale#=(LDrawYMain*2*LDrawV2Map)-IDrawYOffset
	Local IDrawXRelative#=FDrawX1-FDrawX2
	Local IDrawYRelative#=FDrawY1-FDrawY2
	Local IDrawURelative#=0
	Local IDrawVRelative#=0
	Local IDrawARGB%=0
	;Texel/Textur-Lesen
	If FDrawAngle=0 Then
		If IDrawXRelative>-LDrawXSize Then
			If IDrawXRelative<+LDrawXSize Then
				If IDrawYRelative>-LDrawYSize Then
					If IDrawYRelative<+LDrawYSize Then
						IDrawURelative#=0.5+(IDrawXRelative/LDrawXSize*0.5)
						IDrawVRelative#=0.5-(IDrawYRelative/LDrawYSize*0.5)
						IDrawARGB=ReadPixelFast(IDrawXOffset+IDrawXScale*IDrawURelative,IDrawYOffset+IDrawYScale*IDrawVRelative,TextureBuffer(LDrawTexture))
					End If
				End If
			End If
		End If
	Else
		Local IDrawAngle#=ATan2(IDrawYRelative,IDrawXRelative)
		Local IDrawRadius#=Sqr((Abs(IDrawXRelative*IDrawXRelative))+(Abs(IDrawYRelative*IDrawYRelative)))
		IDrawXRelative=Cos(-FDrawAngle-IDrawAngle)*IDrawRadius
		IDrawYRelative=Sin(-FDrawAngle-IDrawAngle)*IDrawRadius
		If IDrawXRelative>-LDrawXSize Then
			If IDrawXRelative<+LDrawXSize Then
				If IDrawYRelative>-LDrawYSize Then
					If IDrawYRelative<+LDrawYSize Then
						IDrawURelative#=0.5+(IDrawXRelative/LDrawXSize*0.5)
						IDrawVRelative#=0.5+(IDrawYRelative/LDrawYSize*0.5)
						IDrawARGB=ReadPixelFast(IDrawXOffset+IDrawXScale*IDrawURelative,IDrawYOffset+IDrawYScale*IDrawVRelative,TextureBuffer(LDrawTexture))
					End If
				End If
			End If
		End If
	End If
	;Eingabe-Maske-Überprüfen
	If FDrawMask<>$FFFFFFFF Then
		Local IDrawRPMXPos%=0
		Local IDrawRPMWert%=0
		Local IDrawRPMPlus%=1
		;Maske-Zusammenfassen
		For IDrawRPMXPos=0 To 31
			If FDrawMask And 2^IDrawRPMXPos Then
				If IDrawARGB And 2^IDrawRPMXPos Then
					IDrawRPMWert=IDrawRPMWert+IDrawRPMPlus
				End If
				IDrawRPMPlus=IDrawRPMPlus*2
			End If
		Next
		;Ausgabe-Mit-Maske
		Return IDrawRPMWert
	Else
		;Reine-Ausgabe
		Return IDrawARGB
	End If
End Function




;FreeImage3D( Handle )
Function FreeImage3D(FDrawHandle%)
	Local IDrawLoop%
	;Master-Bild
	If PeekInt(GDrawBank,FDrawHandle+DRAWBANKKING)>0 Then
		;Textur-Und-Entity-Entfernen/Löschen
		FreeTexture PeekInt(GDrawBank,FDrawHandle+DRAWBANKTEXTURE)
		ClearSurface PeekInt(GDrawBank,FDrawHandle+DRAWBANKFACE)
		FreeEntity PeekInt(GDrawBank,FDrawHandle+DRAWBANKMESH)
		;Angegebene-Bank-Position-Freigeben
		PokeInt GDrawBank,FDrawHandle+DRAWBANKKING,0
		PokeInt GDrawBank,FDrawHandle+DRAWBANKMESH,0
		PokeInt GDrawBank,FDrawHandle+DRAWBANKFACE,0
		;Bank-Dependencies-GGF-Auch-Freigeben
		For IDrawLoop=DRAWBANKSTEP To GDrawBankUsed Step DRAWBANKSTEP
			If PeekInt(GDrawBank,IDrawLoop+DRAWBANKKING)=-FDrawHandle Then
				PokeInt GDrawBank,IDrawLoop+DRAWBANKKING,0
				PokeInt GDrawBank,IDrawLoop+DRAWBANKMESH,0
				PokeInt GDrawBank,IDrawLoop+DRAWBANKFACE,0
			End If
		Next
	End If
	;Teil-Bild
	If PeekInt(GDrawBank,FDrawHandle+DRAWBANKKING)<0 Then
		;Angegebene-Bank-Position-Freigeben
		PokeInt GDrawBank,FDrawHandle+DRAWBANKKING,0
		PokeInt GDrawBank,FDrawHandle+DRAWBANKMESH,0
		PokeInt GDrawBank,FDrawHandle+DRAWBANKFACE,0
	End If
	;Neue-Bank-Position-Festlegen
	XDrawBP3D()
End Function




;Plot3D( Handle, X-Center, Y-Center, IDrawing-Size )
Function Plot3D(FDrawHandle%,FDrawX#,FDrawY#,FDrawSize#=2)
	;Variablen-Vorberechnung
	If FDrawSize=0 Then FDrawSize=2
	;DrawBank-Variablen-AUSweisung
	Local LDrawFace%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKFACE)
	;Vertex/Ploygon-Zuweisung/Berechnungen
	Local IDrawV0=AddVertex(LDrawFace,FDrawX-FDrawSize-0.5,FDrawY+FDrawSize+0.5,0, 0,0)
	Local IDrawV1=AddVertex(LDrawFace,FDrawX+FDrawSize-0.5,FDrawY+FDrawSize+0.5,0, 1,0)
	Local IDrawV2=AddVertex(LDrawFace,FDrawX+FDrawSize-0.5,FDrawY-FDrawSize+0.5,0, 1,1)
	Local IDrawV3=AddVertex(LDrawFace,FDrawX-FDrawSize-0.5,FDrawY-FDrawSize+0.5,0, 0,1)
	VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
	VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
	VertexColor LDrawFace,IDrawV2,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
	VertexColor LDrawFace,IDrawV3,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
	AddTriangle(LDrawFace,IDrawV0,IDrawV1,IDrawV2)
	AddTriangle(LDrawFace,IDrawV2,IDrawV3,IDrawV0)
End Function




;Line3D( Handle, X-Start, Y-Start, X-End, Y-End, IDrawing-Size )
Function Line3D(FDrawHandle%,FDrawX1#,FDrawY1#,FDrawX2#,FDrawY2#,FDrawSize#=2)
	;DrawBank-Variablen-AUSweisung
	Local LDrawFace%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKFACE)
	;Fehlerkorrektur-Durch-Ausblendung
	If FDrawX1<>FDrawX2 Or FDrawY1<>FDrawY2 Then
		;Variablen-Vorberechnung
		If FDrawSize=0 Then FDrawSize=2
		TFormNormal FDrawX2-FDrawX1,FDrawY2-FDrawY1,0,0,0
		Local IDrawUTForm#=TFormedX()*0.5
		Local IDrawVTForm#=TFormedY()*0.5
		Local IDrawXTForm#=IDrawUTForm*2*FDrawSize
		Local IDrawYTForm#=IDrawVTForm*2*FDrawSize
		;Vertex/Ploygon-Zuweisung/Berechnungen
		Local IDrawV0=AddVertex(LDrawFace,FDrawX1+IDrawYTForm-0.5,FDrawY1-IDrawXTForm+0.5,0, 0.5+IDrawVTForm,0.5+IDrawUTForm)
		Local IDrawV1=AddVertex(LDrawFace,FDrawX1-IDrawYTForm-0.5,FDrawY1+IDrawXTForm+0.5,0, 0.5-IDrawVTForm,0.5-IDrawUTForm)
		Local IDrawV2=AddVertex(LDrawFace,FDrawX2-IDrawYTForm-0.5,FDrawY2+IDrawXTForm+0.5,0, 0.5-IDrawVTForm,0.5-IDrawUTForm)
		Local IDrawV3=AddVertex(LDrawFace,FDrawX2+IDrawYTForm-0.5,FDrawY2-IDrawXTForm+0.5,0, 0.5+IDrawVTForm,0.5+IDrawUTForm)
		VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawV2,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawV3,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		AddTriangle(LDrawFace,IDrawV0,IDrawV1,IDrawV2)
		AddTriangle(LDrawFace,IDrawV2,IDrawV3,IDrawV0)
	End If
End Function




;Rect3D( Handle, X-Center, Y-Center, X-Size, Y-Size, IDrawing-Mode, Border-Size )
Function Rect3D(FDrawHandle%,FDrawX#,FDrawY#,FDrawXS#,FDrawYS#,FDrawFill%=1,FDrawSize#=0)
	;DrawBank-Variablen-AUSweisung
	Local LDrawFace%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKFACE)
	;Variablen-Vorberechnung
	FDrawX=FDrawX-0.5
	FDrawY=FDrawY+0.5
	FDrawXS=Abs(FDrawXS)
	FDrawYS=Abs(FDrawYS)
	;Rahmen-Allein-Modus
	If FDrawFill=0 Then
		If FDrawSize=0 Then FDrawSize=2
		;Vertex/Ploygon-Zuweisung/Berechnungen
		Local IDrawV0=AddVertex(LDrawFace,FDrawX-FDrawXS-FDrawSize,FDrawY+FDrawYS+FDrawSize,0, 0.5,0)
		Local IDrawV1=AddVertex(LDrawFace,FDrawX+FDrawXS+FDrawSize,FDrawY+FDrawYS+FDrawSize,0, 0.5,0)
		Local IDrawV2=AddVertex(LDrawFace,FDrawX+FDrawXS-FDrawSize,FDrawY+FDrawYS-FDrawSize,0, 0.5,1)
		Local IDrawV3=AddVertex(LDrawFace,FDrawX-FDrawXS+FDrawSize,FDrawY+FDrawYS-FDrawSize,0, 0.5,1)
		Local IDrawV4=AddVertex(LDrawFace,FDrawX+FDrawXS+FDrawSize,FDrawY+FDrawYS+FDrawSize,0, 1,0.5)
		Local IDrawV5=AddVertex(LDrawFace,FDrawX+FDrawXS+FDrawSize,FDrawY-FDrawYS-FDrawSize,0, 1,0.5)
		Local IDrawV6=AddVertex(LDrawFace,FDrawX+FDrawXS-FDrawSize,FDrawY-FDrawYS+FDrawSize,0, 0,0.5)
		Local IDrawV7=AddVertex(LDrawFace,FDrawX+FDrawXS-FDrawSize,FDrawY+FDrawYS-FDrawSize,0, 0,0.5)
		Local IDrawV8=AddVertex(LDrawFace,FDrawX+FDrawXS+FDrawSize,FDrawY-FDrawYS-FDrawSize,0, 0.5,1)
		Local IDrawV9=AddVertex(LDrawFace,FDrawX-FDrawXS-FDrawSize,FDrawY-FDrawYS-FDrawSize,0, 0.5,1)
		Local IDrawVA=AddVertex(LDrawFace,FDrawX-FDrawXS+FDrawSize,FDrawY-FDrawYS+FDrawSize,0, 0.5,0)
		Local IDrawVB=AddVertex(LDrawFace,FDrawX+FDrawXS-FDrawSize,FDrawY-FDrawYS+FDrawSize,0, 0.5,0)
		Local IDrawVC=AddVertex(LDrawFace,FDrawX-FDrawXS-FDrawSize,FDrawY-FDrawYS-FDrawSize,0, 0,0.5)
		Local IDrawVD=AddVertex(LDrawFace,FDrawX-FDrawXS-FDrawSize,FDrawY+FDrawYS+FDrawSize,0, 0,0.5)
		Local IDrawVE=AddVertex(LDrawFace,FDrawX-FDrawXS+FDrawSize,FDrawY+FDrawYS-FDrawSize,0, 1,0.5)
		Local IDrawVF=AddVertex(LDrawFace,FDrawX-FDrawXS+FDrawSize,FDrawY-FDrawYS+FDrawSize,0, 1,0.5)
		VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawV2,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawV3,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawV4,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawV5,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawV6,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawV7,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawV8,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawV9,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawVA,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawVB,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawVC,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawVD,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawVE,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawVF,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		AddTriangle(LDrawFace,IDrawV0,IDrawV1,IDrawV2)
		AddTriangle(LDrawFace,IDrawV2,IDrawV3,IDrawV0)
		AddTriangle(LDrawFace,IDrawV4,IDrawV5,IDrawV6)
		AddTriangle(LDrawFace,IDrawV6,IDrawV7,IDrawV4)
		AddTriangle(LDrawFace,IDrawV8,IDrawV9,IDrawVA)
		AddTriangle(LDrawFace,IDrawVA,IDrawVB,IDrawV8)
		AddTriangle(LDrawFace,IDrawVC,IDrawVD,IDrawVE)
		AddTriangle(LDrawFace,IDrawVE,IDrawVF,IDrawVC)
	Else
		;Gefüllt-Allein-Modus | Vertex/Ploygon-Zuweisung/Berechnungen
		IDrawV0=AddVertex(LDrawFace,FDrawX-FDrawXS,FDrawY+FDrawYS,0, 0.5-DRAWRECTOFFSET,0.5-DRAWRECTOFFSET)
		IDrawV1=AddVertex(LDrawFace,FDrawX+FDrawXS,FDrawY+FDrawYS,0, 0.5+DRAWRECTOFFSET,0.5-DRAWRECTOFFSET)
		IDrawV2=AddVertex(LDrawFace,FDrawX+FDrawXS,FDrawY-FDrawYS,0, 0.5+DRAWRECTOFFSET,0.5+DRAWRECTOFFSET)
		IDrawV3=AddVertex(LDrawFace,FDrawX-FDrawXS,FDrawY-FDrawYS,0, 0.5-DRAWRECTOFFSET,0.5+DRAWRECTOFFSET)
		VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawV2,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		VertexColor LDrawFace,IDrawV3,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		AddTriangle(LDrawFace,IDrawV0,IDrawV1,IDrawV2)
		AddTriangle(LDrawFace,IDrawV2,IDrawV3,IDrawV0)
		;Halbrahmen-Hinzufügen
		If FDrawSize>0 Then
			;Vertex/Ploygon-Zuweisung/Berechnungen
			IDrawV4=AddVertex(LDrawFace,FDrawX-FDrawXS-FDrawSize,FDrawY+FDrawYS+FDrawSize,0, 0.5,0)
			IDrawV5=AddVertex(LDrawFace,FDrawX+FDrawXS+FDrawSize,FDrawY+FDrawYS+FDrawSize,0, 0.5,0)
			IDrawV6=AddVertex(LDrawFace,FDrawX+FDrawXS+FDrawSize,FDrawY+FDrawYS+FDrawSize,0, 1,0.5)
			IDrawV7=AddVertex(LDrawFace,FDrawX+FDrawXS+FDrawSize,FDrawY-FDrawYS-FDrawSize,0, 1,0.5)
			IDrawV8=AddVertex(LDrawFace,FDrawX+FDrawXS+FDrawSize,FDrawY-FDrawYS-FDrawSize,0, 0.5,1)
			IDrawV9=AddVertex(LDrawFace,FDrawX-FDrawXS-FDrawSize,FDrawY-FDrawYS-FDrawSize,0, 0.5,1)
			IDrawVA=AddVertex(LDrawFace,FDrawX-FDrawXS-FDrawSize,FDrawY-FDrawYS-FDrawSize,0, 0,0.5)
			IDrawVB=AddVertex(LDrawFace,FDrawX-FDrawXS-FDrawSize,FDrawY+FDrawYS+FDrawSize,0, 0,0.5)
			VertexColor LDrawFace,IDrawV4,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV5,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV6,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV7,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV8,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV9,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawVA,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawVB,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			AddTriangle(LDrawFace,IDrawV4,IDrawV5,IDrawV1)
			AddTriangle(LDrawFace,IDrawV1,IDrawV0,IDrawV4)
			AddTriangle(LDrawFace,IDrawV6,IDrawV7,IDrawV2)
			AddTriangle(LDrawFace,IDrawV2,IDrawV1,IDrawV6)
			AddTriangle(LDrawFace,IDrawV8,IDrawV9,IDrawV3)
			AddTriangle(LDrawFace,IDrawV3,IDrawV2,IDrawV8)
			AddTriangle(LDrawFace,IDrawVA,IDrawVB,IDrawV0)
			AddTriangle(LDrawFace,IDrawV0,IDrawV3,IDrawVA)
		End If
	End If
End Function




;Oval3D( Handle, X-Center, Y-Center, X-Size, Y-Size, IDrawing-Mode, Border-Size )
Function Oval3D(FDrawHandle%,FDrawX#,FDrawY#,FDrawXS#,FDrawYS#,FDrawFill%=1,FDrawSize#=0)
	;DrawBank-Variablen-AUSweisung
	Local LDrawFace%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKFACE)
	;Variablen-Vorberechnung
	FDrawX=FDrawX-0.5
	FDrawY=FDrawY+0.5
	FDrawXS=Abs(FDrawXS)
	FDrawYS=Abs(FDrawYS)
	Local IDrawSequences#=8+Int((FDrawXS+FDrawYS)/20)
	If IDrawSequences>32 Then IDrawSequences=32
	Local IDrawAngle#=90.0/IDrawSequences
	Local IDrawLoop%
	;Rahmen-Allein-Modus
	If FDrawFill=0 Then
		If FDrawSize=0 Then FDrawSize=2
		Local IDrawXOutside#=FDrawXS+FDrawSize
		Local IDrawYOutside#=FDrawYS+FDrawSize
		Local IDrawXInside#=FDrawXS-FDrawSize
		Local IDrawYInside#=FDrawYS-FDrawSize
		For IDrawLoop=1 To IDrawSequences
			;Vertex/Ploygon-Zuweisung/Berechnungen
			Local IDrawXPos1#=Cos(IDrawLoop*IDrawAngle)
			Local IDrawYPos1#=Sin(IDrawLoop*IDrawAngle)
			Local IDrawXPos2#=Cos(IDrawLoop*IDrawAngle-IDrawAngle)
			Local IDrawYPos2#=Sin(IDrawLoop*IDrawAngle-IDrawAngle)
			Local IDrawUPos1#=IDrawXPos1*0.5
			Local IDrawVPos1#=IDrawYPos1*0.5
			Local IDrawUPos2#=IDrawXPos2*0.5
			Local IDrawVPos2#=IDrawYPos2*0.5
			;Oval3D-Quartal-1/4-Mirror
			Local IDrawV0=AddVertex(LDrawFace,FDrawX+IDrawXPos1*IDrawXOutside,FDrawY+IDrawYPos1*IDrawYOutside,0, 0.5+IDrawUPos1,0.5-IDrawVPos1)
			Local IDrawV1=AddVertex(LDrawFace,FDrawX+IDrawXPos2*IDrawXOutside,FDrawY+IDrawYPos2*IDrawYOutside,0, 0.5+IDrawUPos2,0.5-IDrawVPos2)
			Local IDrawV2=AddVertex(LDrawFace,FDrawX+IDrawXPos2*IDrawXInside,FDrawY+IDrawYPos2*IDrawYInside,0, 0.5-IDrawUPos2,0.5+IDrawVPos2)
			Local IDrawV3=AddVertex(LDrawFace,FDrawX+IDrawXPos1*IDrawXInside,FDrawY+IDrawYPos1*IDrawYInside,0, 0.5-IDrawUPos1,0.5+IDrawVPos1)
			VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV2,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV3,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			AddTriangle(LDrawFace,IDrawV0,IDrawV1,IDrawV2)
			AddTriangle(LDrawFace,IDrawV2,IDrawV3,IDrawV0)
			;Oval3D-Quartal-2/4-Mirror
			IDrawV0=AddVertex(LDrawFace,FDrawX+IDrawXPos1*IDrawXOutside,FDrawY-IDrawYPos1*IDrawYOutside,0, 0.5+IDrawUPos1,0.5+IDrawVPos1)
			IDrawV1=AddVertex(LDrawFace,FDrawX+IDrawXPos2*IDrawXOutside,FDrawY-IDrawYPos2*IDrawYOutside,0, 0.5+IDrawUPos2,0.5+IDrawVPos2)
			IDrawV2=AddVertex(LDrawFace,FDrawX+IDrawXPos2*IDrawXInside,FDrawY-IDrawYPos2*IDrawYInside,0, 0.5-IDrawUPos2,0.5-IDrawVPos2)
			IDrawV3=AddVertex(LDrawFace,FDrawX+IDrawXPos1*IDrawXInside,FDrawY-IDrawYPos1*IDrawYInside,0, 0.5-IDrawUPos1,0.5-IDrawVPos1)
			VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV2,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV3,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			AddTriangle(LDrawFace,IDrawV0,IDrawV1,IDrawV2)
			AddTriangle(LDrawFace,IDrawV2,IDrawV3,IDrawV0)
			;Oval3D-Quartal-3/4-Mirror
			IDrawV0=AddVertex(LDrawFace,FDrawX-IDrawXPos1*IDrawXOutside,FDrawY-IDrawYPos1*IDrawYOutside,0, 0.5-IDrawUPos1,0.5+IDrawVPos1)
			IDrawV1=AddVertex(LDrawFace,FDrawX-IDrawXPos2*IDrawXOutside,FDrawY-IDrawYPos2*IDrawYOutside,0, 0.5-IDrawUPos2,0.5+IDrawVPos2)
			IDrawV2=AddVertex(LDrawFace,FDrawX-IDrawXPos2*IDrawXInside,FDrawY-IDrawYPos2*IDrawYInside,0, 0.5+IDrawUPos2,0.5-IDrawVPos2)
			IDrawV3=AddVertex(LDrawFace,FDrawX-IDrawXPos1*IDrawXInside,FDrawY-IDrawYPos1*IDrawYInside,0, 0.5+IDrawUPos1,0.5-IDrawVPos1)
			VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV2,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV3,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			AddTriangle(LDrawFace,IDrawV0,IDrawV1,IDrawV2)
			AddTriangle(LDrawFace,IDrawV2,IDrawV3,IDrawV0)
			;Oval3D-Quartal-4/4-Mirror
			IDrawV0=AddVertex(LDrawFace,FDrawX-IDrawXPos1*IDrawXOutside,FDrawY+IDrawYPos1*IDrawYOutside,0, 0.5-IDrawUPos1,0.5-IDrawVPos1)
			IDrawV1=AddVertex(LDrawFace,FDrawX-IDrawXPos2*IDrawXOutside,FDrawY+IDrawYPos2*IDrawYOutside,0, 0.5-IDrawUPos2,0.5-IDrawVPos2)
			IDrawV2=AddVertex(LDrawFace,FDrawX-IDrawXPos2*IDrawXInside,FDrawY+IDrawYPos2*IDrawYInside,0, 0.5+IDrawUPos2,0.5+IDrawVPos2)
			IDrawV3=AddVertex(LDrawFace,FDrawX-IDrawXPos1*IDrawXInside,FDrawY+IDrawYPos1*IDrawYInside,0, 0.5+IDrawUPos1,0.5+IDrawVPos1)
			VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV2,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			VertexColor LDrawFace,IDrawV3,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
			AddTriangle(LDrawFace,IDrawV0,IDrawV1,IDrawV2)
			AddTriangle(LDrawFace,IDrawV2,IDrawV3,IDrawV0)
		Next
	Else
		;Mittelpunkt-Vertex-Zuweisung/Berechnungen
		Local IDrawVC=AddVertex(LDrawFace,FDrawX,FDrawY,0, 0.5,0.5)
		VertexColor LDrawFace,IDrawVC,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
		;Gefüllt+Halbrahmen-Modus
		If FDrawSize>0 Then
			IDrawXOutside#=FDrawXS+FDrawSize
			IDrawYOutside#=FDrawYS+FDrawSize
			For IDrawLoop=1 To IDrawSequences
				;Vertex/Ploygon-Zuweisung/Berechnungen
				IDrawXPos1#=Cos(IDrawLoop*IDrawAngle)
				IDrawYPos1#=Sin(IDrawLoop*IDrawAngle)
				IDrawXPos2#=Cos(IDrawLoop*IDrawAngle-IDrawAngle)
				IDrawYPos2#=Sin(IDrawLoop*IDrawAngle-IDrawAngle)
				IDrawUPos1#=IDrawXPos1*0.5
				IDrawVPos1#=IDrawYPos1*0.5
				IDrawUPos2#=IDrawXPos2*0.5
				IDrawVPos2#=IDrawYPos2*0.5
				;Oval3D-Quartal-1/4-Mirror
				IDrawV0=AddVertex(LDrawFace,FDrawX+IDrawXPos1*IDrawXOutside,FDrawY+IDrawYPos1*IDrawYOutside,0, 0.5+IDrawUPos1,0.5-IDrawVPos1)
				IDrawV1=AddVertex(LDrawFace,FDrawX+IDrawXPos2*IDrawXOutside,FDrawY+IDrawYPos2*IDrawYOutside,0, 0.5+IDrawUPos2,0.5-IDrawVPos2)
				IDrawV2=AddVertex(LDrawFace,FDrawX+IDrawXPos2*FDrawXS,FDrawY+IDrawYPos2*FDrawYS,0, 0.5,0.5)
				IDrawV3=AddVertex(LDrawFace,FDrawX+IDrawXPos1*FDrawXS,FDrawY+IDrawYPos1*FDrawYS,0, 0.5,0.5)
				VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				VertexColor LDrawFace,IDrawV2,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				VertexColor LDrawFace,IDrawV3,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				AddTriangle(LDrawFace,IDrawV0,IDrawV1,IDrawV2)
				AddTriangle(LDrawFace,IDrawV2,IDrawV3,IDrawV0)
				AddTriangle(LDrawFace,IDrawVC,IDrawV3,IDrawV2)
				;Oval3D-Quartal-2/4-Mirror
				IDrawV0=AddVertex(LDrawFace,FDrawX+IDrawXPos1*IDrawXOutside,FDrawY-IDrawYPos1*IDrawYOutside,0, 0.5+IDrawUPos1,0.5+IDrawVPos1)
				IDrawV1=AddVertex(LDrawFace,FDrawX+IDrawXPos2*IDrawXOutside,FDrawY-IDrawYPos2*IDrawYOutside,0, 0.5+IDrawUPos2,0.5+IDrawVPos2)
				IDrawV2=AddVertex(LDrawFace,FDrawX+IDrawXPos2*FDrawXS,FDrawY-IDrawYPos2*FDrawYS,0, 0.5,0.5)
				IDrawV3=AddVertex(LDrawFace,FDrawX+IDrawXPos1*FDrawXS,FDrawY-IDrawYPos1*FDrawYS,0, 0.5,0.5)
				VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				VertexColor LDrawFace,IDrawV2,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				VertexColor LDrawFace,IDrawV3,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				AddTriangle(LDrawFace,IDrawV0,IDrawV1,IDrawV2)
				AddTriangle(LDrawFace,IDrawV2,IDrawV3,IDrawV0)
				AddTriangle(LDrawFace,IDrawVC,IDrawV3,IDrawV2)
				;Oval3D-Quartal-3/4-Mirror
				IDrawV0=AddVertex(LDrawFace,FDrawX-IDrawXPos1*IDrawXOutside,FDrawY-IDrawYPos1*IDrawYOutside,0, 0.5-IDrawUPos1,0.5+IDrawVPos1)
				IDrawV1=AddVertex(LDrawFace,FDrawX-IDrawXPos2*IDrawXOutside,FDrawY-IDrawYPos2*IDrawYOutside,0, 0.5-IDrawUPos2,0.5+IDrawVPos2)
				IDrawV2=AddVertex(LDrawFace,FDrawX-IDrawXPos2*FDrawXS,FDrawY-IDrawYPos2*FDrawYS,0, 0.5,0.5)
				IDrawV3=AddVertex(LDrawFace,FDrawX-IDrawXPos1*FDrawXS,FDrawY-IDrawYPos1*FDrawYS,0, 0.5,0.5)
				VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				VertexColor LDrawFace,IDrawV2,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				VertexColor LDrawFace,IDrawV3,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				AddTriangle(LDrawFace,IDrawV0,IDrawV1,IDrawV2)
				AddTriangle(LDrawFace,IDrawV2,IDrawV3,IDrawV0)
				AddTriangle(LDrawFace,IDrawVC,IDrawV3,IDrawV2)
				;Oval3D-Quartal-4/4-Mirror
				IDrawV0=AddVertex(LDrawFace,FDrawX-IDrawXPos1*IDrawXOutside,FDrawY+IDrawYPos1*IDrawYOutside,0, 0.5-IDrawUPos1,0.5-IDrawVPos1)
				IDrawV1=AddVertex(LDrawFace,FDrawX-IDrawXPos2*IDrawXOutside,FDrawY+IDrawYPos2*IDrawYOutside,0, 0.5-IDrawUPos2,0.5-IDrawVPos2)
				IDrawV2=AddVertex(LDrawFace,FDrawX-IDrawXPos2*FDrawXS,FDrawY+IDrawYPos2*FDrawYS,0, 0.5,0.5)
				IDrawV3=AddVertex(LDrawFace,FDrawX-IDrawXPos1*FDrawXS,FDrawY+IDrawYPos1*FDrawYS,0, 0.5,0.5)
				VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				VertexColor LDrawFace,IDrawV2,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				VertexColor LDrawFace,IDrawV3,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				AddTriangle(LDrawFace,IDrawV0,IDrawV1,IDrawV2)
				AddTriangle(LDrawFace,IDrawV2,IDrawV3,IDrawV0)
				AddTriangle(LDrawFace,IDrawVC,IDrawV3,IDrawV2)
			Next
		Else
			;Gefüllt-Allein-Modus
			For IDrawLoop=1 To IDrawSequences
				;Vertex/Ploygon-Zuweisung/Berechnungen
				IDrawXPos1#=Cos(IDrawLoop*IDrawAngle)
				IDrawYPos1#=Sin(IDrawLoop*IDrawAngle)
				IDrawXPos2#=Cos(IDrawLoop*IDrawAngle-IDrawAngle)
				IDrawYPos2#=Sin(IDrawLoop*IDrawAngle-IDrawAngle)
				;Oval3D-Quartal-1/4-Mirror
				IDrawV0=AddVertex(LDrawFace,FDrawX+IDrawXPos1*FDrawXS,FDrawY+IDrawYPos1*FDrawYS,0, 0.5,0.5)
				IDrawV1=AddVertex(LDrawFace,FDrawX+IDrawXPos2*FDrawXS,FDrawY+IDrawYPos2*FDrawYS,0, 0.5,0.5)
				VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				AddTriangle(LDrawFace,IDrawVC,IDrawV1,IDrawV0)
				;Oval3D-Quartal-2/4-Mirror
				IDrawV0=AddVertex(LDrawFace,FDrawX+IDrawXPos1*FDrawXS,FDrawY-IDrawYPos1*FDrawYS,0, 0.5,0.5)
				IDrawV1=AddVertex(LDrawFace,FDrawX+IDrawXPos2*FDrawXS,FDrawY-IDrawYPos2*FDrawYS,0, 0.5,0.5)
				VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				AddTriangle(LDrawFace,IDrawVC,IDrawV1,IDrawV0)
				;Oval3D-Quartal-3/4-Mirror
				IDrawV0=AddVertex(LDrawFace,FDrawX-IDrawXPos1*FDrawXS,FDrawY-IDrawYPos1*FDrawYS,0, 0.5,0.5)
				IDrawV1=AddVertex(LDrawFace,FDrawX-IDrawXPos2*FDrawXS,FDrawY-IDrawYPos2*FDrawYS,0, 0.5,0.5)
				VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				AddTriangle(LDrawFace,IDrawVC,IDrawV1,IDrawV0)
				;Oval3D-Quartal-4/4-Mirror
				IDrawV0=AddVertex(LDrawFace,FDrawX-IDrawXPos1*FDrawXS,FDrawY+IDrawYPos1*FDrawYS,0, 0.5,0.5)
				IDrawV1=AddVertex(LDrawFace,FDrawX-IDrawXPos2*FDrawXS,FDrawY+IDrawYPos2*FDrawYS,0, 0.5,0.5)
				VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
				AddTriangle(LDrawFace,IDrawVC,IDrawV1,IDrawV0)
			Next
		End If
	End If
End Function




;Poly3D( Handle, X1-Pos, Y1-Pos, X2-Pos, Y2-Pos, X3-Pos, Y3-Pos )
Function Poly3D(FDrawHandle%,FDrawX1#,FDrawY1#,FDrawX2#,FDrawY2#,FDrawX3#,FDrawY3#)
	;DrawBank-Variablen-AUSweisung
	Local LDrawFace%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKFACE)
	;Vertex/Ploygon-Zuweisung/Berechnungen
	Local IDrawV0=AddVertex(LDrawFace,FDrawX1-0.5,FDrawY1+0.5,0, 0.5,0.5)
	Local IDrawV1=AddVertex(LDrawFace,FDrawX2-0.5,FDrawY2+0.5,0, 0.5,0.5)
	Local IDrawV2=AddVertex(LDrawFace,FDrawX3-0.5,FDrawY3+0.5,0, 0.5,0.5)
	VertexColor LDrawFace,IDrawV0,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
	VertexColor LDrawFace,IDrawV1,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
	VertexColor LDrawFace,IDrawV2,GDrawNFR,GDrawNFG,GDrawNFB,GDrawNFA
	AddTriangle(LDrawFace,IDrawV0,IDrawV1,IDrawV2)
End Function





;Text3D( Handle, X-Center-Position, Y-Center-Position, Text-String, Text-Align, Button, Rotation )
Function Text3D(FDrawHandle%,FDrawX#,FDrawY#,FDrawString$,FDrawAlign#=0,FDrawButton%=0,FDrawAngle#=0)
	If FDrawHandle=0 Then RuntimeError "Handle not set"
	;DrawBank-Variablen-AUSweisung
	Local LDrawFace%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKFACE)
	Local LDrawBank%=PeekInt(GDrawBank,FDrawHandle+DRAWFONTBANK)
	Local LDrawSize%=PeekInt(GDrawBank,FDrawHandle+DRAWFONTSIZE)
	;Variablen-Vorberechnung
	FDrawX=FDrawX-0.5
	FDrawY=FDrawY+0.5
	Local IDrawLen%=Len(FDrawString)
	Local IDrawXVector#=Cos(-FDrawAngle)*GDrawSFont
	Local IDrawYVector#=Sin(-FDrawAngle)*GDrawSFont
	Local IDrawXI#=IDrawXVector*GDrawIFont*GDrawHFont
	Local IDrawYI#=IDrawYVector*GDrawIFont*GDrawHFont
	Local IDrawX1Pos#=FDrawX-IDrawYVector*GDrawHFont*0.5*LDrawSize+IDrawXI
	Local IDrawY1Pos#=FDrawY+IDrawXVector*GDrawHFont*0.5*LDrawSize+IDrawYI
	Local IDrawX4Pos#=FDrawX+IDrawYVector*GDrawHFont*0.5*LDrawSize-IDrawXI
	Local IDrawY4Pos#=FDrawY-IDrawXVector*GDrawHFont*0.5*LDrawSize-IDrawYI
	Local IDrawLoop%
	;String-GGF-Ausrichten
	If FDrawAlign<>0 Then
		For IDrawLoop=1 To IDrawLen
			Local IDrawAsc=Asc(Mid$(FDrawString,IDrawLoop,1))
			Local LDrawWidth%=PeekByte(GDrawFontBank,LDrawBank+IDrawAsc)
			IDrawX1Pos=IDrawX1Pos-(LDrawWidth*IDrawXVector+GDrawPFont*IDrawXVector)*FDrawAlign*0.5
			IDrawY1Pos=IDrawY1Pos-(LDrawWidth*IDrawYVector+GDrawPFont*IDrawYVector)*FDrawAlign*0.5
			IDrawX4Pos=IDrawX4Pos-(LDrawWidth*IDrawXVector+GDrawPFont*IDrawXVector)*FDrawAlign*0.5
			IDrawY4Pos=IDrawY4Pos-(LDrawWidth*IDrawYVector+GDrawPFont*IDrawYVector)*FDrawAlign*0.5
		Next
		If FDrawAngle=0 Then
			IDrawX1Pos=Floor(IDrawX1Pos)-0.5
			IDrawY1Pos=Floor(IDrawY1Pos)+0.5
			IDrawX4Pos=Floor(IDrawX4Pos)-0.5
			IDrawY4Pos=Floor(IDrawY4Pos)+0.5
		End If
	End If
	Local IDrawX1Temp#=IDrawX1Pos
	Local IDrawY1Temp#=IDrawY1Pos
	Local IDrawX4Temp#=IDrawX4Pos
	Local IDrawY4Temp#=IDrawY4Pos
	;String-Durchgehend-Zeichnen
	For IDrawLoop=1 To IDrawLen
		IDrawAsc=Asc(Mid$(FDrawString,IDrawLoop,1))
		LDrawWidth%=PeekByte(GDrawFontBank,LDrawBank+IDrawAsc)
		Local IDrawX2Pos#=IDrawX1Pos+IDrawXVector*LDrawWidth
		Local IDrawY2Pos#=IDrawY1Pos+IDrawYVector*LDrawWidth
		Local IDrawX3Pos#=IDrawX4Pos+IDrawXVector*LDrawWidth
		Local IDrawY3Pos#=IDrawY4Pos+IDrawYVector*LDrawWidth
		Local IDrawU1Map#=(IDrawAsc Mod 16)*DRAWFONTUVSTEP
		Local IDrawV1Map#=Floor(IDrawAsc/16)*DRAWFONTUVSTEP
		Local IDrawU2Map#=IDrawU1Map+DRAWFONTUVSTEP*LDrawWidth/LDrawSize
		Local IDrawV2Map#=IDrawV1Map+DRAWFONTUVSTEP
		;Vertex/Ploygon-Zuweisung/Berechnungen
		Local IDrawV0=AddVertex(LDrawFace,IDrawX1Pos,IDrawY1Pos,0, IDrawU1Map,IDrawV1Map)
		Local IDrawV1=AddVertex(LDrawFace,IDrawX2Pos,IDrawY2Pos,0, IDrawU2Map,IDrawV1Map)
		Local IDrawV2=AddVertex(LDrawFace,IDrawX3Pos,IDrawY3Pos,0, IDrawU2Map,IDrawV2Map)
		Local IDrawV3=AddVertex(LDrawFace,IDrawX4Pos,IDrawY4Pos,0, IDrawU1Map,IDrawV2Map)
		VertexColor LDrawFace,IDrawV0,GDrawTFR,GDrawTFG,GDrawTFB,GDrawTFA
		VertexColor LDrawFace,IDrawV1,GDrawTFR,GDrawTFG,GDrawTFB,GDrawTFA
		VertexColor LDrawFace,IDrawV2,GDrawTFR,GDrawTFG,GDrawTFB,GDrawTFA
		VertexColor LDrawFace,IDrawV3,GDrawTFR,GDrawTFG,GDrawTFB,GDrawTFA
		AddTriangle LDrawFace,IDrawV0,IDrawV1,IDrawV2
		AddTriangle LDrawFace,IDrawV2,IDrawV3,IDrawV0
		IDrawX1Pos=IDrawX1Pos+LDrawWidth*IDrawXVector+GDrawPFont*IDrawXVector
		IDrawY1Pos=IDrawY1Pos+LDrawWidth*IDrawYVector+GDrawPFont*IDrawYVector
		IDrawX4Pos=IDrawX4Pos+LDrawWidth*IDrawXVector+GDrawPFont*IDrawXVector
		IDrawY4Pos=IDrawY4Pos+LDrawWidth*IDrawYVector+GDrawPFont*IDrawYVector
	Next
	If FDrawButton<>0 Then CheckQuad3D(IDrawX1Temp,IDrawY1Temp,IDrawX2Pos,IDrawY2Pos,IDrawX3Pos,IDrawY3Pos,IDrawX4Temp,IDrawY4Temp,FDrawButton,FDrawString)
End Function




;StringWidth3D( Handle, Text-String )
Function StringWidth3D(FDrawHandle%,FDrawString$)
	If FDrawHandle=0 Then RuntimeError "Handle not set"
	;DrawBank-Variablen-AUSweisung
	Local LDrawBank%=PeekInt(GDrawBank,FDrawHandle+DRAWFONTBANK)
	;Variablen-Vorberechnung
	Local IDrawLen%=Len(FDrawString)
	Local IDrawWidth#=0
	Local IDrawLoop%
	;Stringlänge-Berechnen
	For IDrawLoop=1 To IDrawLen
		Local IDrawAsc=Asc(Mid$(FDrawString,IDrawLoop,1))
		Local LDrawWidth%=PeekByte(GDrawFontBank,LDrawBank+IDrawAsc)
		IDrawWidth=IDrawWidth+LDrawWidth+GDrawPFont
	Next
	;Variablen-Ausstiegsvorbereitung
	Return IDrawWidth*GDrawSFont-GDrawPFont
End Function




;USwap3D( Handle, Image-Frame )
Function USwap3D(FDrawHandle%,FDrawFrame%=0)
	FDrawFrame=FDrawFrame*DRAWBANKSTEP
	;DrawBank-Variablen-AUSweisung
	Local LDrawU1Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKU1MAP+FDrawFrame)
	Local LDrawU2Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKU2MAP+FDrawFrame)
	;DrawBank-Variablen-EINweisung
	PokeFloat GDrawBank,FDrawHandle+DRAWBANKU1MAP+FDrawFrame,LDrawU2Map
	PokeFloat GDrawBank,FDrawHandle+DRAWBANKU2MAP+FDrawFrame,LDrawU1Map
End Function




;VSwap3D( Handle, Image-Frame )
Function VSwap3D(FDrawHandle%,FDrawFrame%=0)
	FDrawFrame=FDrawFrame*DRAWBANKSTEP
	;DrawBank-Variablen-AUSweisung
	Local LDrawV1Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKV1MAP+FDrawFrame)
	Local LDrawV2Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKV2MAP+FDrawFrame)
	;DrawBank-Variablen-EINweisung
	PokeFloat GDrawBank,FDrawHandle+DRAWBANKV1MAP+FDrawFrame,LDrawV2Map
	PokeFloat GDrawBank,FDrawHandle+DRAWBANKV2MAP+FDrawFrame,LDrawV1Map
End Function




;CheckQuad3D( X1-Pos, Y1-Pos, X2-Pos, Y2-Pos, X3-Pos, Y3-Pos, X4-Pos, Y4-Pos, Button-Handle, Image-Text )
Function CheckQuad3D(FDrawX1#,FDrawY1#,FDrawX2#,FDrawY2#,FDrawX3#,FDrawY3#,FDrawX4#,FDrawY4#,FDrawButton%=1,FDrawOver$="not set")
	;Variablen-Vorberechnung
	MouseOver3D=0
	MouseDown3D=0
	MouseHit3D=0
	MousePit3D=0
	;Quadkollision-Berechnen/CheckQuad3D-Anwenden
	If (FDrawY2-FDrawY1)*(MouseX3DOld-FDrawX2)-(FDrawX2-FDrawX1)*(MouseY3DOld-FDrawY2)=>0 Then
		If (FDrawY3-FDrawY2)*(MouseX3DOld-FDrawX3)-(FDrawX3-FDrawX2)*(MouseY3DOld-FDrawY3)=>0 Then
			If (FDrawY4-FDrawY3)*(MouseX3DOld-FDrawX4)-(FDrawX4-FDrawX3)*(MouseY3DOld-FDrawY4)=>0 Then
				If (FDrawY1-FDrawY4)*(MouseX3DOld-FDrawX1)-(FDrawX1-FDrawX4)*(MouseY3DOld-FDrawY1)=>0 Then
					;Globale-Maus-Variablen-Berechnung
					MouseDown3D=MouseDown(1)+(MouseDown(2)*2)+(MouseDown(3)*4)
					If GDrawMouseHit=0 Then MouseHit3D=MouseDown3D
					If GDrawMousePit<>FDrawOver Then MousePit3D=1
					GDrawMouseHit=MouseDown3D
					GDrawMousePit=FDrawOver
					MouseText3D=FDrawOver
					MouseOver3D=1
					;Nur-Wenn-Imagehandle-Gegeben
					If FDrawButton<>0 Then
						If FDrawButton Mod DRAWBANKSTEP=0 Then
							;DrawBank-Variablen-AUSweisung
							Local LDrawFace%=PeekInt(GDrawBank,FDrawButton+DRAWBANKFACE+(MouseDown3D>0)*DRAWBANKSTEP)
							Local LDrawU1Map#=PeekFloat(GDrawBank,FDrawButton+DRAWBANKU1MAP+(MouseDown3D>0)*DRAWBANKSTEP)
							Local LDrawV1Map#=PeekFloat(GDrawBank,FDrawButton+DRAWBANKV1MAP+(MouseDown3D>0)*DRAWBANKSTEP)
							Local LDrawU2Map#=PeekFloat(GDrawBank,FDrawButton+DRAWBANKU2MAP+(MouseDown3D>0)*DRAWBANKSTEP)
							Local LDrawV2Map#=PeekFloat(GDrawBank,FDrawButton+DRAWBANKV2MAP+(MouseDown3D>0)*DRAWBANKSTEP)
							;Vertex/Ploygon-Zuweisung/Berechnungen
							Local IDrawV0=AddVertex(LDrawFace,FDrawX1,FDrawY1,0 ,LDrawU1Map,LDrawV1Map)
							Local IDrawV1=AddVertex(LDrawFace,FDrawX2,FDrawY2,0 ,LDrawU2Map,LDrawV1Map)
							Local IDrawV2=AddVertex(LDrawFace,FDrawX3,FDrawY3,0 ,LDrawU2Map,LDrawV2Map)
							Local IDrawV3=AddVertex(LDrawFace,FDrawX4,FDrawY4,0 ,LDrawU1Map,LDrawV2Map)
							VertexColor LDrawFace,IDrawV0,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
							VertexColor LDrawFace,IDrawV1,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
							VertexColor LDrawFace,IDrawV2,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
							VertexColor LDrawFace,IDrawV3,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
							AddTriangle LDrawFace,IDrawV0,IDrawV1,IDrawV2
							AddTriangle LDrawFace,IDrawV2,IDrawV3,IDrawV0
						End If
					End If
					;Ausstiegsvorbereitung
					Return True
				End If
			End If
		End If
	End If
End Function




;XDrawMP3D( Handle, Mask-Alpha )
Function XDrawMP3D(FDrawHandle%,FDrawAlpha%=0)
	;DrawBank-Variablen-AUSweisung
	Local LDrawTexture%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKTEXTURE)
	Local LDrawXMain%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKXMAIN)*2
	Local LDrawYMain%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKYMAIN)*2
	;Variablen-Vorberechnung
	Local IDrawXLoop%=0
	Local IDrawYLoop%=0
	Local IDrawColor%=0
	;Maske-Auf-Textur-Anwendung
	LockBuffer TextureBuffer(LDrawTexture)
	If FDrawAlpha=3 Then
		;Alphamaske-Hinzufügen
		For IDrawYLoop=0 To LDrawYMain-1
			For IDrawXLoop=0 To LDrawXMain-1
				IDrawColor=ReadPixelFast(IDrawXLoop,IDrawYLoop,TextureBuffer(LDrawTexture))
				WritePixelFast IDrawXLoop,IDrawYLoop,$FF000000+(IDrawColor And $FFFFFF),TextureBuffer(LDrawTexture)
			Next
		Next
	Else
		;MAV-Workaround-Für-FAST
		For IDrawYLoop=0 To LDrawYMain-1
			For IDrawXLoop=0 To LDrawXMain-1
				IDrawColor=ReadPixelFast(IDrawXLoop,IDrawYLoop,TextureBuffer(LDrawTexture))
				WritePixelFast IDrawXLoop,IDrawYLoop,IDrawColor,TextureBuffer(LDrawTexture)
			Next
		Next
	End If
	UnlockBuffer TextureBuffer(LDrawTexture)
End Function




;XDrawBP3D( )
Function XDrawBP3D()
	;Start-Draw-Bank-Vorgabe
	Local IDrawBP%=DRAWBANKSTEP
	;Nächst-Freie-Bank-Suchen
	Repeat
		If PeekInt(GDrawBank,IDrawBP+DRAWBANKKING)=0 Then Exit
		IDrawBP=IDrawBP+DRAWBANKSTEP
		If IDrawBP>(DRAWBANKSIZE*DRAWBANKSTEP) Then
			RuntimeError "GDrawBank is to small"
		End If
	Forever
	;Bank-Benutzungseingrenzung-Festlegen
	If IDrawBP>GDrawBankUsed Then GDrawBankUsed=IDrawBP
	;Variablen-Ausstiegsvorbereitung
	Return IDrawBP
End Function




;XDrawFP3D( )
Function XDrawFP3D()
	;Start-Font-Bank-Vorgabe
	Local IDrawFP%=0
	;Nächst-Freie-Bank-Suchen
	Repeat
		If PeekByte(GDrawFontBank,IDrawFP+DRAWBANKKING)=0 Then Exit
		IDrawFP=IDrawFP+DRAWFONTBANKSTEP
		If IDrawFP>(DRAWFONTBANKSIZE*DRAWFONTBANKSTEP) Then
			RuntimeError "GDrawFontBank is to small"
		End If
	Forever
	;Variablen-Ausstiegsvorbereitung
	Return IDrawFP
End Function




;XDrawTT3D( Handle, X-Main, Y-Main, X-Tile-Pos, Y-Tile-Pos )
Function XDrawTT3D(FDrawHandle%,FDrawXT%,FDrawYT%,FDrawXP%,FDrawYP%)
	;Variablen-Vorberechnung
	Local IDrawXSize%=FDrawXT/16
	Local IDrawYSize%=FDrawYT/16
	Local IDrawField%=CreateBank(IDrawXSize*IDrawYSize*4)
	Local IDrawXTile%=IDrawXSize*FDrawXP
	Local IDrawYTile%=IDrawYSize*FDrawYP
	Local IDrawXLoop%=0
	Local IDrawYLoop%=0
	Local IDrawValue%=0
	Local IDrawLSet%=0
	Local IDrawRSet%=0
	Local IDrawXPos%=0
	;Textursymbol-Zwischenspeichern
	For IDrawXLoop=0 To IDrawXSize-1 Step+1
		For IDrawYLoop=0 To IDrawYSize-1 Step+1
			IDrawValue=ReadPixelFast(IDrawXTile+IDrawXLoop,IDrawYTile+IDrawYLoop,TextureBuffer(FDrawHandle))
			WritePixelFast IDrawXTile+IDrawXLoop,IDrawYTile+IDrawYLoop,$00000000,TextureBuffer(FDrawHandle)
			PokeInt IDrawField,(IDrawXLoop*IDrawYSize+IDrawYLoop)*4,IDrawValue
		Next
	Next
	;Linke-Grenze-Des-Symbols-Suchen
	For IDrawXLoop=IDrawXSize-1 To 0 Step-1
		For IDrawYLoop=0 To IDrawYSize-1 Step+1
			If PeekInt(IDrawField,(IDrawXLoop*IDrawYSize+IDrawYLoop)*4) Shr 24 <> 0 Then IDrawLSet=IDrawXLoop
		Next
	Next
	;Rechte-Grenze-Des-Symbols-Suchen
	For IDrawXLoop=0 To IDrawXSize-1 Step+1
		For IDrawYLoop=0 To IDrawYSize-1 Step+1
			If PeekInt(IDrawField,(IDrawXLoop*IDrawYSize+IDrawYLoop)*4) Shr 24 <> 0 Then IDrawRSet=IDrawXLoop
		Next
	Next
	;Symbol-Nach-Links-Verschieben
	For IDrawXLoop=0 To IDrawXSize-1 Step+1
		For IDrawYLoop=0 To IDrawYSize-1 Step+1
			IDrawXPos=IDrawXLoop+IDrawLSet
			If IDrawXPos=>0 And IDrawXPos<IDrawXSize Then
				IDrawValue=PeekInt(IDrawField,(IDrawXPos*IDrawYSize+IDrawYLoop)*4)
				WritePixelFast IDrawXTile+IDrawXLoop,IDrawYTile+IDrawYLoop,IDrawValue,TextureBuffer(FDrawHandle)
			End If
		Next
	Next
	;Variablen-Ausstiegsvorbereitung
	Return IDrawRSet-IDrawLSet+1+FDrawXT/512
End Function



;XDrawPlot3D( Handle, X-Center-Position, Y-Center-Position, Size, Angle )
Function XDrawPP3D(FDrawHandle%,FDrawX#,FDrawY#,FDrawSize#,FDrawAngle#)
	;DrawBank-Variablen-AUSweisung
	Local LDrawFace%=PeekInt(GDrawBank,FDrawHandle+DRAWBANKFACE)
	Local LDrawU1Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKU1MAP)
	Local LDrawV1Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKV1MAP)
	Local LDrawU2Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKU2MAP)
	Local LDrawV2Map#=PeekFloat(GDrawBank,FDrawHandle+DRAWBANKV2MAP)
	;Variablen-Vorberechnung
	FDrawX=FDrawX-0.5
	FDrawY=FDrawY+0.5
	FDrawSize=FDrawSize*1.41421
	Local IDrawXPos1#=Cos(45+FDrawAngle)*FDrawSize
	Local IDrawYPos1#=Sin(45+FDrawAngle)*FDrawSize
	Local IDrawXPos2#=Cos(45-FDrawAngle)*FDrawSize
	Local IDrawYPos2#=Sin(45-FDrawAngle)*FDrawSize
	;Vertex/Ploygon-Zuweisung/Berechnungen
	Local IDrawV0=AddVertex(LDrawFace,FDrawX-IDrawXPos1,FDrawY+IDrawYPos1,0 ,LDrawU1Map,LDrawV1Map)
	Local IDrawV1=AddVertex(LDrawFace,FDrawX+IDrawXPos2,FDrawY+IDrawYPos2,0 ,LDrawU2Map,LDrawV1Map)
	Local IDrawV2=AddVertex(LDrawFace,FDrawX+IDrawXPos1,FDrawY-IDrawYPos1,0 ,LDrawU2Map,LDrawV2Map)
	Local IDrawV3=AddVertex(LDrawFace,FDrawX-IDrawXPos2,FDrawY-IDrawYPos2,0 ,LDrawU1Map,LDrawV2Map)
	VertexColor LDrawFace,IDrawV0,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
	VertexColor LDrawFace,IDrawV1,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
	VertexColor LDrawFace,IDrawV2,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
	VertexColor LDrawFace,IDrawV3,GDrawGFR,GDrawGFG,GDrawGFB,GDrawGFA
	AddTriangle LDrawFace,IDrawV0,IDrawV1,IDrawV2
	AddTriangle LDrawFace,IDrawV2,IDrawV3,IDrawV0
End Function


;~IDEal Editor Parameters:
;~C#Blitz3D