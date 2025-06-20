;=======================================================;
;	    $$$CMD.ASM  (Sound Command Control)		;
;  			ORG. MDCMD11.ASM		;
;		'Sound-Source'				;
;		 for Mega Drive (68K)			;
;			Ver  1.1 / 1990.9.1		;
;				      By  H.Kubota	;
;=======================================================;

;=======================================;
;					;
;	       COMMAND SET		;
;					;
;=======================================;
; use resistor
;     a6 : sound ram top
;     a5 : channel ram top
;     a4 : table pointer
;     d5 : data
command:
	subi.w	#$e0,d5			; $E0 -> $00  $E1 -> $01
	lsl.w	#2,d5			; *4 (bra.w  d5=word o.k.)
	jmp	command_tbl(pc,d5.w)	; table address routine call
command_tbl:
	bra.w	jlrpan	 		; E0- LRPAN
	bra.w	jfdt	 		; E1- FDT
	bra.w	jset_tflg 		; E2- SET_TFLG
	bra.w	jret			; E3- CMRET
	bra.w	jautopan 		; E4- AUTOPAN
	bra.w	jpfvadd	 		; E5- PFVADD
	bra.w	jvadd	 		; E6- CMVADD
	bra.w	jtab	 		; E7- CMTAB
	bra.w	jgate	 		; E8- CMGATE
	bra.w	jtranspose	 	; E9- LFO
	bra.w	jtempo_chg 		; EA- TEMPO_CHG
	bra.w	jkeyset	 		; EB- KEYSET
	bra.w	jpvadd	 		; EC- PVADD
	bra.w	jregset	 		; ED- REGSET
	bra.w	jfmwrite 		; EE- FMWRITE
	bra.w	jfenv			; EF- FEV
	bra.w	jfvr	 		; F0- FVR
	bra.w	jvron	 		; F1- VRON
	bra.w	jend	 		; F2- CMEND
	bra.w	jnois	 		; F3- CMNOIS
	bra.w	jvroff	 		; F4- VROFF
	bra.w	jev	 		; F5- EV
	bra.w	jjump	 		; F6- CMJUMP
	bra.w	jrept	 		; F7- CMREPT
	bra.w	jcall	 		; F8- CMCALL
	bra.w	jopn	 		; F9- CMRET

;=======================================;
;					;
;		LRPAN ($E0)		;
;					;
;=======================================;
jlrpan:
	move.b	(a4)+,d1		; d1 = table data
	tst.b	chian(a5)		; if channel = PSG
	bmi.s	?end			; then end
	move.b	panstr(a5),d0		; d0 = pan data
	andi.b	#%00110111,d0		; d0 = ams pms bit data
	or.b	d0,d1			; d1 = new pan data
	move.b	d1,panstr(a5)		; pan data store
	move.b	#lr_mod,d0		; lr registor
	bra	opn_wrt_chk
?end:
	rts
;=======================================;
;					;
;		 FDT ($E1)		;
;					;
;=======================================;
jfdt:
	move.b	(a4)+,fdt_freq(a5)	; fdt frequency set
	rts
;=======================================;
;					;
;	       SET_TFLG ($E2)		;
;					;
;=======================================;
jset_tflg:
	move.b	(a4)+,t_flg(a6)		; t_flg set
	rts
;=======================================;
;					;
;		CMRET ($E3)		;
;					;
;=======================================;
jret:
	moveq	#0,d0
	move.b	stac(a5),d0
	movea.l	(a5,d0.w),a4		; a4 = table pointer
	move.l	#0,(a5,d0.w)
	addq.w	#2,a4			; db cmjump /dw addr read out
	addq.b	#4,d0
	move.b	d0,stac(a5)
	rts
;=======================================;
;					;
;	       AUTOPAN ($E4)		;
;					;
;=======================================;
jautopan:
	movea.l	a6,a0
	lea	oneupwk(a6),a1
	move.w	#fm_se_wk_top/4-1,d0
?loopbk:
	move.l	(a1)+,(a0)+
	dbra	d0,?loopbk
	bset.b	#_wr,pcm_rythm_wk(a6)
	movea.l	a5,a3
	move.b	#$28,d6
	sub.b	fintm(a6),d6
	moveq	#fm_no-1,d7
	lea	fm_wk_top(a6),a5
?loopfm:
	btst.b	#_en,(a5)
	beq.s	?jump
	bset.b	#_nl,(a5)
	add.b	d6,volm(a5)
	btst.b	#_wr,(a5)
	bne.s	?jump
	moveq	#0,d0
	move.b	enve(a5),d0
	movea.l	sng_voice_addr(a6),a1
	jsr	jfenv0(pc)
?jump:
	adda.w	#flgvol,a5
	dbra	d7,?loopfm
	
	moveq	#psg_no-1,d7
?looppsg:
	btst.b	#_en,(a5)
	beq.s	?jump1
	bset.b	#_nl,(a5)
	jsr	psg_off(pc)
	add.b	d6,volm(a5)
?jump1:
	adda.w	#flgvol,a5
	dbra	d7,?looppsg
	movea.l	a3,a5
	move.b	#$80,finfl(a6)
	move.b	#$28,fintm(a6)
	clr.b	oneupfl(a6)
	z80bus_off
	addq.w	#8,sp
	rts
;=======================================;
;					;
;	       PFVADD ($E5)		;
;					;
;=======================================;
jpfvadd:
	move.b	(a4)+,cbase(a5)
	rts
;=======================================;
;					;
;		CMVADD ($E6)		;
;					;
;=======================================;
jvadd:
	move.b	(a4)+,d0		; d0 = FM add data
	add.b	d0,volm(a5)		; add data store
	bra	vol_set			; volume set
;=======================================;
;					;
;		CMTAB ($E7)		;
;					;
;=======================================;
jtab:
	bset.b	#_tie,(a5)		; then set flag
	rts
;=======================================;
;					;
;		CMGATE ($E8)		;
;					;
;=======================================;
jgate:
	move.b	(a4),gate(a5)		; gate data store (work area)
	move.b	(a4)+,gate_str(a5)	; gate data store (store area)
	rts
;=======================================;
;					;
;		 TRANSPOSE ($E9)		;
;					;
;=======================================;
jtranspose:
	move.b	(a4)+,d0
	add.b	d0,bias(a5)
	rts
;=======================================;
;					;
;	      TEMPO_CHG ($EA)		;
;					;
;=======================================;
jtempo_chg:
	move.b	(a4),cuntst(a6)		; change data set
	move.b	(a4)+,rcunt(a6)		; change data set
	rts
;=======================================;
;					;
;		KEYSET ($EB)		;
;					;
;=======================================;
jkeyset:
	lea	wk_top(a6),a0
	move.b	(a4)+,d0
	moveq	#flgvol,d1
	moveq	#song_no-1,d2		; d2 = channel no.
?loop:
	move.b	d0,cbase(a0)
	adda.w	d1,a0
	dbra	d2,?loop
	rts
;=======================================;
;					;
;		PVADD ($EC)		;
;					;
;=======================================;
jpvadd:
	move.b	(a4)+,d0		; add data
	add.b	d0,volm(a5)		; data store
	rts
;=======================================;
;					;
;		REGSET ($ED)		;
;					;
;=======================================;
jregset:
	clr.b	pushfl(a6)
	rts
;=======================================;
;					;
;	       FMWRITE ($EE)		;
;					;
;=======================================;
jfmwrite:
	bclr.b	#_en,(a5)	; Stop track
	bclr.b	#_tie,(a5)	; Clear 'do not attack next note' bit
	jsr	key_off(pc)
	tst.b	fm_se2_wk(a6)	; Is SFX using FM4?
	bmi.s	?jump					; Branch if yes
	movea.l	a5,a3
	lea	fm4_wk(a6),a5
	movea.l	sng_voice_addr(a6),a1		; Voice pointer
	bclr.b	#_wr,(a5)	; Clear 'SFX is overriding' bit
	bset.b	#_nl,(a5)	; Set 'track at rest' bit
	move.b	enve(a5),d0		; Current voice
	jsr	jfenv0(pc)
	movea.l	a3,a5
?jump:
	addq.w	#8,sp	; Tamper with return value so we don't return to caller
	rts
;=======================================;
;					;
;		 FEV ($EF)		;
;					;
;=======================================;
; FM parameter write
;  FBC,others,TL,LR-ams-pms
jfenv:
	moveq	#0,d0			; d0 clear
	move.b	(a4)+,d0		; d0 = voice no.
	move.b	d0,enve(a5)		; voice no. store
	btst.b	#_wr,(a5)		; if write protect on then jump
	bne	jfenv_end

	movea.l	sng_voice_addr(a6),a1	; a1 = song voice address
	tst.b	seflag(a6)		; if s.e flag = 0
	beq.s	jfenv0			; then song (jump)
	movea.l	fm_voice(a5),a1	; a1 = s.e voice address
	tst.b	seflag(a6)		; if seflag = $80
	bmi.b	jfenv0			; then s.e (jump)
	movea.l	back_voice_addr(a6),a1	; a1 = back s.e voice address
jfenv0:					; from secut or jend
	subq.w	#1,d0			; voice no = 1.....
	bmi.s	?jump1
	move.w	#voice_vol,d1
?loop:
	adda.w	d1,a1
	dbra	d0,?loop
?jump1:					; a0 = FM voice top addr

;---------------------------------------;
;	      FM VOICE SET		;
;---------------------------------------;
voice_set:
;---------------< algo >----------------;
	move.b	(a1)+,d1		; algo
	move.b	d1,algo(a5)		; algo store
	move.b	d1,d4			; algo store (use volm_set)
	move.b	#FBC,d0			; registor
	jsr	opn_wrt(pc)		; write
;---------------< other >---------------;
	lea	fm_reg_tbl(pc),a2	; registor table address
	moveq	#20-1,d3		; parameter total
?loop:
	move.b	(a2)+,d0		; d0 = registor
	move.b	(a1)+,d1		; d1 = parameter
	jsr	opn_wrt(pc)		; write
	dbra	d3,?loop
;------------< total level >------------;
	moveq	#4-1,d5			; parameter total
	andi.w	#7,d4			; algo
	move.b	vol_flg_tbl(pc,d4.w),d4	; d4 = volm flag data
	move.b	volm(a5),d3		; d3 = volm data
?loop_t:
	move.b	(a2)+,d0		; d0 = registor
	move.b	(a1)+,d1		; d1 = total level data
	lsr.b	#1,d4			; d4 = flag data
	bcc.s	?jump_t			; if cary then set volm
	add.b	d3,d1			; volm add
?jump_t:
	jsr	opn_wrt(pc)		; write
	dbra	d5,?loop_t
;---------------< lrpan >---------------;
	move.b	#lr_mod,d0		; lr ams pms
	move.b	panstr(a5),d1		; parameter
	jsr	opn_wrt(pc)		; write
?end:
jfenv_end:
	rts
vol_flg_tbl:				; ·¬Ø± / Ó¼Þ­Ú°À É ÃÞ°À
	DC.B	$08			;
	DC.B	$08			; ¶¸ ËÞ¯Ä ¶Þ ·¬Ø±/Ó¼Þ­Ú°À ¦ ±×Ü½
	DC.B	$08			;
	DC.B	$08			; Bit=1 ¶Þ ·¬Ø±
	DC.B	$0A			;      0 ¶Þ Ó¼Þ­Ú°À
	DC.B	$0E			;
	DC.B	$0E			; Bit0=OP 1 , Bit1=OP 2 ... etc
	DC.B	$0F			;
;---------------------------------------;
;	      FM VOLUME SET		;
;---------------------------------------;
vol_set:
	btst.b	#_wr,(a5)		; if write protect on then jump(s.e use)
	bne.s	?end
	moveq	#0,d0
	move.b	enve(a5),d0		; voice no.
?vol_s:
	movea.l	sng_voice_addr(a6),a1
	tst.b	seflag(a6)
	beq.s	?jump1
	movea.l	fm_voice(a6),a1
	tst.b	seflag(a6)		; if seflag = $80
	bmi.b	?jump1			; then not backse
	movea.l	back_voice_addr(a6),a1
?jump1:
	subq.w	#1,d0			; voice no = 1.....
	bmi.s	?vol_s0
	move.w	#voice_vol,d1
?loop_a:
	add.w	d1,a1
	dbra	d0,?loop_a
?vol_s0:				; a0 = FM voice top address
	adda.w	#1+4*5,a1		; total level data address
	lea	tl_reg_tbl(pc),a2	; total level registor address

	move.b	algo(a5),d0		; store to ram (a5 = channel ram top)
	andi.w	#7,d0
	move.b	vol_flg_tbl(pc,d0.w),d4

	move.b	volm(a5),d3		; d3 = volm data
	bmi.b	?end
	moveq	#4-1,d5			; counter
?loop_set:
	move.b	(a2)+,d0		; registor
	move.b	(a1)+,d1		; total level data
	lsr.b	#1,d4			; d6 = flag data
	bcc.s	?jump			; if cary then set volm
	add.b	d3,d1			;
	bcs.s	?jump
	jsr	opn_wrt(pc)
?jump:
	dbra	d5,?loop_set
?end:
	rts

fm_reg_tbl:
	dc.b	MU1,MU2,MU3,MU4
	dc.b	AR1,AR2,AR3,AR4
	dc.b	DR1,DR2,DR3,DR4
	dc.b	SR1,SR2,SR3,SR4
	dc.b	RR1,RR2,RR3,RR4
tl_reg_tbl:
	dc.b	TL1,TL2,TL3,TL4
	if	0
	dc.b	SSG1,SSG2,SSG3,SSG4
	endif
;=======================================;
;					;
;		 FVR ($F0)		;
;					;
;=======================================;
jfvr:
	bset.b	#_fvr,(a5)		; fvrbit set
	move.l	a4,fvr_str(a5)		; tbpon store fvr_str

	move.b	(a4)+,v_delay(a5)	; delay data
	move.b	(a4)+,v_cont(a5)	; counter data
	move.b	(a4)+,v_add(a5)		; add add data
	move.b	(a4)+,d0		; limit data
	lsr.b	#1,d0			; 
	move.b	d0,v_limit(a5)		; 
	clr.w	v_freq(a5)		; 

	rts
;=======================================;
;					;
;		FVR ON ($F1)		;
;					;
;=======================================;
jvron:
	bset.b	#_fvr,(a5)		; fvrbit set
	rts
;=======================================;
;					;
;		CMEND ($F2)		;
;					;
;=======================================;
jend:
	bclr.b	#_en,(a5)		; enable clear
	bclr.b	#_tie,(a5)		; tie bit clear (for key off)
?jump0:
	tst.b	chian(a5)		; if channel = minus
	bmi.s	?psg			; then PSG
;=================< FM >================;
	tst.b	rythm_flag(a6)		; if rythm_cnt
	bmi	?end			; then jump
	jsr	key_off(pc)		; (look _wr)
	bra.s	?jump2
;================< PSG >================;
?psg:
	jsr	psg_off(pc)		; (look _wr)
?jump2:
;==============< s.e scan >=============;
	tst.b	seflag(a6)		; if seflag = plus then end
	bpl	?end
	clr.b	prfl(a6)		; priority clear
;--------------< s.e only >-------------;
	moveq	#0,d0			; d0 clear
	move.b	chian(a5),d0		; d0 = channel no.
	bmi.s	?psgse			; if channel = minus then PSG
?fmse:
	lea	se_song_tb(pc),a0	; a0 = song channel table
	movea.l	a5,a3			; a5 store
	cmpi.b	#4,d0			; if channel · 4
	bne.s	?jump_se1
	tst.b	back_se_wk(a6)		; if back s.e enable off
	bpl.s	?jump_se1
	lea	back_se_wk(a6),a5	; a5 = back s.e ram
	movea.l	back_voice_addr(a6),a1	; a1 = back s.e voice address
	bra.s	?jump_se2
?jump_se1:
	subq.b	#2,d0
	lsl.b	#2,d0			; 2->$00 , 3->$04 , 4->$08 , 5->$0C
	movea.l	(a0,d0.w),a5		; a5 = enable channel address (song)
	tst.b	(a5)			; if channel don't use
	bpl.s	?jump_se3		; then jump to not set
	movea.l	sng_voice_addr(a6),a1	; a1 = song voice address
?jump_se2:
	bclr.b	#_wr,(a5)		; write protect off
	bset.b	#_nl,(a5)		; null flag set
;----------< song voice set >-----------;
	move.b	enve(a5),d0		; d0 = voice no
	jsr	jfenv0(pc)		; song voice set
?jump_se3:
	movea.l	a3,a5			; a5 restore
;------------< s.e mode scan >----------;
*	cmp.b	#2,chian(a5)		; if ch 2 se mode use
*	bne.s	?end
*	clr.b	se_mode_flg(a6)		; semode flag set
*	moveq	#nomal_mode,d1
*	moveq	#mode_tim,d0
*	jsr	opn1_wrt(pc)
	bra.s	?end
?psgse:
;----------< channel enable >-----------;
	lea	back_se2_wk(a6),a0	; a0 = back s.e2 ram
	tst.b	(a0)			; if back s.e2 enable off
	bpl.s	?jump_se4		; then jump
	cmpi.b	#$e0,d0			; if channel · $e0
	beq.s	?jump_se5		; then jump
	cmpi.b	#$c0,d0			; if channel · $c0
	beq.s	?jump_se5		; then jump
?jump_se4:
	lea	se_song_tb(pc),a0	; a0 = song channel table
	lsr.b	#3,d0			; $80->$10 , $A0->$14 , $C0->$18
	movea.l	(a0,d0.w),a0		; a0 = enable channel address (song)
?jump_se5:
	bclr.b	#_wr,(a0)		; write protect bit off
	bset.b	#_nl,(a0)		; null flag set
	cmpi.b	#$e0,chian(a0)		; if channel · $e0 (noise mode)
	bne.s	?jump_se6		; then jump
	move.b	ntype(a0),psg68k	; noise mode write
?jump_se6:
?end:
	addq.w	#8,sp			; 3 return
	rts

;=======================================;
;					;
;		CMNOIS ($F3)		;
;					;
;=======================================;
jnois:
	move.b	#$e0,chian(a5)		; noise mode = E0h
	move.b	(a4)+,ntype(a5)		; set
	btst.b	#_wr,(a5)		; if write protect on
	bne.s	?end			; then end
	move.b	-1(a4),psg68k		; set
?end:
	rts
;=======================================;
;					;
;		FVR OFF ($F4)		;
;					;
;=======================================;
jvroff:
	bclr.b	#_fvr,(a5)		; fvrbit set
	rts
;=======================================;
;					;
;		 EV ($F5)		;
;					;
;=======================================;
jev:
	move.b	(a4)+,enve(a5)		; set
	rts
;=======================================;
;					;
;		CMJUMP ($F6)		;
;					;
;=======================================;
jjump:
	move.b	(a4)+,d0		; high addr get
	lsl.w	#8,d0			; high addr -> d0 high 8 bit
	move.b	(a4)+,d0		; low addr get
	adda.w	d0,a4			; add tbpon
	subq.w	#1,a4			; adjust
	rts
;=======================================;
;					;
;		CMREPT ($F7)		;
;					;
;=======================================;
jrept:
	moveq	#0,d0
	move.b	(a4)+,d0		; rept-reg no get
	move.b	(a4)+,d1		; rept counter data get
	tst.b	reptr(a5,d0.w)
	bne.s	?jump			; then jump
	move.b	d1,reptr(a5,d0.w)	; set rept counter
?jump:
	subq.b	#1,reptr(a5,d0.w)	; d0 = repeat reg no.
	bne.s	jjump			; CMJUMP
	addq.w	#2,a4			; table pointer adjust
	rts
;=======================================;
;					;
;		CMCALL ($F8)		;
;					;
;=======================================;
jcall:
	moveq	#0,d0
	move.b	stac(a5),d0		; d0 = stac
	subq.b	#4,d0			; stac -4
	move.l	a4,(a5,d0.w)		; table address store
	move.b	d0,stac(a5)		; stac store
	bra.s	jjump			; CMJUMP
;=======================================;
;					;
;		OPN ($F9)		;
;					;
;=======================================;
jopn:
	move.b	#RR2,d0
	move.b	#$0f,d1
	jsr	opn1_wrt(pc)
	move.b	#RR4,d0
	move.b	#$0f,d1
	bra	opn1_wrt

