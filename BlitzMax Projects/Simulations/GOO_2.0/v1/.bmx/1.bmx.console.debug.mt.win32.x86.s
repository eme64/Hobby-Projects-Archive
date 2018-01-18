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
	extrn	_bbNullObject
	extrn	_bbObjectClass
	extrn	_bbObjectCompare
	extrn	_bbObjectCtor
	extrn	_bbObjectDowncast
	extrn	_bbObjectDtor
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
	public	__bb_TFEDER_New
	public	__bb_TFEDER_create
	public	__bb_TFEDER_draw
	public	__bb_TFEDER_ini
	public	__bb_TFEDER_liste
	public	__bb_TFEDER_render
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
	cmp	dword [_256],0
	je	_257
	mov	eax,0
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_257:
	mov	dword [_256],1
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
	push	_254
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
	push	_105
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_TOBJEKT
	call	_bbObjectRegisterType
	add	esp,4
	push	_107
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_TFEDER
	call	_bbObjectRegisterType
	add	esp,4
	push	_108
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	60
	push	0
	push	600
	push	800
	call	_brl_graphics_Graphics
	add	esp,20
	push	_109
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bb_TOBJEKT+48]
	push	_110
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bb_TFEDER+48]
	push	_111
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
_24:
	mov	eax,ebp
	push	eax
	push	_252
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_112
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	_brl_max2d_Cls
	push	_113
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	32
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_114
	mov	eax,ebp
	push	eax
	push	_117
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_115
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bb_TOBJEKT+48]
	push	_116
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bb_TFEDER+48]
	call	dword [_bbOnDebugLeaveScope]
_114:
	push	_118
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1
	call	_brl_polledinput_MouseHit
	add	esp,4
	cmp	eax,0
	jne	_119
	push	2
	call	_brl_polledinput_MouseDown
	add	esp,4
_119:
	cmp	eax,0
	je	_121
	mov	eax,ebp
	push	eax
	push	_185
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_122
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_TOBJEKT
	call	_bbObjectNew
	add	esp,4
	mov	dword [ebp-4],eax
	push	_124
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	5
	push	0
	call	_brl_random_Rand
	add	esp,8
	mov	dword [ebp+-84],eax
	fild	dword [ebp+-84]
	fstp	dword [ebp-8]
	push	_126
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_128
	call	_brl_blitz_NullObjectError
_128:
	fld	dword [_539]
	fld	dword [_540]
	fmul	dword [ebp-8]
	faddp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	fld	dword [_541]
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
	push	_129
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-12],1
	push	_131
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-16],_bbNullObject
	mov	eax,dword [__bb_TOBJEKT_liste]
	mov	dword [ebp-80],eax
	mov	ebx,dword [ebp-80]
	cmp	ebx,_bbNullObject
	jne	_135
	call	_brl_blitz_NullObjectError
_135:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+140]
	add	esp,4
	mov	dword [ebp-68],eax
	jmp	_25
_27:
	mov	ebx,dword [ebp-68]
	cmp	ebx,_bbNullObject
	jne	_140
	call	_brl_blitz_NullObjectError
_140:
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
	push	_153
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_141
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [ebp-60],eax
	cmp	dword [ebp-60],_bbNullObject
	jne	_143
	call	_brl_blitz_NullObjectError
_143:
	mov	edi,dword [ebp-16]
	cmp	edi,_bbNullObject
	jne	_145
	call	_brl_blitz_NullObjectError
_145:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_147
	call	_brl_blitz_NullObjectError
_147:
	mov	ebx,dword [ebp-16]
	cmp	ebx,_bbNullObject
	jne	_149
	call	_brl_blitz_NullObjectError
_149:
	fld	qword [_542]
	sub	esp,8
	fstp	qword [esp]
	fld	qword [_543]
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
	fld	qword [_544]
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
	fld	qword [_545]
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setae	al
	movzx	eax,al
	cmp	eax,0
	jne	_150
	mov	eax,ebp
	push	eax
	push	_152
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_151
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-12],0
	call	dword [_bbOnDebugLeaveScope]
_150:
	call	dword [_bbOnDebugLeaveScope]
_25:
	mov	ebx,dword [ebp-68]
	cmp	ebx,_bbNullObject
	jne	_138
	call	_brl_blitz_NullObjectError
_138:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_27
_26:
	push	_154
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	cmp	dword [ebp-12],1
	jne	_155
	mov	eax,ebp
	push	eax
	push	_181
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_156
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-20],_bbNullObject
	mov	eax,dword [__bb_TOBJEKT_liste]
	mov	dword [ebp-76],eax
	mov	ebx,dword [ebp-76]
	cmp	ebx,_bbNullObject
	jne	_160
	call	_brl_blitz_NullObjectError
_160:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+140]
	add	esp,4
	mov	dword [ebp-72],eax
	jmp	_28
_30:
	mov	ebx,dword [ebp-72]
	cmp	ebx,_bbNullObject
	jne	_165
	call	_brl_blitz_NullObjectError
_165:
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
	push	_180
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_166
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [ebp-64],eax
	cmp	dword [ebp-64],_bbNullObject
	jne	_168
	call	_brl_blitz_NullObjectError
_168:
	mov	edi,dword [ebp-20]
	cmp	edi,_bbNullObject
	jne	_170
	call	_brl_blitz_NullObjectError
_170:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_172
	call	_brl_blitz_NullObjectError
_172:
	mov	ebx,dword [ebp-20]
	cmp	ebx,_bbNullObject
	jne	_174
	call	_brl_blitz_NullObjectError
_174:
	fld	qword [_546]
	sub	esp,8
	fstp	qword [esp]
	fld	qword [_547]
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
	fld	qword [_548]
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
	push	_176
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [ebp-24]
	fld	dword [_549]
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setae	al
	movzx	eax,al
	cmp	eax,0
	jne	_177
	mov	eax,ebp
	push	eax
	push	_179
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_178
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1028443341
	push	1116471296
	push	dword [ebp-20]
	push	dword [ebp-4]
	call	dword [_bb_TFEDER+52]
	add	esp,16
	call	dword [_bbOnDebugLeaveScope]
_177:
	call	dword [_bbOnDebugLeaveScope]
_28:
	mov	ebx,dword [ebp-72]
	cmp	ebx,_bbNullObject
	jne	_163
	call	_brl_blitz_NullObjectError
_163:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_30
_29:
	call	dword [_bbOnDebugLeaveScope]
_155:
	push	_182
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [__bb_TOBJEKT_liste]
	cmp	ebx,_bbNullObject
	jne	_184
	call	_brl_blitz_NullObjectError
_184:
	push	dword [ebp-4]
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+68]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
_121:
	push	_190
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-28],_bbNullObject
	mov	edi,dword [__bb_TOBJEKT_liste]
	mov	ebx,edi
	cmp	ebx,_bbNullObject
	jne	_194
	call	_brl_blitz_NullObjectError
_194:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+140]
	add	esp,4
	mov	esi,eax
	jmp	_31
_33:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_199
	call	_brl_blitz_NullObjectError
_199:
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
	push	_203
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_200
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-28]
	cmp	ebx,_bbNullObject
	jne	_202
	call	_brl_blitz_NullObjectError
_202:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+56]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
_31:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_197
	call	_brl_blitz_NullObjectError
_197:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_33
_32:
	push	_204
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	50
	push	50
	push	50
	call	_brl_max2d_SetColor
	add	esp,12
	push	_205
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
	push	_206
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	100
	push	100
	push	100
	call	_brl_max2d_SetColor
	add	esp,12
	push	_207
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
	push	_208
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-32],_bbNullObject
	mov	edi,dword [__bb_TFEDER_liste]
	mov	ebx,edi
	cmp	ebx,_bbNullObject
	jne	_212
	call	_brl_blitz_NullObjectError
_212:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+140]
	add	esp,4
	mov	esi,eax
	jmp	_34
_36:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_217
	call	_brl_blitz_NullObjectError
_217:
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
	push	_221
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_218
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-32]
	cmp	ebx,_bbNullObject
	jne	_220
	call	_brl_blitz_NullObjectError
_220:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+56]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
_34:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_215
	call	_brl_blitz_NullObjectError
_215:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_36
_35:
	push	_223
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-36],_bbNullObject
	mov	edi,dword [__bb_TFEDER_liste]
	mov	ebx,edi
	cmp	ebx,_bbNullObject
	jne	_227
	call	_brl_blitz_NullObjectError
_227:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+140]
	add	esp,4
	mov	esi,eax
	jmp	_37
_39:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_232
	call	_brl_blitz_NullObjectError
_232:
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
	push	_236
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_233
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-36]
	cmp	ebx,_bbNullObject
	jne	_235
	call	_brl_blitz_NullObjectError
_235:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+60]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
_37:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_230
	call	_brl_blitz_NullObjectError
_230:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_39
_38:
	push	_237
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-40],_bbNullObject
	mov	edi,dword [__bb_TOBJEKT_liste]
	mov	ebx,edi
	cmp	ebx,_bbNullObject
	jne	_241
	call	_brl_blitz_NullObjectError
_241:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+140]
	add	esp,4
	mov	esi,eax
	jmp	_40
_42:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_246
	call	_brl_blitz_NullObjectError
_246:
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
	push	_250
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_247
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-40]
	cmp	ebx,_bbNullObject
	jne	_249
	call	_brl_blitz_NullObjectError
_249:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+60]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
_40:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_244
	call	_brl_blitz_NullObjectError
_244:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_42
_41:
	push	_251
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
	push	_253
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	_bbEnd
	mov	ebx,0
	jmp	_68
_68:
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
	push	_259
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
	push	_258
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
	mov	ebx,0
	jmp	_71
_71:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TOBJEKT_ini:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	ebp
	push	_262
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_261
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_brl_linkedlist_TList
	call	_bbObjectNew
	add	esp,4
	mov	dword [__bb_TOBJEKT_liste],eax
	mov	ebx,0
	jmp	_73
_73:
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
	push	_287
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_263
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_265
	call	_brl_blitz_NullObjectError
_265:
	fld	dword [ebp-8]
	fstp	dword [ebx+8]
	push	_267
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_269
	call	_brl_blitz_NullObjectError
_269:
	fld	dword [ebp-12]
	fstp	dword [ebx+16]
	push	_271
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_273
	call	_brl_blitz_NullObjectError
_273:
	fldz
	fstp	dword [ebx+12]
	push	_275
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_277
	call	_brl_blitz_NullObjectError
_277:
	fldz
	fstp	dword [ebx+20]
	push	_279
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_281
	call	_brl_blitz_NullObjectError
_281:
	fld	dword [ebp-16]
	fstp	dword [ebx+24]
	push	_283
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_285
	call	_brl_blitz_NullObjectError
_285:
	fld	dword [ebp-20]
	fstp	dword [ebx+28]
	mov	ebx,0
	jmp	_80
_80:
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
	push	_367
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_288
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_290
	call	_brl_blitz_NullObjectError
_290:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_293
	call	_brl_blitz_NullObjectError
_293:
	fld	dword [ebx+8]
	fadd	dword [esi+12]
	fstp	dword [ebx+8]
	push	_294
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_296
	call	_brl_blitz_NullObjectError
_296:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_299
	call	_brl_blitz_NullObjectError
_299:
	fld	dword [ebx+16]
	fadd	dword [esi+20]
	fstp	dword [ebx+16]
	push	_300
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_302
	call	_brl_blitz_NullObjectError
_302:
	fld	dword [ebx+20]
	fadd	dword [_609]
	fstp	dword [ebx+20]
	push	_304
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_306
	call	_brl_blitz_NullObjectError
_306:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_308
	call	_brl_blitz_NullObjectError
_308:
	fld	dword [esi+16]
	fld	dword [_610]
	fsub	dword [ebx+24]
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_309
	push	ebp
	push	_324
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_310
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_312
	call	_brl_blitz_NullObjectError
_312:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_315
	call	_brl_blitz_NullObjectError
_315:
	fld	dword [_611]
	fsub	dword [esi+24]
	fstp	dword [ebx+16]
	push	_316
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_318
	call	_brl_blitz_NullObjectError
_318:
	fldz
	fstp	dword [ebx+20]
	push	_320
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_322
	call	_brl_blitz_NullObjectError
_322:
	fld	dword [ebx+12]
	fmul	dword [_612]
	fstp	dword [ebx+12]
	call	dword [_bbOnDebugLeaveScope]
_309:
	push	_325
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_327
	call	_brl_blitz_NullObjectError
_327:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_329
	call	_brl_blitz_NullObjectError
_329:
	fld	dword [esi+8]
	fld	dword [_613]
	fsub	dword [ebx+24]
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_330
	push	ebp
	push	_345
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_331
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_333
	call	_brl_blitz_NullObjectError
_333:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_336
	call	_brl_blitz_NullObjectError
_336:
	fld	dword [_614]
	fsub	dword [esi+24]
	fstp	dword [ebx+8]
	push	_337
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_339
	call	_brl_blitz_NullObjectError
_339:
	fldz
	fstp	dword [ebx+12]
	push	_341
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_343
	call	_brl_blitz_NullObjectError
_343:
	fld	dword [ebx+20]
	fmul	dword [_615]
	fstp	dword [ebx+20]
	call	dword [_bbOnDebugLeaveScope]
_330:
	push	_346
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_348
	call	_brl_blitz_NullObjectError
_348:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_350
	call	_brl_blitz_NullObjectError
_350:
	fld	dword [esi+8]
	fld	dword [ebx+24]
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setae	al
	movzx	eax,al
	cmp	eax,0
	jne	_351
	push	ebp
	push	_366
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_352
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_354
	call	_brl_blitz_NullObjectError
_354:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_357
	call	_brl_blitz_NullObjectError
_357:
	fld	dword [esi+24]
	fstp	dword [ebx+8]
	push	_358
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_360
	call	_brl_blitz_NullObjectError
_360:
	fldz
	fstp	dword [ebx+12]
	push	_362
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_364
	call	_brl_blitz_NullObjectError
_364:
	fld	dword [ebx+20]
	fmul	dword [_616]
	fstp	dword [ebx+20]
	call	dword [_bbOnDebugLeaveScope]
_351:
	mov	ebx,0
	jmp	_83
_83:
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
	push	_382
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_368
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	255
	push	255
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	_369
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [ebp-16],eax
	cmp	dword [ebp-16],_bbNullObject
	jne	_371
	call	_brl_blitz_NullObjectError
_371:
	mov	eax,dword [ebp-4]
	mov	dword [ebp-12],eax
	cmp	dword [ebp-12],_bbNullObject
	jne	_373
	call	_brl_blitz_NullObjectError
_373:
	mov	eax,dword [ebp-4]
	mov	dword [ebp-8],eax
	cmp	dword [ebp-8],_bbNullObject
	jne	_375
	call	_brl_blitz_NullObjectError
_375:
	mov	edi,dword [ebp-4]
	cmp	edi,_bbNullObject
	jne	_377
	call	_brl_blitz_NullObjectError
_377:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_379
	call	_brl_blitz_NullObjectError
_379:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_381
	call	_brl_blitz_NullObjectError
_381:
	fld	dword [ebx+24]
	fmul	dword [_645]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [esi+24]
	fmul	dword [_646]
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
	jmp	_86
_86:
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
	push	_384
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	dword [ebp-4]
	call	_bbObjectCtor
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [eax],_bb_TFEDER
	mov	eax,dword [ebp-4]
	mov	dword [eax+8],_bbNullObject
	mov	eax,dword [ebp-4]
	mov	dword [eax+12],_bbNullObject
	mov	eax,dword [ebp-4]
	fldz
	fstp	dword [eax+16]
	mov	eax,dword [ebp-4]
	fldz
	fstp	dword [eax+20]
	push	ebp
	push	_383
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
	mov	ebx,0
	jmp	_89
_89:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TFEDER_ini:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	ebp
	push	_386
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_385
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_brl_linkedlist_TList
	call	_bbObjectNew
	add	esp,4
	mov	dword [__bb_TFEDER_liste],eax
	mov	ebx,0
	jmp	_91
_91:
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
	push	_409
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_387
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_TFEDER
	call	_bbObjectNew
	add	esp,4
	mov	dword [ebp-20],eax
	push	_389
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-20]
	cmp	ebx,_bbNullObject
	jne	_391
	call	_brl_blitz_NullObjectError
_391:
	mov	eax,dword [ebp-4]
	mov	dword [ebx+8],eax
	push	_393
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-20]
	cmp	ebx,_bbNullObject
	jne	_395
	call	_brl_blitz_NullObjectError
_395:
	mov	eax,dword [ebp-8]
	mov	dword [ebx+12],eax
	push	_397
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-20]
	cmp	ebx,_bbNullObject
	jne	_399
	call	_brl_blitz_NullObjectError
_399:
	fld	dword [ebp-12]
	fstp	dword [ebx+16]
	push	_401
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-20]
	cmp	ebx,_bbNullObject
	jne	_403
	call	_brl_blitz_NullObjectError
_403:
	fld	dword [ebp-16]
	fstp	dword [ebx+20]
	push	_405
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [__bb_TFEDER_liste]
	cmp	ebx,_bbNullObject
	jne	_407
	call	_brl_blitz_NullObjectError
_407:
	push	dword [ebp-20]
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+68]
	add	esp,8
	push	_408
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-20]
	jmp	_97
_97:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
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
	push	_492
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_410
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_412
	call	_brl_blitz_NullObjectError
_412:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-60],eax
	cmp	dword [ebp-60],_bbNullObject
	jne	_414
	call	_brl_blitz_NullObjectError
_414:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_416
	call	_brl_blitz_NullObjectError
_416:
	mov	edi,dword [ebx+12]
	cmp	edi,_bbNullObject
	jne	_418
	call	_brl_blitz_NullObjectError
_418:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_420
	call	_brl_blitz_NullObjectError
_420:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_422
	call	_brl_blitz_NullObjectError
_422:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_424
	call	_brl_blitz_NullObjectError
_424:
	mov	esi,dword [esi+12]
	cmp	esi,_bbNullObject
	jne	_426
	call	_brl_blitz_NullObjectError
_426:
	fld	qword [_667]
	sub	esp,8
	fstp	qword [esp]
	fld	qword [_668]
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
	fld	qword [_669]
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
	push	_428
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_430
	call	_brl_blitz_NullObjectError
_430:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_432
	call	_brl_blitz_NullObjectError
_432:
	fld	dword [esi+20]
	fchs
	fld	dword [ebx+16]
	fsub	dword [ebp-8]
	fmulp	st1,st0
	fstp	dword [ebp-12]
	push	_434
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_436
	call	_brl_blitz_NullObjectError
_436:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-64],eax
	cmp	dword [ebp-64],_bbNullObject
	jne	_438
	call	_brl_blitz_NullObjectError
_438:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_440
	call	_brl_blitz_NullObjectError
_440:
	mov	edi,dword [ebx+12]
	cmp	edi,_bbNullObject
	jne	_442
	call	_brl_blitz_NullObjectError
_442:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_444
	call	_brl_blitz_NullObjectError
_444:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_446
	call	_brl_blitz_NullObjectError
_446:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_448
	call	_brl_blitz_NullObjectError
_448:
	mov	esi,dword [esi+12]
	cmp	esi,_bbNullObject
	jne	_450
	call	_brl_blitz_NullObjectError
_450:
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
	push	_452
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_454
	call	_brl_blitz_NullObjectError
_454:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_456
	call	_brl_blitz_NullObjectError
_456:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_459
	call	_brl_blitz_NullObjectError
_459:
	mov	esi,dword [esi+8]
	cmp	esi,_bbNullObject
	jne	_461
	call	_brl_blitz_NullObjectError
_461:
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
	push	_462
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_464
	call	_brl_blitz_NullObjectError
_464:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_466
	call	_brl_blitz_NullObjectError
_466:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_469
	call	_brl_blitz_NullObjectError
_469:
	mov	esi,dword [esi+8]
	cmp	esi,_bbNullObject
	jne	_471
	call	_brl_blitz_NullObjectError
_471:
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
	push	_472
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_474
	call	_brl_blitz_NullObjectError
_474:
	mov	ebx,dword [ebx+12]
	cmp	ebx,_bbNullObject
	jne	_476
	call	_brl_blitz_NullObjectError
_476:
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
	push	_482
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_484
	call	_brl_blitz_NullObjectError
_484:
	mov	ebx,dword [ebx+12]
	cmp	ebx,_bbNullObject
	jne	_486
	call	_brl_blitz_NullObjectError
_486:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_489
	call	_brl_blitz_NullObjectError
_489:
	mov	esi,dword [esi+12]
	cmp	esi,_bbNullObject
	jne	_491
	call	_brl_blitz_NullObjectError
_491:
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
	jmp	_100
_100:
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
	push	_537
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_495
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_497
	call	_brl_blitz_NullObjectError
_497:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-24],eax
	cmp	dword [ebp-24],_bbNullObject
	jne	_499
	call	_brl_blitz_NullObjectError
_499:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_501
	call	_brl_blitz_NullObjectError
_501:
	mov	edi,dword [ebx+12]
	cmp	edi,_bbNullObject
	jne	_503
	call	_brl_blitz_NullObjectError
_503:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_505
	call	_brl_blitz_NullObjectError
_505:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_507
	call	_brl_blitz_NullObjectError
_507:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_509
	call	_brl_blitz_NullObjectError
_509:
	mov	esi,dword [esi+12]
	cmp	esi,_bbNullObject
	jne	_511
	call	_brl_blitz_NullObjectError
_511:
	fld	qword [_706]
	sub	esp,8
	fstp	qword [esp]
	fld	qword [_707]
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
	fld	qword [_708]
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
	push	_513
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_515
	call	_brl_blitz_NullObjectError
_515:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_517
	call	_brl_blitz_NullObjectError
_517:
	fld	dword [esi+16]
	fsub	dword [ebp-8]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatAbs
	add	esp,8
	fdiv	dword [ebx+16]
	fmul	dword [_709]
	fstp	dword [ebp-12]
	push	_519
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	fld	dword [_710]
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
	push	_520
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_522
	call	_brl_blitz_NullObjectError
_522:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-28],eax
	cmp	dword [ebp-28],_bbNullObject
	jne	_524
	call	_brl_blitz_NullObjectError
_524:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_526
	call	_brl_blitz_NullObjectError
_526:
	mov	edi,dword [ebx+8]
	cmp	edi,_bbNullObject
	jne	_528
	call	_brl_blitz_NullObjectError
_528:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_530
	call	_brl_blitz_NullObjectError
_530:
	mov	ebx,dword [ebx+12]
	cmp	ebx,_bbNullObject
	jne	_532
	call	_brl_blitz_NullObjectError
_532:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_534
	call	_brl_blitz_NullObjectError
_534:
	mov	esi,dword [esi+12]
	cmp	esi,_bbNullObject
	jne	_536
	call	_brl_blitz_NullObjectError
_536:
	push	1
	push	dword [esi+16]
	push	dword [ebx+8]
	push	dword [edi+16]
	mov	eax,dword [ebp-28]
	push	dword [eax+8]
	call	_brl_max2d_DrawLine
	add	esp,20
	mov	ebx,0
	jmp	_103
_103:
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
_256:
	dd	0
_255:
	db	"1",0
	align	4
_254:
	dd	1
	dd	_255
	dd	0
_106:
	db	"E:/BMX/GAMES/GOO_2.0/v1/1.bmx",0
	align	4
_105:
	dd	_106
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
	db	"ini",0
_55:
	db	"init",0
_56:
	db	"(f,f,f,f)i",0
_57:
	db	"render",0
_58:
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
	dd	7
	dd	_54
	dd	_53
	dd	48
	dd	6
	dd	_55
	dd	_56
	dd	52
	dd	6
	dd	_57
	dd	_53
	dd	56
	dd	6
	dd	_58
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
	dd	_bbObjectDtor
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
_107:
	dd	_106
	dd	63
	dd	2
	align	4
__bb_TFEDER_liste:
	dd	_bbNullObject
_60:
	db	"TFEDER",0
_61:
	db	"o1",0
_62:
	db	":TOBJEKT",0
_63:
	db	"o2",0
_64:
	db	"s",0
_65:
	db	"D",0
_66:
	db	"create",0
_67:
	db	"(:TOBJEKT,:TOBJEKT,f,f):TFEDER",0
	align	4
_59:
	dd	2
	dd	_60
	dd	3
	dd	_61
	dd	_62
	dd	8
	dd	3
	dd	_63
	dd	_62
	dd	12
	dd	3
	dd	_64
	dd	_46
	dd	16
	dd	3
	dd	_65
	dd	_46
	dd	20
	dd	6
	dd	_52
	dd	_53
	dd	16
	dd	7
	dd	_54
	dd	_53
	dd	48
	dd	7
	dd	_66
	dd	_67
	dd	52
	dd	6
	dd	_57
	dd	_53
	dd	56
	dd	6
	dd	_58
	dd	_53
	dd	60
	dd	0
	align	4
_bb_TFEDER:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_59
	dd	24
	dd	__bb_TFEDER_New
	dd	_bbObjectDtor
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
_108:
	dd	_106
	dd	108
	dd	1
	align	4
_109:
	dd	_106
	dd	109
	dd	1
	align	4
_110:
	dd	_106
	dd	110
	dd	1
	align	4
_111:
	dd	_106
	dd	166
	dd	1
	align	4
_252:
	dd	3
	dd	0
	dd	0
	align	4
_112:
	dd	_106
	dd	114
	dd	2
	align	4
_113:
	dd	_106
	dd	116
	dd	2
	align	4
_117:
	dd	3
	dd	0
	dd	0
	align	4
_115:
	dd	_106
	dd	117
	dd	3
	align	4
_116:
	dd	_106
	dd	118
	dd	3
	align	4
_118:
	dd	_106
	dd	121
	dd	2
_186:
	db	"o",0
_187:
	db	"mass",0
_188:
	db	"ok",0
_189:
	db	"i",0
	align	4
_185:
	dd	3
	dd	0
	dd	2
	dd	_186
	dd	_62
	dd	-4
	dd	2
	dd	_187
	dd	_46
	dd	-8
	dd	2
	dd	_188
	dd	_189
	dd	-12
	dd	0
	align	4
_122:
	dd	_106
	dd	122
	dd	3
	align	4
_124:
	dd	_106
	dd	123
	dd	3
	align	4
_126:
	dd	_106
	dd	124
	dd	3
	align	4
_539:
	dd	0x3f800000
	align	4
_540:
	dd	0x3e4ccccd
	align	4
_541:
	dd	0x40a00000
	align	4
_129:
	dd	_106
	dd	126
	dd	3
	align	4
_131:
	dd	_106
	dd	127
	dd	3
	align	4
_153:
	dd	3
	dd	0
	dd	2
	dd	_63
	dd	_62
	dd	-16
	dd	0
	align	4
_141:
	dd	_106
	dd	128
	dd	4
	align	8
_542:
	dd	0x0,0x3fe00000
	align	8
_543:
	dd	0x0,0x40000000
	align	8
_544:
	dd	0x0,0x40000000
	align	8
_545:
	dd	0x0,0x40490000
	align	4
_152:
	dd	3
	dd	0
	dd	0
	align	4
_151:
	dd	_106
	dd	129
	dd	5
	align	4
_154:
	dd	_106
	dd	133
	dd	3
	align	4
_181:
	dd	3
	dd	0
	dd	0
	align	4
_156:
	dd	_106
	dd	134
	dd	4
	align	4
_180:
	dd	3
	dd	0
	dd	2
	dd	_63
	dd	_62
	dd	-20
	dd	2
	dd	_64
	dd	_46
	dd	-24
	dd	0
	align	4
_166:
	dd	_106
	dd	135
	dd	5
	align	8
_546:
	dd	0x0,0x3fe00000
	align	8
_547:
	dd	0x0,0x40000000
	align	8
_548:
	dd	0x0,0x40000000
	align	4
_176:
	dd	_106
	dd	136
	dd	5
	align	4
_549:
	dd	0x42c80000
	align	4
_179:
	dd	3
	dd	0
	dd	0
	align	4
_178:
	dd	_106
	dd	137
	dd	6
	align	4
_182:
	dd	_106
	dd	142
	dd	3
	align	4
_190:
	dd	_106
	dd	145
	dd	2
	align	4
_203:
	dd	3
	dd	0
	dd	2
	dd	_186
	dd	_62
	dd	-28
	dd	0
	align	4
_200:
	dd	_106
	dd	146
	dd	3
	align	4
_204:
	dd	_106
	dd	149
	dd	2
	align	4
_205:
	dd	_106
	dd	150
	dd	2
	align	4
_206:
	dd	_106
	dd	151
	dd	2
	align	4
_207:
	dd	_106
	dd	152
	dd	2
	align	4
_208:
	dd	_106
	dd	154
	dd	2
_222:
	db	":TFEDER",0
	align	4
_221:
	dd	3
	dd	0
	dd	2
	dd	_46
	dd	_222
	dd	-32
	dd	0
	align	4
_218:
	dd	_106
	dd	155
	dd	3
	align	4
_223:
	dd	_106
	dd	158
	dd	2
	align	4
_236:
	dd	3
	dd	0
	dd	2
	dd	_46
	dd	_222
	dd	-36
	dd	0
	align	4
_233:
	dd	_106
	dd	159
	dd	3
	align	4
_237:
	dd	_106
	dd	162
	dd	2
	align	4
_250:
	dd	3
	dd	0
	dd	2
	dd	_186
	dd	_62
	dd	-40
	dd	0
	align	4
_247:
	dd	_106
	dd	163
	dd	3
	align	4
_251:
	dd	_106
	dd	165
	dd	2
	align	4
_253:
	dd	_106
	dd	167
	dd	1
_260:
	db	"Self",0
	align	4
_259:
	dd	1
	dd	_52
	dd	2
	dd	_260
	dd	_62
	dd	-4
	dd	0
	align	4
_258:
	dd	3
	dd	0
	dd	0
	align	4
_262:
	dd	1
	dd	_54
	dd	0
	align	4
_261:
	dd	_106
	dd	8
	dd	3
	align	4
_287:
	dd	1
	dd	_55
	dd	2
	dd	_260
	dd	_62
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
_263:
	dd	_106
	dd	19
	dd	3
	align	4
_267:
	dd	_106
	dd	20
	dd	3
	align	4
_271:
	dd	_106
	dd	21
	dd	3
	align	4
_275:
	dd	_106
	dd	22
	dd	3
	align	4
_279:
	dd	_106
	dd	23
	dd	3
	align	4
_283:
	dd	_106
	dd	24
	dd	3
	align	4
_367:
	dd	1
	dd	_57
	dd	2
	dd	_260
	dd	_62
	dd	-4
	dd	0
	align	4
_288:
	dd	_106
	dd	28
	dd	3
	align	4
_294:
	dd	_106
	dd	29
	dd	3
	align	4
_300:
	dd	_106
	dd	31
	dd	3
	align	4
_609:
	dd	0x3cf5c28f
	align	4
_304:
	dd	_106
	dd	36
	dd	3
	align	4
_610:
	dd	0x44160000
	align	4
_324:
	dd	3
	dd	0
	dd	0
	align	4
_310:
	dd	_106
	dd	37
	dd	4
	align	4
_611:
	dd	0x44160000
	align	4
_316:
	dd	_106
	dd	38
	dd	4
	align	4
_320:
	dd	_106
	dd	39
	dd	4
	align	4
_612:
	dd	0x3f4ccccd
	align	4
_325:
	dd	_106
	dd	42
	dd	3
	align	4
_613:
	dd	0x44480000
	align	4
_345:
	dd	3
	dd	0
	dd	0
	align	4
_331:
	dd	_106
	dd	43
	dd	4
	align	4
_614:
	dd	0x44480000
	align	4
_337:
	dd	_106
	dd	44
	dd	4
	align	4
_341:
	dd	_106
	dd	45
	dd	4
	align	4
_615:
	dd	0x3f666666
	align	4
_346:
	dd	_106
	dd	48
	dd	3
	align	4
_366:
	dd	3
	dd	0
	dd	0
	align	4
_352:
	dd	_106
	dd	49
	dd	4
	align	4
_358:
	dd	_106
	dd	50
	dd	4
	align	4
_362:
	dd	_106
	dd	51
	dd	4
	align	4
_616:
	dd	0x3f666666
	align	4
_382:
	dd	1
	dd	_58
	dd	2
	dd	_260
	dd	_62
	dd	-4
	dd	0
	align	4
_368:
	dd	_106
	dd	56
	dd	3
	align	4
_369:
	dd	_106
	dd	57
	dd	3
	align	4
_645:
	dd	0x40000000
	align	4
_646:
	dd	0x40000000
	align	4
_384:
	dd	1
	dd	_52
	dd	2
	dd	_260
	dd	_222
	dd	-4
	dd	0
	align	4
_383:
	dd	3
	dd	0
	dd	0
	align	4
_386:
	dd	1
	dd	_54
	dd	0
	align	4
_385:
	dd	_106
	dd	66
	dd	3
	align	4
_409:
	dd	1
	dd	_66
	dd	2
	dd	_61
	dd	_62
	dd	-4
	dd	2
	dd	_63
	dd	_62
	dd	-8
	dd	2
	dd	_64
	dd	_46
	dd	-12
	dd	2
	dd	_65
	dd	_46
	dd	-16
	dd	2
	dd	_46
	dd	_222
	dd	-20
	dd	0
	align	4
_387:
	dd	_106
	dd	76
	dd	3
	align	4
_389:
	dd	_106
	dd	77
	dd	3
	align	4
_393:
	dd	_106
	dd	78
	dd	3
	align	4
_397:
	dd	_106
	dd	79
	dd	3
	align	4
_401:
	dd	_106
	dd	80
	dd	3
	align	4
_405:
	dd	_106
	dd	82
	dd	3
	align	4
_408:
	dd	_106
	dd	84
	dd	3
_493:
	db	"d",0
_494:
	db	"w",0
	align	4
_492:
	dd	1
	dd	_57
	dd	2
	dd	_260
	dd	_222
	dd	-4
	dd	2
	dd	_493
	dd	_46
	dd	-8
	dd	2
	dd	_46
	dd	_46
	dd	-12
	dd	2
	dd	_494
	dd	_46
	dd	-16
	dd	0
	align	4
_410:
	dd	_106
	dd	88
	dd	3
	align	8
_667:
	dd	0x0,0x3fe00000
	align	8
_668:
	dd	0x0,0x40000000
	align	8
_669:
	dd	0x0,0x40000000
	align	4
_428:
	dd	_106
	dd	89
	dd	3
	align	4
_434:
	dd	_106
	dd	90
	dd	3
	align	4
_452:
	dd	_106
	dd	92
	dd	3
	align	4
_462:
	dd	_106
	dd	93
	dd	3
	align	4
_472:
	dd	_106
	dd	95
	dd	3
	align	4
_482:
	dd	_106
	dd	96
	dd	3
_538:
	db	"c",0
	align	4
_537:
	dd	1
	dd	_58
	dd	2
	dd	_260
	dd	_222
	dd	-4
	dd	2
	dd	_493
	dd	_46
	dd	-8
	dd	2
	dd	_538
	dd	_46
	dd	-12
	dd	0
	align	4
_495:
	dd	_106
	dd	100
	dd	3
	align	8
_706:
	dd	0x0,0x3fe00000
	align	8
_707:
	dd	0x0,0x40000000
	align	8
_708:
	dd	0x0,0x40000000
	align	4
_513:
	dd	_106
	dd	101
	dd	3
	align	4
_709:
	dd	0x447a0000
	align	4
_519:
	dd	_106
	dd	102
	dd	3
	align	4
_710:
	dd	0x437f0000
	align	4
_520:
	dd	_106
	dd	103
	dd	3
