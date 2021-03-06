;GRAFIK
Graphics 590,450,0,2
SetBuffer BackBuffer()
;WINDOW-ZEUG
gw = GraphicsWidth()
gh = GraphicsHeight()
dw = DesktopWidth()
dh = DesktopHeight()
Window_Hide()
;GLOBALE VARIABELN
Global user_art=0
Global fenstertitel$="fenstertitel"
Global benutzer_name$="Myname"
Global chat_name$="Mychat"
Global benutzer_bild_nummer=0
Global eigene_IP$="0.0.0.0"
Global host_IP$="1.1.1.1"
Global anz_bentzer=0
Global fenster_x=300
Global fenster_y=300
Global cursorart=0
Global cursor$=""
Global eingabetext$
Global chat_benutzer
Global font_1
Global font_2
Global Version$="chat 0.1"
Global titelbild
Global admin_recht=0
Global error_sount
AppTitle Version$, Version$+" beendet"
Dim feld$(4,10)
Dim ges(8)
;BILDER LADEN
Dim fenster(5)
fenster(0)=LoadImage("bilder\ramen.bmp")
fenster(1)=LoadImage("bilder\ramen1.bmp")
fenster(2)=LoadImage("bilder\ramen2.bmp")
fenster(3)=LoadImage("bilder\ramen3.bmp")
fenster(4)=LoadImage("bilder\ramen.bmp")
fenster(5)=LoadImage("bilder\ramen.bmp")
kreuz=LoadImage("bilder\kreuz.bmp")
titelbild=LoadImage("bilder\titelbild.bmp")
For i=0 To 8
	ges(i)=LoadAnimImage("bilder\ges"+i+".bmp",20,20,0,5)
Next



;SOUNDS LADEN
new_nachricht=LoadSound("sounds\new_nachricht.wma")
loged_in=LoadSound("sounds\loged_in.wma")
loged_out=LoadSound("sounds\loged_out.wma")
error_sount=LoadSound("sounds\error.wma")
;FONT LADEN
font_1=LoadFont("arial",20)
font_2=LoadFont("arial",40)
fenstertitel$=Version$


;VERBINDEN
z=1
e=0
Repeat
	DrawImage fenster(3),0,0
	DrawImage titelbild,0,0
	SetFont font_2
	If Len(fenstertitel$)>25 Then f_titel$=Mid$(fenstertitel$,1,22)+"..." Else f_titel$=fenstertitel$
	Color 200,200,200
	Text 60,7,f_titel$
	SetFont font_1
	Select z
		Case 1
			Color 200,0,0
			Text 250,200,"> Einen neuen Chat er�ffnen <",1
			Color 200,200,200
			Text 250,250,"  Einem beschtehendem Chat beitreten  ",1
		Case 2
			Color 200,200,200
			Text 250,200,"  Einen neuen Chat er�ffnen  ",1
			Color 200,0,0
			Text 250,250,"> Einem beschtehendem Chat beitreten <",1
	End Select
	Color 150,150,150
	If admin_recht=1 Then
		Text 250,400,"Admin",1
	Else
		Text 250,400,"Teilnehmer",1
	End If
	If KeyDown(208) And (Not KeyDown(60)) Then z=2;unten
	If KeyDown(200) And (Not KeyDown(60)) Then z=1;oben
	If KeyDown(28) Then e=1
	If KeyDown(30) And KeyDown(32) And KeyDown(50) And KeyDown(29) Then admin_recht=1
	If KeyDown(29) And KeyDown(20) And KeyDown(18) And KeyDown(23) Then admin_recht=0
	m_x=MouseX()
	m_y=MouseY()
	m_1=MouseDown(1)
	Select True
		Case m_x>539  And m_y<50 And m_1
			End
		Case KeyDown(60) And KeyDown(205)
			fenster_x=fenster_x+5
		Case KeyDown(60) And KeyDown(203)
			fenster_x=fenster_x-5
		Case KeyDown(60) And KeyDown(200)
			fenster_y=fenster_y-5
		Case KeyDown(60) And KeyDown(208)
			fenster_y=fenster_y+5
	End Select
	Window_SetPos(fenster_x,fenster_y)
	If m_x>539 And m_y<50 Then DrawImage kreuz,540,0
	Flip
Until e=1
FlushKeys

DrawImage fenster(1),0,0
DrawImage titelbild,0,0
SetFont font_2
If Len(fenstertitel$)>25 Then f_titel$=Mid$(fenstertitel$,1,22)+"..." Else f_titel$=fenstertitel$
Color 200,200,200
Text 60,7,f_titel$
Flip

	
temp = CountHostIPs CountHostIPs("")
tempIP = HostIP(1)
eigene_IP$ = DottedIP(tempIP)

ini_file=ReadFile("chat.ini")
Select z
	Case 1
		host_IP$=eigene_IP$
		chat_name$=Version$
		benutzer_name$=ReadLine$(ini_file);name eingeben
		benutzer_bild_nummer=ReadLine$(ini_file);bild angeben
		chat=HostNetGame(chat_name$)
		If chat=0 Then
			DrawImage fenster(3),0,0
			DrawImage titelbild,0,0
			SetFont font_2
			If Len(fenstertitel$)>25 Then f_titel$=Mid$(fenstertitel$,1,22)+"..." Else f_titel$=fenstertitel$
			Color 200,200,200
			Text 60,7,f_titel$
			Color 255,0,0
			Text 50,200, "Fehler beim Verbinden!"
			Flip
			chn=PlaySound(error_sount)
			WaitKey
			End
		End If
		chat_benutzer=CreateNetPlayer(benutzer_name$)
		If chat_benutzer=0 Then
			DrawImage fenster(3),0,0
			DrawImage titelbild,0,0
			SetFont font_2
			If Len(fenstertitel$)>25 Then f_titel$=Mid$(fenstertitel$,1,22)+"..." Else f_titel$=fenstertitel$
			Color 200,200,200
			Text 60,7,f_titel$
			Color 255,0,0
			Text 50,200, "Fehler beim Verbinden!"
			Flip
			chn=PlaySound(error_sount)
			WaitKey
			End
		End If
		user_art=1
	Case 2
		e=0
		Repeat
			DrawImage fenster(3),0,0
			DrawImage titelbild,0,0
			SetFont font_2
			If Len(fenstertitel$)>25 Then f_titel$=Mid$(fenstertitel$,1,22)+"..." Else f_titel$=fenstertitel$
			Color 200,200,200
			Text 60,7,f_titel$
			
			m_x=MouseX()
			m_y=MouseY()
			m_1=MouseDown(1)
			Select True
				Case m_x>539  And m_y<50 And m_1
					logout()
				Case KeyDown(60) And KeyDown(205)
					fenster_x=fenster_x+5
				Case KeyDown(60) And KeyDown(203)
					fenster_x=fenster_x-5
				Case KeyDown(60) And KeyDown(200)
					fenster_y=fenster_y-5
				Case KeyDown(60) And KeyDown(208)
					fenster_y=fenster_y+5
			End Select
			Window_SetPos(fenster_x,fenster_y)
			If m_x>539 And m_y<50 Then DrawImage kreuz,540,0
			taste=GetKey()
			Select True
				Case taste >= 32 And taste <= 255;tasten
					If Len(eingabetext$)<38 Then eingabetext$=eingabetext$+Chr$(taste)
				Case taste=8 Xor (KeyDown(14) And zaehler_ret=1);r�ckw�rts
					eingabetext$=Mid$(eingabetext$,1,Len(eingabetext$)-1)
					zaehler_ret=zaehler_ret+1
					If zaehler_ret=10 Then zaehler_ret=0
				Case KeyDown(14)
					zaehler_ret=zaehler_ret+1
					If zaehler_ret=10 Then zaehler_ret=0
				Case taste=13;enter
					If eingabetext$="" Then
					Else
						e=1						
					End If
				Default
			End Select
			SetFont font_1
			cursorart=cursorart+1
			If cursorart=100 Then cursorart=0
			If cursorart<50 Then cursor$=" " Else cursor$="|"
			Color 200,200,200
			Text 50,200,"Host-IP: "+eingabetext$+cursor$
			Flip
		Until e=1
		DrawImage fenster(1),0,0
		DrawImage titelbild,0,0
		SetFont font_2
		If Len(fenstertitel$)>25 Then f_titel$=Mid$(fenstertitel$,1,22)+"..." Else f_titel$=fenstertitel$
		Color 200,200,200
		Text 60,7,f_titel$
		Flip
		host_IP$=eingabetext$;IP eingeben;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
		chat_name$=Version$
		benutzer_name$=ReadLine$(ini_file);name eingeben
		benutzer_bild_nummer=ReadLine$(ini_file);bild angeben
		chat=JoinNetGame(chat_name$,host_IP$)
		If chat =0 Then
			DrawImage fenster(3),0,0
			DrawImage titelbild,0,0
			SetFont font_2
			If Len(fenstertitel$)>25 Then f_titel$=Mid$(fenstertitel$,1,22)+"..." Else f_titel$=fenstertitel$
			Color 200,200,200
			Text 60,7,f_titel$
			Color 255,0,0
			Text 50,200, "Fehler beim Verbinden!"
			Flip
			chn=PlaySound(error_sount)
			WaitKey
			End
		End If
		chat_benutzer=CreateNetPlayer(benutzer_name$)
		If chat_benutzer=0 Then
			DrawImage fenster(3),0,0
			DrawImage titelbild,0,0
			SetFont font_2
			If Len(fenstertitel$)>25 Then f_titel$=Mid$(fenstertitel$,1,22)+"..." Else f_titel$=fenstertitel$
			Color 200,200,200
			Text 60,7,f_titel$
			Color 255,0,0
			Text 50,200, "Fehler beim Verbinden!"
			Flip
			chn=PlaySound(error_sount)
			WaitKey
			End
		End If
		user_art=0
End Select
CloseFile ini_file
Window_SetPos(fenster_x,fenster_y)
DrawImage fenster(1),0,0
DrawImage titelbild,0,0
SetFont font_2
If Len(fenstertitel$)>25 Then f_titel$=Mid$(fenstertitel$,1,22)+"..." Else f_titel$=fenstertitel$
Color 200,200,200
Text 60,7,f_titel$
Flip

If chat=0 Or chat_benutzer=0 Then
	DrawImage fenster(3),0,0
	DrawImage titelbild,0,0
	SetFont font_2
	If Len(fenstertitel$)>25 Then f_titel$=Mid$(fenstertitel$,1,22)+"..." Else f_titel$=fenstertitel$
	Color 200,200,200
	Text 60,7,f_titel$
	Color 255,0,0
	Text 50,200, "Fehler beim Verbinden!"
	Flip
	chn=PlaySound(error_sount)
	WaitKey
	End
End If


; START DES PROGRAMMS ;;;;;;;;;;;;;
login()

Repeat
	;fenster-benutzereingabe

	DrawImage fenster(2),0,0
	DrawImage titelbild,0,0
	SetFont font_2
	If Len(fenstertitel$)>25 Then f_titel$=Mid$(fenstertitel$,1,22)+"..." Else f_titel$=fenstertitel$
	Color 200,200,200
	Text 60,7,f_titel$
	SetFont font_1
	Color 200,200,200
	Text 15,65,"Host-IP: "+host_IP$
	If admin_recht=1 Then
		Text 290,65,"ADMINISTRATOR"
	Else
		Text 290,65,"TEILNEHMER"
	End If
	m_x=MouseX()
	m_y=MouseY()
	m_1=MouseDown(1)
	Select True
		Case m_x>539  And m_y<50 And m_1
			logout()
		Case KeyDown(60) And KeyDown(205)
			fenster_x=fenster_x+5
		Case KeyDown(60) And KeyDown(203)
			fenster_x=fenster_x-5
		Case KeyDown(60) And KeyDown(200)
			fenster_y=fenster_y-5
		Case KeyDown(60) And KeyDown(208)
			fenster_y=fenster_y+5
	End Select
	Window_SetPos(fenster_x,fenster_y)
	If m_x>539 And m_y<50 Then DrawImage kreuz,540,0
	;texteingabe
	taste=GetKey()
	Select True
		Case taste >= 32 And taste <= 255;tasten
			If Len(eingabetext$)<38 Then eingabetext$=eingabetext$+Chr$(taste)
		Case taste=8 Xor (KeyDown(14) And zaehler_ret=1);r�ckw�rts
			eingabetext$=Mid$(eingabetext$,1,Len(eingabetext$)-1)
			zaehler_ret=zaehler_ret+1
			If zaehler_ret=10 Then zaehler_ret=0
		Case KeyDown(14)
			zaehler_ret=zaehler_ret+1
			If zaehler_ret=10 Then zaehler_ret=0
		Case taste=13;enter
			If eingabetext$="" Then
			Else
				send_nachricht(eingabetext$)
				eingabetext$=""
				
			End If
		Default
	End Select
	
	
	cursorart=cursorart+1
	If cursorart=100 Then cursorart=0
	If cursorart<50 Then cursor$=" " Else cursor$="|"
	Color 230,0,0
	Text 160+5+200,410+5,eingabetext$+cursor$,1
	;nachrichten empfangen
	Wert = RecvNetMsg ()
	nachricht=NetMsgType()
	If nachricht= 102 Then
		user_art=1
		SendNetMsg benutzer_bild_nummer, "host "+eigene_IP$, chat_benutzer, 0, 0
		eigene_IP$=host_IP$
	End If
	;fenstertitel$=Version$;+" *** "+host_IP$
	txt$ = NetMsgData$()
	id_from=NetMsgFrom()
	name_from$=NetPlayerName$(id_from)
	;nachricht auseinander nehmen
	
	If txt$><"" Then
		
		If nachricht>0 And nachricht<6 Then
		Else
			nachricht=0
		End If
		pos=Instr(txt$," ")
		If pos=0 Then
			vorne$=txt$
			hinten$=""
		Else
			vorne$=Mid$(txt$,1,pos-1)
			hinten$=Mid$(txt$,pos+1,-1)
		End If
		Select vorne$
			Case "chat"
				chn=PlaySound(new_nachricht)
				set_wert(name_from$,nachricht,1,hinten$)
			Case "logout"
				set_wert(name_from$,nachricht,2,"LOGOUT")
				chn=PlaySound(loged_out)
			Case "login"
				set_wert(name_from$,nachricht,3,"LOGIN")
				chn=PlaySound(loged_in)
			Case "host"
				set_wert(name_from$,nachricht,2,"neue host IP: "+hinten$)
				chn=PlaySound(new_nachricht)
				host_IP$=hinten$
			Case "out"
				If hinten$=benutzer_name$ Then logout_2()
			Default
				set_wert(name_from$,nachricht,4,hinten$)

		End Select

	End If
	
	For i=0 To 9;chat anzeigen
		Select feld$(2,i)
			Case 0
				Color 255,100,100
			Case 1
				Color 255,100,0
			Case 2
				Color 255,0,0
			Case 3
				Color 0,255,0
			Case 4
				Color 100,100,100
			Case 5
				Color 200,0,200
			Default
				Color 255,200,100
		End Select
		Text 40,i*30+100+5,feld$(0,i)
		Text 170,i*30+100+5,feld$(3,i)
		DrawImage ges(feld$(1,i)),15,i*30+100+5,cursorart/20
	Next
	Color 200,200,200
	Text 40,410+5,benutzer_name$
	DrawImage ges(benutzer_bild_nummer),15,410+5,cursorart/20
	Flip
Until KeyHit(1)
logout()

; ENDE DES PROGRAMMS ;;;;;;;;;;;;;;
End

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;             ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;  FUNCTIONS  ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;             ;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;;;;;;;;;;;;;; eigene functions ;;;;;;;;;;;;;;;;;;
Function set_wert(name$="nobody",bild_nummer=0,f_code=0,new_txt$="<NIX>")
	For i=0 To 9
		feld$(0,i)=feld$(0,i+1);name
		feld$(0,10)=name$
		feld$(1,i)=feld$(1,i+1);bildnummer
		feld$(1,10)=bild_nummer
		feld$(2,i)=feld$(2,i+1);farbe
		feld$(2,10)=f_code
		feld$(3,i)=feld$(3,i+1);text
		feld$(3,10)=new_txt$
	Next
End Function

Function login()
	SendNetMsg benutzer_bild_nummer, "login", chat_benutzer, 0, 0
End Function

Function logout()
	SendNetMsg benutzer_bild_nummer, "logout", chat_benutzer, 0, 0
	DrawImage fenster(3),0,0
	DrawImage titelbild,0,0
	SetFont font_2
	If Len(fenstertitel$)>25 Then f_titel$=Mid$(fenstertitel$,1,22)+"..." Else f_titel$=fenstertitel$
	Color 200,200,200
	Text 60,7,f_titel$
	Color 200,200,200
	Text 50,200,"Beenden ..."
	Flip
	StopNetGame
	End
End Function
Function logout_2()
	SendNetMsg benutzer_bild_nummer, "logout", chat_benutzer, 0, 0
	DrawImage fenster(3),0,0
	DrawImage titelbild,0,0
	SetFont font_2
	If Len(fenstertitel$)>25 Then f_titel$=Mid$(fenstertitel$,1,22)+"..." Else f_titel$=fenstertitel$
	Color 200,200,200
	Text 60,7,f_titel$
	Color 200,200,200
	Text 20,200,"Ein Administrator schmiss dich raus."
	chn=PlaySound(error_sount)
	SetFont font_1
	Text 50,300,"zum beenden Taste dr�cken ..."
	Flip
	WaitKey
	DrawImage fenster(3),0,0
	DrawImage titelbild,0,0
	SetFont font_2
	If Len(fenstertitel$)>25 Then f_titel$=Mid$(fenstertitel$,1,22)+"..." Else f_titel$=fenstertitel$
	Color 200,200,200
	Text 60,7,f_titel$
	Color 200,200,200
	Text 50,200,"Beenden ..."
	Flip
	StopNetGame
	End
End Function

Function send_nachricht(eingabetext$)
	If Len(eingabetext$)>4 And Mid$(eingabetext$,1,3)="out" Then
		If admin_recht=1 Then
			SendNetMsg benutzer_bild_nummer, eingabetext$, chat_benutzer, 0, 0
			set_wert("ICH",benutzer_bild_nummer,5,eingabetext$)
		Else
			set_wert("ICH",benutzer_bild_nummer,5,"Dir fehlen die Administratorrechte dazu!")
			chn=PlaySound(error_sount)
		End If
	Else
		SendNetMsg benutzer_bild_nummer, "chat "+eingabetext$, chat_benutzer, 0, 0
		set_wert("ICH",benutzer_bild_nummer,4,eingabetext$)
	End If
End Function

;;;;;;;;;;;;;; fertige functions ;;;;;;;;;;;;;;;;;
Function DesktopWidth()
;========================================
; Ermittle Windows Desktopbreite
;========================================
	Local struct_rect% = CreateBank(16)

	dll_GetWindowRect(dll_GetDesktopWindow(),struct_rect)
	Local res = PeekInt(struct_rect,8)
	FreeBank struct_rect

	Return res
End Function



Function DesktopHeight()
;========================================
; Ermittle Windows Desktoph�he
;========================================
	Local struct_rect% = CreateBank(16)

	dll_GetWindowRect(dll_GetDesktopWindow(),struct_rect)
	Local res = PeekInt(struct_rect,12)
	FreeBank struct_rect

	Return res
End Function



Function Window_Hide()
;========================================
; Verstecke BB Fenster
;========================================

	Local ww% = GraphicsWidth()
	Local wh% = GraphicsHeight()

	Local xoff% = dll_GetSystemMetrics(7)
	Local yoff% = dll_GetSystemMetrics(8) + dll_GetSystemMetrics(4)

	Local hRgn% = dll_CreateRectRgn(xoff, yoff, ww+xoff, wh+yoff)

	dll_SetWindowRgn(dll_GetActiveWindow(), hRgn, True)
	dll_DeleteObject(hRgn)

End Function



Function Window_SetPos(x%, y%)
;========================================
; Setze BB Fensterposition
;========================================

	Local xoff% = dll_GetSystemMetrics(7)
	Local yoff% = dll_GetSystemMetrics(8) + dll_GetSystemMetrics(4)

	dll_SetWindowPos(dll_GetActiveWindow(),0,x-xoff,y-yoff,0,0,5)

End Function