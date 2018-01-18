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
	extrn	_bbArrayNew1D
	extrn	_bbEmptyArray
	extrn	_bbMilliSecs
	extrn	_bbNullObject
	extrn	_bbObjectClass
	extrn	_bbObjectCompare
	extrn	_bbObjectCtor
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
	extrn	_bbStringClass
	extrn	_bbStringConcat
	extrn	_brl_blitz_ArrayBoundsError
	extrn	_brl_blitz_NullObjectError
	extrn	_brl_graphics_Flip
	extrn	_brl_graphics_Graphics
	extrn	_brl_max2d_Cls
	extrn	_brl_max2d_DrawImage
	extrn	_brl_max2d_LoadAnimImage
	extrn	_brl_max2d_SetClsColor
	extrn	_brl_max2d_SetColor
	extrn	_brl_max2d_SetImageHandle
	extrn	_brl_max2d_SetRotation
	extrn	_brl_max2d_SetScale
	extrn	_brl_max2d_TMax2DGraphics
	extrn	_brl_polledinput_KeyDown
	extrn	_brl_polledinput_KeyHit
	extrn	_brl_polledinput_MouseX
	extrn	_brl_polledinput_MouseY
	public	__bb_CHARACTER_Create
	public	__bb_CHARACTER_IMG_Load
	public	__bb_CHARACTER_IMG_NORMAL
	public	__bb_CHARACTER_IMG_New
	public	__bb_CHARACTER_IMG_drawhandle
	public	__bb_CHARACTER_IMG_init
	public	__bb_CHARACTER_New
	public	__bb_CHARACTER_draw
	public	__bb_main
	public	_bb_CHARACTER
	public	_bb_CHARACTER_IMG
	section	"code" code
__bb_main:
	push	ebp
	mov	ebp,esp
	sub	esp,12
	push	ebx
	push	esi
	cmp	dword [_156],0
	je	_157
	mov	eax,0
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_157:
	mov	dword [_156],1
	mov	dword [ebp-4],_bbNullObject
	mov	dword [ebp-8],_bbNullObject
	mov	dword [ebp-12],_bbNullObject
	mov	eax,ebp
	push	eax
	push	_150
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
	push	_102
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_CHARACTER_IMG
	call	_bbObjectRegisterType
	add	esp,4
	push	_bb_CHARACTER
	call	_bbObjectRegisterType
	add	esp,4
	push	_104
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	60
	push	0
	push	600
	push	800
	call	_brl_graphics_Graphics
	add	esp,20
	push	_105
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bb_CHARACTER_IMG+48]
	push	_106
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	dword [__bb_CHARACTER_IMG_NORMAL]
	call	dword [_bb_CHARACTER+48]
	add	esp,4
	mov	dword [ebp-4],eax
	push	_108
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	dword [__bb_CHARACTER_IMG_NORMAL]
	call	dword [_bb_CHARACTER+48]
	add	esp,4
	mov	dword [ebp-8],eax
	push	_110
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	dword [__bb_CHARACTER_IMG_NORMAL]
	call	dword [_bb_CHARACTER+48]
	add	esp,4
	mov	dword [ebp-12],eax
	push	_112
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
_29:
	mov	eax,ebp
	push	eax
	push	_149
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_113
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	esi,255
	mov	ebx,100
	call	_bbMilliSecs
	cdq
	idiv	ebx
	cdq
	idiv	esi
	mov	eax,edx
	push	eax
	mov	esi,255
	mov	ebx,100
	call	_bbMilliSecs
	cdq
	idiv	ebx
	cdq
	idiv	esi
	mov	eax,edx
	push	eax
	mov	esi,255
	mov	ebx,100
	call	_bbMilliSecs
	cdq
	idiv	ebx
	cdq
	idiv	esi
	mov	eax,edx
	push	eax
	call	_brl_max2d_SetClsColor
	add	esp,12
	push	_114
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	_brl_max2d_Cls
	push	_115
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	68
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_116
	mov	eax,ebp
	push	eax
	push	_120
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_117
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_119
	call	_brl_blitz_NullObjectError
_119:
	call	_brl_polledinput_MouseY
	sub	eax,200
	push	eax
	call	_brl_polledinput_MouseX
	sub	eax,50
	push	eax
	push	3
	push	200
	push	50
	push	0
	push	0
	push	0
	push	1
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,40
	call	dword [_bbOnDebugLeaveScope]
	jmp	_121
_116:
	mov	eax,ebp
	push	eax
	push	_125
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_122
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_124
	call	_brl_blitz_NullObjectError
_124:
	call	_brl_polledinput_MouseY
	sub	eax,200
	push	eax
	call	_brl_polledinput_MouseX
	sub	eax,50
	push	eax
	push	3
	push	200
	push	50
	push	0
	push	0
	push	1
	push	1
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,40
	call	dword [_bbOnDebugLeaveScope]
_121:
	push	_126
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	68
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_127
	mov	eax,ebp
	push	eax
	push	_131
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_128
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_130
	call	_brl_blitz_NullObjectError
_130:
	call	_brl_polledinput_MouseY
	sub	eax,200
	push	eax
	call	_brl_polledinput_MouseX
	sub	eax,200
	push	eax
	push	3
	push	200
	push	200
	push	1
	push	1
	push	0
	push	1
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,40
	call	dword [_bbOnDebugLeaveScope]
	jmp	_132
_127:
	mov	eax,ebp
	push	eax
	push	_136
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_133
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_135
	call	_brl_blitz_NullObjectError
_135:
	call	_brl_polledinput_MouseY
	sub	eax,200
	push	eax
	call	_brl_polledinput_MouseX
	sub	eax,200
	push	eax
	push	3
	push	200
	push	200
	push	1
	push	1
	push	1
	push	1
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,40
	call	dword [_bbOnDebugLeaveScope]
_132:
	push	_137
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	68
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_138
	mov	eax,ebp
	push	eax
	push	_142
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_139
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-12]
	cmp	ebx,_bbNullObject
	jne	_141
	call	_brl_blitz_NullObjectError
_141:
	call	_brl_polledinput_MouseY
	sub	eax,200
	push	eax
	call	_brl_polledinput_MouseX
	sub	eax,350
	push	eax
	push	3
	push	200
	push	350
	push	2
	push	2
	push	0
	push	1
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,40
	call	dword [_bbOnDebugLeaveScope]
	jmp	_143
_138:
	mov	eax,ebp
	push	eax
	push	_147
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_144
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-12]
	cmp	ebx,_bbNullObject
	jne	_146
	call	_brl_blitz_NullObjectError
_146:
	call	_brl_polledinput_MouseY
	sub	eax,200
	push	eax
	call	_brl_polledinput_MouseX
	sub	eax,350
	push	eax
	push	3
	push	200
	push	350
	push	2
	push	2
	push	1
	push	1
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,40
	call	dword [_bbOnDebugLeaveScope]
_143:
	push	_148
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	-1
	call	_brl_graphics_Flip
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
_27:
	push	27
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_29
_28:
	mov	ebx,0
	jmp	_66
_66:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_CHARACTER_IMG_New:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_159
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	dword [ebp-4]
	call	_bbObjectCtor
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [eax],_bb_CHARACTER_IMG
	mov	eax,dword [ebp-4]
	mov	dword [eax+8],_bbNullObject
	mov	eax,dword [ebp-4]
	mov	dword [eax+12],_bbNullObject
	mov	eax,dword [ebp-4]
	mov	dword [eax+16],_bbNullObject
	mov	eax,dword [ebp-4]
	mov	dword [eax+20],_bbNullObject
	mov	eax,dword [ebp-4]
	mov	dword [eax+24],0
	mov	eax,dword [ebp-4]
	mov	dword [eax+28],0
	mov	eax,dword [ebp-4]
	mov	dword [eax+32],_bbEmptyArray
	mov	eax,dword [ebp-4]
	mov	dword [eax+36],_bbEmptyArray
	mov	eax,dword [ebp-4]
	mov	dword [eax+40],0
	mov	eax,dword [ebp-4]
	mov	dword [eax+44],0
	mov	eax,dword [ebp-4]
	mov	dword [eax+48],0
	mov	eax,dword [ebp-4]
	mov	dword [eax+52],0
	mov	eax,dword [ebp-4]
	mov	dword [eax+56],0
	push	ebp
	push	_158
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
	mov	ebx,0
	jmp	_69
_69:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_CHARACTER_IMG_init:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	ebp
	push	_162
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_161
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_22
	call	dword [_bb_CHARACTER_IMG+52]
	add	esp,4
	mov	dword [__bb_CHARACTER_IMG_NORMAL],eax
	mov	ebx,0
	jmp	_71
_71:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_CHARACTER_IMG_Load:
	push	ebp
	mov	ebp,esp
	sub	esp,40
	push	ebx
	push	esi
	push	edi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	dword [ebp-8],_bbNullObject
	mov	eax,ebp
	push	eax
	push	_328
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_163
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_CHARACTER_IMG
	call	_bbObjectNew
	add	esp,4
	mov	dword [ebp-8],eax
	push	_165
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_167
	call	_brl_blitz_NullObjectError
_167:
	push	4
	push	_169
	call	_bbArrayNew1D
	add	esp,8
	mov	dword [ebx+32],eax
	push	_170
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_172
	call	_brl_blitz_NullObjectError
_172:
	push	4
	push	_174
	call	_bbArrayNew1D
	add	esp,8
	mov	dword [ebx+36],eax
	push	_175
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_177
	call	_brl_blitz_NullObjectError
_177:
	mov	dword [ebx+24],4
	push	_179
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_181
	call	_brl_blitz_NullObjectError
_181:
	mov	dword [ebx+28],4
	push	_183
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_185
	call	_brl_blitz_NullObjectError
_185:
	mov	dword [ebx+56],32
	push	_187
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_189
	call	_brl_blitz_NullObjectError
_189:
	mov	dword [ebp-40],ebx
	mov	eax,dword [ebp-8]
	mov	dword [ebp-12],eax
	cmp	dword [ebp-12],_bbNullObject
	jne	_192
	call	_brl_blitz_NullObjectError
_192:
	mov	edi,dword [ebp-8]
	cmp	edi,_bbNullObject
	jne	_194
	call	_brl_blitz_NullObjectError
_194:
	mov	esi,dword [ebp-8]
	cmp	esi,_bbNullObject
	jne	_196
	call	_brl_blitz_NullObjectError
_196:
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_198
	call	_brl_blitz_NullObjectError
_198:
	push	0
	mov	eax,dword [esi+24]
	imul	eax,dword [ebx+28]
	push	eax
	push	0
	push	dword [edi+56]
	mov	eax,dword [ebp-12]
	push	dword [eax+56]
	push	_23
	push	dword [ebp-4]
	call	_bbStringConcat
	add	esp,8
	push	eax
	call	_brl_max2d_LoadAnimImage
	add	esp,24
	mov	edx,dword [ebp-40]
	mov	dword [edx+8],eax
	push	_199
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_201
	call	_brl_blitz_NullObjectError
_201:
	mov	dword [ebp-36],ebx
	mov	eax,dword [ebp-8]
	mov	dword [ebp-16],eax
	cmp	dword [ebp-16],_bbNullObject
	jne	_204
	call	_brl_blitz_NullObjectError
_204:
	mov	edi,dword [ebp-8]
	cmp	edi,_bbNullObject
	jne	_206
	call	_brl_blitz_NullObjectError
_206:
	mov	esi,dword [ebp-8]
	cmp	esi,_bbNullObject
	jne	_208
	call	_brl_blitz_NullObjectError
_208:
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_210
	call	_brl_blitz_NullObjectError
_210:
	push	0
	mov	eax,dword [esi+24]
	imul	eax,dword [ebx+28]
	push	eax
	push	0
	push	dword [edi+56]
	mov	eax,dword [ebp-16]
	push	dword [eax+56]
	push	_24
	push	dword [ebp-4]
	call	_bbStringConcat
	add	esp,8
	push	eax
	call	_brl_max2d_LoadAnimImage
	add	esp,24
	mov	edx,dword [ebp-36]
	mov	dword [edx+12],eax
	push	_211
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_213
	call	_brl_blitz_NullObjectError
_213:
	mov	dword [ebp-32],ebx
	mov	eax,dword [ebp-8]
	mov	dword [ebp-20],eax
	cmp	dword [ebp-20],_bbNullObject
	jne	_216
	call	_brl_blitz_NullObjectError
_216:
	mov	edi,dword [ebp-8]
	cmp	edi,_bbNullObject
	jne	_218
	call	_brl_blitz_NullObjectError
_218:
	mov	esi,dword [ebp-8]
	cmp	esi,_bbNullObject
	jne	_220
	call	_brl_blitz_NullObjectError
_220:
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_222
	call	_brl_blitz_NullObjectError
_222:
	push	0
	mov	eax,dword [esi+24]
	imul	eax,dword [ebx+28]
	push	eax
	push	0
	push	dword [edi+56]
	mov	eax,dword [ebp-20]
	push	dword [eax+56]
	push	_25
	push	dword [ebp-4]
	call	_bbStringConcat
	add	esp,8
	push	eax
	call	_brl_max2d_LoadAnimImage
	add	esp,24
	mov	edx,dword [ebp-32]
	mov	dword [edx+16],eax
	push	_223
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_225
	call	_brl_blitz_NullObjectError
_225:
	mov	dword [ebp-28],ebx
	mov	eax,dword [ebp-8]
	mov	dword [ebp-24],eax
	cmp	dword [ebp-24],_bbNullObject
	jne	_228
	call	_brl_blitz_NullObjectError
_228:
	mov	edi,dword [ebp-8]
	cmp	edi,_bbNullObject
	jne	_230
	call	_brl_blitz_NullObjectError
_230:
	mov	esi,dword [ebp-8]
	cmp	esi,_bbNullObject
	jne	_232
	call	_brl_blitz_NullObjectError
_232:
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_234
	call	_brl_blitz_NullObjectError
_234:
	push	0
	mov	eax,dword [esi+24]
	imul	eax,dword [ebx+28]
	push	eax
	push	0
	push	dword [edi+56]
	mov	eax,dword [ebp-24]
	push	dword [eax+56]
	push	_26
	push	dword [ebp-4]
	call	_bbStringConcat
	add	esp,8
	push	eax
	call	_brl_max2d_LoadAnimImage
	add	esp,24
	mov	edx,dword [ebp-28]
	mov	dword [edx+20],eax
	push	_235
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_237
	call	_brl_blitz_NullObjectError
_237:
	push	1098907648
	push	1098907648
	push	dword [ebx+8]
	call	_brl_max2d_SetImageHandle
	add	esp,12
	push	_238
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_240
	call	_brl_blitz_NullObjectError
_240:
	push	1098907648
	push	1098907648
	push	dword [ebx+12]
	call	_brl_max2d_SetImageHandle
	add	esp,12
	push	_241
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_243
	call	_brl_blitz_NullObjectError
_243:
	push	1098907648
	push	1098907648
	push	dword [ebx+16]
	call	_brl_max2d_SetImageHandle
	add	esp,12
	push	_244
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_246
	call	_brl_blitz_NullObjectError
_246:
	push	1098907648
	push	1098907648
	push	dword [ebx+20]
	call	_brl_max2d_SetImageHandle
	add	esp,12
	push	_247
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_249
	call	_brl_blitz_NullObjectError
_249:
	mov	ebx,dword [ebx+32]
	mov	esi,0
	cmp	esi,dword [ebx+20]
	jb	_252
	call	_brl_blitz_ArrayBoundsError
_252:
	shl	esi,2
	add	ebx,esi
	push	1
	push	_38
	call	_bbArrayNew1D
	add	esp,8
	mov	dword [eax+24],1
	mov	dword [ebx+24],eax
	push	_255
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_257
	call	_brl_blitz_NullObjectError
_257:
	mov	ebx,dword [ebx+32]
	mov	esi,1
	cmp	esi,dword [ebx+20]
	jb	_260
	call	_brl_blitz_ArrayBoundsError
_260:
	shl	esi,2
	add	ebx,esi
	push	4
	push	_38
	call	_bbArrayNew1D
	add	esp,8
	mov	dword [eax+24],8
	mov	dword [eax+28],8
	mov	dword [eax+32],8
	mov	dword [eax+36],8
	mov	dword [ebx+24],eax
	push	_263
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_265
	call	_brl_blitz_NullObjectError
_265:
	mov	ebx,dword [ebx+32]
	mov	esi,2
	cmp	esi,dword [ebx+20]
	jb	_268
	call	_brl_blitz_ArrayBoundsError
_268:
	shl	esi,2
	add	ebx,esi
	push	1
	push	_38
	call	_bbArrayNew1D
	add	esp,8
	mov	dword [eax+24],1
	mov	dword [ebx+24],eax
	push	_271
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_273
	call	_brl_blitz_NullObjectError
_273:
	mov	ebx,dword [ebx+32]
	mov	esi,3
	cmp	esi,dword [ebx+20]
	jb	_276
	call	_brl_blitz_ArrayBoundsError
_276:
	shl	esi,2
	add	ebx,esi
	push	1
	push	_38
	call	_bbArrayNew1D
	add	esp,8
	mov	dword [eax+24],1
	mov	dword [ebx+24],eax
	push	_279
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_281
	call	_brl_blitz_NullObjectError
_281:
	mov	ebx,dword [ebx+36]
	mov	esi,0
	cmp	esi,dword [ebx+20]
	jb	_284
	call	_brl_blitz_ArrayBoundsError
_284:
	shl	esi,2
	add	ebx,esi
	push	1
	push	_38
	call	_bbArrayNew1D
	add	esp,8
	mov	dword [eax+24],0
	mov	dword [ebx+24],eax
	push	_287
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_289
	call	_brl_blitz_NullObjectError
_289:
	mov	ebx,dword [ebx+36]
	mov	esi,1
	cmp	esi,dword [ebx+20]
	jb	_292
	call	_brl_blitz_ArrayBoundsError
_292:
	shl	esi,2
	add	ebx,esi
	push	4
	push	_38
	call	_bbArrayNew1D
	add	esp,8
	mov	dword [eax+24],0
	mov	dword [eax+28],-1
	mov	dword [eax+32],0
	mov	dword [eax+36],-1
	mov	dword [ebx+24],eax
	push	_295
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_297
	call	_brl_blitz_NullObjectError
_297:
	mov	ebx,dword [ebx+36]
	mov	esi,2
	cmp	esi,dword [ebx+20]
	jb	_300
	call	_brl_blitz_ArrayBoundsError
_300:
	shl	esi,2
	add	ebx,esi
	push	1
	push	_38
	call	_bbArrayNew1D
	add	esp,8
	mov	dword [eax+24],0
	mov	dword [ebx+24],eax
	push	_303
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_305
	call	_brl_blitz_NullObjectError
_305:
	mov	ebx,dword [ebx+36]
	mov	esi,3
	cmp	esi,dword [ebx+20]
	jb	_308
	call	_brl_blitz_ArrayBoundsError
_308:
	shl	esi,2
	add	ebx,esi
	push	1
	push	_38
	call	_bbArrayNew1D
	add	esp,8
	mov	dword [eax+24],0
	mov	dword [ebx+24],eax
	push	_311
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_313
	call	_brl_blitz_NullObjectError
_313:
	mov	dword [ebx+40],20
	push	_315
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_317
	call	_brl_blitz_NullObjectError
_317:
	mov	dword [ebx+44],13
	push	_319
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_321
	call	_brl_blitz_NullObjectError
_321:
	mov	dword [ebx+48],14
	push	_323
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_325
	call	_brl_blitz_NullObjectError
_325:
	mov	dword [ebx+52],13
	push	_327
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	jmp	_74
_74:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_CHARACTER_IMG_drawhandle:
	push	ebp
	mov	ebp,esp
	sub	esp,60
	push	ebx
	push	esi
	push	edi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	fld	dword [ebp+12]
	fstp	dword [ebp-8]
	fld	dword [ebp+16]
	fstp	dword [ebp-12]
	mov	eax,dword [ebp+20]
	mov	dword [ebp-16],eax
	mov	eax,dword [ebp+24]
	mov	dword [ebp-20],eax
	mov	eax,dword [ebp+28]
	mov	dword [ebp-24],eax
	mov	dword [ebp-28],_bbNullObject
	fldz
	fstp	dword [ebp-32]
	fldz
	fstp	dword [ebp-36]
	fldz
	fstp	dword [ebp-40]
	fldz
	fstp	dword [ebp-44]
	mov	dword [ebp-48],_bbNullObject
	mov	eax,ebp
	push	eax
	push	_362
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_332
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_brl_max2d_TMax2DGraphics+76]
	mov	dword [ebp-28],eax
	push	_334
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-20]
	neg	eax
	mov	dword [ebp+-60],eax
	fild	dword [ebp+-60]
	fstp	dword [ebp-32]
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_337
	call	_brl_blitz_NullObjectError
_337:
	fld	dword [ebp-32]
	mov	eax,dword [ebx+8]
	mov	dword [ebp+-60],eax
	fild	dword [ebp+-60]
	faddp	st1,st0
	fstp	dword [ebp-36]
	push	_339
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-24]
	neg	eax
	mov	dword [ebp+-60],eax
	fild	dword [ebp+-60]
	fstp	dword [ebp-40]
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_342
	call	_brl_blitz_NullObjectError
_342:
	fld	dword [ebp-40]
	mov	eax,dword [ebx+12]
	mov	dword [ebp+-60],eax
	fild	dword [ebp+-60]
	faddp	st1,st0
	fstp	dword [ebp-44]
	push	_344
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_346
	call	_brl_blitz_NullObjectError
_346:
	push	dword [ebp-16]
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,8
	mov	dword [ebp-48],eax
	push	_348
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	cmp	dword [ebp-48],_bbNullObject
	je	_349
	mov	eax,ebp
	push	eax
	push	_361
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_350
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-48]
	mov	dword [ebp-52],eax
	cmp	dword [ebp-52],_bbNullObject
	jne	_352
	call	_brl_blitz_NullObjectError
_352:
	mov	eax,dword [ebp-28]
	mov	dword [ebp-56],eax
	cmp	dword [ebp-56],_bbNullObject
	jne	_354
	call	_brl_blitz_NullObjectError
_354:
	mov	edi,dword [ebp-28]
	cmp	edi,_bbNullObject
	jne	_356
	call	_brl_blitz_NullObjectError
_356:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_358
	call	_brl_blitz_NullObjectError
_358:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_360
	call	_brl_blitz_NullObjectError
_360:
	mov	eax,dword [ebx+12]
	mov	dword [ebp+-60],eax
	fild	dword [ebp+-60]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [esi+8]
	mov	dword [ebp+-60],eax
	fild	dword [ebp+-60]
	sub	esp,4
	fstp	dword [esp]
	push	0
	push	0
	fld	dword [ebp-12]
	fadd	dword [edi+88]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [ebp-8]
	mov	eax,dword [ebp-56]
	fadd	dword [eax+84]
	sub	esp,4
	fstp	dword [esp]
	push	dword [ebp-44]
	push	dword [ebp-36]
	push	dword [ebp-40]
	push	dword [ebp-32]
	push	dword [ebp-52]
	mov	eax,dword [ebp-52]
	mov	eax,dword [eax]
	call	dword [eax+48]
	add	esp,44
	call	dword [_bbOnDebugLeaveScope]
_349:
	mov	ebx,0
	jmp	_82
_82:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_CHARACTER_New:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_378
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	dword [ebp-4]
	call	_bbObjectCtor
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [eax],_bb_CHARACTER
	mov	eax,dword [ebp-4]
	mov	dword [eax+8],_bbNullObject
	mov	eax,dword [ebp-4]
	mov	dword [eax+12],0
	mov	eax,dword [ebp-4]
	mov	dword [eax+16],0
	mov	eax,dword [ebp-4]
	mov	dword [eax+20],0
	push	ebp
	push	_377
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
	mov	ebx,0
	jmp	_85
_85:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_CHARACTER_Create:
	push	ebp
	mov	ebp,esp
	sub	esp,8
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	dword [ebp-8],_bbNullObject
	push	ebp
	push	_386
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_379
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_CHARACTER
	call	_bbObjectNew
	add	esp,4
	mov	dword [ebp-8],eax
	push	_381
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_383
	call	_brl_blitz_NullObjectError
_383:
	mov	eax,dword [ebp-4]
	mov	dword [ebx+8],eax
	push	_385
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	jmp	_88
_88:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_CHARACTER_draw:
	push	ebp
	mov	ebp,esp
	sub	esp,92
	push	ebx
	push	esi
	push	edi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	eax,dword [ebp+12]
	mov	dword [ebp-8],eax
	mov	eax,dword [ebp+16]
	mov	dword [ebp-12],eax
	mov	eax,dword [ebp+20]
	mov	dword [ebp-16],eax
	mov	eax,dword [ebp+24]
	mov	dword [ebp-20],eax
	mov	eax,dword [ebp+28]
	mov	dword [ebp-24],eax
	mov	eax,dword [ebp+32]
	mov	dword [ebp-28],eax
	mov	eax,dword [ebp+36]
	mov	dword [ebp-32],eax
	mov	eax,dword [ebp+40]
	mov	dword [ebp-36],eax
	mov	eax,dword [ebp+44]
	mov	dword [ebp-40],eax
	mov	dword [ebp-44],0
	mov	dword [ebp-48],0
	mov	dword [ebp-52],0
	mov	dword [ebp-56],0
	mov	eax,ebp
	push	eax
	push	_760
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_387
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_389
	call	_brl_blitz_NullObjectError
_389:
	mov	eax,dword [ebp-8]
	cmp	dword [ebx+12],eax
	je	_390
	mov	eax,ebp
	push	eax
	push	_403
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_391
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_393
	call	_brl_blitz_NullObjectError
_393:
	mov	eax,dword [ebp-8]
	mov	dword [ebx+12],eax
	push	_395
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_397
	call	_brl_blitz_NullObjectError
_397:
	mov	dword [ebx+16],0
	push	_399
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_401
	call	_brl_blitz_NullObjectError
_401:
	mov	dword [ebx+20],0
	call	dword [_bbOnDebugLeaveScope]
	jmp	_404
_390:
	mov	eax,ebp
	push	eax
	push	_458
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_405
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_407
	call	_brl_blitz_NullObjectError
_407:
	add	dword [ebx+20],1
	push	_409
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	edi,dword [ebp-4]
	cmp	edi,_bbNullObject
	jne	_411
	call	_brl_blitz_NullObjectError
_411:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_413
	call	_brl_blitz_NullObjectError
_413:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_415
	call	_brl_blitz_NullObjectError
_415:
	mov	ebx,dword [ebx+32]
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_418
	call	_brl_blitz_NullObjectError
_418:
	mov	esi,dword [esi+12]
	cmp	esi,dword [ebx+20]
	jb	_420
	call	_brl_blitz_ArrayBoundsError
_420:
	mov	ebx,dword [ebx+esi*4+24]
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_423
	call	_brl_blitz_NullObjectError
_423:
	mov	esi,dword [esi+16]
	cmp	esi,dword [ebx+20]
	jb	_425
	call	_brl_blitz_ArrayBoundsError
_425:
	mov	eax,dword [ebx+esi*4+24]
	cmp	dword [edi+20],eax
	jl	_426
	mov	eax,ebp
	push	eax
	push	_457
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_427
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_429
	call	_brl_blitz_NullObjectError
_429:
	mov	dword [ebx+20],0
	push	_431
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_433
	call	_brl_blitz_NullObjectError
_433:
	add	dword [ebx+16],1
	push	_435
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	edi,dword [ebp-4]
	cmp	edi,_bbNullObject
	jne	_437
	call	_brl_blitz_NullObjectError
_437:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_439
	call	_brl_blitz_NullObjectError
_439:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_441
	call	_brl_blitz_NullObjectError
_441:
	mov	ebx,dword [ebx+32]
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_444
	call	_brl_blitz_NullObjectError
_444:
	mov	esi,dword [esi+12]
	cmp	esi,dword [ebx+20]
	jb	_446
	call	_brl_blitz_ArrayBoundsError
_446:
	mov	eax,dword [ebx+esi*4+24]
	mov	eax,dword [eax+20]
	cmp	dword [edi+16],eax
	jl	_447
	mov	eax,ebp
	push	eax
	push	_456
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_448
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_450
	call	_brl_blitz_NullObjectError
_450:
	mov	dword [ebx+12],0
	push	_452
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_454
	call	_brl_blitz_NullObjectError
_454:
	mov	dword [ebx+16],0
	call	dword [_bbOnDebugLeaveScope]
_447:
	call	dword [_bbOnDebugLeaveScope]
_426:
	call	dword [_bbOnDebugLeaveScope]
_404:
	push	_459
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	cmp	dword [ebp-12],0
	je	_460
	mov	eax,ebp
	push	eax
	push	_462
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_461
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-32]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-32]
	neg	eax
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_SetScale
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
	jmp	_463
_460:
	mov	eax,ebp
	push	eax
	push	_465
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_464
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-32]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-32]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_SetScale
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
_463:
	push	_466
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	255
	push	255
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	_467
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-16]
	cmp	eax,0
	je	_470
	cmp	eax,1
	je	_471
	cmp	eax,2
	je	_472
	jmp	_469
_470:
	mov	eax,ebp
	push	eax
	push	_486
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_473
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_475
	call	_brl_blitz_NullObjectError
_475:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-60],eax
	cmp	dword [ebp-60],_bbNullObject
	jne	_477
	call	_brl_blitz_NullObjectError
_477:
	mov	edi,dword [ebp-4]
	cmp	edi,_bbNullObject
	jne	_479
	call	_brl_blitz_NullObjectError
_479:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_481
	call	_brl_blitz_NullObjectError
_481:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_483
	call	_brl_blitz_NullObjectError
_483:
	mov	esi,dword [esi+8]
	cmp	esi,_bbNullObject
	jne	_485
	call	_brl_blitz_NullObjectError
_485:
	mov	edx,dword [edi+16]
	mov	eax,dword [ebx+12]
	imul	eax,dword [esi+24]
	add	edx,eax
	push	edx
	mov	eax,dword [ebp-28]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-24]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-60]
	push	dword [eax+20]
	call	_brl_max2d_DrawImage
	add	esp,16
	call	dword [_bbOnDebugLeaveScope]
	jmp	_469
_471:
	mov	eax,ebp
	push	eax
	push	_506
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_487
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_489
	call	_brl_blitz_NullObjectError
_489:
	mov	edi,dword [ebx+8]
	cmp	edi,_bbNullObject
	jne	_491
	call	_brl_blitz_NullObjectError
_491:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_493
	call	_brl_blitz_NullObjectError
_493:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_495
	call	_brl_blitz_NullObjectError
_495:
	mov	ebx,dword [ebx+36]
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_498
	call	_brl_blitz_NullObjectError
_498:
	mov	esi,dword [esi+12]
	cmp	esi,dword [ebx+20]
	jb	_500
	call	_brl_blitz_ArrayBoundsError
_500:
	mov	ebx,dword [ebx+esi*4+24]
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_503
	call	_brl_blitz_NullObjectError
_503:
	mov	esi,dword [esi+16]
	cmp	esi,dword [ebx+20]
	jb	_505
	call	_brl_blitz_ArrayBoundsError
_505:
	push	0
	mov	edx,dword [ebp-28]
	mov	eax,dword [ebp-32]
	imul	eax,dword [ebx+esi*4+24]
	add	edx,eax
	mov	dword [ebp+-92],edx
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-24]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	push	dword [edi+20]
	call	_brl_max2d_DrawImage
	add	esp,16
	call	dword [_bbOnDebugLeaveScope]
	jmp	_469
_472:
	mov	eax,ebp
	push	eax
	push	_598
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_507
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-44],0
	push	_509
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-48],0
	push	_511
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-12]
	cmp	eax,0
	je	_514
	cmp	eax,1
	je	_515
	jmp	_513
_514:
	mov	eax,ebp
	push	eax
	push	_549
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_516
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_518
	call	_brl_blitz_NullObjectError
_518:
	mov	esi,dword [ebx+8]
	cmp	esi,_bbNullObject
	jne	_520
	call	_brl_blitz_NullObjectError
_520:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_522
	call	_brl_blitz_NullObjectError
_522:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_524
	call	_brl_blitz_NullObjectError
_524:
	mov	ecx,dword [esi+40]
	imul	ecx,dword [ebp-32]
	mov	eax,dword [ebx+56]
	imul	eax,dword [ebp-32]
	cdq
	and	edx,1
	add	eax,edx
	sar	eax,1
	sub	ecx,eax
	mov	dword [ebp-44],ecx
	push	_525
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_527
	call	_brl_blitz_NullObjectError
_527:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-76],eax
	cmp	dword [ebp-76],_bbNullObject
	jne	_529
	call	_brl_blitz_NullObjectError
_529:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_531
	call	_brl_blitz_NullObjectError
_531:
	mov	edi,dword [ebx+8]
	cmp	edi,_bbNullObject
	jne	_533
	call	_brl_blitz_NullObjectError
_533:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_535
	call	_brl_blitz_NullObjectError
_535:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_537
	call	_brl_blitz_NullObjectError
_537:
	mov	ebx,dword [ebx+36]
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_540
	call	_brl_blitz_NullObjectError
_540:
	mov	esi,dword [esi+12]
	cmp	esi,dword [ebx+20]
	jb	_542
	call	_brl_blitz_ArrayBoundsError
_542:
	mov	esi,dword [ebx+esi*4+24]
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_545
	call	_brl_blitz_NullObjectError
_545:
	mov	ebx,dword [ebx+16]
	cmp	ebx,dword [esi+20]
	jb	_547
	call	_brl_blitz_ArrayBoundsError
_547:
	mov	eax,dword [ebp-76]
	mov	eax,dword [eax+44]
	imul	eax,dword [ebp-32]
	mov	ecx,eax
	mov	eax,dword [edi+56]
	imul	eax,dword [ebp-32]
	cdq
	and	edx,1
	add	eax,edx
	sar	eax,1
	sub	ecx,eax
	mov	eax,ecx
	mov	edx,dword [ebp-32]
	imul	edx,dword [esi+ebx*4+24]
	add	eax,edx
	mov	dword [ebp-48],eax
	push	_548
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-36]
	sub	eax,dword [ebp-44]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-40]
	sub	eax,dword [ebp-48]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,8
	fstp	qword [esp]
	call	_bbATan2
	add	esp,16
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_SetRotation
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	jmp	_513
_515:
	mov	eax,ebp
	push	eax
	push	_583
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_550
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_552
	call	_brl_blitz_NullObjectError
_552:
	mov	esi,dword [ebx+8]
	cmp	esi,_bbNullObject
	jne	_554
	call	_brl_blitz_NullObjectError
_554:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_556
	call	_brl_blitz_NullObjectError
_556:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_558
	call	_brl_blitz_NullObjectError
_558:
	mov	ecx,dword [esi+40]
	imul	ecx,dword [ebp-32]
	mov	eax,dword [ebx+56]
	imul	eax,dword [ebp-32]
	cdq
	and	edx,1
	add	eax,edx
	sar	eax,1
	sub	ecx,eax
	neg	ecx
	mov	dword [ebp-44],ecx
	push	_559
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_561
	call	_brl_blitz_NullObjectError
_561:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-80],eax
	cmp	dword [ebp-80],_bbNullObject
	jne	_563
	call	_brl_blitz_NullObjectError
_563:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_565
	call	_brl_blitz_NullObjectError
_565:
	mov	edi,dword [ebx+8]
	cmp	edi,_bbNullObject
	jne	_567
	call	_brl_blitz_NullObjectError
_567:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_569
	call	_brl_blitz_NullObjectError
_569:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_571
	call	_brl_blitz_NullObjectError
_571:
	mov	ebx,dword [ebx+36]
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_574
	call	_brl_blitz_NullObjectError
_574:
	mov	esi,dword [esi+12]
	cmp	esi,dword [ebx+20]
	jb	_576
	call	_brl_blitz_ArrayBoundsError
_576:
	mov	esi,dword [ebx+esi*4+24]
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_579
	call	_brl_blitz_NullObjectError
_579:
	mov	ebx,dword [ebx+16]
	cmp	ebx,dword [esi+20]
	jb	_581
	call	_brl_blitz_ArrayBoundsError
_581:
	mov	eax,dword [ebp-80]
	mov	eax,dword [eax+44]
	imul	eax,dword [ebp-32]
	mov	ecx,eax
	mov	eax,dword [edi+56]
	imul	eax,dword [ebp-32]
	cdq
	and	edx,1
	add	eax,edx
	sar	eax,1
	sub	ecx,eax
	mov	eax,ecx
	mov	edx,dword [ebp-32]
	imul	edx,dword [esi+ebx*4+24]
	add	eax,edx
	mov	dword [ebp-48],eax
	push	_582
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-36]
	sub	eax,dword [ebp-44]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-40]
	sub	eax,dword [ebp-48]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,8
	fstp	qword [esp]
	call	_bbATan2
	add	esp,16
	fld	qword [_853]
	faddp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_SetRotation
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	jmp	_513
_513:
	push	_584
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_586
	call	_brl_blitz_NullObjectError
_586:
	mov	edi,dword [ebx+8]
	cmp	edi,_bbNullObject
	jne	_588
	call	_brl_blitz_NullObjectError
_588:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_590
	call	_brl_blitz_NullObjectError
_590:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_592
	call	_brl_blitz_NullObjectError
_592:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_594
	call	_brl_blitz_NullObjectError
_594:
	mov	esi,dword [esi+8]
	cmp	esi,_bbNullObject
	jne	_596
	call	_brl_blitz_NullObjectError
_596:
	push	dword [esi+44]
	push	dword [ebx+40]
	push	1
	mov	eax,dword [ebp-28]
	add	eax,dword [ebp-48]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-24]
	add	eax,dword [ebp-44]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	push	dword [edi+20]
	call	dword [_bb_CHARACTER_IMG+56]
	add	esp,24
	push	_597
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	call	_brl_max2d_SetRotation
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	jmp	_469
_469:
	push	_601
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_603
	call	_brl_blitz_NullObjectError
_603:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-64],eax
	cmp	dword [ebp-64],_bbNullObject
	jne	_605
	call	_brl_blitz_NullObjectError
_605:
	mov	edi,dword [ebp-4]
	cmp	edi,_bbNullObject
	jne	_607
	call	_brl_blitz_NullObjectError
_607:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_609
	call	_brl_blitz_NullObjectError
_609:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_611
	call	_brl_blitz_NullObjectError
_611:
	mov	esi,dword [esi+8]
	cmp	esi,_bbNullObject
	jne	_613
	call	_brl_blitz_NullObjectError
_613:
	mov	edx,dword [edi+16]
	mov	eax,dword [ebx+12]
	imul	eax,dword [esi+24]
	add	edx,eax
	push	edx
	mov	eax,dword [ebp-28]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-24]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-64]
	push	dword [eax+8]
	call	_brl_max2d_DrawImage
	add	esp,16
	push	_614
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_616
	call	_brl_blitz_NullObjectError
_616:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-68],eax
	cmp	dword [ebp-68],_bbNullObject
	jne	_618
	call	_brl_blitz_NullObjectError
_618:
	mov	edi,dword [ebp-4]
	cmp	edi,_bbNullObject
	jne	_620
	call	_brl_blitz_NullObjectError
_620:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_622
	call	_brl_blitz_NullObjectError
_622:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_624
	call	_brl_blitz_NullObjectError
_624:
	mov	esi,dword [esi+8]
	cmp	esi,_bbNullObject
	jne	_626
	call	_brl_blitz_NullObjectError
_626:
	mov	edx,dword [edi+16]
	mov	eax,dword [ebx+12]
	imul	eax,dword [esi+24]
	add	edx,eax
	push	edx
	mov	eax,dword [ebp-28]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-24]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-68]
	push	dword [eax+12]
	call	_brl_max2d_DrawImage
	add	esp,16
	push	_627
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-20]
	cmp	eax,0
	je	_630
	cmp	eax,1
	je	_631
	cmp	eax,2
	je	_632
	jmp	_629
_630:
	mov	eax,ebp
	push	eax
	push	_646
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_633
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_635
	call	_brl_blitz_NullObjectError
_635:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-72],eax
	cmp	dword [ebp-72],_bbNullObject
	jne	_637
	call	_brl_blitz_NullObjectError
_637:
	mov	edi,dword [ebp-4]
	cmp	edi,_bbNullObject
	jne	_639
	call	_brl_blitz_NullObjectError
_639:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_641
	call	_brl_blitz_NullObjectError
_641:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_643
	call	_brl_blitz_NullObjectError
_643:
	mov	esi,dword [esi+8]
	cmp	esi,_bbNullObject
	jne	_645
	call	_brl_blitz_NullObjectError
_645:
	mov	edx,dword [edi+16]
	mov	eax,dword [ebx+12]
	imul	eax,dword [esi+24]
	add	edx,eax
	push	edx
	mov	eax,dword [ebp-28]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-24]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-72]
	push	dword [eax+16]
	call	_brl_max2d_DrawImage
	add	esp,16
	call	dword [_bbOnDebugLeaveScope]
	jmp	_629
_631:
	mov	eax,ebp
	push	eax
	push	_666
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_647
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_649
	call	_brl_blitz_NullObjectError
_649:
	mov	edi,dword [ebx+8]
	cmp	edi,_bbNullObject
	jne	_651
	call	_brl_blitz_NullObjectError
_651:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_653
	call	_brl_blitz_NullObjectError
_653:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_655
	call	_brl_blitz_NullObjectError
_655:
	mov	ebx,dword [ebx+36]
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_658
	call	_brl_blitz_NullObjectError
_658:
	mov	esi,dword [esi+12]
	cmp	esi,dword [ebx+20]
	jb	_660
	call	_brl_blitz_ArrayBoundsError
_660:
	mov	ebx,dword [ebx+esi*4+24]
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_663
	call	_brl_blitz_NullObjectError
_663:
	mov	esi,dword [esi+16]
	cmp	esi,dword [ebx+20]
	jb	_665
	call	_brl_blitz_ArrayBoundsError
_665:
	push	0
	mov	edx,dword [ebp-28]
	mov	eax,dword [ebp-32]
	imul	eax,dword [ebx+esi*4+24]
	add	edx,eax
	mov	dword [ebp+-92],edx
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-24]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	push	dword [edi+16]
	call	_brl_max2d_DrawImage
	add	esp,16
	call	dword [_bbOnDebugLeaveScope]
	jmp	_629
_632:
	mov	eax,ebp
	push	eax
	push	_758
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_667
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-52],0
	push	_669
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-56],0
	push	_671
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-12]
	cmp	eax,0
	je	_674
	cmp	eax,1
	je	_675
	jmp	_673
_674:
	mov	eax,ebp
	push	eax
	push	_709
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_676
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_678
	call	_brl_blitz_NullObjectError
_678:
	mov	esi,dword [ebx+8]
	cmp	esi,_bbNullObject
	jne	_680
	call	_brl_blitz_NullObjectError
_680:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_682
	call	_brl_blitz_NullObjectError
_682:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_684
	call	_brl_blitz_NullObjectError
_684:
	mov	ecx,dword [esi+48]
	imul	ecx,dword [ebp-32]
	mov	eax,dword [ebx+56]
	imul	eax,dword [ebp-32]
	cdq
	and	edx,1
	add	eax,edx
	sar	eax,1
	sub	ecx,eax
	mov	dword [ebp-52],ecx
	push	_685
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_687
	call	_brl_blitz_NullObjectError
_687:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-84],eax
	cmp	dword [ebp-84],_bbNullObject
	jne	_689
	call	_brl_blitz_NullObjectError
_689:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_691
	call	_brl_blitz_NullObjectError
_691:
	mov	edi,dword [ebx+8]
	cmp	edi,_bbNullObject
	jne	_693
	call	_brl_blitz_NullObjectError
_693:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_695
	call	_brl_blitz_NullObjectError
_695:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_697
	call	_brl_blitz_NullObjectError
_697:
	mov	ebx,dword [ebx+36]
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_700
	call	_brl_blitz_NullObjectError
_700:
	mov	esi,dword [esi+12]
	cmp	esi,dword [ebx+20]
	jb	_702
	call	_brl_blitz_ArrayBoundsError
_702:
	mov	esi,dword [ebx+esi*4+24]
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_705
	call	_brl_blitz_NullObjectError
_705:
	mov	ebx,dword [ebx+16]
	cmp	ebx,dword [esi+20]
	jb	_707
	call	_brl_blitz_ArrayBoundsError
_707:
	mov	eax,dword [ebp-84]
	mov	eax,dword [eax+52]
	imul	eax,dword [ebp-32]
	mov	ecx,eax
	mov	eax,dword [edi+56]
	imul	eax,dword [ebp-32]
	cdq
	and	edx,1
	add	eax,edx
	sar	eax,1
	sub	ecx,eax
	mov	eax,ecx
	mov	edx,dword [ebp-32]
	imul	edx,dword [esi+ebx*4+24]
	add	eax,edx
	mov	dword [ebp-56],eax
	push	_708
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-36]
	sub	eax,dword [ebp-52]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-40]
	sub	eax,dword [ebp-56]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,8
	fstp	qword [esp]
	call	_bbATan2
	add	esp,16
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_SetRotation
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	jmp	_673
_675:
	mov	eax,ebp
	push	eax
	push	_743
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_710
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_712
	call	_brl_blitz_NullObjectError
_712:
	mov	esi,dword [ebx+8]
	cmp	esi,_bbNullObject
	jne	_714
	call	_brl_blitz_NullObjectError
_714:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_716
	call	_brl_blitz_NullObjectError
_716:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_718
	call	_brl_blitz_NullObjectError
_718:
	mov	ecx,dword [esi+48]
	imul	ecx,dword [ebp-32]
	mov	eax,dword [ebx+56]
	imul	eax,dword [ebp-32]
	cdq
	and	edx,1
	add	eax,edx
	sar	eax,1
	sub	ecx,eax
	neg	ecx
	mov	dword [ebp-52],ecx
	push	_719
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_721
	call	_brl_blitz_NullObjectError
_721:
	mov	eax,dword [ebx+8]
	mov	dword [ebp-88],eax
	cmp	dword [ebp-88],_bbNullObject
	jne	_723
	call	_brl_blitz_NullObjectError
_723:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_725
	call	_brl_blitz_NullObjectError
_725:
	mov	edi,dword [ebx+8]
	cmp	edi,_bbNullObject
	jne	_727
	call	_brl_blitz_NullObjectError
_727:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_729
	call	_brl_blitz_NullObjectError
_729:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_731
	call	_brl_blitz_NullObjectError
_731:
	mov	ebx,dword [ebx+36]
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_734
	call	_brl_blitz_NullObjectError
_734:
	mov	esi,dword [esi+12]
	cmp	esi,dword [ebx+20]
	jb	_736
	call	_brl_blitz_ArrayBoundsError
_736:
	mov	esi,dword [ebx+esi*4+24]
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_739
	call	_brl_blitz_NullObjectError
_739:
	mov	ebx,dword [ebx+16]
	cmp	ebx,dword [esi+20]
	jb	_741
	call	_brl_blitz_ArrayBoundsError
_741:
	mov	eax,dword [ebp-88]
	mov	eax,dword [eax+52]
	imul	eax,dword [ebp-32]
	mov	ecx,eax
	mov	eax,dword [edi+56]
	imul	eax,dword [ebp-32]
	cdq
	and	edx,1
	add	eax,edx
	sar	eax,1
	sub	ecx,eax
	mov	eax,ecx
	mov	edx,dword [ebp-32]
	imul	edx,dword [esi+ebx*4+24]
	add	eax,edx
	mov	dword [ebp-56],eax
	push	_742
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-36]
	sub	eax,dword [ebp-52]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-40]
	sub	eax,dword [ebp-56]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,8
	fstp	qword [esp]
	call	_bbATan2
	add	esp,16
	fld	qword [_854]
	faddp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_SetRotation
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	jmp	_673
_673:
	push	_744
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_746
	call	_brl_blitz_NullObjectError
_746:
	mov	edi,dword [ebx+8]
	cmp	edi,_bbNullObject
	jne	_748
	call	_brl_blitz_NullObjectError
_748:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_750
	call	_brl_blitz_NullObjectError
_750:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_752
	call	_brl_blitz_NullObjectError
_752:
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_754
	call	_brl_blitz_NullObjectError
_754:
	mov	esi,dword [esi+8]
	cmp	esi,_bbNullObject
	jne	_756
	call	_brl_blitz_NullObjectError
_756:
	push	dword [esi+52]
	push	dword [ebx+48]
	push	1
	mov	eax,dword [ebp-28]
	add	eax,dword [ebp-56]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-24]
	add	eax,dword [ebp-52]
	mov	dword [ebp+-92],eax
	fild	dword [ebp+-92]
	sub	esp,4
	fstp	dword [esp]
	push	dword [edi+16]
	call	dword [_bb_CHARACTER_IMG+56]
	add	esp,24
	push	_757
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	call	_brl_max2d_SetRotation
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	jmp	_629
_629:
	push	_759
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1065353216
	push	1065353216
	call	_brl_max2d_SetScale
	add	esp,8
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
	section	"data" data writeable align 8
	align	4
_156:
	dd	0
_151:
	db	"char_v2",0
_152:
	db	"char_1",0
_153:
	db	":CHARACTER",0
_154:
	db	"char_2",0
_155:
	db	"char_3",0
	align	4
_150:
	dd	1
	dd	_151
	dd	2
	dd	_152
	dd	_153
	dd	-4
	dd	2
	dd	_154
	dd	_153
	dd	-8
	dd	2
	dd	_155
	dd	_153
	dd	-12
	dd	0
_103:
	db	"C:/Users/emanu/OneDrive/BMX-programming/2d voxel engine/character/char_v2.bmx",0
	align	4
_102:
	dd	_103
	dd	5
	dd	2
	align	4
__bb_CHARACTER_IMG_NORMAL:
	dd	_bbNullObject
_31:
	db	"CHARACTER_IMG",0
_32:
	db	"body",0
_33:
	db	":TImage",0
_34:
	db	"head",0
_35:
	db	"arm_front",0
_36:
	db	"arm_back",0
_37:
	db	"frames_per_row",0
_38:
	db	"i",0
_39:
	db	"number_rows",0
_40:
	db	"ticks",0
_41:
	db	"[][]i",0
_42:
	db	"arm_offset",0
_43:
	db	"swing_arm_0_x",0
_44:
	db	"swing_arm_0_y",0
_45:
	db	"swing_arm_1_x",0
_46:
	db	"swing_arm_1_y",0
_47:
	db	"frame_size",0
_48:
	db	"New",0
_49:
	db	"()i",0
_50:
	db	"init",0
_51:
	db	"Load",0
_52:
	db	"($):CHARACTER_IMG",0
_53:
	db	"drawhandle",0
_54:
	db	"(:TImage,f,f,i,i,i)i",0
	align	4
_30:
	dd	2
	dd	_31
	dd	3
	dd	_32
	dd	_33
	dd	8
	dd	3
	dd	_34
	dd	_33
	dd	12
	dd	3
	dd	_35
	dd	_33
	dd	16
	dd	3
	dd	_36
	dd	_33
	dd	20
	dd	3
	dd	_37
	dd	_38
	dd	24
	dd	3
	dd	_39
	dd	_38
	dd	28
	dd	3
	dd	_40
	dd	_41
	dd	32
	dd	3
	dd	_42
	dd	_41
	dd	36
	dd	3
	dd	_43
	dd	_38
	dd	40
	dd	3
	dd	_44
	dd	_38
	dd	44
	dd	3
	dd	_45
	dd	_38
	dd	48
	dd	3
	dd	_46
	dd	_38
	dd	52
	dd	3
	dd	_47
	dd	_38
	dd	56
	dd	6
	dd	_48
	dd	_49
	dd	16
	dd	7
	dd	_50
	dd	_49
	dd	48
	dd	7
	dd	_51
	dd	_52
	dd	52
	dd	7
	dd	_53
	dd	_54
	dd	56
	dd	0
	align	4
_bb_CHARACTER_IMG:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_30
	dd	60
	dd	__bb_CHARACTER_IMG_New
	dd	_bbObjectDtor
	dd	_bbObjectToString
	dd	_bbObjectCompare
	dd	_bbObjectSendMessage
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	__bb_CHARACTER_IMG_init
	dd	__bb_CHARACTER_IMG_Load
	dd	__bb_CHARACTER_IMG_drawhandle
_56:
	db	"CHARACTER",0
_57:
	db	"char_img",0
_58:
	db	":CHARACTER_IMG",0
_59:
	db	"state",0
_60:
	db	"frame",0
_61:
	db	"tick",0
_62:
	db	"Create",0
_63:
	db	"(:CHARACTER_IMG):CHARACTER",0
_64:
	db	"draw",0
_65:
	db	"(i,i,i,i,i,i,i,i,i)i",0
	align	4
_55:
	dd	2
	dd	_56
	dd	3
	dd	_57
	dd	_58
	dd	8
	dd	3
	dd	_59
	dd	_38
	dd	12
	dd	3
	dd	_60
	dd	_38
	dd	16
	dd	3
	dd	_61
	dd	_38
	dd	20
	dd	6
	dd	_48
	dd	_49
	dd	16
	dd	7
	dd	_62
	dd	_63
	dd	48
	dd	6
	dd	_64
	dd	_65
	dd	52
	dd	0
	align	4
_bb_CHARACTER:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_55
	dd	24
	dd	__bb_CHARACTER_New
	dd	_bbObjectDtor
	dd	_bbObjectToString
	dd	_bbObjectCompare
	dd	_bbObjectSendMessage
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	__bb_CHARACTER_Create
	dd	__bb_CHARACTER_draw
	align	4
_104:
	dd	_103
	dd	193
	dd	1
	align	4
_105:
	dd	_103
	dd	194
	dd	1
	align	4
_106:
	dd	_103
	dd	196
	dd	1
	align	4
_108:
	dd	_103
	dd	197
	dd	1
	align	4
_110:
	dd	_103
	dd	198
	dd	1
	align	4
_112:
	dd	_103
	dd	223
	dd	1
	align	4
_149:
	dd	3
	dd	0
	dd	0
	align	4
_113:
	dd	_103
	dd	201
	dd	2
	align	4
_114:
	dd	_103
	dd	202
	dd	2
	align	4
_115:
	dd	_103
	dd	204
	dd	2
	align	4
_120:
	dd	3
	dd	0
	dd	0
	align	4
_117:
	dd	_103
	dd	205
	dd	3
	align	4
_125:
	dd	3
	dd	0
	dd	0
	align	4
_122:
	dd	_103
	dd	207
	dd	3
	align	4
_126:
	dd	_103
	dd	210
	dd	2
	align	4
_131:
	dd	3
	dd	0
	dd	0
	align	4
_128:
	dd	_103
	dd	211
	dd	3
	align	4
_136:
	dd	3
	dd	0
	dd	0
	align	4
_133:
	dd	_103
	dd	213
	dd	3
	align	4
_137:
	dd	_103
	dd	216
	dd	2
	align	4
_142:
	dd	3
	dd	0
	dd	0
	align	4
_139:
	dd	_103
	dd	217
	dd	3
	align	4
_147:
	dd	3
	dd	0
	dd	0
	align	4
_144:
	dd	_103
	dd	219
	dd	3
	align	4
_148:
	dd	_103
	dd	222
	dd	2
_160:
	db	"Self",0
	align	4
_159:
	dd	1
	dd	_48
	dd	2
	dd	_160
	dd	_58
	dd	-4
	dd	0
	align	4
_158:
	dd	3
	dd	0
	dd	0
	align	4
_162:
	dd	1
	dd	_50
	dd	0
	align	4
_161:
	dd	_103
	dd	8
	dd	3
	align	4
_22:
	dd	_bbStringClass
	dd	2147483647
	dd	6
	dw	110,111,114,109,97,108
_329:
	db	"path",0
_330:
	db	"$",0
_331:
	db	"c",0
	align	4
_328:
	dd	1
	dd	_51
	dd	2
	dd	_329
	dd	_330
	dd	-4
	dd	2
	dd	_331
	dd	_58
	dd	-8
	dd	0
	align	4
_163:
	dd	_103
	dd	38
	dd	3
	align	4
_165:
	dd	_103
	dd	40
	dd	3
_169:
	db	"[]i",0
	align	4
_170:
	dd	_103
	dd	41
	dd	3
_174:
	db	"[]i",0
	align	4
_175:
	dd	_103
	dd	42
	dd	3
	align	4
_179:
	dd	_103
	dd	43
	dd	3
	align	4
_183:
	dd	_103
	dd	45
	dd	3
	align	4
_187:
	dd	_103
	dd	47
	dd	3
	align	4
_23:
	dd	_bbStringClass
	dd	2147483647
	dd	9
	dw	92,98,111,100,121,46,112,110,103
	align	4
_199:
	dd	_103
	dd	48
	dd	3
	align	4
_24:
	dd	_bbStringClass
	dd	2147483647
	dd	9
	dw	92,104,101,97,100,46,112,110,103
	align	4
_211:
	dd	_103
	dd	49
	dd	3
	align	4
_25:
	dd	_bbStringClass
	dd	2147483647
	dd	14
	dw	92,97,114,109,95,102,114,111,110,116,46,112,110,103
	align	4
_223:
	dd	_103
	dd	50
	dd	3
	align	4
_26:
	dd	_bbStringClass
	dd	2147483647
	dd	13
	dw	92,97,114,109,95,98,97,99,107,46,112,110,103
	align	4
_235:
	dd	_103
	dd	52
	dd	3
	align	4
_238:
	dd	_103
	dd	53
	dd	3
	align	4
_241:
	dd	_103
	dd	54
	dd	3
	align	4
_244:
	dd	_103
	dd	55
	dd	3
	align	4
_247:
	dd	_103
	dd	57
	dd	3
	align	4
_255:
	dd	_103
	dd	58
	dd	3
	align	4
_263:
	dd	_103
	dd	59
	dd	3
	align	4
_271:
	dd	_103
	dd	60
	dd	3
	align	4
_279:
	dd	_103
	dd	62
	dd	3
	align	4
_287:
	dd	_103
	dd	63
	dd	3
	align	4
_295:
	dd	_103
	dd	64
	dd	3
	align	4
_303:
	dd	_103
	dd	65
	dd	3
	align	4
_311:
	dd	_103
	dd	67
	dd	3
	align	4
_315:
	dd	_103
	dd	68
	dd	3
	align	4
_319:
	dd	_103
	dd	70
	dd	3
	align	4
_323:
	dd	_103
	dd	71
	dd	3
	align	4
_327:
	dd	_103
	dd	73
	dd	3
_363:
	db	"image",0
_364:
	db	"x",0
_365:
	db	"f",0
_366:
	db	"y",0
_367:
	db	"hanlde_x",0
_368:
	db	"handle_y",0
_369:
	db	"gc",0
_370:
	db	":TMax2DGraphics",0
_371:
	db	"x0",0
_372:
	db	"x1",0
_373:
	db	"y0",0
_374:
	db	"y1",0
_375:
	db	"iframe",0
_376:
	db	":TImageFrame",0
	align	4
_362:
	dd	1
	dd	_53
	dd	2
	dd	_363
	dd	_33
	dd	-4
	dd	2
	dd	_364
	dd	_365
	dd	-8
	dd	2
	dd	_366
	dd	_365
	dd	-12
	dd	2
	dd	_60
	dd	_38
	dd	-16
	dd	2
	dd	_367
	dd	_38
	dd	-20
	dd	2
	dd	_368
	dd	_38
	dd	-24
	dd	2
	dd	_369
	dd	_370
	dd	-28
	dd	2
	dd	_371
	dd	_365
	dd	-32
	dd	2
	dd	_372
	dd	_365
	dd	-36
	dd	2
	dd	_373
	dd	_365
	dd	-40
	dd	2
	dd	_374
	dd	_365
	dd	-44
	dd	2
	dd	_375
	dd	_376
	dd	-48
	dd	0
	align	4
_332:
	dd	_103
	dd	78
	dd	3
	align	4
_334:
	dd	_103
	dd	81
	dd	3
	align	4
_339:
	dd	_103
	dd	82
	dd	3
	align	4
_344:
	dd	_103
	dd	83
	dd	3
	align	4
_348:
	dd	_103
	dd	84
	dd	3
	align	4
_361:
	dd	3
	dd	0
	dd	0
	align	4
_350:
	dd	_103
	dd	84
	dd	13
	align	4
_378:
	dd	1
	dd	_48
	dd	2
	dd	_160
	dd	_153
	dd	-4
	dd	0
	align	4
_377:
	dd	3
	dd	0
	dd	0
	align	4
_386:
	dd	1
	dd	_62
	dd	2
	dd	_57
	dd	_58
	dd	-4
	dd	2
	dd	_331
	dd	_153
	dd	-8
	dd	0
	align	4
_379:
	dd	_103
	dd	97
	dd	3
	align	4
_381:
	dd	_103
	dd	99
	dd	3
	align	4
_385:
	dd	_103
	dd	101
	dd	3
_761:
	db	"new_state",0
_762:
	db	"direction",0
_763:
	db	"arm_0",0
_764:
	db	"arm_1",0
_765:
	db	"scale",0
_766:
	db	"aim_dx",0
_767:
	db	"aim_dy",0
	align	4
_760:
	dd	1
	dd	_64
	dd	2
	dd	_160
	dd	_153
	dd	-4
	dd	2
	dd	_761
	dd	_38
	dd	-8
	dd	2
	dd	_762
	dd	_38
	dd	-12
	dd	2
	dd	_763
	dd	_38
	dd	-16
	dd	2
	dd	_764
	dd	_38
	dd	-20
	dd	2
	dd	_364
	dd	_38
	dd	-24
	dd	2
	dd	_366
	dd	_38
	dd	-28
	dd	2
	dd	_765
	dd	_38
	dd	-32
	dd	2
	dd	_766
	dd	_38
	dd	-36
	dd	2
	dd	_767
	dd	_38
	dd	-40
	dd	0
	align	4
_387:
	dd	_103
	dd	108
	dd	3
	align	4
_403:
	dd	3
	dd	0
	dd	0
	align	4
_391:
	dd	_103
	dd	110
	dd	4
	align	4
_395:
	dd	_103
	dd	111
	dd	4
	align	4
_399:
	dd	_103
	dd	112
	dd	4
	align	4
_458:
	dd	3
	dd	0
	dd	0
	align	4
_405:
	dd	_103
	dd	114
	dd	4
	align	4
_409:
	dd	_103
	dd	115
	dd	4
	align	4
_457:
	dd	3
	dd	0
	dd	0
	align	4
_427:
	dd	_103
	dd	116
	dd	5
	align	4
_431:
	dd	_103
	dd	117
	dd	5
	align	4
_435:
	dd	_103
	dd	118
	dd	5
	align	4
_456:
	dd	3
	dd	0
	dd	0
	align	4
_448:
	dd	_103
	dd	119
	dd	6
	align	4
_452:
	dd	_103
	dd	120
	dd	6
	align	4
_459:
	dd	_103
	dd	125
	dd	3
	align	4
_462:
	dd	3
	dd	0
	dd	0
	align	4
_461:
	dd	_103
	dd	126
	dd	4
	align	4
_465:
	dd	3
	dd	0
	dd	0
	align	4
_464:
	dd	_103
	dd	128
	dd	4
	align	4
_466:
	dd	_103
	dd	130
	dd	3
	align	4
_467:
	dd	_103
	dd	132
	dd	3
	align	4
_486:
	dd	3
	dd	0
	dd	0
	align	4
_473:
	dd	_103
	dd	134
	dd	5
	align	4
_506:
	dd	3
	dd	0
	dd	0
	align	4
_487:
	dd	_103
	dd	136
	dd	5
_599:
	db	"xx",0
_600:
	db	"yy",0
	align	4
_598:
	dd	3
	dd	0
	dd	2
	dd	_599
	dd	_38
	dd	-44
	dd	2
	dd	_600
	dd	_38
	dd	-48
	dd	0
	align	4
_507:
	dd	_103
	dd	138
	dd	5
	align	4
_509:
	dd	_103
	dd	139
	dd	5
	align	4
_511:
	dd	_103
	dd	140
	dd	5
	align	4
_549:
	dd	3
	dd	0
	dd	0
	align	4
_516:
	dd	_103
	dd	142
	dd	7
	align	4
_525:
	dd	_103
	dd	143
	dd	7
	align	4
_548:
	dd	_103
	dd	145
	dd	7
	align	4
_583:
	dd	3
	dd	0
	dd	0
	align	4
_550:
	dd	_103
	dd	147
	dd	7
	align	4
_559:
	dd	_103
	dd	148
	dd	7
	align	4
_582:
	dd	_103
	dd	150
	dd	7
	align	8
_853:
	dd	0x0,0x40668000
	align	4
_584:
	dd	_103
	dd	153
	dd	5
	align	4
_597:
	dd	_103
	dd	157
	dd	5
	align	4
_601:
	dd	_103
	dd	160
	dd	3
	align	4
_614:
	dd	_103
	dd	161
	dd	3
	align	4
_627:
	dd	_103
	dd	163
	dd	3
	align	4
_646:
	dd	3
	dd	0
	dd	0
	align	4
_633:
	dd	_103
	dd	165
	dd	5
	align	4
_666:
	dd	3
	dd	0
	dd	0
	align	4
_647:
	dd	_103
	dd	167
	dd	5
	align	4
_758:
	dd	3
	dd	0
	dd	2
	dd	_599
	dd	_38
	dd	-52
	dd	2
	dd	_600
	dd	_38
	dd	-56
	dd	0
	align	4
_667:
	dd	_103
	dd	169
	dd	5
	align	4
_669:
	dd	_103
	dd	170
	dd	5
	align	4
_671:
	dd	_103
	dd	171
	dd	5
	align	4
_709:
	dd	3
	dd	0
	dd	0
	align	4
_676:
	dd	_103
	dd	173
	dd	7
	align	4
_685:
	dd	_103
	dd	174
	dd	7
	align	4
_708:
	dd	_103
	dd	176
	dd	7
	align	4
_743:
	dd	3
	dd	0
	dd	0
	align	4
_710:
	dd	_103
	dd	178
	dd	7
	align	4
_719:
	dd	_103
	dd	179
	dd	7
	align	4
_742:
	dd	_103
	dd	181
	dd	7
	align	8
_854:
	dd	0x0,0x40668000
	align	4
_744:
	dd	_103
	dd	184
	dd	5
	align	4
_757:
	dd	_103
	dd	185
	dd	5
	align	4
_759:
	dd	_103
	dd	188
	dd	3
