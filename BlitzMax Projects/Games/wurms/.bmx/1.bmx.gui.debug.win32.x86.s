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
	extrn	_bbOnDebugEnterScope
	extrn	_bbOnDebugEnterStm
	extrn	_bbOnDebugLeaveScope
	extrn	_bbStringClass
	extrn	_bbStringFromInt
	extrn	_brl_blitz_ArrayBoundsError
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
	push	ebx
	cmp	dword [_157],0
	je	_158
	mov	eax,0
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
_158:
	mov	dword [_157],1
	push	ebp
	push	_155
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
	push	_133
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_135
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_136
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [_139]
	and	eax,1
	cmp	eax,0
	jne	_140
	push	4
	push	100
	push	100
	push	3
	push	_137
	call	_bbArrayNew
	add	esp,20
	inc	dword [eax+4]
	mov	dword [__bb_LEVEL_map],eax
	or	dword [_139],1
_140:
	push	_bb_LEVEL
	call	_bbObjectRegisterType
	add	esp,4
	push	_141
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [_139]
	and	eax,2
	cmp	eax,0
	jne	_142
	mov	ecx,3
	mov	eax,dword [__bb_LEVEL_map_x]
	cdq
	idiv	ecx
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	fstp	dword [__bb_PLAYER_x_1]
	or	dword [_139],2
_142:
	push	_143
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_144
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [_139]
	and	eax,4
	cmp	eax,0
	jne	_145
	mov	ecx,3
	mov	eax,dword [__bb_LEVEL_map_x]
	cdq
	idiv	ecx
	shl	eax,1
	mov	dword [ebp+-4],eax
	fild	dword [ebp+-4]
	fstp	dword [__bb_PLAYER_x_2]
	or	dword [_139],4
_145:
	push	_146
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_147
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_148
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_PLAYER
	call	_bbObjectRegisterType
	add	esp,4
	push	_bb_WEAPON
	call	_bbObjectRegisterType
	add	esp,4
	push	_149
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_150
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	_bb_ANZEIGE
	call	_bbObjectRegisterType
	add	esp,4
	push	_151
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	600
	push	800
	call	dword [_bb_ANZEIGE+48]
	add	esp,8
	push	_152
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	300
	push	400
	call	dword [_bb_LEVEL+48]
	add	esp,12
	push	_153
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bb_LEVEL+52]
	push	_154
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	_bbEnd
	mov	ebx,0
	jmp	_81
_81:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_LEVEL_New:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_160
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	dword [ebp-4]
	call	_bbObjectCtor
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [eax],_bb_LEVEL
	push	ebp
	push	_159
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
	mov	ebx,0
	jmp	_84
_84:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_LEVEL_Delete:
	push	ebp
	mov	ebp,esp
_87:
	mov	eax,0
	jmp	_163
_163:
	mov	esp,ebp
	pop	ebp
	ret
__bb_LEVEL_Create:
	push	ebp
	mov	ebp,esp
	sub	esp,32
	push	ebx
	push	esi
	push	edi
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	eax,dword [ebp+12]
	mov	dword [ebp-8],eax
	mov	eax,dword [ebp+16]
	mov	dword [ebp-12],eax
	mov	dword [ebp-16],0
	mov	dword [ebp-20],0
	mov	dword [ebp-24],0
	mov	eax,ebp
	push	eax
	push	_264
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_164
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [__bb_LEVEL_map_x],eax
	push	_165
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-8]
	mov	dword [__bb_LEVEL_map_y],eax
	push	_166
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	4
	push	dword [__bb_LEVEL_map_y]
	push	dword [__bb_LEVEL_map_x]
	push	3
	push	_167
	call	_bbArrayNew
	add	esp,20
	mov	ebx,eax
	inc	dword [ebx+4]
	mov	eax,dword [__bb_LEVEL_map]
	dec	dword [eax+4]
	jnz	_171
	push	eax
	call	_bbGCFree
	add	esp,4
_171:
	mov	dword [__bb_LEVEL_map],ebx
	push	_172
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ecx,3
	mov	eax,dword [__bb_LEVEL_map_y]
	cdq
	idiv	ecx
	mov	dword [ebp-16],eax
	push	_174
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-20],0
	mov	dword [ebp-20],0
	mov	eax,dword [__bb_LEVEL_map_x]
	sub	eax,1
	mov	dword [ebp-32],eax
	jmp	_176
_24:
	mov	eax,ebp
	push	eax
	push	_262
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_178
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	2
	push	-2
	call	_brl_random_Rand
	add	esp,8
	add	dword [ebp-16],eax
	push	_179
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	cmp	dword [ebp-16],0
	jge	_180
	mov	eax,ebp
	push	eax
	push	_182
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_181
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-16],0
	call	dword [_bbOnDebugLeaveScope]
_180:
	push	_183
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [__bb_LEVEL_map_y]
	sub	eax,1
	cmp	dword [ebp-16],eax
	jle	_184
	mov	eax,ebp
	push	eax
	push	_186
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_185
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [__bb_LEVEL_map_y]
	sub	eax,1
	mov	dword [ebp-16],eax
	call	dword [_bbOnDebugLeaveScope]
_184:
	push	_187
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-24],0
	mov	dword [ebp-24],0
	mov	eax,dword [__bb_LEVEL_map_y]
	sub	eax,1
	mov	dword [ebp-28],eax
	jmp	_189
_27:
	mov	eax,ebp
	push	eax
	push	_260
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_191
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-16]
	cmp	dword [ebp-24],eax
	jl	_192
	mov	eax,ebp
	push	eax
	push	_225
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_193
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-20]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_195
	call	_brl_blitz_ArrayBoundsError
_195:
	mov	eax,dword [ebp-24]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_197
	call	_brl_blitz_ArrayBoundsError
_197:
	mov	ebx,0
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_199
	call	_brl_blitz_ArrayBoundsError
_199:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	byte [edx+32],100
	push	_201
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-20]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_203
	call	_brl_blitz_ArrayBoundsError
_203:
	mov	eax,dword [ebp-24]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_205
	call	_brl_blitz_ArrayBoundsError
_205:
	mov	ebx,1
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_207
	call	_brl_blitz_ArrayBoundsError
_207:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	ecx,edx
	mov	eax,dword [ebp-24]
	imul	eax,dword [ebp-20]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	eax,eax
	and	eax,0xff
	mov	eax,eax
	mov	byte [ecx+32],al
	push	_209
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-20]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_211
	call	_brl_blitz_ArrayBoundsError
_211:
	mov	eax,dword [ebp-24]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_213
	call	_brl_blitz_ArrayBoundsError
_213:
	mov	ebx,2
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_215
	call	_brl_blitz_ArrayBoundsError
_215:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	byte [edx+32],100
	push	_217
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-20]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_219
	call	_brl_blitz_ArrayBoundsError
_219:
	mov	eax,dword [ebp-24]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_221
	call	_brl_blitz_ArrayBoundsError
_221:
	mov	ebx,3
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_223
	call	_brl_blitz_ArrayBoundsError
_223:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	byte [edx+32],1
	call	dword [_bbOnDebugLeaveScope]
	jmp	_226
_192:
	mov	eax,ebp
	push	eax
	push	_259
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_227
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-20]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_229
	call	_brl_blitz_ArrayBoundsError
_229:
	mov	eax,dword [ebp-24]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_231
	call	_brl_blitz_ArrayBoundsError
_231:
	mov	ebx,0
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_233
	call	_brl_blitz_ArrayBoundsError
_233:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	byte [edx+32],10
	push	_235
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-20]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_237
	call	_brl_blitz_ArrayBoundsError
_237:
	mov	eax,dword [ebp-24]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_239
	call	_brl_blitz_ArrayBoundsError
_239:
	mov	ebx,1
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_241
	call	_brl_blitz_ArrayBoundsError
_241:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	byte [edx+32],0
	push	_243
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-20]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_245
	call	_brl_blitz_ArrayBoundsError
_245:
	mov	eax,dword [ebp-24]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_247
	call	_brl_blitz_ArrayBoundsError
_247:
	mov	ebx,2
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_249
	call	_brl_blitz_ArrayBoundsError
_249:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	byte [edx+32],0
	push	_251
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-20]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_253
	call	_brl_blitz_ArrayBoundsError
_253:
	mov	eax,dword [ebp-24]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_255
	call	_brl_blitz_ArrayBoundsError
_255:
	mov	ebx,3
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_257
	call	_brl_blitz_ArrayBoundsError
_257:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	byte [edx+32],0
	call	dword [_bbOnDebugLeaveScope]
_226:
	call	dword [_bbOnDebugLeaveScope]
_25:
	add	dword [ebp-24],1
_189:
	mov	eax,dword [ebp-28]
	cmp	dword [ebp-24],eax
	jle	_27
_26:
	call	dword [_bbOnDebugLeaveScope]
_22:
	add	dword [ebp-20],1
_176:
	mov	eax,dword [ebp-32]
	cmp	dword [ebp-20],eax
	jle	_24
_23:
	mov	ebx,0
	jmp	_92
_92:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_LEVEL_play:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	mov	dword [ebp-4],0
	push	ebp
	push	_290
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_267
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-4],0
	push	_269
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
_30:
_28:
	push	ebp
	push	_289
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_270
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	_brl_max2d_Cls
	push	_271
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bb_PLAYER+48]
	push	_272
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bb_PLAYER+52]
	push	_273
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bb_PLAYER+56]
	push	_274
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bb_PLAYER+60]
	push	_275
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	0
	push	0
	call	_brl_max2d_SetColor
	add	esp,12
	push	_276
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1142292480
	push	1092616192
	push	0
	push	1137016832
	call	_brl_max2d_DrawRect
	add	esp,16
	push	_277
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	32
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_278
	push	ebp
	push	_280
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_279
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	5
	push	2
	push	10
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_754]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	push	eax
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_755]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	push	eax
	call	dword [_bb_LEVEL+56]
	add	esp,20
	call	dword [_bbOnDebugLeaveScope]
_278:
	push	_281
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	add	dword [ebp-4],1
	push	_282
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	255
	push	255
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	_283
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	0
	mov	ecx,60
	mov	eax,dword [ebp-4]
	cdq
	idiv	ecx
	push	eax
	call	_bbStringFromInt
	add	esp,4
	push	eax
	call	_brl_max2d_DrawText
	add	esp,12
	push	_284
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	-1
	call	_brl_graphics_Flip
	add	esp,4
	push	_285
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	27
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_286
	push	ebp
	push	_288
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_287
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,0
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_94
_286:
	call	dword [_bbOnDebugLeaveScope]
	jmp	_30
_94:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_LEVEL_kreis:
	push	ebp
	mov	ebp,esp
	sub	esp,104
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
	mov	dword [ebp-24],0
	mov	dword [ebp-28],0
	mov	dword [ebp-32],0
	mov	dword [ebp-36],0
	mov	eax,ebp
	push	eax
	push	_458
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_291
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-16]
	cmp	eax,1
	je	_294
	cmp	eax,2
	je	_295
	jmp	_293
_294:
	mov	eax,ebp
	push	eax
	push	_357
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_296
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-24],0
	mov	eax,dword [ebp-12]
	neg	eax
	mov	dword [ebp-24],eax
	mov	eax,dword [ebp-12]
	mov	dword [ebp-96],eax
	jmp	_298
_33:
	mov	eax,ebp
	push	eax
	push	_356
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_300
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-24]
	add	eax,dword [ebp-4]
	cmp	eax,0
	jge	_301
	mov	eax,ebp
	push	eax
	push	_303
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_302
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_31
_301:
	push	_304
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	edx,dword [ebp-24]
	add	edx,dword [ebp-4]
	mov	eax,dword [__bb_LEVEL_map_x]
	sub	eax,1
	cmp	edx,eax
	jle	_305
	mov	eax,ebp
	push	eax
	push	_307
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_306
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_32
_305:
	push	_308
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-28],0
	mov	eax,dword [ebp-12]
	neg	eax
	mov	dword [ebp-28],eax
	mov	eax,dword [ebp-12]
	mov	dword [ebp-88],eax
	jmp	_310
_36:
	mov	eax,ebp
	push	eax
	push	_355
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_312
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-28]
	add	eax,dword [ebp-8]
	cmp	eax,0
	jge	_313
	mov	eax,ebp
	push	eax
	push	_315
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_314
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_34
_313:
	push	_316
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	edx,dword [ebp-28]
	add	edx,dword [ebp-8]
	mov	eax,dword [__bb_LEVEL_map_y]
	sub	eax,1
	cmp	edx,eax
	jle	_317
	mov	eax,ebp
	push	eax
	push	_319
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_318
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_35
_317:
	push	_320
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	qword [_761]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-12]
	mov	dword [ebp+-104],eax
	fild	dword [ebp+-104]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-84]
	fld	qword [_762]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-24]
	mov	dword [ebp+-104],eax
	fild	dword [ebp+-104]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-60]
	fld	qword [_763]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-28]
	mov	dword [ebp+-104],eax
	fild	dword [ebp+-104]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [ebp-60]
	faddp	st1,st0
	fstp	qword [ebp-60]
	fld	qword [ebp-60]
	fld	qword [ebp-84]
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_321
	mov	eax,ebp
	push	eax
	push	_354
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_322
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	add	eax,dword [ebp-24]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_324
	call	_brl_blitz_ArrayBoundsError
_324:
	mov	eax,dword [ebp-8]
	add	eax,dword [ebp-28]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_326
	call	_brl_blitz_ArrayBoundsError
_326:
	mov	ebx,0
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_328
	call	_brl_blitz_ArrayBoundsError
_328:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	byte [edx+32],0
	push	_330
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	add	eax,dword [ebp-24]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_332
	call	_brl_blitz_ArrayBoundsError
_332:
	mov	eax,dword [ebp-8]
	add	eax,dword [ebp-28]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_334
	call	_brl_blitz_ArrayBoundsError
_334:
	mov	ebx,1
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_336
	call	_brl_blitz_ArrayBoundsError
_336:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	byte [edx+32],0
	push	_338
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	add	eax,dword [ebp-24]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_340
	call	_brl_blitz_ArrayBoundsError
_340:
	mov	eax,dword [ebp-8]
	add	eax,dword [ebp-28]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_342
	call	_brl_blitz_ArrayBoundsError
_342:
	mov	ebx,2
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_344
	call	_brl_blitz_ArrayBoundsError
_344:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	byte [edx+32],0
	push	_346
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	add	eax,dword [ebp-24]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_348
	call	_brl_blitz_ArrayBoundsError
_348:
	mov	eax,dword [ebp-8]
	add	eax,dword [ebp-28]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_350
	call	_brl_blitz_ArrayBoundsError
_350:
	mov	ebx,3
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_352
	call	_brl_blitz_ArrayBoundsError
_352:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	byte [edx+32],0
	call	dword [_bbOnDebugLeaveScope]
_321:
	call	dword [_bbOnDebugLeaveScope]
_34:
	add	dword [ebp-28],1
_310:
	mov	eax,dword [ebp-88]
	cmp	dword [ebp-28],eax
	jle	_36
_35:
	call	dword [_bbOnDebugLeaveScope]
_31:
	add	dword [ebp-24],1
_298:
	mov	eax,dword [ebp-96]
	cmp	dword [ebp-24],eax
	jle	_33
_32:
	call	dword [_bbOnDebugLeaveScope]
	jmp	_293
_295:
	mov	eax,ebp
	push	eax
	push	_457
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_358
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-32],0
	mov	eax,dword [ebp-12]
	neg	eax
	sub	eax,dword [ebp-20]
	mov	dword [ebp-32],eax
	mov	eax,dword [ebp-12]
	add	eax,dword [ebp-20]
	mov	dword [ebp-100],eax
	jmp	_360
_39:
	mov	eax,ebp
	push	eax
	push	_456
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_362
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-32]
	add	eax,dword [ebp-4]
	cmp	eax,0
	jge	_363
	mov	eax,ebp
	push	eax
	push	_365
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_364
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_37
_363:
	push	_366
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	edx,dword [ebp-32]
	add	edx,dword [ebp-4]
	mov	eax,dword [__bb_LEVEL_map_x]
	sub	eax,1
	cmp	edx,eax
	jle	_367
	mov	eax,ebp
	push	eax
	push	_369
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_368
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_38
_367:
	push	_370
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-36],0
	mov	eax,dword [ebp-12]
	neg	eax
	sub	eax,dword [ebp-20]
	mov	dword [ebp-36],eax
	mov	eax,dword [ebp-12]
	add	eax,dword [ebp-20]
	mov	dword [ebp-92],eax
	jmp	_372
_42:
	mov	eax,ebp
	push	eax
	push	_455
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_374
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-36]
	add	eax,dword [ebp-8]
	cmp	eax,0
	jge	_375
	mov	eax,ebp
	push	eax
	push	_377
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_376
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_40
_375:
	push	_378
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	edx,dword [ebp-36]
	add	edx,dword [ebp-8]
	mov	eax,dword [__bb_LEVEL_map_y]
	sub	eax,1
	cmp	edx,eax
	jle	_379
	mov	eax,ebp
	push	eax
	push	_381
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_380
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_41
_379:
	push	_382
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	qword [_764]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-12]
	add	eax,dword [ebp-20]
	mov	dword [ebp+-104],eax
	fild	dword [ebp+-104]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-76]
	fld	qword [_765]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-32]
	mov	dword [ebp+-104],eax
	fild	dword [ebp+-104]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-52]
	fld	qword [_766]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-36]
	mov	dword [ebp+-104],eax
	fild	dword [ebp+-104]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [ebp-52]
	faddp	st1,st0
	fstp	qword [ebp-52]
	fld	qword [ebp-52]
	fld	qword [ebp-76]
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_383
	mov	eax,ebp
	push	eax
	push	_454
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_384
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	qword [_767]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-12]
	mov	dword [ebp+-104],eax
	fild	dword [ebp+-104]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-68]
	fld	qword [_768]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-32]
	mov	dword [ebp+-104],eax
	fild	dword [ebp+-104]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fstp	qword [ebp-44]
	fld	qword [_769]
	sub	esp,8
	fstp	qword [esp]
	mov	eax,dword [ebp-36]
	mov	dword [ebp+-104],eax
	fild	dword [ebp+-104]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatPow
	add	esp,16
	fld	qword [ebp-44]
	faddp	st1,st0
	fstp	qword [ebp-44]
	fld	qword [ebp-44]
	fld	qword [ebp-68]
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_385
	mov	eax,ebp
	push	eax
	push	_418
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_386
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	add	eax,dword [ebp-32]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_388
	call	_brl_blitz_ArrayBoundsError
_388:
	mov	eax,dword [ebp-8]
	add	eax,dword [ebp-36]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_390
	call	_brl_blitz_ArrayBoundsError
_390:
	mov	ebx,0
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_392
	call	_brl_blitz_ArrayBoundsError
_392:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	byte [edx+32],0
	push	_394
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	add	eax,dword [ebp-32]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_396
	call	_brl_blitz_ArrayBoundsError
_396:
	mov	eax,dword [ebp-8]
	add	eax,dword [ebp-36]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_398
	call	_brl_blitz_ArrayBoundsError
_398:
	mov	ebx,1
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_400
	call	_brl_blitz_ArrayBoundsError
_400:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	byte [edx+32],0
	push	_402
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	add	eax,dword [ebp-32]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_404
	call	_brl_blitz_ArrayBoundsError
_404:
	mov	eax,dword [ebp-8]
	add	eax,dword [ebp-36]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_406
	call	_brl_blitz_ArrayBoundsError
_406:
	mov	ebx,2
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_408
	call	_brl_blitz_ArrayBoundsError
_408:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	byte [edx+32],0
	push	_410
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	add	eax,dword [ebp-32]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_412
	call	_brl_blitz_ArrayBoundsError
_412:
	mov	eax,dword [ebp-8]
	add	eax,dword [ebp-36]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_414
	call	_brl_blitz_ArrayBoundsError
_414:
	mov	ebx,3
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_416
	call	_brl_blitz_ArrayBoundsError
_416:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	byte [edx+32],0
	call	dword [_bbOnDebugLeaveScope]
	jmp	_419
_385:
	mov	eax,ebp
	push	eax
	push	_453
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_420
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	add	eax,dword [ebp-32]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_422
	call	_brl_blitz_ArrayBoundsError
_422:
	mov	eax,dword [ebp-8]
	add	eax,dword [ebp-36]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_424
	call	_brl_blitz_ArrayBoundsError
_424:
	mov	ebx,3
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_426
	call	_brl_blitz_ArrayBoundsError
_426:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	cmp	eax,1
	jne	_427
	mov	eax,ebp
	push	eax
	push	_452
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_428
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	add	eax,dword [ebp-32]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_430
	call	_brl_blitz_ArrayBoundsError
_430:
	mov	eax,dword [ebp-8]
	add	eax,dword [ebp-36]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_432
	call	_brl_blitz_ArrayBoundsError
_432:
	mov	ebx,0
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_434
	call	_brl_blitz_ArrayBoundsError
_434:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	ebx,edx
	movzx	eax,byte [ebx+32]
	mov	dword [ebp+-104],eax
	fild	dword [ebp+-104]
	fmul	dword [_770]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	eax,eax
	and	eax,0xff
	mov	eax,eax
	mov	byte [ebx+32],al
	push	_436
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	add	eax,dword [ebp-32]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_438
	call	_brl_blitz_ArrayBoundsError
_438:
	mov	eax,dword [ebp-8]
	add	eax,dword [ebp-36]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_440
	call	_brl_blitz_ArrayBoundsError
_440:
	mov	ebx,1
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_442
	call	_brl_blitz_ArrayBoundsError
_442:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	ebx,edx
	movzx	eax,byte [ebx+32]
	mov	dword [ebp+-104],eax
	fild	dword [ebp+-104]
	fmul	dword [_771]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	eax,eax
	and	eax,0xff
	mov	eax,eax
	mov	byte [ebx+32],al
	push	_444
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	add	eax,dword [ebp-32]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_446
	call	_brl_blitz_ArrayBoundsError
_446:
	mov	eax,dword [ebp-8]
	add	eax,dword [ebp-36]
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_448
	call	_brl_blitz_ArrayBoundsError
_448:
	mov	ebx,2
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_450
	call	_brl_blitz_ArrayBoundsError
_450:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	add	edx,eax
	mov	ebx,edx
	movzx	eax,byte [ebx+32]
	mov	dword [ebp+-104],eax
	fild	dword [ebp+-104]
	fmul	dword [_772]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	eax,eax
	and	eax,0xff
	mov	eax,eax
	mov	byte [ebx+32],al
	call	dword [_bbOnDebugLeaveScope]
_427:
	call	dword [_bbOnDebugLeaveScope]
_419:
	call	dword [_bbOnDebugLeaveScope]
_383:
	call	dword [_bbOnDebugLeaveScope]
_40:
	add	dword [ebp-36],1
_372:
	mov	eax,dword [ebp-92]
	cmp	dword [ebp-36],eax
	jle	_42
_41:
	call	dword [_bbOnDebugLeaveScope]
_37:
	add	dword [ebp-32],1
_360:
	mov	eax,dword [ebp-100]
	cmp	dword [ebp-32],eax
	jle	_39
_38:
	call	dword [_bbOnDebugLeaveScope]
	jmp	_293
_293:
	mov	ebx,0
	jmp	_101
_101:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_PLAYER_New:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_464
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	dword [ebp-4]
	call	_bbObjectCtor
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [eax],_bb_PLAYER
	push	ebp
	push	_463
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
	mov	ebx,0
	jmp	_104
_104:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_PLAYER_Delete:
	push	ebp
	mov	ebp,esp
_107:
	mov	eax,0
	jmp	_466
_466:
	mov	esp,ebp
	pop	ebp
	ret
__bb_PLAYER_render_1:
	push	ebp
	mov	ebp,esp
	push	ebx
	push	esi
	push	edi
	mov	eax,ebp
	push	eax
	push	_528
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_467
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_837]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_469
	call	_brl_blitz_ArrayBoundsError
_469:
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_838]
	fadd	dword [_839]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_471
	call	_brl_blitz_ArrayBoundsError
_471:
	mov	ebx,3
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_473
	call	_brl_blitz_ArrayBoundsError
_473:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	cmp	eax,0
	jne	_474
	mov	eax,ebp
	push	eax
	push	_476
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_475
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_y_1]
	fadd	dword [_840]
	fstp	dword [__bb_PLAYER_y_1]
	call	dword [_bbOnDebugLeaveScope]
_474:
	push	_477
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_841]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_479
	call	_brl_blitz_ArrayBoundsError
_479:
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_842]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_481
	call	_brl_blitz_ArrayBoundsError
_481:
	mov	ebx,3
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_483
	call	_brl_blitz_ArrayBoundsError
_483:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	cmp	eax,1
	jne	_484
	mov	eax,ebp
	push	eax
	push	_486
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_485
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_y_1]
	fadd	dword [_843]
	fstp	dword [__bb_PLAYER_y_1]
	call	dword [_bbOnDebugLeaveScope]
_484:
	push	_487
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	65
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_494
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_844]
	fsub	dword [_845]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_489
	call	_brl_blitz_ArrayBoundsError
_489:
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_846]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_491
	call	_brl_blitz_ArrayBoundsError
_491:
	mov	ebx,3
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_493
	call	_brl_blitz_ArrayBoundsError
_493:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	cmp	eax,0
	sete	al
	movzx	eax,al
_494:
	cmp	eax,0
	je	_496
	mov	eax,ebp
	push	eax
	push	_498
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_497
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_x_1]
	fsub	dword [_847]
	fstp	dword [__bb_PLAYER_x_1]
	call	dword [_bbOnDebugLeaveScope]
_496:
	push	_499
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	68
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_506
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_848]
	fadd	dword [_849]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_501
	call	_brl_blitz_ArrayBoundsError
_501:
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_850]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_503
	call	_brl_blitz_ArrayBoundsError
_503:
	mov	ebx,3
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_505
	call	_brl_blitz_ArrayBoundsError
_505:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	cmp	eax,0
	sete	al
	movzx	eax,al
_506:
	cmp	eax,0
	je	_508
	mov	eax,ebp
	push	eax
	push	_510
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_509
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_x_1]
	fadd	dword [_851]
	fstp	dword [__bb_PLAYER_x_1]
	call	dword [_bbOnDebugLeaveScope]
_508:
	push	_511
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_d_y_1]
	fsub	dword [_852]
	fstp	dword [__bb_PLAYER_d_y_1]
	push	_512
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	87
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_519
	fld	dword [__bb_PLAYER_x_1]
	fdiv	dword [_853]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_514
	call	_brl_blitz_ArrayBoundsError
_514:
	fld	dword [__bb_PLAYER_y_1]
	fdiv	dword [_854]
	fadd	dword [_855]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_516
	call	_brl_blitz_ArrayBoundsError
_516:
	mov	ebx,3
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_518
	call	_brl_blitz_ArrayBoundsError
_518:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	cmp	eax,1
	sete	al
	movzx	eax,al
_519:
	cmp	eax,0
	je	_521
	mov	eax,ebp
	push	eax
	push	_523
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_522
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [_856]
	fstp	dword [__bb_PLAYER_d_y_1]
	call	dword [_bbOnDebugLeaveScope]
_521:
	push	_524
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_d_y_1]
	fldz
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_525
	mov	eax,ebp
	push	eax
	push	_527
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_526
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_y_1]
	fsub	dword [__bb_PLAYER_d_y_1]
	fstp	dword [__bb_PLAYER_y_1]
	call	dword [_bbOnDebugLeaveScope]
_525:
	mov	ebx,0
	jmp	_109
_109:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
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
	push	edi
	mov	eax,ebp
	push	eax
	push	_590
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_529
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_x_2]
	fdiv	dword [_883]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_531
	call	_brl_blitz_ArrayBoundsError
_531:
	fld	dword [__bb_PLAYER_y_2]
	fdiv	dword [_884]
	fadd	dword [_885]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_533
	call	_brl_blitz_ArrayBoundsError
_533:
	mov	ebx,3
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_535
	call	_brl_blitz_ArrayBoundsError
_535:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	cmp	eax,0
	jne	_536
	mov	eax,ebp
	push	eax
	push	_538
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_537
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_y_2]
	fadd	dword [_886]
	fstp	dword [__bb_PLAYER_y_2]
	call	dword [_bbOnDebugLeaveScope]
_536:
	push	_539
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_x_2]
	fdiv	dword [_887]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_541
	call	_brl_blitz_ArrayBoundsError
_541:
	fld	dword [__bb_PLAYER_y_2]
	fdiv	dword [_888]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_543
	call	_brl_blitz_ArrayBoundsError
_543:
	mov	ebx,3
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_545
	call	_brl_blitz_ArrayBoundsError
_545:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	cmp	eax,1
	jne	_546
	mov	eax,ebp
	push	eax
	push	_548
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_547
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_y_1]
	fadd	dword [_889]
	fstp	dword [__bb_PLAYER_y_1]
	call	dword [_bbOnDebugLeaveScope]
_546:
	push	_549
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	37
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_556
	fld	dword [__bb_PLAYER_x_2]
	fdiv	dword [_890]
	fsub	dword [_891]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_551
	call	_brl_blitz_ArrayBoundsError
_551:
	fld	dword [__bb_PLAYER_y_2]
	fdiv	dword [_892]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_553
	call	_brl_blitz_ArrayBoundsError
_553:
	mov	ebx,3
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_555
	call	_brl_blitz_ArrayBoundsError
_555:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	cmp	eax,0
	sete	al
	movzx	eax,al
_556:
	cmp	eax,0
	je	_558
	mov	eax,ebp
	push	eax
	push	_560
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_559
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_x_2]
	fsub	dword [_893]
	fstp	dword [__bb_PLAYER_x_2]
	call	dword [_bbOnDebugLeaveScope]
_558:
	push	_561
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	39
	call	_brl_polledinput_KeyDown
	add	esp,4
	cmp	eax,0
	je	_568
	fld	dword [__bb_PLAYER_x_2]
	fdiv	dword [_894]
	fadd	dword [_895]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_563
	call	_brl_blitz_ArrayBoundsError
_563:
	fld	dword [__bb_PLAYER_y_2]
	fdiv	dword [_896]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_565
	call	_brl_blitz_ArrayBoundsError
_565:
	mov	ebx,3
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_567
	call	_brl_blitz_ArrayBoundsError
_567:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	cmp	eax,0
	sete	al
	movzx	eax,al
_568:
	cmp	eax,0
	je	_570
	mov	eax,ebp
	push	eax
	push	_572
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_571
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_x_2]
	fadd	dword [_897]
	fstp	dword [__bb_PLAYER_x_2]
	call	dword [_bbOnDebugLeaveScope]
_570:
	push	_573
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_d_y_2]
	fsub	dword [_898]
	fstp	dword [__bb_PLAYER_d_y_2]
	push	_574
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	38
	call	_brl_polledinput_KeyHit
	add	esp,4
	cmp	eax,0
	je	_581
	fld	dword [__bb_PLAYER_x_2]
	fdiv	dword [_899]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_576
	call	_brl_blitz_ArrayBoundsError
_576:
	fld	dword [__bb_PLAYER_y_2]
	fdiv	dword [_900]
	fadd	dword [_901]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_578
	call	_brl_blitz_ArrayBoundsError
_578:
	mov	ebx,3
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_580
	call	_brl_blitz_ArrayBoundsError
_580:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	cmp	eax,1
	sete	al
	movzx	eax,al
_581:
	cmp	eax,0
	je	_583
	mov	eax,ebp
	push	eax
	push	_585
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_584
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [_902]
	fstp	dword [__bb_PLAYER_d_y_2]
	call	dword [_bbOnDebugLeaveScope]
_583:
	push	_586
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_d_y_2]
	fldz
	fxch	st1
	fucompp
	fnstsw	ax
	sahf
	setbe	al
	movzx	eax,al
	cmp	eax,0
	jne	_587
	mov	eax,ebp
	push	eax
	push	_589
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_588
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	fld	dword [__bb_PLAYER_y_2]
	fsub	dword [__bb_PLAYER_d_y_2]
	fstp	dword [__bb_PLAYER_y_2]
	call	dword [_bbOnDebugLeaveScope]
_587:
	mov	ebx,0
	jmp	_111
_111:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_PLAYER_draw_screen_1:
	push	ebp
	mov	ebp,esp
	sub	esp,44
	push	ebx
	push	esi
	push	edi
	mov	dword [ebp-4],0
	mov	dword [ebp-8],0
	mov	eax,ebp
	push	eax
	push	_642
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_591
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	600
	push	400
	push	0
	push	0
	call	_brl_max2d_SetViewport
	add	esp,16
	push	_592
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-4],0
	fld	dword [__bb_PLAYER_x_1]
	fsub	dword [_929]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	dword [ebp-4],eax
	fld	dword [__bb_PLAYER_x_1]
	fadd	dword [_930]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	dword [ebp-40],eax
	jmp	_594
_45:
	mov	eax,ebp
	push	eax
	push	_637
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_596
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map_x]
	sub	edx,1
	cmp	eax,edx
	jle	_597
	mov	eax,ebp
	push	eax
	push	_599
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_598
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_43
_597:
	push	_600
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	cmp	eax,0
	jge	_601
	mov	eax,ebp
	push	eax
	push	_603
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_602
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_43
_601:
	push	_604
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-8],0
	fld	dword [__bb_PLAYER_y_1]
	fsub	dword [_931]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	dword [ebp-8],eax
	fld	dword [__bb_PLAYER_y_1]
	fadd	dword [_932]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	dword [ebp-36],eax
	jmp	_606
_48:
	mov	eax,ebp
	push	eax
	push	_636
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_608
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-8]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map_y]
	sub	edx,1
	cmp	eax,edx
	jle	_609
	mov	eax,ebp
	push	eax
	push	_611
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_610
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_47
_609:
	push	_612
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-8]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	cmp	eax,0
	jge	_613
	mov	eax,ebp
	push	eax
	push	_615
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_614
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_46
_613:
	push	_616
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	dword [ebp-32],eax
	mov	eax,dword [__bb_LEVEL_map]
	mov	eax,dword [eax+20]
	cmp	dword [ebp-32],eax
	jb	_618
	call	_brl_blitz_ArrayBoundsError
_618:
	mov	eax,dword [ebp-8]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	dword [ebp-28],eax
	mov	eax,dword [__bb_LEVEL_map]
	mov	eax,dword [eax+24]
	cmp	dword [ebp-28],eax
	jb	_620
	call	_brl_blitz_ArrayBoundsError
_620:
	mov	dword [ebp-24],0
	mov	eax,dword [__bb_LEVEL_map]
	mov	eax,dword [eax+28]
	cmp	dword [ebp-24],eax
	jb	_622
	call	_brl_blitz_ArrayBoundsError
_622:
	mov	eax,dword [ebp-4]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	dword [ebp-20],eax
	mov	eax,dword [__bb_LEVEL_map]
	mov	eax,dword [eax+20]
	cmp	dword [ebp-20],eax
	jb	_624
	call	_brl_blitz_ArrayBoundsError
_624:
	mov	eax,dword [ebp-8]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	dword [ebp-16],eax
	mov	eax,dword [__bb_LEVEL_map]
	mov	eax,dword [eax+24]
	cmp	dword [ebp-16],eax
	jb	_626
	call	_brl_blitz_ArrayBoundsError
_626:
	mov	dword [ebp-12],1
	mov	eax,dword [__bb_LEVEL_map]
	mov	eax,dword [eax+28]
	cmp	dword [ebp-12],eax
	jb	_628
	call	_brl_blitz_ArrayBoundsError
_628:
	mov	eax,dword [ebp-4]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_630
	call	_brl_blitz_ArrayBoundsError
_630:
	mov	eax,dword [ebp-8]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_632
	call	_brl_blitz_ArrayBoundsError
_632:
	mov	ebx,2
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_634
	call	_brl_blitz_ArrayBoundsError
_634:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	push	eax
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,dword [ebp-20]
	add	eax,dword [ebp-16]
	add	eax,dword [ebp-12]
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	push	eax
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,dword [ebp-32]
	add	eax,dword [ebp-28]
	add	eax,dword [ebp-24]
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	push	eax
	call	_brl_max2d_SetColor
	add	esp,12
	push	_635
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1082130432
	push	1082130432
	mov	eax,dword [ebp-8]
	mov	dword [ebp+-44],eax
	fild	dword [ebp+-44]
	fld	dword [__bb_PLAYER_y_1]
	fsub	dword [_933]
	fsubp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	mov	eax,dword [ebp-4]
	mov	dword [ebp+-44],eax
	fild	dword [ebp+-44]
	fld	dword [__bb_PLAYER_x_1]
	fsub	dword [_934]
	fsubp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_DrawRect
	add	esp,16
	call	dword [_bbOnDebugLeaveScope]
_46:
	add	dword [ebp-8],4
_606:
	mov	eax,dword [ebp-36]
	cmp	dword [ebp-8],eax
	jle	_48
_47:
	call	dword [_bbOnDebugLeaveScope]
_43:
	add	dword [ebp-4],4
_594:
	mov	eax,dword [ebp-40]
	cmp	dword [ebp-4],eax
	jle	_45
_44:
	push	_638
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	0
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	_639
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1101004800
	push	1092616192
	push	1133576192
	push	1128464384
	call	_brl_max2d_DrawRect
	add	esp,16
	push	_640
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	255
	push	0
	call	_brl_max2d_SetColor
	add	esp,12
	push	_641
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1101004800
	push	1092616192
	fld	dword [__bb_PLAYER_y_2]
	fsub	dword [__bb_PLAYER_y_1]
	fadd	dword [_935]
	fsub	dword [_936]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [__bb_PLAYER_x_2]
	fsub	dword [__bb_PLAYER_x_1]
	fadd	dword [_937]
	fsub	dword [_938]
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_DrawRect
	add	esp,16
	mov	ebx,0
	jmp	_113
_113:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_PLAYER_draw_screen_2:
	push	ebp
	mov	ebp,esp
	sub	esp,44
	push	ebx
	push	esi
	push	edi
	mov	dword [ebp-4],0
	mov	dword [ebp-8],0
	mov	eax,ebp
	push	eax
	push	_695
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_643
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	600
	push	400
	push	0
	push	400
	call	_brl_max2d_SetViewport
	add	esp,16
	push	_644
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-4],0
	fld	dword [__bb_PLAYER_x_2]
	fsub	dword [_958]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	dword [ebp-4],eax
	fld	dword [__bb_PLAYER_x_2]
	fadd	dword [_959]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	dword [ebp-40],eax
	jmp	_646
_51:
	mov	eax,ebp
	push	eax
	push	_689
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_648
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map_x]
	sub	edx,1
	cmp	eax,edx
	jle	_649
	mov	eax,ebp
	push	eax
	push	_651
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_650
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_49
_649:
	push	_652
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	cmp	eax,0
	jge	_653
	mov	eax,ebp
	push	eax
	push	_655
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_654
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_49
_653:
	push	_656
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	dword [ebp-8],0
	fld	dword [__bb_PLAYER_y_2]
	fsub	dword [_960]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	dword [ebp-8],eax
	fld	dword [__bb_PLAYER_y_2]
	fadd	dword [_961]
	sub	esp,8
	fstp	qword [esp]
	call	_bbFloatToInt
	add	esp,8
	mov	dword [ebp-36],eax
	jmp	_658
_54:
	mov	eax,ebp
	push	eax
	push	_688
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_660
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-8]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map_y]
	sub	edx,1
	cmp	eax,edx
	jle	_661
	mov	eax,ebp
	push	eax
	push	_663
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_662
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_53
_661:
	push	_664
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-8]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	cmp	eax,0
	jge	_665
	mov	eax,ebp
	push	eax
	push	_667
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_666
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	call	dword [_bbOnDebugLeaveScope]
	call	dword [_bbOnDebugLeaveScope]
	jmp	_52
_665:
	push	_668
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	dword [ebp-32],eax
	mov	eax,dword [__bb_LEVEL_map]
	mov	eax,dword [eax+20]
	cmp	dword [ebp-32],eax
	jb	_670
	call	_brl_blitz_ArrayBoundsError
_670:
	mov	eax,dword [ebp-8]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	dword [ebp-28],eax
	mov	eax,dword [__bb_LEVEL_map]
	mov	eax,dword [eax+24]
	cmp	dword [ebp-28],eax
	jb	_672
	call	_brl_blitz_ArrayBoundsError
_672:
	mov	dword [ebp-24],0
	mov	eax,dword [__bb_LEVEL_map]
	mov	eax,dword [eax+28]
	cmp	dword [ebp-24],eax
	jb	_674
	call	_brl_blitz_ArrayBoundsError
_674:
	mov	eax,dword [ebp-4]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	dword [ebp-20],eax
	mov	eax,dword [__bb_LEVEL_map]
	mov	eax,dword [eax+20]
	cmp	dword [ebp-20],eax
	jb	_676
	call	_brl_blitz_ArrayBoundsError
_676:
	mov	eax,dword [ebp-8]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	dword [ebp-16],eax
	mov	eax,dword [__bb_LEVEL_map]
	mov	eax,dword [eax+24]
	cmp	dword [ebp-16],eax
	jb	_678
	call	_brl_blitz_ArrayBoundsError
_678:
	mov	dword [ebp-12],1
	mov	eax,dword [__bb_LEVEL_map]
	mov	eax,dword [eax+28]
	cmp	dword [ebp-12],eax
	jb	_680
	call	_brl_blitz_ArrayBoundsError
_680:
	mov	eax,dword [ebp-4]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+24]
	mov	edi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	edi,dword [eax+20]
	jb	_682
	call	_brl_blitz_ArrayBoundsError
_682:
	mov	eax,dword [ebp-8]
	cdq
	and	edx,3
	add	eax,edx
	sar	eax,2
	mov	edx,dword [__bb_LEVEL_map]
	imul	eax,dword [edx+28]
	mov	esi,eax
	mov	eax,dword [__bb_LEVEL_map]
	cmp	esi,dword [eax+24]
	jb	_684
	call	_brl_blitz_ArrayBoundsError
_684:
	mov	ebx,2
	mov	eax,dword [__bb_LEVEL_map]
	cmp	ebx,dword [eax+28]
	jb	_686
	call	_brl_blitz_ArrayBoundsError
_686:
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,edi
	add	eax,esi
	add	eax,ebx
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	push	eax
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,dword [ebp-20]
	add	eax,dword [ebp-16]
	add	eax,dword [ebp-12]
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	push	eax
	mov	edx,dword [__bb_LEVEL_map]
	mov	eax,dword [ebp-32]
	add	eax,dword [ebp-28]
	add	eax,dword [ebp-24]
	movzx	eax,byte [edx+eax+32]
	mov	eax,eax
	push	eax
	call	_brl_max2d_SetColor
	add	esp,12
	push	_687
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1082130432
	push	1082130432
	mov	eax,dword [ebp-8]
	mov	dword [ebp+-44],eax
	fild	dword [ebp+-44]
	fld	dword [__bb_PLAYER_y_2]
	fsub	dword [_962]
	fsubp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	fld	dword [_963]
	mov	eax,dword [ebp-4]
	mov	dword [ebp+-44],eax
	fild	dword [ebp+-44]
	fld	dword [__bb_PLAYER_x_2]
	fsub	dword [_964]
	fsubp	st1,st0
	faddp	st1,st0
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_DrawRect
	add	esp,16
	call	dword [_bbOnDebugLeaveScope]
_52:
	add	dword [ebp-8],4
_658:
	mov	eax,dword [ebp-36]
	cmp	dword [ebp-8],eax
	jle	_54
_53:
	call	dword [_bbOnDebugLeaveScope]
_49:
	add	dword [ebp-4],4
_646:
	mov	eax,dword [ebp-40]
	cmp	dword [ebp-4],eax
	jle	_51
_50:
	push	_690
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	255
	push	0
	call	_brl_max2d_SetColor
	add	esp,12
	push	_691
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1101004800
	push	1092616192
	push	1133576192
	push	1142210560
	call	_brl_max2d_DrawRect
	add	esp,16
	push	_692
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	0
	push	255
	call	_brl_max2d_SetColor
	add	esp,12
	push	_693
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	1101004800
	push	1092616192
	fld	dword [__bb_PLAYER_y_1]
	fsub	dword [__bb_PLAYER_y_2]
	fadd	dword [_965]
	fsub	dword [_966]
	sub	esp,4
	fstp	dword [esp]
	fld	dword [__bb_PLAYER_x_1]
	fsub	dword [__bb_PLAYER_x_2]
	fadd	dword [_967]
	fsub	dword [_968]
	fadd	dword [_969]
	sub	esp,4
	fstp	dword [esp]
	call	_brl_max2d_DrawRect
	add	esp,16
	push	_694
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	600
	push	800
	push	0
	push	0
	call	_brl_max2d_SetViewport
	add	esp,16
	mov	ebx,0
	jmp	_115
_115:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	edi
	pop	esi
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_WEAPON_New:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_697
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	dword [ebp-4]
	call	_bbObjectCtor
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [eax],_bb_WEAPON
	push	ebp
	push	_696
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
	mov	ebx,0
	jmp	_118
_118:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_WEAPON_Delete:
	push	ebp
	mov	ebp,esp
_121:
	mov	eax,0
	jmp	_699
_699:
	mov	esp,ebp
	pop	ebp
	ret
__bb_ANZEIGE_New:
	push	ebp
	mov	ebp,esp
	sub	esp,4
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	push	ebp
	push	_701
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	dword [ebp-4]
	call	_bbObjectCtor
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [eax],_bb_ANZEIGE
	push	ebp
	push	_700
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	call	dword [_bbOnDebugLeaveScope]
	mov	ebx,0
	jmp	_124
_124:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
__bb_ANZEIGE_Delete:
	push	ebp
	mov	ebp,esp
_127:
	mov	eax,0
	jmp	_703
_703:
	mov	esp,ebp
	pop	ebp
	ret
__bb_ANZEIGE_ini:
	push	ebp
	mov	ebp,esp
	sub	esp,8
	push	ebx
	mov	eax,dword [ebp+8]
	mov	dword [ebp-4],eax
	mov	eax,dword [ebp+12]
	mov	dword [ebp-8],eax
	push	ebp
	push	_714
	call	dword [_bbOnDebugEnterScope]
	add	esp,8
	push	_704
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-4]
	mov	dword [__bb_ANZEIGE_x],eax
	push	_705
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	eax,dword [ebp-8]
	mov	dword [__bb_ANZEIGE_y],eax
	push	_706
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	mov	ebx,_55
	inc	dword [ebx+4]
	mov	eax,dword [_bbAppTitle]
	dec	dword [eax+4]
	jnz	_710
	push	eax
	call	_bbGCFree
	add	esp,4
_710:
	mov	dword [_bbAppTitle],ebx
	push	_711
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	60
	push	0
	push	dword [ebp-8]
	push	dword [ebp-4]
	call	_brl_graphics_Graphics
	add	esp,20
	push	_712
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	0
	push	0
	push	0
	call	_brl_max2d_SetClsColor
	add	esp,12
	push	_713
	call	dword [_bbOnDebugEnterStm]
	add	esp,4
	push	3
	call	_brl_max2d_SetBlend
	add	esp,4
	mov	ebx,0
	jmp	_131
_131:
	call	dword [_bbOnDebugLeaveScope]
	mov	eax,ebx
	pop	ebx
	mov	esp,ebp
	pop	ebp
	ret
	section	"data" data writeable align 8
	align	4
_157:
	dd	0
_156:
	db	"1",0
	align	4
_155:
	dd	1
	dd	_156
	dd	0
_134:
	db	"C:/Users/Emanuel/Documents/Projekte/BMX/wurms/1.bmx",0
	align	4
_133:
	dd	_134
	dd	5
	dd	2
	align	4
__bb_LEVEL_map_x:
	dd	800
	align	4
_135:
	dd	_134
	dd	6
	dd	2
	align	4
__bb_LEVEL_map_y:
	dd	800
	align	4
_136:
	dd	_134
	dd	7
	dd	2
	align	4
_139:
	dd	0
_137:
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
_141:
	dd	_134
	dd	132
	dd	2
	align	4
__bb_PLAYER_x_1:
	dd	0x0
	align	4
_143:
	dd	_134
	dd	133
	dd	2
	align	4
__bb_PLAYER_y_1:
	dd	0x42c80000
	align	4
_144:
	dd	_134
	dd	134
	dd	2
	align	4
__bb_PLAYER_x_2:
	dd	0x0
	align	4
_146:
	dd	_134
	dd	135
	dd	2
	align	4
__bb_PLAYER_y_2:
	dd	0x42c80000
	align	4
_147:
	dd	_134
	dd	137
	dd	2
	align	4
__bb_PLAYER_d_y_1:
	dd	0x0
	align	4
_148:
	dd	_134
	dd	138
	dd	2
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
_149:
	dd	_134
	dd	223
	dd	2
	align	4
__bb_ANZEIGE_x:
	dd	0
	align	4
_150:
	dd	_134
	dd	224
	dd	2
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
	align	4
_151:
	dd	_134
	dd	235
	dd	1
	align	4
_152:
	dd	_134
	dd	236
	dd	1
	align	4
_153:
	dd	_134
	dd	237
	dd	1
	align	4
_154:
	dd	_134
	dd	239
	dd	1
_161:
	db	"Self",0
_162:
	db	":LEVEL",0
	align	4
_160:
	dd	1
	dd	_61
	dd	2
	dd	_161
	dd	_162
	dd	-4
	dd	0
	align	4
_159:
	dd	3
	dd	0
	dd	0
_263:
	db	"x",0
_261:
	db	"y",0
_265:
	db	"art",0
_266:
	db	"my",0
	align	4
_264:
	dd	1
	dd	_64
	dd	2
	dd	_263
	dd	_59
	dd	-4
	dd	2
	dd	_261
	dd	_59
	dd	-8
	dd	2
	dd	_265
	dd	_59
	dd	-12
	dd	2
	dd	_266
	dd	_59
	dd	-16
	dd	0
	align	4
_164:
	dd	_134
	dd	12
	dd	3
	align	4
_165:
	dd	_134
	dd	13
	dd	3
	align	4
_166:
	dd	_134
	dd	15
	dd	3
_167:
	db	"b",0
	align	4
_172:
	dd	_134
	dd	19
	dd	3
	align	4
_174:
	dd	_134
	dd	21
	dd	3
	align	4
_262:
	dd	3
	dd	0
	dd	2
	dd	_263
	dd	_59
	dd	-20
	dd	0
	align	4
_178:
	dd	_134
	dd	22
	dd	4
	align	4
_179:
	dd	_134
	dd	23
	dd	4
	align	4
_182:
	dd	3
	dd	0
	dd	0
	align	4
_181:
	dd	_134
	dd	23
	dd	17
	align	4
_183:
	dd	_134
	dd	24
	dd	4
	align	4
_186:
	dd	3
	dd	0
	dd	0
	align	4
_185:
	dd	_134
	dd	24
	dd	29
	align	4
_187:
	dd	_134
	dd	26
	dd	4
	align	4
_260:
	dd	3
	dd	0
	dd	2
	dd	_261
	dd	_59
	dd	-24
	dd	0
	align	4
_191:
	dd	_134
	dd	27
	dd	5
	align	4
_225:
	dd	3
	dd	0
	dd	0
	align	4
_193:
	dd	_134
	dd	28
	dd	6
	align	4
_201:
	dd	_134
	dd	29
	dd	6
	align	4
_209:
	dd	_134
	dd	30
	dd	6
	align	4
_217:
	dd	_134
	dd	31
	dd	6
	align	4
_259:
	dd	3
	dd	0
	dd	0
	align	4
_227:
	dd	_134
	dd	33
	dd	6
	align	4
_235:
	dd	_134
	dd	34
	dd	6
	align	4
_243:
	dd	_134
	dd	35
	dd	6
	align	4
_251:
	dd	_134
	dd	36
	dd	6
	align	4
_290:
	dd	1
	dd	_66
	dd	2
	dd	_59
	dd	_59
	dd	-4
	dd	0
	align	4
_267:
	dd	_134
	dd	44
	dd	3
	align	4
_269:
	dd	_134
	dd	80
	dd	3
	align	4
_289:
	dd	3
	dd	0
	dd	0
	align	4
_270:
	dd	_134
	dd	47
	dd	4
	align	4
_271:
	dd	_134
	dd	63
	dd	4
	align	4
_272:
	dd	_134
	dd	64
	dd	4
	align	4
_273:
	dd	_134
	dd	66
	dd	4
	align	4
_274:
	dd	_134
	dd	67
	dd	4
	align	4
_275:
	dd	_134
	dd	69
	dd	4
	align	4
_276:
	dd	_134
	dd	70
	dd	4
	align	4
_277:
	dd	_134
	dd	72
	dd	4
	align	4
_280:
	dd	3
	dd	0
	dd	0
	align	4
_279:
	dd	_134
	dd	72
	dd	30
	align	4
_754:
	dd	0x40800000
	align	4
_755:
	dd	0x40800000
	align	4
_281:
	dd	_134
	dd	74
	dd	4
	align	4
_282:
	dd	_134
	dd	75
	dd	4
	align	4
_283:
	dd	_134
	dd	76
	dd	4
	align	4
_284:
	dd	_134
	dd	77
	dd	4
	align	4
_285:
	dd	_134
	dd	79
	dd	4
	align	4
_288:
	dd	3
	dd	0
	dd	0
	align	4
_287:
	dd	_134
	dd	79
	dd	31
_459:
	db	"xx",0
_460:
	db	"yy",0
_461:
	db	"d",0
_462:
	db	"d2",0
	align	4
_458:
	dd	1
	dd	_67
	dd	2
	dd	_459
	dd	_59
	dd	-4
	dd	2
	dd	_460
	dd	_59
	dd	-8
	dd	2
	dd	_461
	dd	_59
	dd	-12
	dd	2
	dd	_265
	dd	_59
	dd	-16
	dd	2
	dd	_462
	dd	_59
	dd	-20
	dd	0
	align	4
_291:
	dd	_134
	dd	85
	dd	3
	align	4
_357:
	dd	3
	dd	0
	dd	0
	align	4
_296:
	dd	_134
	dd	88
	dd	5
	align	4
_356:
	dd	3
	dd	0
	dd	2
	dd	_263
	dd	_59
	dd	-24
	dd	0
	align	4
_300:
	dd	_134
	dd	89
	dd	6
	align	4
_303:
	dd	3
	dd	0
	dd	0
	align	4
_302:
	dd	_134
	dd	89
	dd	21
	align	4
_304:
	dd	_134
	dd	90
	dd	6
	align	4
_307:
	dd	3
	dd	0
	dd	0
	align	4
_306:
	dd	_134
	dd	90
	dd	33
	align	4
_308:
	dd	_134
	dd	91
	dd	6
	align	4
_355:
	dd	3
	dd	0
	dd	2
	dd	_261
	dd	_59
	dd	-28
	dd	0
	align	4
_312:
	dd	_134
	dd	92
	dd	7
	align	4
_315:
	dd	3
	dd	0
	dd	0
	align	4
_314:
	dd	_134
	dd	92
	dd	22
	align	4
_316:
	dd	_134
	dd	93
	dd	7
	align	4
_319:
	dd	3
	dd	0
	dd	0
	align	4
_318:
	dd	_134
	dd	93
	dd	29
	align	4
_320:
	dd	_134
	dd	94
	dd	7
	align	8
_761:
	dd	0x0,0x40000000
	align	8
_762:
	dd	0x0,0x40000000
	align	8
_763:
	dd	0x0,0x40000000
	align	4
_354:
	dd	3
	dd	0
	dd	0
	align	4
_322:
	dd	_134
	dd	95
	dd	8
	align	4
_330:
	dd	_134
	dd	96
	dd	8
	align	4
_338:
	dd	_134
	dd	97
	dd	8
	align	4
_346:
	dd	_134
	dd	98
	dd	8
	align	4
_457:
	dd	3
	dd	0
	dd	0
	align	4
_358:
	dd	_134
	dd	104
	dd	5
	align	4
_456:
	dd	3
	dd	0
	dd	2
	dd	_263
	dd	_59
	dd	-32
	dd	0
	align	4
_362:
	dd	_134
	dd	105
	dd	6
	align	4
_365:
	dd	3
	dd	0
	dd	0
	align	4
_364:
	dd	_134
	dd	105
	dd	21
	align	4
_366:
	dd	_134
	dd	106
	dd	6
	align	4
_369:
	dd	3
	dd	0
	dd	0
	align	4
_368:
	dd	_134
	dd	106
	dd	33
	align	4
_370:
	dd	_134
	dd	107
	dd	6
	align	4
_455:
	dd	3
	dd	0
	dd	2
	dd	_261
	dd	_59
	dd	-36
	dd	0
	align	4
_374:
	dd	_134
	dd	108
	dd	7
	align	4
_377:
	dd	3
	dd	0
	dd	0
	align	4
_376:
	dd	_134
	dd	108
	dd	22
	align	4
_378:
	dd	_134
	dd	109
	dd	7
	align	4
_381:
	dd	3
	dd	0
	dd	0
	align	4
_380:
	dd	_134
	dd	109
	dd	29
	align	4
_382:
	dd	_134
	dd	110
	dd	7
	align	8
_764:
	dd	0x0,0x40000000
	align	8
_765:
	dd	0x0,0x40000000
	align	8
_766:
	dd	0x0,0x40000000
	align	4
_454:
	dd	3
	dd	0
	dd	0
	align	4
_384:
	dd	_134
	dd	111
	dd	8
	align	8
_767:
	dd	0x0,0x40000000
	align	8
_768:
	dd	0x0,0x40000000
	align	8
_769:
	dd	0x0,0x40000000
	align	4
_418:
	dd	3
	dd	0
	dd	0
	align	4
_386:
	dd	_134
	dd	112
	dd	9
	align	4
_394:
	dd	_134
	dd	113
	dd	9
	align	4
_402:
	dd	_134
	dd	114
	dd	9
	align	4
_410:
	dd	_134
	dd	115
	dd	9
	align	4
_453:
	dd	3
	dd	0
	dd	0
	align	4
_420:
	dd	_134
	dd	117
	dd	9
	align	4
_452:
	dd	3
	dd	0
	dd	0
	align	4
_428:
	dd	_134
	dd	118
	dd	10
	align	4
_770:
	dd	0x3f000000
	align	4
_436:
	dd	_134
	dd	119
	dd	10
	align	4
_771:
	dd	0x3ecccccd
	align	4
_444:
	dd	_134
	dd	120
	dd	10
	align	4
_772:
	dd	0x3e4ccccd
_465:
	db	":PLAYER",0
	align	4
_464:
	dd	1
	dd	_61
	dd	2
	dd	_161
	dd	_465
	dd	-4
	dd	0
	align	4
_463:
	dd	3
	dd	0
	dd	0
	align	4
_528:
	dd	1
	dd	_71
	dd	0
	align	4
_467:
	dd	_134
	dd	141
	dd	3
	align	4
_837:
	dd	0x40800000
	align	4
_838:
	dd	0x40800000
	align	4
_839:
	dd	0x40000000
	align	4
_476:
	dd	3
	dd	0
	dd	0
	align	4
_475:
	dd	_134
	dd	141
	dd	82
	align	4
_840:
	dd	0x40000000
	align	4
_477:
	dd	_134
	dd	142
	dd	3
	align	4
_841:
	dd	0x40800000
	align	4
_842:
	dd	0x40800000
	align	4
_486:
	dd	3
	dd	0
	dd	0
	align	4
_485:
	dd	_134
	dd	142
	dd	79
	align	4
_843:
	dd	0x40400000
	align	4
_487:
	dd	_134
	dd	144
	dd	3
	align	4
_844:
	dd	0x40800000
	align	4
_845:
	dd	0x3f800000
	align	4
_846:
	dd	0x40800000
	align	4
_498:
	dd	3
	dd	0
	dd	0
	align	4
_497:
	dd	_134
	dd	144
	dd	101
	align	4
_847:
	dd	0x40000000
	align	4
_499:
	dd	_134
	dd	145
	dd	3
	align	4
_848:
	dd	0x40800000
	align	4
_849:
	dd	0x3f800000
	align	4
_850:
	dd	0x40800000
	align	4
_510:
	dd	3
	dd	0
	dd	0
	align	4
_509:
	dd	_134
	dd	145
	dd	101
	align	4
_851:
	dd	0x40400000
	align	4
_511:
	dd	_134
	dd	147
	dd	3
	align	4
_852:
	dd	0x3e4ccccd
	align	4
_512:
	dd	_134
	dd	148
	dd	3
	align	4
_853:
	dd	0x40800000
	align	4
_854:
	dd	0x40800000
	align	4
_855:
	dd	0x40000000
	align	4
_523:
	dd	3
	dd	0
	dd	0
	align	4
_522:
	dd	_134
	dd	148
	dd	99
	align	4
_856:
	dd	0x40a00000
	align	4
_524:
	dd	_134
	dd	149
	dd	3
	align	4
_527:
	dd	3
	dd	0
	dd	0
	align	4
_526:
	dd	_134
	dd	149
	dd	26
	align	4
_590:
	dd	1
	dd	_72
	dd	0
	align	4
_529:
	dd	_134
	dd	154
	dd	3
	align	4
_883:
	dd	0x40800000
	align	4
_884:
	dd	0x40800000
	align	4
_885:
	dd	0x40000000
	align	4
_538:
	dd	3
	dd	0
	dd	0
	align	4
_537:
	dd	_134
	dd	154
	dd	82
	align	4
_886:
	dd	0x40000000
	align	4
_539:
	dd	_134
	dd	155
	dd	3
	align	4
_887:
	dd	0x40800000
	align	4
_888:
	dd	0x40800000
	align	4
_548:
	dd	3
	dd	0
	dd	0
	align	4
_547:
	dd	_134
	dd	155
	dd	79
	align	4
_889:
	dd	0x3f800000
	align	4
_549:
	dd	_134
	dd	157
	dd	3
	align	4
_890:
	dd	0x40800000
	align	4
_891:
	dd	0x3f800000
	align	4
_892:
	dd	0x40800000
	align	4
_560:
	dd	3
	dd	0
	dd	0
	align	4
_559:
	dd	_134
	dd	157
	dd	104
	align	4
_893:
	dd	0x40000000
	align	4
_561:
	dd	_134
	dd	158
	dd	3
	align	4
_894:
	dd	0x40800000
	align	4
_895:
	dd	0x3f800000
	align	4
_896:
	dd	0x40800000
	align	4
_572:
	dd	3
	dd	0
	dd	0
	align	4
_571:
	dd	_134
	dd	158
	dd	105
	align	4
_897:
	dd	0x40000000
	align	4
_573:
	dd	_134
	dd	160
	dd	3
	align	4
_898:
	dd	0x3e4ccccd
	align	4
_574:
	dd	_134
	dd	161
	dd	3
	align	4
_899:
	dd	0x40800000
	align	4
_900:
	dd	0x40800000
	align	4
_901:
	dd	0x40000000
	align	4
_585:
	dd	3
	dd	0
	dd	0
	align	4
_584:
	dd	_134
	dd	161
	dd	100
	align	4
_902:
	dd	0x40a00000
	align	4
_586:
	dd	_134
	dd	162
	dd	3
	align	4
_589:
	dd	3
	dd	0
	dd	0
	align	4
_588:
	dd	_134
	dd	162
	dd	26
	align	4
_642:
	dd	1
	dd	_73
	dd	0
	align	4
_591:
	dd	_134
	dd	167
	dd	3
	align	4
_592:
	dd	_134
	dd	169
	dd	3
	align	4
_929:
	dd	0x43480000
	align	4
_930:
	dd	0x43480000
	align	4
_637:
	dd	3
	dd	0
	dd	2
	dd	_263
	dd	_59
	dd	-4
	dd	0
	align	4
_596:
	dd	_134
	dd	170
	dd	4
	align	4
_599:
	dd	3
	dd	0
	dd	0
	align	4
_598:
	dd	_134
	dd	170
	dd	42
	align	4
_600:
	dd	_134
	dd	171
	dd	4
	align	4
_603:
	dd	3
	dd	0
	dd	0
	align	4
_602:
	dd	_134
	dd	171
	dd	30
	align	4
_604:
	dd	_134
	dd	172
	dd	4
	align	4
_931:
	dd	0x43960000
	align	4
_932:
	dd	0x43960000
	align	4
_636:
	dd	3
	dd	0
	dd	2
	dd	_261
	dd	_59
	dd	-8
	dd	0
	align	4
_608:
	dd	_134
	dd	174
	dd	5
	align	4
_611:
	dd	3
	dd	0
	dd	0
	align	4
_610:
	dd	_134
	dd	174
	dd	43
	align	4
_612:
	dd	_134
	dd	175
	dd	5
	align	4
_615:
	dd	3
	dd	0
	dd	0
	align	4
_614:
	dd	_134
	dd	175
	dd	31
	align	4
_616:
	dd	_134
	dd	176
	dd	5
	align	4
_635:
	dd	_134
	dd	177
	dd	5
	align	4
_933:
	dd	0x43960000
	align	4
_934:
	dd	0x43480000
	align	4
_638:
	dd	_134
	dd	181
	dd	3
	align	4
_639:
	dd	_134
	dd	182
	dd	3
	align	4
_640:
	dd	_134
	dd	184
	dd	3
	align	4
_641:
	dd	_134
	dd	185
	dd	3
	align	4
_935:
	dd	0x43960000
	align	4
_936:
	dd	0x41200000
	align	4
_937:
	dd	0x43480000
	align	4
_938:
	dd	0x40a00000
	align	4
_695:
	dd	1
	dd	_74
	dd	0
	align	4
_643:
	dd	_134
	dd	193
	dd	3
	align	4
_644:
	dd	_134
	dd	195
	dd	3
	align	4
_958:
	dd	0x43480000
	align	4
_959:
	dd	0x43480000
	align	4
_689:
	dd	3
	dd	0
	dd	2
	dd	_263
	dd	_59
	dd	-4
	dd	0
	align	4
_648:
	dd	_134
	dd	196
	dd	4
	align	4
_651:
	dd	3
	dd	0
	dd	0
	align	4
_650:
	dd	_134
	dd	196
	dd	42
	align	4
_652:
	dd	_134
	dd	197
	dd	4
	align	4
_655:
	dd	3
	dd	0
	dd	0
	align	4
_654:
	dd	_134
	dd	197
	dd	30
	align	4
_656:
	dd	_134
	dd	198
	dd	4
	align	4
_960:
	dd	0x43960000
	align	4
_961:
	dd	0x43960000
	align	4
_688:
	dd	3
	dd	0
	dd	2
	dd	_261
	dd	_59
	dd	-8
	dd	0
	align	4
_660:
	dd	_134
	dd	200
	dd	5
	align	4
_663:
	dd	3
	dd	0
	dd	0
	align	4
_662:
	dd	_134
	dd	200
	dd	43
	align	4
_664:
	dd	_134
	dd	201
	dd	5
	align	4
_667:
	dd	3
	dd	0
	dd	0
	align	4
_666:
	dd	_134
	dd	201
	dd	31
	align	4
_668:
	dd	_134
	dd	202
	dd	5
	align	4
_687:
	dd	_134
	dd	203
	dd	5
	align	4
_962:
	dd	0x43960000
	align	4
_963:
	dd	0x43c80000
	align	4
_964:
	dd	0x43480000
	align	4
_690:
	dd	_134
	dd	208
	dd	3
	align	4
_691:
	dd	_134
	dd	209
	dd	3
	align	4
_692:
	dd	_134
	dd	211
	dd	3
	align	4
_693:
	dd	_134
	dd	212
	dd	3
	align	4
_965:
	dd	0x43960000
	align	4
_966:
	dd	0x41200000
	align	4
_967:
	dd	0x43480000
	align	4
_968:
	dd	0x40a00000
	align	4
_969:
	dd	0x43c80000
	align	4
_694:
	dd	_134
	dd	214
	dd	3
_698:
	db	":WEAPON",0
	align	4
_697:
	dd	1
	dd	_61
	dd	2
	dd	_161
	dd	_698
	dd	-4
	dd	0
	align	4
_696:
	dd	3
	dd	0
	dd	0
_702:
	db	":ANZEIGE",0
	align	4
_701:
	dd	1
	dd	_61
	dd	2
	dd	_161
	dd	_702
	dd	-4
	dd	0
	align	4
_700:
	dd	3
	dd	0
	dd	0
	align	4
_714:
	dd	1
	dd	_79
	dd	2
	dd	_263
	dd	_59
	dd	-4
	dd	2
	dd	_261
	dd	_59
	dd	-8
	dd	0
	align	4
_704:
	dd	_134
	dd	226
	dd	3
	align	4
_705:
	dd	_134
	dd	227
	dd	3
	align	4
_706:
	dd	_134
	dd	228
	dd	3
	align	4
_55:
	dd	_bbStringClass
	dd	2147483647
	dd	6
	dw	87,252,114,109,101,114
	align	4
_711:
	dd	_134
	dd	229
	dd	3
	align	4
_712:
	dd	_134
	dd	230
	dd	3
	align	4
_713:
	dd	_134
	dd	231
	dd	3
