play01:
		tst.w	editmode
		beq.b	?jump
		bsr.w	playscr
		bra.w	edit
?jump:
		moveq	#0,d0
		move.b	r_no0(a0),d0
		move.w	play01_move_tbl(pc,d0.w),d1
		jmp	play01_move_tbl(pc,d1.w)
play01_move_tbl:
		dc.w play01init-play01_move_tbl
		dc.w play01move-play01_move_tbl
		dc.w play01gole-play01_move_tbl
		dc.w play01gole2-play01_move_tbl
play01init:
		addq.b	#word,r_no0(a0)
		move.b	#14,sprvsize(a0)
		move.b	#7,sprhsize(a0)
		move.l	#playpat,patbase(a0)
		move.w	#$0780,sproffset(a0)
		move.b	#4,actflg(a0)
		move.b	#0,sprpri(a0)
		move.b	#2,mstno(a0)
		bset.b	#2,cddat(a0)
		bset.b	#1,cddat(a0)
play01move:
		tst.w	debugflag
		beq.b	?jump5
		btst.b	#4,swdata1+1
		beq.b	?jump5
		move.w	#1,editmode
?jump5:
		move.b	#0,$30(a0)
		moveq	#0,d0
		move.b	cddat(a0),d0
		andi.w	#2,d0
		move.w	play01move_tbl(pc,d0.w),d1
		jsr	play01move_tbl(pc,d1.w)
		jsr	playwrt
		jmp	actionsub
play01move_tbl:
		dc.w play01walk-play01move_tbl
		dc.w play01jump-play01move_tbl
play01walk:
		bsr.w	spjumpchk
		bsr.w	splevermove
		bsr.w	rotspdset
		bra.b	play01sub
play01jump:
		bsr.w	spjumpchk2
		bsr.w	splevermove
		bsr.w	rotspdset
play01sub:
		bsr.w	spcol_ev
		bsr.w	bobinchk
		jsr	speedset2
		bsr.w	playscr
		move.w	rotdir,d0
		add.w	rotspd,d0
		move.w	d0,rotdir
		jsr	sub_139C4
		rts
splevermove:
		btst.b	#2,swdata
		beq.b	?jump5
		bsr.w	spplwalk_l
?jump5:
		btst.b	#3,swdata
		beq.b	?jump6
		bsr.w	spplwalk_r
?jump6:
		move.b	swdata,d0
		andi.b	#$C,d0
		bne.b	?jump7
		move.w	mspeed(a0),d0
		beq.b	?jump7
		bmi.b	?left
?right:
		subi.w	#$C,d0
		bcc.b	?right2
		move.w	#0,d0
?right2:
		move.w	d0,mspeed(a0)
		bra.b	?jump7
?left:
		addi.w	#$C,d0
		bcc.b	?left2
		move.w	#0,d0
?left2:
		move.w	d0,mspeed(a0)
?jump7:
		move.b	rotdir,d0
		addi.b	#$20,d0
		andi.b	#$c0,d0
		neg.b	d0
		jsr	sinset.l
		muls.w	mspeed(a0),d1
		add.l	d1,xposi(a0)
		muls.w	mspeed(a0),d0
		add.l	d0,yposi(a0)
		movem.l	d0-d1,-(sp)
		move.l	yposi(a0),d2
		move.l	xposi(a0),d3
		bsr.w	spcol
		beq.b	?jump
		movem.l	(sp)+,d0-d1
		sub.l	d1,xposi(a0)
		sub.l	d0,yposi(a0)
		move.w	#0,mspeed(a0)
		rts
?jump:
		movem.l	(sp)+,d0-d1
		rts
spplwalk_l:
		bset.b	#0,cddat(a0)
		move.w	mspeed(a0),d0
		beq.b	?left
		bpl.b	?right
?left:
		subi.w	#$C,d0
		cmpi.w	#-$800,d0
		bgt.b	?left2
		move.w	#-$800,d0
?left2:
		move.w	d0,mspeed(a0)
		rts
?right:
		subi.w	#$40,d0
*		cmpi.w	#$800,d0
		bcc.b	?right2
*		move.w	#$800,d0
		nop
?right2:
		move.w	d0,mspeed(a0)
		rts
spplwalk_r:
		bclr.b	#0,cddat(a0)
		move.w	mspeed(a0),d0
*		beq.b	?right
		bmi.b	?left
?right:
		addi.w	#$C,d0
		cmpi.w	#$800,d0
		blt.b	?right2
		move.w	#$800,d0
?right2:
		move.w	d0,mspeed(a0)
		bra.b	?rightcol
?left:
		addi.w	#$40,d0
*		cmpi.w	#-$800,d0
		bcc.b	?left2
*		move.w	#-$800,d0
		nop
?left2:
		move.w	d0,mspeed(a0)
?rightcol:
		rts
spjumpchk:
		move.b	swdata+1,d0
		andi.b	#$70,d0
		beq.b	?end
		move.b	rotdir,d0
		andi.b	#-4,d0
		neg.b	d0
		subi.b	#$40,d0
		jsr	sinset.l
		muls.w	#$680,d1
		asr.l	#8,d1
		move.w	d1,xspeed(a0)
		muls.w	#$680,d0
		asr.l	#8,d0
		move.w	d0,yspeed(a0)
		bset.b	#1,cddat(a0)
		move.w	#$A0,d0
		jsr	soundset.l
?end:
		rts
spjumpchk2:
		rts
		move.w	#-$400,d1
		cmp.w	yspeed(a0),d1
		ble.b	?end
		move.b	swdata,d0
		andi.b	#$70,d0
		bne.b	?end
		move.w	d1,yspeed(a0)
?end:
		rts
playscr:
		move.w	yposi(a0),d2
		move.w	xposi(a0),d3
		move.w	scra_h_posit,d0
		subi.w	#$A0,d3
		bcs.b	?jump
		sub.w	d3,d0
		sub.w	d0,scra_h_posit
?jump:
		move.w	scra_v_posit,d0
		subi.w	#$70,d2
		bcs.b	?jump2
		sub.w	d2,d0
		sub.w	d0,scra_v_posit
?jump2:
		rts
play01gole:
		addi.w	#$40,rotspd
		cmpi.w	#$1800,rotspd
		bne.b	?jump0
		move.b	#$C,gmmode
?jump0:
		cmpi.w	#$3000,rotspd
		blt.b	?jump
		move.w	#0,rotspd
		move.w	#$4000,rotdir
		addq.b	#2,r_no0(a0)
		move.w	#$3C,$38(a0)
?jump:
		move.w	rotdir,d0
		add.w	rotspd,d0
		move.w	d0,rotdir
		jsr	sub_139C4
		jsr	playwrt
		bsr.w	playscr
		jmp	actionsub
play01gole2:
		subq.w	#1,$38(a0)
		bne.b	?end
		move.b	#$C,gmmode
?end:
		jsr	sub_139C4
		jsr	playwrt
		bsr.w	playscr
		jmp	actionsub
rotspdset:
		move.l	yposi(a0),d2
		move.l	xposi(a0),d3
		move.b	rotdir,d0
		andi.b	#-4,d0
		jsr	sinset.l
		move.w	xspeed(a0),d4
		ext.l	d4
		asl.l	#8,d4
		muls.w	#$2A,d0
		add.l	d4,d0
		move.w	yspeed(a0),d4
		ext.l	d4
		asl.l	#8,d4
		muls.w	#$2A,d1
		add.l	d4,d1
		add.l	d0,d3
		bsr.w	spcol
		beq.b	?jump2
		sub.l	d0,d3
		moveq	#0,d0
		move.w	d0,xspeed(a0)
		bclr.b	#1,cddat(a0)
		add.l	d1,d2
		bsr.w	spcol
		beq.b	?jump3
		sub.l	d1,d2
		moveq	#0,d1
		move.w	d1,yspeed(a0)
		rts
?jump2:
		add.l	d1,d2
		bsr.w	spcol
		beq.b	?jump4
		sub.l	d1,d2
		moveq	#0,d1
		move.w	d1,yspeed(a0)
		bclr.b	#1,cddat(a0)
?jump3:
		asr.l	#8,d0
		asr.l	#8,d1
		move.w	d0,xspeed(a0)
		move.w	d1,yspeed(a0)
		rts
?jump4:
		asr.l	#8,d0
		asr.l	#8,d1
		move.w	d0,xspeed(a0)
		move.w	d1,yspeed(a0)
		bset.b	#1,cddat(a0)
		rts
spcol:
spcol2:
		lea	$FF0000,a1
		moveq	#0,d4
		swap	d2
		move.w	d2,d4
		swap	d2
		addi.w	#$44,d4
		divu.w	#$18,d4
		mulu.w	#$80,d4
		adda.l	d4,a1
		moveq	#0,d4
		swap	d3
		move.w	d3,d4
		swap	d3
		addi.w	#$14,d4
		divu.w	#$18,d4
		adda.w	d4,a1
		moveq	#0,d5
		move.b	(a1)+,d4
		bsr.b	spcolsub
		move.b	(a1)+,d4
		bsr.b	spcolsub
		adda.w	#$7E,a1
		move.b	(a1)+,d4
		bsr.b	spcolsub
		move.b	(a1)+,d4
		bsr.b	spcolsub
		tst.b	d5
		rts
spcolsub:
		beq.b	?end
		cmpi.b	#$28,d4
		beq.b	?end
		cmpi.b	#$3A,d4
		bcs.b	?jump2
		cmpi.b	#$4B,d4
		bcc.b	?jump2
?end:
		rts
?jump2:
		move.b	d4,$30(a0)
		move.l	a1,$32(a0)
		moveq	#-1,d5
		rts
spcol_ev:
		lea	$FF0000,a1
		moveq	#0,d4
		move.w	yposi(a0),d4
		addi.w	#$50,d4
		divu.w	#$18,d4
		mulu.w	#$80,d4
		adda.l	d4,a1
		moveq	#0,d4
		move.w	xposi(a0),d4
		addi.w	#$20,d4
		divu.w	#$18,d4
		adda.w	d4,a1
		move.b	(a1),d4
		bne.b	spcolsub_ev
		tst.b	$3A(a0)
		bne.w	derusub
		moveq	#0,d4
		rts
spcolsub_ev:
		cmpi.b	#$3A,d4
		bne.b	?jump2
		bsr.w	scrwkchk
		bne.b	?worknai
		move.b	#1,(a2)
		move.l	a1,4(a2)
?worknai:
		jsr	sub_9C76
		cmpi.w	#50,$FFFFFE20
		bcs.b	?jump
		bset.b	#0,$FFFFFE1B
		bne.b	?jump
		addq.b	#1,$FFFFFE18
		move.w	#$BF,d0
		jsr	bgmset.l
?jump:
		moveq	#0,d4
		rts
?jump2:
		cmpi.b	#$28,d4
		bne.b	?jump3
		bsr.w	scrwkchk
		bne.b	?worknai2
		move.b	#3,(a2)
		move.l	a1,4(a2)
?worknai2:
		addq.b	#1,$FFFFFE12
		addq.b	#1,$FFFFFE1C
		move.w	#$88,d0
		jsr	bgmset.l
		moveq	#0,d4
		rts
?jump3:
		cmpi.b	#$3B,d4
		bcs.b	?jump4
		cmpi.b	#$40,d4
		bhi.b	?jump4
		bsr.w	scrwkchk
		bne.b	?worknai3
		move.b	#5,(a2)
		move.l	a1,4(a2)
?worknai3:
		cmpi.b	#6,$FFFFFE57
		beq.b	?jump33
		subi.b	#$3B,d4
		moveq	#0,d0
		move.b	$FFFFFE57,d0
		lea	$FFFFFE58,a2
		move.b	d4,(a2,d0.w)
		addq.b	#1,$FFFFFE57
?jump33:
		move.w	#$93,d0
		jsr	soundset.l
		moveq	#0,d4
		rts
?jump4:
		cmpi.b	#$41,d4
		bne.b	?jump5
		move.b	#1,$3A(a0)
?jump5:
		cmpi.b	#$4A,d4
		bne.b	?jump6
		cmpi.b	#1,$3A(a0)
		bne.b	?jump6
		move.b	#2,$3A(a0)
?jump6:
		moveq	#-1,d4
		rts
derusub:
		cmpi.b	#2,$3A(a0)
		bne.b	?end
		lea	$FF1020,a1
		moveq	#$40-1,d1
?loop1:
		moveq	#$40-1,d2
?loop2:
		cmpi.b	#$41,(a1)
		bne.b	?jump
		move.b	#$2C,(a1)
?jump:
		addq.w	#1,a1
		dbf	d2,?loop2
		lea	$40(a1),a1
		dbf	d1,?loop1
?end:
		clr.b	$3A(a0)
		moveq	#0,d4
		rts
bobinchk:
		move.b	$30(a0),d0
		bne.b	?jump
		subq.b	#1,$36(a0)
		bpl.b	?jmp
		move.b	#0,$36(a0)
?jmp:
		subq.b	#1,$37(a0)
		bpl.b	?jmp2
		move.b	#0,$37(a0)
?jmp2:
		rts
?jump:
		cmpi.b	#$25,d0
		bne.b	?jump2
		move.l	$32(a0),d1
		subi.l	#$FF0001,d1
		move.w	d1,d2
		andi.w	#$7F,d1
		mulu.w	#$18,d1
		subi.w	#$14,d1
		lsr.w	#7,d2
		andi.w	#$7F,d2
		mulu.w	#$18,d2
		subi.w	#$44,d2
		sub.w	xposi(a0),d1
		sub.w	yposi(a0),d2
		jsr	atan.l
		jsr	sinset.l
		muls.w	#-$700,d1
		asr.l	#8,d1
		move.w	d1,xspeed(a0)
		muls.w	#-$700,d0
		asr.l	#8,d0
		move.w	d0,yspeed(a0)
		bset.b	#1,cddat(a0)
		bsr.w	scrwkchk
		bne.b	?worknai
		move.b	#2,(a2)
		move.l	$32(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)
?worknai:
		move.w	#$B4,d0
		jmp	soundset.l
?jump2:
		cmpi.b	#$27,d0
		bne.b	?jump3
		addq.b	#word,r_no0(a0)
		move.w	#$A8,d0
		jsr	soundset.l
		rts
?jump3:
		cmpi.b	#$29,d0
		bne.b	?jump4
		tst.b	$36(a0)
		bne.w	?end
		move.b	#$1E,$36(a0)
		btst.b	#6,rotspd+1
		beq.b	?jump33
		asl.w	rotspd
		movea.l	$32(a0),a1
		subq.l	#1,a1
		move.b	#$2A,(a1)
?jump33:
		move.w	#$A9,d0
		jmp	soundset.l
?jump4:
		cmpi.b	#$2A,d0
		bne.b	?jump5
		tst.b	$36(a0)
		bne.w	?end
		move.b	#$1E,$36(a0)
		btst.b	#6,rotspd+1
		bne.b	?jump44
		asr.w	rotspd
		movea.l	$32(a0),a1
		subq.l	#1,a1
		move.b	#$29,(a1)
?jump44:
		move.w	#$A9,d0
		jmp	soundset.l
?jump5:
		cmpi.b	#$2B,d0
		bne.b	?jump6
		tst.b	$37(a0)
		bne.w	?end
		move.b	#$1E,$37(a0)
		bsr.w	scrwkchk
		bne.b	?worknai2
		move.b	#4,(a2)
		move.l	$32(a0),d0
		subq.l	#1,d0
		move.l	d0,4(a2)
?worknai2:
		neg.w	rotspd
		move.w	#$A9,d0
		jmp	soundset.l
?jump6:
		cmpi.b	#$2D,d0
		beq.b	?jump66
		cmpi.b	#$2E,d0
		beq.b	?jump66
		cmpi.b	#$2F,d0
		beq.b	?jump66
		cmpi.b	#$30,d0
		bne.b	?end
?jump66:
		bsr.w	scrwkchk
		bne.b	?worknai3
		move.b	#6,(a2)
		movea.l	$32(a0),a1
		subq.l	#1,a1
		move.l	a1,4(a2)
		move.b	(a1),d0
		addq.b	#1,d0
		cmpi.b	#$30,d0
		bls.b	?jump666
		clr.b	d0
?jump666:
		move.b	d0,4(a2)
?worknai3:
		move.w	#$BA,d0
		jmp	soundset.l
?end:
		rts