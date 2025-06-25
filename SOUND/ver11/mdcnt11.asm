;=======================================================;
;	    $$$CNT.ASM  (Sound Main Control)		;
;			ORG. MDCNT11.ASM		;
;		'Sound-Source'				;
;		 for Mega Drive (68K)			;
;			Ver  1.1 / 1990.9.1		;
;				      By  H.Kubota	;
;=======================================================;
	
sound:
;=======================================;
;					;
;	     OPN BUSY CHECK		;
;					;
;=======================================;
;	if z80 writing z80_flg = 80h
z80opn_chk:
	z80bus_on
	nop
	nop
	nop
?loop1:
	btst.b	#0,z80busreq		; if bit on then bus req ok.
	bne.s	?loop1
	btst.b	#7,z80_flg		; pcm write flag
	beq.s	z80_chk_end
	z80bus_off
	nop
	nop
	nop
	nop
	nop
	bra.s	z80opn_chk

z80_chk_end:

;=======================================;
;					;
;	   SOUND MAIN ROUTIN		;
;					;
;=======================================;
; use registor
;     a6 : sound ram top
	lea	sound_ram,a6		; a6 = sound ram top
	clr.b	seflag(a6)		; se flag clear

	tst.b	pause_flg(a6)		; pause flag check
	bne	pause_chk		; pause check

	subq.b	#1,rcunt(a6)		; rcunt -1
	bne.s	?end			; if rcunt � 0 then end
	jsr	delcont(pc)		; delay counter check
?end:
	move.b	foutfl(a6),d0		; if foutfl = 0
	beq.s	?end1			; then end
	jsr	fout_chk(pc)		; faid out check
?end1:
	tst.b	finfl(a6)
	beq.s	?end2
	jsr	fin_chk(pc)
?end2:
	tst.w	kyflag(a6)
	beq.s	?jump
	jsr	bufscan(pc)		; buffer scan & key scan
?jump:
	cmpi.b	#$80,kyflag0(a6)
	beq.s	?jump1
	jsr	buf_end(pc)
?jump1:

;=======================================;
;					;
;	       SOUND SCAN		;
;					;
;=======================================;
; use registor
;     a6 : sound ram top
;     a5 : channel ram top
;     a4 : table pointer
sound_scan:
;---------------------------------------;
;	       RYTHM SCAN		;
;---------------------------------------;
rythm_scan:
	lea	pcm_rythm_wk(a6),a5	; pcm rhythm work top
	tst.b	(a5)			; if _en = 0
	bpl.s	fm_scan			; then pass
	jsr	fm_rythm_cnt(pc)	; rhythm control
;---------------------------------------;
;		FM SCAN			;
;---------------------------------------;
fm_scan:
	clr.b	rythm_flag(a6)		; rythm flag clear
	moveq	#fm_no-1,d7		; FM total
?loop:
	adda.w	#flgvol,a5		; next channel ram
	tst.b	(a5)			; if _en = 0
	bpl.s	?jump			; then pass
	jsr	fm_cnt(pc)		; FM control
?jump:
	dbra	d7,?loop		; loop
;---------------------------------------;
;		PSG SCAN		;
;---------------------------------------;
psg_scan:
	moveq	#psg_no-1,d7		; PSG total
?loop:
	adda.w	#flgvol,a5		; next channel ram
	tst.b	(a5)			; if _en = 0
	bpl.s	?jump			; then pass
	jsr	psg_cnt(pc)		; PSG control
?jump:
	dbra	d7,?loop		; loop
;---------------------------------------;
;	       FM SE SCAN		;
;---------------------------------------;
fm_se_scan:
	move.b	#$80,seflag(a6)		; s.e flag set (s.e)
	moveq	#fm_se_no-1,d7		; FM s.e total
?loop:
	adda.w	#flgvol,a5		; next channel ram
	tst.b	(a5)			; if _en = 0
	bpl.s	?jump			; then pass
	jsr	fm_cnt(pc)		; FM control
?jump:
	dbra	d7,?loop		; loop
;---------------------------------------;
;	      PSG SE SCAN		;
;---------------------------------------;
psg_se_scan:
	moveq	#psg_se_no-1,d7		; PSG s.e total
?loop:
	adda.w	#flgvol,a5		; next channel ram
	tst.b	(a5)			; if _en = 0
	bpl.s	?jump			; then pass
	jsr	psg_cnt(pc)		; PSG control
?jump:
	dbra	d7,?loop		; loop
;---------------------------------------;
;	     FM BACK SE SCAN		;
;---------------------------------------;
fm_back_scan:
	move.b	#$40,seflag(a6)		; s.e flag set (back s.e)
	adda.w	#flgvol,a5		; next channel ram
	tst.b	(a5)			; if _en = 0
	bpl.s	?psg			; then pass
	jsr	fm_cnt(pc)		; FM control
?psg:
	adda.w	#flgvol,a5		; next channel ram
	tst.b	(a5)			; if _en = 0
	bpl.s	?jump			; then pass
	jsr	psg_cnt(pc)		; PSG control
?jump:
	
z80bus_off_global:
	z80bus_off			; z80 bus req off
	rts
;=======================================;
;					;
;	      RYTHM CONTROL		;
;					;
;=======================================;
; use resistor
;     a6 : sound ram top
;     a5 : channel ram top
;     a4 : table pointer
fm_rythm_cnt:
	subq.b	#1,lcont(a5)		; length counter -1
	bne.s	rythm_end		; if lcont = 0 then next data
rythm_nextd:
	move.b	#$80,rythm_flag(a6)	; rythm flag on (for CMEND)
	movea.l	tbpon(a5),a4		; table pointer set
rythm_cmdchk:
	moveq	#0,d5
	move.b	(a4)+,d5		; d5 = table data
	cmpi.b	#$e0,d5			; if data < $E0
	bcs.s	rythm_nextd0		; then jump (freq)
	jsr	command(pc)		; if data >= $E0 then command
	bra.s	rythm_cmdchk		; loop
rythm_nextd0:
	tst.b	d5
	bpl.s	rythm_leng		; if plus then length data
	move.b	d5,freqb(a5)		; data store
	move.b	(a4)+,d5		; d0 = next table data
	bpl.s	rythm_leng	        ; if plus then length data
	subq.w	#1,a4			; table pointer adjust
	move.b	ecstr(a5),lcont(a5)	; length set
	bra.s	rythm_flg_set
rythm_leng:
	jsr	leng_set(pc)
rythm_flg_set:
	move.l	a4,tbpon(a5)		; table pointer store tbpon
rythm_set:
	btst.b	#_wr,(a5)		; if write protect on
	bne.s	rythm_end		; then end
	moveq	#0,d0			; d0 clear
	move.b	freqb(a5),d0		; data restore
	cmpi.b	#$80,d0			; if data = 'NL'
	beq.s	rythm_end		; then not store
	btst	#3,d0			; if data = 88h-8fh
	bne.s	rythm_tom_set		; then tom set
*	jsr	z80opn_chk(pc)		; z80 bus req on
*	tst.b	z80use_flg		; if z80 voice using
*	bne.s	?pass			; then not store
	move.b	d0,z80kyflag		; rythm req no. set
?pass:
*	z80bus_off			; z80 bus req off
rythm_end:
	rts
;---------------------------------------;
;	      TOM DELAY SET		;
;---------------------------------------;
rythm_tom_set:
	subi.b	#$88,d0			; 88h->0  89h->1  8A->2 ⅴ�
	move.b	tom_dl_tb(pc,d0.w),d0	; d0 = tom delay data
*	jsr	z80opn_chk(pc)		; z80 bus req on
*	tst.b	z80use_flg		; if z80 voice using
*	bne.s	?pass			; then not store
	move.b	d0,z80tom_dl_str	; data -> z80 tom delay addr
	move.b	#$83,z80kyflag		; rythm req no. set
?pass:
*	z80bus_off			; z80 bus req off
	rts
;---------------------------------------;
;	     TOM DELAY TABLE		;
;---------------------------------------;
tom_dl_tb:
	dc.b	18,21,28,29,255,255

;=======================================;
;					;
;	       FM CONTROL		;
;					;
;=======================================;
; use resisters
;  a4 : table pointer
;  a5 : channel ram top address
;  d5 : table data
fm_cnt:
	subq.b	#1,lcont(a5)		; length counter -1
	bne.s	fm_cnt1			; if lcont � 0 then jump
fm_cnt0:
	bclr.b	#_tie,(a5)		; tie flag off
	jsr	fm_nextd(pc)		; table data get & flag set
	jsr	fm_frq_wrt(pc)		; frequency set
*	jsr	pan_set(pc)		; autopan set
	bra	key_on			; key on
fm_cnt1:
	jsr	gate_chk(pc)		; gate check
*	jsr	pan_chk(pc)		; autopan check
	jsr	vibr_chk(pc)		; fvr check
	bra	vibr_frq_set		; frequency set
;---------------------------------------;
;	    FM NEXT DATA SCAN		;
;---------------------------------------;
fm_nextd:
	movea.l	tbpon(a5),a4		; a4 = table pointer
	bclr.b	#_nl,(a5)		; null flag clear
fm_cmdchk:
	moveq	#0,d5
	move.b	(a4)+,d5		; d5 = table data
	cmpi.b	#$e0,d5			; if data >= E0h
	bcs.s	fm_nextd0
	jsr	command(pc)		; then command
	bra.s	fm_cmdchk
fm_nextd0:
	jsr	key_off(pc)		; key off
	tst.b	d5			; if data < 80h
	bpl.s	fm_nextd1               ; then length data
	jsr	fm_frq_get(pc)		; frequency get
	move.b	(a4)+,d5		; d5 next table data
	bpl.s	fm_nextd1               ; then length data
	subq.w	#1,a4			; table pointer adjust
	bra	flag_set
fm_nextd1:
	jsr	leng_set(pc)
	bra	flag_set
;=======================================;
;					;
;	     FM FREQUENCY GET		;
;					;
;=======================================;
; in  d5 : table data
; out d6 : frequency
fm_frq_get:
	subi.b	#$80,d5			; table data -80h
	beq.s	nul_flg_set		; if data = 80h then null

	add.b	bias(a5),d5		; add bias data
	andi.w	#$7f,d5			; use data = low 7 bit 
*	divu	#12,d5			; high 16 bit = scale no.
					; low 16 bit = block
*	swap	d5
	lsl.w	#1,d5			; *2 (word)
	lea	fm_scale(pc),a0		; a0 = scale pointer
	move.w	(a0,d5.w),d6		; d6 = scale data
*	swap	d5
*	andi.w	#7,d5			; d5 = block (low 3 bit only)
*	moveq	#11,d0
*	lsl.w	d0,d5
*	or.w	d5,d6			; d6 = block & scale data
	move.w	d6,freqb(a5)		; data store freqb
	rts

;=======================================;
;					;
;	       LENGTH SET		;
;					;
;=======================================;
;  in a5 = channel ram top
;     d5 = length data
; use d0,d1
leng_set:
	move.b	d5,d0			; length store ecstr
	move.b	cbase(a5),d1		; d1 = base
?loop:
	subq.b	#1,d1
	beq.s	?end
	add.b	d5,d0			; length store ecstr
	bra.s	?loop
?end:
	move.b	d0,ecstr(a5)		; length set
	move.b	d0,lcont(a5)		; length set
	rts

;=======================================;
;					;
;	       FLAG SET			;
;					;
;=======================================;
;	a5 = channel ram top
;---------------------------------------;
;	    FLAG SET (IF 'NL')		;
;---------------------------------------;
nul_flg_set:
	bset.b	#_nl,(a5)		; null flag on
	clr.w	freqb(a5)		; freq clear
;---------------------------------------;
;		FLAG SET		;
;---------------------------------------;
flag_set:
	move.l	a4,tbpon(a5)		; table pointer store
	move.b	ecstr(a5),lcont(a5)	; length set
flag_set0:
	btst.b	#_tie,(a5)		; if tie flag = on
	bne.s	?end			; then end

	move.b	gate_str(a5),gate(a5)	; gate set
	clr.b	econt(a5)		; envelope counter clear

	btst.b	#_fvr,(a5)		; if fvr flag = on
	beq.s	?end			; then end

	movea.l	fvr_str(a5),a0		; a0 = fvr store addr
	move.b	(a0)+,v_delay(a5)	; fvr delay set
	move.b	(a0)+,v_cont(a5)	; fvr counter set
	move.b	(a0)+,v_add(a5)		; fvr add data set
	move.b	(a0)+,d0		; d0 fvr limit data
	lsr.b	#1,d0			; d0 /2
	move.b	d0,v_limit(a5)		; fvr limit set
	clr.w	v_freq(a5)		; fvr frequency clear

?end:
	rts

;=======================================;
;					;
;	       GATE CHECK		;
;					;
;=======================================;
gate_chk:
	tst.b	gate(a5)		; if gate = 0
	beq.s	?end			; then end

	subq.b	#1,gate(a5)		; gate -1
	bne.s	?end			; if gate = 0 then end
	bset.b	#_nl,(a5)		; null flag on
	tst.b	chian(a5)		; if channel = PSG
	bmi	?psg			; then jump (PSG clear)
?fm:
	jsr	key_off(pc)		; if channel = FM then key off
	addq.w	#4,sp			; 2 return
	rts
?psg:
	jsr	psg_off(pc)		; then jump (PSG clear)
	addq.w	#4,sp			; 2 return
?end:
	rts


;=======================================;
;					;
;	        FVR CHECK		;
;					;
;=======================================;
; out d6 : frequency
vibr_chk:
	addq.w	#4,sp			; stack push
					; (for cansel freq set)
	btst.b	#_fvr,(a5)		; if fvr flag = 0
	beq.s	vibr_end		; then end
;---------------------------------------;
;		FVR DELAY 		;
;---------------------------------------;
vibr_delay:
	tst.b	v_delay(a5)		; if fvr delay = 0
	beq.s	vibr_count		; then jump (counter check)
	subq.b	#1,v_delay(a5)		; fvr delay -1
	rts
;---------------------------------------;
;	       FVR COUNTER		;
;---------------------------------------;
vibr_count:
	subq.b	#1,v_cont(a5)		; fvr counter -1
	beq.s	vibr_limit		; if fvr counter = 0 then jump
	rts
;---------------------------------------;
;		FVR LIMIT		;
;---------------------------------------;
vibr_limit:
	movea.l	fvr_str(a5),a0		; a0 = fvr store address
	move.b	1(a0),v_cont(a5)	; fvr counter set

	tst.b	v_limit(a5)		; if fvr limit = 0
	bne.s	vibr_add		; then jump

	move.b	3(a0),v_limit(a5)	; fvr limit set
	neg.b	v_add(a5)		; add data +/- change
	rts
;---------------------------------------;
;		FVR ADD			;
;---------------------------------------;
vibr_add:
	subq.b	#1,v_limit(a5)		; fvr limit -1
	move.b	v_add(a5),d6		; d6 = fvr add data (byte)
	ext.w	d6			; d6 = fvr add data (word)
	add.w	v_freq(a5),d6		; d6 = add data + fvr freq
	move.w	d6,v_freq(a5)		; new fvr freq store v_freq
	add.w	freqb(a5),d6		; d6 = new fvr freq + freqb
	subq.w	#4,sp			; stack get
vibr_end:
	rts
;=======================================;
;					;
;	     FM FREQUENCY SET		;
;					;
;=======================================;
;  in d6 : frequency
fm_frq_wrt:				; from nextd
	btst.b	#_nl,(a5)		; if null flag = on
	bne.s	fm_frq_end		; then end
	move.w	freqb(a5),d6		; d6 = freqb data
	beq.s	nl_set			; then end
vibr_frq_set:				; from vibr_chk
	move.b	fdt_freq(a5),d0		; d0 = fdt frequency (byte)
	ext.w	d0			; d0 = fdt frequency (word)
	add.w	d0,d6			; d6 = freqb + fdt freq
	btst.b	#_wr,(a5)		; if write protect on
	bne.s	fm_frq_end		; then end
*	tst.b	se_mode_flg(a6)		; if ch2 se mode = off
*	beq.s	vibr_frq_wrt		; then jump (write)
*	cmpi.b	#2,chian(a5)		; if channel = 2
*	beq.s	dt_frq_set		; then jump (use se mode)
;---------------------------------------;
;	     FREQUENCY WRITE		;
;---------------------------------------;
vibr_frq_wrt:
	move.w	d6,d1			; d1 = frequency
	lsr.w	#8,d1			; d1 = block & F-Number2 data
	move.b	#blk_f_num2,d0		; d0 = registor address

*	jsr	z80opn_chk(pc)		; z80 bus req on
	jsr	opn_wrt(pc)		; block & F-Number2 write

	move.b	d6,d1			; d1 = frequency
	move.b	#f_num1,d0		; d0 = registor address
	jsr	opn_wrt(pc)		; F-Number1 write
*	z80bus_off			; z80 bus off
fm_frq_end:
	rts
nl_set:
	bset.b	#_nl,(a5)		; null flag on
	rts

;=======================================;
;					;
;     FM FREQUENCY SET (SE MODE USE)	;
;					;
;=======================================;
*	public	dt_frq_set,dt_reg_tb
*dt_frq_set:				; in d6 = freq (dw)
*	lea	dt_reg_tb(pc),a1	; a1 = registor table address
*	lea	dt1(a6),a2		; a2 = dt1 address
*	moveq	#4-1,d7			; d7 = slot number
*	jsr	z80opn_chk(pc)		; z80 bus req on
*?loop:
*	move.w	d6,d1			; d1 = frequency
*	move.w	(a2)+,d0		; d0 = dtune data (word)
*	add.w	d0,d1			; d1 = dtune + frequency
*	move.w	d1,d3			; d3 = dtune + frequency

*	lsr.w	#8,d1			; d1 = block & F-Number2 data
*	move.b	(a1)+,d0		; d0 = registor
*	jsr	opn1_wrt(pc)		; block & F-Number2 write

*	move.b	d3,d1			; d1 = dtune + frequency
*	move.b	(a1)+,d0		; d0 = registor
*	jsr	opn1_wrt(pc)		; F-Number1 write
*	dbra	d7,?loop

*	z80bus_off			; z80 bus req off
*	rts
*dt_reg_tb:
					; block & F-Number2 , F-Number1
*	dc.b	ADH,A9H			; slot 1
*	dc.b	ACH,A8H			; slot 2
*	dc.b	AEH,AAH			; slot 3
*	dc.b	A6H,A2H			; slot 4

;=======================================;
;					;
;	       AUTOPAN SET		;
;					;
;=======================================;
*	public	pan_set,pan_chk
;---------------------------------------;
;	      AUTOPAN SET		;
;---------------------------------------;
*pan_set:
*	btst.b	#_nl,(a5)		; if null flg = on
*	bne.s	pan_set_not		; then end
*	moveq	#0,d0
*	move.b	pan_no(a5),d0		; d0 = pan no.
*	lsl.w	#1,d0			; d0 *2 (rts,bra.s -> word)
*	jmp	pan_set_tbl(pc,d0.w)	; jump to table addr
*pan_set_not:
*pan_set_tbl:
*	rts				; autopan off
*	bra.s	pan_s1			; mode 1
*	bra.s	pan_s2			; mode 2
*	bra.s	pan_s3			; mode 3

;---------------------------------------;
;	      AUTOPAN CHECK		;
;---------------------------------------;
*pan_chk:
*	btst.b	#_nl,(a5)		; if no key on flg = set
*	bne.s	pan_chk_not		; then end
*	moveq	#0,d0
*	move.b	pan_no(a5),d0		; d0 = pan no.
*	lsl.w	#1,d0			; d0 *2 (rts,bra.s -> word)
*	jmp	pan_chk_tbl(pc,d0.w)	; jump to table addr
*pan_chk_not:
*pan_chk_tbl:
*	rts				; autopan off
*	rts				; mode 1
*	bra.s	pan_s2_1		; mode 2
*	bra.s	pan_s3_1		; mode 3
*pan_s2:
*pan_s3:
*	move.b	pan_leng(a5),pan_cont(a5)
*	clr.b	pan_start(a5)
*pan_s1:
*pan_s2_1:
*pan_s3_1:
*	move.b	pan_cont(a5),d0
*	cmp.b	pan_leng(a5),d0
*	bne.s	pan_s2_set

*	move.b	pan_limit(a5),d3
*	cmp.b	pan_start(a5),d3
*	bpl.s	pan_s2_0

*	cmpi.b	#2,pan_no(a5)
*	beq.s	pan_chk_end

*	clr.b	pan_start(a5)
*pan_s2_0:
*	clr.b	pan_cont(a5)
*	addq.b	#1,pan_start(a5)
*pan_s2_set:
*pan_write:
;----------------< set >----------------;
*	moveq	#0,d0
*	move.b	pan_tb(a5),d0
*	subq.w	#1,d0
*	lsl.w	#2,d0			; *4
*	movea.l	pan_addr_tb(pc,d0.w),a0
*	moveq	#0,d0
*	move.b	pan_start(a5),d0
*	subq.w	#1,d0
*	move.b	(a0,d0.w),d1		; pan data
;------------< LFO recover >------------;
*	move.b	panstr(a5),d0		; d0 = pan data
*	andi.b	#%00110111,d0		; d0 = ams pms bit data
*	or.b	d0,d1			; d1 = new pan data
*	move.b	#lr_mod,d0		; FM registor
*	jsr	opn_wrt_chk(pc)

*	addq.b	#1,pan_cont(a5)
*pan_set_end:
*pan_chk_end:
*	rts

;---------------------------------------;
;	      AUTOPAN TABLE		;
;---------------------------------------;
*pan_addr_tb:
*	dc.l	pan_1_data,pan_2_data
*	dc.l	pan_3_data
*pan_1_data	equ	$
*	dc.b	040h
*	dc.b	080h
*pan_2_data	equ	$
*	dc.b	040h
*	dc.b	0C0h
*	dc.b	080h
*pan_3_data	equ	$
*	dc.b	0C0h
*	dc.b	080h
*	dc.b	0C0h
*	dc.b	040h

;=======================================;
;					;
;	      PAUSE CHECK		;
;					;
;=======================================;
pause_chk:
	bmi.s	pause_chk_off		; if pause flag = minus then pause off
;=======================================;
;		PAUSE ON		;
;=======================================;
pause_chk_on:
;============< all tone off >===========;
;---------------< LR off >--------------;
	cmpi.b	#2,pause_flg(a6)
	beq	pause_exit
	move.b	#2,pause_flg(a6)
	moveq	#3-1,d3			; channel no.
	move.b	#lr_mod,d0		; LR registor
	moveq	#0,d1			; LR off data = 0
?loop1:
	jsr	opn1_wrt(pc)
	jsr	opn2_wrt(pc)
	addq.b	#1,d0			; registor change
	dbra	d3,?loop1
;--------------< key off >--------------;
	moveq	#3-1,d3			; channel no. total /2
	moveq	#key_cont,d0		; d0 = key on/off registor
?loop2:
	move.b	d3,d1			; d1 clear
	jsr	opn1_wrt(pc)		; channel 2->1->0
	addq.b	#4,d1			; key off channel add
	jsr	opn1_wrt(pc)		; channel 6->5->4
	dbra	d3,?loop2
;--------------< PSG off >--------------;
	jsr	psg_clear(pc)
	bra	z80bus_off_global			; bus off
;=======================================;
;		PAUSE OFF		;
;=======================================;
pause_chk_off:
;==========< pause flag clear >=========;
	clr.b	pause_flg(a6)		; pause flag off

;=============< LR recover >============;
	moveq	#flgvol,d3		; d3 = constant add data
;--------------< FM song >--------------;
	lea	wk_top(a6),a5		; a5 = ch 0 ram top address
	moveq	#fm_no+pcm_no-1,d4	; d4 = channel total
?loop1:
	btst.b	#_en,(a5)		; if enable off
	beq.s	?pass1			; then jump
	btst.b	#_wr,(a5)		; if write protect on
	bne.s	?pass1			; then jump
	move.b	#lr_mod,d0		; LR registor
	move.b	panstr(a5),d1		; d1 = pan data
	jsr	opn_wrt(pc)		; LR write (don't look _wr)
?pass1:
	adda.w	d3,a5			; ram address add
	dbra	d4,?loop1

;---------------< FM s.e >--------------;
	lea	fm_se_wk_top(a6),a5	; a5 = ch 0 ram top address
	moveq	#fm_se_no-1,d4		; d4 = channel total
?loop2:
	btst.b	#_en,(a5)		; if enable off
	beq.s	?pass2			; then jump
	btst.b	#_wr,(a5)		; if write protect on
	bne.s	?pass2			; then jump
	move.b	#lr_mod,d0		; LR registor
	move.b	panstr(a5),d1		; d1 = pan data
	jsr	opn_wrt(pc)		; LR write (don't look _wr)
?pass2:
	adda.w	d3,a5			; ram address add
	dbra	d4,?loop2

;------------< FM back s.e >------------;
	lea	back_se_wk(a6),a5	; a5 = ch 0 ram top address
	btst.b	#_en,(a5)		; if enable off
	beq.s	?pass3			; then jump
	btst.b	#_wr,(a5)		; if write protect on
	bne.s	?pass3			; then jump
	move.b	#lr_mod,d0		; LR registor
	move.b	panstr(a5),d1		; d1 = pan data
	jsr	opn_wrt(pc)		; LR write (don't look _wr)
?pass3:

pause_exit:
	bra	z80bus_off_global			; bus off

;=======================================;
;					;
;	      BUFFER SCAN		;
;					;
;=======================================;
bufscan:
	movea.l	sound_top+hd_prtb*4,a0	; a1 = priority address
	lea	kyflag(a6),a1		; a0 = kyflag addr (=buf1)
	move.b	prfl(a6),d3		; d3 = priority flag
	moveq	#3-1,d4			; counter (buf = 3)
buf_loop:
	move.b	(a1),d0			; d0 = buffer
	move.b	d0,d1			; d1 = buffer
	clr.b	(a1)+			; buffer clear
	subi.b	#songstrt,d0		; kyflag -81h
	bcs.s	?jump1			; if no.< $81
	cmpi.b	#$80,kyflag0(a6)
	beq.s	?jump0
	move.b	d1,kyflag(a6)
	bra.s	?jump1
?jump0:
	andi.w	#$7f,d0			;
	move.b	(a0,d0.w),d2		; d2 = new priority
	cmp.b	d3,d2			; if new priority < prfl
	bcs.s	?jump1			; then jump (don't set)
	move.b	d2,d3			; priority set
	move.b	d1,kyflag0(a6)		; key flag set
?jump1:
	dbra	d4,buf_loop
	tst.b	d3			; if priority >= $80
	bmi.s	?jump2			; then don't set
	move.b	d3,prfl(a6)		; new priority set
?jump2:
	rts
buf_end:

;==============< key scan >=============;
	moveq	#0,d7			; clear
	move.b	kyflag0(a6),d7		; d7 = key no.
*	cmpi.b	#$80,d7			; if no. = $80
	beq	chamus			; if no. < $80 then chamus
	bpl.s	?end			; if no. = $80 then end
	move.b	#$80,kyflag0(a6)	; kyflag set $80
	cmpi.b	#songend,d7		; if no. <= songend
	bls	songscan		; then song
	cmpi.b	#sestrt,d7		; if no. < sestrt
	bcs	?end			; then end
	cmpi.b	#seend,d7		; if no. <= seend
	bls	sescan			; then seend
	cmpi.b	#bkstrt,d7		; if no. < backse start
	bcs	?end			; then end
	cmpi.b	#utlst,d7		; if no. < utlst
	bcs	backscan		; then back s.e
	cmpi.b	#lstno,d7		; if no. < lstno
	bls.s	utlset			; then utility set
?end:
	rts

;=======================================;
;					;
;	       UTILITY SET		;
;					;
;=======================================;
utlset:
	subi.b	#utlst,d7		; kyflag -E0h
	lsl.w	#2,d7			; *4
	jmp	utltb(pc,d7.w)		; table addr rutine call
utltb:
	bra	fout			; $E0
	bra	z80_voice_set	; $E1
	bra	speedupmus		; $E2
	bra	slowdownmus		; $E3
	bra	chamus			; $E4

;=======================================;
;					;
;	  Z80 VOICE NUMBER SET		;
;					;
;=======================================;
z80_voice_set:
	move.b	#$88,z80kyflag		; voice request no.($88~)
	z80bus_off		; bus off
	move.w	#$12-1,d1
?loop1:
	move.w	#0-1,d0
?loop:
	nop
	dbf	d0,?loop
	dbf	d1,?loop1
	addq.w	#4,sp			; 2 return
	rts

;=======================================;
;					;
;		SONG SCAN		;
;					;
;=======================================;
; in d7 = key no.
songscan:
	cmpi.b	#$88,d7
	bne.s	?jump
	tst.b	oneupfl(a6)
	bne	?jump4
	lea	wk_top(a6),a5
	moveq	#song_no-1,d0
?loopsong:
	bclr.b	#2,(a5)
	adda.w	#flgvol,a5
	dbra	d0,?loopsong
	lea	fm_se_wk_top(a6),a5
	moveq	#se_no-1,d0
?loopsound:
	bclr.b	#7,(a5)
	adda.w	#flgvol,a5
	dbra	d0,?loopsound
	clr.b	prfl(a6)
	movea.l	a6,a0
	lea	oneupwk(a6),a1
	move.w	#fm_se_wk_top/4-1,d0
?loopbk:
	move.l	(a0)+,(a1)+
	dbra	d0,?loopbk
	move.b	#$80,oneupfl(a6)
	clr.b	prfl(a6)
	bra.s	?jump0
?jump:
	clr.b	oneupfl(a6)
	clr.b	fintm(a6)
?jump0:
;-----< chip initial & ram clear >------;
	jsr	chamus2(pc)			; song ram clear
;--------< headder address get >--------;
	movea.l	sound_top+hd_speedup*4,a4
	subi.b	#songstrt,d7		; 81->0,82->1,83->2,...
	move.b	(a4,d7.w),sptempo(a6)
	movea.l	sound_top+hd_bgmtb*4,a4	; a4 = bgmtb address
	lsl.w	#2,d7			; long word table
	movea.l	(a4,d7.w),a4		; a4 = S?? bgm top
;--------< voice table top get >--------;
	moveq	#0,d0
	move.w	(a4),d0			; rel. voice address (word)
	add.l	a4,d0			; bgmtop address + rel. voice address
	move.l	d0,sng_voice_addr(a6)	; voice address store
;----------< delay counter set >---------;
	move.b	hd_delay(a4),d0
	move.b	d0,tempo(a6)
	tst.b	speedup(a6)
	beq.s	?nospeedup
	move.b	sptempo(a6),d0
?nospeedup:
	move.b	d0,cuntst(a6)
	move.b	d0,rcunt(a6)
;=======================================;
;	headder set to channel ram	;
;=======================================;
;=================< FM >================;
	moveq	#0,d1			; d1 clear
	movea.l	a4,a3			; a3 = header
	addq.w	#hd_fmdt_top,a4		; a4 = header pointer
	moveq	#0,d7			; d7 clear
	move.b	hd_fmch_no(a3),d7	; d7 = FM use channel total
	beq	?psg_headder		; if channel total = 0 then jump
	subq.b	#1,d7
	move.b	#$c0,d1			; d1 = pan data
	move.b	hd_base(a3),d4		; d4 = tempo base
	moveq	#flgvol,d6		; d6 = flag size (stac)
	move.b	#1,d5			; d5 = lcont data
	lea	wk_top(a6),a1		; a1 = ram addr
	lea	fm_chan_tb(pc),a2	; a2 = channel table
?loop_fm:
	bset.b	#7,(a1)			; flag set
	move.b	(a2)+,chian(a1)		; channel set
	move.b	d4,cbase(a1)		; base set
	move.b	d6,stac(a1)
	move.b	d1,panstr(a1)		; pan lrset
	move.b	d5,lcont(a1)		; length counter set

	moveq	#0,d0
	move.w	(a4)+,d0		; rel. table pointer addr get (word)
	add.l	a3,d0			; absolute addr making.
	move.l	d0,tbpon(a1)
	move.w	(a4)+,bias(a1)		; bias,volm send (word)

	adda.w	d6,a1			; flgvol add --> next channel
	dbra	d7,?loop_fm

;--------------< ch6 scan >-------------;
	cmpi.b	#7,hd_fmch_no(a3)	; if FM channel total � 7
	bne.s	?pcm_use		; then jump

;--------------< ch6 = FM >-------------;
	moveq	#dsel,d0		; d0 = 6ch d/a or FM select registor
	moveq	#0,d1			; d1 = 6ch FM select data
	jsr	opn1_wrt(pc)	; write
	bra	?psg_headder		; jump
;--------------< ch6 = pcm >------------;
?pcm_use:
	moveq	#key_cont,d0		; d0 = key on/off
	moveq	#$06,d1			; d1 = 6ch key off
	jsr	opn1_wrt(pc)	; write
	
	move.b	#t_lvl+2,d0		; LR registor
	moveq	#$7f,d1			; LR data
	jsr	opn2_wrt(pc)		; ch6 direct write
	
	move.b	#t_lvl+10,d0		; LR registor
	moveq	#$7f,d1			; LR data
	jsr	opn2_wrt(pc)		; ch6 direct write
	
	move.b	#t_lvl+6,d0		; LR registor
	moveq	#$7f,d1			; LR data
	jsr	opn2_wrt(pc)		; ch6 direct write
	
	move.b	#t_lvl+14,d0		; LR registor
	moveq	#$7f,d1			; LR data
	jsr	opn2_wrt(pc)		; ch6 direct write

	move.b	#lr_mod+2,d0		; LR registor
	move.b	#$c0,d1			; LR data
	jsr	opn2_wrt(pc)		; ch6 direct write

;================< PSG >================;
?psg_headder:
	moveq	#0,d7			; d7 clear
	move.b	hd_psgch_no(a3),d7	; d7 = PSG use channel total
	beq.s	?end
	subq.b	#1,d7
	lea	psg_wk_top(a6),a1	; a1 = ram addr
	lea	psg_chan_tb(pc),a2	; a2 = channel table
?loop_psg:
	bset.b	#7,(a1)			; flag set
	move.b	(a2)+,chian(a1)		; channel set
	move.b	d4,cbase(a1)		; base set
	move.b	d6,stac(a1)
	move.b	d5,lcont(a1)		; length counter set

	moveq	#0,d0
	move.w	(a4)+,d0		; rel. table pointer addr get (word)
	add.l	a3,d0			; absolute addr making.
	move.l	d0,tbpon(a1)
	move.w	(a4)+,bias(a1)		; bias,volm send (word)
	move.b	(a4)+,d0
	move.b	(a4)+,enve(a1)		; enve set

	adda.w	d6,a1			; flgvol add --> next channel
	dbra	d7,?loop_psg
?end:
;=======================================;
;      se use channel write protect	;
;=======================================;
;================< s.e >================;
	lea	fm_se_wk_top(a6),a1	; a5 = se work ram top
	moveq	#se_no-1,d7		; d7 = counter
?loop_se:
	tst.b	(a1)			; if enable off
	bpl	?next			; then next
	moveq	#0,d0			; d0 = clear
	move.b	chian(a1),d0		; d0 = channel no.
	bmi.s	?psg_se
;----------< channel enable >-----------;
	subq.b	#2,d0
	lsl.b	#2,d0			; 2->$00 , 3->$04 , 4->$08 , 5->$0C
	bra.s	?jump1
?psg_se:
	lsr.b	#3,d0			; $80->$10 , $A0->$14 , $C0->$18
?jump1:
	lea	se_song_tb(pc),a0	; a0 = song channel table
	movea.l	(a0,d0.w),a0		; a5 = enable channel address (song)
	bset.b	#_wr,(a0)		; write protect on
?next:
	adda.w	d6,a1
	dbra	d7,?loop_se

;==============< back s.e >=============;
	tst	back_se_wk(a6)
	bpl.s	?jump2
	bset.b	#_wr,fm4_wk(a6)		; write protect on
?jump2:
	tst	back_se2_wk(a6)
	bpl.s	?jump3
	bset.b	#_wr,psg2_wk(a6)	; write protect on
?jump3:
;=======================================;
;	     FM off & PSG off		;
;=======================================;
;=================< FM >================;
	lea	fm_wk_top(a6),a5	; channel ram top
	moveq	#fm_no-1,d4		; FM total
?loop_fm2:
	jsr	key_off(pc)		; (look _wr)
	adda.w	d6,a5
	dbra	d4,?loop_fm2

;=================< PSG >===============;
	moveq	#psg_no-1,d4		; PSG total
?loop_psg2:
	jsr	psg_off(pc)		; (look _wr)
?psg_next:
	adda.w	d6,a5
	dbra	d4,?loop_psg2

?jump4:
	addq.w	#4,sp			; 2 return
	rts

fm_chan_tb:
	dc.b	6,0,1,2,4,5,6		; FM channel data
	even
psg_chan_tb:
	dc.b	$80,$a0,$c0		; PSG channel data
	even

;=======================================;
;					;
;		 SE SCAN		;
;					;
;=======================================;
; in d7 = key no.
sescan:
	tst.b	oneupfl(a6)
	bne	?clrpri
	tst.b	foutfl(a6)
	bne	?clrpri
	tst.b	finfl(a6)
	bne	?clrpri
	cmpi.b	#$b5,d7
	bne.s	?jumpnring
	tst.b	ringfl(a6)
	bne.s	?jump
	move.b	#$ce,d7
?jump:
	bchg.b	#0,ringfl(a6)
?jumpnring:
	cmpi.b	#$a7,d7
	bne.s	?jumpnpush
	tst.b	pushfl(a6)
	bne	?jump2
	move.b	#$80,pushfl(a6)
?jumpnpush:
	movea.l	sound_top+hd_setb*4,a0	; a0 = setb address
	subi.b	#sestrt,d7		; d7 = key no. - se start no.
	lsl.w	#2,d7			; *4 (for long word)
	movea.l	(a0,d7.w),a3		; a3 = S?? se top
	movea.l	a3,a1			; a1 = S?? se top
;--------< voice table top get >--------;
	moveq	#0,d1
	move.w	(a1)+,d1		; rel. voice address (word)
	add.l	a3,d1			; abs. voice address (long word)
;-------< base,use channel total >------;
	move.b	(a1)+,d5		; d5 = base
	move.b	(a1)+,d7		; d7 = use channel total
	subq.b	#1,d7			; counter

	moveq	#flgvol,d6		; d6 = flgvol
;=======================================;
;	 s.e headder set to ram		;
;=======================================;
?loop:
;------< dischannel address get >-------;
	moveq	#0,d3			; d3 clear
	move.b	hd_sech_no(a1),d3	; d3 = channel no 
	move.b	d3,d4			; d4 = channel
	bmi.s	?psg
?fm:
	subq.w	#2,d3			
	lsl.w	#2,d3			; $02->$00 $03->$04 $04->$08 $05->$0C
	lea	se_song_tb(pc),a5	; song channel off ram
	movea.l	(a5,d3.w),a5		; song channel off ram
	bset.b	#_wr,(a5)		; write protect on
	bra.s	?header
?psg:
	lsr.w	#3,d3			; $80->$10 $A0->$14 $C0->$18
	lea	se_song_tb(pc),a5	; song channel off ram
	movea.l	(a5,d3.w),a5		; song channel off ram
	bset.b	#_wr,(a5)		; write protect on
	cmpi.b	#$c0,d4			; if channel � $c0
	bne.s	?header			; then jump
	move.b	d4,d0			; channel data
	ori.b	#$1f,d0			; PSG off data
	move.b	d0,psg68k		; PSG off write
	bchg	#5,d0			; $c0->$e0 $e0->$c0
	move.b	d0,psg68k		; PSG off write
?header:
;-------< header ram address get >------;
	move.l	se_ram_tb(pc,d3.w),a5	; a5 = header send ram addr.
	movea.l	a5,a2
;-------< s.e channel ram clear >-------;
	moveq	#flgvol/4-1,d0
?loop1:
	clr.l	(a2)+			; ram clear
	dbra	d0,?loop1

;--------< header ram data set >--------;
	move.w	(a1)+,(a5)		; flag,channel set
	move.b	d5,cbase(a5)		; base set
	moveq	#0,d0			; d0 clear
	move.w	(a1)+,d0		; rel. table pointer
	add.l	a3,d0			; abs. table pointer
	move.l	d0,tbpon(a5)		; table pointer set
	move.w	(a1)+,bias(a5)		; bias, volm set
	move.b	#1,lcont(a5)		; length counter set
	move.b	d6,stac(a5)		; stac (flgvol) set
	tst.b	d4			; if channel = PSG
	bmi.s	?pass1			; then pass
	move.b	#$c0,panstr(a5)		; FM pan store
	move.l	d1,fm_voice(a5)
?pass1:
	dbra	d7,?loop

	tst.b	fm_se2_wk(a6)		; if FM s.e2 enable off
	bpl.s	?jump1			; then jump
	bset.b	#_wr,back_se_wk(a6)	; back s.e write protect on
?jump1:
	tst.b	psg_se3_wk(a6)		; if PSG s.e3 enable
	bpl.s	?jump2			; then jump
	bset.b	#_wr,back_se2_wk(a6)	; back s.e2 write protect on
?jump2:
	rts
?clrpri:
	clr.b	prfl(a6)
	rts

se_song_tb:
	dc.l	fm2_wk+sound_ram	; FM 2ch
	dc.l	0			; dummy
	dc.l	fm4_wk+sound_ram	; FM 4ch
	dc.l	fm5_wk+sound_ram	; FM 5ch
	dc.l	psg0_wk+sound_ram	; PSG 80ch
	dc.l	psg1_wk+sound_ram	; PSG A0ch
	dc.l	psg2_wk+sound_ram	; PSG C0ch
	dc.l	psg2_wk+sound_ram	; PSG E0ch (for CMEND)

se_ram_tb:
	dc.l	fm_se1_wk+sound_ram	; FM 2ch
	dc.l	0			; dummy
	dc.l	fm_se2_wk+sound_ram	; FM 4ch
	dc.l	fm_se3_wk+sound_ram	; FM 5ch
	dc.l	psg_se1_wk+sound_ram	; PSG 80ch
	dc.l	psg_se2_wk+sound_ram	; PSG A0ch
	dc.l	psg_se3_wk+sound_ram	; PSG C0ch
	dc.l	psg_se3_wk+sound_ram	; PSG E0ch (for CMEND)


;=======================================;
;					;
;	      BACK SE SCAN		;
;					;
;=======================================;
; in d7 = key no.
backscan:
	tst.b	oneupfl(a6)
	bne	?jump2
	tst.b	foutfl(a6)
	bne	?jump2
	tst.b	finfl(a6)
	bne	?jump2
	movea.l	sound_top+hd_backtb*4,a0 ; a0 = backtb address
	subi.b	#bkstrt,d7
	lsl.w	#2,d7			; long word table
	movea.l	(a0,d7.w),a3		; a3 = back se header address
	movea.l	a3,a1			; a1 = back se header address
;--------< voice table top get >--------;
	moveq	#0,d0
	move.w	(a1)+,d0		; rel. voice address (word)
	add.l	a3,d0			; abs. voice address (long word)
	move.l	d0,back_voice_addr(a6)	; back se voice address store
;-------< base,use channel total >------;
	move.b	(a1)+,d5		; d5 = base
	move.b	(a1)+,d7		; d7 = use channel total
	subq.b	#1,d7			; counter

	moveq	#flgvol,d6		; d6 = flgvol
;=======================================;
;      back s.e headder set to ram	;
;=======================================;
?loop:
	move.b	hd_sech_no(a1),d4	; d4 = channel
	bmi.s	?psg

	bset.b	#_wr,fm4_wk(a6)		; song write protect on
	lea	back_se_wk(a6),a5	; back se1
	bra.s	?header
?psg:
	bset.b	#_wr,psg2_wk(a6)	; song write protect on
	lea	back_se2_wk(a6),a5	; back se2

;-------< header ram address get >------;
?header:
	movea.l	a5,a2
;----< bsck s.e channel ram clear >-----;
	moveq	#flgvol/4-1,d0
?loop1:
	clr.l	(a2)+			; ram clear
	dbra	d0,?loop1

;--------< header ram data set >--------;
	move.w	(a1)+,(a5)		; flag,channel set
	move.b	d5,cbase(a5)		; base set
	moveq	#0,d0			; d0 clear
	move.w	(a1)+,d0		; rel. table pointer
	add.l	a3,d0			; abs. table pointer
	move.l	d0,tbpon(a5)		; table pointer set
	move.w	(a1)+,bias(a5)		; bias, volm set
	move.b	#1,lcont(a5)		; length counter set
	move.b	d6,stac(a5)		; stac (flgvol) set
	tst.b	d4			; if channel = PSG
	bmi.s	?pass1			; then pass
	move.b	#$c0,panstr(a5)		; FM pan store
?pass1:
	dbra	d7,?loop

	tst.b	fm_se2_wk(a6)		; if FM s.e2 enable off
	bpl.s	?jump1			; then jump
	bset.b	#_wr,back_se_wk(a6)	; back se write protect on
?jump1:
	tst.b	psg_se3_wk(a6)		; if PSG s.e3 enable off
	bpl.s	?jump2
	bset.b	#_wr,back_se2_wk(a6)	; back se2 write protect on
	ori.b	#$1f,d4			; PSG off data
	move.b	d4,psg68k		; PSG off write
	bchg	#5,d4			; $c0->$e0 $e0->$c0
	move.b	d4,psg68k		; PSG off write
?jump2:
	rts

bse_song_tb:
	dc.l	fm4_wk+sound_ram	; FM 4ch
	dc.l	psg2_wk+sound_ram	; PSG C0ch
bse_se_tb:
	dc.l	fm_se2_wk+sound_ram	; FM 4ch
	dc.l	psg_se3_wk+sound_ram	; PSG E0ch (NOISE MODE USE)
bse_ram_tb:
	dc.l	back_se_wk+sound_ram	; FM 4ch
	dc.l	back_se2_wk+sound_ram	; PSG E0ch (NOISE MODE USE)

;=======================================;
;					;
;		 SE CUT			;
;					;
;=======================================;
secut:
	clr.b	prfl(a6)		; priority flag reset

*	moveq	#mode_tim,d0
*	moveq	#nomal_mode,d1
*	jsr	opn1_wrt(pc)

	lea	fm_se_wk_top(a6),a5	; a5 = se work ram top
	moveq	#se_no-1,d7		; d7 = counter
?loop:
	tst.b	(a5)			; if enable off
	bpl	?next			; then next
	bclr.b	#_en,(a5)		; s.e enable off
	moveq	#0,d3			; d3 = clear
	move.b	chian(a5),d3		; d3 = channel no.
	bmi.s	?psg
;==============< secut FM >=============;
;--------------< key off >--------------;
	jsr	key_off(pc)		;
;----------< channel enable >-----------;
	cmpi.b	#4,d3			; if channel � 4
	bne.s	?jump1
	tst.b	back_se_wk(a6)		; if back s.e enable off
	bpl.s	?jump1
	lea	back_se_wk(a6),a5	; a5 = back s.e ram
	movea.l	back_voice_addr(a6),a1	; a1 = back s.e voice address
	bra.s	?jump2
?jump1:
	subq.b	#2,d3
	lsl.b	#2,d3			; 2->$00 , 3->$04 , 4->$08 , 5->$0C
	lea	se_song_tb(pc),a0	; a0 = song channel table
	movea.l	a5,a3			; a5 store
	movea.l	(a0,d3.w),a5		; a5 = enable channel address (song)
	movea.l	sng_voice_addr(a6),a1	; a1 = song voice address
;----------< song voice set >-----------;
?jump2:
	bclr.b	#_wr,(a5)		; write protect off
	bset.b	#_nl,(a5)		; null flag set

	move.b	enve(a5),d0		; d0 = voice no
	jsr	jfenv0(pc)		; song voice set (in a1=voice address)
	movea.l	a3,a5			; a5 restore
	bra.s	?next
;=============< secut PSG >=============;
?psg:
;--------------< PSG off >--------------;
	jsr	psg_off(pc)		;
;----------< channel enable >-----------;
	lea	back_se2_wk(a6),a0	; a0 = back s.e2 ram
	cmpi.b	#$e0,d3			; if channel � $e0
	beq.s	?jump3			; then jump
	cmpi.b	#$c0,d3			; if channel � $c0
	beq.s	?jump3			; then jump
	lsr.b	#3,d3			; $80->$10 , $A0->$14 , $C0->$18
	lea	se_song_tb(pc),a0	; a0 = song channel table
	movea.l	(a0,d3.w),a0		; a0 = enable channel address (song)
?jump3:
;-------------< flag set >--------------;
	bclr.b	#_wr,(a0)		; write protect off
	bset.b	#_nl,(a0)		; null flag set
	cmpi.b	#$e0,chian(a0)		; if channel � $e0 (noise mode)
	bne.s	?next			; then jump
	move.b	ntype(a0),psg68k	; noise mode recover
?next:
	adda.w	#flgvol,a5
	dbra	d7,?loop

	rts
;=======================================;
;					;
;     BACK SE CUT & SONG VOICE SET	;
;					;
;=======================================;
backcut:
;==========< back s.e 1 (FM) >==========;
	lea	back_se_wk(a6),a5	; back s.e wk
	tst.b	(a5)			; if back s.e enable off
	bpl.s	?back2			; then next back s.e
	bclr.b	#_en,(a5)		; back s.e enable off
	btst.b	#_wr,(a5)		; if back s.e write protect on
	bne.s	?back2			; then next back s.e
	jsr	key_off0(pc)		; back s.e 1ch key off
	lea	fm4_wk(a6),a5		; song FM 4ch
	bclr.b	#_wr,(a5)		; song FM 4ch write protect off
	bset.b	#_nl,(a5)		; song FM 4ch null set
	tst.b	(a5)			; if song enable off
	bpl.s	?back2			; then jump
	movea.l	sng_voice_addr(a6),a1	; song voice address
	move.b	enve(a5),d0		; d0 = voice no
	jsr	jfenv0(pc)		; song voice set
;==========< back s.e 1 (PSG) >=========;
?back2:
	lea	back_se2_wk(a6),a5	; back s.e2 wk
	tst.b	(a5)			; if back s.e2 enable off
	bpl.s	?end			; then jump
	bclr.b	#_en,(a5)		; back s.e2 enable off
	btst.b	#_wr,(a5)		; if back s.e write protect on
	bne.s	?end			; then jump
	jsr	psg_off0(pc)		; back s.e2 PSG off
	lea	psg2_wk(a6),a5		; song PSG C0ch
	bclr.b	#_wr,(a5)		; song PSG C0ch write protect off
	bset.b	#_nl,(a5)		; song PSG C0ch null set
	tst.b	(a5)			; if song PSG C0ch enable off
	bpl.s	?end			; then jump
	cmpi.b	#$e0,chian(a5)		; if channel � $e0 (noise mode)
	bne.s	?end			; then jump
	move.b	ntype(a5),psg68k	; noise mode write
?end:
	rts
;=======================================;
;					;
;	   FAID OUT SET (REQUEST)	;
;					;
;=======================================;
fout:
	jsr	secut(pc)		; se cut
	jsr	backcut(pc)		; backse cut
	move.b	#fout_ct0,fouttm(a6)	; fout timer
	move.b	#fout_ct1,foutfl(a6)	; interrupt
	clr.b	pcm_rythm_wk(a6)	; rythm off(flag set 0)
	clr.b	speedup(a6)
	rts
;=======================================;
;					;
;	     FAID OUT CHECK		;
;					;
;=======================================;
fout_chk:
	move.b	fouttm(a6),d0		; if fout timer =0
	beq.s	fout_cnt		; then jump
	subq.b	#1,fouttm(a6)		; not 0 then fouttm -1
?end:
	rts

;---------------------------------------;
;	   FAID OUT END CHECK		;
;---------------------------------------;
fout_cnt:
	subq.b	#1,foutfl(a6)		; foutfl= foutfl--
	beq	chamus			; if foutfl= 0 then sound clear

;---------------------------------------;
;	    FOUT VOLM SET (FM)	  	;
;---------------------------------------;
fout_fm:
	move.b	#fout_ct0,fouttm(a6)	; fouttm reset
	lea	fm_wk_top(a6),a5	; a5 = tone ram top
	moveq	#fm_no-1,d7		; counter
?loop:
	tst.b	(a5)			; if disable
	bpl.s	?pass			; then jump

	addq.b	#1,volm(a5)		; volm add
	bpl.s	?jump			; if volm = plus then jump0
	bclr.b	#_en,(a5)		; if volm = minus ($80) then disable
	bra.s	?pass
?jump:
	jsr	vol_set(pc)
?pass:
	adda.w	#flgvol,a5
	dbra	d7,?loop

;---------------------------------------;
;	    FOUT VOLM SET (PSG)  	;
;---------------------------------------;
fout_psg:				; a5 = PSG ram top
	moveq	#psg_no-1,d7		; counter
?loop:
	tst.b	(a5)			; if disable
	bpl.s	?pass			; then jump
	addq.b	#1,volm(a5)
	cmpi.b	#$10,volm(a5)		; if volm < $10
	bcs.s	?jump			; then jump
	bclr.b	#_en,(a5)		; if volm = minus ($80) then disable
	bra.s	?pass
?jump:
	move.b	volm(a5),d6		; d6 = volm data
	jsr	psg_att_set(pc)		; in d6 = volm
?pass:
	adda.w	#flgvol,a5
	dbra	d7,?loop

	rts

;=======================================;
;					;
;     TOTAL LEVEL & RELEASE OFF (1ch)	;
;					;
;=======================================;
*tl_rr_off:
*	jsr	z80opn_chk(pc)		; z80 bus on
;==========< total level off >==========;
*	moveq	#4-1,d4
*	moveq	#TL1,d3			; TL registor
*	moveq	#$7f,d1			; total level off data
*?loop:
*	move.b	d3,d0			; d0 = TL? registor
*	jsr	opn_wrt(pc)
*	addq.b	#4,d3			; registor add
*	dbra	d4,?loop
;=========< release level off >=========;
*	moveq	#4-1,d4
*	move.b	#RR1,d3			; RR registor
*	moveq	#$0f,d1			; RR off data
*?loop1:
*	move.b	d3,d0			; d0 = FM registor
*	jsr	opn_wrt(pc)
*	addq.b	#4,d3
*	dbra	d4,?loop1
*	z80bus_off
*	rts

;=======================================;
;					;
;		 FM OFF			;
;					;
;=======================================;
fm_clear:
;============< all key off >============:
	moveq	#3-1,d3			; channel no. total /2
	moveq	#key_cont,d0		; d0 = key on/off registor
?loop0:
	move.b	d3,d1			; d1 clear
	jsr	opn1_wrt(pc)		; channel 2->1->0
	addq.b	#4,d1			; key off channel add
	jsr	opn1_wrt(pc)		; channel 6->5->4
	dbra	d3,?loop0

;========< all total level off >========:
	moveq	#$40,d0			; registor
	moveq	#$7f,d1			; total level off data
	moveq	#3-1,d4			; channel total /2
?loop1:
	moveq	#4-1,d3			; slot no.
?loop2:
	jsr	opn1_wrt(pc)
	jsr	opn2_wrt(pc)
	addq.w	#4,d0			; next slot making
	dbra	d3,?loop2

	subi.b	#15,d0			; next channel reg no. making
	dbra	d4,?loop1

	rts
;=======================================;
;					;
;	   SOUND RAM CLEAR (ALL)	;
;					;
;=======================================;
chamus:
;------------< D/A mode set >-----------;
	moveq	#dsel,d0
	move.b	#$80,d1			; d/a mode set
	jsr	opn1_wrt(pc)
;----------< normal mode set >----------;
	moveq	#mode_tim,d0
	moveq	#nomal_mode,d1
	jsr	opn1_wrt(pc)
;-------------< ram clear >-------------;
	movea.l	a6,a0			; a0 = sound ram
	move.w	#(chian_no*flgvol+$30)/4-1,d0
?loop:
	clr.l	(a0)+
	dbra	d0,?loop

	move.b	#$80,kyflag0(a6)	; ky no.set
	jsr	fm_clear(pc)
	bra	psg_clear
;=======================================;
;					;
;	SOUND RAM CLEAR (SONG ONLY)	;
;					;
;=======================================;
chamus2:
	movea.l	a6,a0			; a0 = sound ram
	move.b	prfl(a6),d1		; priority store
	move.b	oneupfl(a6),d2
	move.b	speedup(a6),d3
	move.b	fintm(a6),d4
	move.w	kyflag(a6),d5
	move.w	#((7+3)*flgvol+$40)/4-1,d0
?loop:
	clr.l	(a0)+
	dbra	d0,?loop
	move.b	d1,prfl(a6)		; priority set
	move.b	d2,oneupfl(a6)
	move.b	d3,speedup(a6)
	move.b	d4,fintm(a6)
	move.w	d5,kyflag(a6)
	move.b	#$80,kyflag0(a6)	; ky no.set

	jsr	fm_clear(pc)
	bra	psg_clear
*	rts
;=======================================;
;					;
;	  DELAY CONTROL (SONG ONLY)	;
;					;
;=======================================;
delcont:
	move.b	cuntst(a6),rcunt(a6)	; counter set
	lea	wk_top+lcont(a6),a0		; work ram top
	moveq	#flgvol,d0
	moveq	#song_no-1,d1
?loop:
*	tst.b	(a0)			; if enable flag off
*	bpl.s	?next
	addq.b	#1,(a0)		; lcont +1
*?next:
	adda.w	d0,a0			; channel ram add
	dbra	d1,?loop
?end:
	rts
	
speedupmus:
	tst.b	oneupfl(a6)
	bne.s	?oneup
	move.b	sptempo(a6),cuntst(a6)
	move.b	sptempo(a6),rcunt(a6)
	move.b	#$80,speedup(a6)
	rts
?oneup:
	move.b	oneupwk+sptempo(a6),oneupwk+cuntst(a6)
	move.b	oneupwk+sptempo(a6),oneupwk+rcunt(a6)
	move.b	#$80,oneupwk+speedup(a6)
	rts
	
slowdownmus:
	tst.b	oneupfl(a6)
	bne.s	?oneup
	move.b	tempo(a6),cuntst(a6)
	move.b	tempo(a6),rcunt(a6)
	clr.b	speedup(a6)
	rts
?oneup:
	move.b	oneupwk+tempo(a6),oneupwk+cuntst(a6)
	move.b	oneupwk+tempo(a6),oneupwk+rcunt(a6)
	clr.b	oneupwk+speedup(a6)
	rts
;=======================================;
;					;
;	     FAID IN CHECK		;
;					;
;=======================================;
fin_chk:
	tst.b	fintm_ct(a6)		; if fout timer =0
	beq.s	fin_cnt		; then jump
	subq.b	#1,fintm_ct(a6)		; not 0 then fouttm -1
?end:
	rts

;---------------------------------------;
;	   FAID IN END CHECK		;
;---------------------------------------;
fin_cnt:
	tst.b	fintm(a6)		; foutfl= foutfl--
	beq.s	fin_done			; if foutfl= 0 then sound clear

;---------------------------------------;
;	    FIN VOLM SET (FM)	  	;
;---------------------------------------;
fin_fm:
	subq.b	#1,fintm(a6)
	move.b	#fin_ct0,fintm_ct(a6)	; fouttm reset
	lea	fm_wk_top(a6),a5	; a5 = tone ram top
	moveq	#fm_no-1,d7		; counter
?loop:
	tst.b	(a5)			; if disable
	bpl.s	?pass			; then jump

	subq.b	#1,volm(a5)		; volm add
	jsr	vol_set(pc)
?pass:
	adda.w	#flgvol,a5
	dbra	d7,?loop

;---------------------------------------;
;	    FIN VOLM SET (PSG)  	;
;---------------------------------------;
fin_psg:				; a5 = PSG ram top
	moveq	#psg_no-1,d7		; counter
?loop:
	tst.b	(a5)			; if disable
	bpl.s	?pass			; then jump
	subq.b	#1,volm(a5)
	move.b	volm(a5),d6		; d6 = volm data
	cmpi.b	#$10,d6		; if volm < $10
	bcs.s	?jump			; then jump
	moveq	#$0f,d6
?jump:
	jsr	psg_att_set(pc)		; in d6 = volm
?pass:
	adda.w	#flgvol,a5
	dbra	d7,?loop

	rts
fin_done:
	bclr.b	#_wr,pcm_rythm_wk(a6)
	clr.b	finfl(a6)
	rts
;=======================================;
;					;
;		KEY ON			;
;					;
;=======================================;
key_on:
	btst.b	#_nl,(a5)		; if null flag = on
	bne.s	?end			; then end
;	btst.b	#_tie,(a5)		; if tie flag = on
;	bne.s	?end			; then end
	btst.b	#_wr,(a5)		; if write protect on
	bne.s	?end			; then end
	moveq	#key_cont,d0
	move.b	chian(a5),d1
	ori.b	#$f0,d1			; key on data
	bra	opn1_wrt
?end:
	rts
;=======================================;
;					;
;		KEY OFF			;
;					;
;=======================================;
key_off:
	btst.b	#_tie,(a5)		; if tie flag on
	bne.s	key_off_end		; then end
	btst.b	#_wr,(a5)		; if write protect on
	bne.s	key_off_end		; then end
key_off0:
	moveq	#key_cont,d0
	move.b	chian(a5),d1
	bra	opn1_wrt
key_off_end:
	rts
;=======================================;
;					;
;	 OPN BUSY CHECK & WRITE		;
;					;
;=======================================;
;	input	d0 = FM reg addr.
;		d1 = FM write data.
;		a5 = ram top
opn_wrt_chk:
	btst.b	#_wr,(a5)		; if write protect on
	bne.s	?end			; then end
	bra	opn_wrt		; chip write
?end:
	rts
;=======================================;
;					;
;	       OPN WRITE		;
;					;
;=======================================;
;	input	d0 = FM reg addr.
;		d1 = FM write data.
;		a5 = ram top
opn_wrt:
;----------< OPN 1 or 2 scan >----------;
	btst.b	#2,chian(a5)
	bne.s	opn2_wrt0
	add.b	chian(a5),d0		; d0 = FM registor
;------------< OPN 1 write >------------;
opn1_wrt:
?loop1:
	move.b	opn_status,d2
	btst	#7,d2			; opn status busy bit
	bne.s	?loop1
	move.b	d0,opn1_adr		; FM registor set
	nop
	nop
	nop
?loop2:
	move.b	opn_status,d2
	btst	#7,d2			; opn status busy bit
	bne.s	?loop2
	move.b	d1,opn1_data	; FM data set
	rts
;------------< OPN 2 write >------------;
opn2_wrt0:				;
	move.b	chian(a5),d2		; d2 = channel data
	bclr	#2,d2			; 
	add.b	d2,d0			; FM registor
opn2_wrt:
?loop1:
	move.b	opn_status,d2
	btst	#7,d2			; opn status busy bit
	bne.s	?loop1
	move.b	d0,opn2_adr		; FM registor set
	nop
	nop
	nop
?loop2:
	move.b	opn_status,d2
	btst	#7,d2			; opn status busy bit
	bne.s	?loop2
	move.b	d1,opn2_data	; FM data set
	rts

;=======================================;
;					;
;		FM SCALE		;
;					;
;=======================================;
frq_c		equ	606		; 284h		26ah
frq_cs		equ	644		; 284h		26ah
frq_d		equ	683		; 2abh		28fh
frq_ds		equ	723		; 2d3h		2b6h
frq_e		equ	766		; 2feh		2dfh
frq_f		equ	813		; 32dh		30bh
frq_fs		equ	860		; 35ch		339h
frq_g		equ	911		; 38fh		36ah
frq_gs		equ	965		; 3c5h		39eh
frq_a		equ	1023		; 3ffh		3d5h
frq_as		equ	1084		; 43ch   /542	410h
frq_b		equ	1148		; 47ch   /574	44eh
frq_c1		equ	1216		; 4c0h   /606	48fh

fm_scale:
;	dc.w	frq_c,frq_cs,frq_d,frq_ds,frq_e,frq_f
;	dc.w	frq_fs,frq_g,frq_gs,frq_a,frq_as,frq_b
	dc.w  $25E, $284, $2AB,	$2D3, $2FE, $32D, $35C,	$38F; 0
	dc.w  $3C5, $3FF, $43C,	$47C, $A5E, $A84, $AAB,	$AD3; 8
	dc.w  $AFE, $B2D, $B5C,	$B8F, $BC5, $BFF, $C3C,	$C7C; 16
	dc.w $125E,$1284,$12AB,$12D3,$12FE,$132D,$135C,$138F; 24
	dc.w $13C5,$13FF,$143C,$147C,$1A5E,$1A84,$1AAB,$1AD3; 32
	dc.w $1AFE,$1B2D,$1B5C,$1B8F,$1BC5,$1BFF,$1C3C,$1C7C; 40
	dc.w $225E,$2284,$22AB,$22D3,$22FE,$232D,$235C,$238F; 48
	dc.w $23C5,$23FF,$243C,$247C,$2A5E,$2A84,$2AAB,$2AD3; 56
	dc.w $2AFE,$2B2D,$2B5C,$2B8F,$2BC5,$2BFF,$2C3C,$2C7C; 64
	dc.w $325E,$3284,$32AB,$32D3,$32FE,$332D,$335C,$338F; 72
	dc.w $33C5,$33FF,$343C,$347C,$3A5E,$3A84,$3AAB,$3AD3; 80
	dc.w $3AFE,$3B2D,$3B5C,$3B8F,$3BC5,$3BFF,$3C3C,$3C7C; 88

;=======================================;
;	      END OF FILE		;
;=======================================;

