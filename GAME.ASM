;----------------------------------------------------------------------------
;Music playing array
;----------------------------------------------------------------------------
bgmtbl:
		dc.b $81,$82,$83,$84,$85,$86,$8D
		even
game:
		bset.b	#7,gmmode ; Add 80 to screen mode
		tst.w	demoflag
		bmi.b	loc_37B6
		move.b	#$e0,d0		; Fade out all sounds
		bsr.w	soundset
loc_37B6:
		bsr.w	sub_15DE
		bsr.w	sub_1E52
		tst.w	demoflag
		bmi.b	loc_3802
		move.w	#$2700,sr
		move.l	#$70000002,VDP_CTRL
		lea	ArtNem_TitleCards,a0
		bsr.w	bitdevdatr
		move.w	#$2300,sr
		moveq	#0,d0		; Clear	d0
		move.b	stageno,d0 ; Move	level to d0
		lsl.w	#4,d0		; d0 * 8
		lea	mapinittbl,a2 ;	Load main level	load block to a2
		lea	(a2,d0.w),a2
		moveq	#0,d0
		move.b	(a2),d0
		beq.b	loc_37FC
		bsr.w	PlcLoad_1580
loc_37FC:
		moveq	#1,d0
		bsr.w	PlcLoad_1580	; Load standard	block 2	plc
loc_3802:
		lea	actwk,a1
		moveq	#0,d0
		move.w	#$2000/4-1,d1
loc_380C:
		move.l	d0,(a1)+
		dbf	d1,loc_380C
		lea	$FFFFF628,a1
		moveq	#0,d0
		move.w	#$58/4-1,d1
loc_381C:
		move.l	d0,(a1)+
		dbf	d1,loc_381C
		lea	scra_h_posit,a1
		moveq	#0,d0
		move.w	#$100/4-1,d1
loc_382C:
		move.l	d0,(a1)+
		dbf	d1,loc_382C
		lea	$FFFFFE60,a1
		moveq	#0,d0
		move.w	#$120/4-1,d1
loc_383C:
		move.l	d0,(a1)+
		dbf	d1,loc_383C
		move.w	#$2700,sr
		bsr.w	scrinit
		lea	VDP_CTRL,a6
		move.w	#$8b00+%00000011,(a6)
		move.w	#$8200+vram_plane_a>>10,(a6)
		move.w	#$8400+vram_plane_b>>13,(a6)
		move.w	#$8500+vram_sprtbl>>9,(a6)
		move.w	#$9000+%00000001,(a6)
		move.w	#$8000+%00000100,(a6)
		move.w	#$8700+$02<<4+$00,(a6)
		move.w	#$8a00+224-1,hintposi
		move.w	hintposi,(a6)
		cmpi.b	#1,stageno
		bne.b	loc_38AE	; If level isn't LZ, branch
		move.w	#$8000+%00010100,(a6)
		moveq	#0,d0
		move.b	stageno+1,d0 ; Move	act to d0
		add.w	d0,d0		; d0 * 2
		lea	WaterLevels,a1 ; Load water	level array
		move.w	(a1,d0.w),d0	; Load water level to d0
		move.w	d0,waterposi ; Load	d0 to water level
		move.w	d0,waterposi_m ; Load	d0 to set water	level
		move.w	d0,watermoveposi ; Load	d0 to real water level
		clr.b	water_flag
		clr.b	waterflag
		move.b	#1,waterspeed ; Enable water
loc_38AE:
		move.w	#30,$FFFFFE14
		move.w	#$2300,sr
		moveq	#3,d0
		bsr.w	PalLoad		; Load primary palette line
		cmpi.b	#1,stageno
		bne.b	loc_38E2	; If level isn't LZ, branch
		moveq	#$f,d0		; Move 0F to d0
		cmpi.b	#3,stageno+1
		bne.b	loc_38D2	; If act isn't 03, branch
		moveq	#$10,d0		; Move 10 to d0
loc_38D2:
		bsr.w	UnderwaterPalLoad ; Load underwater palette at d0
		tst.b	$FFFFFE30
		beq.b	loc_38E2
		move.b	$FFFFFE53,waterflag
loc_38E2:
		tst.w	demoflag
		bmi.b	loc_3946
		moveq	#0,d0
		move.b	stageno,d0 ; Move	level to d0
		cmpi.w	#$103,stageno
		bne.b	loc_38F8	; If level isn't SBZ3, branch
		moveq	#5,d0		; Load 5 to d0
loc_38F8:
		cmpi.w	#$502,stageno
		bne.b	loc_3902	; If level isn't FZ, branch
		moveq	#6,d0		; Move 6 to d0
loc_3902:
		lea	bgmtbl.l,a1
		move.b	(a1,d0.w),d0
		bsr.w	bgmset
		move.b	#zone_act,$FFFFD000+$80+actno
loc_3916:
		move.b	#$c,vintmode
		bsr.w	sync
		jsr	Sonic_Load
		jsr	sub_D65E
		bsr.w	sub_15EC
		move.w	$FFFFD000+$100+xposi,d0
		cmp.w	$FFFFD000+$100+$30,d0
		bne.b	loc_3916
		tst.l	$FFFFF680
		bne.b	loc_3916
		jsr	sub_1C822
loc_3946:
		moveq	#3,d0
		bsr.w	PalLoad_Unk1
		bsr.w	sub_5EBE
		bsr.w	sub_6286
		bset.b	#2,$FFFFF754
		bsr.w	sub_6CA6
		bsr.w	sub_6C58
		jsr	nullsub_1
		bsr.w	ColIndexLoad
		bsr.w	sub_3BD0
		move.b	#play00_act,playerwk+actno
		tst.w	demoflag
		bmi.b	loc_3982
		move.b	#score_act,$FFFFD000+$40+actno
loc_3982:
		tst.b	$FFFFFFE2
		beq.b	loc_3996
		btst.b	#6,swdata1
		beq.b	loc_3996
		move.b	#1,debugflag
loc_3996:
		move.w	#0,swdata
		move.w	#0,swdata1
		cmpi.b	#1,stageno
		bne.b	loc_39C2
		move.b	#wave_act,$FFFFD000+$780+actno
		move.w	#$60,$FFFFD000+$780+xposi
		move.b	#wave_act,$FFFFD000+$7C0+actno
		move.w	#$120,$FFFFD000+$7C0+xposi
loc_39C2:
		jsr	actset
		jsr	Sonic_Load
		jsr	sub_D65E
		moveq	#0,d0
		tst.b	$FFFFFE30
		bne.b	loc_39E8
		move.w	d0,$FFFFFE20 ; Clear rings
		move.l	d0,$FFFFFE22 ; Clear time
		move.b	d0,$FFFFFE1B
loc_39E8:
		move.b	d0,$FFFFFE1A
		move.b	d0,$FFFFFE2C
		move.b	d0,$FFFFFE2D
		move.b	d0,$FFFFFE2E
		move.b	d0,$FFFFFE2F
		move.w	d0,editmode
		move.w	d0,$FFFFFE02
		move.w	d0,$FFFFFE04
		bsr.w	sub_4118
		move.b	#1,$FFFFFE1F
		move.b	#1,$FFFFFE1D
		move.b	#1,$FFFFFE1E
		move.w	#0,$FFFFF790
		lea	demotbl,a1
		moveq	#0,d0
		move.b	stageno,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
		tst.w	demoflag
		bpl.b	loc_3A4E
		lea	enddemotbl,a1
		move.w	enddemono,d0
		subq.w	#1,d0
		lsl.w	#2,d0
		movea.l	(a1,d0.w),a1
loc_3A4E:
		move.b	1(a1),$FFFFF792
		subq.b	#1,$FFFFF792
		move.w	#1800,$FFFFF614
		tst.w	demoflag
		bpl.b	loc_3A78
		move.w	#540,$FFFFF614
		cmpi.w	#4,enddemono
		bne.b	loc_3A78
		move.w	#510,$FFFFF614
loc_3A78:
		cmpi.b	#1,stageno
		bne.b	loc_3A90
		moveq	#$b,d0
		cmpi.b	#3,stageno+1
		bne.b	loc_3A8C
		moveq	#$d,d0
loc_3A8C:
		bsr.w	PalLoad_Unk2
loc_3A90:
		move.w	#4-1,d1
loc_3A94:
		move.b	#8,vintmode
		bsr.w	sync
		dbf	d1,loc_3A94
		move.w	#$202f,startcolor
		bsr.w	sub_1DB2
		tst.w	demoflag
		bmi.b	loc_3AC4
		addq.b	#2,$FFFFD000+$80+r_no0
		addq.b	#4,$FFFFD000+$C0+r_no0
		addq.b	#4,$FFFFD000+$100+r_no0
		addq.b	#4,$FFFFD000+$140+r_no0
		bra.b	loc_3ADC
loc_3AC4:
		moveq	#2,d0
		jsr	PlcLoad_1580.l ; Load	explosion
		moveq	#0,d0
		move.b	stageno,d0
		addi.w	#$15,d0
		jsr	PlcLoad_1580.l ; Load	level animals
loc_3ADC:
		bclr.b	#7,gmmode ; Substract 80	from level
loc_3AE2:
		bsr.w	sub_13A8
		move.b	#8,vintmode
		bsr.w	sync
		addq.w	#1,$FFFFFE04
		bsr.w	sub_3FD0
		bsr.w	sub_3BD0
		jsr	Sonic_Load
		tst.w	editmode
		bne.b	loc_3B10
		cmpi.b	#6,playerwk+r_no0
		bcc.b	loc_3B14
loc_3B10:
		bsr.w	sub_6286
loc_3B14:
		jsr	sub_D65E
		jsr	actset
		bsr.w	clchgctr
		bsr.w	sub_15EC
		bsr.w	sub_416E
		bsr.w	sub_4206
		bsr.w	sub_4274
		cmpi.b	#demogamemd,gmmode
		beq.b	loc_3B50
		tst.w	$FFFFFE02
		bne.w	game
		cmpi.b	#gamemd,gmmode
		beq.w	loc_3AE2
		rts
loc_3B50:
		tst.w	$FFFFFE02
		bne.b	loc_3B6E
		tst.w	$FFFFF614
		beq.b	loc_3B6E
		cmpi.b	#demogamemd,gmmode
		beq.w	loc_3AE2
		move.b	#logogamemd,gmmode
		rts
loc_3B6E:
		cmpi.b	#demogamemd,gmmode
		bne.b	loc_3B88
		move.b	#logogamemd,gmmode
		tst.w	demoflag
		bpl.b	loc_3B88
		move.b	#$1c,gmmode
loc_3B88:
		move.w	#60,$FFFFF614
		move.w	#$3f,startcolor
		clr.w	$FFFFF794
loc_3B98:
		move.b	#8,vintmode
		bsr.w	sync
		bsr.w	sub_3FD0
		jsr	Sonic_Load
		jsr	sub_D65E
		jsr	actset
		subq.w	#1,$FFFFF794
		bpl.b	loc_3BC8
		move.w	#3-1,$FFFFF794
		bsr.w	sub_1E72
loc_3BC8:
		tst.w	$FFFFF614
		bne.b	loc_3B98
		rts