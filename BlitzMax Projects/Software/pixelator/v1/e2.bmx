SuperStrict


Import "engine_v3.bmx"
EG_MASTER.init(EG_SCREEN.Create_Screen("PIXELATOR",DesktopWidth()-10,DesktopHeight()-70,0))'1280,1024,1 '800,600,0  'DesktopWidth()-10,DesktopHeight()-70
'DesktopWidth()-10,DesktopHeight()-70
Window_Icon.init()
SetImageFont LoadImageFont("arial.ttf",14)
EG_DRAW.background_image = LoadImage("editor\bg_tile.png")


'TODO



'DONE


Global PixelSide:Int = 16
Global ImageLoadFlag:Int = MASKEDIMAGE' | MIPMAPPEDIMAGE

'########################################################################################################################

Type TPixelImages
	Global images:TImage[]
	
	Function init()
		Local i:Int = 0
		
		Repeat
			Local imgname:String = "gfx\" + PixelSide + "\" + i + ".png"
			If FileType(imgname)
				Print "loading: " + imgname
				
				Local iii:TImage = LoadImage(imgname, ImageLoadFlag)
				SetImageHandle(iii, (iii.width-PixelSide)/2, (iii.height-PixelSide)/2)
				
				TPixelImages.images:+[iii]
				
				
			Else
				Print "end: " + imgname
				Exit
			EndIf
			
			i:+1
		Forever
		
	End Function
End Type

Type TPixelImage_Area Extends EG_AREA
	Field img:TPixelImage
	Field zoom:Float = 1.0
	
	Field select_x1:Int = -1
	Field select_x2:Int = -1
	Field select_y1:Int = -1
	Field select_y2:Int = -1
	Field select_last:Int = 0
	
	Function open:Int(img:TPixelImage)
		If Not img Then Return False
		'window
		
		Local win:EG_WINDOW = EG_WINDOW.Create_WINDOW("Image " + img.name,100,100,200,400,EG_MASTER.screen, Window_Icon.level)
		win.set_adapt(-1)
		
		'scroll
		
		Local sa:EG_SCROLL_AREA = EG_SCROLL_AREA.Create_SCROLL_AREA("scroll",0,0,300,300,win,40,40)
		
		sa.adapt_size_x = 0
		sa.adapt_size_y = 0
		sa.draggable = 1
		
		
		'area
		Local img_a:TPixelImage_Area = TPixelImage_Area.Create(img,sa)
		
	End Function
	
	Function Create:TPixelImage_Area(img:TPixelImage,parent:EG_OBJECT)
		Local a:TPixelImage_Area = New TPixelImage_Area
		a.name = "Image_Area"
		
		a.img = img
		
		a.clscolor = [0,0,0]
		
		a.rel_x = 0
		a.rel_y = 0
		
		a.dx = a.img.dim_x * PixelSide
		a.dy = a.img.dim_y * PixelSide
		
		If parent Then a.parent = parent.add_child(a)
		
		Return a
	End Function
	
	
	Method render:TList(events:TList)'prototype
		For Local e:EG_MOUSE_OVER = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				'mouse over me !
				
				Local lx:Int = (e.rel_x(Self) + PixelSide/2)/PixelSide/Self.zoom
				If lx>Self.img.dim_x Then lx=Self.img.dim_x
				If lx<0 Then lx=0
				
				Local ly:Int = (e.rel_y(Self) + PixelSide/2)/PixelSide/Self.zoom
				If ly>Self.img.dim_y Then ly=Self.img.dim_y
				If ly<0 Then ly=0
				
				'select
				
				Local select_now:Int = 0
				
				If EG_OBJECT.active_object = Self Then
					For Local e:EG_KEY_CONTROLS = EachIn events
						Select e.name
							Case "s"
								If Self.select_last = 0 Then
									Self.select_x1 = lx
									Self.select_x2 = lx
									
									Self.select_y1 = ly
									Self.select_y2 = ly
								Else
									Self.select_x2 = lx
									Self.select_y2 = ly
								EndIf
								select_now = 1
						End Select
						
					Next
				EndIf
				Self.select_last = select_now
				
				Rem
				If select_now = 0 Then
					Self.select_x1 = -1
					Self.select_x2 = -1
					Self.select_y1 = -1
					Self.select_y2 = -1
				EndIf
				End Rem
			End If
		Next
		
		If EG_WINDOW(Self.parent.parent.parent.parent).win_close = 1 Then
			
			Self.parent.parent.parent.parent.parent.rem_child(Self.parent.parent.parent.parent)
		End If
		
		
		For Local e:EG_MOUSE_2_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
				Local lx:Int = e.rel_x(Self)/PixelSide/Self.zoom
				If lx>Self.img.dim_x-1 Then lx=Self.img.dim_x-1
				If lx<0 Then lx=0
				
				Local ly:Int = e.rel_y(Self)/PixelSide/Self.zoom
				If ly>Self.img.dim_y-1 Then ly=Self.img.dim_y-1
				If ly<0 Then ly=0
				
				EG_MOUSE.current_transport = TPixel_Transport.Create(Self.img.pixels[lx,ly])
				
			End If
		Next
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
				Local lx:Int = e.rel_x(Self)/PixelSide/Self.zoom
				If lx>Self.img.dim_x-1 Then lx=Self.img.dim_x-1
				If lx<0 Then lx=0
				
				Local ly:Int = e.rel_y(Self)/PixelSide/Self.zoom
				If ly>Self.img.dim_y-1 Then ly=Self.img.dim_y-1
				If ly<0 Then ly=0
				
				Local pt:TPixel_Transport = TPixel_Transport(EG_MOUSE.current_transport)
				
				If pt Then
					Self.img.pixels[lx,ly] = TPixel.Create(pt.img, pt.color)
				EndIf
				
				Local tpit:TPixelImage_Transport = TPixelImage_Transport(EG_MOUSE.current_transport)
				
				If tpit Then
					Local cimg:TPixelImage = tpit.img
					
					For Local xx:Int = 0 To cimg.dim_x-1
						If lx+xx > Self.img.dim_x-1 Then Continue
						For Local yy:Int = 0 To cimg.dim_y-1
							If ly+yy > Self.img.dim_y-1 Then Continue
							
							Self.img.pixels[xx+lx,yy+ly] = cimg.pixels[xx,yy].copy()
						Next
					Next
				EndIf
				
				Rem
				
				Local x1:Int = Min(Self.select_x1,Self.select_x2)
				Local x2:Int = Max(Self.select_x1,Self.select_x2)-x1
				
				Local y1:Int = Min(Self.select_y1,Self.select_y2)
				Local y2:Int = Max(Self.select_y1,Self.select_y2)-y1
				
				Local cimg:TPixelImage = TPixelImage.create_new(x2,y2)
				
				For Local xx:Int = 0 To x2-1
					For Local yy:Int = 0 To y2-1
						cimg.pixels[xx,yy] = Self.img.pixels[xx+x1,yy+y1].copy()
					Next
				Next
				
				EG_MOUSE.current_transport = TPixelImage_Transport.Create(cimg)
				
				End Rem
				
			End If
		Next
		
		For Local e:EG_MOUSE_DRAG = EachIn events
			If EG_MOUSE_DRAG.eg_obj=Self Or (EG_MOUSE_DRAG.eg_obj=Null And EG_CALC.inside(Self.viewport,[e.x,e.y])) Then
				EG_MOUSE_DRAG.eg_obj=Self
				
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
				Local lx:Int = e.rel_x(Self)/PixelSide/Self.zoom
				If lx>Self.img.dim_x-1 Then lx=Self.img.dim_x-1
				If lx<0 Then lx=0
				
				Local ly:Int = e.rel_y(Self)/PixelSide/Self.zoom
				If ly>Self.img.dim_y-1 Then ly=Self.img.dim_y-1
				If ly<0 Then ly=0
				
				Local pt:TPixel_Transport = TPixel_Transport(EG_MOUSE.current_transport)
				
				If pt Then
					Self.img.pixels[lx,ly] = TPixel.Create(pt.img, pt.color)
				EndIf
				
				Local tpit:TPixelImage_Transport = TPixelImage_Transport(EG_MOUSE.current_transport)
				
				If tpit Then
					Local cimg:TPixelImage = tpit.img
					
					For Local xx:Int = 0 To cimg.dim_x-1
						If lx+xx > Self.img.dim_x-1 Then Continue
						For Local yy:Int = 0 To cimg.dim_y-1
							If ly+yy > Self.img.dim_y-1 Then Continue
							
							Self.img.pixels[xx+lx,yy+ly] = cimg.pixels[xx,yy].copy()
						Next
					Next
				EndIf
				
				e.drag(e.x_drag,e.y_drag)
			End If
		Next
		
		If KeyHit(key_f5) Then
			If EG_OBJECT.active_object = Self Then
				'export image !
				
				Self.img.export(RequestFile("Save PNG.", "Image (PNG):png",True))
			End If
		End If
		
		If KeyHit(key_f6) Then
			If EG_OBJECT.active_object = Self Then
				'save image !
				
				Self.img.save_file(RequestFile("Save EIF.", "DATA (EIF):eif",True))
			End If
		End If
		
		
		For Local e:EG_MOUSE_SCROLL_ZOOM = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				
				
				Self.zoom:*2.0^(Float(e.z)/2.0)
				
				If Self.zoom > 32 Then Self.zoom = 32
				If Self.zoom < 0.25 Then Self.zoom = 0.25
				
				events.remove(e)
			End If
		Next
		
		Self.dx = Self.img.dim_x * PixelSide * Self.zoom
		Self.dy = Self.img.dim_y * PixelSide * Self.zoom
		
		Local w:EG_WINDOW = EG_WINDOW(Self.parent.parent.parent.parent)
		If w Then w.name = "Image " + Self.img.name + ", zoom = " + Self.zoom
		
		
		For Local e:EG_SELECT_ALL = EachIn events
			If EG_OBJECT.active_object = Self Then
				Self.select_x1 = 0
				Self.select_x2 = Self.img.dim_x
				Self.select_y1 = 0
				Self.select_y2 = Self.img.dim_y
				
				events.remove(e)
			EndIf
		Next
		
		For Local e:EG_COPY = EachIn events
			If EG_OBJECT.active_object = Self Then
				
				Local x1:Int = Min(Self.select_x1,Self.select_x2)
				Local x2:Int = Max(Self.select_x1,Self.select_x2)-x1
				
				Local y1:Int = Min(Self.select_y1,Self.select_y2)
				Local y2:Int = Max(Self.select_y1,Self.select_y2)-y1
				
				Local cimg:TPixelImage = TPixelImage.create_new(x2,y2)
				
				For Local xx:Int = 0 To x2-1
					For Local yy:Int = 0 To y2-1
						cimg.pixels[xx,yy] = Self.img.pixels[xx+x1,yy+y1].copy()
					Next
				Next
				
				EG_MOUSE.current_transport = TPixelImage_Transport.Create(cimg)
				
				events.remove(e)
			EndIf
		Next
		
		
		
		Return events
	End Method
	
	Method user_draw()
		
		Self.img.draw(0,0,Self,Self.zoom)
		
		SetScale Self.zoom, Self.zoom
		SetAlpha(Float(MilliSecs() Mod 256)/500.0)
		
		Local x1:Int = Min(Self.select_x1,Self.select_x2)
		Local x2:Int = Max(Self.select_x1,Self.select_x2)-x1
		
		Local y1:Int = Min(Self.select_y1,Self.select_y2)
		Local y2:Int = Max(Self.select_y1,Self.select_y2)-y1
		
		SetColor 255,255,255
		
		EG_DRAW.rect(x1*PixelSide * Self.zoom,y1*PixelSide * Self.zoom,x2*PixelSide,y2*PixelSide,Self)
		
		SetAlpha(1)
		SetScale 1,1
		
	End Method

End Type

Type TPixelImage
	Field dim_x:Int
	Field dim_y:Int
	Field pixels:TPixel[dim_x,dim_y]
	Field name:String
	
	Function create_new:TPixelImage(x:Int,y:Int)
		Local tpi:TPixelImage = New TPixelImage
		
		tpi.name = "unnamed"
		tpi.dim_x = x
		tpi.dim_y = y
		
		tpi.pixels = New TPixel[tpi.dim_x,tpi.dim_y]
		
		For Local xx:Int = 0 To tpi.dim_x-1
			For Local yy:Int = 0 To tpi.dim_y-1
				tpi.pixels[xx,yy] = TPixel.Create(1,TColor_Name.Create("blank"))
			Next
		Next
		
		Return tpi
	End Function
	
	Function create_random:TPixelImage(x:Int,y:Int)
		Local tpi:TPixelImage = New TPixelImage
		
		tpi.name = "unnamed_random"
		tpi.dim_x = x
		tpi.dim_y = y
		
		tpi.pixels = New TPixel[tpi.dim_x,tpi.dim_y]
		
		For Local xx:Int = 0 To tpi.dim_x-1
			For Local yy:Int = 0 To tpi.dim_y-1
				tpi.pixels[xx,yy] = TPixel.random()
			Next
		Next
		
		Return tpi
	End Function
	
	Function load_file:TPixelImage(path:String)
		Local stream:TStream = ReadFile(path)
		
		If Not stream Then Return Null
		
		Local tpi:TPixelImage = New TPixelImage
		
		tpi.name = StripAll(path)
		tpi.dim_x = Int(stream.ReadLine())
		tpi.dim_y = Int(stream.ReadLine())
		
		tpi.pixels = New TPixel[tpi.dim_x,tpi.dim_y]
		
		For Local xx:Int = 0 To tpi.dim_x-1
			For Local yy:Int = 0 To tpi.dim_y-1
				Local img:Int = Int(stream.ReadLine())
				
				Local txt:String = stream.ReadLine()
				Local bits:String[] = txt.Split(",")
				
				Select bits.length
					Case 4
						Local cc:Int[] = [Int(bits[0]),Int(bits[1]),Int(bits[2]),Int(bits[3])]
						
						tpi.pixels[xx,yy] = TPixel.Create(img,TColor_ARGB.Create(cc))
					Case 1
						tpi.pixels[xx,yy] = TPixel.Create(img,TColor_Name.Create(txt))
				End Select
			Next
		Next
		
		CloseFile(stream)
		
		Return tpi
	End Function
	
	Method save_file(path:String)
		
		If path = "" Then Return
		
		Local stream:TStream = WriteFile(path)
		
		stream.WriteLine(Self.dim_x)
		stream.WriteLine(Self.dim_y)
		
		For Local xx:Int = 0 To Self.dim_x-1
			For Local yy:Int = 0 To Self.dim_y-1
				stream.WriteLine(Self.pixels[xx,yy].img)
				
				Select True
					Case TColor_ARGB(Self.pixels[xx,yy].color) <> Null
						Local c:TColor_ARGB = TColor_ARGB(Self.pixels[xx,yy].color)
						
						stream.WriteLine(c.col[0] + "," + c.col[1] + "," + c.col[2] + "," + c.col[3])
					Case TColor_Name(Self.pixels[xx,yy].color) <> Null
						Local c:TColor_Name = TColor_Name(Self.pixels[xx,yy].color)
						Local ccol:Int[] = c.get()
						
						stream.WriteLine(ccol[0] + "," + ccol[1] + "," + ccol[2] + "," + ccol[3])
				End Select
			Next
		Next
		
		CloseFile(stream)
	End Method
	
	Method draw(x:Int,y:Int,parent:EG_OBJECT,zoom:Float)
		SetBlend LIGHTBLEND
		SetScale zoom,zoom
		For Local xx:Int = 0 To Self.dim_x-1
			For Local yy:Int = 0 To Self.dim_y-1
				If Self.pixels[xx,yy] Then
					
					Local ii:Int = Self.pixels[xx,yy].img
					Local col:Int[] = Self.pixels[xx,yy].color.get()
					
					SetAlpha(Float(col[0])/255.0)
					SetColor(col[1],col[2],col[3])
					
					EG_DRAW.image(x+xx*PixelSide*zoom,y+yy*PixelSide*zoom, TPixelImages.images[ii],0,parent)
					
				EndIf
			Next
		Next
		
		SetScale 1,1
		SetAlpha(1)
		SetBlend ALPHABLEND
	End Method
	
	Method export(path:String)
		Print "EXPORT:"
		Print path
		
		Local res_pix:TPixmap = CreatePixmap(Self.dim_x * PixelSide,Self.dim_y * PixelSide,PF_BGRA8888)
		res_pix.ClearPixels(ARGB.get(0,0,0,0))
		
		
		For Local xx:Int = 0 To Self.dim_x-1
			For Local yy:Int = 0 To Self.dim_y-1
				If Self.pixels[xx,yy] Then
					
					Local ii:Int = Self.pixels[xx,yy].img
					Local col:Int[] = Self.pixels[xx,yy].color.get()
					
					Local iii:TImage = TPixelImages.images[ii]
					
					Local iii_p:TPixmap = LockImage(iii,0,False,True)
					
					Local start_x:Int = PixelSide*xx - (iii.width-PixelSide)/2
					Local start_y:Int = PixelSide*yy - (iii.height-PixelSide)/2
					
					Local factor:Int = ARGB.get(col[0],col[1],col[2],col[3])
					
					For Local ix:Int = 0 To iii.width-1
						If ix + start_x < 0 Then Continue
						If ix + start_x > Self.dim_x * PixelSide - 1 Then Continue
						For Local iy:Int = 0 To iii.height-1
							If iy + start_y < 0 Then Continue
							If iy + start_y > Self.dim_y * PixelSide - 1 Then Continue
							
							Local col:Int = ARGB.multiply(factor,iii_p.ReadPixel(ix,iy))
							
							Local n_pix:Int = ARGB.add(res_pix.ReadPixel(ix + start_x,iy + start_y),col)
							
							res_pix.WritePixel(ix + start_x,iy + start_y, n_pix)
						Next
					Next
				EndIf
			Next
		Next
		
		
		SavePixmapPNG(res_pix,path,9)
		
		Print "done"
	End Method
End Type

Type ARGB
	Function add:Int(c1:Int, c2:Int)
		Local c1_a:Int = ARGB.alpha(c1)
		Local c1_r:Int = ARGB.red(c1)
		Local c1_g:Int = ARGB.green(c1)
		Local c1_b:Int = ARGB.blue(c1)
		
		Local c2_a:Int = ARGB.alpha(c2)
		Local c2_r:Int = ARGB.red(c2)
		Local c2_g:Int = ARGB.green(c2)
		Local c2_b:Int = ARGB.blue(c2)
		
		
		Local n_a:Int = 255 - ((255-c1_a) * (255-c2_a))/255'c1_a + c2_a
		
		If n_a > 255 Then
			'c1_a = n_a - c2_a
			n_a = 255
		EndIf
		
		If n_a = 0 Then Return ARGB.get(0,0,0,0)
		
		Local n_r:Int = ((c1_r * c1_a) + (c2_r * c2_a))/ n_a
		Local n_g:Int = ((c1_g * c1_a) + (c2_g * c2_a))/ n_a
		Local n_b:Int = ((c1_b * c1_a) + (c2_b * c2_a))/ n_a
		
		If n_r > 255 Then n_r = 255
		If n_g > 255 Then n_g = 255
		If n_b > 255 Then n_b = 255
		
		Return ARGB.get(n_a, n_r, n_g, n_b)
	End Function
	
	Function multiply:Int(c1:Int, c2:Int)
		Local c1_a:Int = ARGB.alpha(c1)
		Local c1_r:Int = ARGB.red(c1)
		Local c1_g:Int = ARGB.green(c1)
		Local c1_b:Int = ARGB.blue(c1)
		
		Local c2_a:Int = ARGB.alpha(c2)
		Local c2_r:Int = ARGB.red(c2)
		Local c2_g:Int = ARGB.green(c2)
		Local c2_b:Int = ARGB.blue(c2)
		
		Local n_a:Int = c1_a * c2_a / 255'255 - ((255-c1_a) * (255-c2_a))/255
		Local n_r:Int = c1_r * c2_r / 255
		Local n_g:Int = c1_g * c2_g / 255
		Local n_b:Int = c1_b * c2_b / 255
		
		If n_r > 255 Then n_r = 255
		If n_g > 255 Then n_g = 255
		If n_b > 255 Then n_b = 255
		
		Return ARGB.get(n_a, n_r, n_g, n_b)
	End Function
	
	Function get:Int(alpha:Int,red:Int,green:Int,blue:Int)
		Return (Int(alpha * $1000000) + Int(RED * $10000) + Int(green * $100) + Int(blue)) 
	End Function
	
	Function alpha:Int(argb:Int)
		Return (argb Shr 24) & $ff
	End Function
	
	Function red:Int(argb:Int)
	  Return (argb Shr 16) & $ff
	End Function
	
	Function green:Int(argb:Int)
	  Return (argb Shr 8) & $ff
	End Function
	
	Function blue:Int(argb:Int)
	 Return (argb & $ff) 
	End Function
End Type

Type TPixel
	Field img:Int
	Field color:TColor
	
	Function random:TPixel()
		Local p:TPixel = New TPixel
		
		p.img = Rand(0,TPixelImages.images.length-1)
		p.color = TColor_ARGB.Create([Rand(0,255),Rand(0,255),Rand(0,255),Rand(0,255)])
		
		Return p
	End Function
	
	Function Create:TPixel(img:Int, color:TColor)
		Local p:TPixel = New TPixel
		
		p.img = img
		p.color = color.copy()
		
		Return p
	End Function
	
	Method copy:TPixel()
		Local p:TPixel = New TPixel
		
		p.img = Self.img
		p.color = color.copy()
		
		Return p
	End Method
End Type

Type TPixel_Assembler Extends EG_AREA
	Field img:Int
	Field col:Int[]
	Field c_name:String
	
	Field input_name:EG_STRING_AREA
	
	Function Create_TPixel_Assembler:TPixel_Assembler(name:String, img:Int,col:Int[],c_name:String,parent:EG_OBJECT)
		Local a:TPixel_Assembler = New TPixel_Assembler
		a.name = name
		
		a.clscolor = [0,0,0]
		
		a.rel_x = 0
		a.rel_y = 0
		
		a.dx = 150
		a.dy = 170
		
		a.img = img
		a.col = col
		a.c_name = c_name
		
		a.input_name = EG_STRING_AREA.Create_String_Area("input name",5,145,140,a,"")
		
		If parent Then a.parent = parent.add_child(a)
		
		Return a
	End Function
	
	Method render:TList(events:TList)'prototype
		
		events = Super.render(events)
		
		Self.c_name = Self.input_name.text
		
		If Self.c_name <> "" Then
			TColor_Name.map.Insert(Self.c_name,Self.col[0] + "," + Self.col[1] + "," + Self.col[2] + "," + Self.col[3])
		EndIf
		
		For Local e:EG_MOUSE_OVER = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				'mouse over me !
			End If
		Next
		
		
		
		If EG_WINDOW(Self.parent.parent).win_close = 1 Then
			Self.parent.parent.parent.rem_child(Self.parent.parent)
		End If
		
		
		For Local e:EG_MOUSE_DRAG = EachIn events
			If EG_MOUSE_DRAG.eg_obj=Self Or (EG_MOUSE_DRAG.eg_obj=Null And EG_CALC.inside(Self.viewport,[e.x,e.y])) Then
				EG_MOUSE_DRAG.eg_obj=Self
				
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
				Local pt:TPixel_Transport = TPixel_Transport(EG_MOUSE.current_transport)
				
				If pt Then
					Self.img = pt.img
					
					Self.col = pt.color.get()
				EndIf
				
				EG_MOUSE_DRAG.reset()
			End If
		Next
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
				Local pt:TPixel_Transport = TPixel_Transport(EG_MOUSE.current_transport)
				
				If pt Then
					Self.img = pt.img
					
					Self.col = pt.color.get()
				EndIf
				
			End If
		Next
		
		For Local e:EG_MOUSE_2_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
				If Self.c_name <> "" Then
					EG_MOUSE.current_transport = TPixel_Transport.Create(TPixel.Create(Self.img, TColor_Name.Create(Self.c_name)))
				Else
					EG_MOUSE.current_transport = TPixel_Transport.Create(TPixel.Create(Self.img, TColor_ARGB.Create(Self.col)))
				EndIf
				
				
			End If
		Next
		
		Local scroll_typ:Int = 0
		
		For Local e:EG_KEY_CONTROLS = EachIn events
			Select e.name
				Case "1"
					scroll_typ = 1
				Case "2"
					scroll_typ = 2
				Case "3"
					scroll_typ = 3
				Case "4"
					scroll_typ = 4
			End Select
		Next
		
		For Local e:EG_MOUSE_SCROLL = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				
				Local change:Int = e.z
				
				If EG_MOUSE_SCROLL_SIDE(e) Then change = change*50
				If EG_MOUSE_SCROLL_ZOOM(e) Then change = change*10
				
				If scroll_typ > 0 Then
					Self.col[scroll_typ-1]:+change
					
					If Self.col[scroll_typ-1] < 0 Then Self.col[scroll_typ-1] = 0
					If Self.col[scroll_typ-1] > 255 Then Self.col[scroll_typ-1] = 255
				Else
					Self.img:+e.z
					
					If Self.img < 0 Then Self.img = 0
					If Self.img > TPixelImages.images.length-1 Then Self.img = TPixelImages.images.length-1
				EndIf
				events.remove(e)
			End If
		Next
		
		Return events
	End Method
	
	Method user_draw()
		SetAlpha(Float(Self.col[0])/255.0)
		SetColor(Self.col[1],Self.col[2],Self.col[3])
		
		SetScale 32/PixelSide,32/PixelSide
		EG_DRAW.image(50,50, TPixelImages.images[Self.img],0,Self)
		SetScale 1,1
		
		SetAlpha(1)
		SetBlend ALPHABLEND
		SetColor 255,255,255
		EG_DRAW.text(5,130, Self.col[0] + " " + Self.col[1] + " " + Self.col[2] + " " + Self.col[3],Self)
	End Method
End Type

Type TPixel_Transport Extends EG_MOUSE_TRANSPORT
	Field img:Int
	Field color:TColor
	
	Function Create:TPixel_Transport(p:TPixel)
		If p=Null Then Return Null
		Local t:TPixel_Transport = New TPixel_Transport
		t.img = p.img
		t.color = p.color.copy()
		t.name = "pixel_transport"
		Return t
	End Function
	
	Method draw(x:Int,y:Int)
		SetColor 0,0,0
		EG_DRAW.rect(x,y,PixelSide+2,1)
		EG_DRAW.rect(x,y,1,PixelSide+2)
		EG_DRAW.rect(x+PixelSide+1,y,1,PixelSide+2)
		EG_DRAW.rect(x,y+PixelSide+1,PixelSide+2,1)
		
		Local ii:Int = Self.img
		Local col:Int[] = Self.color.get()
		
		SetAlpha(Float(col[0])/255.0)
		SetColor(col[1],col[2],col[3])
		
		EG_DRAW.image(x+1,y+1, TPixelImages.images[ii],0)
		
		SetAlpha(1)
		SetBlend ALPHABLEND
	End Method
End Type

Type TPixelImage_Transport Extends EG_MOUSE_TRANSPORT
	Field img:TPixelImage
	
	Function Create:TPixelImage_Transport(img:TPixelImage)
		If img=Null Then Return Null
		Local t:TPixelImage_Transport = New TPixelImage_Transport
		t.img = img
		t.name = "pixel_image_transport"
		Return t
	End Function
	
	Method draw(x:Int,y:Int)
		SetColor 0,0,0
		EG_DRAW.rect(x,y,PixelSide*Self.img.dim_x+2,1)
		EG_DRAW.rect(x,y,1,PixelSide*Self.img.dim_y+2)
		EG_DRAW.rect(x+PixelSide*Self.img.dim_x+1,y,1,PixelSide*Self.img.dim_y+2)
		EG_DRAW.rect(x,y+PixelSide*Self.img.dim_y+1,PixelSide*Self.img.dim_x+2,1)
		
		Self.img.draw(x,y,Null,1)
		
		SetAlpha(1)
		SetBlend ALPHABLEND
	End Method
End Type

Type TColor
	Method get:Int[]()'argb
	End Method
	
	Method copy:TColor()
	End Method
End Type

Type TColor_ARGB Extends TColor
	Field col:Int[]
	
	Function Create:TColor_ARGB(col:Int[])
		Local c:TColor_ARGB = New TColor_ARGB
		
		c.col = col
		
		Return c
	End Function
	
	Method get:Int[]()
		Return [col[0],col[1],col[2],col[3]]
	End Method
	
	Method copy:TColor()
		Local c:TColor_ARGB = New TColor_ARGB
		
		c.col = [Self.col[0],Self.col[1],Self.col[2],Self.col[3]]
		
		Return c
	End Method
End Type

Type TColor_Name Extends TColor
	Field name:String
	
	Global map:TMap
	
	Function init()
		TColor_Name.map = INIT_MANAGER.get("color_name.data")
		
		If Not TColor_Name.map Then
			TColor_Name.map = New TMap
			TColor_Name.map.Insert("blank","0,0,0,0")
		EndIf
	End Function
	
	Function save_data()
		INIT_MANAGER.set(TColor_Name.map,"color_name.data")
	End Function
	
	Function Create:TColor_Name(name:String)
		Local c:TColor_Name = New TColor_Name
		
		c.name = name
		
		Return c
	End Function
	
	Method get:Int[]()
		If TColor_Name.map.Contains(Self.name) Then
			Local txt:String = String(TColor_Name.map.ValueForKey(Self.name))
			Local cc:String[] = txt.Split(",")
			
			Return [Int(cc[0]),Int(cc[1]),Int(cc[2]),Int(cc[3])]
		Else
			Return [255,Rand(0,255),Rand(0,255),Rand(0,255)]
		EndIf
	End Method
	
	Method copy:TColor()
		Local c:TColor_Name = New TColor_Name
		
		c.name = Self.name
		
		Return c
	End Method
End Type

Type Tool_Constructor
	Function init()
		TPixelImages.init()
		Window_Icon.init()
		TColor_Name.init()
		
		Tool_Constructor.init_tool_box()
	End Function
	
	Function init_pixel_assembler()
		Local win:EG_WINDOW = EG_WINDOW.Create_WINDOW("Pixel Assembler",400,220,200,400,EG_MASTER.screen, Window_Icon.assembler)
		
		win.set_adapt(-1)
		
		TPixel_Assembler.Create_TPixel_Assembler("pixel assembly",0,[255,255,255,255],"",win)
	End Function
	
	Function init_tool_box()
		Local win:EG_WINDOW = EG_WINDOW.Create_WINDOW("Tool Box",300,300,200,400,EG_MASTER.screen, Window_Icon.tool)
		win.set_adapt(-1)
		TTool_Box.Create_TTool_Box(win)
	End Function
End Type

Type Window_Icon
	Function init()
		Window_Icon.server = LoadImage("editor\window\server.png")
		Window_Icon.debug_log = LoadImage("editor\window\debug_log.png")
		Window_Icon.level = LoadImage("editor\window\level.png")
		
		Window_Icon.txt = LoadImage("editor\window\txt.png")
		Window_Icon.load_new = LoadImage("editor\window\load_new.png")
		Window_Icon.script = LoadImage("editor\window\script.png")
		Window_Icon.tool = LoadImage("editor\window\tool.png")
		
		Window_Icon.assembler = LoadImage("editor\window\assembler.png")
		Window_Icon.family  = LoadImage("editor\window\family.png")
		Window_Icon.select_= LoadImage("editor\window\select.png")
		
		Window_Icon.object_= LoadImage("editor\window\object.png")
	End Function
	
	Global server:TImage
	Global debug_log:TImage
	Global level:TImage
	
	Global txt:TImage
	Global load_new:TImage
	Global script:TImage
	Global tool:TImage
	
	Global assembler:TImage
	Global family:TImage
	Global select_:TImage
	
	Global object_:TImage
End Type

Type TTool_Box Extends EG_AREA
	Field pixel_assembler:EG_BUTTON
	
	Field x_input:EG_STRING_AREA
	Field y_input:EG_STRING_AREA
	Field create_button:EG_BUTTON
	
	Field load_button:EG_BUTTON
	
	Function Create_TTool_Box:TTool_Box(parent:EG_OBJECT)
		Local a:TTool_Box = New TTool_Box
		a.name = "Tool_Box"
		
		a.rel_x = 0
		a.rel_y = 0
		
		a.dx = 210
		a.dy = 250
		
		a.clscolor = [100,200,100]
		
		a.pixel_assembler = EG_BUTTON.Create_Button("Pixel Assembler",5,5,200,20,a)
		
		a.x_input = EG_STRING_AREA.Create_String_Area("X",5,30,200,a,"50")
		a.y_input  = EG_STRING_AREA.Create_String_Area("Y",5,55,200,a,"50")
		a.create_button = EG_BUTTON.Create_Button("Create Image",5,80,200,20,a)
		
		a.load_button = EG_BUTTON.Create_Button("Load Image (.EIF)",5,110,200,20,a)
		
		If parent Then a.parent = parent.add_child(a)
		
		Return a
	End Function
	
	Method render:TList(events:TList)'prototype
		
		events = Self.render_children(events)
		
		
		For Local e:EG_MOUSE_OVER = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				'mouse over me !
				
			End If
		Next
		
		
		If Self.pixel_assembler.status = 2 Then
			Self.pixel_assembler.status = 0
			
			Tool_Constructor.init_pixel_assembler()
		End If
		
		If Self.create_button.status = 2 Then
			Self.create_button.status = 0
			
			Local xxx:Int = Int(Self.x_input.text)
			Local yyy:Int = Int(Self.y_input.text)
			
			If xxx > 1 And yyy > 1 Then
				TPixelImage_Area.open(TPixelImage.create_new(xxx,yyy))
			EndIf
		End If
		
		If Self.load_button.status = 2 Then
			Self.load_button.status = 0
			
			TPixelImage_Area.open(TPixelImage.load_file(RequestFile("Load EIF.", "DATA (EIF):eif",False)))
		End If
		
		Return events
	End Method
	
	Method user_draw()
		
	End Method
End Type

Type INIT_MANAGER
	Function get:TMap(filename:String)
		Local fmap:TMap = New TMap
		
		Local stream:TStream = ReadFile(filename)
		
		If Not stream Then Return Null
		
		While Not Eof(stream)
			Local line:String = ReadLine(stream)
			
			If Mid(line,1,1) = "#" Then
				'komentar
			Else
				Local seq:String[] = line.split("=")
				If seq.length > 1 Then
					fmap.Insert(Lower(Trim(seq[0])),Trim(seq[1]))
				ElseIf seq[0]<>""
					Notify("INIT_MANAGER: " + filename + " # :" + seq[0])
				End If
			End If
		Wend
		
		CloseFile(stream)
		
		Return fmap
	End Function
	
	Function set(map:TMap,filename:String)
		Local stream:TStream = WriteFile(filename)
		
		stream.WriteLine("# AUTOGENERATED #")
		
		For Local k:String = EachIn MapKeys(map)
			Local v:String = String(map.ValueForKey(k))
			stream.WriteLine(k + " = " + v)
		Next
		
		CloseFile(stream)
	End Function
End Type


'########################################################################################################################
EG_MASTER.screen.clscolor = [60,40,40]

Tool_Constructor.init()

Repeat
	EG_MASTER.update()
Until (KeyHit(key_escape) Or AppTerminate()) And Confirm("Close ?")

TColor_Name.save_data()