logo:
		move.b	#$e4,d0		; Stop all music
		bsr.w	sfxset
		bsr.w	sub_15DE
		bsr.w	sub_1E52
		lea	VDP_CTRL,a6
		move.w	#$8000+4,(a6)
		move.w	#$8200+$30,(a6)
		move.w	#$8400+7,(a6)
		move.w	#$8700,(a6)
		move.w	#$8B00,(a6)
		clr.b	$FFFFF64E
		move.w	#$2700,sr
		move.w	$FFFFF60C,d0
		andi.b	#$BF,d0
		move.w	d0,VDP_CTRL
		bsr.w	loc_12C4
		move.l	#$40000000,VDP_CTRL
		lea	logocg,a0 ; Load SEGA patterns
		bsr.w	NemesisDec_1440	; Decompress SEGA patterns
		lea	$FF0000,a1
		lea	logomap,a0
		move.w	#$000,d0
		bsr.w	EnigmaDec
		lea	$FF0000,a1
		move.l	#$65100003,d0
		moveq	#24-1,d1
		moveq	#8-1,d2
		bsr.w	sub_1420
		lea	$FF0000+$180,a1
		move.l	#$40000003,d0
		moveq	#40-1,d1
		moveq	#28-1,d2
		bsr.w	sub_1420
		moveq	#0,d0
		bsr.w	PalLoad
		move.w	#-$A,$FFFFF632
		move.w	#0,$FFFFF634
		move.w	#0,$FFFFF662
		move.w	#0,$FFFFF660
		move.w	$FFFFF60C,d0
		ori.b	#$40,d0
		move.w	d0,VDP_CTRL
loc_2ED0:
		move.b	#2,$FFFFF62A
		bsr.w	sub_29A8
		bsr.w	AniPal_Sega
		bne.b	loc_2ED0
		move.b	#$e1,d0		; Play SEGA sound
		bsr.w	sfxset
		move.b	#$14,$FFFFF62A
		bsr.w	sub_29A8
		move.w	#30,$FFFFF614
loc_2EF8:
		move.b	#2,$FFFFF62A
		bsr.w	sub_29A8
loc_2F02:
		tst.w	$FFFFF614
		beq.b	loc_2F10
		andi.b	#$80,swdata1+1
		beq.b	loc_2EF8
loc_2F10:
		move.b	#titlegamemd,gmmode ; Go to Title Screen
		rts