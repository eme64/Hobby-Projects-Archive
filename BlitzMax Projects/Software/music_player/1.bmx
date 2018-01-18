SuperStrict

Framework PUB.Win32
'Import BRL.LinkedList
Import BRL.Graphics
Import BRL.Max2D
Import BRL.GLMax2D

'Import BRL.StandardIO
Import BRL.Retro
'Import BRL.FreeTypeFont


AppTitle="Music Player (c) EME-Soft"



'############################# GUI #####################################


Type EMEGUI
	
	Global FPS:Int
	Global count_fps:Int
	Global time:Int=MilliSecs()
	
	Function render_liste(l:TList)
		
	End Function
	
	Global focus:GUI_OBJEKT
	
	Function render_events()
		
		'FPS
		EMEGUI.count_fps:+1
		If time+1000<MilliSecs() Then
			EMEGUI.FPS=EMEGUI.count_fps
			EMEGUI.count_fps=0
			EMEGUI.time:+1000
		End If
		'SetColor 255,0,0
		'DrawText "FPS: "+EMEGUI.FPS,0,0
		
		'MOUSE
		EMEGUI.m_1_last=EMEGUI.m_1
		Select EMEGUI.m_1_last
			Case 0'off
				If MouseHit(1) Then
					EMEGUI.m_1=1
				End If
			Case 1'new on
				If MouseDown(1) Then
					EMEGUI.m_1=2
				Else
					EMEGUI.m_1=-1
				End If
			Case 2
				If Not MouseDown(1) Then
					EMEGUI.m_1=-1
				End If
			Case -1
				If MouseHit(1) Or MouseDown(1) Then
					EMEGUI.m_1=1
				Else
					EMEGUI.m_1=0
				End If
		End Select
		
		EMEGUI.m_2_last=EMEGUI.m_2
		Select EMEGUI.m_2_last
			Case 0'off
				If MouseHit(2) Or MouseDown(2) Then
					EMEGUI.m_2=1
				End If
			Case 1'new on
				If MouseDown(2) Then
					EMEGUI.m_2=2
				End If
			Case 2
				If Not MouseDown(2) Then
					EMEGUI.m_2=-1
				End If
			Case -1
				If MouseHit(2) Or MouseDown(2) Then
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
					
					If Self.pos>1 Then
						Self.mark=Self.pos-1
						Self.pos=1
					Else
						Self.mark=0
					End If
					
					Exit
				Else If TextWidth(Mid(Self.content,1,i))>EMEGUI.m_x-(Self.x+2)-5 Then
					
					
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
	Field path:String
	
	Field title:String
	Field extensions:String'bla: txt,doc; all files: *
	Field save_load:Int'false=load, true=save
	
	Function Create:GUI_REQUESTFILE(x:Int,y:Int,dx:Int,title:String="title",extensions:String="All Files:*",active:Int=1,save_load:Int=False,path:String="")
		Local rf:GUI_REQUESTFILE=New GUI_REQUESTFILE
		
		rf.save_load=save_load
		rf.x=x
		rf.y=y
		rf.dx=dx
		rf.active=active
		rf.path=path
		rf.extensions=extensions
		
		Return rf
	End Function
	
	Method render()
		If EMEGUI.m_x>Self.x And EMEGUI.m_x<Self.x+Self.dx And EMEGUI.m_y>Self.y And EMEGUI.m_y<Self.y+Self.hoehe Then
			If EMEGUI.m_1=1 Then
				Self.filename=RequestFile(Self.title,Self.extensions,Self.save_load,Self.path)
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

Rem
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
End Rem

'############################# SONSTIGES ###############################
Type SOUND
	
End Type

'############################# MAIN ####################################


Repeat
	Graphics 400,105
	SetClsColor 240,240,240
	
	Local b1:GUI_BUTTON=GUI_BUTTON.Create(5,80,"OK",100)
	
	Local rf1:GUI_REQUESTFILE=GUI_REQUESTFILE.Create(50,5,335,"Datei w�hlen...","Tabellen Files:csv",,,"")
	
	Local i1:GUI_INPUT=GUI_INPUT.Create(70,30,"1",100)'i1.content
	
	Local c1:GUI_CHECK=GUI_CHECK.Create(230,55,0)'c1.wert
	
	Repeat
		EMEGUI.render_events()
		
		'b1.render()
		rf1.render()
		i1.render()
		c1.render()
		
		SetColor 0,0,0
		DrawText "File:",5,5
		DrawText "Anzahl:",5,30
		DrawText "beenden nachdem abgespielt:",5,55
		
		'b1.draw()
		rf1.draw()
		i1.draw()
		c1.draw()
		
		If FileType(rf1.filename)=1 Then
			b1.render()
			b1.draw()
		Else
			
		End If
		
		If AppTerminate() Or KeyHit(key_escape) Then
			If Confirm("Wollen sie das Programm wirklich beenden?") Then End
		End If
		
		Flip
		Cls
	Until (b1.pressed=3 Or KeyHit(key_enter)) And FileType(rf1.filename)=1
	EndGraphics
	
	'EINLESEN und ABSPIELEN
	
	
	
	For Local i:Int=1 To Int(i1.content)
		Local stream:TStream=ReadFile(rf1.filename)
		
		Local txt:String=ReadLine(stream)
		Local pos:Int=Instr(txt,",",1)
		Local factor:Float=Float(Mid(txt,1,pos-1))
		'Print "factor: "+factor
		
		While Not Eof(stream)
			Local txt:String=ReadLine(stream)
			Local pos:Int=Instr(txt,",",1)
			Local freq:Float=Float(Mid(txt,1,pos-1))
			Local length:Float=Float(Mid(txt,pos+1,-1))
			'Print "freq: "+freq
			'Print "length: "+length
			'Print "------------------"
			If freq=0 Then
				Delay length*factor
			Else
				Beep freq,length*factor
			End If
		Wend
		
		Delay 1000
	Next
	
	If c1.wert=1 Then End
Forever

Rem
Local r1:GUI_RADIO=GUI_RADIO.Create()

Local rc1:GUI_RADIO_CHILD=GUI_RADIO_CHILD.Create(10,100,"1",r1)
Local rc2:GUI_RADIO_CHILD=GUI_RADIO_CHILD.Create(10,125,"2",r1)
Local rc3:GUI_RADIO_CHILD=GUI_RADIO_CHILD.Create(10,150,"3",r1)
r1.actual_child=rc1

Local b1:GUI_BUTTON=GUI_BUTTON.Create(100,250,"OK",100)

Repeat
	EMEGUI.render_events()
	
	rc1.render()
	rc2.render()
	rc3.render()
	b1.render()
	
	SetColor 0,0,0
	DrawText "neues Projekt erstellen",30,100
	DrawText "existierendes Projekt laden",30,125
	DrawText "Wiederherstellung nach Absturz",30,150
	
	rc1.draw()
	rc2.draw()
	rc3.draw()
	b1.draw()
	
	If AppTerminate() Then
		If Confirm("Wollen sie das Programm wirklich beenden?") Then End
	End If
	
	Flip
	Cls
Until b1.pressed=3 Or KeyHit(key_enter)
end rem