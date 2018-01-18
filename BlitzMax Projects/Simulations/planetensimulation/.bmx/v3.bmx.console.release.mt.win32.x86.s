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
	extrn	_bbSin
	extrn	_bbStringFromInt
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
	sub	esp,8
	push	ebx
	push	esi
	push	edi
	cmp	dword [_87],0
	je	_88
	mov	eax,0
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_88:
	mov	dword [_87],1
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
	push	_bb_TObjekt
	call	_bbObjectRegisterType
	add	esp,4
	push	_brl_linkedlist_TList
	call	_bbObjectNew
	add	esp,4
	mov	dword [__bb_TObjekt_liste],eax
	push	0
	push	0
	push	0
	push	1176256512
	push	1112014848
	push	1157234688
	push	1157234688
	call	dword [_bb_TObjekt+48]
	add	esp,28
	push	1084227584
	push	0
	push	0
	push	1148846080
	push	1101004800
	push	1157234688
	push	1153138688
	call	dword [_bb_TObjekt+48]
	add	esp,28
	push	1092616192
	push	0
	push	0
	push	1120403456
	push	1092616192
	push	1157234688
	push	1152729088
	call	dword [_bb_TObjekt+48]
	add	esp,28
	push	-1063256064
	push	0
	push	0
	push	1148846080
	push	1101004800
	push	1157234688
	push	1159479296
	call	dword [_bb_TObjekt+48]
	add	esp,28
	push	-1054867456
	push	0
	push	0
	push	1120403456
	push	1092616192
	push	1157234688
	push	1159684096
	call	dword [_bb_TObjekt+48]
	add	esp,28
	push	0
	push	120
	push	0
	push	600
	push	800
	call	_brl_graphics_Graphics
	add	esp,20
	push	3
	call	_brl_max2d_SetBlend
	add	esp,4
	fld	dword [_116]
	fstp	dword [ebp-4]
_33:
	call	_brl_polledinput_MouseZSpeed
	mov	dword [ebp+-8],eax
	fild	dword [ebp+-8]
	fmul	dword [_119]
	fld	dword [ebp-4]
	faddp	st1,st0
	fstp	dword [ebp-4]
	call	_brl_max2d_Cls
	call	dword [_bb_TObjekt+60]
	mov	ebx,dword [__bb_TObjekt_liste]
	mov	eax,ebx
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+140]
	add	esp,4
	mov	edi,eax
	jmp	_34
_36:
	mov	eax,edi
	push	_bb_TObjekt
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+52]
	add	esp,4
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	mov	esi,eax
	cmp	esi,_bbNullObject
	je	_34
	push	255
	push	255
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	fld	dword [_120]
	fmul	dword [esi+16]
	fmul	dword [ebp-4]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [_121]
	fmul	dword [esi+16]
	fmul	dword [ebp-4]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [esi+24]
	fsub	dword [esi+16]
	fmul	dword [ebp-4]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [esi+20]
	fsub	dword [esi+16]
	fmul	dword [ebp-4]
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_DrawOval
	add	esp,16
	push	255
	push	0
	push	0
	call	_brl_max2d_SetColor
	add	esp,12
	fld	dword [esi+24]
	fmul	dword [ebp-4]
	fsub	dword [_122]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [esi+20]
	fmul	dword [ebp-4]
	fsub	dword [_123]
	sub	esp,4
	fstp	dword [esp]
	push	dword [esi+36]
	call	_bbStringFromInt
	add	esp,4
	push	eax
	call	_brl_max2d_DrawText
	add	esp,12
_34:
	mov	eax,edi
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_36
_35:
	push	-1
	call	_brl_graphics_Flip
	add	esp,4
_31:
	push	27
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_33
_32:
	mov	eax,0
	jmp	_56
_56:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TObjekt_New:
	push	ebp
	mov	ebp,esp
	push	ebx
	mov	ebx,dword [ebp+8]
	push	ebx
	call	_bbObjectCtor
	add	esp,4
	mov	dword [ebx],_bb_TObjekt
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
	fldz
	fstp	dword [ebx+32]
	mov	dword [ebx+36],0
	mov	eax,0
	jmp	_59
_59:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TObjekt_Create:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	_bb_TObjekt
	call	_bbObjectNew
	add	esp,4
	mov	ebx,eax
	mov	eax,dword [__bb_TObjekt_liste]
	push	ebx
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+68]
	add	esp,8
	add	dword [__bb_TObjekt_counter],1
	mov	eax,dword [__bb_TObjekt_counter]
	mov	dword [ebx+36],eax
	fld	dword [ebp+8]
	fstp	dword [ebx+20]
	fld	dword [ebp+12]
	fstp	dword [ebx+24]
	fld	dword [ebp+28]
	fstp	dword [ebx+28]
	fld	dword [ebp+32]
	fstp	dword [ebx+32]
	fld	dword [ebp+16]
	fstp	dword [ebx+16]
	fld	dword [ebp+20]
	fstp	dword [ebx+8]
	fld	dword [ebp+24]
	fstp	dword [ebx+12]
	mov	eax,ebx
	jmp	_68
_68:
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TObjekt_render_v_1:
	push	ebp
	mov	ebp,esp
	sub	esp,60
	push	ebx
	push	esi
	push	edi
	mov	esi,dword [ebp+8]
	mov	edi,dword [__bb_TObjekt_liste]
	mov	eax,edi
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+140]
	add	esp,4
	mov	dword [ebp-60],eax
	jmp	_22
_24:
	mov	eax,dword [ebp-60]
	push	_bb_TObjekt
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+52]
	add	esp,4
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	mov	ebx,eax
	cmp	ebx,_bbNullObject
	je	_22
	cmp	ebx,esi
	je	_97
	fld	qword [_133]
	sub	esp,8
	fstp	qword [esp]
	fld	qword [_134]
	sub	esp,8
	fstp	qword [esp]
	fld	dword [ebx+20]
	fsub	dword [esi+20]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-8]
	fld	qword [_135]
	sub	esp,8
	fstp	qword [esp]
	fld	dword [ebx+24]
	fsub	dword [esi+24]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [ebp-8]
	faddp	st1,st0
	fstp	qword [ebp-8]
	fld	qword [ebp-8]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	dword [ebp-48]
	fld	dword [ebx+20]
	fsub	dword [esi+20]
	sub	esp,8
	fstp	qword [esp]
	fld	dword [ebx+24]
	fsub	dword [esi+24]
	sub	esp,8
	fstp	qword [esp]
	call	_bbATan2
	add	esp,16
	fstp	dword [ebp-56]
	fld	dword [ebx+8]
	fmul	dword [esi+8]
	fstp	qword [ebp-16]
	fld	qword [_136]
	sub	esp,8
	fstp	qword [esp]
	fld	dword [ebp-48]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [ebp-16]
	fdivrp	st1,st0
	fstp	qword [ebp-16]
	fld	qword [ebp-16]
	fstp	dword [ebp-52]
	fld	dword [ebx+12]
	fchs
	fmul	dword [esi+12]
	fstp	qword [ebp-24]
	fld	qword [_137]
	sub	esp,8
	fstp	qword [esp]
	fld	dword [ebp-48]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [ebp-24]
	fdivrp	st1,st0
	fstp	qword [ebp-24]
	fld	qword [ebp-24]
	fstp	dword [ebp-44]
	fld	dword [esi+28]
	fstp	qword [ebp-32]
	fld	dword [ebp-56]
	sub	esp,8
	fstp	qword [esp]
	call	_bbCos
	add	esp,8
	fld	dword [ebp-52]
	fadd	dword [ebp-44]
	fmulp	st1,st0
	fld	dword [esi+8]
	fdivp	st1,st0
	fld	qword [ebp-32]
	faddp	st1,st0
	fstp	qword [ebp-32]
	fld	qword [ebp-32]
	fstp	dword [esi+28]
	fld	dword [esi+32]
	fstp	qword [ebp-40]
	fld	dword [ebp-56]
	sub	esp,8
	fstp	qword [esp]
	call	_bbSin
	add	esp,8
	fld	dword [ebp-52]
	fadd	dword [ebp-44]
	fmulp	st1,st0
	fld	dword [esi+8]
	fdivp	st1,st0
	fld	qword [ebp-40]
	faddp	st1,st0
	fstp	qword [ebp-40]
	fld	qword [ebp-40]
	fstp	dword [esi+32]
_97:
_22:
	mov	eax,dword [ebp-60]
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_24
_23:
	mov	eax,0
	jmp	_71
_71:
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_TObjekt_render_v_2:
	push	ebp
	mov	ebp,esp
	mov	eax,dword [ebp+8]
	fld	dword [eax+20]
	fadd	dword [eax+28]
	fstp	dword [eax+20]
	fld	dword [eax+24]
	fadd	dword [eax+32]
	fstp	dword [eax+24]
	mov	eax,0
	jmp	_74
_74:
	mov	esp,ebp
	pop	ebp
	ret
__bb_TObjekt_render:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	esi
	mov	esi,dword [__bb_TObjekt_liste]
	push	esi
	mov	eax,dword [esi]
	call	dword [eax+140]
	add	esp,4
	mov	ebx,eax
	jmp	_25
_27:
	push	_bb_TObjekt
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,4
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	cmp	eax,_bbNullObject
	je	_25
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+52]
	add	esp,4
_25:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_27
_26:
	mov	esi,dword [__bb_TObjekt_liste]
	push	esi
	mov	eax,dword [esi]
	call	dword [eax+140]
	add	esp,4
	mov	ebx,eax
	jmp	_28
_30:
	push	_bb_TObjekt
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+52]
	add	esp,4
	push	eax
	call	_bbObjectDowncast
	add	esp,8
	cmp	eax,_bbNullObject
	je	_28
	push	eax
	mov	eax,dword [eax]
	call	dword [eax+56]
	add	esp,4
_28:
	push	ebx
	mov	eax,dword [ebx]
	call	dword [eax+48]
	add	esp,4
	cmp	eax,0
	jne	_30
_29:
	mov	eax,0
	jmp	_76
_76:
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
	section	"data" data writeable align 8
	align	4
_87:
	dd	0
	align	4
__bb_TObjekt_liste:
	dd	_bbNullObject
	align	4
__bb_TObjekt_counter:
	dd	0
_38:
	db	"TObjekt",0
_39:
	db	"mass",0
_40:
	db	"f",0
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
_116:
	dd	0x3e4ccccd
	align	4
_119:
	dd	0x3ca3d70a
	align	4
_120:
	dd	0x40000000
	align	4
_121:
	dd	0x40000000
	align	4
_122:
	dd	0x40a00000
	align	4
_123:
	dd	0x40a00000
	align	8
_133:
	dd	0x0,0x3fe00000
	align	8
_134:
	dd	0x0,0x40000000
	align	8
_135:
	dd	0x0,0x40000000
	align	8
_136:
	dd	0x0,0x40000000
	align	8
_137:
	dd	0x0,0x40000000
