hohe=Input("Höhe: ")
breite=Input("Breite: ")
ho=hohe-1;höhe
br=breite-1;breite
rand_zahl=101;verändern,um zufall zu machen
Graphics 25*br+25,20*ho+20,32,2
SetBuffer BackBuffer()
sound=LoadSound("mario.mp3")
channel1=PlaySound(sound)

anim=LoadAnimImage("bild.bmp",25,20,0,4)
SeedRnd MilliSecs()
anim2=LoadAnimImage("zahlen2.bmp",20,20,0,9)
MaskImage anim,3,3,3
MaskImage anim2,0,0,0
anz=(ho+1)*(br+1)
Dim feld (br,ho,1)
For i=0 To rand_zahl
r_z=Rnd(0,5)
Next
For x=0 To br
	For y=0 To ho
		If Rand(0,5)=0 Then
			feld(x,y,0)=0
			anz=anz-1 
		Else 
			feld(x,y,0)=2
		End If
	Next
Next
Repeat
Cls


For x=0 To br
	For y=0 To ho
		If feld(x,y,1)=1 Then
				DrawImage anim, x*25, y*20, feld(x,y,0) 
				z=0
				If x > 0 And x < br And y > 0 And y < ho Then
					If feld(x-1,y-1,0)=0 Then z=z+1
					If feld(x-1,y,0)=0 Then z=z+1
					If feld(x-1,y+1,0)=0 Then z=z+1
					If feld(x+1,y-1,0)=0 Then z=z+1
					If feld(x+1,y,0)=0 Then z=z+1
					If feld(x+1,y+1,0)=0 Then z=z+1
					If feld(x,y+1,0)=0 Then z=z+1
					If feld(x,y-1,0)=0 Then z=z+1


				Else
					If x=0 And y=0 Then
						If feld(x+1,y,0)=0 Then z=z+1
						If feld(x+1,y+1,0)=0 Then z=z+1
						If feld(x,y+1,0)=0 Then z=z+1
						
					Else
						If x=0 And y=ho Then
														
							If feld(x+1,y-1,0)=0 Then z=z+1
							If feld(x+1,y,0)=0 Then z=z+1
							If feld(x,y-1,0)=0 Then z=z+1

						Else
					
							If x=br And y=0 Then
								If feld(x-1,y,0)=0 Then z=z+1
								If feld(x-1,y+1,0)=0 Then z=z+1
								If feld(x,y+1,0)=0 Then z=z+1
								
							Else
								If x=br And y=ho Then
									If feld(x-1,y-1,0)=0 Then z=z+1
									If feld(x-1,y,0)=0 Then z=z+1
									If feld(x,y-1,0)=0 Then z=z+1

								Else
									If x=0 Then
										If feld(x+1,y-1,0)=0 Then z=z+1
										If feld(x+1,y,0)=0 Then z=z+1
										If feld(x+1,y+1,0)=0 Then z=z+1
										If feld(x,y+1,0)=0 Then z=z+1
										If feld(x,y-1,0)=0 Then z=z+1
					
									Else
										If x=br Then
											If feld(x-1,y-1,0)=0 Then z=z+1
											If feld(x-1,y,0)=0 Then z=z+1
											If feld(x-1,y+1,0)=0 Then z=z+1
											If feld(x,y+1,0)=0 Then z=z+1
											If feld(x,y-1,0)=0 Then z=z+1
						
										Else
											If y=0 Then
												If feld(x-1,y,0)=0 Then z=z+1
												If feld(x-1,y+1,0)=0 Then z=z+1
												If feld(x+1,y,0)=0 Then z=z+1
												If feld(x+1,y+1,0)=0 Then z=z+1
												If feld(x,y+1,0)=0 Then z=z+1
												
											Else
												If feld(x-1,y-1,0)=0 Then z=z+1
												If feld(x-1,y,0)=0 Then z=z+1
												 
												If feld(x+1,y-1,0)=0 Then z=z+1
												If feld(x+1,y,0)=0 Then z=z+1
												 
												 
												If feld(x,y-1,0)=0 Then z=z+1
							
											End If										
										End If
									End If
								End If	

							End If	

						End If	

					End If	
				End If
				DrawImage anim2,x*25,y*20,z
			Else
				DrawImage anim, x*25, y*20, 3
			End If
	Next 
Next 
If MouseDown(1) Then
	x=MouseX()/25
	y=MouseY()/20
	If feld(x,y,1)=0 Then
		feld(x,y,1)=1
		If feld(x,y,0)=0 Then 
			fin=1
		Else
			anz=anz-1
		End If
	End If
End If
If anz=0 Then fin=2
Flip

If e_z=1 Then e_z2=1
If fin=1 Or fin =2 Then e_z=1

Until KeyHit(1) Or e_z2=1
If fin=1 Then 

	For x=0 To br
		For y=0 To ho
			DrawImage anim, x*25, y*20, feld(x,y,0) 
		Next 
	Next 
	Color 255,0,0
	Print "GAME OVER"
	Flip




Else
	If fin=2 Then
		For x=0 To br
			For y=0 To ho
				If feld(x,y,0)=0 Then
					DrawImage anim, x*25, y*20, 1
				Else
					DrawImage anim, x*25, y*20, 2

				End If
				
			Next 
		Next 
		Color 255,0,0

		Print "YOU WIN"
	End If
End If
Repeat
Until KeyHit(1) 
End