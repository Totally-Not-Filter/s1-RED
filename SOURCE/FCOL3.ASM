* ????????c fcol.fcolj.fcole
*
*cd_walk			equ		0+2
*cd_jump			equ		1+2
*cd_up				equ		2+2
*cd_down			equ		3+2

updotmax	equ		-4
downdotmax	equ		4
jumpdotmax	equ		8

;sprvo		equ		$1c
;sprho		equ		$1d
;sprvs		equ		$1e
;sprhs		equ		$1f
;------------------------------------------------
;		foot colition
;
fcol:
		move.w	yposi(a0),d4
		move.b	sprvo(a0),d1
		add.b	sprvs(a0),d1
		ext.w	d1
		add.w	d1,d4
		move.w	xposi(a0),d5
		move.b	sprho(a0),d1
		ext.w	d1
		add.w	d1,d5
		move.w	xspeed(a0),scrhithz
?loop:
		move.w	d4,d2
		move.w	d5,d3
		moveq	#0,d0
		move.b	sprhs(a0),d0
		tst.w	xspeed(a0)
		bpl.b	?jump
*		btst.b	#cd_right,cddat(a0)
*		beq.b	?jump
		neg.w	d0
?jump:
		add.w	d0,d3
		bsr.w	scdchk
		tst.w	d0
		beq.b	?end
		bpl.b	?down
?up:
		cmpi.w	#updotmax,d1
		blt.b	?nomove
		add.w	d1,yposi(a0)
?end:
		rts
?nomove:
		bsr.b	hoseihsub
		bra.b	?loop
		move.w	#0,xspeed(a0)
		rts
?down:
		move.w	d1,d6
		swap	d6
?loop2:
		move.w	d4,d2
		move.w	d6,d3
		moveq	#0,d0
		move.b	sprvs(a0),d0
		tst.w	xspeed(a0)
		bpl.b	?jump2
*		btst.b	#cd_left,cddat(a0)
*		bne.b	?jump2
		neg.w	d0
?jump2:
		add.w	d0,d3
		bsr.w	scdchk
		tst.w	d0
		beq.b	?end2
		bpl.b	?down2
?up2:
		cmpi.w	#dodotmax,d1
		blt.b	?nomove2
		add.w	d1,yposi(a0)
?end2:
		rts
?nomove2:
		bsr.b	hoseihsub
		bra.b	?loop2
		move.w	#0,xspeed(a0)
		rts
?down2: