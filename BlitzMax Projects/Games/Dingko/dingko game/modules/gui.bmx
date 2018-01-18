

Type EMEGUI
	Global focus:GUI_OBJEKT
	
	Function render_events()
		
		'MOUSE
		
		EMEGUI.m_down_1 = MouseDown(1)
		EMEGUI.m_hit_1 = MouseHit(1)
		
		EMEGUI.m_down_2 = MouseDown(2)
		EMEGUI.m_hit_2 = MouseHit(2)
		
		EMEGUI.m_down_3 = MouseDown(3)
		EMEGUI.m_hit_3 = MouseHit(3)
		
		EMEGUI.m_x_speed = MouseXSpeed()
		EMEGUI.m_y_speed = MouseYSpeed()
		EMEGUI.m_z_speed = MouseZSpeed()
		
		
		EMEGUI.m_1_last=EMEGUI.m_1
		Select EMEGUI.m_1_last
			Case 0'off
				If EMEGUI.m_hit_1 Or EMEGUI.m_down_1 Then
					EMEGUI.m_1=1
				End If
			Case 1'new on
				If EMEGUI.m_down_1 Then
					EMEGUI.m_1=2
				End If
			Case 2
				If Not EMEGUI.m_down_1 Then
					EMEGUI.m_1=-1
				End If
			Case -1
				If EMEGUI.m_hit_1 Or EMEGUI.m_down_1 Then
					EMEGUI.m_1=1
				Else
					EMEGUI.m_1=0
				End If
		End Select
		
		EMEGUI.m_2_last=EMEGUI.m_2
		Select EMEGUI.m_2_last
			Case 0'off
				If EMEGUI.m_hit_2 Or EMEGUI.m_down_2 Then
					EMEGUI.m_2=1
				End If
			Case 1'new on
				If EMEGUI.m_down_2 Then
					EMEGUI.m_2=2
				End If
			Case 2
				If Not EMEGUI.m_down_2 Then
					EMEGUI.m_2=-1
				End If
			Case -1
				If EMEGUI.m_hit_2 Or EMEGUI.m_down_2 Then
					EMEGUI.m_2=1
				Else
					EMEGUI.m_2=0
				End If
		End Select
		
		EMEGUI.m_x=MouseX()
		EMEGUI.m_y=MouseY()
	End Function
	
	Global m_x:Int
	Global m_y:Int
	
	Global m_down_1:Int
	Global m_hit_1:Int
	
	Global m_down_2:Int
	Global m_hit_2:Int
	
	Global m_down_3:Int
	Global m_hit_3:Int
	
	Global m_x_speed:Int
	Global m_y_speed:Int
	Global m_z_speed:Int
	
	Global m_1:Int=0
	Global m_1_last:Int=0
	
	Global m_2:Int=0
	Global m_2_last:Int=0
	
	Function GET_ZWISCHENABLAGE:String()
		Const CF_TEXT:Int = 1
		
		Local clip:String
		Local cbd:Int
		If OpenClipboard(0)
			If IsClipboardFormatAvailable(CF_TEXT)
				cbd=GetClipboardData(CF_TEXT)
				clip=clip.FromCString(Byte Ptr cbd)
			EndIf
			CloseClipboard
			Return clip
		EndIf
	End Function
End Type

Type GUI_OBJEKT
	Field x:Int
	Field y:Int
	
	Field active:Int
	
	Method draw()
	End Method
	
	Method render()
	End Method
End Type

Type GUI_INPUT Extends GUI_OBJEKT
	Field content:String
	Field pos:Int
	Field mark:Int=0'anzahl zeichen markiert von pos an
	Field dx:Int'breite des eingabefeldes in pixel
	Const hoehe:Int=20
	Field count:Int=0
	Const countmax:Int=50
	
	Function Create:GUI_INPUT(x:Int,y:Int,content:String,dx:Int,active:Int=1)
		Local i:GUI_INPUT=New GUI_INPUT
		
		i.x=x
		i.y=y
		i.content=content
		i.pos=Len(content)+1
		i.dx=dx
		i.active=active
		
		Return i
	End Function
	
	Method render()
		If Self.active=0 Then Return
		
		If EMEGUI.m_1=1 And EMEGUI.m_x>Self.x And EMEGUI.m_x<Self.x+Self.dx And EMEGUI.m_y>Self.y And EMEGUI.m_y<Self.y+Self.hoehe Then
			If Not (EMEGUI.focus=Self) Then
				Self.pos=1
				Self.mark=Len(Self.content)+1
				EMEGUI.focus=Self
				FlushKeys()
			Else
				For Local i:Int=1 To Len(Self.content)+1
					If 3 > EMEGUI.m_x-(Self.x+2) Then
						Self.pos=1
						Exit
					Else If TextWidth(Mid(Self.content,1,i))>EMEGUI.m_x-(Self.x+2)-5 Then
						Self.pos=i+1
						Exit
					ElseIf TextWidth(Self.content) < EMEGUI.m_x-(Self.x+2)+5 Then
						Self.pos=Len(Self.content)+1
						Exit
					End If
				Next
			End If
		End If
		
		If EMEGUI.m_1=-1 And EMEGUI.m_x>Self.x And EMEGUI.m_x<Self.x+Self.dx And EMEGUI.m_y>Self.y And EMEGUI.m_y<Self.y+Self.hoehe Then
			For Local i:Int=1 To Len(Self.content)+1
				If 3 > EMEGUI.m_x-(Self.x+2) Then
					'Print 1
					
					
					
					If Self.pos>1 Then
						Self.mark=Self.pos-1
						Self.pos=1
					Else
						Self.mark=0
					End If
					
					Exit
				Else If TextWidth(Mid(Self.content,1,i))>EMEGUI.m_x-(Self.x+2)-5 Then
					'Print 2
					
					If Self.pos=i+1
						Self.mark=0
					ElseIf Self.pos<i+1
						Self.mark=i+1-Self.pos
					Else
						Self.mark=Self.pos-(i+1)
						Self.pos=i+1
					End If
					
					Exit
				ElseIf TextWidth(Self.content) < EMEGUI.m_x-(Self.x+2)+5 Then
					'Print 3
					
					If Self.pos=Len(Self.content)+1 Then
						Self.mark=0
					Else
						Self.mark=Len(Self.content)+1-Self.pos
					End If
					Exit
				End If
			Next
		End If
		
		Self.count:+1
		If Self.count>Self.countmax Then Self.count=0
		
		If EMEGUI.focus=Self Then
			Local gc:Int=GetChar()
			
			Select True
				Case KeyDown(KEY_LCONTROL) And KeyHit(key_v)
					Local txt:String=EMEGUI.GET_ZWISCHENABLAGE()
					If Self.mark>0 Then
						If TextWidth(Mid(Self.content,1,Self.pos-1)+txt+Mid(Self.content,Self.pos+Self.mark,-1))<Self.dx-4 Then
							Self.content=Mid(Self.content,1,Self.pos-1)+txt+Mid(Self.content,Self.pos+Self.mark,-1)
							Self.pos=Self.pos+Len(txt)
							Self.mark=0
						Else
						End If
					Else
						If TextWidth(Mid(Self.content,1,Self.pos-1)+txt+Mid(Self.content,Self.pos,-1))<Self.dx-4 Then
							Self.content=Mid(Self.content,1,Self.pos-1)+txt+Mid(Self.content,Self.pos,-1)
							Self.pos:+Len(txt)
						Else
						End If
					End If
				Case gc=0'nex
					
				Case gc=8'return
					If Self.mark>0 Then
						Self.content=Mid(Self.content,1,Self.pos-1)+Mid(Self.content,Self.pos+Self.mark,-1)
						Self.pos=Self.pos
						Self.mark=0
					Else
						If Self.pos>1 Then
							Self.content=Mid(Self.content,1,Self.pos-2)+Mid(Self.content,Self.pos,-1)
							Self.pos:-1
						End If
					End If
				Case gc>31'zeichen
					If Self.mark>0 Then
						If TextWidth(Mid(Self.content,1,Self.pos-1)+Chr(gc)+Mid(Self.content,Self.pos+Self.mark,-1))<Self.dx-4 Then
							Self.content=Mid(Self.content,1,Self.pos-1)+Chr(gc)+Mid(Self.content,Self.pos+Self.mark,-1)
							Self.pos=Self.pos+1
							Self.mark=0
						Else
						End If
					Else
						If TextWidth(Mid(Self.content,1,Self.pos-1)+Chr(gc)+Mid(Self.content,Self.pos,-1))<Self.dx-4 Then
							Self.content=Mid(Self.content,1,Self.pos-1)+Chr(gc)+Mid(Self.content,Self.pos,-1)
							Self.pos:+1
						Else
						End If
					End If
				Case gc=9'tab?
				Case gc=10'enter?
			End Select
		End If
	End Method
	
	Method draw()
		If Self.active=0 Then Return
		
		If EMEGUI.focus=Self Then
			SetColor 0,0,0
		Else
			SetColor 100,100,100
		End If
		DrawRect Self.x,Self.y,Self.dx,Self.hoehe
		SetColor 255,255,255
		DrawRect Self.x+1,Self.y+1,Self.dx-2,Self.hoehe-2
		If EMEGUI.focus=Self Then
			SetColor 0,0,0
		Else
			SetColor 100,100,100
		End If
		If Self.mark=0 And Self.count<Self.countmax/2 And EMEGUI.focus=Self Then
			DrawLine Self.x+3+TextWidth(Mid(Self.content,1,pos-1)),Self.y+2,Self.x+2+TextWidth(Mid(Self.content,1,pos-1))-1,Self.y+17
		End If
		
		If Self.mark>0 And EMEGUI.focus=Self Then
			DrawText Mid(Self.content,1,pos-1), Self.x+2,Self.y+2
			SetColor 100,100,255
			DrawRect Self.x+2+TextWidth(Mid(Self.content,1,pos-1)),Self.y+2,TextWidth(Mid(Self.content,pos,mark)),16
			SetColor 255,255,255
			DrawText Mid(Self.content,pos,mark), Self.x+2+TextWidth(Mid(Self.content,1,pos-1)),Self.y+2
			If EMEGUI.focus=Self Then
				SetColor 0,0,0
			Else
				SetColor 100,100,100
			End If
			DrawText Mid(Self.content,pos+mark,-1), Self.x+2+TextWidth(Mid(Self.content,1,pos-1)+Mid(Self.content,pos,mark)),Self.y+2
		Else
			DrawText Self.content, Self.x+2,Self.y+2
		End If
		
	End Method
End Type


Type GUI_REQUESTFILE Extends GUI_OBJEKT
	Field filename:String
	Field gui_name:String
	Field dx:Int
	Const hoehe:Int=20
	
	Field title:String
	Field extensions:String'bla: txt,doc; all files: *
	Field save_load:Int'false=load, true=save
	
	Function Create:GUI_REQUESTFILE(x:Int,y:Int,dx:Int,title:String="title",extensions:String="All Files:*",active:Int=1)
		Local rf:GUI_REQUESTFILE=New GUI_REQUESTFILE
		
		rf.x=x
		rf.y=y
		rf.dx=dx
		rf.active=active
		
		Return rf
	End Function
	
	Method render()
		If EMEGUI.m_x>Self.x And EMEGUI.m_x<Self.x+Self.dx And EMEGUI.m_y>Self.y And EMEGUI.m_y<Self.y+Self.hoehe Then
			If EMEGUI.m_1=1 Then
				Self.filename=RequestFile(Self.title,Self.extensions,Self.save_load,"")
				If TextWidth(Self.filename)>Self.dx-4 Then
					Local t:String=Self.filename
					
					While Instr(t,"\")
						t=Mid(t,Instr(t,"\")+1,-1)
					Wend
					
					Self.gui_name=Mid(Self.filename,1,3)+"...\"+t
				Else
					Self.gui_name=Self.filename
				End If
				'Self.gui_name
			End If
		End If
	End Method
	
	Method draw()
		SetColor 50,50,50
		DrawRect Self.x,Self.y,Self.dx,Self.hoehe
		SetColor 200,200,200
		DrawRect Self.x+1,Self.y+1,Self.dx-2,Self.hoehe-2
		SetColor 50,50,50
		DrawText Self.gui_name,Self.x+2,Self.y+2
	End Method
	'Print Requestfile$("bla","")
End Type

Type GUI_BUTTON Extends GUI_OBJEKT
	Field Text:String
	Field dx:Int'breite des buttons in pixel
	Const hoehe:Int=20
	Field pressed:Int=0'0=frei, 1=mouse-on, 2=press, 3=presseddown
	
	Function Create:GUI_BUTTON(x:Int,y:Int,Text:String,dx:Int,active:Int=1)
		Local b:GUI_BUTTON=New GUI_BUTTON
		
		b.x=x
		b.y=y
		b.Text=Text
		b.dx=dx
		b.active=active
		
		Return b
	End Function
	
	Method render()
		If Self.active=0 Then Return
		
		If Self.pressed<>3 Then
			If EMEGUI.m_x>Self.x And EMEGUI.m_x<Self.x+Self.dx And EMEGUI.m_y>Self.y And EMEGUI.m_y<Self.y+Self.hoehe Then
				If EMEGUI.m_1>0 Then
					If EMEGUI.m_1=2 And Self.pressed=1 Then
						Self.pressed=2
					ElseIf EMEGUI.m_1=1 Then
						Self.pressed=1
					End If
				Else
					If Self.pressed=2 Then
						Self.pressed=3
					Else
						Self.pressed=1
					End If
				End If
			Else
				Self.pressed=0
			End If
		End If
	End Method
	
	Method draw()
		If Self.active=0 Then Return
		
		Select Self.pressed
			Case 0
				SetColor 0,0,0
				DrawRect Self.x,Self.y,Self.dx,Self.hoehe
				SetColor 255,255,255
				DrawRect Self.x+1,Self.y+1,Self.dx-2,Self.hoehe-2
				SetColor 0,0,0
				DrawText Self.Text,Self.x+2,Self.y+2
			Case 1
				SetColor 0,0,0
				DrawRect Self.x,Self.y,Self.dx,Self.hoehe
				SetColor 200,200,200
				DrawRect Self.x+1,Self.y+1,Self.dx-2,Self.hoehe-2
				SetColor 0,0,0
				DrawText Self.Text,Self.x+2,Self.y+2
			Case 2
				SetColor 0,0,0
				DrawRect Self.x,Self.y,Self.dx,Self.hoehe
				SetColor 100,100,100
				DrawRect Self.x+1,Self.y+1,Self.dx-2,Self.hoehe-2
				SetColor 0,0,0
				DrawText Self.Text,Self.x+2,Self.y+2
			Case 3
				SetColor 255,255,255
				DrawRect Self.x,Self.y,Self.dx,Self.hoehe
				SetColor 100,100,100
				DrawRect Self.x+1,Self.y+1,Self.dx-2,Self.hoehe-2
				SetColor 255,255,255
				DrawText Self.Text,Self.x+2,Self.y+2
		End Select
	End Method
End Type

Type GUI_CHECK Extends GUI_OBJEKT
	Field wert:Int
	Const seite:Int=15
	
	Function Create:GUI_CHECK(x:Int,y:Int,wert:Int=0)
		Local c:GUI_CHECK=New GUI_CHECK
		
		c.x=x
		c.y=y
		c.wert=wert
		
		Return c
	End Function
	
	Method render()
		If EMEGUI.m_x>Self.x And EMEGUI.m_x<Self.x+Self.seite And EMEGUI.m_y>Self.y And EMEGUI.m_y<Self.y+Self.seite Then
			If EMEGUI.m_1=1 Then
				Self.wert=1-Self.wert
				EMEGUI.focus=Null
			End If
		End If
	End Method
	
	Method draw()
		SetColor 0,0,0
		DrawRect Self.x,Self.y,Self.seite,Self.seite
		
		SetColor 255,255,255
		DrawRect Self.x+1,Self.y+1,Self.seite-2,Self.seite-2
		
		If Self.wert=1 Then
			SetColor 0,0,0
			DrawRect Self.x+3,Self.y+3,Self.seite-6,Self.seite-6
		End If
	End Method
End Type

Type GUI_RADIO Extends GUI_OBJEKT
	Field actual_child:GUI_RADIO_CHILD
	
	
	Function Create:GUI_RADIO()
		Local r:GUI_RADIO=New GUI_RADIO
		
		Return r
	End Function
	
	Method get_wert:String()
		Return Self.actual_child.wert
	End Method
	
	Method render()
	End Method
	
	Method draw()
	End Method
End Type

Type GUI_RADIO_CHILD Extends GUI_OBJEKT
	Field wert:String
	Field parent:GUI_RADIO
	Const seite:Int=15
	
	Function Create:GUI_RADIO_CHILD(x:Int,y:Int,wert:String,parent:GUI_RADIO)
		Local rc:GUI_RADIO_CHILD=New GUI_RADIO_CHILD
		
		rc.x=x
		rc.y=y
		rc.parent=parent
		rc.wert=wert
		
		Return rc
	End Function
	
	Method render()
		If EMEGUI.m_x>Self.x And EMEGUI.m_x<Self.x+Self.seite And EMEGUI.m_y>Self.y And EMEGUI.m_y<Self.y+Self.seite Then
			If EMEGUI.m_1=1 Then
				Self.parent.actual_child=Self
				EMEGUI.focus=Null
			End If
		End If
	End Method
	
	Method draw()
		SetColor 0,0,0
		DrawOval Self.x,Self.y,Self.seite,Self.seite
		
		SetColor 255,255,255
		DrawOval Self.x+1,Self.y+1,Self.seite-2,Self.seite-2
		
		If Self.parent.actual_child=Self Then
			SetColor 0,0,0
			DrawOval Self.x+3,Self.y+3,Self.seite-6,Self.seite-6
		End If
	End Method
End Type


Rem
Graphics 800,600
SetClsColor 150,150,150

Local i1:GUI_OBJEKT=GUI_INPUT.Create(100,100,"bla1",200)
'Local i2:GUI_OBJEKT=GUI_INPUT.Create(100,200,"bla2",200)

Local b1:GUI_OBJEKT=GUI_BUTTON.Create(10,300,"SENDEN",100)

Local rf1:GUI_OBJEKT=GUI_REQUESTFILE.Create(320,200,300,"load...")

Repeat
	EMEGUI.render_events()
	'RENDER
	i1.render()
	'i2.render()
	
	b1.render()
	
	rf1.render()
	
	'DRAW
	i1.draw()
	'i2.draw()
	
	b1.draw()
	
	rf1.draw()
	Flip
	Cls
Until KeyHit(key_escape)
end rem