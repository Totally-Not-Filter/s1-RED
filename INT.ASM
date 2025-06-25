		btst.b	#6,REG_CTRL3
		beq.b	ChecksumCheck
		cmpi.l	#"init",$fffffffc
		beq.w	Init
ChecksumCheck:
		movea.l	#$200,a0
		movea.l	#RomEndLoc,a1
		move.l	(a1),d0
		moveq	#0,d1
loc_32C:
		add.w	(a0)+,d1
		cmp.l	a0,d0
		bcc.b	loc_32C
		movea.l	#Checksum,a1	; Checksum
		cmp.w	(a1),d1		; Compare correct checksum to the one in ROM
		bne.w	ChecksumError
		lea	$fffffe00,a6
		moveq	#0,d7
		move.w	#$0200/4-1,d6
loc_348:
		move.l	d7,(a6)+
		dbf	d6,loc_348
		move.b	REG_VERSION,d0
		andi.b	#$c0,d0
		move.b	d0,mdstatus
		move.l	#"init",$fffffffc
Init:
		lea	$ff0000,a6
		moveq	#0,d7
		move.w	#$fe00/4-1,d6
loc_370:
		move.l	d7,(a6)+
		dbf	d6,loc_370	; Fill $FF0000 to $FFFDFF with 00
		bsr.w	sub_1222
		bsr.w	sub_1352
		bsr.w	sub_11B6
		move.b	#logogamemd,gmmode ; Set Game Mode to Sega Screen
mainloop:
		move.b	gmmode,d0
		andi.w	#$1c,d0
		jsr	GameModeArray(pc,d0.w) ; Jump to certain areas of ROM depending	on Game	Mode
		bra.b	mainloop
GameModeArray:				; Sega Screen (00)
		bra.w	logo
		bra.w	title	; Title	Screen (04)
		bra.w	Level		; Demo Mode (08)
		bra.w	Level		; Normal Level (0C)
		bra.w	SpecialStage	; Special Stage	(10)
		bra.w	ContinueScreen	; Continue Screen (14)
		bra.w	EndingSequence	; End of game sequence (18)
		bra.w	Credits		; Credits (1C)
		rts
ChecksumError:
		bsr.w	sub_1222
		move.l	#$c0000000,VDP_CTRL
		moveq	#$80/2-1,d7
loc_3C8:
		move.w	#$00e,VDP_DATA	; Fill screen with colour red
		dbf	d7,loc_3C8	; Loop until d7	is 0
InfiniteLoop:
		bra.b	InfiniteLoop