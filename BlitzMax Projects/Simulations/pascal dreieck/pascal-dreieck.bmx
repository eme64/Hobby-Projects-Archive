SuperStrict

Type DATA
	
	Global anz_reien:Int
	Global feld:Int[anz_reien,anz_reien+1]
	
	Function init(reien:Int)
		DATA.anz_reien=reien
		DATA.feld=New Int[DATA.anz_reien,DATA.anz_reien+1]
	End Function
	
	Function pascal()
		For Local i:Int=0 To DATA.anz_reien-1
			For Local i2:Int=0 To i
				If i=0 Then
					DATA.feld[i,i2]=1
				Else
					If i2=0
						DATA.feld[i,i2]=1
					Else
						DATA.feld[i,i2]=DATA.feld[i-1,i2] + DATA.feld[i-1,i2-1]
					End If
				EndIf
			Next
		Next
	End Function
	
	Function draw_pascal(x:Int,y:Int)
		For Local i:Int=0 To DATA.anz_reien-1
			For Local i2:Int=0 To i
				Select Abs(DATA.feld[i,i2] Mod 4)
					Case 0
						SetColor 255,0,0
					Case 1
						SetColor 0,255,0
					Case 2
						SetColor 0,0,255
					Case 3
						SetColor 0,255,255
					Case 4
						SetColor 255,255,0
					Default
						SetColor 0,0,0
				End Select
				
				'DrawRect x-i*1.5+i2*3,y+3*i,2,2
				DrawRect x-i*0.5+i2*1,y+1*i,2,2
			Next
		Next
	End Function
End Type

'START

DATA.init(600)
DATA.pascal()

Graphics 800,600
Repeat
	Cls
	DATA.draw_pascal(400,10)
	Flip
Until KeyHit(key_escape)
'END

End