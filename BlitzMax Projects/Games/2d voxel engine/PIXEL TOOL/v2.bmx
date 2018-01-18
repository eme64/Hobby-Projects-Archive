SuperStrict

Rem
----------------- CHANGE-LOG
- made blocks consistent -> fore / background

EndRem
Const SCALE_FACTOR:Int = 3 ' 3 would be the goal, if can make it with buffers...
Const GENERATION_MODE:Int = 2 ' 1 = borders, 2 = shadow

Const BDR_MIN:Int = 1
Const BDR_MAX:Int = 2

Const factor_0:Float = 0.5
Const factor_1:Float = 0.8

Global COLOR_IMAGE:Int = get_pixel_bytes_reverse:Int([Byte(0),Byte(255),Byte(0),Byte(255)])
Global COLOR_BORDER:Int = get_pixel_bytes_reverse:Int([Byte(255),Byte(0),Byte(255),Byte(255)])
Global COLOR_EMPTY:Int = get_pixel_bytes_reverse:Int([Byte(0),Byte(0),Byte(0),Byte(0)])


Global RANDOM:RANDOM_GEN = RANDOM_GEN.Create([[3.0,1.0]])

Type RANDOM_GEN
	Field offset:Long = 0
	
	Field scale:Float[][] ' power of 2 ?
	
	Field noise_size:Int
	Field noise:Byte[,]
	
	Function Create:RANDOM_GEN(scale:Float[][], noise_size:Int = 0, noise:Byte[,] = Null)
		Local r:RANDOM_GEN = New RANDOM_GEN
		
		r.scale = scale
		
		r.noise_size = noise_size
		r.noise = noise
		
		If r.noise_size = 0 Then
			r.noise_size = 2^6
			r.noise = RANDOM_GEN.get_noise_field(r.noise_size)
		EndIf
		
		Return r
	End Function
	
	Function get_noise_field:Byte[,](size:Int)
		Local n:Byte[,] = New Byte[size,size]
		
		For Local x:Int = 0 To size-1
			For Local y:Int = 0 To size-1
				n[x,y] = Rand(0,255)
			Next
		Next
		
		Return n
	End Function
	
	Method get_1d:Float(x:Float)
		Local sum:Float = 0
		Local sum_weight:Float = 0
		For Local i:Int = 0 To scale.length-1
			Local x1:Int = Floor(x/scale[i][0])
			
			Local x_side:Float = x/scale[i][0]-x1
			
			Local typ:Int = 2 ' interpol typ: 0 linear, 1 hermite, 2 quintic
			
			Local x_s:Float = interpolate(x_side,typ)
			Local x_s_i:Float = interpolate(1.0-x_side,typ)
			
			Local a:Float = get_1d_int(x1,scale[i][0])*x_s_i + get_1d_int(x1+1, scale[i][0])*x_s
			
			sum:+ a
			sum_weight:+scale[i][1]
		Next
		Return sum / sum_weight
	End Method
		
	Method get_1d_int:Float(x:Int,scale:Float)
		x = x + offset
		
		'If y<0 Or x < 0 Then Return 0.0
		Local n2:Int = noise_size*noise_size
		
		x = ((x Mod n2) +n2) Mod n2
		
		Return noise[x Mod noise_size,x/noise_size]/256.0
	End Method

		
	Method interpolate:Float(t:Float, typ:Int = 0)
		' t from 0 to 1
		Select typ
			Case 0
				Return t
			Case 1 ' Hermite
				Return (t*t*(3.0-2.0*t))
			Case 2 ' Quintic
				Return t*t*t*(t*(t*6.0-15.0)+10.0)
			Default
				Return t
		End Select
	End Method
End Type


Function scale_pixmap:TPixmap(src:TPixmap) ' scales to SCALE_FACTOR
	Local dest:TPixmap = CreatePixmap(src.width*SCALE_FACTOR, src.height*SCALE_FACTOR, PF_BGRA8888)
	
	For Local x_out:Int = 0 To src.width-1
		For Local y_out:Int = 0 To src.height-1
			Local clr:Int = src.ReadPixel(x_out, y_out)
			
			For Local x_in:Int = 0 To SCALE_FACTOR-1
				For Local y_in:Int = 0 To SCALE_FACTOR-1
					dest.WritePixel(x_out*SCALE_FACTOR + x_in, y_out*SCALE_FACTOR + y_in,  clr)
				Next
			Next
		Next
	Next
	
	Return dest
End Function

Function fill_darkest_pixmap:TPixmap(src:TPixmap) ' just to debug the darkest color !
	Local dest:TPixmap = CreatePixmap(src.width, src.height, PF_BGRA8888)
	
	Local clr:Int = get_darkest_pixel(src)
	
	Local b:Byte[] = get_pixel_bytes(clr)
	
	Print("   > darkest: " + b[0] + " " + b[1] + " " + b[2] + " " + b[3])
	
	For Local x_out:Int = 0 To src.width-1
		For Local y_out:Int = 0 To src.height-1
			dest.WritePixel(x_out, y_out,  clr)
		Next
	Next
	
	Return dest
End Function

Function get_darkest_pixel:Int(src:TPixmap)
	Local darkest:Int = 0
	Local darkest_lvl:Int = 1000
	
	For Local x_out:Int = 0 To src.width-1
		For Local y_out:Int = 0 To src.height-1
			Local clr:Int = src.ReadPixel(x_out, y_out)
			
			Local b:Byte[] = get_pixel_bytes(clr)
			
			If b[3] = 255 Then
				If darkest_lvl > (b[0] + b[1] + b[2]) Then
					darkest_lvl = (b[0] + b[1] + b[2])
					darkest = clr
				EndIf
			EndIf
		Next
	Next
	
	Return darkest
End Function

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

Function get_pixel_bytes_reverse:Int(b:Byte[])
	Local pix:Int = b[3]
	
	pix = pix Shl 8
	pix = pix | b[0]
	
	pix = pix Shl 8
	pix = pix | b[1]
	
	pix = pix Shl 8
	pix = pix | b[2]
	
	Return pix
End Function

Function canvas_get_empty:TPixmap[](size:Int, n:Int) ' get empty square canvas
	Local dest:TPixmap[] = New TPixmap[n]
	
	For Local i:Int = 0 To n-1
		dest[i] = CreatePixmap(size, size, PF_BGRA8888)
	
		For Local x_out:Int = 0 To size-1
			For Local y_out:Int = 0 To size-1
				dest[i].WritePixel(x_out, y_out,  COLOR_EMPTY)
			Next
		Next
	Next
	
	Return dest
End Function

Function canvas_add_top(src:TPixmap[], a:Int,b:Int, version:Int) ' version so that different corners can have different schemes
	
	For Local i:Int = 0 To src.length-1
		Local rnd_offset:Int = i*src[i].width + 400 + 1000*version
		
		For Local x_out:Int = 0 To src[i].width-1
			Local width:Int = RANDOM.get_1d(x_out + rnd_offset)*Float(b-a+1) + a
			
			For Local y_out:Int = 0 To width-1
				Local clr:Int = src[i].ReadPixel(x_out, y_out)
				
				If clr <> COLOR_IMAGE Then
					If y_out = width-1 Then
						src[i].WritePixel(x_out, y_out,  COLOR_BORDER)
					Else
						src[i].WritePixel(x_out, y_out,  COLOR_IMAGE)
					EndIf
				EndIf
			Next
		Next
	Next
End Function

Function canvas_add_bottom(src:TPixmap[], a:Int,b:Int, version:Int)
	
	For Local i:Int = 0 To src.length-1
		Local rnd_offset:Int = i*src[i].width + 300 + 1000*version
		
		For Local x_out:Int = 0 To src[0].width-1
			Local width:Int = RANDOM.get_1d(x_out + rnd_offset)*Float(b-a+1) + a
			
			For Local y_out:Int = src[0].height-width To src[0].height-1
				Local clr:Int = src[i].ReadPixel(x_out, y_out)
				
				If clr <> COLOR_IMAGE Then
					If y_out = src[i].height-width Then
						src[i].WritePixel(x_out, y_out,  COLOR_BORDER)
					Else
						src[i].WritePixel(x_out, y_out,  COLOR_IMAGE)
					EndIf
				EndIf
			Next
		Next
	Next
End Function

Function canvas_add_right(src:TPixmap[], a:Int,b:Int, version:Int)
	
	For Local i:Int = 0 To src.length-1
		Local rnd_offset:Int = i*src[i].width + 100 + 1000*version
		
		For Local y_out:Int = 0 To src[i].width-1
			Local width:Int = RANDOM.get_1d(y_out + rnd_offset)*Float(b-a+1) + a
			
			For Local x_out:Int = src[i].height-width To src[i].height-1
				Local clr:Int = src[i].ReadPixel(x_out, y_out)
				
				If clr <> COLOR_IMAGE Then
					If x_out = src[i].height-width Then
						src[i].WritePixel(x_out, y_out,  COLOR_BORDER)
					Else
						src[i].WritePixel(x_out, y_out,  COLOR_IMAGE)
					EndIf
				EndIf
			Next
		Next
	Next
End Function


Function canvas_add_left(src:TPixmap[], a:Int,b:Int, version:Int)
	For Local i:Int = 0 To src.length-1
		Local rnd_offset:Int = i*src[i].width + 200 + 1000*version
		
		For Local y_out:Int = 0 To src[i].width-1
			Local width:Int = RANDOM.get_1d(y_out + rnd_offset)*Float(b-a+1) + a
			
			For Local x_out:Int = 0 To width-1
				Local clr:Int = src[i].ReadPixel(x_out, y_out)
				
				If clr <> COLOR_IMAGE Then
					If x_out = width-1 Then
						src[i].WritePixel(x_out, y_out,  COLOR_BORDER)
					Else
						src[i].WritePixel(x_out, y_out,  COLOR_IMAGE)
					EndIf
				EndIf
			Next
		Next
	Next
End Function

Function canvas_add_corner_tl(src:TPixmap[])
	
	Local x_out:Int = 0; Local y_out:Int = 0
	
	For Local i:Int = 0 To src.length-1
		Local clr:Int = src[i].ReadPixel(x_out, y_out)		
		If clr <> COLOR_IMAGE Then
			src[i].WritePixel(x_out, y_out,  COLOR_BORDER)
		EndIf
	Next
End Function

Function canvas_add_corner_tr(src:TPixmap[])
	Local x_out:Int = src[0].height-1; Local y_out:Int = 0
	
	For Local i:Int = 0 To src.length-1
		Local clr:Int = src[i].ReadPixel(x_out, y_out)		
		If clr <> COLOR_IMAGE Then
			src[i].WritePixel(x_out, y_out,  COLOR_BORDER)
		EndIf
	Next
End Function

Function canvas_add_corner_bl(src:TPixmap[])
	Local x_out:Int = 0; Local y_out:Int = src[0].height-1
	
	For Local i:Int = 0 To src.length-1
		Local clr:Int = src[i].ReadPixel(x_out, y_out)		
		If clr <> COLOR_IMAGE Then
			src[i].WritePixel(x_out, y_out,  COLOR_BORDER)
		EndIf
	Next
End Function

Function canvas_add_corner_br(src:TPixmap[])
	Local x_out:Int = src[0].width-1; Local y_out:Int = src[0].height-1
	
	For Local i:Int = 0 To src.length-1
		Local clr:Int = src[i].ReadPixel(x_out, y_out)		
		If clr <> COLOR_IMAGE Then
			src[i].WritePixel(x_out, y_out,  COLOR_BORDER)
		EndIf
	Next
End Function


Function get_pixmap_tl:TPixmap[](src:TPixmap[])
	Local dest:TPixmap[] = New TPixmap[src.length]
	
	For Local i:Int = 0 To src.length-1
		dest[i] = CreatePixmap(src[i].width/2, src[i].height/2, PF_BGRA8888)
	
		For Local x_out:Int = 0 To src[i].width/2-1
			For Local y_out:Int = 0 To src[i].height/2-1
				Local clr:Int = src[i].ReadPixel(x_out, y_out)
				
				dest[i].WritePixel(x_out, y_out,  clr)
			Next
		Next
	Next
	
	Return dest
End Function

Function get_pixmap_tr:TPixmap[](src:TPixmap[])
	Local dest:TPixmap[] = New TPixmap[src.length]
	
	For Local i:Int = 0 To src.length-1
		dest[i] = CreatePixmap(src[i].width/2, src[i].height/2, PF_BGRA8888)
		
		For Local x_out:Int = 0 To src[i].width/2-1
			For Local y_out:Int = 0 To src[i].height/2-1
				Local clr:Int = src[i].ReadPixel(x_out + src[i].width/2, y_out)
				
				dest[i].WritePixel(x_out, y_out,  clr)
			Next
		Next
	Next
	
	Return dest
End Function

Function get_pixmap_bl:TPixmap[](src:TPixmap[])
	Local dest:TPixmap[] = New TPixmap[src.length]
	
	For Local i:Int = 0 To src.length-1
		dest[i] = CreatePixmap(src[i].width/2, src[i].height/2, PF_BGRA8888)
	
		For Local x_out:Int = 0 To src[i].width/2-1
			For Local y_out:Int = 0 To src[i].height/2-1
				Local clr:Int = src[i].ReadPixel(x_out, y_out + src[i].width/2)
				
				dest[i].WritePixel(x_out, y_out,  clr)
			Next
		Next
	Next
	
	Return dest
End Function

Function get_pixmap_br:TPixmap[](src:TPixmap[])
	Local dest:TPixmap[] = New TPixmap[src.length]
	
	For Local i:Int = 0 To src.length-1
		dest[i] = CreatePixmap(src[i].width/2, src[i].height/2, PF_BGRA8888)
	
		For Local x_out:Int = 0 To src[i].width/2-1
			For Local y_out:Int = 0 To src[i].height/2-1
				Local clr:Int = src[i].ReadPixel(x_out + src[i].width/2, y_out + src[i].width/2)
				
				dest[i].WritePixel(x_out, y_out,  clr)
			Next
		Next
	Next
	
	Return dest
End Function


Function render_pixmap_on_canvas:TPixmap[](src:TPixmap[], canv:TPixmap[], border_color:Int)
	Local dest:TPixmap[] = New TPixmap[src.length]
	
	For Local i:Int = 0 To src.length-1
		dest[i] = CreatePixmap(src[0].width, src[0].height, PF_BGRA8888)
	
		For Local x_out:Int = 0 To src[0].width-1
			For Local y_out:Int = 0 To src[0].height-1
				Local clr_src:Int = src[i].ReadPixel(x_out, y_out)
				Local clr_canv:Int = canv[i].ReadPixel(x_out, y_out)
				
				If clr_canv = COLOR_BORDER Then'COLOR_IMAGE, COLOR_BORDER, COLOR_EMPTY
					dest[i].WritePixel(x_out, y_out,  border_color)
				ElseIf clr_canv = COLOR_IMAGE Then
					dest[i].WritePixel(x_out, y_out,  clr_src)
				ElseIf clr_canv = COLOR_EMPTY Then
					dest[i].WritePixel(x_out, y_out,  COLOR_EMPTY)
				Else
					Input("found false color in canv ! ")
					End
				EndIf
			Next
		Next
	Next
	
	Return dest
End Function

Function pixmap_divide_frames:TPixmap[](src:TPixmap, size:Int)
	Local n:Int = src.width/size
	
	Local dest:TPixmap[] = New TPixmap[n]
	
	For Local i:Int = 0 To n-1
		dest[i] = CreatePixmap(size, size, PF_BGRA8888)
		
		For Local x_out:Int = 0 To size-1
			For Local y_out:Int = 0 To size-1
				Local clr:Int = src.ReadPixel(x_out + i*size, y_out)
				
				dest[i].WritePixel(x_out, y_out,  clr)
			Next
		Next
	Next
	
	Return dest
End Function

Function pixmap_merge_frames:TPixmap(src:TPixmap[])
	Local size:Int = src[0].height
	Local dest:TPixmap = CreatePixmap(size*src.length, size, PF_BGRA8888)
	
	For Local i:Int = 0 To src.length-1
		For Local x_out:Int = 0 To size-1
			For Local y_out:Int = 0 To size-1
				Local clr:Int = src[i].ReadPixel(x_out, y_out)
				
				dest.WritePixel(x_out + i*size, y_out,  clr)
			Next
		Next
	Next
	
	Return dest
End Function

Rem

Function canvas_add_top(src:TPixmap, a:Int,b:Int)
	
	Local rnd_offset:Int = Rand(0,2^6)
	
	For Local x_out:Int = 0 To src.width-1
		Local width:Int = RANDOM.get_1d(x_out + rnd_offset)*Float(b-a+1) + a
		
		For Local y_out:Int = 0 To width-1
			Local clr:Int = src.ReadPixel(x_out, y_out)
			
			If clr <> COLOR_IMAGE Then
				If y_out = width-1 Then
					src.WritePixel(x_out, y_out,  COLOR_BORDER)
				Else
					src.WritePixel(x_out, y_out,  COLOR_IMAGE)
				EndIf
			EndIf
		Next
	Next
End Function
End Rem

Print("welcome:")

For Local i:Int = 1 To AppArgs.length-1
	Local s:String = AppArgs[i]
	
	Print("# running on: " + s)
	If Not FileType(s) = FILETYPE_FILE Then
		Print("  > not a file !")
	Else
		Local img:TImage = LoadImage(s)
		
		If Not img Then
			Print("  > could not load image !")
		Else
			Print("  > image: " + img.width + ", " + img.height)
			
			Local dest_path:String = "results/" + StripAll(s)
			CreateDir(dest_path, True)
			
			Local resource:TPixmap = LockImage(img)
			
			Select GENERATION_MODE
				Case 0 ' -------------------------------------------------------- SIMPLE SCALE
					' the base !
					
					
					Local destination_0:TPixmap = scale_pixmap(resource)
					SavePixmapPNG(destination_0, dest_path + "/0.png",5)
				Case 1 ' -------------------------------------------------------- SIMPLE BORDERS
					' the base !
					Local destination_0:TPixmap = scale_pixmap(resource)
					SavePixmapPNG(destination_0, dest_path + "/0.png",5)
					
					Local res_frames:TPixmap[] = pixmap_divide_frames(resource, resource.height)
					
					Local resource_tl:TPixmap[] = get_pixmap_tl(res_frames)
					Local resource_tr:TPixmap[] = get_pixmap_tr(res_frames)
					Local resource_bl:TPixmap[] = get_pixmap_bl(res_frames)
					Local resource_br:TPixmap[] = get_pixmap_br(res_frames)
					
					' test darkest pixel:
					'Local destination_drk:TPixmap = fill_darkest_pixmap(resource)
					'SavePixmapPNG(destination_drk, dest_path + "/drk.png",5)
					
					'COLOR_IMAGE, COLOR_BORDER, COLOR_EMPTY
					Local border_clr:Int = get_darkest_pixel(resource)
					
					'------------------------------------------------------------------------- TOP LEFT
					Local canvas:TPixmap[] = canvas_get_empty(resource.height/2, res_frames.length)
					
					canvas_add_corner_tl(canvas)
					Local destination_tl_0:TPixmap[] = render_pixmap_on_canvas(resource_tl, canvas, border_clr)
					SavePixmapPNG(scale_pixmap(pixmap_merge_frames(destination_tl_0)), dest_path + "/tl_0.png",5)
					
					canvas_add_top(canvas, BDR_MIN,BDR_MAX, 0)
					Local destination_tl_1:TPixmap[] = render_pixmap_on_canvas(resource_tl, canvas, border_clr)
					SavePixmapPNG(scale_pixmap(pixmap_merge_frames(destination_tl_1)), dest_path + "/tl_1.png",5)
					
					canvas_add_left(canvas, BDR_MIN,BDR_MAX, 0)
					Local destination_tl_3:TPixmap[] = render_pixmap_on_canvas(resource_tl, canvas, border_clr)
					SavePixmapPNG(scale_pixmap(pixmap_merge_frames(destination_tl_3)), dest_path + "/tl_3.png",5)
					
					canvas = canvas_get_empty(resource.height/2, res_frames.length)
					canvas_add_left(canvas, BDR_MIN,BDR_MAX, 0)
					Local destination_tl_2:TPixmap[] = render_pixmap_on_canvas(resource_tl, canvas, border_clr)
					SavePixmapPNG(scale_pixmap(pixmap_merge_frames(destination_tl_2)), dest_path + "/tl_2.png",5)
					
					'------------------------------------------------------------------------- TOP Right
					canvas = canvas_get_empty(resource.height/2, res_frames.length)
					
					canvas_add_corner_tr(canvas)
					Local destination_tr_0:TPixmap[] = render_pixmap_on_canvas(resource_tr, canvas, border_clr)
					SavePixmapPNG(scale_pixmap(pixmap_merge_frames(destination_tr_0)), dest_path + "/tr_0.png",5)
					
					canvas_add_top(canvas, BDR_MIN,BDR_MAX, 1)
					Local destination_tr_1:TPixmap[] = render_pixmap_on_canvas(resource_tr, canvas, border_clr)
					SavePixmapPNG(scale_pixmap(pixmap_merge_frames(destination_tr_1)), dest_path + "/tr_1.png",5)
					
					canvas_add_right(canvas, BDR_MIN,BDR_MAX, 0)
					Local destination_tr_3:TPixmap[] = render_pixmap_on_canvas(resource_tr, canvas, border_clr)
					SavePixmapPNG(scale_pixmap(pixmap_merge_frames(destination_tr_3)), dest_path + "/tr_3.png",5)
					
					canvas = canvas_get_empty(resource.height/2, res_frames.length)
					canvas_add_right(canvas, BDR_MIN,BDR_MAX, 0)
					Local destination_tr_2:TPixmap[] = render_pixmap_on_canvas(resource_tr, canvas, border_clr)
					SavePixmapPNG(scale_pixmap(pixmap_merge_frames(destination_tr_2)), dest_path + "/tr_2.png",5)
					
					'------------------------------------------------------------------------- BOTTOM LEFT
					canvas = canvas_get_empty(resource.height/2, res_frames.length)
					
					canvas_add_corner_bl(canvas)
					Local destination_bl_0:TPixmap[] = render_pixmap_on_canvas(resource_bl, canvas, border_clr)
					SavePixmapPNG(scale_pixmap(pixmap_merge_frames(destination_bl_0)), dest_path + "/bl_0.png",5)
					
					canvas_add_left(canvas, BDR_MIN,BDR_MAX, 1)
					Local destination_bl_1:TPixmap[] = render_pixmap_on_canvas(resource_bl, canvas, border_clr)
					SavePixmapPNG(scale_pixmap(pixmap_merge_frames(destination_bl_1)), dest_path + "/bl_1.png",5)
					
					canvas_add_bottom(canvas, BDR_MIN,BDR_MAX, 0)
					Local destination_bl_3:TPixmap[] = render_pixmap_on_canvas(resource_bl, canvas, border_clr)
					SavePixmapPNG(scale_pixmap(pixmap_merge_frames(destination_bl_3)), dest_path + "/bl_3.png",5)
					
					canvas = canvas_get_empty(resource.height/2, res_frames.length)
					canvas_add_bottom(canvas, BDR_MIN,BDR_MAX, 0)
					Local destination_bl_2:TPixmap[] = render_pixmap_on_canvas(resource_bl, canvas, border_clr)
					SavePixmapPNG(scale_pixmap(pixmap_merge_frames(destination_bl_2)), dest_path + "/bl_2.png",5)
					
					'------------------------------------------------------------------------- BOTTOM Right
					canvas = canvas_get_empty(resource.height/2, res_frames.length)
					
					canvas_add_corner_br(canvas)
					Local destination_br_0:TPixmap[] = render_pixmap_on_canvas(resource_br, canvas, border_clr)
					SavePixmapPNG(scale_pixmap(pixmap_merge_frames(destination_br_0)), dest_path + "/br_0.png",5)
					
					canvas_add_right(canvas, BDR_MIN,BDR_MAX, 1)
					Local destination_br_1:TPixmap[] = render_pixmap_on_canvas(resource_br, canvas, border_clr)
					SavePixmapPNG(scale_pixmap(pixmap_merge_frames(destination_br_1)), dest_path + "/br_1.png",5)
					
					canvas_add_bottom(canvas, BDR_MIN,BDR_MAX, 1)
					Local destination_br_3:TPixmap[] = render_pixmap_on_canvas(resource_br, canvas, border_clr)
					SavePixmapPNG(scale_pixmap(pixmap_merge_frames(destination_br_3)), dest_path + "/br_3.png",5)
					
					canvas = canvas_get_empty(resource.height/2, res_frames.length)
					canvas_add_bottom(canvas, BDR_MIN,BDR_MAX, 1)
					Local destination_br_2:TPixmap[] = render_pixmap_on_canvas(resource_br, canvas, border_clr)
					SavePixmapPNG(scale_pixmap(pixmap_merge_frames(destination_br_2)), dest_path + "/br_2.png",5)
				Default
					RuntimeError("mode not found: " + GENERATION_MODE)
			End Select
		EndIf
	EndIf
Next

Print("bye.")
Input("press any key to close >") ' just to observe debugging!

End