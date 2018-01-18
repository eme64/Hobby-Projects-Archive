Graphics 800,600,0,2
SetBuffer BackBuffer()

Dim feld(1,11,11)

Global maus_bild=LoadImage("bilder\maus.bmp")
MaskImage maus_bild,0,0,0
Global boden_bilder=LoadAnimImage("bilder\anim.bmp",50,50,0,4)
MaskImage boden_bilder,255,0,255
Global map_bilder=LoadAnimImage("bilder\map.bmp",12,12,0,10)

Const rbg_rot=255*$1000000 +255*$10000 + 0*$100 + 0
Const rbg_gruen=255*$1000000 +0*$10000 + 255*$100 + 0
Const rbg_schwarz=255*$1000000 +0*$10000 + 0*$100 + 0
Const rbg_weiss=255*$1000000 +255*$10000 + 255*$100 + 255

Global maus_x,maus_y
Global game_over=0


Global l=0
load_map(l)
c=0
Repeat
	Cls
	c=c+1
	AppTitle l
	m_x=MouseX()
	m_y=MouseY()
	
	If MouseHit(1) Then
		If feld(0,m_x/50,m_y/50)=1 Then
			feld(0,m_x/50,m_y/50)=3
			maus_wegfind()
		EndIf
	EndIf
	
	For x=0 To 11
		For y=0 To 11
			DrawImage boden_bilder,x*50,y*50,feld(0,x,y)
			;Text x*50,y*50,feld(1,x,y)
		Next
	Next
	
	For x=0 To 11
		For y=0 To 11
			Color feld(1,x,y)*10+10,0,0
			Rect 600+x*2,0+y*2,2,2
		Next
	Next
	
	DrawImage maus_bild,maus_x*50,maus_y*50
	Flip
	Select game_over
		Case 2
			
			Print "game over"
			WaitKey
			End
		Case 1
			Print "you win"
			WaitKey
			l=l+1
			game_over=0
			load_map(l)
			
	End Select
Until KeyHit(1)

End

Function load_map(level=0)
	buffer=ImageBuffer(map_bilder,level)
	LockBuffer buffer
	For x=0 To 11
		For y=0 To 11
			Select ReadPixelFast(x,y,buffer)
				Case rbg_rot
					feld(0,x,y)=0
				Case rbg_weiss
					feld(0,x,y)=1
				Case rbg_schwarz
					feld(0,x,y)=2
				Case rbg_gruen
					maus_x=x
					maus_y=y
					feld(0,x,y)=1
			End Select
		Next
	Next
	UnlockBuffer buffer
End Function

Function maus_wegfind()
	For x=0 To 11
		For y=0 To 11
			Select feld(0,x,y)
				Case 0,3
					feld(1,x,y)=-1
				Case 2
					feld(1,x,y)=1
				Default
					feld(1,x,y)=0
			End Select
		Next
	Next
	
	i=0
	Repeat
		i=i+1
		e=0
		For x=1 To 10
			For y=1 To 10
				If feld(1,x,y)=0 And (feld(1,x+1,y)=i Or feld(1,x-1,y)=i Or feld(1,x,y+1)=i Or feld(1,x,y-1)=i) Then
					feld(1,x,y)=i+1
					e=1
				End If
			Next
		Next
		
	Until e=0
	iii=i
	ii=0
	
	i1=feld(1,maus_x+1,maus_y)
	If i1>0 Then
		ii=1
		iii=i1
	End If
	
	i2=feld(1,maus_x,maus_y+1)
	If i2>0 And iii>=i2 Then
		ii=2
		iii=i2
	End If
	
	i3=feld(1,maus_x,maus_y-1)
	If i3>0 And iii>=i3 Then
		ii=3
		iii=i3
	End If
	
	i4=feld(1,maus_x-1,maus_y)
	If i4>0 And iii>=i4 Then ii=4
	
	AppTitle ii
	
	Select ii
		Case 1
			maus_x=maus_x+1
		Case 2
			maus_y=maus_y+1
		Case 3
			maus_y=maus_y-1
		Case 4
			maus_x=maus_x-1
		Case 0
			game_over=1
	End Select
	
	If feld(0,maus_x,maus_y)=2 Then game_over=2
	
End Function