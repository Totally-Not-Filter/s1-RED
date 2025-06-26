usa:
		rts
*		moveq	#0,d0
*		move.b	r_no0(a0),d0
*		move.w	usa_move_tbl(pc,d0.w),d1
*		jmp	usa_move_tbl(pc,d1.w)
*usa_move_tbl:
*		dc.w	usainit-usa_move_tbl
*		dc.w	loc_D246-usa_move_tbl
*		dc.w	loc_D274-usa_move_tbl
*		dc.w	loc_D2C8-usa_move_tbl
*usainit:
*		addq.b	#word,r_no0(a0)
*		move.l	#usapat,patbase(a0)
*		move.w	#$2448,sproffset(a0)
*		move.b	#4,actflg(a0)
*		move.b	#4,sprpri(a0)
*		move.b	#12,sprhs(a0)
*		move.b	#20,sprvsize(a0)
*		move.b	#2,colino(a0)
*		tst.b	userflag(a0)
*		beq.s	loc_D246
*		move.w	#$300,d2
*		bra.s	loc_D24A
*loc_D246:
*		move.w	#$E0,d2
*loc_D24A:
*		move.w	#$100,d1
*		bset.b	#0,actflg(a0)
*		move.w	playerwk+xposi,d0
*		sub.w	xposi(a0),d0
*		bcc.s	loc_D268
*		neg.w	d0
*		neg.w	d1
*		bclr.b	#0,actflg(a0)
*loc_D268:
*		cmp.w	d2,d0
*		bcc.s	loc_D274
*		move.w	d1,xspeed(a0)
*		addq.b	#word,r_no0(a0)
*loc_D274:
*		bsr.w	speedset
*		move.b	#1,patno(a0)
*		tst.w	yspeed(a0)
*		bmi.s	loc_D2AE
*		move.b	#0,patno(a0)
*		bsr.w	sub_14E18
*		tst.w	d1
*		bpl.s	loc_D2AE
*		move.w	(a1),d0
*		andi.w	#$3FF,d0
*		cmpi.w	#$2D2,d0
*		bcs.s	loc_D2A4
*		addq.b	#word,r_no0(a0)
*		bra.s	loc_D2AE
*loc_D2A4:
*		add.w	d1,yposi(a0)
*		move.w	#-$400,yspeed(a0)
*loc_D2AE:
*		bsr.w	sub_F808
*		beq.s	loc_D2C4
*		neg.w	xspeed(a0)
*		bchg.b	#0,actflg(a0)
*		bchg.b	#0,cddat(a0)
*loc_D2C4:
*		bra.w	loc_F6AC
*loc_D2C8:
*		bsr.w	speedset
*		bsr.w	actionsub
*		tst.b	actflg(a0)
*		bpl.w	frameout
*		rts