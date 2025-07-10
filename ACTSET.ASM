actset:
		moveq	#0,d0
		move.b	actset_rno,d0
		move.w	actset_move_tbl(pc,d0.w),d0
		jmp	actset_move_tbl(pc,d0.w)
actset_move_tbl:
		dc.w actsetinit-actset_move_tbl
		dc.w loc_D980-actset_move_tbl
actsetinit:
		addq.b	#word,actset_rno
		move.w	stageno,d0
		lsl.b	#6,d0
		lsr.w	#4,d0
		lea	Off_Sprites,a0
		movea.l	a0,a1
		adda.w	(a0,d0.w),a0
		move.l	a0,$FFFFF770
		move.l	a0,$FFFFF774
		adda.w	2(a1,d0.w),a1
		move.l	a1,$FFFFF778
		move.l	a1,$FFFFF77C
		lea	$FFFFFC00,a2
		move.w	#$101,(a2)+
		move.w	#$BE/2-1,d0	; There is a slight oversight here, this should be divided by 4 (longword) rather than 2 (word).
loc_D924:
		clr.l	(a2)+
		dbf	d0,loc_D924
		lea	$FFFFFC00,a2
		moveq	#0,d2
		move.w	scra_h_posit,d6
		subi.w	#$80,d6
		bcc.b	loc_D93C
		moveq	#0,d6
loc_D93C:
		andi.w	#-$80,d6
		movea.l	$FFFFF770,a0
loc_D944:
		cmp.w	(a0),d6
		bls.b	loc_D956
		tst.b	4(a0)
		bpl.b	loc_D952
		move.b	(a2),d2
		addq.b	#1,(a2)
loc_D952:
		addq.w	#6,a0
		bra.b	loc_D944
loc_D956:
		move.l	a0,$FFFFF770
		movea.l	$FFFFF774,a0
		subi.w	#$80,d6
		bcs.b	loc_D976
loc_D964:
		cmp.w	(a0),d6
		bls.b	loc_D976
		tst.b	4(a0)
		bpl.b	loc_D972
		addq.b	#1,1(a2)
loc_D972:
		addq.w	#6,a0
		bra.b	loc_D964
loc_D976:
		move.l	a0,$FFFFF774
		move.w	#-1,$FFFFF76E
loc_D980:
		lea	$FFFFFC00,a2
		moveq	#0,d2
		move.w	scra_h_posit,d6
		andi.w	#-$80,d6
		cmp.w	$FFFFF76E,d6
		beq.w	locret_DA3A
		bge.b	loc_D9F6
		move.w	d6,$FFFFF76E
		movea.l	$FFFFF774,a0
		subi.w	#$80,d6
		bcs.b	loc_D9D2
loc_D9A6:
		cmp.w	-6(a0),d6
		bge.b	loc_D9D2
		subq.w	#6,a0
		tst.b	4(a0)
		bpl.b	loc_D9BC
		subq.b	#1,1(a2)
		move.b	1(a2),d2
loc_D9BC:
		bsr.w	sub_DA3C
		bne.b	loc_D9C6
		subq.w	#6,a0
		bra.b	loc_D9A6
loc_D9C6:
		tst.b	4(a0)
		bpl.b	loc_D9D0
		addq.b	#1,1(a2)
loc_D9D0:
		addq.w	#6,a0
loc_D9D2:
		move.l	a0,$FFFFF774
		movea.l	$FFFFF770,a0
		addi.w	#$300,d6
loc_D9DE:
		cmp.w	-6(a0),d6
		bgt.b	loc_D9F0
		tst.b	-2(a0)
		bpl.b	loc_D9EC
		subq.b	#1,(a2)
loc_D9EC:
		subq.w	#6,a0
		bra.b	loc_D9DE
loc_D9F0:
		move.l	a0,$FFFFF770
		rts
loc_D9F6:
		move.w	d6,$FFFFF76E
		movea.l	$FFFFF770,a0
		addi.w	#$280,d6
loc_DA02:
		cmp.w	(a0),d6
		bls.b	loc_DA16
		tst.b	4(a0)
		bpl.b	loc_DA10
		move.b	(a2),d2
		addq.b	#1,(a2)
loc_DA10:
		bsr.w	sub_DA3C
		beq.b	loc_DA02
loc_DA16:
		move.l	a0,$FFFFF770
		movea.l	$FFFFF774,a0
		subi.w	#$300,d6
		bcs.b	loc_DA36
loc_DA24:
		cmp.w	(a0),d6
		bls.b	loc_DA36
		tst.b	4(a0)
		bpl.b	loc_DA32
		addq.b	#1,1(a2)
loc_DA32:
		addq.w	#6,a0
		bra.b	loc_DA24
loc_DA36:
		move.l	a0,$FFFFF774
locret_DA3A:
		rts
sub_DA3C:
		tst.b	4(a0)
		bpl.b	loc_DA50
		bset.b	#7,2(a2,d2.w)
		beq.b	loc_DA50
		addq.w	#6,a0
		moveq	#0,d0
		rts
loc_DA50:
		bsr.w	actwkchk
		bne.b	locret_DA8A
		move.w	(a0)+,xposi(a1)
		move.w	(a0)+,d0
		move.w	d0,d1
		andi.w	#$fff,d0
		move.w	d0,yposi(a1)
		rol.w	#2,d1
		andi.b	#3,d1
		move.b	d1,actflg(a1)
		move.b	d1,cddat(a1)
		move.b	(a0)+,d0
		bpl.b	loc_DA80
		andi.b	#$7f,d0
		move.b	d2,cdsts(a1)
loc_DA80:
		move.b	d0,actno(a1)
		move.b	(a0)+,userflag(a1)
		moveq	#0,d0
locret_DA8A:
		rts