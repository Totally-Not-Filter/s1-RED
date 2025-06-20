scoreset:
		tst.w	debugflag
		bne.w	loc_1C7A2
		tst.b	$FFFFFE1F
		beq.b	loc_1C6D8
		clr.b	$FFFFFE1F
		move.l	#$5C800003,d0
		move.l	$FFFFFE26,d1
		bsr.w	sub_1C8DA
loc_1C6D8:
		tst.b	$FFFFFE1D
		beq.b	loc_1C6F8
		bpl.b	loc_1C6E4
		bsr.w	sub_1C80E
loc_1C6E4:
		clr.b	$FFFFFE1D
		move.l	#$5F400003,d0
		moveq	#0,d1
		move.w	$FFFFFE20,d1
		bsr.w	sub_1C8D0
loc_1C6F8:
		tst.b	$FFFFFE1E
		beq.b	loc_1C754
		tst.w	pauseflag
		bne.b	loc_1C754
		lea	$FFFFFE22,a1
		cmpi.l	#9<<16+59<<8+59,(a1)+
		beq.b	loc_1C78C
		addq.b	#1,-(a1)
		cmpi.b	#60,(a1)
		bcs.b	loc_1C754
		move.b	#0,(a1)
		addq.b	#1,-(a1)
		cmpi.b	#60,(a1)
		bcs.b	loc_1C734
		move.b	#0,(a1)
		addq.b	#1,-(a1)
		cmpi.b	#9,(a1)
		bcs.b	loc_1C734
		move.b	#9,(a1)
loc_1C734:
		move.l	#$5E400003,d0
		moveq	#0,d1
		move.b	$FFFFFE23,d1
		bsr.w	sub_1C9A8
		move.l	#$5EC00003,d0
		moveq	#0,d1
		move.b	$FFFFFE24,d1
		bsr.w	sub_1C9B2
loc_1C754:
		tst.b	$FFFFFE1C
		beq.b	loc_1C762
		clr.b	$FFFFFE1C
		bsr.w	sub_1CA6E
loc_1C762:
		tst.b	$FFFFF7D6
		beq.b	locret_1C78A
		clr.b	$FFFFF7D6
		move.l	#$6E000002,VDP_CTRL
		moveq	#0,d1
		move.w	$FFFFF7D2,d1
		bsr.w	sub_1CA0C
		moveq	#0,d1
		move.w	$FFFFF7D4,d1
		bsr.w	sub_1CA0C
locret_1C78A:
		rts
loc_1C78C:
		clr.b	$FFFFFE1E
		lea	playerwk,a0
		movea.l	a0,a2
		bsr.w	sub_1B098
		move.b	#1,$FFFFFE1A
		rts
loc_1C7A2:
		bsr.w	sub_1C87A
		tst.b	$FFFFFE1D
		beq.b	loc_1C7C6
		bpl.b	loc_1C7B2
		bsr.w	sub_1C80E
loc_1C7B2:
		clr.b	$FFFFFE1D
		move.l	#$5F400003,d0
		moveq	#0,d1
		move.w	$FFFFFE20,d1
		bsr.w	sub_1C8D0
loc_1C7C6:
		move.l	#$5EC00003,d0
		moveq	#0,d1
		move.b	$FFFFF62C,d1
		bsr.w	sub_1C9B2
		tst.b	$FFFFFE1C
		beq.b	loc_1C7E4
		clr.b	$FFFFFE1C
		bsr.w	sub_1CA6E
loc_1C7E4:
		tst.b	$FFFFF7D6
		beq.b	locret_1C80C
		clr.b	$FFFFF7D6
		move.l	#$6E000002,VDP_CTRL
		moveq	#0,d1
		move.w	$FFFFF7D2,d1
		bsr.w	sub_1CA0C
		moveq	#0,d1
		move.w	$FFFFF7D4,d1
		bsr.w	sub_1CA0C
locret_1C80C:
		rts
sub_1C80E:
		move.l	#$5F400003,VDP_CTRL
		lea	byte_1C876(pc),a2
		move.w	#3-1,d2
		bra.b	loc_1C83E
sub_1C822:
		lea	VDP_DATA,a6
		bsr.w	sub_1CA6E
		move.l	#$5C400003,VDP_CTRL
		lea	byte_1C86A(pc),a2
		move.w	#15-1,d2
loc_1C83E:
		lea	scorewrtcg(pc),a1
loc_1C842:
		move.w	#16-1,d1
		move.b	(a2)+,d0
		bmi.b	loc_1C85E
		ext.w	d0
		lsl.w	#5,d0
		lea	(a1,d0.w),a3
loc_1C852:
		move.l	(a3)+,(a6)
		dbf	d1,loc_1C852
loc_1C858:
		dbf	d2,loc_1C842
		rts
loc_1C85E:
		move.l	#0,(a6)
		dbf	d1,loc_1C85E
		bra.b	loc_1C858
byte_1C86A:	dc.b $16,$FF,$FF,$FF,$FF,$FF,$FF,  0,  0,$14,  0,  0
byte_1C876:	dc.b $FF,$FF,  0,  0
sub_1C87A:
		move.l	#$5C400003,VDP_CTRL
		move.w	scra_h_posit,d1
		swap	d1
		move.w	playerwk+xposi,d1
		bsr.b	sub_1C89A
		move.w	scra_v_posit,d1
		swap	d1
		move.w	playerwk+yposi,d1
sub_1C89A:
		moveq	#8-1,d6
		lea	ascii.l,a1
loc_1C8A2:
		rol.w	#4,d1
		move.w	d1,d2
		andi.w	#$F,d2
		cmpi.w	#$A,d2
		bcs.b	loc_1C8B2
		addq.w	#7,d2
loc_1C8B2:
		lsl.w	#5,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		swap	d1
		dbf	d6,loc_1C8A2
		rts
sub_1C8D0:
		lea	dword_1C99C,a2
		moveq	#3-1,d6
		bra.b	loc_1C8E2
sub_1C8DA:
		lea	dword_1C990,a2
		moveq	#6-1,d6
loc_1C8E2:
		moveq	#0,d4
		lea	scorewrtcg(pc),a1
loc_1C8E8:
		moveq	#0,d2
		move.l	(a2)+,d3
loc_1C8EC:
		sub.l	d3,d1
		bcs.b	loc_1C8F4
		addq.w	#1,d2
		bra.b	loc_1C8EC
loc_1C8F4:
		add.l	d3,d1
		tst.w	d2
		beq.b	loc_1C8FE
		move.w	#1,d4
loc_1C8FE:
		tst.w	d4
		beq.b	loc_1C92C
		lsl.w	#6,d2
		move.l	d0,4(a6)
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
loc_1C92C:
		addi.l	#$400000,d0
		dbf	d6,loc_1C8E8
		rts
sub_1C938:
		move.l	#$5F800003,VDP_CTRL
		lea	VDP_DATA,a6
		lea	dword_1C9A0,a2
		moveq	#2-1,d6
		moveq	#0,d4
		lea	scorewrtcg(pc),a1
loc_1C956:
		moveq	#0,d2
		move.l	(a2)+,d3
loc_1C95A:
		sub.l	d3,d1
		bcs.b	loc_1C962
		addq.w	#1,d2
		bra.b	loc_1C95A
loc_1C962:
		add.l	d3,d1
		lsl.w	#6,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		dbf	d6,loc_1C956
		rts
dword_1C990:	dc.l 100000
		dc.l 10000
dword_1C998:	dc.l 1000
dword_1C99C:	dc.l 100
dword_1C9A0:	dc.l 10
dword_1C9A4:	dc.l 1
sub_1C9A8:
		lea	dword_1C9A4,a2
		moveq	#0,d6
		bra.b	loc_1C9BA
sub_1C9B2:
		lea	dword_1C9A0,a2
		moveq	#1,d6
loc_1C9BA:
		moveq	#0,d4
		lea	scorewrtcg(pc),a1
loc_1C9C0:
		moveq	#0,d2
		move.l	(a2)+,d3
loc_1C9C4:
		sub.l	d3,d1
		bcs.b	loc_1C9CC
		addq.w	#1,d2
		bra.b	loc_1C9C4
loc_1C9CC:
		add.l	d3,d1
		tst.w	d2
		beq.b	loc_1C9D6
		move.w	#1,d4
loc_1C9D6:
		lsl.w	#6,d2
		move.l	d0,4(a6)
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		addi.l	#$400000,d0
		dbf	d6,loc_1C9C0
		rts
sub_1CA0C:
		lea	dword_1C998,a2
		moveq	#4-1,d6
		moveq	#0,d4
		lea	scorewrtcg(pc),a1
loc_1CA1A:
		moveq	#0,d2
		move.l	(a2)+,d3
loc_1CA1E:
		sub.l	d3,d1
		bcs.b	loc_1CA26
		addq.w	#1,d2
		bra.b	loc_1CA1E
loc_1CA26:
		add.l	d3,d1
		tst.w	d2
		beq.b	loc_1CA30
		move.w	#1,d4
loc_1CA30:
		tst.w	d4
		beq.b	loc_1CA60
		lsl.w	#6,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
loc_1CA5A:
		dbf	d6,loc_1CA1A
		rts
loc_1CA60:
		moveq	#$10-1,d5
loc_1CA62:
		move.l	#0,(a6)
		dbf	d5,loc_1CA62
		bra.b	loc_1CA5A
sub_1CA6E:
		move.l	#$7BA00003,d0
		moveq	#0,d1
		move.b	$FFFFFE12,d1
		lea	dword_1C9A0,a2
		moveq	#2-1,d6
		moveq	#0,d4
		lea	playsuucg(pc),a1
loc_1CA88:
		move.l	d0,4(a6)
		moveq	#0,d2
		move.l	(a2)+,d3
loc_1CA90:
		sub.l	d3,d1
		bcs.b	loc_1CA98
		addq.w	#1,d2
		bra.b	loc_1CA90
loc_1CA98:
		add.l	d3,d1
		tst.w	d2
		beq.b	loc_1CAA2
		move.w	#1,d4
loc_1CAA2:
		tst.w	d4
		beq.b	loc_1CAC8
loc_1CAA6:
		lsl.w	#5,d2
		lea	(a1,d2.w),a3
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
		move.l	(a3)+,(a6)
loc_1CABC:
		addi.l	#$400000,d0
		dbf	d6,loc_1CA88
		rts
loc_1CAC8:
		tst.w	d6
		beq.b	loc_1CAA6
		moveq	#8-1,d5
loc_1CACE:
		move.l	#0,(a6)
		dbf	d5,loc_1CACE
		bra.b	loc_1CABC