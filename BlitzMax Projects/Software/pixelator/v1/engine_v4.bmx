SuperStrict
Import "clipboard_1.bmx"

'################### EME GUI OBJECTS ######################
Type EG_OBJECT
	Global active_object:EG_OBJECT
	
	Field name:String
	
	Field parent:EG_OBJECT
	
	Field children:TList
	
	Method New()
		Self.children = New TList
		Self.name = "Object"
	End Method
	
	Field active:Int = 0'0 = off, 1 = transfer, 2 = activated
	
	Method render_relation:Int(ax:Int,ay:Int)
		Self.adapt_size()
		
		Self.abs_x = ax+Self.rel_x
		Self.abs_y = ay+Self.rel_y
		Self.active = 0
		
		Self.viewport[0] = Self.abs_x
		Self.viewport[1] = Self.abs_y
		Self.viewport[2] = Self.abs_x + Self.dx
		Self.viewport[3] = Self.abs_y + Self.dy
		
		If parent Then
			If Self.viewport[0] < parent.viewport[0] Then Self.viewport[0] = parent.viewport[0]
			If Self.viewport[1] < parent.viewport[1] Then Self.viewport[1] = parent.viewport[1]
			If Self.viewport[2] > parent.viewport[2] Then Self.viewport[2] = parent.viewport[2]
			If Self.viewport[3] > parent.viewport[3] Then Self.viewport[3] = parent.viewport[3]
			
			If Self.viewport[0] > Self.viewport[2] Or Self.viewport[1] > Self.viewport[3] Then
				Self.viewport = [-1,-1,-1,-1]
			End If
		End If
		
		For Local c:EG_OBJECT = EachIn Self.children
			If c.render_relation(Self.abs_x, Self.abs_y) > 0 Then
				Self.active=1
			End If
		Next
		
		If Self = EG_OBJECT.active_object Then Self.active=2
		
		Return Self.active
	End Method
	
	Field clscolor:Int[] = COLORS.empty
	
	Field rel_x:Int'relative to parent
	Field rel_y:Int
	
	Field abs_x:Int'absolute to screen
	Field abs_y:Int
	
	Field dx:Int
	Field dy:Int
	
	'adapt
	Field adapt_size_x:Int=0'0=not, 1=adapt to parent, -1=adapt to children
	Field adapt_size_y:Int=0
	
	Method set_adapt(mode:Int)
		Select mode
			Case -1
				Self.adapt_size_x = -1
				Self.adapt_size_y = -1
			Case 0
				Self.adapt_size_x = 0
				Self.adapt_size_y = 0
			Case 1
				Self.adapt_size_x = 1
				Self.adapt_size_y = 1
			Default
				Self.adapt_size_x = 0
				Self.adapt_size_y = 0
		End Select
	End Method
	
	Method give_inside_dx:Int()
		Return Self.dx
	End Method
	
	Method give_inside_dy:Int()
		Return Self.dy
	End Method
	
	Method adapt_size()
		If Self.adapt_size_x = 1 Then'adapt to parent
			If parent Then
				Self.dx = Self.parent.give_inside_dx()
			End If
		ElseIf Self.adapt_size_x = -1 Then'adapt to children
			Self.dx = 10
			For Local c:EG_OBJECT = EachIn Self.children
				If c.adapt_size_x <> 1 And Self.dx < c.rel_x+c.dx Then Self.dx = c.rel_x+c.dx
			Next
		ElseIf Self.adapt_size_x = 0 Then'not adapt
		End If
		
		If Self.adapt_size_y = 1 Then'adapt to parent
			If parent Then
				Self.dy = Self.parent.give_inside_dy()
			End If
		ElseIf Self.adapt_size_y = -1 Then'adapt to children
			Self.dy = 10
			For Local c:EG_OBJECT = EachIn Self.children
				If c.adapt_size_y <> 1 And Self.dy < c.rel_y+c.dy Then Self.dy = c.rel_y+c.dy
			Next
		ElseIf Self.adapt_size_y = 0 Then'not adapt
		End If
	End Method
	'end adapt
	
	Field viewport:Int[4]'[x,y, x,y]
	
	Method setarea()
		SetViewport Self.viewport[0], Self.viewport[1], Self.viewport[2]-Self.viewport[0], Self.viewport[3]-Self.viewport[1]
	End Method
	
	Method render:TList(events:TList)'prototype
		events = Self.render_children(events)
		
		Return events
	End Method
	
	Field children_upsidedown:Int = 0
	
	Method render_children:TList(events:TList)
		Local first:EG_OBJECT
		
		Self.children.reverse()
		Self.children_upsidedown = 1
		For Local c:EG_OBJECT = EachIn Self.children
			events = c.render(events:TList)
			If c.active Then first = c
		Next
		Self.children.reverse()
		Self.children_upsidedown = 0
		
		If first And Self.children.contains(first) Then' must check wether contains, if killed !
			Self.children.remove(first)
			Self.children.addlast(first)
		End If
		
		Return events
	End Method
	
	Method draw()'prototype
		Self.setarea()
		
		EG_DRAW.clear(Self.clscolor[0], Self.clscolor[1], Self.clscolor[2],Self)
		
		For Local c:EG_OBJECT = EachIn Self.children
			c.draw()
		Next
	End Method
	
	Method add_child:EG_OBJECT(obj:EG_OBJECT)'gives parent
		
		If Self.children_upsidedown = 0 Then
			Self.children.addfirst(obj)
		Else
			Self.children.addlast(obj)
		End If
		
		obj.parent = Self
		Return Self
	End Method
	
	Method rem_child(obj:EG_OBJECT)
		If obj.active > 0 Then EG_OBJECT.active_object = Self
		Self.children.remove(obj)
	End Method
End Type

Rem
	buttons
	checkbox, radiobox - designs ?
	textfield - data-type, multiple lines ?
End Rem

Type EG_RADIO_PARENT
	Field list:EG_RADIO_CHILD[]
	Field child_activated:Int = 0
	
	Method get_activated:EG_RADIO_CHILD()
		If Self.list.length = 0 Then Return Null
		
		Return Self.list[Self.child_activated]
	End Method
	
	Method add:Int(c:EG_RADIO_CHILD)
		If Self.list.length = 0 Then
			Self.list = [c]
		Else
			Self.list:+ [c]
		End If
		
		c.radio_parent = Self
		
		Return Self.list.length-1
	End Method
End Type

'-------------------------------------------## RADIO_CHILD ##------------------------
Type EG_RADIO_CHILD Extends EG_OBJECT
	Method New()
		Self.children = New TList
		Self.name = "Radio_child"
		
		Self.clscolor = COLORS.area
		Self.tick_color = COLORS.tick
		Self.text_color = COLORS.area_text
	End Method
	
	Field tick_color:Int[]
	Field text_color:Int[]
	
	Field radio_parent:EG_RADIO_PARENT
	Field id_number:Int'number in radio_parent list
	
	Field status:Int = 0'0 = off, 1 = on
	Field text:String
	
	Global side:Int = 20
	
	Function Create_Radio_Child:EG_RADIO_CHILD(name:String,x:Int,y:Int,parent:EG_OBJECT,rp:EG_RADIO_PARENT,text:String = "")
		Local a:EG_RADIO_CHILD = New EG_RADIO_CHILD
		a.name = name
		
		a.rel_x = x
		a.rel_y = y
		a.dx = EG_RADIO_CHILD.side
		a.dy = EG_RADIO_CHILD.side
		
		a.text = text
		
		If a.text <> "" Then
			a.dx = EG_RADIO_CHILD.side + 10 + TextWidth(a.text)
		End If
		
		If parent Then a.parent = parent.add_child(a)
		
		a.id_number = rp.add(a)
		
		Return a
	End Function
	
	Method render:TList(events:TList)'prototype
		If Self.status = 0 Then
			For Local e:EG_MOUSE_OVER = EachIn events
				If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
					events.remove(e)
				End If
			Next
		End If
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Self.radio_parent.child_activated = Self.id_number
				EG_OBJECT.active_object = Self
			End If
		Next
		
		For Local e:EG_MOUSE_DRAG = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Self.radio_parent.child_activated = Self.id_number
				EG_MOUSE_DRAG.reset()
			End If
		Next
		
		Self.status = (Self.radio_parent.child_activated = Self.id_number)
		
		Return events
	End Method
	
	Method draw()'prototype
		Self.setarea()
		
		
		
		'no cls !
		
		
		
		If Self.text <> "" Then
			SetColor Self.clscolor[0]*0.6, Self.clscolor[1]*0.6, Self.clscolor[2]*0.6
			EG_DRAW.rect(0.5*EG_RADIO_CHILD.side,0,Self.dx,Self.dy,Self)
			
			SetColor Self.clscolor[0]*0.4, Self.clscolor[1]*0.4, Self.clscolor[2]*0.4
			EG_DRAW.rect(0.5*EG_RADIO_CHILD.side,0+2,Self.dx-0.5*EG_RADIO_CHILD.side-2,Self.dy-4,Self)
			
			SetColor Self.text_color[0],Self.text_color[1],Self.text_color[2]
			EG_DRAW.text(EG_RADIO_CHILD.side+5,0+2,Self.text,Self)
		End If
		
		
		SetColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
		EG_DRAW.oval(0,0,EG_RADIO_CHILD.side,EG_RADIO_CHILD.side,Self)
		
		SetColor Self.clscolor[0]*0.8, Self.clscolor[1]*0.8, Self.clscolor[2]*0.8
		EG_DRAW.oval(0+2,0+2,EG_RADIO_CHILD.side-4,EG_RADIO_CHILD.side-4,Self)
		
		If Self.status = 1 Then
			SetColor Self.tick_color[0],Self.tick_color[1],Self.tick_color[2]
			
			EG_DRAW.oval(0+4,0+4,EG_RADIO_CHILD.side-8,EG_RADIO_CHILD.side-8,Self)
		End If
		
	End Method
End Type


'-------------------------------------------## CHECK ##------------------------
Type EG_CHECK Extends EG_OBJECT
	Method New()
		Self.children = New TList
		Self.name = "Check"
		
		Self.clscolor = COLORS.area
		Self.tick_color = COLORS.tick
		Self.text_color = COLORS.area_text
	End Method
	
	Field tick_color:Int[]
	Field text_color:Int[]
	
	Field status:Int = 0'0 = off, 1 = on
	Field text:String
	
	Global side:Int = 20
	
	Function Create_Check:EG_CHECK(name:String,x:Int,y:Int,parent:EG_OBJECT,text:String = "")
		Local a:EG_CHECK = New EG_CHECK
		a.name = name
		
		a.rel_x = x
		a.rel_y = y
		a.dx = EG_CHECK.side
		a.dy = EG_CHECK.side
		
		a.text = text
		
		If a.text <> "" Then
			a.dx = EG_CHECK.side + 10 + TextWidth(a.text)
		End If
		
		If parent Then a.parent = parent.add_child(a)
		
		Return a
	End Function
	
	Method render:TList(events:TList)'prototype
		If Self.status = 0 Then
			For Local e:EG_MOUSE_OVER = EachIn events
				If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
					events.remove(e)
				End If
			Next
		End If
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Self.status = 1- Self.status
				EG_OBJECT.active_object = Self
			End If
		Next
		
		For Local e:EG_MOUSE_DRAG = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Self.status = 1- Self.status
				EG_MOUSE_DRAG.reset()
			End If
		Next
		
		Return events
	End Method
	
	Method draw()'prototype
		Self.setarea()
		
		SetClsColor Self.clscolor[0]*0.6, Self.clscolor[1]*0.6, Self.clscolor[2]*0.6
		Cls
		
		SetColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
		EG_DRAW.rect(0,0,EG_CHECK.side,EG_CHECK.side,Self)
		
		SetColor Self.clscolor[0]*0.8, Self.clscolor[1]*0.8, Self.clscolor[2]*0.8
		EG_DRAW.rect(0+2,0+2,EG_CHECK.side-4,EG_CHECK.side-4,Self)
		
		If Self.status = 1 Then
			SetColor Self.tick_color[0],Self.tick_color[1],Self.tick_color[2]
			
			EG_DRAW.rect(0+4,0+4,EG_CHECK.side-8,EG_CHECK.side-8,Self)
		End If
		
		
		If Self.text <> "" Then
			SetColor Self.clscolor[0]*0.4, Self.clscolor[1]*0.4, Self.clscolor[2]*0.4
			EG_DRAW.rect(EG_CHECK.side,0+2,Self.dx-EG_CHECK.side-2,Self.dy-4,Self)
			
			SetColor Self.text_color[0],Self.text_color[1],Self.text_color[2]
			EG_DRAW.text(EG_CHECK.side+5,0+2,Self.text,Self)
		End If
		
	End Method
End Type


'-------------------------------------------## CHOOSE_WIN ##------------------------
Type EG_CHOOSE_WIN Extends EG_OBJECT
	Method New()
		Self.children = New TList
		Self.name = "choose_win"
		
		Self.clscolor = COLORS.area
		
		Self.text_color = COLORS.area_text
		Self.mark_color = COLORS.mark
		Self.mark_text_color = COLORS.mark_text
	End Method
	
	Const line_height:Int = 20
	
	Field text_color:Int[]
	Field mark_color:Int[]
	Field mark_text_color:Int[]
	
	Field choose_area:EG_CHOOSE_AREA
	
	Function Create_Choose_Win:EG_CHOOSE_WIN(choose_area:EG_CHOOSE_AREA)
		Local a:EG_CHOOSE_WIN = New EG_CHOOSE_WIN
		a.name = choose_area.name + "_choose-win"
		
		a.choose_area = choose_area
		
		a.parent = EG_MASTER.screen'.add_child(a)
		a.parent.children.addfirst(a)
		
		a.dy = EG_CHOOSE_WIN.line_height*a.choose_area.choices.length
		
		
		a.dx = 100
		For Local i:Int = 0 To a.choose_area.choices.length-1
			Local ddx:Int = TextWidth(a.choose_area.choices[i])
			If a.dx < ddx Then a.dx = ddx
		Next
		
		a.rel_x = a.choose_area.abs_x
		If a.rel_x < 0 Then a.rel_x = 0
		If a.rel_x > a.parent.give_inside_dx()-a.dx Then a.rel_x = a.parent.give_inside_dx()-a.dx
		
		a.rel_y = a.choose_area.abs_y + a.choose_area.dy
		
		If a.rel_y + a.dy > a.parent.give_inside_dy() Then
			a.rel_y = a.choose_area.abs_y - a.dy
		End If
		
		EG_OBJECT.active_object = a
		Return a
	End Function
	
	Method destroy_me()
		Self.parent.rem_child(Self)
	End Method
	
	Method render:TList(events:TList)
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Self.choose_area.chosen = e.rel_y(Self)/EG_CHOOSE_WIN.line_height
				
				Self.destroy_me()
			Else
				Self.destroy_me()
			End If
		Next
		
		For Local e:EG_MOUSE_DRAG = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Self.choose_area.chosen = e.rel_y(Self)/EG_CHOOSE_WIN.line_height
				
				Self.destroy_me()
				EG_MOUSE_DRAG.reset()
			Else
				Self.destroy_me()
			End If
		Next
		
		For Local e:EG_MOUSE_2_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Self.destroy_me()
			Else
				Self.destroy_me()
			End If
		Next
		
		For Local e:EG_MOUSE_SCROLL = EachIn events
			'If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				
				Self.choose_area.chosen:-e.z
				If Self.choose_area.chosen<0 Then Self.choose_area.chosen=0
				If Self.choose_area.chosen>Self.choose_area.choices.length-1 Then Self.choose_area.chosen=Self.choose_area.choices.length-1
				
				events.remove(e)
			'End If
		Next
		
		For Local e:EG_ENTER = EachIn events
			Self.destroy_me()
			
			events.remove(e)
		Next
		
		For Local e:EG_LETTER = EachIn events
			Self.destroy_me()
			
			events.remove(e)
		Next
		
		
		
		For Local e:EG_KEY_RIGHT = EachIn events
			Self.choose_area.chosen:+1
			If Self.choose_area.chosen<0 Then Self.choose_area.chosen=0
			If Self.choose_area.chosen>Self.choose_area.choices.length-1 Then Self.choose_area.chosen=Self.choose_area.choices.length-1
			
			events.remove(e)
		Next
		
		For Local e:EG_KEY_LEFT = EachIn events
			Self.choose_area.chosen:-1
			If Self.choose_area.chosen<0 Then Self.choose_area.chosen=0
			If Self.choose_area.chosen>Self.choose_area.choices.length-1 Then Self.choose_area.chosen=Self.choose_area.choices.length-1
			
			events.remove(e)
		Next
		
		For Local e:EG_KEY_UP = EachIn events
			Self.choose_area.chosen:-1
			If Self.choose_area.chosen<0 Then Self.choose_area.chosen=0
			If Self.choose_area.chosen>Self.choose_area.choices.length-1 Then Self.choose_area.chosen=Self.choose_area.choices.length-1
			
			events.remove(e)
		Next
		
		For Local e:EG_KEY_DOWN = EachIn events
			Self.choose_area.chosen:+1
			If Self.choose_area.chosen<0 Then Self.choose_area.chosen=0
			If Self.choose_area.chosen>Self.choose_area.choices.length-1 Then Self.choose_area.chosen=Self.choose_area.choices.length-1
			
			events.remove(e)
		Next
		
		Return events
	End Method
	
	Method draw()'prototype
		Self.setarea()
		
		SetClsColor Self.clscolor[0]*0.7, Self.clscolor[1]*0.7, Self.clscolor[2]*0.7
		
		Cls
		
		SetColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
		EG_DRAW.rect(0+2,0+2,Self.dx-4,Self.dy-4,Self)
		
		
		For Local i:Int = 0 To Self.choose_area.choices.length-1
			
			If i = Self.choose_area.chosen Then
				SetColor Self.mark_color[0], Self.mark_color[1], Self.mark_color[2]
				EG_DRAW.rect(2,i*EG_CHOOSE_WIN.line_height+2,Self.dx-4,EG_CHOOSE_WIN.line_height-4,Self)
				
				SetColor Self.mark_text_color[0], Self.mark_text_color[1], Self.mark_text_color[2]
			Else
				SetColor Self.text_color[0], Self.text_color[1], Self.text_color[2]
			End If
			
			EG_DRAW.text(2,2+i*EG_CHOOSE_WIN.line_height,Self.choose_area.choices[i],Self)
		Next
		
	End Method
	
End Type

'-------------------------------------------## CHOOSE_AREA ##------------------------
Type EG_CHOOSE_AREA Extends EG_OBJECT
	Method New()
		Self.children = New TList
		Self.name = "choose_area"
		
		Self.clscolor = COLORS.area
		
		Self.text_color = COLORS.area_text
	End Method
	
	
	Const height:Int = 20
	
	Field text_color:Int[]
	
	Field choices:String[]
	Field chosen:Int
	
	Method get_choice:Int()
		Return Self.chosen-1
	End Method
	
	Method set_choice(i:Int)
		Self.chosen = i+1
	End Method
	
	Method set_choice_text(txt:String)
		For Local i:Int = 0 To Self.choices.length - 1
			If txt = Self.choices[i] Then Self.chosen = i
		Next
	End Method
	
	Method get_choice_text:String()
		Return Self.choices[Self.chosen]
	End Method
	
	Function Create_Choose_Area:EG_CHOOSE_AREA(name:String,x:Int,y:Int,dx:Int,title:String,choices:String[],chosen:Int=-1,parent:EG_OBJECT)
		Local a:EG_CHOOSE_AREA = New EG_CHOOSE_AREA
		a.name = name
		
		a.rel_x = x
		a.rel_y = y
		a.dx = dx
		a.dy = EG_CHOOSE_AREA.height
		
		a.choices = [title] + choices
		a.chosen = chosen+1
		
		If parent Then a.parent = parent.add_child(a)
		
		Return a
	End Function
	
	Method reset_choices(choices:String[])
		Self.choices = [Self.choices[0]] + choices
		If Self.chosen > Self.choices.length - 1 Then Self.chosen = Self.choices.length - 1
	End Method
	
	Method render:TList(events:TList)
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				EG_CHOOSE_WIN.Create_Choose_Win(Self)
			End If
		Next
		
		For Local e:EG_MOUSE_DRAG = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				EG_CHOOSE_WIN.Create_Choose_Win(Self)
				
				EG_MOUSE_DRAG.reset()
			End If
		Next
		
		Rem
		For Local e:EG_MOUSE_SCROLL = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				
				
				Self.chosen:-e.z
				If Self.chosen<0 Then Self.chosen=0
				If Self.chosen>Self.choices.length-1 Then Self.chosen=Self.choices.length-1
				
				events.remove(e)
			End If
		Next
		End Rem
		
		Return events
	End Method
	
	Method draw()'prototype
		Self.setarea()
		
		SetClsColor Self.clscolor[0]*0.7, Self.clscolor[1]*0.7, Self.clscolor[2]*0.7
		
		Cls
		
		SetColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
		EG_DRAW.rect(0+2,0+2,Self.dx-4,Self.dy-4,Self)
		
		SetColor Self.text_color[0], Self.text_color[1], Self.text_color[2]
		EG_DRAW.text(2,2,Self.choices[Self.chosen],Self)
		
	End Method
	
End Type


'-------------------------------------------## FILE_AREA ##------------------------
Type EG_FILE_AREA Extends EG_OBJECT
	Method New()
		Self.children = New TList
		Self.name = "file_area"
		Self.clscolor = COLORS.area
		
		Self.e_load_color = COLORS.orange
		Self.e_save_color = COLORS.dark_blue
		
		Self.ok_color = COLORS.dark_green
		Self.overwrite_color = COLORS.dark_red
		Self.notexist_color = COLORS.dark_red
	End Method
	
	Field save:Int
	Field title:String
	Field extensions:String
	Field dir:String
	
	Field filename:String
	
	Const height:Int = 20
	
	Field e_load_color:Int[]
	Field e_save_color:Int[]
	
	Field ok_color:Int[]
	Field overwrite_color:Int[]
	Field notexist_color:Int[]
	
	Function Create_File_Area:EG_FILE_AREA(name:String,x:Int,y:Int,dx:Int,save:Int,title:String,extensions:String,dir:String,parent:EG_OBJECT)
		Local a:EG_FILE_AREA = New EG_FILE_AREA
		a.name = name
		
		a.rel_x = x
		a.rel_y = y
		a.dx = dx
		a.dy = EG_FILE_AREA.height
		
		a.save = save
		a.title = title
		a.extensions = extensions
		a.dir = dir
		
		If parent Then a.parent = parent.add_child(a)
		
		Return a
	End Function
	
	Method request()
		Local txt:String = RequestFile(Self.title,"File (" + Self.extensions + "):" + Self.extensions,Self.save,Self.dir)
		If txt <> "" Then Self.filename = txt
	End Method
	
	Method render:TList(events:TList)
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Self.request()
				
				EG_OBJECT.active_object = Self
			End If
		Next
		
		For Local e:EG_MOUSE_DRAG = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Self.request()
				
				EG_MOUSE_DRAG.reset()
			End If
		Next
		
		Return events
	End Method
	
	Method draw()'prototype
		Self.setarea()
		
		SetClsColor Self.clscolor[0]*0.7, Self.clscolor[1]*0.7, Self.clscolor[2]*0.7
		
		Cls
		
		SetColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
		EG_DRAW.rect(0+2,0+2,Self.dx-4,Self.dy-4,Self)
		
		
		If Self.save Then
			If FileType(Self.filename) Then
				SetColor Self.overwrite_color[0], Self.overwrite_color[1], Self.overwrite_color[2]
			Else
				SetColor Self.ok_color[0], Self.ok_color[1], Self.ok_color[2]
			End If
		Else
			If FileType(Self.filename) Then
				SetColor Self.ok_color[0], Self.ok_color[1], Self.ok_color[2]
			Else
				SetColor Self.notexist_color[0], Self.notexist_color[1], Self.notexist_color[2]
			End If
		End If
		
		Local txt:String = StripExt(Self.filename)
		
		EG_DRAW.text(Self.dx-TextWidth("."+Self.extensions)-4-TextWidth(txt),2,txt,Self)
		
		If Self.save Then
			SetColor Self.e_save_color[0], Self.e_save_color[1], Self.e_save_color[2]
		Else
			SetColor Self.e_load_color[0], Self.e_load_color[1], Self.e_load_color[2]
		End If
		
		EG_DRAW.text(Self.dx-TextWidth("."+Self.extensions)-4,2,"."+Self.extensions,Self)
		
	End Method
	
End Type

'-------------------------------------------## STRING_AREA ##------------------------
Type EG_STRING_AREA Extends EG_OBJECT
	Method New()
		Self.children = New TList
		Self.name = "string_area"
		
		Self.clscolor = COLORS.area
		Self.select_color = COLORS.mark
		Self.select_text_color = COLORS.mark_text
		Self.text_color = COLORS.area_text
	End Method
	
	Field select_color:Int[]
	Field select_text_color:Int[]
	Field text_color:Int[]
	
	Field text:String
	Field marked:Int[]=[1,3]'currsor and marking at the same time
	Field first_marked:Int
	
	Const height:Int = 20
	
	Field shift:Int = 0
	
	Function Create_String_Area:EG_STRING_AREA(name:String,x:Int,y:Int,dx:Int,parent:EG_OBJECT,text:String = "")
		Local a:EG_STRING_AREA = New EG_STRING_AREA
		a.name = name
		
		a.rel_x = x
		a.rel_y = y
		a.dx = dx
		a.dy = EG_STRING_AREA.height
		
		a.text = text
		
		If parent Then a.parent = parent.add_child(a)
		
		Return a
	End Function
	
	Method render:TList(events:TList)'prototype
		If TextWidth(Self.text)>Self.dx-4 Then
			Self.shift = Self.dx-4-TextWidth(Self.text)
		Else
			Self.shift = 0
		End If
		
		If Self.marked[0]<0 Then Self.marked[0]=0
		If Self.marked[1]<0 Then Self.marked[1]=0
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Local i:Int = Self.get_pos(e.x)
				Self.marked = [i,i]
				
				If EG_OBJECT.active_object <> Self Then
					Self.marked = [0,Len(Self.text)]
				End If
				
				EG_OBJECT.active_object = Self
			End If
		Next
			
		For Local d:EG_MOUSE_DRAG = EachIn events
			If EG_MOUSE_DRAG.eg_obj=Self Or (EG_MOUSE_DRAG.eg_obj=Null And EG_CALC.inside(Self.viewport,[d.x,d.y])) Then
				EG_MOUSE_DRAG.eg_obj=Self
				
				events.remove(d)
				
				If d.first Then
					Local i:Int = Self.get_pos(d.x)
					Self.marked = [i,i]
					
					Self.first_marked = i
					
				Else
					Local i:Int = Self.get_pos(d.x)
					
					If i > Self.first_marked Then
						Self.marked = [Self.first_marked, i]
					Else
						Self.marked = [i, Self.first_marked]
					End If
					
				End If
				
				d.drag(d.x_drag,d.y_drag)
				
				
				If EG_OBJECT.active_object <> Self Then
					Self.marked = [0,Len(Self.text)]
					EG_MOUSE_DRAG.reset()
				End If
				
				EG_OBJECT.active_object = Self
			End If
		Next
		
		If EG_OBJECT.active_object = Self Then
			For Local e:EG_BACKSPACE = EachIn events
				If Self.marked[0] = Self.marked[1] And Self.marked[1]>0 Then
					Self.text = Mid(Self.text,0,Self.marked[0])+Mid(Self.text,Self.marked[0]+1,-1)
					Self.marked = [Self.marked[0]-1,Self.marked[0]-1]
				Else
					Self.text = Mid(Self.text,0,Self.marked[0]+1)+Mid(Self.text,Self.marked[1]+1,-1)
					
					Self.marked = [Self.marked[0],Self.marked[0]]
				End If
				
				events.remove(e)
			Next
			
			For Local e:EG_DELETE = EachIn events
				If Self.marked[0] = Self.marked[1] Then
					Self.text = Mid(Self.text,0,Self.marked[0]+1)+Mid(Self.text,Self.marked[0]+2,-1)
					Self.marked = [Self.marked[0],Self.marked[0]]
				Else
					Self.text = Mid(Self.text,0,Self.marked[0]+1)+Mid(Self.text,Self.marked[1]+1,-1)
					
					Self.marked = [Self.marked[0],Self.marked[0]]
				End If
				
				events.remove(e)
			Next
			
			For Local e:EG_ENTER = EachIn events
				EG_OBJECT.active_object = Self.parent
				
				events.remove(e)
			Next
			
			
			For Local e:EG_SELECT_ALL = EachIn events
				Self.marked[0] = 0
				Self.marked[1] = Len(Self.text)
				
				events.remove(e)
			Next
			
			
			For Local e:EG_COPY = EachIn events
				Local txt:String
				
				If Self.marked[0]=Self.marked[1] Then
					txt = ""
				Else
					txt = Mid(Self.text,Self.marked[0]+1,Self.marked[1]-Self.marked[0])
					TextToClipboard(txt)
				End If
				
				events.remove(e)
			Next
			
			
			For Local e:EG_CUT = EachIn events
				Local txt:String
				
				If Self.marked[0]=Self.marked[1] Then
					txt = ""
				Else
					txt = Mid(Self.text,Self.marked[0]+1,Self.marked[1]-Self.marked[0])
					TextToClipboard(txt)
				End If
				
				'delete
				Self.text = Mid(Self.text,0,Self.marked[0]+1)+Mid(Self.text,Self.marked[1]+1,-1)
					
				Self.marked = [Self.marked[0],Self.marked[0]]
				
				events.remove(e)
			Next
			
			
			For Local e:EG_PASTE = EachIn events
				Local txt:String = TextFromClipboard()
				
				'Chr(13)+ Chr(10)
				
				While Instr(txt,Chr(13)+ Chr(10))
					
					Local pos:Int = Instr(txt,Chr(13)+ Chr(10))
					txt = Mid(txt,0,pos)+Mid(txt,pos+2,-1)
				Wend
				
				If txt<>"" Then
					
					If Self.marked[0] = Self.marked[1] Then
						Self.text = Mid(Self.text,0,Self.marked[0]+1)+txt+Mid(Self.text,Self.marked[0]+1,-1)
						Self.marked = [Self.marked[0]+Len(txt),Self.marked[0]+Len(txt)]
					Else
						Self.text = Mid(Self.text,0,Self.marked[0]+1)+txt+Mid(Self.text,Self.marked[1]+1,-1)
						
						Self.marked = [Self.marked[0]+Len(txt),Self.marked[0]+Len(txt)]
					End If
				End If
				
				events.remove(e)
			Next
			
			
			For Local e:EG_LETTER = EachIn events
				If Self.marked[0] = Self.marked[1] Then
					Self.text = Mid(Self.text,0,Self.marked[0]+1)+e.letter+Mid(Self.text,Self.marked[0]+1,-1)
					Self.marked = [Self.marked[0]+Len(e.letter),Self.marked[0]+Len(e.letter)]
				Else
					Self.text = Mid(Self.text,0,Self.marked[0]+1)+e.letter+Mid(Self.text,Self.marked[1]+1,-1)
					
					Self.marked = [Self.marked[0]+Len(e.letter),Self.marked[0]+Len(e.letter)]
				End If
				
				events.remove(e)
			Next
			
			For Local e:EG_KEY_RIGHT = EachIn events
				If Self.marked[0] = Self.marked[1] Then
					Self.marked = [Self.marked[0]+1,Self.marked[0]+1]
					
				Else
					Self.marked = [Self.marked[1],Self.marked[1]]
				End If
				
				events.remove(e)
			Next
			
			For Local e:EG_KEY_LEFT = EachIn events
				If Self.marked[0] = Self.marked[1] Then
					
					Self.marked = [Self.marked[0]-1,Self.marked[0]-1]
				Else
					
					Self.marked = [Self.marked[0],Self.marked[0]]
				End If
				
				events.remove(e)
			Next
			
			If Self.marked[0]<0 Then Self.marked[0]=0
			If Self.marked[1]<0 Then Self.marked[1]=0
			
			If Self.marked[0]>Len(Self.text) Then Self.marked[0]=Len(Self.text)
			If Self.marked[1]>Len(Self.text) Then Self.marked[1]=Len(Self.text)
			
		End If
		
		If EG_OBJECT.active_object <> Self Then Self.marked=[0,0]
		
		Return events
	End Method
	
	Method get_pos:Int(ex:Int)
		Local xx:Int = 0
		
		For Local i:Int = 0 To Len(Self.text)+1
			
			If (ex-Self.abs_x-Self.shift) <= xx + 0.5*TextWidth(Mid(Self.text,i,1)) Then
				'Self.marked = [i-1,i-1]
				Return i-1
			End If
			
			xx:+TextWidth(Mid(Self.text,i,1))
		Next
		
		Return Len(Self.text)
	End Method
	
	Method draw()'prototype
		Self.setarea()
		
		SetClsColor Self.clscolor[0]*0.6, Self.clscolor[1]*0.6, Self.clscolor[2]*0.6
		
		Cls
		
		SetColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
		EG_DRAW.rect(2,2,Self.dx-4,Self.dy-4,Self)
		
		
		
		Local xx:Int = Self.shift
		
		For Local i:Int = 0 To Len(Self.text)
			If i>Self.marked[0] And i<=Self.marked[1] Then
				SetColor Self.select_color[0], Self.select_color[1], Self.select_color[2]
				EG_DRAW.rect(2+xx,2,TextWidth(Mid(Self.text,i,1)),TextHeight(Self.text),Self)
				SetColor Self.select_text_color[0], Self.select_text_color[1], Self.select_text_color[2]
			Else
				If EG_OBJECT.active_object = Self Then
					SetColor Self.text_color[0], Self.text_color[1], Self.text_color[2]
				Else
					SetColor (Self.text_color[0]+Self.clscolor[0])/2, (Self.text_color[1]+Self.clscolor[1])/2, (Self.text_color[2]+Self.clscolor[2])/2
				End If
			End If
			
			EG_DRAW.text(2+xx,2,Mid(Self.text,i,1),Self)
			xx:+TextWidth(Mid(Self.text,i,1))
			
			If EG_OBJECT.active_object = Self And Self.marked[0] = Self.marked[1] And Self.marked[0]=i Then'draw currsor
				If (MilliSecs() Mod 500) > 250 Then EG_DRAW.rect(2+xx,2,1,TextHeight(Self.text),Self)
			End If
		Next
		
	End Method
End Type


'-------------------------------------------## TEXT_AREA ##------------------------
Type EG_TEXT_AREA Extends EG_OBJECT
	Method New()
		Self.children = New TList
		Self.name = "text_area"
		
		Self.clscolor = COLORS.area
		Self.select_color = COLORS.mark
		Self.select_text_color = COLORS.mark_text
		Self.text_color = COLORS.area_text
	End Method
	
	Field select_color:Int[]
	Field select_text_color:Int[]
	Field text_color:Int[]
	
	
	Field lines:String[]
	Field marked_line:Int[]=[0,1]
	Field marked:Int[]=[3,3]'currsor and marking at the same time
	
	Field first_marked_x:Int
	Field first_marked_y:Int
	
	Const line_height:Int = 20
	
	Field last_currsor:Int
	Const max_currsor:Int = 500
	
	Function Create_Text_Area:EG_TEXT_AREA(name:String,x:Int,y:Int,dx:Int,dy:Int,parent:EG_OBJECT, lines:String[])
		Local a:EG_TEXT_AREA = New EG_TEXT_AREA
		a.name = name
		
		a.rel_x = x
		a.rel_y = y
		a.dx = dx
		a.dy = dy
		
		a.lines = lines
		a.change_size()
		
		If parent Then a.parent = parent.add_child(a)
		
		Return a
	End Function
	
	Method change_size()'Time Consuming
		Self.dy = EG_TEXT_AREA.line_height*Self.lines.length
		
		Self.dx = 0
		For Local i:Int = 0 To Self.lines.length-1
			If Self.dx < TextWidth(Self.lines[i]) Then Self.dx = TextWidth(Self.lines[i])
		Next
		Self.dx:+5
	End Method
	
	
	Method render:TList(events:TList)'prototype
		
		'Self.change_size()'Time Consuming
		
		If Self.lines.length = 0 Then
			Self.lines = [""]
			Print
		End If
		
		If Self.marked_line[0] < 0 Then Self.marked_line[0] = 0
		If Self.marked_line[1] < 0 Then Self.marked_line[1] = 0
		
		If Self.marked_line[0] > Self.lines.length-1 Then Self.marked_line[0] = Self.lines.length-1
		If Self.marked_line[1] > Self.lines.length-1 Then Self.marked_line[1] = Self.lines.length-1
		
		If Self.marked[0]<0 Then Self.marked[0]=0
		If Self.marked[1]<0 Then Self.marked[1]=0
		
		If Self.marked[0]>Len(Self.lines[Self.marked_line[0]]) Then Self.marked[0]=Len(Self.lines[Self.marked_line[0]])
		If Self.marked[1]>Len(Self.lines[Self.marked_line[1]]) Then Self.marked[1]=Len(Self.lines[Self.marked_line[1]])
		
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Local il:Int = Self.get_pos_y(e.x,e.y)
				Local i:Int = Self.get_pos_x(e.x,e.y)
				
				Self.marked_line = [il,il]
				Self.marked = [i,i]
				
				Self.last_currsor = MilliSecs()'reset currsor !
				
				Rem
				If EG_OBJECT.active_object <> Self Then
					Self.marked_line = [0,Self.lines.length]
					
					Self.marked = [0,Len(Self.lines[Self.lines.length-1])]
				End If
				End Rem
				
				EG_OBJECT.active_object = Self
			End If
		Next
		
		
		For Local d:EG_MOUSE_DRAG = EachIn events
			If EG_MOUSE_DRAG.eg_obj=Self Or (EG_MOUSE_DRAG.eg_obj=Null And EG_CALC.inside(Self.viewport,[d.x,d.y])) Then
				EG_MOUSE_DRAG.eg_obj=Self
				
				events.remove(d)
				
				If d.first Then
					Self.first_marked_x = Self.get_pos_x(d.x,d.y)
					Self.first_marked_y = Self.get_pos_y(d.x,d.y)
					
					Self.marked = [Self.first_marked_x,Self.first_marked_x]
					Self.marked_line = [Self.first_marked_y,Self.first_marked_y]
				Else
					Local il:Int= Self.get_pos_y(d.x,d.y)
					Local i:Int = Self.get_pos_x(d.x,d.y)
					
					If il > Self.first_marked_y Or (il = Self.first_marked_y And i > Self.first_marked_x) Then
						Self.marked = [Self.first_marked_x, i]
						Self.marked_line = [Self.first_marked_y, il]
					Else
						Self.marked = [i, Self.first_marked_x]
						Self.marked_line = [il, Self.first_marked_y]
					End If
					
				End If
				
				Self.last_currsor = MilliSecs()'reset currsor !
				
				d.drag(d.x_drag,d.y_drag)
				
				Rem
				If EG_OBJECT.active_object <> Self Then
					Self.marked_line = [0,Self.lines.length]
					
					Self.marked = [0,Len(Self.lines[Self.lines.length-1])]
					
					EG_MOUSE_DRAG.reset()
				End If
				End Rem
				
				EG_OBJECT.active_object = Self
			End If
		Next
		
		
		If EG_OBJECT.active_object = Self Then
			For Local e:EG_BACKSPACE = EachIn events
				Self.last_currsor = MilliSecs()'reset currsor !
				
				If Self.marked_line[0] = Self.marked_line[1] Then
					If Self.marked[0] = Self.marked[1] Then
						If Self.marked[0]=0 Then
							If Self.marked_line[0]>0 Then
								'beginning of line
								Local txt:String = Self.lines[Self.marked_line[0]-1]+Self.lines[Self.marked_line[0]]
								
								Local nx:Int = Len(Self.lines[Self.marked_line[0]-1])
								Local ny:Int = Self.marked_line[0]-1
								
								Self.lines = Self.lines[..Self.marked_line[0]-1] + [txt] + Self.lines[Self.marked_line[0]+1..]
								
								Self.marked = [nx,nx]
								
								Self.marked_line = [ny,ny]
							Else
								'beginning of document - nothing
							End If
						Else
							'delete one
							Local txt:String = Self.lines[Self.marked_line[0]]
							Self.lines[Self.marked_line[0]] = Mid(txt,0,Self.marked[0])+Mid(txt,Self.marked[0]+1,-1)
							
							Self.marked = [Self.marked[0]-1,Self.marked[0]-1]
						End If
					Else
						'sale line
						Local txt:String = Self.lines[Self.marked_line[0]]
						Self.lines[Self.marked_line[0]] = Mid(txt,0,Self.marked[0]+1)+Mid(txt,Self.marked[1]+1,-1)
						
						Self.marked = [Self.marked[0],Self.marked[0]]
					End If
				Else
					'ceveral lines
					Local txt:String = Mid(Self.lines[Self.marked_line[0]],1,Self.marked[0]) + Mid(Self.lines[Self.marked_line[1]],Self.marked[1]+1,-1)
					
					Self.lines = Self.lines[..Self.marked_line[0]] + [txt] + Self.lines[Self.marked_line[1]+1..]
					
					Self.marked = [Self.marked[0],Self.marked[0]]
					
					Self.marked_line = [Self.marked_line[0],Self.marked_line[0]]
				End If
				
				Self.change_size()'Time Consuming
				events.remove(e)
			Next
			
			
			For Local e:EG_DELETE = EachIn events
				Self.last_currsor = MilliSecs()'reset currsor !
				
				If Self.marked_line[0] = Self.marked_line[1] Then
					If Self.marked[0] = Self.marked[1] Then
						If Self.marked[0]=Len(Self.lines[Self.marked_line[0]]) Then
							If Self.marked_line[0]<Self.lines.length-1 Then
								'end of line
								Local txt:String = Self.lines[Self.marked_line[0]]+Self.lines[Self.marked_line[0]+1]
								
								Self.lines = Self.lines[..Self.marked_line[0]] + [txt] + Self.lines[Self.marked_line[0]+2..]
								
							Else
								'end of document - nothing
							End If
						Else
							'delete one
							Local txt:String = Self.lines[Self.marked_line[0]]
							Self.lines[Self.marked_line[0]] = Mid(txt,0,Self.marked[0]+1)+Mid(txt,Self.marked[0]+2,-1)
							
						End If
					Else
						'same line
						Local txt:String = Self.lines[Self.marked_line[0]]
						Self.lines[Self.marked_line[0]] = Mid(txt,0,Self.marked[0]+1)+Mid(txt,Self.marked[1]+1,-1)
						
						Self.marked = [Self.marked[0],Self.marked[0]]
					End If
				Else
					'ceveral lines
					Local txt:String = Mid(Self.lines[Self.marked_line[0]],1,Self.marked[0]) + Mid(Self.lines[Self.marked_line[1]],Self.marked[1]+1,-1)
					
					Self.lines = Self.lines[..Self.marked_line[0]] + [txt] + Self.lines[Self.marked_line[1]+1..]
					
					Self.marked = [Self.marked[0],Self.marked[0]]
					
					Self.marked_line = [Self.marked_line[0],Self.marked_line[0]]
				End If
				
				Self.change_size()'Time Consuming
				events.remove(e)
			Next
			
			
			For Local e:EG_ENTER = EachIn events
				
				Self.last_currsor = MilliSecs()'reset currsor !
				
				'ceveral lines
				Local txt1:String = Mid(Self.lines[Self.marked_line[0]],1,Self.marked[0])
				Local txt2:String = Mid(Self.lines[Self.marked_line[1]],Self.marked[1]+1,-1)
				
				
				Self.lines = Self.lines[..Self.marked_line[0]] + [txt1] + [txt2] + Self.lines[Self.marked_line[1]+1..]
				
				Self.marked = [0,0]
				Self.marked_line = [Self.marked_line[0]+1,Self.marked_line[0]+1]
				
				Self.change_size()'Time Consuming
				events.remove(e)
			Next
			
			For Local e:EG_SELECT_ALL = EachIn events
				Self.marked = [0,Len(Self.lines[Self.lines.length-1])]
				Self.marked_line = [0,Self.lines.length-1]
				
				events.remove(e)
			Next
			
			For Local e:EG_COPY = EachIn events
				If Self.marked_line[0]=Self.marked_line[1] Then
					'one line
					If Self.marked[0]=Self.marked[1] Then
						'nothing
						TextToClipboard("")
					Else
						'string
						TextToClipboard(Mid(Self.lines[Self.marked_line[0]], Self.marked[0]+1,Self.marked[1]-Self.marked[0]))
					End If
				Else
					'multiple lines
					Local txt:String
					For Local i:Int = Self.marked_line[0] To Self.marked_line[1]
						
						If i = Self.marked_line[0] Then
							txt = Mid(Self.lines[Self.marked_line[0]],Self.marked[0]+1,-1)
						ElseIf i = Self.marked_line[1] Then
							txt:+ Chr(13)+ Chr(10) + Mid(Self.lines[Self.marked_line[1]],0,Self.marked[1]+1)
						Else
							txt:+ Chr(13)+ Chr(10) + Self.lines[i]
						End If
					Next
					
					TextToClipboard(txt)
				End If
				
				events.remove(e)
			Next
			
			For Local e:EG_CUT = EachIn events
				If Self.marked_line[0]=Self.marked_line[1] Then
					'one line
					If Self.marked[0]=Self.marked[1] Then
						'nothing
						TextToClipboard("")
					Else
						'string
						TextToClipboard(Mid(Self.lines[Self.marked_line[0]], Self.marked[0]+1,Self.marked[1]-Self.marked[0]))
					End If
				Else
					'multiple lines
					Local txt:String
					For Local i:Int = Self.marked_line[0] To Self.marked_line[1]
						
						If i = Self.marked_line[0] Then
							txt = Mid(Self.lines[Self.marked_line[0]],Self.marked[0]+1,-1)
						ElseIf i = Self.marked_line[1] Then
							txt:+ Chr(13)+ Chr(10) + Mid(Self.lines[Self.marked_line[1]],0,Self.marked[1]+1)
						Else
							txt:+ Chr(13)+ Chr(10) + Self.lines[Self.marked_line[1]]
						End If
					Next
					
					TextToClipboard(txt)
				End If
				
				'delete
				
				If Self.marked_line[0] = Self.marked_line[1] Then
					If Self.marked[0] = Self.marked[1] Then
						'nothing
					Else
						'same line
						Local txt:String = Self.lines[Self.marked_line[0]]
						Self.lines[Self.marked_line[0]] = Mid(txt,0,Self.marked[0]+1)+Mid(txt,Self.marked[1]+1,-1)
						
						Self.marked = [Self.marked[0],Self.marked[0]]
					End If
				Else
					'ceveral lines
					Local txt:String = Mid(Self.lines[Self.marked_line[0]],1,Self.marked[0]) + Mid(Self.lines[Self.marked_line[1]],Self.marked[1]+1,-1)
					
					Self.lines = Self.lines[..Self.marked_line[0]] + [txt] + Self.lines[Self.marked_line[1]+1..]
					
					Self.marked = [Self.marked[0],Self.marked[0]]
					
					Self.marked_line = [Self.marked_line[0],Self.marked_line[0]]
				End If
				
				Self.change_size()'Time Consuming
				events.remove(e)
			Next
			
			
			For Local e:EG_PASTE = EachIn events
				
				'delete
				
				If Self.marked_line[0] = Self.marked_line[1] Then
					If Self.marked[0] = Self.marked[1] Then
						'nothing
					Else
						'same line
						Local txt:String = Self.lines[Self.marked_line[0]]
						Self.lines[Self.marked_line[0]] = Mid(txt,0,Self.marked[0]+1)+Mid(txt,Self.marked[1]+1,-1)
						
						Self.marked = [Self.marked[0],Self.marked[0]]
					End If
				Else
					'ceveral lines
					Local txt:String = Mid(Self.lines[Self.marked_line[0]],1,Self.marked[0]) + Mid(Self.lines[Self.marked_line[1]],Self.marked[1]+1,-1)
					
					Self.lines = Self.lines[..Self.marked_line[0]] + [txt] + Self.lines[Self.marked_line[1]+1..]
					
					Self.marked = [Self.marked[0],Self.marked[0]]
					
					Self.marked_line = [Self.marked_line[0],Self.marked_line[0]]
				End If
				
				
				Local txt:String = TextFromClipboard()
				
				Local l:String[]
				
				'Local i:Int = 0
				While Instr(txt,Chr(13)+ Chr(10))
					'i:+1
					Local pos:Int = Instr(txt,Chr(13)+ Chr(10))
					'txt = Mid(txt,0,pos-1)+Mid(txt,pos+1,-1)
					
					l:+ [Mid(txt,0,pos)]
					
					
					txt = Mid(txt,pos+2,-1)'rest
				Wend
				
				l:+ [txt]
				
				For Local i:Int = 0 To l.length-1
					txt = l[i]
					If i=0 Then
						Self.lines[Self.marked_line[0]] = Mid(Self.lines[Self.marked_line[0]],0,Self.marked[0]+1) + txt + Mid(Self.lines[Self.marked_line[0]],Self.marked[1]+1,-1)
						Self.marked = [Self.marked[0]+Len(txt),Self.marked[0]+Len(txt)]
					Else
						'next line
						
						Local t1:String = Mid(Self.lines[Self.marked_line[0]],0,Self.marked[0]+1)
						Local t2:String = Mid(Self.lines[Self.marked_line[0]],Self.marked[1]+1,-1)
						
						Self.lines = Self.lines[..Self.marked_line[0]] + [t1] + [t2] + Self.lines[Self.marked_line[1]+1..]
						
						Self.marked = [0,0]
						Self.marked_line = [Self.marked_line[0]+1,Self.marked_line[0]+1]
						
						'add text
						Self.lines[Self.marked_line[0]] = txt + Mid(Self.lines[Self.marked_line[0]],Self.marked[1]+1,-1)
						Self.marked = [Self.marked[0]+Len(txt),Self.marked[0]+Len(txt)]
					End If
				Next
				
				Self.change_size()'Time Consuming
				events.remove(e)
			Next
			
			For Local e:EG_LETTER = EachIn events
				
				Self.last_currsor = MilliSecs()'reset currsor !
				
				Local txt:String = Mid(Self.lines[Self.marked_line[0]],1,Self.marked[0]) + e.letter + Mid(Self.lines[Self.marked_line[1]],Self.marked[1]+1,-1)
				
				Self.lines = Self.lines[..Self.marked_line[0]] + [txt] + Self.lines[Self.marked_line[1]+1..]
				
				Self.marked = [Self.marked[0]+Len(e.letter),Self.marked[0]+Len(e.letter)]
				Self.marked_line = [Self.marked_line[0],Self.marked_line[0]]
				
				Self.change_size()'Time Consuming
				events.remove(e)
			Next
			
			
			For Local e:EG_KEY_RIGHT = EachIn events
				
				Self.last_currsor = MilliSecs()'reset currsor !
				
				If Self.marked[0] = Self.marked[1] And Self.marked_line[0] = Self.marked_line[1] Then
					If Self.marked[0]=Len(Self.lines[Self.marked_line[0]]) And Self.marked_line[0]<Self.lines.length-1 Then
						Self.marked = [0,0]
						Self.marked_line = [Self.marked_line[1]+1,Self.marked_line[1]+1]
					Else
						Self.marked = [Self.marked[0]+1,Self.marked[0]+1]
					End If
				Else
					Self.marked = [Self.marked[1],Self.marked[1]]
					Self.marked_line = [Self.marked_line[1],Self.marked_line[1]]
				End If
				
				events.remove(e)
			Next
			
			For Local e:EG_KEY_LEFT = EachIn events
				
				Self.last_currsor = MilliSecs()'reset currsor !
				
				If Self.marked[0] = Self.marked[1] And Self.marked_line[0] = Self.marked_line[1] Then
					If Self.marked[0]=0 Then
						If Self.marked_line[1]-1>=0 Then
							Self.marked = [Len(Self.lines[Self.marked_line[0]-1]),Len(Self.lines[Self.marked_line[0]-1])]
							Self.marked_line = [Self.marked_line[1]-1,Self.marked_line[1]-1]
						End If
					Else
						Self.marked = [Self.marked[0]-1,Self.marked[0]-1]
					End If
				Else
					Self.marked = [Self.marked[0],Self.marked[0]]
					Self.marked_line = [Self.marked_line[0],Self.marked_line[0]]
				End If
				
				events.remove(e)
			Next
			
			For Local e:EG_KEY_DOWN = EachIn events
				Self.last_currsor = MilliSecs()'reset currsor !
				
				Self.marked_line = [Self.marked_line[1]+1,Self.marked_line[1]+1]
				
				events.remove(e)
			Next
			
			For Local e:EG_KEY_UP = EachIn events
				Self.last_currsor = MilliSecs()'reset currsor !
				
				Self.marked_line = [Self.marked_line[0]-1,Self.marked_line[0]-1]
				
				events.remove(e)
			Next
			
			If Self.marked_line[0] < 0 Then Self.marked_line[0] = 0
			If Self.marked_line[1] < 0 Then Self.marked_line[1] = 0
			
			If Self.marked_line[0] > Self.lines.length-1 Then Self.marked_line[0] = Self.lines.length-1
			If Self.marked_line[1] > Self.lines.length-1 Then Self.marked_line[1] = Self.lines.length-1
			
			If Self.marked[0]<0 Then Self.marked[0]=0
			If Self.marked[1]<0 Then Self.marked[1]=0
			
			If Self.marked[0]>Len(Self.lines[Self.marked_line[0]]) Then Self.marked[0]=Len(Self.lines[Self.marked_line[0]])
			If Self.marked[1]>Len(Self.lines[Self.marked_line[1]]) Then Self.marked[1]=Len(Self.lines[Self.marked_line[1]])
			
		End If
		
		Return events
	End Method
	
	Method get_pos_y:Int(ex:Int,ey:Int)
		Local il:Int = (ey-Self.abs_y)/EG_TEXT_AREA.line_height
		If il > Self.lines.length-1 Then il = Self.lines.length-1
		Return il
	End Method
	
	Method get_pos_x:Int(ex:Int,ey:Int)
		Local il:Int = (ey-Self.abs_y)/EG_TEXT_AREA.line_height
		If il > Self.lines.length-1 Then il = Self.lines.length-1
		If il < 0 Then il = 0
		
		
		Local xx:Int = 0
		Local txt:String = Self.lines[il]
		
		For Local i:Int = 0 To Len(txt)+1
			
			If (ex-Self.abs_x) <= xx + 0.5*TextWidth(Mid(txt,i,1)) Then
				'Self.marked = [i-1,i-1]
				Return i-1
			End If
			
			xx:+TextWidth(Mid(txt,i,1))
		Next
		
		Return Len(txt)
	End Method
	
	
	
	Method draw()
		
		
		Self.setarea()
		
		SetClsColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
		
		Cls
		
		Local l_start:Int = 0
		Local l_end:Int = Self.lines.length-1
		
		Local offset_1:Int = (Self.viewport[1]-Self.abs_y)/EG_TEXT_AREA.line_height
		If offset_1>l_start Then l_start = offset_1
		
		
		Local offset_2:Int = (Self.viewport[3]-Self.viewport[1])/EG_TEXT_AREA.line_height + offset_1
		If offset_2<l_end Then l_end = offset_2
		
		
		For Local il:Int = l_start To l_end
			Local xx:Int = 0
			Local yy:Int = EG_TEXT_AREA.line_height*il
			
			Local txt:String = Self.lines[il]
			
			Local marking:Int = 0
			'0 no mark
			'1 start and stop
			'2 start
			'3 on
			'4 stop
			
			If il=marked_line[0] And il=marked_line[1] Then
				If Self.marked[0]=Self.marked[1]
					marking = 0
				Else
					marking = 1
				End If
			ElseIf il=marked_line[0]
				marking = 2
			ElseIf il=marked_line[1]
				marking = 4
			ElseIf il>marked_line[0] And il<marked_line[1]
				marking = 3
			End If
			
			Select marking
				Case 0
					If EG_OBJECT.active_object = Self Then
						SetColor Self.text_color[0], Self.text_color[1], Self.text_color[2]
					Else
						SetColor (Self.text_color[0]+Self.clscolor[0])/2, (Self.text_color[1]+Self.clscolor[1])/2, (Self.text_color[2]+Self.clscolor[2])/2
					End If
					
					EG_DRAW.text(xx,yy,txt,Self)
				Case 1
					Local txt1:String = Mid(txt,0,Self.marked[0]+1)
					Local txt2:String = Mid(txt,Self.marked[0]+1,Self.marked[1]-Self.marked[0])
					Local txt3:String = Mid(txt,Self.marked[1]+1,-1)
					
					
					
					If EG_OBJECT.active_object = Self Then
						SetColor Self.text_color[0], Self.text_color[1], Self.text_color[2]
					Else
						SetColor (Self.text_color[0]+Self.clscolor[0])/2, (Self.text_color[1]+Self.clscolor[1])/2, (Self.text_color[2]+Self.clscolor[2])/2
					End If
					EG_DRAW.text(xx,yy,txt1,Self)
					
					xx:+TextWidth(txt1)
					
					SetColor Self.select_color[0], Self.select_color[1], Self.select_color[2]
					EG_DRAW.rect(xx,yy,TextWidth(txt2),EG_TEXT_AREA.line_height,Self)
					SetColor Self.select_text_color[0], Self.select_text_color[1], Self.select_text_color[2]
					EG_DRAW.text(xx,yy,txt2,Self)
					
					xx:+TextWidth(txt2)
					
					If EG_OBJECT.active_object = Self Then
						SetColor Self.text_color[0], Self.text_color[1], Self.text_color[2]
					Else
						SetColor (Self.text_color[0]+Self.clscolor[0])/2, (Self.text_color[1]+Self.clscolor[1])/2, (Self.text_color[2]+Self.clscolor[2])/2
					End If
					EG_DRAW.text(xx,yy,txt3,Self)
					
					'Print txt1
					'Print txt2
					'Print txt3
				Case 2
					Local txt1:String = Mid(txt,0,Self.marked[0]+1)
					Local txt2:String = Mid(txt,Self.marked[0]+1,-1)
					
					
					
					If EG_OBJECT.active_object = Self Then
						SetColor Self.text_color[0], Self.text_color[1], Self.text_color[2]
					Else
						SetColor (Self.text_color[0]+Self.clscolor[0])/2, (Self.text_color[1]+Self.clscolor[1])/2, (Self.text_color[2]+Self.clscolor[2])/2
					End If
					EG_DRAW.text(xx,yy,txt1,Self)
					
					xx:+TextWidth(txt1)
					
					SetColor Self.select_color[0], Self.select_color[1], Self.select_color[2]
					EG_DRAW.rect(xx,yy,TextWidth(txt2),EG_TEXT_AREA.line_height,Self)
					SetColor Self.select_text_color[0], Self.select_text_color[1], Self.select_text_color[2]
					EG_DRAW.text(xx,yy,txt2,Self)
					
				Case 4
					Local txt1:String = Mid(txt,0,Self.marked[1]+1)
					Local txt2:String = Mid(txt,Self.marked[1]+1,-1)
					
					SetColor Self.select_color[0], Self.select_color[1], Self.select_color[2]
					EG_DRAW.rect(xx,yy,TextWidth(txt1),EG_TEXT_AREA.line_height,Self)
					SetColor Self.select_text_color[0], Self.select_text_color[1], Self.select_text_color[2]
					EG_DRAW.text(xx,yy,txt1,Self)
					
					xx:+TextWidth(txt1)
					
					If EG_OBJECT.active_object = Self Then
						SetColor Self.text_color[0], Self.text_color[1], Self.text_color[2]
					Else
						SetColor (Self.text_color[0]+Self.clscolor[0])/2, (Self.text_color[1]+Self.clscolor[1])/2, (Self.text_color[2]+Self.clscolor[2])/2
					End If
					EG_DRAW.text(xx,yy,txt2,Self)
				Case 3
					SetColor Self.select_color[0], Self.select_color[1], Self.select_color[2]
					EG_DRAW.rect(xx,yy,TextWidth(txt),EG_TEXT_AREA.line_height,Self)
					SetColor Self.select_text_color[0], Self.select_text_color[1], Self.select_text_color[2]
					EG_DRAW.text(xx,yy,txt,Self)
			End Select
			
			
			'currsor
			
			If EG_OBJECT.active_object = Self And Self.marked_line[0] = Self.marked_line[1] And Self.marked[0] = Self.marked[1] Then
				If MilliSecs()-Self.last_currsor>Self.max_currsor Then
					Self.last_currsor = MilliSecs()'reset currsor !
				End If
				
				If MilliSecs()-Self.last_currsor < Self.max_currsor*0.5 Then
					Local xx:Int = TextWidth(Mid(Self.lines[Self.marked_line[0]],0,Self.marked[0]+1))
					Local yy:Int = Self.marked_line[0]*EG_TEXT_AREA.line_height
					
					EG_DRAW.rect(xx,yy,1,TextHeight(txt),Self)
				End If
			End If
		Next
		
		
	End Method
End Type

'-------------------------------------------## BUTTON ##------------------------
Type EG_BUTTON Extends EG_OBJECT
	Method New()
		Self.children = New TList
		Self.name = "Button"
		
		Self.clscolor = COLORS.area
		Self.txt_color = COLORS.area_text
	End Method
	
	Field txt_color:Int[] = [0,0,0]
	
	Field status:Int = 0'0 = off, 1 = mouse_over, 2 = clicked
	
	Field mouse_info:EG_MOUSE_INFO
	
	Function Create_Button:EG_BUTTON(name:String,x:Int,y:Int,dx:Int,dy:Int,parent:EG_OBJECT)
		Local a:EG_BUTTON = New EG_BUTTON
		a.name = name
		
		a.rel_x = x
		a.rel_y = y
		a.dx = dx
		a.dy = dy
		
		If parent Then a.parent = parent.add_child(a)
		
		Return a
	End Function
	
	Method render:TList(events:TList)'prototype
		If Self.status = 1 Then Self.status = 0
		
		If Self.status = 0 Then
			For Local e:EG_MOUSE_OVER = EachIn events
				If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
					events.remove(e)
					
					If Self.mouse_info Then Self.mouse_info.set()
					
					Self.status = 1
				End If
			Next
		End If
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Self.status = 2
				EG_OBJECT.active_object = Self
			End If
		Next
		
		For Local e:EG_MOUSE_DRAG = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Self.status = 2
				EG_MOUSE_DRAG.reset()
			End If
		Next
		
		Return events
	End Method
	
	Method draw()'prototype
		Self.setarea()
		
		Select Self.status
			Case 0
				SetClsColor Self.clscolor[0]*0.8, Self.clscolor[1]*0.8, Self.clscolor[2]*0.8
			Case 1
				SetClsColor Self.clscolor[0]*0.6, Self.clscolor[1]*0.6, Self.clscolor[2]*0.6
			Case 2
				SetClsColor Self.clscolor[0]*0.8, Self.clscolor[1]*0.8, Self.clscolor[2]*0.8
		End Select
		
		Cls
		
		Select Self.status
			Case 0
				SetColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
			Case 1
				SetColor Self.clscolor[0]*0.9, Self.clscolor[1]*0.9, Self.clscolor[2]*0.9
			Case 2
				SetColor Self.clscolor[0]*0.4, Self.clscolor[1]*0.4, Self.clscolor[2]*0.4
		End Select
		
		EG_DRAW.rect(0+2,0+2,Self.dx-4,Self.dy-4,Self)
		
		SetColor Self.txt_color[0],Self.txt_color[1],Self.txt_color[2]
		
		EG_DRAW.text(2,2,Self.name,Self)
	End Method
End Type

'-------------------------------------------## BUTTON_IMAGE ##------------------------
Type EG_BUTTON_IMAGE Extends EG_OBJECT
	Method New()
		Self.children = New TList
		Self.name = "Button_IMAGE"
		
		Self.clscolor = COLORS.area
	End Method
	
	Field image:TImage
	
	Field status:Int = 0'0 = off, 1 = mouse_over, 2 = clicked
	
	Field mouse_info:EG_MOUSE_INFO
	
	Function Create_Button:EG_BUTTON_IMAGE(image:TImage,x:Int,y:Int,parent:EG_OBJECT)
		Local a:EG_BUTTON_IMAGE = New EG_BUTTON_IMAGE
		a.image = image
		
		a.rel_x = x
		a.rel_y = y
		a.dx = image.width+4
		a.dy = image.height+4
		
		If parent Then a.parent = parent.add_child(a)
		
		Return a
	End Function
	
	Method render:TList(events:TList)'prototype
		If Self.status = 1 Then Self.status = 0
		
		If Self.status = 0 Then
			For Local e:EG_MOUSE_OVER = EachIn events
				If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
					events.remove(e)
					
					
					If Self.mouse_info Then Self.mouse_info.set()
					
					
					Self.status = 1
				End If
			Next
		End If
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Self.status = 2
				EG_OBJECT.active_object = Self
			End If
		Next
		
		For Local e:EG_MOUSE_DRAG = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Self.status = 2
				EG_MOUSE_DRAG.reset()
			End If
		Next
		
		Return events
	End Method
	
	Method draw()'prototype
		Self.setarea()
		
		Select Self.status
			Case 0
				SetClsColor Self.clscolor[0]*0.8, Self.clscolor[1]*0.8, Self.clscolor[2]*0.8
			Case 1
				SetClsColor Self.clscolor[0]*0.6, Self.clscolor[1]*0.6, Self.clscolor[2]*0.6
			Case 2
				SetClsColor Self.clscolor[0]*0.8, Self.clscolor[1]*0.8, Self.clscolor[2]*0.8
		End Select
		
		Cls
		
		Select Self.status
			Case 0
				SetColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
			Case 1
				SetColor Self.clscolor[0]*0.9, Self.clscolor[1]*0.9, Self.clscolor[2]*0.9
			Case 2
				SetColor Self.clscolor[0]*0.4, Self.clscolor[1]*0.4, Self.clscolor[2]*0.4
		End Select
		
		EG_DRAW.rect(0+2,0+2,Self.dx-4,Self.dy-4,Self)
		
		SetColor 255,255,255
		
		EG_DRAW.image(2,2,Self.image,0,Self)
	End Method
End Type

'-------------------------------------------## AREA ##------------------------
Type EG_AREA Extends EG_OBJECT
	Method New()
		Self.children = New TList
		Self.name = "Area"
	End Method
	
	Function Create_Area:EG_AREA(name:String,x:Int,y:Int,dx:Int,dy:Int,parent:EG_OBJECT)
		Local a:EG_AREA = New EG_AREA
		a.name = name
		
		a.rel_x = x
		a.rel_y = y
		a.dx = dx
		a.dy = dy
		
		If parent Then a.parent = parent.add_child(a)
		
		Return a
	End Function
	
	Rem
	Method resize(x:Int,y:Int,mode:Int=0)
		' resize children as well !
	End Method
	End Rem
	
	
	Method render:TList(events:TList)'prototype
		events = Super.render(events)
		
		For Local e:EG_MOUSE_OVER = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				'mouse over me !
			End If
		Next
		
		Return events
	End Method
	
	'EG_MOUSE_OVER
	Method draw()'prototype
		Self.setarea()
		
		EG_DRAW.clear(Self.clscolor[0], Self.clscolor[1], Self.clscolor[2],Self)
		
		Self.user_draw()
		
		For Local c:EG_OBJECT = EachIn Self.children
			c.draw()
		Next
	End Method
	
	Method user_draw()
	End Method
End Type

'-------------------------------------------## SEPARATOR_X ##------------------------
Type EG_SEPARATOR_X Extends EG_AREA
	Method New()
		Self.children = New TList
		Self.name = "separator_x"
		
		Self.clscolor = COLORS.separator
	End Method
	
	Global bar_width:Int = 10
	
	Field sep_factor:Float = 0.5
	Global min_distance:Float = 20
	
	'Field a1:EG_AREA
	Field a1_s:EG_AREA'EG_SCROLL_AREA
	
	'Field a2:EG_AREA
	Field a2_s:EG_AREA'EG_SCROLL_AREA
	
	Method add_child:EG_OBJECT(obj:EG_OBJECT)'gives parent
		If Self.a1_s = Null Or Self.a2_s = Null Then
			
			obj.set_adapt(0)
			obj.parent = Self
			Return Self
			
		ElseIf EG_SCROLL_AREA(Self.a1_s) And EG_SCROLL_AREA(Self.a1_s).shifting_area = Null Then
			
			Return Self.a1_s.add_child(obj)
		ElseIf EG_SCROLL_AREA(Self.a2_s) And EG_SCROLL_AREA(Self.a2_s).shifting_area = Null Then
			
			Return Self.a2_s.add_child(obj)
		End If
		
		'EG_SCROLL_AREA
	End Method
	
	Method set_apartment_1(a1_s:EG_AREA)
		a1_s.parent = Self
		Self.a1_s = a1_s
		Self.a1_s.set_adapt(0)
	End Method
	
	Method set_apartment_2(a2_s:EG_AREA)
		a2_s.parent = Self
		Self.a2_s = a2_s
		
		Self.a2_s.set_adapt(0)
	End Method
	
	Method render_relation:Int(ax:Int,ay:Int)
		Self.adapt_size()
		
		Self.abs_x = ax+Self.rel_x
		Self.abs_y = ay+Self.rel_y
		Self.active = 0
		
		Self.viewport[0] = Self.abs_x
		Self.viewport[1] = Self.abs_y
		Self.viewport[2] = Self.abs_x + Self.dx
		Self.viewport[3] = Self.abs_y + Self.dy
		
		If parent Then
			If Self.viewport[0] < parent.viewport[0] Then Self.viewport[0] = parent.viewport[0]
			If Self.viewport[1] < parent.viewport[1] Then Self.viewport[1] = parent.viewport[1]
			If Self.viewport[2] > parent.viewport[2] Then Self.viewport[2] = parent.viewport[2]
			If Self.viewport[3] > parent.viewport[3] Then Self.viewport[3] = parent.viewport[3]
			
			If Self.viewport[0] > Self.viewport[2] Or Self.viewport[1] > Self.viewport[3] Then
				Self.viewport = [-1,-1,-1,-1]
			End If
		End If
		
		If Self.a1_s.render_relation(Self.abs_x, Self.abs_y) Then Self.active=1
		If Self.a2_s.render_relation(Self.abs_x, Self.abs_y) Then Self.active=1
		
		If Self = EG_OBJECT.active_object Then Self.active=2
		
		Return Self.active
	End Method
	
	Function Create_SEPARATOR_X:EG_SEPARATOR_X(name:String,x:Int,y:Int,dx:Int,dy:Int,parent:EG_OBJECT,a1:EG_AREA=Null,a2:EG_AREA=Null)
		Local a:EG_SEPARATOR_X = New EG_SEPARATOR_X
		a.name = name
		
		a.rel_x = x
		a.rel_y = y
		a.dx = dx
		a.dy = dy
		
		a.a1_s = EG_SCROLL_AREA.Create_SCROLL_AREA(a.name + "_a1_s",0,0,100,100,a)
		'a.a1_s.set_adapt(0)
		
		a.a2_s = EG_SCROLL_AREA.Create_SCROLL_AREA(a.name + "_a2_s",110,0,100,100,a)
		'a.a2_s.set_adapt(0)
		
		If a1 Then a.add_child(a1)
		If a2 Then a.add_child(a2)
		
		If parent Then a.parent = parent.add_child(a)
		
		Return a
	End Function
	
	Method render:TList(events:TList)
		events = Self.a1_s.render(events)
		events = Self.a2_s.render(events)
		
		For Local e:EG_MOUSE_OVER = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				'mouse over me !
			End If
		Next
		
		For Local e:EG_MOUSE_2_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
			End If
		Next
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
			End If
		Next
		
		For Local d:EG_MOUSE_DRAG = EachIn events
			If EG_MOUSE_DRAG.eg_obj=Self Or (EG_MOUSE_DRAG.eg_obj=Null And EG_CALC.inside(Self.viewport,[d.x,d.y])) Then
				EG_MOUSE_DRAG.eg_obj=Self
				
				events.remove(d)
				
				EG_OBJECT.active_object = Self
				
				Local distance:Float = Self.sep_factor*Self.dx
				
				Local drag_x:Int = d.x_drag' ---------- X DRAG
				
				If distance + d.x_drag > Self.dx-Self.bar_width*0.5-Self.min_distance Then
					drag_x = (Self.dx-Self.bar_width*0.5-Self.min_distance) - distance
				End If
				
				If distance+d.x_drag < Self.bar_width*0.5+Self.min_distance Then
					drag_x = Self.bar_width*0.5+Self.min_distance - distance
				End If
				
				distance:+drag_x
				
				Self.sep_factor = distance/Self.dx
				
				d.drag(drag_x,0)
				
			End If
		Next
		
		Self.a1_s.rel_x = 0
		Self.a1_s.rel_y = 0
		
		Self.a1_s.dx = Self.dx*Self.sep_factor - 0.5*Self.bar_width
		Self.a1_s.dy = Self.dy
		
		Self.a2_s.rel_x = Self.dx*Self.sep_factor + 0.5*Self.bar_width
		Self.a2_s.rel_y = 0
		
		Self.a2_s.dx = Self.dx*(1.0 - Self.sep_factor) - 0.5*Self.bar_width
		Self.a2_s.dy = Self.dy
		
		Return events
	End Method
	
	
	Method draw()
		Self.setarea()
		SetClsColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
		Cls
		
		SetColor Self.clscolor[0]*0.5, Self.clscolor[1]*0.5, Self.clscolor[2]*0.5
		EG_DRAW.rect(Self.dx*Self.sep_factor - 0.5*Self.bar_width+2,0,2,Self.dy,Self)
		EG_DRAW.rect(Self.dx*Self.sep_factor - 0.5*Self.bar_width+Self.bar_width-4,0,2,Self.dy,Self)
		
		Self.a1_s.draw()
		Self.a2_s.draw()
	End Method
End Type

'-------------------------------------------## SEPARATOR_Y ##------------------------
Type EG_SEPARATOR_Y Extends EG_AREA
	Method New()
		Self.children = New TList
		Self.name = "separator_y"
		
		Self.clscolor = COLORS.separator
	End Method
	
	Global bar_width:Int = 10
	
	Field sep_factor:Float = 0.5
	Global min_distance:Float = 20
	
	'Field a1:EG_AREA
	Field a1_s:EG_AREA'EG_SCROLL_AREA
	
	'Field a2:EG_AREA
	Field a2_s:EG_AREA'EG_SCROLL_AREA
	
	Method add_child:EG_OBJECT(obj:EG_OBJECT)'gives parent
		If Self.a1_s = Null Or Self.a2_s = Null Then
			
			obj.set_adapt(0)
			obj.parent = Self
			Return Self
			
		ElseIf EG_SCROLL_AREA(Self.a1_s) And EG_SCROLL_AREA(Self.a1_s).shifting_area = Null Then
			
			Return Self.a1_s.add_child(obj)
		ElseIf EG_SCROLL_AREA(Self.a2_s) And EG_SCROLL_AREA(Self.a2_s).shifting_area = Null Then
			
			Return Self.a2_s.add_child(obj)
		End If
		
		'EG_SCROLL_AREA
	End Method
	
	Method set_apartment_1(a1_s:EG_AREA)
		a1_s.parent = Self
		Self.a1_s = a1_s
		Self.a1_s.set_adapt(0)
	End Method
	
	Method set_apartment_2(a2_s:EG_AREA)
		a2_s.parent = Self
		Self.a2_s = a2_s
		
		Self.a2_s.set_adapt(0)
	End Method
	
	Method render_relation:Int(ax:Int,ay:Int)
		Self.adapt_size()
		
		Self.abs_x = ax+Self.rel_x
		Self.abs_y = ay+Self.rel_y
		Self.active = 0
		
		Self.viewport[0] = Self.abs_x
		Self.viewport[1] = Self.abs_y
		Self.viewport[2] = Self.abs_x + Self.dx
		Self.viewport[3] = Self.abs_y + Self.dy
		
		If parent Then
			If Self.viewport[0] < parent.viewport[0] Then Self.viewport[0] = parent.viewport[0]
			If Self.viewport[1] < parent.viewport[1] Then Self.viewport[1] = parent.viewport[1]
			If Self.viewport[2] > parent.viewport[2] Then Self.viewport[2] = parent.viewport[2]
			If Self.viewport[3] > parent.viewport[3] Then Self.viewport[3] = parent.viewport[3]
			
			If Self.viewport[0] > Self.viewport[2] Or Self.viewport[1] > Self.viewport[3] Then
				Self.viewport = [-1,-1,-1,-1]
			End If
		End If
		
		If Self.a1_s.render_relation(Self.abs_x, Self.abs_y) Then Self.active=1
		If Self.a2_s.render_relation(Self.abs_x, Self.abs_y) Then Self.active=1
		
		If Self = EG_OBJECT.active_object Then Self.active=2
		
		Return Self.active
	End Method
	
	Function Create_SEPARATOR_Y:EG_SEPARATOR_Y(name:String,x:Int,y:Int,dx:Int,dy:Int,parent:EG_OBJECT,a1:EG_AREA=Null,a2:EG_AREA=Null)
		Local a:EG_SEPARATOR_Y = New EG_SEPARATOR_Y
		a.name = name
		
		a.rel_x = x
		a.rel_y = y
		a.dx = dx
		a.dy = dy
		
		a.a1_s = EG_SCROLL_AREA.Create_SCROLL_AREA(a.name + "_a1_s",0,0,100,100,a)
		'a.a1_s.set_adapt(0)
		
		a.a2_s = EG_SCROLL_AREA.Create_SCROLL_AREA(a.name + "_a2_s",110,0,100,100,a)
		'a.a2_s.set_adapt(0)
		
		If a1 Then a.add_child(a1)
		If a2 Then a.add_child(a2)
		
		If parent Then a.parent = parent.add_child(a)
		
		Return a
	End Function
	
	Method render:TList(events:TList)
		events = Self.a1_s.render(events)
		events = Self.a2_s.render(events)
		
		For Local e:EG_MOUSE_OVER = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				'mouse over me !
			End If
		Next
		
		For Local e:EG_MOUSE_2_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
			End If
		Next
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
			End If
		Next
		
		For Local d:EG_MOUSE_DRAG = EachIn events
			If EG_MOUSE_DRAG.eg_obj=Self Or (EG_MOUSE_DRAG.eg_obj=Null And EG_CALC.inside(Self.viewport,[d.x,d.y])) Then
				EG_MOUSE_DRAG.eg_obj=Self
				
				events.remove(d)
				
				EG_OBJECT.active_object = Self
				
				Local distance:Float = Self.sep_factor*Self.dy
				
				Local drag_y:Int = d.y_drag' ---------- Y DRAG
				
				If distance + d.y_drag > Self.dy-Self.bar_width*0.5-Self.min_distance Then
					drag_y = (Self.dy-Self.bar_width*0.5-Self.min_distance) - distance
				End If
				
				If distance+d.y_drag < Self.bar_width*0.5+Self.min_distance Then
					drag_y = Self.bar_width*0.5+Self.min_distance - distance
				End If
				
				distance:+drag_y
				
				Self.sep_factor = distance/Self.dy
				
				d.drag(0,drag_y)
				
			End If
		Next
		
		Self.a1_s.rel_x = 0
		Self.a1_s.rel_y = 0
		
		Self.a1_s.dx = Self.dx
		Self.a1_s.dy = Self.dy*Self.sep_factor - 0.5*Self.bar_width
		
		Self.a2_s.rel_x = 0
		Self.a2_s.rel_y = Self.dy*Self.sep_factor + 0.5*Self.bar_width
		
		Self.a2_s.dx = Self.dx
		Self.a2_s.dy = Self.dy*(1.0 - Self.sep_factor) - 0.5*Self.bar_width
		
		Return events
	End Method
	
	
	Method draw()
		Self.setarea()
		SetClsColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
		Cls
		
		SetColor Self.clscolor[0]*0.5, Self.clscolor[1]*0.5, Self.clscolor[2]*0.5
		EG_DRAW.rect(0,Self.dy*Self.sep_factor - 0.5*Self.bar_width+2,Self.dx,2,Self)
		EG_DRAW.rect(0,Self.dy*Self.sep_factor - 0.5*Self.bar_width+Self.bar_width-4,Self.dx,2,Self)
		
		Self.a1_s.draw()
		Self.a2_s.draw()
	End Method
End Type

'-------------------------------------------## TAB_AREA ##------------------------
Type EG_TAB_AREA Extends EG_AREA
	Method New()
		Self.children = New TList
		Self.name = "tab_area"
		
		Self.clscolor = COLORS.tab
	End Method
	
	Global bar_height:Int = 20
	
	Field tabs:EG_OBJECT[]
	Field tab_active:Int = 0
	
	Method add_child:EG_OBJECT(obj:EG_OBJECT)'gives parent
		If Self.tabs.length = 0 Then
			Self.tabs = [obj]
		Else
			Self.tabs:+[obj]
		End If
		
		obj.rel_x = 0
		obj.rel_y = EG_TAB_AREA.bar_height
		'obj.dx = Self.dx
		'obj.dy = Self.dy-EG_TAB_AREA.bar_height
		
		obj.parent = Self
		Return Self
	End Method
	
	Method render_relation:Int(ax:Int,ay:Int)
		Self.adapt_size()
		
		Self.abs_x = ax+Self.rel_x
		Self.abs_y = ay+Self.rel_y
		Self.active = 0
		
		Self.viewport[0] = Self.abs_x
		Self.viewport[1] = Self.abs_y
		Self.viewport[2] = Self.abs_x + Self.dx
		Self.viewport[3] = Self.abs_y + Self.dy
		
		If parent Then
			If Self.viewport[0] < parent.viewport[0] Then Self.viewport[0] = parent.viewport[0]
			If Self.viewport[1] < parent.viewport[1] Then Self.viewport[1] = parent.viewport[1]
			If Self.viewport[2] > parent.viewport[2] Then Self.viewport[2] = parent.viewport[2]
			If Self.viewport[3] > parent.viewport[3] Then Self.viewport[3] = parent.viewport[3]
			
			If Self.viewport[0] > Self.viewport[2] Or Self.viewport[1] > Self.viewport[3] Then
				Self.viewport = [-1,-1,-1,-1]
			End If
		End If
		
		For Local i:Int = 0 To Self.tabs.length-1
			If Self.tabs[i].render_relation(Self.abs_x, Self.abs_y) > 0 Then
				Self.active=1
			End If
		Next
		
		If Self = EG_OBJECT.active_object Then Self.active=2
		
		Return Self.active
	End Method
	
	'adapt
	Method give_inside_dx:Int()
		Return Self.dx
	End Method
	
	Method give_inside_dy:Int()
		Return Self.dy-EG_TAB_AREA.bar_height
	End Method
	
	Method adapt_size()
		If Self.adapt_size_x = 1 Then'adapt to parent
			If parent Then
				Self.dx = Self.parent.give_inside_dx()
			End If
		ElseIf Self.adapt_size_x = -1 Then'adapt to children
			'Self.dx = 0
			'For Local c:EG_OBJECT = EachIn Self.tabs
			'	If Self.dx < c.rel_x+c.dx Then Self.dx = c.rel_x+c.dx
			'Next
			
			Self.dx = Self.tabs[Self.tab_active].rel_x+Self.tabs[Self.tab_active].dx
		ElseIf Self.adapt_size_x = 0 Then'not adapt
		End If
		
		If Self.adapt_size_y = 1 Then'adapt to parent
			If parent Then
				Self.dy = Self.parent.give_inside_dy()
			End If
		ElseIf Self.adapt_size_y = -1 Then'adapt to children
			'Self.dy = 0
			'For Local c:EG_OBJECT = EachIn Self.tabs
			'	If Self.dy < c.rel_y+c.dy Then Self.dy = c.rel_y+c.dy
			'Next
			
			Self.dy = Self.tabs[Self.tab_active].rel_y+Self.tabs[Self.tab_active].dy
		ElseIf Self.adapt_size_y = 0 Then'not adapt
		End If
	End Method
	'end adapt
	
	Function Create_TAB_AREA:EG_TAB_AREA(name:String,x:Int,y:Int,dx:Int,dy:Int,parent:EG_OBJECT)
		Local a:EG_TAB_AREA= New EG_TAB_AREA
		a.name = name
		
		a.rel_x = x
		a.rel_y = y
		a.dx = dx
		a.dy = dy
		
		If parent Then a.parent = parent.add_child(a)
		
		Return a
	End Function
	
	Method render:TList(events:TList)
		Self.tabs[Self.tab_active].render(events)
		
		For Local e:EG_MOUSE_OVER = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				'mouse over me !
			End If
		Next
		
		For Local e:EG_MOUSE_2_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
			End If
		Next
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				If e.y < Self.abs_y+EG_TAB_AREA.bar_height Then
					
					Self.tab_active = Floor(Self.tabs.length*(e.x-Self.abs_x)/Self.dx)
					
					EG_OBJECT.active_object = Self.tabs[Self.tab_active]
				End If
				
				'EG_OBJECT.active_object = Self
			End If
		Next
		
		For Local e:EG_MOUSE_DRAG = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				If e.y < Self.abs_y+EG_TAB_AREA.bar_height Then
					
					Self.tab_active = Floor(Self.tabs.length*(e.x-Self.abs_x)/Self.dx)
					EG_OBJECT.active_object = Self.tabs[Self.tab_active]
				End If
				
				EG_MOUSE_DRAG.reset()' maybe change afterwards
			End If
		Next
		
		Return events
	End Method
	
	
	Method draw()
		Self.setarea()
		SetClsColor Self.clscolor[0]*0.9, Self.clscolor[1]*0.9, Self.clscolor[2]*0.9
		Cls
		
		For Local i:Int = 0 To Self.tabs.length-1
			If i = Self.tab_active Then
				SetColor Self.clscolor[0]*0.7, Self.clscolor[1]*0.7, Self.clscolor[2]*0.7
			Else
				SetColor Self.clscolor[0]*0.5, Self.clscolor[1]*0.5, Self.clscolor[2]*0.5
			End If
			
			EG_DRAW.rect(i*Self.dx/Self.tabs.length,0,Self.dx/Self.tabs.length,EG_TAB_AREA.bar_height,Self)
			
			If i = Self.tab_active Then
				SetColor Self.clscolor[0]*0.4, Self.clscolor[1]*0.4, Self.clscolor[2]*0.4
			Else
				SetColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
			End If
			
			EG_DRAW.rect(i*Self.dx/Self.tabs.length+2,0+2,Self.dx/Self.tabs.length-4,EG_TAB_AREA.bar_height-4,Self)
			
			SetColor 0,0,0
			EG_DRAW.text(2+i*Self.dx/Self.tabs.length,2,Self.tabs[i].name,Self)
		Next
		
		Self.tabs[Self.tab_active].draw()
	End Method
End Type
'-------------------------------------------## SCROLL_AREA ##------------------------
Type EG_SCROLL_AREA Extends EG_AREA
	Method New()
		Self.children = New TList
		Self.name = "scroll_area"
		
		Self.clscolor = COLORS.area
	End Method
	
	Field draw_area:EG_AREA
	Field shifting_area:EG_OBJECT
	Field scroll_x:EG_SCROLL_X
	Field scroll_y:EG_SCROLL_Y
	
	Field draggable:Int=1
	
	Method add_child:EG_OBJECT(obj:EG_OBJECT)'gives parent
		
		If Not Self.draw_area Then
			Self.draw_area = EG_AREA(obj)
			
			Self.children.addlast(Self.draw_area)
			
			Self.draw_area.parent = Self
			Return Self
		ElseIf Not Self.scroll_x Then
			Self.scroll_x = EG_SCROLL_X(obj)
			
			Self.children.addlast(Self.scroll_x)
			
			Self.scroll_x.parent = Self
			Return Self
		ElseIf Not Self.scroll_y Then
			Self.scroll_y = EG_SCROLL_Y(obj)
			
			Self.children.addlast(Self.scroll_y)
			
			Self.scroll_y.parent = Self
			Return Self
		Else
			
			If Self.shifting_area Then Print "reset ?"
			Self.shifting_area = obj
			
			Return Self.draw_area.add_child(Self.shifting_area)
			
			'Self.shifting_area.parent = Self
			'Return Self
		End If
	End Method
	
	'adapt
	Method give_inside_dx:Int()
		Return Self.dx-EG_SCROLL_X.height
	End Method
	
	Method give_inside_dy:Int()
		Return Self.dy-EG_SCROLL_Y.width
	End Method
	
	Method adapt_size()
		If Self.adapt_size_x = 1 Then'adapt to parent
			If parent Then
				Self.dx = Self.parent.give_inside_dx()
			End If
		ElseIf Self.adapt_size_x = -1 Then'adapt to children
			Self.dx = Self.shifting_area.dx+EG_SCROLL_X.height
		ElseIf Self.adapt_size_x = 0 Then'not adapt
		End If
		
		If Self.adapt_size_y = 1 Then'adapt to parent
			If parent Then
				Self.dy = Self.parent.give_inside_dy()
			End If
		ElseIf Self.adapt_size_y = -1 Then'adapt to children
			Self.dy = Self.shifting_area.dy+EG_SCROLL_Y.width
		ElseIf Self.adapt_size_y = 0 Then'not adapt
		End If
	End Method
	'end adapt
	
	
	Function Create_SCROLL_AREA:EG_SCROLL_AREA(name:String,x:Int,y:Int,dx:Int,dy:Int,parent:EG_OBJECT,scroll_step_x:Int=0,scroll_step_y:Int=0)
		Local a:EG_SCROLL_AREA= New EG_SCROLL_AREA
		a.name = name
		
		a.rel_x = x
		a.rel_y = y
		a.dx = dx
		a.dy = dy
		
		If parent Then a.parent = parent.add_child(a)
		
		a.draw_area = EG_AREA.Create_Area(a.name + "_draw_area",0,0,a.dx-EG_SCROLL_X.height,a.dy-EG_SCROLL_Y.width,a)
		a.draw_area.clscolor = [200,200,200]
		
		'a.scroll_x = 
		EG_SCROLL_X.Create_SCROLL_X(a.name + "_scroll_x",0,a.dy-EG_SCROLL_Y.width,a.dx-EG_SCROLL_X.height,a,[0,0,0],scroll_step_x)'shifting_area.dx-a.draw_area.dx])
		'a.scroll_y = 
		EG_SCROLL_Y.Create_SCROLL_Y(a.name + "_scroll_y",a.dx-EG_SCROLL_X.height,0,a.dy-EG_SCROLL_Y.width,a,[0,0,0],scroll_step_y)'shifting_area.dy-a.draw_area.dy])
		
		
		
		'a.shifting_area = shifting_area
		'a.draw_area.add_child(a.shifting_area)
		
		Return a
	End Function
	
	Method update_from_to()
		Self.draw_area.dx = Self.dx-EG_SCROLL_X.height
		Self.draw_area.dy = Self.dy-EG_SCROLL_Y.width
		
		Self.scroll_x.rel_y = Self.dy-EG_SCROLL_Y.width
		Self.scroll_x.dx = Self.dx-EG_SCROLL_X.height
		
		Self.scroll_y.rel_x = Self.dx-EG_SCROLL_X.height
		Self.scroll_y.dy = Self.dy-EG_SCROLL_Y.width
		
		Self.scroll_x.update_from_to([0,0,Self.shifting_area.dx-Self.draw_area.dx])
		Self.scroll_y.update_from_to([0,0,Self.shifting_area.dy-Self.draw_area.dy])
		
	End Method
	
	Method render:TList(events:TList)'prototype
		
		Self.update_from_to()
		
		For Local d:EG_MOUSE_DRAG = EachIn events
			If EG_MOUSE_DRAG.eg_obj=Self Or (EG_MOUSE_DRAG.eg_obj=Null And d.rel_x(Self)>Self.dx-EG_SCROLL_Y.width And d.rel_y(Self)>Self.dy-EG_SCROLL_X.height And EG_CALC.inside(Self.viewport,[d.x,d.y])) Then
				
				EG_MOUSE_DRAG.eg_obj=Self
				EG_OBJECT.active_object = Self
				
				events.remove(d)
				
				Local drag_x:Int = d.x_drag' ---------- X DRAG
				
				If drag_x<10-Self.dx Then
					drag_x=10-Self.dx
				End If
				
				If Self.adapt_size_x=1 Or draggable=0 Then
					drag_x=0
				End If
				
				Self.dx:+drag_x
				d.drag(drag_x,0)
				
				Local drag_y:Int = d.y_drag' ---------- Y DRAG
				
				If drag_y<10-Self.dy Then
					drag_y=10-Self.dy
				End If
				
				If Self.adapt_size_y=1 Or draggable=0 Then
					drag_y=0
				End If
				
				Self.dy:+drag_y
				d.drag(0,drag_y)
			End If
		Next
		
		events = Super.render(events)
		
		For Local e:EG_MOUSE_OVER = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				'mouse over me !
			End If
		Next
		
		For Local e:EG_MOUSE_SCROLL_SIDE = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				Self.scroll_x.scroll(e.z)
				
				events.remove(e)
			End If
		Next
		
		For Local e:EG_MOUSE_SCROLL = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				Self.scroll_y.scroll(e.z)
				
				events.remove(e)
			End If
		Next
		
		Self.shifting_area.rel_x = -Self.scroll_x.value
		Self.shifting_area.rel_y = -Self.scroll_y.value
		
		Return events
	End Method
End Type

'-------------------------------------------## SCROLL_X ##------------------------
Type EG_SCROLL_X Extends EG_AREA
	Method New()
		Self.children = New TList
		Self.name = "scroll_x"
		
		Self.clscolor = COLORS.scroll
	End Method
	
	Const height:Int = 15
	Const glider_side:Int = 20
	
	Field value_from:Float
	Field value:Float
	Field value_to:Float
	
	
	Function Create_SCROLL_X:EG_SCROLL_X(name:String,x:Int,y:Int,dx:Int,parent:EG_OBJECT,values:Int[],scroll_step_x:Float=0)
		Local a:EG_SCROLL_X = New EG_SCROLL_X
		a.name = name
		
		a.rel_x = x
		a.rel_y = y
		a.dx = dx
		a.dy = EG_SCROLL_X.height
		
		a.scroll_step_x = scroll_step_x
		If a.scroll_step_x > 0 Then a.scroll_typ=1
		
		If parent Then a.parent = parent.add_child(a)
		
		If Not values.length < 3 Then
			a.value_from = values[0]
			a.value = values[1]
			a.value_to = values[2]
		End If
		
		Return a
	End Function
	
	
	Method update_from_to(values:Int[])
		
		If Not values.length < 3 Then
			Self.value_from = values[0]
			Self.value_to = values[2]
			
			If Self.value > Self.value_to Then Self.value = Self.value_to
			If Self.value < Self.value_from Then Self.value = Self.value_from
		End If
	End Method
	
	Method render:TList(events:TList)'prototype
		' no children !
		
		
		For Local e:EG_MOUSE_OVER = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				'mouse over me !
			End If
		Next
		
		For Local d:EG_MOUSE_DRAG = EachIn events
			If EG_MOUSE_DRAG.eg_obj=Self Or (EG_MOUSE_DRAG.eg_obj=Null And EG_CALC.inside(Self.viewport,[d.x,d.y])) Then
				EG_MOUSE_DRAG.eg_obj=Self
				
				events.remove(d)
				
				EG_OBJECT.active_object = Self
				
				Local distance:Float = (Self.dx-Self.glider_side)*(Self.value-Self.value_from)/(Self.value_to-Self.value_from)
				
				If Self.value_to <= Self.value_from Then
					distance = 0
				End If
				
				Local drag_x:Int = d.x_drag' ---------- X DRAG
				
				If distance+d.x_drag > (Self.dx-Self.glider_side) Then
					drag_x = (Self.dx-Self.glider_side) - distance
				End If
				
				If distance+d.x_drag < 0 Then
					drag_x = 0 - distance
				End If
				
				distance:+drag_x
				
				Self.value = Self.value_from+(Self.value_to-Self.value_from)*distance/(Self.dx-Self.glider_side)
				
				d.drag(drag_x,0)
				
			End If
		Next
		
		
		For Local e:EG_MOUSE_SCROLL = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				
				Self.scroll(e.z)
				
				Rem
				Self.value:+e.z*(Self.value_to-Self.value_from)*0.05
				If Self.value > Self.value_to Then Self.value = Self.value_to
				If Self.value < Self.value_from Then Self.value = Self.value_from
				End Rem
				
				events.remove(e)
			End If
		Next
		
		Return events
	End Method
	
	Method scroll_percent(amount:Int)
		Self.value:-amount*(Self.value_to-Self.value_from)*0.05
		If Self.value > Self.value_to Then Self.value = Self.value_to
		If Self.value < Self.value_from Then Self.value = Self.value_from
	End Method
	
	Method scroll_abs(amount:Int)
		Self.value:-amount
		If Self.value > Self.value_to Then Self.value = Self.value_to
		If Self.value < Self.value_from Then Self.value = Self.value_from
	End Method
	
	Method scroll_step(amount:Int)
		Self.value:-amount*Self.scroll_step_x
		If Self.value > Self.value_to Then Self.value = Self.value_to
		If Self.value < Self.value_from Then Self.value = Self.value_from
	End Method
	
	Field scroll_step_x:Float = 10.0
	Field scroll_typ:Int=0'0 = percent, 1=step
	
	Method scroll(amount:Int)
		Select scroll_typ
			Case 0
				Self.scroll_percent(amount)
			Case 1
				Self.scroll_step(amount)
		End Select
	End Method
	
	
	Method draw()'prototype
		Self.setarea()
		SetClsColor Self.clscolor[0]*0.7, Self.clscolor[1]*0.7, Self.clscolor[2]*0.7
		Cls
		
		SetColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
		EG_DRAW.rect(2,2,Self.dx-4,Self.dy-4,Self)
		
		'SetColor 0,0,0
		'EG_DRAW.text(2,2,Int(Self.value),Self)
		
		SetColor Self.clscolor[0]*0.4, Self.clscolor[1]*0.4, Self.clscolor[2]*0.4
		Local percent:Float = (Self.value-Self.value_from)/(Self.value_to-Self.value_from)
		EG_DRAW.rect(percent*(Self.dx-Self.glider_side),0,Self.glider_side,Self.dy,Self)
		
		SetColor Self.clscolor[0]*0.8, Self.clscolor[1]*0.8, Self.clscolor[2]*0.8
		EG_DRAW.rect(percent*(Self.dx-Self.glider_side)+2,0+2,Self.glider_side-4,Self.dy-4,Self)
	End Method
End Type
'-------------------------------------------## SCROLL_Y ##------------------------
Type EG_SCROLL_Y Extends EG_AREA
	Method New()
		Self.children = New TList
		Self.name = "scroll_y"
		
		Self.clscolor = COLORS.scroll
	End Method
	
	Const width:Int = 15
	
	Const glider_side:Int = 20
	
	Field value_from:Float
	Field value:Float
	Field value_to:Float
	
	Function Create_SCROLL_Y:EG_SCROLL_Y(name:String,x:Int,y:Int,dy:Int,parent:EG_OBJECT,values:Int[],scroll_step_y:Float=0)
		Local a:EG_SCROLL_Y = New EG_SCROLL_Y
		a.name = name
		
		a.rel_x = x
		a.rel_y = y
		a.dy = dy
		a.dx = EG_SCROLL_Y.width
		
		a.scroll_step_y = scroll_step_y
		If a.scroll_step_y>0 Then a.scroll_typ = 1
		
		If parent Then a.parent = parent.add_child(a)
		
		If Not values.length < 3 Then
			a.value_from = values[0]
			a.value = values[1]
			a.value_to = values[2]
		End If
		
		Return a
	End Function
	
	Method update_from_to(values:Int[])
		
		If Not values.length < 3 Then
			Self.value_from = values[0]
			Self.value_to = values[2]
			
			If Self.value > Self.value_to Then Self.value = Self.value_to
			If Self.value < Self.value_from Then Self.value = Self.value_from
		End If
	End Method
	
	Method render:TList(events:TList)'prototype
		' no children !
		
		
		For Local e:EG_MOUSE_OVER = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				'mouse over me !
			End If
		Next
		
		For Local d:EG_MOUSE_DRAG = EachIn events
			If EG_MOUSE_DRAG.eg_obj=Self Or (EG_MOUSE_DRAG.eg_obj=Null And EG_CALC.inside(Self.viewport,[d.x,d.y])) Then
				EG_MOUSE_DRAG.eg_obj=Self
				
				events.remove(d)
				
				EG_OBJECT.active_object = Self
				
				Local distance:Float = (Self.dy-Self.glider_side)*(Self.value-Self.value_from)/(Self.value_to-Self.value_from)
				
				Local drag_y:Int = d.y_drag' ---------- Y DRAG
				
				If distance+d.y_drag > (Self.dy-Self.glider_side) Then
					drag_y = (Self.dy-Self.glider_side) - distance
				End If
				
				If distance+d.y_drag < 0 Then
					drag_y = 0 - distance
				End If
				
				distance:+drag_y
				
				Self.value = Self.value_from+(Self.value_to-Self.value_from)*distance/(Self.dy-Self.glider_side)
				
				d.drag(0,drag_y)
				
			End If
		Next
		
		
		For Local e:EG_MOUSE_SCROLL = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				Self.scroll(e.z)
				
				events.remove(e)
			End If
		Next
		
		Return events
	End Method
	
	Method scroll_percent(amount:Int)
		Self.value:-amount*(Self.value_to-Self.value_from)*0.05
		If Self.value > Self.value_to Then Self.value = Self.value_to
		If Self.value < Self.value_from Then Self.value = Self.value_from
	End Method
	
	Method scroll_abs(amount:Int)
		Self.value:-amount
		If Self.value > Self.value_to Then Self.value = Self.value_to
		If Self.value < Self.value_from Then Self.value = Self.value_from
	End Method
	
	Method scroll_step(amount:Int)
		Self.value:-amount*Self.scroll_step_y
		If Self.value > Self.value_to Then Self.value = Self.value_to
		If Self.value < Self.value_from Then Self.value = Self.value_from
	End Method
	
	Field scroll_step_y:Float = 10.0
	Field scroll_typ:Int=0'0 = percent, 1=step
	
	Method scroll(amount:Int)
		Select scroll_typ
			Case 0
				Self.scroll_percent(amount)
			Case 1
				Self.scroll_step(amount)
		End Select
	End Method
	
	Method draw()'prototype
		Self.setarea()
		SetClsColor Self.clscolor[0]*0.7, Self.clscolor[1]*0.7, Self.clscolor[2]*0.7
		Cls
		
		SetColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
		EG_DRAW.rect(2,2,Self.dx-4,Self.dy-4,Self)
		
		'SetColor 0,0,0
		'EG_DRAW.text(2,2,Int(Self.value),Self)
		
		SetColor Self.clscolor[0]*0.4, Self.clscolor[1]*0.4, Self.clscolor[2]*0.4
		Local percent:Float = (Self.value-Self.value_from)/(Self.value_to-Self.value_from)
		EG_DRAW.rect(0,percent*(Self.dy-Self.glider_side),Self.dx,Self.glider_side,Self)
		
		SetColor Self.clscolor[0]*0.8, Self.clscolor[1]*0.8, Self.clscolor[2]*0.8
		EG_DRAW.rect(0+2,percent*(Self.dy-Self.glider_side)+2,Self.dx-4,Self.glider_side-4,Self)
	End Method
End Type

'-------------------------------------------## TABLE_EDITOR ##------------------------
Type EG_TABLE_EDITOR Extends EG_AREA
	Method New()
		Self.children = New TList
		Self.name = "TABLE EDITOR"
	End Method
	
	Field x1:Int, x2:Int
	Field y1:Int
	
	Field selected:String
	Field map:TMap
	
	Field input_key:EG_STRING_AREA
	Field input_value:EG_STRING_AREA
	Field button_new:EG_BUTTON
	Field button_delete:EG_BUTTON
	Field scroll:EG_SCROLL_AREA
	Field sub:EG_TABLE_EDITOR_SUB
	
	Function Create_TABLE_EDITOR:EG_TABLE_EDITOR(name:String,x:Int,y:Int,x1:Int,x2:Int,y1:Int,map:TMap,parent:EG_OBJECT)
		Local a:EG_TABLE_EDITOR = New EG_TABLE_EDITOR
		a.name = name
		
		a.rel_x = x
		a.rel_y = y
		a.dx = x1+x2+EG_SCROLL_Y.width
		a.dy = 55+y1+EG_SCROLL_X.height
		
		a.x1 = x1
		a.x2 = x2
		a.y1 = y1
		
		a.map = map
		
		If parent Then a.parent = parent.add_child(a)
		
		'top
		a.input_key = EG_STRING_AREA.Create_String_Area("input key",5,2,a.x1,a,"key")
		a.input_value = EG_STRING_AREA.Create_String_Area("input value",10+a.x1,2,a.x2,a,"value")
		a.button_new = EG_BUTTON.Create_Button("new variable",5,30,(a.x1+a.x2)/2,20,a)
		a.button_delete = EG_BUTTON.Create_Button("delete",10+(a.x1+a.x2)/2,30,(a.x1+a.x2)/2,20,a)
		
		'sub
		a.scroll = EG_SCROLL_AREA.Create_SCROLL_AREA("scroll",0,55,a.dx,y1+EG_SCROLL_X.height,a,20,20)
		a.scroll.set_adapt(0)
		a.scroll.draggable = 0
		a.sub = EG_TABLE_EDITOR_SUB.Create_TABLE_EDITOR_SUB("table editor",a,a.scroll)
		
		a.set_adapt(-1)
		
		Return a
	End Function
	
	
	Method render:TList(events:TList)'prototype
		If Self.map.Contains(Self.selected) Then
			Self.input_key.text = Self.selected
			Self.input_value.text = String(Self.map.ValueForKey(Self.selected))
		End If
		
		Local save_selected:String = Self.selected
		
		events = Super.render(events)
		
		If save_selected = Self.selected Then
			If Self.map.Contains(save_selected) Then
				Self.map.Remove(save_selected)
				
				Self.map.Insert(Self.input_key.text,Self.input_value.text)
				
				Self.selected = Self.input_key.text
			End If
		End If
		
		
		For Local e:EG_MOUSE_OVER = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				'mouse over me !
			End If
		Next
		
		If Self.button_new.status = 2 Then
			Self.button_new.status = 0
			
			Local i:Int = 1
			
			While Self.map.Contains("new_" + i)
				i:+1
			Wend
			
			Self.map.Insert("new_" + i,"")
		End If
		
		If Self.button_delete.status = 2 Then
			Self.button_delete.status = 0
			Self.map.Remove(Self.selected)
		End If
		
		Return events
	End Method
	
	'EG_MOUSE_OVER
	Method draw()'prototype
		Self.setarea()
		SetClsColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
		Cls
		
		Self.user_draw()
		
		For Local c:EG_OBJECT = EachIn Self.children
			c.draw()
		Next
	End Method
	
	Method user_draw()
	End Method
End Type

'-------------------------------------------## TABLE_TABLE_EDITOR_SUB ##------------------------
Type EG_TABLE_EDITOR_SUB Extends EG_AREA
	Method New()
		Self.children = New TList
		Self.name = "TABLE EDITOR SUB"
	End Method
	
	Field super_table_editor:EG_TABLE_EDITOR
	Global distance:Int = 20
	
	Function Create_TABLE_EDITOR_SUB:EG_TABLE_EDITOR_SUB(name:String,super_table_editor:EG_TABLE_EDITOR,parent:EG_OBJECT)
		Local a:EG_TABLE_EDITOR_SUB = New EG_TABLE_EDITOR_SUB
		a.name = name
		
		a.rel_x = 0
		a.rel_y = 0
		a.dx = super_table_editor.x1 + super_table_editor.x2
		a.dy = 200'super_table_editor.map.count()*EG_TABLE_EDITOR_SUB.distance
		
		a.super_table_editor = super_table_editor
		
		If parent Then a.parent = parent.add_child(a)
		
		a.clscolor = [200,200,200]
		
		Return a
	End Function
	
	
	Method render:TList(events:TList)'prototype
		events = Super.render(events)
		
		For Local e:EG_MOUSE_OVER = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				'mouse over me !
			End If
		Next
		
		For Local e:EG_MOUSE_DRAG = EachIn events
			If EG_MOUSE_DRAG.eg_obj=Self Or (EG_MOUSE_DRAG.eg_obj=Null And EG_CALC.inside(Self.viewport,[e.x,e.y])) Then
				EG_MOUSE_DRAG.eg_obj=Self
				
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
				Local yy:Int = e.rel_y(Self)/EG_TABLE_EDITOR_SUB.distance
				
				Local i:Int = 0
				For Local key:String = EachIn Self.super_table_editor.map.Keys()
					
					If i = yy Then Self.super_table_editor.selected = key
					
					i:+1
				Next
				
				EG_MOUSE_DRAG.reset()
			End If
		Next
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
				Local yy:Int = e.rel_y(Self)/EG_TABLE_EDITOR_SUB.distance
				
				Local i:Int = 0
				For Local key:String = EachIn Self.super_table_editor.map.Keys()
					
					If i = yy Then Self.super_table_editor.selected = key
					
					i:+1
				Next
			End If
		Next
		
		'EG_TABLE_EDITOR_SUB.distance
		
		Return events
	End Method
	
	'EG_MOUSE_OVER
	Method draw()'prototype
		Self.setarea()
		
		Self.user_draw()
	End Method
	
	Method user_draw()
		SetClsColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
		Cls
		
		Local i:Int = 0
		
		For Local key:String = EachIn Self.super_table_editor.map.Keys()
			Local value:String = String(Self.super_table_editor.map.ValueForKey(key))
			
			If Self.super_table_editor.selected = key Then
				SetColor 255,255,255
				EG_DRAW.rect(0,i*EG_TABLE_EDITOR_SUB.distance,Self.dx,EG_TABLE_EDITOR_SUB.distance,Self)
			End If
			
			SetColor 0,0,0
			EG_DRAW.rect(0,(i+1)*EG_TABLE_EDITOR_SUB.distance,Self.dx,-1,Self)
			
			EG_DRAW.text(2,i*EG_TABLE_EDITOR_SUB.distance+2,key,Self)
			EG_DRAW.text(2+Self.super_table_editor.x1,i*EG_TABLE_EDITOR_SUB.distance+2,value,Self)
			
			i:+1
		Next
		
		EG_DRAW.rect(Self.super_table_editor.x1,0,1,Self.dy,Self)
		
		Self.dy = i*EG_TABLE_EDITOR_SUB.distance
	End Method
End Type

'-------------------------------------------## WINDOW ##------------------------
Type EG_WINDOW Extends EG_AREA
	Method New()
		Self.children = New TList
		Self.name = "Window"
		
		Self.icon = CreateImage(20,20)
		
		Self.clscolor = COLORS.window
	End Method
	
	Field icon:TImage
	
	Field area:EG_AREA
	
	Field disactivated:Int = 0
	
	Field win_close:Int = 0
	
	Const w_rand_0:Int = 3'left
	Const w_rand_1:Int = 23'top
	Const w_rand_2:Int = 3'right
	Const w_rand_3:Int = 3'bottom
	
	Function Create_WINDOW:EG_WINDOW(name:String,x:Int,y:Int,dx:Int,dy:Int,parent:EG_OBJECT,icon:TImage = Null)
		Local w:EG_WINDOW = New EG_WINDOW
		w.name = name
		
		If icon <> Null Then w.icon = icon
		
		w.rel_x = x - EG_WINDOW.w_rand_0
		w.rel_y = y - EG_WINDOW.w_rand_1
		w.dx = dx + EG_WINDOW.w_rand_0+w_rand_3
		w.dy = dy + EG_WINDOW.w_rand_1+EG_WINDOW.w_rand_3
		
		If w.rel_x < 0 Then w.rel_x = 0
		If w.rel_x > parent.dx-30 Then w.rel_x = parent.dx-30
		
		If w.rel_y < 0 Then w.rel_y = 0
		If w.rel_y > parent.dy-30 Then w.rel_y = parent.dy-30
		
		If parent Then w.parent = parent.add_child(w)
		
		'drawing area:
		
		w.area = EG_AREA.Create_Area(w.name + "_area",w_rand_0,EG_WINDOW.w_rand_1,dx,dy,w)
		w.area.clscolor = [100,100,100]
		
		Return w
	End Function
	
	'adapt
	Method give_inside_dx:Int()
		Return Self.dx-EG_WINDOW.w_rand_0-EG_WINDOW.w_rand_2
	End Method
	
	Method give_inside_dy:Int()
		Return Self.dy-EG_WINDOW.w_rand_1-EG_WINDOW.w_rand_3
	End Method
	
	Method set_adapt(mode:Int)
		Self.area.set_adapt(mode)
		Select mode
			Case -1
				Self.adapt_size_x = -1
				Self.adapt_size_y = -1
			Case 0
				Self.adapt_size_x = 0
				Self.adapt_size_y = 0
			Case 1
				Self.adapt_size_x = 1
				Self.adapt_size_y = 1
			Default
				Self.adapt_size_x = 0
				Self.adapt_size_y = 0
		End Select
	End Method
	
	Method adapt_size()
		If Self.adapt_size_x = 1 Then'adapt to parent
			If parent Then
				Self.dx = Self.parent.give_inside_dx()
			End If
		ElseIf Self.adapt_size_x = -1 Then'adapt to children
			Self.dx = Self.area.dx+EG_WINDOW.w_rand_0+EG_WINDOW.w_rand_2
		ElseIf Self.adapt_size_x = 0 Then'not adapt
		End If
		
		If Self.adapt_size_y = 1 Then'adapt to parent
			If parent Then
				Self.dy = Self.parent.give_inside_dy()
			End If
		ElseIf Self.adapt_size_y = -1 Then'adapt to children
			Self.dy = Self.area.dy+EG_WINDOW.w_rand_1+EG_WINDOW.w_rand_3
		ElseIf Self.adapt_size_y = 0 Then'not adapt
		End If
	End Method
	'end adapt
	
	Method add_child:EG_OBJECT(obj:EG_OBJECT)'gives parent
		If Self.area Then
			Return Self.area.add_child(obj)
			
			obj.parent = Self.area
		Else
			Self.children.addlast(obj)
			
			obj.parent = Self
		End If
		Return obj.parent
	End Method
	
	
	Method get_height:Int()
		Return Self.area.dy
	End Method
	
	Method get_width:Int()
		Return Self.area.dx
	End Method
	
	
	Method render:TList(events:TList)' complete
		If Self.disactivated Then Return events
		
		If Not Self.active Then
			For Local e:EG_MOUSE_1_CLICK = EachIn events
				If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
					events.remove(e)
					
					EG_OBJECT.active_object = Self
					
				End If
			Next
			
			For Local d:EG_MOUSE_DRAG = EachIn events
				If (EG_MOUSE_DRAG.eg_obj=Null And EG_CALC.inside(Self.viewport,[d.x,d.y])) Then
					
					events.remove(d)
					
					EG_OBJECT.active_object = Self
					
					EG_MOUSE_DRAG.reset()
				End If
			Next
			
			
			For Local e:EG_MOUSE_SCROLL = EachIn events
				If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
					events.remove(e)
				End If
			Next
		End If
		
		
		If EG_OBJECT.active_object = Self Then
			For Local e:EG_KEY_DOWN = EachIn events
				Self.disactivated = 1
				
				EG_OBJECT.active_object = Null
				
				events.remove(e)
			Next
		End If
		
		
		For Local c:EG_OBJECT = EachIn Self.children' render children
			events = c.render(events:TList)
		Next
		
		
		For Local e:EG_MOUSE_OVER = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				'mouse over me !
			End If
		Next
		
		
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				
				Local xx:Int = Self.dx-w_rand_2-w_rand_1*2+6*2
				
				Local xx2:Int = Self.dx-w_rand_2-w_rand_1+6
				
				Local yy:Int = 3
				Local dxx:Int = w_rand_1-6
				Local dyy:Int = w_rand_1-6
				
				If xx <= e.rel_x(Self) And xx+dxx > e.rel_x(Self) And yy <= e.rel_y(Self) And yy+dyy > e.rel_y(Self) Then
					If EG_OBJECT.active_object = Self Then EG_OBJECT.active_object = Null
					Self.disactivated = 1
				ElseIf xx2 <= e.rel_x(Self) And xx2+dxx > e.rel_x(Self) And yy <= e.rel_y(Self) And yy+dyy > e.rel_y(Self) Then
					Self.close_win()
				Else
					EG_OBJECT.active_object = Self
				End If
				
				events.remove(e)
			End If
		Next
		
		For Local e:EG_MOUSE_2_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
			End If
		Next
		
		For Local d:EG_MOUSE_DRAG = EachIn events
			If EG_MOUSE_DRAG.eg_obj=Self Or (EG_MOUSE_DRAG.eg_obj=Null And EG_CALC.inside(Self.viewport,[d.x,d.y])) Then
				
				Local still_drag:Int = 1
				
				If EG_MOUSE_DRAG.eg_obj=Null Then
					Local xx:Int = Self.dx-w_rand_2-w_rand_1*2+6*2
					
					Local xx2:Int = Self.dx-w_rand_2-w_rand_1+6
					
					Local yy:Int = 3
					Local dxx:Int = w_rand_1-6
					Local dyy:Int = w_rand_1-6
					
					If xx <= d.rel_x(Self) And xx+dxx > d.rel_x(Self) And yy <= d.rel_y(Self) And yy+dyy > d.rel_y(Self) Then
						If EG_OBJECT.active_object = Self Then EG_OBJECT.active_object = Null
						Self.disactivated = 1
						
						still_drag = 0
					ElseIf xx2 <= d.rel_x(Self) And xx2+dxx > d.rel_x(Self) And yy <= d.rel_y(Self) And yy+dyy > d.rel_y(Self) Then
						Self.close_win()
						still_drag = 0
					End If
				End If
				
				If still_drag Then
					EG_MOUSE_DRAG.eg_obj=Self
					
					events.remove(d)
					
					EG_OBJECT.active_object = Self
					
					Local drag_x:Int = d.x_drag' ---------- X DRAG
					
					If Self.rel_x+d.x_drag > Self.parent.dx-30 Then
						drag_x = (Self.parent.dx-30) - (Self.rel_x)
					End If
					
					If Self.rel_x+d.x_drag < -Self.dx+30 Then
						drag_x = (-Self.dx+30) - (Self.rel_x)
					End If
					
					Self.rel_x:+drag_x
					d.drag(drag_x,0)
					
					Local drag_y:Int = d.y_drag' ---------- Y DRAG
					
					If Self.rel_y+d.y_drag > Self.parent.dy-30 Then
						drag_y = (Self.parent.dy-30) - Self.rel_y
					End If
					
					If Self.rel_y+d.y_drag < -10 Then
						drag_y = (-10) - Self.rel_y
					End If
					
					Self.rel_y:+drag_y
					d.drag(0,drag_y)
				End If
			End If
		Next
		
		For Local e:EG_MOUSE_SCROLL = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
			End If
		Next
		
		Return events
	End Method
	
	Method close_win()
		Self.win_close = 1
	End Method
	
	Method draw()'prototype
		If Self.disactivated Then Return
		
		Self.setarea()
		
		If Self.active Then
			SetColor Self.clscolor[0]*0.7, Self.clscolor[1]*0.7, Self.clscolor[2]*0.7
		Else
			SetColor Self.clscolor[0]*0.5, Self.clscolor[1]*0.5, Self.clscolor[2]*0.5
		End If
		
		SetAlpha 0.7
		EG_DRAW.rect(0,0,Self.dx,Self.dy,Self)
		
		
		If Self.active Then
			SetColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
		Else
			SetColor Self.clscolor[0]*0.4, Self.clscolor[1]*0.4, Self.clscolor[2]*0.4
		End If
		
		EG_DRAW.rect(2,2,Self.dx-4,Self.dy-4,Self)
		
		If Self.active Then
			SetColor Self.clscolor[0]*0.7, Self.clscolor[1]*0.7, Self.clscolor[2]*0.7
		Else
			SetColor Self.clscolor[0]*0.5, Self.clscolor[1]*0.5, Self.clscolor[2]*0.5
		End If
		
		EG_DRAW.rect(Self.dx,Self.dy,15,15,Self)
		
		SetAlpha 1
		SetColor 255,255,255
		EG_DRAW.text(w_rand_0+2 + 20,w_rand_0+2,Self.name,Self)
		
		Local f:Int = (MilliSecs() / 400) Mod Self.icon.frames.length
		EG_DRAW.image(w_rand_0,w_rand_0,Self.icon,f,Self)
		
		'MINIMIE AND CLOSE
		Local xx:Int = Self.dx-w_rand_2-w_rand_1*2+6*2
		Local yy:Int = 3
		Local dxx:Int = w_rand_1-6
		Local dyy:Int = w_rand_1-6
		
		SetColor COLORS.window_min[0], COLORS.window_min[1], COLORS.window_min[2]
		EG_DRAW.rect(xx,yy,dxx,dyy,Self)
		SetColor COLORS.window_ri[0], COLORS.window_ri[1], COLORS.window_ri[2]
		EG_DRAW.poly([xx+2,yy+2, xx+dxx-2,yy+2, xx+dxx/2,yy+dyy-2],Self)
		
		
		xx = Self.dx-w_rand_2-w_rand_1+6
		SetColor COLORS.window_close[0], COLORS.window_close[1], COLORS.window_close[2]
		EG_DRAW.rect(xx,yy,dxx,dyy,Self)
		SetColor COLORS.window_ri[0], COLORS.window_ri[1], COLORS.window_ri[2]
		EG_DRAW.poly([xx+2,yy+dyy/2, xx+dxx/2,yy+2, xx+dxx-2,yy+dyy/2, xx+dxx/2,yy+dyy-2],Self)
		
		
		'CHILDREN
		For Local c:EG_OBJECT = EachIn Self.children
			c.draw()
		Next
	End Method
End Type

'-------------------------------------------## AREA ##------------------------
Type EG_TASK_BAR Extends EG_AREA
	Method New()
		Self.children = New TList
		Self.name = "Task_Bar"
	End Method
	
	Const height:Int = 30
	Field w_list:TList
	
	Field text_on:Int[]
	Field text_off:Int[]
	
	Function Create_TASK_BAR:EG_TASK_BAR(name:String,x:Int,y:Int,dx:Int,parent:EG_OBJECT)
		Local a:EG_TASK_BAR= New EG_TASK_BAR
		a.name = name
		
		a.rel_x = x
		a.rel_y = y
		a.dx = dx
		a.dy = EG_TASK_BAR.height
		
		If parent Then a.parent = parent.add_child(a)
		
		If EG_SCREEN(a.parent) Then EG_SCREEN(a.parent).taskbar = a
		a.w_list = New TList
		
		a.clscolor = COLORS.taskbar
		a.text_on = COLORS.taskbar_text_on
		a.text_off = COLORS.taskbar_text_off
		
		Return a
	End Function
	
	Rem
	
	Global taskbar:Int[] = [100,100,200]
	Global taskbar_text_on:Int[] = [255,255,255]
	Global taskbar_text_off:Int[] = [0,0,0]
	
	End Rem
	
	Method render:TList(events:TList)'prototype
		events = Super.render(events)
		
		For Local e:EG_MOUSE_OVER = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				'mouse over me !
			End If
		Next
		
		For Local d:EG_MOUSE_DRAG = EachIn events
			If EG_MOUSE_DRAG.eg_obj=Self Or (EG_MOUSE_DRAG.eg_obj=Null And EG_CALC.inside(Self.viewport,[d.x,d.y])) Then
				EG_MOUSE_DRAG.eg_obj=Self
				
				events.remove(d)
				
				Local i:Int = 0
				Local i_max:Int = Self.w_list.count()
				
				Local clicked_i:Int = d.rel_x(Self)*i_max/Self.dx
				
				For Local w:EG_WINDOW = EachIn Self.w_list
					If i = clicked_i Then
						EG_OBJECT.active_object = w
						w.disactivated = 0
					End If
					i:+1
				Next
				
				EG_MOUSE_DRAG.reset()
				
			End If
		Next
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Local i:Int = 0
				Local i_max:Int = Self.w_list.count()
				
				Local clicked_i:Int = e.rel_x(Self)*i_max/Self.dx
				
				For Local w:EG_WINDOW = EachIn Self.w_list
					If i = clicked_i Then
						EG_OBJECT.active_object = w
						w.disactivated = 0
					End If
					i:+1
				Next
				
			End If
		Next
		
		For Local e:EG_MOUSE_2_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				Local i:Int = 0
				Local i_max:Int = Self.w_list.count()
				
				Local clicked_i:Int = e.rel_x(Self)*i_max/Self.dx
				
				For Local w:EG_WINDOW = EachIn Self.w_list
					If i = clicked_i Then
						If EG_OBJECT.active_object = w Then EG_OBJECT.active_object = Self
						w.disactivated = 1
					End If
					i:+1
				Next
			End If
		Next
		
		'If Self.disactivated Then Return
		
		Return events
	End Method
	
	'EG_MOUSE_OVER
	Method draw()'prototype
		Self.setarea()
		SetClsColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
		Cls
		
		'SetClsColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
		
		Local i:Int = 0
		Local i_max:Int = Self.w_list.count()
		
		For Local w:EG_WINDOW = EachIn Self.w_list
			If w.active Then
				SetColor Self.clscolor[0]*0.7, Self.clscolor[1]*0.7, Self.clscolor[2]*0.7
				EG_DRAW.rect(i*Self.dx/i_max,0,Self.dx/i_max,Self.dy,Self)
				
				SetColor Self.clscolor[0], Self.clscolor[1], Self.clscolor[2]
				EG_DRAW.rect(1+i*Self.dx/i_max,1,Self.dx/i_max-2,Self.dy-2,Self)
				
				SetColor 255,255,255
				Local f:Int = (MilliSecs() / 400) Mod w.icon.frames.length
				EG_DRAW.image(2+i*Self.dx/i_max,2,w.icon,f,Self)
				
				SetColor Self.text_on[0], Self.text_on[1], Self.text_on[2]
				EG_DRAW.text(24+i*Self.dx/i_max,2,w.name,Self)
			ElseIf w.disactivated = 1 Then
				SetColor Self.clscolor[0]*0.6, Self.clscolor[1]*0.8, Self.clscolor[2]*0.6
				EG_DRAW.rect(i*Self.dx/i_max,0,Self.dx/i_max,Self.dy,Self)
				
				SetColor Self.clscolor[0]*0.3, Self.clscolor[1]*0.3, Self.clscolor[2]*0.3
				EG_DRAW.rect(1+i*Self.dx/i_max,1,Self.dx/i_max-2,Self.dy-2,Self)
				
				SetColor 255,255,255
				Local f:Int = (MilliSecs() / 400) Mod w.icon.frames.length
				EG_DRAW.image(2+i*Self.dx/i_max,2,w.icon,f,Self)
				
				SetColor Self.text_off[0], Self.text_off[1], Self.text_off[2]
				EG_DRAW.text(24+i*Self.dx/i_max,2,w.name,Self)
			Else
				SetColor Self.clscolor[0]*0.8, Self.clscolor[1]*0.8, Self.clscolor[2]*0.8
				EG_DRAW.rect(i*Self.dx/i_max,0,Self.dx/i_max,Self.dy,Self)
				
				SetColor Self.clscolor[0]*0.5, Self.clscolor[1]*0.5, Self.clscolor[2]*0.5
				EG_DRAW.rect(1+i*Self.dx/i_max,1,Self.dx/i_max-2,Self.dy-2,Self)
				
				SetColor 255,255,255
				Local f:Int = (MilliSecs() / 400) Mod w.icon.frames.length
				EG_DRAW.image(2+i*Self.dx/i_max,2,w.icon,f,Self)
				
				SetColor Self.text_off[0], Self.text_off[1], Self.text_off[2]
				EG_DRAW.text(24+i*Self.dx/i_max,2,w.name,Self)
			End If
			
			i:+1
		Next
	End Method
End Type

'-------------------------------------------## SCREEN ##------------------------
Type EG_SCREEN Extends EG_AREA
	Field mode:Int'screen mode, full, window
	
	Field taskbar:EG_TASK_BAR
	
	Method New()
		Self.children = New TList
		Self.name = "Screen"
		Self.clscolor = COLORS.screen
	End Method
	
	Function Create_Screen:EG_SCREEN(name:String,x:Int,y:Int,mode:Int=0)
		Local s:EG_SCREEN = New EG_SCREEN
		s.name = name
		s.rel_x = 0
		s.rel_y = 0
		s.dx = x
		s.dy = y
		
		AppTitle = name
		
		Select mode
			Case 0
				Graphics s.dx, s.dy,,30
			Default
				Graphics s.dx, s.dy,32,30
		End Select
		
		SetBlend alphablend
		
		HideMouse()
		
		EG_TASK_BAR.Create_TASK_BAR("task_bar",0,s.dy-EG_TASK_BAR.height,s.dx,s)
		
		Return s
	End Function
	
	Method render:TList(events:TList)'prototype
		events = Super.render(events)
		
		For Local e:EG_MOUSE_1_CLICK = EachIn events
			If EG_CALC.inside(Self.viewport,[e.x,e.y]) Then
				events.remove(e)
				
				EG_OBJECT.active_object = Self
				
			End If
		Next
		
		Return events
	End Method
	
	Method add_child:EG_OBJECT(obj:EG_OBJECT)'gives parent
		
		If Self.children_upsidedown = 0 Then
			Self.children.addfirst(obj)
		Else
			Self.children.addlast(obj)
		End If
		
		If Self.taskbar Then
			Self.taskbar.w_list.addlast(obj)
		End If
		
		obj.parent = Self
		Return Self
	End Method
	
	Method rem_child(obj:EG_OBJECT)
		Self.children.remove(obj)
		
		If Self.taskbar Then
			Self.taskbar.w_list.remove(obj)
		End If
	End Method
	
	Method render_children:TList(events:TList)
		Local first:EG_OBJECT
		
		Self.children.reverse()
		For Local c:EG_OBJECT = EachIn Self.children
			events = c.render(events:TList)
			If c.active Then first = c
		Next
		Self.children.reverse()
		
		If first And Self.children.contains(first) Then' must check wether contains, if killed !
			Self.children.remove(first)
			Self.children.addlast(first)
		End If
		
		If Self.taskbar Then
			Self.children.remove(Self.taskbar)
			Self.children.addlast(Self.taskbar)
		End If
		
		Return events
	End Method
	
	Method draw()
		Self.setarea()
		
		EG_DRAW.clear(Self.clscolor[0], Self.clscolor[1], Self.clscolor[2],Self)
		
		SetColor 100,100,100
		If EG_OBJECT.active_object Then EG_DRAW.text(2,2,"selected: " + EG_OBJECT.active_object.name,Self)
		If EG_MOUSE_DRAG.eg_obj Then EG_DRAW.text(2,20,"drag: " + EG_MOUSE_DRAG.eg_obj.name,Self)
		If EG_MOUSE.current_transport Then EG_DRAW.text(2,38,"mouse_transport: " + EG_MOUSE.current_transport.name,Self)
		
		For Local c:EG_OBJECT = EachIn Self.children
			c.draw()
		Next
		
		EG_MOUSE.draw()
		
		Flip' only screen !
	End Method
End Type

'################### EME GUI DRAWING #######################
Type EG_DRAW
	Function rect(x:Int,y:Int,dx:Int,dy:Int,eg_obj:EG_OBJECT=Null)
		Local px:Int = 0
		Local py:Int = 0
		
		If eg_obj <> Null Then
			px = eg_obj.abs_x
			py = eg_obj.abs_y
		End If
		
		DrawRect px+x, py+y, dx, dy
	End Function
	
	Function oval(x:Int,y:Int,dx:Int,dy:Int,eg_obj:EG_OBJECT=Null)
		Local px:Int = 0
		Local py:Int = 0
		
		If eg_obj <> Null Then
			px = eg_obj.abs_x
			py = eg_obj.abs_y
		End If
		
		DrawOval px+x, py+y, dx, dy
	End Function
	
	Function image(x:Int,y:Int,image:TImage,frame:Int=0,eg_obj:EG_OBJECT=Null)
		Local px:Int = 0
		Local py:Int = 0
		
		If eg_obj <> Null Then
			px = eg_obj.abs_x
			py = eg_obj.abs_y
		End If
		
		DrawImage image,px+x, py+y,frame
	End Function
	
	Function poly(xy:Int[],eg_obj:EG_OBJECT=Null,offset_x:Int=0,offset_y:Int=0)
		Local nxy:Float[xy.length]
		
		Local px:Int = 0
		Local py:Int = 0
		
		If eg_obj <> Null Then
			px = eg_obj.abs_x
			py = eg_obj.abs_y
		End If
		
		For Local i:Int = 0 To xy.length-1
			If (i Mod 2)=0 Then'x
				nxy[i]= xy[i]+px+offset_x
			Else'y
				nxy[i]= xy[i]+py+offset_y
			End If
		Next
		
		DrawPoly(nxy)
	End Function
	
	Function text(x:Int,y:Int,text:String,eg_obj:EG_OBJECT=Null)
		Local px:Int = 0
		Local py:Int = 0
		
		If eg_obj <> Null Then
			px = eg_obj.abs_x
			py = eg_obj.abs_y
		End If
		
		DrawText text,px+x, py+y
	End Function
	
	Global background_image:TImage
	
	Function clear(r:Float,g:Float,b:Float,eg_obj:EG_OBJECT=Null)'EG_DRAW.clear()
		SetClsColor r,g,b
		
		Cls()
		
		If Not EG_DRAW.background_image Then Return
		
		SetColor r,g,b
		
		Local px:Int = 0
		Local py:Int = 0
		
		If eg_obj <> Null Then
			px = eg_obj.abs_x
			py = eg_obj.abs_y
		End If
		
		TileImage(EG_DRAW.background_image,px,py)
	End Function
	
	'DrawLine(x1,y1,x2,y2)
	'DrawText( t$,x#,y# )
	'DrawImage( image:TImage,x#,y#,frame=0 )
	'DrawOval( x#,y#,width#,height# )
	'DrawPoly( xy#[] )
End Type

'#################### EME GUI EVENTS ######################

Type EG_MOUSE
	Global x:Int
	Global y:Int
	Global z_speed:Int
	
	Function rel_x:Int(eg_obj:EG_OBJECT)
		If eg_obj Then
			Return EG_MOUSE.x - eg_obj.abs_x
		End If
		
		Return EG_MOUSE.x
	End Function
	
	Function rel_y:Int(eg_obj:EG_OBJECT)
		If eg_obj Then
			Return EG_MOUSE.y - eg_obj.abs_y
		End If
		
		Return EG_MOUSE.y
	End Function
	
	Function render()
		EG_MOUSE.x = MouseX()
		EG_MOUSE.y = MouseY()
		
		If EG_MOUSE.x < EG_MASTER.screen.abs_x Then EG_MOUSE.x = EG_MASTER.screen.abs_x
		If EG_MOUSE.y < EG_MASTER.screen.abs_y Then EG_MOUSE.y = EG_MASTER.screen.abs_y
		If EG_MOUSE.x > EG_MASTER.screen.dx + EG_MASTER.screen.abs_x Then EG_MOUSE.x = EG_MASTER.screen.dx + EG_MASTER.screen.abs_x
		If EG_MOUSE.y > EG_MASTER.screen.dy + EG_MASTER.screen.abs_y Then EG_MOUSE.y = EG_MASTER.screen.dy + EG_MASTER.screen.abs_y
		
		If EG_MOUSE.last_1>1 Then
			If Not MouseDown(1) Then
				EG_MOUSE.last_1 = EG_MOUSE.last_1-MilliSecs()
				
				EG_MOUSE_DRAG.eg_obj = Null'reset drag object
			End If
		Else
			If MouseHit(1) Then
				EG_MOUSE.last_1 = MilliSecs()
				EG_MOUSE.last_x_set = EG_MOUSE.x
				EG_MOUSE.last_y_set = EG_MOUSE.y
			Else
				EG_MOUSE_DRAG.eg_obj = Null
			End If
		End If
		
		If EG_MOUSE.last_1<0 Then
			
			If EG_MOUSE.last_1 < -100 Then
				EG_EVENT.list.addlast(EG_MOUSE_DRAG.Create(1))
				'drag is ending here
			Else
				EG_EVENT.list.addlast(EG_MOUSE_1_CLICK.Create(EG_MOUSE.x,EG_MOUSE.y))
				
				EG_MOUSE_DRAG.reset()
			End If
			
			EG_MOUSE.last_1 = 0
		ElseIf MilliSecs()-EG_MOUSE.last_1>100 And EG_MOUSE.last_1 > 0 Then
			EG_EVENT.list.addlast(EG_MOUSE_DRAG.Create())
			'current drag
		ElseIf EG_MOUSE.last_1 = 0
			EG_EVENT.list.addlast(EG_MOUSE_OVER.Create(EG_MOUSE.x,EG_MOUSE.y))
			
			EG_MOUSE_DRAG.reset()
		End If
		
		If MouseHit(2) Then EG_EVENT.list.addlast(EG_MOUSE_2_CLICK.Create(EG_MOUSE.x,EG_MOUSE.y))
		
		EG_MOUSE.z_speed = MouseZSpeed()
		If EG_MOUSE.z_speed <> 0 Then
			
			Local direction_side:Int = 0
			For Local c:EG_KEY_CONTROLS = EachIn EG_EVENT.list
				If c.name = "LCONTROL" Then direction_side = 1
				If c.name = "LSHIFT" Then direction_side = 2
				'
			Next
			
			If direction_side = 1
				EG_EVENT.list.addlast(EG_MOUSE_SCROLL_SIDE.Create(EG_MOUSE.x,EG_MOUSE.y,EG_MOUSE.z_speed))
			ElseIf direction_side = 2
				EG_EVENT.list.addlast(EG_MOUSE_SCROLL_ZOOM.Create(EG_MOUSE.x,EG_MOUSE.y,EG_MOUSE.z_speed))
			Else
				EG_EVENT.list.addlast(EG_MOUSE_SCROLL.Create(EG_MOUSE.x,EG_MOUSE.y,EG_MOUSE.z_speed))
			End If
		End If
	End Function
	
	Global last_1:Int
	
	Global last_x_set:Int
	Global last_y_set:Int
	
	Global current_transport:EG_MOUSE_TRANSPORT
	
	Global current_info:EG_MOUSE_INFO
	Global info_time:Int
	
	Function draw()
		EG_MASTER.screen.setarea()
		
		If EG_MOUSE.current_info Then
			
			EG_MOUSE.current_info.draw(EG_MOUSE.x,EG_MOUSE.y)
			
			EG_MOUSE.info_time:-1
			
			If EG_MOUSE.info_time<0 Then
				EG_MOUSE.info_time = 0
				EG_MOUSE.current_info = Null
			EndIf
		EndIf
		
		If EG_MOUSE.current_transport Then
			SetColor 0,0,0
			EG_DRAW.rect(EG_MOUSE.x,EG_MOUSE.y,10,5)
			EG_DRAW.rect(EG_MOUSE.x,EG_MOUSE.y,5,10)
			
			SetColor 255,255,255
			EG_DRAW.rect(EG_MOUSE.x+1,EG_MOUSE.y+1,10-2,5-2)
			EG_DRAW.rect(EG_MOUSE.x+1,EG_MOUSE.y+1,5-2,10-2)
			
			EG_MOUSE.current_transport.draw(EG_MOUSE.x+5,EG_MOUSE.y+5)
		Else
			SetColor 0,0,0
			'EG_DRAW.rect(EG_MOUSE.x,EG_MOUSE.y,10,10)
			EG_DRAW.poly([0,0,15,15,0,20],EG_MASTER.screen,EG_MOUSE.x,EG_MOUSE.y)
			
			SetColor 255,255,255
			EG_DRAW.poly([1,3,12,14,1,18],EG_MASTER.screen,EG_MOUSE.x,EG_MOUSE.y)
			'EG_DRAW.rect(EG_MOUSE.x+1,EG_MOUSE.y+1,10-2,10-2)
		End If
	End Function
End Type

Type EG_MOUSE_INFO
	Field lines:String[]
	Field dx:Int
	
	Function Create:EG_MOUSE_INFO[lines:String[]]
		Local i:EG_MOUSE_INFO = New EG_MOUSE_INFO
		
		i.lines = lines
		
		i.dx = 100
		
		
		
		Return i
	End Function
	
	Method set()
		EG_MOUSE.current_info = Self
		EG_MOUSE.info_time = 30
	End Method
	
	Method draw(x:Int,y:Int)
		SetColor 0,0,0
		SetAlpha 0.3
		EG_DRAW.rect(x,y,Self.dx+4,Self.lines.length()*20)
		SetAlpha 1
		
		SetColor 255,255,255
		For Local ii:Int = 0 To Self.lines.length()-1
			Self.dx = Max(Self.dx, TextWidth(i.lines[ii]))
			EG_DRAW.text(x+2,y+ii*20,Self.lines[ii])
		Next
		
		SetAlpha 1
	End Method
End Type

Type EG_MOUSE_TRANSPORT
	Field name:String="transport"
	
	Method draw(x:Int,y:Int)
		SetColor 0,0,0
		EG_DRAW.rect(x,y,10,10)
		
		SetColor 255,255,255
		EG_DRAW.rect(x+1,y+1,10-2,10-2)
	End Method
	
	Method set()
		EG_MOUSE.current_transport = Self
	End Method
End Type

Type EG_EVENT
	Global list:TList = New TList
	
	Function get:TList()
		Local l:TList = EG_EVENT.list
		
		Return l
	End Function
	
	Function back(events:TList)
		For Local e:EG_MOUSE_DRAG = EachIn events
			events.remove(e)
			EG_MOUSE.last_1 = 0
			EG_MOUSE_DRAG.eg_obj = Null
		Next
		
		For Local e:EG_LETTER = EachIn events
			If e.letter = " " Then
				events.remove(e)
				
				EG_MOUSE.current_transport = Null
			End If
		Next
		
		Rem
		Local e_text:String
		For Local e:EG_EVENT = EachIn events
			e_text:+e.name+"; "
		Next
		
		If Not events.count()=0 Then Print events.count()+": "+e_text
		
		End Rem
		
		EG_EVENT.list = New TList
	End Function
	
	Field name:String = "event"
End Type


Type EG_KEYBOARD
	Const press_delay:Int = 100
	Function render()
		
		Local n:Int = GetChar()
		
		While n>0
			
			'Print n
			
			If n=1 Then' ctrl a - select all
				EG_EVENT.list.addlast(New EG_SELECT_ALL)
			End If
			
			If n=3 Then' ctrl c - copy
				EG_EVENT.list.addlast(New EG_COPY)
			End If
			
			If n=24 Then' ctrl x - cut
				EG_EVENT.list.addlast(New EG_CUT)
			End If
			
			If n=22 Then' ctrl v - paste
				EG_EVENT.list.addlast(New EG_PASTE)
			End If
			
			If n=19 Then' ctrl s - paste
				EG_EVENT.list.addlast(New EG_SAVE)
			End If
			
			If n>31'And n<225 Then
				EG_EVENT.list.addlast(EG_LETTER.Create(Chr(n)))
			End If
			
			If n=9 Then'tab
				EG_EVENT.list.addlast(EG_LETTER.Create(Chr(32) + Chr(32) + Chr(32) + Chr(32) + Chr(32)))
			End If
			
			If n=8 Then
				EG_EVENT.list.addlast(New EG_BACKSPACE)
			End If
			
			If n=13 Then
				EG_EVENT.list.addlast(New EG_ENTER)
			End If
			
			n = GetChar()
		Wend
		
		
		If EG_DELETE.get_on() Then
			EG_EVENT.list.addlast(New EG_DELETE)
		End If
		
		If EG_KEY_UP.get_on() Then EG_EVENT.list.addlast(New EG_KEY_UP)
		If EG_KEY_DOWN.get_on() Then EG_EVENT.list.addlast(New EG_KEY_DOWN)
		If EG_KEY_LEFT.get_on() Then EG_EVENT.list.addlast(New EG_KEY_LEFT)
		If EG_KEY_RIGHT.get_on() Then EG_EVENT.list.addlast(New EG_KEY_RIGHT)
		
		EG_KEY_CONTROLS.render()
	End Function
End Type

Type EG_KEY_CONTROLS Extends EG_EVENT
	Global last_controlls:TMap
	
	Method New()
		Self.name = "controls"
	End Method
	
	Global key_map:TMap
	
	Function init()
		EG_KEY_CONTROLS.key_map = New TMap
		
		EG_KEY_CONTROLS.key_map.insert("0", String(KEY_0))
		EG_KEY_CONTROLS.key_map.insert("1", String(KEY_1))
		EG_KEY_CONTROLS.key_map.insert("2", String(KEY_2))
		EG_KEY_CONTROLS.key_map.insert("3", String(KEY_3))
		EG_KEY_CONTROLS.key_map.insert("4", String(KEY_4))
		EG_KEY_CONTROLS.key_map.insert("5", String(KEY_5))
		EG_KEY_CONTROLS.key_map.insert("6", String(KEY_6))
		EG_KEY_CONTROLS.key_map.insert("7", String(KEY_7))
		EG_KEY_CONTROLS.key_map.insert("8", String(KEY_8))
		EG_KEY_CONTROLS.key_map.insert("9", String(KEY_9))
		
		
		EG_KEY_CONTROLS.key_map.insert("a", String(KEY_a))
		EG_KEY_CONTROLS.key_map.insert("b", String(KEY_b))
		EG_KEY_CONTROLS.key_map.insert("c", String(KEY_c))
		EG_KEY_CONTROLS.key_map.insert("d", String(KEY_d))
		EG_KEY_CONTROLS.key_map.insert("e", String(KEY_e))
		EG_KEY_CONTROLS.key_map.insert("f", String(KEY_f))
		EG_KEY_CONTROLS.key_map.insert("g", String(KEY_g))
		EG_KEY_CONTROLS.key_map.insert("h", String(KEY_h))
		EG_KEY_CONTROLS.key_map.insert("i", String(KEY_i))
		EG_KEY_CONTROLS.key_map.insert("j", String(KEY_j))
		EG_KEY_CONTROLS.key_map.insert("k", String(KEY_k))
		EG_KEY_CONTROLS.key_map.insert("l", String(KEY_l))
		EG_KEY_CONTROLS.key_map.insert("m", String(KEY_m))
		EG_KEY_CONTROLS.key_map.insert("n", String(KEY_n))
		EG_KEY_CONTROLS.key_map.insert("o", String(KEY_o))
		EG_KEY_CONTROLS.key_map.insert("p", String(KEY_p))
		EG_KEY_CONTROLS.key_map.insert("q", String(KEY_q))
		EG_KEY_CONTROLS.key_map.insert("r", String(KEY_r))
		EG_KEY_CONTROLS.key_map.insert("s", String(KEY_s))
		EG_KEY_CONTROLS.key_map.insert("t", String(KEY_t))
		EG_KEY_CONTROLS.key_map.insert("u", String(KEY_u))
		EG_KEY_CONTROLS.key_map.insert("v", String(KEY_v))
		EG_KEY_CONTROLS.key_map.insert("w", String(KEY_w))
		EG_KEY_CONTROLS.key_map.insert("x", String(KEY_x))
		EG_KEY_CONTROLS.key_map.insert("y", String(KEY_y))
		EG_KEY_CONTROLS.key_map.insert("z", String(KEY_z))
		
		EG_KEY_CONTROLS.key_map.insert("up", String(KEY_up))
		EG_KEY_CONTROLS.key_map.insert("down", String(KEY_down))
		EG_KEY_CONTROLS.key_map.insert("left", String(KEY_left))
		EG_KEY_CONTROLS.key_map.insert("right", String(KEY_right))
		
		EG_KEY_CONTROLS.key_map.insert("+", String(KEY_NUMADD))
		EG_KEY_CONTROLS.key_map.insert("-", String(KEY_NUMSUBTRACT))
		
		EG_KEY_CONTROLS.key_map.insert("LCONTROL", String(KEY_LCONTROL))
		EG_KEY_CONTROLS.key_map.insert("RCONTROL", String(KEY_RCONTROL))
		
		EG_KEY_CONTROLS.key_map.insert("LSHIFT", String(KEY_LSHIFT))
		EG_KEY_CONTROLS.key_map.insert("RSHIFT", String(KEY_RSHIFT))
		
		
		EG_KEY_CONTROLS.last_controlls = New TMap
	End Function
	
	'Field name:String
	Field key:Int
	Field number:Int
	
	Function render()
		For Local name:String = EachIn MapKeys(EG_KEY_CONTROLS.key_map)
			Local k:Int = Int(String(EG_KEY_CONTROLS.key_map.ValueForKey(name)))
			
			Local c:EG_KEY_CONTROLS = EG_KEY_CONTROLS(EG_KEY_CONTROLS.last_controlls.ValueForKey(name))
			
			If c Then
				If KeyHit(k) Then
					c.number = 1
					
					EG_EVENT.list.addlast(c)
				ElseIf KeyDown(k)
					c.number:+ 1
					
					EG_EVENT.list.addlast(c)
				Else
					EG_KEY_CONTROLS.last_controlls.remove(name)
				End If
			Else
				If KeyHit(k) Then
					c = New EG_KEY_CONTROLS
					c.name = name
					c.key = k
					c.number = 1
					
					EG_KEY_CONTROLS.last_controlls.insert(name,c)
					EG_EVENT.list.addlast(c)
				Else
					'nothing
				End If
			End If
		Next
		
		'EG_EVENT.list.addlast(New EG_DELETE)
	End Function
End Type


Type EG_CUT Extends EG_EVENT
	Method New()
		Self.name = "cut"
	End Method
End Type

Type EG_COPY Extends EG_EVENT
	Method New()
		Self.name = "copy"
	End Method
End Type

Type EG_PASTE Extends EG_EVENT
	Method New()
		Self.name = "paste"
	End Method
End Type

Type EG_SAVE Extends EG_EVENT
	Method New()
		Self.name = "save"
	End Method
End Type

Type EG_SELECT_ALL Extends EG_EVENT
	Method New()
		Self.name = "select_all"
	End Method
End Type

Type EG_BACKSPACE Extends EG_EVENT
	Method New()
		Self.name = "backspace"
	End Method
End Type

Type EG_DELETE Extends EG_EVENT
	Method New()
		Self.name = "delete"
	End Method
	
	Global last:Int
	
	Function get_on:Int()
		If KeyHit(key_delete) Then
			EG_DELETE.last = MilliSecs()
			Return 1
		ElseIf KeyDown(key_delete)
			If MilliSecs()-EG_DELETE.last>EG_KEYBOARD.press_delay Then
				EG_DELETE.last = MilliSecs()
				Return 1
			End If
		End If
		
		Return 0
	End Function
End Type

Type EG_ENTER Extends EG_EVENT
	Method New()
		Self.name = "enter"
	End Method
End Type

Type EG_KEY_UP Extends EG_EVENT
	Method New()
		Self.name = "up"
	End Method
	
	Function get_on:Int()
		If KeyHit(key_up) Then
			EG_DELETE.last = MilliSecs()
			Return 1
		ElseIf KeyDown(key_up)
			If MilliSecs()-EG_DELETE.last>EG_KEYBOARD.press_delay Then
				EG_DELETE.last = MilliSecs()
				Return 1
			End If
		End If
		
		Return 0
	End Function
End Type

Type EG_KEY_DOWN Extends EG_EVENT
	Method New()
		Self.name = "down"
	End Method
	
	Function get_on:Int()
		If KeyHit(key_down) Then
			EG_DELETE.last = MilliSecs()
			Return 1
		ElseIf KeyDown(key_down)
			If MilliSecs()-EG_DELETE.last>EG_KEYBOARD.press_delay Then
				EG_DELETE.last = MilliSecs()
				Return 1
			End If
		End If
		
		Return 0
	End Function
End Type

Type EG_KEY_LEFT Extends EG_EVENT
	Method New()
		Self.name = "left"
	End Method
	
	Function get_on:Int()
		If KeyHit(key_left) Then
			EG_DELETE.last = MilliSecs()
			Return 1
		ElseIf KeyDown(key_left)
			If MilliSecs()-EG_DELETE.last>EG_KEYBOARD.press_delay Then
				EG_DELETE.last = MilliSecs()
				Return 1
			End If
		End If
		
		Return 0
	End Function
End Type

Type EG_KEY_RIGHT Extends EG_EVENT
	Method New()
		Self.name = "right"
	End Method
	
	Function get_on:Int()
		If KeyHit(key_right) Then
			EG_DELETE.last = MilliSecs()
			Return 1
		ElseIf KeyDown(key_right)
			If MilliSecs()-EG_DELETE.last>EG_KEYBOARD.press_delay Then
				EG_DELETE.last = MilliSecs()
				Return 1
			End If
		End If
		
		Return 0
	End Function
End Type

Type EG_LETTER Extends EG_EVENT
	Method New()
		Self.name = "letter"
	End Method
	
	Function Create:EG_LETTER(letter:String)
		Local l:EG_LETTER = New EG_LETTER
		
		l.letter = letter
		l.name = "letter_"+l.letter
		
		Return l
	End Function
	
	Field letter:String
End Type

Type EG_MOUSE_OVER Extends EG_EVENT
	Method New()
		Self.name = "mouse_over"
	End Method
	
	Field x:Int
	Field y:Int
	
	Method rel_x:Int(eg_obj:EG_OBJECT)
		Return x-eg_obj.abs_x
	End Method
	
	Method rel_y:Int(eg_obj:EG_OBJECT)
		Return y-eg_obj.abs_y
	End Method
	
	Function Create:EG_MOUSE_OVER(x:Int,y:Int)
		Local e:EG_MOUSE_OVER = New EG_MOUSE_OVER
		e.x = x
		e.y = y
		Return e
	End Function
End Type

Type EG_MOUSE_1_CLICK Extends EG_EVENT
	Method New()
		Self.name = "mouse_1_click"
	End Method
	
	Field x:Int
	Field y:Int
	
	Method rel_x:Int(eg_obj:EG_OBJECT)
		Return x-eg_obj.abs_x
	End Method
	
	Method rel_y:Int(eg_obj:EG_OBJECT)
		Return y-eg_obj.abs_y
	End Method
	
	Function Create:EG_MOUSE_1_CLICK(x:Int,y:Int)
		Local e:EG_MOUSE_1_CLICK = New EG_MOUSE_1_CLICK
		e.x = x
		e.y = y
		Return e
	End Function
End Type

Type EG_MOUSE_2_CLICK Extends EG_EVENT
	Method New()
		Self.name = "mouse_2_click"
	End Method
	
	Field x:Int
	Field y:Int
	
	Method rel_x:Int(eg_obj:EG_OBJECT)
		Return x-eg_obj.abs_x
	End Method
	
	Method rel_y:Int(eg_obj:EG_OBJECT)
		Return y-eg_obj.abs_y
	End Method
	
	Function Create:EG_MOUSE_2_CLICK(x:Int,y:Int)
		Local e:EG_MOUSE_2_CLICK = New EG_MOUSE_2_CLICK
		e.x = x
		e.y = y
		Return e
	End Function
End Type

Type EG_MOUSE_SCROLL Extends EG_EVENT
	Method New()
		Self.name = "mouse_scroll"
	End Method
	
	Field x:Int
	Field y:Int
	Field z:Int
	
	Method rel_x:Int(eg_obj:EG_OBJECT)
		Return x-eg_obj.abs_x
	End Method
	
	Method rel_y:Int(eg_obj:EG_OBJECT)
		Return y-eg_obj.abs_y
	End Method
	
	Function Create:EG_MOUSE_SCROLL(x:Int,y:Int,z:Int)
		Local e:EG_MOUSE_SCROLL = New EG_MOUSE_SCROLL
		e.x = x
		e.y = y
		e.z = z
		Return e
	End Function
End Type

Type EG_MOUSE_SCROLL_SIDE Extends EG_MOUSE_SCROLL
	Method New()
		Self.name = "mouse_scroll_side"
	End Method
	
	Function Create:EG_MOUSE_SCROLL(x:Int,y:Int,z:Int)
		Local e:EG_MOUSE_SCROLL = New EG_MOUSE_SCROLL_SIDE
		e.x = x
		e.y = y
		e.z = z
		Return e
	End Function
End Type

Type EG_MOUSE_SCROLL_ZOOM Extends EG_MOUSE_SCROLL
	Method New()
		Self.name = "mouse_scroll_zoom"
	End Method
	
	Function Create:EG_MOUSE_SCROLL(x:Int,y:Int,z:Int)
		Local e:EG_MOUSE_SCROLL = New EG_MOUSE_SCROLL_ZOOM
		e.x = x
		e.y = y
		e.z = z
		Return e
	End Function
End Type

Type EG_MOUSE_DRAG Extends EG_EVENT
	Method New()
		Self.name = "mouse_drag"
	End Method
	
	Global x:Int
	Global y:Int
	
	Global x_drag:Int
	Global y_drag:Int
	
	Global last:Int
	Global first:Int
	
	Global eg_obj:EG_OBJECT
	
	Method rel_x:Int(eg_obj:EG_OBJECT)
		Return x-eg_obj.abs_x
	End Method
	
	Method rel_y:Int(eg_obj:EG_OBJECT)
		Return y-eg_obj.abs_y
	End Method
	
	Function Create:EG_MOUSE_DRAG(last:Int=0)
		Local e:EG_MOUSE_DRAG = New EG_MOUSE_DRAG
		
		e.last = last
		
		If e.first > 0 Then e.first:-1
		
		e.x = EG_MOUSE.last_x_set
		e.y = EG_MOUSE.last_y_set
		
		e.x_drag = EG_MOUSE.x - EG_MOUSE.last_x_set
		e.y_drag = EG_MOUSE.y - EG_MOUSE.last_y_set
		Return e
	End Function
	
	Method drag(x:Int,y:Int)
		EG_MOUSE.last_x_set:+x
		EG_MOUSE.last_y_set:+y
	End Method
	
	Function reset()
		EG_MOUSE_DRAG.eg_obj = Null
		EG_MOUSE.last_1 = 0
		
		EG_MOUSE_DRAG.first = 2
	End Function
End Type


Rem
	Mouse
	Keys
	terminate parent ?
End Rem


'################### EME GUI MASTER ########################
Type EG_MASTER
	Global screen:EG_SCREEN
	
	Function init(screen:EG_SCREEN)
		EG_MASTER.screen = screen
		
		EG_KEY_CONTROLS.init()
	End Function
	
	Function update()
		EG_KEYBOARD.render()
		EG_MOUSE.render()
		
		EG_MASTER.screen.render_relation(0,0)
		
		EG_EVENT.back(EG_MASTER.screen.render(EG_EVENT.get()))
		
		EG_MASTER.screen.draw()
	End Function
End Type

'##################### CALCULATIONS #########################
Type EG_CALC
	Function inside:Int(rect:Int[],point:Int[])
		If rect.length < 4 Then Return 0
		If point.length < 2 Then Return 0
		
		If point[0]<rect[0] Then Return 0
		If point[1]<rect[1] Then Return 0
		
		If point[0]>rect[2] Then Return 0
		If point[1]>rect[3] Then Return 0
		
		Return 1
	End Function
	
	'EG_CALC.inside([3,3,5,5],[4,4])
End Type

Type COLORS
	Global window:Int[] = [100,100,100]
	Global window_min:Int[] = [0,100,0]
	Global window_close:Int[] = [100,0,0]
	Global window_ri:Int[] = [0,0,0]
	
	Global empty:Int[] = [100,100,100]
	Global area:Int[] = [255,255,255]
	'Global def:Int[] = [255,255,255]
	Global tick:Int[] = [0,0,0]
	Global area_text:Int[] = [0,0,0]
	Global mark:Int[] = [50,50,150]
	Global mark_text:Int[] = [255,255,255]
	Global tab:Int[] = [200,200,200]
	Global separator:Int[] = [150,150,150]
	Global scroll:Int[] = [200,200,200]
	Global screen:Int[] = [200,200,200]
	
	Global taskbar:Int[] = [150,100,50]
	Global taskbar_text_on:Int[] = [0,0,0]
	Global taskbar_text_off:Int[] = [255,255,255]
	
	Global dark_red:Int[] = [100,0,0]
	Global light_red:Int[] = [255,0,0]
	Global dark_blue:Int[] = [0,0,100]
	Global light_blue:Int[] = [50,50,200]
	Global dark_green:Int[] = [0,100,0]
	Global light_green:Int[] = [0,255,0]
	Global orange:Int[] = [255,100,0]
End Type

'################### MAIN PROCESSING #########################

Rem
EG_MASTER.init()

Repeat
	EG_MASTER.update()
Until KeyHit(key_escape) Or AppTerminate()
End Rem
