'SuperStrict

Type EFONT
	Global curr_font:EFONT
	
	Function set_font(font:EFONT)
		curr_font = font
	End Function
	
	Function draw(txt:String, x:Int, y:Int, scale:Int)
		curr_font.draw_(txt, x,y, scale)
	End Function
	
	Function get_width:Int(txt:String, scale:Int)
		Return curr_font.get_width_(txt,scale)
	End Function
	
	Field img:TImage
	Field size:Int
	Field frame:Byte[]
	Field frame_size:Byte[]
	
	Function Create:EFONT(file:String, size:Int)
		Local f:EFONT = New EFONT
		
		f.size = size
		f.img = LoadAnimImage(file, size,size,  0, 128, 0)
		
		f.frame = New Byte[256]
		f.frame_size = New Byte[256]
		
		' reset
		For Local i:Int = 0 To 255
			f.frame[i] = 94
			f.frame_size[i] = 4
		Next
		
		For Local i:Int = (0+33) To (93+33)
			f.frame[i] = i-33
			f.frame_size[i] = 0
			
			'scan image:
			Local pixmap:TPixmap = LockImage(f.img, f.frame[i])
			
			For Local x:Int = 0 To size-1
				For Local y:Int = 0 To size-1
					If get_pixel_bytes(pixmap.ReadPixel(x,y))[3] > 0 Then
						f.frame_size[i] = x
					EndIf
				Next
			Next
			f.frame_size[i]:+1
			
			UnlockImage(f.img, f.frame[i])
		Next
		
		f.frame[32] = 127
		f.frame_size[32] = 3
		
		Return f
	End Function
	
	Method draw_(txt:String, x:Int, y:Int, scale:Int)
		SetScale scale,scale
		For Local i:Int = 0 To Len(txt)-1
			DrawImage(img, x,y, frame[txt[i]])
			x:+(frame_size[txt[i]]+1)*scale
		Next
		SetScale 1,1
	EndMethod
	
	Method get_width_:Int(txt:String, scale:Int)
		Local x:Int = 0
		For Local i:Int = 0 To Len(txt)-1
			x:+(frame_size[txt[i]]+1)*scale
		Next
		
		Return x-scale
	End Method
	
	Function get_pixel_bytes:Byte[](pix:Int)
		Local b:Byte[] = New Byte[4]
		
		Const mask:Int = 255
		
		b[2] = pix & mask
		
		pix = pix Shr 8
		b[1] = pix & mask
		
		pix = pix Shr 8
		b[0] = pix & mask
		
		pix = pix Shr 8
		b[3] = pix & mask
		
		Return b
	End Function
EndType
