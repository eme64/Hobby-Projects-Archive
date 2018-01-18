	format	MS COFF
	extrn	___bb_blitz_blitz
	extrn	___bb_glew_glew
	extrn	___bb_glmax2d_glmax2d
	extrn	___bb_standardio_standardio
	extrn	___glewBindFramebufferEXT
	extrn	___glewBindRenderbufferEXT
	extrn	___glewCheckFramebufferStatusEXT
	extrn	___glewFramebufferRenderbufferEXT
	extrn	___glewFramebufferTexture2DEXT
	extrn	___glewGenFramebuffersEXT
	extrn	___glewGenRenderbuffersEXT
	extrn	___glewRenderbufferStorageEXT
	extrn	_bbArrayNew1D
	extrn	_bbEnd
	extrn	_bbGCFree
	extrn	_bbNullObject
	extrn	_bbObjectClass
	extrn	_bbObjectCompare
	extrn	_bbObjectCtor
	extrn	_bbObjectDowncast
	extrn	_bbObjectFree
	extrn	_bbObjectNew
	extrn	_bbObjectRegisterType
	extrn	_bbObjectReserved
	extrn	_bbObjectSendMessage
	extrn	_bbObjectToString
	extrn	_bbStringClass
	extrn	_brl_blitz_RuntimeError
	extrn	_brl_glmax2d_GLMax2DDriver
	extrn	_brl_glmax2d_TGLImageFrame
	extrn	_brl_graphics_Graphics
	extrn	_brl_graphics_SetGraphicsDriver
	extrn	_brl_max2d_GetViewport
	extrn	_brl_standardio_Print
	extrn	_glBindTexture@8
	extrn	_glClear@4
	extrn	_glClearColor@16
	extrn	_glGetTexLevelParameteriv@16
	extrn	_glLoadIdentity@0
	extrn	_glMatrixMode@4
	extrn	_glOrtho@48
	extrn	_glScissor@16
	extrn	_glTexImage2D@36
	extrn	_glViewport@16
	extrn	_glewInit
	public	___bb_modules_lights
	public	__bb_TImageBuffer_BindBuffer
	public	__bb_TImageBuffer_BufferHeight
	public	__bb_TImageBuffer_BufferWidth
	public	__bb_TImageBuffer_Cls
	public	__bb_TImageBuffer_Delete
	public	__bb_TImageBuffer_GenerateFBO
	public	__bb_TImageBuffer_Init
	public	__bb_TImageBuffer_New
	public	__bb_TImageBuffer_SetBuffer
	public	__bb_TImageBuffer_UnBindBuffer
	public	_bb_AdjustTexSize
	public	_bb_Pow2Size
	public	_bb_TImageBuffer
	section	"code" code
___bb_modules_lights:
	push	ebp
	mov	ebp,esp
	cmp	dword [_87],0
	je	_88
	mov	eax,0
	mov	esp,ebp
	pop	ebp
	ret
_88:
	mov	dword [_87],1
	call	___bb_blitz_blitz
	call	___bb_glmax2d_glmax2d
	call	___bb_glew_glew
	call	___bb_standardio_standardio
	push	_bb_TImageBuffer
	call	_bbObjectRegisterType
	add	esp,4
	mov	eax,0
	jmp	_40
_40:
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_New:
	push	ebp
	mov	ebp,esp
	push	ebx
	mov	ebx,dword [ebp+8]
	push	ebx
	call	_bbObjectCtor
	add	esp,4
	mov	dword [ebx],_bb_TImageBuffer
	mov	eax,_bbNullObject
	inc	dword [eax+4]
	mov	dword [ebx+8],eax
	push	1
	push	_90
	call	_bbArrayNew1D
	add	esp,8
	inc	dword [eax+4]
	mov	dword [ebx+12],eax
	push	1
	push	_92
	call	_bbArrayNew1D
	add	esp,8
	inc	dword [eax+4]
	mov	dword [ebx+16],eax
	mov	eax,_bbNullObject
	inc	dword [eax+4]
	mov	dword [ebx+20],eax
	mov	dword [ebx+24],0
	mov	dword [ebx+28],0
	mov	dword [ebx+32],0
	mov	dword [ebx+36],0
	mov	dword [ebx+40],0
	mov	eax,0
	jmp	_43
_43:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_Delete:
	push	ebp
	mov	ebp,esp
	push	ebx
	mov	ebx,dword [ebp+8]
_46:
	mov	eax,dword [ebx+20]
	dec	dword [eax+4]
	jnz	_97
	push	eax
	call	_bbGCFree
	add	esp,4
_97:
	mov	eax,dword [ebx+16]
	dec	dword [eax+4]
	jnz	_99
	push	eax
	call	_bbGCFree
	add	esp,4
_99:
	mov	eax,dword [ebx+12]
	dec	dword [eax+4]
	jnz	_101
	push	eax
	call	_bbGCFree
	add	esp,4
_101:
	mov	eax,dword [ebx+8]
	dec	dword [eax+4]
	jnz	_103
	push	eax
	call	_bbGCFree
	add	esp,4
_103:
	mov	eax,0
	jmp	_95
_95:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_SetBuffer:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	esi
	push	edi
	mov	esi,dword [ebp+8]
	mov	edi,dword [ebp+12]
	push	_bb_TImageBuffer
	call	_bbObjectNew
	add	esp,4
	mov	ebx,eax
	mov	eax,esi
	inc	dword [eax+4]
	mov	esi,eax
	mov	eax,dword [ebx+8]
	dec	dword [eax+4]
	jnz	_108
	push	eax
	call	_bbGCFree
	add	esp,4
_108:
	mov	dword [ebx+8],esi
	mov	dword [ebx+24],edi
	mov	eax,ebx
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+56]
	add	esp,4
	mov	eax,ebx
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+60]
	add	esp,4
	mov	eax,ebx
	jmp	_50
_50:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_Init:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	esi
	push	edi
	mov	esi,dword [ebp+8]
	mov	ebx,dword [ebp+12]
	mov	edi,dword [ebp+16]
	push	2
	call	_brl_glmax2d_GLMax2DDriver
	push	eax
	call	_brl_graphics_SetGraphicsDriver
	add	esp,8
	push	0
	push	dword [ebp+20]
	push	edi
	push	ebx
	push	esi
	call	_brl_graphics_Graphics
	add	esp,20
	call	_glewInit
	mov	eax,0
	jmp	_56
_56:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_GenerateFBO:
	push	ebp
	mov	ebp,esp
	sub	esp,8
	push	ebx
	push	esi
	push	edi
	mov	ebx,dword [ebp+8]
	mov	eax,dword [ebx+8]
	push	_brl_glmax2d_TGLImageFrame
	push	dword [ebx+24]
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+52]
	add	esp,8
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	inc	dword [eax+4]
	mov	esi,eax
	mov	eax,dword [ebx+20]
	dec	dword [eax+4]
	jnz	_115
	push	eax
	call	_bbGCFree
	add	esp,4
_115:
	mov	dword [ebx+20],esi
	mov	edx,dword [ebx+20]
	mov	eax,dword [ebx+20]
	fld	dword [eax+20]
	fstp	dword [edx+12]
	mov	eax,dword [ebx+20]
	fldz
	fstp	dword [eax+20]
	mov	eax,dword [ebx+8]
	mov	eax,dword [eax+8]
	mov	dword [ebp-4],eax
	mov	eax,dword [ebx+8]
	mov	eax,dword [eax+12]
	mov	dword [ebp-8],eax
	lea	eax,dword [ebp-8]
	push	eax
	lea	eax,dword [ebp-4]
	push	eax
	call	_bb_AdjustTexSize
	add	esp,8
	mov	eax,dword [ebx+16]
	lea	eax,dword [eax+24]
	push	eax
	push	1
	call	dword [___glewGenFramebuffersEXT]
	mov	eax,dword [ebx+12]
	lea	eax,dword [eax+24]
	push	eax
	push	1
	call	dword [___glewGenRenderbuffersEXT]
	mov	eax,dword [ebx+20]
	push	dword [eax+32]
	push	3553
	call	_glBindTexture@8
	mov	eax,dword [ebx+16]
	push	dword [eax+24]
	push	36160
	call	dword [___glewBindFramebufferEXT]
	push	0
	mov	eax,dword [ebx+20]
	push	dword [eax+32]
	push	3553
	push	36064
	push	36160
	call	dword [___glewFramebufferTexture2DEXT]
	mov	eax,dword [ebx+12]
	push	dword [eax+24]
	push	36161
	call	dword [___glewBindRenderbufferEXT]
	push	dword [ebp-8]
	push	dword [ebp-4]
	push	33190
	push	36161
	call	dword [___glewRenderbufferStorageEXT]
	mov	eax,dword [ebx+12]
	push	dword [eax+24]
	push	36161
	push	36096
	push	36160
	call	dword [___glewFramebufferRenderbufferEXT]
	push	36160
	call	dword [___glewCheckFramebufferStatusEXT]
	cmp	eax,36053
	je	_121
	cmp	eax,36061
	je	_122
	call	_bbEnd
	jmp	_120
_121:
	jmp	_120
_122:
	push	_3
	call	_brl_standardio_Print
	add	esp,4
	jmp	_120
_120:
	mov	eax,0
	jmp	_59
_59:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_BindBuffer:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	push	esi
	push	edi
	mov	ebx,dword [ebp+8]
	lea	eax,dword [ebx+40]
	push	eax
	lea	eax,dword [ebx+36]
	push	eax
	lea	eax,dword [ebx+32]
	push	eax
	lea	eax,dword [ebx+28]
	push	eax
	call	_brl_max2d_GetViewport
	add	esp,16
	mov	eax,dword [ebx+16]
	push	dword [eax+24]
	push	36160
	call	dword [___glewBindFramebufferEXT]
	push	5889
	call	_glMatrixMode@4
	call	_glLoadIdentity@0
	fld1
	sub	esp,8
	fstp	qword [esp]
	fld	qword [_147]
	sub	esp,8
	fstp	qword [esp]
	fldz
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebx+8]
	mov	eax,dword [eax+8]
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebx+8]
	mov	eax,dword [eax+8]
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	sub	esp,8
	fstp	qword [esp]
	fldz
	sub	esp,8
	fstp	qword [esp]
	call	_glOrtho@48
	push	5888
	call	_glMatrixMode@4
	mov	eax,dword [ebx+8]
	push	dword [eax+12]
	mov	eax,dword [ebx+8]
	push	dword [eax+8]
	push	0
	push	0
	call	_glViewport@16
	mov	eax,dword [ebx+8]
	push	dword [eax+12]
	mov	eax,dword [ebx+8]
	push	dword [eax+8]
	push	0
	push	0
	call	_glScissor@16
	mov	eax,0
	jmp	_62
_62:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_UnBindBuffer:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	push	esi
	push	edi
	mov	ebx,dword [ebp+8]
	push	0
	push	36160
	call	dword [___glewBindFramebufferEXT]
	push	5889
	call	_glMatrixMode@4
	call	_glLoadIdentity@0
	fld1
	sub	esp,8
	fstp	qword [esp]
	fld	qword [_150]
	sub	esp,8
	fstp	qword [esp]
	fldz
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebx+40]
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebx+36]
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	sub	esp,8
	fstp	qword [esp]
	fldz
	sub	esp,8
	fstp	qword [esp]
	call	_glOrtho@48
	push	5888
	call	_glMatrixMode@4
	push	dword [ebx+40]
	push	dword [ebx+36]
	push	0
	push	0
	call	_glViewport@16
	push	dword [ebx+40]
	push	dword [ebx+36]
	push	0
	push	0
	call	_glScissor@16
	mov	eax,0
	jmp	_65
_65:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_Cls:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	esi
	push	edi
	fld	dword [ebp+12]
	fld	dword [ebp+16]
	fld	dword [ebp+20]
	fld	dword [ebp+24]
	sub	esp,4
	fstp	dword [esp]
	sub	esp,4
	fstp	dword [esp]
	sub	esp,4
	fstp	dword [esp]
	sub	esp,4
	fstp	dword [esp]
	call	_glClearColor@16
	push	16640
	call	_glClear@4
	mov	eax,0
	jmp	_72
_72:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_BufferWidth:
	push	ebp
	mov	ebp,esp
	mov	eax,dword [ebp+8]
	mov	eax,dword [eax+8]
	mov	eax,dword [eax+8]
	jmp	_75
_75:
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_BufferHeight:
	push	ebp
	mov	ebp,esp
	mov	eax,dword [ebp+8]
	mov	eax,dword [eax+8]
	mov	eax,dword [eax+12]
	jmp	_78
_78:
	mov	esp,ebp
	pop	ebp
	ret
_bb_AdjustTexSize:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	push	esi
	push	edi
	mov	esi,dword [ebp+8]
	mov	ebx,dword [ebp+12]
	push	dword [esi]
	call	_bb_Pow2Size
	add	esp,4
	mov	dword [esi],eax
	push	dword [ebx]
	call	_bb_Pow2Size
	add	esp,4
	mov	dword [ebx],eax
_6:
_4:
	mov	dword [ebp-4],0
	push	0
	push	5121
	push	6408
	push	0
	push	dword [ebx]
	push	dword [esi]
	push	4
	push	0
	push	32868
	call	_glTexImage2D@36
	lea	eax,dword [ebp-4]
	push	eax
	push	4096
	push	0
	push	32868
	call	_glGetTexLevelParameteriv@16
	cmp	dword [ebp-4],0
	je	_124
	mov	eax,0
	jmp	_82
_124:
	mov	eax,dword [esi]
	cmp	eax,1
	sete	al
	movzx	eax,al
	cmp	eax,0
	je	_125
	mov	eax,dword [ebx]
	cmp	eax,1
	sete	al
	movzx	eax,al
_125:
	cmp	eax,0
	je	_127
	push	_7
	call	_brl_blitz_RuntimeError
	add	esp,4
_127:
	cmp	dword [esi],1
	jle	_128
	mov	eax,dword [esi]
	cdq
	and	edx,1
	add	eax,edx
	sar	eax,1
	mov	dword [esi],eax
_128:
	cmp	dword [ebx],1
	jle	_129
	mov	eax,dword [ebx]
	cdq
	and	edx,1
	add	eax,edx
	sar	eax,1
	mov	dword [ebx],eax
_129:
	jmp	_6
_82:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_bb_Pow2Size:
	push	ebp
	mov	ebp,esp
	mov	edx,dword [ebp+8]
	mov	eax,1
	jmp	_8
_10:
	shl	eax,1
_8:
	cmp	eax,edx
	jl	_10
_9:
	jmp	_85
_85:
	mov	esp,ebp
	pop	ebp
	ret
	section	"data" data writeable align 8
	align	4
_87:
	dd	0
_12:
	db	"TImageBuffer",0
_13:
	db	"Image",0
_14:
	db	":TImage",0
_15:
	db	"rb",0
_16:
	db	"[]i",0
_17:
	db	"fb",0
_18:
	db	"Imageframe",0
_19:
	db	":TGLImageframe",0
_20:
	db	"Frame",0
_21:
	db	"i",0
_22:
	db	"OrigX",0
_23:
	db	"OrigY",0
_24:
	db	"OrigW",0
_25:
	db	"OrigH",0
_26:
	db	"New",0
_27:
	db	"()i",0
_28:
	db	"Delete",0
_29:
	db	"SetBuffer",0
_30:
	db	"(:TImage,i):TImageBuffer",0
_31:
	db	"Init",0
_32:
	db	"(i,i,i,i)i",0
_33:
	db	"GenerateFBO",0
_34:
	db	"BindBuffer",0
_35:
	db	"UnBindBuffer",0
_36:
	db	"Cls",0
_37:
	db	"(f,f,f,f)i",0
_38:
	db	"BufferWidth",0
_39:
	db	"BufferHeight",0
	align	4
_11:
	dd	2
	dd	_12
	dd	3
	dd	_13
	dd	_14
	dd	8
	dd	3
	dd	_15
	dd	_16
	dd	12
	dd	3
	dd	_17
	dd	_16
	dd	16
	dd	3
	dd	_18
	dd	_19
	dd	20
	dd	3
	dd	_20
	dd	_21
	dd	24
	dd	3
	dd	_22
	dd	_21
	dd	28
	dd	3
	dd	_23
	dd	_21
	dd	32
	dd	3
	dd	_24
	dd	_21
	dd	36
	dd	3
	dd	_25
	dd	_21
	dd	40
	dd	6
	dd	_26
	dd	_27
	dd	16
	dd	6
	dd	_28
	dd	_27
	dd	20
	dd	7
	dd	_29
	dd	_30
	dd	48
	dd	7
	dd	_31
	dd	_32
	dd	52
	dd	6
	dd	_33
	dd	_27
	dd	56
	dd	6
	dd	_34
	dd	_27
	dd	60
	dd	6
	dd	_35
	dd	_27
	dd	64
	dd	6
	dd	_36
	dd	_37
	dd	68
	dd	6
	dd	_38
	dd	_27
	dd	72
	dd	6
	dd	_39
	dd	_27
	dd	76
	dd	0
	align	4
_bb_TImageBuffer:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_11
	dd	44
	dd	__bb_TImageBuffer_New
	dd	__bb_TImageBuffer_Delete
	dd	_bbObjectToString
	dd	_bbObjectCompare
	dd	_bbObjectSendMessage
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	__bb_TImageBuffer_SetBuffer
	dd	__bb_TImageBuffer_Init
	dd	__bb_TImageBuffer_GenerateFBO
	dd	__bb_TImageBuffer_BindBuffer
	dd	__bb_TImageBuffer_UnBindBuffer
	dd	__bb_TImageBuffer_Cls
	dd	__bb_TImageBuffer_BufferWidth
	dd	__bb_TImageBuffer_BufferHeight
_90:
	db	"i",0
_92:
	db	"i",0
	align	4
_3:
	dd	_bbStringClass
	dd	2147483647
	dd	24
	dw	99,104,111,111,115,101,32,100,105,102,102,101,114,101,110,116
	dw	32,102,111,114,109,97,116,115
	align	8
_147:
	dd	0x0,0xbff00000
	align	8
_150:
	dd	0x0,0xbff00000
	align	4
_7:
	dd	_bbStringClass
	dd	2147483647
	dd	28
	dw	85,110,97,98,108,101,32,116,111,32,99,97,108,99,117,108
	dw	97,116,101,32,116,101,120,32,115,105,122,101
