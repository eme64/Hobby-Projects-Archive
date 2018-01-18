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
	extrn	_brl_max2d_SetScale
	extrn	_brl_polledinput_KeyDown
	extrn	_brl_polledinput_KeyHit
	public	__bb_CHARACTER_Create
	public	__bb_CHARACTER_IMG_Load
	public	__bb_CHARACTER_IMG_NORMAL
	public	__bb_CHARACTER_IMG_New
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
	sub	esp,4
	push	ebx
	push	esi
	cmp	dword [_100],0
	je	_101
	mov	eax,0
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_101:
	mov	dword [_100],1
	mov	dword [ebp-4],_bbNullObject
	mov	eax,ebp
	push	eax
	push	_96
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
	push	_74
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_CHARACTER_IMG
	call	_bbObjectRegisterType
	add	esp,4
	push	_bb_CHARACTER
	call	_bbObjectRegisterType
	add	esp,4
	push	_76
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	60
	push	0
	push	600
	push	800
	call	_brl_graphics_Graphics
	add	esp,20
	push	_77
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bb_CHARACTER_IMG+48]
	push	_78
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	dword [__bb_CHARACTER_IMG_NORMAL]
	call	dword [_bb_CHARACTER+48]
	add	esp,4
	mov	dword [ebp-4],eax
	push	_80
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
_27:
	mov	eax,ebp
	push	eax
	push	_95
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_81
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
	push	_82
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	_brl_max2d_Cls
	push	_83
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	68
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_84
	mov	eax,ebp
	push	eax
	push	_88
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_85
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_87
	call	_brl_blitz_NullObjectError
_87:
	push	3
	push	200
	push	200
	push	1
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,20
	call	dword [_bbOnDebugLeaveScope]
	jmp	_89
_84:
	mov	eax,ebp
	push	eax
	push	_93
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_90
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_92
	call	_brl_blitz_NullObjectError
_92:
	push	3
	push	200
	push	200
	push	0
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,20
	call	dword [_bbOnDebugLeaveScope]
_89:
	push	_94
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	-1
	call	_brl_graphics_Flip
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
_25:
	push	27
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_27
_26:
	mov	ebx,0
	jmp	_51
_51:
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
	push	_103
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	dword [ebp-4]
	call	_bbObjectCtor
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [eax],_bb_CHARACTER_IMG
	mov	eax,dword [ebp-4]
	mov	dword [eax+8],_bbEmptyArray
	mov	eax,dword [ebp-4]
	mov	dword [eax+12],_bbEmptyArray
	push	ebp
	push	_102
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
	mov	ebx,0
	jmp	_54
_54:
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
	push	_106
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_105
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_22
	call	dword [_bb_CHARACTER_IMG+52]
	add	esp,4
	mov	dword [__bb_CHARACTER_IMG_NORMAL],eax
	mov	ebx,0
	jmp	_56
_56:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_CHARACTER_IMG_Load:
	push	ebp
	mov	ebp,esp
	sub	esp,8
	push	ebx
	push	esi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	dword [ebp-8],_bbNullObject
	mov	eax,ebp
	push	eax
	push	_150
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_107
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_CHARACTER_IMG
	call	_bbObjectNew
	add	esp,4
	mov	dword [ebp-8],eax
	push	_109
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_111
	call	_brl_blitz_NullObjectError
_111:
	push	2
	push	_113
	call	_bbArrayNew1D
	add	esp,8
	mov	dword [ebx+8],eax
	push	_114
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_116
	call	_brl_blitz_NullObjectError
_116:
	push	2
	push	_118
	call	_bbArrayNew1D
	add	esp,8
	mov	dword [ebx+12],eax
	push	_119
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_121
	call	_brl_blitz_NullObjectError
_121:
	mov	ebx,dword [ebx+8]
	mov	esi,0
	cmp	esi,dword [ebx+20]
	jb	_124
	call	_brl_blitz_ArrayBoundsError
_124:
	shl	esi,2
	add	ebx,esi
	push	0
	push	1
	push	0
	push	32
	push	16
	push	_23
	push	dword [ebp-4]
	call	_bbStringConcat
	add	esp,8
	push	eax
	call	_brl_max2d_LoadAnimImage
	add	esp,24
	mov	dword [ebx+24],eax
	push	_126
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_128
	call	_brl_blitz_NullObjectError
_128:
	mov	ebx,dword [ebx+12]
	mov	esi,0
	cmp	esi,dword [ebx+20]
	jb	_131
	call	_brl_blitz_ArrayBoundsError
_131:
	shl	esi,2
	add	ebx,esi
	push	1
	push	_44
	call	_bbArrayNew1D
	add	esp,8
	mov	dword [eax+24],1
	mov	dword [ebx+24],eax
	push	_134
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_136
	call	_brl_blitz_NullObjectError
_136:
	mov	ebx,dword [ebx+8]
	mov	esi,1
	cmp	esi,dword [ebx+20]
	jb	_139
	call	_brl_blitz_ArrayBoundsError
_139:
	shl	esi,2
	add	ebx,esi
	push	0
	push	4
	push	0
	push	32
	push	16
	push	_24
	push	dword [ebp-4]
	call	_bbStringConcat
	add	esp,8
	push	eax
	call	_brl_max2d_LoadAnimImage
	add	esp,24
	mov	dword [ebx+24],eax
	push	_141
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_143
	call	_brl_blitz_NullObjectError
_143:
	mov	ebx,dword [ebx+12]
	mov	esi,1
	cmp	esi,dword [ebx+20]
	jb	_146
	call	_brl_blitz_ArrayBoundsError
_146:
	shl	esi,2
	add	ebx,esi
	push	4
	push	_44
	call	_bbArrayNew1D
	add	esp,8
	mov	dword [eax+24],8
	mov	dword [eax+28],8
	mov	dword [eax+32],8
	mov	dword [eax+36],8
	mov	dword [ebx+24],eax
	push	_149
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	jmp	_59
_59:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
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
	push	_155
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
	push	_154
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
	mov	ebx,0
	jmp	_62
_62:
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
	push	_163
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_156
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_CHARACTER
	call	_bbObjectNew
	add	esp,4
	mov	dword [ebp-8],eax
	push	_158
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	cmp	ebx,_bbNullObject
	jne	_160
	call	_brl_blitz_NullObjectError
_160:
	mov	eax,dword [ebp-4]
	mov	dword [ebx+8],eax
	push	_162
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-8]
	jmp	_65
_65:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_CHARACTER_draw:
	push	ebp
	mov	ebp,esp
	sub	esp,24
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
	mov	eax,ebp
	push	eax
	push	_251
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_164
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_166
	call	_brl_blitz_NullObjectError
_166:
	mov	eax,dword [ebp-8]
	cmp	dword [ebx+12],eax
	je	_167
	mov	eax,ebp
	push	eax
	push	_180
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_168
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_170
	call	_brl_blitz_NullObjectError
_170:
	mov	eax,dword [ebp-8]
	mov	dword [ebx+12],eax
	push	_172
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_174
	call	_brl_blitz_NullObjectError
_174:
	mov	dword [ebx+16],0
	push	_176
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_178
	call	_brl_blitz_NullObjectError
_178:
	mov	dword [ebx+20],0
	call	dword [_bbOnDebugLeaveScope]
	jmp	_181
_167:
	mov	eax,ebp
	push	eax
	push	_235
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_182
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_184
	call	_brl_blitz_NullObjectError
_184:
	add	dword [ebx+20],1
	push	_186
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	edi,dword [ebp-4]
	cmp	edi,_bbNullObject
	jne	_188
	call	_brl_blitz_NullObjectError
_188:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_190
	call	_brl_blitz_NullObjectError
_190:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_192
	call	_brl_blitz_NullObjectError
_192:
	mov	ebx,dword [ebx+12]
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_195
	call	_brl_blitz_NullObjectError
_195:
	mov	esi,dword [esi+12]
	cmp	esi,dword [ebx+20]
	jb	_197
	call	_brl_blitz_ArrayBoundsError
_197:
	mov	ebx,dword [ebx+esi*4+24]
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_200
	call	_brl_blitz_NullObjectError
_200:
	mov	esi,dword [esi+16]
	cmp	esi,dword [ebx+20]
	jb	_202
	call	_brl_blitz_ArrayBoundsError
_202:
	mov	eax,dword [ebx+esi*4+24]
	cmp	dword [edi+20],eax
	jl	_203
	mov	eax,ebp
	push	eax
	push	_234
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_204
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_206
	call	_brl_blitz_NullObjectError
_206:
	mov	dword [ebx+20],0
	push	_208
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_210
	call	_brl_blitz_NullObjectError
_210:
	add	dword [ebx+16],1
	push	_212
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	edi,dword [ebp-4]
	cmp	edi,_bbNullObject
	jne	_214
	call	_brl_blitz_NullObjectError
_214:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_216
	call	_brl_blitz_NullObjectError
_216:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_218
	call	_brl_blitz_NullObjectError
_218:
	mov	ebx,dword [ebx+12]
	mov	esi,dword [ebp-4]
	cmp	esi,_bbNullObject
	jne	_221
	call	_brl_blitz_NullObjectError
_221:
	mov	esi,dword [esi+12]
	cmp	esi,dword [ebx+20]
	jb	_223
	call	_brl_blitz_ArrayBoundsError
_223:
	mov	eax,dword [ebx+esi*4+24]
	mov	eax,dword [eax+20]
	cmp	dword [edi+16],eax
	jl	_224
	mov	eax,ebp
	push	eax
	push	_233
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_225
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_227
	call	_brl_blitz_NullObjectError
_227:
	mov	dword [ebx+12],0
	push	_229
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_231
	call	_brl_blitz_NullObjectError
_231:
	mov	dword [ebx+16],0
	call	dword [_bbOnDebugLeaveScope]
_224:
	call	dword [_bbOnDebugLeaveScope]
_203:
	call	dword [_bbOnDebugLeaveScope]
_181:
	push	_236
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-20]
	mov	dword [ebp+-24],eax
	fild	dword [ebp+-24]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-20]
	mov	dword [ebp+-24],eax
	fild	dword [ebp+-24]
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_SetScale
	add	esp,8
	push	_237
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	255
	push	255
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	_238
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_240
	call	_brl_blitz_NullObjectError
_240:
	mov	ebx,dword [ebx+8]
	cmp	ebx,_bbNullObject
	jne	_242
	call	_brl_blitz_NullObjectError
_242:
	mov	edi,dword [ebx+8]
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_245
	call	_brl_blitz_NullObjectError
_245:
	mov	esi,dword [ebx+12]
	cmp	esi,dword [edi+20]
	jb	_247
	call	_brl_blitz_ArrayBoundsError
_247:
	mov	ebx,dword [ebp-4]
	cmp	ebx,_bbNullObject
	jne	_249
	call	_brl_blitz_NullObjectError
_249:
	push	dword [ebx+16]
	mov	eax,dword [ebp-16]
	mov	dword [ebp+-24],eax
	fild	dword [ebp+-24]
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-12]
	mov	dword [ebp+-24],eax
	fild	dword [ebp+-24]
	sub	esp,4
	fstp	dword [esp]
	push	dword [edi+esi*4+24]
	call	_brl_max2d_DrawImage
	add	esp,16
	push	_250
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1065353216
	push	1065353216
	call	_brl_max2d_SetScale
	add	esp,8
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
	section	"data" data writeable align 8
	align	4
_100:
	dd	0
_97:
	db	"char_v1",0
_98:
	db	"char",0
_99:
	db	":CHARACTER",0
	align	4
_96:
	dd	1
	dd	_97
	dd	2
	dd	_98
	dd	_99
	dd	-4
	dd	0
_75:
	db	"C:/Users/emanu/OneDrive/BMX-programming/2d voxel engine/character/char_v1.bmx",0
	align	4
_74:
	dd	_75
	dd	5
	dd	2
	align	4
__bb_CHARACTER_IMG_NORMAL:
	dd	_bbNullObject
_29:
	db	"CHARACTER_IMG",0
_30:
	db	"body",0
_31:
	db	"[]:TImage",0
_32:
	db	"body_ticks",0
_33:
	db	"[][]i",0
_34:
	db	"New",0
_35:
	db	"()i",0
_36:
	db	"init",0
_37:
	db	"Load",0
_38:
	db	"($):CHARACTER_IMG",0
	align	4
_28:
	dd	2
	dd	_29
	dd	3
	dd	_30
	dd	_31
	dd	8
	dd	3
	dd	_32
	dd	_33
	dd	12
	dd	6
	dd	_34
	dd	_35
	dd	16
	dd	7
	dd	_36
	dd	_35
	dd	48
	dd	7
	dd	_37
	dd	_38
	dd	52
	dd	0
	align	4
_bb_CHARACTER_IMG:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_28
	dd	16
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
_40:
	db	"CHARACTER",0
_41:
	db	"char_img",0
_42:
	db	":CHARACTER_IMG",0
_43:
	db	"state",0
_44:
	db	"i",0
_45:
	db	"frame",0
_46:
	db	"tick",0
_47:
	db	"Create",0
_48:
	db	"(:CHARACTER_IMG):CHARACTER",0
_49:
	db	"draw",0
_50:
	db	"(i,i,i,i)i",0
	align	4
_39:
	dd	2
	dd	_40
	dd	3
	dd	_41
	dd	_42
	dd	8
	dd	3
	dd	_43
	dd	_44
	dd	12
	dd	3
	dd	_45
	dd	_44
	dd	16
	dd	3
	dd	_46
	dd	_44
	dd	20
	dd	6
	dd	_34
	dd	_35
	dd	16
	dd	7
	dd	_47
	dd	_48
	dd	48
	dd	6
	dd	_49
	dd	_50
	dd	52
	dd	0
	align	4
_bb_CHARACTER:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_39
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
_76:
	dd	_75
	dd	81
	dd	1
	align	4
_77:
	dd	_75
	dd	82
	dd	1
	align	4
_78:
	dd	_75
	dd	84
	dd	1
	align	4
_80:
	dd	_75
	dd	97
	dd	1
	align	4
_95:
	dd	3
	dd	0
	dd	0
	align	4
_81:
	dd	_75
	dd	87
	dd	2
	align	4
_82:
	dd	_75
	dd	88
	dd	2
	align	4
_83:
	dd	_75
	dd	90
	dd	2
	align	4
_88:
	dd	3
	dd	0
	dd	0
	align	4
_85:
	dd	_75
	dd	91
	dd	3
	align	4
_93:
	dd	3
	dd	0
	dd	0
	align	4
_90:
	dd	_75
	dd	93
	dd	3
	align	4
_94:
	dd	_75
	dd	96
	dd	2
_104:
	db	"Self",0
	align	4
_103:
	dd	1
	dd	_34
	dd	2
	dd	_104
	dd	_42
	dd	-4
	dd	0
	align	4
_102:
	dd	3
	dd	0
	dd	0
	align	4
_106:
	dd	1
	dd	_36
	dd	0
	align	4
_105:
	dd	_75
	dd	8
	dd	3
	align	4
_22:
	dd	_bbStringClass
	dd	2147483647
	dd	6
	dw	110,111,114,109,97,108
_151:
	db	"path",0
_152:
	db	"$",0
_153:
	db	"c",0
	align	4
_150:
	dd	1
	dd	_37
	dd	2
	dd	_151
	dd	_152
	dd	-4
	dd	2
	dd	_153
	dd	_42
	dd	-8
	dd	0
	align	4
_107:
	dd	_75
	dd	21
	dd	3
	align	4
_109:
	dd	_75
	dd	23
	dd	3
_113:
	db	":TImage",0
	align	4
_114:
	dd	_75
	dd	24
	dd	3
_118:
	db	"[]i",0
	align	4
_119:
	dd	_75
	dd	26
	dd	3
	align	4
_23:
	dd	_bbStringClass
	dd	2147483647
	dd	10
	dw	92,115,116,97,110,100,46,112,110,103
	align	4
_126:
	dd	_75
	dd	27
	dd	3
	align	4
_134:
	dd	_75
	dd	29
	dd	3
	align	4
_24:
	dd	_bbStringClass
	dd	2147483647
	dd	8
	dw	92,114,117,110,46,112,110,103
	align	4
_141:
	dd	_75
	dd	30
	dd	3
	align	4
_149:
	dd	_75
	dd	32
	dd	3
	align	4
_155:
	dd	1
	dd	_34
	dd	2
	dd	_104
	dd	_99
	dd	-4
	dd	0
	align	4
_154:
	dd	3
	dd	0
	dd	0
	align	4
_163:
	dd	1
	dd	_47
	dd	2
	dd	_41
	dd	_42
	dd	-4
	dd	2
	dd	_153
	dd	_99
	dd	-8
	dd	0
	align	4
_156:
	dd	_75
	dd	46
	dd	3
	align	4
_158:
	dd	_75
	dd	48
	dd	3
	align	4
_162:
	dd	_75
	dd	50
	dd	3
_252:
	db	"new_state",0
_253:
	db	"x",0
_254:
	db	"y",0
_255:
	db	"scale",0
	align	4
_251:
	dd	1
	dd	_49
	dd	2
	dd	_104
	dd	_99
	dd	-4
	dd	2
	dd	_252
	dd	_44
	dd	-8
	dd	2
	dd	_253
	dd	_44
	dd	-12
	dd	2
	dd	_254
	dd	_44
	dd	-16
	dd	2
	dd	_255
	dd	_44
	dd	-20
	dd	0
	align	4
_164:
	dd	_75
	dd	54
	dd	3
	align	4
_180:
	dd	3
	dd	0
	dd	0
	align	4
_168:
	dd	_75
	dd	56
	dd	4
	align	4
_172:
	dd	_75
	dd	57
	dd	4
	align	4
_176:
	dd	_75
	dd	58
	dd	4
	align	4
_235:
	dd	3
	dd	0
	dd	0
	align	4
_182:
	dd	_75
	dd	60
	dd	4
	align	4
_186:
	dd	_75
	dd	61
	dd	4
	align	4
_234:
	dd	3
	dd	0
	dd	0
	align	4
_204:
	dd	_75
	dd	62
	dd	5
	align	4
_208:
	dd	_75
	dd	63
	dd	5
	align	4
_212:
	dd	_75
	dd	64
	dd	5
	align	4
_233:
	dd	3
	dd	0
	dd	0
	align	4
_225:
	dd	_75
	dd	65
	dd	6
	align	4
_229:
	dd	_75
	dd	66
	dd	6
	align	4
_236:
	dd	_75
	dd	71
	dd	3
	align	4
_237:
	dd	_75
	dd	72
	dd	3
	align	4
_238:
	dd	_75
	dd	74
	dd	3
	align	4
_250:
	dd	_75
	dd	76
	dd	3
