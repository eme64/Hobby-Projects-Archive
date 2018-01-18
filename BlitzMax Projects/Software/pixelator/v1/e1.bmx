SuperStrict


Import "engine_v3.bmx"
EG_MASTER.init(EG_SCREEN.Create_Screen("PIXELATOR",800,600,0))'1280,1024,1 '800,600,0  'DesktopWidth()-10,DesktopHeight()-70
'DesktopWidth()-10,DesktopHeight()-70
Window_Icon.init()
SetImageFont LoadImageFont("arial.ttf",14)
EG_DRAW.background_image = LoadImage("editor\bg_tile.png")


'TODO



'DONE


Global PixelSide:Int = 16'8
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
	
	Function open:Int(img:TPixelImage)
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
		
		a.clscolor = [255,255,255]
		
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
			End If
		Next
		
		If EG_WINDOW(Self.parent.parent.parent.parent).win_close = 1 Then
			
			Self.parent.parent.parent.parent.parent.rem_child(Self.parent.parent.parent.parent)
		End If
		
		
		For Local e:EG_MOUSE_2_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
				Local lx:Int = e.rel_x(Self)/PixelSide
				If lx>Self.img.dim_x-1 Then lx=Self.img.dim_x-1
				If lx<0 Then lx=0
				
				Local ly:Int = e.rel_y(Self)/PixelSide
				If ly>Self.img.dim_y-1 Then ly=Self.img.dim_y-1
				If ly<0 Then ly=0
				
				EG_MOUSE.current_transport = TPixel_Transport.Create(Self.img.pixels[lx,ly])
				
			End If
		Next
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
				Local lx:Int = e.rel_x(Self)/PixelSide
				If lx>Self.img.dim_x-1 Then lx=Self.img.dim_x-1
				If lx<0 Then lx=0
				
				Local ly:Int = e.rel_y(Self)/PixelSide
				If ly>Self.img.dim_y-1 Then ly=Self.img.dim_y-1
				If ly<0 Then ly=0
				
				Local pt:TPixel_Transport = TPixel_Transport(EG_MOUSE.current_transport)
				
				If pt Then
					Self.img.pixels[lx,ly] = TPixel.Create(pt.img, pt.color)
				EndIf
				
			End If
		Next
		
		For Local e:EG_MOUSE_DRAG = EachIn events
			If EG_MOUSE_DRAG.eg_obj=Self Or (EG_MOUSE_DRAG.eg_obj=Null And EG_CALC.inside(Self.viewport,[e.x,e.y])) Then
				EG_MOUSE_DRAG.eg_obj=Self
				
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
				Local lx:Int = e.rel_x(Self)/PixelSide
				If lx>Self.img.dim_x-1 Then lx=Self.img.dim_x-1
				If lx<0 Then lx=0
				
				Local ly:Int = e.rel_y(Self)/PixelSide
				If ly>Self.img.dim_y-1 Then ly=Self.img.dim_y-1
				If ly<0 Then ly=0
				
				Local pt:TPixel_Transport = TPixel_Transport(EG_MOUSE.current_transport)
				
				If pt Then
					Self.img.pixels[lx,ly] = TPixel.Create(pt.img, pt.color)
				EndIf
				
				e.drag(e.x_drag,e.y_drag)
			End If
		Next
		
		If KeyHit(key_f5) Then
			If EG_OBJECT.active_object = Self Then
				'export image !
				
				Self.img.export(RequestFile("Save PNG.", "Image:png",True))
			End If
		End If
		
		Return events
	End Method
	
	Method user_draw()
		
		Self.img.draw(0,0,Self)
		
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
	End Function
	
	Method save_file(path:String)
	End Method
	
	Method draw(x:Int,y:Int,parent:EG_OBJECT)
		'SetBlend LIGHTBLEND
		For Local xx:Int = 0 To Self.dim_x-1
			For Local yy:Int = 0 To Self.dim_y-1
				If Self.pixels[xx,yy] Then
					
					Local ii:Int = Self.pixels[xx,yy].img
					Local col:Int[] = Self.pixels[xx,yy].color.get()
					
					SetAlpha(Float(col[0])/255.0)
					SetColor(col[1],col[2],col[3])
					
					EG_DRAW.image(xx*PixelSide,yy*PixelSide, TPixelImages.images[ii],0,parent)
					
					
				EndIf
			Next
		Next
		
		SetAlpha(1)
		'SetBlend ALPHABLEND
	End Method
	
	Method export(path:String)
		Print "EXPORT:"
		Print path
		
		Local res_pix:TPixmap = CreatePixmap(Self.dim_x * PixelSide,Self.dim_y * PixelSide,PF_BGRA8888)
		res_pix.ClearPixels(ARGB.get(0,0,0,0))
		
		
		For Local xx:Int = 1 To Self.dim_x-2
			For Local yy:Int = 1 To Self.dim_y-2
				If Self.pixels[xx,yy] Then
					
					Local ii:Int = Self.pixels[xx,yy].img
					Local col:Int[] = Self.pixels[xx,yy].color.get()
					
					Local iii:TImage = TPixelImages.images[ii]
					
					Local iii_p:TPixmap = LockImage(iii,0,False,True)
					
					Local start_x:Int = PixelSide*xx - (iii.width-PixelSide)/2
					Local start_y:Int = PixelSide*yy - (iii.height-PixelSide)/2
					
					Local factor:Int = ARGB.get(col[0],col[1],col[2],col[3])
					
					For Local ix:Int = 0 To iii.width-1
						For Local iy:Int = 0 To iii.height-1
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
		
		
		Local n_a:Int = c1_a + c2_a
		
		If n_a > 255 Then
			c1_a = n_a - c2_a
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
End Type

Type TPixel_Transport Extends EG_MOUSE_TRANSPORT
	Field img:Int
	Field color:TColor
	
	Function Create:TPixel_Transport(p:TPixel)
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
		Return col
	End Method
	
	Method copy:TColor()
		Local c:TColor_ARGB = New TColor_ARGB
		
		c.col = Self.col
		
		Return c
	End Method
End Type

Type Tool_Constructor
	Function init()
		TPixelImages.init()
		Window_Icon.init()
		
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

'########################################################################################################################
EG_MASTER.screen.clscolor = [60,40,40]

Tool_Constructor.init()

TPixelImage_Area.open(TPixelImage.create_random(20,20))

Repeat
	EG_MASTER.update()
Until (KeyHit(key_escape) Or AppTerminate()) And Confirm("Close ?")