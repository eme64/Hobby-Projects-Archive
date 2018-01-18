SuperStrict

'original code on:
'http://www.blitzforum.de/forum/viewtopic.php?t=27274&highlight=fbo

' First adapted for light-engine
' now repurposed for 2d voxel-engine

Import BRL.GlMax2D
Import Pub.Glew
Import BRL.StandardIO

Type TImageBuffer
	Field Image:TImage
	Field rb:Int[1]
	Field fb:Int[1]
	Field Imageframe:TGLImageframe
	Field Frame:Int = 0
	Field OrigX:Int
	Field OrigY:Int
	Field OrigW:Int
	Field OrigH:Int
	
	Function SetBuffer:TImageBuffer(Image:TImage,Frame:Int = 0 )
		Local IB:TImageBuffer = New TImageBuffer
		IB.Image = Image
		IB.Frame = Frame
		IB.GenerateFBO()
		IB.BindBuffer()
		Return IB
	End Function
	
	Function Init(Width:Int,Height:Int,Bit:Int=0,Mode:Int=60)
		SetGraphicsDriver(GLMax2DDriver())
		Graphics Width , Height,bit,Mode
		glewInit()
	End Function
	
	Method GenerateFBO()
		ImageFrame = TGLImageFrame(Image.frame(Frame) )
		
		imageframe.v0 = imageframe.v1
		imageframe.v1 = 0.0
		
		Local W:Int = Image.width
		Local H:Int = Image.Height
		
		AdjustTexSize(W , H)
		
		glGenFramebuffersEXT(1, fb )
		glGenRenderbuffersEXT(1 , rb)
		
		glBindTexture(GL_TEXTURE_2D, Imageframe.name);
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT , fb[0]) ;
		
		
		glFramebufferTexture2DEXT(GL_FRAMEBUFFER_EXT, GL_COLOR_ATTACHMENT0_EXT, GL_TEXTURE_2D,  Imageframe.name, 0);
		glBindRenderbufferEXT(GL_RENDERBUFFER_EXT, rb[0]);
		glRenderbufferStorageEXT(GL_RENDERBUFFER_EXT, GL_DEPTH_COMPONENT24, W, H);
		glFramebufferRenderbufferEXT(GL_FRAMEBUFFER_EXT , GL_DEPTH_ATTACHMENT_EXT , GL_RENDERBUFFER_EXT , rb[0])
		
		Local status:Int =  glCheckFramebufferStatusEXT(GL_FRAMEBUFFER_EXT)
		
		Select status
			Case GL_FRAMEBUFFER_COMPLETE_EXT
				'Print "IMAGE_BUFFER: all right" + " : " + Status
			Case GL_FRAMEBUFFER_UNSUPPORTED_EXT
				Print "choose different formats"
			Default
				End
		EndSelect
		
	End Method
	
	Method BindBuffer()
		GetViewport(OrigX,OrigY,OrigW,OrigH)
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT , fb[0])
		glMatrixMode GL_PROJECTION
		glLoadIdentity
		glOrtho 0,Image.Width,Image.Width,0,-1,1
		glMatrixMode GL_MODELVIEW
		glViewport(0 , 0 , Image.Width , Image.Height)
		glScissor 0,0, Image.Width , Image.Height
	End Method
	
	Method UnBindBuffer()
		glBindFramebufferEXT(GL_FRAMEBUFFER_EXT , 0)
		glMatrixMode GL_PROJECTION
		glLoadIdentity
		glOrtho 0,OrigW ,Origh,0,-1,1
		glMatrixMode GL_MODELVIEW
		glViewport(0 , 0 , OrigW, OrigH)
		glScissor 0,0, OrigW ,OrigH
	End Method
	
	Method Cls(r#=0.0,g#=0.0,b#=0.0,a#=1.0)
		glClearColor r,g,b,a
		glClear GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT
	End Method
	
	Method cls_part(x:Int,y:Int, w:Int, h:Int, r#=0.0,g#=0.0,b#=0.0,a#=1.0)
		'glViewport(x , y , w , h)
		
		glEnable GL_SCISSOR_TEST
		glScissor x , Image.Height-y-h , w , h
		
		glClearColor r,g,b,a
		glClear GL_COLOR_BUFFER_BIT|GL_DEPTH_BUFFER_BIT
		
		glDisable GL_SCISSOR_TEST
		
		glViewport(0 , 0 , Image.Width , Image.Height)
		glScissor 0,0, Image.Width , Image.Height
	EndMethod
	
	Method BufferWidth:Int()
		Return Image.Width
	End Method
	
	Method BufferHeight:Int()
		Return Image.Height
	End Method
	
End Type


Function AdjustTexSize( width:Int Var,height:Int Var )
	'calc texture size
	width=Pow2Size( width )
	height=Pow2Size( height )
	Repeat
		Local t:Int
		glTexImage2D GL_PROXY_TEXTURE_2D,0,4,width,height,0,GL_RGBA,GL_UNSIGNED_BYTE,Null
		glGetTexLevelParameteriv GL_PROXY_TEXTURE_2D,0,GL_TEXTURE_WIDTH,Varptr t
		If t Return
		If width=1 And height=1 RuntimeError "Unable to calculate tex size"
		If width>1 width:/2
		If height>1 height:/2
	Forever
End Function

Function Pow2Size:Int( n:Int )
	Local t:Int=1
	While t<n
		t:*2
	Wend
	Return t
End Function