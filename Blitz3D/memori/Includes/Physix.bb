



;Physix.V.1.0
;15.04.2008
;Autor.hectic
;www.hectic.de

;Dependency: Draw3D V.3.2


;====-===-==-=-O-P-T-I-O-N-S-=---- --- -- - -  -   -    -
Const PHYXLOOPS#=2 ;Loops-Of-Calculating (Standard=2)
Const OVERDRIVE#=2 ;Stability (Less-Save) (Standard=2)
;====-===-==-=-O-P-T-I-O-N-S-=---- --- -- - -  -   -    -




Type KP
	Field HD% ;PivotHandle
	Field IH% ;ImageHandle
	Field FX% ;Position-Fixed
	Field XF# ;X-Fix-Position
	Field YF# ;Y-Fix-Position
	Field XP# ;X-Position
	Field YP# ;Y-Position
	Field XS# ;X-Speed
	Field YS# ;Y-Speed
	Field TM# ;Turn-Moment
	Field TP# ;Turn-Position
	Field TS# ;Turn-Speed
	Field RD# ;Radius
	Field MS# ;Masse
End Type


Type VK
	Field K1.KP ;KP->1
	Field K2.KP ;KP->2
	Field IH% ;ImageHandle
	Field FD% ;Federung (Suspension)
	Field DF% ;Dämpfung (Attenuation)
	Field LN# ;Solllänge
End Type


Type AM
	Field KP.KP ;KP-->
	Field VK.VK ;VK-->
	Field AT% ;KP=1, VK=2
	Field IH% ;ImageHandle
	Field XS# ;X-Pos-Offset
	Field YS# ;Y-Pos-Offset
	Field TS#;Turn-Offset
	Field MD% ;Mode-Draw
End Type


Type CL
	Field IH% ;ImageHandle
	Field X1# ;X1-Position
	Field Y1# ;Y1-Position
	Field X2# ;X2-Position
	Field Y2# ;Y2-Position
End Type


If DRAWBANKSIZE=0 Then RuntimeError "This Version of ''Physix.bb'' needed ''Draw3D.bb'' V.3.2"

Global GPhyxXGravity#=0
Global GPhyxYGravity#=0
Global GPhyxMesh%=CreateMesh()
Global GPhyxFace%=CreateSurface(GPhyxMesh)
EntityAlpha GPhyxMesh,0




Function PhysixInit(FPhyxXG#,FPhyxYG#,FPhyxCT%)
	GPhyxXGravity=FPhyxXG
	GPhyxYGravity=FPhyxYG
	EntityType GPhyxMesh,FPhyxCT
End Function




Function NewKP.KP(FPhyxIH%,FPhyxXP#,FPhyxYP#,FPhyxRD#,FPhyxMS#=1,FPhyxCT%=1,FPhyxTM#=10000)
	FPhyxTM=FPhyxTM+1:If FPhyxTM<1 Then FPhyxTM=1
	Local IPhyxKP.KP
	IPhyxKP.KP=New KP
	IPhyxKP\HD=CreatePivot()
	IPhyxKP\IH=FPhyxIH
	If FPhyxMS=0 Then IPhyxKP\FX=1 Else IPhyxKP\FX=0
	IPhyxKP\XF=FPhyxXP
	IPhyxKP\YF=FPhyxYP
	IPhyxKP\XP=FPhyxXP
	IPhyxKP\YP=FPhyxYP
	IPhyxKP\XS=0
	IPhyxKP\YS=0
	IPhyxKP\TM=FPhyxTM
	IPhyxKP\TP=0
	IPhyxKP\TS=0
	IPhyxKP\RD=FPhyxRD
	If FPhyxMS=0 Then IPhyxKP\MS=1 Else IPhyxKP\MS=FPhyxMS
	PositionEntity IPhyxKP\HD,FPhyxXP,FPhyxYP,0
	EntityRadius IPhyxKP\HD,FPhyxRD
	EntityType IPhyxKP\HD,FPhyxCT
	Return IPhyxKP
End Function




Function NewVK.VK(FPhyxIH%,FPhyxK1.KP,FPhyxK2.KP,FPhyxFD%,FPhyxDF%)
	Local IPhyxVK.VK
	If FPhyxFD<1 Then FPhyxFD=1
	If FPhyxDF<1 Then FPhyxDF=1
	IPhyxVK.VK=New VK
	IPhyxVK\K1=FPhyxK1
	IPhyxVK\K2=FPhyxK2
	IPhyxVK\IH=FPhyxIH
	IPhyxVK\FD=(FPhyxFD+1)^2
	IPhyxVK\DF=(FPhyxDF+1)^2
	IPhyxVK\LN=Sqr((FPhyxK2\XP-FPhyxK1\XP)^2+(FPhyxK2\YP-FPhyxK1\YP)^2)
	Return IPhyxVK
End Function




Function NewKPAM.AM(FPhyxIH%,FPhyxKP.KP)
	Local IPhyxAM.AM
	IPhyxAM.AM=New AM
	IPhyxAM\KP=FPhyxKP
	IPhyxAM\AT=1
	IPhyxAM\IH=FPhyxIH
	Return IPhyxAM
End Function




Function NewVKAM.AM(FPhyxIH%,FPhyxVK.VK,FPhyxXS#=0,FPhyxYS#=0,FPhyxTS#=0,FPhyxMD%=3)
	Local IPhyxAM.AM
	If FPhyxMD<0 Then FPhyxMD=0
	If FPhyxMD>3 Then FPhyxMD=3
	IPhyxAM.AM=New AM
	IPhyxAM\VK=FPhyxVK
	IPhyxAM\AT=2
	IPhyxAM\IH=FPhyxIH
	IPhyxAM\XS=FPhyxXS
	IPhyxAM\YS=FPhyxYS
	IPhyxAM\TS=FPhyxTS
	IPhyxAM\MD=FPhyxMD
	Return IPhyxAM
End Function




Function NewCL(FPhyxIH%,FPhyxX1#,FPhyxY1#,FPhyxX2#,FPhyxY2#)
	Local IPhyxCL.CL,IPhyxV0,IPhyxV1,IPhyxV2,IPhyxV3
	IPhyxCL.CL=New CL
	IPhyxCL\IH=FPhyxIH
	IPhyxCL\X1=FPhyxX1
	IPhyxCL\Y1=FPhyxY1
	IPhyxCL\X2=FPhyxX2
	IPhyxCL\Y2=FPhyxY2
	IPhyxV0=AddVertex(GPhyxFace,FPhyxX1,FPhyxY1,+1)
	IPhyxV1=AddVertex(GPhyxFace,FPhyxX2,FPhyxY2,+1)
	IPhyxV2=AddVertex(GPhyxFace,FPhyxX2,FPhyxY2,-1)
	IPhyxV3=AddVertex(GPhyxFace,FPhyxX1,FPhyxY1,-1)
	AddTriangle(GPhyxFace,IPhyxV0,IPhyxV1,IPhyxV2)
	AddTriangle(GPhyxFace,IPhyxV2,IPhyxV3,IPhyxV0)
End Function




Function DelKP(FPhyxKP.KP)
	Local IPhyxVK.VK,IPhyxDelete
	For IPhyxVK.VK=Each VK
		IPhyxDelete=0
		If IPhyxVK\K1=FPhyxKP.KP Then IPhyxDelete=1
		If IPhyxVK\K2=FPhyxKP.KP Then IPhyxDelete=1
		If IPhyxDelete=1 Then DelVK(IPhyxVK)
	Next
	Delete FPhyxKP.KP
End Function




Function DelVK(FPhyxVK.VK)
	Local IPhyxAM.AM
	For IPhyxAM.AM=Each AM
		If IPhyxAM\VK=FPhyxVK.VK Then DelAM(IPhyxAM)
	Next
	Delete FPhyxVK.VK
End Function




Function DelAM(FPhyxAM.AM)
	Delete FPhyxAM.AM
End Function




Function DelCL(FPhyxCL.CL)
	Local IPhyxCL.CL,IPhyxV0,IPhyxV1,IPhyxV2,IPhyxV3
	Delete FPhyxCL.CL
	ClearSurface GPhyxFace
	For IPhyxCL.CL=Each CL
		IPhyxV0=AddVertex(GPhyxFace,IPhyxCL\X1,IPhyxCL\Y1,+1)
		IPhyxV1=AddVertex(GPhyxFace,IPhyxCL\X2,IPhyxCL\Y2,+1)
		IPhyxV2=AddVertex(GPhyxFace,IPhyxCL\X2,IPhyxCL\Y2,-1)
		IPhyxV3=AddVertex(GPhyxFace,IPhyxCL\X1,IPhyxCL\Y1,-1)
		AddTriangle(GPhyxFace,IPhyxV0,IPhyxV1,IPhyxV2)
		AddTriangle(GPhyxFace,IPhyxV2,IPhyxV3,IPhyxV0)
	Next
End Function




Function SetKPPos(FPhyxKP.KP,FPhyxXP#,FPhyxYP#)
	FPhyxKP\XF=FPhyxXP
	FPhyxKP\YF=FPhyxYP
	FPhyxKP\XP=FPhyxXP
	FPhyxKP\YP=FPhyxYP
	FPhyxKP\XS=(FPhyxXP-FPhyxKP\XP)*0.5/PHYXLOOPS
	FPhyxKP\YS=(FPhyxYP-FPhyxKP\YP)*0.5/PHYXLOOPS
End Function




Function MoveKP(FPhyxKP.KP,FPhyxXSpeed#,FPhyxYSpeed#)
	FPhyxKP\XS=FPhyxKP\XS+FPhyxXSpeed/PHYXLOOPS
	FPhyxKP\YS=FPhyxKP\YS+FPhyxYSpeed/PHYXLOOPS
End Function




Function MoveVK(FPhyxVK.VK,FPhyxSpeed#)
	Local IPhyxWK#=ATan2(FPhyxVK\K1\YP-FPhyxVK\K2\YP,FPhyxVK\K1\XP-FPhyxVK\K2\XP)
	FPhyxVK\K1\XS=FPhyxVK\K1\XS+Cos(IPhyxWK)*FPhyxSpeed/FPhyxVK\K1\MS*0.5/PHYXLOOPS
	FPhyxVK\K1\YS=FPhyxVK\K1\YS+Sin(IPhyxWK)*FPhyxSpeed/FPhyxVK\K1\MS*0.5/PHYXLOOPS
	FPhyxVK\K2\XS=FPhyxVK\K2\XS+Cos(IPhyxWK)*FPhyxSpeed/FPhyxVK\K2\MS*0.5/PHYXLOOPS
	FPhyxVK\K2\YS=FPhyxVK\K2\YS+Sin(IPhyxWK)*FPhyxSpeed/FPhyxVK\K2\MS*0.5/PHYXLOOPS
End Function




Function TurnKP(FPhyxKP.KP,FPhyxSpeed#,FPhysixBreak#=1)
	If FPhysixBreak>1 Then FPhysixBreak=1
	FPhyxKP\TS=(FPhyxKP\TS-FPhyxSpeed)*FPhysixBreak
End Function




Function BreakKP(FPhyxKP.KP,FPhyxLinear#,FPhyxFricty#)
	If FPhyxFricty>1 Then FPhyxFricty=1
	FPhyxKP\TS=(FPhyxKP\TS-(Sgn(FPhyxKP\TS)*FPhyxLinear))*FPhyxFricty
	If Abs(FPhyxKP\TS)<FPhyxLinear Then FPhyxKP\TS=0
End Function




Function TurnVK(FPhyxVK.VK,FPhyxSpeed#)
	Local IPhyxWK#=ATan2(FPhyxVK\K1\YP-FPhyxVK\K2\YP,FPhyxVK\K1\XP-FPhyxVK\K2\XP)
	FPhyxVK\K1\XS=FPhyxVK\K1\XS+Cos(IPhyxWK-90)*FPhyxSpeed/FPhyxVK\K1\MS*0.5/PHYXLOOPS
	FPhyxVK\K1\YS=FPhyxVK\K1\YS+Sin(IPhyxWK-90)*FPhyxSpeed/FPhyxVK\K1\MS*0.5/PHYXLOOPS
	FPhyxVK\K2\XS=FPhyxVK\K2\XS+Cos(IPhyxWK+90)*FPhyxSpeed/FPhyxVK\K2\MS*0.5/PHYXLOOPS
	FPhyxVK\K2\YS=FPhyxVK\K2\YS+Sin(IPhyxWK+90)*FPhyxSpeed/FPhyxVK\K2\MS*0.5/PHYXLOOPS
End Function




Function DrawKP()
	Local IPhyxKP.KP
	For IPhyxKP.KP=Each KP
		If IPhyxKP\IH>0 Then Plot3D(IPhyxKP\IH,IPhyxKP\XP,IPhyxKP\YP,IPhyxKP\RD)
	Next
End Function




Function DrawVK(FPhyxSize#)
	Local IPhyxVK.VK
	For IPhyxVK.VK=Each VK
		If IPhyxVK\IH>0 Then Line3D(IPhyxVK\IH,IPhyxVK\K1\XP,IPhyxVK\K1\YP,IPhyxVK\K2\XP,IPhyxVK\K2\YP,FPhyxSize)
	Next
End Function




Function DrawAM()
	Local IPhyxAM.AM,IPhyxDX#,IPhyxDY#
	Local IPhyxDX1#,IPhyxDY1#,IPhyxDX2#,IPhyxDY2#
	Local IPhyxX1#,IPhyxY1#,IPhyxX2#,IPhyxY2#
	For IPhyxAM.AM=Each AM
		
		Select IPhyxAM\AT
				
			Case 1
				XDrawPP3D(IPhyxAM\IH,IPhyxAM\KP\XP,IPhyxAM\KP\YP,IPhyxAM\KP\RD,IPhyxAM\KP\TP)
				
			Case 2
				IPhyxX1=IPhyxAM\VK\K1\XP
				IPhyxY1=IPhyxAM\VK\K1\YP
				IPhyxX2=IPhyxAM\VK\K2\XP
				IPhyxY2=IPhyxAM\VK\K2\YP
				TFormNormal IPhyxY2-IPhyxY1,IPhyxX1-IPhyxX2,0,0,0
				IPhyxDX1=TFormedX():IPhyxDY1=TFormedY()
				TFormNormal IPhyxX2-IPhyxX1,IPhyxY2-IPhyxY1,0,0,0
				IPhyxDX2=TFormedX():IPhyxDY2=TFormedY()
				IPhyxDX=IPhyxDX1*IPhyxAM\XS+IPhyxDX2*IPhyxAM\YS
				IPhyxDY=IPhyxDY2*IPhyxAM\YS+IPhyxDY1*IPhyxAM\XS
				Select IPhyxAM\MD
					Case 0 DrawLine3D(IPhyxAM\IH,IPhyxX1+IPhyxDX,IPhyxY1+IPhyxDY,IPhyxX2+IPhyxDX,IPhyxY2+IPhyxDY,IPhyxAM\TS,0)
					Case 1 DrawLine3D(IPhyxAM\IH,IPhyxX1+IPhyxDX,IPhyxY1+IPhyxDY,IPhyxX2+IPhyxDX,IPhyxY2+IPhyxDY,IPhyxAM\TS,1)
					Case 2 DrawLine3D(IPhyxAM\IH,IPhyxX1+IPhyxDX,IPhyxY1+IPhyxDY,IPhyxX2+IPhyxDX,IPhyxY2+IPhyxDY,IPhyxAM\TS,2)
					Case 3 DrawImage3D(IPhyxAM\IH,IPhyxX1+IPhyxDX,IPhyxY1+IPhyxDY,0,IPhyxAM\TS-90-ATan2(IPhyxY1-IPhyxY2,IPhyxX1-IPhyxX2))
				End Select
		End Select
		
	Next
End Function




Function DrawCL(FPhyxSize#)
	Local IPhyxCL.CL
	For IPhyxCL.CL=Each CL
		If IPhyxCL\IH>0 Then Line3D(IPhyxCL\IH,IPhyxCL\X1,IPhyxCL\Y1,IPhyxCL\X2,IPhyxCL\Y2,FPhyxSize)
	Next
End Function




Function Physix(FPhyxAirFricty#=1)
	Local IPhyxKP.KP,IPhyxVK.VK,IPhyxEH#=1.0/PHYXLOOPS
	Local IPhyxDX#,IPhyxDY#,IPhyxSP#,IPhyxLN#,IPhyxQ%,IPhyxW%
	Local IPhyxNX#,IPhyxNY#,IPhyxW1#,IPhyxW2#
	Local IPhyxXGravity#=GPhyxXGravity*IPhyxEH
	Local IPhyxYGravity#=GPhyxYGravity*IPhyxEH
	
	For IPhyxQ=1 To PHYXLOOPS
		For IPhyxKP.KP=Each KP
			For IPhyxW=1 To CountCollisions(IPhyxKP\HD)
				IPhyxNX=CollisionNX(IPhyxKP\HD,IPhyxW)
				IPhyxNY=CollisionNY(IPhyxKP\HD,IPhyxW)
				IPhyxW1=ATan2(IPhyxNY,IPhyxNX)
				IPhyxW2=ATan2(IPhyxKP\YS,IPhyxKP\XS)
				IPhyxSP=Sqr(IPhyxKP\XS^2+IPhyxKP\YS^2)*PHYXLOOPS
				IPhyxKP\TS=IPhyxKP\TS+(((Sin(IPhyxW2-IPhyxW1)*IPhyxSP)-IPhyxKP\TS)/IPhyxKP\TM/IPhyxKP\TM)
				IPhyxKP\XS=(IPhyxKP\XS-IPhyxNY*IPhyxKP\TS*IPhyxEH)*0.5
				IPhyxKP\YS=(IPhyxKP\YS+IPhyxNX*IPhyxKP\TS*IPhyxEH)*0.5
			Next
			IPhyxKP\XP=IPhyxKP\XP+IPhyxKP\XS
			IPhyxKP\YP=IPhyxKP\YP+IPhyxKP\YS
			If IPhyxQ=1 Then
				IPhyxKP\XS=IPhyxKP\XS+IPhyxXGravity
				IPhyxKP\YS=IPhyxKP\YS+IPhyxYGravity
				IPhyxKP\TP=IPhyxKP\TP-(IPhyxKP\TS/IPhyxKP\RD*64)
				If IPhyxKP\TP>+180 Then IPhyxKP\TP=IPhyxKP\TP-360
				If IPhyxKP\TP<-180 Then IPhyxKP\TP=IPhyxKP\TP+360
			End If
			MoveEntity IPhyxKP\HD,IPhyxKP\XS,IPhyxKP\YS,0
		Next
		
		For IPhyxVK.VK=Each VK
			If IPhyxVK\K1\XP<>IPhyxVK\K2\XP Then
				If IPhyxVK\K1\YP<>IPhyxVK\K2\YP Then
					TFormNormal IPhyxVK\K1\XP-IPhyxVK\K2\XP,IPhyxVK\K1\YP-IPhyxVK\K2\YP,0,0,0
					IPhyxLN=Sqr((IPhyxVK\K1\XP-IPhyxVK\K2\XP)^2+(IPhyxVK\K1\YP-IPhyxVK\K2\YP)^2)
					IPhyxDX=TFormedX()*OVERDRIVE*(IPhyxLN-IPhyxVK\LN)
					IPhyxDY=TFormedY()*OVERDRIVE*(IPhyxLN-IPhyxVK\LN)
					IPhyxVK\K1\XP=IPhyxVK\K1\XP-(IPhyxDX/IPhyxVK\FD)/IPhyxVK\K1\MS
					IPhyxVK\K1\YP=IPhyxVK\K1\YP-(IPhyxDY/IPhyxVK\FD)/IPhyxVK\K1\MS
					IPhyxVK\K1\XS=IPhyxVK\K1\XS-(IPhyxDX/IPhyxVK\DF)/IPhyxVK\K1\MS
					IPhyxVK\K1\YS=IPhyxVK\K1\YS-(IPhyxDY/IPhyxVK\DF)/IPhyxVK\K1\MS
					IPhyxVK\K2\XP=IPhyxVK\K2\XP+(IPhyxDX/IPhyxVK\FD)/IPhyxVK\K2\MS
					IPhyxVK\K2\YP=IPhyxVK\K2\YP+(IPhyxDY/IPhyxVK\FD)/IPhyxVK\K2\MS
					IPhyxVK\K2\XS=IPhyxVK\K2\XS+(IPhyxDX/IPhyxVK\DF)/IPhyxVK\K2\MS
					IPhyxVK\K2\YS=IPhyxVK\K2\YS+(IPhyxDY/IPhyxVK\DF)/IPhyxVK\K2\MS
				End If
			End If
		Next
		
		For IPhyxKP.KP=Each KP
			If IPhyxKP\FX=1 Then
				IPhyxKP\XS=(IPhyxKP\XF-IPhyxKP\XP)*0.5/PHYXLOOPS
				IPhyxKP\YS=(IPhyxKP\YF-IPhyxKP\YP)*0.5/PHYXLOOPS
				IPhyxKP\XP=IPhyxKP\XF
				IPhyxKP\YP=IPhyxKP\YF
			Else
				If IPhyxQ=1 Then
					IPhyxKP\XS=IPhyxKP\XS*FPhyxAirFricty
					IPhyxKP\YS=IPhyxKP\YS*FPhyxAirFricty
				End If
				If CountCollisions(IPhyxKP\HD)>0 Then
					IPhyxKP\XP=EntityX(IPhyxKP\HD)
					IPhyxKP\YP=EntityY(IPhyxKP\HD)
				End If
			End If
			PositionEntity IPhyxKP\HD,IPhyxKP\XP,IPhyxKP\YP,0
		Next
	Next
	
End Function




Function GetKPTurnSpeed#(FPhyxKP.KP)
	Return -FPhyxKP\TS
End Function




Function GetKPTurnPos#(FPhyxKP.KP)
	Return FPhyxKP\TP
End Function




Function GetKPXPos#(FPhyxKP.KP)
	Return FPhyxKP\XP
End Function




Function GetKPYPos#(FPhyxKP.KP)
	Return FPhyxKP\YP
End Function




Function GetKPXSpeed#(FPhyxKP.KP)
	Return FPhyxKP\XS*PHYXLOOPS
End Function




Function GetKPYSpeed#(FPhyxKP.KP)
	Return FPhyxKP\YS*PHYXLOOPS
End Function




Function GetVKXVector#(FPhyxVK.VK)
	TFormNormal FPhyxVK\K2\XP-FPhyxVK\K1\XP,FPhyxVK\K2\YP-FPhyxVK\K1\YP,0,0,0
	Return TFormedX()
End Function




Function GetVKYVector#(FPhyxVK.VK)
	TFormNormal FPhyxVK\K2\XP-FPhyxVK\K1\XP,FPhyxVK\K2\YP-FPhyxVK\K1\YP,0,0,0
	Return TFormedY()
End Function




Function AddVKLen(FPhyxVK.VK,FPhyxLN#)
	FPhyxVK\LN=FPhyxVK\LN+FPhyxLN
End Function




Function SetVKLen(FPhyxVK.VK,FPhyxLN#)
	FPhyxVK\LN=FPhyxLN
End Function




Function GetVKLen#(FPhyxVK.VK)
	Return FPhyxVK\LN
End Function




Function GetVKAngle#(FPhyxVK.VK)
	Return ATan2(FPhyxVK\K2\XP-FPhyxVK\K1\XP,FPhyxVK\K2\YP-FPhyxVK\K1\YP)
End Function




Function GetVKStress#(FPhyxVK.VK)
	Local IPhyxX1#,IPhyxY1#,IPhyxX2#,IPhyxY2#,IPhyxLN#
	IPhyxX1=FPhyxVK\K1\XP
	IPhyxY1=FPhyxVK\K1\YP
	IPhyxX2=FPhyxVK\K2\XP
	IPhyxY2=FPhyxVK\K2\YP
	IPhyxLN=Sqr((IPhyxX1-IPhyxX2)^2+(IPhyxY1-IPhyxY2)^2)
	Return IPhyxLN-FPhyxVK\LN
End Function




Function GetKPDistance#(FPhyxK1.KP,FPhyxK2.KP)
	Return EntityDistance(FPhyxK1.KP\HD,FPhyxK2.KP\HD)
End Function




Function CountKP()
	Local IPhyxKP.KP,IPhyxCount
	For IPhyxKP.KP=Each KP
		IPhyxCount=IPhyxCount+1
	Next
	Return IPhyxCount
End Function




Function CountVK()
	Local IPhyxVK.VK,IPhyxCount
	For IPhyxVK.VK=Each VK
		IPhyxCount=IPhyxCount+1
	Next
	Return IPhyxCount
End Function




Function CountAM()
	Local IPhyxAM.AM,IPhyxCount
	For IPhyxAM.AM=Each AM
		IPhyxCount=IPhyxCount+1
	Next
	Return IPhyxCount
End Function




Function CountCL()
	Local IPhyxCL.CL,IPhyxCount
	For IPhyxCL.CL=Each CL
		IPhyxCount=IPhyxCount+1
	Next
	Return IPhyxCount
End Function




Function DelKPList()
	Local IPhyxKP.KP
	Local IPhyxVK.VK
	Local IPhyxAM.AM
	For IPhyxKP.KP=Each KP Delete IPhyxKP.KP Next
	For IPhyxVK.VK=Each VK Delete IPhyxVK.VK Next
	For IPhyxAM.AM=Each AM Delete IPhyxAM.AM Next
End Function




Function DelVKList()
	Local IPhyxVK.VK
	Local IPhyxAM.AM
	For IPhyxVK.VK=Each VK
		Delete IPhyxVK.VK
	Next
	For IPhyxAM.AM=Each AM
		If IPhyxAM\AT=2 Then Delete IPhyxAM.AM
	Next
End Function




Function DelAMList()
	Local IPhyxAM.AM
	For IPhyxAM.AM=Each AM
		Delete IPhyxAM.AM
	Next
End Function




Function DelCLList()
	Local IPhyxCL.CL
	ClearSurface GPhyxFace
	For IPhyxCL.CL=Each CL
		Delete IPhyxCL.CL
	Next
End Function


;~IDEal Editor Parameters:
;~C#Blitz3D