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
	extrn	_bbAppTitle
	extrn	_bbArrayNew
	extrn	_bbEmptyArray
	extrn	_bbEnd
	extrn	_bbFloatPow
	extrn	_bbFloatToInt
	extrn	_bbGCFree
	extrn	_bbObjectClass
	extrn	_bbObjectCompare
	extrn	_bbObjectCtor
	extrn	_bbObjectFree
	extrn	_bbObjectRegisterType
	extrn	_bbObjectReserved
	extrn	_bbObjectSendMessage
	extrn	_bbObjectToString
	extrn	_bbStringClass
	extrn	_bbStringFromInt
	extrn	_brl_graphics_Flip
	extrn	_brl_graphics_Graphics
	extrn	_brl_max2d_Cls
	extrn	_brl_max2d_DrawRect
	extrn	_brl_max2d_DrawText
	extrn	_brl_max2d_SetBlend
	extrn	_brl_max2d_SetClsColor
	extrn	_brl_max2d_SetColor
	extrn	_brl_max2d_SetViewport
	extrn	_brl_polledinput_KeyDown
	extrn	_brl_polledinput_KeyHit
	extrn	_brl_random_Rand
	public	__bb_ANZEIGE_Delete
	public	__bb_ANZEIGE_New
	public	__bb_ANZEIGE_ini
	public	__bb_ANZEIGE_x
	public	__bb_ANZEIGE_y
	public	__bb_LEVEL_Create
	public	__bb_LEVEL_Delete
	public	__bb_LEVEL_New
	public	__bb_LEVEL_kreis
	public	__bb_LEVEL_map
	public	__bb_LEVEL_map_x
	public	__bb_LEVEL_map_y
	public	__bb_LEVEL_play
	public	__bb_PLAYER_Delete
	public	__bb_PLAYER_New
	public	__bb_PLAYER_d_y_1
	public	__bb_PLAYER_d_y_2
	public	__bb_PLAYER_draw_screen_1
	public	__bb_PLAYER_draw_screen_2
	public	__bb_PLAYER_render_1
	public	__bb_PLAYER_render_2
	public	__bb_PLAYER_x_1
	public	__bb_PLAYER_x_2
	public	__bb_PLAYER_y_1
	public	__bb_PLAYER_y_2
	public	__bb_WEAPON_Delete
	public	__bb_WEAPON_New
	public	__bb_main
	public	_bb_ANZEIGE
	public	_bb_LEVEL
	public	_bb_PLAYER
	public	_bb_WEAPON
	section	"code" code
__bb_main:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	cmp	dword [_139],0
	je	_140
	mov	eax,0
	mov	esp,ebp
	pop	ebp
	ret
_140:
	mov	dword [_139],1
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
	mov	eax,dword [_135]
	and	eax,1
	cmp	eax,0
	jne	_136
	push	4
	push	100
	push	100
	push	3
	push	_133
	call	_bbArrayNew
	add	esp,20
	inc	dword [eax+4]
	mov	dword [__bb_LEVEL_map],eax
	or	dword [_135],1
_136:
	push	_bb_LEVEL
	call	_bbObjectRegisterType
	add	esp,4
	mov	eax,dword [_135]
	and	eax,2
	cmp	eax,0
	jne	_137
	mov	ecx,3
	mov	eax,dword [__bb_LEVEL_map_x]
	cdq
	idiv	ecx
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	fstp	dword [__bb_PLAYER_x_1]
	or	dword [_135],2
_137:
	mov	eax,dword [_135]
	and	eax,4
	cmp	eax,0
	jne	_138
	mov	ecx,3
	mov	eax,dword [__bb_LEVEL_map_x]
	cdq
	idiv	ecx
	shl	eax,1
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	fstp	dword [__bb_PLAYER_x_2]
	or	dword [_135],4
_138:
	push	_bb_PLAYER
	call	_bbObjectRegisterType
	add	esp,4
	push	_bb_WEAPON
	call	_bbObjectRegisterType
	add	esp,4
	push	_bb_ANZEIGE
	call	_bbObjectRegisterType
	add	esp,4
	push	600
	push	800
	call	dword [_bb_ANZEIGE+48]
	add	esp,8
	push	0
	push	300
	push	400
	call	dword [_bb_LEVEL+48]
	add	esp,12
	call	dword [_bb_LEVEL+52]
	call	_bbEnd
	mov	eax,0
	jmp	_81
_81:
	mov	esp,ebp
	pop	ebp
	ret
__bb_LEVEL_New:
	push	ebp
	mov	ebp,esp
	push	ebx
	mov	ebx,dword [ebp+8]
	push	ebx
	call	_bbObjectCtor
	add	esp,4
	mov	dword [ebx],_bb_LEVEL
	mov	eax,0
	jmp	_84
_84:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_LEVEL_Delete:
	push	ebp
	mov	ebp,esp
_87:
	mov	eax,0
	jmp	_141
_141:
	mov	esp,ebp
	pop	ebp
	ret
__bb_LEVEL_Create:
	push	ebp
	mov	ebp,esp
	sub	esp,12
	push	ebx
	push	esi
	push	edi
	mov	edx,dword [ebp+8]
	mov	eax,dword [ebp+12]
	mov	dword [__bb_LEVEL_map_x],edx
	mov	dword [__bb_LEVEL_map_y],eax
	push	4
	push	dword [__bb_LEVEL_map_y]
	push	dword [__bb_LEVEL_map_x]
	push	3
	push	_142
	call	_bbArrayNew
	add	esp,20
	mov	ebx,eax
	inc	dword [ebx+4]
	mov	eax,dword [__bb_LEVEL_map]
	dec	dword [eax+4]
	jnz	_146
	push	eax
	call	_bbGCFree
	add	esp,4
_146:
	mov	dword [__bb_LEVEL_map],ebx
	mov	ecx,3
	mov	eax,dword [__bb_LEVEL_map_y]
	cdq
	idiv	ecx
	mov	dword [ebp-8],eax
	mov	edi,0
	mov	eax,dword [__bb_LEVEL_map_x]
	sub	eax,1
	mov	dword [ebp-12],eax
	jmp	_149
_24:
	push	2
	push	-2
	call	_brl_random_Rand
	add	esp,8
	add	dword [ebp-8],eax
	cmp	dword [ebp-8],0
	jge	_151
	mov	dword [ebp-8],0
_151:
	mov	eax,dword [__bb_LEVEL_map_y]
	sub	eax,1
	cmp	dword [ebp-8],eax
	jle	_152
	mov	eax,dword [__bb_LEVEL_map_y]
	sub	eax,1
	mov	dword [ebp-8],eax
_152:
	mov	esi,0
	mov	eax,dword [__bb_LEVEL_map_y]
	sub	eax,1
	mov	dword [ebp-4],eax
	jmp	_154
_27:
	cmp	esi,dword [ebp-8]
	jl	_156
	mov	ebx,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,esi
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	byte [ebx+ecx+32],100
	mov	ebx,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,esi
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	add	ecx,1
	mov	eax,esi
	imul	eax,edi
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	eax,eax
	and	eax,0xff
	mov	eax,eax
	mov	byte [ebx+ecx+32],al
	mov	ebx,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,esi
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,2
	mov	byte [ebx+eax+32],100
	mov	ebx,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,esi
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,3
	mov	byte [ebx+eax+32],1
	jmp	_157
_156:
	mov	ebx,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,esi
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	byte [ebx+ecx+32],10
	mov	ebx,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,esi
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,1
	mov	byte [ebx+eax+32],0
	mov	ebx,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,esi
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,2
	mov	byte [ebx+eax+32],0
	mov	ebx,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,esi
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,3
	mov	byte [ebx+eax+32],0
_157:
_25:
	add	esi,1
_154:
	cmp	esi,dword [ebp-4]
	jle	_27
_26:
_22:
	add	edi,1
_149:
	cmp	edi,dword [ebp-12]
	jle	_24
_23:
	mov	eax,0
	jmp	_92
_92:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_LEVEL_play:
	push	ebp
	mov	ebp,esp
	push	ebx
	mov	ebx,0
_30:
_28:
	call	_brl_max2d_Cls
	call	dword [_bb_PLAYER+48]
	call	dword [_bb_PLAYER+52]
	call	dword [_bb_PLAYER+56]
	call	dword [_bb_PLAYER+60]
	push	0
	push	0
	push	0
	call	_brl_max2d_SetColor
	add	esp,12
	push	1142292480
	push	1092616192
	push	0
	push	1137016832
	call	_brl_max2d_DrawRect
	add	esp,16
	push	32
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_159
	push	5
	push	2
	push	10
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_256]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	push	eax
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_257]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	push	eax
	call	dword [_bb_LEVEL+56]
	add	esp,20
_159:
	add	ebx,1
	push	255
	push	255
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	0
	push	0
	mov	ecx,60
	mov	eax,ebx
	cdq
	idiv	ecx
	push	eax
	call	_bbStringFromInt
	add	esp,4
	push	eax
	call	_brl_max2d_DrawText
	add	esp,12
	push	-1
	call	_brl_graphics_Flip
	add	esp,4
	push	27
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_160
	mov	eax,0
	jmp	_94
_160:
	jmp	_30
_94:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_LEVEL_kreis:
	push	ebp
	mov	ebp,esp
	sub	esp,76
	push	ebx
	push	esi
	push	edi
	mov	eax,dword [ebp+20]
	cmp	eax,1
	je	_163
	cmp	eax,2
	je	_164
	jmp	_162
_163:
	mov	eax,dword [ebp+16]
	neg	eax
	mov	edi,eax
	mov	eax,dword [ebp+16]
	mov	dword [ebp-68],eax
	jmp	_166
_33:
	mov	eax,edi
	add	eax,dword [ebp+8]
	cmp	eax,0
	jge	_168
	jmp	_31
_168:
	mov	edx,edi
	add	edx,dword [ebp+8]
	mov	eax,dword [__bb_LEVEL_map_x]
	sub	eax,1
	cmp	edx,eax
	jle	_169
	jmp	_32
_169:
	mov	eax,dword [ebp+16]
	neg	eax
	mov	ebx,eax
	mov	eax,dword [ebp+16]
	mov	dword [ebp-60],eax
	jmp	_171
_36:
	mov	eax,ebx
	add	eax,dword [ebp+12]
	cmp	eax,0
	jge	_173
	jmp	_34
_173:
	mov	edx,ebx
	add	edx,dword [ebp+12]
	mov	eax,dword [__bb_LEVEL_map_y]
	sub	eax,1
	cmp	edx,eax
	jle	_174
	jmp	_35
_174:
	fld	qword [_262]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp+16]
	mov	dword [ebp+-76],eax
	fild	dword [ebp+-76]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-48]
	fld	qword [_263]
	sub	esp,8
	fstp	qword [esp]
	mov	dword [ebp+-76],edi
	fild	dword [ebp+-76]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-24]
	fld	qword [_264]
	sub	esp,8
	fstp	qword [esp]
	mov	dword [ebp+-76],ebx
	fild	dword [ebp+-76]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [ebp-24]
	faddp	st1,st0
	fstp	qword [ebp-24]
	fld	qword [ebp-24]
	fld	qword [ebp-48]
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_175
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,dword [ebp+8]
	add	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	eax,dword [ebp+12]
	add	eax,ebx
	mov	edx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	byte [esi+ecx+32],0
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,dword [ebp+8]
	add	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	eax,dword [ebp+12]
	add	eax,ebx
	mov	edx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,1
	mov	byte [esi+eax+32],0
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,dword [ebp+8]
	add	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	eax,dword [ebp+12]
	add	eax,ebx
	mov	edx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,2
	mov	byte [esi+eax+32],0
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,dword [ebp+8]
	add	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	eax,dword [ebp+12]
	add	eax,ebx
	mov	edx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,3
	mov	byte [esi+eax+32],0
_175:
_34:
	add	ebx,1
_171:
	cmp	ebx,dword [ebp-60]
	jle	_36
_35:
_31:
	add	edi,1
_166:
	cmp	edi,dword [ebp-68]
	jle	_33
_32:
	jmp	_162
_164:
	mov	eax,dword [ebp+16]
	neg	eax
	sub	eax,dword [ebp+24]
	mov	dword [ebp-56],eax
	mov	eax,dword [ebp+16]
	add	eax,dword [ebp+24]
	mov	dword [ebp-72],eax
	jmp	_177
_39:
	mov	eax,dword [ebp-56]
	add	eax,dword [ebp+8]
	cmp	eax,0
	jge	_179
	jmp	_37
_179:
	mov	edx,dword [ebp-56]
	add	edx,dword [ebp+8]
	mov	eax,dword [__bb_LEVEL_map_x]
	sub	eax,1
	cmp	edx,eax
	jle	_180
	jmp	_38
_180:
	mov	eax,dword [ebp+16]
	neg	eax
	sub	eax,dword [ebp+24]
	mov	dword [ebp-52],eax
	mov	eax,dword [ebp+16]
	add	eax,dword [ebp+24]
	mov	dword [ebp-64],eax
	jmp	_182
_42:
	mov	eax,dword [ebp-52]
	add	eax,dword [ebp+12]
	cmp	eax,0
	jge	_184
	jmp	_40
_184:
	mov	edx,dword [ebp-52]
	add	edx,dword [ebp+12]
	mov	eax,dword [__bb_LEVEL_map_y]
	sub	eax,1
	cmp	edx,eax
	jle	_185
	jmp	_41
_185:
	fld	qword [_265]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp+16]
	add	eax,dword [ebp+24]
	mov	dword [ebp+-76],eax
	fild	dword [ebp+-76]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-40]
	fld	qword [_266]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-56]
	mov	dword [ebp+-76],eax
	fild	dword [ebp+-76]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-16]
	fld	qword [_267]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-52]
	mov	dword [ebp+-76],eax
	fild	dword [ebp+-76]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [ebp-16]
	faddp	st1,st0
	fstp	qword [ebp-16]
	fld	qword [ebp-16]
	fld	qword [ebp-40]
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_186
	fld	qword [_268]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp+16]
	mov	dword [ebp+-76],eax
	fild	dword [ebp+-76]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-32]
	fld	qword [_269]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-56]
	mov	dword [ebp+-76],eax
	fild	dword [ebp+-76]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-8]
	fld	qword [_270]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-52]
	mov	dword [ebp+-76],eax
	fild	dword [ebp+-76]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [ebp-8]
	faddp	st1,st0
	fstp	qword [ebp-8]
	fld	qword [ebp-8]
	fld	qword [ebp-32]
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_187
	mov	ecx,dword [__bb_LEVEL_map]
	mov	edx,dword [ebp+8]
	add	edx,dword [ebp-56]
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+24]
	mov	eax,dword [ebp+12]
	add	eax,dword [ebp-52]
	mov	ebx,dword [__bb_LEVEL_map]
	imul	eax,dword [ebx+28]
	add	edx,eax
	mov	byte [ecx+edx+32],0
	mov	ecx,dword [__bb_LEVEL_map]
	mov	edx,dword [ebp+8]
	add	edx,dword [ebp-56]
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+24]
	mov	eax,dword [ebp+12]
	add	eax,dword [ebp-52]
	mov	ebx,dword [__bb_LEVEL_map]
	imul	eax,dword [ebx+28]
	add	edx,eax
	add	edx,1
	mov	byte [ecx+edx+32],0
	mov	ecx,dword [__bb_LEVEL_map]
	mov	edx,dword [ebp+8]
	add	edx,dword [ebp-56]
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+24]
	mov	eax,dword [ebp+12]
	add	eax,dword [ebp-52]
	mov	ebx,dword [__bb_LEVEL_map]
	imul	eax,dword [ebx+28]
	add	edx,eax
	add	edx,2
	mov	byte [ecx+edx+32],0
	mov	ecx,dword [__bb_LEVEL_map]
	mov	edx,dword [ebp+8]
	add	edx,dword [ebp-56]
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+24]
	mov	eax,dword [ebp+12]
	add	eax,dword [ebp-52]
	mov	ebx,dword [__bb_LEVEL_map]
	imul	eax,dword [ebx+28]
	add	edx,eax
	add	edx,3
	mov	byte [ecx+edx+32],0
	jmp	_188
_187:
	mov	ecx,dword [__bb_LEVEL_map]
	mov	edx,dword [ebp+8]
	add	edx,dword [ebp-56]
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+24]
	mov	eax,dword [ebp+12]
	add	eax,dword [ebp-52]
	mov	ebx,dword [__bb_LEVEL_map]
	imul	eax,dword [ebx+28]
	add	edx,eax
	add	edx,3
	movzx	eax,byte [ecx+edx+32]
	mov	eax,eax
	cmp	eax,1
	jne	_189
	mov	edi,dword [__bb_LEVEL_map]
	mov	eax,dword [ebp+8]
	add	eax,dword [ebp-56]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ebx,eax
	mov	eax,dword [ebp+12]
	add	eax,dword [ebp-52]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	add	ebx,eax
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,dword [ebp+8]
	add	eax,dword [ebp-56]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	eax,dword [ebp+12]
	add	eax,dword [ebp-52]
	mov	edx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	movzx	eax,byte [esi+ecx+32]
	mov	dword [ebp+-76],eax
	fild	dword [ebp+-76]
	fmul	dword [_271]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	eax,eax
	and	eax,0xff
	mov	eax,eax
	mov	byte [edi+ebx+32],al
	mov	edi,dword [__bb_LEVEL_map]
	mov	eax,dword [ebp+8]
	add	eax,dword [ebp-56]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edx,dword [ebp+12]
	add	edx,dword [ebp-52]
	mov	ecx,dword [__bb_LEVEL_map]
	imul	edx,dword [ecx+28]
	add	eax,edx
	mov	ebx,eax
	add	ebx,1
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,dword [ebp+8]
	add	eax,dword [ebp-56]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	eax,dword [ebp+12]
	add	eax,dword [ebp-52]
	mov	edx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,1
	movzx	eax,byte [esi+eax+32]
	mov	dword [ebp+-76],eax
	fild	dword [ebp+-76]
	fmul	dword [_272]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	eax,eax
	and	eax,0xff
	mov	eax,eax
	mov	byte [edi+ebx+32],al
	mov	edi,dword [__bb_LEVEL_map]
	mov	eax,dword [ebp+8]
	add	eax,dword [ebp-56]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edx,dword [ebp+12]
	add	edx,dword [ebp-52]
	mov	ecx,dword [__bb_LEVEL_map]
	imul	edx,dword [ecx+28]
	add	eax,edx
	mov	ebx,eax
	add	ebx,2
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,dword [ebp+8]
	add	eax,dword [ebp-56]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	eax,dword [ebp+12]
	add	eax,dword [ebp-52]
	mov	edx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,2
	movzx	eax,byte [esi+eax+32]
	mov	dword [ebp+-76],eax
	fild	dword [ebp+-76]
	fmul	dword [_273]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	eax,eax
	and	eax,0xff
	mov	eax,eax
	mov	byte [edi+ebx+32],al
_189:
_188:
_186:
_40:
	add	dword [ebp-52],1
_182:
	mov	eax,dword [ebp-64]
	cmp	dword [ebp-52],eax
	jle	_42
_41:
_37:
	add	dword [ebp-56],1
_177:
	mov	eax,dword [ebp-72]
	cmp	dword [ebp-56],eax
	jle	_39
_38:
	jmp	_162
_162:
	mov	eax,0
	jmp	_101
_101:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_PLAYER_New:
	push	ebp
	mov	ebp,esp
	push	ebx
	mov	ebx,dword [ebp+8]
	push	ebx
	call	_bbObjectCtor
	add	esp,4
	mov	dword [ebx],_bb_PLAYER
	mov	eax,0
	jmp	_104
_104:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_PLAYER_Delete:
	push	ebp
	mov	ebp,esp
_107:
	mov	eax,0
	jmp	_190
_190:
	mov	esp,ebp
	pop	ebp
	ret
__bb_PLAYER_render_1:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	esi
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_294]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_295]
	fadd	dword [_296]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	add	ebx,eax
	add	ebx,3
	movzx	eax,byte [esi+ebx+32]
	mov	eax,eax
	cmp	eax,0
	jne	_191
	fld	dword [__bb_PLAYER_y_1]
	fadd	dword [_297]
	fstp	dword [__bb_PLAYER_y_1]
_191:
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_298]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_299]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	add	ebx,eax
	add	ebx,3
	movzx	eax,byte [esi+ebx+32]
	mov	eax,eax
	cmp	eax,1
	jne	_192
	fld	dword [__bb_PLAYER_y_1]
	fadd	dword [_300]
	fstp	dword [__bb_PLAYER_y_1]
_192:
	push	65
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_193
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_301]
	fsub	dword [_302]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_303]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	add	ebx,eax
	add	ebx,3
	movzx	eax,byte [esi+ebx+32]
	mov	eax,eax
	cmp	eax,0
	sete	al
	movzx	eax,al
_193:
	cmp	eax,0
	je	_195
	fld	dword [__bb_PLAYER_x_1]
	fsub	dword [_304]
	fstp	dword [__bb_PLAYER_x_1]
_195:
	push	68
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_196
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_305]
	fadd	dword [_306]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_307]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	add	ebx,eax
	add	ebx,3
	movzx	eax,byte [esi+ebx+32]
	mov	eax,eax
	cmp	eax,0
	sete	al
	movzx	eax,al
_196:
	cmp	eax,0
	je	_198
	fld	dword [__bb_PLAYER_x_1]
	fadd	dword [_308]
	fstp	dword [__bb_PLAYER_x_1]
_198:
	fld	dword [__bb_PLAYER_d_y_1]
	fsub	dword [_309]
	fstp	dword [__bb_PLAYER_d_y_1]
	push	87
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_199
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_310]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_311]
	fadd	dword [_312]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	add	ebx,eax
	add	ebx,3
	movzx	eax,byte [esi+ebx+32]
	mov	eax,eax
	cmp	eax,1
	sete	al
	movzx	eax,al
_199:
	cmp	eax,0
	je	_201
	fld	dword [_313]
	fstp	dword [__bb_PLAYER_d_y_1]
_201:
	fld	dword [__bb_PLAYER_d_y_1]
	fldz
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_202
	fld	dword [__bb_PLAYER_y_1]
	fsub	dword [__bb_PLAYER_d_y_1]
	fstp	dword [__bb_PLAYER_y_1]
_202:
	mov	eax,0
	jmp	_109
_109:
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_PLAYER_render_2:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	esi
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_2]
	fdiv	dword [_325]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_2]
	fdiv	dword [_326]
	fadd	dword [_327]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	add	ebx,eax
	add	ebx,3
	movzx	eax,byte [esi+ebx+32]
	mov	eax,eax
	cmp	eax,0
	jne	_203
	fld	dword [__bb_PLAYER_y_2]
	fadd	dword [_328]
	fstp	dword [__bb_PLAYER_y_2]
_203:
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_2]
	fdiv	dword [_329]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_2]
	fdiv	dword [_330]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	add	ebx,eax
	add	ebx,3
	movzx	eax,byte [esi+ebx+32]
	mov	eax,eax
	cmp	eax,1
	jne	_204
	fld	dword [__bb_PLAYER_y_1]
	fadd	dword [_331]
	fstp	dword [__bb_PLAYER_y_1]
_204:
	push	37
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_205
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_2]
	fdiv	dword [_332]
	fsub	dword [_333]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_2]
	fdiv	dword [_334]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	add	ebx,eax
	add	ebx,3
	movzx	eax,byte [esi+ebx+32]
	mov	eax,eax
	cmp	eax,0
	sete	al
	movzx	eax,al
_205:
	cmp	eax,0
	je	_207
	fld	dword [__bb_PLAYER_x_2]
	fsub	dword [_335]
	fstp	dword [__bb_PLAYER_x_2]
_207:
	push	39
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_208
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_2]
	fdiv	dword [_336]
	fadd	dword [_337]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_2]
	fdiv	dword [_338]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	add	ebx,eax
	add	ebx,3
	movzx	eax,byte [esi+ebx+32]
	mov	eax,eax
	cmp	eax,0
	sete	al
	movzx	eax,al
_208:
	cmp	eax,0
	je	_210
	fld	dword [__bb_PLAYER_x_2]
	fadd	dword [_339]
	fstp	dword [__bb_PLAYER_x_2]
_210:
	fld	dword [__bb_PLAYER_d_y_2]
	fsub	dword [_340]
	fstp	dword [__bb_PLAYER_d_y_2]
	push	38
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_211
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_2]
	fdiv	dword [_341]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_2]
	fdiv	dword [_342]
	fadd	dword [_343]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	add	ebx,eax
	add	ebx,3
	movzx	eax,byte [esi+ebx+32]
	mov	eax,eax
	cmp	eax,1
	sete	al
	movzx	eax,al
_211:
	cmp	eax,0
	je	_213
	fld	dword [_344]
	fstp	dword [__bb_PLAYER_d_y_2]
_213:
	fld	dword [__bb_PLAYER_d_y_2]
	fldz
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_214
	fld	dword [__bb_PLAYER_y_2]
	fsub	dword [__bb_PLAYER_d_y_2]
	fstp	dword [__bb_PLAYER_y_2]
_214:
	mov	eax,0
	jmp	_111
_111:
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_PLAYER_draw_screen_1:
	push	ebp
	mov	ebp,esp
	sub	esp,12
	push	ebx
	push	esi
	push	edi
	push	600
	push	400
	push	0
	push	0
	call	_brl_max2d_SetViewport
	add	esp,16
	fld	dword [__bb_PLAYER_x_1]
	fsub	dword [_356]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edi,eax
	fld	dword [__bb_PLAYER_x_1]
	fadd	dword [_357]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	dword [ebp-8],eax
	jmp	_216
_45:
	mov	eax,edi
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map_x]
	sub	edx,1
	cmp	eax,edx
	jle	_218
	jmp	_43
_218:
	mov	eax,edi
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	cmp	eax,0
	jge	_219
	jmp	_43
_219:
	fld	dword [__bb_PLAYER_y_1]
	fsub	dword [_358]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	fld	dword [__bb_PLAYER_y_1]
	fadd	dword [_359]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	dword [ebp-4],eax
	jmp	_221
_48:
	mov	eax,ebx
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map_y]
	sub	edx,1
	cmp	eax,edx
	jle	_223
	jmp	_47
_223:
	mov	eax,ebx
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	cmp	eax,0
	jge	_224
	jmp	_46
_224:
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	eax,ebx
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,2
	movzx	eax,byte [esi+eax+32]
	mov	eax,eax
	push	eax
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	eax,ebx
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,1
	movzx	eax,byte [esi+eax+32]
	mov	eax,eax
	push	eax
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	eax,ebx
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	movzx	eax,byte [esi+ecx+32]
	mov	eax,eax
	push	eax
	call	_brl_max2d_SetColor
	add	esp,12
	push	1082130432
	push	1082130432
	mov	dword [ebp+-12],ebx
	fild	dword [ebp+-12]
	fld	dword [__bb_PLAYER_y_1]
	fsub	dword [_360]
	fsubp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	mov	dword [ebp+-12],edi
	fild	dword [ebp+-12]
	fld	dword [__bb_PLAYER_x_1]
	fsub	dword [_361]
	fsubp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_DrawRect
	add	esp,16
_46:
	add	ebx,4
_221:
	cmp	ebx,dword [ebp-4]
	jle	_48
_47:
_43:
	add	edi,4
_216:
	cmp	edi,dword [ebp-8]
	jle	_45
_44:
	push	0
	push	0
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	1101004800
	push	1092616192
	push	1133576192
	push	1128464384
	call	_brl_max2d_DrawRect
	add	esp,16
	push	0
	push	255
	push	0
	call	_brl_max2d_SetColor
	add	esp,12
	push	1101004800
	push	1092616192
	fld	dword [__bb_PLAYER_y_2]
	fsub	dword [__bb_PLAYER_y_1]
	fadd	dword [_362]
	fsub	dword [_363]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [__bb_PLAYER_x_2]
	fsub	dword [__bb_PLAYER_x_1]
	fadd	dword [_364]
	fsub	dword [_365]
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_DrawRect
	add	esp,16
	mov	eax,0
	jmp	_113
_113:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_PLAYER_draw_screen_2:
	push	ebp
	mov	ebp,esp
	sub	esp,12
	push	ebx
	push	esi
	push	edi
	push	600
	push	400
	push	0
	push	400
	call	_brl_max2d_SetViewport
	add	esp,16
	fld	dword [__bb_PLAYER_x_2]
	fsub	dword [_372]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edi,eax
	fld	dword [__bb_PLAYER_x_2]
	fadd	dword [_373]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	dword [ebp-8],eax
	jmp	_226
_51:
	mov	eax,edi
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map_x]
	sub	edx,1
	cmp	eax,edx
	jle	_228
	jmp	_49
_228:
	mov	eax,edi
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	cmp	eax,0
	jge	_229
	jmp	_49
_229:
	fld	dword [__bb_PLAYER_y_2]
	fsub	dword [_374]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	fld	dword [__bb_PLAYER_y_2]
	fadd	dword [_375]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	dword [ebp-4],eax
	jmp	_231
_54:
	mov	eax,ebx
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map_y]
	sub	edx,1
	cmp	eax,edx
	jle	_233
	jmp	_53
_233:
	mov	eax,ebx
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	cmp	eax,0
	jge	_234
	jmp	_52
_234:
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	eax,ebx
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,2
	movzx	eax,byte [esi+eax+32]
	mov	eax,eax
	push	eax
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	eax,ebx
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,1
	movzx	eax,byte [esi+eax+32]
	mov	eax,eax
	push	eax
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	eax,ebx
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	movzx	eax,byte [esi+ecx+32]
	mov	eax,eax
	push	eax
	call	_brl_max2d_SetColor
	add	esp,12
	push	1082130432
	push	1082130432
	mov	dword [ebp+-12],ebx
	fild	dword [ebp+-12]
	fld	dword [__bb_PLAYER_y_2]
	fsub	dword [_376]
	fsubp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	fld	dword [_377]
	mov	dword [ebp+-12],edi
	fild	dword [ebp+-12]
	fld	dword [__bb_PLAYER_x_2]
	fsub	dword [_378]
	fsubp	st1,st0
	faddp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_DrawRect
	add	esp,16
_52:
	add	ebx,4
_231:
	cmp	ebx,dword [ebp-4]
	jle	_54
_53:
_49:
	add	edi,4
_226:
	cmp	edi,dword [ebp-8]
	jle	_51
_50:
	push	0
	push	255
	push	0
	call	_brl_max2d_SetColor
	add	esp,12
	push	1101004800
	push	1092616192
	push	1133576192
	push	1142210560
	call	_brl_max2d_DrawRect
	add	esp,16
	push	0
	push	0
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	1101004800
	push	1092616192
	fld	dword [__bb_PLAYER_y_1]
	fsub	dword [__bb_PLAYER_y_2]
	fadd	dword [_379]
	fsub	dword [_380]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [__bb_PLAYER_x_1]
	fsub	dword [__bb_PLAYER_x_2]
	fadd	dword [_381]
	fsub	dword [_382]
	fadd	dword [_383]
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_DrawRect
	add	esp,16
	push	600
	push	800
	push	0
	push	0
	call	_brl_max2d_SetViewport
	add	esp,16
	mov	eax,0
	jmp	_115
_115:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_WEAPON_New:
	push	ebp
	mov	ebp,esp
	push	ebx
	mov	ebx,dword [ebp+8]
	push	ebx
	call	_bbObjectCtor
	add	esp,4
	mov	dword [ebx],_bb_WEAPON
	mov	eax,0
	jmp	_118
_118:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_WEAPON_Delete:
	push	ebp
	mov	ebp,esp
_121:
	mov	eax,0
	jmp	_235
_235:
	mov	esp,ebp
	pop	ebp
	ret
__bb_ANZEIGE_New:
	push	ebp
	mov	ebp,esp
	push	ebx
	mov	ebx,dword [ebp+8]
	push	ebx
	call	_bbObjectCtor
	add	esp,4
	mov	dword [ebx],_bb_ANZEIGE
	mov	eax,0
	jmp	_124
_124:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_ANZEIGE_Delete:
	push	ebp
	mov	ebp,esp
_127:
	mov	eax,0
	jmp	_236
_236:
	mov	esp,ebp
	pop	ebp
	ret
__bb_ANZEIGE_ini:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	esi
	push	edi
	mov	esi,dword [ebp+8]
	mov	ebx,dword [ebp+12]
	mov	dword [__bb_ANZEIGE_x],esi
	mov	dword [__bb_ANZEIGE_y],ebx
	mov	eax,_55
	inc	dword [eax+4]
	mov	edi,eax
	mov	eax,dword [_bbAppTitle]
	dec	dword [eax+4]
	jnz	_240
	push	eax
	call	_bbGCFree
	add	esp,4
_240:
	mov	dword [_bbAppTitle],edi
	push	0
	push	60
	push	0
	push	ebx
	push	esi
	call	_brl_graphics_Graphics
	add	esp,20
	push	0
	push	0
	push	0
	call	_brl_max2d_SetClsColor
	add	esp,12
	push	3
	call	_brl_max2d_SetBlend
	add	esp,4
	mov	eax,0
	jmp	_131
_131:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
	section	"data" data writeable align 8
	align	4
_139:
	dd	0
	align	4
__bb_LEVEL_map_x:
	dd	800
	align	4
__bb_LEVEL_map_y:
	dd	800
	align	4
_135:
	dd	0
_133:
	db	"b",0
	align	4
__bb_LEVEL_map:
	dd	_bbEmptyArray
_57:
	db	"LEVEL",0
_58:
	db	"block_s",0
_59:
	db	"i",0
	align	4
_60:
	dd	_bbStringClass
	dd	2147483646
	dd	1
	dw	52
_61:
	db	"New",0
_62:
	db	"()i",0
_63:
	db	"Delete",0
_64:
	db	"Create",0
_65:
	db	"(i,i,i)i",0
_66:
	db	"play",0
_67:
	db	"kreis",0
_68:
	db	"(i,i,i,i,i)i",0
	align	4
_56:
	dd	2
	dd	_57
	dd	1
	dd	_58
	dd	_59
	dd	_60
	dd	6
	dd	_61
	dd	_62
	dd	16
	dd	6
	dd	_63
	dd	_62
	dd	20
	dd	7
	dd	_64
	dd	_65
	dd	48
	dd	7
	dd	_66
	dd	_62
	dd	52
	dd	7
	dd	_67
	dd	_68
	dd	56
	dd	0
	align	4
_bb_LEVEL:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_56
	dd	8
	dd	__bb_LEVEL_New
	dd	__bb_LEVEL_Delete
	dd	_bbObjectToString
	dd	_bbObjectCompare
	dd	_bbObjectSendMessage
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	__bb_LEVEL_Create
	dd	__bb_LEVEL_play
	dd	__bb_LEVEL_kreis
	align	4
__bb_PLAYER_x_1:
	dd	0x0
	align	4
__bb_PLAYER_y_1:
	dd	0x42c80000
	align	4
__bb_PLAYER_x_2:
	dd	0x0
	align	4
__bb_PLAYER_y_2:
	dd	0x42c80000
	align	4
__bb_PLAYER_d_y_1:
	dd	0x0
	align	4
__bb_PLAYER_d_y_2:
	dd	0x0
_70:
	db	"PLAYER",0
_71:
	db	"render_1",0
_72:
	db	"render_2",0
_73:
	db	"draw_screen_1",0
_74:
	db	"draw_screen_2",0
	align	4
_69:
	dd	2
	dd	_70
	dd	6
	dd	_61
	dd	_62
	dd	16
	dd	6
	dd	_63
	dd	_62
	dd	20
	dd	7
	dd	_71
	dd	_62
	dd	48
	dd	7
	dd	_72
	dd	_62
	dd	52
	dd	7
	dd	_73
	dd	_62
	dd	56
	dd	7
	dd	_74
	dd	_62
	dd	60
	dd	0
	align	4
_bb_PLAYER:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_69
	dd	8
	dd	__bb_PLAYER_New
	dd	__bb_PLAYER_Delete
	dd	_bbObjectToString
	dd	_bbObjectCompare
	dd	_bbObjectSendMessage
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	__bb_PLAYER_render_1
	dd	__bb_PLAYER_render_2
	dd	__bb_PLAYER_draw_screen_1
	dd	__bb_PLAYER_draw_screen_2
_76:
	db	"WEAPON",0
	align	4
_75:
	dd	2
	dd	_76
	dd	6
	dd	_61
	dd	_62
	dd	16
	dd	6
	dd	_63
	dd	_62
	dd	20
	dd	0
	align	4
_bb_WEAPON:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_75
	dd	8
	dd	__bb_WEAPON_New
	dd	__bb_WEAPON_Delete
	dd	_bbObjectToString
	dd	_bbObjectCompare
	dd	_bbObjectSendMessage
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	align	4
__bb_ANZEIGE_x:
	dd	0
	align	4
__bb_ANZEIGE_y:
	dd	0
_78:
	db	"ANZEIGE",0
_79:
	db	"ini",0
_80:
	db	"(i,i)i",0
	align	4
_77:
	dd	2
	dd	_78
	dd	6
	dd	_61
	dd	_62
	dd	16
	dd	6
	dd	_63
	dd	_62
	dd	20
	dd	7
	dd	_79
	dd	_80
	dd	48
	dd	0
	align	4
_bb_ANZEIGE:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_77
	dd	8
	dd	__bb_ANZEIGE_New
	dd	__bb_ANZEIGE_Delete
	dd	_bbObjectToString
	dd	_bbObjectCompare
	dd	_bbObjectSendMessage
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	__bb_ANZEIGE_ini
_142:
	db	"b",0
	align	4
_256:
	dd	0x40800000
	align	4
_257:
	dd	0x40800000
	align	8
_262:
	dd	0x0,0x40000000
	align	8
_263:
	dd	0x0,0x40000000
	align	8
_264:
	dd	0x0,0x40000000
	align	8
_265:
	dd	0x0,0x40000000
	align	8
_266:
	dd	0x0,0x40000000
	align	8
_267:
	dd	0x0,0x40000000
	align	8
_268:
	dd	0x0,0x40000000
	align	8
_269:
	dd	0x0,0x40000000
	align	8
_270:
	dd	0x0,0x40000000
	align	4
_271:
	dd	0x3f000000
	align	4
_272:
	dd	0x3ecccccd
	align	4
_273:
	dd	0x3e4ccccd
	align	4
_294:
	dd	0x40800000
	align	4
_295:
	dd	0x40800000
	align	4
_296:
	dd	0x40000000
	align	4
_297:
	dd	0x40000000
	align	4
_298:
	dd	0x40800000
	align	4
_299:
	dd	0x40800000
	align	4
_300:
	dd	0x40400000
	align	4
_301:
	dd	0x40800000
	align	4
_302:
	dd	0x3f800000
	align	4
_303:
	dd	0x40800000
	align	4
_304:
	dd	0x40000000
	align	4
_305:
	dd	0x40800000
	align	4
_306:
	dd	0x3f800000
	align	4
_307:
	dd	0x40800000
	align	4
_308:
	dd	0x40400000
	align	4
_309:
	dd	0x3e4ccccd
	align	4
_310:
	dd	0x40800000
	align	4
_311:
	dd	0x40800000
	align	4
_312:
	dd	0x40000000
	align	4
_313:
	dd	0x40a00000
	align	4
_325:
	dd	0x40800000
	align	4
_326:
	dd	0x40800000
	align	4
_327:
	dd	0x40000000
	align	4
_328:
	dd	0x40000000
	align	4
_329:
	dd	0x40800000
	align	4
_330:
	dd	0x40800000
	align	4
_331:
	dd	0x3f800000
	align	4
_332:
	dd	0x40800000
	align	4
_333:
	dd	0x3f800000
	align	4
_334:
	dd	0x40800000
	align	4
_335:
	dd	0x40000000
	align	4
_336:
	dd	0x40800000
	align	4
_337:
	dd	0x3f800000
	align	4
_338:
	dd	0x40800000
	align	4
_339:
	dd	0x40000000
	align	4
_340:
	dd	0x3e4ccccd
	align	4
_341:
	dd	0x40800000
	align	4
_342:
	dd	0x40800000
	align	4
_343:
	dd	0x40000000
	align	4
_344:
	dd	0x40a00000
	align	4
_356:
	dd	0x43480000
	align	4
_357:
	dd	0x43480000
	align	4
_358:
	dd	0x43960000
	align	4
_359:
	dd	0x43960000
	align	4
_360:
	dd	0x43960000
	align	4
_361:
	dd	0x43480000
	align	4
_362:
	dd	0x43960000
	align	4
_363:
	dd	0x41200000
	align	4
_364:
	dd	0x43480000
	align	4
_365:
	dd	0x40a00000
	align	4
_372:
	dd	0x43480000
	align	4
_373:
	dd	0x43480000
	align	4
_374:
	dd	0x43960000
	align	4
_375:
	dd	0x43960000
	align	4
_376:
	dd	0x43960000
	align	4
_377:
	dd	0x43c80000
	align	4
_378:
	dd	0x43480000
	align	4
_379:
	dd	0x43960000
	align	4
_380:
	dd	0x41200000
	align	4
_381:
	dd	0x43480000
	align	4
_382:
	dd	0x40a00000
	align	4
_383:
	dd	0x43c80000
	align	4
_55:
	dd	_bbStringClass
	dd	2147483647
	dd	6
	dw	87,252,114,109,101,114
