;---------------------------------------------------------------------------------------
;Title Screen
;---------------------------------------------------------------------------------------
title:
		move.b	#$e4,d0		; Stop all music
		bsr.w	soundset
		bsr.w	sub_15DE
		bsr.w	sub_1E52
		move.w	#$2700,sr
		bsr.w	sub_1352
		lea	VDP_CTRL,a6
		move.w	#$8000+%00000100,(a6)
		move.w	#$8200+%00110000,(a6)
		move.w	#$8400+%00000111,(a6)
		move.w	#$9000+%00000001,(a6)
		move.w	#$9200+%00000000,(a6)
		move.w	#$8B00+%00000011,(a6)
		move.w	#$8700+%00100000,(a6)
		clr.b	waterflag
		bsr.w	scrinit
		lea	actwk,a1
		moveq	#0,d0
		move.w	#$2000/4-1,d1
loc_2F64:
		move.l	d0,(a1)+
		dbf	d1,loc_2F64	; Fill FFD000 -	FFEFFF with 00
		move.l	#$40000000,VDP_CTRL ; RAM location to load Japanese Credits into
		lea	ArtNem_JapCredits,a0 ; Load	Japanese Credits
		bsr.w	bitdevr	; Decompress Japanese Credits
		move.l	#$54C00000,VDP_CTRL ; RAM location to load Alphabet into
		lea	ArtNem_Alphabet,a0 ; Load Alphabet
		bsr.w	bitdevr	; Decompress Alphabet
		lea	$FF0000,a1
		lea	Eni_HiddenJapCreditsMappings,a0
		move.w	#$000,d0
		bsr.w	mapdevr
		lea	$FF0000,a1
		move.l	#$40000003,d0
		moveq	#40-1,d1
		moveq	#28-1,d2
		bsr.w	sub_1420
		lea	$FFFFFB80,a1
		moveq	#0,d0
		move.w	#$80/4-1,d1
loc_2FC4:
		move.l	d0,(a1)+
		dbf	d1,loc_2FC4
		moveq	#3,d0
		bsr.w	PalLoad_Unk1
		move.b	#$8A,$FFFFD000+$80
		jsr	Sonic_Load
		jsr	sub_D65E
		bsr.w	sub_1DAC
		move.w	#$2700,sr
		move.l	#$40000001,VDP_CTRL
		lea	titlecg,a0
		bsr.w	bitdevr
		move.l	#$60000001,VDP_CTRL
		lea	titlespcg,a0
		bsr.w	bitdevr
		move.l	#$62000002,VDP_CTRL
		lea	ArtNem_TitleTM,a0
		bsr.w	bitdevr
		lea	VDP_DATA,a6
		move.l	#$50000003,4(a6)
		lea	ascii.l,a5
		move.w	#$0520/2-1,d1
loc_303E:
		move.w	(a5)+,(a6)
		dbf	d1,loc_303E
		move.b	#0,$FFFFFE30
		move.w	#0,editmode
		move.w	#0,demoflag
		move.w	#0,$FFFFFFEA
		move.w	#0,stageno
		move.w	#0,clchgtim
		bsr.w	sub_5EBE
		bsr.w	sub_6286
		lea	blkwk,a1
		lea	zone00blk,a0
		move.w	#$000,d0
		bsr.w	mapdevr
		lea	zone00map,a0
		lea	mapwk,a1
		bsr.w	unlze
		bsr.w	sub_6D12
		bsr.w	sub_1E52
		move.w	#$2700,sr
		bsr.w	scrinit
		lea	VDP_CTRL,a5
		lea	VDP_DATA,a6
		lea	$FFFFF708,a3
		lea	mapwkb,a4
		move.w	#$6000,d2
		bsr.w	sub_6C7E
		lea	$FF0000,a1
		lea	titlemap,a0
		move.w	#$000,d0
		bsr.w	mapdevr
		lea	$FF0000,a1
		move.l	#$42060003,d0
		moveq	#$22-1,d1
		moveq	#$16-1,d2
		bsr.w	sub_1420
		move.l	#$40000000,VDP_CTRL
		lea	ArtNem_Ghz8_1,a0
		bsr.w	bitdevr
		moveq	#1,d0
		bsr.w	PalLoad_Unk1
		move.b	#$8A,d0
		bsr.w	soundset
		move.b	#0,debugflag
		move.w	#376,$FFFFF614
		lea	$FFFFD000+$80,a1
		moveq	#0,d0
		move.w	#$0200/$40-1,d1	; This line has a slight error to it, the base value should be $0400 instead of $0200, resulting in the PRESS START BUTTON text not appearing in-game.
loc_311E:
		move.l	d0,(a1)+
		dbf	d1,loc_311E
		move.b	#$0e,$FFFFD000+$40
		move.b	#$0f,$FFFFD000+$80
		move.b	#$0f,$FFFFD000+$C0
		move.b	#$03,$FFFFD000+$C0+patno
		move.b	#$0f,$FFFFD000+$100
		move.b	#$02,$FFFFD000+$100+patno
		jsr	Sonic_Load
		bsr.w	sub_6286
		jsr	sub_D65E
		moveq	#0,d0
		bsr.w	PlcLoad_15B2
		move.w	#0,$FFFFFFE4
		move.w	#0,$FFFFFFE6
		move.w	$FFFFF60C,d0
		ori.b	#$40,d0
		move.w	d0,VDP_CTRL
		bsr.w	sub_1DAC
loc_317C:
		move.b	#4,$FFFFF62A
		bsr.w	sync
		jsr	Sonic_Load
		bsr.w	sub_6286
		jsr	sub_D65E
		bsr.w	AniPal_TitleScreen
		bsr.w	sub_15EC
		move.w	playerwk+xposi,d0
		addq.w	#2,d0
		move.w	d0,playerwk+xposi
		cmpi.w	#$1C00,d0
		bcs.b	loc_31B6	; If D008 isn't 1C00, branch
		move.b	#logogamemd,gmmode ; Set screen mode to 00 (sega screen)
		rts
loc_31B6:
		tst.b	mdstatus	; Check	if the machine is US or	Japanese
		bpl.b	loc_31C4	; If Japanese, branch
		lea	LevelSelectCode_US,a0 ; Load US code
sub_31C2:
		bra.b	loc_31CA
loc_31C4:
		lea	LevelSelectCode_J,a0 ; Load	J code
loc_31CA:
		move.w	$FFFFFFE4,d0 ; Level select	code stuff
		adda.w	d0,a0
		move.b	swdata1+1,d0
		andi.b	#$F,d0
		cmp.b	(a0),d0
		bne.b	loc_3210
		addq.w	#1,$FFFFFFE4
		tst.b	d0
		bne.b	loc_3222
		lea	$FFFFFFE0,a0
		move.w	$FFFFFFE6,d1
		lsr.w	#1,d1
		andi.w	#3,d1
		beq.b	loc_3200
		tst.b	$FFFFFFF8
		bpl.b	loc_3200
		moveq	#1,d1
		move.b	d1,1(a0,d1.w)
loc_3200:
		move.b	#1,(a0,d1.w)
		move.b	#$B5,d0		; Set ring sound
		bsr.w	soundset	; Play ring sound
		bra.b	loc_3222
loc_3210:
		tst.b	d0
		beq.b	loc_3222
		cmpi.w	#9,$FFFFFFE4
		beq.b	loc_3222
		move.w	#0,$FFFFFFE4
loc_3222:
		move.b	swdata1+1,d0
		andi.b	#$20,d0
		beq.b	loc_3230
		addq.w	#1,$FFFFFFE6
loc_3230:
		tst.w	$FFFFF614
		beq.w	loc_33B0
		andi.b	#$80,swdata1+1 ; Check if Start is pressed
		beq.w	loc_317C	; If not, go back
loc_3242:
		tst.b	$FFFFFFE0	; Check	if level select	code is	on
		beq.w	PlayLevel	; If not, play level
		btst.b	#6,swdata1 ; Check if A is pressed
		beq.w	PlayLevel	; If not, play level
		moveq	#2,d0		; Set level select palette
		bsr.w	PalLoad		; Load level select palette
		lea	$FFFFCC00,a1
		moveq	#0,d0
		move.w	#$0380/4-1,d1
loc_3264:
		move.l	d0,(a1)+
		dbf	d1,loc_3264
		move.l	d0,$FFFFF616
		move.w	#$2700,sr
		lea	VDP_DATA,a6
		move.l	#$60000003,VDP_CTRL
		move.w	#$1000/4-1,d1
loc_3286:
		move.l	d0,(a6)
		dbf	d1,loc_3286
		bsr.w	sub_34E6
loc_3290:
		move.b	#4,$FFFFF62A
		bsr.w	sync
		bsr.w	sub_3460
		bsr.w	sub_15EC
		tst.l	$FFFFF680
		bne.b	loc_3290
		andi.b	#$f0,swdata1+1 ; Check if A, B, C, or Start	is pressed
		beq.b	loc_3290	; If not, branch
		move.w	$FFFFFF82,d0 ; Move	selected option	to D0
		cmpi.w	#$14,d0		; Check	if the option is 14
		bne.b	LSelect_LevelOrSS ; If not, go to Level	or SS sub
		move.w	$FFFFFF84,d0 ; Move	selected sound to D0
		addi.w	#$80,d0	; Add 80 to D0
		tst.b	$FFFFFFE3	; Check	if Japanese Credits cheat is on
		beq.b	loc_32D4	; If not, branch
		cmpi.w	#$9f,d0	; Check if sound is 9F
		beq.b	LSelect_EndingSequence ; If yes, go to Ending Sequence sub
		cmpi.w	#$9e,d0	; Check if sound is 9E
		beq.b	LSelect_Credits	; If yes, go to	credits	sub
loc_32D4:
		cmpi.w	#$94,d0
		bcs.b	loc_32E0	; If d0	is smaller than	94, branch
		cmpi.w	#$a0,d0
		bcs.b	loc_3290	; If d0	is smaller than	A0, branch
loc_32E0:
		bsr.w	soundset	; Play selected	sound
		bra.b	loc_3290	; Go back
LSelect_EndingSequence:
		move.b	#$18,gmmode ; Set screen	mode to	18 (ending sequence)
		move.w	#$600,stageno ; Set level	to 0600	(ending	sequence)
		rts
LSelect_Credits:
		move.b	#$1c,gmmode ; Set screen	mode to	1C (credits)
		move.b	#$91,d0		; Load credits music
		bsr.w	soundset	; Play credits music
		move.w	#0,enddemono ; Reset $FFF4
		rts
LSelect_LevelOrSS:
		add.w	d0,d0		; Multiply selected level by 2
		move.w	LevelSelectArray(pc,d0.w),d0 ; Load level from array
		bmi.w	loc_3290
		cmpi.w	#$700,d0	; Check	if selected level is 0700 (special stage)
		bne.b	LSelect_Level	; If not (normal level)	go to level playing sub
LSelect_SS:				; Set screen mode to 10	(special stage)
		move.b	#spgamemd,gmmode
		clr.w	stageno	; Clear	level
		move.b	#3,$FFFFFE12 ; Set lives to	3
		moveq	#0,d0
		move.w	d0,$FFFFFE20 ; Clear rings
		move.l	d0,$FFFFFE22 ; Clear time
		move.l	d0,$FFFFFE26 ; Clear score
		rts
LSelect_Level:
		andi.w	#$3fff,d0	; Selected level AND $3FFF
		move.w	d0,stageno ; Set level
PlayLevel:
		move.b	#$c,gmmode ; Set	screen mode to 0C (level)
		move.b	#3,$FFFFFE12 ; Set lives to	3
		moveq	#0,d0
		move.w	d0,$FFFFFE20 ; Clear rings
		move.l	d0,$FFFFFE22 ; Clear time
		move.l	d0,$FFFFFE26 ; Clear score
		move.b	d0,$FFFFFE16
		move.b	d0,$FFFFFE57 ; Clear emeralds
		move.l	d0,$FFFFFE58
		move.l	d0,$FFFFFE5C
		move.b	d0,$FFFFFE18 ; Clear continues
		move.b	#$e0,d0		; Fade out title screen	music
		bsr.w	soundset
		rts
;----------------------------------------------------------------------------------
;Level select array
;
;Each word represents one level
;0x0700	- Special stage
;----------------------------------------------------------------------------------
LevelSelectArray:
		dc.w	0
		dc.w	1
		dc.w	2
		dc.w	$100
		dc.w	$101
		dc.w	$102
		dc.w	$200
		dc.w	$201
		dc.w	$202
		dc.w	$300
		dc.w	$301
		dc.w	$302
		dc.w	$400
		dc.w	$401
		dc.w	$402
		dc.w	$500
		dc.w	$501
		dc.w	$103
		dc.w	$502
		dc.w	$700
		dc.w	$8000
;----------------------------------------------------------------------------------
;Level select code (J)
;
;Each word represents one key:
;+0x01 - Up
;+0x02 - Down
;+0x04 - Left
;+0x08 - Right
;
;You can mix keys, so Up+Left will be 0x05
;----------------------------------------------------------------------------------
LevelSelectCode_J:
		dc.b	 1,  2,	 4,  8,	 0,255
;----------------------------------------------------------------------------------
;Level select code (US)
;----------------------------------------------------------------------------------
LevelSelectCode_US:
		dc.b	  1,  2,  4,  8,  0,255
loc_33B0:
		move.w	#30,$FFFFF614
loc_33B6:
		move.b	#4,$FFFFF62A
		bsr.w	sync
		bsr.w	sub_6286
		bsr.w	clchgctr
		bsr.w	sub_15EC
		move.w	playerwk+xposi,d0
		addq.w	#2,d0
		move.w	d0,playerwk+xposi
		cmpi.w	#$1C00,d0
		bcs.b	loc_33E4
		move.b	#0,gmmode
		rts
loc_33E4:
		andi.b	#$80,swdata1+1
		bne.w	loc_3242	; If Start isn't pressed, branch
		tst.w	$FFFFF614
		bne.w	loc_33B6
		move.b	#$e0,d0		; Fade out all sounds
		bsr.w	soundset
		move.w	demono,d0 ; Move	demo level to d0
		andi.w	#7,d0		; d0 AND 7
		add.w	d0,d0		; d0 * 2
		move.w	DemoLevels(pc,d0.w),d0 ; Load level from demo levels array to d0
		move.w	d0,stageno ; Load	d0 to level
		addq.w	#1,demono ; Increment demo level
		cmpi.w	#4,demono
		bcs.b	loc_3422	; If demo level	is 4, branch
		move.w	#0,demono ; Clear demo level
loc_3422:
		move.w	#1,demoflag ; Turn	demo mode on
		move.b	#8,gmmode ; Set screen mode to 08 (demo)
		cmpi.w	#$600,d0
		bne.b	loc_3442	; If level isn't 0600 (special stage), branch
		move.b	#spgamemd,gmmode ; Set screen	mode to	10 (special stage)
		clr.w	stageno	; Clear	level
		clr.b	$FFFFFE16
loc_3442:
		move.b	#3,$FFFFFE12 ; Set lives to	3
		moveq	#0,d0
		move.w	d0,$FFFFFE20 ; Clear rings
		move.l	d0,$FFFFFE22 ; Clear time
		move.l	d0,$FFFFFE26 ; Clear score
		rts
;---------------------------------------------------------------------------------------
;Demo levels
;
;Levels	that are played	during demos
;---------------------------------------------------------------------------------------
DemoLevels:
		dc.w	0
		dc.w	$200
		dc.w	$400
		dc.w	$600
sub_3460:
		move.b	swdata1+1,d1
		andi.b	#3,d1
		bne.b	loc_3470
		subq.w	#1,$FFFFFF80
		bpl.b	loc_34AA
loc_3470:
		move.w	#12-1,$FFFFFF80
		move.b	swdata1,d1
		andi.b	#3,d1
		beq.b	loc_34AA
		move.w	$FFFFFF82,d0
		btst.l	#0,d1
		beq.b	loc_3490
		subq.w	#1,d0
		bcc.b	loc_3490
		moveq	#$14,d0
loc_3490:
		btst.l	#1,d1
		beq.b	loc_34A0
		addq.w	#1,d0
		cmpi.w	#$15,d0
		bcs.b	loc_34A0
		moveq	#0,d0
loc_34A0:
		move.w	d0,$FFFFFF82
		bsr.w	sub_34E6
		rts
loc_34AA:
		cmpi.w	#$14,$FFFFFF82
		bne.b	locret_34E4
		move.b	swdata1+1,d1
		andi.b	#$C,d1
		beq.b	locret_34E4
		move.w	$FFFFFF84,d0
		btst.l	#2,d1
		beq.b	loc_34CC
		subq.w	#1,d0
		bcc.b	loc_34CC
		moveq	#$4F,d0
loc_34CC:
		btst.l	#3,d1
		beq.b	loc_34DC
		addq.w	#1,d0
		cmpi.w	#$50,d0
		bcs.b	loc_34DC
		moveq	#0,d0
loc_34DC:
		move.w	d0,$FFFFFF84
		bsr.w	sub_34E6
locret_34E4:
		rts
sub_34E6:
		lea	LSelect_Text,a1
		lea	VDP_DATA,a6
		move.l	#$62100003,d4
		move.w	#$E680,d3
		moveq	#$15-1,d1
loc_34FE:
		move.l	d4,4(a6)
		bsr.w	sub_3586
		addi.l	#$800000,d4
		dbf	d1,loc_34FE
		moveq	#0,d0
		move.w	$FFFFFF82,d0
		move.w	d0,d1
		move.l	#$62100003,d4
		lsl.w	#7,d0
		swap	d0
		add.l	d0,d4
		lea	LSelect_Text,a1
		lsl.w	#3,d1
		move.w	d1,d0
		add.w	d1,d1
		add.w	d0,d1
		adda.w	d1,a1
		move.w	#$c680,d3
		move.l	d4,4(a6)
		bsr.w	sub_3586
		move.w	#$e680,d3
		cmpi.w	#$14,$FFFFFF82
		bne.b	loc_3550
		move.w	#$c680,d3
loc_3550:
		move.l	#$6C300003,VDP_CTRL
		move.w	$FFFFFF84,d0
		addi.w	#$80,d0
		move.b	d0,d2
		lsr.b	#4,d0
		bsr.w	sub_3572
		move.b	d2,d0
		bsr.w	sub_3572
		rts
sub_3572:
		andi.w	#$F,d0
		cmpi.b	#$A,d0
		bcs.b	loc_3580
		addi.b	#7,d0
loc_3580:
		add.w	d3,d0
		move.w	d0,(a6)
		rts
sub_3586:
		moveq	#$18-1,d2
loc_3588:
		moveq	#0,d0
		move.b	(a1)+,d0
		bpl.b	loc_3598
		move.w	#0,(a6)
		dbf	d2,loc_3588
		rts
loc_3598:
		add.w	d3,d0
		move.w	d0,(a6)
		dbf	d2,loc_3588
		rts
LSelect_Text:
		dc.b $17,$22,$15,$15,$1E,$FF,$18,$19,$1C,$1C,$FF,$10,$1F,$1E,$15,$FF,$FF,$23,$24,$11,$17,$15,$FF,  1; 0
		dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$23,$24,$11,$17,$15,$FF,  2; 24
		dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$23,$24,$11,$17,$15,$FF,  3; 48
		dc.b $1C,$11,$12, $F,$22,$19,$1E,$24,$18,$FF,$10,$1F,$1E,$15,$FF,$FF,$FF,$23,$24,$11,$17,$15,$FF,  1; 72
		dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$23,$24,$11,$17,$15,$FF,  2; 96
		dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$23,$24,$11,$17,$15,$FF,  3; 120
		dc.b $1D,$11,$22,$12,$1C,$15,$FF,$10,$1F,$1E,$15,$FF,$FF,$FF,$FF,$FF,$FF,$23,$24,$11,$17,$15,$FF,  1; 144
		dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$23,$24,$11,$17,$15,$FF,  2; 168
		dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$23,$24,$11,$17,$15,$FF,  3; 192
		dc.b $23,$24,$11,$22,$FF,$1C,$19,$17,$18,$24,$FF,$10,$1F,$1E,$15,$FF,$FF,$23,$24,$11,$17,$15,$FF,  1; 216
		dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$23,$24,$11,$17,$15,$FF,  2; 240
		dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$23,$24,$11,$17,$15,$FF,  3; 264
		dc.b $23,$20,$22,$19,$1E,$17,$FF, $F,$11,$22,$14,$FF,$10,$1F,$1E,$15,$FF,$23,$24,$11,$17,$15,$FF,  1; 288
		dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$23,$24,$11,$17,$15,$FF,  2; 312
		dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$23,$24,$11,$17,$15,$FF,  3; 336
		dc.b $23,$13,$22,$11,$20,$FF,$12,$22,$11,$19,$1E,$FF,$10,$1F,$1E,$15,$FF,$23,$24,$11,$17,$15,$FF,  1; 360
		dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$23,$24,$11,$17,$15,$FF,  2; 384
		dc.b $FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$23,$24,$11,$17,$15,$FF,  3; 408
		dc.b $16,$19,$1E,$11,$1C,$FF,$10,$1F,$1E,$15,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF; 432
		dc.b $23,$20,$15,$13,$19,$11,$1C,$FF,$23,$24,$11,$17,$15,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF; 456
		dc.b $23,$1F,$25,$1E,$14,$FF,$23,$15,$1C,$15,$13,$24,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF,$FF; 480
		even