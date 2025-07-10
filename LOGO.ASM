logo:
		move.b	#$e4,d0		; Stop all music
		bsr.w	soundset
		bsr.w	sub_15DE
		bsr.w	sub_1E52
		lea	VDP_CTRL,a6
		move.w	#$8000+%00000100,(a6)
		move.w	#$8200+vram_plane_a>>10,(a6)
		move.w	#$8400+vram_plane_b>>13,(a6)
		move.w	#$8700+$00<<4+$00,(a6)
		move.w	#$8B00+%00000000,(a6)
		clr.b	waterflag
		move.w	#$2700,sr
		move.w	$FFFFF60C,d0
		andi.b	#$bf,d0
		move.w	d0,VDP_CTRL
		bsr.w	scrinit
		move.l	#$40000000,VDP_CTRL
		lea	logocg,a0 ; Load SEGA patterns
		bsr.w	bitdevdatr	; Decompress SEGA patterns
		lea	$FF0000,a1
		lea	logomap,a0
		move.w	#$000,d0
		bsr.w	mapdevr
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
		move.w	#-$A,clchgcnt
		move.w	#0,clchgtim
		move.w	#0,$FFFFF662
		move.w	#0,$FFFFF660
		move.w	$FFFFF60C,d0
		ori.b	#$40,d0
		move.w	d0,VDP_CTRL
?loop:
		move.b	#2,vintmode
		bsr.w	sync
		bsr.w	AniPal_Sega
		bne.b	?loop
		move.b	#$e1,d0		; Play SEGA sound
		bsr.w	soundset
		move.b	#$14,vintmode
		bsr.w	sync
		move.w	#30,$FFFFF614
?loop2:
		move.b	#2,vintmode
		bsr.w	sync
		tst.w	$FFFFF614
		beq.b	?end
		andi.b	#$80,swdata1+1
		beq.b	?loop2
?end:
		move.b	#titlegamemd,gmmode ; Go to Title Screen
		rts