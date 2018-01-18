	format	ELF
	extrn	__bb_blitz_blitz
	extrn	__bb_glew_glew
	extrn	__bb_glmax2d_glmax2d
	extrn	__bb_standardio_standardio
	extrn	__glewBindFramebufferEXT
	extrn	__glewBindRenderbufferEXT
	extrn	__glewCheckFramebufferStatusEXT
	extrn	__glewFramebufferRenderbufferEXT
	extrn	__glewFramebufferTexture2DEXT
	extrn	__glewGenFramebuffersEXT
	extrn	__glewGenRenderbuffersEXT
	extrn	__glewRenderbufferStorageEXT
	extrn	bbArrayNew1D
	extrn	bbEnd
	extrn	bbNullObject
	extrn	bbObjectClass
	extrn	bbObjectCompare
	extrn	bbObjectCtor
	extrn	bbObjectDowncast
	extrn	bbObjectDtor
	extrn	bbObjectFree
	extrn	bbObjectNew
	extrn	bbObjectRegisterType
	extrn	bbObjectReserved
	extrn	bbObjectSendMessage
	extrn	bbObjectToString
	extrn	bbOnDebugEnterScope
	extrn	bbOnDebugEnterStm
	extrn	bbOnDebugLeaveScope
	extrn	bbStringClass
	extrn	brl_blitz_ArrayBoundsError
	extrn	brl_blitz_NullObjectError
	extrn	brl_blitz_RuntimeError
	extrn	brl_glmax2d_GLMax2DDriver
	extrn	brl_glmax2d_TGLImageFrame
	extrn	brl_graphics_Graphics
	extrn	brl_graphics_SetGraphicsDriver
	extrn	brl_max2d_GetViewport
	extrn	brl_standardio_Print
	extrn	glBindTexture
	extrn	glClear
	extrn	glClearColor
	extrn	glGetTexLevelParameteriv
	extrn	glLoadIdentity
	extrn	glMatrixMode
	extrn	glOrtho
	extrn	glScissor
	extrn	glTexImage2D
	extrn	glViewport
	extrn	glewInit
	public	__bb_modules_lights
	public	_bb_TImageBuffer_BindBuffer
	public	_bb_TImageBuffer_BufferHeight
	public	_bb_TImageBuffer_BufferWidth
	public	_bb_TImageBuffer_Cls
	public	_bb_TImageBuffer_GenerateFBO
	public	_bb_TImageBuffer_Init
	public	_bb_TImageBuffer_New
	public	_bb_TImageBuffer_SetBuffer
	public	_bb_TImageBuffer_UnBindBuffer
	public	bb_AdjustTexSize
	public	bb_Pow2Size
	public	bb_TImageBuffer
	section	"code" executable
__bb_modules_lights:
	push	ebp
	mov	ebp,esp
	push	ebx
	cmp	dword [_85],0
	je	_86
	mov	eax,0
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_86:
	mov	dword [_85],1
	push	ebp
	push	_83
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	call	__bb_blitz_blitz
	call	__bb_glmax2d_glmax2d
	call	__bb_glew_glew
	call	__bb_standardio_standardio
	push	bb_TImageBuffer
	call	bbObjectRegisterType
	add	esp,4
	mov	ebx,0
	jmp	_39
_39:
	call	dword [bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_bb_TImageBuffer_New:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_90
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	dword [ebp-4]
	call	bbObjectCtor
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [eax],bb_TImageBuffer
	mov	eax,dword [ebp-4]
	mov	dword [eax+8],bbNullObject
	mov	ebx,dword [ebp-4]
	push	1
	push	_87
	call	bbArrayNew1D
	add	esp,8
	mov	dword [ebx+12],eax
	mov	ebx,dword [ebp-4]
	push	1
	push	_88
	call	bbArrayNew1D
	add	esp,8
	mov	dword [ebx+16],eax
	mov	eax,dword [ebp-4]
	mov	dword [eax+20],bbNullObject
	mov	eax,dword [ebp-4]
	mov	dword [eax+24],0
	mov	eax,dword [ebp-4]
	mov	dword [eax+28],0
	mov	eax,dword [ebp-4]
	mov	dword [eax+32],0
	mov	eax,dword [ebp-4]
	mov	dword [eax+36],0
	mov	eax,dword [ebp-4]
	mov	dword [eax+40],0
	push	ebp
	push	_89
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	call	dword [bbOnDebugLeaveScope]
	mov	ebx,0
	jmp	_42
_42:
	call	dword [bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_bb_TImageBuffer_SetBuffer:
	push	ebp
	mov	ebp,esp
	sub	esp,12
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	eax,dword [ebp+12]
	mov	dword [ebp-8],eax
	mov	dword [ebp-12],bbNullObject
	push	ebp
	push	_111
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_93
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	push	bb_TImageBuffer
	call	bbObjectNew
	add	esp,4
	mov	dword [ebp-12],eax
	push	_96
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-12]
	cmp	ebx,bbNullObject
	jne	_98
	call	brl_blitz_NullObjectError
_98:
	mov	eax,dword [ebp-4]
	mov	dword [ebx+8],eax
	push	_100
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-12]
	cmp	ebx,bbNullObject
	jne	_102
	call	brl_blitz_NullObjectError
_102:
	mov	eax,dword [ebp-8]
	mov	dword [ebx+24],eax
	push	_104
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-12]
	cmp	ebx,bbNullObject
	jne	_106
	call	brl_blitz_NullObjectError
_106:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+56]
	add	esp,4
	push	_107
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-12]
	cmp	ebx,bbNullObject
	jne	_109
	call	brl_blitz_NullObjectError
_109:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+60]
	add	esp,4
	push	_110
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-12]
	jmp	_46
_46:
	call	dword [bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_bb_TImageBuffer_Init:
	push	ebp
	mov	ebp,esp
	sub	esp,16
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	eax,dword [ebp+12]
	mov	dword [ebp-8],eax
	mov	eax,dword [ebp+16]
	mov	dword [ebp-12],eax
	mov	eax,dword [ebp+20]
	mov	dword [ebp-16],eax
	push	ebp
	push	_116
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_113
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	push	2
	call	brl_glmax2d_GLMax2DDriver
	push	eax
	call	brl_graphics_SetGraphicsDriver
	add	esp,8
	push	_114
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	dword [ebp-16]
	push	dword [ebp-12]
	push	dword [ebp-8]
	push	dword [ebp-4]
	call	brl_graphics_Graphics
	add	esp,20
	push	_115
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	call	glewInit
	mov	ebx,0
	jmp	_52
_52:
	call	dword [bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_bb_TImageBuffer_GenerateFBO:
	push	ebp
	mov	ebp,esp
	sub	esp,24
	push	ebx
	push	esi
	push	edi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	dword [ebp-8],0
	mov	dword [ebp-12],0
	mov	dword [ebp-16],0
	mov	eax,ebp
	push	eax
	push	_209
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_121
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_123
	call	brl_blitz_NullObjectError
_123:
	mov	edi,ebx
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_126
	call	brl_blitz_NullObjectError
_126:
	mov	esi,dword [ebx+8]
	cmp	esi,bbNullObject
	jne	_128
	call	brl_blitz_NullObjectError
_128:
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_130
	call	brl_blitz_NullObjectError
_130:
	push	brl_glmax2d_TGLImageFrame
	push	dword [ebx+24]
	push	esi
	mov	eax,dword [esi]
	call	dword [eax+52]
	add	esp,8
	push	eax
	call	bbObjectDowncast
	add	esp,8
	mov	dword [edi+20],eax
	push	_131
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_133
	call	brl_blitz_NullObjectError
_133:
	mov	ebx,dword [ebx+20]
	cmp	ebx,bbNullObject
	jne	_135
	call	brl_blitz_NullObjectError
_135:
	mov	esi,dword [ebp-4]
	cmp	esi,bbNullObject
	jne	_138
	call	brl_blitz_NullObjectError
_138:
	mov	esi,dword [esi+20]
	cmp	esi,bbNullObject
	jne	_140
	call	brl_blitz_NullObjectError
_140:
	fld	dword [esi+20]
	fstp	dword [ebx+12]
	push	_141
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_143
	call	brl_blitz_NullObjectError
_143:
	mov	ebx,dword [ebx+20]
	cmp	ebx,bbNullObject
	jne	_145
	call	brl_blitz_NullObjectError
_145:
	fldz
	fstp	dword [ebx+20]
	push	_147
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_149
	call	brl_blitz_NullObjectError
_149:
	mov	ebx,dword [ebx+8]
	cmp	ebx,bbNullObject
	jne	_151
	call	brl_blitz_NullObjectError
_151:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-8],eax
	push	_153
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_155
	call	brl_blitz_NullObjectError
_155:
	mov	ebx,dword [ebx+8]
	cmp	ebx,bbNullObject
	jne	_157
	call	brl_blitz_NullObjectError
_157:
	mov	eax,dword [ebx+12]
	mov	dword [ebp-12],eax
	push	_159
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	lea	eax,dword [ebp-12]
	push	eax
	lea	eax,dword [ebp-8]
	push	eax
	call	bb_AdjustTexSize
	add	esp,8
	push	_160
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_162
	call	brl_blitz_NullObjectError
_162:
	mov	eax,dword [ebx+16]
	mov	dword [ebp-20],eax
	mov	eax,dword [ebp-20]
	lea	eax,dword [eax+24]
	push	eax
	push	1
	call	dword [__glewGenFramebuffersEXT]
	add	esp,8
	push	_164
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_166
	call	brl_blitz_NullObjectError
_166:
	mov	eax,dword [ebx+12]
	mov	dword [ebp-24],eax
	mov	eax,dword [ebp-24]
	lea	eax,dword [eax+24]
	push	eax
	push	1
	call	dword [__glewGenRenderbuffersEXT]
	add	esp,8
	push	_168
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_170
	call	brl_blitz_NullObjectError
_170:
	mov	ebx,dword [ebx+20]
	cmp	ebx,bbNullObject
	jne	_172
	call	brl_blitz_NullObjectError
_172:
	push	dword [ebx+32]
	push	3553
	call	glBindTexture
	add	esp,8
	push	_173
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_175
	call	brl_blitz_NullObjectError
_175:
	mov	esi,dword [ebx+16]
	mov	ebx,0
	cmp	ebx,dword [esi+20]
	jb	_178
	call	brl_blitz_ArrayBoundsError
_178:
	push	dword [esi+ebx*4+24]
	push	36160
	call	dword [__glewBindFramebufferEXT]
	add	esp,8
	push	_179
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_181
	call	brl_blitz_NullObjectError
_181:
	mov	ebx,dword [ebx+20]
	cmp	ebx,bbNullObject
	jne	_183
	call	brl_blitz_NullObjectError
_183:
	push	0
	push	dword [ebx+32]
	push	3553
	push	36064
	push	36160
	call	dword [__glewFramebufferTexture2DEXT]
	add	esp,20
	push	_184
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_186
	call	brl_blitz_NullObjectError
_186:
	mov	esi,dword [ebx+12]
	mov	ebx,0
	cmp	ebx,dword [esi+20]
	jb	_189
	call	brl_blitz_ArrayBoundsError
_189:
	push	dword [esi+ebx*4+24]
	push	36161
	call	dword [__glewBindRenderbufferEXT]
	add	esp,8
	push	_190
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	push	dword [ebp-12]
	push	dword [ebp-8]
	push	33190
	push	36161
	call	dword [__glewRenderbufferStorageEXT]
	add	esp,16
	push	_191
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_193
	call	brl_blitz_NullObjectError
_193:
	mov	esi,dword [ebx+12]
	mov	ebx,0
	cmp	ebx,dword [esi+20]
	jb	_196
	call	brl_blitz_ArrayBoundsError
_196:
	push	dword [esi+ebx*4+24]
	push	36161
	push	36096
	push	36160
	call	dword [__glewFramebufferRenderbufferEXT]
	add	esp,16
	push	_197
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	push	36160
	call	dword [__glewCheckFramebufferStatusEXT]
	add	esp,4
	mov	dword [ebp-16],eax
	push	_199
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-16]
	cmp	eax,36053
	je	_202
	cmp	eax,36061
	je	_203
	mov	eax,ebp
	push	eax
	push	_205
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_204
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	call	bbEnd
	call	dword [bbOnDebugLeaveScope]
	jmp	_201
_202:
	mov	eax,ebp
	push	eax
	push	_206
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	call	dword [bbOnDebugLeaveScope]
	jmp	_201
_203:
	mov	eax,ebp
	push	eax
	push	_208
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_207
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	push	_3
	call	brl_standardio_Print
	add	esp,4
	call	dword [bbOnDebugLeaveScope]
	jmp	_201
_201:
	mov	ebx,0
	jmp	_55
_55:
	call	dword [bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_bb_TImageBuffer_BindBuffer:
	push	ebp
	mov	ebp,esp
	sub	esp,12
	push	ebx
	push	esi
	push	edi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	eax,ebp
	push	eax
	push	_258
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_213
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [ebp-8],eax
	cmp	dword [ebp-8],bbNullObject
	jne	_215
	call	brl_blitz_NullObjectError
_215:
	mov	edi,dword [ebp-4]
	cmp	edi,bbNullObject
	jne	_217
	call	brl_blitz_NullObjectError
_217:
	mov	esi,dword [ebp-4]
	cmp	esi,bbNullObject
	jne	_219
	call	brl_blitz_NullObjectError
_219:
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_221
	call	brl_blitz_NullObjectError
_221:
	lea	eax,dword [ebx+40]
	push	eax
	lea	eax,dword [esi+36]
	push	eax
	lea	eax,dword [edi+32]
	push	eax
	mov	eax,dword [ebp-8]
	lea	eax,dword [eax+28]
	push	eax
	call	brl_max2d_GetViewport
	add	esp,16
	push	_222
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_224
	call	brl_blitz_NullObjectError
_224:
	mov	esi,dword [ebx+16]
	mov	ebx,0
	cmp	ebx,dword [esi+20]
	jb	_227
	call	brl_blitz_ArrayBoundsError
_227:
	push	dword [esi+ebx*4+24]
	push	36160
	call	dword [__glewBindFramebufferEXT]
	add	esp,8
	push	_228
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	push	5889
	call	glMatrixMode
	add	esp,4
	push	_229
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	call	glLoadIdentity
	push	_230
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_232
	call	brl_blitz_NullObjectError
_232:
	mov	ebx,dword [ebx+8]
	cmp	ebx,bbNullObject
	jne	_234
	call	brl_blitz_NullObjectError
_234:
	mov	esi,dword [ebp-4]
	cmp	esi,bbNullObject
	jne	_236
	call	brl_blitz_NullObjectError
_236:
	mov	esi,dword [esi+8]
	cmp	esi,bbNullObject
	jne	_238
	call	brl_blitz_NullObjectError
_238:
	fld1
	sub	esp,8
	fstp	qword [esp]
	fld	qword [_383]
	sub	esp,8
	fstp	qword [esp]
	fldz
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [esi+8]
	mov	dword [ebp+-12],eax
	fild	dword [ebp+-12]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebx+8]
	mov	dword [ebp+-12],eax
	fild	dword [ebp+-12]
	sub	esp,8
	fstp	qword [esp]
	fldz
	sub	esp,8
	fstp	qword [esp]
	call	glOrtho
	add	esp,48
	push	_239
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	push	5888
	call	glMatrixMode
	add	esp,4
	push	_240
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_242
	call	brl_blitz_NullObjectError
_242:
	mov	ebx,dword [ebx+8]
	cmp	ebx,bbNullObject
	jne	_244
	call	brl_blitz_NullObjectError
_244:
	mov	esi,dword [ebp-4]
	cmp	esi,bbNullObject
	jne	_246
	call	brl_blitz_NullObjectError
_246:
	mov	esi,dword [esi+8]
	cmp	esi,bbNullObject
	jne	_248
	call	brl_blitz_NullObjectError
_248:
	push	dword [esi+12]
	push	dword [ebx+8]
	push	0
	push	0
	call	glViewport
	add	esp,16
	push	_249
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_251
	call	brl_blitz_NullObjectError
_251:
	mov	ebx,dword [ebx+8]
	cmp	ebx,bbNullObject
	jne	_253
	call	brl_blitz_NullObjectError
_253:
	mov	esi,dword [ebp-4]
	cmp	esi,bbNullObject
	jne	_255
	call	brl_blitz_NullObjectError
_255:
	mov	esi,dword [esi+8]
	cmp	esi,bbNullObject
	jne	_257
	call	brl_blitz_NullObjectError
_257:
	push	dword [esi+12]
	push	dword [ebx+8]
	push	0
	push	0
	call	glScissor
	add	esp,16
	mov	ebx,0
	jmp	_58
_58:
	call	dword [bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_bb_TImageBuffer_UnBindBuffer:
	push	ebp
	mov	ebp,esp
	sub	esp,8
	push	ebx
	push	esi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_278
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_259
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	36160
	call	dword [__glewBindFramebufferEXT]
	add	esp,8
	push	_260
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	push	5889
	call	glMatrixMode
	add	esp,4
	push	_261
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	call	glLoadIdentity
	push	_262
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_264
	call	brl_blitz_NullObjectError
_264:
	mov	esi,dword [ebp-4]
	cmp	esi,bbNullObject
	jne	_266
	call	brl_blitz_NullObjectError
_266:
	fld1
	sub	esp,8
	fstp	qword [esp]
	fld	qword [_404]
	sub	esp,8
	fstp	qword [esp]
	fldz
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [esi+40]
	mov	dword [ebp+-8],eax
	fild	dword [ebp+-8]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebx+36]
	mov	dword [ebp+-8],eax
	fild	dword [ebp+-8]
	sub	esp,8
	fstp	qword [esp]
	fldz
	sub	esp,8
	fstp	qword [esp]
	call	glOrtho
	add	esp,48
	push	_267
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	push	5888
	call	glMatrixMode
	add	esp,4
	push	_268
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-4]
	cmp	esi,bbNullObject
	jne	_270
	call	brl_blitz_NullObjectError
_270:
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_272
	call	brl_blitz_NullObjectError
_272:
	push	dword [ebx+40]
	push	dword [esi+36]
	push	0
	push	0
	call	glViewport
	add	esp,16
	push	_273
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-4]
	cmp	esi,bbNullObject
	jne	_275
	call	brl_blitz_NullObjectError
_275:
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_277
	call	brl_blitz_NullObjectError
_277:
	push	dword [ebx+40]
	push	dword [esi+36]
	push	0
	push	0
	call	glScissor
	add	esp,16
	mov	ebx,0
	jmp	_61
_61:
	call	dword [bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_bb_TImageBuffer_Cls:
	push	ebp
	mov	ebp,esp
	sub	esp,20
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	fld	dword [ebp+12]
	fstp	dword [ebp-8]
	fld	dword [ebp+16]
	fstp	dword [ebp-12]
	fld	dword [ebp+20]
	fstp	dword [ebp-16]
	fld	dword [ebp+24]
	fstp	dword [ebp-20]
	push	ebp
	push	_281
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_279
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	push	dword [ebp-20]
	push	dword [ebp-16]
	push	dword [ebp-12]
	push	dword [ebp-8]
	call	glClearColor
	add	esp,16
	push	_280
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	push	16640
	call	glClear
	add	esp,4
	mov	ebx,0
	jmp	_68
_68:
	call	dword [bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_bb_TImageBuffer_BufferWidth:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_292
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_287
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_289
	call	brl_blitz_NullObjectError
_289:
	mov	ebx,dword [ebx+8]
	cmp	ebx,bbNullObject
	jne	_291
	call	brl_blitz_NullObjectError
_291:
	mov	ebx,dword [ebx+8]
	jmp	_71
_71:
	call	dword [bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_bb_TImageBuffer_BufferHeight:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_298
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_293
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,bbNullObject
	jne	_295
	call	brl_blitz_NullObjectError
_295:
	mov	ebx,dword [ebx+8]
	cmp	ebx,bbNullObject
	jne	_297
	call	brl_blitz_NullObjectError
_297:
	mov	ebx,dword [ebx+12]
	jmp	_74
_74:
	call	dword [bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
bb_AdjustTexSize:
	push	ebp
	mov	ebp,esp
	sub	esp,12
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	eax,dword [ebp+12]
	mov	dword [ebp-8],eax
	mov	dword [ebp-12],0
	push	ebp
	push	_326
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_299
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	mov	eax,dword [ebp-4]
	push	dword [eax]
	call	bb_Pow2Size
	add	esp,4
	mov	dword [ebx],eax
	push	_300
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	mov	eax,dword [ebp-8]
	push	dword [eax]
	call	bb_Pow2Size
	add	esp,4
	mov	dword [ebx],eax
	push	_301
	call	dword [bbOnDebugEnterStm]
	add	esp,4
_6:
_4:
	push	ebp
	push	_324
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_302
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-12],0
	push	_304
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	5121
	push	6408
	push	0
	mov	eax,dword [ebp-8]
	push	dword [eax]
	mov	eax,dword [ebp-4]
	push	dword [eax]
	push	4
	push	0
	push	32868
	call	glTexImage2D
	add	esp,36
	push	_305
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	lea	eax,dword [ebp-12]
	push	eax
	push	4096
	push	0
	push	32868
	call	glGetTexLevelParameteriv
	add	esp,16
	push	_306
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	cmp	dword [ebp-12],0
	je	_307
	push	ebp
	push	_309
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_308
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,0
	call	dword [bbOnDebugLeaveScope]
	call	dword [bbOnDebugLeaveScope]
	jmp	_78
_307:
	push	_310
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	eax,dword [eax]
	cmp	eax,1
	sete	al
	movzx	eax,al
	cmp	eax,0
	je	_311
	mov	eax,dword [ebp-8]
	mov	eax,dword [eax]
	cmp	eax,1
	sete	al
	movzx	eax,al
_311:
	cmp	eax,0
	je	_313
	push	ebp
	push	_315
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_314
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	push	_7
	call	brl_blitz_RuntimeError
	add	esp,4
	call	dword [bbOnDebugLeaveScope]
_313:
	push	_316
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	cmp	dword [eax],1
	jle	_317
	push	ebp
	push	_319
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_318
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ecx,dword [ebp-4]
	mov	eax,dword [ebp-4]
	mov	eax,dword [eax]
	cdq
	and	edx,1
	add	eax,edx
	sar	eax,1
	mov	dword [ecx],eax
	call	dword [bbOnDebugLeaveScope]
_317:
	push	_320
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-8]
	cmp	dword [eax],1
	jle	_321
	push	ebp
	push	_323
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_322
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ecx,dword [ebp-8]
	mov	eax,dword [ebp-8]
	mov	eax,dword [eax]
	cdq
	and	edx,1
	add	eax,edx
	sar	eax,1
	mov	dword [ecx],eax
	call	dword [bbOnDebugLeaveScope]
_321:
	call	dword [bbOnDebugLeaveScope]
	jmp	_6
_78:
	call	dword [bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
bb_Pow2Size:
	push	ebp
	mov	ebp,esp
	sub	esp,8
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	dword [ebp-8],0
	push	ebp
	push	_336
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_330
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-8],1
	push	_332
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	jmp	_8
_10:
	push	ebp
	push	_334
	call	dword [bbOnDebugEnterScope]
	add	esp,8
	push	_333
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-8]
	shl	eax,1
	mov	dword [ebp-8],eax
	call	dword [bbOnDebugLeaveScope]
_8:
	mov	eax,dword [ebp-4]
	cmp	dword [ebp-8],eax
	jl	_10
_9:
	push	_335
	call	dword [bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	jmp	_81
_81:
	call	dword [bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
	section	"data" writeable align 8
	align	4
_85:
	dd	0
_84:
	db	"lights",0
	align	4
_83:
	dd	1
	dd	_84
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
	db	"SetBuffer",0
_29:
	db	"(:TImage,i):TImageBuffer",0
_30:
	db	"Init",0
_31:
	db	"(i,i,i,i)i",0
_32:
	db	"GenerateFBO",0
_33:
	db	"BindBuffer",0
_34:
	db	"UnBindBuffer",0
_35:
	db	"Cls",0
_36:
	db	"(f,f,f,f)i",0
_37:
	db	"BufferWidth",0
_38:
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
	dd	7
	dd	_28
	dd	_29
	dd	48
	dd	7
	dd	_30
	dd	_31
	dd	52
	dd	6
	dd	_32
	dd	_27
	dd	56
	dd	6
	dd	_33
	dd	_27
	dd	60
	dd	6
	dd	_34
	dd	_27
	dd	64
	dd	6
	dd	_35
	dd	_36
	dd	68
	dd	6
	dd	_37
	dd	_27
	dd	72
	dd	6
	dd	_38
	dd	_27
	dd	76
	dd	0
	align	4
bb_TImageBuffer:
	dd	bbObjectClass
	dd	bbObjectFree
	dd	_11
	dd	44
	dd	_bb_TImageBuffer_New
	dd	bbObjectDtor
	dd	bbObjectToString
	dd	bbObjectCompare
	dd	bbObjectSendMessage
	dd	bbObjectReserved
	dd	bbObjectReserved
	dd	bbObjectReserved
	dd	_bb_TImageBuffer_SetBuffer
	dd	_bb_TImageBuffer_Init
	dd	_bb_TImageBuffer_GenerateFBO
	dd	_bb_TImageBuffer_BindBuffer
	dd	_bb_TImageBuffer_UnBindBuffer
	dd	_bb_TImageBuffer_Cls
	dd	_bb_TImageBuffer_BufferWidth
	dd	_bb_TImageBuffer_BufferHeight
_91:
	db	"Self",0
_92:
	db	":TImageBuffer",0
	align	4
_90:
	dd	1
	dd	_26
	dd	2
	dd	_91
	dd	_92
	dd	-4
	dd	0
_87:
	db	"i",0
_88:
	db	"i",0
	align	4
_89:
	dd	3
	dd	0
	dd	0
_112:
	db	"IB",0
	align	4
_111:
	dd	1
	dd	_28
	dd	2
	dd	_13
	dd	_14
	dd	-4
	dd	2
	dd	_20
	dd	_21
	dd	-8
	dd	2
	dd	_112
	dd	_92
	dd	-12
	dd	0
_94:
	db	"/home/emanuel/Desktop/Dingko 21.8.13/Dingko The Game new/modules/lights.bmx",0
	align	4
_93:
	dd	_94
	dd	22
	dd	3
	align	4
_96:
	dd	_94
	dd	23
	dd	3
	align	4
_100:
	dd	_94
	dd	24
	dd	3
	align	4
_104:
	dd	_94
	dd	25
	dd	3
	align	4
_107:
	dd	_94
	dd	26
	dd	3
	align	4
_110:
	dd	_94
	dd	27
	dd	3
_117:
	db	"Width",0
_118:
	db	"Height",0
_119:
	db	"Bit",0
_120:
	db	"Mode",0
	align	4
_116:
	dd	1
	dd	_30
	dd	2
	dd	_117
	dd	_21
	dd	-4
	dd	2
	dd	_118
	dd	_21
	dd	-8
	dd	2
	dd	_119
	dd	_21
	dd	-12
	dd	2
	dd	_120
	dd	_21
	dd	-16
	dd	0
	align	4
_113:
	dd	_94
	dd	31
	dd	3
	align	4
_114:
	dd	_94
	dd	32
	dd	3
	align	4
_115:
	dd	_94
	dd	33
	dd	3
_210:
	db	"W",0
_211:
	db	"H",0
_212:
	db	"status",0
	align	4
_209:
	dd	1
	dd	_32
	dd	2
	dd	_91
	dd	_92
	dd	-4
	dd	2
	dd	_210
	dd	_21
	dd	-8
	dd	2
	dd	_211
	dd	_21
	dd	-12
	dd	2
	dd	_212
	dd	_21
	dd	-16
	dd	0
	align	4
_121:
	dd	_94
	dd	37
	dd	3
	align	4
_131:
	dd	_94
	dd	39
	dd	3
	align	4
_141:
	dd	_94
	dd	40
	dd	3
	align	4
_147:
	dd	_94
	dd	42
	dd	3
	align	4
_153:
	dd	_94
	dd	43
	dd	3
	align	4
_159:
	dd	_94
	dd	45
	dd	3
	align	4
_160:
	dd	_94
	dd	48
	dd	3
	align	4
_164:
	dd	_94
	dd	49
	dd	3
	align	4
_168:
	dd	_94
	dd	51
	dd	3
	align	4
_173:
	dd	_94
	dd	52
	dd	3
	align	4
_179:
	dd	_94
	dd	55
	dd	3
	align	4
_184:
	dd	_94
	dd	56
	dd	3
	align	4
_190:
	dd	_94
	dd	57
	dd	3
	align	4
_191:
	dd	_94
	dd	58
	dd	3
	align	4
_197:
	dd	_94
	dd	60
	dd	3
	align	4
_199:
	dd	_94
	dd	62
	dd	3
	align	4
_205:
	dd	3
	dd	0
	dd	0
	align	4
_204:
	dd	_94
	dd	68
	dd	5
	align	4
_206:
	dd	3
	dd	0
	dd	0
	align	4
_208:
	dd	3
	dd	0
	dd	0
	align	4
_207:
	dd	_94
	dd	66
	dd	5
	align	4
_3:
	dd	bbStringClass
	dd	2147483647
	dd	24
	dw	99,104,111,111,115,101,32,100,105,102,102,101,114,101,110,116
	dw	32,102,111,114,109,97,116,115
	align	4
_258:
	dd	1
	dd	_33
	dd	2
	dd	_91
	dd	_92
	dd	-4
	dd	0
	align	4
_213:
	dd	_94
	dd	74
	dd	3
	align	4
_222:
	dd	_94
	dd	75
	dd	3
	align	4
_228:
	dd	_94
	dd	76
	dd	3
	align	4
_229:
	dd	_94
	dd	77
	dd	3
	align	4
_230:
	dd	_94
	dd	78
	dd	3
	align	8
_383:
	dd	0x0,0xbff00000
	align	4
_239:
	dd	_94
	dd	79
	dd	3
	align	4
_240:
	dd	_94
	dd	80
	dd	3
	align	4
_249:
	dd	_94
	dd	81
	dd	3
	align	4
_278:
	dd	1
	dd	_34
	dd	2
	dd	_91
	dd	_92
	dd	-4
	dd	0
	align	4
_259:
	dd	_94
	dd	85
	dd	3
	align	4
_260:
	dd	_94
	dd	86
	dd	3
	align	4
_261:
	dd	_94
	dd	87
	dd	3
	align	4
_262:
	dd	_94
	dd	88
	dd	3
	align	8
_404:
	dd	0x0,0xbff00000
	align	4
_267:
	dd	_94
	dd	89
	dd	3
	align	4
_268:
	dd	_94
	dd	90
	dd	3
	align	4
_273:
	dd	_94
	dd	91
	dd	3
_282:
	db	"r",0
_283:
	db	"f",0
_284:
	db	"g",0
_285:
	db	"b",0
_286:
	db	"a",0
	align	4
_281:
	dd	1
	dd	_35
	dd	2
	dd	_91
	dd	_92
	dd	-4
	dd	2
	dd	_282
	dd	_283
	dd	-8
	dd	2
	dd	_284
	dd	_283
	dd	-12
	dd	2
	dd	_285
	dd	_283
	dd	-16
	dd	2
	dd	_286
	dd	_283
	dd	-20
	dd	0
	align	4
_279:
	dd	_94
	dd	95
	dd	3
	align	4
_280:
	dd	_94
	dd	96
	dd	3
	align	4
_292:
	dd	1
	dd	_37
	dd	2
	dd	_91
	dd	_92
	dd	-4
	dd	0
	align	4
_287:
	dd	_94
	dd	100
	dd	3
	align	4
_298:
	dd	1
	dd	_38
	dd	2
	dd	_91
	dd	_92
	dd	-4
	dd	0
	align	4
_293:
	dd	_94
	dd	104
	dd	3
_327:
	db	"AdjustTexSize",0
_328:
	db	"width",0
_329:
	db	"height",0
	align	4
_326:
	dd	1
	dd	_327
	dd	5
	dd	_328
	dd	_21
	dd	-4
	dd	5
	dd	_329
	dd	_21
	dd	-8
	dd	0
	align	4
_299:
	dd	_94
	dd	112
	dd	2
	align	4
_300:
	dd	_94
	dd	113
	dd	2
	align	4
_301:
	dd	_94
	dd	122
	dd	2
_325:
	db	"t",0
	align	4
_324:
	dd	3
	dd	0
	dd	2
	dd	_325
	dd	_21
	dd	-12
	dd	0
	align	4
_302:
	dd	_94
	dd	115
	dd	3
	align	4
_304:
	dd	_94
	dd	116
	dd	3
	align	4
_305:
	dd	_94
	dd	117
	dd	3
	align	4
_306:
	dd	_94
	dd	118
	dd	3
	align	4
_309:
	dd	3
	dd	0
	dd	0
	align	4
_308:
	dd	_94
	dd	118
	dd	8
	align	4
_310:
	dd	_94
	dd	119
	dd	3
	align	4
_315:
	dd	3
	dd	0
	dd	0
	align	4
_314:
	dd	_94
	dd	119
	dd	27
	align	4
_7:
	dd	bbStringClass
	dd	2147483647
	dd	28
	dw	85,110,97,98,108,101,32,116,111,32,99,97,108,99,117,108
	dw	97,116,101,32,116,101,120,32,115,105,122,101
	align	4
_316:
	dd	_94
	dd	120
	dd	3
	align	4
_319:
	dd	3
	dd	0
	dd	0
	align	4
_318:
	dd	_94
	dd	120
	dd	14
	align	4
_320:
	dd	_94
	dd	121
	dd	3
	align	4
_323:
	dd	3
	dd	0
	dd	0
	align	4
_322:
	dd	_94
	dd	121
	dd	15
_337:
	db	"Pow2Size",0
_338:
	db	"n",0
	align	4
_336:
	dd	1
	dd	_337
	dd	2
	dd	_338
	dd	_21
	dd	-4
	dd	2
	dd	_325
	dd	_21
	dd	-8
	dd	0
	align	4
_330:
	dd	_94
	dd	126
	dd	2
	align	4
_332:
	dd	_94
	dd	127
	dd	2
	align	4
_334:
	dd	3
	dd	0
	dd	0
	align	4
_333:
	dd	_94
	dd	128
	dd	3
	align	4
_335:
	dd	_94
	dd	130
	dd	2
