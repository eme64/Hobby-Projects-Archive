Strict

Include "modules/gui.bmx"


Extern "Win32"
	Const GMEM_FIXED:Int = 0
	Const CF_TEXT:Int=1
	
	Function OpenClipboard(hwnd%)
	Function CloseClipboard()
	Function EmptyClipboard()
	Function SetClipboardData(format%, hMem:Byte Ptr)
	
	Function GlobalAlloc:Byte Ptr( uflags, bytes )
	Function GlobalFree( buf:Byte Ptr )
End Extern

' -----------------------------------------------

Function GlobalAllocString:Byte Ptr( txt$ )
	Local p:Byte Ptr= GlobalAlloc( GMEM_FIXED , Len(txt)+1 )
	
	For Local i=0 Until Len(txt)
		p[i]=txt[i]
	Next
	
	p[Len(txt)+1]=0
	
	Return p
EndFunction

'----------------------------------------------

AppTitle = "Block Code"
Graphics 450,150
Local feld:String[3,3]

Local ret:String = ""

feld[1,1]="+"

SetClsColor 50,50,50

Repeat
	EMEGUI.render_events()
	
	Cls
	
	ret = ""
	
	For Local y:Int = 0 To 2
		For Local x:Int = 0 To 2
			
			If feld[x,y]="" Then feld[x,y]="0"
			
			ret:+feld[x,y]
			
			If x=1 And y=1 Then
				SetColor 100,100,100
				DrawRect x*50+1,y*50+1,50-2,50-2
				
				SetColor 255,255,255
				DrawText "  +  ",x*50+2,y*50+15
			Else
				
				SetColor (feld[x,y]=1)*200,(feld[x,y]=1)*200,(feld[x,y]=1)*200+(feld[x,y]=2)*200
				DrawRect x*50+1,y*50+1,50-2,50-2
				
				SetColor 255,255,255
				
				Select feld[x,y]
					Case 0
						DrawText "empty",x*50+2,y*50+15
					Case 1
						SetColor 0,0,0
						DrawText "solid",x*50+2,y*50+15
					Case 2
						DrawText " ? ? ",x*50+2,y*50+15
				End Select
				
				If EMEGUI.m_x > x*50 And EMEGUI.m_x =< x*50+50 And EMEGUI.m_y > y*50 And EMEGUI.m_y =< y*50+50 Then
					If EMEGUI.m_hit_1 Then
						If feld[x,y]=0 Then
							feld[x,y]=1
						Else
							feld[x,y]=0
						End If
					End If
					
					If EMEGUI.m_hit_2 Then
						feld[x,y]=2
					End If
				End If
			End If
		Next
	Next
	
	SetColor 255,255,255
	DrawText ret,160,10
	DrawText "Mouse_left  -> on / off", 160,60
	DrawText "Mouse_right -> ? ?", 160,80
	
	DrawText "[Enter] oder M3 Zwischenablage", 160,120
	
	If KeyHit(key_enter) Or EMEGUI.m_hit_3 Then
		Print ret
		Global txt:String=ret
		
		Local hbuf:Byte Ptr
		
		'If OpenClipboard(0)
			EmptyClipboard
			hbuf = GlobalAllocString( txt )
			SetClipboardData CF_TEXT, hbuf
			CloseClipboard
		'Else
		'	RuntimeError "Failed to open Clipboard"
		'EndIf
		
		If hbuf GlobalFree(hbuf)
	End If
	
	Flip
Until KeyHit(key_escape) Or AppTerminate()