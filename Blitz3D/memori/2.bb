Graphics 800,600,0,2
SetBuffer BackBuffer()

Global bild=LoadImage("bild.bmp")
Print bild
WaitKey()
Repeat
	Cls
	DrawImage bild,10,10
	Flip
Until KeyHit(1)
End