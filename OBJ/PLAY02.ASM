play02:
		rts
*		moveq	#0,d0
*		move.b	r_no0(a0),d0
*		move.w	play02_move_tbl(pc,d0.w),d1
*		jmp	play02_move_tbl(pc,d1.w)
*play02_move_tbl:
*		dc.w	play02init-play02_move_tbl
*		dc.w	play02move-play02_move_tbl
*		dc.w	loc_11286-play02_move_tbl
*		dc.w	loc_11286-play02_move_tbl
*play02init:
*		addq.b	#word,r_no0(a0)
*		move.b	#18,sprvsize(a0)
*		move.b	#9,sprhsize(a0)
*		move.l	#playpat,patbase(a0)
*		move.w	#$0780,sproffset(a0)
*		move.b	#4,actflg(a0)
*		move.b	#2,sprpri(a0)
*play02move:
*		bsr.w	?jump
*		bsr.w	playwrt
*		jmp	actionsub
*?jump:
*		move.b	swdata,d4
*		move.w	yposi(a0),d2
*		move.w	xposi(a0),d3
*		moveq	#1,d1
*		btst.l	#0,d4
*		beq.b	?jump0
*		sub.w	d1,d2
*?jump0:
*		btst.l	#1,d4
*		beq.b	?jump1
*		add.w	d1,d2
*?jump1:
*		btst.l	#2,d4
*		beq.b	?jump2
*		sub.w	d1,d3
*?jump2:
*		btst.l	#3,d4
*		beq.b	?jump3
*		add.w	d1,d3
*?jump3:
*		move.w	d2,yposi(a0)
*		move.w	d3,xposi(a0)
*		btst.b	#4,swdata
*		beq.b	?jump4
*		move.b	actflg(a0),d0
*		move.b	d0,d1
*		addq.b	#1,d0
*		andi.b	#3,d0
*		andi.b	#$fc,d1
*		or.b	d1,d0
*		move.b	d0,actflg(a0)
*?jump4:
*		btst.b	#5,swdata
*		beq.b	?jump5
*		addq.b	#1,mstno(a0)
*		cmpi.b	#25,mstno(a0)
*		bcs.b	?jump5
*		move.b	#0,mstno(a0)
*?jump5:
*		jsr	sub_139C4
*		rts
*loc_11286:
*		jmp	frameout