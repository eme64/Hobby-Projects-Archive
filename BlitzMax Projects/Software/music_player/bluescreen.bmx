SuperStrict

Framework BRL.Graphics
Import BRL.Retro
Import BRL.Max2D
Import BRL.GLMax2D

Type BLUESCREEN
	Global linie:Int=0
	
	Function WriteLine(txt:String)
		DrawText txt,1,20*linie+1
		SetColor 255,255,255
		BLUESCREEN.linie:+1
	End Function
	
	Function clear_creen()
		SetClsColor 0,0,255
		Cls
		BLUESCREEN.linie=0
	End Function
End Type


Graphics 800,600,32,30

HideMouse()


Repeat
	
	MouseX()
	
	BLUESCREEN.clear_creen()
	
	BLUESCREEN.WriteLine("Windows musste beendet werden, da sonst ihr Computer kapputt geht")
	BLUESCREEN.WriteLine("")
	BLUESCREEN.WriteLine("Hinweis:")
	BLUESCREEN.WriteLine("Nie vergessen den Computer zu sperren.")
	BLUESCREEN.WriteLine("Bitte um Rat in der Klasse fragen.")
	BLUESCREEN.WriteLine("")
	BLUESCREEN.WriteLine("Technical information:")
	BLUESCREEN.WriteLine("*** STOP: 1. April (01.04.2011)")
	BLUESCREEN.WriteLine("")
	BLUESCREEN.WriteLine("Ihr Computer wird sich KOMISCH verhalten...")
	BLUESCREEN.WriteLine("")
	BLUESCREEN.WriteLine("Gruss: PC")
	BLUESCREEN.WriteLine("")
	BLUESCREEN.WriteLine("")
	BLUESCREEN.WriteLine("")
	BLUESCREEN.WriteLine("")
	BLUESCREEN.WriteLine("")
	BLUESCREEN.WriteLine("")
	BLUESCREEN.WriteLine("Deleting Harddisk(c:) "+Mid(String((Float(MilliSecs()) Mod 1000000.0)/10000.0),1,5)+"%")
	Local txt:String=""
	For Local i:Int = 1 To 100 Step 2
		If (Float(MilliSecs()) Mod 1000000.0)/10000.0 >= i Then
			txt:+"#"
		Else
			txt:+"_"
		End If
	Next
	BLUESCREEN.WriteLine("")
	BLUESCREEN.WriteLine("  "+txt)
	Flip
	
	If KeyDown(key_escape) And KeyHit(key_e) Then End
Forever