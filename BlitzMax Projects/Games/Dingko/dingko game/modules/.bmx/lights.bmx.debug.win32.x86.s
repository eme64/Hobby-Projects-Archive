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
	extrn	_bbOnDebugEnterScope
	extrn	_bbOnDebugEnterStm
	extrn	_bbOnDebugLeaveScope
	extrn	_bbStringClass
	extrn	_brl_blitz_ArrayBoundsError
	extrn	_brl_blitz_NullObjectError
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
	push	ebx
	cmp	dword [_89],0
	je	_90
	mov	eax,0
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_90:
	mov	dword [_89],1
	push	ebp
	push	_87
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	___bb_blitz_blitz
	call	___bb_glmax2d_glmax2d
	call	___bb_glew_glew
	call	___bb_standardio_standardio
	push	_bb_TImageBuffer
	call	_bbObjectRegisterType
	add	esp,4
	mov	ebx,0
	jmp	_40
_40:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_New:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_98
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	dword [ebp-4]
	call	_bbObjectCtor
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [eax],_bb_TImageBuffer
	mov	edx,_bbNullObject
	inc	dword [edx+4]
	mov	eax,dword [ebp-4]
	mov	dword [eax+8],edx
	push	1
	push	_92
	call	_bbArrayNew1D
	add	esp,8
	inc	dword [eax+4]
	mov	edx,dword [ebp-4]
	mov	dword [edx+12],eax
	push	1
	push	_94
	call	_bbArrayNew1D
	add	esp,8
	inc	dword [eax+4]
	mov	edx,dword [ebp-4]
	mov	dword [edx+16],eax
	mov	edx,_bbNullObject
	inc	dword [edx+4]
	mov	eax,dword [ebp-4]
	mov	dword [eax+20],edx
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
	push	_97
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
	mov	ebx,0
	jmp	_43
_43:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
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
	jnz	_103
	push	eax
	call	_bbGCFree
	add	esp,4
_103:
	mov	eax,dword [ebx+16]
	dec	dword [eax+4]
	jnz	_105
	push	eax
	call	_bbGCFree
	add	esp,4
_105:
	mov	eax,dword [ebx+12]
	dec	dword [eax+4]
	jnz	_107
	push	eax
	call	_bbGCFree
	add	esp,4
_107:
	mov	eax,dword [ebx+8]
	dec	dword [eax+4]
	jnz	_109
	push	eax
	call	_bbGCFree
	add	esp,4
_109:
	mov	eax,0
	jmp	_101
_101:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_SetBuffer:
	push	ebp
	mov	ebp,esp
	sub	esp,12
	push	ebx
	push	esi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	eax,dword [ebp+12]
	mov	dword [ebp-8],eax
	mov	dword [ebp-12],_bbNullObject
	push	ebp
	push	_132
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_110
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_TImageBuffer
	call	_bbObjectNew
	add	esp,4
	mov	dword [ebp-12],eax
	push	_113
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-12]
	cmp	esi,_bbNullObject
	jne	_115
	call	_brl_blitz_NullObjectError
_115:
	mov	ebx,dword [ebp-4]
	inc	dword [ebx+4]
	mov	eax,dword [esi+8]
	dec	dword [eax+4]
	jnz	_120
	push	eax
	call	_bbGCFree
	add	esp,4
_120:
	mov	dword [esi+8],ebx
	push	_121
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-12]
	cmp	ebx,_bbNullObject
	jne	_123
	call	_brl_blitz_NullObjectError
_123:
	mov	eax,dword [ebp-8]
	mov	dword [ebx+24],eax
	push	_125
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-12]
	cmp	ebx,_bbNullObject
	jne	_127
	call	_brl_blitz_NullObjectError
_127:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+56]
	add	esp,4
	push	_128
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-12]
	cmp	ebx,_bbNullObject
	jne	_130
	call	_brl_blitz_NullObjectError
_130:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+60]
	add	esp,4
	push	_131
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-12]
	jmp	_50
_50:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_Init:
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
	push	_137
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_134
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	2
	call	_brl_glmax2d_GLMax2DDriver
	push	eax
	call	_brl_graphics_SetGraphicsDriver
	add	esp,8
	push	_135
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	dword [ebp-16]
	push	dword [ebp-12]
	push	dword [ebp-8]
	push	dword [ebp-4]
	call	_brl_graphics_Graphics
	add	esp,20
	push	_136
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	_glewInit
	mov	ebx,0
	jmp	_56
_56:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_GenerateFBO:
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
	push	_234
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_142
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_144
	call	_brl_blitz_NullObjectError
_144:
	mov	edi,ebx
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_147
	call	_brl_blitz_NullObjectError
_147:
	mov	esi,dword [ebx+8]
	cmp	esi,_bbNullObject
	jne	_149
	call	_brl_blitz_NullObjectError
_149:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_151
	call	_brl_blitz_NullObjectError
_151:
	push	_brl_glmax2d_TGLImageFrame
	push	dword [ebx+24]
	push	esi
	mov	eax,dword [esi]
	call	dword [eax+52]
	add	esp,8
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	mov	ebx,eax
	inc	dword [ebx+4]
	mov	eax,dword [edi+20]
	dec	dword [eax+4]
	jnz	_155
	push	eax
	call	_bbGCFree
	add	esp,4
_155:
	mov	dword [edi+20],ebx
	push	_156
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_158
	call	_brl_blitz_NullObjectError
_158:
	mov	ebx,dword [ebx+20]
	cmp	ebx,_bbNullObject
	jne	_160
	call	_brl_blitz_NullObjectError
_160:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_163
	call	_brl_blitz_NullObjectError
_163:
	mov	esi,dword [esi+20]
	cmp	esi,_bbNullObject
	jne	_165
	call	_brl_blitz_NullObjectError
_165:
	fld	dword [esi+20]
	fstp	dword [ebx+12]
	push	_166
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_168
	call	_brl_blitz_NullObjectError
_168:
	mov	ebx,dword [ebx+20]
	cmp	ebx,_bbNullObject
	jne	_170
	call	_brl_blitz_NullObjectError
_170:
	fldz
	fstp	dword [ebx+20]
	push	_172
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_174
	call	_brl_blitz_NullObjectError
_174:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_176
	call	_brl_blitz_NullObjectError
_176:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-8],eax
	push	_178
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_180
	call	_brl_blitz_NullObjectError
_180:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_182
	call	_brl_blitz_NullObjectError
_182:
	mov	eax,dword [ebx+12]
	mov	dword [ebp-12],eax
	push	_184
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	lea	eax,dword [ebp-12]
	push	eax
	lea	eax,dword [ebp-8]
	push	eax
	call	_bb_AdjustTexSize
	add	esp,8
	push	_185
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_187
	call	_brl_blitz_NullObjectError
_187:
	mov	eax,dword [ebx+16]
	mov	dword [ebp-20],eax
	mov	eax,dword [ebp-20]
	lea	eax,dword [eax+24]
	push	eax
	push	1
	call	dword [___glewGenFramebuffersEXT]
	push	_189
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_191
	call	_brl_blitz_NullObjectError
_191:
	mov	eax,dword [ebx+12]
	mov	dword [ebp-24],eax
	mov	eax,dword [ebp-24]
	lea	eax,dword [eax+24]
	push	eax
	push	1
	call	dword [___glewGenRenderbuffersEXT]
	push	_193
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_195
	call	_brl_blitz_NullObjectError
_195:
	mov	ebx,dword [ebx+20]
	cmp	ebx,_bbNullObject
	jne	_197
	call	_brl_blitz_NullObjectError
_197:
	push	dword [ebx+32]
	push	3553
	call	_glBindTexture@8
	push	_198
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_200
	call	_brl_blitz_NullObjectError
_200:
	mov	esi,dword [ebx+16]
	mov	ebx,0
	cmp	ebx,dword [esi+20]
	jb	_203
	call	_brl_blitz_ArrayBoundsError
_203:
	push	dword [esi+ebx*4+24]
	push	36160
	call	dword [___glewBindFramebufferEXT]
	push	_204
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_206
	call	_brl_blitz_NullObjectError
_206:
	mov	ebx,dword [ebx+20]
	cmp	ebx,_bbNullObject
	jne	_208
	call	_brl_blitz_NullObjectError
_208:
	push	0
	push	dword [ebx+32]
	push	3553
	push	36064
	push	36160
	call	dword [___glewFramebufferTexture2DEXT]
	push	_209
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_211
	call	_brl_blitz_NullObjectError
_211:
	mov	esi,dword [ebx+12]
	mov	ebx,0
	cmp	ebx,dword [esi+20]
	jb	_214
	call	_brl_blitz_ArrayBoundsError
_214:
	push	dword [esi+ebx*4+24]
	push	36161
	call	dword [___glewBindRenderbufferEXT]
	push	_215
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	dword [ebp-12]
	push	dword [ebp-8]
	push	33190
	push	36161
	call	dword [___glewRenderbufferStorageEXT]
	push	_216
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_218
	call	_brl_blitz_NullObjectError
_218:
	mov	esi,dword [ebx+12]
	mov	ebx,0
	cmp	ebx,dword [esi+20]
	jb	_221
	call	_brl_blitz_ArrayBoundsError
_221:
	push	dword [esi+ebx*4+24]
	push	36161
	push	36096
	push	36160
	call	dword [___glewFramebufferRenderbufferEXT]
	push	_222
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	36160
	call	dword [___glewCheckFramebufferStatusEXT]
	mov	dword [ebp-16],eax
	push	_224
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-16]
	cmp	eax,36053
	je	_227
	cmp	eax,36061
	je	_228
	mov	eax,ebp
	push	eax
	push	_230
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_229
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	_bbEnd
	call	dword [_bbOnDebugLeaveScope]
	jmp	_226
_227:
	mov	eax,ebp
	push	eax
	push	_231
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
	jmp	_226
_228:
	mov	eax,ebp
	push	eax
	push	_233
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_232
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_3
	call	_brl_standardio_Print
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	jmp	_226
_226:
	mov	ebx,0
	jmp	_59
_59:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_BindBuffer:
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
	push	_283
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_238
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [ebp-8],eax
	cmp	dword [ebp-8],_bbNullObject
	jne	_240
	call	_brl_blitz_NullObjectError
_240:
	mov	edi,dword [ebp-4]
	cmp	edi,_bbNullObject
	jne	_242
	call	_brl_blitz_NullObjectError
_242:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_244
	call	_brl_blitz_NullObjectError
_244:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_246
	call	_brl_blitz_NullObjectError
_246:
	lea	eax,dword [ebx+40]
	push	eax
	lea	eax,dword [esi+36]
	push	eax
	lea	eax,dword [edi+32]
	push	eax
	mov	eax,dword [ebp-8]
	lea	eax,dword [eax+28]
	push	eax
	call	_brl_max2d_GetViewport
	add	esp,16
	push	_247
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_249
	call	_brl_blitz_NullObjectError
_249:
	mov	esi,dword [ebx+16]
	mov	ebx,0
	cmp	ebx,dword [esi+20]
	jb	_252
	call	_brl_blitz_ArrayBoundsError
_252:
	push	dword [esi+ebx*4+24]
	push	36160
	call	dword [___glewBindFramebufferEXT]
	push	_253
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	5889
	call	_glMatrixMode@4
	push	_254
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	_glLoadIdentity@0
	push	_255
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_257
	call	_brl_blitz_NullObjectError
_257:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_259
	call	_brl_blitz_NullObjectError
_259:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_261
	call	_brl_blitz_NullObjectError
_261:
	mov	esi,dword [esi+8]
	cmp	esi,_bbNullObject
	jne	_263
	call	_brl_blitz_NullObjectError
_263:
	fld1
	sub	esp,8
	fstp	qword [esp]
	fld	qword [_410]
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
	call	_glOrtho@48
	push	_264
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	5888
	call	_glMatrixMode@4
	push	_265
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_267
	call	_brl_blitz_NullObjectError
_267:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_269
	call	_brl_blitz_NullObjectError
_269:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_271
	call	_brl_blitz_NullObjectError
_271:
	mov	esi,dword [esi+8]
	cmp	esi,_bbNullObject
	jne	_273
	call	_brl_blitz_NullObjectError
_273:
	push	dword [esi+12]
	push	dword [ebx+8]
	push	0
	push	0
	call	_glViewport@16
	push	_274
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_276
	call	_brl_blitz_NullObjectError
_276:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_278
	call	_brl_blitz_NullObjectError
_278:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_280
	call	_brl_blitz_NullObjectError
_280:
	mov	esi,dword [esi+8]
	cmp	esi,_bbNullObject
	jne	_282
	call	_brl_blitz_NullObjectError
_282:
	push	dword [esi+12]
	push	dword [ebx+8]
	push	0
	push	0
	call	_glScissor@16
	mov	ebx,0
	jmp	_62
_62:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_UnBindBuffer:
	push	ebp
	mov	ebp,esp
	sub	esp,8
	push	ebx
	push	esi
	push	edi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_303
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_284
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	36160
	call	dword [___glewBindFramebufferEXT]
	push	_285
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	5889
	call	_glMatrixMode@4
	push	_286
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	_glLoadIdentity@0
	push	_287
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_289
	call	_brl_blitz_NullObjectError
_289:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_291
	call	_brl_blitz_NullObjectError
_291:
	fld1
	sub	esp,8
	fstp	qword [esp]
	fld	qword [_431]
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
	call	_glOrtho@48
	push	_292
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	5888
	call	_glMatrixMode@4
	push	_293
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_295
	call	_brl_blitz_NullObjectError
_295:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_297
	call	_brl_blitz_NullObjectError
_297:
	push	dword [ebx+40]
	push	dword [esi+36]
	push	0
	push	0
	call	_glViewport@16
	push	_298
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_300
	call	_brl_blitz_NullObjectError
_300:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_302
	call	_brl_blitz_NullObjectError
_302:
	push	dword [ebx+40]
	push	dword [esi+36]
	push	0
	push	0
	call	_glScissor@16
	mov	ebx,0
	jmp	_65
_65:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_Cls:
	push	ebp
	mov	ebp,esp
	sub	esp,20
	push	ebx
	push	esi
	push	edi
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
	push	_306
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_304
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	dword [ebp-20]
	push	dword [ebp-16]
	push	dword [ebp-12]
	push	dword [ebp-8]
	call	_glClearColor@16
	push	_305
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	16640
	call	_glClear@4
	mov	ebx,0
	jmp	_72
_72:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_BufferWidth:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_317
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_312
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_314
	call	_brl_blitz_NullObjectError
_314:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_316
	call	_brl_blitz_NullObjectError
_316:
	mov	ebx,dword [ebx+8]
	jmp	_75
_75:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TImageBuffer_BufferHeight:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_323
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_318
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_320
	call	_brl_blitz_NullObjectError
_320:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_322
	call	_brl_blitz_NullObjectError
_322:
	mov	ebx,dword [ebx+12]
	jmp	_78
_78:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_bb_AdjustTexSize:
	push	ebp
	mov	ebp,esp
	sub	esp,12
	push	ebx
	push	esi
	push	edi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	eax,dword [ebp+12]
	mov	dword [ebp-8],eax
	mov	dword [ebp-12],0
	push	ebp
	push	_351
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_324
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	mov	eax,dword [ebp-4]
	push	dword [eax]
	call	_bb_Pow2Size
	add	esp,4
	mov	dword [ebx],eax
	push	_325
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	mov	eax,dword [ebp-8]
	push	dword [eax]
	call	_bb_Pow2Size
	add	esp,4
	mov	dword [ebx],eax
	push	_326
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
_6:
_4:
	push	ebp
	push	_349
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_327
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-12],0
	push	_329
	call	dword [_bbOnDebugEnterStm]
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
	call	_glTexImage2D@36
	push	_330
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	lea	eax,dword [ebp-12]
	push	eax
	push	4096
	push	0
	push	32868
	call	_glGetTexLevelParameteriv@16
	push	_331
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	cmp	dword [ebp-12],0
	je	_332
	push	ebp
	push	_334
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_333
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,0
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_82
_332:
	push	_335
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	eax,dword [eax]
	cmp	eax,1
	sete	al
	movzx	eax,al
	cmp	eax,0
	je	_336
	mov	eax,dword [ebp-8]
	mov	eax,dword [eax]
	cmp	eax,1
	sete	al
	movzx	eax,al
_336:
	cmp	eax,0
	je	_338
	push	ebp
	push	_340
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_339
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_7
	call	_brl_blitz_RuntimeError
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
_338:
	push	_341
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	cmp	dword [eax],1
	jle	_342
	push	ebp
	push	_344
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_343
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ecx,dword [ebp-4]
	mov	eax,dword [ebp-4]
	mov	eax,dword [eax]
	cdq
	and	edx,1
	add	eax,edx
	sar	eax,1
	mov	dword [ecx],eax
	call	dword [_bbOnDebugLeaveScope]
_342:
	push	_345
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-8]
	cmp	dword [eax],1
	jle	_346
	push	ebp
	push	_348
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_347
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ecx,dword [ebp-8]
	mov	eax,dword [ebp-8]
	mov	eax,dword [eax]
	cdq
	and	edx,1
	add	eax,edx
	sar	eax,1
	mov	dword [ecx],eax
	call	dword [_bbOnDebugLeaveScope]
_346:
	call	dword [_bbOnDebugLeaveScope]
	jmp	_6
_82:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_bb_Pow2Size:
	push	ebp
	mov	ebp,esp
	sub	esp,8
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	dword [ebp-8],0
	push	ebp
	push	_361
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_355
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-8],1
	push	_357
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	jmp	_8
_10:
	push	ebp
	push	_359
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_358
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-8]
	shl	eax,1
	mov	dword [ebp-8],eax
	call	dword [_bbOnDebugLeaveScope]
_8:
	mov	eax,dword [ebp-4]
	cmp	dword [ebp-8],eax
	jl	_10
_9:
	push	_360
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	jmp	_85
_85:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
	section	"data" data writeable align 8
	align	4
_89:
	dd	0
_88:
	db	"lights",0
	align	4
_87:
	dd	1
	dd	_88
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
_99:
	db	"Self",0
_100:
	db	":TImageBuffer",0
	align	4
_98:
	dd	1
	dd	_26
	dd	2
	dd	_99
	dd	_100
	dd	-4
	dd	0
_92:
	db	"i",0
_94:
	db	"i",0
	align	4
_97:
	dd	3
	dd	0
	dd	0
_133:
	db	"IB",0
	align	4
_132:
	dd	1
	dd	_29
	dd	2
	dd	_13
	dd	_14
	dd	-4
	dd	2
	dd	_20
	dd	_21
	dd	-8
	dd	2
	dd	_133
	dd	_100
	dd	-12
	dd	0
_111:
	db	"D:/Programming/BMX/BMX_Desktop/Dingko 21.8.13/Dingko The Game new/modules/lights.bmx",0
	align	4
_110:
	dd	_111
	dd	22
	dd	3
	align	4
_113:
	dd	_111
	dd	23
	dd	3
	align	4
_121:
	dd	_111
	dd	24
	dd	3
	align	4
_125:
	dd	_111
	dd	25
	dd	3
	align	4
_128:
	dd	_111
	dd	26
	dd	3
	align	4
_131:
	dd	_111
	dd	27
	dd	3
_138:
	db	"Width",0
_139:
	db	"Height",0
_140:
	db	"Bit",0
_141:
	db	"Mode",0
	align	4
_137:
	dd	1
	dd	_31
	dd	2
	dd	_138
	dd	_21
	dd	-4
	dd	2
	dd	_139
	dd	_21
	dd	-8
	dd	2
	dd	_140
	dd	_21
	dd	-12
	dd	2
	dd	_141
	dd	_21
	dd	-16
	dd	0
	align	4
_134:
	dd	_111
	dd	31
	dd	3
	align	4
_135:
	dd	_111
	dd	32
	dd	3
	align	4
_136:
	dd	_111
	dd	33
	dd	3
_235:
	db	"W",0
_236:
	db	"H",0
_237:
	db	"status",0
	align	4
_234:
	dd	1
	dd	_33
	dd	2
	dd	_99
	dd	_100
	dd	-4
	dd	2
	dd	_235
	dd	_21
	dd	-8
	dd	2
	dd	_236
	dd	_21
	dd	-12
	dd	2
	dd	_237
	dd	_21
	dd	-16
	dd	0
	align	4
_142:
	dd	_111
	dd	37
	dd	3
	align	4
_156:
	dd	_111
	dd	39
	dd	3
	align	4
_166:
	dd	_111
	dd	40
	dd	3
	align	4
_172:
	dd	_111
	dd	42
	dd	3
	align	4
_178:
	dd	_111
	dd	43
	dd	3
	align	4
_184:
	dd	_111
	dd	45
	dd	3
	align	4
_185:
	dd	_111
	dd	48
	dd	3
	align	4
_189:
	dd	_111
	dd	49
	dd	3
	align	4
_193:
	dd	_111
	dd	51
	dd	3
	align	4
_198:
	dd	_111
	dd	52
	dd	3
	align	4
_204:
	dd	_111
	dd	55
	dd	3
	align	4
_209:
	dd	_111
	dd	56
	dd	3
	align	4
_215:
	dd	_111
	dd	57
	dd	3
	align	4
_216:
	dd	_111
	dd	58
	dd	3
	align	4
_222:
	dd	_111
	dd	60
	dd	3
	align	4
_224:
	dd	_111
	dd	62
	dd	3
	align	4
_230:
	dd	3
	dd	0
	dd	0
	align	4
_229:
	dd	_111
	dd	68
	dd	5
	align	4
_231:
	dd	3
	dd	0
	dd	0
	align	4
_233:
	dd	3
	dd	0
	dd	0
	align	4
_232:
	dd	_111
	dd	66
	dd	5
	align	4
_3:
	dd	_bbStringClass
	dd	2147483647
	dd	24
	dw	99,104,111,111,115,101,32,100,105,102,102,101,114,101,110,116
	dw	32,102,111,114,109,97,116,115
	align	4
_283:
	dd	1
	dd	_34
	dd	2
	dd	_99
	dd	_100
	dd	-4
	dd	0
	align	4
_238:
	dd	_111
	dd	74
	dd	3
	align	4
_247:
	dd	_111
	dd	75
	dd	3
	align	4
_253:
	dd	_111
	dd	76
	dd	3
	align	4
_254:
	dd	_111
	dd	77
	dd	3
	align	4
_255:
	dd	_111
	dd	78
	dd	3
	align	8
_410:
	dd	0x0,0xbff00000
	align	4
_264:
	dd	_111
	dd	79
	dd	3
	align	4
_265:
	dd	_111
	dd	80
	dd	3
	align	4
_274:
	dd	_111
	dd	81
	dd	3
	align	4
_303:
	dd	1
	dd	_35
	dd	2
	dd	_99
	dd	_100
	dd	-4
	dd	0
	align	4
_284:
	dd	_111
	dd	85
	dd	3
	align	4
_285:
	dd	_111
	dd	86
	dd	3
	align	4
_286:
	dd	_111
	dd	87
	dd	3
	align	4
_287:
	dd	_111
	dd	88
	dd	3
	align	8
_431:
	dd	0x0,0xbff00000
	align	4
_292:
	dd	_111
	dd	89
	dd	3
	align	4
_293:
	dd	_111
	dd	90
	dd	3
	align	4
_298:
	dd	_111
	dd	91
	dd	3
_307:
	db	"r",0
_308:
	db	"f",0
_309:
	db	"g",0
_310:
	db	"b",0
_311:
	db	"a",0
	align	4
_306:
	dd	1
	dd	_36
	dd	2
	dd	_99
	dd	_100
	dd	-4
	dd	2
	dd	_307
	dd	_308
	dd	-8
	dd	2
	dd	_309
	dd	_308
	dd	-12
	dd	2
	dd	_310
	dd	_308
	dd	-16
	dd	2
	dd	_311
	dd	_308
	dd	-20
	dd	0
	align	4
_304:
	dd	_111
	dd	95
	dd	3
	align	4
_305:
	dd	_111
	dd	96
	dd	3
	align	4
_317:
	dd	1
	dd	_38
	dd	2
	dd	_99
	dd	_100
	dd	-4
	dd	0
	align	4
_312:
	dd	_111
	dd	100
	dd	3
	align	4
_323:
	dd	1
	dd	_39
	dd	2
	dd	_99
	dd	_100
	dd	-4
	dd	0
	align	4
_318:
	dd	_111
	dd	104
	dd	3
_352:
	db	"AdjustTexSize",0
_353:
	db	"width",0
_354:
	db	"height",0
	align	4
_351:
	dd	1
	dd	_352
	dd	5
	dd	_353
	dd	_21
	dd	-4
	dd	5
	dd	_354
	dd	_21
	dd	-8
	dd	0
	align	4
_324:
	dd	_111
	dd	112
	dd	2
	align	4
_325:
	dd	_111
	dd	113
	dd	2
	align	4
_326:
	dd	_111
	dd	122
	dd	2
_350:
	db	"t",0
	align	4
_349:
	dd	3
	dd	0
	dd	2
	dd	_350
	dd	_21
	dd	-12
	dd	0
	align	4
_327:
	dd	_111
	dd	115
	dd	3
	align	4
_329:
	dd	_111
	dd	116
	dd	3
	align	4
_330:
	dd	_111
	dd	117
	dd	3
	align	4
_331:
	dd	_111
	dd	118
	dd	3
	align	4
_334:
	dd	3
	dd	0
	dd	0
	align	4
_333:
	dd	_111
	dd	118
	dd	8
	align	4
_335:
	dd	_111
	dd	119
	dd	3
	align	4
_340:
	dd	3
	dd	0
	dd	0
	align	4
_339:
	dd	_111
	dd	119
	dd	27
	align	4
_7:
	dd	_bbStringClass
	dd	2147483647
	dd	28
	dw	85,110,97,98,108,101,32,116,111,32,99,97,108,99,117,108
	dw	97,116,101,32,116,101,120,32,115,105,122,101
	align	4
_341:
	dd	_111
	dd	120
	dd	3
	align	4
_344:
	dd	3
	dd	0
	dd	0
	align	4
_343:
	dd	_111
	dd	120
	dd	14
	align	4
_345:
	dd	_111
	dd	121
	dd	3
	align	4
_348:
	dd	3
	dd	0
	dd	0
	align	4
_347:
	dd	_111
	dd	121
	dd	15
_362:
	db	"Pow2Size",0
_363:
	db	"n",0
	align	4
_361:
	dd	1
	dd	_362
	dd	2
	dd	_363
	dd	_21
	dd	-4
	dd	2
	dd	_350
	dd	_21
	dd	-8
	dd	0
	align	4
_355:
	dd	_111
	dd	126
	dd	2
	align	4
_357:
	dd	_111
	dd	127
	dd	2
	align	4
_359:
	dd	3
	dd	0
	dd	0
	align	4
_358:
	dd	_111
	dd	128
	dd	3
	align	4
_360:
	dd	_111
	dd	130
	dd	2
