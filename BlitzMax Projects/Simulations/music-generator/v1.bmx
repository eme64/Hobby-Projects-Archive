SuperStrict

Type TTon
	Field sound:TSound
	Field pitch:Float
	
	Function create:TTon(sound:TSound,pitch:Float)
		Local t:TTon = New TTon
		
		t.sound = sound
		t.pitch = pitch
		
		Return t
	End Function
	
	Method play(pan:Float)
		Local channel:TChannel=Self.sound.play()
		SetChannelRate(channel,Self.pitch*(1.0+0.1*Float(MouseZ())))
		SetChannelPan(channel,pan)
		'ResumeChannel(channel)
	End Method
End Type


Type TRaster
	Field feld:Int[16,16]'0=aus, 1=an
	Field feld_licht:Float[16,16]
	Field toene:TTon[16]
	Field last_time:Int = 0
	
	Field speed:Int
	
	Method draw()
		For Local x:Int = 0 To 15
			For Local y:Int = 0 To 15
				SetColor 40,40,40
				DrawRect x*25+1,y*25+1,23,23
				
				SetColor Self.feld[x,y]*50,Self.feld[x,y]*50,Self.feld[x,y]*50
				DrawRect x*25+2,y*25+2,21,21
				
				SetColor Self.feld_licht[x,y],Self.feld_licht[x,y],Self.feld_licht[x,y]
				DrawRect x*25,y*25,25,25
			Next
		Next
	End Method
	
	Method render()
		Local mh1:Int = MouseHit(1)'Eingabe
		Local mx:Int = MouseX()
		Local my:Int = MouseY()
		
		For Local x:Int = 0 To 15'RASTER
			For Local y:Int = 0 To 15
				
				If Self.feld_licht[x,y]>0.1 Then
					Self.feld_licht[x,y]:-1
				End If
				
				If mh1 And mx > x*25 And mx < x*25+25 And my > y*25 And my < y*25+25 Then
					Self.feld[x,y]= 1 - Self.feld[x,y]
				End If
				
			Next
		Next
		
		'Töne
		Local time:Int = (MilliSecs() Mod speed)*16/speed
		SetColor 100,0,0
		DrawRect time*25,0,25,25*16
		
		If time >< Self.last_time Then
			Self.last_time = time
			
			'play!!!
			For Local y:Int = 0 To 15
				If Self.feld[time,y]=1 Then
					Self.feld_licht[time,y] = 100.0
					
					Self.toene[y].play((time Mod 2)*2-1)
				End If
			Next
			
		End If
		
	End Method
End Type

Graphics 800,600,0,200

SetBlend Lightblend

Local raster:TRaster = New TRaster
'raster.toene:TTon[16]

If 1=2 Then
	For Local i:Float = 0 To 15'HALBTON
		raster.toene[i] = TTon.create(TSound.Load("sound\3.wav",0),2.0^((10.0-i)/12.0))'4.0-(Float(i)/5.0))
	Next
Else
	For Local i:Int = 0 To 15'Pentatonik
		Local act_i:Int = Int(i/5)*12 + ((i Mod 5)=1)*2 + ((i Mod 5)=2)*4 + ((i Mod 5)=3)*7 + ((i Mod 5)=4)*9
		raster.toene[15-i] = TTon.create(TSound.Load("sound\4.wav",0),2.0^(Float(act_i-10)/12.0))
	Next
End If

raster.speed = 1500

Repeat
	
	If KeyHit(key_space) Then
		For Local x:Int = 0 To 15
			For Local y:Int = 0 To 15
				raster.feld[x,y]=0
			Next
		Next
	End If
	
	raster.render()
	Cls
	raster.draw()
	Flip
Until KeyHit(key_escape)

