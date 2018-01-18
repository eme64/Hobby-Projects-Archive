	format	MS COFF
	extrn	___bb_appstub_appstub
	extrn	___bb_audio_audio
	extrn	___bb_bank_bank
	extrn	___bb_bankstream_bankstream
	extrn	___bb_basic_basic
	extrn	___bb_blitz_blitz
	extrn	___bb_bmploader_bmploader
	extrn	___bb_d3d7max2d_d3d7max2d
	extrn	___bb_d3d9max2d_d3d9max2d
	extrn	___bb_data_data
	extrn	___bb_directsoundaudio_directsoundaudio
	extrn	___bb_eventqueue_eventqueue
	extrn	___bb_freeaudioaudio_freeaudioaudio
	extrn	___bb_freejoy_freejoy
	extrn	___bb_freeprocess_freeprocess
	extrn	___bb_freetypefont_freetypefont
	extrn	___bb_glew_glew
	extrn	___bb_gnet_gnet
	extrn	___bb_jpgloader_jpgloader
	extrn	___bb_macos_macos
	extrn	___bb_map_map
	extrn	___bb_maxlua_maxlua
	extrn	___bb_maxutil_maxutil
	extrn	___bb_oggloader_oggloader
	extrn	___bb_openalaudio_openalaudio
	extrn	___bb_pngloader_pngloader
	extrn	___bb_retro_retro
	extrn	___bb_tgaloader_tgaloader
	extrn	___bb_threads_threads
	extrn	___bb_timer_timer
	extrn	___bb_wavloader_wavloader
	extrn	_bbATan2
	extrn	_bbCos
	extrn	_bbEnd
	extrn	_bbFloatAbs
	extrn	_bbFloatPow
	extrn	_bbFloatToInt
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
	extrn	_bbSin
	extrn	_brl_blitz_NullObjectError
	extrn	_brl_graphics_Flip
	extrn	_brl_graphics_Graphics
	extrn	_brl_linkedlist_TList
	extrn	_brl_max2d_Cls
	extrn	_brl_max2d_DrawLine
	extrn	_brl_max2d_DrawOval
	extrn	_brl_max2d_SetColor
	extrn	_brl_polledinput_KeyHit
	extrn	_brl_polledinput_MouseDown
	extrn	_brl_polledinput_MouseHit
	extrn	_brl_polledinput_MouseX
	extrn	_brl_polledinput_MouseY
	extrn	_brl_random_Rand
	public	__bb_TFEDER_Delete
	public	__bb_TFEDER_New
	public	__bb_TFEDER_create
	public	__bb_TFEDER_draw
	public	__bb_TFEDER_ini
	public	__bb_TFEDER_liste
	public	__bb_TFEDER_render
	public	__bb_TOBJEKT_Delete
	public	__bb_TOBJEKT_New
	public	__bb_TOBJEKT_draw
	public	__bb_TOBJEKT_ini
	public	__bb_TOBJEKT_init
	public	__bb_TOBJEKT_liste
	public	__bb_TOBJEKT_render
	public	__bb_main
	public	_bb_TFEDER
	public	_bb_TOBJEKT
	section	"code" code
__bb_main:
	push	ebp
	mov	ebp,esp
	sub	esp,84
	push	ebx
	push	esi
	push	edi
	cmp	dword [_263],0
	je	_264
	mov	eax,0
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_264:
	mov	dword [_263],1
	mov	dword [ebp-4],_bbNullObject
	fldz
	fstp	dword [ebp-8]
	mov	dword [ebp-12],0
	mov	dword [ebp-16],_bbNullObject
	mov	dword [ebp-20],_bbNullObject
	fldz
	fstp	dword [ebp-24]
	mov	dword [ebp-28],_bbNullObject
	mov	dword [ebp-32],_bbNullObject
	mov	dword [ebp-36],_bbNullObject
	mov	dword [ebp-40],_bbNullObject
	mov	eax,ebp
	push	eax
	push	_261
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	___bb_blitz_blitz
	call	___bb_appstub_appstub
	call	___bb_audio_audio
	call	___bb_bank_bank
	call	___bb_bankstream_bankstream
	call	___bb_basic_basic
	call	___bb_bmploader_bmploader
	call	___bb_d3d7max2d_d3d7max2d
	call	___bb_d3d9max2d_d3d9max2d
	call	___bb_data_data
	call	___bb_directsoundaudio_directsoundaudio
	call	___bb_eventqueue_eventqueue
	call	___bb_freeaudioaudio_freeaudioaudio
	call	___bb_freetypefont_freetypefont
	call	___bb_gnet_gnet
	call	___bb_jpgloader_jpgloader
	call	___bb_map_map
	call	___bb_maxlua_maxlua
	call	___bb_maxutil_maxutil
	call	___bb_oggloader_oggloader
	call	___bb_openalaudio_openalaudio
	call	___bb_pngloader_pngloader
	call	___bb_retro_retro
	call	___bb_tgaloader_tgaloader
	call	___bb_threads_threads
	call	___bb_timer_timer
	call	___bb_wavloader_wavloader
	call	___bb_freejoy_freejoy
	call	___bb_freeprocess_freeprocess
	call	___bb_glew_glew
	call	___bb_macos_macos
	push	_112
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_TOBJEKT
	call	_bbObjectRegisterType
	add	esp,4
	push	_114
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_TFEDER
	call	_bbObjectRegisterType
	add	esp,4
	push	_115
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	60
	push	0
	push	600
	push	800
	call	_brl_graphics_Graphics
	add	esp,20
	push	_116
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bb_TOBJEKT+48]
	push	_117
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bb_TFEDER+48]
	push	_118
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
_24:
	mov	eax,ebp
	push	eax
	push	_259
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_119
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	_brl_max2d_Cls
	push	_120
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	32
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_121
	mov	eax,ebp
	push	eax
	push	_124
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_122
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bb_TOBJEKT+48]
	push	_123
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bb_TFEDER+48]
	call	dword [_bbOnDebugLeaveScope]
_121:
	push	_125
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1
	call	_brl_polledinput_MouseHit
	add	esp,4
	cmp	eax,0
	jne	_126
	push	2
	call	_brl_polledinput_MouseDown
	add	esp,4
_126:
	cmp	eax,0
	je	_128
	mov	eax,ebp
	push	eax
	push	_192
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_129
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_TOBJEKT
	call	_bbObjectNew
	add	esp,4
	mov	dword [ebp-4],eax
	push	_131
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	5
	push	0
	call	_brl_random_Rand
	add	esp,8
	mov	dword [ebp+-84],eax
	fild	dword [ebp+-84]
	fstp	dword [ebp-8]
	push	_133
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_135
	call	_brl_blitz_NullObjectError
_135:
	fld	dword [_570]
	fld	dword [_571]
	fmul	dword [ebp-8]
	faddp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	fld	dword [_572]
	fadd	dword [ebp-8]
	sub	esp,4
	fstp	dword [esp]
	call	_brl_polledinput_MouseY
	mov	dword [ebp+-84],eax
	fild	dword [ebp+-84]
	sub	esp,4
	fstp	dword [esp]
	call	_brl_polledinput_MouseX
	mov	dword [ebp+-84],eax
	fild	dword [ebp+-84]
	sub	esp,4
	fstp	dword [esp]
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,20
	push	_136
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-12],1
	push	_138
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-16],_bbNullObject
	mov	eax,dword [__bb_TOBJEKT_liste]
	mov	dword [ebp-80],eax
	mov	ebx,dword [ebp-80]
	cmp	ebx,_bbNullObject
	jne	_142
	call	_brl_blitz_NullObjectError
_142:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+140]
	add	esp,4
	mov	dword [ebp-68],eax
	jmp	_25
_27:
	mov	ebx,dword [ebp-68]
	cmp	ebx,_bbNullObject
	jne	_147
	call	_brl_blitz_NullObjectError
_147:
	push	_bb_TOBJEKT
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,4
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	mov	dword [ebp-16],eax
	cmp	dword [ebp-16],_bbNullObject
	je	_25
	mov	eax,ebp
	push	eax
	push	_160
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_148
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [ebp-60],eax
	cmp	dword [ebp-60],_bbNullObject
	jne	_150
	call	_brl_blitz_NullObjectError
_150:
	mov	edi,dword [ebp-16]
	cmp	edi,_bbNullObject
	jne	_152
	call	_brl_blitz_NullObjectError
_152:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_154
	call	_brl_blitz_NullObjectError
_154:
	mov	ebx,dword [ebp-16]
	cmp	ebx,_bbNullObject
	jne	_156
	call	_brl_blitz_NullObjectError
_156:
	fld	qword [_573]
	sub	esp,8
	fstp	qword [esp]
	fld	qword [_574]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-60]
	fld	dword [eax+8]
	fsub	dword [edi+8]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-56]
	fld	qword [_575]
	sub	esp,8
	fstp	qword [esp]
	fld	dword [esi+16]
	fsub	dword [ebx+16]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [ebp-56]
	faddp	st1,st0
	fstp	qword [ebp-56]
	fld	qword [ebp-56]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [_576]
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setae	al
	movzx	eax,al
	cmp	eax,0
	jne	_157
	mov	eax,ebp
	push	eax
	push	_159
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_158
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-12],0
	call	dword [_bbOnDebugLeaveScope]
_157:
	call	dword [_bbOnDebugLeaveScope]
_25:
	mov	ebx,dword [ebp-68]
	cmp	ebx,_bbNullObject
	jne	_145
	call	_brl_blitz_NullObjectError
_145:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_27
_26:
	push	_161
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	cmp	dword [ebp-12],1
	jne	_162
	mov	eax,ebp
	push	eax
	push	_188
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_163
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-20],_bbNullObject
	mov	eax,dword [__bb_TOBJEKT_liste]
	mov	dword [ebp-76],eax
	mov	ebx,dword [ebp-76]
	cmp	ebx,_bbNullObject
	jne	_167
	call	_brl_blitz_NullObjectError
_167:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+140]
	add	esp,4
	mov	dword [ebp-72],eax
	jmp	_28
_30:
	mov	ebx,dword [ebp-72]
	cmp	ebx,_bbNullObject
	jne	_172
	call	_brl_blitz_NullObjectError
_172:
	push	_bb_TOBJEKT
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,4
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	mov	dword [ebp-20],eax
	cmp	dword [ebp-20],_bbNullObject
	je	_28
	mov	eax,ebp
	push	eax
	push	_187
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_173
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [ebp-64],eax
	cmp	dword [ebp-64],_bbNullObject
	jne	_175
	call	_brl_blitz_NullObjectError
_175:
	mov	edi,dword [ebp-20]
	cmp	edi,_bbNullObject
	jne	_177
	call	_brl_blitz_NullObjectError
_177:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_179
	call	_brl_blitz_NullObjectError
_179:
	mov	ebx,dword [ebp-20]
	cmp	ebx,_bbNullObject
	jne	_181
	call	_brl_blitz_NullObjectError
_181:
	fld	qword [_577]
	sub	esp,8
	fstp	qword [esp]
	fld	qword [_578]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-64]
	fld	dword [eax+8]
	fsub	dword [edi+8]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-48]
	fld	qword [_579]
	sub	esp,8
	fstp	qword [esp]
	fld	dword [esi+16]
	fsub	dword [ebx+16]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [ebp-48]
	faddp	st1,st0
	fstp	qword [ebp-48]
	fld	qword [ebp-48]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	dword [ebp-24]
	push	_183
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [ebp-24]
	fld	dword [_580]
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setae	al
	movzx	eax,al
	cmp	eax,0
	jne	_184
	mov	eax,ebp
	push	eax
	push	_186
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_185
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1028443341
	push	1116471296
	push	dword [ebp-20]
	push	dword [ebp-4]
	call	dword [_bb_TFEDER+52]
	add	esp,16
	call	dword [_bbOnDebugLeaveScope]
_184:
	call	dword [_bbOnDebugLeaveScope]
_28:
	mov	ebx,dword [ebp-72]
	cmp	ebx,_bbNullObject
	jne	_170
	call	_brl_blitz_NullObjectError
_170:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_30
_29:
	call	dword [_bbOnDebugLeaveScope]
_162:
	push	_189
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [__bb_TOBJEKT_liste]
	cmp	ebx,_bbNullObject
	jne	_191
	call	_brl_blitz_NullObjectError
_191:
	push	dword [ebp-4]
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+68]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
_128:
	push	_197
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-28],_bbNullObject
	mov	edi,dword [__bb_TOBJEKT_liste]
	mov	ebx,edi
	cmp	ebx,_bbNullObject
	jne	_201
	call	_brl_blitz_NullObjectError
_201:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+140]
	add	esp,4
	mov	esi,eax
	jmp	_31
_33:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_206
	call	_brl_blitz_NullObjectError
_206:
	push	_bb_TOBJEKT
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,4
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	mov	dword [ebp-28],eax
	cmp	dword [ebp-28],_bbNullObject
	je	_31
	mov	eax,ebp
	push	eax
	push	_210
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_207
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-28]
	cmp	ebx,_bbNullObject
	jne	_209
	call	_brl_blitz_NullObjectError
_209:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+56]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
_31:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_204
	call	_brl_blitz_NullObjectError
_204:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_33
_32:
	push	_211
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	50
	push	50
	push	50
	call	_brl_max2d_SetColor
	add	esp,12
	push	_212
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1128792064
	push	1128792064
	call	_brl_polledinput_MouseY
	sub	eax,100
	mov	dword [ebp+-84],eax
	fild	dword [ebp+-84]
	sub	esp,4
	fstp	dword [esp]
	call	_brl_polledinput_MouseX
	sub	eax,100
	mov	dword [ebp+-84],eax
	fild	dword [ebp+-84]
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_DrawOval
	add	esp,16
	push	_213
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	100
	push	100
	push	100
	call	_brl_max2d_SetColor
	add	esp,12
	push	_214
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1120403456
	push	1120403456
	call	_brl_polledinput_MouseY
	sub	eax,50
	mov	dword [ebp+-84],eax
	fild	dword [ebp+-84]
	sub	esp,4
	fstp	dword [esp]
	call	_brl_polledinput_MouseX
	sub	eax,50
	mov	dword [ebp+-84],eax
	fild	dword [ebp+-84]
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_DrawOval
	add	esp,16
	push	_215
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-32],_bbNullObject
	mov	edi,dword [__bb_TFEDER_liste]
	mov	ebx,edi
	cmp	ebx,_bbNullObject
	jne	_219
	call	_brl_blitz_NullObjectError
_219:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+140]
	add	esp,4
	mov	esi,eax
	jmp	_34
_36:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_224
	call	_brl_blitz_NullObjectError
_224:
	push	_bb_TFEDER
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,4
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	mov	dword [ebp-32],eax
	cmp	dword [ebp-32],_bbNullObject
	je	_34
	mov	eax,ebp
	push	eax
	push	_228
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_225
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-32]
	cmp	ebx,_bbNullObject
	jne	_227
	call	_brl_blitz_NullObjectError
_227:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+56]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
_34:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_222
	call	_brl_blitz_NullObjectError
_222:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_36
_35:
	push	_230
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-36],_bbNullObject
	mov	edi,dword [__bb_TFEDER_liste]
	mov	ebx,edi
	cmp	ebx,_bbNullObject
	jne	_234
	call	_brl_blitz_NullObjectError
_234:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+140]
	add	esp,4
	mov	esi,eax
	jmp	_37
_39:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_239
	call	_brl_blitz_NullObjectError
_239:
	push	_bb_TFEDER
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,4
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	mov	dword [ebp-36],eax
	cmp	dword [ebp-36],_bbNullObject
	je	_37
	mov	eax,ebp
	push	eax
	push	_243
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_240
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-36]
	cmp	ebx,_bbNullObject
	jne	_242
	call	_brl_blitz_NullObjectError
_242:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+60]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
_37:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_237
	call	_brl_blitz_NullObjectError
_237:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_39
_38:
	push	_244
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-40],_bbNullObject
	mov	edi,dword [__bb_TOBJEKT_liste]
	mov	ebx,edi
	cmp	ebx,_bbNullObject
	jne	_248
	call	_brl_blitz_NullObjectError
_248:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+140]
	add	esp,4
	mov	esi,eax
	jmp	_40
_42:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_253
	call	_brl_blitz_NullObjectError
_253:
	push	_bb_TOBJEKT
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,4
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	mov	dword [ebp-40],eax
	cmp	dword [ebp-40],_bbNullObject
	je	_40
	mov	eax,ebp
	push	eax
	push	_257
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_254
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-40]
	cmp	ebx,_bbNullObject
	jne	_256
	call	_brl_blitz_NullObjectError
_256:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+60]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
_40:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_251
	call	_brl_blitz_NullObjectError
_251:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_42
_41:
	push	_258
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	-1
	call	_brl_graphics_Flip
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
_22:
	push	27
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_24
_23:
	push	_260
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	_bbEnd
	mov	ebx,0
	jmp	_69
_69:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TOBJEKT_New:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_266
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	dword [ebp-4]
	call	_bbObjectCtor
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [eax],_bb_TOBJEKT
	mov	eax,dword [ebp-4]
	fldz
	fstp	dword [eax+8]
	mov	eax,dword [ebp-4]
	fldz
	fstp	dword [eax+12]
	mov	eax,dword [ebp-4]
	fldz
	fstp	dword [eax+16]
	mov	eax,dword [ebp-4]
	fldz
	fstp	dword [eax+20]
	mov	eax,dword [ebp-4]
	fldz
	fstp	dword [eax+24]
	mov	eax,dword [ebp-4]
	fldz
	fstp	dword [eax+28]
	push	ebp
	push	_265
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
	mov	ebx,0
	jmp	_72
_72:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TOBJEKT_Delete:
	push	ebp
	mov	ebp,esp
_75:
	mov	eax,0
	jmp	_268
_268:
	mov	esp,ebp
	pop	ebp
	ret
__bb_TOBJEKT_ini:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	ebp
	push	_274
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_269
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_brl_linkedlist_TList
	call	_bbObjectNew
	add	esp,4
	inc	dword [eax+4]
	mov	ebx,eax
	mov	eax,dword [__bb_TOBJEKT_liste]
	dec	dword [eax+4]
	jnz	_273
	push	eax
	call	_bbGCFree
	add	esp,4
_273:
	mov	dword [__bb_TOBJEKT_liste],ebx
	mov	ebx,0
	jmp	_77
_77:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TOBJEKT_init:
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
	push	_299
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_275
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_277
	call	_brl_blitz_NullObjectError
_277:
	fld	dword [ebp-8]
	fstp	dword [ebx+8]
	push	_279
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_281
	call	_brl_blitz_NullObjectError
_281:
	fld	dword [ebp-12]
	fstp	dword [ebx+16]
	push	_283
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_285
	call	_brl_blitz_NullObjectError
_285:
	fldz
	fstp	dword [ebx+12]
	push	_287
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_289
	call	_brl_blitz_NullObjectError
_289:
	fldz
	fstp	dword [ebx+20]
	push	_291
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_293
	call	_brl_blitz_NullObjectError
_293:
	fld	dword [ebp-16]
	fstp	dword [ebx+24]
	push	_295
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_297
	call	_brl_blitz_NullObjectError
_297:
	fld	dword [ebp-20]
	fstp	dword [ebx+28]
	mov	ebx,0
	jmp	_84
_84:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TOBJEKT_render:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	push	esi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_379
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_300
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_302
	call	_brl_blitz_NullObjectError
_302:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_305
	call	_brl_blitz_NullObjectError
_305:
	fld	dword [ebx+8]
	fadd	dword [esi+12]
	fstp	dword [ebx+8]
	push	_306
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_308
	call	_brl_blitz_NullObjectError
_308:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_311
	call	_brl_blitz_NullObjectError
_311:
	fld	dword [ebx+16]
	fadd	dword [esi+20]
	fstp	dword [ebx+16]
	push	_312
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_314
	call	_brl_blitz_NullObjectError
_314:
	fld	dword [ebx+20]
	fadd	dword [_642]
	fstp	dword [ebx+20]
	push	_316
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_318
	call	_brl_blitz_NullObjectError
_318:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_320
	call	_brl_blitz_NullObjectError
_320:
	fld	dword [esi+16]
	fld	dword [_643]
	fsub	dword [ebx+24]
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_321
	push	ebp
	push	_336
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_322
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_324
	call	_brl_blitz_NullObjectError
_324:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_327
	call	_brl_blitz_NullObjectError
_327:
	fld	dword [_644]
	fsub	dword [esi+24]
	fstp	dword [ebx+16]
	push	_328
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_330
	call	_brl_blitz_NullObjectError
_330:
	fldz
	fstp	dword [ebx+20]
	push	_332
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_334
	call	_brl_blitz_NullObjectError
_334:
	fld	dword [ebx+12]
	fmul	dword [_645]
	fstp	dword [ebx+12]
	call	dword [_bbOnDebugLeaveScope]
_321:
	push	_337
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_339
	call	_brl_blitz_NullObjectError
_339:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_341
	call	_brl_blitz_NullObjectError
_341:
	fld	dword [esi+8]
	fld	dword [_646]
	fsub	dword [ebx+24]
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_342
	push	ebp
	push	_357
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_343
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_345
	call	_brl_blitz_NullObjectError
_345:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_348
	call	_brl_blitz_NullObjectError
_348:
	fld	dword [_647]
	fsub	dword [esi+24]
	fstp	dword [ebx+8]
	push	_349
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_351
	call	_brl_blitz_NullObjectError
_351:
	fldz
	fstp	dword [ebx+12]
	push	_353
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_355
	call	_brl_blitz_NullObjectError
_355:
	fld	dword [ebx+20]
	fmul	dword [_648]
	fstp	dword [ebx+20]
	call	dword [_bbOnDebugLeaveScope]
_342:
	push	_358
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_360
	call	_brl_blitz_NullObjectError
_360:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_362
	call	_brl_blitz_NullObjectError
_362:
	fld	dword [esi+8]
	fld	dword [ebx+24]
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setae	al
	movzx	eax,al
	cmp	eax,0
	jne	_363
	push	ebp
	push	_378
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_364
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_366
	call	_brl_blitz_NullObjectError
_366:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_369
	call	_brl_blitz_NullObjectError
_369:
	fld	dword [esi+24]
	fstp	dword [ebx+8]
	push	_370
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_372
	call	_brl_blitz_NullObjectError
_372:
	fldz
	fstp	dword [ebx+12]
	push	_374
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_376
	call	_brl_blitz_NullObjectError
_376:
	fld	dword [ebx+20]
	fmul	dword [_649]
	fstp	dword [ebx+20]
	call	dword [_bbOnDebugLeaveScope]
_363:
	mov	ebx,0
	jmp	_87
_87:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TOBJEKT_draw:
	push	ebp
	mov	ebp,esp
	sub	esp,16
	push	ebx
	push	esi
	push	edi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	eax,ebp
	push	eax
	push	_394
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_380
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	255
	push	255
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	_381
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [ebp-16],eax
	cmp	dword [ebp-16],_bbNullObject
	jne	_383
	call	_brl_blitz_NullObjectError
_383:
	mov	eax,dword [ebp-4]
	mov	dword [ebp-12],eax
	cmp	dword [ebp-12],_bbNullObject
	jne	_385
	call	_brl_blitz_NullObjectError
_385:
	mov	eax,dword [ebp-4]
	mov	dword [ebp-8],eax
	cmp	dword [ebp-8],_bbNullObject
	jne	_387
	call	_brl_blitz_NullObjectError
_387:
	mov	edi,dword [ebp-4]
	cmp	edi,_bbNullObject
	jne	_389
	call	_brl_blitz_NullObjectError
_389:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_391
	call	_brl_blitz_NullObjectError
_391:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_393
	call	_brl_blitz_NullObjectError
_393:
	fld	dword [ebx+24]
	fmul	dword [_678]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [esi+24]
	fmul	dword [_679]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-8]
	fld	dword [eax+16]
	fsub	dword [edi+24]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-16]
	fld	dword [eax+8]
	mov	eax,dword [ebp-12]
	fsub	dword [eax+24]
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_DrawOval
	add	esp,16
	mov	ebx,0
	jmp	_90
_90:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TFEDER_New:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_398
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	dword [ebp-4]
	call	_bbObjectCtor
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [eax],_bb_TFEDER
	mov	edx,_bbNullObject
	inc	dword [edx+4]
	mov	eax,dword [ebp-4]
	mov	dword [eax+8],edx
	mov	edx,_bbNullObject
	inc	dword [edx+4]
	mov	eax,dword [ebp-4]
	mov	dword [eax+12],edx
	mov	eax,dword [ebp-4]
	fldz
	fstp	dword [eax+16]
	mov	eax,dword [ebp-4]
	fldz
	fstp	dword [eax+20]
	push	ebp
	push	_397
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
	mov	ebx,0
	jmp	_93
_93:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TFEDER_Delete:
	push	ebp
	mov	ebp,esp
	push	ebx
	mov	ebx,dword [ebp+8]
_96:
	mov	eax,dword [ebx+12]
	dec	dword [eax+4]
	jnz	_401
	push	eax
	call	_bbGCFree
	add	esp,4
_401:
	mov	eax,dword [ebx+8]
	dec	dword [eax+4]
	jnz	_403
	push	eax
	call	_bbGCFree
	add	esp,4
_403:
	mov	eax,0
	jmp	_399
_399:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TFEDER_ini:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	ebp
	push	_409
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_404
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_brl_linkedlist_TList
	call	_bbObjectNew
	add	esp,4
	inc	dword [eax+4]
	mov	ebx,eax
	mov	eax,dword [__bb_TFEDER_liste]
	dec	dword [eax+4]
	jnz	_408
	push	eax
	call	_bbGCFree
	add	esp,4
_408:
	mov	dword [__bb_TFEDER_liste],ebx
	mov	ebx,0
	jmp	_98
_98:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TFEDER_create:
	push	ebp
	mov	ebp,esp
	sub	esp,20
	push	ebx
	push	esi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	eax,dword [ebp+12]
	mov	dword [ebp-8],eax
	fld	dword [ebp+16]
	fstp	dword [ebp-12]
	fld	dword [ebp+20]
	fstp	dword [ebp-16]
	mov	dword [ebp-20],_bbNullObject
	push	ebp
	push	_440
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_410
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_TFEDER
	call	_bbObjectNew
	add	esp,4
	mov	dword [ebp-20],eax
	push	_412
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-20]
	cmp	esi,_bbNullObject
	jne	_414
	call	_brl_blitz_NullObjectError
_414:
	mov	ebx,dword [ebp-4]
	inc	dword [ebx+4]
	mov	eax,dword [esi+8]
	dec	dword [eax+4]
	jnz	_419
	push	eax
	call	_bbGCFree
	add	esp,4
_419:
	mov	dword [esi+8],ebx
	push	_420
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-20]
	cmp	esi,_bbNullObject
	jne	_422
	call	_brl_blitz_NullObjectError
_422:
	mov	ebx,dword [ebp-8]
	inc	dword [ebx+4]
	mov	eax,dword [esi+12]
	dec	dword [eax+4]
	jnz	_427
	push	eax
	call	_bbGCFree
	add	esp,4
_427:
	mov	dword [esi+12],ebx
	push	_428
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-20]
	cmp	ebx,_bbNullObject
	jne	_430
	call	_brl_blitz_NullObjectError
_430:
	fld	dword [ebp-12]
	fstp	dword [ebx+16]
	push	_432
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-20]
	cmp	ebx,_bbNullObject
	jne	_434
	call	_brl_blitz_NullObjectError
_434:
	fld	dword [ebp-16]
	fstp	dword [ebx+20]
	push	_436
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [__bb_TFEDER_liste]
	cmp	ebx,_bbNullObject
	jne	_438
	call	_brl_blitz_NullObjectError
_438:
	push	dword [ebp-20]
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+68]
	add	esp,8
	push	_439
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-20]
	jmp	_104
_104:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TFEDER_render:
	push	ebp
	mov	ebp,esp
	sub	esp,64
	push	ebx
	push	esi
	push	edi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	fldz
	fstp	dword [ebp-8]
	fldz
	fstp	dword [ebp-12]
	fldz
	fstp	dword [ebp-16]
	mov	eax,ebp
	push	eax
	push	_523
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_441
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_443
	call	_brl_blitz_NullObjectError
_443:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-60],eax
	cmp	dword [ebp-60],_bbNullObject
	jne	_445
	call	_brl_blitz_NullObjectError
_445:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_447
	call	_brl_blitz_NullObjectError
_447:
	mov	edi,dword [ebx+12]
	cmp	edi,_bbNullObject
	jne	_449
	call	_brl_blitz_NullObjectError
_449:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_451
	call	_brl_blitz_NullObjectError
_451:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_453
	call	_brl_blitz_NullObjectError
_453:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_455
	call	_brl_blitz_NullObjectError
_455:
	mov	esi,dword [esi+12]
	cmp	esi,_bbNullObject
	jne	_457
	call	_brl_blitz_NullObjectError
_457:
	fld	qword [_702]
	sub	esp,8
	fstp	qword [esp]
	fld	qword [_703]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-60]
	fld	dword [eax+8]
	fsub	dword [edi+8]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-24]
	fld	qword [_704]
	sub	esp,8
	fstp	qword [esp]
	fld	dword [ebx+16]
	fsub	dword [esi+16]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [ebp-24]
	faddp	st1,st0
	fstp	qword [ebp-24]
	fld	qword [ebp-24]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	dword [ebp-8]
	push	_459
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_461
	call	_brl_blitz_NullObjectError
_461:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_463
	call	_brl_blitz_NullObjectError
_463:
	fld	dword [esi+20]
	fchs
	fld	dword [ebx+16]
	fsub	dword [ebp-8]
	fmulp	st1,st0
	fstp	dword [ebp-12]
	push	_465
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_467
	call	_brl_blitz_NullObjectError
_467:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-64],eax
	cmp	dword [ebp-64],_bbNullObject
	jne	_469
	call	_brl_blitz_NullObjectError
_469:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_471
	call	_brl_blitz_NullObjectError
_471:
	mov	edi,dword [ebx+12]
	cmp	edi,_bbNullObject
	jne	_473
	call	_brl_blitz_NullObjectError
_473:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_475
	call	_brl_blitz_NullObjectError
_475:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_477
	call	_brl_blitz_NullObjectError
_477:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_479
	call	_brl_blitz_NullObjectError
_479:
	mov	esi,dword [esi+12]
	cmp	esi,_bbNullObject
	jne	_481
	call	_brl_blitz_NullObjectError
_481:
	fld	dword [ebx+8]
	fsub	dword [esi+8]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-64]
	fld	dword [eax+16]
	fsub	dword [edi+16]
	sub	esp,8
	fstp	qword [esp]
	call	_bbATan2
	add	esp,16
	fstp	dword [ebp-16]
	push	_483
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_485
	call	_brl_blitz_NullObjectError
_485:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_487
	call	_brl_blitz_NullObjectError
_487:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_490
	call	_brl_blitz_NullObjectError
_490:
	mov	esi,dword [esi+8]
	cmp	esi,_bbNullObject
	jne	_492
	call	_brl_blitz_NullObjectError
_492:
	fld	dword [ebx+12]
	fstp	qword [ebp-32]
	fld	dword [ebp-16]
	sub	esp,8
	fstp	qword [esp]
	call	_bbCos
	add	esp,8
	fld	dword [ebp-12]
	fmulp	st1,st0
	fld	dword [esi+28]
	fdivp	st1,st0
	fld	qword [ebp-32]
	fsubrp	st1,st0
	fstp	qword [ebp-32]
	fld	qword [ebp-32]
	fstp	dword [ebx+12]
	push	_493
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_495
	call	_brl_blitz_NullObjectError
_495:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_497
	call	_brl_blitz_NullObjectError
_497:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_500
	call	_brl_blitz_NullObjectError
_500:
	mov	esi,dword [esi+8]
	cmp	esi,_bbNullObject
	jne	_502
	call	_brl_blitz_NullObjectError
_502:
	fld	dword [ebx+20]
	fstp	qword [ebp-40]
	fld	dword [ebp-16]
	sub	esp,8
	fstp	qword [esp]
	call	_bbSin
	add	esp,8
	fld	dword [ebp-12]
	fmulp	st1,st0
	fld	dword [esi+28]
	fdivp	st1,st0
	fld	qword [ebp-40]
	fsubrp	st1,st0
	fstp	qword [ebp-40]
	fld	qword [ebp-40]
	fstp	dword [ebx+20]
	push	_503
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_505
	call	_brl_blitz_NullObjectError
_505:
	mov	ebx,dword [ebx+12]
	cmp	ebx,_bbNullObject
	jne	_507
	call	_brl_blitz_NullObjectError
_507:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_510
	call	_brl_blitz_NullObjectError
_510:
	mov	esi,dword [esi+12]
	cmp	esi,_bbNullObject
	jne	_512
	call	_brl_blitz_NullObjectError
_512:
	fld	dword [ebx+12]
	fstp	qword [ebp-48]
	fld	dword [ebp-16]
	sub	esp,8
	fstp	qword [esp]
	call	_bbCos
	add	esp,8
	fld	dword [ebp-12]
	fmulp	st1,st0
	fld	dword [esi+28]
	fdivp	st1,st0
	fld	qword [ebp-48]
	faddp	st1,st0
	fstp	qword [ebp-48]
	fld	qword [ebp-48]
	fstp	dword [ebx+12]
	push	_513
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_515
	call	_brl_blitz_NullObjectError
_515:
	mov	ebx,dword [ebx+12]
	cmp	ebx,_bbNullObject
	jne	_517
	call	_brl_blitz_NullObjectError
_517:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_520
	call	_brl_blitz_NullObjectError
_520:
	mov	esi,dword [esi+12]
	cmp	esi,_bbNullObject
	jne	_522
	call	_brl_blitz_NullObjectError
_522:
	fld	dword [ebx+20]
	fstp	qword [ebp-56]
	fld	dword [ebp-16]
	sub	esp,8
	fstp	qword [esp]
	call	_bbSin
	add	esp,8
	fld	dword [ebp-12]
	fmulp	st1,st0
	fld	dword [esi+28]
	fdivp	st1,st0
	fld	qword [ebp-56]
	faddp	st1,st0
	fstp	qword [ebp-56]
	fld	qword [ebp-56]
	fstp	dword [ebx+20]
	mov	ebx,0
	jmp	_107
_107:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TFEDER_draw:
	push	ebp
	mov	ebp,esp
	sub	esp,28
	push	ebx
	push	esi
	push	edi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	fldz
	fstp	dword [ebp-8]
	fldz
	fstp	dword [ebp-12]
	mov	eax,ebp
	push	eax
	push	_568
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_526
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_528
	call	_brl_blitz_NullObjectError
_528:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-24],eax
	cmp	dword [ebp-24],_bbNullObject
	jne	_530
	call	_brl_blitz_NullObjectError
_530:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_532
	call	_brl_blitz_NullObjectError
_532:
	mov	edi,dword [ebx+12]
	cmp	edi,_bbNullObject
	jne	_534
	call	_brl_blitz_NullObjectError
_534:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_536
	call	_brl_blitz_NullObjectError
_536:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_538
	call	_brl_blitz_NullObjectError
_538:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_540
	call	_brl_blitz_NullObjectError
_540:
	mov	esi,dword [esi+12]
	cmp	esi,_bbNullObject
	jne	_542
	call	_brl_blitz_NullObjectError
_542:
	fld	qword [_741]
	sub	esp,8
	fstp	qword [esp]
	fld	qword [_742]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-24]
	fld	dword [eax+8]
	fsub	dword [edi+8]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-20]
	fld	qword [_743]
	sub	esp,8
	fstp	qword [esp]
	fld	dword [ebx+16]
	fsub	dword [esi+16]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [ebp-20]
	faddp	st1,st0
	fstp	qword [ebp-20]
	fld	qword [ebp-20]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	dword [ebp-8]
	push	_544
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_546
	call	_brl_blitz_NullObjectError
_546:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_548
	call	_brl_blitz_NullObjectError
_548:
	fld	dword [esi+16]
	fsub	dword [ebp-8]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatAbs
	add	esp,8
	fdiv	dword [ebx+16]
	fmul	dword [_744]
	fstp	dword [ebp-12]
	push	_550
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	fld	dword [_745]
	fsub	dword [ebp-12]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	push	eax
	fld	dword [ebp-12]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	push	eax
	call	_brl_max2d_SetColor
	add	esp,12
	push	_551
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_553
	call	_brl_blitz_NullObjectError
_553:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-28],eax
	cmp	dword [ebp-28],_bbNullObject
	jne	_555
	call	_brl_blitz_NullObjectError
_555:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_557
	call	_brl_blitz_NullObjectError
_557:
	mov	edi,dword [ebx+8]
	cmp	edi,_bbNullObject
	jne	_559
	call	_brl_blitz_NullObjectError
_559:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_561
	call	_brl_blitz_NullObjectError
_561:
	mov	ebx,dword [ebx+12]
	cmp	ebx,_bbNullObject
	jne	_563
	call	_brl_blitz_NullObjectError
_563:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_565
	call	_brl_blitz_NullObjectError
_565:
	mov	esi,dword [esi+12]
	cmp	esi,_bbNullObject
	jne	_567
	call	_brl_blitz_NullObjectError
_567:
	push	1
	push	dword [esi+16]
	push	dword [ebx+8]
	push	dword [edi+16]
	mov	eax,dword [ebp-28]
	push	dword [eax+8]
	call	_brl_max2d_DrawLine
	add	esp,20
	mov	ebx,0
	jmp	_110
_110:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
	section	"data" data writeable align 8
	align	4
_263:
	dd	0
_262:
	db	"1",0
	align	4
_261:
	dd	1
	dd	_262
	dd	0
_113:
	db	"C:/Users/Emanuel/Documents/Projekte/BMX/GAMES/GOO_2.0/v1/1.bmx",0
	align	4
_112:
	dd	_113
	dd	5
	dd	2
	align	4
__bb_TOBJEKT_liste:
	dd	_bbNullObject
_44:
	db	"TOBJEKT",0
_45:
	db	"x",0
_46:
	db	"f",0
_47:
	db	"vx",0
_48:
	db	"y",0
_49:
	db	"vy",0
_50:
	db	"r",0
_51:
	db	"m",0
_52:
	db	"New",0
_53:
	db	"()i",0
_54:
	db	"Delete",0
_55:
	db	"ini",0
_56:
	db	"init",0
_57:
	db	"(f,f,f,f)i",0
_58:
	db	"render",0
_59:
	db	"draw",0
	align	4
_43:
	dd	2
	dd	_44
	dd	3
	dd	_45
	dd	_46
	dd	8
	dd	3
	dd	_47
	dd	_46
	dd	12
	dd	3
	dd	_48
	dd	_46
	dd	16
	dd	3
	dd	_49
	dd	_46
	dd	20
	dd	3
	dd	_50
	dd	_46
	dd	24
	dd	3
	dd	_51
	dd	_46
	dd	28
	dd	6
	dd	_52
	dd	_53
	dd	16
	dd	6
	dd	_54
	dd	_53
	dd	20
	dd	7
	dd	_55
	dd	_53
	dd	48
	dd	6
	dd	_56
	dd	_57
	dd	52
	dd	6
	dd	_58
	dd	_53
	dd	56
	dd	6
	dd	_59
	dd	_53
	dd	60
	dd	0
	align	4
_bb_TOBJEKT:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_43
	dd	32
	dd	__bb_TOBJEKT_New
	dd	__bb_TOBJEKT_Delete
	dd	_bbObjectToString
	dd	_bbObjectCompare
	dd	_bbObjectSendMessage
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	__bb_TOBJEKT_ini
	dd	__bb_TOBJEKT_init
	dd	__bb_TOBJEKT_render
	dd	__bb_TOBJEKT_draw
	align	4
_114:
	dd	_113
	dd	63
	dd	2
	align	4
__bb_TFEDER_liste:
	dd	_bbNullObject
_61:
	db	"TFEDER",0
_62:
	db	"o1",0
_63:
	db	":TOBJEKT",0
_64:
	db	"o2",0
_65:
	db	"s",0
_66:
	db	"D",0
_67:
	db	"create",0
_68:
	db	"(:TOBJEKT,:TOBJEKT,f,f):TFEDER",0
	align	4
_60:
	dd	2
	dd	_61
	dd	3
	dd	_62
	dd	_63
	dd	8
	dd	3
	dd	_64
	dd	_63
	dd	12
	dd	3
	dd	_65
	dd	_46
	dd	16
	dd	3
	dd	_66
	dd	_46
	dd	20
	dd	6
	dd	_52
	dd	_53
	dd	16
	dd	6
	dd	_54
	dd	_53
	dd	20
	dd	7
	dd	_55
	dd	_53
	dd	48
	dd	7
	dd	_67
	dd	_68
	dd	52
	dd	6
	dd	_58
	dd	_53
	dd	56
	dd	6
	dd	_59
	dd	_53
	dd	60
	dd	0
	align	4
_bb_TFEDER:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_60
	dd	24
	dd	__bb_TFEDER_New
	dd	__bb_TFEDER_Delete
	dd	_bbObjectToString
	dd	_bbObjectCompare
	dd	_bbObjectSendMessage
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	__bb_TFEDER_ini
	dd	__bb_TFEDER_create
	dd	__bb_TFEDER_render
	dd	__bb_TFEDER_draw
	align	4
_115:
	dd	_113
	dd	108
	dd	1
	align	4
_116:
	dd	_113
	dd	109
	dd	1
	align	4
_117:
	dd	_113
	dd	110
	dd	1
	align	4
_118:
	dd	_113
	dd	166
	dd	1
	align	4
_259:
	dd	3
	dd	0
	dd	0
	align	4
_119:
	dd	_113
	dd	114
	dd	2
	align	4
_120:
	dd	_113
	dd	116
	dd	2
	align	4
_124:
	dd	3
	dd	0
	dd	0
	align	4
_122:
	dd	_113
	dd	117
	dd	3
	align	4
_123:
	dd	_113
	dd	118
	dd	3
	align	4
_125:
	dd	_113
	dd	121
	dd	2
_193:
	db	"o",0
_194:
	db	"mass",0
_195:
	db	"ok",0
_196:
	db	"i",0
	align	4
_192:
	dd	3
	dd	0
	dd	2
	dd	_193
	dd	_63
	dd	-4
	dd	2
	dd	_194
	dd	_46
	dd	-8
	dd	2
	dd	_195
	dd	_196
	dd	-12
	dd	0
	align	4
_129:
	dd	_113
	dd	122
	dd	3
	align	4
_131:
	dd	_113
	dd	123
	dd	3
	align	4
_133:
	dd	_113
	dd	124
	dd	3
	align	4
_570:
	dd	0x3f800000
	align	4
_571:
	dd	0x3e4ccccd
	align	4
_572:
	dd	0x40a00000
	align	4
_136:
	dd	_113
	dd	126
	dd	3
	align	4
_138:
	dd	_113
	dd	127
	dd	3
	align	4
_160:
	dd	3
	dd	0
	dd	2
	dd	_64
	dd	_63
	dd	-16
	dd	0
	align	4
_148:
	dd	_113
	dd	128
	dd	4
	align	8
_573:
	dd	0x0,0x3fe00000
	align	8
_574:
	dd	0x0,0x40000000
	align	8
_575:
	dd	0x0,0x40000000
	align	8
_576:
	dd	0x0,0x40490000
	align	4
_159:
	dd	3
	dd	0
	dd	0
	align	4
_158:
	dd	_113
	dd	129
	dd	5
	align	4
_161:
	dd	_113
	dd	133
	dd	3
	align	4
_188:
	dd	3
	dd	0
	dd	0
	align	4
_163:
	dd	_113
	dd	134
	dd	4
	align	4
_187:
	dd	3
	dd	0
	dd	2
	dd	_64
	dd	_63
	dd	-20
	dd	2
	dd	_65
	dd	_46
	dd	-24
	dd	0
	align	4
_173:
	dd	_113
	dd	135
	dd	5
	align	8
_577:
	dd	0x0,0x3fe00000
	align	8
_578:
	dd	0x0,0x40000000
	align	8
_579:
	dd	0x0,0x40000000
	align	4
_183:
	dd	_113
	dd	136
	dd	5
	align	4
_580:
	dd	0x42c80000
	align	4
_186:
	dd	3
	dd	0
	dd	0
	align	4
_185:
	dd	_113
	dd	137
	dd	6
	align	4
_189:
	dd	_113
	dd	142
	dd	3
	align	4
_197:
	dd	_113
	dd	145
	dd	2
	align	4
_210:
	dd	3
	dd	0
	dd	2
	dd	_193
	dd	_63
	dd	-28
	dd	0
	align	4
_207:
	dd	_113
	dd	146
	dd	3
	align	4
_211:
	dd	_113
	dd	149
	dd	2
	align	4
_212:
	dd	_113
	dd	150
	dd	2
	align	4
_213:
	dd	_113
	dd	151
	dd	2
	align	4
_214:
	dd	_113
	dd	152
	dd	2
	align	4
_215:
	dd	_113
	dd	154
	dd	2
_229:
	db	":TFEDER",0
	align	4
_228:
	dd	3
	dd	0
	dd	2
	dd	_46
	dd	_229
	dd	-32
	dd	0
	align	4
_225:
	dd	_113
	dd	155
	dd	3
	align	4
_230:
	dd	_113
	dd	158
	dd	2
	align	4
_243:
	dd	3
	dd	0
	dd	2
	dd	_46
	dd	_229
	dd	-36
	dd	0
	align	4
_240:
	dd	_113
	dd	159
	dd	3
	align	4
_244:
	dd	_113
	dd	162
	dd	2
	align	4
_257:
	dd	3
	dd	0
	dd	2
	dd	_193
	dd	_63
	dd	-40
	dd	0
	align	4
_254:
	dd	_113
	dd	163
	dd	3
	align	4
_258:
	dd	_113
	dd	165
	dd	2
	align	4
_260:
	dd	_113
	dd	167
	dd	1
_267:
	db	"Self",0
	align	4
_266:
	dd	1
	dd	_52
	dd	2
	dd	_267
	dd	_63
	dd	-4
	dd	0
	align	4
_265:
	dd	3
	dd	0
	dd	0
	align	4
_274:
	dd	1
	dd	_55
	dd	0
	align	4
_269:
	dd	_113
	dd	8
	dd	3
	align	4
_299:
	dd	1
	dd	_56
	dd	2
	dd	_267
	dd	_63
	dd	-4
	dd	2
	dd	_45
	dd	_46
	dd	-8
	dd	2
	dd	_48
	dd	_46
	dd	-12
	dd	2
	dd	_50
	dd	_46
	dd	-16
	dd	2
	dd	_51
	dd	_46
	dd	-20
	dd	0
	align	4
_275:
	dd	_113
	dd	19
	dd	3
	align	4
_279:
	dd	_113
	dd	20
	dd	3
	align	4
_283:
	dd	_113
	dd	21
	dd	3
	align	4
_287:
	dd	_113
	dd	22
	dd	3
	align	4
_291:
	dd	_113
	dd	23
	dd	3
	align	4
_295:
	dd	_113
	dd	24
	dd	3
	align	4
_379:
	dd	1
	dd	_58
	dd	2
	dd	_267
	dd	_63
	dd	-4
	dd	0
	align	4
_300:
	dd	_113
	dd	28
	dd	3
	align	4
_306:
	dd	_113
	dd	29
	dd	3
	align	4
_312:
	dd	_113
	dd	31
	dd	3
	align	4
_642:
	dd	0x3cf5c28f
	align	4
_316:
	dd	_113
	dd	36
	dd	3
	align	4
_643:
	dd	0x44160000
	align	4
_336:
	dd	3
	dd	0
	dd	0
	align	4
_322:
	dd	_113
	dd	37
	dd	4
	align	4
_644:
	dd	0x44160000
	align	4
_328:
	dd	_113
	dd	38
	dd	4
	align	4
_332:
	dd	_113
	dd	39
	dd	4
	align	4
_645:
	dd	0x3f4ccccd
	align	4
_337:
	dd	_113
	dd	42
	dd	3
	align	4
_646:
	dd	0x44480000
	align	4
_357:
	dd	3
	dd	0
	dd	0
	align	4
_343:
	dd	_113
	dd	43
	dd	4
	align	4
_647:
	dd	0x44480000
	align	4
_349:
	dd	_113
	dd	44
	dd	4
	align	4
_353:
	dd	_113
	dd	45
	dd	4
	align	4
_648:
	dd	0x3f666666
	align	4
_358:
	dd	_113
	dd	48
	dd	3
	align	4
_378:
	dd	3
	dd	0
	dd	0
	align	4
_364:
	dd	_113
	dd	49
	dd	4
	align	4
_370:
	dd	_113
	dd	50
	dd	4
	align	4
_374:
	dd	_113
	dd	51
	dd	4
	align	4
_649:
	dd	0x3f666666
	align	4
_394:
	dd	1
	dd	_59
	dd	2
	dd	_267
	dd	_63
	dd	-4
	dd	0
	align	4
_380:
	dd	_113
	dd	56
	dd	3
	align	4
_381:
	dd	_113
	dd	57
	dd	3
	align	4
_678:
	dd	0x40000000
	align	4
_679:
	dd	0x40000000
	align	4
_398:
	dd	1
	dd	_52
	dd	2
	dd	_267
	dd	_229
	dd	-4
	dd	0
	align	4
_397:
	dd	3
	dd	0
	dd	0
	align	4
_409:
	dd	1
	dd	_55
	dd	0
	align	4
_404:
	dd	_113
	dd	66
	dd	3
	align	4
_440:
	dd	1
	dd	_67
	dd	2
	dd	_62
	dd	_63
	dd	-4
	dd	2
	dd	_64
	dd	_63
	dd	-8
	dd	2
	dd	_65
	dd	_46
	dd	-12
	dd	2
	dd	_66
	dd	_46
	dd	-16
	dd	2
	dd	_46
	dd	_229
	dd	-20
	dd	0
	align	4
_410:
	dd	_113
	dd	76
	dd	3
	align	4
_412:
	dd	_113
	dd	77
	dd	3
	align	4
_420:
	dd	_113
	dd	78
	dd	3
	align	4
_428:
	dd	_113
	dd	79
	dd	3
	align	4
_432:
	dd	_113
	dd	80
	dd	3
	align	4
_436:
	dd	_113
	dd	82
	dd	3
	align	4
_439:
	dd	_113
	dd	84
	dd	3
_524:
	db	"d",0
_525:
	db	"w",0
	align	4
_523:
	dd	1
	dd	_58
	dd	2
	dd	_267
	dd	_229
	dd	-4
	dd	2
	dd	_524
	dd	_46
	dd	-8
	dd	2
	dd	_46
	dd	_46
	dd	-12
	dd	2
	dd	_525
	dd	_46
	dd	-16
	dd	0
	align	4
_441:
	dd	_113
	dd	88
	dd	3
	align	8
_702:
	dd	0x0,0x3fe00000
	align	8
_703:
	dd	0x0,0x40000000
	align	8
_704:
	dd	0x0,0x40000000
	align	4
_459:
	dd	_113
	dd	89
	dd	3
	align	4
_465:
	dd	_113
	dd	90
	dd	3
	align	4
_483:
	dd	_113
	dd	92
	dd	3
	align	4
_493:
	dd	_113
	dd	93
	dd	3
	align	4
_503:
	dd	_113
	dd	95
	dd	3
	align	4
_513:
	dd	_113
	dd	96
	dd	3
_569:
	db	"c",0
	align	4
_568:
	dd	1
	dd	_59
	dd	2
	dd	_267
	dd	_229
	dd	-4
	dd	2
	dd	_524
	dd	_46
	dd	-8
	dd	2
	dd	_569
	dd	_46
	dd	-12
	dd	0
	align	4
_526:
	dd	_113
	dd	100
	dd	3
	align	8
_741:
	dd	0x0,0x3fe00000
	align	8
_742:
	dd	0x0,0x40000000
	align	8
_743:
	dd	0x0,0x40000000
	align	4
_544:
	dd	_113
	dd	101
	dd	3
	align	4
_744:
	dd	0x447a0000
	align	4
_550:
	dd	_113
	dd	102
	dd	3
	align	4
_745:
	dd	0x437f0000
	align	4
_551:
	dd	_113
	dd	103
	dd	3
