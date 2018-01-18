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
	extrn	_bbFloatPow
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
	extrn	_bbStringFromInt
	extrn	_brl_blitz_NullObjectError
	extrn	_brl_graphics_Flip
	extrn	_brl_graphics_Graphics
	extrn	_brl_linkedlist_TList
	extrn	_brl_max2d_Cls
	extrn	_brl_max2d_DrawOval
	extrn	_brl_max2d_DrawText
	extrn	_brl_max2d_SetBlend
	extrn	_brl_max2d_SetColor
	extrn	_brl_polledinput_KeyHit
	extrn	_brl_polledinput_MouseZSpeed
	public	__bb_TObjekt_Create
	public	__bb_TObjekt_New
	public	__bb_TObjekt_counter
	public	__bb_TObjekt_liste
	public	__bb_TObjekt_render
	public	__bb_TObjekt_render_v_1
	public	__bb_TObjekt_render_v_2
	public	__bb_main
	public	_bb_TObjekt
	section	"code" code
__bb_main:
	push	ebp
	mov	ebp,esp
	sub	esp,44
	push	ebx
	push	esi
	push	edi
	cmp	dword [_141],0
	je	_142
	mov	eax,0
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_142:
	mov	dword [_141],1
	fldz
	fstp	dword [ebp-4]
	fldz
	fstp	dword [ebp-8]
	fldz
	fstp	dword [ebp-12]
	mov	dword [ebp-16],_bbNullObject
	mov	eax,ebp
	push	eax
	push	_136
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
	push	_78
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_80
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_TObjekt
	call	_bbObjectRegisterType
	add	esp,4
	push	_81
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_brl_linkedlist_TList
	call	_bbObjectNew
	add	esp,4
	mov	dword [__bb_TObjekt_liste],eax
	push	_82
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	0
	push	0
	push	1176256512
	push	1112014848
	push	1157234688
	push	1157234688
	call	dword [_bb_TObjekt+48]
	add	esp,28
	push	_83
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1084227584
	push	0
	push	0
	push	1148846080
	push	1101004800
	push	1157234688
	push	1153138688
	call	dword [_bb_TObjekt+48]
	add	esp,28
	push	_84
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1092616192
	push	0
	push	0
	push	1120403456
	push	1092616192
	push	1157234688
	push	1152729088
	call	dword [_bb_TObjekt+48]
	add	esp,28
	push	_85
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	-1063256064
	push	0
	push	0
	push	1148846080
	push	1101004800
	push	1157234688
	push	1159479296
	call	dword [_bb_TObjekt+48]
	add	esp,28
	push	_86
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	-1054867456
	push	0
	push	0
	push	1120403456
	push	1092616192
	push	1157234688
	push	1159684096
	call	dword [_bb_TObjekt+48]
	add	esp,28
	push	_87
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	120
	push	0
	push	600
	push	800
	call	_brl_graphics_Graphics
	add	esp,20
	push	_88
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	3
	call	_brl_max2d_SetBlend
	add	esp,4
	push	_89
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [_291]
	fstp	dword [ebp-4]
	push	_91
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fldz
	fstp	dword [ebp-8]
	push	_93
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fldz
	fstp	dword [ebp-12]
	push	_95
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
_33:
	mov	eax,ebp
	push	eax
	push	_135
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_96
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [ebp-4]
	fstp	dword [ebp-20]
	call	_brl_polledinput_MouseZSpeed
	mov	dword [ebp+-44],eax
	fild	dword [ebp+-44]
	fmul	dword [_292]
	fld	dword [ebp-20]
	faddp	st1,st0
	fstp	dword [ebp-20]
	fld	dword [ebp-20]
	fstp	dword [ebp-4]
	push	_97
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	_brl_max2d_Cls
	push	_98
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bb_TObjekt+60]
	push	_99
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-16],_bbNullObject
	mov	eax,dword [__bb_TObjekt_liste]
	mov	dword [ebp-40],eax
	mov	ebx,dword [ebp-40]
	cmp	ebx,_bbNullObject
	jne	_103
	call	_brl_blitz_NullObjectError
_103:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+140]
	add	esp,4
	mov	dword [ebp-36],eax
	jmp	_34
_36:
	mov	ebx,dword [ebp-36]
	cmp	ebx,_bbNullObject
	jne	_108
	call	_brl_blitz_NullObjectError
_108:
	push	_bb_TObjekt
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,4
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	mov	dword [ebp-16],eax
	cmp	dword [ebp-16],_bbNullObject
	je	_34
	mov	eax,ebp
	push	eax
	push	_131
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_109
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	255
	push	255
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	_110
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-16]
	mov	dword [ebp-32],eax
	cmp	dword [ebp-32],_bbNullObject
	jne	_112
	call	_brl_blitz_NullObjectError
_112:
	mov	eax,dword [ebp-16]
	mov	dword [ebp-28],eax
	cmp	dword [ebp-28],_bbNullObject
	jne	_114
	call	_brl_blitz_NullObjectError
_114:
	mov	eax,dword [ebp-16]
	mov	dword [ebp-24],eax
	cmp	dword [ebp-24],_bbNullObject
	jne	_116
	call	_brl_blitz_NullObjectError
_116:
	mov	edi,dword [ebp-16]
	cmp	edi,_bbNullObject
	jne	_118
	call	_brl_blitz_NullObjectError
_118:
	mov	esi,dword [ebp-16]
	cmp	esi,_bbNullObject
	jne	_120
	call	_brl_blitz_NullObjectError
_120:
	mov	ebx,dword [ebp-16]
	cmp	ebx,_bbNullObject
	jne	_122
	call	_brl_blitz_NullObjectError
_122:
	fld	dword [_293]
	fmul	dword [ebx+16]
	fmul	dword [ebp-4]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [_294]
	fmul	dword [esi+16]
	fmul	dword [ebp-4]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-24]
	fld	dword [eax+24]
	fsub	dword [edi+16]
	fmul	dword [ebp-4]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-32]
	fld	dword [eax+20]
	mov	eax,dword [ebp-28]
	fsub	dword [eax+16]
	fmul	dword [ebp-4]
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_DrawOval
	add	esp,16
	push	_123
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	255
	push	0
	push	0
	call	_brl_max2d_SetColor
	add	esp,12
	push	_124
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	edi,dword [ebp-16]
	cmp	edi,_bbNullObject
	jne	_126
	call	_brl_blitz_NullObjectError
_126:
	mov	esi,dword [ebp-16]
	cmp	esi,_bbNullObject
	jne	_128
	call	_brl_blitz_NullObjectError
_128:
	mov	ebx,dword [ebp-16]
	cmp	ebx,_bbNullObject
	jne	_130
	call	_brl_blitz_NullObjectError
_130:
	fld	dword [ebx+24]
	fmul	dword [ebp-4]
	fsub	dword [_295]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [esi+20]
	fmul	dword [ebp-4]
	fsub	dword [_296]
	sub	esp,4
	fstp	dword [esp]
	push	dword [edi+36]
	call	_bbStringFromInt
	add	esp,4
	push	eax
	call	_brl_max2d_DrawText
	add	esp,12
	call	dword [_bbOnDebugLeaveScope]
_34:
	mov	ebx,dword [ebp-36]
	cmp	ebx,_bbNullObject
	jne	_106
	call	_brl_blitz_NullObjectError
_106:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_36
_35:
	push	_134
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	-1
	call	_brl_graphics_Flip
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
_31:
	push	27
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_33
_32:
	mov	ebx,0
	jmp	_56
_56:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TObjekt_New:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_144
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	dword [ebp-4]
	call	_bbObjectCtor
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [eax],_bb_TObjekt
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
	mov	eax,dword [ebp-4]
	fldz
	fstp	dword [eax+32]
	mov	eax,dword [ebp-4]
	mov	dword [eax+36],0
	push	ebp
	push	_143
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
	mov	ebx,0
	jmp	_59
_59:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TObjekt_Create:
	push	ebp
	mov	ebp,esp
	sub	esp,32
	push	ebx
	fld	dword [ebp+8]
	fstp	dword [ebp-4]
	fld	dword [ebp+12]
	fstp	dword [ebp-8]
	fld	dword [ebp+16]
	fstp	dword [ebp-12]
	fld	dword [ebp+20]
	fstp	dword [ebp-16]
	fld	dword [ebp+24]
	fstp	dword [ebp-20]
	fld	dword [ebp+28]
	fstp	dword [ebp-24]
	fld	dword [ebp+32]
	fstp	dword [ebp-28]
	mov	dword [ebp-32],_bbNullObject
	push	ebp
	push	_185
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_146
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_TObjekt
	call	_bbObjectNew
	add	esp,4
	mov	dword [ebp-32],eax
	push	_148
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [__bb_TObjekt_liste]
	cmp	ebx,_bbNullObject
	jne	_150
	call	_brl_blitz_NullObjectError
_150:
	push	dword [ebp-32]
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+68]
	add	esp,8
	push	_151
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	add	dword [__bb_TObjekt_counter],1
	push	_152
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-32]
	cmp	ebx,_bbNullObject
	jne	_154
	call	_brl_blitz_NullObjectError
_154:
	mov	eax,dword [__bb_TObjekt_counter]
	mov	dword [ebx+36],eax
	push	_156
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-32]
	cmp	ebx,_bbNullObject
	jne	_158
	call	_brl_blitz_NullObjectError
_158:
	fld	dword [ebp-4]
	fstp	dword [ebx+20]
	push	_160
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-32]
	cmp	ebx,_bbNullObject
	jne	_162
	call	_brl_blitz_NullObjectError
_162:
	fld	dword [ebp-8]
	fstp	dword [ebx+24]
	push	_164
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-32]
	cmp	ebx,_bbNullObject
	jne	_166
	call	_brl_blitz_NullObjectError
_166:
	fld	dword [ebp-24]
	fstp	dword [ebx+28]
	push	_168
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-32]
	cmp	ebx,_bbNullObject
	jne	_170
	call	_brl_blitz_NullObjectError
_170:
	fld	dword [ebp-28]
	fstp	dword [ebx+32]
	push	_172
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-32]
	cmp	ebx,_bbNullObject
	jne	_174
	call	_brl_blitz_NullObjectError
_174:
	fld	dword [ebp-12]
	fstp	dword [ebx+16]
	push	_176
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-32]
	cmp	ebx,_bbNullObject
	jne	_178
	call	_brl_blitz_NullObjectError
_178:
	fld	dword [ebp-16]
	fstp	dword [ebx+8]
	push	_180
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-32]
	cmp	ebx,_bbNullObject
	jne	_182
	call	_brl_blitz_NullObjectError
_182:
	fld	dword [ebp-20]
	fstp	dword [ebx+12]
	push	_184
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-32]
	jmp	_68
_68:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TObjekt_render_v_1:
	push	ebp
	mov	ebp,esp
	sub	esp,80
	push	ebx
	push	esi
	push	edi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	dword [ebp-8],_bbNullObject
	fldz
	fstp	dword [ebp-12]
	fldz
	fstp	dword [ebp-16]
	fldz
	fstp	dword [ebp-20]
	fldz
	fstp	dword [ebp-24]
	mov	eax,ebp
	push	eax
	push	_248
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_186
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-8],_bbNullObject
	mov	eax,dword [__bb_TObjekt_liste]
	mov	dword [ebp-76],eax
	mov	ebx,dword [ebp-76]
	cmp	ebx,_bbNullObject
	jne	_190
	call	_brl_blitz_NullObjectError
_190:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+140]
	add	esp,4
	mov	dword [ebp-80],eax
	jmp	_22
_24:
	mov	ebx,dword [ebp-80]
	cmp	ebx,_bbNullObject
	jne	_195
	call	_brl_blitz_NullObjectError
_195:
	push	_bb_TObjekt
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,4
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	mov	dword [ebp-8],eax
	cmp	dword [ebp-8],_bbNullObject
	je	_22
	mov	eax,ebp
	push	eax
	push	_247
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_196
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	cmp	dword [ebp-8],eax
	je	_197
	mov	eax,ebp
	push	eax
	push	_242
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_198
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-8]
	mov	dword [ebp-72],eax
	cmp	dword [ebp-72],_bbNullObject
	jne	_200
	call	_brl_blitz_NullObjectError
_200:
	mov	edi,dword [ebp-4]
	cmp	edi,_bbNullObject
	jne	_202
	call	_brl_blitz_NullObjectError
_202:
	mov	esi,dword [ebp-8]
	cmp	esi,_bbNullObject
	jne	_204
	call	_brl_blitz_NullObjectError
_204:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_206
	call	_brl_blitz_NullObjectError
_206:
	fld	qword [_327]
	sub	esp,8
	fstp	qword [esp]
	fld	qword [_328]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-72]
	fld	dword [eax+20]
	fsub	dword [edi+20]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-32]
	fld	qword [_329]
	sub	esp,8
	fstp	qword [esp]
	fld	dword [esi+24]
	fsub	dword [ebx+24]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [ebp-32]
	faddp	st1,st0
	fstp	qword [ebp-32]
	fld	qword [ebp-32]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	dword [ebp-12]
	push	_208
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-8]
	mov	dword [ebp-68],eax
	cmp	dword [ebp-68],_bbNullObject
	jne	_210
	call	_brl_blitz_NullObjectError
_210:
	mov	edi,dword [ebp-4]
	cmp	edi,_bbNullObject
	jne	_212
	call	_brl_blitz_NullObjectError
_212:
	mov	esi,dword [ebp-8]
	cmp	esi,_bbNullObject
	jne	_214
	call	_brl_blitz_NullObjectError
_214:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_216
	call	_brl_blitz_NullObjectError
_216:
	fld	dword [esi+20]
	fsub	dword [ebx+20]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-68]
	fld	dword [eax+24]
	fsub	dword [edi+24]
	sub	esp,8
	fstp	qword [esp]
	call	_bbATan2
	add	esp,16
	fstp	dword [ebp-16]
	push	_218
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-8]
	cmp	esi,_bbNullObject
	jne	_220
	call	_brl_blitz_NullObjectError
_220:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_222
	call	_brl_blitz_NullObjectError
_222:
	fld	dword [esi+8]
	fmul	dword [ebx+8]
	fstp	qword [ebp-40]
	fld	qword [_330]
	sub	esp,8
	fstp	qword [esp]
	fld	dword [ebp-12]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [ebp-40]
	fdivrp	st1,st0
	fstp	qword [ebp-40]
	fld	qword [ebp-40]
	fstp	dword [ebp-20]
	push	_224
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,dword [ebp-8]
	cmp	esi,_bbNullObject
	jne	_226
	call	_brl_blitz_NullObjectError
_226:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_228
	call	_brl_blitz_NullObjectError
_228:
	fld	dword [esi+12]
	fchs
	fmul	dword [ebx+12]
	fstp	qword [ebp-48]
	fld	qword [_331]
	sub	esp,8
	fstp	qword [esp]
	fld	dword [ebp-12]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [ebp-48]
	fdivrp	st1,st0
	fstp	qword [ebp-48]
	fld	qword [ebp-48]
	fstp	dword [ebp-24]
	push	_230
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_232
	call	_brl_blitz_NullObjectError
_232:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_235
	call	_brl_blitz_NullObjectError
_235:
	fld	dword [ebx+28]
	fstp	qword [ebp-56]
	fld	dword [ebp-16]
	sub	esp,8
	fstp	qword [esp]
	call	_bbCos
	add	esp,8
	fld	dword [ebp-20]
	fadd	dword [ebp-24]
	fmulp	st1,st0
	fld	dword [esi+8]
	fdivp	st1,st0
	fld	qword [ebp-56]
	faddp	st1,st0
	fstp	qword [ebp-56]
	fld	qword [ebp-56]
	fstp	dword [ebx+28]
	push	_236
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_238
	call	_brl_blitz_NullObjectError
_238:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_241
	call	_brl_blitz_NullObjectError
_241:
	fld	dword [ebx+32]
	fstp	qword [ebp-64]
	fld	dword [ebp-16]
	sub	esp,8
	fstp	qword [esp]
	call	_bbSin
	add	esp,8
	fld	dword [ebp-20]
	fadd	dword [ebp-24]
	fmulp	st1,st0
	fld	dword [esi+8]
	fdivp	st1,st0
	fld	qword [ebp-64]
	faddp	st1,st0
	fstp	qword [ebp-64]
	fld	qword [ebp-64]
	fstp	dword [ebx+32]
	call	dword [_bbOnDebugLeaveScope]
_197:
	call	dword [_bbOnDebugLeaveScope]
_22:
	mov	ebx,dword [ebp-80]
	cmp	ebx,_bbNullObject
	jne	_193
	call	_brl_blitz_NullObjectError
_193:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_24
_23:
	mov	ebx,0
	jmp	_71
_71:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TObjekt_render_v_2:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	push	esi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_261
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_249
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_251
	call	_brl_blitz_NullObjectError
_251:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_254
	call	_brl_blitz_NullObjectError
_254:
	fld	dword [ebx+20]
	fadd	dword [esi+28]
	fstp	dword [ebx+20]
	push	_255
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_257
	call	_brl_blitz_NullObjectError
_257:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_260
	call	_brl_blitz_NullObjectError
_260:
	fld	dword [ebx+24]
	fadd	dword [esi+32]
	fstp	dword [ebx+24]
	mov	ebx,0
	jmp	_74
_74:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TObjekt_render:
	push	ebp
	mov	ebp,esp
	sub	esp,8
	push	ebx
	push	esi
	push	edi
	mov	dword [ebp-4],_bbNullObject
	mov	dword [ebp-8],_bbNullObject
	mov	eax,ebp
	push	eax
	push	_290
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_262
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-4],_bbNullObject
	mov	edi,dword [__bb_TObjekt_liste]
	mov	ebx,edi
	cmp	ebx,_bbNullObject
	jne	_266
	call	_brl_blitz_NullObjectError
_266:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+140]
	add	esp,4
	mov	esi,eax
	jmp	_25
_27:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_271
	call	_brl_blitz_NullObjectError
_271:
	push	_bb_TObjekt
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,4
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	mov	dword [ebp-4],eax
	cmp	dword [ebp-4],_bbNullObject
	je	_25
	mov	eax,ebp
	push	eax
	push	_275
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_272
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_274
	call	_brl_blitz_NullObjectError
_274:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
_25:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_269
	call	_brl_blitz_NullObjectError
_269:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_27
_26:
	push	_276
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-8],_bbNullObject
	mov	edi,dword [__bb_TObjekt_liste]
	mov	ebx,edi
	cmp	ebx,_bbNullObject
	jne	_280
	call	_brl_blitz_NullObjectError
_280:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+140]
	add	esp,4
	mov	esi,eax
	jmp	_28
_30:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_285
	call	_brl_blitz_NullObjectError
_285:
	push	_bb_TObjekt
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,4
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	mov	dword [ebp-8],eax
	cmp	dword [ebp-8],_bbNullObject
	je	_28
	mov	eax,ebp
	push	eax
	push	_289
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_286
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_288
	call	_brl_blitz_NullObjectError
_288:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+56]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
_28:
	mov	ebx,esi
	cmp	ebx,_bbNullObject
	jne	_283
	call	_brl_blitz_NullObjectError
_283:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_30
_29:
	mov	ebx,0
	jmp	_76
_76:
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
_141:
	dd	0
_137:
	db	"v3",0
_138:
	db	"scale",0
_40:
	db	"f",0
_139:
	db	"x_pos",0
_140:
	db	"y_pos",0
	align	4
_136:
	dd	1
	dd	_137
	dd	2
	dd	_138
	dd	_40
	dd	-4
	dd	2
	dd	_139
	dd	_40
	dd	-8
	dd	2
	dd	_140
	dd	_40
	dd	-12
	dd	0
_79:
	db	"C:/Project-Archive/BlitzMax Projects/Simulations/planetensimulation/v3.bmx",0
	align	4
_78:
	dd	_79
	dd	4
	dd	2
	align	4
__bb_TObjekt_liste:
	dd	_bbNullObject
	align	4
_80:
	dd	_79
	dd	5
	dd	2
	align	4
__bb_TObjekt_counter:
	dd	0
_38:
	db	"TObjekt",0
_39:
	db	"mass",0
_41:
	db	"charge",0
_42:
	db	"r",0
_43:
	db	"x",0
_44:
	db	"y",0
_45:
	db	"vx",0
_46:
	db	"vy",0
_47:
	db	"id",0
_48:
	db	"i",0
_49:
	db	"New",0
_50:
	db	"()i",0
_51:
	db	"Create",0
_52:
	db	"(f,f,f,f,f,f,f):TObjekt",0
_53:
	db	"render_v_1",0
_54:
	db	"render_v_2",0
_55:
	db	"render",0
	align	4
_37:
	dd	2
	dd	_38
	dd	3
	dd	_39
	dd	_40
	dd	8
	dd	3
	dd	_41
	dd	_40
	dd	12
	dd	3
	dd	_42
	dd	_40
	dd	16
	dd	3
	dd	_43
	dd	_40
	dd	20
	dd	3
	dd	_44
	dd	_40
	dd	24
	dd	3
	dd	_45
	dd	_40
	dd	28
	dd	3
	dd	_46
	dd	_40
	dd	32
	dd	3
	dd	_47
	dd	_48
	dd	36
	dd	6
	dd	_49
	dd	_50
	dd	16
	dd	7
	dd	_51
	dd	_52
	dd	48
	dd	6
	dd	_53
	dd	_50
	dd	52
	dd	6
	dd	_54
	dd	_50
	dd	56
	dd	7
	dd	_55
	dd	_50
	dd	60
	dd	0
	align	4
_bb_TObjekt:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_37
	dd	40
	dd	__bb_TObjekt_New
	dd	_bbObjectDtor
	dd	_bbObjectToString
	dd	_bbObjectCompare
	dd	_bbObjectSendMessage
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	__bb_TObjekt_Create
	dd	__bb_TObjekt_render_v_1
	dd	__bb_TObjekt_render_v_2
	dd	__bb_TObjekt_render
	align	4
_81:
	dd	_79
	dd	69
	dd	1
	align	4
_82:
	dd	_79
	dd	83
	dd	1
	align	4
_83:
	dd	_79
	dd	84
	dd	1
	align	4
_84:
	dd	_79
	dd	85
	dd	1
	align	4
_85:
	dd	_79
	dd	87
	dd	1
	align	4
_86:
	dd	_79
	dd	88
	dd	1
	align	4
_87:
	dd	_79
	dd	99
	dd	1
	align	4
_88:
	dd	_79
	dd	101
	dd	1
	align	4
_89:
	dd	_79
	dd	103
	dd	1
	align	4
_291:
	dd	0x3e4ccccd
	align	4
_91:
	dd	_79
	dd	104
	dd	1
	align	4
_93:
	dd	_79
	dd	105
	dd	1
	align	4
_95:
	dd	_79
	dd	121
	dd	1
	align	4
_135:
	dd	3
	dd	0
	dd	0
	align	4
_96:
	dd	_79
	dd	108
	dd	2
	align	4
_292:
	dd	0x3ca3d70a
	align	4
_97:
	dd	_79
	dd	109
	dd	2
	align	4
_98:
	dd	_79
	dd	110
	dd	2
	align	4
_99:
	dd	_79
	dd	111
	dd	2
_132:
	db	"o",0
_133:
	db	":TObjekt",0
	align	4
_131:
	dd	3
	dd	0
	dd	2
	dd	_132
	dd	_133
	dd	-16
	dd	0
	align	4
_109:
	dd	_79
	dd	112
	dd	3
	align	4
_110:
	dd	_79
	dd	113
	dd	3
	align	4
_293:
	dd	0x40000000
	align	4
_294:
	dd	0x40000000
	align	4
_123:
	dd	_79
	dd	114
	dd	3
	align	4
_124:
	dd	_79
	dd	115
	dd	3
	align	4
_295:
	dd	0x40a00000
	align	4
_296:
	dd	0x40a00000
	align	4
_134:
	dd	_79
	dd	120
	dd	2
_145:
	db	"Self",0
	align	4
_144:
	dd	1
	dd	_49
	dd	2
	dd	_145
	dd	_133
	dd	-4
	dd	0
	align	4
_143:
	dd	3
	dd	0
	dd	0
	align	4
_185:
	dd	1
	dd	_51
	dd	2
	dd	_43
	dd	_40
	dd	-4
	dd	2
	dd	_44
	dd	_40
	dd	-8
	dd	2
	dd	_42
	dd	_40
	dd	-12
	dd	2
	dd	_39
	dd	_40
	dd	-16
	dd	2
	dd	_41
	dd	_40
	dd	-20
	dd	2
	dd	_45
	dd	_40
	dd	-24
	dd	2
	dd	_46
	dd	_40
	dd	-28
	dd	2
	dd	_132
	dd	_133
	dd	-32
	dd	0
	align	4
_146:
	dd	_79
	dd	18
	dd	3
	align	4
_148:
	dd	_79
	dd	20
	dd	3
	align	4
_151:
	dd	_79
	dd	21
	dd	3
	align	4
_152:
	dd	_79
	dd	22
	dd	3
	align	4
_156:
	dd	_79
	dd	24
	dd	3
	align	4
_160:
	dd	_79
	dd	25
	dd	3
	align	4
_164:
	dd	_79
	dd	26
	dd	3
	align	4
_168:
	dd	_79
	dd	27
	dd	3
	align	4
_172:
	dd	_79
	dd	29
	dd	3
	align	4
_176:
	dd	_79
	dd	30
	dd	3
	align	4
_180:
	dd	_79
	dd	31
	dd	3
	align	4
_184:
	dd	_79
	dd	33
	dd	3
	align	4
_248:
	dd	1
	dd	_53
	dd	2
	dd	_145
	dd	_133
	dd	-4
	dd	0
	align	4
_186:
	dd	_79
	dd	37
	dd	3
	align	4
_247:
	dd	3
	dd	0
	dd	2
	dd	_132
	dd	_133
	dd	-8
	dd	0
	align	4
_196:
	dd	_79
	dd	38
	dd	4
_243:
	db	"d",0
_244:
	db	"w",0
_245:
	db	"fg",0
_246:
	db	"fe",0
	align	4
_242:
	dd	3
	dd	0
	dd	2
	dd	_243
	dd	_40
	dd	-12
	dd	2
	dd	_244
	dd	_40
	dd	-16
	dd	2
	dd	_245
	dd	_40
	dd	-20
	dd	2
	dd	_246
	dd	_40
	dd	-24
	dd	0
	align	4
_198:
	dd	_79
	dd	39
	dd	5
	align	8
_327:
	dd	0x0,0x3fe00000
	align	8
_328:
	dd	0x0,0x40000000
	align	8
_329:
	dd	0x0,0x40000000
	align	4
_208:
	dd	_79
	dd	40
	dd	5
	align	4
_218:
	dd	_79
	dd	42
	dd	5
	align	8
_330:
	dd	0x0,0x40000000
	align	4
_224:
	dd	_79
	dd	43
	dd	5
	align	8
_331:
	dd	0x0,0x40000000
	align	4
_230:
	dd	_79
	dd	46
	dd	5
	align	4
_236:
	dd	_79
	dd	47
	dd	5
	align	4
_261:
	dd	1
	dd	_54
	dd	2
	dd	_145
	dd	_133
	dd	-4
	dd	0
	align	4
_249:
	dd	_79
	dd	54
	dd	3
	align	4
_255:
	dd	_79
	dd	55
	dd	3
	align	4
_290:
	dd	1
	dd	_55
	dd	0
	align	4
_262:
	dd	_79
	dd	60
	dd	3
	align	4
_275:
	dd	3
	dd	0
	dd	2
	dd	_132
	dd	_133
	dd	-4
	dd	0
	align	4
_272:
	dd	_79
	dd	61
	dd	4
	align	4
_276:
	dd	_79
	dd	63
	dd	3
	align	4
_289:
	dd	3
	dd	0
	dd	2
	dd	_132
	dd	_133
	dd	-8
	dd	0
	align	4
_286:
	dd	_79
	dd	64
	dd	4
