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
	extrn	_bbAppTitle
	extrn	_bbArrayNew
	extrn	_bbCos
	extrn	_bbEmptyArray
	extrn	_bbEnd
	extrn	_bbFloatPow
	extrn	_bbFloatToInt
	extrn	_bbGCFree
	extrn	_bbMilliSecs
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
	extrn	_bbSin
	extrn	_bbStringClass
	extrn	_bbStringFromInt
	extrn	_brl_blitz_NullMethodError
	extrn	_brl_graphics_Flip
	extrn	_brl_graphics_Graphics
	extrn	_brl_linkedlist_ListRemove
	extrn	_brl_linkedlist_TList
	extrn	_brl_max2d_Cls
	extrn	_brl_max2d_DrawImage
	extrn	_brl_max2d_DrawRect
	extrn	_brl_max2d_DrawText
	extrn	_brl_max2d_LoadImage
	extrn	_brl_max2d_MidHandleImage
	extrn	_brl_max2d_SetBlend
	extrn	_brl_max2d_SetClsColor
	extrn	_brl_max2d_SetColor
	extrn	_brl_max2d_SetRotation
	extrn	_brl_max2d_SetViewport
	extrn	_brl_pixmap_LoadPixmap
	extrn	_brl_pixmap_PixmapHeight
	extrn	_brl_pixmap_PixmapWidth
	extrn	_brl_pixmap_ReadPixel
	extrn	_brl_polledinput_KeyDown
	extrn	_brl_polledinput_KeyHit
	extrn	_brl_random_Rand
	extrn	_brl_random_SeedRnd
	extrn	_brl_standardio_Print
	public	__bb_ANZEIGE_Delete
	public	__bb_ANZEIGE_New
	public	__bb_ANZEIGE_ini
	public	__bb_ANZEIGE_x
	public	__bb_ANZEIGE_y
	public	__bb_GRANATE_NORMAL_Create
	public	__bb_GRANATE_NORMAL_Delete
	public	__bb_GRANATE_NORMAL_New
	public	__bb_GRANATE_NORMAL_draw
	public	__bb_GRANATE_NORMAL_image
	public	__bb_GRANATE_NORMAL_ini
	public	__bb_LEVEL_Create
	public	__bb_LEVEL_Delete
	public	__bb_LEVEL_New
	public	__bb_LEVEL_getpixel
	public	__bb_LEVEL_gravitation
	public	__bb_LEVEL_ini
	public	__bb_LEVEL_kreis
	public	__bb_LEVEL_map
	public	__bb_LEVEL_map_x
	public	__bb_LEVEL_map_y
	public	__bb_LEVEL_play
	public	__bb_LEVEL_wasser
	public	__bb_LEVEL_wasser_hoehe
	public	__bb_LEVEL_wind
	public	__bb_PLAYER_Delete
	public	__bb_PLAYER_New
	public	__bb_PLAYER_d_y_1
	public	__bb_PLAYER_d_y_2
	public	__bb_PLAYER_draw_screen_1
	public	__bb_PLAYER_draw_screen_2
	public	__bb_PLAYER_ini
	public	__bb_PLAYER_mann
	public	__bb_PLAYER_pistole
	public	__bb_PLAYER_render_1
	public	__bb_PLAYER_render_2
	public	__bb_PLAYER_w_1
	public	__bb_PLAYER_w_2
	public	__bb_PLAYER_x_1
	public	__bb_PLAYER_x_2
	public	__bb_PLAYER_y_1
	public	__bb_PLAYER_y_2
	public	__bb_RAKETE_NORMAL_Create
	public	__bb_RAKETE_NORMAL_Delete
	public	__bb_RAKETE_NORMAL_New
	public	__bb_RAKETE_NORMAL_draw
	public	__bb_RAKETE_NORMAL_image
	public	__bb_RAKETE_NORMAL_ini
	public	__bb_RAKETE_NORMAL_render
	public	__bb_WAFFE_Delete
	public	__bb_WAFFE_New
	public	__bb_WAFFE_draw_all
	public	__bb_WAFFE_ini
	public	__bb_WAFFE_liste
	public	__bb_WAFFE_render
	public	__bb_WAFFE_render_all
	public	__bb_main
	public	_bb_ANZEIGE
	public	_bb_GRANATE_NORMAL
	public	_bb_LEVEL
	public	_bb_PLAYER
	public	_bb_RAKETE_NORMAL
	public	_bb_WAFFE
	section	"code" code
__bb_main:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	cmp	dword [_249],0
	je	_250
	mov	eax,0
	mov	esp,ebp
	pop	ebp
	ret
_250:
	mov	dword [_249],1
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
	mov	eax,dword [_245]
	and	eax,1
	cmp	eax,0
	jne	_246
	push	4
	push	100
	push	100
	push	3
	push	_243
	call	_bbArrayNew
	add	esp,20
	inc	dword [eax+4]
	mov	dword [__bb_LEVEL_map],eax
	or	dword [_245],1
_246:
	push	_bb_LEVEL
	call	_bbObjectRegisterType
	add	esp,4
	mov	eax,dword [_245]
	and	eax,2
	cmp	eax,0
	jne	_247
	mov	ecx,3
	mov	eax,dword [__bb_LEVEL_map_x]
	cdq
	idiv	ecx
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	fstp	dword [__bb_PLAYER_x_1]
	or	dword [_245],2
_247:
	mov	eax,dword [_245]
	and	eax,4
	cmp	eax,0
	jne	_248
	mov	ecx,3
	mov	eax,dword [__bb_LEVEL_map_x]
	cdq
	idiv	ecx
	shl	eax,1
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	fstp	dword [__bb_PLAYER_x_2]
	or	dword [_245],4
_248:
	push	_bb_PLAYER
	call	_bbObjectRegisterType
	add	esp,4
	push	_bb_WAFFE
	call	_bbObjectRegisterType
	add	esp,4
	push	_bb_GRANATE_NORMAL
	call	_bbObjectRegisterType
	add	esp,4
	push	_bb_RAKETE_NORMAL
	call	_bbObjectRegisterType
	add	esp,4
	push	_bb_ANZEIGE
	call	_bbObjectRegisterType
	add	esp,4
	call	_bbMilliSecs
	push	eax
	call	_brl_random_SeedRnd
	add	esp,4
	push	600
	push	800
	call	dword [_bb_ANZEIGE+48]
	add	esp,8
	call	dword [_bb_LEVEL+48]
	call	dword [_bb_WAFFE+48]
	call	dword [_bb_PLAYER+48]
	call	dword [_bb_RAKETE_NORMAL+48]
	call	dword [_bb_GRANATE_NORMAL+48]
	push	0
	push	300
	push	400
	call	dword [_bb_LEVEL+52]
	add	esp,12
	call	dword [_bb_LEVEL+60]
	call	_bbEnd
	mov	eax,0
	jmp	_121
_121:
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
	jmp	_124
_124:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_LEVEL_Delete:
	push	ebp
	mov	ebp,esp
_127:
	mov	eax,0
	jmp	_251
_251:
	mov	esp,ebp
	pop	ebp
	ret
__bb_LEVEL_ini:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	-1
	push	_22
	call	_brl_max2d_LoadImage
	add	esp,8
	inc	dword [eax+4]
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_wasser]
	dec	dword [eax+4]
	jnz	_255
	push	eax
	call	_bbGCFree
	add	esp,4
_255:
	mov	dword [__bb_LEVEL_wasser],ebx
	mov	eax,0
	jmp	_129
_129:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_LEVEL_Create:
	push	ebp
	mov	ebp,esp
	sub	esp,28
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
	push	_256
	call	_bbArrayNew
	add	esp,20
	inc	dword [eax+4]
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	dec	dword [eax+4]
	jnz	_260
	push	eax
	call	_bbGCFree
	add	esp,4
_260:
	mov	dword [__bb_LEVEL_map],ebx
	push	_23
	call	_brl_pixmap_LoadPixmap
	add	esp,4
	mov	dword [ebp-24],eax
	push	_24
	call	_brl_pixmap_LoadPixmap
	add	esp,4
	mov	dword [ebp-20],eax
	mov	ecx,3
	mov	eax,dword [__bb_LEVEL_map_y]
	cdq
	idiv	ecx
	mov	dword [ebp-12],eax
	mov	dword [ebp-16],0
	mov	dword [ebp-4],0
	mov	edi,0
	mov	eax,dword [__bb_LEVEL_map_x]
	sub	eax,1
	mov	dword [ebp-28],eax
	jmp	_267
_27:
	push	1
	push	-1
	call	_brl_random_Rand
	add	esp,8
	add	dword [ebp-16],eax
	cmp	dword [ebp-16],5
	jle	_269
	mov	dword [ebp-16],5
_269:
	cmp	dword [ebp-16],-5
	jge	_270
	mov	dword [ebp-16],-5
_270:
	cmp	dword [ebp-12],50
	jge	_271
	add	dword [ebp-16],1
_271:
	mov	eax,dword [__bb_LEVEL_map_y]
	sub	eax,1
	sub	eax,50
	cmp	dword [ebp-12],eax
	jle	_272
	sub	dword [ebp-16],1
_272:
	mov	eax,dword [ebp-16]
	add	dword [ebp-12],eax
	mov	ebx,0
	mov	eax,dword [__bb_LEVEL_map_y]
	sub	eax,1
	mov	dword [ebp-8],eax
	jmp	_274
_30:
	cmp	ebx,dword [ebp-12]
	jl	_276
	cmp	dword [ebp-4],5
	jge	_277
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,ebx
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,2
	lea	eax,byte [esi+eax+32]
	push	eax
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,ebx
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,1
	lea	eax,byte [esi+eax+32]
	push	eax
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,ebx
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	lea	eax,byte [esi+ecx+32]
	push	eax
	push	dword [ebp-4]
	push	edi
	push	dword [ebp-20]
	call	dword [_bb_LEVEL+56]
	add	esp,24
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,ebx
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,3
	mov	byte [esi+eax+32],1
	jmp	_278
_277:
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,ebx
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,2
	lea	eax,byte [esi+eax+32]
	push	eax
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,ebx
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,1
	lea	eax,byte [esi+eax+32]
	push	eax
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,ebx
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	lea	eax,byte [esi+ecx+32]
	push	eax
	push	ebx
	push	edi
	push	dword [ebp-24]
	call	dword [_bb_LEVEL+56]
	add	esp,24
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,ebx
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,3
	mov	byte [esi+eax+32],1
_278:
	add	dword [ebp-4],1
	jmp	_279
_276:
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,ebx
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	byte [esi+ecx+32],0
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,ebx
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,1
	mov	byte [esi+eax+32],0
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,ebx
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,2
	mov	byte [esi+eax+32],0
	mov	esi,dword [__bb_LEVEL_map]
	mov	eax,edi
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ecx,eax
	mov	edx,ebx
	mov	eax,dword [__bb_LEVEL_map]
	imul	edx,dword [eax+28]
	add	ecx,edx
	mov	eax,ecx
	add	eax,3
	mov	byte [esi+eax+32],0
	mov	dword [ebp-4],0
_279:
_28:
	add	ebx,1
_274:
	cmp	ebx,dword [ebp-8]
	jle	_30
_29:
_25:
	add	edi,1
_267:
	cmp	edi,dword [ebp-28]
	jle	_27
_26:
	mov	eax,0
	jmp	_134
_134:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_LEVEL_getpixel:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	esi
	push	edi
	mov	esi,dword [ebp+8]
	mov	ebx,dword [ebp+12]
	mov	edi,dword [ebp+16]
	jmp	_31
_33:
	push	esi
	call	_brl_pixmap_PixmapWidth
	add	esp,4
	sub	ebx,eax
_31:
	push	esi
	call	_brl_pixmap_PixmapWidth
	add	esp,4
	cmp	ebx,eax
	jge	_33
_32:
	jmp	_34
_36:
	push	esi
	call	_brl_pixmap_PixmapHeight
	add	esp,4
	sub	edi,eax
_34:
	push	esi
	call	_brl_pixmap_PixmapHeight
	add	esp,4
	cmp	edi,eax
	jge	_36
_35:
	push	edi
	push	ebx
	push	esi
	call	_brl_pixmap_ReadPixel
	add	esp,12
	mov	edx,eax
	mov	eax,edx
	shr	eax,16
	mov	eax,eax
	and	eax,0xff
	mov	eax,eax
	mov	ecx,dword [ebp+20]
	mov	eax,eax
	and	eax,0xff
	mov	eax,eax
	mov	byte [ecx],al
	mov	eax,edx
	shr	eax,8
	mov	eax,eax
	and	eax,0xff
	mov	eax,eax
	mov	ecx,dword [ebp+24]
	mov	eax,eax
	and	eax,0xff
	mov	eax,eax
	mov	byte [ecx],al
	mov	eax,edx
	and	eax,0xff
	mov	eax,eax
	mov	edx,dword [ebp+28]
	mov	eax,eax
	and	eax,0xff
	mov	eax,eax
	mov	byte [edx],al
	mov	eax,0
	jmp	_142
_142:
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
_39:
_37:
	call	_brl_max2d_Cls
	call	dword [_bb_WAFFE+60]
	call	dword [_bb_PLAYER+52]
	call	dword [_bb_PLAYER+56]
	call	dword [_bb_PLAYER+60]
	call	dword [_bb_PLAYER+64]
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
	je	_282
	push	2
	push	2
	push	5
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_454]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	push	eax
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_455]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	push	eax
	call	dword [_bb_LEVEL+64]
	add	esp,20
_282:
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
	je	_283
	mov	eax,0
	jmp	_144
_283:
	jmp	_39
_144:
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
	je	_286
	cmp	eax,2
	je	_287
	jmp	_285
_286:
	mov	eax,dword [ebp+16]
	neg	eax
	mov	edi,eax
	mov	eax,dword [ebp+16]
	mov	dword [ebp-68],eax
	jmp	_289
_42:
	mov	eax,edi
	add	eax,dword [ebp+8]
	cmp	eax,0
	jge	_291
	jmp	_40
_291:
	mov	edx,edi
	add	edx,dword [ebp+8]
	mov	eax,dword [__bb_LEVEL_map_x]
	sub	eax,1
	cmp	edx,eax
	jle	_292
	jmp	_41
_292:
	mov	eax,dword [ebp+16]
	neg	eax
	mov	ebx,eax
	mov	eax,dword [ebp+16]
	mov	dword [ebp-60],eax
	jmp	_294
_45:
	mov	eax,ebx
	add	eax,dword [ebp+12]
	cmp	eax,0
	jge	_296
	jmp	_43
_296:
	mov	edx,ebx
	add	edx,dword [ebp+12]
	mov	eax,dword [__bb_LEVEL_map_y]
	sub	eax,1
	cmp	edx,eax
	jle	_297
	jmp	_44
_297:
	fld	qword [_460]
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
	fld	qword [_461]
	sub	esp,8
	fstp	qword [esp]
	mov	dword [ebp+-76],edi
	fild	dword [ebp+-76]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-24]
	fld	qword [_462]
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
	jne	_298
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
_298:
_43:
	add	ebx,1
_294:
	cmp	ebx,dword [ebp-60]
	jle	_45
_44:
_40:
	add	edi,1
_289:
	cmp	edi,dword [ebp-68]
	jle	_42
_41:
	jmp	_285
_287:
	mov	eax,dword [ebp+16]
	neg	eax
	sub	eax,dword [ebp+24]
	mov	dword [ebp-56],eax
	mov	eax,dword [ebp+16]
	add	eax,dword [ebp+24]
	mov	dword [ebp-72],eax
	jmp	_300
_48:
	mov	eax,dword [ebp-56]
	add	eax,dword [ebp+8]
	cmp	eax,0
	jge	_302
	jmp	_46
_302:
	mov	edx,dword [ebp-56]
	add	edx,dword [ebp+8]
	mov	eax,dword [__bb_LEVEL_map_x]
	sub	eax,1
	cmp	edx,eax
	jle	_303
	jmp	_47
_303:
	mov	eax,dword [ebp+16]
	neg	eax
	sub	eax,dword [ebp+24]
	mov	dword [ebp-52],eax
	mov	eax,dword [ebp+16]
	add	eax,dword [ebp+24]
	mov	dword [ebp-64],eax
	jmp	_305
_51:
	mov	eax,dword [ebp-52]
	add	eax,dword [ebp+12]
	cmp	eax,0
	jge	_307
	jmp	_49
_307:
	mov	edx,dword [ebp-52]
	add	edx,dword [ebp+12]
	mov	eax,dword [__bb_LEVEL_map_y]
	sub	eax,1
	cmp	edx,eax
	jle	_308
	jmp	_50
_308:
	fld	qword [_463]
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
	fld	qword [_464]
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
	fld	qword [_465]
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
	jne	_309
	fld	qword [_466]
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
	fld	qword [_467]
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
	fld	qword [_468]
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
	jne	_310
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
	jmp	_311
_310:
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
	jne	_312
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
	fmul	dword [_469]
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
	fmul	dword [_470]
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
	fmul	dword [_471]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	eax,eax
	and	eax,0xff
	mov	eax,eax
	mov	byte [edi+ebx+32],al
_312:
_311:
_309:
_49:
	add	dword [ebp-52],1
_305:
	mov	eax,dword [ebp-64]
	cmp	dword [ebp-52],eax
	jle	_51
_50:
_46:
	add	dword [ebp-56],1
_300:
	mov	eax,dword [ebp-72]
	cmp	dword [ebp-56],eax
	jle	_48
_47:
	jmp	_285
_285:
	mov	eax,0
	jmp	_151
_151:
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
	jmp	_154
_154:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_PLAYER_Delete:
	push	ebp
	mov	ebp,esp
_157:
	mov	eax,0
	jmp	_313
_313:
	mov	esp,ebp
	pop	ebp
	ret
__bb_PLAYER_ini:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	-1
	push	_52
	call	_brl_max2d_LoadImage
	add	esp,8
	inc	dword [eax+4]
	mov	ebx,eax
	mov	eax,dword [__bb_PLAYER_pistole]
	dec	dword [eax+4]
	jnz	_317
	push	eax
	call	_bbGCFree
	add	esp,4
_317:
	mov	dword [__bb_PLAYER_pistole],ebx
	push	dword [__bb_PLAYER_pistole]
	call	_brl_max2d_MidHandleImage
	add	esp,4
	push	-1
	push	_53
	call	_brl_max2d_LoadImage
	add	esp,8
	inc	dword [eax+4]
	mov	ebx,eax
	mov	eax,dword [__bb_PLAYER_mann]
	dec	dword [eax+4]
	jnz	_321
	push	eax
	call	_bbGCFree
	add	esp,4
_321:
	mov	dword [__bb_PLAYER_mann],ebx
	mov	eax,0
	jmp	_159
_159:
	pop	ebx
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
	fdiv	dword [_494]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_495]
	fadd	dword [_496]
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
	jne	_322
	fld	dword [__bb_PLAYER_y_1]
	fadd	dword [_497]
	fstp	dword [__bb_PLAYER_y_1]
_322:
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_498]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_499]
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
	jne	_323
	fld	dword [__bb_PLAYER_y_1]
	fadd	dword [_500]
	fstp	dword [__bb_PLAYER_y_1]
_323:
	push	65
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_324
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_501]
	fsub	dword [_502]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_503]
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
_324:
	cmp	eax,0
	je	_326
	fld	dword [__bb_PLAYER_x_1]
	fsub	dword [_504]
	fstp	dword [__bb_PLAYER_x_1]
_326:
	push	68
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_327
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_505]
	fadd	dword [_506]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_507]
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
_327:
	cmp	eax,0
	je	_329
	fld	dword [__bb_PLAYER_x_1]
	fadd	dword [_508]
	fstp	dword [__bb_PLAYER_x_1]
_329:
	fld	dword [__bb_PLAYER_d_y_1]
	fsub	dword [_509]
	fstp	dword [__bb_PLAYER_d_y_1]
	push	87
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_330
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_510]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_511]
	fadd	dword [_512]
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
_330:
	cmp	eax,0
	je	_332
	fld	dword [_513]
	fstp	dword [__bb_PLAYER_d_y_1]
_332:
	fld	dword [__bb_PLAYER_d_y_1]
	fldz
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_333
	fld	dword [__bb_PLAYER_y_1]
	fsub	dword [__bb_PLAYER_d_y_1]
	fstp	dword [__bb_PLAYER_y_1]
_333:
	push	81
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_334
	fld	dword [__bb_PLAYER_w_1]
	fsub	dword [_514]
	fstp	dword [__bb_PLAYER_w_1]
_334:
	push	69
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_335
	fld	dword [__bb_PLAYER_w_1]
	fadd	dword [_515]
	fstp	dword [__bb_PLAYER_w_1]
_335:
	push	83
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_336
	push	1120403456
	push	dword [__bb_PLAYER_w_1]
	push	dword [__bb_PLAYER_y_1]
	push	dword [__bb_PLAYER_x_1]
	call	dword [_bb_RAKETE_NORMAL+68]
	add	esp,16
_336:
	mov	eax,0
	jmp	_161
_161:
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
	fdiv	dword [_530]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_2]
	fdiv	dword [_531]
	fadd	dword [_532]
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
	jne	_337
	fld	dword [__bb_PLAYER_y_2]
	fadd	dword [_533]
	fstp	dword [__bb_PLAYER_y_2]
_337:
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_2]
	fdiv	dword [_534]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_2]
	fdiv	dword [_535]
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
	jne	_338
	fld	dword [__bb_PLAYER_y_1]
	fadd	dword [_536]
	fstp	dword [__bb_PLAYER_y_1]
_338:
	push	100
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_339
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_2]
	fdiv	dword [_537]
	fsub	dword [_538]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_2]
	fdiv	dword [_539]
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
_339:
	cmp	eax,0
	je	_341
	fld	dword [__bb_PLAYER_x_2]
	fsub	dword [_540]
	fstp	dword [__bb_PLAYER_x_2]
_341:
	push	102
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_342
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_2]
	fdiv	dword [_541]
	fadd	dword [_542]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_2]
	fdiv	dword [_543]
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
_342:
	cmp	eax,0
	je	_344
	fld	dword [__bb_PLAYER_x_2]
	fadd	dword [_544]
	fstp	dword [__bb_PLAYER_x_2]
_344:
	fld	dword [__bb_PLAYER_d_y_2]
	fsub	dword [_545]
	fstp	dword [__bb_PLAYER_d_y_2]
	push	104
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_345
	mov	esi,dword [__bb_LEVEL_map]
	fld	dword [__bb_PLAYER_x_2]
	fdiv	dword [_546]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	mov	eax,dword [__bb_LEVEL_map]
	imul	ebx,dword [eax+24]
	fld	dword [__bb_PLAYER_y_2]
	fdiv	dword [_547]
	fadd	dword [_548]
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
_345:
	cmp	eax,0
	je	_347
	fld	dword [_549]
	fstp	dword [__bb_PLAYER_d_y_2]
_347:
	fld	dword [__bb_PLAYER_d_y_2]
	fldz
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_348
	fld	dword [__bb_PLAYER_y_2]
	fsub	dword [__bb_PLAYER_d_y_2]
	fstp	dword [__bb_PLAYER_y_2]
_348:
	push	103
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_349
	fld	dword [__bb_PLAYER_w_1]
	fsub	dword [_550]
	fstp	dword [__bb_PLAYER_w_1]
_349:
	push	105
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_350
	fld	dword [__bb_PLAYER_w_1]
	fadd	dword [_551]
	fstp	dword [__bb_PLAYER_w_1]
_350:
	push	101
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_351
	push	1120403456
	push	dword [__bb_PLAYER_w_2]
	push	dword [__bb_PLAYER_y_2]
	push	dword [__bb_PLAYER_x_2]
	call	dword [_bb_RAKETE_NORMAL+68]
	add	esp,16
_351:
	mov	eax,0
	jmp	_163
_163:
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
	fsub	dword [_566]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edi,eax
	fld	dword [__bb_PLAYER_x_1]
	fadd	dword [_567]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	dword [ebp-8],eax
	jmp	_353
_56:
	mov	eax,edi
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map_x]
	sub	edx,1
	cmp	eax,edx
	jle	_355
	jmp	_54
_355:
	mov	eax,edi
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	cmp	eax,0
	jge	_356
	jmp	_54
_356:
	fld	dword [__bb_PLAYER_y_1]
	fsub	dword [_568]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	fld	dword [__bb_PLAYER_y_1]
	fadd	dword [_569]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	dword [ebp-4],eax
	jmp	_358
_59:
	mov	eax,ebx
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map_y]
	sub	edx,1
	cmp	eax,edx
	jle	_360
	jmp	_58
_360:
	mov	eax,ebx
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	cmp	eax,0
	jge	_361
	jmp	_57
_361:
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
	add	eax,3
	movzx	eax,byte [esi+eax+32]
	mov	eax,eax
	cmp	eax,1
	jne	_362
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
	fsub	dword [_570]
	fsubp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	mov	dword [ebp+-12],edi
	fild	dword [ebp+-12]
	fld	dword [__bb_PLAYER_x_1]
	fsub	dword [_571]
	fsubp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_DrawRect
	add	esp,16
_362:
_57:
	add	ebx,4
_358:
	cmp	ebx,dword [ebp-4]
	jle	_59
_58:
_54:
	add	edi,4
_353:
	cmp	edi,dword [ebp-8]
	jle	_56
_55:
	push	0
	push	100
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	0
	push	1133576192
	push	1128464384
	push	dword [__bb_PLAYER_mann]
	call	_brl_max2d_DrawImage
	add	esp,16
	push	255
	push	255
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	dword [__bb_PLAYER_w_1]
	call	_brl_max2d_SetRotation
	add	esp,4
	push	0
	push	1133903872
	push	1128792064
	push	dword [__bb_PLAYER_pistole]
	call	_brl_max2d_DrawImage
	add	esp,16
	push	0
	call	_brl_max2d_SetRotation
	add	esp,4
	push	100
	push	255
	push	0
	call	_brl_max2d_SetColor
	add	esp,12
	push	0
	fld	dword [__bb_PLAYER_y_2]
	fsub	dword [__bb_PLAYER_y_1]
	fadd	dword [_572]
	fsub	dword [_573]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [__bb_PLAYER_x_2]
	fsub	dword [__bb_PLAYER_x_1]
	fadd	dword [_574]
	fsub	dword [_575]
	sub	esp,4
	fstp	dword [esp]
	push	dword [__bb_PLAYER_mann]
	call	_brl_max2d_DrawImage
	add	esp,16
	push	dword [__bb_PLAYER_w_2]
	call	_brl_max2d_SetRotation
	add	esp,4
	push	0
	fld	dword [__bb_PLAYER_y_2]
	fsub	dword [__bb_PLAYER_y_1]
	fadd	dword [_576]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [__bb_PLAYER_x_2]
	fsub	dword [__bb_PLAYER_x_1]
	fadd	dword [_577]
	sub	esp,4
	fstp	dword [esp]
	push	dword [__bb_PLAYER_pistole]
	call	_brl_max2d_DrawImage
	add	esp,16
	push	0
	call	_brl_max2d_SetRotation
	add	esp,4
	push	300
	push	200
	fld	dword [__bb_PLAYER_y_1]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	push	eax
	fld	dword [__bb_PLAYER_x_1]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	push	eax
	call	dword [_bb_WAFFE+64]
	add	esp,16
	push	255
	push	255
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	0
	mov	eax,dword [__bb_LEVEL_wasser_hoehe]
	mov	dword [ebp+-12],eax
	fild	dword [ebp+-12]
	fsub	dword [__bb_PLAYER_y_1]
	fadd	dword [_578]
	sub	esp,4
	fstp	dword [esp]
	push	0
	push	dword [__bb_LEVEL_wasser]
	call	_brl_max2d_DrawImage
	add	esp,16
	mov	eax,0
	jmp	_165
_165:
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
	fsub	dword [_586]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edi,eax
	fld	dword [__bb_PLAYER_x_2]
	fadd	dword [_587]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	dword [ebp-8],eax
	jmp	_364
_62:
	mov	eax,edi
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map_x]
	sub	edx,1
	cmp	eax,edx
	jle	_366
	jmp	_60
_366:
	mov	eax,edi
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	cmp	eax,0
	jge	_367
	jmp	_60
_367:
	fld	dword [__bb_PLAYER_y_2]
	fsub	dword [_588]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	ebx,eax
	fld	dword [__bb_PLAYER_y_2]
	fadd	dword [_589]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	dword [ebp-4],eax
	jmp	_369
_65:
	mov	eax,ebx
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map_y]
	sub	edx,1
	cmp	eax,edx
	jle	_371
	jmp	_64
_371:
	mov	eax,ebx
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	cmp	eax,0
	jge	_372
	jmp	_63
_372:
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
	add	eax,3
	movzx	eax,byte [esi+eax+32]
	mov	eax,eax
	cmp	eax,1
	jne	_373
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
	fsub	dword [_590]
	fsubp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	fld	dword [_591]
	mov	dword [ebp+-12],edi
	fild	dword [ebp+-12]
	fld	dword [__bb_PLAYER_x_2]
	fsub	dword [_592]
	fsubp	st1,st0
	faddp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_DrawRect
	add	esp,16
_373:
_63:
	add	ebx,4
_369:
	cmp	ebx,dword [ebp-4]
	jle	_65
_64:
_60:
	add	edi,4
_364:
	cmp	edi,dword [ebp-8]
	jle	_62
_61:
	push	100
	push	255
	push	0
	call	_brl_max2d_SetColor
	add	esp,12
	push	0
	push	1133576192
	push	1142210560
	push	dword [__bb_PLAYER_mann]
	call	_brl_max2d_DrawImage
	add	esp,16
	push	255
	push	255
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	dword [__bb_PLAYER_w_2]
	call	_brl_max2d_SetRotation
	add	esp,4
	push	0
	push	1133903872
	push	1142292480
	push	dword [__bb_PLAYER_pistole]
	call	_brl_max2d_DrawImage
	add	esp,16
	push	0
	call	_brl_max2d_SetRotation
	add	esp,4
	push	0
	push	100
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	0
	fld	dword [__bb_PLAYER_y_1]
	fsub	dword [__bb_PLAYER_y_2]
	fadd	dword [_593]
	fsub	dword [_594]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [__bb_PLAYER_x_1]
	fsub	dword [__bb_PLAYER_x_2]
	fadd	dword [_595]
	fsub	dword [_596]
	fadd	dword [_597]
	sub	esp,4
	fstp	dword [esp]
	push	dword [__bb_PLAYER_mann]
	call	_brl_max2d_DrawImage
	add	esp,16
	push	dword [__bb_PLAYER_w_1]
	call	_brl_max2d_SetRotation
	add	esp,4
	push	0
	fld	dword [__bb_PLAYER_y_1]
	fsub	dword [__bb_PLAYER_y_2]
	fadd	dword [_598]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [__bb_PLAYER_x_1]
	fsub	dword [__bb_PLAYER_x_2]
	fadd	dword [_599]
	sub	esp,4
	fstp	dword [esp]
	push	dword [__bb_PLAYER_pistole]
	call	_brl_max2d_DrawImage
	add	esp,16
	push	0
	call	_brl_max2d_SetRotation
	add	esp,4
	push	300
	push	600
	fld	dword [__bb_PLAYER_y_2]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	push	eax
	fld	dword [__bb_PLAYER_x_2]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	push	eax
	call	dword [_bb_WAFFE+64]
	add	esp,16
	push	255
	push	255
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	0
	mov	eax,dword [__bb_LEVEL_wasser_hoehe]
	mov	dword [ebp+-12],eax
	fild	dword [ebp+-12]
	fsub	dword [__bb_PLAYER_y_2]
	fadd	dword [_600]
	sub	esp,4
	fstp	dword [esp]
	push	1137180672
	push	dword [__bb_LEVEL_wasser]
	call	_brl_max2d_DrawImage
	add	esp,16
	push	600
	push	800
	push	0
	push	0
	call	_brl_max2d_SetViewport
	add	esp,16
	mov	eax,0
	jmp	_167
_167:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_WAFFE_New:
	push	ebp
	mov	ebp,esp
	push	ebx
	mov	ebx,dword [ebp+8]
	push	ebx
	call	_bbObjectCtor
	add	esp,4
	mov	dword [ebx],_bb_WAFFE
	fldz
	fstp	dword [ebx+8]
	fldz
	fstp	dword [ebx+12]
	fldz
	fstp	dword [ebx+16]
	fldz
	fstp	dword [ebx+20]
	fldz
	fstp	dword [ebx+24]
	fldz
	fstp	dword [ebx+28]
	mov	eax,dword [__bb_WAFFE_liste]
	push	ebx
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+68]
	add	esp,8
	fld1
	fstp	dword [ebx+16]
	fld1
	fstp	dword [ebx+28]
	mov	eax,0
	jmp	_170
_170:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_WAFFE_Delete:
	push	ebp
	mov	ebp,esp
_173:
	mov	eax,0
	jmp	_375
_375:
	mov	esp,ebp
	pop	ebp
	ret
__bb_WAFFE_ini:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	_brl_linkedlist_TList
	call	_bbObjectNew
	add	esp,4
	inc	dword [eax+4]
	mov	ebx,eax
	mov	eax,dword [__bb_WAFFE_liste]
	dec	dword [eax+4]
	jnz	_379
	push	eax
	call	_bbGCFree
	add	esp,4
_379:
	mov	dword [__bb_WAFFE_liste],ebx
	mov	eax,0
	jmp	_175
_175:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_WAFFE_render:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	push	esi
	push	edi
	mov	esi,dword [ebp+8]
	fld	dword [esi+12]
	fadd	dword [__bb_LEVEL_wind]
	fstp	dword [esi+12]
	fld	dword [esi+12]
	fmul	dword [esi+16]
	fstp	dword [esi+12]
	fld	dword [esi+8]
	fadd	dword [esi+12]
	fstp	dword [esi+8]
	fld	dword [esi+24]
	fadd	dword [__bb_LEVEL_gravitation]
	fstp	dword [esi+24]
	fld	dword [esi+24]
	fmul	dword [esi+28]
	fstp	dword [esi+24]
	fld	dword [esi+20]
	fadd	dword [esi+24]
	fstp	dword [esi+20]
	fld	dword [esi+20]
	mov	eax,dword [__bb_LEVEL_wasser_hoehe]
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_380
	push	esi
	push	dword [__bb_WAFFE_liste]
	call	_brl_linkedlist_ListRemove
	add	esp,8
_380:
	fld	dword [esi+8]
	fldz
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setb	al
	movzx	eax,al
	cmp	eax,0
	jne	_381
	fld	dword [esi+20]
	fldz
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setb	al
	movzx	eax,al
_381:
	cmp	eax,0
	jne	_383
	fld	dword [esi+8]
	mov	eax,dword [__bb_LEVEL_map_x]
	shl	eax,2
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	seta	al
	movzx	eax,al
_383:
	cmp	eax,0
	jne	_385
	fld	dword [esi+20]
	mov	eax,dword [__bb_LEVEL_map_y]
	shl	eax,2
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	seta	al
	movzx	eax,al
_385:
	cmp	eax,0
	je	_387
	mov	eax,0
	jmp	_178
_387:
	mov	edi,dword [__bb_LEVEL_map]
	fld	dword [esi+8]
	fdiv	dword [_614]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ebx,eax
	fld	dword [esi+20]
	fdiv	dword [_615]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	add	ebx,eax
	mov	eax,ebx
	add	eax,3
	movzx	eax,byte [edi+eax+32]
	mov	eax,eax
	cmp	eax,1
	jne	_388
	push	esi
	push	dword [__bb_WAFFE_liste]
	call	_brl_linkedlist_ListRemove
	add	esp,8
	push	5
	push	2
	push	10
	fld	dword [esi+20]
	fdiv	dword [_616]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	push	eax
	fld	dword [esi+8]
	fdiv	dword [_617]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	push	eax
	call	dword [_bb_LEVEL+64]
	add	esp,20
_388:
	mov	eax,0
	jmp	_178
_178:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_WAFFE_render_all:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	esi
	mov	esi,dword [__bb_WAFFE_liste]
	push	esi
	mov	eax,dword [esi]
	call	dword [eax+140]
	add	esp,4
	mov	ebx,eax
	jmp	_66
_68:
	push	_bb_WAFFE
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,4
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	cmp	eax,_bbNullObject
	je	_66
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+56]
	add	esp,4
_66:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_68
_67:
	mov	eax,0
	jmp	_180
_180:
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_WAFFE_draw_all:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	esi
	push	edi
	mov	edi,dword [ebp+16]
	mov	esi,dword [__bb_WAFFE_liste]
	mov	eax,esi
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+140]
	add	esp,4
	mov	ebx,eax
	jmp	_69
_71:
	mov	eax,ebx
	push	_bb_WAFFE
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+52]
	add	esp,4
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	cmp	eax,_bbNullObject
	je	_69
	push	dword [ebp+20]
	push	edi
	push	dword [ebp+12]
	push	dword [ebp+8]
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+52]
	add	esp,20
_69:
	mov	eax,ebx
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_71
_70:
	mov	eax,0
	jmp	_186
_186:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_GRANATE_NORMAL_New:
	push	ebp
	mov	ebp,esp
	push	ebx
	mov	ebx,dword [ebp+8]
	push	ebx
	call	__bb_WAFFE_New
	add	esp,4
	mov	dword [ebx],_bb_GRANATE_NORMAL
	mov	eax,0
	jmp	_189
_189:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_GRANATE_NORMAL_Delete:
	push	ebp
	mov	ebp,esp
	mov	eax,dword [ebp+8]
_192:
	mov	dword [eax],_bb_WAFFE
	push	eax
	call	__bb_WAFFE_Delete
	add	esp,4
	mov	eax,0
	jmp	_403
_403:
	mov	esp,ebp
	pop	ebp
	ret
__bb_GRANATE_NORMAL_ini:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	-1
	push	_72
	call	_brl_max2d_LoadImage
	add	esp,8
	inc	dword [eax+4]
	mov	ebx,eax
	mov	eax,dword [__bb_GRANATE_NORMAL_image]
	dec	dword [eax+4]
	jnz	_407
	push	eax
	call	_bbGCFree
	add	esp,4
_407:
	mov	dword [__bb_GRANATE_NORMAL_image],ebx
	push	dword [__bb_GRANATE_NORMAL_image]
	call	_brl_max2d_MidHandleImage
	add	esp,4
	cmp	dword [__bb_GRANATE_NORMAL_image],_bbNullObject
	jne	_408
	push	_1
	call	_brl_standardio_Print
	add	esp,4
_408:
	mov	eax,0
	jmp	_194
_194:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_GRANATE_NORMAL_draw:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	push	esi
	push	edi
	mov	esi,dword [ebp+8]
	mov	ebx,dword [ebp+16]
	mov	edi,dword [ebp+20]
	push	255
	push	255
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	fld	dword [esi+12]
	sub	esp,8
	fstp	qword [esp]
	fld	dword [esi+24]
	sub	esp,8
	fstp	qword [esp]
	call	_bbATan2
	add	esp,16
	fld	qword [_639]
	faddp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_SetRotation
	add	esp,4
	push	0
	mov	eax,dword [ebp+24]
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	fadd	dword [esi+20]
	mov	dword [ebp+-4],ebx
	fild	dword [ebp+-4]
	fsubp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	mov	dword [ebp+-4],edi
	fild	dword [ebp+-4]
	fadd	dword [esi+8]
	mov	eax,dword [ebp+12]
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	fsubp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	push	dword [__bb_GRANATE_NORMAL_image]
	call	_brl_max2d_DrawImage
	add	esp,16
	push	0
	call	_brl_max2d_SetRotation
	add	esp,4
	mov	eax,0
	jmp	_201
_201:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_GRANATE_NORMAL_Create:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	_bb_GRANATE_NORMAL
	call	_bbObjectNew
	add	esp,4
	mov	ebx,eax
	fld	dword [ebp+8]
	fstp	dword [ebx+8]
	fld	dword [ebp+12]
	fstp	dword [ebx+20]
	fld	dword [ebp+16]
	sub	esp,8
	fstp	qword [esp]
	call	_bbCos
	add	esp,8
	fld	dword [ebp+20]
	fmulp	st1,st0
	fld	qword [_642]
	fmulp	st1,st0
	fstp	dword [ebx+12]
	fld	dword [ebp+16]
	sub	esp,8
	fstp	qword [esp]
	call	_bbSin
	add	esp,8
	fld	dword [ebp+20]
	fmulp	st1,st0
	fld	qword [_643]
	fmulp	st1,st0
	fstp	dword [ebx+24]
	mov	eax,ebx
	jmp	_207
_207:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_RAKETE_NORMAL_New:
	push	ebp
	mov	ebp,esp
	push	ebx
	mov	ebx,dword [ebp+8]
	push	ebx
	call	__bb_WAFFE_New
	add	esp,4
	mov	dword [ebx],_bb_RAKETE_NORMAL
	mov	dword [ebx+32],60
	mov	eax,0
	jmp	_210
_210:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_RAKETE_NORMAL_Delete:
	push	ebp
	mov	ebp,esp
	mov	eax,dword [ebp+8]
_213:
	mov	dword [eax],_bb_WAFFE
	push	eax
	call	__bb_WAFFE_Delete
	add	esp,4
	mov	eax,0
	jmp	_410
_410:
	mov	esp,ebp
	pop	ebp
	ret
__bb_RAKETE_NORMAL_ini:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	-1
	push	_73
	call	_brl_max2d_LoadImage
	add	esp,8
	inc	dword [eax+4]
	mov	ebx,eax
	mov	eax,dword [__bb_RAKETE_NORMAL_image]
	dec	dword [eax+4]
	jnz	_414
	push	eax
	call	_bbGCFree
	add	esp,4
_414:
	mov	dword [__bb_RAKETE_NORMAL_image],ebx
	push	dword [__bb_RAKETE_NORMAL_image]
	call	_brl_max2d_MidHandleImage
	add	esp,4
	cmp	dword [__bb_RAKETE_NORMAL_image],_bbNullObject
	jne	_415
	push	_1
	call	_brl_standardio_Print
	add	esp,4
_415:
	mov	eax,0
	jmp	_215
_215:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_RAKETE_NORMAL_draw:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	push	esi
	push	edi
	mov	esi,dword [ebp+8]
	mov	ebx,dword [ebp+16]
	mov	edi,dword [ebp+20]
	push	255
	push	255
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	fld	dword [esi+12]
	sub	esp,8
	fstp	qword [esp]
	fld	dword [esi+24]
	sub	esp,8
	fstp	qword [esp]
	call	_bbATan2
	add	esp,16
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_SetRotation
	add	esp,4
	push	0
	mov	eax,dword [ebp+24]
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	fadd	dword [esi+20]
	mov	dword [ebp+-4],ebx
	fild	dword [ebp+-4]
	fsubp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	mov	dword [ebp+-4],edi
	fild	dword [ebp+-4]
	fadd	dword [esi+8]
	mov	eax,dword [ebp+12]
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	fsubp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	push	dword [__bb_RAKETE_NORMAL_image]
	call	_brl_max2d_DrawImage
	add	esp,16
	push	0
	call	_brl_max2d_SetRotation
	add	esp,4
	mov	eax,0
	jmp	_222
_222:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_RAKETE_NORMAL_Create:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	_bb_RAKETE_NORMAL
	call	_bbObjectNew
	add	esp,4
	mov	ebx,eax
	fld	dword [ebp+8]
	fstp	dword [ebx+8]
	fld	dword [ebp+12]
	fstp	dword [ebx+20]
	fld	dword [ebp+16]
	sub	esp,8
	fstp	qword [esp]
	call	_bbCos
	add	esp,8
	fld	dword [ebp+20]
	fmulp	st1,st0
	fld	qword [_656]
	fmulp	st1,st0
	fstp	dword [ebx+12]
	fld	dword [ebp+16]
	sub	esp,8
	fstp	qword [esp]
	call	_bbSin
	add	esp,8
	fld	dword [ebp+20]
	fmulp	st1,st0
	fld	qword [_657]
	fmulp	st1,st0
	fstp	dword [ebx+24]
	mov	eax,ebx
	jmp	_228
_228:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_RAKETE_NORMAL_render:
	push	ebp
	mov	ebp,esp
	sub	esp,20
	push	ebx
	push	esi
	push	edi
	mov	esi,dword [ebp+8]
	cmp	dword [esi+32],0
	jle	_417
	fld	dword [esi+12]
	fstp	qword [ebp-8]
	fld	dword [esi+12]
	sub	esp,8
	fstp	qword [esp]
	fld	dword [esi+24]
	sub	esp,8
	fstp	qword [esp]
	call	_bbATan2
	add	esp,16
	sub	esp,8
	fstp	qword [esp]
	call	_bbCos
	add	esp,8
	fld	qword [_661]
	fmulp	st1,st0
	mov	eax,dword [esi+32]
	mov	dword [ebp+-20],eax
	fild	dword [ebp+-20]
	fmulp	st1,st0
	fld	qword [ebp-8]
	faddp	st1,st0
	fstp	qword [ebp-8]
	fld	qword [ebp-8]
	fstp	dword [esi+12]
	fld	dword [esi+24]
	fstp	qword [ebp-16]
	fld	dword [esi+12]
	sub	esp,8
	fstp	qword [esp]
	fld	dword [esi+24]
	sub	esp,8
	fstp	qword [esp]
	call	_bbATan2
	add	esp,16
	sub	esp,8
	fstp	qword [esp]
	call	_bbSin
	add	esp,8
	fld	qword [_662]
	fmulp	st1,st0
	mov	eax,dword [esi+32]
	mov	dword [ebp+-20],eax
	fild	dword [ebp+-20]
	fmulp	st1,st0
	fld	qword [ebp-16]
	faddp	st1,st0
	fstp	qword [ebp-16]
	fld	qword [ebp-16]
	fstp	dword [esi+24]
	sub	dword [esi+32],1
_417:
	fld	dword [esi+12]
	fadd	dword [__bb_LEVEL_wind]
	fstp	dword [esi+12]
	fld	dword [esi+12]
	fmul	dword [esi+16]
	fstp	dword [esi+12]
	fld	dword [esi+8]
	fadd	dword [esi+12]
	fstp	dword [esi+8]
	fld	dword [esi+24]
	fadd	dword [__bb_LEVEL_gravitation]
	fstp	dword [esi+24]
	fld	dword [esi+24]
	fmul	dword [esi+28]
	fstp	dword [esi+24]
	fld	dword [esi+20]
	fadd	dword [esi+24]
	fstp	dword [esi+20]
	fld	dword [esi+20]
	mov	eax,dword [__bb_LEVEL_wasser_hoehe]
	mov	dword [ebp+-20],eax
	fild	dword [ebp+-20]
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_418
	push	esi
	push	dword [__bb_WAFFE_liste]
	call	_brl_linkedlist_ListRemove
	add	esp,8
_418:
	fld	dword [esi+8]
	fldz
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setb	al
	movzx	eax,al
	cmp	eax,0
	jne	_419
	fld	dword [esi+20]
	fldz
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setb	al
	movzx	eax,al
_419:
	cmp	eax,0
	jne	_421
	fld	dword [esi+8]
	mov	eax,dword [__bb_LEVEL_map_x]
	shl	eax,2
	mov	dword [ebp+-20],eax
	fild	dword [ebp+-20]
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	seta	al
	movzx	eax,al
_421:
	cmp	eax,0
	jne	_423
	fld	dword [esi+20]
	mov	eax,dword [__bb_LEVEL_map_y]
	shl	eax,2
	mov	dword [ebp+-20],eax
	fild	dword [ebp+-20]
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	seta	al
	movzx	eax,al
_423:
	cmp	eax,0
	je	_425
	mov	eax,0
	jmp	_231
_425:
	mov	edi,dword [__bb_LEVEL_map]
	fld	dword [esi+8]
	fdiv	dword [_663]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	ebx,eax
	fld	dword [esi+20]
	fdiv	dword [_664]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	add	ebx,eax
	mov	eax,ebx
	add	eax,3
	movzx	eax,byte [edi+eax+32]
	mov	eax,eax
	cmp	eax,1
	jne	_426
	push	esi
	push	dword [__bb_WAFFE_liste]
	call	_brl_linkedlist_ListRemove
	add	esp,8
	push	5
	push	2
	push	10
	fld	dword [esi+20]
	fdiv	dword [_665]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	push	eax
	fld	dword [esi+8]
	fdiv	dword [_666]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	push	eax
	call	dword [_bb_LEVEL+64]
	add	esp,20
_426:
	mov	eax,0
	jmp	_231
_231:
	pop	edi
	pop	esi
	pop	ebx
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
	jmp	_234
_234:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_ANZEIGE_Delete:
	push	ebp
	mov	ebp,esp
_237:
	mov	eax,0
	jmp	_427
_427:
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
	mov	eax,_74
	inc	dword [eax+4]
	mov	edi,eax
	mov	eax,dword [_bbAppTitle]
	dec	dword [eax+4]
	jnz	_431
	push	eax
	call	_bbGCFree
	add	esp,4
_431:
	mov	dword [_bbAppTitle],edi
	push	0
	push	60
	push	0
	push	ebx
	push	esi
	call	_brl_graphics_Graphics
	add	esp,20
	push	150
	push	100
	push	0
	call	_brl_max2d_SetClsColor
	add	esp,12
	push	3
	call	_brl_max2d_SetBlend
	add	esp,4
	mov	eax,0
	jmp	_241
_241:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
	section	"data" data writeable align 8
	align	4
_249:
	dd	0
	align	4
__bb_LEVEL_map_x:
	dd	800
	align	4
__bb_LEVEL_map_y:
	dd	800
	align	4
_245:
	dd	0
_243:
	db	"b",0
	align	4
__bb_LEVEL_map:
	dd	_bbEmptyArray
	align	4
__bb_LEVEL_wasser:
	dd	_bbNullObject
	align	4
__bb_LEVEL_wasser_hoehe:
	dd	1000
	align	4
__bb_LEVEL_wind:
	dd	0x3d4ccccd
	align	4
__bb_LEVEL_gravitation:
	dd	0x3e4ccccd
_76:
	db	"LEVEL",0
_77:
	db	"block_s",0
_78:
	db	"i",0
	align	4
_79:
	dd	_bbStringClass
	dd	2147483646
	dd	1
	dw	52
_80:
	db	"New",0
_81:
	db	"()i",0
_82:
	db	"Delete",0
_83:
	db	"ini",0
_84:
	db	"Create",0
_85:
	db	"(i,i,i)i",0
_86:
	db	"getpixel",0
_87:
	db	"(:TPixmap,i,i,*b,*b,*b)i",0
_88:
	db	"play",0
_89:
	db	"kreis",0
_90:
	db	"(i,i,i,i,i)i",0
	align	4
_75:
	dd	2
	dd	_76
	dd	1
	dd	_77
	dd	_78
	dd	_79
	dd	6
	dd	_80
	dd	_81
	dd	16
	dd	6
	dd	_82
	dd	_81
	dd	20
	dd	7
	dd	_83
	dd	_81
	dd	48
	dd	7
	dd	_84
	dd	_85
	dd	52
	dd	7
	dd	_86
	dd	_87
	dd	56
	dd	7
	dd	_88
	dd	_81
	dd	60
	dd	7
	dd	_89
	dd	_90
	dd	64
	dd	0
	align	4
_bb_LEVEL:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_75
	dd	8
	dd	__bb_LEVEL_New
	dd	__bb_LEVEL_Delete
	dd	_bbObjectToString
	dd	_bbObjectCompare
	dd	_bbObjectSendMessage
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	__bb_LEVEL_ini
	dd	__bb_LEVEL_Create
	dd	__bb_LEVEL_getpixel
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
	align	4
__bb_PLAYER_w_1:
	dd	0x0
	align	4
__bb_PLAYER_w_2:
	dd	0x0
	align	4
__bb_PLAYER_pistole:
	dd	_bbNullObject
	align	4
__bb_PLAYER_mann:
	dd	_bbNullObject
_92:
	db	"PLAYER",0
_93:
	db	"render_1",0
_94:
	db	"render_2",0
_95:
	db	"draw_screen_1",0
_96:
	db	"draw_screen_2",0
	align	4
_91:
	dd	2
	dd	_92
	dd	6
	dd	_80
	dd	_81
	dd	16
	dd	6
	dd	_82
	dd	_81
	dd	20
	dd	7
	dd	_83
	dd	_81
	dd	48
	dd	7
	dd	_93
	dd	_81
	dd	52
	dd	7
	dd	_94
	dd	_81
	dd	56
	dd	7
	dd	_95
	dd	_81
	dd	60
	dd	7
	dd	_96
	dd	_81
	dd	64
	dd	0
	align	4
_bb_PLAYER:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_91
	dd	8
	dd	__bb_PLAYER_New
	dd	__bb_PLAYER_Delete
	dd	_bbObjectToString
	dd	_bbObjectCompare
	dd	_bbObjectSendMessage
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	__bb_PLAYER_ini
	dd	__bb_PLAYER_render_1
	dd	__bb_PLAYER_render_2
	dd	__bb_PLAYER_draw_screen_1
	dd	__bb_PLAYER_draw_screen_2
	align	4
__bb_WAFFE_liste:
	dd	_bbNullObject
_98:
	db	"WAFFE",0
_99:
	db	"x",0
_100:
	db	"f",0
_101:
	db	"v_x",0
_102:
	db	"a_r_x",0
_103:
	db	"y",0
_104:
	db	"v_y",0
_105:
	db	"a_r_y",0
_106:
	db	"draw",0
_107:
	db	"(i,i,i,i)i",0
_108:
	db	"render",0
_109:
	db	"render_all",0
_110:
	db	"draw_all",0
	align	4
_97:
	dd	2
	dd	_98
	dd	3
	dd	_99
	dd	_100
	dd	8
	dd	3
	dd	_101
	dd	_100
	dd	12
	dd	3
	dd	_102
	dd	_100
	dd	16
	dd	3
	dd	_103
	dd	_100
	dd	20
	dd	3
	dd	_104
	dd	_100
	dd	24
	dd	3
	dd	_105
	dd	_100
	dd	28
	dd	6
	dd	_80
	dd	_81
	dd	16
	dd	6
	dd	_82
	dd	_81
	dd	20
	dd	7
	dd	_83
	dd	_81
	dd	48
	dd	6
	dd	_106
	dd	_107
	dd	52
	dd	6
	dd	_108
	dd	_81
	dd	56
	dd	7
	dd	_109
	dd	_81
	dd	60
	dd	7
	dd	_110
	dd	_107
	dd	64
	dd	0
	align	4
_bb_WAFFE:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_97
	dd	32
	dd	__bb_WAFFE_New
	dd	__bb_WAFFE_Delete
	dd	_bbObjectToString
	dd	_bbObjectCompare
	dd	_bbObjectSendMessage
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	__bb_WAFFE_ini
	dd	_brl_blitz_NullMethodError
	dd	__bb_WAFFE_render
	dd	__bb_WAFFE_render_all
	dd	__bb_WAFFE_draw_all
	align	4
__bb_GRANATE_NORMAL_image:
	dd	_bbNullObject
_112:
	db	"GRANATE_NORMAL",0
_113:
	db	"(f,f,f,f):GRANATE_NORMAL",0
	align	4
_111:
	dd	2
	dd	_112
	dd	6
	dd	_80
	dd	_81
	dd	16
	dd	6
	dd	_82
	dd	_81
	dd	20
	dd	7
	dd	_83
	dd	_81
	dd	48
	dd	6
	dd	_106
	dd	_107
	dd	52
	dd	7
	dd	_84
	dd	_113
	dd	68
	dd	0
	align	4
_bb_GRANATE_NORMAL:
	dd	_bb_WAFFE
	dd	_bbObjectFree
	dd	_111
	dd	32
	dd	__bb_GRANATE_NORMAL_New
	dd	__bb_GRANATE_NORMAL_Delete
	dd	_bbObjectToString
	dd	_bbObjectCompare
	dd	_bbObjectSendMessage
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	__bb_GRANATE_NORMAL_ini
	dd	__bb_GRANATE_NORMAL_draw
	dd	__bb_WAFFE_render
	dd	__bb_WAFFE_render_all
	dd	__bb_WAFFE_draw_all
	dd	__bb_GRANATE_NORMAL_Create
	align	4
__bb_RAKETE_NORMAL_image:
	dd	_bbNullObject
_115:
	db	"RAKETE_NORMAL",0
_116:
	db	"power",0
_117:
	db	"(f,f,f,f):RAKETE_NORMAL",0
	align	4
_114:
	dd	2
	dd	_115
	dd	3
	dd	_116
	dd	_78
	dd	32
	dd	6
	dd	_80
	dd	_81
	dd	16
	dd	6
	dd	_82
	dd	_81
	dd	20
	dd	7
	dd	_83
	dd	_81
	dd	48
	dd	6
	dd	_106
	dd	_107
	dd	52
	dd	7
	dd	_84
	dd	_117
	dd	68
	dd	6
	dd	_108
	dd	_81
	dd	56
	dd	0
	align	4
_bb_RAKETE_NORMAL:
	dd	_bb_WAFFE
	dd	_bbObjectFree
	dd	_114
	dd	36
	dd	__bb_RAKETE_NORMAL_New
	dd	__bb_RAKETE_NORMAL_Delete
	dd	_bbObjectToString
	dd	_bbObjectCompare
	dd	_bbObjectSendMessage
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	_bbObjectReserved
	dd	__bb_RAKETE_NORMAL_ini
	dd	__bb_RAKETE_NORMAL_draw
	dd	__bb_RAKETE_NORMAL_render
	dd	__bb_WAFFE_render_all
	dd	__bb_WAFFE_draw_all
	dd	__bb_RAKETE_NORMAL_Create
	align	4
__bb_ANZEIGE_x:
	dd	0
	align	4
__bb_ANZEIGE_y:
	dd	0
_119:
	db	"ANZEIGE",0
_120:
	db	"(i,i)i",0
	align	4
_118:
	dd	2
	dd	_119
	dd	6
	dd	_80
	dd	_81
	dd	16
	dd	6
	dd	_82
	dd	_81
	dd	20
	dd	7
	dd	_83
	dd	_120
	dd	48
	dd	0
	align	4
_bb_ANZEIGE:
	dd	_bbObjectClass
	dd	_bbObjectFree
	dd	_118
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
	align	4
_22:
	dd	_bbStringClass
	dd	2147483647
	dd	14
	dw	103,102,120,92,119,97,115,115,101,114,46,112,110,103
_256:
	db	"b",0
	align	4
_23:
	dd	_bbStringClass
	dd	2147483647
	dd	17
	dw	103,102,120,92,109,97,112,92,98,111,100,101,110,46,98,109
	dw	112
	align	4
_24:
	dd	_bbStringClass
	dd	2147483647
	dd	16
	dw	103,102,120,92,109,97,112,92,103,114,97,115,46,98,109,112
	align	4
_454:
	dd	0x40800000
	align	4
_455:
	dd	0x40800000
	align	8
_460:
	dd	0x0,0x40000000
	align	8
_461:
	dd	0x0,0x40000000
	align	8
_462:
	dd	0x0,0x40000000
	align	8
_463:
	dd	0x0,0x40000000
	align	8
_464:
	dd	0x0,0x40000000
	align	8
_465:
	dd	0x0,0x40000000
	align	8
_466:
	dd	0x0,0x40000000
	align	8
_467:
	dd	0x0,0x40000000
	align	8
_468:
	dd	0x0,0x40000000
	align	4
_469:
	dd	0x3f333333
	align	4
_470:
	dd	0x3f333333
	align	4
_471:
	dd	0x3f333333
	align	4
_52:
	dd	_bbStringClass
	dd	2147483647
	dd	22
	dw	103,102,120,92,119,97,102,102,101,110,92,112,105,115,116,111
	dw	108,101,46,112,110,103
	align	4
_53:
	dd	_bbStringClass
	dd	2147483647
	dd	12
	dw	103,102,120,92,109,97,110,110,46,112,110,103
	align	4
_494:
	dd	0x40800000
	align	4
_495:
	dd	0x40800000
	align	4
_496:
	dd	0x40000000
	align	4
_497:
	dd	0x40000000
	align	4
_498:
	dd	0x40800000
	align	4
_499:
	dd	0x40800000
	align	4
_500:
	dd	0x40400000
	align	4
_501:
	dd	0x40800000
	align	4
_502:
	dd	0x3f800000
	align	4
_503:
	dd	0x40800000
	align	4
_504:
	dd	0x40000000
	align	4
_505:
	dd	0x40800000
	align	4
_506:
	dd	0x3f800000
	align	4
_507:
	dd	0x40800000
	align	4
_508:
	dd	0x40400000
	align	4
_509:
	dd	0x3e4ccccd
	align	4
_510:
	dd	0x40800000
	align	4
_511:
	dd	0x40800000
	align	4
_512:
	dd	0x40000000
	align	4
_513:
	dd	0x40a00000
	align	4
_514:
	dd	0x40000000
	align	4
_515:
	dd	0x40000000
	align	4
_530:
	dd	0x40800000
	align	4
_531:
	dd	0x40800000
	align	4
_532:
	dd	0x40000000
	align	4
_533:
	dd	0x40000000
	align	4
_534:
	dd	0x40800000
	align	4
_535:
	dd	0x40800000
	align	4
_536:
	dd	0x3f800000
	align	4
_537:
	dd	0x40800000
	align	4
_538:
	dd	0x3f800000
	align	4
_539:
	dd	0x40800000
	align	4
_540:
	dd	0x40000000
	align	4
_541:
	dd	0x40800000
	align	4
_542:
	dd	0x3f800000
	align	4
_543:
	dd	0x40800000
	align	4
_544:
	dd	0x40000000
	align	4
_545:
	dd	0x3e4ccccd
	align	4
_546:
	dd	0x40800000
	align	4
_547:
	dd	0x40800000
	align	4
_548:
	dd	0x40000000
	align	4
_549:
	dd	0x40a00000
	align	4
_550:
	dd	0x40000000
	align	4
_551:
	dd	0x40000000
	align	4
_566:
	dd	0x43480000
	align	4
_567:
	dd	0x43480000
	align	4
_568:
	dd	0x43960000
	align	4
_569:
	dd	0x43960000
	align	4
_570:
	dd	0x43960000
	align	4
_571:
	dd	0x43480000
	align	4
_572:
	dd	0x43960000
	align	4
_573:
	dd	0x41200000
	align	4
_574:
	dd	0x43480000
	align	4
_575:
	dd	0x40a00000
	align	4
_576:
	dd	0x43960000
	align	4
_577:
	dd	0x43480000
	align	4
_578:
	dd	0x43960000
	align	4
_586:
	dd	0x43480000
	align	4
_587:
	dd	0x43480000
	align	4
_588:
	dd	0x43960000
	align	4
_589:
	dd	0x43960000
	align	4
_590:
	dd	0x43960000
	align	4
_591:
	dd	0x43c80000
	align	4
_592:
	dd	0x43480000
	align	4
_593:
	dd	0x43960000
	align	4
_594:
	dd	0x41200000
	align	4
_595:
	dd	0x43480000
	align	4
_596:
	dd	0x40a00000
	align	4
_597:
	dd	0x43c80000
	align	4
_598:
	dd	0x43960000
	align	4
_599:
	dd	0x44160000
	align	4
_600:
	dd	0x43960000
	align	4
_614:
	dd	0x40800000
	align	4
_615:
	dd	0x40800000
	align	4
_616:
	dd	0x40800000
	align	4
_617:
	dd	0x40800000
	align	4
_72:
	dd	_bbStringClass
	dd	2147483647
	dd	29
	dw	103,102,120,92,119,97,102,102,101,110,92,103,114,97,110,97
	dw	116,101,95,110,111,114,109,97,108,46,112,110,103
	align	4
_1:
	dd	_bbStringClass
	dd	2147483647
	dd	0
	align	8
_639:
	dd	0x0,0x40568000
	align	8
_642:
	dd	0xa0000000,0x3fb99999
	align	8
_643:
	dd	0xa0000000,0x3fb99999
	align	4
_73:
	dd	_bbStringClass
	dd	2147483647
	dd	28
	dw	103,102,120,92,119,97,102,102,101,110,92,114,97,107,101,116
	dw	101,95,110,111,114,109,97,108,46,112,110,103
	align	8
_656:
	dd	0xa0000000,0x3fa99999
	align	8
_657:
	dd	0xa0000000,0x3fa99999
	align	8
_661:
	dd	0x40000000,0x3f747ae1
	align	8
_662:
	dd	0x40000000,0x3f747ae1
	align	4
_663:
	dd	0x40800000
	align	4
_664:
	dd	0x40800000
	align	4
_665:
	dd	0x40800000
	align	4
_666:
	dd	0x40800000
	align	4
_74:
	dd	_bbStringClass
	dd	2147483647
	dd	6
	dw	87,252,114,109,101,114
