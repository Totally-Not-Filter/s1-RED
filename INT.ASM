		btst.b	#6,REG_CTRL3
		beq.b	ChecksumCheck
		cmpi.l	#"init",intflag
		beq.w	Init
ChecksumCheck:
		movea.l	#$200,a0
		movea.l	#RomEndLoc,a1
		move.l	(a1),d0
		moveq	#0,d1
?loop:
		add.w	(a0)+,d1
		cmp.l	a0,d0
		bcc.b	?loop
		movea.l	#Checksum,a1	; Checksum
		cmp.w	(a1),d1		; Compare correct checksum to the one in ROM
		bne.w	ChecksumError
clrstack:
		lea	stack,a6
		moveq	#0,d7
		move.w	#$200/4-1,d6
?loop:
		move.l	d7,(a6)+
		dbf	d6,?loop
		move.b	REG_VERSION,d0
		andi.b	#$c0,d0
		move.b	d0,mdstatus
		move.l	#"init",intflag
Init:
		lea	ip_start,a6
		moveq	#0,d7
		move.w	#$fe00/4-1,d6
?loop:
		move.l	d7,(a6)+
		dbf	d6,?loop	; Fill $FF0000 to $FFFDFF with 00
		bsr.w	sub_1222
		bsr.w	sub_1352
		bsr.w	sub_11B6
		move.b	#logogamemd,gmmode ; Set Game Mode to Sega Screen
gmmodeloop:
		move.b	gmmode,d0
		andi.w	#$1c,d0
		jsr	gmmodetbl(pc,d0.w) ; Jump to certain areas of ROM depending	on Game	Mode
		bra.b	gmmodeloop
gmmodetbl:
		bra.w	logo	; Sega Screen (00)
		bra.w	title	; Title	Screen (04)
		bra.w	game	; Demo Mode (08)
		bra.w	game	; Normal Level (0C)
		bra.w	SpecialStage	; Special Stage	(10)
		bra.w	ContinueScreen	; Continue Screen (14)
		bra.w	EndingSequence	; End of game sequence (18)
		bra.w	Credits	; Credits (1C)
		rts
ChecksumError:
		bsr.w	sub_1222
		move.l	#$c0000000,VDP_CTRL
		moveq	#$80/2-1,d7
?loop:
		move.w	#$00e,VDP_DATA	; Fill screen with colour red
		dbf	d7,?loop	; Loop until d7	is 0
InfiniteLoop:
		bra.b	InfiniteLoop